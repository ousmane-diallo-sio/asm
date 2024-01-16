;****************************************
;   Base icone
; ---------------------------------------
;	Any key --> Exit
;
;  v 1.0  T. JOUBERT  05 Dec 2021
;****************************************

include LIBGFX.INC

extrn image:word

pile    segment stack   ; Segment de pile
pile    ends

donnees segment public  ; Segment de donnees 
donnees ends    

; ============================================
;               PROGRAMME
;=============================================
code    segment public        ; Segment de code
assume  cs:code,ds:donnees,es:code,ss:pile

prog:
	mov AX, donnees
	mov DS, AX

	CALL VideoVGA
    mov hX, 5
	mov hY, 5
	mov BX, offset image
	CALL drawIconBig
	call WaitKey
		
fin:
	call VideoCMD
	mov AH,4Ch      ; 4Ch = fonction de fin de prog DOS
	mov AL,00h      ; code de sortie 0 (tout s'est bien passe)
	int 21h		

;=============================================
code    ends                   ; Fin du segment de code
end prog                         ; Fin du programme
