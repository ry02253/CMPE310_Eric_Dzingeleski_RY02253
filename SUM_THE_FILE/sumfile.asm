section .data
	pathname DD "/afs/umbc.edu/users/r/y/ry02253/home/cmpe310/Assignment2/randomInt100.txt"

section .bss
buffer:	   resb 1024
char:	   resb 1
sum:	resb 2
array:	resb 2000
num_ints:	resb 4
file_over resb 1

section .text
	global _start
_start:
	xor esp, esp
	xor ecx, ecx
	mov eax, 5
	mov ebx, pathname
	mov ecx, 0
	int 0x80
	jmp read
read:
	mov ebx, eax
	mov eax, 3
	mov ecx, buffer
	mov edx, 1024
	int 0x80
	jmp loop_start

	
loop_start:
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	xor esp, esp
	xor ebp, ebp
	jmp load

load:
	mov byte dl, [buffer + esp]
	inc esp
	mov byte cl, [buffer + esp]
	inc esp
	cmp cl, 10
	je add_single
	mov byte bl, [buffer + esp]
	inc esp
	cmp bl, 10
	je add_double
	mov byte ah, [buffer + esp]
	inc esp
	cmp ah, 10
	je add_triple
	mov byte al, [buffer + esp]
	inc esp
	cmp al, 10
	je add_quadruple
	mov dh, 1
	mov [file_over], dh
	xor dh, dh
	jmp end_of_file


add_single:
	sub dl, 48
	add [sum], edx
	cmp ebp, 0
	je initialize
	jmp array_insert

add_double:
	sub cl, 48
	add [sum], ecx
	mov ecx, edx
	sub ecx, 48
	mov eax, 10
	mul ecx
	add [sum], eax
	cmp ebp, 0
	je initialize
	jmp array_insert

add_triple:
	sub ebx, 48
	add [sum], ebx
	mov ebx, edx
	mov eax, 10
	sub ecx, 48
	sub ebx, 48
	mul ecx
	add [sum], eax
	mov eax, 100
	mul ebx
	add [sum], eax
	cmp ebp, 0
	je initialize
	jmp array_insert

add_quadruple:
	shr eax, 8
	sub eax, 48
	sub ebx, 48
	sub ecx, 48
	sub edx, 48
	add [sum], eax
	mov eax, 10
	mov ch, dl
	mul ebx
	add [sum], eax
	mov bl,ch
	mov eax, 100
	mul ecx
	add [sum], eax
	mov eax, 1000
	mul ebx
	add [sum], eax
	cmp ebp, 0
	je initialize
	jmp array_insert

end_of_file:
	mov esi, [num_ints]
	cmp cl, 0
	je add_single
	cmp bl, 0
	je add_double
	cmp ah, 0
	je add_triple
	cmp al, 0
	je add_quadruple
	jmp sum_initialize

initialize:
	mov ax, [sum]
	mov [num_ints], ax
	mov edx, [num_ints]
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	mov [sum], eax
	inc ebp
	jmp load

array_insert:
	mov eax, [sum]
	mov [array + 2*ebp], eax
	inc ebp
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	mov [sum], eax
	cmp ebp, [num_ints]
	jg sum_initialize
	mov eax, [file_over]
	cmp eax, 0
	jne sum_initialize
	jmp load
	
sum_initialize:
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	mov edx, [num_ints]
	jmp sum_array


sum_array:
	xor ebx, ebx
	mov byte bh, [array + (2*ecx) + 1]
	mov byte bl, [array + (2*ecx)]
	add eax, ebx
	inc ecx
	cmp ecx, edx
	jg write
	jmp sum_array

write:
	mov [sum], eax
	mov ebx, [sum]
	xor ecx, ecx
	jmp thousands

thousands:
	cmp ebx, 1000
	jle printchar
	sub ebx, 1000
	inc ecx

hundreds:
	cmp ebx, 100
	jle printchar
	sub ebx, 100
	inc ecx
	
tens:
	cmp ebx, 10
	jle printchar
	sub ebx, 10
	inc ecx

ones:
	cmp ebx, 0
	je printchar
	dec ebx
	inc ecx
	
printchar:
	mov ebp, ebx
	mov ebx, 1
	mov eax, 4
	add ecx, 48
	mov [char], ecx
	mov ecx, char
	mov edx, 1
	int 0x80
	mov ebx, ebp
	xor ecx, ecx
	cmp ebx, 0
	je end
	cmp ebx, 1000
	jl hundreds
	cmp ebx, 100
	jl tens
	cmp ebx, 10
	jl ones
	jmp end

end:
	mov eax, 6
	int 0x80
	mov eax, 1
	int 0x80
