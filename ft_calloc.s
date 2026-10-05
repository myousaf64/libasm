default rel

section .text
global ft_calloc
extern malloc, __errno_location

ft_calloc:
	mov rax, rdi
	mul rsi ; rdx:rax = nmemb * size, CF set on overflow
	jc overflow
	push rax ; save size, align stack to 16 for the call
	mov rdi, rax
	call malloc wrt ..plt
	pop rcx
	cmp rax, 0x0
	je end
	mov rdi, rax
	mov rdx, rax ; keep pointer, rep stosb moves rdi
	xor eax, eax
	rep stosb
	mov rax, rdx
end:
	ret

overflow:
	sub rsp, 8 ; align stack to 16 for the call
	call __errno_location wrt ..plt
	add rsp, 8
	mov DWORD [rax], 12 ; ENOMEM
	xor rax, rax
	ret
