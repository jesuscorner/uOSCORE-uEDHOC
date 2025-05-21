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
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

#include <time.h> // Ensure time.h is included
#include <stdio.h> // Ensure stdio.h is included
#include <math.h> // For fabs function

extern "C" {
#include "edhoc.h"
#include "sock.h"
#include "edhoc_test_vectors_p256_v16.h"
#include "edhoc_test_vectors_rfc9529.h"
}
#include "cantcoap.h"

// Structure to hold EDHOC exchange metrics
struct edhoc_metrics {
    int m1_size;
    int m2_size;
    int m3_size;
    int m4_size;
    double m1_gen_time;
    double m2_gen_time;
    double m3_gen_time;
    double m4_gen_time;
    double total_time;
    int method; // EDHOC method (0-4)
};

// Global metrics structure
struct edhoc_metrics metrics = {0, 0, 0, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0};

// Timing variables for message generation and total exchange
clock_t msg1_start = 0, msg2_start = 0, msg3_start = 0, msg4_start = 0;
clock_t total_start = 0, total_end = 0;
double total_elapsed_ms = 0.0;

#define USE_IPV4
//#define USE_IPV6
/*comment this out to use DH keys from the test vectors*/
#define USE_RANDOM_EPHEMERAL_DH_KEY

/**
 * @brief	Initializes sockets for CoAP client.
 * @param
 * @retval	error code
 */
static int start_coap_client(int *sockfd)
{
	int err;
#ifdef USE_IPV4
	struct sockaddr_in servaddr;
	const char IPV4_SERVADDR[] = "192.168.56.102";
	err = sock_init(SOCK_CLIENT, IPV4_SERVADDR, IPv4, &servaddr,
			sizeof(servaddr), sockfd);
	if (err < 0) {
		printf("error during socket initialization (error code: %d)",
		       err);
		return -1;
	}
#endif
#ifdef USE_IPV6
	struct sockaddr_in6 servaddr;
	const char IPV6_SERVADDR[] = { "2001:db8::1" };
	err = sock_init(SOCK_CLIENT, IPV6_SERVADDR, IPv6, &servaddr,
			sizeof(servaddr), sockfd);
	if (err < 0) {
		printf("error during socket initialization (error code: %d)",
		       err);
		return -1;
	}
#endif
	return 0;
}

enum err ead_process(void *params, struct byte_array *ead13)
{
	/*for this sample we are not using EAD*/
	/*to save RAM we use FEATURES += -DEAD_SIZE=0*/
	return ok;
}

/**
 * @brief	Callback function called inside the frontend when data needs to 
 * 		be send over the network. We use here CoAP as transport 
 * @param	data pointer to the data that needs to be send
 */
enum err tx(void *sock, struct byte_array *data)
{
	/*construct a CoAP packet*/
	static uint16_t mid = 0;
	static uint32_t token = 0;
	CoapPDU *pdu = new CoapPDU();
	pdu->reset();
	pdu->setVersion(1);
	pdu->setType(CoapPDU::COAP_CONFIRMABLE);
	pdu->setCode(CoapPDU::COAP_POST);
	pdu->setToken((uint8_t *)&(++token), sizeof(token));
	pdu->setMessageID(mid++);
	pdu->setURI((char *)".well-known/edhoc", 17);
	pdu->setPayload(data->ptr, data->len);

	// Record message sizes for metrics and calculate generation time
	if (metrics.m1_size == 0) {
		metrics.m1_size = data->len; // First message is M1
		// Calculate time between start and now
		clock_t end_time = clock();
		metrics.m1_gen_time = (double)(end_time - msg1_start) * 1000.0 / CLOCKS_PER_SEC;
	} else if (metrics.m3_size == 0) {
		metrics.m3_size = data->len; // Second message is M3
		// Calculate time between start and now
		clock_t end_time = clock();
		metrics.m3_gen_time = (double)(end_time - msg3_start) * 1000.0 / CLOCKS_PER_SEC;
	}

	const void *data_ptr = pdu->getPDUPointer();
	size_t len = pdu->getPDULength();

	send(*((int *)sock), data_ptr, len, 0);

	delete pdu;
	return ok;
}

/**
 * @brief	Callback function called inside the frontend when data needs to 
 * 		be received over the network. We use here CoAP as transport 
 * @param	data pointer to the data that needs to be received
 */
