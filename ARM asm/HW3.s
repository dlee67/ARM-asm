	AREA HW3, CODE, READONLY

	ENTRY

	EXPORT main

main
	
	MOV R6, #0 ;Clear

	;Could test the output with either of those.
	;MOV R5, #10
	MOV R5, #-10

	CMP R5, #0 ;Trying to simulate R1 < 0.

	BMI IF

ELSE 

	ADD R6, R5, #18 ;R2 = 18 + R1

	SUB R5, R5, #1 ;R1 = R1 - 1

	B NEXT

IF 
	
	RSB R6, R5, #18 ;Simulate R2 = 18 - R1

	ADD R5, #1 ;Simulate R1 = R1 + 1

NEXT

	END
