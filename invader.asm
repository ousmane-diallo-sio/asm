;****************************************
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
cr01 DB   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
cr11 DB   0, 0, 0, 7, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0
cr12 DB   0, 0, 0, 0, 7, 0, 0, 0, 7, 0, 0, 0, 0, 0
cr21 DB   0, 0, 0, 7, 7, 7, 7, 7, 7, 7, 0, 0, 0, 0
cr22 DB   0, 0, 7, 7, 4, 7, 7, 7, 0, 7, 7, 0, 0, 0
cr31 DB   0, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 0, 0
cr32 DB   0, 7, 0, 7, 7, 7, 7, 7, 7, 7, 0, 7, 0, 0
cr41 DB   0, 7, 0, 7, 0, 0, 0, 0, 0, 7, 0, 7, 0, 0
cr42 DB   0, 0, 0, 0, 7, 7, 0, 7, 7, 0, 0, 0, 0, 0
cr51 DB   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

barc DW   14,140
ba01 DB   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
ba11 DB   0, 0, 0, 7, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0
ba12 DB   0, 7, 0, 0, 7, 0, 0, 0, 7, 0, 0, 7, 0, 0
ba21 DB   0, 7, 0, 7, 7, 7, 7, 7, 7, 7, 0, 7, 0, 0
ba22 DB   0, 7, 7, 7, 0, 7, 7, 7, 4, 7, 7, 7, 0, 0
ba31 DB   0, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 0, 0
ba32 DB   0, 0, 7, 7, 7, 7, 7, 7, 7, 7, 7, 0, 0, 0
ba41 DB   0, 0, 0, 7, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0
ba42 DB   0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0
ba51 DB   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

; +++++++++++++++++++++++++++++++++++++++++++++
;               VARIABLES
; +++++++++++++++++++++++++++++++++++++++++++++
cycle DB  0
direction DB 0
posX  DW  5
posY  DW  5

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
    mov tempo, 20
    
    mov Rx, 100
    mov Ry, 20
    mov Rh, 50
    mov Rw, 10
    mov col, 7
    call Rectangle

; ========== GAME LOOP ===============
gameloop:  
    CALL dessine
    call docycle
    call sleep
    call interact
    call isdead
    jmp gameloop
; ====================================
   
; =============================
;      ROUTINES
; =============================
;--------- dessine ------------ 
; cycle <<  
dessine:
    mov AX, posX
    mov hX, AX
    mov AX, posY
	mov hY, AX
    cmp cycle, 0
    jne dess1            
	mov BX, offset crab  ; cycle = 0
	CALL drawIcon
    RET
dess1: 
	mov BX, offset barc  ; cycle = 1
	CALL drawIcon
    RET

;------- docycle ---------------
; >> posX, cycle
docycle:
    cmp direction, 0   ; move right
    jne moveL
    inc posX
    jmp cycle1
moveL:                 ; move left
    cmp direction, 1
    jne moveU
    dec posX
    jmp cycle1
moveU:
    cmp direction, 2
    jne moveD
    dec posY
    jmp cycle1
moveD:
    inc posY
    
cycle1:          ; change cycle 0-1
    cmp cycle, 0
    jne cycle0
    mov cycle, 1
    RET
cycle0:
    mov cycle, 0
    RET
     
;------- interact ---------------
; >> direction
interact:
	call PeekKey
    cmp userinput, '*'
    jne  testR
    call VideoCMD
	mov AH,4Ch      ; 4Ch = fonction de fin de prog DOS
	mov AL,00h      ; code de sortie 0 (tout s'est bien passe)
	int 21h		  
testR:
    CMP userinput,'M'	; M for right			; case M
    JNE testL
    MOV direction, 0
    RET
testL:
    CMP userinput,'K'	; K for left			; case K
    JNE testU
    MOV direction, 1
	RET
testU:
    CMP userinput,'H'	; H for up				; case H
    JNE testD 
    MOV direction, 2
	RET
testD:
    CMP userinput,'P'	; P for down			; case P
	JNE noHit
    MOV direction, 3
    RET
noHit:
    RET
     
;------- isdead ---------------
; posX, posX >>
isdead:
    mov AX, posX
    add AX, 13
    mov cCX, AX
    mov AX, posY
    add AX, 8
    mov cDX, AX
    call ReadPxl
    cmp rdcol, 0
    je  notdead
    call VideoCMD
	mov AH,4Ch      ; 4Ch = fonction de fin de prog DOS
	mov AL,00h      ; code de sortie 0 (tout s'est bien passe)
	int 21h		
notDead:
    ret

; ================= FIN DU CODE ===============
        
code    ends                   ; Fin du segment de code
end prog                         ; Fin du programme
