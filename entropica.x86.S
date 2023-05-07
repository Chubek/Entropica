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

#define SYSCID_stdout $1
#define SYSCID_stderr $2

#define SYSC_NRR %rax
#define SYSC_RET %rax
#define SYSC_AG0 %rdi
#define SYSC_AG1 %rsi
#define SYSC_AG2 %rdx
#define SYSC_AG3 %r10
#define SYSC_AG4 %r8
#define SYSC_AG5 %r9

#define CABI_AG0 %rdi
#define CABI_AG1 %rsi
#define CABI_AG2 %rdx
#define CABI_AG3 %rcx
#define CABI_AG4 %r8
#define CABI_AG5 %r9

#define CNTR_QWD %rcx
#define CNTR_DWD %ecx
#define CNTR_WRD %cx
#define CNTR_LOB %cl
#define CNTR_HIB %ch

#define ACCM_QWD %rax
#define ACCM_DWD %eax
#define ACCM_WRD %ax
#define ACCM_LOB %al
#define ACCM_HIB %ah

#define CLB1_QWD %r10
#define CLB1_DWD %r10d
#define CLB1_WRD %r10w
#define CLB1_LOW %r10b

#define CLB2_QWD %r11
#define CLB2_DWD %r11d
#define CLB2_WRD %r11w
#define CLB2_LOW %r11b

#define CSV1_QWD %r8
#define CSV1_DWD %r8d
#define CSV1_WRD %r8w
#define CSV1_LOW %r8b

#define CSV2_QWD %r9
#define CSV2_DWD %r9d
#define CSV2_WRD %r9w
#define CSV2_LOW %r9b

#define SRCR_LOW %sil


.data

	.global count_bytes_til_newl
	.global get_freqs
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
	.global write_nullterm_str_to_stdout
	.global write_nullterm_str_to_stderr
	.global get_file_size


