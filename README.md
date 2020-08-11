# stkmachine.asm 

Basic arithmetic and logical operations with stacks in x86 assembly

Stacks are cool

| Command 	| Return value 	| Return Type 	|
|---------	|--------------	|-------------	|
| Add        	|         x+y     	|     Integer        	|
| Sub     	| x-y             	| Integer            	|
| Neg        	|      -y        	|       Integer      	|
| eq        	|      x==y        	|       Boolean      	|
| gt        	|      x > y       	|       Boolean      	|
| lt        	|      y < x        	|       Boolean      	|
| and        	|      x and y        	|       Boolean      	|
| or        	|      x or y        	|       Boolean      	|
| not        	|      not y        	|       Boolean      	|


---

Any arithmetic or logical operation can be expressed and evaluated by applying some sequence 
of the above operations on a stack

---

### How to run 🏃 ?

Just `make`
or maybe you have a lot of time
```
nasm -f elf64 stk.asm # assemble the program
ld -s -o stk stk.o # link the object file nasm produced into an executable file
./stk # stk is an executable file
```

### Addition

`./stk "+" a` b

No more fingers for addition !! 

### Subtraction

`./stk "-" a` b

Subtraction 


### Negative

`./stk "n"` a 

-a but in a non-human format

### Equality

`./stk "=" a` b

if a = b print 1 else 0
Everything is equal in the eyes of assembler


### Greater-than

`./stk ">"` a b

if a > b print 1 else print 0


### Lesser-than

`./stk "<" a` b

if a < b print 1 else print 0


### Bitwise AND

`./stk "&" a` b

AND operation

### Bitwise OR

`./stk "|" a` b

OR operation


### Bitwise NOT

`./stk "~" a` 

NOT operation


### Tests

Bash tests written with bats

https://github.com/bats-core/bats-core

`make test`

### Why ?

Even old New York was once New Amsterdam

Why they changed it I can't say

People just liked it better that way


Code that helped: https://github.com/flouthoc/calc.asm