/*
   Copyright (c) 2021 Fraunhofer AISEC. See the COPYRIGHT
   file at the top-level directory of this distribution.

   Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
   http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
   <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
   option. This file may not be copied, modified, or distributed
   except according to those terms.
*/

#include <stdbool.h>
#include <time.h> // Include for timing
#include <stdio.h> // Include for printf
#include "edhoc_internal.h"

#include "common/crypto_wrapper.h"
#include "common/oscore_edhoc_error.h"
#include "common/memcpy_s.h"
#include "common/print_util.h"

#include "edhoc/buffer_sizes.h"
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
#include "edhoc/runtime_context.h"
#include "edhoc/bstr_encode_decode.h"
#include "edhoc/int_encode_decode.h"

#include "zcbor_encode.h" // Include zcbor encode header
#include "cbor/edhoc_encode_message_1.h"
#include "cbor/edhoc_decode_message_2.h"
#include "cbor/edhoc_encode_message_3.h"

/** 
 * @brief   			Parses message 2.
 * @param c 			Initiator context.
 * @param[in] msg2 		Message 2. 
 * @param[out] g_y		G_Y ephemeral public key of the responder.
 * @param[out] ciphertext2	Ciphertext 2.
 * @retval			Ok or error code.
 */
static inline enum err msg2_parse(struct byte_array *msg2,
				  struct byte_array *g_y,
				  struct byte_array *ciphertext2)
{
	PRINT_MSG("\n---------------------------------------------\n")

	PRINT_MSG("\n\033[1mParsing Message 2...\033[0m\n");

	BYTE_ARRAY_NEW(g_y_ciphertext_2, G_Y_CIPHERTEXT_2, G_Y_CIPHERTEXT_2);
	TRY(decode_bstr(msg2, &g_y_ciphertext_2));

	TRY(_memcpy_s(g_y->ptr, g_y->len, g_y_ciphertext_2.ptr, g_y->len));
	PRINT_ARRAY("\n\033[1mG_Y\033[0m", g_y->ptr, g_y->len);

	TRY(_memcpy_s(ciphertext2->ptr, ciphertext2->len,
		      g_y_ciphertext_2.ptr + g_y->len,
		      g_y_ciphertext_2.len - g_y->len));

	ciphertext2->len = g_y_ciphertext_2.len - g_y->len;
	PRINT_ARRAY("\033[1mCiphertext 2\033[0m", ciphertext2->ptr,
		    ciphertext2->len);

	PRINT_MSG("\n\033[1mMessage 2 correctly parsed.\033[0m\n\n");

	PRINT_MSG("---------------------------------------------\n\n")

	return ok;
}

enum err msg1_gen(const struct edhoc_initiator_context *c,
		  struct runtime_context *rc)
{
	PRINT_MSG("---------------------------------------------\n")
	PRINT_MSG("\n\033[1mGenerating Message 1...\033[0m\n\n");

	struct message_1 m1;

	/*METHOD_CORR*/
	PRINTF("\033[1mMETHOD\033[0m:\n\t%d\n", c->method);
	m1.message_1_METHOD = (int32_t)c->method;

	/*SUITES_I*/
	if (c->suites_i.len == 1) {
		/* only one suite, encode into int */
		m1.message_1_SUITES_I_choice = message_1_SUITES_I_int_c;
		m1.message_1_SUITES_I_int = c->suites_i.ptr[0];
	} else if (c->suites_i.len > 1) {
		/* more suites, encode into array */
		// Check size of suite array
		if (c->suites_i.len > sizeof(m1.SUITES_I_suite_l_suite) / sizeof(m1.SUITES_I_suite_l_suite[0])) {
			return suites_i_list_to_long; // Return an error if the array is too large
		}
		m1.message_1_SUITES_I_choice = SUITES_I_suite_l_c;
		m1.SUITES_I_suite_l_suite_count = c->suites_i.len;
		for (uint32_t i = 0; i < c->suites_i.len; i++) {
			// Ensure the value fits in int32_t if necessary, though suite IDs are small
			m1.SUITES_I_suite_l_suite[i] = (int32_t)c->suites_i.ptr[i];
		}
	} else {
		/* no suites selected */
		return wrong_parameter;
	}

	/*G_X*/
	m1.message_1_G_X.value = c->g_x.ptr;
	m1.message_1_G_X.len = c->g_x.len;

