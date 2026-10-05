NAME = libasm.a

ASM = nasm
ASMFLAGS = -f elf64
CC = gcc

SRC =  ft_read.s ft_strcmp.s ft_strcpy.s ft_strdup.s ft_strlen.s ft_write.s 

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

TEST ?=
LLVM_MCA ?= $(firstword $(foreach t,llvm-mca llvm-mca-22 llvm-mca-21,$(shell command -v $(t) 2>/dev/null)))

PHONY += lint
lint:
	@command -v $(ASM) >/dev/null || { echo "install: sudo apt install nasm"; exit 1; }
	@for f in $(SRC); do \
		$(ASM) -f elf64 -w+all -Werror $$f -o /dev/null || exit 1; \
	done
	@echo "lint: ok"

PHONY += fmt
fmt:
	@if command -v nasmfmt >/dev/null; then nasmfmt $(SRC); \
	else echo "fmt: nasmfmt not found, skipped. install: go install github.com/yamnikov-oleg/nasmfmt@latest"; fi

PHONY += analyze
analyze:
	@[ -n "$(LLVM_MCA)" ] || { echo "install: sudo apt install llvm"; exit 1; }
	@command -v objdump >/dev/null || { echo "install: sudo apt install binutils"; exit 1; }
	@tmp=$$(mktemp); for f in $(SRC); do \
		echo "== $$f =="; \
		$(ASM) -f elf64 $$f -o $$tmp || { rm -f $$tmp; exit 1; }; \
		objdump -d --no-show-raw-insn $$tmp | sed -n 's/^ *[0-9a-f]*:\t//p' \
			| sed -E 's/ *<.*>//; s/^(j[a-z]+|call) +([0-9a-f]+)$$/\1 0x\2/' \
			| $(LLVM_MCA) -mcpu=native || { rm -f $$tmp; exit 1; }; \
	done; rm -f $$tmp

PHONY += memcheck
memcheck:
	@command -v valgrind >/dev/null || { echo "install: sudo apt install valgrind"; exit 1; }
	@[ -n "$(TEST)" ] || { echo "usage: make memcheck TEST=./prog"; exit 1; }
	valgrind --leak-check=full ./$(TEST)

PHONY += debug
debug:
	@command -v gdb >/dev/null || { echo "install: sudo apt install gdb"; exit 1; }
	@[ -n "$(TEST)" ] || { echo "usage: make debug TEST=./prog"; exit 1; }
	$(MAKE) re ASMFLAGS="$(ASMFLAGS) -g -F dwarf"
	gdb ./$(TEST)

.PHONY: $(PHONY)
