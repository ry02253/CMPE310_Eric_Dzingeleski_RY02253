section .data
	foo db 'this is a test', 0x0d
	bar db 'of the emergency broadcast', 0x1a
	len db 112
section .bss
sum:resb 4
section .text
global _start
_start:	

jmp initialize
	
initialize:
	xor eax, eax
	xor ecx, ecx
	xor edx, edx
	xor esi, esi
	jmp changechars
changechars:
	xor ch, ch
	mov byte al, [foo + esi]
	mov byte ah, [bar + esi]
	xor al, ah
	inc esi
	jmp loop	 
loop:
	shr al, 1
	jc add
	jmp endloop
add:
	inc edx
	jmp endloop
endloop:
	inc cl
	inc ch
	cmp cl, [len]
	jz finish
	cmp ch, 8
	jz changechars
	jmp loop
finish:
	
	add edx, '0'		;adds 48, so 8 shows '8', but 38 shows 'V'
	mov [sum], edx
	mov ecx, sum

	mov eax, 4
	mov ebx, 1
	mov edx, 1

	int 0x80
	mov eax, 1
	int 0x80
