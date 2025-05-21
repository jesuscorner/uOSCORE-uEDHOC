	.file	"x509_crt.c"
	.text
.Ltext0:
	.file 1 "../../../externals/mbedtls/library/x509_crt.c"
	.type	x509_profile_check_md_alg, @function
x509_profile_check_md_alg:
.LVL0:
.LFB41:
	.loc 1 186 1 view -0
	.cfi_startproc
	.loc 1 187 5 view .LVU1
	.loc 1 187 7 is_stmt 0 view .LVU2
	testl	%esi, %esi
	je	.L3
	.loc 1 190 5 is_stmt 1 view .LVU3
	.loc 1 190 34 is_stmt 0 view .LVU4
	leal	-1(%rsi), %ecx
	movl	$1, %eax
	sall	%cl, %eax
	.loc 1 190 7 view .LVU5
	testl	%eax, (%rdi)
	je	.L5
	.loc 1 191 15 view .LVU6
	movl	$0, %eax
	.loc 1 194 1 view .LVU7
	ret
.L5:
	.loc 1 193 11 view .LVU8
	movl	$-1, %eax
	ret
.L3:
	.loc 1 188 15 view .LVU9
	movl	$-1, %eax
	ret
	.cfi_endproc
.LFE41:
	.size	x509_profile_check_md_alg, .-x509_profile_check_md_alg
	.type	x509_profile_check_pk_alg, @function
x509_profile_check_pk_alg:
.LVL1:
.LFB42:
	.loc 1 202 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 203 5 view .LVU11
	.loc 1 203 7 is_stmt 0 view .LVU12
	testl	%esi, %esi
	je	.L8
	.loc 1 206 5 is_stmt 1 view .LVU13
	.loc 1 206 34 is_stmt 0 view .LVU14
	leal	-1(%rsi), %ecx
	movl	$1, %eax
	sall	%cl, %eax
	.loc 1 206 7 view .LVU15
	testl	%eax, 4(%rdi)
	je	.L10
	.loc 1 207 15 view .LVU16
	movl	$0, %eax
	.loc 1 210 1 view .LVU17
	ret
.L10:
	.loc 1 209 11 view .LVU18
	movl	$-1, %eax
	ret
.L8:
	.loc 1 204 15 view .LVU19
	movl	$-1, %eax
	ret
	.cfi_endproc
.LFE42:
	.size	x509_profile_check_pk_alg, .-x509_profile_check_pk_alg
	.type	x509_memcasecmp, @function
x509_memcasecmp:
.LVL2:
.LFB44:
	.loc 1 255 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 255 1 is_stmt 0 view .LVU21
	movq	%rdi, %r9
	.loc 1 256 5 is_stmt 1 view .LVU22
	.loc 1 257 5 view .LVU23
	.loc 1 258 5 view .LVU24
.LVL3:
	.loc 1 260 5 view .LVU25
	.loc 1 260 12 is_stmt 0 view .LVU26
	movl	$0, %ecx
	.loc 1 260 5 view .LVU27
	jmp	.L12
.LVL4:
.L13:
	.loc 1 260 27 is_stmt 1 discriminator 2 view .LVU28
	addq	$1, %rcx
.LVL5:
.L12:
	.loc 1 260 19 discriminator 1 view .LVU29
	cmpq	%rdx, %rcx
	jnb	.L18
	.loc 1 262 9 view .LVU30
	.loc 1 262 18 is_stmt 0 view .LVU31
	movzbl	(%r9,%rcx), %eax
	.loc 1 262 26 view .LVU32
	movzbl	(%rsi,%rcx), %edi
	.loc 1 262 14 view .LVU33
	movl	%eax, %r8d
	xorl	%edi, %r8d
.LVL6:
	.loc 1 264 9 is_stmt 1 view .LVU34
	.loc 1 264 11 is_stmt 0 view .LVU35
	cmpb	%dil, %al
	je	.L13
	.loc 1 267 9 is_stmt 1 view .LVU36
	.loc 1 267 11 is_stmt 0 view .LVU37
	cmpb	$32, %r8b
	jne	.L16
	.loc 1 268 48 discriminator 1 view .LVU38
	leal	-97(%rax), %edi
	cmpb	$25, %dil
	setbe	%dil
	subl	$65, %eax
	cmpb	$25, %al
	setbe	%al
	.loc 1 267 24 discriminator 1 view .LVU39
	orb	%al, %dil
	jne	.L13
	.loc 1 274 15 view .LVU40
	movl	$-1, %eax
	.loc 1 278 1 view .LVU41
	ret
.LVL7:
.L18:
	.loc 1 277 11 view .LVU42
	movl	$0, %eax
	ret
.LVL8:
.L16:
	.loc 1 274 15 view .LVU43
	movl	$-1, %eax
	ret
	.cfi_endproc
.LFE44:
	.size	x509_memcasecmp, .-x509_memcasecmp
	.type	x509_crt_verify_chain_reset, @function
x509_crt_verify_chain_reset:
.LVL9:
.LFB48:
	.loc 1 386 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 387 5 view .LVU45
	.loc 1 389 5 view .LVU46
	.loc 1 389 12 is_stmt 0 view .LVU47
	movl	$0, %edx
	.loc 1 389 5 view .LVU48
	jmp	.L20
.LVL10:
.L21:
	.loc 1 391 9 is_stmt 1 discriminator 3 view .LVU49
	.loc 1 391 33 is_stmt 0 discriminator 3 view .LVU50
	movq	%rdx, %rax
	salq	$4, %rax
	addq	%rdi, %rax
	movq	$0, (%rax)
	.loc 1 392 9 is_stmt 1 discriminator 3 view .LVU51
	.loc 1 392 35 is_stmt 0 discriminator 3 view .LVU52
	movl	$-1, 8(%rax)
	.loc 1 389 58 is_stmt 1 discriminator 3 view .LVU53
	addq	$1, %rdx
.LVL11:
.L20:
	.loc 1 389 19 discriminator 1 view .LVU54
	cmpq	$9, %rdx
	jbe	.L21
	.loc 1 395 5 view .LVU55
	.loc 1 395 20 is_stmt 0 view .LVU56
	movl	$0, 160(%rdi)
	.loc 1 400 1 view .LVU57
	ret
	.cfi_endproc
.LFE48:
	.size	x509_crt_verify_chain_reset, .-x509_crt_verify_chain_reset
	.type	x509_crt_merge_flags_with_cb, @function
x509_crt_merge_flags_with_cb:
.LVL12:
.LFB89:
	.loc 1 3064 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 3064 1 is_stmt 0 view .LVU59
	pushq	%r14
.LCFI0:
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
.LCFI1:
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
.LCFI2:
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
.LCFI3:
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
.LCFI4:
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$16, %rsp
.LCFI5:
	.cfi_def_cfa_offset 64
	movq	%rdi, %rbp
	movq	%rsi, %r12
	movq	%rdx, %r13
	movq	%rcx, %r14
	.loc 1 3065 5 is_stmt 1 view .LVU60
.LVL13:
	.loc 1 3066 5 view .LVU61
	.loc 1 3067 5 view .LVU62
	.loc 1 3068 5 view .LVU63
	.loc 1 3070 5 view .LVU64
	.loc 1 3070 12 is_stmt 0 view .LVU65
	movl	160(%rsi), %edx
.LVL14:
	.loc 1 3070 5 view .LVU66
	jmp	.L23
.LVL15:
.L24:
	.loc 1 3079 9 is_stmt 1 discriminator 2 view .LVU67
	movl	0(%rbp), %eax
	.loc 1 3079 16 is_stmt 0 discriminator 2 view .LVU68
	orl	12(%rsp), %eax
	movl	%eax, 0(%rbp)
	.loc 1 3070 38 is_stmt 1 discriminator 2 view .LVU69
.LVL16:
	.loc 1 3070 38 is_stmt 0 discriminator 2 view .LVU70
	movl	%ebx, %edx
.LVL17:
.L23:
	.loc 1 3070 32 is_stmt 1 discriminator 1 view .LVU71
	testl	%edx, %edx
	je	.L28
	.loc 1 3072 9 view .LVU72
	.loc 1 3072 34 is_stmt 0 view .LVU73
	leal	-1(%rdx), %ebx
.LVL18:
	.loc 1 3073 9 is_stmt 1 view .LVU74
	.loc 1 3073 24 is_stmt 0 view .LVU75
	movl	%ebx, %eax
	salq	$4, %rax
	movl	8(%r12,%rax), %eax
	.loc 1 3073 19 view .LVU76
	movl	%eax, 12(%rsp)
	.loc 1 3075 9 is_stmt 1 view .LVU77
	.loc 1 3075 11 is_stmt 0 view .LVU78
	testq	%r13, %r13
	je	.L24
	.loc 1 3076 13 is_stmt 1 view .LVU79
	.loc 1 3076 44 is_stmt 0 view .LVU80
	movl	%ebx, %eax
	salq	$4, %rax
	movq	(%r12,%rax), %rsi
	.loc 1 3076 25 view .LVU81
	leaq	12(%rsp), %rcx
	movl	%ebx, %edx
.LVL19:
	.loc 1 3076 25 view .LVU82
	movq	%r14, %rdi
	call	*%r13
.LVL20:
	.loc 1 3076 15 view .LVU83
	testl	%eax, %eax
	je	.L24
	jmp	.L22
.LVL21:
.L28:
	.loc 1 3082 11 view .LVU84
	movl	$0, %eax
.LVL22:
.L22:
	.loc 1 3083 1 view .LVU85
	addq	$16, %rsp
.LCFI6:
	.cfi_def_cfa_offset 48
	popq	%rbx
.LCFI7:
	.cfi_def_cfa_offset 40
	popq	%rbp
.LCFI8:
	.cfi_def_cfa_offset 32
.LVL23:
	.loc 1 3083 1 view .LVU86
	popq	%r12
.LCFI9:
	.cfi_def_cfa_offset 24
.LVL24:
	.loc 1 3083 1 view .LVU87
	popq	%r13
.LCFI10:
	.cfi_def_cfa_offset 16
.LVL25:
	.loc 1 3083 1 view .LVU88
	popq	%r14
.LCFI11:
	.cfi_def_cfa_offset 8
.LVL26:
	.loc 1 3083 1 view .LVU89
	ret
	.cfi_endproc
.LFE89:
	.size	x509_crt_merge_flags_with_cb, .-x509_crt_merge_flags_with_cb
	.type	x509_get_uid, @function
x509_get_uid:
.LVL27:
.LFB51:
	.loc 1 474 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 475 5 view .LVU91
	.loc 1 477 5 view .LVU92
	.loc 1 477 9 is_stmt 0 view .LVU93
	movq	(%rdi), %rax
	.loc 1 477 7 view .LVU94
	cmpq	%rsi, %rax
	je	.L32
	.loc 1 474 1 view .LVU95
	pushq	%rbp
.LCFI12:
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
.LCFI13:
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
.LCFI14:
	.cfi_def_cfa_offset 32
	movq	%rdi, %rbx
	movq	%rdx, %rbp
	.loc 1 480 5 is_stmt 1 view .LVU96
	.loc 1 480 16 is_stmt 0 view .LVU97
	movzbl	(%rax), %eax
	.loc 1 480 14 view .LVU98
	movl	%eax, (%rdx)
	.loc 1 482 5 is_stmt 1 view .LVU99
	.loc 1 482 17 is_stmt 0 view .LVU100
	orb	$-96, %cl
.LVL28:
	.loc 1 482 17 view .LVU101
	leaq	8(%rdx), %rdx
.LVL29:
	.loc 1 482 17 view .LVU102
	call	mbedtls_asn1_get_tag@PLT
.LVL30:
	.loc 1 482 7 view .LVU103
	testl	%eax, %eax
	je	.L31
	.loc 1 485 9 is_stmt 1 view .LVU104
	.loc 1 485 11 is_stmt 0 view .LVU105
	cmpl	$-98, %eax
	je	.L33
	.loc 1 488 9 is_stmt 1 view .LVU106
.LVL31:
.LBB113:
.LBI113:
	.file 2 "../../../externals/mbedtls/include/mbedtls/error.h"
	.loc 2 156 19 view .LVU107
.LBB114:
	.loc 2 163 5 view .LVU108
	.loc 2 164 5 view .LVU109
	.loc 2 166 5 view .LVU110
	.loc 2 166 18 is_stmt 0 view .LVU111
	subl	$8576, %eax
.LVL32:
	.loc 2 166 18 view .LVU112
.LBE114:
.LBE113:
	.loc 1 488 17 view .LVU113
	jmp	.L29
.LVL33:
.L31:
	.loc 1 491 5 is_stmt 1 view .LVU114
	.loc 1 491 14 is_stmt 0 view .LVU115
	movq	(%rbx), %rdx
	.loc 1 491 12 view .LVU116
	movq	%rdx, 16(%rbp)
	.loc 1 492 5 is_stmt 1 view .LVU117
	.loc 1 492 8 is_stmt 0 view .LVU118
	addq	8(%rbp), %rdx
	movq	%rdx, (%rbx)
	.loc 1 494 5 is_stmt 1 view .LVU119
.LVL34:
.L29:
	.loc 1 495 1 is_stmt 0 view .LVU120
	addq	$8, %rsp
.LCFI15:
	.cfi_def_cfa_offset 24
	popq	%rbx
.LCFI16:
	.cfi_def_cfa_offset 16
.LVL35:
	.loc 1 495 1 view .LVU121
	popq	%rbp
.LCFI17:
	.cfi_def_cfa_offset 8
.LVL36:
	.loc 1 495 1 view .LVU122
	ret
.LVL37:
.L32:
	.cfi_restore 3
	.cfi_restore 6
	.loc 1 478 15 view .LVU123
	movl	$0, %eax
	.loc 1 495 1 view .LVU124
	ret
.LVL38:
.L33:
.LCFI18:
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -24
	.cfi_offset 6, -16
	.loc 1 486 19 view .LVU125
	movl	$0, %eax
.LVL39:
	.loc 1 486 19 view .LVU126
	jmp	.L29
	.cfi_endproc
.LFE51:
	.size	x509_get_uid, .-x509_get_uid
	.section	.rodata
.LC0:
	.string	"U\035 "
	.string	""
	.text
	.type	x509_get_certificate_policies, @function
x509_get_certificate_policies:
.LVL40:
.LFB57:
	.loc 1 790 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 790 1 is_stmt 0 view .LVU128
	pushq	%r15
.LCFI19:
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
.LCFI20:
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
.LCFI21:
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
.LCFI22:
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
.LCFI23:
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
.LCFI24:
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$56, %rsp
.LCFI25:
	.cfi_def_cfa_offset 112
	movq	%rdi, %rbx
	movq	%rsi, %r15
	movq	%rdx, %rbp
	.loc 1 791 5 is_stmt 1 view .LVU129
.LVL41:
	.loc 1 792 5 view .LVU130
	.loc 1 793 5 view .LVU131
	.loc 1 794 5 view .LVU132
	.loc 1 797 5 view .LVU133
	.loc 1 797 11 is_stmt 0 view .LVU134
	leaq	40(%rsp), %rdx
.LVL42:
	.loc 1 797 11 view .LVU135
	movl	$48, %ecx
	call	mbedtls_asn1_get_tag@PLT
.LVL43:
	.loc 1 797 11 view .LVU136
	movl	%eax, 12(%rsp)
.LVL44:
	.loc 1 799 5 is_stmt 1 view .LVU137
	.loc 1 799 7 is_stmt 0 view .LVU138
	testl	%eax, %eax
	jne	.L58
	.loc 1 802 5 is_stmt 1 view .LVU139
	.loc 1 802 12 is_stmt 0 view .LVU140
	movq	40(%rsp), %rax
.LVL45:
	.loc 1 802 12 view .LVU141
	movq	%rax, %rdx
	addq	(%rbx), %rdx
	.loc 1 802 7 view .LVU142
	cmpq	%r15, %rdx
	jne	.L50
	.loc 1 809 5 is_stmt 1 view .LVU143
	.loc 1 809 7 is_stmt 0 view .LVU144
	testq	%rax, %rax
	jne	.L41
	.loc 1 810 17 view .LVU145
	movl	$-9574, 12(%rsp)
.LVL46:
	.loc 1 810 17 view .LVU146
	jmp	.L38
.LVL47:
.L58:
	.loc 1 800 9 is_stmt 1 view .LVU147
.LBB115:
.LBI115:
	.loc 2 156 19 view .LVU148
.LBB116:
	.loc 2 163 5 view .LVU149
	.loc 2 164 5 view .LVU150
	.loc 2 166 5 view .LVU151
	.loc 2 166 18 is_stmt 0 view .LVU152
	subl	$9472, 12(%rsp)
.LVL48:
.L38:
	.loc 2 166 18 view .LVU153
.LBE116:
.LBE115:
	.loc 1 897 1 view .LVU154
	movl	12(%rsp), %eax
	addq	$56, %rsp
.LCFI26:
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
.LCFI27:
	.cfi_def_cfa_offset 48
.LVL49:
	.loc 1 897 1 view .LVU155
	popq	%rbp
.LCFI28:
	.cfi_def_cfa_offset 40
.LVL50:
	.loc 1 897 1 view .LVU156
	popq	%r12
.LCFI29:
	.cfi_def_cfa_offset 32
	popq	%r13
.LCFI30:
	.cfi_def_cfa_offset 24
	popq	%r14
.LCFI31:
	.cfi_def_cfa_offset 16
	popq	%r15
.LCFI32:
	.cfi_def_cfa_offset 8
.LVL51:
	.loc 1 897 1 view .LVU157
	ret
.LVL52:
.L62:
.LCFI33:
	.cfi_restore_state
.LBB117:
	.loc 1 823 13 is_stmt 1 view .LVU158
.LBB118:
.LBI118:
	.loc 2 156 19 view .LVU159
.LBB119:
	.loc 2 163 5 view .LVU160
	.loc 2 164 5 view .LVU161
	.loc 2 166 5 view .LVU162
	.loc 2 166 18 is_stmt 0 view .LVU163
	subl	$9472, %eax
.LVL53:
	.loc 2 166 18 view .LVU164
	movl	%eax, 12(%rsp)
.LVL54:
	.loc 2 166 18 view .LVU165
.LBE119:
.LBE118:
	.loc 1 823 21 view .LVU166
	jmp	.L38
.LVL55:
.L63:
	.loc 1 829 13 is_stmt 1 view .LVU167
.LBB120:
.LBI120:
	.loc 2 156 19 view .LVU168
.LBB121:
	.loc 2 163 5 view .LVU169
	.loc 2 164 5 view .LVU170
	.loc 2 166 5 view .LVU171
	.loc 2 166 18 is_stmt 0 view .LVU172
	subl	$9472, %eax
.LVL56:
	.loc 2 166 18 view .LVU173
	movl	%eax, 12(%rsp)
.LVL57:
	.loc 2 166 18 view .LVU174
.LBE121:
.LBE120:
	.loc 1 829 21 view .LVU175
	jmp	.L38
.LVL58:
.L64:
	.loc 1 838 13 discriminator 2 view .LVU176
	movq	%r13, %rdx
	movq	%r14, %rsi
	leaq	.LC0(%rip), %rdi
	call	memcmp@PLT
.LVL59:
	.loc 1 838 13 discriminator 2 view .LVU177
	testl	%eax, %eax
	je	.L45
	.loc 1 844 23 view .LVU178
	movl	$-8320, 12(%rsp)
.LVL60:
.L45:
	.loc 1 848 9 is_stmt 1 view .LVU179
	.loc 1 848 11 is_stmt 0 view .LVU180
	cmpq	$0, 16(%rbp)
	je	.L46
	.loc 1 850 13 is_stmt 1 view .LVU181
	.loc 1 850 15 is_stmt 0 view .LVU182
	cmpq	$0, 24(%rbp)
	jne	.L53
	.loc 1 853 13 is_stmt 1 view .LVU183
	.loc 1 853 25 is_stmt 0 view .LVU184
	movl	$32, %esi
	movl	$1, %edi
	call	calloc@PLT
.LVL61:
	.loc 1 853 23 view .LVU185
	movq	%rax, 24(%rbp)
	.loc 1 855 13 is_stmt 1 view .LVU186
	.loc 1 855 15 is_stmt 0 view .LVU187
	testq	%rax, %rax
	je	.L54
	.loc 1 859 17 view .LVU188
	movq	%rax, %rbp
.LVL62:
.L46:
	.loc 1 862 9 is_stmt 1 view .LVU189
	.loc 1 863 9 view .LVU190
	.loc 1 863 18 is_stmt 0 view .LVU191
	movl	$6, 0(%rbp)
	.loc 1 864 9 is_stmt 1 view .LVU192
	.loc 1 864 16 is_stmt 0 view .LVU193
	movq	%r14, 16(%rbp)
	.loc 1 865 9 is_stmt 1 view .LVU194
	.loc 1 865 18 is_stmt 0 view .LVU195
	movq	%r13, 8(%rbp)
	.loc 1 867 9 is_stmt 1 view .LVU196
	.loc 1 867 12 is_stmt 0 view .LVU197
	movq	40(%rsp), %rax
	addq	(%rbx), %rax
	movq	%rax, (%rbx)
	.loc 1 873 9 is_stmt 1 view .LVU198
	.loc 1 873 11 is_stmt 0 view .LVU199
	cmpq	%r12, %rax
	jb	.L59
.LVL63:
.L47:
	.loc 1 884 9 is_stmt 1 view .LVU200
	.loc 1 884 11 is_stmt 0 view .LVU201
	cmpq	%r12, (%rbx)
	jne	.L60
.LVL64:
.L41:
	.loc 1 884 11 view .LVU202
.LBE117:
	.loc 1 813 15 is_stmt 1 view .LVU203
	cmpq	%r15, (%rbx)
	jnb	.L61
.LBB124:
	.loc 1 815 9 view .LVU204
	.loc 1 816 9 view .LVU205
	.loc 1 821 9 view .LVU206
	.loc 1 821 21 is_stmt 0 view .LVU207
	leaq	40(%rsp), %rdx
	movl	$48, %ecx
	movq	%r15, %rsi
	movq	%rbx, %rdi
	call	mbedtls_asn1_get_tag@PLT
.LVL65:
	.loc 1 821 11 view .LVU208
	testl	%eax, %eax
	jne	.L62
	.loc 1 825 9 is_stmt 1 view .LVU209
	.loc 1 825 25 is_stmt 0 view .LVU210
	movq	40(%rsp), %r12
	.loc 1 825 20 view .LVU211
	addq	(%rbx), %r12
.LVL66:
	.loc 1 827 9 is_stmt 1 view .LVU212
	.loc 1 827 21 is_stmt 0 view .LVU213
	leaq	40(%rsp), %rdx
	movl	$6, %ecx
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	mbedtls_asn1_get_tag@PLT
.LVL67:
	.loc 1 827 11 view .LVU214
	testl	%eax, %eax
	jne	.L63
	.loc 1 831 9 is_stmt 1 view .LVU215
	.loc 1 831 24 is_stmt 0 view .LVU216
	movl	$6, 16(%rsp)
	.loc 1 832 9 is_stmt 1 view .LVU217
	.loc 1 832 24 is_stmt 0 view .LVU218
	movq	40(%rsp), %r13
	movq	%r13, 24(%rsp)
	.loc 1 833 9 is_stmt 1 view .LVU219
	.loc 1 833 24 is_stmt 0 view .LVU220
	movq	(%rbx), %r14
	.loc 1 833 22 view .LVU221
	movq	%r14, 32(%rsp)
	.loc 1 838 9 is_stmt 1 view .LVU222
	.loc 1 838 13 is_stmt 0 view .LVU223
	cmpq	$4, %r13
	je	.L64
	.loc 1 844 23 view .LVU224
	movl	$-8320, 12(%rsp)
.LVL68:
	.loc 1 844 23 view .LVU225
	jmp	.L45
.LVL69:
.L59:
	.loc 1 875 13 is_stmt 1 view .LVU226
	.loc 1 875 25 is_stmt 0 view .LVU227
	leaq	40(%rsp), %rdx
	movl	$48, %ecx
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	mbedtls_asn1_get_tag@PLT
.LVL70:
	.loc 1 875 15 view .LVU228
	testl	%eax, %eax
	jne	.L65
	.loc 1 881 13 is_stmt 1 view .LVU229
	.loc 1 881 16 is_stmt 0 view .LVU230
	movq	40(%rsp), %rax
.LVL71:
	.loc 1 881 16 view .LVU231
	addq	%rax, (%rbx)
	jmp	.L47
.LVL72:
.L65:
	.loc 1 877 17 is_stmt 1 view .LVU232
.LBB122:
.LBI122:
	.loc 2 156 19 view .LVU233
.LBB123:
	.loc 2 163 5 view .LVU234
	.loc 2 164 5 view .LVU235
	.loc 2 166 5 view .LVU236
	.loc 2 166 18 is_stmt 0 view .LVU237
	subl	$9472, %eax
.LVL73:
	.loc 2 166 18 view .LVU238
	movl	%eax, 12(%rsp)
