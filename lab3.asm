;******************
; Programme vide
;******************

pile    segment stack     ; Segment de pile
pile    ends

data segment public
letter1 DB 0
letter2 DB 0
data ends

code    segment public  ; Segment de code
assume  cs:code,ds:data,es:code,ss:pile

myprog:
  mov AX, data ; AX = segment de donnees
  mov DS, AX ; DS = segment de donnees

  call getchar
  call putchar

getchar:
  mov AH, 07h
  int 21h
  mov letter1, AL
  int 21h
  mov letter2, AL

putchar:
  mov AH, 02h
  mov DL, letter1
  int 21h

  mov AH, 02h
  mov DL, letter2
  int 21h

  
code    ends  ; Fin du segment de code
end myprog  ; Fin du programme

