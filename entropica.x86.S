#define SYSCNR_read $0
#define SYSCNR_write $1
#define SYSCNR_open $2
#define SYSCNR_close $3
#define SYSCNR_fstat $5
#define SYSCNR_lseek $8
#define SYSCNR_mmap $9
#define SYSCNR_munmap $11
#define SYSCNR_brk $12
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
#define CABI_RET %rax

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

#define SRCR_QWD %rdx
#define SRCR_DWD %edx
#define SRCR_WRD %dx
#define SRCR_LOW %sil

#define DEST_QWD %rdi
#define DEST_DWD %edi
#define DEST_WRD %di
#define DEST_LOB %dl
#define DEST_HIB %dh

.data

	.global count_bytes_til_newl
	.global hash_bytes_til_newl
	.global detect_header
	.global get_freqs
	.global get_len_from_countarray
	.global sum_log2_freq_get_entropy
	.global fork_process
	.global exit_process
	.global allocate_shared_memory
	.global unallocate_shared_memory
	.global allocate_pbreak_memory
	.global unallocate_pbreak_memory
	.global open_file_path
	.global seek_file_from_start
	.global close_file_descriptor
	.global read_buffer_from_file
	.global write_buffer_to_file
	.global write_nullterm_str_to_stdout
	.global write_nullterm_str_to_stderr
	.global get_file_size
	.global ascii_to_integer
	.global integer_to_ascii


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


	hash_bytes_til_newl:
		#define CHAR_BUF CABI_AG0
		#define PERM_TAB CABI_AG1
		#define RETR_LOW ACCM_LOB
		#define RETR_WRD ACCM_WRD
		#define RETR_DWD ACCM_DWD
		#define BYTE_REG SRCR_DWD
		#define BYTE_WRD SRCR_WRD
		#define TEMP_REG CLB1_QWD
		#define TEMP_DWD CLB1_DWD
		#define TEMP_WRD CLB1_WRD
		#define INDX_REG CLB2_QWD
		#define INDX_DWD CLB2_DWD
		#define INDX_WRD CLB2_WRD
		#define CNTR_REG CNTR_QWD
		#define RETR_REG CABI_RET
		#define BYTE_LEN $1
		#define NEWL_CHR $10
		#define HWRD_NUM 2
		#define DWRD_LEN $4

		movq CHAR_BUF, TEMP_REG
	1:
		movzbl (CHAR_BUF), BYTE_REG
		cmpl NEWL_CHR, BYTE_REG
		je 2f
		incq CHAR_BUF
		jmp 1b

	2:
		subq TEMP_REG, CHAR_BUF
		movq CHAR_BUF, RETR_REG
		movq CHAR_BUF, CNTR_REG
		subq BYTE_LEN, CNTR_REG
		movq TEMP_REG, CHAR_BUF
		xorq TEMP_REG, TEMP_REG
	3:
		movzwl (CHAR_BUF, CNTR_REG), BYTE_REG
		xorw BYTE_WRD, RETR_WRD
		movzwl RETR_WRD, INDX_DWD
		shrq DWRD_LEN, INDX_REG
		movzwl (PERM_TAB, INDX_REG, HWRD_NUM), RETR_DWD
		loop 3b

		ret

		#undef CHAR_BUF
		#undef PERM_TAB
		#undef RETR_LOW
		#undef RETR_WRD
		#undef RETR_DWD
		#undef BYTE_REG
		#undef BYTE_WRD
		#undef TEMP_REG
		#undef TEMP_DWD
		#undef TEMP_WRD
		#undef INDX_REG
		#undef INDX_DWD
		#undef INDX_WRD
		#undef CNTR_REG
		#undef RETR_REG
		#undef BYTE_LEN
		#undef NEWL_CHR
		#undef HWRD_NUM
		#undef DWRD_LEN
		

	write_entropy_to_hashtble:
		#define HASH_SEQ CABI_AG0
		#define ENTR_SEQ CABI_AG1
		#define HASH_TAB CABI_AG2
		#define SHSH_WRD DEST_WRD
		#define HWRD_NUM 2

		movw SHSH_WRD, (HASH_TAB, HASH_SEQ, HWRD_NUM)

		ret

		#undef HASH_SEQ
		#undef ENTR_SEQ
		#undef HASH_TAB
		#undef SHSH_WRD
		#undef HWRD_NUM

	detect_header:
		#define BYTE_PTR CABI_AG0
		#define BYTE_REG CLB1_LOW
		#define QWRD_REG CLB1_QWD
		#define RETR_RES CABI_RET
		#define MARK_TRU $1
		#define MARK_FLS $0
		#define HEAD_CHR $62

		xorq QWRD_REG, QWRD_REG
		movb (BYTE_PTR), BYTE_REG

		cmp HEAD_CHR, BYTE_REG
		je 2f

		movq MARK_FLS, RETR_RES
	1:
		ret
	2:
		movq MARK_TRU, RETR_RES
		jmp 1b

	    #undef BYTE_PTR
        #undef BYTE_REG
        #undef RETR_RES
        #undef MARK_TRU
        #undef MARK_FLS
        #undef HEAD_CHR

	get_freqs:
		#define CNTR_PTR CABI_AG0
		#define NSEQ_LEN CABI_AG1
		#define MAGC_PTR CABI_AG2
		#define CNTR_REG CNTR_QWD
		#define CNTR_DWR CNTR_DWD
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

		pushq SHR1_REG
		pushq SHR2_REG

		movzwl (MAGC_PTR, NSEQ_LEN, LWRD_BIT), CNTR_DWR
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

		popq SHR2_REG
		popq SHR1_REG

		ret

		#undef CNTR_PTR
		#undef NSEQ_LEN
		#undef MAGC_PTR
		#undef CNTR_REG
		#undef CNTR_DWR
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
		#define RETR_REG CABI_RET
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
		#define RETR_REG CABI_RET
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
		#define ALCL_REG CLB1_QWD
		#define PROT_RWX $7
		#define FLAG_SHA $33
		#define NULL_FLD $-1
		#define QWRD_LEN $8
		#define QWRD_NUM 8

		movq ALOC_LEN, ALCL_REG
		addq QWRD_LEN, ALOC_LEN
		movq ALOC_LEN, SYSC_AG1
		xorq SYSC_AG0, SYSC_AG0
		movq PROT_RWX, SYSC_AG2
		movq FLAG_SHA, SYSC_AG3
		movq NULL_FLD, SYSC_AG4
		xorq SYSC_AG5, SYSC_AG5
		syscall

		movq ALCL_REG, (SYSC_RET)
		leaq QWRD_NUM(SYSC_RET), SYSC_RET

		ret

		#undef ALOC_LEN
		#undef PROT_RWX
		#undef FLAG_SHA
		#undef NULL_FLD
		#undef ALCL_REG
		#undef QWRD_LEN
		#undef QWRD_NUM


	unallocate_shared_memory:
		#define ALOC_PTR CABI_AG0
		#define ALCL_REG SYSC_AG1
		#define QWRD_NUM -8
		#define QWRD_LEN $8

		movq QWRD_NUM(ALOC_PTR), ALCL_REG
		addq QWRD_LEN, ALCL_REG

		movq SYSCNR_munmap, SYSC_NRR
		syscall

		ret

		#undef ALOC_PTR
		#undef ALCL_REG
		#undef QWRD_NUM
		#undef QWRD_LEN

	allocate_pbreak_memory:
		#define ALOC_LEN CABI_AG0
		#define TEMP_REG CLB1_QWD
		#define QWRD_NUM 8
		#define NEGT_BRK $-1
		#define QWRD_LEN $8

		movq ALOC_LEN, TEMP_REG
		movq NEGT_BRK, SYSC_AG0
		movq SYSCNR_brk, SYSC_NRR
		syscall


		addq QWRD_LEN, TEMP_REG
		addq TEMP_REG, SYSC_RET
		movq SYSC_RET, SYSC_AG0
		movq SYSCNR_brk, SYSC_NRR
		syscall

		movq TEMP_REG, (SYSC_RET)
		leaq QWRD_NUM(SYSC_RET), SYSC_RET

		ret

		#undef ALOC_LEN
		#undef TEMP_REG
		#undef NEGT_BRK
		#undef QWRD_LEN
		#undef QWRD_NUM

		
	unallocate_pbreak_memory:
		#define DLOC_PTR CABI_AG0
		#define TEMP_REG CLB1_QWD
		#define NEGT_BRK $-1
		#define QWRD_NUM -8
		#define QWRD_LEN $8

		leaq QWRD_NUM(DLOC_PTR), DLOC_PTR
		movq (DLOC_PTR), TEMP_REG
		addq QWRD_LEN, TEMP_REG

		subq TEMP_REG, DLOC_PTR
		movq SYSCNR_brk, SYSC_NRR
		syscall

		ret

		#undef DLOC_LEN
		#undef TEMP_REG
		#undef NEGT_BRK
		#undef QWRD_NUM
		#undef QWRD_LEN

	open_file_path:
		movq SYSCNR_open, SYSC_NRR
		syscall

		ret

	close_file_descriptor:
		movq SYSCNR_close, SYSC_NRR
		syscall

		ret

	read_buffer_from_file:
		movq SYSCNR_read, SYSC_NRR
		syscall

		ret

	write_buffer_to_file:
		movq SYSCNR_write, SYSC_NRR
		syscall

		ret

	seek_file_from_start:
		#define SEEK_SET SYSC_AG2

		xorq SEEK_SET, SEEK_SET
		movq SYSCNR_lseek, SYSC_NRR
		syscall

		ret

		#undef SEEK_SET

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
		#define RETR_REG CABI_RET
		#define STAT_LEN $144
		#define SIZE_OFS 48
		#define FRAM_PTR %rbp
		#define STCK_PTR %rsp

		pushq FRAM_PTR
		movq STCK_PTR, FRAM_PTR
		subq STAT_LEN, FRAM_PTR

		leaq (FRAM_PTR), SYSC_AG1
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

    ascii_to_integer:
    	#define BYTE_PTR CABI_AG0
    	#define RETR_REG CABI_RET
    	#define BYTE_REG CLB1_DWD
    	#define QWRD_REG CLB1_QWD
    	#define TEMP_REG CLB2_QWD
    	#define CNTR_REG CNTR_QWD
    	#define DECA_SH1 $1
    	#define DECA_SH2 $3
    	#define DIGT_MAX $20
    	#define ZERO_CHR $48

   		movq DIGT_MAX, CNTR_QWD
   	1:
    	movzbl (BYTE_PTR), BYTE_REG
    	andq QWRD_REG, QWRD_REG
    	jz 2f
    	incq BYTE_PTR
    	movq RETR_REG, TEMP_REG
    	shlq DECA_SH1, RETR_REG
    	shlq DECA_SH2, TEMP_REG
    	addq TEMP_REG, RETR_REG
    	subq ZERO_CHR, QWRD_REG
    	addq QWRD_REG, RETR_REG
    	loop 1b

    2:
    	ret

    	#undef BYTE_PTR
    	#undef RETR_REG
    	#undef BYTE_REG
    	#undef QWRD_REG
    	#undef TEMP_REG
    	#undef CNTR_REG
    	#undef DECA_SH1
    	#undef DECA_SH2
    	#undef DIGT_MAX
    	#undef ZERO_CHR

    integer_to_ascii:
    	#define INTG_NUM CABI_AG0
    	#define BYTE_PTR CABI_AG1
    	#define REMN_REG CABI_AG2
    	#define REMN_LOW SRCR_LOW
    	#define DECA_REG CLB2_QWD
    	#define CNTR_REG CNTR_QWD
    	#define BYTE_REG CLB1_LOW
    	#define ACCM_REG ACCM_QWD
    	#define DECA_NUM $10
    	#define ZERO_CHR $48
    	#define DIGT_MAX $20

    	movq DECA_NUM, DECA_REG
    	movq DIGT_MAX, CNTR_REG
    1:
    	movq INTG_NUM, ACCM_REG
    	xorq REMN_REG, REMN_REG
    	divq DECA_REG
    	test ACCM_REG, ACCM_REG
    	jz 2f
    	addq ZERO_CHR, REMN_REG
    	movb REMN_LOW, (BYTE_PTR)
    	incq BYTE_PTR
    	movq ACCM_REG, INTG_NUM
    	loop 1b

    2:
    	ret

    	#undef INTG_NUM
    	#undef BYTE_PTR
    	#undef REMN_REG
    	#undef REMN_LOW
    	#undef DECA_REG
    	#undef CNTR_REG
    	#undef BYTE_REQ
    	#undef ACCM_REG
    	#undef DECA_NUM
    	#undef ZERO_CHR
    	#undef DIGT_MAX



#undef SYSCNR_read
#undef SYSCNR_write
#undef SYSCNR_open
#undef SYSCNR_close
#undef SYSCNR_fstat
#undef SYSCNR_lseek
#undef SYSCNR_mmap
#undef SYSCNR_munmap
#undef SYSCNR_brk
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
#undef CABI_RET

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

#undef SRCR_QWD
#undef SRCR_DWD
#undef SRCR_WRD
#undef SRCR_LOW

#undef DEST_QWD
#undef DEST_DWD
#undef DEST_WRD
#undef DEST_LOB
#undef DEST_HIB