;******************
; Programme vide
;******************

pile    segment stack     ; Segment de pile
pile    ends

donnees segment public

donnees ends

code    segment public    ; Segment de code
assume  cs:code,ds:donnees,es:code,ss:pile

myprog:
  ; Initialisation de DS avec l'adresse du segment de données
  mov AX, donnees
  mov DS, AX

  mov AH, 0h ; 0h = set video mode
  mov AL, 13h ; 320x240
  int 10h ; Passage au mode graphique

  mov AH, 0Ch ; 0Ch = set pixel
  mov AL, 0  ; Couleur (nombre entre 0 et 255)
  mov CX, 10  ; 10 = x
  mov DX, 30  ; 30 = y

boucle:
  int 10h ; 
  cmp AL, 255 ; Si AL = 255
  je wait
  inc AL
  inc CX
  inc DX  ; Pour faire descendre sur y
  jmp boucle

wait:
  mov AH, 07h ; 07h = attente d'un appui sur une touche
  int 21h ; appel DOS

fin:
    mov AH,4Ch  ; 4Ch = fonction exit DOS
    mov AL,00h  ; code de sortie 0 (OK)
    int 21h
  
code    ends               ; Fin du segment de code
end myprog                 ; Fin du programme

