; Basic Arithmetic/ logical operation with stacks in x86 Assembly
section .data
	FEW_ARGS: db "Too Few Arguments, follow ./stk <operator> <operand1> <operand2 (optional)>", 0xA
	LOTTA_ARGS: db "Too Many Arguments, follow ./stk <operator> <operand1> <operand2 (optional)>", 0xA
	BINARY_ONLY: db "Argument must be binary, can be either 0 or 1", 0xA
	INVALID_OPERATOR: db "Invalid Operator, available operators are: +, -, &, |, =, >, <, n, ~ ", 0xA
	INVALID_OPERAND: db "Invalid Operand, use a valid integer", 0XA
	BYTE_BUFFER: times 10 db 0

section .text

	global _start

_start:
	;Check args min:3 and max:4
	pop rdx 
	cmp rdx, 3
	jl few_args
	cmp rdx, 4
	jg lotta_args
	; skip over the name
	add rsp, 8
	; Pop out the Operator
	pop rsi 

	;if else in assembly (BRANCHING)
	cmp byte[rsi], 0x2B ;If operator is '+' then goto block addition
	je addition
	cmp byte[rsi], 0x2D ;If operator is '-' then goto block subtraction
	je subtraction
	cmp byte[rsi], 0x6E	;If operator is 'n' then goto block negative
	je negative
	cmp byte[rsi], 0x3D ;If operator is '=' then goto block equality
	je equality
	cmp byte[rsi], 0x3E	 ;If operator is '>' then goto block greaterthan
	je greaterthan
	cmp byte[rsi], 0x3C	 ;If operator is '<' then goto block lesserthan
	je lesserthan
	cmp byte[rsi], 0x26	 ;If operator is '&' then goto block bitwiseand
	je bitwiseand
	cmp byte[rsi], 0x7C	 ;If operator is '|' then goto block bitwiseor
	je bitwiseor
	cmp byte[rsi], 0x7E  ;If operator is '~' then goto block bitwisenot
	je bitwisenot

	;If <operator> does not match to any case then goto block invalid_operator
	jmp invalid_operator

; Function for Addition
addition:
	; pop operand1
	pop rsi
	; convert ascii to integer
	call ascii_to_int
	;Store the integer in r10
	mov r10, rax
	pop rsi
	call ascii_to_int
	; Addition
	add rax, r10
	jmp print_result ;Throw cursor at block print cursor, which will print the result

; Function for Subtraction
subtraction:
	pop rsi
	call ascii_to_int
	mov r10, rax
	pop rsi
	call ascii_to_int
	sub r10, rax
	mov rax, r10
	jmp print_result

; Function for negative
negative:
	pop rsi
	call ascii_to_int
	neg rax
	jmp print_result

; Function for equality
equality:
	pop rsi
	call ascii_to_int
	mov r10, rax
	pop rsi
	call ascii_to_int
	cmp r10, rax
	je print_one
	jne print_zero

; Function for greaterthan
greaterthan:
	pop rsi
	call ascii_to_int
	mov r10, rax
	pop rsi
	call ascii_to_int
	cmp r10, rax
	jg print_one
	jl print_zero

; Function for lesserthan
lesserthan:
	pop rsi
	call ascii_to_int
	mov r10, rax
	pop rsi
	call ascii_to_int
	cmp r10, rax
	jl print_one
	jg print_zero

; Function for bitwiseand
bitwiseand:
	pop rsi
	call ascii_to_int
	mov r10, rax
	pop rsi
	call ascii_to_int
	and r10, rax
	mov rax, r10
	jmp print_result

; Function for bitwiseor
bitwiseor:
	pop rsi
	call ascii_to_int
	mov r10, rax
	pop rsi
	call ascii_to_int
	or r10, rax
	mov rax, r10
	jmp print_result

; Function for bitwisenot
bitwisenot:
	pop rsi
	call ascii_to_int
	cmp rax, 0
	je print_one
	dec rax
	je print_zero
	jne binary_only
	jmp print_result

; Function to print 0
print_zero:
	xor rax, rax
	jmp print_result

; Function to print 1
print_one:
	xor rax, rax
	inc rax
	jmp print_result

; Function to print content on the screen
print_result:
	; Convert integer back to ASCII to print
	call int_to_ascii
	;Store syscall number , 1 is for sys_write
	mov rax, 1 
	;Descriptor where we want to write , 1 is for stdout
	mov rdi, 1
	;This is pointer to the ascii character which was returned by int_to_ascii
	mov rsi, r9 
	;r11 stores the number of chars in our string
	mov rdx, r11
	syscall
	jmp exit


