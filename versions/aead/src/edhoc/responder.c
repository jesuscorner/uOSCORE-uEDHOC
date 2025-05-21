/*
   Copyright (c) 2021 Fraunhofer AISEC. See the COPYRIGHT
   file at the top-level directory of this distribution.

   Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
   http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
   <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
   option. This file may not be copied, modified, or distributed
   except according to those terms.
*/

#include "edhoc/buffer_sizes.h"
#include "edhoc_internal.h"
#include "edhoc.h"
#include <time.h> // Include for timing
#include <stdio.h> // Include for printf

#include "common/memcpy_s.h"
#include "common/print_util.h"
#include "common/crypto_wrapper.h"
#include "common/oscore_edhoc_error.h"

#include "edhoc/hkdf_info.h"
#include "edhoc/messages.h"
#include "edhoc/okm.h"
#include "edhoc/plaintext.h"
#include "edhoc/prk.h"
#include "edhoc/retrieve_cred.h"
#include "edhoc/signature_or_mac_msg.h"
#include "edhoc/suites.h"
#include "edhoc/th.h"
#include "edhoc/txrx_wrapper.h"
#include "edhoc/ciphertext.h"
#include "edhoc/suites.h"
#include "edhoc/runtime_context.h"
#include "edhoc/bstr_encode_decode.h"
#include "edhoc/int_encode_decode.h"

#include "cbor/edhoc_decode_message_1.h"
#include "cbor/edhoc_encode_message_2.h"
#include "cbor/edhoc_decode_message_3.h"

#define CBOR_UINT_SINGLE_BYTE_UINT_MAX_VALUE (0x17)
#define CBOR_UINT_MULTI_BYTE_UINT_MAX_VALUE (0x17)
#define CBOR_BSTR_TYPE_MIN_VALUE (0x40)
#define CBOR_BSTR_TYPE_MAX_VALUE (0x57)

/**
 * @brief   			Parses message 1.
 * @param[in] msg1 		Message 1.
 * @param[out] method 		EDHOC method.
 * @param[out] suites_i 	Cipher suites suported by the initiator
 * @param[out] g_x 		Public ephemeral key of the initiator.
 * @param[out] c_i 		Connection identifier of the initiator.
 * @param[out] id_cred_psk   PSK identifier of the initiator.
 * @param[out] ead1 		External authorized data 1.
 * @retval 			Ok or error code.
 */
static inline enum err
msg1_parse(struct byte_array *msg1, enum method_type *method,
	   struct byte_array *suites_i, struct byte_array *g_x,
	   struct byte_array *c_i, struct byte_array *id_cred_psk,
	   struct byte_array *ead1)
{

	PRINT_MSG("\n\033[1mProcessing Message 1...\033[0m\n\n");

	uint32_t i;
	struct message_1 m;
	size_t decode_len = 0;

	TRY_EXPECT(cbor_decode_message_1(msg1->ptr, msg1->len, &m, &decode_len),
		   0);

	/*METHOD*/
	if ((m.message_1_METHOD > INITIATOR_PSK_RESPONDER_PSK) ||
	    (m.message_1_METHOD < INITIATOR_SK_RESPONDER_SK)) {
		return wrong_parameter;
	}
	PRINTF("\033[1mMETHOD:\033[0m %d\n", m.message_1_METHOD);
	
	*method = (enum method_type)m.message_1_METHOD;
	
	/*SUITES_I*/
	if (m.message_1_SUITES_I_choice == message_1_SUITES_I_int_c) {
		/*the initiator supports only one suite*/
		suites_i->ptr[0] = (uint8_t)m.message_1_SUITES_I_int;
		suites_i->len = 1;
	} else {
		if (0 == m.SUITES_I_suite_l_suite_count) {
			return suites_i_list_empty;
		}

		/*the initiator supports more than one suite*/
		if (m.SUITES_I_suite_l_suite_count > suites_i->len) {
			return suites_i_list_to_long;
		}

		for (i = 0; i < m.SUITES_I_suite_l_suite_count; i++) {
			suites_i->ptr[i] = (uint8_t)m.SUITES_I_suite_l_suite[i];
		}
		suites_i->len = (uint32_t)m.SUITES_I_suite_l_suite_count;
	}
	PRINT_ARRAY("\033[1mSUITES_I\033[0m", suites_i->ptr, suites_i->len);

