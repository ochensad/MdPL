EXTRN NUM : word
EXTERN OUT_HEX_STRING: word
PUBLIC hex_unsigned

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG
hex_unsigned proc near
    mov AX, SEG NUM
    mov DS, AX

    mov AX, offset OUT_HEX_STRING
    mov DX, AX
    mov AH, 9
    int 21h

    mov AH, 2

    mov BX, NUM
    mov CX, 4

    begin:
        mov DL, BH
        and DL, 0F0h

        mov AL, CL
        mov CL, 4
        shr DL, CL
        mov CL, AL

        cmp DL, 9
            jg letter
        jmp digit

        letter:
            sub DL, 10
            add DL, 'A';
            jmp print

        digit:
            add DL, '0'
            jmp print

        print:
            int 21h

        mov AL, CL
        mov CL, 4
        shl BX, CL
        mov CL, AL
        loop begin

    mov AH, 2
    mov DL, 10
    int 21h
    mov DL, 13
    int 21h	

    ret
hex_unsigned endp
CSEG ENDS
END