.LVL74:
	.loc 2 166 18 view .LVU239
.LBE123:
.LBE122:
	.loc 1 877 25 view .LVU240
	jmp	.L38
.LVL75:
.L53:
	.loc 1 851 23 view .LVU241
	movl	$-9472, 12(%rsp)
.LVL76:
	.loc 1 851 23 view .LVU242
	jmp	.L38
.LVL77:
.L54:
	.loc 1 856 25 view .LVU243
	movl	$-9578, 12(%rsp)
.LVL78:
	.loc 1 856 25 view .LVU244
	jmp	.L38
.LVL79:
.L60:
	.loc 1 885 21 view .LVU245
	movl	$-9574, 12(%rsp)
.LVL80:
	.loc 1 885 21 view .LVU246
	jmp	.L38
.LVL81:
.L61:
	.loc 1 885 21 view .LVU247
.LBE124:
	.loc 1 890 5 is_stmt 1 view .LVU248
	.loc 1 890 15 is_stmt 0 view .LVU249
	movq	$0, 24(%rbp)
	.loc 1 892 5 is_stmt 1 view .LVU250
	.loc 1 892 7 is_stmt 0 view .LVU251
	cmpq	%r15, (%rbx)
	je	.L38
	.loc 1 893 17 view .LVU252
	movl	$-9574, 12(%rsp)
.LVL82:
	.loc 1 893 17 view .LVU253
	jmp	.L38
.LVL83:
.L50:
	.loc 1 803 17 view .LVU254
	movl	$-9574, 12(%rsp)
.LVL84:
	.loc 1 803 17 view .LVU255
	jmp	.L38
	.cfi_endproc
.LFE57:
	.size	x509_get_certificate_policies, .-x509_get_certificate_policies
	.type	x509_string_cmp, @function
x509_string_cmp:
.LVL85:
.LFB46:
	.loc 1 320 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 320 1 is_stmt 0 view .LVU257
	pushq	%r13
.LCFI34:
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
.LCFI35:
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
.LCFI36:
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
.LCFI37:
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$8, %rsp
.LCFI38:
	.cfi_def_cfa_offset 48
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	.loc 1 321 5 is_stmt 1 view .LVU258
	.loc 1 321 10 is_stmt 0 view .LVU259
	movl	(%rdi), %r12d
	.loc 1 321 20 view .LVU260
	movl	(%rsi), %r13d
	.loc 1 321 7 view .LVU261
	cmpl	%r13d, %r12d
	je	.L73
.LVL86:
.L67:
	.loc 1 328 5 is_stmt 1 view .LVU262
	.loc 1 328 46 is_stmt 0 view .LVU263
	cmpl	$12, %r12d
	sete	%al
	cmpl	$19, %r12d
	sete	%dl
	.loc 1 328 7 view .LVU264
	orb	%dl, %al
	je	.L69
	.loc 1 329 46 discriminator 1 view .LVU265
	cmpl	$12, %r13d
	sete	%al
	cmpl	$19, %r13d
	sete	%dl
	.loc 1 328 91 discriminator 1 view .LVU266
	orb	%dl, %al
	je	.L70
	.loc 1 330 20 view .LVU267
	movq	8(%rbp), %rdx
	.loc 1 329 91 view .LVU268
	cmpq	%rdx, 8(%rbx)
	jne	.L71
	.loc 1 331 33 view .LVU269
	movq	16(%rbp), %rsi
	.loc 1 331 27 view .LVU270
	movq	16(%rbx), %rdi
	.loc 1 331 9 view .LVU271
	call	x509_memcasecmp
.LVL87:
	.loc 1 330 26 view .LVU272
	testl	%eax, %eax
	jne	.L74
.L66:
	.loc 1 337 1 view .LVU273
	addq	$8, %rsp
.LCFI39:
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
.LCFI40:
	.cfi_def_cfa_offset 32
.LVL88:
	.loc 1 337 1 view .LVU274
	popq	%rbp
.LCFI41:
	.cfi_def_cfa_offset 24
.LVL89:
	.loc 1 337 1 view .LVU275
	popq	%r12
.LCFI42:
	.cfi_def_cfa_offset 16
	popq	%r13
.LCFI43:
	.cfi_def_cfa_offset 8
	ret
.LVL90:
.L73:
.LCFI44:
	.cfi_restore_state
	.loc 1 322 20 discriminator 1 view .LVU276
	movq	8(%rsi), %rdx
	.loc 1 321 26 discriminator 1 view .LVU277
	cmpq	%rdx, 8(%rdi)
	jne	.L67
	.loc 1 323 24 view .LVU278
	movq	16(%rsi), %rsi
.LVL91:
	.loc 1 323 18 view .LVU279
	movq	16(%rdi), %rdi
	.loc 1 323 9 view .LVU280
	call	memcmp@PLT
.LVL92:
	.loc 1 322 26 view .LVU281
	testl	%eax, %eax
	jne	.L67
	jmp	.L66
.L74:
	.loc 1 336 11 view .LVU282
	movl	$-1, %eax
	jmp	.L66
.L69:
	.loc 1 336 11 view .LVU283
	movl	$-1, %eax
	jmp	.L66
.L70:
	movl	$-1, %eax
	jmp	.L66
.L71:
	.loc 1 336 11 view .LVU284
	movl	$-1, %eax
	jmp	.L66
	.cfi_endproc
.LFE46:
	.size	x509_string_cmp, .-x509_string_cmp
	.type	x509_name_cmp, @function
x509_name_cmp:
.LVL93:
.LFB47:
	.loc 1 350 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 350 1 is_stmt 0 view .LVU286
	pushq	%rbp
.LCFI45:
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
.LCFI46:
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
.LCFI47:
	.cfi_def_cfa_offset 32
	movq	%rdi, %rbp
	movq	%rsi, %rbx
	.loc 1 352 5 is_stmt 1 view .LVU287
	.loc 1 352 10 is_stmt 0 view .LVU288
	jmp	.L76
.LVL94:
.L78:
	.loc 1 354 9 is_stmt 1 view .LVU289
	.loc 1 354 15 is_stmt 0 view .LVU290
	testq	%rbp, %rbp
	sete	%al
	.loc 1 354 28 view .LVU291
	testq	%rbx, %rbx
	sete	%dl
	.loc 1 354 11 view .LVU292
	orb	%dl, %al
	jne	.L79
	.loc 1 358 9 is_stmt 1 view .LVU293
	.loc 1 358 11 is_stmt 0 view .LVU294
	movl	(%rbx), %eax
	cmpl	%eax, 0(%rbp)
	jne	.L80
	.loc 1 359 33 discriminator 1 view .LVU295
	movq	8(%rbx), %rdx
	.loc 1 358 38 discriminator 1 view .LVU296
	cmpq	%rdx, 8(%rbp)
	jne	.L81
	.loc 1 360 37 view .LVU297
	movq	16(%rbx), %rsi
	.loc 1 360 27 view .LVU298
	movq	16(%rbp), %rdi
	.loc 1 360 13 view .LVU299
	call	memcmp@PLT
.LVL95:
	.loc 1 359 38 view .LVU300
	testl	%eax, %eax
	jne	.L82
	.loc 1 366 9 is_stmt 1 view .LVU301
	.loc 1 366 39 is_stmt 0 view .LVU302
	leaq	24(%rbx), %rsi
	.loc 1 366 30 view .LVU303
	leaq	24(%rbp), %rdi
	.loc 1 366 13 view .LVU304
	call	x509_string_cmp
.LVL96:
	.loc 1 366 11 view .LVU305
	testl	%eax, %eax
	jne	.L83
	.loc 1 370 9 is_stmt 1 view .LVU306
	.loc 1 370 11 is_stmt 0 view .LVU307
	movzbl	56(%rbx), %eax
	cmpb	%al, 56(%rbp)
	jne	.L84
	.loc 1 373 9 is_stmt 1 view .LVU308
	.loc 1 373 11 is_stmt 0 view .LVU309
	movq	48(%rbp), %rbp
.LVL97:
	.loc 1 374 9 is_stmt 1 view .LVU310
	.loc 1 374 11 is_stmt 0 view .LVU311
	movq	48(%rbx), %rbx
.LVL98:
.L76:
	.loc 1 352 22 is_stmt 1 view .LVU312
	.loc 1 352 14 is_stmt 0 view .LVU313
	testq	%rbp, %rbp
	setne	%al
	.loc 1 352 27 view .LVU314
	testq	%rbx, %rbx
	setne	%dl
	.loc 1 352 22 view .LVU315
	testb	%al, %al
	jne	.L78
	.loc 1 352 22 view .LVU316
	testb	%dl, %dl
	jne	.L78
	.loc 1 378 11 view .LVU317
	movl	$0, %eax
.L75:
	.loc 1 379 1 view .LVU318
	addq	$8, %rsp
.LCFI48:
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
.LCFI49:
	.cfi_def_cfa_offset 16
.LVL99:
	.loc 1 379 1 view .LVU319
	popq	%rbp
.LCFI50:
	.cfi_def_cfa_offset 8
.LVL100:
	.loc 1 379 1 view .LVU320
	ret
.LVL101:
.L79:
.LCFI51:
	.cfi_restore_state
	.loc 1 355 19 view .LVU321
	movl	$-1, %eax
	jmp	.L75
.L80:
	.loc 1 362 19 view .LVU322
	movl	$-1, %eax
	jmp	.L75
.L81:
	movl	$-1, %eax
	jmp	.L75
.L82:
	movl	$-1, %eax
	jmp	.L75
.L83:
	.loc 1 367 19 view .LVU323
	movl	$-1, %eax
	jmp	.L75
.L84:
	.loc 1 371 19 view .LVU324
	movl	$-1, %eax
	jmp	.L75
	.cfi_endproc
.LFE47:
	.size	x509_name_cmp, .-x509_name_cmp
	.type	x509_crt_check_ee_locally_trusted, @function
x509_crt_check_ee_locally_trusted:
.LVL102:
.LFB84:
	.loc 1 2744 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 2744 1 is_stmt 0 view .LVU326
	pushq	%rbp
.LCFI52:
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
.LCFI53:
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
.LCFI54:
	.cfi_def_cfa_offset 32
	movq	%rdi, %rbp
	movq	%rsi, %rbx
	.loc 1 2745 5 is_stmt 1 view .LVU327
	.loc 1 2748 5 view .LVU328
	.loc 1 2748 38 is_stmt 0 view .LVU329
	leaq	224(%rdi), %rsi
.LVL103:
	.loc 1 2748 24 view .LVU330
	leaq	160(%rdi), %rdi
.LVL104:
	.loc 1 2748 9 view .LVU331
	call	x509_name_cmp
.LVL105:
	.loc 1 2748 7 view .LVU332
	testl	%eax, %eax
	je	.L88
	.loc 1 2749 15 view .LVU333
	movl	$-1, %edx
	jmp	.L86
.LVL106:
.L89:
	.loc 1 2752 43 is_stmt 1 discriminator 2 view .LVU334
	movq	608(%rbx), %rbx
.LVL107:
.L88:
	.loc 1 2752 30 discriminator 1 view .LVU335
	testq	%rbx, %rbx
	je	.L93
	.loc 1 2754 9 view .LVU336
	.loc 1 2754 21 is_stmt 0 view .LVU337
	movq	16(%rbp), %rdx
	.loc 1 2754 11 view .LVU338
	cmpq	16(%rbx), %rdx
	jne	.L89
	.loc 1 2755 41 discriminator 1 view .LVU339
	movq	24(%rbx), %rsi
	.loc 1 2755 29 discriminator 1 view .LVU340
	movq	24(%rbp), %rdi
	.loc 1 2755 13 discriminator 1 view .LVU341
	call	memcmp@PLT
.LVL108:
	movl	%eax, %edx
	.loc 1 2754 42 discriminator 1 view .LVU342
	testl	%eax, %eax
	jne	.L89
	jmp	.L86
.L93:
	.loc 1 2762 11 view .LVU343
	movl	$-1, %edx
.LVL109:
.L86:
	.loc 1 2763 1 view .LVU344
	movl	%edx, %eax
	addq	$8, %rsp
.LCFI55:
	.cfi_def_cfa_offset 24
	popq	%rbx
.LCFI56:
	.cfi_def_cfa_offset 16
	popq	%rbp
.LCFI57:
	.cfi_def_cfa_offset 8
.LVL110:
	.loc 1 2763 1 view .LVU345
	ret
	.cfi_endproc
.LFE84:
	.size	x509_crt_check_ee_locally_trusted, .-x509_crt_check_ee_locally_trusted
	.type	x509_get_version, @function
x509_get_version:
.LVL111:
.LFB49:
	.loc 1 408 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 408 1 is_stmt 0 view .LVU347
	pushq	%r12
.LCFI58:
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
.LCFI59:
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
.LCFI60:
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	subq	$16, %rsp
.LCFI61:
	.cfi_def_cfa_offset 48
	movq	%rdi, %rbx
	movq	%rdx, %rbp
	.loc 1 409 5 is_stmt 1 view .LVU348
.LVL112:
	.loc 1 410 5 view .LVU349
	.loc 1 412 5 view .LVU350
	.loc 1 412 17 is_stmt 0 view .LVU351
	leaq	8(%rsp), %rdx
.LVL113:
	.loc 1 412 17 view .LVU352
	movl	$160, %ecx
	call	mbedtls_asn1_get_tag@PLT
.LVL114:
	.loc 1 412 7 view .LVU353
	testl	%eax, %eax
	je	.L95
	.loc 1 415 9 is_stmt 1 view .LVU354
	.loc 1 415 11 is_stmt 0 view .LVU355
	cmpl	$-98, %eax
	je	.L101
	.loc 1 421 9 is_stmt 1 view .LVU356
.LVL115:
.LBB125:
.LBI125:
	.loc 2 156 19 view .LVU357
.LBB126:
	.loc 2 163 5 view .LVU358
	.loc 2 164 5 view .LVU359
	.loc 2 166 5 view .LVU360
	.loc 2 166 18 is_stmt 0 view .LVU361
	subl	$8576, %eax
.LVL116:
.L94:
	.loc 2 166 18 view .LVU362
.LBE126:
.LBE125:
	.loc 1 434 1 view .LVU363
	addq	$16, %rsp
.LCFI62:
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
.LCFI63:
	.cfi_def_cfa_offset 24
.LVL117:
	.loc 1 434 1 view .LVU364
	popq	%rbp
.LCFI64:
	.cfi_def_cfa_offset 16
.LVL118:
	.loc 1 434 1 view .LVU365
	popq	%r12
.LCFI65:
	.cfi_def_cfa_offset 8
	ret
.LVL119:
.L101:
.LCFI66:
	.cfi_restore_state
	.loc 1 417 13 is_stmt 1 view .LVU366
	.loc 1 417 18 is_stmt 0 view .LVU367
	movl	$0, 0(%rbp)
	.loc 1 418 13 is_stmt 1 view .LVU368
	.loc 1 418 19 is_stmt 0 view .LVU369
	movl	$0, %eax
.LVL120:
	.loc 1 418 19 view .LVU370
	jmp	.L94
.LVL121:
.L95:
	.loc 1 424 5 is_stmt 1 view .LVU371
	.loc 1 424 14 is_stmt 0 view .LVU372
	movq	8(%rsp), %r12
	.loc 1 424 9 view .LVU373
	addq	(%rbx), %r12
.LVL122:
	.loc 1 426 5 is_stmt 1 view .LVU374
	.loc 1 426 17 is_stmt 0 view .LVU375
	movq	%rbp, %rdx
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	mbedtls_asn1_get_int@PLT
.LVL123:
	.loc 1 426 7 view .LVU376
	testl	%eax, %eax
	jne	.L102
	.loc 1 429 5 is_stmt 1 view .LVU377
	.loc 1 429 7 is_stmt 0 view .LVU378
	cmpq	%r12, (%rbx)
	je	.L94
	.loc 1 430 17 view .LVU379
	movl	$-8806, %eax
.LVL124:
	.loc 1 430 17 view .LVU380
	jmp	.L94
.LVL125:
.L102:
	.loc 1 427 9 is_stmt 1 view .LVU381
.LBB127:
.LBI127:
	.loc 2 156 19 view .LVU382
.LBB128:
	.loc 2 163 5 view .LVU383
	.loc 2 164 5 view .LVU384
	.loc 2 166 5 view .LVU385
	.loc 2 166 18 is_stmt 0 view .LVU386
	subl	$8704, %eax
.LVL126:
	.loc 2 166 18 view .LVU387
.LBE128:
.LBE127:
	.loc 1 427 17 view .LVU388
	jmp	.L94
	.cfi_endproc
.LFE49:
	.size	x509_get_version, .-x509_get_version
	.type	x509_get_dates, @function
x509_get_dates:
.LVL127:
.LFB50:
	.loc 1 445 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 445 1 is_stmt 0 view .LVU390
	pushq	%r13
.LCFI67:
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
.LCFI68:
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
.LCFI69:
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
.LCFI70:
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$24, %rsp
.LCFI71:
	.cfi_def_cfa_offset 64
	movq	%rdi, %rbx
	movq	%rdx, %r13
	movq	%rcx, %rbp
	.loc 1 446 5 is_stmt 1 view .LVU391
.LVL128:
	.loc 1 447 5 view .LVU392
	.loc 1 449 5 view .LVU393
	.loc 1 449 17 is_stmt 0 view .LVU394
	leaq	8(%rsp), %rdx
.LVL129:
	.loc 1 449 17 view .LVU395
	movl	$48, %ecx
.LVL130:
	.loc 1 449 17 view .LVU396
	call	mbedtls_asn1_get_tag@PLT
.LVL131:
	.loc 1 449 7 view .LVU397
	testl	%eax, %eax
	je	.L104
	.loc 1 451 9 is_stmt 1 view .LVU398
.LVL132:
.LBB129:
.LBI129:
	.loc 2 156 19 view .LVU399
.LBB130:
	.loc 2 163 5 view .LVU400
	.loc 2 164 5 view .LVU401
	.loc 2 166 5 view .LVU402
	.loc 2 166 18 is_stmt 0 view .LVU403
	subl	$9216, %eax
.LVL133:
.L103:
	.loc 2 166 18 view .LVU404
.LBE130:
.LBE129:
	.loc 1 466 1 view .LVU405
	addq	$24, %rsp
.LCFI72:
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
.LCFI73:
	.cfi_def_cfa_offset 32
.LVL134:
	.loc 1 466 1 view .LVU406
	popq	%rbp
.LCFI74:
	.cfi_def_cfa_offset 24
.LVL135:
	.loc 1 466 1 view .LVU407
	popq	%r12
.LCFI75:
	.cfi_def_cfa_offset 16
	popq	%r13
.LCFI76:
	.cfi_def_cfa_offset 8
.LVL136:
	.loc 1 466 1 view .LVU408
	ret
.LVL137:
.L104:
.LCFI77:
	.cfi_restore_state
	.loc 1 453 5 is_stmt 1 view .LVU409
	.loc 1 453 14 is_stmt 0 view .LVU410
	movq	8(%rsp), %r12
	.loc 1 453 9 view .LVU411
	addq	(%rbx), %r12
.LVL138:
	.loc 1 455 5 is_stmt 1 view .LVU412
	.loc 1 455 17 is_stmt 0 view .LVU413
	movq	%r13, %rdx
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	mbedtls_x509_get_time@PLT
.LVL139:
	.loc 1 455 7 view .LVU414
	testl	%eax, %eax
	jne	.L103
	.loc 1 458 5 is_stmt 1 view .LVU415
	.loc 1 458 17 is_stmt 0 view .LVU416
	movq	%rbp, %rdx
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	mbedtls_x509_get_time@PLT
.LVL140:
	.loc 1 458 7 view .LVU417
	testl	%eax, %eax
	jne	.L103
	.loc 1 461 5 is_stmt 1 view .LVU418
	.loc 1 461 7 is_stmt 0 view .LVU419
	cmpq	%r12, (%rbx)
	je	.L103
	.loc 1 462 17 view .LVU420
	movl	$-9318, %eax
.LVL141:
	.loc 1 462 17 view .LVU421
	jmp	.L103
	.cfi_endproc
.LFE50:
	.size	x509_get_dates, .-x509_get_dates
	.type	x509_get_basic_constraints, @function
x509_get_basic_constraints:
.LVL142:
.LFB52:
	.loc 1 501 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 501 1 is_stmt 0 view .LVU423
	pushq	%r14
.LCFI78:
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
.LCFI79:
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
.LCFI80:
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
.LCFI81:
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
.LCFI82:
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$16, %rsp
.LCFI83:
	.cfi_def_cfa_offset 64
	movq	%rdi, %r12
	movq	%rsi, %rbp
	movq	%rdx, %r13
	movq	%rcx, %r14
	.loc 1 502 5 is_stmt 1 view .LVU424
.LVL143:
	.loc 1 503 5 view .LVU425
	.loc 1 510 5 view .LVU426
	.loc 1 510 16 is_stmt 0 view .LVU427
	movl	$0, (%rdx)
	.loc 1 511 5 is_stmt 1 view .LVU428
	.loc 1 511 18 is_stmt 0 view .LVU429
	movl	$0, (%rcx)
	.loc 1 513 5 is_stmt 1 view .LVU430
	.loc 1 513 17 is_stmt 0 view .LVU431
	leaq	8(%rsp), %rdx
.LVL144:
	.loc 1 513 17 view .LVU432
	movl	$48, %ecx
.LVL145:
	.loc 1 513 17 view .LVU433
	call	mbedtls_asn1_get_tag@PLT
.LVL146:
	.loc 1 513 17 view .LVU434
	movl	%eax, %ebx
.LVL147:
	.loc 1 513 7 view .LVU435
	testl	%eax, %eax
	jne	.L118
	.loc 1 517 5 is_stmt 1 view .LVU436
	.loc 1 517 7 is_stmt 0 view .LVU437
	cmpq	%rbp, (%r12)
	je	.L108
	.loc 1 520 5 is_stmt 1 view .LVU438
	.loc 1 520 17 is_stmt 0 view .LVU439
	movq	%r13, %rdx
	movq	%rbp, %rsi
	movq	%r12, %rdi
	call	mbedtls_asn1_get_bool@PLT
.LVL148:
	.loc 1 520 7 view .LVU440
	testl	%eax, %eax
	je	.L111
	.loc 1 522 9 is_stmt 1 view .LVU441
	.loc 1 522 11 is_stmt 0 view .LVU442
	cmpl	$-98, %eax
	je	.L119
.L112:
	.loc 1 525 9 is_stmt 1 view .LVU443
	.loc 1 525 11 is_stmt 0 view .LVU444
	testl	%eax, %eax
	jne	.L120
	.loc 1 528 9 is_stmt 1 view .LVU445
	.loc 1 528 11 is_stmt 0 view .LVU446
	cmpl	$0, 0(%r13)
	je	.L111
	.loc 1 529 13 is_stmt 1 view .LVU447
	.loc 1 529 24 is_stmt 0 view .LVU448
	movl	$1, 0(%r13)
.L111:
	.loc 1 532 5 is_stmt 1 view .LVU449
	.loc 1 532 7 is_stmt 0 view .LVU450
	cmpq	%rbp, (%r12)
	je	.L108
	.loc 1 535 5 is_stmt 1 view .LVU451
	.loc 1 535 17 is_stmt 0 view .LVU452
	movq	%r14, %rdx
	movq	%rbp, %rsi
	movq	%r12, %rdi
	call	mbedtls_asn1_get_int@PLT
.LVL149:
	.loc 1 535 17 view .LVU453
	movl	%eax, %ebx
.LVL150:
	.loc 1 535 7 view .LVU454
	testl	%eax, %eax
	jne	.L121
	.loc 1 538 5 is_stmt 1 view .LVU455
	.loc 1 538 7 is_stmt 0 view .LVU456
	cmpq	%rbp, (%r12)
	jne	.L115
	.loc 1 544 5 is_stmt 1 view .LVU457
	.loc 1 544 9 is_stmt 0 view .LVU458
	movl	(%r14), %eax
.LVL151:
	.loc 1 544 7 view .LVU459
	cmpl	$2147483647, %eax
	je	.L116
	.loc 1 548 5 is_stmt 1 view .LVU460
	.loc 1 548 19 is_stmt 0 view .LVU461
	addl	$1, %eax
	movl	%eax, (%r14)
	.loc 1 550 5 is_stmt 1 view .LVU462
	.loc 1 550 11 is_stmt 0 view .LVU463
	jmp	.L108
.LVL152:
.L118:
	.loc 1 515 9 is_stmt 1 view .LVU464
.LBB131:
.LBI131:
	.loc 2 156 19 view .LVU465
.LBB132:
	.loc 2 163 5 view .LVU466
	.loc 2 164 5 view .LVU467
	.loc 2 166 5 view .LVU468
	.loc 2 166 18 is_stmt 0 view .LVU469
	subl	$9472, %ebx
.LVL153:
.L108:
	.loc 2 166 18 view .LVU470
