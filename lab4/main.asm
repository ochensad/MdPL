STSG SEGMENT PARA STACK 'STACK'
	db 100 dup (0)
STSG ENDS

DSG SEGMENT PARA public 'DATA'
	STRING db 10 dup (' ')
	db '$'
DSG ENDS

CSG SEGMENT PARA public 'CODE'
	assume CS:CSG, DS:DSG
main:
	mov ax, DSG
	mov ds, ax
	mov ah, 0Ah
	mov dx, offset STRING
	int 21h
	mov Ah, 02h
    mov dl, 10
    int 21h

    mov AL, [STRING[1 + 2]]

    sub AL, '0'
    mov BL, Al
    add Al, '0'

    mov AL, STRING[3 + 2]

    sub AL, '0'
    add BL, Al

    mov AL, BL
    add Al, '0'

    mov dl, al
    mov Ah, 02h
    int 21h
    mov AH, 4Ch
    int 21h

CSG ENDS
END main