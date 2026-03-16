includelib	../import32.lib
    extrn	ExitProcess: near
    extrn	GetStdHandle: near
    extrn	WriteConsoleA: near
    extrn	ReadConsoleA: near
    extrn	_wsprintfA: near

ReadConsole equ ReadConsoleA
WriteConsole equ WriteConsoleA
wsprintf equ _wsprintfA
STD_INPUT_HANDLE equ -10
STD_OUTPUT_HANDLE equ -11

.386
.model flat, stdcall

.data
s2 db 48 dup(0)
; s2 db "101010", 0, 0
s6 db 13 dup(' '), 0
    db 2 dup(?) ; padding
n dd 0
p dd ?
len dd ?

tmp dd ?
inputHandle dd ?
outputHandle dd ?
message1 db 'Enter a binary number: ', 0
message2 db 'Number in a base 6: ', 0

.code
_start:
    call GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax
    
    call GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax

    call WriteConsole, outputHandle, offset message1, 23, offset tmp, 0
    call ReadConsole, inputHandle, offset s2, 33, offset tmp, 0

    mov ecx, -1
    mov edi, offset s2
    mov esi, edi
    mov al, 0Dh ; al = '\r'
    repne scasb

    dec edi
    mov len, edi    ; len = &(конец строки)
    sub edi, esi
    dec edi
    mov ecx, edi    ; ecx = длина строки - 1

    mov ebx, 1
    shl ebx, cl     ; ebx = P
    mov edi, offset s2     ; edi = &S2
first_loop:
    xor eax, eax    ; eax = 0
    mov al, [edi]   ; al - код символа
    sub al, '0'     ; eax = цифра 2-ной СС
    mul ebx         ; eax *= ebx
    add n, eax      ; n += eax

    inc edi         ; i++
    shr ebx, 1      ; p //= 2
    cmp edi, len    ; i < |s2|
    jb first_loop   ; если да, то продолжить

    mov eax, n      ; eax = n
    mov ecx, 6      ; ecx = 6 (основание)
    mov edi, offset s6 + 12 ; edi = &(конец s6)
second_loop:
    xor edx, edx    ; обнулить edx перед делением edx:eax
    div ecx         ; eax - частное, edx - остаток
    add dl, '0'     ; dl = цифра 6-ной СС
    mov [edi], dl   ; записали цифру
    dec edi         ; сместить указатель для след. записи
    cmp eax, 0      ; eax > 0
    ja second_loop  ; если да, то продолжить

    call WriteConsole, outputHandle, offset message2, 23, offset tmp, 0

    mov ecx, 13
    mov edi, offset s6
    mov esi, edi
    mov al, ' '
    repe scasb
    dec edi
    inc ecx

    call WriteConsole, outputHandle, edi, ecx, offset tmp, 0
    call ReadConsole, inputHandle, offset s2, 2, offset tmp, 0

    call ExitProcess, 0
    ends
    end _start