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

#include "edhoc/okm.h"
#include "edhoc/edhoc_method_type.h"
#include "edhoc.h"
#include "edhoc/ciphertext.h"
#include "edhoc/signature_or_mac_msg.h"
#include "edhoc/plaintext.h"
#include "edhoc/associated_data_encode.h"
#include "edhoc/suites.h"
#include "edhoc/bstr_encode_decode.h"
#include "edhoc/int_encode_decode.h"

#include "common/crypto_wrapper.h"
#include "common/oscore_edhoc_error.h"
#include "common/memcpy_s.h"

/**
 * @brief 			Xors two arrays.
 * 
 * @param[in] in1		An input array.
 * @param[in] in2 		An input array.
 * @param[out] out 		The result of the xor operation.
 * @retval			Ok or error code.
 */
static inline enum err xor_arrays(const struct byte_array *in1,
				  const struct byte_array *in2,
				  struct byte_array *out)
{
	if (in1->len != in2->len) {
		return xor_error;
	}
	for (uint32_t i = 0; i < in1->len; i++) {
		out->ptr[i] = in1->ptr[i] ^ in2->ptr[i];
	}
	return ok;
}

/**
 * @brief 			Encrypts a plaintext or decrypts a ciphertext.
 * 
 * @param ctxt 			CIPHERTEXT2, CIPHERTEXT3 or CIPHERTEXT4.
 * @param op 			ENCRYPT or DECRYPT.
 * @param[in] in 		Ciphertext or plaintext. 
 * @param[in] key 		The key used of encryption/decryption.
 * @param[in] nonce 		AEAD nonce.
 * @param[in] aad 		Additional authenticated data for AEAD.
 * @param[out] out 		The result.
 * @param[out] tag 		AEAD authentication tag.
 * @return 			Ok or error code. 
 */
static enum err ciphertext_encrypt_decrypt(
	enum ciphertext ctxt, enum aes_operation op,
	const struct byte_array *in, const struct byte_array *key,
	struct byte_array *nonce, const struct byte_array *aad,
	struct byte_array *out, struct byte_array *tag)
{
	// Usar AEAD para todos los mensajes, incluido CIPHERTEXT2
	TRY(aead(op, in, key, nonce, aad, out, tag));
	return ok;
}

/**
 * @brief 			Computes the key stream for ciphertext 2 and 
 * 				the key and IV for ciphertext 3 and 4. 
 * 
 * @param ctxt 			CIPHERTEXT2, CIPHERTEXT3 or CIPHERTEXT4.
 * @param edhoc_hash 		The EDHOC hash algorithm.
 * @param prk 			Pseudorandom key.
 * @param th 			Transcript hash.
 * @param[out] key 		The generated key/key stream.
 * @param[out] iv 		The generated iv.
 * @return 			Ok or error code. 
 */