	/*G_X*/
	TRY(_memcpy_s(g_x->ptr, g_x->len, m.message_1_G_X.value,
		      (uint32_t)m.message_1_G_X.len));
	g_x->len = (uint32_t)m.message_1_G_X.len;
	PRINT_ARRAY("\033[1mG_X\033[0m", g_x->ptr, g_x->len);

	/*C_I*/
	if (m.message_1_C_I_choice == message_1_C_I_int_c) {
		c_i->ptr[0] = (uint8_t)m.message_1_C_I_int;
		c_i->len = 1;
	} else {
		TRY(_memcpy_s(c_i->ptr, c_i->len, m.message_1_C_I_bstr.value,
			      (uint32_t)m.message_1_C_I_bstr.len));
		c_i->len = (uint32_t)m.message_1_C_I_bstr.len;
	}
	PRINT_ARRAY("\033[1mC_I\033[0m", c_i->ptr, c_i->len);

	/*ID_CRED_PSK*/
	if (m.message_1_METHOD == INITIATOR_PSK_RESPONDER_PSK) 
	{
		if (m.message_1_ID_CRED_PSK_present)
		{
			TRY(_memcpy_s(id_cred_psk->ptr, id_cred_psk->len, m.message_1_ID_CRED_PSK.value,
				   (uint32_t)m.message_1_ID_CRED_PSK.len));
			id_cred_psk->len = (uint32_t)m.message_1_ID_CRED_PSK.len;
		}
		else { // JTODO: For variant 2 it is not an error but the expected field.
			PRINT_MSG("This is an error\n");
			return wrong_parameter;
		}
		PRINT_ARRAY("\033[1mID_CRED_PSK\033[0m", id_cred_psk->ptr, id_cred_psk->len);
	}

	/*ead_1*/
	if (m.message_1_ead_1_present) {
		TRY(_memcpy_s(ead1->ptr, ead1->len, m.message_1_ead_1.value,
			      (uint32_t)m.message_1_ead_1.len));
		ead1->len = (uint32_t)m.message_1_ead_1.len;
		PRINT_ARRAY("\033[1mEAD_1\033[0m", ead1->ptr, ead1->len);
	}

	PRINT_MSG("\n\033[1mMessage 1 correctly processed.\033[0m\n\n");

	PRINT_MSG("---------------------------------------------\n\n");
	PRINT_MSG("\033[1mMESSAGE 1: METHOD, SUITES_I, G_X, C_I, ? EAD_1\033[0m\n\n");

	PRINT_MSG("\033[1mMETHOD:\033[0m");
	PRINTF("%d\n", m.message_1_METHOD);

	PRINT_MSG("\033[1mSUITES_I:\033[0m ");
	PRINTF("%d\n", m.message_1_SUITES_I_int);

	PRINT_ARRAY("\033[1mG_X\033[0m", m.message_1_G_X.value, (uint32_t)m.message_1_G_X.len);

	PRINT_ARRAY("\033[1mC_I\033[0m", c_i->ptr, c_i->len);

	if (m.message_1_METHOD == INITIATOR_PSK_RESPONDER_PSK && m.message_1_ID_CRED_PSK_present) {
		PRINT_ARRAY("\033[1mID_CRED_PSK\033[0m", m.message_1_ID_CRED_PSK.value, (uint32_t)m.message_1_ID_CRED_PSK.len);
	}

	if (m.message_1_ead_1_present) {
		PRINT_ARRAY("\033[1mEAD_1\033[0m", m.message_1_ead_1.value, (uint32_t)m.message_1_ead_1.len);
	}
	PRINT_MSG("\n---------------------------------------------\n")


	return ok;
}

/**
 * @brief   			Checks if the selected cipher suite 
 * 				(the first in the list received from the 
 * 				initiator) is supported.
 * @param selected 		The selected suite.
 * @param[in] suites_r 		The list of suported cipher suites.
 * @retval  			True if supported.
 */
static inline bool selected_suite_is_supported(uint8_t selected,
					       struct byte_array *suites_r)
{
	for (uint32_t i = 0; i < suites_r->len; i++) {
		if (suites_r->ptr[i] == selected)
			//PRINTF("Suite %d will be used in this EDHOC run.\n",
			//       selected);
		return true;
	}
	return false;
}