	/*C_I*/
	// Always encode single-byte C_I as integer, let zcbor handle CBOR encoding (e.g., 0x18 XX for values > 23)
	if (c->c_i.len == 1) {
		m1.message_1_C_I_choice = message_1_C_I_int_c;
		// Directly assign the byte value, ensuring it's treated as unsigned then cast
		m1.message_1_C_I_int = (int32_t)c->c_i.ptr[0];
	}
	// If C_I is longer than 1 byte, encode as bstr
	else if (c->c_i.len > 1) {
		m1.message_1_C_I_choice = message_1_C_I_bstr_c;
		m1.message_1_C_I_bstr.value = c->c_i.ptr;
		m1.message_1_C_I_bstr.len = c->c_i.len;
	}
	// Handle case where c_i.len is 0 (optional, depending on requirements)
	// else { /* c_i.len == 0 */ }


	/* ID_CRED_PSK - Assign the kid directly as bstr */
	if (c->id_cred_psk.len != 0) {
		PRINT_ARRAY("\033[1mID_CRED_PSK (kid value)\033[0m", c->id_cred_psk.ptr,
			    c->id_cred_psk.len);

		m1.message_1_ID_CRED_PSK.value = c->id_cred_psk.ptr; // Assign pointer // JTODO: Check if this is correct for PSK ID Credential encoding
		m1.message_1_ID_CRED_PSK.len = c->id_cred_psk.len;   // Assign length
		m1.message_1_ID_CRED_PSK_present = true;
	} else {
		m1.message_1_ID_CRED_PSK_present = false;
	}

	/* EAD_1 unprotected opaque auxiliary data */
	if (c->ead_1.len != 0) {
		m1.message_1_ead_1.value = c->ead_1.ptr;
		m1.message_1_ead_1.len = c->ead_1.len;
		m1.message_1_ead_1_present = true;
		PRINT_ARRAY("\033[1mEAD_1\033[0m", m1.message_1_ead_1.value,
			    (uint32_t)m1.message_1_ead_1.len);

	} else {
		m1.message_1_ead_1_present = false;
	}

	size_t payload_len_out;
	TRY_EXPECT(cbor_encode_message_1(rc->msg.ptr, rc->msg.len, &m1,
					 &payload_len_out),
		   0);
	rc->msg.len = (uint32_t)payload_len_out;

	TRY(get_suite((enum suite_label)c->suites_i.ptr[c->suites_i.len - 1],
		      &rc->suite));
	/* Calculate hash of msg1 for TH2. */
	TRY(hash(rc->suite.edhoc_hash, &rc->msg, &rc->msg1_hash));

	PRINT_MSG("\n\033[1mMessage 1 correctly generated.\033[0m\n\n");

	PRINT_MSG("---------------------------------------------\n");

	if (m1.message_1_METHOD == INITIATOR_PSK_RESPONDER_PSK) {
		PRINT_MSG("\n\033[1mSent message_1: METHOD, SUITES_I, G_X, C_I, ID_CRED_PSK, ? EAD_1\n\n\033[0m");
	} else {
		PRINT_MSG("\n\033[1mSent message_1: METHOD, SUITES_I, G_X, C_I, ? EAD_1\n\n\033[0m");
	}

	PRINT_MSG("\033[1mMETHOD\033[0m:\n");
	PRINTF("\t%d\n", m1.message_1_METHOD);

	PRINT_MSG("\033[1mSUITES_I: \033[0m\n");
	PRINTF("\t%d\n", m1.message_1_SUITES_I_int);

	PRINT_ARRAY("\033[1mG_X\033[0m", m1.message_1_G_X.value,
		    (uint32_t)m1.message_1_G_X.len);

	PRINT_ARRAY("\033[1mC_I\033[0m", c->c_i.ptr, c->c_i.len);

	if (m1.message_1_METHOD == INITIATOR_PSK_RESPONDER_PSK) {
		PRINT_ARRAY("\033[1mID_CRED_PSK\033[0m", m1.message_1_ID_CRED_PSK.value,
			    (uint32_t)m1.message_1_ID_CRED_PSK.len);
	} 

	// Only print EAD_1 if it is present
	if (m1.message_1_ead_1_present) {
		PRINT_ARRAY("\033[1mEAD_1\033[0m", m1.message_1_ead_1.value,
			    (uint32_t)m1.message_1_ead_1.len);
	}

