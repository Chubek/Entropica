#include "entropica.h"
#include "udivmagics.h"
#include "permutable.h"




entropica_semtable_t allocate_semtable() {
	return allocate_shared_memory(MAX_CONCURRENT_READERS);
}

entropica_nonyieldt_t unallocate_semtable(entropica_semtable_t semtable) {
	unallocate_shared_memory(semtable);
}

entropica_hashtable_t allocate_hashtable() {
	return allocate_shared_memory(HASHTABLE_SIZE * sizeof(entropica_seqhash_t));
}

entropica_nonyieldt_t unallocate_hashtable(entropica_hashtable_t hashtable) {
	unallocate_shared_memory(hashtable);
}

entropica_fofsttable_t allocate_fofsttable() {
	return allocate_shared_memory(MAX_CONCURRENT_READERS * sizeof(entropica_fileofst_t));
}

entropica_nonyieldt_t unallocate_fofsttable(entropica_fofsttable_t fofsttable) {
	unallocate_shared_memory(fofsttable);
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