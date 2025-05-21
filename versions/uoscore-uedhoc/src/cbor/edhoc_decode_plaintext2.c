/*
 * Generated using zcbor version 0.8.99
 * https://github.com/NordicSemiconductor/zcbor
 * Generated with a --default-max-qty of 3
 */

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <string.h>
#include "zcbor_decode.h"
#include "cbor/edhoc_decode_plaintext2.h"
#include "zcbor_print.h"

#if DEFAULT_MAX_QTY != 3
#error "The type file was generated with a different default_max_qty than this file"
#endif

static bool decode_repeated_map2_kid(zcbor_state_t *state, struct map2_kid_r *result);
static bool decode_repeated_map2_x5bag(zcbor_state_t *state, struct map2_x5bag *result);
static bool decode_repeated_map2_x5chain(zcbor_state_t *state, struct map2_x5chain *result);
static bool decode_repeated_map2_x5t(zcbor_state_t *state, struct map2_x5t_r *result);
static bool decode_repeated_map2_x5u(zcbor_state_t *state, struct map2_x5u *result);
static bool decode_repeated_map2_c5b(zcbor_state_t *state, struct map2_c5b *result);
static bool decode_repeated_map2_c5c(zcbor_state_t *state, struct map2_c5c *result);
static bool decode_repeated_map2_c5t(zcbor_state_t *state, struct map2_c5t_r *result);
static bool decode_repeated_map2_c5u(zcbor_state_t *state, struct map2_c5u *result);
static bool decode_map2(zcbor_state_t *state, struct map2 *result);
static bool decode_ptxt2(zcbor_state_t *state, struct ptxt2 *result);