static enum err key_gen(enum ciphertext ctxt, enum hash_alg edhoc_hash,
			struct byte_array *prk, struct byte_array *th,
			struct byte_array *key, struct byte_array *iv)
{
	switch (ctxt) {
	case CIPHERTEXT2:

		PRINT_MSG("\n---------------------------------------------\n\n");

		PRINT_MSG("\n\033[1mDeriving K_2: HKDF-Expand( PRK_2e, label=0, TH_2, L=10 )\033[0m\n");
		TRY(edhoc_kdf(edhoc_hash, prk, KEYSTREAM_2, th, key));
		PRINT_MSG("\033[1mFinished key derivation. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mK_2\033[0m", key->ptr, key->len);

		PRINT_MSG("\n---------------------------------------------\n\n");
		PRINT_MSG("\033[1mIV_2  = HKDF-Expand( PRK_2e, label=1, TH_2, L=13 )\033[0m\n");
		TRY(edhoc_kdf(edhoc_hash, prk, SALT_3e2m, th, iv));
		PRINT_ARRAY("\033[1mIV_2\033[0m", iv->ptr, iv->len);
		PRINT_MSG("\n\n---------------------------------------------\n\n");

		break;

	case CIPHERTEXT3:
		PRINT_MSG("\n---------------------------------------------\n\n");
		PRINT_MSG("\033[1mDeriving K_3: EDHOC-KDF( PRK_3e, label=1, TH_3 )...\033[0m\n");
		TRY(edhoc_kdf(edhoc_hash, prk, K_3, th, key));
		PRINT_MSG("\033[1mFinished key derivation. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mK_3\033[0m", key->ptr, key->len);
		PRINT_MSG("\n---------------------------------------------\n");

		PRINT_MSG("\n\033[1mDeriving IV_3: EDHOC-KDF( PRK_3e, label=2, TH_3 )...\033[0m\n");
		TRY(edhoc_kdf(edhoc_hash, prk, IV_3, th, iv));
		PRINT_MSG("\033[1mFinished key derivation. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mIV_3\033[0m", iv->ptr, iv->len);
		PRINT_MSG("\n---------------------------------------------\n");
		break;

	case CIPHERTEXT4:
		PRINT_ARRAY("\033[1mPRK_4e3m\033[0m", prk->ptr, prk->len);
		PRINT_ARRAY("\033[1mTH_4\033[0m", th->ptr, th->len);

		PRINT_MSG("\n---------------------------------------------\n\n");
		PRINT_MSG("\033[1mDeriving K_4: EDHOC-KDF( PRK_4e3m, label=3, TH_4 )...\033[0m\n");
		TRY(edhoc_kdf(edhoc_hash, prk, K_4, th, key));
		PRINT_MSG("\033[1mFinished key derivation. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mK_4\033[0m", key->ptr, key->len);
		PRINT_MSG("\n---------------------------------------------\n\n");
		
		PRINT_MSG("\033[1mDeriving IV_4: EDHOC-KDF( PRK_4e3m, label=4, TH_4 )...\033[0m\n");
		TRY(edhoc_kdf(edhoc_hash, prk, IV_4, th, iv));
		PRINT_MSG("\033[1mFinished key derivation. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mIV_4\033[0m", iv->ptr, iv->len);
		PRINT_MSG("\n---------------------------------------------\n");

		break;
	}
	return ok;
}

enum err ciphertext_decrypt_split(
	enum ciphertext ctxt, struct suite *suite, struct byte_array *c_r,
	struct byte_array *id_cred, struct byte_array *sig_or_mac,
	struct byte_array *ead, struct byte_array *prk, struct byte_array *th,
	struct byte_array *ciphertext, struct byte_array *plaintext, bool is_psk)
{
	/*generate key and iv (no iv in for ciphertext 2)*/
	uint32_t key_len;
	if (ctxt == CIPHERTEXT2) {
		key_len = get_aead_key_len(suite->edhoc_aead);
	} else {
		key_len = get_aead_key_len(suite->edhoc_aead);
	}

	BYTE_ARRAY_NEW(key, CIPHERTEXT2_SIZE, key_len);
	BYTE_ARRAY_NEW(iv, AEAD_IV_SIZE, get_aead_iv_len(suite->edhoc_aead));

	TRY(key_gen(ctxt, suite->edhoc_hash, prk, th, &key, &iv));

	/*Associated data*/
	PRINT_MSG("\n\033[1mDeriving Associated Data...\033[0m\n\n");
	BYTE_ARRAY_NEW(associated_data, AAD_SIZE, AAD_SIZE);
	TRY(associated_data_encode(th, &associated_data));
	PRINT_MSG("\033[1mFinished associated data derivation. Result:\033[0m\n");
	PRINT_ARRAY("\033[1mAssociated Data\033[0m", associated_data.ptr,
		    associated_data.len);
	
	PRINT_MSG("\n---------------------------------------------\n\n");

	uint32_t tag_len = get_aead_mac_len(suite->edhoc_aead);
	// Ajustamos la lógica para manejar etiquetas AEAD tanto en mensaje 2 como en los demás mensajes
	if (plaintext->len < tag_len) {
		return error_message_received;
	}
	plaintext->len -= tag_len;
	/*Decrypt ciphertext*/
	PRINT_MSG("\033[1mDecrypting ciphertext for Plaintext 2...\033[0m\n\n\n");
	if (ctxt == CIPHERTEXT2) {
		PRINT_MSG("\033[1m[SEGURIDAD MEJORADA] Descifrando mensaje 2 con AEAD en lugar de XOR simple (Enc)\033[0m\n");
	}
	struct byte_array tag = BYTE_ARRAY_INIT(ciphertext->ptr, tag_len);
	TRY(ciphertext_encrypt_decrypt(ctxt, DECRYPT, ciphertext, &key, &iv,
				       &associated_data, plaintext, &tag));
	
