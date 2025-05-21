/*
   Copyright (c) 2021 Fraunhofer AISEC. See the COPYRIGHT
   file at the top-level directory of this distribution.

   Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
   http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
   <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
   option. This file may not be copied, modified, or distributed
   except according to those terms.
*/

#include <arpa/inet.h>
#include <errno.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

#include <time.h> // Ensure time.h is included
#include <stdio.h> // Ensure stdio.h is included
#include <stdbool.h> // For bool type

extern "C" {
#include "edhoc.h"
#include "sock.h"
#include "edhoc_test_vectors_p256_v16.h"
#include "edhoc_test_vectors_rfc9529.h"
}
#include "cantcoap.h"

#define USE_IPV4
//#define USE_IPV6

CoapPDU *txPDU = new CoapPDU();

char buffer[MAXLINE];
CoapPDU *rxPDU;

/*comment this out to use DH keys from the test vectors*/
#define USE_RANDOM_EPHEMERAL_DH_KEY

#ifdef USE_IPV6
struct sockaddr_in6 client_addr;
#endif
#ifdef USE_IPV4
struct sockaddr_in client_addr;
#endif
socklen_t client_addr_len;

// Static variables for precise total time measurement
static bool first_message_received = false;
static clock_t actual_start_time;

/**
 * @brief	Initializes socket for CoAP server.
 * @param	
 * @retval	error code
 */
static int start_coap_server(int *sockfd)
{
	int err;
#ifdef USE_IPV4
	struct sockaddr_in servaddr;
	client_addr_len = sizeof(client_addr);
	memset(&client_addr, 0, sizeof(client_addr));
	const char IPV4_SERVADDR[] = { "192.168.56.102" };
	err = sock_init(SOCK_SERVER, IPV4_SERVADDR, IPv4, &servaddr,
			sizeof(servaddr), sockfd);
	if (err < 0) {
		printf("error during socket initialization (error code: %d)",
		       err);
		return -1;
	}
#endif
#ifdef USE_IPV6
	struct sockaddr_in6 servaddr;
	client_addr_len = sizeof(client_addr);
	memset(&client_addr, 0, sizeof(client_addr));
	const char IPV6_SERVADDR[] = { "2001:db8::2" };
	err = sock_init(SOCK_SERVER, IPV6_SERVADDR, IPv6, &servaddr,
			sizeof(servaddr), sockfd);
	if (err < 0) {
		printf("error during socket initialization (error code: %d)",
		       err);
		return -1;
	}
#endif

	return 0;
}
/**
 * @brief	Sends CoAP packet over network.
 * @param	pdu pointer to CoAP packet
 * @retval	error code
 */
static int send_coap_reply(void *sock, CoapPDU *pdu)
{
	int r;

	r = sendto(*((int *)sock), pdu->getPDUPointer(), pdu->getPDULength(), 0,
		   (struct sockaddr *)&client_addr, client_addr_len);
	if (r < 0) {
		printf("Error: failed to send reply (Code: %d, ErrNo: %d)\n", r,
		       errno);
		return r;
	}

	//printf("CoAP reply sent!\n");
	return 0;
}

enum err ead_process(void *params, struct byte_array *ead13)
{
	/*for this sample we are not using EAD*/
	/*to save RAM we use FEATURES += -DEAD_SIZE=0*/
	return ok;
}

enum err tx(void *sock, struct byte_array *data)
{
	txPDU->setCode(CoapPDU::COAP_CHANGED);
	txPDU->setPayload(data->ptr, data->len);
	send_coap_reply(sock, txPDU);
	return ok;
}

enum err rx(void *sock, struct byte_array *data)
{
	int n;

	/* receive */
	client_addr_len = sizeof(client_addr);
	memset(&client_addr, 0, sizeof(client_addr));

	n = recvfrom(*((int *)sock), (char *)buffer, sizeof(buffer), 0,
		     (struct sockaddr *)&client_addr, &client_addr_len);
	if (n < 0) {
		printf("recv error");
		return unexpected_result_from_ext_lib; // Return an error if recvfrom fails
	}

	// Record start time only after receiving the *first* message of the exchange
	if (!first_message_received) {
		actual_start_time = clock();
		first_message_received = true;
	}

	rxPDU = new CoapPDU((uint8_t *)buffer, n);