.LBE132:
.LBE131:
	.loc 1 551 1 view .LVU471
	movl	%ebx, %eax
	addq	$16, %rsp
.LCFI84:
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx
.LCFI85:
	.cfi_def_cfa_offset 40
	popq	%rbp
.LCFI86:
	.cfi_def_cfa_offset 32
.LVL154:
	.loc 1 551 1 view .LVU472
	popq	%r12
.LCFI87:
	.cfi_def_cfa_offset 24
.LVL155:
	.loc 1 551 1 view .LVU473
	popq	%r13
.LCFI88:
	.cfi_def_cfa_offset 16
.LVL156:
	.loc 1 551 1 view .LVU474
	popq	%r14
.LCFI89:
	.cfi_def_cfa_offset 8
.LVL157:
	.loc 1 551 1 view .LVU475
	ret
.LVL158:
.L119:
.LCFI90:
	.cfi_restore_state
	.loc 1 523 13 is_stmt 1 view .LVU476
	.loc 1 523 19 is_stmt 0 view .LVU477
	movq	%r13, %rdx
	movq	%rbp, %rsi
	movq	%r12, %rdi
	call	mbedtls_asn1_get_int@PLT
.LVL159:
	.loc 1 523 19 view .LVU478
	jmp	.L112
.L120:
	.loc 1 526 13 is_stmt 1 view .LVU479
.LVL160:
.LBB133:
.LBI133:
	.loc 2 156 19 view .LVU480
.LBB134:
	.loc 2 163 5 view .LVU481
	.loc 2 164 5 view .LVU482
	.loc 2 166 5 view .LVU483
	.loc 2 166 18 is_stmt 0 view .LVU484
	leal	-9472(%rax), %ebx
.LVL161:
	.loc 2 166 18 view .LVU485
.LBE134:
.LBE133:
	.loc 1 526 21 view .LVU486
	jmp	.L108
.L121:
	.loc 1 536 9 is_stmt 1 view .LVU487
.LVL162:
.LBB135:
.LBI135:
	.loc 2 156 19 view .LVU488
.LBB136:
	.loc 2 163 5 view .LVU489
	.loc 2 164 5 view .LVU490
	.loc 2 166 5 view .LVU491
	.loc 2 166 18 is_stmt 0 view .LVU492
	subl	$9472, %ebx
.LVL163:
	.loc 2 166 18 view .LVU493
.LBE136:
.LBE135:
	.loc 1 536 17 view .LVU494
	jmp	.L108
.L115:
	.loc 1 539 17 view .LVU495
	movl	$-9574, %ebx
	jmp	.L108
.LVL164:
.L116:
	.loc 1 545 17 view .LVU496
	movl	$-9572, %ebx
.LVL165:
	.loc 1 545 17 view .LVU497
	jmp	.L108
	.cfi_endproc
.LFE52:
	.size	x509_get_basic_constraints, .-x509_get_basic_constraints
	.type	x509_get_key_usage, @function
x509_get_key_usage:
.LVL166:
.LFB54:
	.loc 1 575 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 575 1 is_stmt 0 view .LVU499
	pushq	%rbx
.LCFI91:
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp
.LCFI92:
	.cfi_def_cfa_offset 48
	movq	%rdx, %rbx
	.loc 1 576 5 is_stmt 1 view .LVU500
.LVL167:
	.loc 1 577 5 view .LVU501
	.loc 1 578 5 view .LVU502
	.loc 1 578 28 is_stmt 0 view .LVU503
	movq	$0, (%rsp)
	movb	$0, 8(%rsp)
	movq	$0, 16(%rsp)
	.loc 1 580 5 is_stmt 1 view .LVU504
	.loc 1 580 17 is_stmt 0 view .LVU505
	movq	%rsp, %rdx
.LVL168:
	.loc 1 580 17 view .LVU506
	call	mbedtls_asn1_get_bitstring@PLT
.LVL169:
	.loc 1 580 7 view .LVU507
	testl	%eax, %eax
	jne	.L129
	.loc 1 583 5 is_stmt 1 view .LVU508
	.loc 1 583 7 is_stmt 0 view .LVU509
	cmpq	$0, (%rsp)
	je	.L127
	.loc 1 588 5 is_stmt 1 view .LVU510
	.loc 1 588 16 is_stmt 0 view .LVU511
	movl	$0, (%rbx)
	.loc 1 589 5 is_stmt 1 view .LVU512
.LVL170:
	.loc 1 589 12 is_stmt 0 view .LVU513
	movl	$0, %edx
	.loc 1 589 5 view .LVU514
	jmp	.L125
.LVL171:
.L129:
	.loc 1 581 9 is_stmt 1 view .LVU515
.LBB137:
.LBI137:
	.loc 2 156 19 view .LVU516
.LBB138:
	.loc 2 163 5 view .LVU517
	.loc 2 164 5 view .LVU518
	.loc 2 166 5 view .LVU519
	.loc 2 166 18 is_stmt 0 view .LVU520
	subl	$9472, %eax
.LVL172:
	.loc 2 166 18 view .LVU521
.LBE138:
.LBE137:
	.loc 1 581 17 view .LVU522
	jmp	.L122
.LVL173:
.L126:
	.loc 1 591 9 is_stmt 1 discriminator 4 view .LVU523
	.loc 1 591 23 is_stmt 0 discriminator 4 view .LVU524
	movq	16(%rsp), %rcx
	movzbl	(%rcx,%rdx), %esi
	.loc 1 591 46 discriminator 4 view .LVU525
	leal	0(,%rdx,8), %ecx
	sall	%cl, %esi
	.loc 1 591 20 discriminator 4 view .LVU526
	orl	%esi, (%rbx)
	.loc 1 589 60 is_stmt 1 discriminator 4 view .LVU527
	addq	$1, %rdx
.LVL174:
.L125:
	.loc 1 589 28 discriminator 1 view .LVU528
	cmpq	(%rsp), %rdx
	jnb	.L122
	.loc 1 589 28 is_stmt 0 discriminator 3 view .LVU529
	cmpq	$3, %rdx
	jbe	.L126
.LVL175:
.L122:
	.loc 1 595 1 view .LVU530
	addq	$32, %rsp
.LCFI93:
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
.LCFI94:
	.cfi_def_cfa_offset 8
.LVL176:
	.loc 1 595 1 view .LVU531
	ret
.LVL177:
.L127:
.LCFI95:
	.cfi_restore_state
	.loc 1 584 17 view .LVU532
	movl	$-9572, %eax
.LVL178:
	.loc 1 584 17 view .LVU533
	jmp	.L122
	.cfi_endproc
.LFE54:
	.size	x509_get_key_usage, .-x509_get_key_usage
	.type	x509_get_ns_cert_type, @function
x509_get_ns_cert_type:
.LVL179:
.LFB53:
	.loc 1 556 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 556 1 is_stmt 0 view .LVU535
	pushq	%rbx
.LCFI96:
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp
.LCFI97:
	.cfi_def_cfa_offset 48
	movq	%rdx, %rbx
	.loc 1 557 5 is_stmt 1 view .LVU536
.LVL180:
	.loc 1 558 5 view .LVU537
	.loc 1 558 28 is_stmt 0 view .LVU538
	movq	$0, (%rsp)
	movb	$0, 8(%rsp)
	movq	$0, 16(%rsp)
	.loc 1 560 5 is_stmt 1 view .LVU539
	.loc 1 560 17 is_stmt 0 view .LVU540
	movq	%rsp, %rdx
.LVL181:
	.loc 1 560 17 view .LVU541
	call	mbedtls_asn1_get_bitstring@PLT
.LVL182:
	.loc 1 560 7 view .LVU542
	testl	%eax, %eax
	jne	.L135
	.loc 1 563 5 is_stmt 1 view .LVU543
	.loc 1 563 7 is_stmt 0 view .LVU544
	cmpq	$1, (%rsp)
	jne	.L133
	.loc 1 568 5 is_stmt 1 view .LVU545
	.loc 1 568 24 is_stmt 0 view .LVU546
	movq	16(%rsp), %rdx
	.loc 1 568 21 view .LVU547
	movzbl	(%rdx), %edx
	.loc 1 568 19 view .LVU548
	movb	%dl, (%rbx)
	.loc 1 569 5 is_stmt 1 view .LVU549
.LVL183:
.L130:
	.loc 1 570 1 is_stmt 0 view .LVU550
	addq	$32, %rsp
.LCFI98:
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
.LCFI99:
	.cfi_def_cfa_offset 8
.LVL184:
	.loc 1 570 1 view .LVU551
	ret
.LVL185:
.L135:
.LCFI100:
	.cfi_restore_state
	.loc 1 561 9 is_stmt 1 view .LVU552
.LBB139:
.LBI139:
	.loc 2 156 19 view .LVU553
.LBB140:
	.loc 2 163 5 view .LVU554
	.loc 2 164 5 view .LVU555
	.loc 2 166 5 view .LVU556
	.loc 2 166 18 is_stmt 0 view .LVU557
	subl	$9472, %eax
.LVL186:
	.loc 2 166 18 view .LVU558
.LBE140:
.LBE139:
	.loc 1 561 17 view .LVU559
	jmp	.L130
.LVL187:
.L133:
	.loc 1 564 17 view .LVU560
	movl	$-9572, %eax
.LVL188:
	.loc 1 564 17 view .LVU561
	jmp	.L130
	.cfi_endproc
.LFE53:
	.size	x509_get_ns_cert_type, .-x509_get_ns_cert_type
	.type	x509_get_ext_key_usage, @function
x509_get_ext_key_usage:
.LVL189:
.LFB55:
	.loc 1 605 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 605 1 is_stmt 0 view .LVU563
	pushq	%rbx
.LCFI101:
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdx, %rbx
	.loc 1 606 5 is_stmt 1 view .LVU564
.LVL190:
	.loc 1 608 5 view .LVU565
	.loc 1 608 17 is_stmt 0 view .LVU566
	movl	$6, %ecx
	call	mbedtls_asn1_get_sequence_of@PLT
.LVL191:
	.loc 1 608 7 view .LVU567
	testl	%eax, %eax
	jne	.L141
	.loc 1 612 5 is_stmt 1 view .LVU568
	.loc 1 612 7 is_stmt 0 view .LVU569
	cmpq	$0, 16(%rbx)
	je	.L142
.LVL192:
.L136:
	.loc 1 617 1 view .LVU570
	popq	%rbx
.LCFI102:
	.cfi_remember_state
	.cfi_def_cfa_offset 8
.LVL193:
	.loc 1 617 1 view .LVU571
	ret
.LVL194:
.L141:
.LCFI103:
	.cfi_restore_state
	.loc 1 609 9 is_stmt 1 view .LVU572
.LBB141:
.LBI141:
	.loc 2 156 19 view .LVU573
.LBB142:
	.loc 2 163 5 view .LVU574
	.loc 2 164 5 view .LVU575
	.loc 2 166 5 view .LVU576
	.loc 2 166 18 is_stmt 0 view .LVU577
	subl	$9472, %eax
.LVL195:
	.loc 2 166 18 view .LVU578
.LBE142:
.LBE141:
	.loc 1 609 17 view .LVU579
	jmp	.L136
.LVL196:
.L142:
	.loc 1 613 17 view .LVU580
	movl	$-9572, %eax
.LVL197:
	.loc 1 613 17 view .LVU581
	jmp	.L136
	.cfi_endproc
.LFE55:
	.size	x509_get_ext_key_usage, .-x509_get_ext_key_usage
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1:
	.string	"+\006\001\005\005\007\b\004"
	.text
	.type	x509_get_other_name, @function
x509_get_other_name:
.LVL198:
.LFB67:
	.loc 1 1702 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 1702 1 is_stmt 0 view .LVU583
	pushq	%r13
.LCFI104:
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
.LCFI105:
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
.LCFI106:
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
.LCFI107:
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$56, %rsp
.LCFI108:
	.cfi_def_cfa_offset 96
	.loc 1 1703 5 is_stmt 1 view .LVU584
.LVL199:
	.loc 1 1704 5 view .LVU585
	.loc 1 1705 5 view .LVU586
	.loc 1 1705 40 is_stmt 0 view .LVU587
	movq	16(%rdi), %rbx
	.loc 1 1705 20 view .LVU588
	movq	%rbx, 32(%rsp)
	.loc 1 1706 5 is_stmt 1 view .LVU589
	.loc 1 1706 26 is_stmt 0 view .LVU590
	addq	8(%rdi), %rbx
.LVL200:
	.loc 1 1707 5 is_stmt 1 view .LVU591
	.loc 1 1709 5 view .LVU592
	.loc 1 1709 27 is_stmt 0 view .LVU593
	movl	(%rdi), %eax
	.loc 1 1709 33 view .LVU594
	andl	$223, %eax
	.loc 1 1709 7 view .LVU595
	cmpl	$128, %eax
	jne	.L152
	movq	%rsi, %rbp
	.loc 1 1719 5 is_stmt 1 view .LVU596
	.loc 1 1719 17 is_stmt 0 view .LVU597
	leaq	40(%rsp), %rdx
	leaq	32(%rsp), %rdi
.LVL201:
	.loc 1 1719 17 view .LVU598
	movl	$6, %ecx
	movq	%rbx, %rsi
.LVL202:
	.loc 1 1719 17 view .LVU599
	call	mbedtls_asn1_get_tag@PLT
.LVL203:
	.loc 1 1719 7 view .LVU600
	testl	%eax, %eax
	jne	.L156
	.loc 1 1723 5 is_stmt 1 view .LVU601
	.loc 1 1723 17 is_stmt 0 view .LVU602
	movl	$6, (%rsp)
	.loc 1 1724 5 is_stmt 1 view .LVU603
	.loc 1 1724 15 is_stmt 0 view .LVU604
	movq	32(%rsp), %r12
	movq	%r12, 16(%rsp)
	.loc 1 1725 5 is_stmt 1 view .LVU605
	.loc 1 1725 17 is_stmt 0 view .LVU606
	movq	40(%rsp), %r13
	movq	%r13, 8(%rsp)
	.loc 1 1730 5 is_stmt 1 view .LVU607
	.loc 1 1730 9 is_stmt 0 view .LVU608
	cmpq	$8, %r13
	jne	.L153
	.loc 1 1730 9 discriminator 2 view .LVU609
	movq	%r13, %rdx
	movq	%r12, %rsi
	leaq	.LC1(%rip), %rdi
	call	memcmp@PLT
.LVL204:
	.loc 1 1730 9 discriminator 2 view .LVU610
	testl	%eax, %eax
	jne	.L154
	.loc 1 1735 5 is_stmt 1 view .LVU611
	.loc 1 1735 11 is_stmt 0 view .LVU612
	addq	%r13, %r12
	.loc 1 1735 7 view .LVU613
	cmpq	%rbx, %r12
	jnb	.L157
	.loc 1 1741 5 is_stmt 1 view .LVU614
	.loc 1 1741 7 is_stmt 0 view .LVU615
	movq	%r12, 32(%rsp)
	.loc 1 1742 5 is_stmt 1 view .LVU616
	.loc 1 1742 17 is_stmt 0 view .LVU617
	leaq	40(%rsp), %rdx
	leaq	32(%rsp), %rdi
	movl	$160, %ecx
	movq	%rbx, %rsi
	call	mbedtls_asn1_get_tag@PLT
.LVL205:
	.loc 1 1742 7 view .LVU618
	testl	%eax, %eax
	je	.L147
	.loc 1 1744 9 is_stmt 1 view .LVU619
.LVL206:
.LBB143:
.LBI143:
	.loc 2 156 19 view .LVU620
.LBB144:
	.loc 2 163 5 view .LVU621
	.loc 2 164 5 view .LVU622
	.loc 2 166 5 view .LVU623
	.loc 2 166 18 is_stmt 0 view .LVU624
	subl	$9472, %eax
.LVL207:
	.loc 2 166 18 view .LVU625
.LBE144:
.LBE143:
	.loc 1 1744 17 view .LVU626
	jmp	.L143
.LVL208:
.L156:
	.loc 1 1721 9 is_stmt 1 view .LVU627
.LBB145:
.LBI145:
	.loc 2 156 19 view .LVU628
.LBB146:
	.loc 2 163 5 view .LVU629
	.loc 2 164 5 view .LVU630
	.loc 2 166 5 view .LVU631
	.loc 2 166 18 is_stmt 0 view .LVU632
	subl	$9472, %eax
.LVL209:
.L143:
	.loc 2 166 18 view .LVU633
.LBE146:
.LBE145:
	.loc 1 1780 1 view .LVU634
	addq	$56, %rsp
.LCFI109:
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
.LCFI110:
	.cfi_def_cfa_offset 32
.LVL210:
	.loc 1 1780 1 view .LVU635
	popq	%rbp
.LCFI111:
	.cfi_def_cfa_offset 24
	popq	%r12
.LCFI112:
	.cfi_def_cfa_offset 16
	popq	%r13
.LCFI113:
	.cfi_def_cfa_offset 8
	ret
.LVL211:
.L157:
.LCFI114:
	.cfi_restore_state
	.loc 1 1737 9 is_stmt 1 view .LVU636
	movl	$72, %esi
	movq	%rbp, %rdi
	call	mbedtls_platform_zeroize@PLT
.LVL212:
	.loc 1 1738 9 view .LVU637
	.loc 1 1738 17 is_stmt 0 view .LVU638
	movl	$-9574, %eax
	jmp	.L143
.LVL213:
.L147:
	.loc 1 1746 5 is_stmt 1 view .LVU639
	.loc 1 1746 17 is_stmt 0 view .LVU640
	leaq	40(%rsp), %rdx
	leaq	32(%rsp), %rdi
	movl	$48, %ecx
	movq	%rbx, %rsi
	call	mbedtls_asn1_get_tag@PLT
.LVL214:
	.loc 1 1746 7 view .LVU641
	testl	%eax, %eax
	je	.L148
	.loc 1 1748 8 is_stmt 1 view .LVU642
.LVL215:
.LBB147:
.LBI147:
	.loc 2 156 19 view .LVU643
.LBB148:
	.loc 2 163 5 view .LVU644
	.loc 2 164 5 view .LVU645
	.loc 2 166 5 view .LVU646
	.loc 2 166 18 is_stmt 0 view .LVU647
	subl	$9472, %eax
.LVL216:
	.loc 2 166 18 view .LVU648
.LBE148:
.LBE147:
	.loc 1 1748 16 view .LVU649
	jmp	.L143
.LVL217:
.L148:
	.loc 1 1750 5 is_stmt 1 view .LVU650
	.loc 1 1750 17 is_stmt 0 view .LVU651
	leaq	40(%rsp), %rdx
	leaq	32(%rsp), %rdi
	movl	$6, %ecx
	movq	%rbx, %rsi
	call	mbedtls_asn1_get_tag@PLT
.LVL218:
	.loc 1 1750 7 view .LVU652
	testl	%eax, %eax
	jne	.L158
	.loc 1 1753 5 is_stmt 1 view .LVU653
	.loc 1 1753 52 is_stmt 0 view .LVU654
	movl	$6, 24(%rbp)
	.loc 1 1754 5 is_stmt 1 view .LVU655
	.loc 1 1754 50 is_stmt 0 view .LVU656
	movq	32(%rsp), %rax
.LVL219:
	.loc 1 1754 50 view .LVU657
	movq	%rax, 40(%rbp)
	.loc 1 1755 5 is_stmt 1 view .LVU658
	.loc 1 1755 52 is_stmt 0 view .LVU659
	movq	40(%rsp), %rdx
	movq	%rdx, 32(%rbp)
	.loc 1 1757 5 is_stmt 1 view .LVU660
	.loc 1 1757 11 is_stmt 0 view .LVU661
	addq	%rdx, %rax
	.loc 1 1757 7 view .LVU662
	cmpq	%rbx, %rax
	jnb	.L159
	.loc 1 1763 5 is_stmt 1 view .LVU663
	.loc 1 1763 7 is_stmt 0 view .LVU664
	movq	%rax, 32(%rsp)
	.loc 1 1764 5 is_stmt 1 view .LVU665
	.loc 1 1764 17 is_stmt 0 view .LVU666
	leaq	40(%rsp), %rdx
	leaq	32(%rsp), %rdi
	movl	$4, %ecx
	movq	%rbx, %rsi
	call	mbedtls_asn1_get_tag@PLT
.LVL220:
	.loc 1 1764 7 view .LVU667
	testl	%eax, %eax
	jne	.L160
	.loc 1 1768 5 is_stmt 1 view .LVU668
	.loc 1 1768 52 is_stmt 0 view .LVU669
	movl	$4, 48(%rbp)
	.loc 1 1769 5 is_stmt 1 view .LVU670
	.loc 1 1769 50 is_stmt 0 view .LVU671
	movq	32(%rsp), %rdx
	movq	%rdx, 64(%rbp)
	.loc 1 1770 5 is_stmt 1 view .LVU672
	.loc 1 1770 52 is_stmt 0 view .LVU673
	movq	40(%rsp), %rcx
	movq	%rcx, 56(%rbp)
	.loc 1 1771 5 is_stmt 1 view .LVU674
	.loc 1 1771 7 is_stmt 0 view .LVU675
	addq	%rcx, %rdx
	movq	%rdx, 32(%rsp)
	.loc 1 1772 5 is_stmt 1 view .LVU676
	.loc 1 1772 7 is_stmt 0 view .LVU677
	cmpq	%rbx, %rdx
	je	.L143
	.loc 1 1774 9 is_stmt 1 view .LVU678
	movl	$72, %esi
	movq	%rbp, %rdi
	call	mbedtls_platform_zeroize@PLT
.LVL221:
	.loc 1 1776 9 view .LVU679
	.loc 1 1776 17 is_stmt 0 view .LVU680
	movl	$-9574, %eax
	jmp	.L143
.LVL222:
.L158:
	.loc 1 1751 9 is_stmt 1 view .LVU681
.LBB149:
.LBI149:
	.loc 2 156 19 view .LVU682
.LBB150:
	.loc 2 163 5 view .LVU683
	.loc 2 164 5 view .LVU684
	.loc 2 166 5 view .LVU685
	.loc 2 166 18 is_stmt 0 view .LVU686
	subl	$9472, %eax
.LVL223:
	.loc 2 166 18 view .LVU687
.LBE150:
.LBE149:
	.loc 1 1751 17 view .LVU688
	jmp	.L143
.LVL224:
.L159:
	.loc 1 1759 9 is_stmt 1 view .LVU689
	movl	$72, %esi
	movq	%rbp, %rdi
	call	mbedtls_platform_zeroize@PLT
.LVL225:
	.loc 1 1760 9 view .LVU690
	.loc 1 1760 17 is_stmt 0 view .LVU691
	movl	$-9574, %eax
	jmp	.L143
.LVL226:
.L160:
	.loc 1 1766 9 is_stmt 1 view .LVU692
.LBB151:
.LBI151:
	.loc 2 156 19 view .LVU693
.LBB152:
	.loc 2 163 5 view .LVU694
	.loc 2 164 5 view .LVU695
	.loc 2 166 5 view .LVU696
	.loc 2 166 18 is_stmt 0 view .LVU697
	subl	$9472, %eax
.LVL227:
	.loc 2 166 18 view .LVU698
.LBE152:
.LBE151:
	.loc 1 1766 17 view .LVU699
	jmp	.L143
.LVL228:
.L152:
	.loc 1 1716 15 view .LVU700
	movl	$-10240, %eax
	jmp	.L143
.LVL229:
.L153:
	.loc 1 1732 15 view .LVU701
	movl	$-8320, %eax
.LVL230:
	.loc 1 1732 15 view .LVU702
	jmp	.L143
.L154:
	movl	$-8320, %eax
	jmp	.L143
	.cfi_endproc
.LFE67:
	.size	x509_get_other_name, .-x509_get_other_name
	.section	.rodata.str1.1
.LC2:
	.string	""
.LC3:
	.string	", "
.LC4:
	.string	"%sSSL Client"
.LC5:
	.string	"%sSSL Server"
.LC6:
	.string	"%sEmail"
.LC7:
	.string	"%sObject Signing"
.LC8:
	.string	"%sReserved"
.LC9:
	.string	"%sSSL CA"
.LC10:
	.string	"%sEmail CA"
.LC11:
	.string	"%sObject Signing CA"
	.text
	.type	x509_info_cert_type, @function
x509_info_cert_type:
.LVL231:
.LFB70:
	.loc 1 1959 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 1959 1 is_stmt 0 view .LVU704
	pushq	%r14
.LCFI115:
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
.LCFI116:
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
.LCFI117:
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
.LCFI118:
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
.LCFI119:
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	%rdi, %r13
	movq	%rsi, %r14
	movl	%edx, %ebp
	.loc 1 1960 5 is_stmt 1 view .LVU705
.LVL232:
	.loc 1 1961 5 view .LVU706
	.loc 1 1961 12 is_stmt 0 view .LVU707
	movq	(%rsi), %rbx
.LVL233:
	.loc 1 1962 5 is_stmt 1 view .LVU708
	.loc 1 1962 11 is_stmt 0 view .LVU709
	movq	(%rdi), %r12