	PRINT_MSG("\n---------------------------------------------\n")

	PRINT_ARRAY("\n\033[1mMessage 1 (CBOR Sequence)\033[0m", rc->msg.ptr,
		    rc->msg.len);

	PRINT_MSG("\n---------------------------------------------\n");


	return ok;
}

static enum err msg2_process(const struct edhoc_initiator_context *c,
			     struct runtime_context *rc,
			     struct cred_array *cred_r_array,
			     struct byte_array *c_r, bool static_dh_i,
			     bool static_dh_r, struct byte_array *th3,
			     struct byte_array *PRK_3e2m)
{
	PRINT_MSG("\n---------------------------------------------\n");

	PRINT_MSG("\n\033[1mProcessing Message 2...\033[0m\n");

	BYTE_ARRAY_NEW(g_y, G_Y_SIZE, get_ecdh_pk_len(rc->suite.edhoc_ecdh));
	uint32_t ciphertext_len = rc->msg.len - g_y.len;
	ciphertext_len -= BSTR_ENCODING_OVERHEAD(ciphertext_len);
	BYTE_ARRAY_NEW(ciphertext, CIPHERTEXT2_SIZE, ciphertext_len);
	BYTE_ARRAY_NEW(plaintext, PLAINTEXT2_SIZE, ciphertext.len);

	/*parse the message*/
	TRY(msg2_parse(&rc->msg, &g_y, &ciphertext));

	/*calculate the DH shared secret*/
	BYTE_ARRAY_NEW(g_xy, ECDH_SECRET_SIZE, ECDH_SECRET_SIZE);
	PRINT_MSG(
		"\033[1mDeriving G_XY (ECDH shared secret from G_X and G_Y).\033[0m\n\n");
	TRY(shared_secret_derive(rc->suite.edhoc_ecdh, &c->x, &g_y, g_xy.ptr));
	PRINT_MSG("\033[1mFinished G_XY calculation. Result:\033[0m\n");
	PRINT_ARRAY("\033[1mG_XY\033[0m", g_xy.ptr, g_xy.len);

	PRINT_MSG("\n---------------------------------------------\n");

	/*calculate th2*/
	BYTE_ARRAY_NEW(th2, HASH_SIZE, get_hash_len(rc->suite.edhoc_hash));
	TRY(th2_calculate(rc->suite.edhoc_hash, &rc->msg1_hash, &g_y, &th2));

	PRINT_MSG("---------------------------------------------\n\n");

	/*calculate PRK_2e*/
	PRINT_MSG(
		"\033[1mDeriving PRK_2e: HKDF-Extract( salt = TH_2, IKM = G_XY )...\033[0m\n");
	BYTE_ARRAY_NEW(PRK_2e, PRK_SIZE, PRK_SIZE);
	TRY(hkdf_extract(rc->suite.edhoc_hash, &th2, &g_xy, PRK_2e.ptr));
	PRINT_MSG("\033[1mFinished key derivation. Result:\033[0m\n");
	PRINT_ARRAY("\033[1mPRK_2e\033[0m", PRK_2e.ptr, PRK_2e.len);

	PRINT_MSG("\n---------------------------------------------\n");

	BYTE_ARRAY_NEW(sign_or_mac, SIG_OR_MAC_SIZE, SIG_OR_MAC_SIZE);
	BYTE_ARRAY_NEW(id_cred_r, ID_CRED_R_SIZE, ID_CRED_R_SIZE);

	plaintext.len = ciphertext.len;
	TRY(check_buffer_size(PLAINTEXT2_SIZE, plaintext.len));

	// Intentamos descifrar y dividir el plaintext
	int ret = ciphertext_decrypt_split(CIPHERTEXT2, &rc->suite, c_r,
					   &id_cred_r, &sign_or_mac, &rc->ead,
					   &PRK_2e, &th2, &ciphertext,
					   &plaintext, rc->is_psk);

	if (ret != ok) {
		PRINT_MSG(
			"Error al procesar el mensaje 2. Si está usando PSK, esto podría ser debido a un problema de formato.\n");
		return ret;
	}

