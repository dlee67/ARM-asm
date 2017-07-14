;	AREA String, DATA, READWRITE

;	EXPORT city

;city   DCB "Greenwood Vilage", 0 ;Designates a portion of memory to hold ASCII's

;sales  DCB 28 ;Creates a simulation of memory, being segregated by bytes, where each section holds a value.

;	   DCB 39
	   
;	   DCB 34
	   
;	   DCB 26
	   
;	   DCB 50
	
;x
	
;	DCB 0 ; A variable x holds a value 0.
	
;fifoQueue

;	SPACE 5000 ; Allocates a 5000 byte length for future usages.
	
;	AREA Testing, CODE, READONLY
	
	ENTRY
	
;	EXPORT main
	
;main
	
;	LDR R5, =0x55555555
	
;	LDR R2, =sales
	
;	LDR R3, [R2] ;Should take a look at the behavior.
	
;	MOV R4, #100 
	
;	ADD R5, R4, R3

;	LDR R2, =x
	
;	STR R5, [R2] ;Something that has to do with READWRITE and READONLY
	
;	END