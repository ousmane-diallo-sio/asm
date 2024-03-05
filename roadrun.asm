;****************************************
;   UP ==> Se deplace vers le haut
;   DOWN ==> Se deplace vers le bas
;   LEFT ==> Se deplace vers la gauche
;   RIGHT ==> Se deplace vers la droite
;   SPACE ==> Commence le jeu
;   Q ==> Quitte le jeu
;****************************************
include LIBGFX.INC

pile    segment stack         ; Segment de pile
pile    ends

donnees segment public  ; ******* Segment de donnees **********

; +++++++++++++++++++++++++++++++++++++++++++++
;               CONSTANTES
; +++++++++++++++++++++++++++++++++++++++++++++
; ============- GAME ICONS =====================

;extrn splash:word
extrn map:word
extrn carMiddle:word
extrn carRight:word
extrn carLeft:word

; +++++++++++++++++++++++++++++++++++++++++++++
;               VARIABLES
; +++++++++++++++++++++++++++++++++++++++++++++
cycle DB  0
direction DB 2
mapPosX  DW  5
mapPosY  DW  5
carPosX DW 0
carPosY DW 0
obstacleYPos DW 0

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
    mov tempo, 5
    
    mov Rx, 100
    mov Ry, 20
    mov Rh, 50
    mov Rw, 10
    mov col, 7
    call Rectangle

; ========== Display Splash ===============
displaySplash:
    mov BX, offset map
    CALL drawIcon
    call WaitKey
    cmp userinput, ' '  ; Space bar
    je gameloop
    jmp displaySplash

; ========== GAME LOOP ===============
gameloop:
    call drawMap
    CALL drawCar
    call docycle
    call sleep
    call interact
    ;call isdead
    jmp gameloop
; ====================================
   
; =============================
;      ROUTINES
; =============================
;--------- drawMap ------------
drawMap:
    mov AX, mapPosX
    mov hX, AX
    mov AX, mapPosY
    mov hY, AX
    mov BX, offset map
    call drawIconBig
    ret

;--------- drawCar ------------ 
; cycle <<  
drawCar:
    mov AX, carPosX
    mov hX, AX
    mov AX, carPosY
    mov hY, AX
    cmp direction, 0  ; right
    jne drawCarLeft
    call drawCarMiddle
    jmp drawCarCall
drawCarLeft:
    cmp direction, 1  ; left
    jne drawCarMiddle
    mov BX, offset carLeft
    jmp drawCarCall
drawCarRight:
    cmp direction, 2  ; up
    jne drawCarMiddle
    mov BX, offset carRight
    jmp drawCarCall
drawCarMiddle:
    mov BX, offset carMiddle
    jmp drawCarCall
drawCarCall:
    CALL drawIcon
    RET
dess1: 
    mov BX, offset carLeft  ; cycle = 1
	  CALL drawIcon
    RET

;------- docycle ---------------
; >> carPosX, cycle
docycle:
    cmp direction, 0   ; move right
    jne moveL
    inc carPosX
    jmp cycle1
moveL:                 ; move left
    cmp direction, 1
    jne moveU
    dec carPosX
    jmp cycle1
moveU:
    cmp direction, 2
    jne moveD
    dec carPosY
    jmp cycle1
moveD:
    inc carPosY
    
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
    cmp userinput, 'q'
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
    mov AX, mapPosX
    add AX, 13
    mov cCX, AX
    mov AX, mapPosY
    add AX, 8
    mov cDX, AX
    call ReadPxl
    cmp rdcol, 0
    je  notDead
    call VideoCMD
	mov AH,4Ch      ; 4Ch = fonction de fin de prog DOS
	mov AL,00h      ; code de sortie 0 (tout s'est bien passe)
	int 21h		
notDead:
    ret

; ================= FIN DU CODE ===============
        
code    ends                   ; Fin du segment de code
end prog                         ; Fin du programme