static bool decode_repeated_map2_kid(
		zcbor_state_t *state, struct map2_kid_r *result)
{
	zcbor_log("%s\r\n", __func__);
	bool int_res;

	bool tmp_result = ((((zcbor_uint32_expect(state, (4))))
	&& (zcbor_union_start_code(state) && (int_res = ((((zcbor_int32_decode(state, (&(*result).map2_kid_int)))) && (((*result).map2_kid_choice = map2_kid_int_c), true))
	|| (((zcbor_bstr_decode(state, (&(*result).map2_kid_bstr)))) && (((*result).map2_kid_choice = map2_kid_bstr_c), true))), zcbor_union_end_code(state), int_res))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}

static bool decode_repeated_map2_x5bag(
		zcbor_state_t *state, struct map2_x5bag *result)
{
	zcbor_log("%s\r\n", __func__);

	bool tmp_result = ((((zcbor_uint32_expect(state, (32))))
	&& (zcbor_bstr_decode(state, (&(*result).map2_x5bag)))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}

static bool decode_repeated_map2_x5chain(
		zcbor_state_t *state, struct map2_x5chain *result)
{
	zcbor_log("%s\r\n", __func__);

	bool tmp_result = ((((zcbor_uint32_expect(state, (33))))
	&& (zcbor_bstr_decode(state, (&(*result).map2_x5chain)))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}

static bool decode_repeated_map2_x5t(
		zcbor_state_t *state, struct map2_x5t_r *result)
{
	zcbor_log("%s\r\n", __func__);
	bool int_res;

	bool tmp_result = ((((zcbor_uint32_expect(state, (34))))
	&& (zcbor_list_start_decode(state) && ((((zcbor_union_start_code(state) && (int_res = ((((zcbor_int32_decode(state, (&(*result).map2_x5t_alg_int)))) && (((*result).map2_x5t_alg_choice = map2_x5t_alg_int_c), true))
	|| (((zcbor_tstr_decode(state, (&(*result).map2_x5t_alg_tstr)))) && (((*result).map2_x5t_alg_choice = map2_x5t_alg_tstr_c), true))), zcbor_union_end_code(state), int_res)))
	&& ((zcbor_bstr_decode(state, (&(*result).map2_x5t_hash))))) || (zcbor_list_map_end_force_decode(state), false)) && zcbor_list_end_decode(state))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}

static bool decode_repeated_map2_x5u(
		zcbor_state_t *state, struct map2_x5u *result)
{
	zcbor_log("%s\r\n", __func__);

	bool tmp_result = ((((zcbor_uint32_expect(state, (35))))
	&& (zcbor_bstr_decode(state, (&(*result).map2_x5u)))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}

static bool decode_repeated_map2_c5b(
		zcbor_state_t *state, struct map2_c5b *result)
{
	zcbor_log("%s\r\n", __func__);

	bool tmp_result = ((((zcbor_uint32_expect(state, (52))))
	&& (zcbor_bstr_decode(state, (&(*result).map2_c5b)))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}

static bool decode_repeated_map2_c5c(
		zcbor_state_t *state, struct map2_c5c *result)
{
	zcbor_log("%s\r\n", __func__);

	bool tmp_result = ((((zcbor_uint32_expect(state, (53))))
	&& (zcbor_bstr_decode(state, (&(*result).map2_c5c)))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}

static bool decode_repeated_map2_c5t(
		zcbor_state_t *state, struct map2_c5t_r *result)
{
	zcbor_log("%s\r\n", __func__);
	bool int_res;

	bool tmp_result = ((((zcbor_uint32_expect(state, (54))))
	&& (zcbor_list_start_decode(state) && ((((zcbor_union_start_code(state) && (int_res = ((((zcbor_int32_decode(state, (&(*result).map2_c5t_alg_int)))) && (((*result).map2_c5t_alg_choice = map2_c5t_alg_int_c), true))
	|| (((zcbor_tstr_decode(state, (&(*result).map2_c5t_alg_tstr)))) && (((*result).map2_c5t_alg_choice = map2_c5t_alg_tstr_c), true))), zcbor_union_end_code(state), int_res)))
	&& ((zcbor_bstr_decode(state, (&(*result).map2_c5t_hash))))) || (zcbor_list_map_end_force_decode(state), false)) && zcbor_list_end_decode(state))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}

static bool decode_repeated_map2_c5u(
		zcbor_state_t *state, struct map2_c5u *result)
{
	zcbor_log("%s\r\n", __func__);

	bool tmp_result = ((((zcbor_uint32_expect(state, (55))))
	&& (zcbor_bstr_decode(state, (&(*result).map2_c5u)))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}

static bool decode_map2(
		zcbor_state_t *state, struct map2 *result)
{
	zcbor_log("%s\r\n", __func__);

	bool tmp_result = (((zcbor_map_start_decode(state) && ((zcbor_present_decode(&((*result).map2_kid_present), (zcbor_decoder_t *)decode_repeated_map2_kid, state, (&(*result).map2_kid))
	&& zcbor_present_decode(&((*result).map2_x5bag_present), (zcbor_decoder_t *)decode_repeated_map2_x5bag, state, (&(*result).map2_x5bag))
	&& zcbor_present_decode(&((*result).map2_x5chain_present), (zcbor_decoder_t *)decode_repeated_map2_x5chain, state, (&(*result).map2_x5chain))
	&& zcbor_present_decode(&((*result).map2_x5t_present), (zcbor_decoder_t *)decode_repeated_map2_x5t, state, (&(*result).map2_x5t))
	&& zcbor_present_decode(&((*result).map2_x5u_present), (zcbor_decoder_t *)decode_repeated_map2_x5u, state, (&(*result).map2_x5u))
	&& zcbor_present_decode(&((*result).map2_c5b_present), (zcbor_decoder_t *)decode_repeated_map2_c5b, state, (&(*result).map2_c5b))
	&& zcbor_present_decode(&((*result).map2_c5c_present), (zcbor_decoder_t *)decode_repeated_map2_c5c, state, (&(*result).map2_c5c))
	&& zcbor_present_decode(&((*result).map2_c5t_present), (zcbor_decoder_t *)decode_repeated_map2_c5t, state, (&(*result).map2_c5t))
	&& zcbor_present_decode(&((*result).map2_c5u_present), (zcbor_decoder_t *)decode_repeated_map2_c5u, state, (&(*result).map2_c5u))) || (zcbor_list_map_end_force_decode(state), false)) && zcbor_map_end_decode(state))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}

static bool decode_ptxt2(
		zcbor_state_t *state, struct ptxt2 *result)
{
	zcbor_log("%s\r\n", __func__);
	bool int_res;

	bool tmp_result = (((((zcbor_union_start_code(state) && (int_res = ((((zcbor_int32_decode(state, (&(*result).ptxt2_C_R_int)))) && (((*result).ptxt2_C_R_choice = ptxt2_C_R_int_c), true))
	|| (((zcbor_bstr_decode(state, (&(*result).ptxt2_C_R_bstr)))) && (((*result).ptxt2_C_R_choice = ptxt2_C_R_bstr_c), true))), zcbor_union_end_code(state), int_res)))
	&& ((zcbor_union_start_code(state) && (int_res = ((((decode_map2(state, (&(*result).ptxt2_ID_CRED_R_map2_m)))) && (((*result).ptxt2_ID_CRED_R_choice = ptxt2_ID_CRED_R_map2_m_c), true))
	|| (zcbor_union_elem_code(state) && (((zcbor_bstr_decode(state, (&(*result).ptxt2_ID_CRED_R_bstr)))) && (((*result).ptxt2_ID_CRED_R_choice = ptxt2_ID_CRED_R_bstr_c), true)))
	|| (((zcbor_int32_decode(state, (&(*result).ptxt2_ID_CRED_R_int)))) && (((*result).ptxt2_ID_CRED_R_choice = ptxt2_ID_CRED_R_int_c), true))), zcbor_union_end_code(state), int_res)))
	&& ((zcbor_bstr_decode(state, (&(*result).ptxt2_SGN_or_MAC_2))))
	&& ((*result).ptxt2_EAD_2_present = ((zcbor_bstr_decode(state, (&(*result).ptxt2_EAD_2)))), 1))));

	if (!tmp_result) {
		zcbor_trace_file(state);
		zcbor_log("%s error: %s\r\n", __func__, zcbor_error_str(zcbor_peek_error(state)));
	} else {
		zcbor_log("%s success\r\n", __func__);
	}

	return tmp_result;
}



int cbor_decode_ptxt2(
		const uint8_t *payload, size_t payload_len,
		struct ptxt2 *result,
		size_t *payload_len_out)
{
	zcbor_state_t states[6];

	return zcbor_entry_function(payload, payload_len, (void *)result, payload_len_out, states,
		(zcbor_decoder_t *)decode_ptxt2, sizeof(states) / sizeof(zcbor_state_t), 4);
}
