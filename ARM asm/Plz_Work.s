	AREA TextA, DATA, READWRITE
		
	EXPORT STOREPLACE	
		
STOREPLACE DCD STORE
	
STORE DCB "HI", 0
	

	AREA Text1, CODE, READONLY

	EXPORT main
	
	ENTRY
	
main 

;The example below is straight off from the book.

	MOVW R6, #0x00008000

	MOVW R5, #0 
	
	MOVW R5, #0x0000BABE 
	
	ADD R5, #0xF0000000
	
	ADD R5, #0x0E000000
	
	ADD R5, #0x00E00000
	
	ADD R5, #0x000D0000
	
	;ADR R7, STOREPLACE
	
	;STR R5, [R7] 

	SWI 0x11

;So, the adrString contains the content in String?
;In my understanding, the below instructions are having adrString contain the location called String.
;and the address location called String contains the ASCII of HI
;but when I looked into memory location called 0x0414, nothing seemed to be there.

;adrString	DCD String

;String DCB "Hi" 

;	LDR R5, =adrString

;	ADR R6, adrString

;I recognize that the BL will save the address to return to, but 
;it's giving me an error if I am trying to branch to R14.
;	MOV R5, #0
;	BL Jump
;Jump MOVW R5, #0x000000FF
;	MOV R5, #0
;	B R14
	
	 END
	