	// Para PSK (método 4), el manejo es diferente
	if (c->method == INITIATOR_PSK_RESPONDER_PSK) {
		// Continuamos con el proceso PSK normal
		TRY(prk_derive_psk(rc->suite, SALT_3e2m, &th2, &PRK_2e,
				   &(c->cred_psk), PRK_3e2m->ptr));

		// En PSK, verificamos directamente MAC_2
		PRINT_MSG(
			"\033[1mVerifying MAC_2...\033[0m\n\n");
		TRY(signature_or_mac(VERIFY, true, &rc->suite, NULL, NULL,
				     PRK_3e2m, c_r, &th2, &(c->id_cred_psk),
				     &(c->cred_psk), &rc->ead, MAC_2,
				     &sign_or_mac));
		PRINT_MSG(
			"\033[1mFinished MAC_2 verification. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mMAC_2\033[0m", sign_or_mac.ptr,
			    sign_or_mac.len);

		PRINT_MSG("\n---------------------------------------------\n\n");


		// Calculamos TH3 usando la PSK
		PRINT_MSG("\033[1mDeriving TH_3: H( TH_2, ciphertext_2, CRED_C )...\033[0m\n");
		TRY(th34_calculate(rc->suite.edhoc_hash, &th2, &plaintext,
				   &c->cred_psk, th3));
		PRINT_MSG("\n\033[1mFinished TH_3 calculation. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mTH_3\033[0m", th3->ptr, th3->len);

		PRINT_MSG("\n---------------------------------------------\n\n");


		// Derivamos PRK_4e3m para PSK
		PRINT_MSG(
			"\033[1mDeriving PRK_4e3m: EDHOC-KDF( PRK_3e2m, label=5, TH_3 )...\033[0m\n\n");
		TRY(prk_derive(false, rc->suite, SALT_4e3m, th3, PRK_3e2m, &g_y,
			       &c->i, rc->prk_4e3m.ptr));
		PRINT_MSG("\n\033[1mFinished key derivation. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mPRK_4e3m\033[0m", rc->prk_4e3m.ptr,
			    rc->prk_4e3m.len);
		PRINT_MSG("\n");

	} else {
		// Código existente para métodos no-PSK
		/*check the authenticity of the responder*/

		PRINT_MSG("\n---------------------------------------------\n\n");

		PRINT_MSG(
			"\033[1mRetrieving Responder's Credentials...\033[0m\n\n");
		BYTE_ARRAY_NEW(cred_r, CRED_R_SIZE, CRED_R_SIZE);
		BYTE_ARRAY_NEW(pk, PK_SIZE, PK_SIZE);
		BYTE_ARRAY_NEW(g_r, G_R_SIZE, G_R_SIZE);
		TRY(retrieve_cred(static_dh_r, cred_r_array, &id_cred_r,
				  &cred_r, &pk, &g_r));
		PRINT_ARRAY("\033[1mCRED_R\033[0m", cred_r.ptr, cred_r.len);
		PRINT_ARRAY(
			"\033[1mG_Y (Responder's Static DH Public Key)\033[0m",
			g_r.ptr, g_r.len);
		PRINT_MSG("\n");

		PRINT_MSG("---------------------------------------------\n\n")

		/*derive prk_3e2m*/
		PRINT_MSG("\033[1mDeriving PRK_3e2m: EDHOC-KDF( PRK_2e2m, label=4, TH_2 )...\033[0m\n\n");
		TRY(prk_derive(static_dh_r, rc->suite, SALT_3e2m, &th2, &PRK_2e,
			       &g_r, &c->x, PRK_3e2m->ptr));
		PRINT_MSG(
			"\033[1mFinished PRK_3e2m derivation. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mPRK_3e2m\033[0m", PRK_3e2m->ptr,
			    PRK_3e2m->len);

		PRINT_MSG("\n---------------------------------------------\n\n");

		PRINT_MSG("\033[1mVerifying Signature_or_MAC_2...\033[0m\n");
		TRY(signature_or_mac(VERIFY, static_dh_r, &rc->suite, NULL, &pk,
				     PRK_3e2m, c_r, &th2, &id_cred_r, &cred_r,
				     &rc->ead, MAC_2, &sign_or_mac));
		PRINT_MSG(
			"\033[1mFinished Signature_or_MAC_2 verification. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mSignature_or_MAC_2\033[0m", sign_or_mac.ptr,
			    sign_or_mac.len);

		PRINT_MSG("\n---------------------------------------------\n\n")

		PRINT_MSG("\033[1mDeriving TH_3 ( TH_1, message_2, plaintext_2, CRED_R )...\033[0m\n\n");
		TRY(th34_calculate(rc->suite.edhoc_hash, &th2, &plaintext,
				   &cred_r, th3));
		PRINT_MSG("\n\033[1mFinished TH_3 calculation. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mTH_3\033[0m", th3->ptr, th3->len);
		
		PRINT_MSG("\n---------------------------------------------\n\n")


		/*derive prk_4e3m*/
		PRINT_MSG("\033[1mDeriving PRK_4e3m...\033[0m\n\n");
		TRY(prk_derive(static_dh_i, rc->suite, SALT_4e3m, th3, PRK_3e2m,
			       &g_y, &c->i, rc->prk_4e3m.ptr));
		PRINT_MSG(
			"\033[1mFinished PRK_4e3m derivation. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mPRK_4e3m\033[0m", rc->prk_4e3m.ptr,
			    rc->prk_4e3m.len);
		PRINT_MSG("\n");
	}

