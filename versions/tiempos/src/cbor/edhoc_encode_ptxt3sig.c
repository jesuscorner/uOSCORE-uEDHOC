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
#include "cbor/edhoc_encode_ptxt3sig.h"
#include "zcbor_print.h"

#if DEFAULT_MAX_QTY != 3
#error "The type file was generated with a different default_max_qty than this file"
#endif

static bool encode_repeated_map3_kid(zcbor_state_t *state, const struct map3_kid_r *input);
static bool encode_repeated_map3_x5bag(zcbor_state_t *state, const struct map3_x5bag *input);
static bool encode_repeated_map3_x5chain(zcbor_state_t *state, const struct map3_x5chain *input);
static bool encode_repeated_map3_x5t(zcbor_state_t *state, const struct map3_x5t_r *input);
static bool encode_repeated_map3_x5u(zcbor_state_t *state, const struct map3_x5u *input);
static bool encode_repeated_map3_c5b(zcbor_state_t *state, const struct map3_c5b *input);
static bool encode_repeated_map3_c5c(zcbor_state_t *state, const struct map3_c5c *input);
static bool encode_repeated_map3_c5t(zcbor_state_t *state, const struct map3_c5t_r *input);
static bool encode_repeated_map3_c5u(zcbor_state_t *state, const struct map3_c5u *input);
static bool encode_map3(zcbor_state_t *state, const struct map3 *input);
static bool encode_ptxt3sig(zcbor_state_t *state, const struct ptxt3sig *input);


