NASM=nasm
CFLAGS=-f elf64
LINKER=ld
OBJ=stk.o

all: stk

%.o: %.asm
	$(NASM) $(CFLAGS) -o $@ $<

stk: $(OBJ)
	$(LINKER) -o stk $(OBJ)

test:
	bats stk.bats

.PHONY: clean
clean:
	rm *.o stk
