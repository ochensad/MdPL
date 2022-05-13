.686
.MODEL FLAT, C
.STACK

.CODE

strncpyAsm proc dst:DWORD, src:DWORD, len:DWORD
    pushf
    mov ECX, len
    mov ESI, src
    mov EDI, dst

    cld ; сброс фрага DF, чтобы строки обрабатывались в сторону увеличения адрессов

    cmp ESI, EDI
    je exit ; если указатели равны

    cmp ESI, EDI
    jg copy ; если источник больше приемника

    mov EAX, ESI
    sub EAX, EDI
    cmp EAX, len
    jge copy; если строки не накладываются друг на друга

    add EDI, len
    dec EDI
    add ESI, len
    dec ESI
    std ; возвращаем значение фрага DF

copy:
    rep movsb; буквально операция копирования строк

exit:
    popf
    ret
strncpyAsm endp
END