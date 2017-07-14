	AREA HW5, CODE, READONLY
	
	ENTRY 
	
	EXPORT main
		
main

	MOV R4, #0x0 ; Count-control

	MOV R5, #0x0 ; R5 will be used for holding the orginal address of HexStr
	
	MOV R6, #0x0 ; R6 will hold the value of the interest

	MOV R7, #0x0 ; R7 will hold the value that is being converted.
	
	MOV R8, #0x0 ; R8 will hold over all values.

	LDR R5, =HexStr ; R5 holds the address of HexStr

Loop

	LDRB R6, [R5, R4] ; Holds the actual value of interest.
	
	CMP R6, #0
	
	BEQ ToTwosComp ; When R6 hits the null-terminator, 
				   ; branch to ToTwosComp
	
	ADD R4, #1 ; Increment after the iteration.

	CMP R6, #48

	BLT Invalid ;If the R6 is greater than 57, then the value is invalid.

	CMP R6, #70 ;If greater than immediate value 70, the value is invalid
	
	BGT Invalid

	CMP R6, #65 ; To see if the value of the R6 is A-F

	BGE As2Hex ;Branch if R6(the value of interest) is greater or equal to 41, which indeicates the character that is greater 'A'

	CMP R6, #57 ; To see if the value of R6 is 0-9

	BGT Invalid

	BLE As2Dec

	
As2Dec

	SUB R7, R6, #48
	
	LSL R8, #4
	
	ADD R8, R7
	
	B ToLoop ;Unconditionally branch to ToLoop, for ASCII to Hexadecimal value conversion is not needed, if this block of code was executed.

As2Hex

	SUB R7, R6, #55 ; R7 will hold the ASCII -> Hexa value 

	LSL R8, #4

	ADD R8, R7

	B ToLoop 

Invalid 

	LDR R10, =0xFFFFFFFF
	
	SVC #0x11 

ToLoop

	B Loop
	
ToTwosComp

	LDR R9, =TwosComp ; Temporary register where I will store the address of TwosComp
					  ; inorder to STR value of R8 into TwoComp address(because STR don't have a pseudo instruction.
	
	STR R8, [R9]   ;Since, R8 has the converted value, I must move those values into the RvsStr Address, while performing the
				   ;division and storing.
	
	MOV R4, #0 ; R4 is the count control
	
	MOV R6, #0 ; For the replacement quotient
	
	LDR R9, =RvsDecStr
	
	LDR R10, =DecStr
	
	CMP R8, #0x80000000 ;I only compare the values which is MSB...
	
	BPL IsNeg

NegEvalComp

	MOV R5, R8 ;Move the value of the R8 into the R5, so R5 evaluation doesn't touch the R8

ToRvsStr

	B Subtract

EvalSubComp

	;After the R5's evaluation is complete,
	;then what I want to store that value into the remainder.
	
	ADD R5, '0'
	
	STRB R5, [R9, R4]
	
	SUB R5, '0'
	
	ADD R4, #1
	
	MOV R5, R6 
	
	MOV R8, R6 
	
	MOV R6, #0
	
	CMP R8, #10
	
	BLT LastStr

	B ToRvsStr

DoneLastStr

	B DONE_RvsStr
	
LastStr

	ADD R8, '0'

	CMP R8, '0'
	
	BEQ DoneLastStr
		
	STRB R8, [R9, R4]

	ADD R4, #1

	B DoneLastStr

DONE_RvsStr

	CMP R12, #1
	
	MOVEQ R5, '-'
	
	BEQ HasSign
	
	B NoSign
	
HasSign ; If has sign, then add sign and null-ter
	
	STRB R5, [R9, R4]

	ADD R4, #1

	B ToDecStr
	
NoSign ; If no sign, then put null ter then break
	
	MOV R5, #0

	ADD R4, #1

	STRB R5, [R9, R4]

	B ToDecStr

InnitToDecStr

	MOV R6, #0 ;The counter

ToDecStr

;The plan is the R4 needs to keep being subtracted one by one
;And the new counter needs to increment again and again.

	LDRB R5, [R9, r4]
	
	CMP R5, #0 
	
	BEQ NullTerSkip 
	
	STRB R5, [R10, R6]
	
	ADD R6, #1
	
	CMP R4, 0 
	
	BEQ Done 
	
NullTerSkip	
	
	SUB R4, #1
	
	B ToDecStr

Subtract 

	CMP R5, #10

	BLT EvalSubComp

	SUB R5, #10

	ADD R6, #1

	B Subtract

IsNeg

	MVN R8, R8 ;Flipping
	
	ADD R8, #1 ;Adding one
	
	MOV R12, #1
	
	B NegEvalComp

Done

	SVC #0x11
			
	AREA HW5D, DATA, READWRITE
		
	EXPORT adrHexStr

	EXPORT adrTwosComp
		
	EXPORT adrDecStr

	EXPORT adrRvsDecStr

HexStr DCB "FFF4B3FA", 0

TwosComp DCD 0
	
DecStr SPACE 12
	
RvsDecStr SPACE 11
	
adrHexStr DCD HexStr
	
adrTwosComp DCD TwosComp
	
adrDecStr DCD DecStr
	
adrRvsDecStr DCD RvsDecStr
	
	END