	PRINT_MSG("---------------------------------------------\n")

	PRINT_MSG(
		"\n\033[1mProcessed message_2: G_Y, Enc( C_R, MAC_2, ? EAD_2 )\033[0m\n\n");

	PRINT_ARRAY("\033[1mG_Y\033[0m", g_y.ptr, g_y.len);
	PRINT_ARRAY("\033[1mC_R\033[0m", c_r->ptr, c_r->len);

	if (c->method != INITIATOR_PSK_RESPONDER_PSK) {
		PRINT_ARRAY("\033[1mID_CRED_R\033[0m", id_cred_r.ptr,
			    id_cred_r.len);
	}

	if (c->method == INITIATOR_PSK_RESPONDER_PSK) {
		PRINT_ARRAY("\033[1mMAC_2\033[0m", sign_or_mac.ptr,
			    sign_or_mac.len);
	} else {
		PRINT_ARRAY("\033[1mSIGNATURE_OR_MAC_2\033[0m", sign_or_mac.ptr,
			    sign_or_mac.len);
	}

	PRINT_ARRAY("\033[1mEAD_2\033[0m", rc->ead.ptr, rc->ead.len);

	PRINT_MSG("\n---------------------------------------------\n")

	return ok;
}

static enum err msg3_only_gen(const struct edhoc_initiator_context *c,
				  struct runtime_context *rc, bool static_dh_i,
				  struct byte_array *th3,
				  struct byte_array *PRK_3e2m,
				  struct byte_array *prk_out)
{
	PRINT_MSG("\n\033[1mGenerating Message 3...\033[0m\n\n");

	PRINT_MSG("---------------------------------------------\n\n")

	struct byte_array plaintext;

	if (c->method == INITIATOR_PSK_RESPONDER_PSK) {
		// Para PSK, creamos un plaintext con la longitud de EAD_3
		BYTE_ARRAY_NEW(plaintext_psk, PLAINTEXT3_SIZE, c->ead_3.len);
		plaintext =
			plaintext_psk; // Usar la variable estructurada en lugar de una nueva
	} else {
		// Para no-PSK, incluimos ID_CRED_I y SIGNATURE_OR_MAC_3
		BYTE_ARRAY_NEW(plaintext_std, PLAINTEXT3_SIZE,
				   c->id_cred_i.len +
					   AS_BSTR_SIZE(SIG_OR_MAC_SIZE) +
					   c->ead_3.len);
		plaintext =
			plaintext_std; // Usar la variable estructurada en lugar de una nueva
	}

	BYTE_ARRAY_NEW(ciphertext, CIPHERTEXT3_SIZE,
			   AS_BSTR_SIZE(plaintext.len) +
				   get_aead_mac_len(rc->suite.edhoc_aead));

	/*calculate Signature_or_MAC_3*/
	BYTE_ARRAY_NEW(sign_or_mac_3, SIG_OR_MAC_SIZE, SIG_OR_MAC_SIZE);

