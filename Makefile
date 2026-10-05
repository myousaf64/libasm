NAME = libasm.a

ASM = nasm
ASMFLAGS = -f elf64

SRC =  ft_read.s ft_strcmp.s ft_strcpy.s ft_strdup.s ft_strlen.s ft_write.s ft_calloc.s

OBJ = $(SRC:.s=.o)

PHONY = all
all: $(NAME)

%.o: %.s
	$(ASM) $(ASMFLAGS) $< -o $@

$(NAME): $(OBJ)
	ar rcs $(NAME) $(OBJ)

PHONY += clean
clean:
	rm -f $(OBJ)

PHONY += fclean
fclean: clean
	rm -f $(NAME)

PHONY += re
re: fclean all

.PHONY: $(PHONY)
