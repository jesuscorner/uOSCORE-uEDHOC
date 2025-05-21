/*
 * Generated using zcbor version 0.8.99
 * https://github.com/NordicSemiconductor/zcbor
 * Generated with a --default-max-qty of 3
 */

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <string.h>
#include "zcbor_encode.h"
#include "cbor/edhoc_encode_ptxt2psk.h"
#include "zcbor_print.h"

#if DEFAULT_MAX_QTY != 3
#error "The type file was generated with a different default_max_qty than this file"
#endif

static bool encode_ptxt2psk(zcbor_state_t *state, const struct ptxt2psk *input);


static bool encode_ptxt2psk(
		zcbor_state_t *state, const struct ptxt2psk *input)
{
	zcbor_log("%s\r\n", __func__);

	bool tmp_result = (((((((*input).ptxt2psk_C_R_choice == ptxt2psk_C_R_int_c) ? ((zcbor_int32_encode(state, (&(*input).ptxt2psk_C_R_int))))
	: (((*input).ptxt2psk_C_R_choice == ptxt2psk_C_R_bstr_c) ? ((zcbor_bstr_encode(state, (&(*input).ptxt2psk_C_R_bstr))))
	: false)))
	&& ((zcbor_bstr_encode(state, (&(*input).ptxt2psk_MAC_2))))
	&& (!(*input).ptxt2psk_EAD_2_present || zcbor_bstr_encode(state, (&(*input).ptxt2psk_EAD_2))))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}



int cbor_encode_ptxt2psk(
		uint8_t *payload, size_t payload_len,
		const struct ptxt2psk *input,
		size_t *payload_len_out)
{
	zcbor_state_t states[3];

	return zcbor_entry_function(payload, payload_len, (void *)input, payload_len_out, states,
		(zcbor_decoder_t *)encode_ptxt2psk, sizeof(states) / sizeof(zcbor_state_t), 3);
}