/**
 * @brief   			Encodes message 2.
 * @param[in] g_y 		Public ephemeral DH key of the responder. 
 * @param[in] c_r 		Connection identifier of the responder.
 * @param[in] ciphertext_2 	The ciphertext.
 * @param[out] msg2 		The encoded message.
 * @retval  			Ok or error code.
 */
static inline enum err msg2_encode(const struct byte_array *g_y,
				   struct byte_array *c_r,
				   const struct byte_array *ciphertext_2,
				   struct byte_array *msg2)
{

	PRINT_MSG("\033[1mEncoding Message 2...\033[0m\n\n");

	BYTE_ARRAY_NEW(g_y_ciphertext_2, G_Y_CIPHERTEXT_2,
		       g_y->len + ciphertext_2->len);

	memcpy(g_y_ciphertext_2.ptr, g_y->ptr, g_y->len);
	memcpy(g_y_ciphertext_2.ptr + g_y->len, ciphertext_2->ptr,
	       ciphertext_2->len);

	TRY(encode_bstr(&g_y_ciphertext_2, msg2));
	PRINT_MSG("\033[1mFinished encoding Message 2. Result:\033[0m\n");
	PRINT_ARRAY("\033[1mMessage_2 (CBOR Sequence)\033[0m", msg2->ptr, msg2->len);
	PRINT_MSG("\n---------------------------------------------\n\n");

	return ok;
}

enum err msg2_gen(struct edhoc_responder_context *c, struct runtime_context *rc,
		  struct byte_array *c_i)
{
	enum method_type method = INITIATOR_PSK_RESPONDER_PSK; // JTODO: This is a default value.
	BYTE_ARRAY_NEW(suites_i, SUITES_I_SIZE, SUITES_I_SIZE);
	BYTE_ARRAY_NEW(g_x, G_X_SIZE, G_X_SIZE);
	BYTE_ARRAY_NEW(id_cred_psk, 32, 32);

	TRY(msg1_parse(&rc->msg, &method, &suites_i, &g_x, c_i, &id_cred_psk, &rc->ead));

	// TODO this may be a vulnerability in case suites_i.len is zero
	if (!(selected_suite_is_supported(suites_i.ptr[suites_i.len - 1],
					  &c->suites_r))) {
		// TODO implement here the sending of an error message
		return error_message_sent;
	}

	/*get cipher suite*/
	TRY(get_suite((enum suite_label)suites_i.ptr[suites_i.len - 1],
		      &rc->suite));

	bool static_dh_r;
	bool is_psk;
	authentication_type_get(method, &rc->static_dh_i, &static_dh_r, &is_psk);
	rc->is_psk = is_psk;

	/******************* create and send message 2*************************/
	BYTE_ARRAY_NEW(th2, HASH_SIZE, get_hash_len(rc->suite.edhoc_hash));
	TRY(hash(rc->suite.edhoc_hash, &rc->msg, &rc->msg1_hash));
	TRY(th2_calculate(rc->suite.edhoc_hash, &rc->msg1_hash, &c->g_y, &th2));

	PRINT_MSG("---------------------------------------------\n\n");

	/*calculate the DH shared secret*/
	PRINT_MSG("\033[1mCalculating G_XY (DH shared secret)...\033[0m\n\n");
	BYTE_ARRAY_NEW(g_xy, ECDH_SECRET_SIZE, ECDH_SECRET_SIZE);
	TRY(shared_secret_derive(rc->suite.edhoc_ecdh, &c->y, &g_x, g_xy.ptr));
	PRINT_MSG("\033[1mFinished calculating G_XY. Result:\033[0m\n");
	PRINT_ARRAY("\033[1mG_XY\033[0m", g_xy.ptr, g_xy.len);

	PRINT_MSG("\n---------------------------------------------\n\n");

	PRINT_MSG("\033[1mExtracting PRK_2e: HKDF-Extract( G_XY, label=2, TH_2 )...\033[0m\n");
	BYTE_ARRAY_NEW(PRK_2e, PRK_SIZE, PRK_SIZE);
	TRY(hkdf_extract(rc->suite.edhoc_hash, &th2, &g_xy, PRK_2e.ptr));
	PRINT_MSG("\033[1mFinished extracting PRK_2e. Result:\033[0m\n");
	PRINT_ARRAY("\033[1mPRK_2e\033[0m", PRK_2e.ptr, PRK_2e.len);

	PRINT_MSG("\n---------------------------------------------\n\n");

