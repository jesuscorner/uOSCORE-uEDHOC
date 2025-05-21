/*
   Copyright (c) 2021 Fraunhofer AISEC. See the COPYRIGHT
   file at the top-level directory of this distribution.

   Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
   http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
   <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
   option. This file may not be copied, modified, or distributed
   except according to those terms.
*/

#include <string.h>

#include "edhoc/buffer_sizes.h"

#include "edhoc/suites.h"
#include "edhoc/prk.h"
#include "edhoc/okm.h"

#include "common/crypto_wrapper.h"
#include "common/oscore_edhoc_error.h"
#include "common/print_util.h"
#include "common/memcpy_s.h"

enum err prk_derive(bool static_dh_auth, struct suite suite, uint8_t label,
			struct byte_array *context, const struct byte_array *prk_in,
			const struct byte_array *stat_pk,
			const struct byte_array *stat_sk, uint8_t *prk_out)
{
	PRINTF("\033[1mDeriving PRK ( Label: %d )...\033[0m\n\n", label);
	PRINT_ARRAY("\033[1mInput PRK\033[0m", prk_in->ptr, prk_in->len);

	if (static_dh_auth) {
		PRINT_MSG("\033[1mStatic DH Authentication required.\033[0m\n");
		BYTE_ARRAY_NEW(dh_secret, ECDH_SECRET_SIZE, ECDH_SECRET_SIZE);

		PRINT_MSG("\n---------------------------------------------\n\n")

		PRINT_MSG("\033[1mDeriving ECDH shared secret...\033[0m\n\n");
		TRY(shared_secret_derive(suite.edhoc_ecdh, stat_sk, stat_pk,
					 dh_secret.ptr));
		PRINT_MSG("\033[1mECDH shared secret derivation finished. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mDH_SECRET\033[0m", dh_secret.ptr, dh_secret.len);

		PRINT_MSG("\n---------------------------------------------\n\n")

		BYTE_ARRAY_NEW(salt, HASH_SIZE, get_hash_len(suite.edhoc_hash));
		PRINTF("\033[1mDeriving Salt (EDHOC-KDF(PRK_in, label=%d, context))...\033[0m\n", label);
		TRY(edhoc_kdf(suite.edhoc_hash, prk_in, label, context, &salt));
		PRINT_MSG("\033[1mSalt derivation finished. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mSALT\033[0m", salt.ptr, salt.len);

		PRINT_MSG("\n---------------------------------------------\n\n")

		PRINT_MSG("\033[1mDeriving PRK_out: HKDF-Extract( Salt, DH_SECRET )...\033[0m\n");
		TRY(hkdf_extract(suite.edhoc_hash, &salt, &dh_secret, prk_out));
		PRINT_MSG("\033[1mPRK_out derivation finished. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mPRK_out\033[0m", prk_out, get_hash_len(suite.edhoc_hash));
		PRINT_MSG("\n");

		PRINT_MSG("---------------------------------------------\n\n")


	} else {
		PRINT_MSG("\033[1mStatic DH Authentication not required. Copying PRK_in to PRK_out.\033[0m\n");
		/*it is save to do that since prks have the same size*/
		memcpy(prk_out, prk_in->ptr, prk_in->len);
		PRINT_MSG("\033[1mCopy finished. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mPRK_out\033[0m", prk_out, get_hash_len(suite.edhoc_hash));
		PRINT_MSG("\n");

		PRINT_MSG("---------------------------------------------\n\n")

	}
	return ok;
}

enum err prk_derive_psk(struct suite suite, uint8_t label,
	struct byte_array *context, const struct byte_array *prk_in,
	const struct byte_array *psk, uint8_t *prk_out)
{
	PRINT_MSG("\n---------------------------------------------\n\n");
	PRINT_MSG("\033[1mDeriving SALT_3e2m: EDHOC-KDF( PRK_3e, label=3, TH_3 )...\033[0m\n");
	BYTE_ARRAY_NEW(salt, HASH_SIZE, get_hash_len(suite.edhoc_hash));
	TRY(edhoc_kdf(suite.edhoc_hash, prk_in, label, context, &salt));
	PRINT_MSG("\033[1mFinished key derivation. Result:\033[0m\n");
	PRINT_ARRAY("\033[1mSALT_3e2m\033[0m", salt.ptr, salt.len);
	
	PRINT_MSG("\n---------------------------------------------\n\n");

	PRINT_MSG("\033[1mDeriving PRK_3e2m: EDHOC-KDF( PRK_3e, label=3, TH_3 )...\033[0m\n");
	TRY(hkdf_extract(suite.edhoc_hash, &salt, psk, prk_out));
	PRINT_MSG("\033[1mFinished key derivation. Result:\033[0m\n");
	PRINT_ARRAY("\033[1mPRK_3e2m\033[0m", prk_out, get_hash_len(suite.edhoc_hash));
	PRINT_MSG("\n---------------------------------------------\n\n");

	return ok;
}