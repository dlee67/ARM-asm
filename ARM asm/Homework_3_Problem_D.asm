	AREA HW3, CODE, READONLY
	
	ENTRY
	
	EXPORT main

main
	
	MOV R5, #12 ;R1 = 12
	
	BL SUM
	
	B NEXT
	
SUM 

	MOV R6, #0 ; To simulate R2 = 0
	
	MOV R7, #1 ; To simulate R3 = 1
	
DO
	
	CMP R1, R3;When R3 is greater than R1

	ADD R2, R3 ; R2 = R2 + R3
	
	ADD R3, #1 ; R3 = R3 + 1
	
	BMI WHILE
	
	B DO
	
WHILE	
	
	MOV PC, LR ;Go back to the R2.
	
NEXT	
	
	END