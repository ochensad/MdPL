EXTRN NUM : word
EXTERN OUT_BIN_STRING : word
PUBLIC bin_signed

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG

bin_signed proc near
    mov AX, SEG NUM
    mov DS, AX

    mov AX, offset OUT_BIN_STRING
    mov DX, AX
    mov AH, 9
    int 21h

    mov AH, 2
    xor DL, DL

    mov BX, NUM
    ; add BX, 8000h
    ; cmp BX, 8000h
    rol bx, 1
        jc print_sign
    jnc begin

    print_sign:
        mov DL, '-'
        int 21h
        jmp begin
    
    to_neg:
        neg BX
        jmp print_begin

    begin:
        mov BX, NUM

        cmp DL, '-'
            je to_neg
        print_begin:
            mov CX, 16
    
    print_bits:
        shl BX, 1
        jc print_one

        mov DL, '0'
        jmp print_bite


        print_one:
            mov DL, '1'
            jmp print_bite
        
        print_bite:
            int 21h
            loop print_bits
    
    mov DL, 10
    int 21h
    mov DL, 13
    int 21h

    ret
bin_signed endp

CSEG ENDS
END
