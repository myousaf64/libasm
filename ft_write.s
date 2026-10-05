default rel

section .text
global ft_write
extern __errno_location

ft_write:
	mov rax, 0x01
	syscall
	cmp rax, 0
	jl check_error
	ret

check_error:
	neg rax
	push rax ; save errno, align stack to 16 for the call
	jmp call_errno


call_errno:
	call __errno_location wrt ..plt
	pop rcx
	mov [rax], ecx
	jmp fail_end 

fail_end:
	mov rax, 0xFFFFFFFFFFFFFFFF
	ret

