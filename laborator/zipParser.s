	.file	"zipParser.c"
	.section	.rodata
.LC0:
	.string	"Usage: zipParser zipFileName\n"
.LC1:
	.string	"rb"
.LC2:
	.string	"Can not open zip file!"
	.text
	.globl	main
	.type	main, @function
main:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movl	%edi, -52(%rbp)
	movq	%rsi, -64(%rbp)
	cmpl	$2, -52(%rbp)
	je	.L2
	movl	$.LC0, %edi
	call	printErr
.L2:
	movq	-64(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movl	$.LC1, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, -40(%rbp)
	cmpq	$0, -40(%rbp)
	jne	.L3
	movl	$.LC2, %edi
	call	printErr
.L3:
	leaq	-32(%rbp), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	findEOCD
	leaq	-32(%rbp), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	readCDFHs
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.globl	printErr
	.type	printErr, @function
printErr:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	stderr(%rip), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	fputs
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE3:
	.size	printErr, .-printErr
	.section	.rodata
	.align 8
.LC3:
	.string	"Reading has failed because it reached EOF!\n"
.LC4:
	.string	"Error when reading"
.LC5:
	.string	"Reading has failed\n"
	.text
	.globl	readDatav
	.type	readDatav, @function
readDatav:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	%rdx, -40(%rbp)
	movq	-40(%rbp), %rdx
	movl	-28(%rbp), %ecx
	movq	-24(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	readData
	movl	%eax, -4(%rbp)
	cmpl	$1, -4(%rbp)
	je	.L6
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	feof
	testl	%eax, %eax
	je	.L8
	movl	$.LC3, %edi
	call	printErr
	jmp	.L6
.L8:
	movl	$.LC4, %edi
	call	perror
	movl	$.LC5, %edi
	call	printErr
.L6:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	readDatav, .-readDatav
	.globl	readData
	.type	readData, @function
readData:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-24(%rbp), %rdx
	movl	-12(%rbp), %esi
	movq	-8(%rbp), %rax
	movq	%rdx, %rcx
	movl	$1, %edx
	movq	%rax, %rdi
	call	readDatai
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	readData, .-readData
	.globl	readDatai
	.type	readDatai, @function
readDatai:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	%edx, -16(%rbp)
	movq	%rcx, -24(%rbp)
	movl	-16(%rbp), %eax
	movslq	%eax, %rdx
	movl	-12(%rbp), %eax
	movslq	%eax, %rsi
	movq	-24(%rbp), %rcx
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	fread
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	readDatai, .-readDatai
	.section	.rodata
.LC6:
	.string	"Error in fseek!"
	.align 8
.LC7:
	.string	"Something went wrong when reading EOCD!"
.LC8:
	.string	"Error in ftell!"
	.text
	.globl	findEOCD
	.type	findEOCD, @function
findEOCD:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-40(%rbp), %rax
	movl	$2, %edx
	movq	$-21, %rsi
	movq	%rax, %rdi
	call	fseek
	movl	$0, -32(%rbp)
	movl	$0, -20(%rbp)
	movq	$0, -16(%rbp)
	jmp	.L14
.L21:
	jmp	.L15
.L17:
	movq	-40(%rbp), %rax
	movl	$1, %edx
	movq	$-1, %rsi
	movq	%rax, %rdi
	call	fseek
	cltq
	movq	%rax, -8(%rbp)
	cmpq	$-1, -8(%rbp)
	jne	.L16
	movl	$.LC6, %edi
	call	printErr
.L16:
	movq	-40(%rbp), %rdx
	leaq	-32(%rbp), %rax
	movl	$4, %esi
	movq	%rax, %rdi
	call	readDatav
	movq	-40(%rbp), %rax
	movl	$1, %edx
	movq	$-4, %rsi
	movq	%rax, %rdi
	call	fseek
	cltq
	movq	%rax, -8(%rbp)
	cmpq	$-1, -8(%rbp)
	jne	.L15
	movl	$.LC6, %edi
	call	printErr
.L15:
	movl	-32(%rbp), %eax
	cmpl	$101010256, %eax
	jne	.L17
	movl	-32(%rbp), %eax
	cmpl	$101010256, %eax
	je	.L18
	movl	$.LC7, %edi
	call	printErr
.L18:
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	ftell
	movq	%rax, -16(%rbp)
	cmpq	$-1, -16(%rbp)
	jne	.L19
	movl	$.LC8, %edi
	call	printErr
.L19:
	movq	-40(%rbp), %rax
	movl	$1, %edx
	movl	$16, %esi
	movq	%rax, %rdi
	call	fseek
	movq	-40(%rbp), %rdx
	leaq	-28(%rbp), %rax
	movl	$4, %esi
	movq	%rax, %rdi
	call	readDatav
	movl	-28(%rbp), %eax
	movl	%eax, %ecx
	movq	-40(%rbp), %rax
	movl	$0, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	fseek
	movq	-40(%rbp), %rdx
	leaq	-24(%rbp), %rax
	movl	$4, %esi
	movq	%rax, %rdi
	call	readDatav
	movl	-24(%rbp), %eax
	cmpl	$33639248, %eax
	jne	.L14
	movl	$1, -20(%rbp)
.L14:
	cmpl	$0, -20(%rbp)
	je	.L21
	movl	-32(%rbp), %edx
	movq	-48(%rbp), %rax
	movl	%edx, (%rax)
	movq	-16(%rbp), %rax
	leaq	10(%rax), %rcx
	movq	-40(%rbp), %rax
	movl	$0, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	fseek
	movq	-48(%rbp), %rax
	leaq	10(%rax), %rcx
	movq	-40(%rbp), %rax
	movq	%rax, %rdx
	movl	$2, %esi
	movq	%rcx, %rdi
	call	readDatav
	movq	-48(%rbp), %rax
	leaq	12(%rax), %rcx
	movq	-40(%rbp), %rax
	movq	%rax, %rdx
	movl	$4, %esi
	movq	%rcx, %rdi
	call	readDatav
	movq	-48(%rbp), %rax
	leaq	16(%rax), %rcx
	movq	-40(%rbp), %rax
	movq	%rax, %rdx
	movl	$4, %esi
	movq	%rcx, %rdi
	call	readDatav
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	findEOCD, .-findEOCD
	.section	.rodata
.LC9:
	.string	"Corrupted ZIP file!\n"
	.text
	.globl	readCDFHs
	.type	readCDFHs, @function
readCDFHs:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movl	16(%rax), %eax
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, -12(%rbp)
	movl	$0, -8(%rbp)
	jmp	.L23
.L25:
	movl	-12(%rbp), %ecx
	movq	-40(%rbp), %rax
	movl	$0, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	fseek
	movq	-40(%rbp), %rdx
	leaq	-20(%rbp), %rax
	movl	$4, %esi
	movq	%rax, %rdi
	call	readDatav
	movl	-20(%rbp), %eax
	cmpl	$33639248, %eax
	je	.L24
	movl	$.LC9, %edi
	call	printErr
.L24:
	movq	-40(%rbp), %rax
	movl	$1, %edx
	movl	$24, %esi
	movq	%rax, %rdi
	call	fseek
	movq	-40(%rbp), %rdx
	leaq	-26(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	readDatav
	movq	-40(%rbp), %rdx
	leaq	-24(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	readDatav
	movq	-40(%rbp), %rdx
	leaq	-22(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	readDatav
	movq	-40(%rbp), %rax
	movl	$1, %edx
	movl	$8, %esi
	movq	%rax, %rdi
	call	fseek
	movq	-40(%rbp), %rdx
	leaq	-16(%rbp), %rax
	movl	$4, %esi
	movq	%rax, %rdi
	call	readDatav
	movl	-16(%rbp), %eax
	movl	%eax, %edx
	movq	-40(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	dumpData
	movzwl	-26(%rbp), %eax
	movzwl	%ax, %eax
	leal	46(%rax), %edx
	movzwl	-24(%rbp), %eax
	movzwl	%ax, %eax
	addl	%eax, %edx
	movzwl	-22(%rbp), %eax
	movzwl	%ax, %eax
	addl	%edx, %eax
	addl	%eax, -12(%rbp)
	addl	$1, -8(%rbp)
.L23:
	movq	-48(%rbp), %rax
	movzwl	10(%rax), %eax
	movzwl	%ax, %eax
	cmpl	-8(%rbp), %eax
	jg	.L25
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	readCDFHs, .-readCDFHs
	.section	.rodata
	.align 8
.LC10:
	.string	"LOCAL FILE HEADER signature error!\n"
.LC11:
	.string	"File is compressed!\n"
	.align 8
.LC12:
	.string	"File is probably compressed! (compressedSize and uncompressedSize sizes do not match)\n"
.LC13:
	.string	"File name: %s\n"
	.align 8
.LC14:
	.string	"The file could not be created!"
.LC15:
	.string	"wb"
	.align 8
.LC16:
	.string	"The file with name %s was not created!\n"
	.align 8
.LC17:
	.string	"Not enough memory for file %s !\n"
	.align 8
.LC18:
	.string	"Not all data was read/written!"
	.text
	.globl	dumpData
	.type	dumpData, @function
dumpData:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%rdi, -72(%rbp)
	movq	%rsi, -80(%rbp)
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rax
	movl	$0, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	fseek
	movq	-72(%rbp), %rdx
	leaq	-52(%rbp), %rax
	movl	$4, %esi
	movq	%rax, %rdi
	call	readDatav
	movl	-52(%rbp), %eax
	cmpl	$67324752, %eax
	je	.L27
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$35, %edx
	movl	$1, %esi
	movl	$.LC10, %edi
	call	fwrite
	jmp	.L26
.L27:
	movq	-72(%rbp), %rax
	movl	$1, %edx
	movl	$4, %esi
	movq	%rax, %rdi
	call	fseek
	movq	-72(%rbp), %rdx
	leaq	-58(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	readDatav
	movzwl	-58(%rbp), %eax
	testw	%ax, %ax
	je	.L29
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$20, %edx
	movl	$1, %esi
	movl	$.LC11, %edi
	call	fwrite
	jmp	.L26
.L29:
	movq	-72(%rbp), %rax
	movl	$1, %edx
	movl	$8, %esi
	movq	%rax, %rdi
	call	fseek
	movq	-72(%rbp), %rdx
	leaq	-48(%rbp), %rax
	movl	$4, %esi
	movq	%rax, %rdi
	call	readDatav
	movq	-72(%rbp), %rdx
	leaq	-44(%rbp), %rax
	movl	$4, %esi
	movq	%rax, %rdi
	call	readDatav
	movl	-48(%rbp), %edx
	movl	-44(%rbp), %eax
	cmpl	%eax, %edx
	je	.L30
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$86, %edx
	movl	$1, %esi
	movl	$.LC12, %edi
	call	fwrite
	jmp	.L26
.L30:
	movq	-72(%rbp), %rdx
	leaq	-56(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	readDatav
	movq	-72(%rbp), %rdx
	leaq	-54(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	readDatav
	movzwl	-56(%rbp), %eax
	movzwl	%ax, %eax
	addl	$1, %eax
	cltq
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -24(%rbp)
	movzwl	-56(%rbp), %eax
	movzwl	%ax, %ecx
	movq	-72(%rbp), %rdx
	movq	-24(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	readDatav
	movzwl	-56(%rbp), %eax
	movzwl	%ax, %edx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	movq	-24(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC13, %edi
	movl	$0, %eax
	call	printf
	movzwl	-54(%rbp), %eax
	movzwl	%ax, %ecx
	movq	-72(%rbp), %rax
	movl	$1, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	fseek
	movq	-24(%rbp), %rax
	movl	$292, %edx
	movl	$193, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open
	movl	%eax, -40(%rbp)
	cmpl	$-1, -40(%rbp)
	jne	.L31
	call	__errno_location
	movl	(%rax), %eax
	cmpl	$21, %eax
	jne	.L32
	movq	-24(%rbp), %rax
	movl	$509, %esi
	movq	%rax, %rdi
	call	mkdir
	movl	%eax, -36(%rbp)
	cmpl	$-1, -36(%rbp)
	je	.L32
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	free
	jmp	.L26
.L32:
	movl	$.LC14, %edi
	call	perror
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	free
	jmp	.L26
.L31:
	movl	-40(%rbp), %eax
	movl	$.LC15, %esi
	movl	%eax, %edi
	call	fdopen
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jne	.L34
	movq	stderr(%rip), %rax
	movq	-24(%rbp), %rdx
	movl	$.LC16, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	free
	jmp	.L26
.L34:
	movl	-44(%rbp), %eax
	movl	%eax, %eax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jne	.L35
	movq	stderr(%rip), %rax
	movq	-24(%rbp), %rdx
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	free
	jmp	.L26
.L35:
	movl	-44(%rbp), %eax
	movl	%eax, %edx
	movq	-72(%rbp), %rcx
	movq	-8(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	readDatai
	movl	%eax, -32(%rbp)
	movl	-32(%rbp), %eax
	movslq	%eax, %rdx
	movq	-16(%rbp), %rcx
	movq	-8(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	fwrite
	movl	%eax, -28(%rbp)
	movl	-28(%rbp), %edx
	movl	-44(%rbp), %eax
	cmpl	%eax, %edx
	je	.L36
	movl	$.LC18, %edi
	call	perror
.L36:
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	free
.L26:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	dumpData, .-dumpData
	.ident	"GCC: (Ubuntu 4.8.4-2ubuntu1~14.04.3) 4.8.4"
	.section	.note.GNU-stack,"",@progbits
