default rel



section .text
global ft_read
extern ft_strlen, __errno_location

ft_read:
	xor rax, rax
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
	mov [rax], ecx; move specific value to location pointed by rax
	jmp fail_end 

fail_end:
	mov rax, 0xFFFFFFFFFFFFFFFF
	ret

; syscalls in 64 bit x86
; rax 0 -> read
; rdi -> file descriptor
; rsi -> buffer address
; rdx -> count bytes to read
; syscall