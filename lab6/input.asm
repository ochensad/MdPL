PUBLIC input_oct_number
PUBLIC NUM
PUBLIC OUT_HEX_STRING
PUBLIC OUT_BIN_STRING

OCT_SEG SEGMENT PARA PUBLIC 'DATA'
    INPUT_STRING db 10, 13, "Input num: ", '$'
    OUT_HEX_STRING db 10, 13, "Hex num: ", '$'
    OUT_BIN_STRING db 10, 13, "Bin num: ", '$'
    NUM dw 1 dup(0)
OCT_SEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG, DS:OCT_SEG

input_oct_number proc near
    mov AX, OCT_SEG
    mov DS, AX

    mov AX, offset INPUT_STRING
    mov DX, AX
    mov AH, 9
    int 21h

    mov AH, 1
    xor BX, BX
    mov CX, 6

    put_digit:
        mov AL, CL
        mov CL, 3
        shl BX, CL
        mov CL, AL

        int 21h
        sub AL, '0'
        or BL, AL
        loop put_digit
    
    mov NUM, BX

    mov AH, 2
    mov DL, 10
    int 21h
    mov DL, 13
    int 21h
    ret
input_oct_number endp
CSEG ENDS
END