	/*derive prk_3e2m*/
	PRINT_MSG("\033[1mDeriving PRK_3e2m: EDHOC-KDF( PRK_2e2m, label=4, TH_2 )...\033[0m\n\n");
	if (is_psk) {
		TRY(prk_derive_psk(rc->suite, SALT_3e2m, &th2, &PRK_2e, &(c->cred_psk),
				   rc->prk_3e2m.ptr));
	} else {
		TRY(prk_derive(static_dh_r, rc->suite, SALT_3e2m, &th2, &PRK_2e, &g_x, &c->r,
			       rc->prk_3e2m.ptr));
	}
	PRINT_MSG("\033[1mFinished deriving PRK_3e2m. Result:\033[0m\n");
	PRINT_ARRAY("\033[1mPRK_3e2m\033[0m", rc->prk_3e2m.ptr, rc->prk_3e2m.len);
	
	PRINT_MSG("\n---------------------------------------------\n\n");
	

	/*compute signature_or_MAC_2*/
	BYTE_ARRAY_NEW(sign_or_mac_2, SIGNATURE_SIZE,
				   get_signature_len(rc->suite.edhoc_sign));
	
	// Para PSK, calcular MAC_2 en lugar de SIGNATURE_OR_MAC_2
	if (rc->is_psk) {
		// Generar MAC_2 para PSK
		PRINT_MSG("\033[1mCalculating MAC_2: MAC( K_2, transcript_hash_2, C_R, ID_CRED_I, PSK )...\033[0m\n\n");
		TRY(signature_or_mac(GENERATE, rc->is_psk, &rc->suite, &c->sk_r,
			     &c->pk_r, &rc->prk_3e2m, &c->c_r, &th2,
			     &c->id_cred_psk, &c->cred_psk, &c->ead_2, MAC_2,
			     &sign_or_mac_2));
		PRINT_MSG("\033[1mFinished calculating MAC_2. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mMAC_2\033[0m", sign_or_mac_2.ptr, sign_or_mac_2.len);

		PRINT_MSG("\n---------------------------------------------\n\n");
		
		// Para PSK, usar ciphertext_gen sin ID_CRED_R
		BYTE_ARRAY_NEW(plaintext_2, PLAINTEXT2_SIZE_PSK,
					   AS_BSTR_SIZE(c->c_r.len) + 
					   AS_BSTR_SIZE(sign_or_mac_2.len) + c->ead_2.len);
 
		BYTE_ARRAY_NEW(ciphertext_2, CIPHERTEXT2_SIZE, plaintext_2.len);
		
		// Usamos ciphertext_gen con NULL en lugar de id_cred para PSK
		PRINT_MSG("\033[1mGenerating CIPHERTEXT_2: AEAD_ENC( K_2, IV_2, Plaintext_2, Associated Data )...\033[0m\n");
		PRINT_MSG("\n---------------------------------------------\n\n");
		TRY(ciphertext_gen(CIPHERTEXT2, &rc->suite, &c->c_r, NULL,
				&sign_or_mac_2, &c->ead_2, &PRK_2e, &th2,
				&ciphertext_2, &plaintext_2));
		PRINT_MSG("\n\033[1mFinished generating CIPHERTEXT_2. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mCIPHERTEXT_2\033[0m", ciphertext_2.ptr, ciphertext_2.len);
		PRINT_MSG("\n---------------------------------------------\n\n");
		
		// Clear the message buffer.
		memset(rc->msg.ptr, 0, rc->msg.len);
		rc->msg.len = sizeof(rc->msg_buf);
		// message 2 create
		TRY(msg2_encode(&c->g_y, &c->c_r, &ciphertext_2, &rc->msg));
		// Calculamos TH3 usando la PSK

		PRINT_MSG("\033[1mCalculating TH_3...\033[0m\n\n");
	 	TRY(th34_calculate(rc->suite.edhoc_hash, &th2, &plaintext_2, &c->cred_psk, &rc->th3));
		PRINT_MSG("\033[1mFinished calculating TH_3. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mTH_3\033[0m", rc->th3.ptr, rc->th3.len);
		PRINT_MSG("\n---------------------------------------------\n\n");

		PRINT_MSG("\033[1mFinished calculating MAC_2. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mMAC_2\033[0m", sign_or_mac_2.ptr, sign_or_mac_2.len);
		PRINT_MSG("\n---------------------------------------------\n\n");
	} else {
		// Código existente para métodos no-PSK
		PRINT_MSG("\033[1mCalculating Signature_or_MAC_2...\033[0m\n\n");
		TRY(signature_or_mac(GENERATE, static_dh_r, &rc->suite, &c->sk_r,
			&c->pk_r, &rc->prk_3e2m, &c->c_r, &th2,
			&c->id_cred_r, &c->cred_r, &c->ead_2, MAC_2,
			&sign_or_mac_2));
		BYTE_ARRAY_NEW(plaintext_2, PLAINTEXT2_SIZE,
				AS_BSTR_SIZE(c->c_r.len) + c->id_cred_r.len +
					AS_BSTR_SIZE(sign_or_mac_2.len) + c->ead_2.len);
	 	BYTE_ARRAY_NEW(ciphertext_2, CIPHERTEXT2_SIZE, plaintext_2.len);
		TRY(ciphertext_gen(CIPHERTEXT2, &rc->suite, &c->c_r, &c->id_cred_r,
			&sign_or_mac_2, &c->ead_2, &PRK_2e, &th2,
			&ciphertext_2, &plaintext_2));
		/* Clear the message buffer. */
		memset(rc->msg.ptr, 0, rc->msg.len);
		rc->msg.len = sizeof(rc->msg_buf);
		/*message 2 create*/
		TRY(msg2_encode(&c->g_y, &c->c_r, &ciphertext_2, &rc->msg));
		TRY(th34_calculate(rc->suite.edhoc_hash, &th2, &plaintext_2, &c->cred_r,
				&rc->th3));
		PRINT_MSG("\n\033[1mFinished calculating Signature_or_MAC_2.\033[0m\n");
		PRINT_ARRAY("\033[1mSIGNATURE_OR_MAC_2\033[0m", sign_or_mac_2.ptr, sign_or_mac_2.len);
	}		

