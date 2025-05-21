/*
   Copyright (c) 2021 Fraunhofer AISEC. See the COPYRIGHT
   file at the top-level directory of this distribution.

   Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
   http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
   <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
   option. This file may not be copied, modified, or distributed
   except according to those terms.
*/

#include <stdint.h>
#include <stdbool.h>

#include "edhoc/retrieve_cred.h"
#include "edhoc/plaintext.h"
#include "edhoc/signature_or_mac_msg.h"
#include "edhoc/int_encode_decode.h"
#include "edhoc.h" // Corrected include path

#include "common/oscore_edhoc_error.h"
#include "common/memcpy_s.h"
#include "common/print_util.h"

// Include the new generated headers
#include "cbor/edhoc_decode_ptxt2sig.h"
#include "cbor/edhoc_decode_ptxt2psk.h"
#include "cbor/edhoc_decode_ptxt3sig.h"
#include "cbor/edhoc_decode_ptxt3psk.h"
#include "cbor/edhoc_decode_ptxt3psk_types.h" // Added for struct ptxt3psk definition

#include "cbor/edhoc_encode_id_cred_x.h"
// #include "cbor/edhoc_encode_int_type.h" // Removed - Caused redefinitions
// #include "cbor/edhoc_encode_ptxt2sig.h" // Removed - Caused redefinitions
// #include "cbor/edhoc_encode_ptxt2psk.h" // Removed - Caused redefinitions
#include "edhoc/edhoc_method_type.h" // Added for enum method_type
#include "edhoc/int_encode_decode.h" // Added for encode_int

/**
 * @brief 			Encodes ID_CRED_x as a CBOR map.
 * @param label 		The CBOR map label.
 * @param algo 			The EDHOC hash algorithm used in x5t. This 
 * 				parameter can take any other value when xchain 
 * 				or kid are used.
 * @param id 			The actual credential identifier.
 * @param id_len 		Length of id.
 * @param[out] id_cred_x	The encoded value.
 * @retval			Ok or error.
 */
static enum err id_cred_x_encode(enum id_cred_x_label label, int algo,
				 const void *id, uint32_t id_len,
				 struct byte_array *id_cred_x)
{
	struct id_cred_x_map map = { 0 };
	size_t payload_len_out;

	switch (label) {
	case kid:
		//todo update that to v15
		map.id_cred_x_map_kid_present = true;
		map.id_cred_x_map_kid.id_cred_x_map_kid_choice =
			id_cred_x_map_kid_int_c;
		map.id_cred_x_map_kid.id_cred_x_map_kid_int =
			*((const int32_t *)id);
		break;
	case x5chain:
		map.id_cred_x_map_x5chain_present = true;
		map.id_cred_x_map_x5chain.id_cred_x_map_x5chain.value = id;
		map.id_cred_x_map_x5chain.id_cred_x_map_x5chain.len = id_len;
		break;
	case x5t:
		map.id_cred_x_map_x5t_present = true;
		map.id_cred_x_map_x5t.id_cred_x_map_x5t_alg_choice =
			id_cred_x_map_x5t_alg_int_c;
		map.id_cred_x_map_x5t.id_cred_x_map_x5t_alg_int = algo;
		map.id_cred_x_map_x5t.id_cred_x_map_x5t_hash.value = id;
		map.id_cred_x_map_x5t.id_cred_x_map_x5t_hash.len = id_len;
		break;
	default:
		break;
	}

	TRY_EXPECT(cbor_encode_id_cred_x_map(id_cred_x->ptr, id_cred_x->len,
					     &map, &payload_len_out),
		   0);

	id_cred_x->len = (uint32_t)payload_len_out;

	return ok;
}

static enum err plaintext2_split_psk(struct byte_array *ptxt,
                                    struct byte_array *c_r,
                                    struct byte_array *sign_or_mac,
                                    struct byte_array *ead_2) // Added ead_2 parameter
{
    // Decode using the generated decoder for ptxt2psk
    size_t decode_len = 0;
    struct ptxt2psk p; // Use ptxt2psk struct
    int cbor_err = 0;

    cbor_err = cbor_decode_ptxt2psk(ptxt->ptr, ptxt->len, &p, &decode_len);
    if (cbor_err != 0) {
        return cbor_decoding_error; // Corrected error code
    }

