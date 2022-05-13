STSG SEGMENT PARA STACK 'STACK'
	db 255 dup (0)
STSG ENDS

DSG SEGMENT PARA public 'DATA'
INPUT_ROW_SIZE_STRING db 13
    db 'Input rows of matrix '
    db '$'
    db 10
INPUT_COLUMN_SIZE_STRING db 10
    db "Input columns of matix "
    db '$'
    db 10
INPUT_MATRIX db 10
    db "Input matrix"
    db 10
    db '$'
OUTPUT_MATRIX_STRING db 10
    db "Output matrix"
    db 10
    db '$'
ROWS db 9
COLUMNS db 9
MATRIX db 81 dup(0)
F_ROW db 0

DSG ENDS

CSG SEGMENT PARA public 'CODE'
	assume CS:CSG, DS:DSG

read_size proc near
    mov AX, offset INPUT_ROW_SIZE_STRING
    mov DX, AX
    mov AH, 9
    int 21h

    mov AH, 01h
    int 21h
    sub AL, '0'
    mov [ROWS], AL

    mov AX, offset INPUT_COLUMN_SIZE_STRING
    mov DX, AX
    mov AH, 9
    int 21h

    xor AL, AL
    mov AH, 01h
    int 21h
    sub AL, '0'
    mov [COLUMNS], AL

    mov AH, 2
    mov DL, 10
    int 21h
    mov DL, 13
    int 21h
    
    ret
read_size endp

read_matrix proc near
    mov AX, offset INPUT_MATRIX
    mov DX, AX
    mov AH, 9
    int 21h

    lea SI, MATRIX
    xor CX, CX
    mov CL, [ROWS]
    input_rows:
        mov BL, CL
        mov CL,[COLUMNS]

        input_row:
            mov AH, 1
            int 21h
            sub AL, '0'
            mov [SI], AL
            inc SI

            mov AH, 2
            mov DL, ' '
            int 21h

            loop input_row
        mov AH, 2
        mov DL, 10
        int 21h
        mov DL, 13
        int 21h

        mov CL, BL
        loop input_rows
    mov AH, 2
    mov DL, 10
    int 21h
    mov DL, 13
    int 21h

    ret
read_matrix endp

find_index proc near
    lea SI, MATRIX
    xor CX, CX
    mov CL, [ROWS]
    enter 4, 0
    label sum_of_row at bp-2
    label max_sum at bp-4
    mov [max_sum], 0
    read_rows:
        mov BL, CL
        mov CL, [COLUMNS]
        mov [sum_of_row], 0
        read_row:
            xor AL, AL
            mov AL, [SI]
            inc SI
            add sum_of_row, AL
            loop read_row
        xor AL, AL
        mov AL, [sum_of_row]
        cmp AL, [max_sum]
        ja greater
        continue:
        mov CL, BL
        loop read_rows
    leave
    ret
greater:
    mov AL, [sum_of_row]
    mov [max_sum], AL
    mov [F_ROW], BL
    jmp continue

find_index endp


delite_row proc near
    lea SI, MATRIX
    lea DI, MATRIX

    mov CL, [COLUMNS]
    increm_d:
        inc DI
        loop increm_d

    xor CX, CX
    mov CL, [ROWS]

    del_rows:
        mov BL, CL
        mov CL,[COLUMNS]
        xor AL, AL
        mov AL, [F_ROW]
        cmp AL, BL
        jge del

        inc_row:
            inc SI
            inc DI
            loop inc_row
        mov CL, BL
        loop del_rows
    back:
    ret
del:
    mov CL, BL
    del_rows_num:
        mov BL, CL
        mov CL, [COLUMNS]
        del_row:
            mov AL, [DI]
            mov [SI], AL
            inc SI
            inc DI
            loop del_row
        mov CL, BL
        loop del_rows_num
    dec ROWS
    jmp back
delite_row endp

output_matrix proc near
    mov AX, offset OUTPUT_MATRIX_STRING
    mov DX, AX
    mov AH, 9
    int 21h
    lea SI, MATRIX
    xor CX, CX
    mov CL, [ROWS]
    output_rows:
        mov BL, CL
        mov CL,[COLUMNS]

        output_row:
            xor AL, AL
            mov AL, [SI]
            add AL, '0'
            mov AH, 2
            mov DL, AL
            int 21h
            inc SI

            mov AH, 2
            mov DL, ' '
            int 21h

            loop output_row
        mov AH, 2
        mov DL, 10
        int 21h
        mov DL, 13
        int 21h

        mov CL, BL
        loop output_rows
    mov AH, 2
    mov DL, 10
    int 21h
    mov DL, 13
    int 21h

    ret
output_matrix endp

main:
    mov AX, DSG
    mov DS, AX

    call read_size
    call read_matrix
    call find_index
    call delite_row
    call output_matrix
    mov AH, 4Ch
    int 21h


CSG ENDS
END main