	PRINT_MSG("\n---------------------------------------------\n\n");

	PRINT_MSG("\033[1mMessage 2 generated.\n\033[0m\n\n");
	
	PRINT_MSG("\033[1mSent Message 2:  G_Y, AEAD( C_R, MAC_2, ? EAD_2 )\033[0m\n\n");

	PRINT_MSG("---------------------------------------------\n\n");
	
	PRINT_MSG("\033[1mMESSAGE_2:\033[0m\n\n");

	PRINT_ARRAY("\033[1mG_Y\033[0m", c->g_y.ptr, c->g_y.len);
	PRINT_ARRAY("\033[1mC_R\033[0m", c->c_r.ptr, c->c_r.len);

	if (!is_psk) {
		PRINT_ARRAY("\033[1mID_CRED_R\033[0m", c->id_cred_r.ptr, c->id_cred_r.len);
	} 

	if (is_psk) {
		PRINT_ARRAY("\033[1mMAC_2\033[0m", sign_or_mac_2.ptr, sign_or_mac_2.len);
	} else {
		PRINT_ARRAY("\033[1mSIGNATURE_OR_MAC_2\033[0m", sign_or_mac_2.ptr, sign_or_mac_2.len);
	}

	if (c->ead_2.len > 0) {
		PRINT_ARRAY("\033[1mEAD_2\033[0m", c->ead_2.ptr, c->ead_2.len);
	}

	PRINT_MSG("\n---------------------------------------------\n\n");

	return ok;
 }

enum err msg3_process(struct edhoc_responder_context *c,
		      struct runtime_context *rc,
		      struct cred_array *cred_i_array,
		      struct byte_array *prk_out,
		      struct byte_array *initiator_pk)
{
	PRINT_MSG("\033[1mProcessing Message 3...\033[0m\n\n");

	BYTE_ARRAY_NEW(ctxt3, CIPHERTEXT3_SIZE, rc->msg.len);
	TRY(decode_bstr(&rc->msg, &ctxt3));
	PRINT_ARRAY("\033[1mCIPHERTEXT_3\033[0m", ctxt3.ptr, ctxt3.len);

	BYTE_ARRAY_NEW(id_cred_i, ID_CRED_I_SIZE, ID_CRED_I_SIZE);
	BYTE_ARRAY_NEW(sign_or_mac, SIG_OR_MAC_SIZE, SIG_OR_MAC_SIZE);

#if defined(_WIN32)
	BYTE_ARRAY_NEW(ptxt3,
		       PLAINTEXT3_SIZE + 16, // 16 is max aead mac length
		       ctxt3.len);
#else
	BYTE_ARRAY_NEW(ptxt3,
		       PLAINTEXT3_SIZE + get_aead_mac_len(rc->suite.edhoc_aead),
		       ctxt3.len);
#endif

