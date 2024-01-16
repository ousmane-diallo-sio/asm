```;****************************************

;   TJO Invaders  (c) 2020

;   ...inspired from TAITO Space Invaders

;   original author: Tomohiro Nishikado

; =======================================

;   touches de direction LEFT RIGHT ==> deplacement

;   *  ==> Exit

;   UP ==> Fire

;   -- CHEAT KEYS --

;   a  ==> accelere

;   d  ==> ralentit

;   r  ==> restore cibles

;

;  v 1.0  T. JOUBERT  25 may 2017

;  v 1.1  T. JOUBERT  26 may 2017

;  v 1.3  T. JOUBERT  03 jun 2017

;  v 1.4  T. JOUBERT  15 avr 2019

;  v 1.5  T. JOUBERT  20 Sep 2019

;  v 1.6  T. JOUBERT  10 Nov 2020

;  v 2.0  T. JOUBERT  11 Nov 2020

 

;****************************************

include LIBGFX.INC

 

pile    segment stack         ; Segment de pile

pile    ends

 

donnees segment public  ; ******* Segment de donnees **********

 

; +++++++++++++++++++++++++++++++++++++++++++++

;               CONSTANTES

; +++++++++++++++++++++++++++++++++++++++++++++

; ============- CRAB ICONS =====================

crab DW   14,140

cr01 DB   0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0

cr11 DB   0, 0, 0, 7, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0

cr12 DB   0, 0, 0, 0, 7, 0, 0, 0, 7, 0, 0, 0, 0, 0

cr21 DB   0, 0, 0, 7, 7, 7, 7, 7, 7, 7, 0, 0, 0, 0

cr22 DB   0, 0, 7, 7, 0, 7, 7, 7, 0, 7, 7, 0, 0, 0

cr31 DB   0, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 0, 0

cr32 DB   0, 7, 0, 7, 7, 7, 7, 7, 7, 7, 0, 7, 0, 0

cr41 DB   0, 7, 0, 7, 0, 0, 0, 0, 0, 7, 0, 7, 0, 0

cr42 DB   0, 0, 0, 0, 7, 7, 0, 7, 7, 0, 0, 0, 0, 0

cr51 DB   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

 

barc DW   14,140

ba01 DB   0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0

ba11 DB   0, 0, 0, 7, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0

ba12 DB   0, 7, 0, 0, 7, 0, 0, 0, 7, 0, 0, 7, 0, 0

ba21 DB   0, 7, 0, 7, 7, 7, 7, 7, 7, 7, 0, 7, 0, 0

ba22 DB   0, 7, 7, 7, 0, 7, 7, 7, 0, 7, 7, 7, 0, 0

ba31 DB   0, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 0, 0

ba32 DB   0, 0, 7, 7, 7, 7, 7, 7, 7, 7, 7, 0, 0, 0

ba41 DB   0, 0, 0, 7, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0

ba42 DB   0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0

ba51 DB   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

 

 

 

; +++++++++++++++++++++++++++++++++++++++++++++

;               VARIABLES

; +++++++++++++++++++++++++++++++++++++++++++++

donnees ends    ; ********** FIN Segment de donnees ************

 

; +++++++++++++++++++++++++++++++++++++++++++++

;               PROGRAMME

; +++++++++++++++++++++++++++++++++++++++++++++

code    segment public        ; Segment de code

assume  cs:code,ds:donnees,es:code,ss:pile

 

prog:

; ================== Gestion des registres =========

  mov AX, donnees
  mov DS, AX
  CALL Video13h
  mov tempo, 50


gameloop:  
  mov hX, 5
  mov hY, 5
  mov BX, offset crab
  CALL drawIcon
  CALL sleep
  mov hX, 5
  mov hY, 5
  mov BX, offset barc
  CALL drawIcon
  CALL sleep
  call PeekKey
  cmp userinput, '*'
  je  FIN
  jmp gameloop                       


fin:
  call VideoCMD
  mov AH,4Ch      ; 4Ch = fonction de fin de prog DOS
  mov AL,00h      ; code de sortie 0 (tout s'est bien passe)
  int 21h                


; ================= FIN DU CODE ===============


code    ends                   ; Fin du segment de code

end prog                         ; Fin du programme```