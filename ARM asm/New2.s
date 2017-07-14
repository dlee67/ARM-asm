	;AREA  New2_D, DATA, READWRITE
	
Index_One   EQU #1

Index_Two   EQU #2

Index_Three EQU #3 

Index_Four	EQU #4

Index_Five  EQU #5
 	
city DCB "Greenwood Village", 0

	ALIGN

sales
	
	DCW #28

	DCW #39
	
	DCW #34
	
	DCW #26
	
	DCW #50
	
	ALIGN
	
Int_X 

	DCW #0
	
	ALIGN
	
fifoQueue

	SPACE 5000
	
	ALIGN	

	AREA New2, CODE, READONLY
	
	ENTRY
	
;	EXPORT main
	
main
	
	MOVW R1, #0x55555555
	
	ADR R2, sales
	
	MOV R3, R2
	
	MOV R4, #100
	
	ADD R5, R4, R3
	
	ADR R2, Int_X
	
	END