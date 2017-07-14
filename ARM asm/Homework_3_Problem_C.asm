	AREA HW3, CODE, READONLY
	
	ENTRY
	
	EXPORT main
	
main
	
	;Considering R5 to be R1
	;R6 to be R2
	;R7 to hold 0
	;I believe that I can use CBNZ, but going to push that
	;aside for now.
	CMP R7, R5 ;Trying to simulate R1 < 0.
	
	BMI IF
	
ELSE 

	ADD R6, R1, #18 ;R2 = 18 + R1
	
	SUB R5, R5, #1 ;R1 = R1 - 1

IF 
	
	RSB R6, #18 ;Simulate R2 = 18 - R1

	ADD R5, #1 ;Simulate R1 = R1 + 1
	
	END