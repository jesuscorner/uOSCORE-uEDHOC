#include <stdint.h>
#include <stdio.h>
#include <string.h> // For strlen, sprintf
#include "common/print_util.h"   // Para usar PRINTF, PRINT_ARRAY, etc.
#include "common/cbor_print_message_1.h" // Header file for this implementation

/**
 * @brief Imprime detalladamente el contenido de message_1 codificado en CBOR.
 *
 * Cada campo de EDHOC message_1 se muestra en hexadecimal junto con una flecha 
 * y su descripción (nombre, valor interpretado y tipo de dato).
 *
 * @param msg       Puntero al mensaje_1 codificado (secuencia CBOR).
 * @param msg_len   Longitud en bytes de msg.
 */
void cbor_print_message_1(const uint8_t *msg, size_t msg_len) {
    if (msg == NULL || msg_len == 0) {
        PRINTF("message_1 vacío o nulo.\n");
        return;
    }

    // Imprimir cabecera de la sección
    PRINTF("\nmessage_1 (CBOR Sequence):\n");

    size_t index = 0;
    char hex_buf[512];  // Buffer para representar los bytes en hex (512 es suficiente para message_1)
    size_t hex_len;

    /** Función interna para formatear una secuencia de bytes en hex con posible truncamiento */
    // Helper lambda converted to a static local function for C compatibility
    // Note: This function is not directly callable from outside cbor_print_message_1
    // and its signature is simplified as it accesses hex_buf and its size directly.
    auto format_bytes = [&](const uint8_t *bytes, size_t length, char *out_str, size_t out_size) {
        size_t out_index = 0;
        if (length > 5) {
            // Truncar: mostrar 3 bytes iniciales y 1 final, separándolos con '…'
            size_t front_count = 3;
            size_t back_count = 1;
            // Parte frontal
            for (size_t i = 0; i < front_count && i < length; i++) {
                if (out_index + 3 < out_size) {
                    out_index += sprintf(out_str + out_index, "%02X ", bytes[i]);
                }
            }
            if (out_index > 0) {
                out_index--; // eliminar el último espacio de la parte frontal
            }
            if (out_index + 1 < out_size) {
                out_str[out_index++] = '\xE2'; // UTF-8 for ellipsis
                out_str[out_index++] = '\x80';
                out_str[out_index++] = '\xA6';
            }
            // Parte final
            size_t start_back = length - back_count;
            for (size_t j = start_back; j < length; j++) {
                if (out_index + 3 < out_size) {
                    out_index += sprintf(out_str + out_index, "%02X", bytes[j]);
                    if (j < length - 1) {
                        out_index += sprintf(out_str + out_index, " ");
                    }
                }
            }
        } else {
            // Sin truncamiento: mostrar todos los bytes
            for (size_t i = 0; i < length; i++) {
                if (out_index + 3 < out_size) {
                    out_index += sprintf(out_str + out_index, "%02X", bytes[i]);
                    if (i < length - 1) {
                        out_index += sprintf(out_str + out_index, " ");
                    }
                }
            }
        }
        out_str[out_index] = '\0';
        return out_index;
    };

    // 1. METHOD (int)
    size_t field_start = index;
    if (index >= msg_len) {
        PRINTF("Error: mensaje demasiado corto para METHOD\n");
        return;
    }
    uint8_t first_byte = msg[index++];
    uint64_t method_corr_val = 0;
    if ((first_byte & 0xE0) == 0x00) {  // Entero positivo
        if (first_byte <= 0x17) {
            method_corr_val = first_byte;  // valor directo
        } else if (first_byte == 0x18) {
            if (index >= msg_len) { PRINTF("Error: METHOD valor 0x18 mal formado\n"); return; }
            method_corr_val = msg[index++];
        } else if (first_byte == 0x19) {
            if (index + 1 >= msg_len) { PRINTF("Error: METHOD valor 0x19 mal formado\n"); return; }
            method_corr_val = (msg[index] << 8) | msg[index+1];
            index += 2;
        } else if (first_byte == 0x1A) {
            if (index + 3 >= msg_len) { PRINTF("Error: METHOD valor 0x1A mal formado\n"); return; }
            method_corr_val = ((uint32_t)msg[index] << 24) | ((uint32_t)msg[index+1] << 16) |
                              ((uint32_t)msg[index+2] << 8) | msg[index+3];
            index += 4;
        } else if (first_byte == 0x1B) {
            if (index + 7 >= msg_len) { PRINTF("Error: METHOD valor 0x1B mal formado\n"); return; }
            method_corr_val = 0;
            for (int k = 0; k < 8; k++) {
                method_corr_val = (method_corr_val << 8) | msg[index + k];
            }
            index += 8;
        }
    } else if ((first_byte & 0xE0) == 0x20) {  // Entero negativo (CBOR tipo 1)
        uint64_t n = 0;
        if ((first_byte & 0x1F) <= 0x17) {
            n = first_byte & 0x1F;
        } else if ((first_byte & 0x1F) == 0x18) {
            if (index >= msg_len) { PRINTF("Error: METHOD valor neg 0x18 mal formado\n"); return; }
            n = msg[index++];
        } else if ((first_byte & 0x1F) == 0x19) {
            if (index + 1 >= msg_len) { PRINTF("Error: METHOD valor neg 0x19 mal formado\n"); return; }
            n = (msg[index] << 8) | msg[index+1];
            index += 2;
        } else if ((first_byte & 0x1F) == 0x1A) {
            if (index + 3 >= msg_len) { PRINTF("Error: METHOD valor neg 0x1A mal formado\n"); return; }
            n = ((uint32_t)msg[index] << 24) | ((uint32_t)msg[index+1] << 16) |
                ((uint32_t)msg[index+2] << 8) | msg[index+3];
            index += 4;
        } else if ((first_byte & 0x1F) == 0x1B) {
            if (index + 7 >= msg_len) { PRINTF("Error: METHOD valor neg 0x1B mal formado\n"); return; }
            n = 0;
            for (int k = 0; k < 8; k++) {
                n = (n << 8) | msg[index + k];
            }
            index += 8;
        }
        if (n <= INT64_MAX) {
            method_corr_val = (uint64_t)(-1 - (int64_t)n);
        } else {
            method_corr_val = 0; 
        }
    } else {
        PRINTF("Error: METHOD no es un tipo entero válido\n");
        return;
    }
    hex_len = format_bytes(msg + field_start, index - field_start, hex_buf, sizeof(hex_buf));
    int arrow_col = 18;
    int pad_spaces = arrow_col - (int)hex_len;
    if (pad_spaces < 1) pad_spaces = 1;
    PRINTF("%s%*s\xE2\x86\x90 METHOD = %d (int)\n", hex_buf, pad_spaces, "", (int)method_corr_val); // UTF-8 for left arrow

    uint8_t method = (uint8_t)(method_corr_val >> 2);
    uint8_t corr   = (uint8_t)(method_corr_val & 0x03);
    (void)corr;

    // 2. SUITES_I (array de int o int)
    if (index >= msg_len) {
        PRINTF("Error: mensaje truncado antes de SUITES_I\n");
        return;
    }
    field_start = index;
    uint8_t suites_first = msg[index++];
    bool suites_is_array = false;
    uint32_t suites_count = 0;
    int32_t suites_single_val = 0;
    int32_t suites_list_vals[1024];
    if ((suites_first >> 5) == 4) {
        suites_is_array = true;
        uint32_t length = suites_first & 0x1F;
        if (length == 0x18) {
            if (index >= msg_len) { PRINTF("Error: SUITES_I tamaño 0x18 mal formado\n"); return; }
            length = msg[index++];
        } else if (length == 0x19) {
            if (index + 1 >= msg_len) { PRINTF("Error: SUITES_I tamaño 0x19 mal formado\n"); return; }
            length = (msg[index] << 8) | msg[index+1];
            index += 2;
        } else if (length == 0x1A) {
            if (index + 3 >= msg_len) { PRINTF("Error: SUITES_I tamaño 0x1A mal formado\n"); return; }
            length = ((uint32_t)msg[index] << 24) | ((uint32_t)msg[index+1] << 16) |
                     ((uint32_t)msg[index+2] << 8) | msg[index+3];
            index += 4;
        } else if (length == 0x1B) {
            if (index + 7 >= msg_len) { PRINTF("Error: SUITES_I tamaño 0x1B mal formado\n"); return; }
            length = 0;
            for (int k = 0; k < 8; k++) {
                length = (length << 8) | msg[index + k];
            }
            index += 8;
        }
        suites_count = length;
        if (suites_count > 1024) suites_count = 1024;
        for (uint32_t j = 0; j < suites_count; j++) {
            if (index >= msg_len) {
                PRINTF("Error: datos incompletos en lista SUITES_I\n");
                return;
            }
            uint8_t ib = msg[index++];
            int64_t val = 0;
            if ((ib & 0xE0) == 0x00) { // int positivo
                if (ib <= 0x17) {
                    val = ib;
                } else if (ib == 0x18) {
                    if (index >= msg_len) { PRINTF("Error: SUITES_I int 0x18 mal formado\n"); return; }
                    val = msg[index++];
                } else if (ib == 0x19) {
                    if (index + 1 >= msg_len) { PRINTF("Error: SUITES_I int 0x19 mal formado\n"); return; }
                    val = (msg[index] << 8) | msg[index+1];
                    index += 2;
                } else if (ib == 0x1A) {
                    if (index + 3 >= msg_len) { PRINTF("Error: SUITES_I int 0x1A mal formado\n"); return; }
                    val = ((uint32_t)msg[index] << 24) | ((uint32_t)msg[index+1] << 16) |
                          ((uint32_t)msg[index+2] << 8) | msg[index+3];
                    index += 4;
                } else if (ib == 0x1B) {
                    if (index + 7 >= msg_len) { PRINTF("Error: SUITES_I int 0x1B mal formado\n"); return; }
                    val = 0;
                    for (int k = 0; k < 8; k++) {
                        val = (val << 8) | msg[index + k];
                    }
                    index += 8;
                }
            } else if ((ib & 0xE0) == 0x20) { // int negativo
                uint64_t n = 0;
                if ((ib & 0x1F) <= 0x17) {
                    n = ib & 0x1F;
                } else if ((ib & 0x1F) == 0x18) {
                    if (index >= msg_len) { PRINTF("Error: SUITES_I neg 0x18 mal formado\n"); return; }
                    n = msg[index++];
                } else if ((ib & 0x1F) == 0x19) {
                    if (index + 1 >= msg_len) { PRINTF("Error: SUITES_I neg 0x19 mal formado\n"); return; }
                    n = (msg[index] << 8) | msg[index+1];
                    index += 2;
                } else if ((ib & 0x1F) == 0x1A) {
                    if (index + 3 >= msg_len) { PRINTF("Error: SUITES_I neg 0x1A mal formado\n"); return; }
                    n = ((uint32_t)msg[index] << 24) | ((uint32_t)msg[index+1] << 16) |
                        ((uint32_t)msg[index+2] << 8) | msg[index+3];
                    index += 4;
                } else if ((ib & 0x1F) == 0x1B) {
                    if (index + 7 >= msg_len) { PRINTF("Error: SUITES_I neg 0x1B mal formado\n"); return; }
                    n = 0;
                    for (int k = 0; k < 8; k++) {
                        n = (n << 8) | msg[index + k];
                    }
                    index += 8;
                }
                if (n <= INT64_MAX) {
                    val = -1 - (int64_t)n;
                } else {
                    val = INT64_MIN;
                }
            } else {
                PRINTF("Error: elemento de SUITES_I no es entero\n");
                return;
            }
            if (j < 1024) {
                suites_list_vals[j] = (int32_t)val;
            }
        }
    } else {
        suites_is_array = false;
        index--; 
        uint8_t ib = msg[index++];
        int64_t val = 0;
        if ((ib & 0xE0) == 0x00) {
            if (ib <= 0x17) {
                val = ib;
            } else if (ib == 0x18) {
                if (index >= msg_len) { PRINTF("Error: SUITES_I int único 0x18 mal formado\n"); return; }
                val = msg[index++];
            } else if (ib == 0x19) {
                if (index + 1 >= msg_len) { PRINTF("Error: SUITES_I int único 0x19 mal formado\n"); return; }
                val = (msg[index] << 8) | msg[index+1];
                index += 2;
            } else if (ib == 0x1A) {
                if (index + 3 >= msg_len) { PRINTF("Error: SUITES_I int único 0x1A mal formado\n"); return; }
                val = ((uint32_t)msg[index] << 24) | ((uint32_t)msg[index+1] << 16) |
                      ((uint32_t)msg[index+2] << 8) | msg[index+3];
                index += 4;
            } else if (ib == 0x1B) {
                if (index + 7 >= msg_len) { PRINTF("Error: SUITES_I int único 0x1B mal formado\n"); return; }
                val = 0;
                for (int k = 0; k < 8; k++) {
                    val = (val << 8) | msg[index + k];
                }
                index += 8;
            }
        } else if ((ib & 0xE0) == 0x20) {
            uint64_t n = 0;
            if ((ib & 0x1F) <= 0x17) {
                n = ib & 0x1F;
            } else if ((ib & 0x1F) == 0x18) {
                if (index >= msg_len) { PRINTF("Error: SUITES_I int neg único 0x18 mal formado\n"); return; }
                n = msg[index++];
            } else if ((ib & 0x1F) == 0x19) {
                if (index + 1 >= msg_len) { PRINTF("Error: SUITES_I int neg único 0x19 mal formado\n"); return; }
                n = (msg[index] << 8) | msg[index+1];
                index += 2;
            } else if ((ib & 0x1F) == 0x1A) {
                if (index + 3 >= msg_len) { PRINTF("Error: SUITES_I int neg único 0x1A mal formado\n"); return; }
                n = ((uint32_t)msg[index] << 24) | ((uint32_t)msg[index+1] << 16) |
                    ((uint32_t)msg[index+2] << 8) | msg[index+3];
                index += 4;
            } else if ((ib & 0x1F) == 0x1B) {
                if (index + 7 >= msg_len) { PRINTF("Error: SUITES_I int neg único 0x1B mal formado\n"); return; }
                n = 0;
                for (int k = 0; k < 8; k++) {
                    n = (n << 8) | msg[index + k];
                }
                index += 8;
            }
            if (n <= INT64_MAX) {
                val = -1 - (int64_t)n;
            } else {
                val = INT64_MIN;
            }
        } else {
            PRINTF("Error: SUITES_I no es ni array ni int\n");
            return;
        }
        suites_single_val = (int32_t)val;
        suites_count = 1;
        suites_list_vals[0] = suites_single_val;
    }
    hex_len = format_bytes(msg + field_start, index - field_start, hex_buf, sizeof(hex_buf));
    char suites_desc[256]; // Increased size for safety
    if (suites_is_array) {
        size_t off = 0;
        off += sprintf(suites_desc + off, "[");
        for (uint32_t j = 0; j < suites_count && j < 1024; j++) {
            off += sprintf(suites_desc + off, "%d", suites_list_vals[j]);
            if (j < suites_count - 1) {
                off += sprintf(suites_desc + off, ", ");
            }
        }
        off += sprintf(suites_desc + off, "]");
        suites_desc[off] = '\0';
    } else {
        sprintf(suites_desc, "%d", suites_single_val);
    }
    pad_spaces = arrow_col - (int)hex_len;
    if (pad_spaces < 1) pad_spaces = 1;
    if (suites_is_array) {
        PRINTF("%s%*s\xE2\x86\x90 SUITES_I = %s (array of int)\n", hex_buf, pad_spaces, "", suites_desc);
    } else {
        PRINTF("%s%*s\xE2\x86\x90 SUITES_I = %s (int)\n", hex_buf, pad_spaces, "", suites_desc);
    }

    // 3. G_X (bstr de longitud 32 bytes típicamente)
    if (index >= msg_len) {
        PRINTF("Error: mensaje truncado antes de G_X\n");
        return;
    }
    field_start = index;
    uint8_t bstr_head = msg[index++];
    size_t bstr_len = 0;
    if ((bstr_head & 0xE0) == 0x40) {
        size_t addl = bstr_head & 0x1F;
        if (addl <= 0x17) {
            bstr_len = addl;
        } else if (addl == 0x18) {
            if (index >= msg_len) { PRINTF("Error: G_X tamaño 0x18 mal formado\n"); return; }
            bstr_len = msg[index++];
        } else if (addl == 0x19) {
            if (index + 1 >= msg_len) { PRINTF("Error: G_X tamaño 0x19 mal formado\n"); return; }
            bstr_len = (msg[index] << 8) | msg[index+1];
            index += 2;
        } else if (addl == 0x1A) {
            if (index + 3 >= msg_len) { PRINTF("Error: G_X tamaño 0x1A mal formado\n"); return; }
            bstr_len = ((uint32_t)msg[index] << 24) | ((uint32_t)msg[index+1] << 16) |
                       ((uint32_t)msg[index+2] << 8) | msg[index+3];
            index += 4;
        } else if (addl == 0x1B) {
            if (index + 7 >= msg_len) { PRINTF("Error: G_X tamaño 0x1B mal formado\n"); return; }
            bstr_len = 0;
            for (int k = 0; k < 8; k++) {
                bstr_len = (bstr_len << 8) | msg[index + k];
            }
            index += 8;
        } else {
            PRINTF("Error: G_X cadena con longitud indefinida no soportada\n");
            return;
        }
    } else {
        PRINTF("Error: G_X no es un byte string\n");
        return;
    }
    if (index + bstr_len > msg_len) {
        PRINTF("Error: G_X declarado con %zu bytes pero mensaje incompleto\n", bstr_len);
        return;
    }
    index += bstr_len;
    hex_len = format_bytes(msg + field_start, index - field_start, hex_buf, sizeof(hex_buf));
    pad_spaces = arrow_col - (int)hex_len;
    if (pad_spaces < 1) pad_spaces = 1;
    PRINTF("%s%*s\xE2\x86\x90 G_X (%zu bytes) (byte string)\n", hex_buf, pad_spaces, "", bstr_len);

    // 4. C_I (int o bstr, contexto específico)
    if (index >= msg_len) {
        PRINTF("%*s\xE2\x86\x90 C_I (context-specific interpretation)\n", arrow_col + 1, ""); 
    } else {
        field_start = index;
        uint8_t ci_first = msg[index++];
        bool ci_is_int = false;
        uint64_t ci_val = 0;
        size_t ci_bstr_len = 0;
        if ((ci_first & 0xE0) == 0x00 || (ci_first & 0xE0) == 0x20) {
            ci_is_int = true;
            index--;
            uint8_t ib = msg[index++];
            int64_t val = 0;
            if ((ib & 0xE0) == 0x00) {
                if (ib <= 0x17) {
                    val = ib;
                } else if (ib == 0x18) {
                    if (index >= msg_len) { PRINTF("Error: C_I int 0x18 mal formado\n"); return; }
                    val = msg[index++];
                } else if (ib == 0x19) {
                    if (index + 1 >= msg_len) { PRINTF("Error: C_I int 0x19 mal formado\n"); return; }
                    val = (msg[index] << 8) | msg[index+1];
                    index += 2;
                } else if (ib == 0x1A) {
                    if (index + 3 >= msg_len) { PRINTF("Error: C_I int 0x1A mal formado\n"); return; }
                    val = ((uint32_t)msg[index] << 24) | ((uint32_t)msg[index+1] << 16) |
                          ((uint32_t)msg[index+2] << 8) | msg[index+3];
                    index += 4;
                } else if (ib == 0x1B) {
                    if (index + 7 >= msg_len) { PRINTF("Error: C_I int 0x1B mal formado\n"); return; }
                    val = 0;
                    for (int k = 0; k < 8; k++) {
                        val = (val << 8) | msg[index + k];
                    }
                    index += 8;
                }
            } else if ((ib & 0xE0) == 0x20) {
                uint64_t n = 0;
                if ((ib & 0x1F) <= 0x17) {
                    n = ib & 0x1F;
                } else if ((ib & 0x1F) == 0x18) {
                    if (index >= msg_len) { PRINTF("Error: C_I neg 0x18 mal formado\n"); return; }
                    n = msg[index++];
                } else if ((ib & 0x1F) == 0x19) {
                    if (index + 1 >= msg_len) { PRINTF("Error: C_I neg 0x19 mal formado\n"); return; }
                    n = (msg[index] << 8) | msg[index+1];
                    index += 2;
                } else if ((ib & 0x1F) == 0x1A) {
                    if (index + 3 >= msg_len) { PRINTF("Error: C_I neg 0x1A mal formado\n"); return; }
                    n = ((uint32_t)msg[index] << 24) | ((uint32_t)msg[index+1] << 16) |
                        ((uint32_t)msg[index+2] << 8) | msg[index+3];
                    index += 4;
                } else if ((ib & 0x1F) == 0x1B) {
                    if (index + 7 >= msg_len) { PRINTF("Error: C_I neg 0x1B mal formado\n"); return; }
                    n = 0;
                    for (int k = 0; k < 8; k++) {
                        n = (n << 8) | msg[index + k];
                    }
                    index += 8;
                }
                if (n <= INT64_MAX) {
                    val = -1 - (int64_t)n;
                } else {
                    val = INT64_MIN;
                }
            } else {
                PRINTF("Error: C_I formato desconocido\n");
                return;
            }
            ci_val = (uint64_t)val;
        } else if ((ci_first & 0xE0) == 0x40) {
            ci_is_int = false;
            uint8_t addl = ci_first & 0x1F;
            if (addl <= 0x17) {
                ci_bstr_len = addl;
            } else if (addl == 0x18) {
                if (index >= msg_len) { PRINTF("Error: C_I bstr tamaño 0x18 mal formado\n"); return; }
                ci_bstr_len = msg[index++];
            } else if (addl == 0x19) {
                if (index + 1 >= msg_len) { PRINTF("Error: C_I bstr tamaño 0x19 mal formado\n"); return; }
                ci_bstr_len = (msg[index] << 8) | msg[index+1];
                index += 2;
            } else if (addl == 0x1A) {
                if (index + 3 >= msg_len) { PRINTF("Error: C_I bstr tamaño 0x1A mal formado\n"); return; }
                ci_bstr_len = ((uint32_t)msg[index] << 24) | ((uint32_t)msg[index+1] << 16) |
                              ((uint32_t)msg[index+2] << 8) | msg[index+3];
                index += 4;
            } else if (addl == 0x1B) {
                if (index + 7 >= msg_len) { PRINTF("Error: C_I bstr tamaño 0x1B mal formado\n"); return; }
                ci_bstr_len = 0;
                for (int k = 0; k < 8; k++) {
                    ci_bstr_len = (ci_bstr_len << 8) | msg[index + k];
                }
                index += 8;
            } else {
                PRINTF("Error: C_I cadena con longitud indefinida no soportada\n");
                return;
            }
            if (index + ci_bstr_len > msg_len) {
                PRINTF("Error: C_I bstr longitud declarada excede mensaje\n");
                return;
            }
            index += ci_bstr_len;
        } else {
            PRINTF("Error: C_I no es int ni bstr\n");
            return;
        }
        hex_len = format_bytes(msg + field_start, index - field_start, hex_buf, sizeof(hex_buf));
        pad_spaces = arrow_col - (int)hex_len;
        if (pad_spaces < 1) pad_spaces = 1;
        if (ci_is_int) {
            PRINTF("%s%*s\xE2\x86\x90 C_I (context-specific interpretation)\n", hex_buf, pad_spaces, "");
        } else {
            PRINTF("%s%*s\xE2\x86\x90 C_I (context-specific interpretation)\n", hex_buf, pad_spaces, "");
        }
    }

    // 5. ID_CRED_PSK (opcional, bstr)
    if (method == 3) {
        if (index < msg_len) {
            field_start = index;
            uint8_t idcred_first = msg[index++];
            size_t idcred_len = 0;
            if ((idcred_first & 0xE0) == 0x40) {
                uint8_t addl = idcred_first & 0x1F;
                if (addl <= 0x17) {
                    idcred_len = addl;
                } else if (addl == 0x18) {
                    if (index >= msg_len) { PRINTF("Error: ID_CRED_PSK 0x18 mal formado\n"); return; }
                    idcred_len = msg[index++];
                } else if (addl == 0x19) {
                    if (index + 1 >= msg_len) { PRINTF("Error: ID_CRED_PSK 0x19 mal formado\n"); return; }
                    idcred_len = (msg[index] << 8) | msg[index+1];
                    index += 2;
                } else if (addl == 0x1A) {
                    if (index + 3 >= msg_len) { PRINTF("Error: ID_CRED_PSK 0x1A mal formado\n"); return; }
                    idcred_len = ((uint32_t)msg[index] << 24) | ((uint32_t)msg[index+1] << 16) |
                                 ((uint32_t)msg[index+2] << 8) | msg[index+3];
                    index += 4;
                } else if (addl == 0x1B) {
                    if (index + 7 >= msg_len) { PRINTF("Error: ID_CRED_PSK 0x1B mal formado\n"); return; }
                    idcred_len = 0;
                    for (int k = 0; k < 8; k++) {
                        idcred_len = (idcred_len << 8) | msg[index + k];
                    }
                    index += 8;
                } else {
                    PRINTF("Error: ID_CRED_PSK longitud indefinida no soportada\n");
                    return;
                }
            } else {
                PRINTF("Error: ID_CRED_PSK no es bstr\n");
                return;
            }
            if (index + idcred_len > msg_len) {
                PRINTF("Error: ID_CRED_PSK longitud declarada excede mensaje\n");
                return;
            }
            index += idcred_len;
            hex_len = format_bytes(msg + field_start, index - field_start, hex_buf, sizeof(hex_buf));
            pad_spaces = arrow_col - (int)hex_len;
            if (pad_spaces < 1) pad_spaces = 1;
            PRINTF("%s%*s\xE2\x86\x90 ID_CRED_PSK (%zu bytes) (byte string)\n", hex_buf, pad_spaces, "", idcred_len);
        }
    } else {
        ; 
    }

    // 6. EAD_1 (opcional, bstr)
    if (index < msg_len) {
        field_start = index;
        uint8_t ead_first = msg[index++];
        size_t ead_len = 0;
        if ((ead_first & 0xE0) == 0x40) {
            uint8_t addl = ead_first & 0x1F;
            if (addl <= 0x17) {
                ead_len = addl;
            } else if (addl == 0x18) {
                if (index >= msg_len) { PRINTF("Error: EAD_1 0x18 mal formado\n"); return; }
                ead_len = msg[index++];
            } else if (addl == 0x19) {
                if (index + 1 >= msg_len) { PRINTF("Error: EAD_1 0x19 mal formado\n"); return; }
                ead_len = (msg[index] << 8) | msg[index+1];
                index += 2;
            } else if (addl == 0x1A) {
                if (index + 3 >= msg_len) { PRINTF("Error: EAD_1 0x1A mal formado\n"); return; }
                ead_len = ((uint32_t)msg[index] << 24) | ((uint32_t)msg[index+1] << 16) |
                          ((uint32_t)msg[index+2] << 8) | msg[index+3];
                index += 4;
            } else if (addl == 0x1B) {
                if (index + 7 >= msg_len) { PRINTF("Error: EAD_1 0x1B mal formado\n"); return; }
                ead_len = 0;
                for (int k = 0; k < 8; k++) {
                    ead_len = (ead_len << 8) | msg[index + k];
                }
                index += 8;
            } else {
                PRINTF("Error: EAD_1 longitud indefinida no soportada\n");
                return;
            }
        } else {
            PRINTF("Error: EAD_1 no es un byte string\n");
            return;
        }
        if (index + ead_len > msg_len) {
            PRINTF("Error: EAD_1 longitud declarada excede mensaje\n");
            return;
        }
        index += ead_len;
        hex_len = format_bytes(msg + field_start, index - field_start, hex_buf, sizeof(hex_buf));
        pad_spaces = arrow_col - (int)hex_len;
        if (pad_spaces < 1) pad_spaces = 1;
        PRINTF("%s%*s\xE2\x86\x90 EAD_1 (%zu bytes) (byte string)\n", hex_buf, pad_spaces, "", ead_len);
    }
}