	if (plaintext->len == 0) {
		PRINT_MSG("\033[1mPlaintext is empty.\033[0m\n");
	} else {
		PRINT_MSG("\033[1mFinished decryption. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mPlaintext 2\033[0m", plaintext->ptr, plaintext->len);
		PRINT_MSG("\n---------------------------------------------\n");
	}

	if (ctxt == CIPHERTEXT4 && plaintext->len != 0) {
		TRY(decode_bstr(plaintext, ead));
		PRINT_ARRAY("\033[1mEAD_4\033[0m", ead->ptr, ead->len);
	} else if (ctxt == CIPHERTEXT4 && plaintext->len == 0) {
		ead->ptr = NULL;
		ead->len = 0;
		//PRINT_MSG("\033[1mNo EAD_4\033[0m\n");
	} else {
		if (ctxt == CIPHERTEXT2) {

			TRY(plaintext_split(plaintext, c_r, id_cred, sig_or_mac,
					    ead, is_psk));
			PRINT_ARRAY("\033[1mC_R\033[0m", c_r->ptr, c_r->len);
		} else {
			TRY(plaintext_split(plaintext, NULL, id_cred,
					    sig_or_mac, ead, is_psk));
		}
		if (ead->len) {
			PRINT_ARRAY("\033[1mEAD\033[0m", ead->ptr, ead->len);
		}
		
		// Solo muestra información si hay contenido válido
		if (id_cred && id_cred->len > 0) {
			PRINT_ARRAY("\033[1mID_CRED\033[0m", id_cred->ptr, id_cred->len);
		}
		if (sig_or_mac && sig_or_mac->len > 0) {
			PRINT_ARRAY("\033[1mSignature_or_MAC\033[0m", sig_or_mac->ptr, sig_or_mac->len);
		}
		if (ead && ead->len > 0) {
			PRINT_ARRAY("\033[1mEAD\033[0m", ead->ptr, ead->len);
		}
	}

	return ok;
}

enum err ciphertext_gen_psk(enum ciphertext ctxt, struct suite *suite,
				const struct byte_array *c_r,
				const struct byte_array *id_cred,
				const struct byte_array *ead, struct byte_array *prk,
				struct byte_array *th, struct byte_array *ciphertext,
				struct byte_array *plaintext)
{
	PRINT_ARRAY("\033[1mPRK\033[0m", prk->ptr, prk->len);
	PRINT_ARRAY("\033[1mTH\033[0m", th->ptr, th->len);

	uint32_t ptxt_buf_capacity = plaintext->len;
	plaintext->len = 0;
	PRINT_MSG("\n---------------------------------------------\n\n");
	PRINT_MSG("\033[1mConstructing plaintext...\033[0m\n");
	if (ctxt == CIPHERTEXT2) {
		if (c_x_is_encoded_int(c_r)) {
			TRY(byte_array_append(plaintext, c_r,
						  ptxt_buf_capacity));
			PRINT_ARRAY("\033[1mPlaintext after C_R (int)\033[0m", plaintext->ptr, plaintext->len);
		} else {
			BYTE_ARRAY_NEW(c_r_enc, AS_BSTR_SIZE(C_I_SIZE),
					   AS_BSTR_SIZE(c_r->len));
			TRY(encode_bstr(c_r, &c_r_enc));
			TRY(byte_array_append(plaintext, &c_r_enc,
						  ptxt_buf_capacity));
			PRINT_ARRAY("\033[1mPlaintext after C_R (bstr)\033[0m", plaintext->ptr, plaintext->len);
		}
	}

	if ((ctxt != CIPHERTEXT4) && (id_cred != NULL)) {
		BYTE_ARRAY_NEW(kid, KID_SIZE, KID_SIZE);
		TRY(id_cred2kid(id_cred, &kid));
		PRINT_ARRAY("\033[1mKID derived from ID_CRED\033[0m", kid.ptr, kid.len);

		if (kid.len != 0) {
			/*id_cred_x is a KID*/
			TRY(byte_array_append(plaintext, &kid,
						  ptxt_buf_capacity));
			PRINT_ARRAY("\033[1mPlaintext after KID\033[0m", plaintext->ptr, plaintext->len);
		} else {
			/*id_cred_x is NOT a KID*/
			TRY(byte_array_append(plaintext, id_cred,
						  ptxt_buf_capacity));
			PRINT_ARRAY("\033[1mPlaintext after ID_CRED (not KID)\033[0m", plaintext->ptr, plaintext->len);
		}
	} else if (id_cred == NULL){
		//PRINT_MSG("\033[1mNo ID_CRED provided, skipping append to plaintext.\033[0m\n");
	} else { /* ctxt == CIPHERTEXT4 */
		//PRINT_MSG("\033[1mCIPHERTEXT4: ID_CRED not included in plaintext.\033[0m\n");
		plaintext->len=0; /* As per original logic for CIPHERTEXT4 */
	}

