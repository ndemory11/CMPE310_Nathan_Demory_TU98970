	section .data
	mode_read   db "r", 0 ; File mode for reading
	fmt_input   db "%d", 0 ; Format for fscanf
	fmt_output  db "Sum = %d", 10, 0 ; Format for printf
	err_msg     db "Error opening file", 10, 0

	section .bss
	array       resd 1000 ; Space for 1000 integers
	num_values  resd 1	; Number of values in the file
	sum         resd 1	; Sum result
	file_ptr    resd 1	; File pointer storage

	section .text
	extern printf, fopen, fscanf, fclose
	global main

main:
	push ebp
	mov ebp, esp

	;;  Get filename from command line 
	mov eax, [ebp + 12]	
	mov eax, [eax + 4]	 

	;;  Open file
	push mode_read
	push eax		; Filename from command line
	call fopen
	add esp, 8

	test eax, eax	; Check if file opened successfully
	jz error_exit
	mov [file_ptr], eax	; Store file pointer

	;;  Read number of values
	push num_values
	push fmt_input
	push eax		
	call fscanf
	add esp, 12

	;;  Read integers into array
	mov ecx, [num_values] ; Number of integers to read
	mov edi, array    
	mov ebx, [file_ptr]	

read_loop:
	push ecx		; Save counter
	push edi	
	push fmt_input11
	push ebx
	call fscanf
	add esp, 12
	pop ecx		

	cmp eax, 1		
	jne close_file	

	add edi, 4	
	dec ecx		; Decrease counter
	jnz read_loop	

	;;  Calculate sum
	xor eax, eax	; Clear sum
	mov ecx, [num_values] 
	mov esi, array   

sum_loop:
	add eax, [esi]	; Add  number to sum
	add esi, 4	; Move to next number
	loop sum_loop

	mov [sum], eax	;  final sum

	;;  Print 
	push eax
	push fmt_output
	call printf
	add esp, 8

close_file:
	;;  Close the file
	push dword [file_ptr]
	call fclose
	add esp, 4

	;;  Exit with success
	mov eax, 0
	mov esp, ebp
	pop ebp
	ret

error_exit:
	;;  Print error message
	push err_msg
	call printf
	add esp, 4

	;;  Exit with error
	mov eax, 1
	mov esp, ebp
	pop ebp
	    ret
