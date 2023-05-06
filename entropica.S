.data

	.global entropica_count_bytes_til_newl
	.global entropica_get_freqs
	.global get_len_from_countarray
	.global sum_log2_freq_get_entropy


.text
	entropica_count_bytes_til_newl:
		#define BYTE_PTR %rdi
		#define CNTR_PTR %rsi
		#define CNTR_REG %rcx
		#define BYTE_REG %r10b
		#define DWRD_REG %r10
		#define NEWL_CHR $10

		xorq DWRD_REG, DWRD_REG

	1:
		movb (BYTE_PTR), BYTE_REG
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

		xorq CNTR_REG, CNTR_REG

		movl (MAGC_PTR, NSEQ_LEN, LWRD_BIT), CNTR_WRD
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
			xorq ACCM_REG, ACCM_REG;					\
			movb OFFSET ## (CNTR_PTR), ACCM_LOW;		\
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

		xorq RETR_REG, REGR_REG

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
			tzcnt OFFSET ## (CNTR_PTR), TEMP_REG;		\
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