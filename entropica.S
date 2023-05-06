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
		#define MAGC_PTR %rsi
		#define CNTR_REG %rcx
		#define CNTR_WRD %ecx
		#define ACCM_REG %rax
		#define MAGC_REG %r10
		#define SHR1_REG %r8
		#define SHR2_REG %r9
		#define UI16_MAX $0xffff
		#define UI24_MAX $0xffffff
		#define UI04_MAX $15
		#define UI16_BIT $16
		#define UI08_BIT $8
		#define UI04_BIT $4
		#define DECA_SH1 $1
		#define DECA_SH3 $3

		xorq CNTR_REG, CNTR_REG
		movl (MAGC_PTR, NSEQ_LEN), CNTR_WRD
		movq CNTR_REG, MAGC_REG
		movq CNTR_REG, SHR1_REG
		movq CNTR_REG, SHR2_REG

		andq UI04_MAX, SHR1_REG

		shrq UI04_BIT, SHR2_REG
		andq UI04_MAX, SHR2_REG

		shrq UI08_BIT, MAGC_REG
		andq UI24_MAX, MAGC_REG

		#define GETFREQ(OFFSET) 						\
			movq OFFSET ## (CNTR_PTR), ACCM_REG;		\
			movq ACCM_REG, NSEQ_LEN;					\
			.rept 2 									\
			shlq DECA_SH1, ACCM_REG;					\
			shlq DECA_SH3, NSEQ_LEN;					\
			addq ACCM_REG, NSEQ_LEN;					\
			movq NSEQ_LEN, ACCM_REG;					\
			.endr										\
			mulq MAGC_REG;								\
			subq ACCM_REG, NSEQ_LEN;					\
			movq SHR1_REG, CNTR_REG;					\
			shlq NSEQ_LEN;								\
			addq ACCM_REG, NSEQ_LEN;					\
			movq SHR2_REG, NSEQ_LEN;					\
			shlq NSEQ_LEN;								\
			movq NSEQ_LEN, OFFSET ## (CNTR_PTR);


		GETFREQ(65)
		GETFREQ(67)
		GETFREQ(71)
		GETFREQ(84)

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






		main:
			nop