	if (ead->len > 0) {
		TRY(byte_array_append(plaintext, ead, ptxt_buf_capacity));
		PRINT_ARRAY("\033[1mPlaintext after EAD\033[0m", plaintext->ptr, plaintext->len);
	} else {
		//PRINT_MSG("\033[1mNo EAD provided, skipping append to plaintext.\033[0m\n");
	}

	/*Generate key and IV (no IV in for ciphertext 2)*/
	uint32_t key_len;
	if (ctxt == CIPHERTEXT2) {
		key_len = get_aead_key_len(suite->edhoc_aead);
	} else {
		key_len = get_aead_key_len(suite->edhoc_aead);
	}

	BYTE_ARRAY_NEW(key, CIPHERTEXT2_SIZE, key_len);
	BYTE_ARRAY_NEW(iv, AEAD_IV_SIZE, get_aead_iv_len(suite->edhoc_aead));

	TRY(key_gen(ctxt, suite->edhoc_hash, prk, th, &key, &iv));
	/* key_gen already has detailed prints */

	/*encrypt*/
	BYTE_ARRAY_NEW(aad, AAD_SIZE, AAD_SIZE);
	BYTE_ARRAY_NEW(tag, MAC_SIZE, get_aead_mac_len(suite->edhoc_aead));

	if (ctxt != CIPHERTEXT2) {
		/*Associated data*/
		TRY(associated_data_encode(th, &aad));
		PRINT_ARRAY("\n\033[1mAAD Data\033[0m", aad.ptr, aad.len);
	} else {
		/*Associated data para CIPHERTEXT2*/
		PRINT_MSG("\n\033[1mEncoding Associated Data for CIPHERTEXT2...\033[0m\n");
		TRY(associated_data_encode(th, &aad));
		PRINT_ARRAY("\033[1mAssociated Data (AAD) for CIPHERTEXT2\033[0m", aad.ptr, aad.len);
		PRINT_MSG("\n---------------------------------------------\n\n");
		tag.len = get_aead_mac_len(suite->edhoc_aead);
	}

	PRINT_MSG("\n---------------------------------------------\n\n");
	ciphertext->len = plaintext->len;

	PRINT_MSG("\033[1mEncrypting...\033[0m\n\n");
	if (ctxt == CIPHERTEXT2) {
		PRINT_MSG("\033[1m[SEGURIDAD MEJORADA] Utilizando cifrado AEAD para mensaje 2 en lugar de XOR simple (Enc)\033[0m\n");
	}
	TRY(ciphertext_encrypt_decrypt(ctxt, ENCRYPT, plaintext, &key, &iv,
					   &aad, ciphertext, &tag));
	ciphertext->len += tag.len;

	if (ctxt == CIPHERTEXT2) {
		PRINT_ARRAY("\033[1mGenerated CIPHERTEXT_2\033[0m", ciphertext->ptr, ciphertext->len);
	} else if (ctxt == CIPHERTEXT3) {
		PRINT_ARRAY("\033[1mGenerated CIPHERTEXT_3\033[0m", ciphertext->ptr, ciphertext->len);
	} else {
		PRINT_ARRAY("\033[1mGenerated CIPHERTEXT_4\033[0m", ciphertext->ptr, ciphertext->len);
	}
	return ok;
}

enum err ciphertext_gen(enum ciphertext ctxt, struct suite *suite,
			const struct byte_array *c_r,
			const struct byte_array *id_cred,
			struct byte_array *signature_or_mac,
			const struct byte_array *ead, struct byte_array *prk,
			struct byte_array *th, struct byte_array *ciphertext,
			struct byte_array *plaintext)
{
	BYTE_ARRAY_NEW(signature_or_mac_enc, AS_BSTR_SIZE(SIG_OR_MAC_SIZE),
		       AS_BSTR_SIZE(signature_or_mac->len));

