section .bss

num             : resw 1
noOfDigits      : resw 1
digit           : resb 1
i               : resw 1
factorial       : resw 1


section .data

prompt1 : db 0Ah, "Enter the number : "
len1    : equ $- prompt1
msg2    : db 0Ah, "Factorial of the number is : "
len2    : equ $- msg2
newl    : db 0Ah
space   : db ' '


section .text

global _start:
_start:

mov eax, 4
mov ebx, 1
mov ecx, prompt1
mov edx, len1
int 80h

call _readTheNumber
mov ax, word[num]
mov word[i], ax
mov word[factorial], 1

mov eax, 4
mov ebx, 1
mov ecx, msg2
mov edx, len2
int 80h

cmp word[num], 0
jne _finder

mov word[num], 1
call _printTheNumber
jmp _exit

_finder:

call _findFactorial

mov ax, word[factorial]
mov word[num], ax
call _printTheNumber

_exit:

call _newLinePrinter
call _newLinePrinter

mov eax, 1
mov ebx, 0
int 80h



_spacePrinter:
    pusha
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 80h
    popa
    ret

_newLinePrinter:
    pusha
    mov eax, 4
    mov ebx, 1
    mov ecx, newl
    mov edx, 1
    int 80h
    popa
    ret

_readTheNumber:
    pusha
    mov word[num], 0

    _reader:

        mov eax, 3
        mov ebx, 0
        mov ecx, digit
        mov edx, 1
        int 80h
        
        cmp byte[digit], 10
        je _endReading

        mov ax, word[num]
        mov bx, 10
        mul bx
        sub byte[digit], 30h
        movzx bx, byte[digit]
        add ax, bx
        mov word[num], ax
        jmp _reader
    
    _endReading:
    popa
    ret


_printTheNumber:
    pusha

    mov word[noOfDigits], 0

    cmp word[num], 0
    jne _breakingItDown

    add word[num], 30h
    mov eax, 4
    mov ebx, 1
    mov ecx, num
    mov edx, 1
    int 80h

    jmp _endPrinting

    _breakingItDown:
        cmp word[num], 0
        je _puttingItBack

        inc word[noOfDigits]
        mov dx, 0
        mov ax, word[num]
        mov bx, 10
        div bx
        push dx
        mov word[num], ax
        jmp _breakingItDown

    _puttingItBack:
        cmp word[noOfDigits], 0
        je _endPrinting

        dec word[noOfDigits]
        pop dx
        mov byte[digit], dl
        add byte[digit], 30h
        mov eax, 4
        mov ebx, 1
        mov ecx, digit
        mov edx, 1
        int 80h

        jmp _puttingItBack
    
    _endPrinting:
    popa
    ret


_findFactorial:

    mov ax, word[i]
    cmp ax, 0
    je _endFindFactorial

    mov ax, word[i]
    mov bx, word[factorial]
    mul bx
    mov word[factorial], ax
    dec word[i]
    call _findFactorial

    _endFindFactorial:
    ret