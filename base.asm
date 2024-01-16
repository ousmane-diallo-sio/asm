;******************
; Programme vide
;******************

pile    segment stack     ; Segment de pile
pile    ends

donnees segment public    ; Segment de donnees
donnees ends

code    segment public    ; Segment de code
assume  cs:code,ds:donnees,es:code,ss:pile

myprog:			; debut de la zone instructions

; --- WRITE YOUR CODE HERE ------
				
fin:
    mov AH,4Ch  ; 4Ch = fonction exit DOS
    mov AL,00h  ; code de sortie 0 (OK)
    int 21h

code    ends               ; Fin du segment de code
end myprog                 ; Fin du programme