enum err rx(void *sock, struct byte_array *data)
{
	int n;
	char buffer[MAXLINE];
	CoapPDU *recvPDU;
	/* receive */
	clock_t rx_start = clock(); // Record start time of reception
	
	n = recv(*((int *)sock), (char *)buffer, MAXLINE, MSG_WAITALL);
	if (n < 0) {
		printf("recv error");
	}
	
	// Calculate reception time
	clock_t rx_end = clock();
	double rx_time = (double)(rx_end - rx_start) * 1000.0 / CLOCKS_PER_SEC;

	recvPDU = new CoapPDU((uint8_t *)buffer, n);

	if (recvPDU->validate()) {
		//recvPDU->printHuman();
	}

	uint32_t payload_len = recvPDU->getPayloadLength();
	//printf("data_len: %d\n", data->len);
	//printf("payload_len: %d\n", payload_len);

	if (data->len >= payload_len) {
		memcpy(data->ptr, recvPDU->getPayloadPointer(), payload_len);
		data->len = payload_len;
		
		// Record message sizes for metrics
		if (metrics.m2_size == 0) {
			metrics.m2_size = payload_len; // First received message is M2
			// Record actual reception time for M2
			metrics.m2_gen_time = rx_time;
			// Start timing for M3 generation
			msg3_start = clock();
		} else if (metrics.m4_size == 0) {
			metrics.m4_size = payload_len; // Second received message is M4 (if implemented)
			// Record actual reception time for M4
			metrics.m4_gen_time = rx_time;
		}
	} else {
		printf("insufficient space in buffer");
		return buffer_to_small;
	}

	delete recvPDU;
	return ok;
}

