;******************
; Programme vide
;******************

pile    segment stack     ; Segment de pile
pile    ends

donnees segment public    ; Segment de donnees
; vos variables

donnees ends

code    segment public    ; Segment de code
assume  cs:code,ds:donnees,es:code,ss:pile

myprog:			; debut de la zone instructions

; --- WRITE YOUR CODE HERE ------
labelBoucle:
    mov AH,07h  ; 07h = fonction getchar DOS
    int 21h
    mov AH,02h  ; 02h = fonction putchar DOS
    mov DL,AL
    int 21h
    cmp AL, '*'
    jne labelBoucle

fin:
    mov AH,4Ch  ; 4Ch = fonction exit DOS
    mov AL,00h  ; code de sortie 0 (OK)
    int 21h

code    ends               ; Fin du segment de code
end myprog                 ; Fin du programme