	PRINT_ARRAY("\033[1mSignature_or_MAC\033[0m", signature_or_mac->ptr,signature_or_mac->len);
	TRY(encode_bstr(signature_or_mac, &signature_or_mac_enc));

	uint32_t ptxt_buf_capacity = plaintext->len;
	plaintext->len = 0;
	if (ctxt == CIPHERTEXT2) {
		if (c_x_is_encoded_int(c_r)) {
			TRY(byte_array_append(plaintext, c_r,
					      ptxt_buf_capacity));
		} else {
			BYTE_ARRAY_NEW(c_r_enc, AS_BSTR_SIZE(C_I_SIZE),
				       AS_BSTR_SIZE(c_r->len));
			TRY(encode_bstr(c_r, &c_r_enc));
			TRY(byte_array_append(plaintext, &c_r_enc,
					      ptxt_buf_capacity));
		}
	}

	if (ctxt != CIPHERTEXT4 && (id_cred != NULL)) {
		BYTE_ARRAY_NEW(kid, KID_SIZE, KID_SIZE);
		TRY(id_cred2kid(id_cred, &kid));

		PRINT_ARRAY("\033[1mKID derived from ID_CRED\033[0m", kid.ptr, kid.len);

		if (kid.len != 0) {
			/*id_cred_x is a KID*/
			TRY(byte_array_append(plaintext, &kid,
					      ptxt_buf_capacity));
		} else {
			/*id_cred_x is NOT a KID*/
			TRY(byte_array_append(plaintext, id_cred,
					      ptxt_buf_capacity));
		}
		TRY(byte_array_append(plaintext, &signature_or_mac_enc,
				      ptxt_buf_capacity));
	} else if (id_cred == NULL) {
		TRY(byte_array_append(plaintext, &signature_or_mac_enc,
			ptxt_buf_capacity));
	} else {
		plaintext->len = 0;
	}
	if (ead->len > 0) {
		TRY(byte_array_append(plaintext, ead, ptxt_buf_capacity));
	}

	PRINT_ARRAY("\033[1mPlaintext\033[0m", plaintext->ptr, plaintext->len);

	/*generate key and iv (no iv in for ciphertext 2)*/
	uint32_t key_len;
	if (ctxt == CIPHERTEXT2) {
		key_len = get_aead_key_len(suite->edhoc_aead);
	} else {
		key_len = get_aead_key_len(suite->edhoc_aead);
	}

	BYTE_ARRAY_NEW(key, CIPHERTEXT2_SIZE, key_len);
	BYTE_ARRAY_NEW(iv, AEAD_IV_SIZE, get_aead_iv_len(suite->edhoc_aead));

	TRY(key_gen(ctxt, suite->edhoc_hash, prk, th, &key, &iv));

	/*encrypt*/
	BYTE_ARRAY_NEW(aad, AAD_SIZE, AAD_SIZE);
	BYTE_ARRAY_NEW(tag, MAC_SIZE, get_aead_mac_len(suite->edhoc_aead));

	if (ctxt != CIPHERTEXT2) {
		/*Associated data*/
		TRY(associated_data_encode(th, &aad));
		PRINT_ARRAY("\n\033[1mAAD Data\033[0m", aad.ptr, aad.len);
		PRINT_MSG("\n---------------------------------------------\n\n");
	} else {
		/*Associated data para CIPHERTEXT2*/
		PRINT_MSG("\n\033[1mEncoding Associated Data for CIPHERTEXT2...\033[0m\n");
		TRY(associated_data_encode(th, &aad));
		PRINT_ARRAY("\033[1mAssociated Data (AAD) for CIPHERTEXT2\033[0m", aad.ptr, aad.len);
		PRINT_MSG("\n---------------------------------------------\n\n");
		tag.len = get_aead_mac_len(suite->edhoc_aead);
	}

	PRINT_MSG("\n---------------------------------------------\n\n");
	ciphertext->len = plaintext->len;

	PRINT_MSG("\033[1mEncrypting...\033[0m\n\n");
	if (ctxt == CIPHERTEXT2) {
		PRINT_MSG("\033[1m[SEGURIDAD MEJORADA] Utilizando cifrado AEAD para mensaje 2 en lugar de XOR simple (Enc)\033[0m\n");
	}
	TRY(ciphertext_encrypt_decrypt(ctxt, ENCRYPT, plaintext, &key, &iv,
					   &aad, ciphertext, &tag));
	ciphertext->len += tag.len;

	return ok;
}
