	.file	"L4-1.c"
	.intel_syntax noprefix
	.text
	.globl	absdiff2
	.type	absdiff2, @function
absdiff2:
.LFB0:
	.cfi_startproc
	push	ebx
	.cfi_def_cfa_offset 8
	.cfi_offset 3, -8
	mov	ecx, DWORD PTR [esp+8]
	mov	edx, DWORD PTR [esp+12]
	mov	eax, edx
	sub	eax, ecx
	mov	ebx, ecx
	sub	ebx, edx
	cmp	ecx, edx
	cmovge	eax, ebx
	pop	ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE0:
	.size	absdiff2, .-absdiff2
	.globl	cmovdiff
	.type	cmovdiff, @function
cmovdiff:
.LFB1:
	.cfi_startproc
	push	ebx
	.cfi_def_cfa_offset 8
	.cfi_offset 3, -8
	mov	edx, DWORD PTR [esp+8]
	mov	ecx, DWORD PTR [esp+12]
	mov	eax, edx
	sub	eax, ecx
	mov	ebx, ecx
	sub	ebx, edx
	cmp	ecx, edx
	cmovg	eax, ebx
	pop	ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE1:
	.size	cmovdiff, .-cmovdiff
	.globl	absdiff3
	.type	absdiff3, @function
absdiff3:
.LFB2:
	.cfi_startproc
	mov	eax, DWORD PTR [esp+4]
	mov	edx, DWORD PTR [esp+8]
	cmp	eax, edx
	jge	.L10
	mov	DWORD PTR lcount, 10
	sub	edx, eax
	mov	eax, edx
	ret
.L10:
	mov	DWORD PTR lcount, 20
	sub	eax, edx
	ret
	.cfi_endproc
.LFE2:
	.size	absdiff3, .-absdiff3
	.globl	lcount
	.bss
	.align 4
	.type	lcount, @object
	.size	lcount, 4
lcount:
	.zero	4
	.ident	"GCC: (Ubuntu 4.8.4-2ubuntu1~14.04.3) 4.8.4"
	.section	.note.GNU-stack,"",@progbits
