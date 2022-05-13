.MODEL TINY

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CODES, DS:CODES
    ORG 100h; Формат .com

main:
    jmp init
    cur db 0
    speed db 01fh
    OLD_8H dd ?
    FLAG db 134

MY_NEW_8H proc
    pusha ; поместить в стек значения всех 16-битных регистров общего назначения
    pushf ; поместить в стек значение регистра FLAGS
    push ES
    push DS

    mov AH, 02h ; читать время из "постоянных" 
    int 1ah ; ввод-вывод для времени

    cmp DH, cur ; чтение секунд
    mov cur, DH
    je end_loop

    mov AL, 0F3h ; установка автоповтора
    out 60h, AL
    mov AL, speed ; характеристика автоповтора период - 2.0
    out 60h, AL

    dec speed; уменьшаем период повтора
    test speed, 01fh; логическое И
    jz reset
    jmp end_loop

    reset:
        mov speed, 01fh

    end_loop:
        pop DS
        pop ES
        popf
        popa
        jmp CS:OLD_8H
MY_NEW_8H endp

init:
    mov AX, 3508h ; получение адреса обработчика
    int 21h

    cmp ES:FLAG, 134
    je uninstall

    mov word ptr OLD_8H, BX ; сохранение указателей на программу обработки
    mov word ptr OLD_8H + 2, ES

    mov AX, 2509h ; подмена

    mov DX, offset MY_NEW_8H ; установка нового обработчика
    int 21h

    mov DX, offset INSTALL_MSG ; вывод сообщения
    mov AH, 9
    int 21h

    mov DX, offset init
    int 27h; завершение с сохранением памяти

uninstall:
    push ES ; сохранение в стеке содержимого ES
    push DS ; /-/ DS

    mov AL, 0F3h ; установка автоповтора
    out 60h, AL
    mov AL, 0 ; характеристика автоповтора период - 30.0
    out 60h, AL

    mov DX, word ptr ES:OLD_8H ; возврат старого обраточика
    mov DS, word ptr ES:OLD_8H + 2
    mov AX, 2509h
    int 21h

    pop DS ; вывод из стека
    pop ES

    mov AH, 49h; освобождаем память
    int 21h

    mov DX, offset UNINSTALL_MSG ; вывод сообщения
    mov AH, 9h
    int 21h

    mov AX, 4C00h ; конец программы
    int 21h

    INSTALL_MSG DB 'Install custom breaking$'
    UNINSTALL_MSG DB 'Uninstall custom breaking$'

CODES ENDS
END main