.LVL234:
	.loc 1 1963 5 is_stmt 1 view .LVU710
	.loc 1 1965 5 view .LVU711
	testb	%dl, %dl
	js	.L189
	.loc 1 1963 17 is_stmt 0 view .LVU712
	leaq	.LC2(%rip), %rcx
.LVL235:
.L162:
	.loc 1 1965 5 is_stmt 1 discriminator 7 view .LVU713
	.loc 1 1965 76 discriminator 7 view .LVU714
	.loc 1 1966 5 discriminator 7 view .LVU715
	testb	$64, %bpl
	jne	.L190
.LVL236:
.L164:
	.loc 1 1966 5 discriminator 7 view .LVU716
	.loc 1 1966 76 discriminator 7 view .LVU717
	.loc 1 1967 5 discriminator 7 view .LVU718
	testb	$32, %bpl
	jne	.L191
.LVL237:
.L165:
	.loc 1 1967 5 discriminator 7 view .LVU719
	.loc 1 1967 71 discriminator 7 view .LVU720
	.loc 1 1968 5 discriminator 7 view .LVU721
	testb	$16, %bpl
	jne	.L192
.LVL238:
.L166:
	.loc 1 1968 5 discriminator 7 view .LVU722
	.loc 1 1968 80 discriminator 7 view .LVU723
	.loc 1 1969 5 discriminator 7 view .LVU724
	testb	$8, %bpl
	jne	.L193
.LVL239:
.L167:
	.loc 1 1969 5 discriminator 7 view .LVU725
	.loc 1 1969 74 discriminator 7 view .LVU726
	.loc 1 1970 5 discriminator 7 view .LVU727
	testb	$4, %bpl
	jne	.L194
.LVL240:
.L168:
	.loc 1 1970 5 discriminator 7 view .LVU728
	.loc 1 1970 72 discriminator 7 view .LVU729
	.loc 1 1971 5 discriminator 7 view .LVU730
	testb	$2, %bpl
	jne	.L195
.LVL241:
.L169:
	.loc 1 1971 5 discriminator 7 view .LVU731
	.loc 1 1971 74 discriminator 7 view .LVU732
	.loc 1 1972 5 discriminator 7 view .LVU733
	testb	$1, %bpl
	jne	.L196
.LVL242:
.L170:
	.loc 1 1972 5 discriminator 7 view .LVU734
	.loc 1 1972 83 discriminator 7 view .LVU735
	.loc 1 1974 5 discriminator 7 view .LVU736
	.loc 1 1974 11 is_stmt 0 discriminator 7 view .LVU737
	movq	%rbx, (%r14)
	.loc 1 1975 5 is_stmt 1 discriminator 7 view .LVU738
	.loc 1 1975 10 is_stmt 0 discriminator 7 view .LVU739
	movq	%r12, 0(%r13)
	.loc 1 1977 5 is_stmt 1 discriminator 7 view .LVU740
	.loc 1 1977 11 is_stmt 0 discriminator 7 view .LVU741
	movl	$0, %eax
.L161:
	.loc 1 1978 1 view .LVU742
	popq	%rbx
.LCFI120:
	.cfi_remember_state
	.cfi_def_cfa_offset 40
.LVL243:
	.loc 1 1978 1 view .LVU743
	popq	%rbp
.LCFI121:
	.cfi_def_cfa_offset 32
	popq	%r12
.LCFI122:
	.cfi_def_cfa_offset 24
.LVL244:
	.loc 1 1978 1 view .LVU744
	popq	%r13
.LCFI123:
	.cfi_def_cfa_offset 16
.LVL245:
	.loc 1 1978 1 view .LVU745
	popq	%r14
.LCFI124:
	.cfi_def_cfa_offset 8
.LVL246:
	.loc 1 1978 1 view .LVU746
	ret
.LVL247:
.L189:
.LCFI125:
	.cfi_restore_state
	.loc 1 1965 5 is_stmt 1 discriminator 1 view .LVU747
	leaq	.LC2(%rip), %rcx
	leaq	.LC4(%rip), %rdx
.LVL248:
	.loc 1 1965 5 is_stmt 0 discriminator 1 view .LVU748
	movq	%rbx, %rsi
.LVL249:
	.loc 1 1965 5 discriminator 1 view .LVU749
	movq	%r12, %rdi
.LVL250:
	.loc 1 1965 5 discriminator 1 view .LVU750
	movl	$0, %eax
	call	snprintf@PLT
.LVL251:
	.loc 1 1965 5 is_stmt 1 discriminator 1 view .LVU751
	.loc 1 1965 5 discriminator 1 view .LVU752
	testl	%eax, %eax
	js	.L172
	.loc 1 1965 5 is_stmt 0 discriminator 4 view .LVU753
	cltq
	.loc 1 1965 5 discriminator 4 view .LVU754
	cmpq	%rbx, %rax
	jnb	.L173
	.loc 1 1965 5 is_stmt 1 discriminator 6 view .LVU755
	subq	%rax, %rbx
.LVL252:
	.loc 1 1965 5 discriminator 6 view .LVU756
	addq	%rax, %r12
.LVL253:
	.loc 1 1965 5 discriminator 6 view .LVU757
	.loc 1 1965 5 discriminator 6 view .LVU758
	.loc 1 1965 5 is_stmt 0 discriminator 6 view .LVU759
	leaq	.LC3(%rip), %rcx
	jmp	.L162