	if (rxPDU->validate()) {
		//rxPDU->printHuman();
	}

	//PRINT_ARRAY("CoAP message", rxPDU->getPayloadPointer(),
	//	    rxPDU->getPayloadLength());

	uint32_t payload_len = rxPDU->getPayloadLength();
	if (data->len >= payload_len) {
		memcpy(data->ptr, rxPDU->getPayloadPointer(), payload_len);
		data->len = payload_len;
	} else {
		printf("insufficient space in buffer");
	}

	txPDU->reset();
	txPDU->setVersion(rxPDU->getVersion());
	txPDU->setMessageID(rxPDU->getMessageID());
	txPDU->setToken(rxPDU->getTokenPointer(), rxPDU->getTokenLength());

	if (rxPDU->getType() == CoapPDU::COAP_CONFIRMABLE) {
		txPDU->setType(CoapPDU::COAP_ACKNOWLEDGEMENT);
	} else {
		txPDU->setType(CoapPDU::COAP_NON_CONFIRMABLE);
	}

	delete rxPDU;
	return ok;
}

int main()
{
	int sockfd;
	BYTE_ARRAY_NEW(prk_exporter, 32, 32);
	BYTE_ARRAY_NEW(oscore_master_secret, 16, 16);
	BYTE_ARRAY_NEW(oscore_master_salt, 8, 8);
	BYTE_ARRAY_NEW(PRK_out, 32, 32);
	BYTE_ARRAY_NEW(err_msg, 0, 0);

	/* test vector inputs */
	struct other_party_cred cred_i;
	struct edhoc_responder_context c_r;

	TRY_EXPECT(start_coap_server(&sockfd), 0);

#define ORIG
#ifdef ORIG

	uint8_t TEST_VEC_NUM = 1;
	uint8_t vec_num_i = TEST_VEC_NUM - 1;
	
	c_r.sock = &sockfd;
	c_r.c_r.ptr = (uint8_t *)test_vectors[vec_num_i].c_r;
	c_r.c_r.len = test_vectors[vec_num_i].c_r_len;
	c_r.suites_r.len = test_vectors[vec_num_i].SUITES_R_len;
	c_r.suites_r.ptr = (uint8_t *)test_vectors[vec_num_i].SUITES_R;
	c_r.ead_2.len = test_vectors[vec_num_i].ead_2_len;
	c_r.ead_2.ptr = (uint8_t *)test_vectors[vec_num_i].ead_2;
	c_r.ead_4.len = test_vectors[vec_num_i].ead_4_len;
	c_r.ead_4.ptr = (uint8_t *)test_vectors[vec_num_i].ead_4;

	c_r.id_cred_psk.len = test_vectors[vec_num_i].id_cred_psk_len;
	c_r.id_cred_psk.ptr = (uint8_t *)test_vectors[vec_num_i].id_cred_psk;
	
	c_r.cred_psk.len = test_vectors[vec_num_i].cred_psk_len;
	c_r.cred_psk.ptr = (uint8_t *)test_vectors[vec_num_i].cred_psk;
	
	PRINT_ARRAY("\033[1mPSK Credentials\033[0m", c_r.cred_psk.ptr, c_r.cred_psk.len);

	c_r.id_cred_r.len = test_vectors[vec_num_i].id_cred_r_len;
	c_r.id_cred_r.ptr = (uint8_t *)test_vectors[vec_num_i].id_cred_r;
	c_r.cred_r.len = test_vectors[vec_num_i].cred_r_len;
	c_r.cred_r.ptr = (uint8_t *)test_vectors[vec_num_i].cred_r;
	c_r.g_y.len = test_vectors[vec_num_i].g_y_raw_len;
	c_r.g_y.ptr = (uint8_t *)test_vectors[vec_num_i].g_y_raw;
	c_r.y.len = test_vectors[vec_num_i].y_raw_len;
	c_r.y.ptr = (uint8_t *)test_vectors[vec_num_i].y_raw;
	c_r.g_r.len = test_vectors[vec_num_i].g_r_raw_len;
	c_r.g_r.ptr = (uint8_t *)test_vectors[vec_num_i].g_r_raw;
	c_r.r.len = test_vectors[vec_num_i].r_raw_len;
	c_r.r.ptr = (uint8_t *)test_vectors[vec_num_i].r_raw;
	c_r.sk_r.len = test_vectors[vec_num_i].sk_r_raw_len;
	c_r.sk_r.ptr = (uint8_t *)test_vectors[vec_num_i].sk_r_raw;
	c_r.pk_r.len = test_vectors[vec_num_i].pk_r_raw_len;
	c_r.pk_r.ptr = (uint8_t *)test_vectors[vec_num_i].pk_r_raw;

	cred_i.id_cred.len = test_vectors[vec_num_i].id_cred_i_len;
	cred_i.id_cred.ptr = (uint8_t *)test_vectors[vec_num_i].id_cred_i;
	cred_i.cred.len = test_vectors[vec_num_i].cred_i_len;
	cred_i.cred.ptr = (uint8_t *)test_vectors[vec_num_i].cred_i;
	cred_i.g.len = test_vectors[vec_num_i].g_i_raw_len;
	cred_i.g.ptr = (uint8_t *)test_vectors[vec_num_i].g_i_raw;
	cred_i.pk.len = test_vectors[vec_num_i].pk_i_raw_len;
	cred_i.pk.ptr = (uint8_t *)test_vectors[vec_num_i].pk_i_raw;
	cred_i.ca.len = test_vectors[vec_num_i].ca_i_len;
	cred_i.ca.ptr = (uint8_t *)test_vectors[vec_num_i].ca_i;
	cred_i.ca_pk.len = test_vectors[vec_num_i].ca_i_pk_len;
	cred_i.ca_pk.ptr = (uint8_t *)test_vectors[vec_num_i].ca_i_pk;
#endif

#ifdef T1_RFC9529
	c_r.sock = &sockfd;
	c_r.c_r.len = T1_RFC9529__C_R_LEN;
	c_r.c_r.ptr = (uint8_t *)T1_RFC9529__C_R;
	c_r.suites_r.len = T1_RFC9529__SUITES_R_LEN;
	c_r.suites_r.ptr = (uint8_t *)T1_RFC9529__SUITES_R;
	c_r.ead_2.len = 0;
	c_r.ead_2.ptr = NULL;
	c_r.ead_4.len = 0;
	c_r.ead_4.ptr = NULL;
	c_r.id_cred_r.len = T1_RFC9529__ID_CRED_R_LEN;
	c_r.id_cred_r.ptr = (uint8_t *)T1_RFC9529__ID_CRED_R;
	c_r.cred_r.len = T1_RFC9529__CRED_R_LEN;
	c_r.cred_r.ptr = (uint8_t *)T1_RFC9529__CRED_R;
	c_r.g_y.len = T1_RFC9529__G_Y_LEN;
	c_r.g_y.ptr = (uint8_t *)T1_RFC9529__G_Y;
	c_r.y.len = T1_RFC9529__Y_LEN;
	c_r.y.ptr = (uint8_t *)T1_RFC9529__Y;
	c_r.g_r.len = 0;
	c_r.g_r.ptr = NULL;
	c_r.r.len = 0;
	c_r.r.ptr = NULL;
	c_r.sk_r.len = T1_RFC9529__SK_R_LEN;
	c_r.sk_r.ptr = (uint8_t *)T1_RFC9529__SK_R;
	c_r.pk_r.len = T1_RFC9529__PK_R_LEN;
	c_r.pk_r.ptr = (uint8_t *)T1_RFC9529__PK_R;

	cred_i.id_cred.len = T1_RFC9529__ID_CRED_I_LEN;
	cred_i.id_cred.ptr = (uint8_t *)T1_RFC9529__ID_CRED_I;
	cred_i.cred.len = T1_RFC9529__CRED_I_LEN;
	cred_i.cred.ptr = (uint8_t *)T1_RFC9529__CRED_I;
	cred_i.g.len = 0;
	cred_i.g.ptr = NULL;
	cred_i.pk.len = T1_RFC9529__PK_I_LEN;
	cred_i.pk.ptr = (uint8_t *)T1_RFC9529__PK_I;
	cred_i.ca.len = 0;
	cred_i.ca.ptr = NULL;
	cred_i.ca_pk.len = 0;
	cred_i.ca_pk.ptr = NULL;
#endif

	struct cred_array cred_i_array = { .len = 1, .ptr = &cred_i };

#ifdef USE_RANDOM_EPHEMERAL_DH_KEY
	uint32_t seed;
	BYTE_ARRAY_NEW(Y_random, 32, 32);
	BYTE_ARRAY_NEW(G_Y_random, 32, 32);
	c_r.g_y.ptr = G_Y_random.ptr;
	c_r.g_y.len = G_Y_random.len;
	c_r.y.ptr = Y_random.ptr;
	c_r.y.len = Y_random.len;
#endif

	while (1) {
		clock_t total_end; // End time variable
		double total_elapsed_ms;

#ifdef USE_RANDOM_EPHEMERAL_DH_KEY
		/*create ephemeral DH keys from seed*/
		/*create a random seed*/
		FILE *fp;
		fp = fopen("/dev/urandom", "r");
		uint64_t seed_len =
			fread((uint8_t *)&seed, 1, sizeof(seed), fp);
		fclose(fp);

		PRINT_MSG("\033[1mPreparing new EDHOC exchange...\033[0m\n\n");

		PRINT_ARRAY("\033[1mSeed\033[0m", (uint8_t *)&seed, seed_len);

		TRY(ephemeral_dh_key_gen(P256, seed, &Y_random, &G_Y_random));
		PRINT_ARRAY("\033[1mSecret ephemeral DH key (y)\033[0m", c_r.g_y.ptr,
			    c_r.g_y.len);
		PRINT_ARRAY("\033[1mPublic ephemeral DH key (G_Y)\033[0m", c_r.y.ptr, c_r.y.len);

		PRINT_MSG("\n-------------------------------------------\n\n");
#endif

#ifdef TINYCRYPT
		/* Register RNG function */
		uECC_set_rng(default_CSPRNG);
#endif

		// Reset the flag for the new exchange
		first_message_received = false;

		TRY(edhoc_responder_run(&c_r, &cred_i_array, &err_msg, &PRK_out,
					tx, rx, ead_process));

		PRINT_MSG("\033[1mDeriving PRK_exporter: HKDF-Extract( PRK_out, label=exporter )...\033[0m\n");
		TRY(prk_out2exporter(SHA_256, &PRK_out, &prk_exporter));
		PRINT_MSG("\033[1mObtained PRK_exporter. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mPRK_exporter\033[0m", prk_exporter.ptr, prk_exporter.len);
		PRINT_MSG("\n-------------------------------------------\n\n");
		PRINT_MSG("\033[1mDeriving OSCORE Master Secret: HKDF-Expand( PRK_exporter, label=OSCORE Master Secret )...\033[0m\n");
		TRY(edhoc_exporter(SHA_256, OSCORE_MASTER_SECRET, &prk_exporter,
				   &oscore_master_secret));
		PRINT_MSG("\033[1mFinished key derivation. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mOSCORE Master Secret\033[0m", oscore_master_secret.ptr,
			    oscore_master_secret.len);
		PRINT_MSG("\n-------------------------------------------\n\n");
		PRINT_MSG("\033[1mDeriving OSCORE Master Salt: HKDF-Expand( PRK_exporter, label=OSCORE Master Salt )...\033[0m\n");
		TRY(edhoc_exporter(SHA_256, OSCORE_MASTER_SALT, &prk_exporter,
				   &oscore_master_salt));
		PRINT_MSG("\033[1mFinished key derivation. Result:\033[0m\n");
		PRINT_ARRAY("\033[1mOSCORE Master Salt\033[0m", oscore_master_salt.ptr,
			    oscore_master_salt.len);
		PRINT_MSG("\n-------------------------------------------\n\n");

		total_end = clock(); // End total timer for this exchange
		// Calculate total time using the actual start time recorded in rx
		if (first_message_received) { // Ensure rx was actually called at least once
			total_elapsed_ms = (double)(total_end - actual_start_time) * 1000.0 / CLOCKS_PER_SEC;
			printf("[EDHOC Responder] Total exchange time (from msg1 reception): \033[32m%.3f ms\033[0m\n", total_elapsed_ms); // Print total time for this exchange
		} else {
			printf("[EDHOC Responder] Error: First message not received, cannot calculate total time.\n");
		}

		PRINT_MSG("\n-------------------------------------------\n\n");
	}

	close(sockfd);
	return 0;
}