    // Extract C_R (assuming it's always present and is an int for simplicity here)
    // A robust implementation would handle both int and bstr choices
    if (p.ptxt2psk_C_R_choice == ptxt2psk_C_R_int_c) {
        // Encode the integer C_R back into a byte array if needed elsewhere,
        // or handle the integer value directly. Here we just copy it if it fits.
        // This part might need adjustment based on how C_R is used later.
        // For now, let's assume c_r buffer is large enough for encoded int.
        // Use generic encode_int instead of non-existent specific function
        // Correct arguments: pointer to int, length (1), output byte_array
        cbor_err = encode_int(&p.ptxt2psk_C_R_int, 1, c_r);
        if (cbor_err != ok) return cbor_encoding_error; // Check against 'ok' enum
        // encode_int likely updates c_r->len directly.
    } else if (p.ptxt2psk_C_R_choice == ptxt2psk_C_R_bstr_c) {
        TRY(_memcpy_s(c_r->ptr, c_r->len, p.ptxt2psk_C_R_bstr.value, (uint32_t)p.ptxt2psk_C_R_bstr.len));
        c_r->len = (uint32_t)p.ptxt2psk_C_R_bstr.len;
    } else {
        return wrong_parameter; // C_R must be present
    }


    // Copy MAC_2
    TRY(_memcpy_s(sign_or_mac->ptr, sign_or_mac->len,
                  p.ptxt2psk_MAC_2.value,
                  (uint32_t)p.ptxt2psk_MAC_2.len));
    sign_or_mac->len = (uint32_t)p.ptxt2psk_MAC_2.len;

    // Copy EAD_2 if present
    if (p.ptxt2psk_EAD_2_present) {
        TRY(_memcpy_s(ead_2->ptr, ead_2->len, p.ptxt2psk_EAD_2.value,
                      (uint32_t)p.ptxt2psk_EAD_2.len));
        ead_2->len = (uint32_t)p.ptxt2psk_EAD_2.len;
    } else {
        ead_2->len = 0;
    }

    return ok;
}


/**
 * @brief Splits plaintext 2 into its components (signature variant).
 * @param ptxt The plaintext to split.
 * @param c_r Connection identifier chosen by the responder. // Added parameter
 * @param id_cred_r The credential identifier of the responder.
 * @param sign_or_mac The signature or MAC.
 * @param ead_2 EAD_2 value.
 * @return Ok or error.
 */
static enum err plaintext2_split_sig(struct byte_array *ptxt,
                     struct byte_array *c_r, 
				     struct byte_array *id_cred_r,
				     struct byte_array *sign_or_mac,
				     struct byte_array *ead_2)
{
	size_t decode_len = 0;
	struct ptxt2sig p;

	TRY_EXPECT(cbor_decode_ptxt2sig(ptxt->ptr, ptxt->len, &p, &decode_len), 0);



	/*decode C_R*/
	if (p.ptxt2sig_C_R_choice == ptxt2sig_C_R_bstr_c) {
		TRY(_memcpy_s(c_r->ptr, c_r->len, p.ptxt2sig_C_R_bstr.value,
			      (uint32_t)p.ptxt2sig_C_R_bstr.len));
		c_r->len = (uint32_t)p.ptxt2sig_C_R_bstr.len;
	} else {
		/*provide C_R in encoded form if it was an int*/
		/*this is how it C_R was chosen by the responder*/
		TRY(encode_int(&p.ptxt2sig_C_R_int, 1, c_r));
	}

	/*ID_CRED_R*/
	if (p.ptxt2sig_ID_CRED_X_choice == ptxt2sig_ID_CRED_X_map2_m_c) {
		if (p.ptxt2sig_ID_CRED_X_map2_m.map2_x5chain_present) {
			TRY(id_cred_x_encode(
				x5chain, 0,
				p.ptxt2sig_ID_CRED_X_map2_m.map2_x5chain
					.map2_x5chain.value,
				(uint32_t)p.ptxt2sig_ID_CRED_X_map2_m.map2_x5chain
					.map2_x5chain.len,
				id_cred_r));
		}
		if (p.ptxt2sig_ID_CRED_X_map2_m.map2_x5t_present) {
			TRY(id_cred_x_encode(x5t,
					     p.ptxt2sig_ID_CRED_X_map2_m.map2_x5t
						     .map2_x5t_alg_int,
					     p.ptxt2sig_ID_CRED_X_map2_m.map2_x5t
						     .map2_x5t_hash.value,
					     (uint32_t)p.ptxt2sig_ID_CRED_X_map2_m
						     .map2_x5t.map2_x5t_hash.len,
					     id_cred_r));
		}
	} else {
		/*Note that if ID_CRED_x contains a single 'kid' parameter,
            i.e., ID_CRED_R = { 4 : kid_x }, only the byte string kid_x
            is conveyed in the plaintext encoded as a bstr or int*/
		if (p.ptxt2sig_ID_CRED_X_choice == ptxt2sig_ID_CRED_X_bstr_c) {
			TRY(id_cred_x_encode(
				kid, 0, p.ptxt2sig_ID_CRED_X_bstr.value,
				(uint32_t)p.ptxt2sig_ID_CRED_X_bstr.len,
				id_cred_r));

		} else if (p.ptxt2sig_ID_CRED_X_choice == ptxt2sig_ID_CRED_X_int_c) {
			int _kid = p.ptxt2sig_ID_CRED_X_int;
			TRY(id_cred_x_encode(kid, 0, &_kid, sizeof(_kid), id_cred_r)); // Updated size to sizeof(_kid)
		} else {
			return wrong_parameter;
		}
	}
	TRY(_memcpy_s(sign_or_mac->ptr, sign_or_mac->len,
		      p.ptxt2sig_SGN_or_MAC_2.value,
		      (uint32_t)p.ptxt2sig_SGN_or_MAC_2.len));
	sign_or_mac->len = (uint32_t)p.ptxt2sig_SGN_or_MAC_2.len;

