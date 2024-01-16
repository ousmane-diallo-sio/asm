;******************
; Programme vide
;******************

pile    segment stack     ; Segment de pile
pile    ends

donnees segment public
  letters DB 11 DUP(0)  ; Tableau de 11 octets initialisé à 0
donnees ends

code    segment public    ; Segment de code
assume  cs:code,ds:donnees,es:code,ss:pile

myprog:			; debut de la zone instructions

  mov AX, donnees ; AX pointe sur le segment de données
  mov DS, AX ; DS pointe sur le segment de données

  call getchar
  call putchar  

  print:
    mov BX, offset letters ; BX pointe sur le tableau letters
    mov AH, 02h ; putchar()

  getchar:
    mov AH, 07h ; getchar()
    int 21h
    mov byte ptr[BX], AL ; stocke le caractère lu dans le tableau
    inc BX ; décrémente BX
    cmp AL, '*' ; si le caractère est un astérisque
    je print ; on affiche le tableau
    jmp putchar ; sinon on continue la boucle
    ret

  putchar:
    mov AH, 02h ; putchar()
    mov DL, byte ptr[BX] ; DL contient le caractère pointé par BX
    inc BX ; incrémente BX
    cmp DL, '*' ; si le caractère est un astérisque
    je fin ; on sort de la boucle
    int 21h
    jmp getchar ; sinon on continue la boucle
    ret

  fin:
    mov AH,4Ch  ; 4Ch = fonction exit DOS
    mov AL,00h  ; code de sortie 0 (OK)
    int 21h

code    ends               ; Fin du segment de code
end myprog                 ; Fin du programme

