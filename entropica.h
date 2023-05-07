#define NUCL_ADN 65
#define NUCL_CYT 67
#define NUCL_GUA 71
#define NUCL_THY 84

#ifdef __hashtablesize__
#define HASHTABLE_SIZE __hashtablesize__
#else
#define HASHTABLE_SIZE 4096
#endif

#ifdef __permutablesize__
#define PERMUTABLE_SIZE __permutablesize__
#else
#define PERMUTABLE_SIZE 4096
#endif

#ifdef __udivmagicsize__
#define UDIVMAGIC_SIZE __udivmagicsize__
#else
#define UDIVMAGIC_SIZE 1000
#endif

#define CNTR_SIZE 128
#define MAXM_DIGT 21

typedef signed char entropica_asciinum_t[MAXM_DIGT];
typedef unsigned char entropica_countarray_t[CNTR_SIZE];
typedef unsigned short entropica_permutable_t[PERMUTABLE_SIZE];
typedef unsigned short entropica_hashtable_t[HASHTABLE_SIZE];
typedef unsigned int   entropica_udivmagics_t[UDIVMAGIC_SIZE];

typedef void entropica_nonyield_t;
typedef void *entropica_memaddr_t;
typedef signed char *entropica_nseq_t;
typedef signed char *entropica_filepath_t;
typedef signed char *entropica_charbuff_t;
typedef signed char *entropica_nulltermstr_t;
typedef signed int entropica_procid_t;
typedef signed int entropica_exitstat_t;
typedef signed int entropica_filedsc_t;
typedef signed int entropica_oflag_t;
typedef unsigned short entropica_length_t;
typedef unsigned short entropica_procnum_t;
typedef unsigned short entropica_freq_t;
typedef unsigned short entropica_entropy_t;
typedef unsigned short entropica_seqhash_t;
typedef unsigned long entropica_memsize_t;
typedef unsigned long entropica_cntnum_t;
typedef unsigned long entropica_filesize_t;
typedef unsigned long entropica_integer_t;
typedef unsigned long entropica_readnum_t;
typedef unsigned long entropica_writenum_t;


extern entropica_nonyield_t count_bytes_til_newl(entropica_charbuff_t charbuff, entropica_countarray_t countarray);
extern entropica_seqhash_t hash_bytes_til_newl(entropica_charbuff_t charbuff, entropica_permutable_t permutationtable);
extern entropica_nonyield_t write_entropy_to_hashtble(entropica_entropy_t entropy, entropica_seqhash_t seqhash, entropica_hashtable_t hashtable);
extern entropica_nonyield_t get_freqs(entropica_countarray_t countarray, entropica_length_t seqlen, entropica_udivmagics_t magicsarray);
extern entropica_length_t get_len_from_countarray(entropica_countarray_t countarray);
extern entropica_entropy_t sum_log2_freq_get_entropy(entropica_countarray_t countarray);
extern entropica_nonyield_t exit_process(entropica_exitstat_t status);
extern entropica_memaddr_t allocate_shared_memory(entropica_memsize_t memsize);
extern entropica_nonyield_t unallocate_shared_memory(entropica_memaddr_t memaddr);
extern entropica_memaddr_t allocate_pbreak_memory(entropica_memsize_t memsize);
extern entropica_nonyield_t unallocate_pbreak_memory(entropica_memaddr_t memaddr);
extern entropica_filedsc_t open_file_path(entropica_filepath_t filepath, entropica_oflag_t flags);
extern entropica_nonyield_t seek_file_from_start(entropica_filedsc_t filedsc);
extern entropica_nonyield_t close_file_descriptor(entropica_filedsc_t filedsc);
extern entropica_readnum_t read_buffer_from_file(entropica_filedsc_t filedsc, entropica_charbuff_t buffer, entropica_cntnum_t numchars);
extern entropica_writenum_t write_buffer_to_file(entropica_filedsc_t filedsc, entropica_charbuff_t buffer, entropica_cntnum_t numchars);
extern entropica_nonyield_t write_nullterm_str_to_stdout(entropica_nulltermstr_t string);
extern entropica_nonyield_t write_nullterm_str_to_stderr(entropica_nulltermstr_t string);
extern entropica_filesize_t get_file_size(entropica_filedsc_t filedsc);
extern entropica_integer_t ascii_to_integer(entropica_charbuff_t asciibuffer);
extern entropica_nonyield_t integer_to_ascii(entropica_integer_t integer, entropica_asciinum_t asciibuff);
extern entropica_procid_t fork_process();