	if (p.ptxt2sig_EAD_2_present == true) {
		TRY(_memcpy_s(ead_2->ptr, ead_2->len, p.ptxt2sig_EAD_2.value,
			      (uint32_t)p.ptxt2sig_EAD_2.len));
		ead_2->len = (uint32_t)p.ptxt2sig_EAD_2.len;
	} else {
		if (ead_2->len) {
			ead_2->len = 0;
		}
	}

	return ok;
}

/**
 * @brief Splits plaintext 3 into its components (signature variant).
 * @param ptxt The plaintext to split.
 * @param id_cred_i The credential identifier of the initiator.
 * @param sign_or_mac The signature or MAC.
 * @param ead_3 EAD_3 value.
 * @return Ok or error.
 */
static enum err plaintext3_split_sig(struct byte_array *ptxt,
				     struct byte_array *id_cred_i,
				     struct byte_array *sign_or_mac,
				     struct byte_array *ead_3)
{
	size_t decode_len = 0;
	struct ptxt3sig p;
	int cbor_err = 0;

	cbor_err = cbor_decode_ptxt3sig(ptxt->ptr, ptxt->len, &p, &decode_len);
	if (cbor_err != 0) {
		return cbor_decoding_error; // Corrected error code
	}

	/*ID_CRED_I*/
	if (p.ptxt3sig_ID_CRED_I_choice == ptxt3sig_ID_CRED_I_map3_m_c) {
		if (p.ptxt3sig_ID_CRED_I_map3_m.map3_x5chain_present) {
			PRINT_MSG("ID_CRED_I is x5chain\n");
			TRY(id_cred_x_encode(
				x5chain, 0,
				p.ptxt3sig_ID_CRED_I_map3_m.map3_x5chain
					.map3_x5chain.value,
				(uint32_t)p.ptxt3sig_ID_CRED_I_map3_m.map3_x5chain
					.map3_x5chain.len,
				id_cred_i));
		}
		if (p.ptxt3sig_ID_CRED_I_map3_m.map3_x5t_present) {
			PRINT_MSG("ID_CRED_I is x5t\n");
			TRY(id_cred_x_encode(x5t,
					     p.ptxt3sig_ID_CRED_I_map3_m.map3_x5t
						     .map3_x5t_alg_int,
					     p.ptxt3sig_ID_CRED_I_map3_m.map3_x5t
						     .map3_x5t_hash.value,
					     (uint32_t)p.ptxt3sig_ID_CRED_I_map3_m
						     .map3_x5t.map3_x5t_hash.len,
					     id_cred_i));
		}
	} else {
		/*Note that if ID_CRED_x contains a single 'kid' parameter,
            i.e., ID_CRED_I = { 4 : kid_x }, only the byte string kid_x
            is conveyed in the plaintext encoded as a bstr or int*/
		if (p.ptxt3sig_ID_CRED_I_choice == ptxt3sig_ID_CRED_I_map3_m_c) {
			TRY(id_cred_x_encode(
				kid, 0, p.ptxt3sig_ID_CRED_I_bstr.value,
				(uint32_t)p.ptxt3sig_ID_CRED_I_bstr.len,
				id_cred_i));

		} else {
			int _kid = p.ptxt3sig_ID_CRED_I_int;
			TRY(id_cred_x_encode(kid, 0, &_kid, 1, id_cred_i));
		}
	}
	TRY(_memcpy_s(sign_or_mac->ptr, sign_or_mac->len,
		      p.ptxt3sig_SGN_or_MAC_3.value,
		      (uint32_t)p.ptxt3sig_SGN_or_MAC_3.len));
	sign_or_mac->len = (uint32_t)p.ptxt3sig_SGN_or_MAC_3.len;