.LVL254:
.L190:
	.loc 1 1966 5 is_stmt 1 discriminator 1 view .LVU760
	leaq	.LC5(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	movl	$0, %eax
	call	snprintf@PLT
.LVL255:
	.loc 1 1966 5 discriminator 1 view .LVU761
	.loc 1 1966 5 discriminator 1 view .LVU762
	testl	%eax, %eax
	js	.L174
	.loc 1 1966 5 is_stmt 0 discriminator 4 view .LVU763
	cltq
	.loc 1 1966 5 discriminator 4 view .LVU764
	cmpq	%rbx, %rax
	jnb	.L175
	.loc 1 1966 5 is_stmt 1 discriminator 6 view .LVU765
	subq	%rax, %rbx
.LVL256:
	.loc 1 1966 5 discriminator 6 view .LVU766
	addq	%rax, %r12
.LVL257:
	.loc 1 1966 5 discriminator 6 view .LVU767
	.loc 1 1966 5 discriminator 6 view .LVU768
	.loc 1 1966 5 is_stmt 0 discriminator 6 view .LVU769
	leaq	.LC3(%rip), %rcx
	jmp	.L164
.LVL258:
.L191:
	.loc 1 1967 5 is_stmt 1 discriminator 1 view .LVU770
	leaq	.LC6(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	movl	$0, %eax
	call	snprintf@PLT
.LVL259:
	.loc 1 1967 5 discriminator 1 view .LVU771
	.loc 1 1967 5 discriminator 1 view .LVU772
	testl	%eax, %eax
	js	.L176
	.loc 1 1967 5 is_stmt 0 discriminator 4 view .LVU773
	cltq
	.loc 1 1967 5 discriminator 4 view .LVU774
	cmpq	%rbx, %rax
	jnb	.L177
	.loc 1 1967 5 is_stmt 1 discriminator 6 view .LVU775
	subq	%rax, %rbx
.LVL260:
	.loc 1 1967 5 discriminator 6 view .LVU776
	addq	%rax, %r12
.LVL261:
	.loc 1 1967 5 discriminator 6 view .LVU777
	.loc 1 1967 5 discriminator 6 view .LVU778
	.loc 1 1967 5 is_stmt 0 discriminator 6 view .LVU779
	leaq	.LC3(%rip), %rcx
	jmp	.L165
.LVL262:
.L192:
	.loc 1 1968 5 is_stmt 1 discriminator 1 view .LVU780
	leaq	.LC7(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	movl	$0, %eax
	call	snprintf@PLT
.LVL263:
	.loc 1 1968 5 discriminator 1 view .LVU781
	.loc 1 1968 5 discriminator 1 view .LVU782
	testl	%eax, %eax
	js	.L178
	.loc 1 1968 5 is_stmt 0 discriminator 4 view .LVU783
	cltq
	.loc 1 1968 5 discriminator 4 view .LVU784
	cmpq	%rbx, %rax
	jnb	.L179
	.loc 1 1968 5 is_stmt 1 discriminator 6 view .LVU785
	subq	%rax, %rbx
.LVL264:
	.loc 1 1968 5 discriminator 6 view .LVU786
	addq	%rax, %r12
.LVL265:
	.loc 1 1968 5 discriminator 6 view .LVU787
	.loc 1 1968 5 discriminator 6 view .LVU788
	.loc 1 1968 5 is_stmt 0 discriminator 6 view .LVU789
	leaq	.LC3(%rip), %rcx
	jmp	.L166
.LVL266:
.L193:
	.loc 1 1969 5 is_stmt 1 discriminator 1 view .LVU790
	leaq	.LC8(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	movl	$0, %eax
	call	snprintf@PLT
.LVL267:
	.loc 1 1969 5 discriminator 1 view .LVU791
	.loc 1 1969 5 discriminator 1 view .LVU792
	testl	%eax, %eax
	js	.L180
	.loc 1 1969 5 is_stmt 0 discriminator 4 view .LVU793
	cltq
	.loc 1 1969 5 discriminator 4 view .LVU794
	cmpq	%rbx, %rax
	jnb	.L181
	.loc 1 1969 5 is_stmt 1 discriminator 6 view .LVU795
	subq	%rax, %rbx
.LVL268:
	.loc 1 1969 5 discriminator 6 view .LVU796
	addq	%rax, %r12
.LVL269:
	.loc 1 1969 5 discriminator 6 view .LVU797
	.loc 1 1969 5 discriminator 6 view .LVU798
	.loc 1 1969 5 is_stmt 0 discriminator 6 view .LVU799
	leaq	.LC3(%rip), %rcx
	jmp	.L167
.LVL270:
.L194:
	.loc 1 1970 5 is_stmt 1 discriminator 1 view .LVU800
	leaq	.LC9(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	movl	$0, %eax
	call	snprintf@PLT
.LVL271:
	.loc 1 1970 5 discriminator 1 view .LVU801
	.loc 1 1970 5 discriminator 1 view .LVU802
	testl	%eax, %eax
	js	.L182
	.loc 1 1970 5 is_stmt 0 discriminator 4 view .LVU803
	cltq
	.loc 1 1970 5 discriminator 4 view .LVU804
	cmpq	%rbx, %rax
	jnb	.L183
	.loc 1 1970 5 is_stmt 1 discriminator 6 view .LVU805
	subq	%rax, %rbx
.LVL272:
	.loc 1 1970 5 discriminator 6 view .LVU806
	addq	%rax, %r12
.LVL273:
	.loc 1 1970 5 discriminator 6 view .LVU807
	.loc 1 1970 5 discriminator 6 view .LVU808
	.loc 1 1970 5 is_stmt 0 discriminator 6 view .LVU809
	leaq	.LC3(%rip), %rcx
	jmp	.L168
.LVL274:
.L195:
	.loc 1 1971 5 is_stmt 1 discriminator 1 view .LVU810
	leaq	.LC10(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	movl	$0, %eax
	call	snprintf@PLT
.LVL275:
	.loc 1 1971 5 discriminator 1 view .LVU811
	.loc 1 1971 5 discriminator 1 view .LVU812
	testl	%eax, %eax
	js	.L184
	.loc 1 1971 5 is_stmt 0 discriminator 4 view .LVU813
	cltq
	.loc 1 1971 5 discriminator 4 view .LVU814
	cmpq	%rbx, %rax
	jnb	.L185
	.loc 1 1971 5 is_stmt 1 discriminator 6 view .LVU815
	subq	%rax, %rbx
.LVL276:
	.loc 1 1971 5 discriminator 6 view .LVU816
	addq	%rax, %r12
.LVL277:
	.loc 1 1971 5 discriminator 6 view .LVU817
	.loc 1 1971 5 discriminator 6 view .LVU818
	.loc 1 1971 5 is_stmt 0 discriminator 6 view .LVU819
	leaq	.LC3(%rip), %rcx
	jmp	.L169
.LVL278:
.L196:
	.loc 1 1972 5 is_stmt 1 discriminator 1 view .LVU820
	leaq	.LC11(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	movl	$0, %eax
	call	snprintf@PLT
.LVL279:
	.loc 1 1972 5 discriminator 1 view .LVU821
	.loc 1 1972 5 discriminator 1 view .LVU822
	testl	%eax, %eax
	js	.L186
	.loc 1 1972 5 is_stmt 0 discriminator 4 view .LVU823
	cltq
	.loc 1 1972 5 discriminator 4 view .LVU824
	cmpq	%rbx, %rax
	jnb	.L187
	.loc 1 1972 5 is_stmt 1 discriminator 6 view .LVU825
	subq	%rax, %rbx
.LVL280:
	.loc 1 1972 5 discriminator 6 view .LVU826
	addq	%rax, %r12
.LVL281:
	.loc 1 1972 5 discriminator 6 view .LVU827
	.loc 1 1972 5 discriminator 6 view .LVU828
	.loc 1 1972 5 is_stmt 0 discriminator 6 view .LVU829
	jmp	.L170
.LVL282:
.L172:
	.loc 1 1965 5 view .LVU830
	movl	$-10624, %eax
.LVL283:
	.loc 1 1965 5 view .LVU831
	jmp	.L161
.LVL284:
.L173:
	.loc 1 1965 5 view .LVU832
	movl	$-10624, %eax
.LVL285:
	.loc 1 1965 5 view .LVU833
	jmp	.L161
.LVL286:
.L174:
	.loc 1 1966 5 view .LVU834
	movl	$-10624, %eax
.LVL287:
	.loc 1 1966 5 view .LVU835
	jmp	.L161
.LVL288:
.L175:
	.loc 1 1966 5 view .LVU836
	movl	$-10624, %eax
.LVL289:
	.loc 1 1966 5 view .LVU837
	jmp	.L161
.LVL290:
.L176:
	.loc 1 1967 5 view .LVU838
	movl	$-10624, %eax
.LVL291:
	.loc 1 1967 5 view .LVU839
	jmp	.L161
.LVL292:
.L177:
	.loc 1 1967 5 view .LVU840
	movl	$-10624, %eax
.LVL293:
	.loc 1 1967 5 view .LVU841
	jmp	.L161
.LVL294:
.L178:
	.loc 1 1968 5 view .LVU842
	movl	$-10624, %eax
.LVL295:
	.loc 1 1968 5 view .LVU843
	jmp	.L161
.LVL296:
.L179:
	.loc 1 1968 5 view .LVU844
	movl	$-10624, %eax
.LVL297:
	.loc 1 1968 5 view .LVU845
	jmp	.L161
.LVL298:
.L180:
	.loc 1 1969 5 view .LVU846
	movl	$-10624, %eax
.LVL299:
	.loc 1 1969 5 view .LVU847
	jmp	.L161
.LVL300:
.L181:
	.loc 1 1969 5 view .LVU848
	movl	$-10624, %eax
.LVL301:
	.loc 1 1969 5 view .LVU849
	jmp	.L161
.LVL302:
.L182:
	.loc 1 1970 5 view .LVU850
	movl	$-10624, %eax
.LVL303:
	.loc 1 1970 5 view .LVU851
	jmp	.L161
.LVL304:
.L183:
	.loc 1 1970 5 view .LVU852
	movl	$-10624, %eax
.LVL305:
	.loc 1 1970 5 view .LVU853
	jmp	.L161
.LVL306:
.L184:
	.loc 1 1971 5 view .LVU854
	movl	$-10624, %eax
.LVL307:
	.loc 1 1971 5 view .LVU855
	jmp	.L161
.LVL308:
.L185:
	.loc 1 1971 5 view .LVU856
	movl	$-10624, %eax
.LVL309:
	.loc 1 1971 5 view .LVU857
	jmp	.L161
.LVL310:
.L186:
	.loc 1 1972 5 view .LVU858
	movl	$-10624, %eax
.LVL311:
	.loc 1 1972 5 view .LVU859
	jmp	.L161
.LVL312:
.L187:
	.loc 1 1972 5 view .LVU860
	movl	$-10624, %eax
.LVL313:
	.loc 1 1972 5 view .LVU861
	jmp	.L161
	.cfi_endproc
.LFE70:
	.size	x509_info_cert_type, .-x509_info_cert_type
	.section	.rodata.str1.1
.LC12:
	.string	"%sDigital Signature"
.LC13:
	.string	"%sNon Repudiation"
.LC14:
	.string	"%sKey Encipherment"
.LC15:
	.string	"%sData Encipherment"
.LC16:
	.string	"%sKey Agreement"
.LC17:
	.string	"%sKey Cert Sign"
.LC18:
	.string	"%sCRL Sign"
.LC19:
	.string	"%sEncipher Only"
.LC20:
	.string	"%sDecipher Only"
	.text
	.type	x509_info_key_usage, @function
x509_info_key_usage:
.LVL314:
.LFB71:
	.loc 1 1986 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 1986 1 is_stmt 0 view .LVU863
	pushq	%r14
.LCFI126:
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
.LCFI127:
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
.LCFI128:
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
.LCFI129:
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
.LCFI130:
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	%rdi, %r13
	movq	%rsi, %r14
	movl	%edx, %ebp
	.loc 1 1987 5 is_stmt 1 view .LVU864
.LVL315:
	.loc 1 1988 5 view .LVU865
	.loc 1 1988 12 is_stmt 0 view .LVU866
	movq	(%rsi), %rbx
.LVL316:
	.loc 1 1989 5 is_stmt 1 view .LVU867
	.loc 1 1989 11 is_stmt 0 view .LVU868
	movq	(%rdi), %r12
.LVL317:
	.loc 1 1990 5 is_stmt 1 view .LVU869
	.loc 1 1992 5 view .LVU870
	testb	$-128, %dl
	jne	.L228
	.loc 1 1990 17 is_stmt 0 view .LVU871
	leaq	.LC2(%rip), %rcx
.LVL318:
.L198:
	.loc 1 1992 5 is_stmt 1 discriminator 7 view .LVU872
	.loc 1 1992 75 discriminator 7 view .LVU873
	.loc 1 1993 5 discriminator 7 view .LVU874
	testb	$64, %bpl
	jne	.L229
.LVL319:
.L200:
	.loc 1 1993 5 discriminator 7 view .LVU875
	.loc 1 1993 73 discriminator 7 view .LVU876
	.loc 1 1994 5 discriminator 7 view .LVU877
	testb	$32, %bpl
	jne	.L230
.LVL320:
.L201:
	.loc 1 1994 5 discriminator 7 view .LVU878
	.loc 1 1994 74 discriminator 7 view .LVU879
	.loc 1 1995 5 discriminator 7 view .LVU880
	testb	$16, %bpl
	jne	.L231
.LVL321:
.L202:
	.loc 1 1995 5 discriminator 7 view .LVU881
	.loc 1 1995 75 discriminator 7 view .LVU882
	.loc 1 1996 5 discriminator 7 view .LVU883
	testb	$8, %bpl
	jne	.L232
.LVL322:
.L203:
	.loc 1 1996 5 discriminator 7 view .LVU884
	.loc 1 1996 71 discriminator 7 view .LVU885
	.loc 1 1997 5 discriminator 7 view .LVU886
	testb	$4, %bpl
	jne	.L233
.LVL323:
.L204:
	.loc 1 1997 5 discriminator 7 view .LVU887
	.loc 1 1997 71 discriminator 7 view .LVU888
	.loc 1 1998 5 discriminator 7 view .LVU889
	testb	$2, %bpl
	jne	.L234
.LVL324:
.L205:
	.loc 1 1998 5 discriminator 7 view .LVU890
	.loc 1 1998 66 discriminator 7 view .LVU891
	.loc 1 1999 5 discriminator 7 view .LVU892
	testb	$1, %bpl
	jne	.L235
.LVL325:
.L206:
	.loc 1 1999 5 discriminator 7 view .LVU893
	.loc 1 1999 71 discriminator 7 view .LVU894
	.loc 1 2000 5 discriminator 7 view .LVU895
	testl	$32768, %ebp
	jne	.L236
.LVL326:
.L207:
	.loc 1 2000 5 discriminator 7 view .LVU896
	.loc 1 2000 71 discriminator 7 view .LVU897
	.loc 1 2002 5 discriminator 7 view .LVU898
	.loc 1 2002 11 is_stmt 0 discriminator 7 view .LVU899
	movq	%rbx, (%r14)
	.loc 1 2003 5 is_stmt 1 discriminator 7 view .LVU900
	.loc 1 2003 10 is_stmt 0 discriminator 7 view .LVU901
	movq	%r12, 0(%r13)
	.loc 1 2005 5 is_stmt 1 discriminator 7 view .LVU902
	.loc 1 2005 11 is_stmt 0 discriminator 7 view .LVU903
	movl	$0, %eax
.L197:
	.loc 1 2006 1 view .LVU904
	popq	%rbx
.LCFI131:
	.cfi_remember_state
	.cfi_def_cfa_offset 40
.LVL327:
	.loc 1 2006 1 view .LVU905
	popq	%rbp
.LCFI132:
	.cfi_def_cfa_offset 32
.LVL328:
	.loc 1 2006 1 view .LVU906
	popq	%r12
.LCFI133:
	.cfi_def_cfa_offset 24
.LVL329:
	.loc 1 2006 1 view .LVU907
	popq	%r13
.LCFI134:
	.cfi_def_cfa_offset 16
.LVL330:
	.loc 1 2006 1 view .LVU908
	popq	%r14
.LCFI135:
	.cfi_def_cfa_offset 8
.LVL331:
	.loc 1 2006 1 view .LVU909
	ret
.LVL332:
.L228:
.LCFI136:
	.cfi_restore_state
	.loc 1 1992 5 is_stmt 1 discriminator 1 view .LVU910
	leaq	.LC2(%rip), %rcx
	leaq	.LC12(%rip), %rdx
.LVL333:
	.loc 1 1992 5 is_stmt 0 discriminator 1 view .LVU911
	movq	%rbx, %rsi
.LVL334:
	.loc 1 1992 5 discriminator 1 view .LVU912
	movq	%r12, %rdi
.LVL335:
	.loc 1 1992 5 discriminator 1 view .LVU913
	movl	$0, %eax
	call	snprintf@PLT
.LVL336:
	.loc 1 1992 5 is_stmt 1 discriminator 1 view .LVU914
	.loc 1 1992 5 discriminator 1 view .LVU915
	testl	%eax, %eax
	js	.L209
	.loc 1 1992 5 is_stmt 0 discriminator 4 view .LVU916
	cltq
	.loc 1 1992 5 discriminator 4 view .LVU917
	cmpq	%rbx, %rax
	jnb	.L210
	.loc 1 1992 5 is_stmt 1 discriminator 6 view .LVU918
	subq	%rax, %rbx
.LVL337:
	.loc 1 1992 5 discriminator 6 view .LVU919
	addq	%rax, %r12
.LVL338:
	.loc 1 1992 5 discriminator 6 view .LVU920
	.loc 1 1992 5 discriminator 6 view .LVU921
	.loc 1 1992 5 is_stmt 0 discriminator 6 view .LVU922
	leaq	.LC3(%rip), %rcx
	jmp	.L198
.LVL339:
.L229:
	.loc 1 1993 5 is_stmt 1 discriminator 1 view .LVU923
	leaq	.LC13(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	movl	$0, %eax
	call	snprintf@PLT
.LVL340:
	.loc 1 1993 5 discriminator 1 view .LVU924
	.loc 1 1993 5 discriminator 1 view .LVU925
	testl	%eax, %eax
	js	.L211
	.loc 1 1993 5 is_stmt 0 discriminator 4 view .LVU926
	cltq
	.loc 1 1993 5 discriminator 4 view .LVU927
	cmpq	%rbx, %rax
	jnb	.L212
	.loc 1 1993 5 is_stmt 1 discriminator 6 view .LVU928
	subq	%rax, %rbx
.LVL341:
	.loc 1 1993 5 discriminator 6 view .LVU929
	addq	%rax, %r12
.LVL342:
	.loc 1 1993 5 discriminator 6 view .LVU930
	.loc 1 1993 5 discriminator 6 view .LVU931
	.loc 1 1993 5 is_stmt 0 discriminator 6 view .LVU932
	leaq	.LC3(%rip), %rcx
	jmp	.L200
.LVL343:
.L230:
	.loc 1 1994 5 is_stmt 1 discriminator 1 view .LVU933
	leaq	.LC14(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	movl	$0, %eax
	call	snprintf@PLT
.LVL344:
	.loc 1 1994 5 discriminator 1 view .LVU934
	.loc 1 1994 5 discriminator 1 view .LVU935
	testl	%eax, %eax
	js	.L213
	.loc 1 1994 5 is_stmt 0 discriminator 4 view .LVU936
	cltq
	.loc 1 1994 5 discriminator 4 view .LVU937
	cmpq	%rbx, %rax
	jnb	.L214
	.loc 1 1994 5 is_stmt 1 discriminator 6 view .LVU938
	subq	%rax, %rbx
.LVL345:
	.loc 1 1994 5 discriminator 6 view .LVU939
	addq	%rax, %r12
.LVL346:
	.loc 1 1994 5 discriminator 6 view .LVU940
	.loc 1 1994 5 discriminator 6 view .LVU941
	.loc 1 1994 5 is_stmt 0 discriminator 6 view .LVU942
	leaq	.LC3(%rip), %rcx
	jmp	.L201
.LVL347:
.L231:
	.loc 1 1995 5 is_stmt 1 discriminator 1 view .LVU943
	leaq	.LC15(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	movl	$0, %eax
	call	snprintf@PLT
.LVL348:
	.loc 1 1995 5 discriminator 1 view .LVU944
	.loc 1 1995 5 discriminator 1 view .LVU945
	testl	%eax, %eax
	js	.L215
	.loc 1 1995 5 is_stmt 0 discriminator 4 view .LVU946
	cltq
	.loc 1 1995 5 discriminator 4 view .LVU947
	cmpq	%rbx, %rax
	jnb	.L216
	.loc 1 1995 5 is_stmt 1 discriminator 6 view .LVU948
	subq	%rax, %rbx
.LVL349:
	.loc 1 1995 5 discriminator 6 view .LVU949
	addq	%rax, %r12
.LVL350:
	.loc 1 1995 5 discriminator 6 view .LVU950
	.loc 1 1995 5 discriminator 6 view .LVU951
	.loc 1 1995 5 is_stmt 0 discriminator 6 view .LVU952
	leaq	.LC3(%rip), %rcx
	jmp	.L202
.LVL351:
.L232:
	.loc 1 1996 5 is_stmt 1 discriminator 1 view .LVU953
	leaq	.LC16(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	movl	$0, %eax
	call	snprintf@PLT
.LVL352:
	.loc 1 1996 5 discriminator 1 view .LVU954
	.loc 1 1996 5 discriminator 1 view .LVU955
	testl	%eax, %eax
	js	.L217
	.loc 1 1996 5 is_stmt 0 discriminator 4 view .LVU956
	cltq
	.loc 1 1996 5 discriminator 4 view .LVU957
	cmpq	%rbx, %rax
	jnb	.L218
	.loc 1 1996 5 is_stmt 1 discriminator 6 view .LVU958
	subq	%rax, %rbx
.LVL353:
	.loc 1 1996 5 discriminator 6 view .LVU959
	addq	%rax, %r12
.LVL354:
	.loc 1 1996 5 discriminator 6 view .LVU960
	.loc 1 1996 5 discriminator 6 view .LVU961
	.loc 1 1996 5 is_stmt 0 discriminator 6 view .LVU962
	leaq	.LC3(%rip), %rcx
	jmp	.L203
.LVL355:
.L233:
	.loc 1 1997 5 is_stmt 1 discriminator 1 view .LVU963
	leaq	.LC17(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	movl	$0, %eax
	call	snprintf@PLT
.LVL356:
	.loc 1 1997 5 discriminator 1 view .LVU964
	.loc 1 1997 5 discriminator 1 view .LVU965
	testl	%eax, %eax
	js	.L219
	.loc 1 1997 5 is_stmt 0 discriminator 4 view .LVU966
	cltq
	.loc 1 1997 5 discriminator 4 view .LVU967
	cmpq	%rbx, %rax
	jnb	.L220
	.loc 1 1997 5 is_stmt 1 discriminator 6 view .LVU968
	subq	%rax, %rbx
.LVL357:
	.loc 1 1997 5 discriminator 6 view .LVU969
	addq	%rax, %r12
.LVL358:
	.loc 1 1997 5 discriminator 6 view .LVU970
	.loc 1 1997 5 discriminator 6 view .LVU971
	.loc 1 1997 5 is_stmt 0 discriminator 6 view .LVU972
	leaq	.LC3(%rip), %rcx
	jmp	.L204
.LVL359:
.L234:
	.loc 1 1998 5 is_stmt 1 discriminator 1 view .LVU973
	leaq	.LC18(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	movl	$0, %eax
	call	snprintf@PLT
.LVL360:
	.loc 1 1998 5 discriminator 1 view .LVU974
	.loc 1 1998 5 discriminator 1 view .LVU975
	testl	%eax, %eax
	js	.L221
	.loc 1 1998 5 is_stmt 0 discriminator 4 view .LVU976
	cltq
	.loc 1 1998 5 discriminator 4 view .LVU977
	cmpq	%rbx, %rax
	jnb	.L222
	.loc 1 1998 5 is_stmt 1 discriminator 6 view .LVU978
	subq	%rax, %rbx
.LVL361:
	.loc 1 1998 5 discriminator 6 view .LVU979
	addq	%rax, %r12
.LVL362:
	.loc 1 1998 5 discriminator 6 view .LVU980
	.loc 1 1998 5 discriminator 6 view .LVU981
	.loc 1 1998 5 is_stmt 0 discriminator 6 view .LVU982
	leaq	.LC3(%rip), %rcx
	jmp	.L205
.LVL363:
.L235:
	.loc 1 1999 5 is_stmt 1 discriminator 1 view .LVU983
	leaq	.LC19(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	movl	$0, %eax
	call	snprintf@PLT
.LVL364:
	.loc 1 1999 5 discriminator 1 view .LVU984
	.loc 1 1999 5 discriminator 1 view .LVU985
	testl	%eax, %eax
	js	.L223
	.loc 1 1999 5 is_stmt 0 discriminator 4 view .LVU986
	cltq
	.loc 1 1999 5 discriminator 4 view .LVU987
	cmpq	%rbx, %rax
	jnb	.L224
	.loc 1 1999 5 is_stmt 1 discriminator 6 view .LVU988
	subq	%rax, %rbx
.LVL365:
	.loc 1 1999 5 discriminator 6 view .LVU989
	addq	%rax, %r12
.LVL366:
	.loc 1 1999 5 discriminator 6 view .LVU990
	.loc 1 1999 5 discriminator 6 view .LVU991
	.loc 1 1999 5 is_stmt 0 discriminator 6 view .LVU992
	leaq	.LC3(%rip), %rcx
	jmp	.L206
.LVL367:
.L236:
	.loc 1 2000 5 is_stmt 1 discriminator 1 view .LVU993
	leaq	.LC20(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	movl	$0, %eax
	call	snprintf@PLT
.LVL368:
	.loc 1 2000 5 discriminator 1 view .LVU994
	.loc 1 2000 5 discriminator 1 view .LVU995
	testl	%eax, %eax
	js	.L225
	.loc 1 2000 5 is_stmt 0 discriminator 4 view .LVU996
	cltq
	.loc 1 2000 5 discriminator 4 view .LVU997
	cmpq	%rbx, %rax
	jnb	.L226
	.loc 1 2000 5 is_stmt 1 discriminator 6 view .LVU998
	subq	%rax, %rbx
.LVL369:
	.loc 1 2000 5 discriminator 6 view .LVU999
	addq	%rax, %r12
.LVL370:
	.loc 1 2000 5 discriminator 6 view .LVU1000
	.loc 1 2000 5 discriminator 6 view .LVU1001
	.loc 1 2000 5 is_stmt 0 discriminator 6 view .LVU1002
	jmp	.L207
.LVL371:
.L209:
	.loc 1 1992 5 view .LVU1003
	movl	$-10624, %eax
.LVL372:
	.loc 1 1992 5 view .LVU1004
	jmp	.L197
.LVL373:
.L210:
	.loc 1 1992 5 view .LVU1005
	movl	$-10624, %eax
.LVL374:
	.loc 1 1992 5 view .LVU1006
	jmp	.L197
.LVL375:
.L211:
	.loc 1 1993 5 view .LVU1007
	movl	$-10624, %eax
.LVL376:
	.loc 1 1993 5 view .LVU1008
	jmp	.L197
.LVL377:
.L212:
	.loc 1 1993 5 view .LVU1009
	movl	$-10624, %eax
.LVL378:
	.loc 1 1993 5 view .LVU1010
	jmp	.L197
.LVL379:
.L213:
	.loc 1 1994 5 view .LVU1011
	movl	$-10624, %eax
.LVL380:
	.loc 1 1994 5 view .LVU1012
	jmp	.L197
.LVL381:
.L214:
	.loc 1 1994 5 view .LVU1013
	movl	$-10624, %eax
.LVL382:
	.loc 1 1994 5 view .LVU1014
	jmp	.L197
.LVL383:
.L215:
	.loc 1 1995 5 view .LVU1015
	movl	$-10624, %eax
.LVL384:
	.loc 1 1995 5 view .LVU1016
	jmp	.L197
.LVL385:
.L216:
	.loc 1 1995 5 view .LVU1017
	movl	$-10624, %eax
.LVL386:
	.loc 1 1995 5 view .LVU1018
	jmp	.L197
.LVL387:
.L217:
	.loc 1 1996 5 view .LVU1019
	movl	$-10624, %eax
.LVL388:
	.loc 1 1996 5 view .LVU1020
	jmp	.L197
.LVL389:
.L218:
	.loc 1 1996 5 view .LVU1021
	movl	$-10624, %eax
.LVL390:
	.loc 1 1996 5 view .LVU1022
	jmp	.L197
.LVL391:
.L219:
	.loc 1 1997 5 view .LVU1023
	movl	$-10624, %eax
.LVL392:
	.loc 1 1997 5 view .LVU1024
	jmp	.L197
.LVL393:
.L220:
	.loc 1 1997 5 view .LVU1025
	movl	$-10624, %eax
.LVL394:
	.loc 1 1997 5 view .LVU1026
	jmp	.L197
.LVL395:
.L221:
	.loc 1 1998 5 view .LVU1027
	movl	$-10624, %eax
.LVL396:
	.loc 1 1998 5 view .LVU1028
	jmp	.L197
.LVL397:
.L222:
	.loc 1 1998 5 view .LVU1029
	movl	$-10624, %eax
.LVL398:
	.loc 1 1998 5 view .LVU1030
	jmp	.L197
.LVL399:
.L223:
	.loc 1 1999 5 view .LVU1031
	movl	$-10624, %eax
.LVL400:
	.loc 1 1999 5 view .LVU1032
	jmp	.L197
.LVL401:
.L224:
	.loc 1 1999 5 view .LVU1033
	movl	$-10624, %eax
.LVL402:
	.loc 1 1999 5 view .LVU1034
	jmp	.L197
.LVL403:
.L225:
	.loc 1 2000 5 view .LVU1035
	movl	$-10624, %eax
.LVL404:
	.loc 1 2000 5 view .LVU1036
	jmp	.L197
.LVL405:
.L226:
	.loc 1 2000 5 view .LVU1037
	movl	$-10624, %eax
.LVL406:
	.loc 1 2000 5 view .LVU1038
	jmp	.L197
	.cfi_endproc
.LFE71:
	.size	x509_info_key_usage, .-x509_info_key_usage
	.section	.rodata.str1.1
.LC21:
	.string	"???"
.LC22:
	.string	"%s%s"
	.text
	.type	x509_info_ext_key_usage, @function
x509_info_ext_key_usage:
.LVL407:
.LFB72:
	.loc 1 2010 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 2010 1 is_stmt 0 view .LVU1040
	pushq	%r15
.LCFI137:
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
.LCFI138:
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
.LCFI139:
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
.LCFI140:
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
.LCFI141:
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
.LCFI142:
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24, %rsp
.LCFI143:
	.cfi_def_cfa_offset 80
	movq	%rdi, %r13
	movq	%rsi, %r14
	movq	%rdx, %rbx
	.loc 1 2011 5 is_stmt 1 view .LVU1041
.LVL408:
	.loc 1 2012 5 view .LVU1042
	.loc 1 2013 5 view .LVU1043
	.loc 1 2013 12 is_stmt 0 view .LVU1044
	movq	(%rsi), %rbp
.LVL409:
	.loc 1 2014 5 is_stmt 1 view .LVU1045
	.loc 1 2014 11 is_stmt 0 view .LVU1046
	movq	(%rdi), %r12
.LVL410:
	.loc 1 2015 5 is_stmt 1 view .LVU1047
	.loc 1 2016 5 view .LVU1048
	.loc 1 2018 5 view .LVU1049
	.loc 1 2016 17 is_stmt 0 view .LVU1050
	leaq	.LC2(%rip), %r15
	.loc 1 2018 10 view .LVU1051
	jmp	.L238
.LVL411:
.L239:
	.loc 1 2023 9 is_stmt 1 view .LVU1052
	.loc 1 2023 15 is_stmt 0 view .LVU1053
	movq	8(%rsp), %r8
	movq	%r15, %rcx
	leaq	.LC22(%rip), %rdx
	movq	%rbp, %rsi
	movq	%r12, %rdi
	movl	$0, %eax
	call	snprintf@PLT
.LVL412:
	.loc 1 2024 9 is_stmt 1 view .LVU1054
	.loc 1 2024 9 view .LVU1055
	testl	%eax, %eax
	js	.L242
	.loc 1 2024 9 is_stmt 0 discriminator 2 view .LVU1056
	cltq
	.loc 1 2024 9 discriminator 2 view .LVU1057
	cmpq	%rbp, %rax
	jnb	.L243
	.loc 1 2024 9 is_stmt 1 discriminator 4 view .LVU1058
	subq	%rax, %rbp
.LVL413:
	.loc 1 2024 9 discriminator 4 view .LVU1059
	addq	%rax, %r12
.LVL414:
	.loc 1 2024 9 discriminator 4 view .LVU1060
	.loc 1 2026 9 discriminator 4 view .LVU1061
	.loc 1 2028 9 discriminator 4 view .LVU1062
	.loc 1 2028 13 is_stmt 0 discriminator 4 view .LVU1063
	movq	24(%rbx), %rbx
.LVL415:
	.loc 1 2026 13 discriminator 4 view .LVU1064
	leaq	.LC3(%rip), %r15
.LVL416:
.L238:
	.loc 1 2018 16 is_stmt 1 view .LVU1065
	testq	%rbx, %rbx
	je	.L245
	.loc 1 2020 9 view .LVU1066
	.loc 1 2020 13 is_stmt 0 view .LVU1067
	leaq	8(%rsp), %rsi
	movq	%rbx, %rdi
	call	mbedtls_oid_get_extended_key_usage@PLT
.LVL417:
	.loc 1 2020 11 view .LVU1068
	testl	%eax, %eax
	je	.L239
	.loc 1 2021 13 is_stmt 1 view .LVU1069
	.loc 1 2021 18 is_stmt 0 view .LVU1070
	leaq	.LC21(%rip), %rax
	movq	%rax, 8(%rsp)
	jmp	.L239
.L245:
	.loc 1 2031 5 is_stmt 1 view .LVU1071
	.loc 1 2031 11 is_stmt 0 view .LVU1072
	movq	%rbp, (%r14)
	.loc 1 2032 5 is_stmt 1 view .LVU1073
	.loc 1 2032 10 is_stmt 0 view .LVU1074
	movq	%r12, 0(%r13)
	.loc 1 2034 5 is_stmt 1 view .LVU1075
	.loc 1 2034 11 is_stmt 0 view .LVU1076
	movl	$0, %eax
.L237:
	.loc 1 2035 1 view .LVU1077
	addq	$24, %rsp
.LCFI144:
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
.LCFI145:
	.cfi_def_cfa_offset 48
.LVL418:
	.loc 1 2035 1 view .LVU1078
	popq	%rbp
.LCFI146:
	.cfi_def_cfa_offset 40
.LVL419:
	.loc 1 2035 1 view .LVU1079
	popq	%r12
.LCFI147:
	.cfi_def_cfa_offset 32
.LVL420:
	.loc 1 2035 1 view .LVU1080
	popq	%r13
.LCFI148:
	.cfi_def_cfa_offset 24
.LVL421:
	.loc 1 2035 1 view .LVU1081
	popq	%r14
.LCFI149:
	.cfi_def_cfa_offset 16
.LVL422:
	.loc 1 2035 1 view .LVU1082
	popq	%r15
.LCFI150:
	.cfi_def_cfa_offset 8
.LVL423:
	.loc 1 2035 1 view .LVU1083
	ret
.LVL424:
.L242:
.LCFI151:
	.cfi_restore_state
	.loc 1 2024 9 view .LVU1084
	movl	$-10624, %eax
.LVL425:
	.loc 1 2024 9 view .LVU1085
	jmp	.L237
.LVL426:
.L243:
	.loc 1 2024 9 view .LVU1086
	movl	$-10624, %eax
.LVL427:
	.loc 1 2024 9 view .LVU1087
	jmp	.L237
	.cfi_endproc
.LFE72:
	.size	x509_info_ext_key_usage, .-x509_info_ext_key_usage
	.type	x509_info_cert_policies, @function
x509_info_cert_policies:
.LVL428:
.LFB73:
	.loc 1 2039 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 2039 1 is_stmt 0 view .LVU1089
	pushq	%r15
.LCFI152:
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
.LCFI153:
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
.LCFI154:
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
.LCFI155:
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
.LCFI156:
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
.LCFI157:
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24, %rsp
.LCFI158:
	.cfi_def_cfa_offset 80
	movq	%rdi, %r13
	movq	%rsi, %r14
	movq	%rdx, %rbx
	.loc 1 2040 5 is_stmt 1 view .LVU1090
.LVL429:
	.loc 1 2041 5 view .LVU1091
	.loc 1 2042 5 view .LVU1092
	.loc 1 2042 12 is_stmt 0 view .LVU1093
	movq	(%rsi), %rbp
.LVL430:
	.loc 1 2043 5 is_stmt 1 view .LVU1094
	.loc 1 2043 11 is_stmt 0 view .LVU1095
	movq	(%rdi), %r12
.LVL431:
	.loc 1 2044 5 is_stmt 1 view .LVU1096
	.loc 1 2045 5 view .LVU1097
	.loc 1 2047 5 view .LVU1098
	.loc 1 2045 17 is_stmt 0 view .LVU1099
	leaq	.LC2(%rip), %r15
	.loc 1 2047 10 view .LVU1100
	jmp	.L247
.LVL432:
.L248:
	.loc 1 2052 9 is_stmt 1 view .LVU1101
	.loc 1 2052 15 is_stmt 0 view .LVU1102
	movq	8(%rsp), %r8
	movq	%r15, %rcx
	leaq	.LC22(%rip), %rdx
	movq	%rbp, %rsi
	movq	%r12, %rdi
	movl	$0, %eax
	call	snprintf@PLT
.LVL433:
	.loc 1 2053 9 is_stmt 1 view .LVU1103
	.loc 1 2053 9 view .LVU1104
	testl	%eax, %eax
	js	.L251
	.loc 1 2053 9 is_stmt 0 discriminator 2 view .LVU1105
	cltq
	.loc 1 2053 9 discriminator 2 view .LVU1106
	cmpq	%rbp, %rax
	jnb	.L252
	.loc 1 2053 9 is_stmt 1 discriminator 4 view .LVU1107
	subq	%rax, %rbp
.LVL434:
	.loc 1 2053 9 discriminator 4 view .LVU1108
	addq	%rax, %r12
.LVL435:
	.loc 1 2053 9 discriminator 4 view .LVU1109
	.loc 1 2055 9 discriminator 4 view .LVU1110
	.loc 1 2057 9 discriminator 4 view .LVU1111
	.loc 1 2057 13 is_stmt 0 discriminator 4 view .LVU1112
	movq	24(%rbx), %rbx
.LVL436:
	.loc 1 2055 13 discriminator 4 view .LVU1113
	leaq	.LC3(%rip), %r15
.LVL437:
.L247:
	.loc 1 2047 16 is_stmt 1 view .LVU1114
	testq	%rbx, %rbx
	je	.L254
	.loc 1 2049 9 view .LVU1115
	.loc 1 2049 13 is_stmt 0 view .LVU1116
	leaq	8(%rsp), %rsi
	movq	%rbx, %rdi
	call	mbedtls_oid_get_certificate_policies@PLT
.LVL438:
	.loc 1 2049 11 view .LVU1117
	testl	%eax, %eax
	je	.L248
	.loc 1 2050 13 is_stmt 1 view .LVU1118
	.loc 1 2050 18 is_stmt 0 view .LVU1119
	leaq	.LC21(%rip), %rax
	movq	%rax, 8(%rsp)
	jmp	.L248
.L254:
	.loc 1 2060 5 is_stmt 1 view .LVU1120
	.loc 1 2060 11 is_stmt 0 view .LVU1121
	movq	%rbp, (%r14)
	.loc 1 2061 5 is_stmt 1 view .LVU1122
	.loc 1 2061 10 is_stmt 0 view .LVU1123
	movq	%r12, 0(%r13)
	.loc 1 2063 5 is_stmt 1 view .LVU1124
	.loc 1 2063 11 is_stmt 0 view .LVU1125
	movl	$0, %eax
.L246:
	.loc 1 2064 1 view .LVU1126
	addq	$24, %rsp
.LCFI159:
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
.LCFI160:
	.cfi_def_cfa_offset 48
.LVL439:
	.loc 1 2064 1 view .LVU1127
	popq	%rbp
.LCFI161:
	.cfi_def_cfa_offset 40
.LVL440:
	.loc 1 2064 1 view .LVU1128
	popq	%r12
.LCFI162:
	.cfi_def_cfa_offset 32
.LVL441:
	.loc 1 2064 1 view .LVU1129
	popq	%r13
.LCFI163:
	.cfi_def_cfa_offset 24
.LVL442:
	.loc 1 2064 1 view .LVU1130
	popq	%r14
.LCFI164:
	.cfi_def_cfa_offset 16
.LVL443:
	.loc 1 2064 1 view .LVU1131
	popq	%r15
.LCFI165:
	.cfi_def_cfa_offset 8
.LVL444:
	.loc 1 2064 1 view .LVU1132
	ret
.LVL445:
.L251:
.LCFI166:
	.cfi_restore_state
	.loc 1 2053 9 view .LVU1133
	movl	$-10624, %eax
.LVL446:
	.loc 1 2053 9 view .LVU1134
	jmp	.L246
.LVL447:
.L252:
	.loc 1 2053 9 view .LVU1135
	movl	$-10624, %eax
.LVL448:
	.loc 1 2053 9 view .LVU1136
	jmp	.L246
	.cfi_endproc
.LFE73:
	.size	x509_info_cert_policies, .-x509_info_cert_policies
	.type	x509_profile_check_key, @function
x509_profile_check_key:
.LVL449:
.LFB43:
	.loc 1 218 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 218 1 is_stmt 0 view .LVU1138
	pushq	%rbp
.LCFI167:
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
.LCFI168:
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
.LCFI169:
	.cfi_def_cfa_offset 32
	movq	%rdi, %rbp
	movq	%rsi, %rbx
	.loc 1 219 5 is_stmt 1 view .LVU1139
	.loc 1 219 38 is_stmt 0 view .LVU1140
	movq	%rsi, %rdi
.LVL450:
	.loc 1 219 38 view .LVU1141
	call	mbedtls_pk_get_type@PLT
.LVL451:
	.loc 1 222 5 is_stmt 1 view .LVU1142
	.loc 1 222 16 is_stmt 0 view .LVU1143
	cmpl	$1, %eax
	sete	%dl
	.loc 1 222 44 view .LVU1144
	cmpl	$6, %eax
	sete	%cl
	.loc 1 222 7 view .LVU1145
	orb	%cl, %dl
	jne	.L264
	.loc 1 232 5 is_stmt 1 view .LVU1146
	.loc 1 232 16 is_stmt 0 view .LVU1147
	cmpl	$4, %eax
	sete	%dl
	.loc 1 233 16 view .LVU1148
	cmpl	$2, %eax
	sete	%cl
	.loc 1 232 7 view .LVU1149
	orb	%cl, %dl
	jne	.L258
	.loc 1 233 36 view .LVU1150
	cmpl	$3, %eax
	jne	.L260
.L258:
.LBB153:
	.loc 1 236 9 is_stmt 1 view .LVU1151
	movq	8(%rbx), %rax
.LVL452:
.LBB154:
.LBI154:
	.file 3 "../../../externals/mbedtls/include/mbedtls/pk.h"
	.loc 3 239 36 view .LVU1152
.LBB155:
	.loc 3 241 5 view .LVU1153
	.loc 3 241 5 is_stmt 0 view .LVU1154
.LBE155:
.LBE154:
	.loc 1 236 36 view .LVU1155
	movl	(%rax), %ecx
.LVL453:
	.loc 1 238 9 is_stmt 1 view .LVU1156
	.loc 1 238 11 is_stmt 0 view .LVU1157
	testl	%ecx, %ecx
	je	.L261
	.loc 1 241 9 is_stmt 1 view .LVU1158
	.loc 1 241 41 is_stmt 0 view .LVU1159
	subl	$1, %ecx
.LVL454:
	.loc 1 241 41 view .LVU1160
	movl	$1, %eax
.LVL455:
	.loc 1 241 41 view .LVU1161
	sall	%cl, %eax
	.loc 1 241 11 view .LVU1162
	testl	%eax, 8(%rbp)
	je	.L262
	.loc 1 242 19 view .LVU1163
	movl	$0, %eax
.LVL456:
.L255:
	.loc 1 242 19 view .LVU1164
.LBE153:
	.loc 1 249 1 view .LVU1165
	addq	$8, %rsp
.LCFI170:
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
.LCFI171:
	.cfi_def_cfa_offset 16
.LVL457:
	.loc 1 249 1 view .LVU1166
	popq	%rbp
.LCFI172:
	.cfi_def_cfa_offset 8
.LVL458:
	.loc 1 249 1 view .LVU1167
	ret
.LVL459:
.L264:
.LCFI173:
	.cfi_restore_state
	.loc 1 224 9 is_stmt 1 view .LVU1168
	.loc 1 224 13 is_stmt 0 view .LVU1169
	movq	%rbx, %rdi
	call	mbedtls_pk_get_bitlen@PLT
.LVL460:
	.loc 1 224 13 view .LVU1170
	movq	%rax, %rdx
	.loc 1 224 51 view .LVU1171
	movl	12(%rbp), %eax
	.loc 1 224 11 view .LVU1172
	cmpq	%rax, %rdx
	jb	.L259
	.loc 1 225 19 view .LVU1173
	movl	$0, %eax
	jmp	.L255
.L259:
	.loc 1 227 15 view .LVU1174
	movl	$-1, %eax
	jmp	.L255
.LVL461:
.L260:
	.loc 1 248 11 view .LVU1175
	movl	$-1, %eax
.LVL462:
	.loc 1 248 11 view .LVU1176
	jmp	.L255
.LVL463:
.L261:
.LBB156:
	.loc 1 239 19 view .LVU1177
	movl	$-1, %eax
	.loc 1 239 19 view .LVU1178
	jmp	.L255
.LVL464:
.L262:
	.loc 1 244 15 view .LVU1179
	movl	$-1, %eax
	jmp	.L255
.LBE156:
	.cfi_endproc
.LFE43:
	.size	x509_profile_check_key, .-x509_profile_check_key
	.type	x509_check_wildcard, @function
x509_check_wildcard:
.LVL465:
.LFB45:
	.loc 1 284 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 284 1 is_stmt 0 view .LVU1181
	pushq	%rbp
.LCFI174:
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
.LCFI175:
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
.LCFI176:
	.cfi_def_cfa_offset 32
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	.loc 1 285 5 is_stmt 1 view .LVU1182
	.loc 1 286 5 view .LVU1183
.LVL466:
	.loc 1 286 33 is_stmt 0 view .LVU1184
	call	strlen@PLT
.LVL467:
	.loc 1 289 5 is_stmt 1 view .LVU1185
	.loc 1 289 13 is_stmt 0 view .LVU1186
	movq	8(%rbp), %rdx
	.loc 1 289 7 view .LVU1187
	cmpq	$2, %rdx
	jbe	.L270
	.loc 1 289 30 discriminator 1 view .LVU1188
	movq	16(%rbp), %rdi
	.loc 1 289 23 discriminator 1 view .LVU1189
	cmpb	$42, (%rdi)
	jne	.L271
	.loc 1 289 44 discriminator 2 view .LVU1190
	cmpb	$46, 1(%rdi)
	jne	.L272
	.loc 1 292 12 view .LVU1191
	movl	$0, %ecx
.L267:
.LVL468:
	.loc 1 292 19 is_stmt 1 discriminator 1 view .LVU1192
	cmpq	%rax, %rcx
	jnb	.L276
	.loc 1 294 9 view .LVU1193
	.loc 1 294 11 is_stmt 0 view .LVU1194
	cmpb	$46, (%rbx,%rcx)
	je	.L268
	.loc 1 292 29 is_stmt 1 discriminator 2 view .LVU1195
	addq	$1, %rcx
.LVL469:
	.loc 1 292 29 is_stmt 0 discriminator 2 view .LVU1196
	jmp	.L267
.L276:
	.loc 1 286 12 view .LVU1197
	movl	$0, %ecx
.LVL470:
.L268:
	.loc 1 301 5 is_stmt 1 view .LVU1198
	.loc 1 301 7 is_stmt 0 view .LVU1199
	testq	%rcx, %rcx
	je	.L273
	.loc 1 304 5 is_stmt 1 view .LVU1200
	.loc 1 304 16 is_stmt 0 view .LVU1201
	subq	%rcx, %rax
.LVL471:
	.loc 1 304 38 view .LVU1202
	subq	$1, %rdx
	.loc 1 304 7 view .LVU1203
	cmpq	%rdx, %rax
	jne	.L274
	.loc 1 305 42 discriminator 1 view .LVU1204
	leaq	(%rbx,%rcx), %rsi
	.loc 1 305 9 discriminator 1 view .LVU1205
	addq	$1, %rdi
	call	x509_memcasecmp
.LVL472:
	.loc 1 304 42 discriminator 1 view .LVU1206
	testl	%eax, %eax
	jne	.L277
.LVL473:
.L265:
	.loc 1 311 1 view .LVU1207
	addq	$8, %rsp
.LCFI177:
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
.LCFI178:
	.cfi_def_cfa_offset 16
.LVL474:
	.loc 1 311 1 view .LVU1208
	popq	%rbp
.LCFI179:
	.cfi_def_cfa_offset 8
.LVL475:
	.loc 1 311 1 view .LVU1209
	ret
.LVL476:
.L277:
.LCFI180:
	.cfi_restore_state
	.loc 1 310 11 view .LVU1210
	movl	$-1, %eax
	jmp	.L265
.LVL477:
.L270:
	.loc 1 290 15 view .LVU1211
	movl	$-1, %eax
.LVL478:
	.loc 1 290 15 view .LVU1212
	jmp	.L265
.LVL479:
.L271:
	.loc 1 290 15 view .LVU1213
	movl	$-1, %eax
.LVL480:
	.loc 1 290 15 view .LVU1214
	jmp	.L265
.LVL481:
.L272:
	.loc 1 290 15 view .LVU1215
	movl	$-1, %eax
.LVL482:
	.loc 1 290 15 view .LVU1216
	jmp	.L265
.LVL483:
.L273:
	.loc 1 302 15 view .LVU1217
	movl	$-1, %eax
.LVL484:
	.loc 1 302 15 view .LVU1218
	jmp	.L265
.L274:
	.loc 1 310 11 view .LVU1219
	movl	$-1, %eax
	jmp	.L265
	.cfi_endproc
.LFE45:
	.size	x509_check_wildcard, .-x509_check_wildcard
	.type	x509_crt_check_cn, @function
x509_crt_check_cn:
.LVL485:
.LFB86:
	.loc 1 2982 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 2982 1 is_stmt 0 view .LVU1221
	pushq	%rbp
.LCFI181:
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
.LCFI182:
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
.LCFI183:
	.cfi_def_cfa_offset 32
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	.loc 1 2984 5 is_stmt 1 view .LVU1222
	.loc 1 2984 7 is_stmt 0 view .LVU1223
	cmpq	%rdx, 8(%rdi)
	je	.L282
.LVL486:
.L279:
	.loc 1 2991 5 is_stmt 1 view .LVU1224
	.loc 1 2991 9 is_stmt 0 view .LVU1225
	movq	%rbx, %rsi
	movq	%rbp, %rdi
	call	x509_check_wildcard
.LVL487:
	.loc 1 2991 7 view .LVU1226
	testl	%eax, %eax
	jne	.L283
.L278:
	.loc 1 2997 1 view .LVU1227
	addq	$8, %rsp
.LCFI184:
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
.LCFI185:
	.cfi_def_cfa_offset 16
.LVL488:
	.loc 1 2997 1 view .LVU1228
	popq	%rbp
.LCFI186:
	.cfi_def_cfa_offset 8
.LVL489:
	.loc 1 2997 1 view .LVU1229
	ret
.LVL490:
.L282:
.LCFI187:
	.cfi_restore_state
	.loc 1 2985 34 discriminator 1 view .LVU1230
	movq	16(%rdi), %rsi
.LVL491:
	.loc 1 2985 9 discriminator 1 view .LVU1231
	movq	%rbp, %rdi
	call	x509_memcasecmp
.LVL492:
	.loc 1 2984 29 discriminator 1 view .LVU1232
	testl	%eax, %eax
	jne	.L279
	jmp	.L278
.L283:
	.loc 1 2996 11 view .LVU1233
	movl	$-1, %eax
	jmp	.L278
	.cfi_endproc
.LFE86:
	.size	x509_crt_check_cn, .-x509_crt_check_cn
	.type	x509_crt_check_san, @function
x509_crt_check_san:
.LVL493:
.LFB87:
	.loc 1 3004 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 3005 5 view .LVU1235
	.loc 1 3005 25 is_stmt 0 view .LVU1236
	movzbl	(%rdi), %eax
	andl	$31, %eax
.LVL494:
	.loc 1 3009 5 is_stmt 1 view .LVU1237
	.loc 1 3009 7 is_stmt 0 view .LVU1238
	cmpb	$2, %al
	jne	.L286
	.loc 1 3004 1 view .LVU1239
	subq	$8, %rsp
.LCFI188:
	.cfi_def_cfa_offset 16
	.loc 1 3010 9 is_stmt 1 view .LVU1240
	.loc 1 3010 17 is_stmt 0 view .LVU1241
	call	x509_crt_check_cn
.LVL495:
	.loc 1 3016 1 view .LVU1242
	addq	$8, %rsp
.LCFI189:
	.cfi_def_cfa_offset 8
	ret
.LVL496:
.L286:
	.loc 1 3015 11 view .LVU1243
	movl	$-1, %eax
.LVL497:
	.loc 1 3016 1 view .LVU1244
	ret
	.cfi_endproc
.LFE87:
	.size	x509_crt_check_san, .-x509_crt_check_san
	.section	.rodata.str1.1
.LC23:
	.string	"U\004\003"
	.text
	.type	x509_crt_verify_name, @function
x509_crt_verify_name:
.LVL498:
.LFB88:
	.loc 1 3024 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 3024 1 is_stmt 0 view .LVU1246
	pushq	%r13
.LCFI190:
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
.LCFI191:
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
.LCFI192:
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
.LCFI193:
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$8, %rsp
.LCFI194:
	.cfi_def_cfa_offset 48
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	movq	%rdx, %r13
	.loc 1 3025 5 is_stmt 1 view .LVU1247
	.loc 1 3026 5 view .LVU1248
	.loc 1 3027 5 view .LVU1249
	.loc 1 3027 21 is_stmt 0 view .LVU1250
	movq	%rsi, %rdi
.LVL499:
	.loc 1 3027 21 view .LVU1251
	call	strlen@PLT
.LVL500:
	.loc 1 3027 21 view .LVU1252
	movq	%rax, %r12
.LVL501:
	.loc 1 3029 5 is_stmt 1 view .LVU1253
	.loc 1 3029 7 is_stmt 0 view .LVU1254
	testb	$32, 512(%rbx)
	je	.L292
	.loc 1 3031 9 is_stmt 1 view .LVU1255
	.loc 1 3031 18 is_stmt 0 view .LVU1256
	addq	$448, %rbx
.LVL502:
.L293:
	.loc 1 3031 49 is_stmt 1 discriminator 1 view .LVU1257
	testq	%rbx, %rbx
	je	.L294
	.loc 1 3033 13 view .LVU1258
	.loc 1 3033 17 is_stmt 0 view .LVU1259
	movq	%r12, %rdx
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	x509_crt_check_san
.LVL503:
	.loc 1 3033 15 view .LVU1260
	testl	%eax, %eax
	je	.L294
	.loc 1 3031 62 is_stmt 1 discriminator 2 view .LVU1261
	movq	24(%rbx), %rbx
.LVL504:
	.loc 1 3031 62 is_stmt 0 discriminator 2 view .LVU1262
	jmp	.L293
.L294:
	.loc 1 3037 9 is_stmt 1 view .LVU1263
	.loc 1 3037 11 is_stmt 0 view .LVU1264
	testq	%rbx, %rbx
	je	.L302
.LVL505:
.L291:
	.loc 1 3054 1 view .LVU1265
	addq	$8, %rsp
.LCFI195:
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
.LCFI196:
	.cfi_def_cfa_offset 32
	popq	%rbp
.LCFI197:
	.cfi_def_cfa_offset 24
.LVL506:
	.loc 1 3054 1 view .LVU1266
	popq	%r12
.LCFI198:
	.cfi_def_cfa_offset 16
.LVL507:
	.loc 1 3054 1 view .LVU1267
	popq	%r13
.LCFI199:
	.cfi_def_cfa_offset 8
.LVL508:
	.loc 1 3054 1 view .LVU1268
	ret
.LVL509:
.L302:
.LCFI200:
	.cfi_restore_state
	.loc 1 3038 13 is_stmt 1 view .LVU1269
	.loc 1 3038 20 is_stmt 0 view .LVU1270
	movl	0(%r13), %eax
	orl	$4, %eax
	movl	%eax, 0(%r13)
	jmp	.L291
.LVL510:
.L292:
	.loc 1 3042 9 is_stmt 1 view .LVU1271
	.loc 1 3042 19 is_stmt 0 view .LVU1272
	addq	$224, %rbx
.LVL511:
	.loc 1 3042 9 view .LVU1273
	jmp	.L297
.LVL512:
.L298:
	.loc 1 3042 55 is_stmt 1 discriminator 2 view .LVU1274
	movq	48(%rbx), %rbx
.LVL513:
.L297:
	.loc 1 3042 41 discriminator 1 view .LVU1275
	testq	%rbx, %rbx
	je	.L299
	.loc 1 3044 13 view .LVU1276
	.loc 1 3044 17 is_stmt 0 view .LVU1277
	movq	8(%rbx), %rdx
	cmpq	$3, %rdx
	jne	.L298
	.loc 1 3044 17 discriminator 2 view .LVU1278
	movq	16(%rbx), %rsi
	leaq	.LC23(%rip), %rdi
	call	memcmp@PLT
.LVL514:
	testl	%eax, %eax
	jne	.L298
	.loc 1 3045 36 view .LVU1279
	leaq	24(%rbx), %rdi
	.loc 1 3045 17 view .LVU1280
	movq	%r12, %rdx
	movq	%rbp, %rsi
	call	x509_crt_check_cn
.LVL515:
	.loc 1 3044 71 view .LVU1281
	testl	%eax, %eax
	jne	.L298
.L299:
	.loc 1 3051 9 is_stmt 1 view .LVU1282
	.loc 1 3051 11 is_stmt 0 view .LVU1283
	testq	%rbx, %rbx
	jne	.L291
	.loc 1 3052 13 is_stmt 1 view .LVU1284
	.loc 1 3052 20 is_stmt 0 view .LVU1285
	movl	0(%r13), %eax
	orl	$4, %eax
	movl	%eax, 0(%r13)
	.loc 1 3054 1 view .LVU1286
	jmp	.L291
	.cfi_endproc
.LFE88:
	.size	x509_crt_verify_name, .-x509_crt_verify_name
	.type	x509_crt_check_signature, @function
x509_crt_check_signature:
.LVL516:
.LFB80:
	.loc 1 2423 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 2423 1 is_stmt 0 view .LVU1288
	pushq	%r13
.LCFI201:
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
.LCFI202:
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
.LCFI203:
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
.LCFI204:
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$72, %rsp
.LCFI205:
	.cfi_def_cfa_offset 112
	movq	%rdi, %rbx
	movq	%rsi, %r13
	.loc 1 2424 5 is_stmt 1 view .LVU1289
	.loc 1 2425 5 view .LVU1290
	.loc 1 2427 5 view .LVU1291
	.loc 1 2428 5 view .LVU1292
	.loc 1 2428 47 is_stmt 0 view .LVU1293
	movl	592(%rdi), %edi
.LVL517:
	.loc 1 2428 15 view .LVU1294
	call	mbedtls_md_info_from_type@PLT
.LVL518:
	.loc 1 2428 15 view .LVU1295
	movq	%rax, %rbp
.LVL519:
	.loc 1 2429 5 is_stmt 1 view .LVU1296
	.loc 1 2429 16 is_stmt 0 view .LVU1297
	movq	%rax, %rdi
	call	mbedtls_md_get_size@PLT
.LVL520:
	.loc 1 2429 14 view .LVU1298
	movzbl	%al, %r12d
.LVL521:
	.loc 1 2432 5 is_stmt 1 view .LVU1299
	.loc 1 2432 54 is_stmt 0 view .LVU1300
	movq	40(%rbx), %rdx
	.loc 1 2432 40 view .LVU1301
	movq	48(%rbx), %rsi
	.loc 1 2432 9 view .LVU1302
	movq	%rsp, %rcx
	movq	%rbp, %rdi
	call	mbedtls_md@PLT
.LVL522:
	.loc 1 2432 7 view .LVU1303
	testl	%eax, %eax
	jne	.L305
	.loc 1 2454 5 is_stmt 1 view .LVU1304
	.loc 1 2454 48 is_stmt 0 view .LVU1305
	movl	596(%rbx), %esi
	.loc 1 2454 30 view .LVU1306
	addq	$360, %r13
.LVL523:
	.loc 1 2454 11 view .LVU1307
	movq	%r13, %rdi
	call	mbedtls_pk_can_do@PLT
.LVL524:
	.loc 1 2454 7 view .LVU1308
	testl	%eax, %eax
	je	.L306
	.loc 1 2465 5 is_stmt 1 view .LVU1309
	.loc 1 2468 5 view .LVU1310
	.loc 1 2469 22 is_stmt 0 view .LVU1311
	movl	592(%rbx), %ecx
	.loc 1 2468 56 view .LVU1312
	movq	600(%rbx), %rsi
	.loc 1 2468 41 view .LVU1313
	movl	596(%rbx), %edi
	.loc 1 2468 13 view .LVU1314
	pushq	576(%rbx)
.LCFI206:
	.cfi_def_cfa_offset 120
	pushq	584(%rbx)
.LCFI207:
	.cfi_def_cfa_offset 128
	movq	%r12, %r9
	leaq	16(%rsp), %r8
	movq	%r13, %rdx
	call	mbedtls_pk_verify_ext@PLT
.LVL525:
	addq	$16, %rsp
.LCFI208:
	.cfi_def_cfa_offset 112
.LVL526:
.L303:
	.loc 1 2471 1 view .LVU1315
	addq	$72, %rsp
.LCFI209:
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
.LCFI210:
	.cfi_def_cfa_offset 32
.LVL527:
	.loc 1 2471 1 view .LVU1316
	popq	%rbp
.LCFI211:
	.cfi_def_cfa_offset 24
.LVL528:
	.loc 1 2471 1 view .LVU1317
	popq	%r12
.LCFI212:
	.cfi_def_cfa_offset 16
.LVL529:
	.loc 1 2471 1 view .LVU1318
	popq	%r13
.LCFI213:
	.cfi_def_cfa_offset 8
	ret
.LVL530:
.L305:
.LCFI214:
	.cfi_restore_state
	.loc 1 2433 15 view .LVU1319
	movl	$-1, %eax
	jmp	.L303
.LVL531:
.L306:
	.loc 1 2455 15 view .LVU1320
	movl	$-1, %eax
	jmp	.L303
	.cfi_endproc
.LFE80:
	.size	x509_crt_check_signature, .-x509_crt_check_signature
	.globl	mbedtls_x509_parse_subject_alt_name
	.type	mbedtls_x509_parse_subject_alt_name, @function
mbedtls_x509_parse_subject_alt_name:
.LVL532:
.LFB68:
	.loc 1 1784 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 1784 1 is_stmt 0 view .LVU1322
	pushq	%rbx
.LCFI215:
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$80, %rsp
.LCFI216:
	.cfi_def_cfa_offset 96
	movq	%rsi, %rbx
	.loc 1 1785 5 is_stmt 1 view .LVU1323
.LVL533:
	.loc 1 1786 5 view .LVU1324
	.loc 1 1786 26 is_stmt 0 view .LVU1325
	movl	(%rdi), %eax
	andl	$223, %eax
	.loc 1 1786 5 view .LVU1326
	cmpl	$128, %eax
	je	.L309
	cmpl	$130, %eax
	je	.L310
	movl	$-8320, %eax
.LVL534:
.L308:
	.loc 1 1830 1 view .LVU1327
	addq	$80, %rsp
.LCFI217:
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
.LCFI218:
	.cfi_def_cfa_offset 8
.LVL535:
	.loc 1 1830 1 view .LVU1328
	ret
.LVL536:
.L309:
.LCFI219:
	.cfi_restore_state
.LBB157:
	.loc 1 1795 13 is_stmt 1 view .LVU1329
	.loc 1 1797 13 view .LVU1330
	.loc 1 1797 19 is_stmt 0 view .LVU1331
	movq	%rsp, %rsi
	call	x509_get_other_name
.LVL537:
	.loc 1 1798 13 is_stmt 1 view .LVU1332
	.loc 1 1798 15 is_stmt 0 view .LVU1333
	testl	%eax, %eax
	jne	.L308
	.loc 1 1801 13 is_stmt 1 view .LVU1334
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rbx)
	movups	%xmm0, 16(%rbx)
	movups	%xmm0, 32(%rbx)
	movups	%xmm0, 48(%rbx)
	movups	%xmm0, 64(%rbx)
	.loc 1 1802 13 view .LVU1335
	.loc 1 1803 13 view .LVU1336
	movdqa	(%rsp), %xmm2
	movups	%xmm2, 8(%rbx)
	movdqa	16(%rsp), %xmm3
	movups	%xmm3, 24(%rbx)
	movdqa	32(%rsp), %xmm4
	movups	%xmm4, 40(%rbx)
	movdqa	48(%rsp), %xmm5
	movups	%xmm5, 56(%rbx)
	movq	64(%rsp), %rcx
	movq	%rcx, 72(%rbx)
.LBE157:
	.loc 1 1807 9 view .LVU1337
	jmp	.L308
.LVL538:
.L310:
	.loc 1 1814 13 view .LVU1338
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rsi)
	movups	%xmm0, 16(%rsi)
	movups	%xmm0, 32(%rsi)
	movups	%xmm0, 48(%rsi)
	movups	%xmm0, 64(%rsi)
	.loc 1 1815 13 view .LVU1339
	.loc 1 1815 23 is_stmt 0 view .LVU1340
	movl	$2, (%rsi)
	.loc 1 1817 13 is_stmt 1 view .LVU1341
	movdqu	(%rdi), %xmm1
	movups	%xmm1, 8(%rsi)
	movq	16(%rdi), %rax
	movq	%rax, 24(%rsi)
	.loc 1 1821 9 view .LVU1342
	.loc 1 1829 11 is_stmt 0 view .LVU1343
	movl	$0, %eax
	.loc 1 1821 9 view .LVU1344
	jmp	.L308
	.cfi_endproc
.LFE68:
	.size	mbedtls_x509_parse_subject_alt_name, .-mbedtls_x509_parse_subject_alt_name
	.type	x509_get_subject_alt_name, @function
x509_get_subject_alt_name:
.LVL539:
.LFB56:
	.loc 1 649 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 649 1 is_stmt 0 view .LVU1346
	pushq	%r15
.LCFI220:
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
.LCFI221:
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
.LCFI222:
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
.LCFI223:
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
.LCFI224:
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
.LCFI225:
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$120, %rsp
.LCFI226:
	.cfi_def_cfa_offset 176
	movq	%rdi, %rbx
	movq	%rsi, %r13
	movq	%rdx, 8(%rsp)
	.loc 1 650 5 is_stmt 1 view .LVU1347
.LVL540:
	.loc 1 651 5 view .LVU1348
	.loc 1 652 5 view .LVU1349
	.loc 1 653 5 view .LVU1350
	.loc 1 654 5 view .LVU1351
	.loc 1 657 5 view .LVU1352
	.loc 1 657 17 is_stmt 0 view .LVU1353
	leaq	104(%rsp), %rdx
.LVL541:
	.loc 1 657 17 view .LVU1354
	movl	$48, %ecx
	call	mbedtls_asn1_get_tag@PLT
.LVL542:
	.loc 1 657 17 view .LVU1355
	movl	%eax, %r15d
.LVL543:
	.loc 1 657 7 view .LVU1356
	testl	%eax, %eax
	jne	.L331
	.loc 1 661 5 is_stmt 1 view .LVU1357
	.loc 1 661 12 is_stmt 0 view .LVU1358
	movq	104(%rsp), %rax
.LVL544:
	.loc 1 661 12 view .LVU1359
	addq	(%rbx), %rax
	.loc 1 661 7 view .LVU1360
	cmpq	%r13, %rax
	jne	.L325
	.loc 1 654 28 view .LVU1361
	movq	8(%rsp), %rbp
	jmp	.L317
.LVL545:
.L331:
	.loc 1 659 9 is_stmt 1 view .LVU1362
.LBB158:
.LBI158:
	.loc 2 156 19 view .LVU1363
.LBB159:
	.loc 2 163 5 view .LVU1364
	.loc 2 164 5 view .LVU1365
	.loc 2 166 5 view .LVU1366
	.loc 2 166 18 is_stmt 0 view .LVU1367
	subl	$9472, %r15d
.LVL546:
.L314:
	.loc 2 166 18 view .LVU1368
.LBE159:
.LBE158:
	.loc 1 736 1 view .LVU1369
	movl	%r15d, %eax
	addq	$120, %rsp
.LCFI227:
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
.LCFI228:
	.cfi_def_cfa_offset 48
	popq	%rbp
.LCFI229:
	.cfi_def_cfa_offset 40
	popq	%r12
.LCFI230:
	.cfi_def_cfa_offset 32
	popq	%r13
.LCFI231:
	.cfi_def_cfa_offset 24
.LVL547:
	.loc 1 736 1 view .LVU1370
	popq	%r14
.LCFI232:
	.cfi_def_cfa_offset 16
	popq	%r15
.LCFI233:
	.cfi_def_cfa_offset 8
	ret
.LVL548:
.L334:
.LCFI234:
	.cfi_restore_state
.LBB160:
	.loc 1 673 13 is_stmt 1 view .LVU1371
.LBB161:
.LBI161:
	.loc 2 156 19 view .LVU1372
.LBB162:
	.loc 2 163 5 view .LVU1373
	.loc 2 164 5 view .LVU1374
	.loc 2 166 5 view .LVU1375
	.loc 2 166 18 is_stmt 0 view .LVU1376
	leal	-9472(%rax), %r15d
.LVL549:
	.loc 2 166 18 view .LVU1377
.LBE162:
.LBE161:
	.loc 1 673 21 view .LVU1378
	jmp	.L314
.LVL550:
.L335:
.LBB163:
	.loc 1 692 13 is_stmt 1 view .LVU1379
	.loc 1 692 36 is_stmt 0 view .LVU1380
	movq	8(%rsp), %rax
	movq	24(%rax), %rbx
.LVL551:
	.loc 1 693 13 is_stmt 1 view .LVU1381
	.loc 1 694 13 view .LVU1382
.L321:
	.loc 1 694 28 view .LVU1383
	testq	%rbx, %rbx
	je	.L332
	.loc 1 696 17 view .LVU1384
.LVL552:
	.loc 1 697 17 view .LVU1385
	.loc 1 697 25 is_stmt 0 view .LVU1386
	movq	24(%rbx), %rbp
.LVL553:
	.loc 1 698 17 is_stmt 1 view .LVU1387
	movl	$32, %esi
	movq	%rbx, %rdi
	call	mbedtls_platform_zeroize@PLT
.LVL554:
	.loc 1 700 17 view .LVU1388
	movq	%rbx, %rdi
	call	free@PLT
.LVL555:
	.loc 1 697 25 is_stmt 0 view .LVU1389
	movq	%rbp, %rbx
.LVL556:
	.loc 1 697 25 view .LVU1390
	jmp	.L321
.LVL557:
.L332:
	.loc 1 702 13 is_stmt 1 view .LVU1391
	.loc 1 702 36 is_stmt 0 view .LVU1392
	movq	8(%rsp), %rax
	movq	$0, 24(%rax)
	.loc 1 703 13 is_stmt 1 view .LVU1393
	.loc 1 703 19 is_stmt 0 view .LVU1394
	movl	%r12d, %r15d
	jmp	.L314
.LVL558:
.L323:
	.loc 1 703 19 view .LVU1395
.LBE163:
	.loc 1 721 9 is_stmt 1 view .LVU1396
	.loc 1 722 9 view .LVU1397
	.loc 1 722 18 is_stmt 0 view .LVU1398
	movl	%r14d, 0(%rbp)
	.loc 1 723 9 is_stmt 1 view .LVU1399
	.loc 1 723 18 is_stmt 0 view .LVU1400
	movq	(%rbx), %rax
	.loc 1 723 16 view .LVU1401
	movq	%rax, 16(%rbp)
	.loc 1 724 9 is_stmt 1 view .LVU1402
	.loc 1 724 18 is_stmt 0 view .LVU1403
	movq	96(%rsp), %rax
	movq	%rax, 8(%rbp)
	.loc 1 725 9 is_stmt 1 view .LVU1404
	.loc 1 725 12 is_stmt 0 view .LVU1405
	addq	%rax, (%rbx)
.LVL559:
.L317:
	.loc 1 725 12 view .LVU1406
.LBE160:
	.loc 1 665 15 is_stmt 1 view .LVU1407
	cmpq	%r13, (%rbx)
	jnb	.L333
.LBB164:
	.loc 1 667 9 view .LVU1408
	.loc 1 668 9 view .LVU1409
	pxor	%xmm0, %xmm0
	movaps	%xmm0, 16(%rsp)
	movaps	%xmm0, 32(%rsp)
	movaps	%xmm0, 48(%rsp)
	movaps	%xmm0, 64(%rsp)
	movaps	%xmm0, 80(%rsp)
	.loc 1 670 9 view .LVU1410
	.loc 1 670 16 is_stmt 0 view .LVU1411
	movq	(%rbx), %rax
	.loc 1 670 13 view .LVU1412
	movzbl	(%rax), %r12d
.LVL560:
	.loc 1 671 9 is_stmt 1 view .LVU1413
	.loc 1 671 13 is_stmt 0 view .LVU1414
	addq	$1, %rax
	movq	%rax, (%rbx)
	.loc 1 672 9 is_stmt 1 view .LVU1415
	.loc 1 672 21 is_stmt 0 view .LVU1416
	leaq	96(%rsp), %rdx
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	mbedtls_asn1_get_len@PLT
.LVL561:
	.loc 1 672 11 view .LVU1417
	testl	%eax, %eax
	jne	.L334
	.loc 1 675 9 is_stmt 1 view .LVU1418
	.loc 1 675 19 is_stmt 0 view .LVU1419
	movzbl	%r12b, %r14d
	.loc 1 675 11 view .LVU1420
	andl	$-64, %r12d
.LVL562:
	.loc 1 675 11 view .LVU1421
	cmpb	$-128, %r12b
	jne	.L326
	.loc 1 685 9 is_stmt 1 view .LVU1422
	.loc 1 685 15 is_stmt 0 view .LVU1423
	leaq	16(%rsp), %rsi
	movq	%rbp, %rdi
	call	mbedtls_x509_parse_subject_alt_name
.LVL563:
	.loc 1 685 15 view .LVU1424
	movl	%eax, %r12d
.LVL564:
	.loc 1 690 9 is_stmt 1 view .LVU1425
	.loc 1 690 17 is_stmt 0 view .LVU1426
	testl	%eax, %eax
	setne	%dl
	.loc 1 690 29 view .LVU1427
	cmpl	$-8320, %eax
	setne	%al
.LVL565:
	.loc 1 690 11 view .LVU1428
	testb	%al, %dl
	jne	.L335
	.loc 1 707 9 is_stmt 1 view .LVU1429
	.loc 1 707 11 is_stmt 0 view .LVU1430
	cmpq	$0, 16(%rbp)
	je	.L323
	.loc 1 709 13 is_stmt 1 view .LVU1431
	.loc 1 709 15 is_stmt 0 view .LVU1432
	cmpq	$0, 24(%rbp)
	jne	.L327
	.loc 1 712 13 is_stmt 1 view .LVU1433
	.loc 1 712 25 is_stmt 0 view .LVU1434
	movl	$32, %esi
	movl	$1, %edi
	call	calloc@PLT
.LVL566:
	.loc 1 712 23 view .LVU1435
	movq	%rax, 24(%rbp)
	.loc 1 714 13 is_stmt 1 view .LVU1436
	.loc 1 714 15 is_stmt 0 view .LVU1437
	testq	%rax, %rax
	je	.L328
	.loc 1 718 17 view .LVU1438
	movq	%rax, %rbp
.LVL567:
	.loc 1 718 17 view .LVU1439
	jmp	.L323
.LVL568:
.L326:
	.loc 1 678 21 view .LVU1440
	movl	$-9570, %r15d
	jmp	.L314
.LVL569:
.L327:
	.loc 1 710 23 view .LVU1441
	movl	$-9472, %r15d
	jmp	.L314
.L328:
	.loc 1 715 25 view .LVU1442
	movl	$-9578, %r15d
	jmp	.L314
.LVL570:
.L333:
	.loc 1 715 25 view .LVU1443
.LBE164:
	.loc 1 729 5 is_stmt 1 view .LVU1444
	.loc 1 729 15 is_stmt 0 view .LVU1445
	movq	$0, 24(%rbp)
	.loc 1 731 5 is_stmt 1 view .LVU1446
	.loc 1 731 7 is_stmt 0 view .LVU1447
	cmpq	%r13, (%rbx)
	je	.L314
	.loc 1 732 17 view .LVU1448
	movl	$-9574, %r15d
	jmp	.L314
.LVL571:
.L325:
	.loc 1 662 17 view .LVU1449
	movl	$-9574, %r15d
.LVL572:
	.loc 1 662 17 view .LVU1450
	jmp	.L314
	.cfi_endproc
.LFE56:
	.size	x509_get_subject_alt_name, .-x509_get_subject_alt_name
	.type	x509_get_crt_ext, @function
x509_get_crt_ext:
.LVL573:
.LFB58:
	.loc 1 908 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 908 1 is_stmt 0 view .LVU1452
	pushq	%r15
.LCFI235:
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
.LCFI236:
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
.LCFI237:
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
.LCFI238:
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
.LCFI239:
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
.LCFI240:
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$88, %rsp
.LCFI241:
	.cfi_def_cfa_offset 144
	movq	%rcx, 16(%rsp)
	movq	%r8, 24(%rsp)
	.loc 1 909 5 is_stmt 1 view .LVU1453
.LVL574:
	.loc 1 910 5 view .LVU1454
	.loc 1 911 5 view .LVU1455
	.loc 1 913 5 view .LVU1456
	.loc 1 913 7 is_stmt 0 view .LVU1457
	cmpq	%rsi, (%rdi)
	je	.L360
	movq	%rdi, %rbx
	movq	%rdx, %r12
	.loc 1 916 5 is_stmt 1 view .LVU1458
	.loc 1 916 17 is_stmt 0 view .LVU1459
	leaq	424(%rdx), %rdx
.LVL575:
	.loc 1 916 17 view .LVU1460
	movl	$3, %ecx
.LVL576:
	.loc 1 916 17 view .LVU1461
	call	mbedtls_x509_get_ext@PLT
.LVL577:
	.loc 1 916 17 view .LVU1462
	movl	%eax, 12(%rsp)
.LVL578:
	.loc 1 916 7 view .LVU1463
	testl	%eax, %eax
	jne	.L336
	.loc 1 919 5 is_stmt 1 view .LVU1464
	.loc 1 919 38 is_stmt 0 view .LVU1465
	movq	432(%r12), %r14
	.loc 1 919 9 view .LVU1466
	addq	440(%r12), %r14
.LVL579:
	.loc 1 920 5 is_stmt 1 view .LVU1467
.L338:
	.loc 1 920 15 view .LVU1468
	.loc 1 920 12 is_stmt 0 view .LVU1469
	movq	(%rbx), %rax
	.loc 1 920 15 view .LVU1470
	cmpq	%r14, %rax
	jnb	.L375
.LBB165:
	.loc 1 928 9 is_stmt 1 view .LVU1471
	.loc 1 928 26 is_stmt 0 view .LVU1472
	movl	$0, 48(%rsp)
	movq	$0, 56(%rsp)
	movq	$0, 64(%rsp)
	.loc 1 929 9 is_stmt 1 view .LVU1473
	.loc 1 929 13 is_stmt 0 view .LVU1474
	movl	$0, 40(%rsp)
	.loc 1 930 9 is_stmt 1 view .LVU1475
	.loc 1 930 13 is_stmt 0 view .LVU1476
	movl	$0, 44(%rsp)
	.loc 1 932 9 is_stmt 1 view .LVU1477
	.loc 1 932 21 is_stmt 0 view .LVU1478
	leaq	72(%rsp), %rdx
	movl	$48, %ecx
	movq	%r14, %rsi
	movq	%rbx, %rdi
	call	mbedtls_asn1_get_tag@PLT
.LVL580:
	.loc 1 932 11 view .LVU1479
	testl	%eax, %eax
	jne	.L376
	.loc 1 936 9 is_stmt 1 view .LVU1480
	.loc 1 936 27 is_stmt 0 view .LVU1481
	movq	72(%rsp), %rbp
	.loc 1 936 22 view .LVU1482
	addq	(%rbx), %rbp
.LVL581:
	.loc 1 939 9 is_stmt 1 view .LVU1483
	.loc 1 939 21 is_stmt 0 view .LVU1484
	leaq	56(%rsp), %rdx
	movl	$6, %ecx
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	mbedtls_asn1_get_tag@PLT
.LVL582:
	.loc 1 939 11 view .LVU1485
	testl	%eax, %eax
	jne	.L377
	.loc 1 943 9 is_stmt 1 view .LVU1486
	.loc 1 943 22 is_stmt 0 view .LVU1487
	movl	$6, 48(%rsp)
	.loc 1 944 9 is_stmt 1 view .LVU1488
	.loc 1 944 22 is_stmt 0 view .LVU1489
	movq	(%rbx), %rax
.LVL583:
	.loc 1 944 20 view .LVU1490
	movq	%rax, 64(%rsp)
	.loc 1 945 9 is_stmt 1 view .LVU1491
	.loc 1 945 12 is_stmt 0 view .LVU1492
	addq	56(%rsp), %rax
	movq	%rax, (%rbx)
	.loc 1 948 9 is_stmt 1 view .LVU1493
	.loc 1 948 21 is_stmt 0 view .LVU1494
	leaq	40(%rsp), %rdx
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	mbedtls_asn1_get_bool@PLT
.LVL584:
	.loc 1 948 11 view .LVU1495
	testl	%eax, %eax
	je	.L342
	.loc 1 948 83 discriminator 1 view .LVU1496
	cmpl	$-98, %eax
	jne	.L378
.L342:
	.loc 1 953 9 is_stmt 1 view .LVU1497
	.loc 1 953 21 is_stmt 0 view .LVU1498
	leaq	72(%rsp), %rdx
	movl	$4, %ecx
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	mbedtls_asn1_get_tag@PLT
.LVL585:
	.loc 1 953 11 view .LVU1499
	testl	%eax, %eax
	jne	.L379
	.loc 1 957 9 is_stmt 1 view .LVU1500
	.loc 1 957 25 is_stmt 0 view .LVU1501
	movq	(%rbx), %r15
.LVL586:
	.loc 1 958 9 is_stmt 1 view .LVU1502
	.loc 1 958 23 is_stmt 0 view .LVU1503
	movq	%r15, %r13
	addq	72(%rsp), %r13
.LVL587:
	.loc 1 960 9 is_stmt 1 view .LVU1504
	.loc 1 960 11 is_stmt 0 view .LVU1505
	cmpq	%r13, %rbp
	jne	.L361
	.loc 1 967 9 is_stmt 1 view .LVU1506
	.loc 1 967 15 is_stmt 0 view .LVU1507
	leaq	44(%rsp), %rsi
	leaq	48(%rsp), %rdi
	call	mbedtls_oid_get_x509_ext_type@PLT
.LVL588:
	.loc 1 969 9 is_stmt 1 view .LVU1508
	.loc 1 969 11 is_stmt 0 view .LVU1509
	testl	%eax, %eax
	je	.L344
	.loc 1 972 13 is_stmt 1 view .LVU1510
	.loc 1 972 15 is_stmt 0 view .LVU1511
	movq	16(%rsp), %rax
.LVL589:
	.loc 1 972 15 view .LVU1512
	testq	%rax, %rax
	je	.L345
	.loc 1 974 17 is_stmt 1 view .LVU1513
	.loc 1 974 23 is_stmt 0 view .LVU1514
	leaq	48(%rsp), %rdx
	movq	%r13, %r9
	movq	(%rbx), %r8
	movl	40(%rsp), %ecx
	movq	%r12, %rsi
	movq	24(%rsp), %rdi
	call	*%rax
.LVL590:
	.loc 1 975 17 is_stmt 1 view .LVU1515
	.loc 1 975 19 is_stmt 0 view .LVU1516
	testl	%eax, %eax
	je	.L346
	.loc 1 975 30 discriminator 1 view .LVU1517
	cmpl	$0, 40(%rsp)
	je	.L346
	.loc 1 976 27 view .LVU1518
	movl	%eax, 12(%rsp)
	jmp	.L336
.LVL591:
.L376:
	.loc 1 934 13 is_stmt 1 view .LVU1519
.LBB166:
.LBI166:
	.loc 2 156 19 view .LVU1520
.LBB167:
	.loc 2 163 5 view .LVU1521
	.loc 2 164 5 view .LVU1522
	.loc 2 166 5 view .LVU1523
	.loc 2 166 18 is_stmt 0 view .LVU1524
	subl	$9472, %eax
.LVL592:
	.loc 2 166 18 view .LVU1525
	movl	%eax, 12(%rsp)
.LVL593:
	.loc 2 166 18 view .LVU1526
.LBE167:
.LBE166:
	.loc 1 934 21 view .LVU1527
	jmp	.L336
.LVL594:
.L377:
	.loc 1 941 13 is_stmt 1 view .LVU1528
.LBB168:
.LBI168:
	.loc 2 156 19 view .LVU1529
.LBB169:
	.loc 2 163 5 view .LVU1530
	.loc 2 164 5 view .LVU1531
	.loc 2 166 5 view .LVU1532
	.loc 2 166 18 is_stmt 0 view .LVU1533
	subl	$9472, %eax
.LVL595:
	.loc 2 166 18 view .LVU1534
	movl	%eax, 12(%rsp)
.LVL596:
	.loc 2 166 18 view .LVU1535
.LBE169:
.LBE168:
	.loc 1 941 21 view .LVU1536
	jmp	.L336
.LVL597:
.L378:
	.loc 1 950 13 is_stmt 1 view .LVU1537
.LBB170:
.LBI170:
	.loc 2 156 19 view .LVU1538
.LBB171:
	.loc 2 163 5 view .LVU1539
	.loc 2 164 5 view .LVU1540
	.loc 2 166 5 view .LVU1541
	.loc 2 166 18 is_stmt 0 view .LVU1542
	subl	$9472, %eax
.LVL598:
	.loc 2 166 18 view .LVU1543
	movl	%eax, 12(%rsp)
.LVL599:
	.loc 2 166 18 view .LVU1544
.LBE171:
.LBE170:
	.loc 1 950 21 view .LVU1545
	jmp	.L336
.LVL600:
.L379:
	.loc 1 955 13 is_stmt 1 view .LVU1546
.LBB172:
.LBI172:
	.loc 2 156 19 view .LVU1547
.LBB173:
	.loc 2 163 5 view .LVU1548
	.loc 2 164 5 view .LVU1549
	.loc 2 166 5 view .LVU1550
	.loc 2 166 18 is_stmt 0 view .LVU1551
	subl	$9472, %eax
.LVL601:
	.loc 2 166 18 view .LVU1552
	movl	%eax, 12(%rsp)
.LVL602:
	.loc 2 166 18 view .LVU1553
.LBE173:
.LBE172:
	.loc 1 955 21 view .LVU1554
	jmp	.L336
.LVL603:
.L346:
	.loc 1 977 17 is_stmt 1 view .LVU1555
	.loc 1 977 20 is_stmt 0 view .LVU1556
	movq	%r13, (%rbx)
	.loc 1 978 17 is_stmt 1 view .LVU1557
	jmp	.L338
.LVL604:
.L345:
	.loc 1 982 13 view .LVU1558
	.loc 1 982 16 is_stmt 0 view .LVU1559
	movq	%r13, (%rbx)
	.loc 1 984 13 is_stmt 1 view .LVU1560
	.loc 1 984 15 is_stmt 0 view .LVU1561
	cmpl	$0, 40(%rsp)
	je	.L338
	.loc 1 987 25 view .LVU1562
	movl	$-9570, 12(%rsp)
	jmp	.L336
.LVL605:
.L344:
	.loc 1 994 9 is_stmt 1 view .LVU1563
	.loc 1 994 18 is_stmt 0 view .LVU1564
	movl	512(%r12), %edx
	.loc 1 994 30 view .LVU1565
	movl	44(%rsp), %eax
.LVL606:
	.loc 1 994 11 view .LVU1566
	testl	%eax, %edx
	jne	.L364
	.loc 1 997 9 is_stmt 1 view .LVU1567
	.loc 1 997 24 is_stmt 0 view .LVU1568
	orl	%eax, %edx
	movl	%edx, 512(%r12)
	.loc 1 999 9 is_stmt 1 view .LVU1569
	cmpl	$256, %eax
	je	.L348
	jg	.L349
	cmpl	$8, %eax
	je	.L350
	cmpl	$32, %eax
	jne	.L380
	.loc 1 1024 13 view .LVU1570
	.loc 1 1024 25 is_stmt 0 view .LVU1571
	leaq	448(%r12), %rdx
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	x509_get_subject_alt_name
.LVL607:
	.loc 1 1024 15 view .LVU1572
	testl	%eax, %eax
	je	.L338
	.loc 1 1026 23 view .LVU1573
	movl	%eax, 12(%rsp)
	jmp	.L336
.LVL608:
.L380:
	.loc 1 999 9 view .LVU1574
	cmpl	$4, %eax
	jne	.L353
	.loc 1 1010 13 is_stmt 1 view .LVU1575
	.loc 1 1010 25 is_stmt 0 view .LVU1576
	leaq	524(%r12), %rdx
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	x509_get_key_usage
.LVL609:
	.loc 1 1010 15 view .LVU1577
	testl	%eax, %eax
	je	.L338
	.loc 1 1012 23 view .LVU1578
	movl	%eax, 12(%rsp)
	jmp	.L336
.LVL610:
.L349:
	.loc 1 999 9 view .LVU1579
	cmpl	$2048, %eax
	je	.L354
	cmpl	$65536, %eax
	jne	.L353
	.loc 1 1031 13 is_stmt 1 view .LVU1580
	.loc 1 1031 25 is_stmt 0 view .LVU1581
	leaq	560(%r12), %rdx
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	x509_get_ns_cert_type
.LVL611:
	.loc 1 1031 15 view .LVU1582
	testl	%eax, %eax
	je	.L338
	.loc 1 1033 23 view .LVU1583
	movl	%eax, 12(%rsp)
	jmp	.L336
.LVL612:
.L348:
	.loc 1 1003 13 is_stmt 1 view .LVU1584
	.loc 1 1003 25 is_stmt 0 view .LVU1585
	leaq	520(%r12), %rcx
	leaq	516(%r12), %rdx
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	x509_get_basic_constraints
.LVL613:
	.loc 1 1003 15 view .LVU1586
	testl	%eax, %eax
	je	.L338
	.loc 1 1005 23 view .LVU1587
	movl	%eax, 12(%rsp)
	jmp	.L336
.LVL614:
.L354:
	.loc 1 1017 13 is_stmt 1 view .LVU1588
	.loc 1 1017 25 is_stmt 0 view .LVU1589
	leaq	528(%r12), %rdx
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	x509_get_ext_key_usage
.LVL615:
	.loc 1 1017 15 view .LVU1590
	testl	%eax, %eax
	je	.L338
	.loc 1 1019 23 view .LVU1591
	movl	%eax, 12(%rsp)
	jmp	.L336
.LVL616:
.L350:
	.loc 1 1038 13 is_stmt 1 view .LVU1592
	.loc 1 1038 25 is_stmt 0 view .LVU1593
	leaq	480(%r12), %rdx
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	x509_get_certificate_policies
.LVL617:
	movl	%eax, %ebp
.LVL618:
	.loc 1 1038 15 view .LVU1594
	testl	%eax, %eax
	je	.L338
	.loc 1 1043 17 is_stmt 1 view .LVU1595
	.loc 1 1043 25 is_stmt 0 view .LVU1596
	cmpl	$-8320, %eax
	sete	%dl
	.loc 1 1043 71 view .LVU1597
	movq	16(%rsp), %r10
	testq	%r10, %r10
	setne	%al
.LVL619:
	.loc 1 1043 19 view .LVU1598
	testb	%al, %dl
	je	.L357
	.loc 1 1044 21 discriminator 1 view .LVU1599
	leaq	48(%rsp), %rdx
	movq	%r13, %r9
	movq	%r15, %r8
	movl	40(%rsp), %ecx
	movq	%r12, %rsi
	movq	24(%rsp), %rdi
	call	*%r10
.LVL620:
	.loc 1 1043 79 discriminator 1 view .LVU1600
	testl	%eax, %eax
	je	.L338
.L357:
	.loc 1 1048 17 is_stmt 1 view .LVU1601
	.loc 1 1048 19 is_stmt 0 view .LVU1602
	cmpl	$0, 40(%rsp)
	jne	.L370
	.loc 1 1057 17 is_stmt 1 view .LVU1603
	.loc 1 1057 19 is_stmt 0 view .LVU1604
	cmpl	$-8320, %ebp
	je	.L338
	.loc 1 1058 27 view .LVU1605
	movl	%ebp, 12(%rsp)
	jmp	.L336
.LVL621:
.L353:
	.loc 1 1068 13 is_stmt 1 view .LVU1606
	.loc 1 1068 15 is_stmt 0 view .LVU1607
	cmpl	$0, 40(%rsp)
	jne	.L372
	.loc 1 1071 17 is_stmt 1 view .LVU1608
	.loc 1 1071 20 is_stmt 0 view .LVU1609
	movq	%r13, (%rbx)
	jmp	.L338
.LVL622:
.L361:
	.loc 1 961 21 view .LVU1610
	movl	$-9574, 12(%rsp)
	jmp	.L336
.LVL623:
.L364:
	.loc 1 995 19 view .LVU1611
	movl	$-9472, 12(%rsp)
	jmp	.L336
.LVL624:
.L370:
	.loc 1 1049 27 view .LVU1612
	movl	%ebp, 12(%rsp)
	jmp	.L336
.LVL625:
.L372:
	.loc 1 1069 23 view .LVU1613
	movl	$-8320, 12(%rsp)
	jmp	.L336
.LVL626:
.L375:
	.loc 1 1069 23 view .LVU1614
.LBE165:
	.loc 1 1075 5 is_stmt 1 view .LVU1615
	.loc 1 1075 7 is_stmt 0 view .LVU1616
	je	.L336
	.loc 1 1076 17 view .LVU1617
	movl	$-9574, 12(%rsp)
	jmp	.L336
.LVL627:
.L360:
	.loc 1 914 15 view .LVU1618
	movl	$0, 12(%rsp)
.LVL628:
.L336:
	.loc 1 1080 1 view .LVU1619
	movl	12(%rsp), %eax
	addq	$88, %rsp
.LCFI242:
	.cfi_def_cfa_offset 56
	popq	%rbx
.LCFI243:
	.cfi_def_cfa_offset 48
	popq	%rbp
.LCFI244:
	.cfi_def_cfa_offset 40
	popq	%r12
.LCFI245:
	.cfi_def_cfa_offset 32
	popq	%r13
.LCFI246:
	.cfi_def_cfa_offset 24
	popq	%r14
.LCFI247:
	.cfi_def_cfa_offset 16
	popq	%r15
.LCFI248:
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE58:
	.size	x509_get_crt_ext, .-x509_get_crt_ext
	.section	.rodata.str1.1
.LC24:
	.string	"\n%s    <unsupported>"
.LC25:
	.string	"\n%s    <malformed>"
.LC26:
	.string	"\n%s    otherName :"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC27:
	.string	"\n%s        hardware module name :"
	.align 8
.LC28:
	.string	"\n%s            hardware type          : "
	.align 8
.LC29:
	.string	"\n%s            hardware serial number : "
	.section	.rodata.str1.1
.LC30:
	.string	"\n%s    dNSName : "
	.text
	.type	x509_info_subject_alt_name, @function
x509_info_subject_alt_name:
.LVL629:
.LFB69:
	.loc 1 1837 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 1837 1 is_stmt 0 view .LVU1621
	pushq	%r15
.LCFI249:
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
.LCFI250:
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
.LCFI251:
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
.LCFI252:
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
.LCFI253:
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
.LCFI254:
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$88, %rsp
.LCFI255:
	.cfi_def_cfa_offset 144
	movq	%rdi, %r15
	movq	%rsi, %r13
	movq	%rdx, %rbp
	movq	%rcx, %r12
	.loc 1 1838 5 is_stmt 1 view .LVU1622
.LVL630:
	.loc 1 1839 5 view .LVU1623
	.loc 1 1839 12 is_stmt 0 view .LVU1624
	movq	(%rsi), %rbx
.LVL631:
	.loc 1 1840 5 is_stmt 1 view .LVU1625
	.loc 1 1840 11 is_stmt 0 view .LVU1626
	movq	(%rdi), %r14
.LVL632:
	.loc 1 1841 5 is_stmt 1 view .LVU1627
	.loc 1 1842 5 view .LVU1628
	.loc 1 1843 5 view .LVU1629
	.loc 1 1845 5 view .LVU1630
	.loc 1 1845 10 is_stmt 0 view .LVU1631
	jmp	.L382
.LVL633:
.L417:
	.loc 1 1853 17 is_stmt 1 view .LVU1632
	.loc 1 1853 23 is_stmt 0 view .LVU1633
	movq	%r12, %rcx
	leaq	.LC24(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r14, %rdi
	movl	$0, %eax
.LVL634:
	.loc 1 1853 23 view .LVU1634
	call	snprintf@PLT
.LVL635:
	.loc 1 1854 17 is_stmt 1 view .LVU1635
	.loc 1 1854 17 view .LVU1636
	testl	%eax, %eax
	js	.L396
	.loc 1 1854 17 is_stmt 0 discriminator 2 view .LVU1637
	cltq
	.loc 1 1854 17 discriminator 2 view .LVU1638
	cmpq	%rbx, %rax
	jnb	.L397
	.loc 1 1854 17 is_stmt 1 discriminator 4 view .LVU1639
	subq	%rax, %rbx
.LVL636:
	.loc 1 1854 17 discriminator 4 view .LVU1640
	addq	%rax, %r14
.LVL637:
	.loc 1 1854 17 discriminator 4 view .LVU1641
.L386:
	.loc 1 1859 17 discriminator 5 view .LVU1642
	.loc 1 1861 13 discriminator 5 view .LVU1643
	.loc 1 1861 17 is_stmt 0 discriminator 5 view .LVU1644
	movq	24(%rbp), %rbp
.LVL638:
	.loc 1 1862 13 is_stmt 1 discriminator 5 view .LVU1645
.L382:
	.loc 1 1845 16 view .LVU1646
	testq	%rbp, %rbp
	je	.L416
	.loc 1 1847 9 view .LVU1647
	movq	%rsp, %rsi
	pxor	%xmm0, %xmm0
	movaps	%xmm0, (%rsp)
	movaps	%xmm0, 16(%rsp)
	movaps	%xmm0, 32(%rsp)
	movaps	%xmm0, 48(%rsp)
	movaps	%xmm0, 64(%rsp)
	.loc 1 1848 9 view .LVU1648
	.loc 1 1848 21 is_stmt 0 view .LVU1649
	movq	%rbp, %rdi
	call	mbedtls_x509_parse_subject_alt_name
.LVL639:
	.loc 1 1849 9 is_stmt 1 view .LVU1650
	.loc 1 1849 11 is_stmt 0 view .LVU1651
	testl	%eax, %eax
	je	.L383
	.loc 1 1851 13 is_stmt 1 view .LVU1652
	.loc 1 1851 15 is_stmt 0 view .LVU1653
	cmpl	$-8320, %eax
	je	.L417
	.loc 1 1858 17 is_stmt 1 view .LVU1654
	.loc 1 1858 23 is_stmt 0 view .LVU1655
	movq	%r12, %rcx
	leaq	.LC25(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r14, %rdi
	movl	$0, %eax
.LVL640:
	.loc 1 1858 23 view .LVU1656
	call	snprintf@PLT
.LVL641:
	.loc 1 1859 17 is_stmt 1 view .LVU1657
	.loc 1 1859 17 view .LVU1658
	testl	%eax, %eax
	js	.L398
	.loc 1 1859 17 is_stmt 0 discriminator 2 view .LVU1659
	cltq
	.loc 1 1859 17 discriminator 2 view .LVU1660
	cmpq	%rbx, %rax
	jnb	.L399
	.loc 1 1859 17 is_stmt 1 discriminator 4 view .LVU1661
	subq	%rax, %rbx
.LVL642:
	.loc 1 1859 17 discriminator 4 view .LVU1662
	addq	%rax, %r14
.LVL643:
	.loc 1 1859 17 is_stmt 0 discriminator 4 view .LVU1663
	jmp	.L386
.LVL644:
.L383:
	.loc 1 1865 9 is_stmt 1 view .LVU1664
	.loc 1 1865 20 is_stmt 0 view .LVU1665
	movl	(%rsp), %eax
.LVL645:
	.loc 1 1865 9 view .LVU1666
	testl	%eax, %eax
	je	.L388
	cmpl	$2, %eax
	je	.L389
	.loc 1 1930 17 is_stmt 1 view .LVU1667
	.loc 1 1930 23 is_stmt 0 view .LVU1668
	movq	%r12, %rcx
	leaq	.LC24(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r14, %rdi
	movl	$0, %eax
	call	snprintf@PLT
.LVL646:
	.loc 1 1931 17 is_stmt 1 view .LVU1669
	.loc 1 1931 17 view .LVU1670
	testl	%eax, %eax
	js	.L412
	.loc 1 1931 17 is_stmt 0 discriminator 2 view .LVU1671
	cltq
	.loc 1 1931 17 discriminator 2 view .LVU1672
	cmpq	%rbx, %rax
	jnb	.L413
	.loc 1 1931 17 is_stmt 1 discriminator 4 view .LVU1673
	subq	%rax, %rbx
.LVL647:
	.loc 1 1931 17 discriminator 4 view .LVU1674
	addq	%rax, %r14
.LVL648:
	.loc 1 1931 17 discriminator 4 view .LVU1675
	.loc 1 1932 17 discriminator 4 view .LVU1676
.L392:
	.loc 1 1935 9 view .LVU1677
	.loc 1 1935 13 is_stmt 0 view .LVU1678
	movq	24(%rbp), %rbp
.LVL649:
	.loc 1 1935 13 view .LVU1679
	jmp	.L382
.L388:
.LBB174:
	.loc 1 1872 17 is_stmt 1 view .LVU1680
.LVL650:
	.loc 1 1874 17 view .LVU1681
	.loc 1 1874 23 is_stmt 0 view .LVU1682
	movq	%r12, %rcx
	leaq	.LC26(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r14, %rdi
	movl	$0, %eax
	call	snprintf@PLT
.LVL651:
	.loc 1 1875 17 is_stmt 1 view .LVU1683
	.loc 1 1875 17 view .LVU1684
	testl	%eax, %eax
	js	.L400
	.loc 1 1875 17 is_stmt 0 discriminator 2 view .LVU1685
	cltq
	.loc 1 1875 17 discriminator 2 view .LVU1686
	cmpq	%rbx, %rax
	jnb	.L401
	.loc 1 1875 17 is_stmt 1 discriminator 4 view .LVU1687
	subq	%rax, %rbx
.LVL652:
	.loc 1 1875 17 discriminator 4 view .LVU1688
	addq	%rax, %r14
.LVL653:
	.loc 1 1875 17 discriminator 4 view .LVU1689
	.loc 1 1877 17 discriminator 4 view .LVU1690
	.loc 1 1877 21 is_stmt 0 discriminator 4 view .LVU1691
	movq	40(%rsp), %rdx
	cmpq	$8, %rdx
	jne	.L391
	.loc 1 1877 21 discriminator 2 view .LVU1692
	movq	48(%rsp), %rsi
	leaq	.LC1(%rip), %rdi
	call	memcmp@PLT
.LVL654:
	.loc 1 1877 21 discriminator 2 view .LVU1693
	testl	%eax, %eax
	je	.L392
.L391:
	.loc 1 1880 21 is_stmt 1 view .LVU1694
	.loc 1 1880 27 is_stmt 0 view .LVU1695
	movq	%r12, %rcx
	leaq	.LC27(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r14, %rdi
	movl	$0, %eax
	call	snprintf@PLT
.LVL655:
	.loc 1 1881 21 is_stmt 1 view .LVU1696
	.loc 1 1881 21 view .LVU1697
	testl	%eax, %eax
	js	.L402
	.loc 1 1881 21 is_stmt 0 discriminator 2 view .LVU1698
	cltq
	.loc 1 1881 21 discriminator 2 view .LVU1699
	cmpq	%rbx, %rax
	jnb	.L403
	.loc 1 1881 21 is_stmt 1 discriminator 4 view .LVU1700
	subq	%rax, %rbx
.LVL656:
	.loc 1 1881 21 discriminator 4 view .LVU1701
	addq	%rax, %r14
.LVL657:
	.loc 1 1881 21 discriminator 4 view .LVU1702
	.loc 1 1882 21 discriminator 4 view .LVU1703
	.loc 1 1882 27 is_stmt 0 discriminator 4 view .LVU1704
	movq	%r12, %rcx
	leaq	.LC28(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r14, %rdi
	movl	$0, %eax
.LVL658:
	.loc 1 1882 27 discriminator 4 view .LVU1705
	call	snprintf@PLT
.LVL659:
	.loc 1 1883 21 is_stmt 1 discriminator 4 view .LVU1706
	.loc 1 1883 21 discriminator 4 view .LVU1707
	testl	%eax, %eax
	js	.L404
	.loc 1 1883 21 is_stmt 0 discriminator 2 view .LVU1708
	cltq
	.loc 1 1883 21 discriminator 2 view .LVU1709
	cmpq	%rbx, %rax
	jnb	.L405
	.loc 1 1883 21 is_stmt 1 discriminator 4 view .LVU1710
	subq	%rax, %rbx
.LVL660:
	.loc 1 1883 21 discriminator 4 view .LVU1711
	addq	%rax, %r14
.LVL661:
	.loc 1 1883 21 discriminator 4 view .LVU1712
	.loc 1 1885 21 discriminator 4 view .LVU1713
	.loc 1 1885 27 is_stmt 0 discriminator 4 view .LVU1714
	leaq	32(%rsp), %rdx
	movq	%rbx, %rsi
	movq	%r14, %rdi
	call	mbedtls_oid_get_numeric_string@PLT
.LVL662:
	.loc 1 1886 21 is_stmt 1 discriminator 4 view .LVU1715
	.loc 1 1886 21 discriminator 4 view .LVU1716
	testl	%eax, %eax
	js	.L406
	.loc 1 1886 21 is_stmt 0 discriminator 2 view .LVU1717
	cltq
	.loc 1 1886 21 discriminator 2 view .LVU1718
	cmpq	%rbx, %rax
	jnb	.L407
	.loc 1 1886 21 is_stmt 1 discriminator 4 view .LVU1719
	subq	%rax, %rbx
.LVL663:
	.loc 1 1886 21 discriminator 4 view .LVU1720
	addq	%rax, %r14
.LVL664:
	.loc 1 1886 21 discriminator 4 view .LVU1721
	.loc 1 1888 21 discriminator 4 view .LVU1722
	.loc 1 1888 27 is_stmt 0 discriminator 4 view .LVU1723
	movq	%r12, %rcx
	leaq	.LC29(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r14, %rdi
	movl	$0, %eax
.LVL665:
	.loc 1 1888 27 discriminator 4 view .LVU1724
	call	snprintf@PLT
.LVL666:
	.loc 1 1889 21 is_stmt 1 discriminator 4 view .LVU1725
	.loc 1 1889 21 discriminator 4 view .LVU1726
	testl	%eax, %eax
	js	.L408
	.loc 1 1889 21 is_stmt 0 discriminator 2 view .LVU1727
	cltq
	.loc 1 1889 21 discriminator 2 view .LVU1728
	cmpq	%rbx, %rax
	jnb	.L409
	.loc 1 1889 21 is_stmt 1 discriminator 4 view .LVU1729
	subq	%rax, %rbx
.LVL667:
	.loc 1 1889 21 discriminator 4 view .LVU1730
	addq	%rax, %r14
.LVL668:
	.loc 1 1889 21 discriminator 4 view .LVU1731
	.loc 1 1891 21 discriminator 4 view .LVU1732
	.loc 1 1891 67 is_stmt 0 discriminator 4 view .LVU1733
	movq	64(%rsp), %rdx
	.loc 1 1891 23 discriminator 4 view .LVU1734
	cmpq	%rbx, %rdx
	jnb	.L418
	.loc 1 1897 21 is_stmt 1 view .LVU1735
	movq	72(%rsp), %rsi
	movq	%r14, %rdi
	call	memcpy@PLT
.LVL669:
	.loc 1 1899 21 view .LVU1736
	.loc 1 1899 68 is_stmt 0 view .LVU1737
	movq	64(%rsp), %rax
	.loc 1 1899 23 view .LVU1738
	addq	%rax, %r14
.LVL670:
	.loc 1 1901 21 is_stmt 1 view .LVU1739
	.loc 1 1901 23 is_stmt 0 view .LVU1740
	subq	%rax, %rbx
.LVL671:
	.loc 1 1901 23 view .LVU1741
	jmp	.L392
.LVL672:
.L418:
	.loc 1 1893 25 is_stmt 1 view .LVU1742
	.loc 1 1893 28 is_stmt 0 view .LVU1743
	movb	$0, (%r14)
	.loc 1 1894 25 is_stmt 1 view .LVU1744
	.loc 1 1894 31 is_stmt 0 view .LVU1745
	movl	$-10624, %eax
.LVL673:
	.loc 1 1894 31 view .LVU1746
	jmp	.L381
.LVL674:
.L389:
	.loc 1 1894 31 view .LVU1747
.LBE174:
	.loc 1 1912 17 is_stmt 1 view .LVU1748
	.loc 1 1912 23 is_stmt 0 view .LVU1749
	movq	%r12, %rcx
	leaq	.LC30(%rip), %rdx
	movq	%rbx, %rsi
	movq	%r14, %rdi
	movl	$0, %eax
	call	snprintf@PLT
.LVL675:
	.loc 1 1913 17 is_stmt 1 view .LVU1750
	.loc 1 1913 17 view .LVU1751
	testl	%eax, %eax
	js	.L410
	.loc 1 1913 17 is_stmt 0 discriminator 2 view .LVU1752
	cltq
	.loc 1 1913 17 discriminator 2 view .LVU1753
	cmpq	%rbx, %rax
	jnb	.L411
	.loc 1 1913 17 is_stmt 1 discriminator 4 view .LVU1754
	subq	%rax, %rbx
.LVL676:
	.loc 1 1913 17 discriminator 4 view .LVU1755
	addq	%rax, %r14
.LVL677:
	.loc 1 1913 17 discriminator 4 view .LVU1756
	.loc 1 1914 17 discriminator 4 view .LVU1757
	.loc 1 1914 46 is_stmt 0 discriminator 4 view .LVU1758
	movq	16(%rsp), %rdx
	.loc 1 1914 19 discriminator 4 view .LVU1759
	cmpq	%rbx, %rdx
	jnb	.L419
	.loc 1 1920 17 is_stmt 1 view .LVU1760
	movq	24(%rsp), %rsi
	movq	%r14, %rdi
	call	memcpy@PLT
.LVL678:
	.loc 1 1921 17 view .LVU1761
	.loc 1 1921 47 is_stmt 0 view .LVU1762
	movq	16(%rsp), %rax
	.loc 1 1921 19 view .LVU1763
	addq	%rax, %r14
.LVL679:
	.loc 1 1922 17 is_stmt 1 view .LVU1764
	.loc 1 1922 19 is_stmt 0 view .LVU1765
	subq	%rax, %rbx
.LVL680:
	.loc 1 1924 13 is_stmt 1 view .LVU1766
	jmp	.L392
.LVL681:
.L419:
	.loc 1 1916 21 view .LVU1767
	.loc 1 1916 24 is_stmt 0 view .LVU1768
	movb	$0, (%r14)
	.loc 1 1917 21 is_stmt 1 view .LVU1769
	.loc 1 1917 27 is_stmt 0 view .LVU1770
	movl	$-10624, %eax
.LVL682:
	.loc 1 1917 27 view .LVU1771
	jmp	.L381
.LVL683:
.L416:
	.loc 1 1938 5 is_stmt 1 view .LVU1772
	.loc 1 1938 8 is_stmt 0 view .LVU1773
	movb	$0, (%r14)
	.loc 1 1940 5 is_stmt 1 view .LVU1774
	.loc 1 1940 11 is_stmt 0 view .LVU1775
	movq	%rbx, 0(%r13)
	.loc 1 1941 5 is_stmt 1 view .LVU1776
	.loc 1 1941 10 is_stmt 0 view .LVU1777
	movq	%r14, (%r15)
	.loc 1 1943 5 is_stmt 1 view .LVU1778
	.loc 1 1943 11 is_stmt 0 view .LVU1779
	movl	$0, %eax
.L381:
	.loc 1 1944 1 view .LVU1780
	addq	$88, %rsp
.LCFI256:
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
.LCFI257:
	.cfi_def_cfa_offset 48
.LVL684:
	.loc 1 1944 1 view .LVU1781
	popq	%rbp
.LCFI258:
	.cfi_def_cfa_offset 40
.LVL685:
	.loc 1 1944 1 view .LVU1782
	popq	%r12
.LCFI259:
	.cfi_def_cfa_offset 32
.LVL686:
	.loc 1 1944 1 view .LVU1783
	popq	%r13
.LCFI260:
	.cfi_def_cfa_offset 24
.LVL687:
	.loc 1 1944 1 view .LVU1784
	popq	%r14
.LCFI261:
	.cfi_def_cfa_offset 16
.LVL688:
	.loc 1 1944 1 view .LVU1785
	popq	%r15
.LCFI262:
	.cfi_def_cfa_offset 8
.LVL689:
	.loc 1 1944 1 view .LVU1786
	ret
.LVL690:
.L396:
.LCFI263:
	.cfi_restore_state
	.loc 1 1854 17 view .LVU1787
	movl	$-10624, %eax
.LVL691:
	.loc 1 1854 17 view .LVU1788
	jmp	.L381
.LVL692:
.L397:
	.loc 1 1854 17 view .LVU1789
	movl	$-10624, %eax
.LVL693:
	.loc 1 1854 17 view .LVU1790
	jmp	.L381
.LVL694:
.L398:
	.loc 1 1859 17 view .LVU1791
	movl	$-10624, %eax
.LVL695:
	.loc 1 1859 17 view .LVU1792
	jmp	.L381
.LVL696:
.L399:
	.loc 1 1859 17 view .LVU1793
	movl	$-10624, %eax
.LVL697:
	.loc 1 1859 17 view .LVU1794
	jmp	.L381
.LVL698:
.L400:
.LBB175:
	.loc 1 1875 17 view .LVU1795
	movl	$-10624, %eax
.LVL699:
	.loc 1 1875 17 view .LVU1796
	jmp	.L381
.LVL700:
.L401:
	.loc 1 1875 17 view .LVU1797
	movl	$-10624, %eax
.LVL701:
	.loc 1 1875 17 view .LVU1798
	jmp	.L381
.LVL702:
.L402:
	.loc 1 1881 21 view .LVU1799
	movl	$-10624, %eax
.LVL703:
	.loc 1 1881 21 view .LVU1800
	jmp	.L381
.LVL704:
.L403:
	.loc 1 1881 21 view .LVU1801
	movl	$-10624, %eax
.LVL705:
	.loc 1 1881 21 view .LVU1802
	jmp	.L381
.LVL706:
.L404:
	.loc 1 1883 21 view .LVU1803
	movl	$-10624, %eax
.LVL707:
	.loc 1 1883 21 view .LVU1804
	jmp	.L381
.LVL708:
.L405:
	.loc 1 1883 21 view .LVU1805
	movl	$-10624, %eax
.LVL709:
	.loc 1 1883 21 view .LVU1806
	jmp	.L381
.LVL710:
.L406:
	.loc 1 1886 21 view .LVU1807
	movl	$-10624, %eax
.LVL711:
	.loc 1 1886 21 view .LVU1808
	jmp	.L381
.LVL712:
.L407:
	.loc 1 1886 21 view .LVU1809
	movl	$-10624, %eax
.LVL713:
	.loc 1 1886 21 view .LVU1810
	jmp	.L381
.LVL714:
.L408:
	.loc 1 1889 21 view .LVU1811
	movl	$-10624, %eax
.LVL715:
	.loc 1 1889 21 view .LVU1812
	jmp	.L381
.LVL716:
.L409:
	.loc 1 1889 21 view .LVU1813
	movl	$-10624, %eax
.LVL717:
	.loc 1 1889 21 view .LVU1814
	jmp	.L381
.LVL718:
.L410:
	.loc 1 1889 21 view .LVU1815
.LBE175:
	.loc 1 1913 17 view .LVU1816
	movl	$-10624, %eax
.LVL719:
	.loc 1 1913 17 view .LVU1817
	jmp	.L381
.LVL720:
.L411:
	.loc 1 1913 17 view .LVU1818
	movl	$-10624, %eax
.LVL721:
	.loc 1 1913 17 view .LVU1819
	jmp	.L381
.LVL722:
.L412:
	.loc 1 1931 17 view .LVU1820
	movl	$-10624, %eax
.LVL723:
	.loc 1 1931 17 view .LVU1821
	jmp	.L381
.LVL724:
.L413:
	.loc 1 1931 17 view .LVU1822
	movl	$-10624, %eax
.LVL725:
	.loc 1 1931 17 view .LVU1823
	jmp	.L381
	.cfi_endproc
.LFE69:
	.size	x509_info_subject_alt_name, .-x509_info_subject_alt_name
	.section	.rodata.str1.1
.LC31:
	.string	"true"
.LC32:
	.string	"false"
	.se