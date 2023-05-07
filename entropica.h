#define NUCL_ADN 65
#define NUCL_CYT 67
#define NUCL_GUA 71
#define NUCL_THY 84

typedef void entropica_nonyield_t;
typedef vod *entropica_memaddr_t;
typedef char *entropica_nseq_t;
typedef char *entropica_filepath_t;
typedef char *entropica_charbuff_t;
typedef char *entropica_nulltermstr_t;
typedef int entropica_procid_t;
typedef int entropica_exitstat_t;
typedef int entropica_filedsc_t;
typedef unsigned char entropica_cntr_t[128];
typedef unsigned short entropica_len_t;
typedef unsigned short entropica_freq_t;
typedef unsigned short entropica_entropy_t;
typedef unsigned int   *entropica_magic_t;
typedef unsigned long entropica_memsize_t;
typedef unsigned long entropica_cntnum_t;
typedef unsigned long entropica_filesize_t;
typedef unsigned long entropica_integer_t;

typedef struct IOVec {
	entropica_memaddr_t starting_addr;
	entropica_memsize_t read_len;
} entropica_iovec_t;

extern entropica_nonyield_t count_bytes_til_newl(entropica_nseq_t sequence, entropica_cntr_t countarray);
extern entropica_nonyield_t get_freqs(entropica_cntr_t countarray, entropica_len_t seqlen, entropica_magic_t magicsarray);
extern entropica_len_t get_len_from_countarray(entropica_cntr_t countarray);
extern entropica_entropy_t sum_log2_freq_get_entropy(entropica_cntr_t countarray);
extern entropica_procid_t fork_process();
extern entropica_nonyield_t exit_process(entropica_exitstat_t status);
extern entropica_memaddr_t allocate_shared_memory(entropica_memsize_t memsize);
extern entropica_nonyield_t unallocate_shared_memory(entropica_memaddr_t memaddr);
extern entropica_memaddr_t allocate_pbreak_memory(entropica_memsize_t memsize);
extern entropica_nonyield_t unallocate_pbreak_memory(entropica_memaddr_t memaddr);
extern entropica_filedsc_t open_file_path(entropica_filepath_t filepath);
extern entropica_nonyield_t close_file_descriptor(entropica_filedsc_t filedsc);
extern entropica_nonyield_t read_multiple_buffers_from_file(entropica_filedsc_t filedsc, entropica_iovec_t *iovecs, entropica_cntnum_t numiovecs);
extern entropica_cntnum_t write_buffer_to_file(entropica_filedsc_t filedsc, entropica_charbuff_t buffer, entropica_cntnum_t numchars);
extern entropica_nonyield_t write_nullterm_str_to_stdout(entropica_nulltermstr_t string);
extern entropica_nonyield_t write_nullterm_str_to_stderr(entropica_nulltermstr_t string);
extern entropica_filesize_t get_file_size(entropica_filedsc_t filedsc);
extern entropica_integer_t ascii_to_integer(entropica_charbuff_t asciibuffer);
extern entropica_nonyield_t integer_to_ascii(entropica_integer_t integer, entropica_charbuff_t asciibuffer);