	TRY(ciphertext_decrypt_split(CIPHERTEXT3, &rc->suite, NULL, &id_cred_i,
				     &sign_or_mac, &rc->ead, &rc->prk_3e2m,
				     &rc->th3, &ctxt3, &ptxt3, rc->is_psk));

	if (rc->is_psk) {
		PRINT_MSG("\n---------------------------------------------\n\n");
		PRINT_MSG("\033[1mDeriving PRK_4e3m: HKDF-Extract( PRK_3e2m, label=5, TH_3 )\033[0m\n\n");
		TRY(prk_derive(false, rc->suite, SALT_4e3m, &rc->th3,
					&rc->prk_3e2m, NULL, &c->y, rc->prk_4e3m.ptr));
		PRINT_MSG("\n\033[1mFinished deriving PRK_4e3m. Result:\033[0m");
		PRINT_ARRAY("\033[1mPRK_4e3m\033[0m", rc->prk_4e3m.ptr, rc->prk_4e3m.len);
		PRINT_MSG("\n---------------------------------------------\n\n");
		PRINT_MSG("\033[1mCalculating TH_4...\033[0m\n\n");
		TRY(th34_calculate(rc->suite.edhoc_hash, &rc->th3, &ptxt3, &c->cred_psk,
					&rc->th4));
		PRINT_MSG("\n\033[1mFinished calculating TH_4. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mTH_4\033[0m", rc->th4.ptr, rc->th4.len);
		PRINT_MSG("\n---------------------------------------------\n\n");
		PRINT_MSG("\033[1mDeriving PRK_out: EDHOC-KDF( PRK_4e3m, label=6, TH_4 )\033[0m");
		TRY(edhoc_kdf(rc->suite.edhoc_hash, &rc->prk_4e3m, PRK_out, &rc->th4,
			prk_out));
		PRINT_MSG("\033[1mFinished deriving PRK_out. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mPRK_out\033[0m", prk_out->ptr, prk_out->len);
	} else {
		/*check the authenticity of the initiator*/
		BYTE_ARRAY_NEW(cred_i, CRED_I_SIZE, CRED_I_SIZE);
		BYTE_ARRAY_NEW(pk, PK_SIZE, PK_SIZE);
		BYTE_ARRAY_NEW(g_i, G_I_SIZE, G_I_SIZE);

		PRINT_MSG("\n---------------------------------------------\n\n");

		PRINT_MSG("\033[1mRetrieving Initiator's Credentials...\033[0m\n\n");
		TRY(retrieve_cred(rc->static_dh_i, cred_i_array, &id_cred_i, &cred_i,
				&pk, &g_i));
		PRINT_MSG("\033[1mFinished retrieving Initiator's Credentials. Results:\033[0m\n\n");
		PRINT_ARRAY("\033[1mCRED_I\033[0m", cred_i.ptr, cred_i.len);
		PRINT_ARRAY("\033[1mPublic Key (pk)\033[0m", pk.ptr, pk.len);
		PRINT_ARRAY("\033[1mStatic DH Key (g_i)\033[0m", g_i.ptr, g_i.len);
		PRINT_MSG("\n---------------------------------------------\n\n");

		/* Export public key. */
		if ((NULL != initiator_pk) && (NULL != initiator_pk->ptr)) {
			_memcpy_s(initiator_pk->ptr, initiator_pk->len, pk.ptr, pk.len);
			initiator_pk->len = pk.len;
		}

		/*derive prk_4e3m*/
		PRINT_MSG("\033[1mDeriving PRK_4e3m: HKDF-Extract( G_XY, label=5, TH_3 )...\033[0m\n\n");
		TRY(prk_derive(rc->static_dh_i, rc->suite, SALT_4e3m, &rc->th3,
				&rc->prk_3e2m, &g_i, &c->y, rc->prk_4e3m.ptr));
		PRINT_MSG("\033[1mFinished deriving PRK_4e3m. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mPRK_4e3m\033[0m", rc->prk_4e3m.ptr, rc->prk_4e3m.len);
		PRINT_MSG("\n---------------------------------------------\n\n");

		PRINT_MSG("\033[1mVerifying SIGNATURE_OR_MAC_3...\033[0m\n\n");
		TRY(signature_or_mac(VERIFY, rc->static_dh_i, &rc->suite, NULL, &pk,
					&rc->prk_4e3m, &NULL_ARRAY, &rc->th3, &id_cred_i,
					&cred_i, &rc->ead, MAC_3, &sign_or_mac));
		PRINT_MSG("\033[1mFinished verifying SIGNATURE_OR_MAC_3.\033[0m\n");
		PRINT_MSG("\n---------------------------------------------\n\n");

		/*TH4*/
		PRINT_MSG("\033[1mCalculating TH_4...\033[0m\n\n");
		// ptxt3.len = ptxt3.len - get_aead_mac_len(rc->suite.edhoc_aead);
		TRY(th34_calculate(rc->suite.edhoc_hash, &rc->th3, &ptxt3, &cred_i,
				&rc->th4));
		PRINT_MSG("\n\033[1mFinished calculating TH_4. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mTH_4\033[0m", rc->th4.ptr, rc->th4.len);
		PRINT_MSG("\n---------------------------------------------\n\n");

		/*PRK_out*/
		PRINT_MSG("\033[1mDeriving PRK_out: EDHOC-KDF( PRK_4e3m, label=6, TH_4 )\033[0m\n\n");
		TRY(edhoc_kdf(rc->suite.edhoc_hash, &rc->prk_4e3m, PRK_out, &rc->th4,
				prk_out));
		PRINT_MSG("\n\033[1mFinished deriving PRK_out. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mPRK_out\033[0m", prk_out->ptr, prk_out->len);
	}
	PRINT_MSG("\n---------------------------------------------\n\n");
	PRINT_MSG("\033[1mMessage 3 processed.\033[0m\n\n");
	PRINT_MSG("---------------------------------------------\n\n");

