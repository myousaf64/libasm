SRC =  ft_read.s ft_strcmp.s ft_strcpy.s ft_strdup.s ft_strlen.s ft_write.s 

BONUS =  ft_list_push_front.s ft_list_remove_if.s ft_list_size.s ft_list_sort.s ft_atoi_base.s

OBJ = $(SRC:.s=.o)
BONUS_OBJ = $(BONUS:.s=.o)

ASM = nasm
ASMFLAGS = -f elf64

NAME = libasm.a

CC = gcc
TESTER_FILES = tester/*.c
EXEC = a.out

PHONY = all
all: $(NAME)

PHONY += bonus
bonus: $(NAME)

%.o: %.s
	$(ASM) $(ASMFLAGS) $< -o $@

$(NAME): $(OBJ)
	ar rcs $(NAME) $(OBJ)

bonus: $(BONUS_OBJ) $(OBJ)
	ar rcs $(NAME) $(BONUS_OBJ) $(OBJ)

# run: bonus $(NAME) $(TESTER_FILES)
# 	$(CC) $(TESTER_FILES) $(NAME) -o $(EXEC)

PHONY += clean
clean:
	rm -f $(OBJ) $(BONUS_OBJ)

PHONY += fclean
fclean: clean
	rm -f $(NAME) $(EXEC) $(NAME) 

PHONY += re
re: fclean all

.PHONY: $(PHONY)
