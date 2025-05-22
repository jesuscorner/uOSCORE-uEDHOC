#ifndef CBOR_PRINT_MESSAGE_1_H
#define CBOR_PRINT_MESSAGE_1_H

#include <stdint.h>
#include <stddef.h> // For size_t

/**
 * @brief Imprime detalladamente el contenido de message_1 codificado en CBOR.
 *
 * Cada campo de EDHOC message_1 se muestra en hexadecimal junto con una flecha
 * y su descripción (nombre, valor interpretado y tipo de dato).
 *
 * @param msg       Puntero al mensaje_1 codificado (secuencia CBOR).
 * @param msg_len   Longitud en bytes de msg.
 */
void cbor_print_message_1(const uint8_t *msg, size_t msg_len);

#endif // CBOR_PRINT_MESSAGE_1_H