	if (p.ptxt3sig_EAD_3_present == true) {
		TRY(_memcpy_s(ead_3->ptr, ead_3->len, p.ptxt3sig_EAD_3.value,
			      (uint32_t)p.ptxt3sig_EAD_3.len));
		ead_3->len = (uint32_t)p.ptxt3sig_EAD_3.len;
	} else {
		if (ead_3->len) {
			ead_3->len = 0;
		}
	}
	return ok;
}

/**
 * @brief Splits plaintext 3 into its components (PSK variant).
 * @param ptxt The plaintext to split.
 * @param ead_3 EAD_3 value. // Only EAD_3 is present according to CDDL
 * @return Ok or error.
 */
static enum err plaintext3_split_psk(struct byte_array *ptxt,
				     // No id_cred_i for PSK msg 3
				     // No sign_or_mac for PSK msg 3
				     struct byte_array *ead_3)
{
	size_t decode_len = 0;
	// Use the struct that actually contains EAD_3, based on _types.h
	struct ptxt3psk_EAD_3 p; 
	int cbor_err = 0;

	// Decode the plaintext using the generated CBOR decoder for ptxt3psk
    // The decoder expects a pointer to the structure holding the optional EAD_3
    // Use the correct function name from the header
	cbor_err = cbor_decode_ptxt3psk_EAD_3(ptxt->ptr, ptxt->len, &p, &decode_len);
	if (cbor_err != 0) {
		// If decoding fails, it might be because the plaintext was empty (allowed if EAD_3 is absent)
        // Check if the plaintext is indeed empty and return ok if so.
        if (ptxt->len == 0) {
            ead_3->len = 0;
            return ok;
        }
		return cbor_decoding_error; // Corrected error code
	}

    // According to the CDDL `ptxt3psk = (? EAD_3: bstr)`, there is only EAD_3.
    // ID_CRED_I and MAC_3 are NOT part of ptxt3psk.

	// Copy EAD_3 if present
	if (p.ptxt3psk_EAD_3_present) { // Use the correct struct member
		TRY(_memcpy_s(ead_3->ptr, ead_3->len, p.ptxt3psk_EAD_3.value, // Use the correct struct member
			      (uint32_t)p.ptxt3psk_EAD_3.len)); // Use the correct struct member
		ead_3->len = (uint32_t)p.ptxt3psk_EAD_3.len; // Use the correct struct member
	} else {
		ead_3->len = 0;
	}

	return ok;
}


enum err plaintext_split(struct byte_array *ptxt, struct byte_array *c_r,
			 struct byte_array *id_cred_x,
			 struct byte_array *sign_or_mac, struct byte_array *ead, bool is_psk)
{
    PRINT_MSG("\n\033[1mSplitting plaintext...\033[0m\n\n");
	enum err ret = ok; // Initialize ret

	/* C_R is present only in plaintext 2 */
	if (c_r != NULL) {
		// Dispatch based on method for plaintext 2
		if (is_psk) { // Use correct enum value
            PRINT_MSG("Splitting plaintext 2 (PSK)...\n");
            // For PSK, ID_CRED_R is not expected in the main structure according to ptxt2psk CDDL
            id_cred_x->len = 0;
            // Pass ead buffer to plaintext2_split_psk
            ret = plaintext2_split_psk(ptxt, c_r, sign_or_mac, ead); // Pass all relevant args
		} else {
            PRINT_MSG("Splitting plaintext 2 (Signature/Static DH)...\n");
            // Pass c_r to plaintext2_split_sig as it's now part of the signature
			ret = plaintext2_split_sig(ptxt, c_r, id_cred_x, sign_or_mac, ead); // Correct arguments
		}
    } else { /* Plaintext 3 (c_r is NULL) */
        // Dispatch based on method for plaintext 3
        if (is_psk) { // Use correct enum value
             PRINT_MSG("Splitting plaintext 3 (PSK)...\n");
             // For PSK msg 3, only EAD_3 is present. ID_CRED_I and MAC_3 are not.
             id_cred_x->len = 0;     // No ID_CRED_I
             sign_or_mac->len = 0; // No MAC_3
             ret = plaintext3_split_psk(ptxt, ead); // Pass only relevant args (ptxt, ead_3)
        } else {
             PRINT_MSG("Splitting plaintext 3 (Signature/Static DH)...\n");
             // Pass id_cred_x as the buffer for ID_CRED_I
             ret = plaintext3_split_sig(ptxt, id_cred_x, sign_or_mac, ead);
        }
    }
	PRINT_MSG("\n---------------------------------------------\n\n");
	return ret;
}
