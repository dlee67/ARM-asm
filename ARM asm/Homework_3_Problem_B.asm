	AREA HW3, CODE, READONLY
	
	ENTRY
	
	EXPORT main
	
main 

	MOV R5, #0 ; To simulate R2 = 16
	
	MOV R6, #16 ; To simulate R1 = 0
	
	MOV R7, #10 ; To stop the loop at one point.
	
FOR CMP R7, R5 ; To simulate R1 < 10

	BEQ NEXT

	ADD R6, R6, R5 ; R2 = R2 + R1

	ADD R5, R5, #1

	B FOR
	
NEXT	
	
	END