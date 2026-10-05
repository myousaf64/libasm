section .text
global ft_strcmp

ft_strcmp:
	xor rax, rax
	xor rcx, rcx 

char_checker_loop:
	movzx eax, BYTE [rdi + rcx]
	movzx edx, BYTE [rsi + rcx]
	sub eax, edx
	jne end
	test edx, edx
	je end
	inc rcx
	jmp char_checker_loop

end:
	ret


