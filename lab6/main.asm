EXTERN input_oct_number : proc
EXTERN hex_unsigned : proc
EXTERN bin_signed : proc

SSEG SEGMENT PARA STACK 'STACK'
    db 100 dup (0)
SSEG ENDS

MENUSEG SEGMENT PARA PUBLIC 'DATA'
    ENTRY db "This program get unsigned oct number and can translate to hex and binary system", 10, 13, '$'
    MENU_MES db "Menu:", 10, 13, "1 - Enter unsigned oct number", 10, 13, "2 - Output unsigned hex number", 10, 13, "3 - output signed binary number", 10, 13, "0 - Exit", 10, 13, 10, 13, "Choice: ", '$'
    ERR db "Unknown program!", 10, 13, 10, 13, '$'
    PROCS dw input_oct_number, hex_unsigned, bin_signed
MENUSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG, DS:MENUSEG

err_print:
    mov AH, 9
    lea DX, ERR
    int 21h
    jmp menu

main:
    mov AX, MENUSEG
    mov DS, AX

    mov AH, 9
    lea DX, ENTRY
    int 21h

    menu:
        mov AX, MENUSEG
        mov DS, AX

        mov AH, 9
        lea DX, MENU_MES
        int 21h

        mov AH, 1
        int 21h

        mov DH, AL

        mov AH, 2
        mov DL, 10
        int 21h
        mov DL, 13
        int 21h

        mov AL, DH

        sub AL, '0'
        mov BL, AL
        xor BH, BH

        cmp BL, 0
            je exit
        cmp BL, 4
            jge err_print
        
        dec BX
        shl BX, 1
        call PROCS[BX]
        
        jmp menu
    exit:
        mov AH, 4Ch
        int 21h
CSEG ENDS
END main