;Error Functions to stderr
few_args:
	mov rdi, FEW_ARGS
	call print_error

lotta_args:
	mov rdi, LOTTA_ARGS
	call print_error

binary_only:
	mov rdi, BINARY_ONLY
	call print_error

invalid_operator:
	mov rdi, INVALID_OPERATOR
	call print_error

invalid_operand:
	mov rdi, INVALID_OPERAND
	call print_error

print_error:
	push rdi
	;calculate the length of rdi (error message)
	call strlen
	;write to stderr
	mov rdi, 2 
	pop rsi
	mov rdx, rax
	mov rax, 1
	syscall
	call error_exit
	ret

strlen:
	;initialize zero
	xor rax, rax 
.strlen_loop:
	;compare byte to a newline
	cmp BYTE [rdi + rax], 0xA
	;break if the current byte is a newline
	je .strlen_break 
	inc rax
	;repeat if the current byte isn't a newline
	jmp .strlen_loop
.strlen_break:
	;add one to strlen
	inc rax
	ret


; ascii to integer
ascii_to_int:
	xor ax, ax
	xor cx, cx
	; Since input ascii string is in base 10, each place value increases by a factor of 10
	mov bx, 10 

.loop_block:

	;REMEMBER rsi is base address to the string which we want to convert to integer equivalent

	mov cl, [rsi] ;Store value at address (rsi + 0) or (rsi + index) in cl, rsi is incremented below so dont worry about where is index.
	cmp cl, byte 0 ;If value at address (rsi + index ) is byte 0 (NULL) , means our string is terminated here
	je .return_block

	;Each digit must be between 0 (ASCII code 48) and 9 (ASCII code 57)
	cmp cl, 0x30 ;If value is lesser than 0 goto invalid operand
	jl invalid_operand
	cmp cl, 0x39 ;If value is greater than 9 goto invalid operand
	jg invalid_operand

	sub cl, 48 ;Convert ASCII to integer by subtracting 48 - '0' is ASCII code 48, so subtracting 48 gives us the integer value

	;Multiply the value in 'ax' (implied by 'mul') by bx (always 10). This can be thought of as shifting the current value
	;to the left by one place (e.g. '123' -> '1230'), which 'makes room' for the current digit to be added onto the end.
	;The result is stored in dx:ax.
	mul bx

	;Add the current digit, stored in cl, to the current intermediate number.
	;The resulting sum will be mulitiplied by 10 during the next iteration of the loop, with a new digit being added onto it
	add ax, cx

	inc rsi ;Increment the rsi's index i.e (rdi + index ) we are incrementing the index

	jmp .loop_block ;Keep looping until loop breaks on its own

.return_block:
	ret


;This is the function which will convert our integers back to ascii characters
int_to_ascii:
	mov rbx, 10
	;We have declared a memory which we will use as buffer to store our result
	mov r9, BYTE_BUFFER+10 ;We are are storing the number in backward order like LSB in 10 index and decrementing index as we move to MSB
	mov [r9], byte 0 ;Store NULL terminating byte in last slot
	dec r9 ;Decrement memory index
	mov [r9], byte 0XA ;Store break line
	dec r9 ;Decrement memory index
	mov r11, 2;r11 will store the size of our string stored in buffer we will use it while printing as argument to sys_write

.loop_block:
	mov rdx, 0
	div rbx    ;Get the LSB by dividing number by 10 , LSB will be remainder (stored in 'dl') like 23 divider 10 will give us 3 as remainder which is LSB here
	cmp rax, 0 ;If rax (quotient) becomes 0 our procedure reached to the MSB of the number we should leave now
	je .return_block
	add dl, 48 ;Convert each digit to its ASCII value
	mov [r9], dl ;Store the ASCII value in memory by using r9 as index
	dec r9 ;Dont forget to decrement r9 remember we are using memory backwards
	inc r11 ;Increment size as soon as you add a digit in memory
	jmp .loop_block ;Loop until it breaks on its own


.return_block:
	add dl, 48
	mov [r9], dl
	dec r9
	inc r11
	ret

;Normal return code 0 and for abnormal/ errors set it to 1
error_exit:
	;Syscall 60 is exit. 
	mov rax, 60
	mov rdi, 1
	syscall

exit:
	mov rax, 60
	mov rdi, 0
	syscall

; Code that helped: https://github.com/flouthoc/calc.asm
; Never doing this again :)