	if (c->method == INITIATOR_PSK_RESPONDER_PSK) {

		PRINT_MSG("---------------------------------------------\n\n");

		PRINT_MSG(
			"\033[1mGenerating Ciphertext 3 (PSK method)...\033[0m\n\n");
		TRY(ciphertext_gen_psk(CIPHERTEXT3, &rc->suite, &NULL_ARRAY,
					   NULL, &c->ead_3, PRK_3e2m, th3,
					   &ciphertext, &plaintext));
		PRINT_MSG("\n---------------------------------------------\n\n");
	} else {
		PRINT_MSG(
			"\033[1mGenerating Signature_or_MAC_3...\033[0m\n\n");
		TRY(signature_or_mac(
			GENERATE, static_dh_i, &rc->suite, &c->sk_i, &c->pk_i,
			&rc->prk_4e3m, &NULL_ARRAY, th3, &c->id_cred_i,
			&c->cred_i, &c->ead_3, MAC_3, &sign_or_mac_3));
		PRINT_MSG(
			"\033[1mFinished Signature_or_MAC_3 generation. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mSignature_or_MAC_3\033[0m",
				sign_or_mac_3.ptr, sign_or_mac_3.len);

		PRINT_MSG("\n---------------------------------------------\n\n");

		/*create plaintext3 and ciphertext3*/
		PRINT_MSG(
			"\033[1mGenerating Plaintext 3 and Ciphertext 3...\033[0m\n\n");
		TRY(ciphertext_gen(CIPHERTEXT3, &rc->suite, &NULL_ARRAY,
				   &c->id_cred_i, &sign_or_mac_3, &c->ead_3,
				   PRK_3e2m, th3, &ciphertext, &plaintext));
		PRINT_ARRAY("\033[1mPlaintext 3\033[0m", plaintext.ptr,
				plaintext.len);
		PRINT_ARRAY("\033[1mCiphertext 3\033[0m", ciphertext.ptr,
				ciphertext.len);
		PRINT_MSG("\n");
	}

	/*massage 3 create and send*/
	PRINT_MSG("\033[1mGenerating Message 3...\033[0m\n");
	TRY(encode_bstr(&ciphertext, &rc->msg));
	PRINT_ARRAY("\033[1mMessage 3 (CBOR Sequence)\033[0m", rc->msg.ptr,
			rc->msg.len);
	PRINT_MSG("\n---------------------------------------------\n\n");
	
	/*TH4*/
	PRINT_MSG(
		"\033[1mDeriving TH_4: H( TH_3, plaintext_3, CRED_I )... \033[0m\n\n");
	if (c->method == INITIATOR_PSK_RESPONDER_PSK) {
		TRY(th34_calculate(rc->suite.edhoc_hash, th3, &plaintext,
				   &c->cred_psk, &rc->th4));
	} else {
		TRY(th34_calculate(rc->suite.edhoc_hash, th3, &plaintext,
				   &c->cred_i, &rc->th4));
	}
	PRINT_MSG("\n\033[1mFinished TH_4 calculation. Result:\033[0m\n");
	PRINT_ARRAY("\033[1mTH_4\033[0m", rc->th4.ptr, rc->th4.len);
	PRINT_MSG("\n---------------------------------------------\n\n");

	/*PRK_out*/
	PRINT_MSG(
		"\033[1mDeriving PRK_out: EDHOC-KDF( PRK_4e3m, label=6, TH_4 )...\033[0m\n");
	TRY(edhoc_kdf(rc->suite.edhoc_hash, &rc->prk_4e3m, PRK_out, &rc->th4,
			  prk_out));
	PRINT_MSG("\n\033[1mFinished PRK_out derivation. Result:\033[0m\n");
	PRINT_ARRAY("\033[1mPRK_out\033[0m", prk_out->ptr, prk_out->len);
	PRINT_MSG("\n---------------------------------------------\n\n");
	

	PRINT_MSG("\033[1mMessage 3 correctly generated.\033[0m\n\n");
	PRINT_MSG("---------------------------------------------\n");
	PRINT_MSG("\n\033[1mSent message_3: AEAD( ? EAD_3 )\n\n\033[0m");
	PRINT_ARRAY("\033[1mCiphertext 3\033[0m", ciphertext.ptr,
			ciphertext.len);
	PRINT_ARRAY("\n\033[1mMessage 3 (CBOR Sequence)\033[0m", rc->msg.ptr,
			rc->msg.len);
	PRINT_MSG("\n---------------------------------------------\n")

	return ok;
}

enum err msg3_gen(const struct edhoc_initiator_context *c,
		  struct runtime_context *rc, struct cred_array *cred_r_array,
		  struct byte_array *c_r, struct byte_array *prk_out)
{
	PRINT_MSG("---------------------------------------------\n")
	PRINT_MSG("\n\033[1mStarting Message 3 Generation Process...\033[0m\n");
	
	bool static_dh_r = false;