	return ok;
}

#ifdef MESSAGE_4
enum err msg4_gen(struct edhoc_responder_context *c, struct runtime_context *rc)
{
	PRINT_MSG("\033[1mGenerating Message 4...\033[0m\n\n");

	/*Ciphertext 4 calculate*/
	BYTE_ARRAY_NEW(ctxt4, CIPHERTEXT4_SIZE, CIPHERTEXT4_SIZE);
#if PLAINTEXT4_SIZE != 0
	BYTE_ARRAY_NEW(ptxt4, PLAINTEXT4_SIZE, PLAINTEXT4_SIZE);
#else
	struct byte_array ptxt4 = BYTE_ARRAY_INIT(NULL, 0);
#endif

	TRY(ciphertext_gen(CIPHERTEXT4, &rc->suite, &NULL_ARRAY, &NULL_ARRAY,
			   &NULL_ARRAY, &c->ead_4, &rc->prk_4e3m, &rc->th4,
			   &ctxt4, &ptxt4));

	TRY(encode_bstr(&ctxt4, &rc->msg));

	PRINT_MSG("\033[1mMessage 4 generated.\033[0m\n\n");

	PRINT_ARRAY("\033[1mMessage 4\033[0m", rc->msg.ptr, rc->msg.len);

	PRINT_MSG("\n------------------------------------------------\n\n");
	
	return ok;
}
#endif // MESSAGE_4

enum err edhoc_responder_run_extended(
	struct edhoc_responder_context *c, struct cred_array *cred_i_array,
	struct byte_array *err_msg, struct byte_array *prk_out,
	struct byte_array *initiator_pub_key, struct byte_array *c_i_bytes,
	enum err (*tx)(void *sock, struct byte_array *data),
	enum err (*rx)(void *sock, struct byte_array *data),
	enum err (*ead_process)(void *params, struct byte_array *ead13))
{
	struct runtime_context rc = { 0 };
	runtime_context_init(&rc);
	clock_t start, end; // Timing variables
	double elapsed_ms;

	/*receive message 1*/
	PRINT_MSG("\033[1mWaiting to receive Message 1...\033[0m\n\n");
	start = clock(); // Start timing before receiving
	TRY(rx(c->sock, &rc.msg));
	// Processing happens within msg2_gen
	// end = clock(); // End timing after receiving
	// elapsed_ms = (double)(end - start) * 1000.0 / CLOCKS_PER_SEC;
	// printf("[EDHOC Responder Core] message_1 size: %u bytes, receive time: %.3f ms\n", rc.msg.len, elapsed_ms); // Note: This is just receive time, processing is below
	PRINT_MSG("\033[1mReceived Message 1.\033[0m\n\n");
	PRINT_ARRAY("\033[1mMessage 1\033[0m", rc.msg.ptr, rc.msg.len);