int main()
{
	// Reset metrics for new run
	metrics = {0, 0, 0, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0};

	clock_t total_start, total_end; // Variables for total time
	double total_elapsed_ms;

	PRINT_MSG("\n---------------------------------------------\n");
	PRINT_MSG("\n\033[1mStarting EDHOC Initiator...\033[0m\n\n");
	
	int sockfd;
	BYTE_ARRAY_NEW(prk_exporter, 32, 32);
	BYTE_ARRAY_NEW(oscore_master_secret, 16, 16);
	BYTE_ARRAY_NEW(oscore_master_salt, 8, 8);
	BYTE_ARRAY_NEW(PRK_out, 32, 32);
	BYTE_ARRAY_NEW(err_msg, 0, 0);

	/* test vector inputs */
	struct other_party_cred cred_r;
	struct edhoc_initiator_context c_i;

#define ORIG
#ifdef ORIG

	uint8_t TEST_VEC_NUM = 1;
	uint8_t vec_num_i = TEST_VEC_NUM - 1;

	c_i.sock = &sockfd;
	c_i.c_i.len = test_vectors[vec_num_i].c_i_len;
	c_i.c_i.ptr = (uint8_t *)test_vectors[vec_num_i].c_i;
	c_i.method = (enum method_type) * test_vectors[vec_num_i].method;
	
	// Store method in metrics 
	metrics.method = * test_vectors[vec_num_i].method;
	
	c_i.suites_i.len = test_vectors[vec_num_i].SUITES_I_len;
	c_i.suites_i.ptr = (uint8_t *)test_vectors[vec_num_i].SUITES_I;
	c_i.ead_1.len = test_vectors[vec_num_i].ead_1_len;
	c_i.ead_1.ptr = (uint8_t *)test_vectors[vec_num_i].ead_1;
	c_i.ead_3.len = test_vectors[vec_num_i].ead_3_len;
	c_i.ead_3.ptr = (uint8_t *)test_vectors[vec_num_i].ead_3;
	c_i.id_cred_i.len = test_vectors[vec_num_i].id_cred_i_len;
	c_i.id_cred_i.ptr = (uint8_t *)test_vectors[vec_num_i].id_cred_i;

	c_i.id_cred_psk.len = test_vectors[vec_num_i].id_cred_psk_len;
	c_i.id_cred_psk.ptr = (uint8_t *)test_vectors[vec_num_i].id_cred_psk;

	c_i.cred_psk.len = test_vectors[vec_num_i].cred_psk_len;
	c_i.cred_psk.ptr = (uint8_t *)test_vectors[vec_num_i].cred_psk;
	
	PRINT_ARRAY("\033[1mPSK Credentials\033[0m",c_i.cred_psk.ptr, c_i.cred_psk.len);

	c_i.cred_i.len = test_vectors[vec_num_i].cred_i_len;
	c_i.cred_i.ptr = (uint8_t *)test_vectors[vec_num_i].cred_i;
	c_i.g_x.len = test_vectors[vec_num_i].g_x_raw_len;
	c_i.g_x.ptr = (uint8_t *)test_vectors[vec_num_i].g_x_raw;
	c_i.x.len = test_vectors[vec_num_i].x_raw_len;
	c_i.x.ptr = (uint8_t *)test_vectors[vec_num_i].x_raw;
	c_i.g_i.len = test_vectors[vec_num_i].g_i_raw_len;
	c_i.g_i.ptr = (uint8_t *)test_vectors[vec_num_i].g_i_raw;
	c_i.i.len = test_vectors[vec_num_i].i_raw_len;
	c_i.i.ptr = (uint8_t *)test_vectors[vec_num_i].i_raw;
	c_i.sk_i.len = test_vectors[vec_num_i].sk_i_raw_len;
	c_i.sk_i.ptr = (uint8_t *)test_vectors[vec_num_i].sk_i_raw;
	c_i.pk_i.len = test_vectors[vec_num_i].pk_i_raw_len;
	c_i.pk_i.ptr = (uint8_t *)test_vectors[vec_num_i].pk_i_raw;

	/*JTODO: CRED_PSK*/

	cred_r.id_cred_psk.len = test_vectors[vec_num_i].id_cred_psk_len;
	cred_r.id_cred_psk.ptr = (uint8_t *)test_vectors[vec_num_i].id_cred_psk;

	cred_r.cred_psk.len = test_vectors[vec_num_i].cred_psk_len;
	cred_r.cred_psk.ptr = (uint8_t *)test_vectors[vec_num_i].cred_psk;

	cred_r.id_cred.len = test_vectors[vec_num_i].id_cred_r_len;
	cred_r.id_cred.ptr = (uint8_t *)test_vectors[vec_num_i].id_cred_r;
	cred_r.cred.len = test_vectors[vec_num_i].cred_r_len;
	cred_r.cred.ptr = (uint8_t *)test_vectors[vec_num_i].cred_r;
	cred_r.g.len = test_vectors[vec_num_i].g_r_raw_len;
	cred_r.g.ptr = (uint8_t *)test_vectors[vec_num_i].g_r_raw;
	cred_r.pk.len = test_vectors[vec_num_i].pk_r_raw_len;
	cred_r.pk.ptr = (uint8_t *)test_vectors[vec_num_i].pk_r_raw;
	cred_r.ca.len = test_vectors[vec_num_i].ca_r_len;
	cred_r.ca.ptr = (uint8_t *)test_vectors[vec_num_i].ca_r;
	cred_r.ca_pk.len = test_vectors[vec_num_i].ca_r_pk_len;
	cred_r.ca_pk.ptr = (uint8_t *)test_vectors[vec_num_i].ca_r_pk;
#endif

#ifdef T1_RFC9529
	c_i.sock = &sockfd;
	c_i.c_i.len = T1_RFC9529__C_I_LEN;
	c_i.c_i.ptr = (uint8_t *)T1_RFC9529__C_I;
	c_i.method = (enum method_type)T1_RFC9529__METHOD;
	c_i.suites_i.len = T1_RFC9529__SUITES_I_LEN;
	c_i.suites_i.ptr = (uint8_t *)T1_RFC9529__SUITES_I;
	c_i.ead_1.len = 0;
	c_i.ead_1.ptr = NULL;
	c_i.ead_3.len = 0;
	c_i.ead_3.ptr = NULL;
	c_i.id_cred_i.len = T1_RFC9529__ID_CRED_I_LEN;
	c_i.id_cred_i.ptr = (uint8_t *)T1_RFC9529__ID_CRED_I;
	c_i.cred_i.len = T1_RFC9529__CRED_I_LEN;
	c_i.cred_i.ptr = (uint8_t *)T1_RFC9529__CRED_I;
	c_i.g_x.len = T1_RFC9529__G_X_LEN;
	c_i.g_x.ptr = (uint8_t *)T1_RFC9529__G_X;
	c_i.x.len = T1_RFC9529__X_LEN;
	c_i.x.ptr = (uint8_t *)T1_RFC9529__X;
	c_i.g_i.len = 0;
	c_i.g_i.ptr = NULL;
	c_i.i.len = 0;
	c_i.i.ptr = NULL;
	c_i.sk_i.len = T1_RFC9529__SK_I_LEN;
	c_i.sk_i.ptr = (uint8_t *)T1_RFC9529__SK_I;
	c_i.pk_i.len = T1_RFC9529__PK_I_LEN;
	c_i.pk_i.ptr = (uint8_t *)T1_RFC9529__PK_I;
	cred_r.id_cred.len = T1_RFC9529__ID_CRED_R_LEN;
	cred_r.id_cred.ptr = (uint8_t *)T1_RFC9529__ID_CRED_R;
	cred_r.cred.len = T1_RFC9529__CRED_R_LEN;
	cred_r.cred.ptr = (uint8_t *)T1_RFC9529__CRED_R;
	cred_r.g.len = 0;
	cred_r.g.ptr = NULL;
	cred_r.pk.len = T1_RFC9529__PK_R_LEN;
	cred_r.pk.ptr = (uint8_t *)T1_RFC9529__PK_R;
	cred_r.ca.len = 0;
	cred_r.ca.ptr = NULL;
	cred_r.ca_pk.len = 0;
	cred_r.ca_pk.ptr = NULL;

#endif

	struct cred_array cred_r_array = { .len = 1, .ptr = &cred_r };

#ifdef USE_RANDOM_EPHEMERAL_DH_KEY
	uint32_t seed;
	BYTE_ARRAY_NEW(X_random, 32, 32);
	BYTE_ARRAY_NEW(G_X_random, 32, 32);

	/*create a random seed*/
	FILE *fp;
	fp = fopen("/dev/urandom", "r");
	uint64_t seed_len = fread((uint8_t *)&seed, 1, sizeof(seed), fp);
	fclose(fp);
	PRINT_ARRAY("\033[1mSeed\033[0m", (uint8_t *)&seed, seed_len);

	/*create ephemeral DH keys from seed*/
	TRY(ephemeral_dh_key_gen(P256, seed, &X_random, &G_X_random));
	c_i.g_x.ptr = G_X_random.ptr;
	c_i.g_x.len = G_X_random.len;
	c_i.x.ptr = X_random.ptr;
	c_i.x.len = X_random.len;
	PRINT_ARRAY("\033[1mSecret ephemeral DH key (x)\033[0m", c_i.x.ptr, c_i.x.len);
	PRINT_ARRAY("\033[1mPublic ephemeral DH key (G_X)\033[0m", c_i.g_x.ptr, c_i.g_x.len);

#endif

#ifdef TINYCRYPT
	/* Register RNG function */
	uECC_set_rng(default_CSPRNG);
#endif

	TRY_EXPECT(start_coap_client(&sockfd), 0);

	total_start = clock(); // Start total timer
	msg1_start = clock(); // Start timing for M1 generation
	
	TRY(edhoc_initiator_run(&c_i, &cred_r_array, &err_msg, &PRK_out, tx, rx,
				ead_process));

	total_end = clock(); // End total timer
	total_elapsed_ms = (double)(total_end - total_start) * 1000.0 / CLOCKS_PER_SEC; // Calculate total time

	// Log warnings for timing anomalies but keep the actual measured values
	// This preserves the raw timing data for more accurate analysis
	double sum_of_times = metrics.m1_gen_time + metrics.m2_gen_time + 
                          metrics.m3_gen_time + metrics.m4_gen_time;
    
	// Check for timing anomalies and log them without modifying the data
	if (metrics.m1_gen_time > total_elapsed_ms)
		printf("WARNING: M1 generation time (%.3f ms) exceeds total time (%.3f ms)\n", 
               metrics.m1_gen_time, total_elapsed_ms);
               
	if (metrics.m2_gen_time > total_elapsed_ms) 
		printf("WARNING: M2 reception time (%.3f ms) exceeds total time (%.3f ms)\n", 
               metrics.m2_gen_time, total_elapsed_ms);
               
	if (metrics.m3_gen_time > total_elapsed_ms)
		printf("WARNING: M3 generation time (%.3f ms) exceeds total time (%.3f ms)\n", 
               metrics.m3_gen_time, total_elapsed_ms);
               
	if (metrics.m4_gen_time > total_elapsed_ms)
		printf("WARNING: M4 reception time (%.3f ms) exceeds total time (%.3f ms)\n", 
               metrics.m4_gen_time, total_elapsed_ms);
    
    // Log if sum of individual times is significantly different from total
    if (fabs(sum_of_times - total_elapsed_ms) > (total_elapsed_ms * 0.1)) {
        printf("INFO: Sum of individual times (%.3f ms) differs from total time (%.3f ms) by %.1f%%\n",
               sum_of_times, total_elapsed_ms, 
               fabs(sum_of_times - total_elapsed_ms) * 100 / total_elapsed_ms);
    }

	PRINT_ARRAY("\n\033[1mPRK_out\033[0m", PRK_out.ptr, PRK_out.len);

	PRINT_MSG("\n---------------------------------------------\n\n");
	PRINT_MSG("\033[1mDeriving PRK_exporter: HKDF-Extract( PRK_out, label=exporter )...\033[0m\n");
	TRY(prk_out2exporter(SHA_256, &PRK_out, &prk_exporter));
	PRINT_MSG("\033[1mFinished key derivation. Result:\033[0m\n");
	PRINT_ARRAY("\033[1mPRK_exporter\033[0m", prk_exporter.ptr, prk_exporter.len);

	PRINT_MSG("\n---------------------------------------------\n\n");

	PRINT_MSG("\033[1mDeriving OSCORE Master Secret (HKDF-Expand(PRK_exporter, label=OSCORE))...\033[0m\n");
	TRY(edhoc_exporter(SHA_256, OSCORE_MASTER_SECRET, &prk_exporter,
			   &oscore_master_secret));
	PRINT_MSG("\033[1mFinished key derivation. Result:\033[0m\n");
	PRINT_ARRAY("\033[1mOSCORE Master Secret\033[0m", oscore_master_secret.ptr,
		    oscore_master_secret.len);

	PRINT_MSG("\n---------------------------------------------\n\n");


	PRINT_MSG("\033[1mDeriving OSCORE Master Salt: HKDF-Expand( PRK_exporter, label=OSCORE )...\033[0m\n");
	TRY(edhoc_exporter(SHA_256, OSCORE_MASTER_SALT, &prk_exporter,
			   &oscore_master_salt));
	PRINT_MSG("\033[1mFinished key derivation. Result:\033[0m\n");
	PRINT_ARRAY("\033[1mOSCORE Master Salt\033[0m", oscore_master_salt.ptr,
		    oscore_master_salt.len);

	PRINT_MSG("\n---------------------------------------------\n");

	PRINT_MSG("\n\033[1mExchange obtained data\033[0m\n\n");
	
	PRINT_ARRAY("\033[1mPRK_out\033[0m", PRK_out.ptr, PRK_out.len);
	PRINT_ARRAY("\033[1mPRK_exporter\033[0m", prk_exporter.ptr, prk_exporter.len);
	PRINT_ARRAY("\033[1mOSCORE Master Secret\033[0m", oscore_master_secret.ptr,
		    oscore_master_secret.len);
	PRINT_ARRAY("\033[1mOSCORE Master Salt\033[0m", oscore_master_salt.ptr,
										    oscore_master_salt.len);

	PRINT_MSG("\n---------------------------------------------\n");

	PRINT_MSG("\n\033[1mEDHOC Initiator finished successfully!\033[0m\n\n");

	printf("\033[32m[EDHOC Initiator] Total exchange time: %.3f ms\033[0m\n", total_elapsed_ms); // Print total time in green
	
	// Record total time for metrics
	metrics.total_time = total_elapsed_ms;
	
	// Output metrics in CSV format for script to capture
	printf("CSV_OUTPUT:%d,%d,%d,%d,%.3f,%.3f,%.3f,%.3f,%.3f,%d\n",
		metrics.m1_size, metrics.m2_size, metrics.m3_size, metrics.m4_size,
		metrics.m1_gen_time, metrics.m2_gen_time, metrics.m3_gen_time, metrics.m4_gen_time,
		metrics.total_time, metrics.method);
	
	PRINT_MSG("\n---------------------------------------------\n\n");

	close(sockfd);
	return 0;
}
