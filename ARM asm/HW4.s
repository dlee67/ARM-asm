	AREA HW4D, DATA, READWRITE
	
	EXPORT adrStrOne
	
	EXPORT adrStrTwo
		
	EXPORT adrMixStr
	
StrOne	  DCB "Hello Metro State!", 0 ;StrOne 
  
StrTwo    DCB "I like assembly programming.", 0 ;StrTwo

MAX_LEN   EQU 100 

MixStr	  SPACE MAX_LEN+1 ;wonder if that works

		  ALIGN

adrStrOne DCD StrOne
	
adrStrTwo DCD StrTwo
	
adrMixStr DCD MixStr

	AREA HW4, CODE, READONLY
	
	ENTRY
	
	EXPORT main
	
main
	
	LDR R5, =StrOne
	
	LDR R6, =MixStr

	LDR R7, =StrTwo

	;R8 is supposed to be a place holder for the bytes those moved in.

	B MovStrOneByte

MovStrOneByte
	
		
	LDRB R8, [R5]
	
	STRB R8, [R6]
	
	ADD R5, R5, #0x1 ;StrOne pointer increment
	
	CMP R8, #0
	
	BEQ FinStrTwo
	
	ADD R6, R6, #0x1 ;MixStr pointer increment
	
	B MovStrTwoByte

MovStrTwoByte

	LDRB R8, [R7]
	
	STRB R8, [R6]
	
	ADD R7, R7, #0x1 ;For the increment of the StrTwo 
	
	CMP R8, #0
	
	BEQ FinStrOne
	
	ADD R6, R6, #0x1 ;For the increment of the MixStr
	
	B MovStrOneByte
	
FinStrOne
	
	LDRB R8, [R5]
	
	STRB R8, [R6]
	
	CMP R8, #0
	
	BEQ Done
	
	ADD R5, R5, #1
	
	ADD R6, R6, #1
	
	B FinStrOne
	
FinStrTwo

	LDRB R8, [R7]
	
	STRB R8, [R6]
	
	CMP R8, #0
	
	BEQ Done
	
	ADD R6, R6, #1
	
	ADD R7, R7, #1
	
	B FinStrTwo

Done
	
	SVC #0x11 ;to wrap up nicely
	
	END