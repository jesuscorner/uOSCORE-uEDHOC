/*
 * Generated using zcbor version 0.8.99
 * https://github.com/NordicSemiconductor/zcbor
 * Generated with a --default-max-qty of 3
 */

#ifndef EDHOC_ENCODE_PTXT3PSK_TYPES_H__
#define EDHOC_ENCODE_PTXT3PSK_TYPES_H__

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <zcbor_common.h>

#ifdef __cplusplus
extern "C" {
#endif

/** Which value for --default-max-qty this file was created with.
 *
 *  The define is used in the other generated file to do a build-time
 *  compatibility check.
 *
 *  See `zcbor --help` for more information about --default-max-qty
 */
#define DEFAULT_MAX_QTY 3

struct ptxt3psk_EAD_3 {
	struct zcbor_string ptxt3psk_EAD_3;
	bool ptxt3psk_EAD_3_present;
};

#ifdef __cplusplus
}
#endif

#endif /* EDHOC_ENCODE_PTXT3PSK_TYPES_H__ */
