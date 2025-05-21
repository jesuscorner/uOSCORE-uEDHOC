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

#include "edhoc/th.h"
#include "edhoc/bstr_encode_decode.h"
#include "edhoc/int_encode_decode.h"

#include "common/crypto_wrapper.h"
#include "common/oscore_edhoc_error.h"
#include "common/memcpy_s.h"
#include "common/print_util.h"

#include "cbor/edhoc_encode_data_2.h"
#include "cbor/edhoc_encode_th2.h"

/**
 * @brief   			Setups a data structure used as input for th2, 
 * 				namely CBOR sequence H( G_Y, C_R, H(message_1)).
 *
 * @param[in] hash_msg1 	Hash of message 1.
 * @param[in] g_y 		Ephemeral public DH key.
 * @param[out] th2_input	The result.
 * @retval			Ok or error.
 */
static inline enum err th2_input_encode(struct byte_array *hash_msg1,
					struct byte_array *g_y,
					struct byte_array *th2_input)
{
	size_t payload_len_out;
	struct th2 th2;

	/*Encode hash_msg1*/
	th2.th2_hash_msg1.value = hash_msg1->ptr;
	th2.th2_hash_msg1.len = hash_msg1->len;

	/*Encode G_Y*/
	th2.th2_G_Y.value = g_y->ptr;
	th2.th2_G_Y.len = g_y->len;

	TRY_EXPECT(cbor_encode_th2(th2_input->ptr, th2_input->len, &th2,
				   &payload_len_out),
		   0);

	/* Get the the total th2 length */
	th2_input->len = (uint32_t)payload_len_out;

	PRINT_ARRAY("\033[1mInput to calculate TH_2 (CBOR Sequence)\033[0m",
		    th2_input->ptr, th2_input->len);
	PRINT_MSG("\n");
	return ok;
}

/**
 * @brief   			Setups a data structure used as input for 
 * 				th3 or th4.
 * 
 * @param[in] th23 		th2 or th3.
 * @param[in] plaintext_23 	Plaintext 2 or plaintext 3.
 * @param[in] cred		The credential.
 * @param[out] th34_input 	The result.
 * @retval			Ok or error code.
 */
static enum err th34_input_encode(struct byte_array *th23,
				  struct byte_array *plaintext_23,
				  const struct byte_array *cred,
				  struct byte_array *th34_input)
{
	PRINT_ARRAY("\033[1mTH23\033[0m", th23->ptr, th23->len);
	PRINT_ARRAY("\033[1mPlaintext_23\033[0m", plaintext_23->ptr, plaintext_23->len);
	PRINT_ARRAY("\033[1mCredential\033[0m", cred->ptr, cred->len);

	PRINT_ARRAY("\033[1mInitial TH34_input buffer\033[0m", th34_input->ptr, th34_input->len);

	uint32_t tmp_len_th3 = th34_input->len;

	TRY(encode_bstr(th23, th34_input));
	PRINT_ARRAY("\033[1mTH34_input after encoding TH23\033[0m", th34_input->ptr, th34_input->len);

	uint32_t tmp_len = th34_input->len;

	if (plaintext_23->len != 0) {
		PRINT_MSG("\033[1mPlaintext_23 length is non-zero.\033[0m\n");
		TRY(_memcpy_s(th34_input->ptr + tmp_len,
				  th34_input->len - tmp_len - cred->len,
				  plaintext_23->ptr, plaintext_23->len));
		tmp_len += plaintext_23->len;
		TRY(_memcpy_s(th34_input->ptr + tmp_len,
				  th34_input->len - tmp_len, cred->ptr, cred->len));
		th34_input->len = tmp_len + cred->len;
		PRINT_ARRAY("\033[1mInput to calculate TH_3/TH_4 (CBOR Sequence)\033[0m",
				th34_input->ptr, th34_input->len);
	} else {
		TRY(_memcpy_s(th34_input->ptr + tmp_len,
				  tmp_len_th3 - th34_input->len, cred->ptr,
				  cred->len));
		th34_input->len = tmp_len + cred->len;
		PRINT_ARRAY("\033[1mInput to calculate TH_3/TH_4 (CBOR Sequence)\033[0m",
				th34_input->ptr, th34_input->len);
	}
	return ok;
}

/**
 * @brief 			Computes TH_3 or TH4. Where: 
 * 				TH_3 = H(TH_2, PLAINTEXT_2)
 * 				TH_4 = H(TH_3, PLAINTEXT_3)
 * 
 * @param alg 			The hash algorithm to be used.
 * @param[in] th23 		th2 if we compute TH_3, th3 if we compute TH_4.
 * @param[in] plaintext_23 	The plaintext.
 * @param[in] cred		The credential.
 * @param[out] th34 		The result.
 * @return 			Ok or error. 
 */
enum err th34_calculate(enum hash_alg alg, struct byte_array *th23,
			struct byte_array *plaintext_23,
			const struct byte_array *cred, struct byte_array *th34)
{
	uint32_t th34_input_len =
		AS_BSTR_SIZE(get_hash_len(alg)) + plaintext_23->len + cred->len;
	BYTE_ARRAY_NEW(th34_input, TH34_INPUT_SIZE, th34_input_len);

	TRY(th34_input_encode(th23, plaintext_23, cred, &th34_input));
	TRY(hash(alg, &th34_input, th34));

	return ok;
}

/** 
 * @brief 			Computes TH_2. Where: 
 * 				TH_2 = H(TH_1, G_Y)
 * 
 * @param alg 			The hash algorithm to be used.
 * @param[in] msg1_hash 	Hash of message 1.
 * @param[in] g_y 		Ephemeral public DH key.
 * @param[out] th2 		The result.
 * @return 			Ok or error. 
 */
enum err th2_calculate(enum hash_alg alg, struct byte_array *msg1_hash,
		       struct byte_array *g_y, struct byte_array *th2)
{
	PRINT_MSG("\n\033[1mCalculating TH_2: H ( TH_1, G_Y )...\033[0m\n\n");
	BYTE_ARRAY_NEW(th2_input, TH2_INPUT_SIZE,
		       AS_BSTR_SIZE(g_y->len) +
			       AS_BSTR_SIZE(get_hash_len(alg)));
	PRINT_ARRAY("\033[1mTH_1: H( METHOD, SUITES_I )\033[0m", msg1_hash->ptr,
		    msg1_hash->len);
	PRINT_ARRAY("\033[1mG_Y\033[0m", g_y->ptr, g_y->len);
	TRY(th2_input_encode(msg1_hash, g_y, &th2_input));
	TRY(hash(alg, &th2_input, th2));
	PRINT_MSG("\033[1mFinished TH_2 calculation. Result:\033[0m\n");
	PRINT_ARRAY("\033[1mTH_2\033[0m", th2->ptr, th2->len);
	PRINT_MSG("\n");
	return ok;
}
