#include "entropica.h"
#include "udivmagics.h"
#include "permutable.h"




entropica_semtable_t allocate_semtable() {
	return allocate_shared_memory(MAX_CONCURRENT_READERS);
}

entropica_hashtable_t allocate_hashtable() {
	return allocate_shared_memory(HASHTABLE_SIZE * sizeof(entropica_seqhash_t));
}

entropica_fofsttable_t allocate_fofsttable() {
	return allocate_shared_memory(MAX_CONCURRENT_READERS * sizeof(entropica_fileofst_t));
}


entropica_readctx_t new_read_context(entropica_filepath_t filepath, entropica_procnum_t numprocesses) {
	entropica_filedsc_t filedescriptor = open_file_path(filepath);
	entropica_semtable_t signals = allocate_semtable();
	entropica_hashtable_t entropyresults = allocate_hashtable();
	entropica_fofsttable_t fileoffsets = allocate_fofstable();
	return (entropica_readctx_t){
		.filedescriptor = filedescriptor,
		.numprocecesses = numprocecesses,
		.entropyresults = entropyresults,
		.signals = signals,
		.fileoffsets = fileoffsets,
	};
}


entropica_nonyield_t destroy_read_context(entropica_readctx_t *context) {
	close_file_descriptor(context->filedescriptor);
	unallocate_shared_memory(context->entropyresults);
	unallocate_shared_memory(context->signals);
	unallocate_shared_memory(context->fileoffsets);
}