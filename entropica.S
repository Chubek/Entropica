.data

	.global entropica_count_bytes_til_newl
	.global entropica_get_freqs


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
		#define CNTR_BYT %cl
		#define ACCM_REG %rax
		#define ACCM_LOW %al
		#define NSEQ_LOW %dl
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
		#define DECA_SH1 $1
		#define DECA_SH3 $3
		#define NUCL_ADN 65
		#define NUCL_CYT 67
		#define NUCL_GUA 71
		#define NUCL_THY 84
		#define LWRD_BIT 4

		xorq CNTR_REG, CNTR_REG
		xorq ACCM_REG, ACCM_REG

		movl (MAGC_PTR, NSEQ_LEN, LWRD_BIT), CNTR_WRD
		movq CNTR_REG, MAGC_REG
		movq CNTR_REG, SHR1_REG
		movq CNTR_REG, SHR2_REG

		andq UI04_MAX, SHR1_REG

		shrq UI04_BIT, SHR2_REG
		andq UI04_MAX, SHR2_REG

		shrq UI08_BIT, MAGC_REG
		andq UI24_MAX, MAGC_REG

		#define GETFREQ(OFFSET) 						\
			movb OFFSET ## (CNTR_PTR), ACCM_LOW;		\
			movq ACCM_REG, NSEQ_LEN;					\
			.rept 2 									\
			shlq DECA_SH1, ACCM_REG;					\
			shlq DECA_SH3, NSEQ_LEN;					\
			addq ACCM_REG, NSEQ_LEN;					\
			movq NSEQ_LEN, ACCM_REG;					\
			.endr										\
			mulq MAGC_REG;								\
			shrq UI16_BIT, ACCM_REG;					\
			andq UI16_MAX, ACCM_REG;					\
			subq ACCM_REG, NSEQ_LEN;					\
			movq SHR1_REG, CNTR_REG;					\
			shrq CNTR_REG, NSEQ_LEN;					\
			addq ACCM_REG, NSEQ_LEN;					\
			movq SHR2_REG, CNTR_REG;					\
			shrq CNTR_REG, NSEQ_LEN;					\
			movb NSEQ_LOW, OFFSET ## (CNTR_PTR);


		GETFREQ(NUCL_ADN)
		GETFREQ(NUCL_CYT)
		GETFREQ(NUCL_GUA)
		GETFREQ(NUCL_THY)

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
		#undef DECA_SH1
		#undef DECA_SH3
		#undef NUCL_ADN
		#undef NUCL_CYT
		#undef NUCL_GUA
		#undef NUCL_THY





		main:
			nop