.text
	count_bytes_til_newl:
		#define BYTE_PTR CABI_AG0
		#define CNTR_PTR CABI_AG1
		#define CNTR_REG CNTR_QWD
		#define BYTE_REG CLB1_DWD
		#define DWRD_REG CLB1_QWD
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


	get_freqs:
		#define CNTR_PTR CABI_AG0
		#define NSEQ_LEN CABI_AG1
		#define MAGC_PTR CABI_AG2
		#define CNTR_REG CNTR_QWD
		#define CNTR_WRD CNTR_DWD
		#define ACCM_REG ACCM_QWD
		#define ACCM_MID ACCM_DWD
		#define ACCM_LOW ACCM_LOB
		#define DIVN_QWD CABI_AG1
		#define DIVN_LOW SRCR_LOW
		#define MAGC_REG CLB1_QWD
		#define SHR1_REG CSV1_QWD
		#define SHR2_REG CSV2_QWD
		#define SHR1_BYT CSV1_LOW
		#define SHR2_BYT CSV2_LOW
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
		#define CNTR_PTR CABI_AG0
		#define RETR_REG ACCM_QWD
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
		#define CNTR_PTR CABI_AG0
		#define RETR_REG ACCM_QWD
		#define TEMP_REG CLB1_QWD
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
		#define ALOC_LEN CABI_AG0
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
		#define ALOC_PTR CABI_AG0
		#define ALOC_LEN CABI_AG1

		movq SYSCNR_munmap, SYSC_NRR
		syscall

		ret

		#undef ALOC_PTR
		#undef ALOC_LEN


	allocate_private_memory:
		#define ALOC_LEN CABI_AG0
		#define TEMP_REG CLB1_QWD
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
		#define DLOC_LEN CABI_AG0
		#define TEMP_REG CLB1_QWD
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

	write_nullterm_str_to_stdout:
		#define STRN_PTR CABI_AG0
		#define STRN_TMP CLB2_QWD
		#define BYTE_REG CLB2_LOW
		#define DWRD_REG CLB2_QWD

		xorq DWRD_REG, DWRD_REG
		movq STRN_PTR, STRN_TMP
	1:
		movb (STRN_TMP), BYTE_REG
		incq STRN_TMP
		test DWRD_REG, DWRD_REG
		jz 2f
		jmp 1b
	2:
		movq STRN_TMP, SYSC_AG2
		subq STRN_PTR, SYSC_AG2
		movq STRN_PTR, SYSC_AG1
		movq SYSCID_stdout, SYSC_NRR
		syscall

		ret

		#undef STRN_PTR
		#undef STRN_TMP
		#undef BYTE_REG
		#undef DWRD_REG


	write_nullterm_str_to_stderr:
		#define STRN_PTR CABI_AG0
		#define STRN_TMP CLB2_QWD
		#define BYTE_REG CLB2_LOW
		#define DWRD_REG CLB2_QWD

		xorq DWRD_REG, DWRD_REG
		movq STRN_PTR, STRN_TMP
	1:
		movb (STRN_TMP), BYTE_REG
		incq STRN_TMP
		test DWRD_REG, DWRD_REG
		jz 2f
		jmp 1b
	2:
		movq STRN_TMP, SYSC_AG2
		subq STRN_PTR, SYSC_AG2
		movq STRN_PTR, SYSC_AG1
		movq SYSCID_stderr, SYSC_NRR
		syscall

		ret

		#undef STRN_PTR
		#undef STRN_TMP
		#undef BYTE_REG
		#undef DWRD_REG

	get_file_size:
		#define FILE_DSC CABI_AG0
		#define RETR_REG ACCM_QWD
		#define STAT_LEN $144
		#define SIZE_OFS $48
		#define FRAM_PTR %rbp
		#define STCK_PTR %rsp

		pushq FRAM_PTR
		movq STCK_PTR, FRAM_PTR
		subq STAT_LEN, FRAM_PTR

		leaq FRAM_PTR, SYSC_AG1
		movq SYSCNR_fstat, SYSC_NRR
		syscall

		movq SIZE_OFS(FRAM_PTR), RETR_REG

		popq FRAM_PTR
		ret

		#undef FILE_DSC
        #undef RETR_REG
        #undef STAT_LEN
        #undef SIZE_OFS
        #undef FRAM_PTR
        #undef STCK_PTR




#undef SYSCNR_read
#undef SYSCNR_write
#undef SYSCNR_open
#undef SYSCNR_close
#undef SYSCNR_fstat
#undef SYSCNR_mmap
#undef SYSCNR_munmap
#undef SYSCNR_brk
#undef SYSCNR_readv
#undef SYSCNR_fork
#undef SYSCNR_exit

#undef SYSCID_stdout
#undef SYSCID_stderr

#undef SYSC_NRR
#undef SYSC_RET
#undef SYSC_AG0
#undef SYSC_AG1
#undef SYSC_AG2
#undef SYSC_AG3
#undef SYSC_AG4
#undef SYSC_AG5

#undef CABI_AG0 
#undef CABI_AG1 
#undef CABI_AG2 
#undef CABI_AG3 
#undef CABI_AG4 
#undef CABI_AG5 

#undef CNTR_QWD 
#undef CNTR_DWD 
#undef CNTR_WRD 
#undef CNTR_LOB 
#undef CNTR_HIB 

#undef ACCM_QWD 
#undef ACCM_DWD 
#undef ACCM_WRD 
#undef ACCM_LOB 
#undef ACCM_HIB 

#undef CLB1_QWD 
#undef CLB1_DWD 
#undef CLB1_WRD 
#undef CLB1_LOW 

#undef CLB2_QWD 
#undef CLB2_DWD 
#undef CLB2_WRD 
#undef CLB2_LOW 

#undef CSV1_QWD 
#undef CSV1_DWD 
#undef CSV1_WRD 
#undef CSV1_LOW 

#undef CSV2_QWD 
#undef CSV2_DWD 
#undef CSV2_WRD 
#undef CSV2_LOW 

#undef SRCR_LOW 