	authentication_type_get(c->method, &rc->static_dh_i, &static_dh_r, &rc->is_psk);

	BYTE_ARRAY_NEW(th3, HASH_SIZE, HASH_SIZE);
	BYTE_ARRAY_NEW(PRK_3e2m, PRK_SIZE, PRK_SIZE);

	/*process message 2*/
	TRY(msg2_process(c, rc, cred_r_array, c_r, rc->static_dh_i, static_dh_r,
			 &th3, &PRK_3e2m));

	/*generate message 3*/
	TRY(msg3_only_gen(c, rc, rc->static_dh_i, &th3, &PRK_3e2m, prk_out));

	PRINT_MSG("\n\033[1mFinished Message 3 Generation Process.\033[0m\n\n");
	PRINT_MSG("---------------------------------------------\n")
	return ok;
}

#ifdef MESSAGE_4
enum err msg4_process(struct runtime_context *rc)
{	
	PRINT_MSG("\n\033[1mReceived Message 4...\033[0m\n\n");
	PRINT_ARRAY("\033[1mMessage 4 (CBOR Sequence)\033[0m", rc->msg.ptr,
		rc->msg.len);

	PRINT_MSG("\n---------------------------------------------\n\n");

	PRINT_MSG("\033[1mProcessing Message 4...\033[0m\n");

	PRINT_MSG("\n---------------------------------------------\n\n");

	BYTE_ARRAY_NEW(ciphertext4, CIPHERTEXT4_SIZE, CIPHERTEXT4_SIZE);
	TRY(decode_bstr(&rc->msg, &ciphertext4));
	PRINT_ARRAY("\033[1mCiphertext 4\033[0m", ciphertext4.ptr,
			ciphertext4.len);

	BYTE_ARRAY_NEW(plaintext4,
			   PLAINTEXT4_SIZE + get_aead_mac_len(rc->suite.edhoc_aead),
			   ciphertext4.len);
	
	PRINT_MSG("\n---------------------------------------------\n\n");

	PRINT_MSG("\033[1mDecrypting Ciphertext 4...\033[0m\n\n");
	TRY(ciphertext_decrypt_split(CIPHERTEXT4, &rc->suite, NULL, &NULL_ARRAY,
					 &NULL_ARRAY, &rc->ead, &rc->prk_4e3m,
					 &rc->th4, &ciphertext4, &plaintext4, rc->is_psk));
	// PRINT_MSG("\033[1mFinished Ciphertext 4 decryption. Result:\033[0m\n");
	// PRINT_ARRAY("\033[1mPlaintext 4\033[0m", plaintext4.ptr,
	// 		plaintext4.len);
	// PRINT_ARRAY("\033[1mEAD_4\033[0m", rc->ead.ptr, rc->ead.len);
	PRINT_MSG("\n---------------------------------------------\n\n");

	PRINT_MSG("\033[1mMessage 4 correctly processed.\033[0m\n\n");
	PRINT_MSG("---------------------------------------------\n")
	PRINT_MSG(
		"\n\033[1mProcessed message_4: Enc( ? EAD_4 )\033[0m\n\n");
	PRINT_ARRAY("\033[1mEAD_4\033[0m", rc->ead.ptr, rc->ead.len);
	PRINT_MSG("\n---------------------------------------------\n")

	return ok;
}
#endif // MESSAGE_4

enum err edhoc_initiator_run_extended(
	const struct edhoc_initiator_context *c,
	struct cred_array *cred_r_array, struct byte_array *err_msg,
	struct byte_array *c_r_bytes, struct byte_array *prk_out,
	enum err (*tx)(void *sock, struct byte_array *data),
	enum err (*rx)(void *sock, struct byte_array *data),
	enum err (*ead_process)(void *params, struct byte_array *ead24))
{
	struct runtime_context rc = { 0 };
	runtime_context_init(&rc);
	clock_t start, end; // Timing variables
	double elapsed_ms;

	/*create and send message 1*/
	start = clock();
	TRY(msg1_gen(c, &rc));
	end = clock();
	elapsed_ms = (double)(end - start) * 1000.0 / CLOCKS_PER_SEC;
	printf("\n\033[32m[EDHOC Initiator Core] message_1 size: %u bytes, generation time: %.3f ms\033[0m\n", rc.msg.len, elapsed_ms);
	PRINT_MSG("\n---------------------------------------------\n\n");
	TRY(tx(c->sock, &rc.msg));

