#define SYSCNR_read $0
#define SYSCNR_write $1
#define SYSCNR_open $2
#define SYSCNR_close $3
#define SYSCNR_fstat $5
#define SYSCNR_mmap $9
#define SYSCNR_munmap $11
#define SYSCNR_brk $12
#define SYSCNR_readv $19
#define SYSCNR_fork $57
#define SYSCNR_exit $60

#define SYSC_NRR %rax
#define SYSC_RET %rax
#define SYSC_AG0 %rdi
#define SYSC_AG1 %rsi
#define SYSC_AG2 %rdx
#define SYSC_AG3 %r10
#define SYSC_AG4 %r8
#define SYSC_AG5 %r9

.data

	.global entropica_count_bytes_til_newl
	.global entropica_get_freqs
	.global get_len_from_countarray
	.global sum_log2_freq_get_entropy
	.global fork_process
	.global exit_process
	.global allocate_shared_memory
	.global unallocate_shared_memory
	.global allocate_private_memory
	.global unallocate_private_memory
	.global open_file_path
	.global close_file_descriptor
	.global read_multiple_buffers_from_file
	.global write_buffer_to_file


.text
	entropica_count_bytes_til_newl:
		#define BYTE_PTR %rdi
		#define CNTR_PTR %rsi
		#define CNTR_REG %rcx
		#define BYTE_REG %r10d
		#define DWRD_REG %r10
		#define NEWL_CHR $10


	1:
		movzbl (BYTE_PTR), BYTE_REG
		cmpq NEWL_CHR, DWRD_REG
		je 2f
		incq (CNTR_PTR, DWRD_REG)
		incq BYTE_PTR
		jmp 1b

	2:
		ret

		#undef BYTE_PTR
		#undef CNTR_PTR
		#undef CNTR_REG
		#undef BYTE_REG
		#undef DWRD_REG
		#undef NEWL_CHR


	entropica_get_freqs:
		#define CNTR_PTR %rdi
		#define NSEQ_LEN %rsi
		#define MAGC_PTR %rdx
		#define CNTR_REG %rcx
		#define CNTR_WRD %ecx
		#define ACCM_REG %rax
		#define ACCM_MID %eax
		#define ACCM_LOW %al
		#define DIVN_QWD %rsi
		#define DIVN_LOW %sil
		#define MAGC_REG %r10
		#define SHR1_REG %r8
		#define SHR2_REG %r9
		#define SHR1_BYT %r8b
		#define SHR2_BYT %r9b
		#define UI16_MAX $0xffff
		#define UI24_MAX $0xffffff
		#define UI04_MAX $15
		#define UI16_BIT $16
		#define UI08_BIT $8
		#define UI04_BIT $4
		#define DECA_SH3 $3
		#define NUCL_ADN 65
		#define NUCL_CYT 67
		#define NUCL_GUA 71
		#define NUCL_THY 84
		#define LWRD_BIT 4


		movzwl (MAGC_PTR, NSEQ_LEN, LWRD_BIT), CNTR_WRD
		movq CNTR_REG, MAGC_REG
		movq CNTR_REG, SHR1_REG
		movq CNTR_REG, SHR2_REG

		andq UI04_MAX, SHR1_REG

		shrq UI04_BIT, SHR2_REG
		andq UI04_MAX, SHR2_REG

		shrq UI08_BIT, MAGC_REG
		andq UI24_MAX, MAGC_REG

		#define MULTDECA								\
			shlq ACCM_REG;								\
			shlq DECA_SH3, DIVN_QWD;					\
			addq ACCM_REG, DIVN_QWD;					\
			movq DIVN_QWD, ACCM_REG;

		#define GETFREQC(OFFSET) 						\
			movzbl OFFSET ## (CNTR_PTR), ACCM_MID;		\
			movq ACCM_REG, DIVN_QWD;					\
			MULTDECA									\
			MULTDECA									\
			mulq MAGC_REG;								\
			shrq UI16_BIT, ACCM_REG;					\
			andq UI16_MAX, ACCM_REG;					\
			subq ACCM_REG, DIVN_QWD;					\
			movq SHR1_REG, CNTR_REG;					\
			shrq CNTR_REG, DIVN_QWD;					\
			addq ACCM_REG, DIVN_QWD;					\
			movq SHR2_REG, CNTR_REG;					\
			shrq CNTR_REG, DIVN_QWD;					\
			movb DIVN_LOW, OFFSET ## (CNTR_PTR);


		GETFREQC(NUCL_ADN)
		GETFREQC(NUCL_CYT)
		GETFREQC(NUCL_GUA)
		GETFREQC(NUCL_THY)

		ret

		#undef CNTR_PTR
		#undef NSEQ_LEN
		#undef MAGC_PTR
		#undef CNTR_REG
		#undef ACCM_REG
		#undef MAGC_REG
		#undef SHR1_REG
		#undef SHR2_REG
		#undef UI16_MAX
		#undef UI24_MAX
		#undef UI04_MAX
		#undef UI16_BIT
		#undef UI08_BIT
		#undef UI04_BIT
		#undef DECA_SH3
		#undef NUCL_ADN
		#undef NUCL_CYT
		#undef NUCL_GUA
		#undef NUCL_THY
		#undef LWRD_BIT
		#undef DIVN_LOW
		#undef DIVN_QWD

		#undef MULTDECA
		#undef GETFREQC


	get_len_from_countarray:
		#define CNTR_PTR %rdi
		#define RETR_REG %rax
		#define NUCL_ADN 65
		#define NUCL_CYT 67
		#define NUCL_GUA 71
		#define NUCL_THY 84

		xorq RETR_REG, RETR_REG

		#define ADDNLEN(OFFSET) 					\
			addq OFFSET ## (CNTR_PTR), RETR_REG;

		ADDNLEN(NUCL_ADN)
		ADDNLEN(NUCL_CYT)
		ADDNLEN(NUCL_GUA)
		ADDNLEN(NUCL_THY)

		ret

		#undef CNTR_PTR
		#undef RETR_REG
		#undef NUCL_ADN
		#undef NUCL_CYT
		#undef NUCL_GUA
		#undef NUCL_THY

	sum_log2_freq_get_entropy:
		#define CNTR_PTR %rdi
		#define RETR_REG %rax
		#define TEMP_REG %r10
		#define SUBQ_ONE $1
		#define NUCL_ADN 65
		#define NUCL_CYT 67
		#define NUCL_GUA 71
		#define NUCL_THY 84

		xorq RETR_REG, RETR_REG
		

		#define COMPENT(OFFSET)							\
			xorq TEMP_REG, TEMP_REG;					\
			lzcnt OFFSET ## (CNTR_PTR), TEMP_REG;		\
			subq SUBQ_ONE, TEMP_REG;					\
			addq TEMP_REG, RETR_REG;


		COMPENT(NUCL_ADN)
		COMPENT(NUCL_CYT)
		COMPENT(NUCL_GUA)
		COMPENT(NUCL_THY)

		ret

		#undef CNTR_PTR
		#undef RETR_REG
		#undef TEMP_REG
		#undef SUBQ_ONE
		#undef NUCL_ADN
		#undef NUCL_CYT
		#undef NUCL_GUA
		#undef NUCL_THY


	fork_process:
		movq SYSCNR_fork, SYSC_NRR
		syscall

		ret

	exit_process:
		movq SYSCNR_exit, SYSC_NRR
		syscall

		ret

	allocate_shared_memory:
		#define ALOC_LEN %rdi
		#define PROT_RWX $7
		#define FLAG_SHA $33
		#define NULL_FLD $-1

		movq ALOC_LEN, SYSC_AG1
		xorq SYSC_AG0, SYSC_AG0
		movq PROT_RWX, SYSC_AG2
		movq FLAG_SHA, SYSC_AG3
		movq NULL_FLD, SYSC_AG4
		xorq SYSC_AG5, SYSC_AG5
		syscall

		ret

		#undef ALOC_LEN
		#undef PROT_RWX
		#undef FLAG_SHA
		#undef NULL_FLD


	unallocate_shared_memory:
		#define ALOC_PTR %rdi
		#define ALOC_LEN %rsi

		movq SYSCNR_munmap, SYSC_NRR
		syscall

		ret

		#undef ALOC_PTR
		#undef ALOC_LEN


	allocate_private_memory:
		#define ALOC_LEN %rdi
		#define TEMP_REG %r10
		#define NEGT_BRK $-1

		movq ALOC_LEN, TEMP_REG
		movq NEGT_BRK, SYSC_AG0
		movq SYSCNR_brk, SYSC_NRR
		syscall


		addq TEMP_REG, SYSC_RET
		movq SYSC_RET, SYSC_AG0
		movq SYSCNR_brk, SYSC_NRR
		syscall

		ret

		#undef ALOC_LEN
		#undef TEMP_REG
		#undef NEGT_BRK

		
	unallocate_private_memory:
		#define DLOC_LEN %rdi
		#define TEMP_REG %r10
		#define NEGT_BRK $-1
		
		movq DLOC_LEN, TEMP_REG
		movq NEGT_BRK, SYSC_AG0
		movq SYSCNR_brk, SYSC_NRR
		syscall


		subq TEMP_REG, SYSC_RET
		movq SYSC_RET, SYSC_AG0
		movq SYSCNR_brk, SYSC_NRR
		syscall

		ret

		#undef DLOC_LEN
		#undef TEMP_REG
		#undef NEGT_BRK4

	open_file_path:
		movq SYSCNR_open, SYSC_NRR
		syscall

		ret

	close_file_descriptor:
		movq SYSCNR_close, SYSC_NRR
		syscall

		ret

	read_multiple_buffers_from_file:
		movq SYSCNR_readv, SYSC_NRR
		syscall

		ret

	write_buffer_to_file:
		movq SYSCNR_write, SYSC_NRR
		syscall

		ret