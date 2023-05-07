#include "udivmagics.h"
#include "entropica.h"


entropica_entropy_t compute_sequence_entropy(entropica_cntr_t countarray) {
	entropica_len_t len = get_len_from_countarray(countarray);
	get_freqs(countarray, len, UDIV_MAGICS);
	entropica_entropy_t entropy = sum_log2_freq_get_entropy(countarray);
	return entropy;
}