	PRINT_MSG("\n---------------------------------------------\n");

	/* Process message 1 and create/send message 2 */
	start = clock(); // Start timing msg1 processing and msg2 generation
	TRY(msg2_gen(c, &rc, c_i_bytes));
	end = clock();
	elapsed_ms = (double)(end - start) * 1000.0 / CLOCKS_PER_SEC;
	printf("[EDHOC Responder Core] message_1 processing + message_2 generation time: \033[32m%.3f ms\033[0m\n", elapsed_ms);
	printf("[EDHOC Responder Core] message_2 size: \033[32m%u bytes\033[0m\n", rc.msg.len);

	PRINT_MSG("\n---------------------------------------------\n\n");

	// EAD processing timing (optional)
	start = clock();
	TRY(ead_process(c->params_ead_process, &rc.ead));
	end = clock();
	elapsed_ms = (double)(end - start) * 1000.0 / CLOCKS_PER_SEC;
	if (rc.ead.len > 0) {
		printf("[EDHOC Responder Core] EAD_1 processing time: \033[32m%.3f ms\033[0m\n", elapsed_ms);
	}

	TRY(tx(c->sock, &rc.msg));

	/*receive message 3*/
	PRINT_MSG("\033[1mWaiting to receive Message 3...\033[0m\n\n");
	rc.msg.len = sizeof(rc.msg_buf);
	start = clock(); // Start timing before receiving
	TRY(rx(c->sock, &rc.msg));
	// Processing happens within msg3_process
	// end = clock(); // End timing after receiving
	// elapsed_ms = (double)(end - start) * 1000.0 / CLOCKS_PER_SEC;
	// printf("[EDHOC Responder Core] message_3 size: %u bytes, receive time: %.3f ms\n", rc.msg.len, elapsed_ms); // Note: This is just receive time, processing is below
	PRINT_MSG("\033[1mReceived Message 3.\033[0m\n");
	PRINT_MSG("\n---------------------------------------------\n\n");

	start = clock(); // Start timing msg3 processing
	TRY(msg3_process(c, &rc, cred_i_array, prk_out, initiator_pub_key));
	end = clock();
	elapsed_ms = (double)(end - start) * 1000.0 / CLOCKS_PER_SEC;
	printf("[EDHOC Responder Core] message_3 processing time: \033[32m%.3f ms\033[0m\n", elapsed_ms);
	PRINT_MSG("\n---------------------------------------------\n\n");

	// EAD processing timing (optional)
	start = clock();
	TRY(ead_process(c->params_ead_process, &rc.ead));
	end = clock();
	elapsed_ms = (double)(end - start) * 1000.0 / CLOCKS_PER_SEC;
	if (rc.ead.len > 0) {
		printf("[EDHOC Responder Core] EAD_3 processing time: \033[32m%.3f ms\033[0m\n", elapsed_ms);
	}

	/*create and send message 4*/
#ifdef MESSAGE_4
	start = clock(); // Start timing msg4 generation
	TRY(msg4_gen(c, &rc));
	end = clock();
	elapsed_ms = (double)(end - start) * 1000.0 / CLOCKS_PER_SEC;
	printf("[EDHOC Responder Core] message_4 generation time: \033[32m%.3f ms\033[0m\n", elapsed_ms);
	printf("[EDHOC Responder Core] message_4 size: \033[32m%u bytes\033[0m\n", rc.msg.len);
	PRINT_MSG("\n---------------------------------------------\n\n");
	TRY(tx(c->sock, &rc.msg));
#endif // MESSAGE_4
	return ok;
}

enum err edhoc_responder_run(
	struct edhoc_responder_context *c, struct cred_array *cred_i_array,
	struct byte_array *err_msg, struct byte_array *prk_out,
	enum err (*tx)(void *sock, struct byte_array *data),
	enum err (*rx)(void *sock, struct byte_array *data),
	enum err (*ead_process)(void *params, struct byte_array *ead13))
{
	BYTE_ARRAY_NEW(c_i, C_I_SIZE, C_I_SIZE);
	return edhoc_responder_run_extended(c, cred_i_array, err_msg, prk_out,
					    &NULL_ARRAY, &c_i, tx, rx,
					    ead_process);
}