static bool encode_repeated_map3_kid(
		zcbor_state_t *state, const struct map3_kid_r *input)
{
	zcbor_log("%s\r\n", __func__);

	bool tmp_result = ((((zcbor_uint32_put(state, (4))))
	&& (((*input).map3_kid_choice == map3_kid_int_c) ? ((zcbor_int32_encode(state, (&(*input).map3_kid_int))))
	: (((*input).map3_kid_choice == map3_kid_bstr_c) ? ((zcbor_bstr_encode(state, (&(*input).map3_kid_bstr))))
	: false))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}

static bool encode_repeated_map3_x5bag(
		zcbor_state_t *state, const struct map3_x5bag *input)
{
	zcbor_log("%s\r\n", __func__);

	bool tmp_result = ((((zcbor_uint32_put(state, (32))))
	&& (zcbor_bstr_encode(state, (&(*input).map3_x5bag)))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}

static bool encode_repeated_map3_x5chain(
		zcbor_state_t *state, const struct map3_x5chain *input)
{
	zcbor_log("%s\r\n", __func__);

	bool tmp_result = ((((zcbor_uint32_put(state, (33))))
	&& (zcbor_bstr_encode(state, (&(*input).map3_x5chain)))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}

static bool encode_repeated_map3_x5t(
		zcbor_state_t *state, const struct map3_x5t_r *input)
{
	zcbor_log("%s\r\n", __func__);

	bool tmp_result = ((((zcbor_uint32_put(state, (34))))
	&& (zcbor_list_start_encode(state, 2) && ((((((*input).map3_x5t_alg_choice == map3_x5t_alg_int_c) ? ((zcbor_int32_encode(state, (&(*input).map3_x5t_alg_int))))
	: (((*input).map3_x5t_alg_choice == map3_x5t_alg_tstr_c) ? ((zcbor_tstr_encode(state, (&(*input).map3_x5t_alg_tstr))))
	: false)))
	&& ((zcbor_bstr_encode(state, (&(*input).map3_x5t_hash))))) || (zcbor_list_map_end_force_encode(state), false)) && zcbor_list_end_encode(state, 2))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}

static bool encode_repeated_map3_x5u(
		zcbor_state_t *state, const struct map3_x5u *input)
{
	zcbor_log("%s\r\n", __func__);

	bool tmp_result = ((((zcbor_uint32_put(state, (35))))
	&& (zcbor_bstr_encode(state, (&(*input).map3_x5u)))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}

static bool encode_repeated_map3_c5b(
		zcbor_state_t *state, const struct map3_c5b *input)
{
	zcbor_log("%s\r\n", __func__);

	bool tmp_result = ((((zcbor_uint32_put(state, (52))))
	&& (zcbor_bstr_encode(state, (&(*input).map3_c5b)))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}

static bool encode_repeated_map3_c5c(
		zcbor_state_t *state, const struct map3_c5c *input)
{
	zcbor_log("%s\r\n", __func__);

	bool tmp_result = ((((zcbor_uint32_put(state, (53))))
	&& (zcbor_bstr_encode(state, (&(*input).map3_c5c)))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}

static bool encode_repeated_map3_c5t(
		zcbor_state_t *state, const struct map3_c5t_r *input)
{
	zcbor_log("%s\r\n", __func__);

	bool tmp_result = ((((zcbor_uint32_put(state, (54))))
	&& (zcbor_list_start_encode(state, 2) && ((((((*input).map3_c5t_alg_choice == map3_c5t_alg_int_c) ? ((zcbor_int32_encode(state, (&(*input).map3_c5t_alg_int))))
	: (((*input).map3_c5t_alg_choice == map3_c5t_alg_tstr_c) ? ((zcbor_tstr_encode(state, (&(*input).map3_c5t_alg_tstr))))
	: false)))
	&& ((zcbor_bstr_encode(state, (&(*input).map3_c5t_hash))))) || (zcbor_list_map_end_force_encode(state), false)) && zcbor_list_end_encode(state, 2))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}

static bool encode_repeated_map3_c5u(
		zcbor_state_t *state, const struct map3_c5u *input)
{
	zcbor_log("%s\r\n", __func__);

	bool tmp_result = ((((zcbor_uint32_put(state, (55))))
	&& (zcbor_bstr_encode(state, (&(*input).map3_c5u)))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}

static bool encode_map3(
		zcbor_state_t *state, const struct map3 *input)
{
	zcbor_log("%s\r\n", __func__);

	bool tmp_result = (((zcbor_map_start_encode(state, 9) && (((!(*input).map3_kid_present || encode_repeated_map3_kid(state, (&(*input).map3_kid)))
	&& (!(*input).map3_x5bag_present || encode_repeated_map3_x5bag(state, (&(*input).map3_x5bag)))
	&& (!(*input).map3_x5chain_present || encode_repeated_map3_x5chain(state, (&(*input).map3_x5chain)))
	&& (!(*input).map3_x5t_present || encode_repeated_map3_x5t(state, (&(*input).map3_x5t)))
	&& (!(*input).map3_x5u_present || encode_repeated_map3_x5u(state, (&(*input).map3_x5u)))
	&& (!(*input).map3_c5b_present || encode_repeated_map3_c5b(state, (&(*input).map3_c5b)))
	&& (!(*input).map3_c5c_present || encode_repeated_map3_c5c(state, (&(*input).map3_c5c)))
	&& (!(*input).map3_c5t_present || encode_repeated_map3_c5t(state, (&(*input).map3_c5t)))
	&& (!(*input).map3_c5u_present || encode_repeated_map3_c5u(state, (&(*input).map3_c5u)))) || (zcbor_list_map_end_force_encode(state), false)) && zcbor_map_end_encode(state, 9))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}

static bool encode_ptxt3sig(
		zcbor_state_t *state, const struct ptxt3sig *input)
{
	zcbor_log("%s\r\n", __func__);

	bool tmp_result = (((((((*input).ptxt3sig_ID_CRED_I_choice == ptxt3sig_ID_CRED_I_map3_m_c) ? ((encode_map3(state, (&(*input).ptxt3sig_ID_CRED_I_map3_m))))
	: (((*input).ptxt3sig_ID_CRED_I_choice == ptxt3sig_ID_CRED_I_bstr_c) ? ((zcbor_bstr_encode(state, (&(*input).ptxt3sig_ID_CRED_I_bstr))))
	: (((*input).ptxt3sig_ID_CRED_I_choice == ptxt3sig_ID_CRED_I_int_c) ? ((zcbor_int32_encode(state, (&(*input).ptxt3sig_ID_CRED_I_int))))
	: false))))
	&& ((zcbor_bstr_encode(state, (&(*input).ptxt3sig_SGN_or_MAC_3))))
	&& (!(*input).ptxt3sig_EAD_3_present || zcbor_bstr_encode(state, (&(*input).ptxt3sig_EAD_3))))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}



int cbor_encode_ptxt3sig(
		uint8_t *payload, size_t payload_len,
		const struct ptxt3sig *input,
		size_t *payload_len_out)
{
	zcbor_state_t states[6];

	return zcbor_entry_function(payload, payload_len, (void *)input, payload_len_out, states,
		(zcbor_decoder_t *)encode_ptxt3sig, sizeof(states) / sizeof(zcbor_state_t), 3);
}
