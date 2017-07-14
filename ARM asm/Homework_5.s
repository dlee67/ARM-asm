	AREA HW5D, DATA, READWRITE

	EXPORT adrHexStr
		
	EXPORT adrTwosComp
		
	EXPORT adrDecStr
	
	EXPORT adrRvsDecStr

HexStr DCB "A8F", 0 ;That's the first point of the assig.

TwosComp DCD 0 ;That's suppose to the be second point, but what's the point of signed word,
			   ;if the word will be zero?
			   ;Appears to be meaningless.
			   ;Anyways, that was the second bullet.
	
DecStr SPACE 12 ;This is the third bullet.
				;In order to simulate the reservation of the 12 bytes of memory,
				;SPACE 12 is a correct way, I think
	
RvsDecStr SPACE 11 ;This is the fourth bullet, which is the exact replica of the third bullet.
	
adrHexStr DCD HexStr ; #

adrTwosComp DCD TwosComp ; #
	
adrDecStr DCD DecStr ; #
	
adrRvsDecStr DCD RvsDecStr ; #

;# the pounded sections are 5th bullet.
	
;Now, on the idea of coding.	
	
	AREA HW5, CODE, READONLY
		
	ENTRY
	
	EXPORT main
		
main

	MOV R5, 

	LDR R1, =HexStr
	BL 	strToHex
	
	BX LR  ;end program
;takes in an address to a string in r1
;outputs the value of the string in hex in r2
strToHex

	MOV R2, #0 ; n = 0 <- basket where the value will be in
	MOV R4, #0 ; i = 0 <- count control

LOOP_strToHex

	CMP r4, #8 ; <- Because I can't accept more than 8 characters.
	BGE DONE_strToHex ; Why not EQ? because it's a convention and it protects me from memory corruption.
	
	LDRB R6, [R1, R4] ;
	CMP R6, #0 ; Check for null terminaotr
	BEQ DONE_strToHex ; To check the null-terminator
	
	
	CMP R6, #'0'
	BLT INVALID_HEX
	CMP R6, #'F'
	BGT INVALID_HEX
	
	SUB R5, R6, #'0'
	CMP R5, #9
	BLE hexSum ; We have the valid value, now we are going to brach to a function where we are going convert that value.
	
	
	
	SUB R5, R6, #55; Comparison to see if my value is within the Hexa value range
	CMP R5, #10 ;If less than 10, that means its less than A.
	BLT INVALID_HEX 
	
	
	
	
hexSum

	ADD R2, R5, R2, LSL #4 
	ADD R4, R4, #1 ; Remember, count controll.
	
	B LOOP_strToHex
	
	
INVALID_HEX

	MOV R2, #0xFFFFFFFF ; To check the error.
	
DONE_strToHex
	
	BX LR

	END
