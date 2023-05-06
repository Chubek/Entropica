#include "udivmagics.h"
#include <stdio.h>

#define NUCL_ADN 65
#define NUCL_CYT 67
#define NUCL_GUA 71
#define NUCL_THY 84

typedef void entropica_nonyield_t;
typedef char *entropica_nseq_t;
typedef unsigned char entropica_cntr_t[128];
typedef unsigned short entropica_len_t;
typedef unsigned short entropica_freq_t;
typedef unsigned short entropica_entropy_t;
typedef unsigned int   *entropica_magic_t;


extern entropica_nonyield_t entropica_count_bytes_til_newl(entropica_nseq_t sequence, entropica_cntr_t countarray);
extern entropica_nonyield_t entropica_get_freqs(entropica_cntr_t countarray, entropica_len_t seqlen, entropica_magic_t magicsarray);
extern entropica_len_t get_len_from_countarray(entropica_cntr_t countarray);
extern entropica_entropy_t sum_log2_freq_get_entropy(entropica_cntr_t countarray);

int main() {
	entropica_cntr_t countarray;
	entropica_nseq_t sequence = "AATTGTATC\n";
	entropica_count_bytes_til_newl(sequence, countarray);
	entropica_len_t len = get_len_from_countarray(countarray);
	entropica_get_freqs(countarray, len, UDIV_MAGICS);
	entropica_entropy_t entropy = sum_log2_freq_get_entropy(countarray);
}