	/*receive message 2*/
	PRINT_MSG("\n\033[1mWaiting to receive Message 2...\033[0m\n\n");
	rc.msg.len = sizeof(rc.msg_buf);
	start = clock(); // Start timing before receiving
	TRY(rx(c->sock, &rc.msg));
	// Processing happens within msg3_gen
	// end = clock(); // End timing after receiving
	// elapsed_ms = (double)(end - start) * 1000.0 / CLOCKS_PER_SEC;
	// printf("[EDHOC Initiator Core] message_2 size: %u bytes, receive time: %.3f ms\n", rc.msg.len, elapsed_ms); // Note: This is just receive time, processing is below
	PRINT_MSG("\033[1mReceived Message 2.\033[0m\n\n");

	PRINT_ARRAY("\033[1mMessage 2 (CBOR Sequence)\033[0m", rc.msg.ptr,
		    rc.msg.len);

	PRINT_MSG("\n");

	/* Process message 2 and create/send message 3 */
	start = clock(); // Start timing msg2 processing and msg3 generation
	TRY(msg3_gen(c, &rc, cred_r_array, c_r_bytes, prk_out));
	end = clock();
	elapsed_ms = (double)(end - start) * 1000.0 / CLOCKS_PER_SEC;
	printf("\n\033[32m[EDHOC Initiator Core] message_2 processing + message_3 generation time: %.3f ms\033[0m\n", elapsed_ms);
	printf("\033[32m[EDHOC Initiator Core] message_3 size: %u bytes\033[0m\n", rc.msg.len);


	// EAD processing timing (optional, could be part of msg3_gen timing if desired)
	start = clock();
	TRY(ead_process(c->params_ead_process, &rc.ead));
	end = clock();
	elapsed_ms = (double)(end - start) * 1000.0 / CLOCKS_PER_SEC;
	if (rc.ead.len > 0) {
		printf("\033[32m[EDHOC Initiator Core] EAD_2 processing time: %.3f ms\033[0m\n", elapsed_ms);
	}
	PRINT_MSG("\n---------------------------------------------\n\n");

	TRY(tx(c->sock, &rc.msg));

/*receive message 4*/
#ifdef MESSAGE_4
	PRINT_MSG("\n\033[1mWaiting to receive Message 4...\033[0m\n");
	rc.msg.len = sizeof(rc.msg_buf);
	start = clock(); // Start timing before receiving
	TRY(rx(c->sock, &rc.msg));
	// Processing happens within msg4_process
	// end = clock(); // End timing after receiving
	// elapsed_ms = (double)(end - start) * 1000.0 / CLOCKS_PER_SEC;
	// printf("[EDHOC Initiator Core] message_4 size: %u bytes, receive time: %.3f ms\n", rc.msg.len, elapsed_ms); // Note: This is just receive time, processing is below

	start = clock(); // Start timing msg4 processing
	TRY(msg4_process(&rc));
	end = clock();
	elapsed_ms = (double)(end - start) * 1000.0 / CLOCKS_PER_SEC;
	printf("\n\033[32m[EDHOC Initiator Core] message_4 processing time: %.3f ms\033[0m\n", elapsed_ms);
	PRINT_MSG("\n---------------------------------------------\n\n");

	// EAD processing timing (optional)
	start = clock();
	TRY(ead_process(c->params_ead_process, &rc.ead));
	end = clock();
	elapsed_ms = (double)(end - start) * 1000.0 / CLOCKS_PER_SEC;
	if (rc.ead.len > 0) {
		printf("\033[32m[EDHOC Initiator Core] EAD_4 processing time: %.3f ms\033[0m\n", elapsed_ms);
	}
#endif // MESSAGE_4
	return ok;
}

enum err edhoc_initiator_run(
	const struct edhoc_initiator_context *c,
	struct cred_array *cred_r_array, struct byte_array *err_msg,
	struct byte_array *prk_out,
	enum err (*tx)(void *sock, struct byte_array *data),
	enum err (*rx)(void *sock, struct byte_array *data),
	enum err (*ead_process)(void *params, struct byte_array *ead24))
{
	BYTE_ARRAY_NEW(c_r, C_R_SIZE, C_R_SIZE);

	return edhoc_initiator_run_extended(c, cred_r_array, err_msg, &c_r,
					    prk_out, tx, rx, ead_process);
}
