/*
 * Generated using zcbor version 0.8.99
 * https://github.com/NordicSemiconductor/zcbor
 * Generated with a --default-max-qty of 3
 */

#ifndef EDHOC_DECODE_PTXT2PSK_H__
#define EDHOC_DECODE_PTXT2PSK_H__

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <string.h>
#include "cbor/edhoc_decode_ptxt2psk_types.h"

#ifdef __cplusplus
extern "C" {
#endif

#if DEFAULT_MAX_QTY != 3
#error "The type file was generated with a different default_max_qty than this file"
#endif


int cbor_decode_ptxt2psk(
		const uint8_t *payload, size_t payload_len,
		struct ptxt2psk *result,
		size_t *payload_len_out);


#ifdef __cplusplus
}
#endif

#endif /* EDHOC_DECODE_PTXT2PSK_H__ */
