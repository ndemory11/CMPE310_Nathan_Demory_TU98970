section .bss
    str1 resb 256  ; Buffer for first string
    str2 resb 256  ; Buffer for second string
    result resb 1  ; Store Hamming distance
    length resb 1  ; Store actual length of input

section .data
    newline db 10         ; Newline character
    msg db 'Hamming Distance: ', 0
    output db '0', 10, 0  ; Buffer to store output (with newline)
    prompt1 db 'Enter first string: ', 0
    prompt2 db 'Enter second string: ', 0

section .text
    global _start

_start:
    ; Prompt and read first string
    mov eax, 1             ; syscall: sys_write
    mov edi, 1             ; file descriptor: stdout
    mov rsi, prompt1       ; message to print
    mov edx, 19            ; message length
    syscall

    mov eax, 0             ; syscall: sys_read
    mov edi, 0             ; file descriptor: stdin
    mov rsi, str1          ; buffer to store input
    mov edx, 255           ; max length
    syscall
    dec eax                ; Adjust for newline character
    mov [length], al       ; Store the actual length

    ; Prompt and read second string
    mov eax, 1             ; syscall: sys_write
    mov edi, 1             ; file descriptor: stdout
    mov rsi, prompt2       ; message to print
    mov edx, 20            ; message length
    syscall

    mov eax, 0             ; syscall: sys_read
    mov edi, 0             ; file descriptor: stdin
    mov rsi, str2          ; buffer to store input
    mov edx, 255           ; max length
    syscall
   

    xor ecx, ecx      ; Counter for loop
    xor eax, eax      ; Store Hamming distance
    movzx ebx, byte [length]

compute_hamming:
    cmp ecx, ebx           ; Check if we reached input length
    jge convert_to_ascii   ; Exit loop if done
    
    mov al, [str1 + ecx]   ; Load character from str1
    mov dl, [str2 + ecx]   ; Load character from str2
    
    xor al, dl             ; XOR both characters
    popcnt edx, eax        ; Count the number of 1 bits in result
    add byte [result], dl  ; Accumulate in result
    
    inc ecx                ; Move to next character
    jmp compute_hamming    ; Loop

convert_to_ascii:
    mov al, [result]       ; Load result
    add al, '0'            ; Convert to ASCII
    mov [output], al       ; Store in output buffer

print_message:
    mov eax, 1             ; syscall: sys_write
    mov edi, 1             ; file descriptor: stdout
    mov rsi, msg           ; message to print
    mov edx, 18            ; message length
    syscall

print_result:
    mov eax, 1             ; syscall: sys_write
    mov edi, 1             ; file descriptor: stdout
    mov rsi, output        ; output buffer
    mov edx, 2             ; output length (digit + newline)
    syscall

exit:
    mov eax, 60  ; syscall: exit
    xor edi, edi ; status: 0
    syscall
