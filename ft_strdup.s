default rel ; to allow the variable declaration to be relative in the .data section

section .text
global ft_strdup
extern ft_strlen, malloc, ft_strcpy

ft_strdup:
	xor rcx, rcx
	xor rax, rax
	cmp rdi, 0x0
	je end
	push rdi ; save src, align stack to 16 for the calls
	call ft_strlen
	inc rax
	mov rdi, rax 
	call malloc wrt ..plt ; Allow position independatand tables to external library like doing lea rdi, [rel msg]
	pop rsi
	cmp rax, 0x0
	je end
	mov rdi, rax 
	call ft_strcpy
	ret
end:
	ret


