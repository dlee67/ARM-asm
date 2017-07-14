	AREA OffMyOwn, CODE, READONLY
		
	ENTRY
	
	EXPORT main
		
main

	LDR R3, =HCode

	MOV R4, #0 ; R4 will contain the bytes those will be transferred to from HCode.
	
	MOV R5, #1 ; R5 will play a role as an index to be computated with other things.
			   ; Taking a consideration that HammingCode's index starts from one.
	
	MOV R6, #0 ; R6 will act as the index that will point through the HCode.	
	
	MOV R7, #0 ; pRec, which is the register that has received that pairity.
	
	MOV R8, #0 ; pCal, calculated parity bits.
	
	MOV R9, #0 ; for the purpose of counting 1's, have it be n.
	
	MOV R10, #0 ; for the purpose of counting 1's, have it be n - 1.

	MOV R11, #0 ; counting ones, which is counting ANDs happened.

checkLoop ; while(R4 != 0)
	
	LDRB R4, [R3, R6] 	

	CMP R4, #0
	
	BEQ checkLoopDone
;So, the logic is that, okay, out loops aren't finished, I got a 1 or 0 as a character.	

	SUB R4, #'0' ; Subtract R4 with '0', so I actually get a number...

;Now, I need to count the ones, in order to see if the bit I've got is part of a check bit or a data bit.
	
	MOV R9, R5 ; To have my material be separated from the rest.	
	
	MOV R11, #0
	
	BL countOnes ;Seems like I am counting ones right.
	
;I am guessing it's time for me to compare stuff.
	
	CMP R11, #1 ;To see if it is check bit.
	
	BEQ isCheck

notCheck ;If it is not a check bit, then 

	CMP R4, #1
	
	EOREQ R8, R8, R5

	ADD R5, R5, #1
	
	ADD R6, R6, #1
	
	B checkLoop 

isCheck ;If it is a check bit, then ORR the thing and store that to pRec

	CMP R4, #1

	ORREQ R7, R7, R5 

	ADD R5, R5, #1

	ADD R6, R6, #1

	B checkLoop
	
checkLoopDone	
	
	;I need to see if I do have an error.
	
	EOR R4, R7, R8 ; I should be getting the position where the error has occurred;
				   ; into that address, I need to chuck in a one.

	CMP R4, #0

	BEQ noErr

	SUB R4, #1 ;Subtract one because hamming code is +1.

	LDRB R6, [R3, R4] ; See if the bit I need to flip is 1 or 0.

	CMP R6, #'1' ;If it's 1...

	MOVEQ R5, #'0' ;Prepare to move 0 into it. 

	MOVNE R5, #'1' ;if it's not one, then prepare to flip the bit.			

	STRB R5, [R3, R4] ; The  

noErr

	;R3, =HCode <-I would still want that since because I need to transfer those bits those I've gotten
	
	LDR R4, =SrcWord
	
	MOV R5, #0 ; R5 will contain the bytes those will be transferred to SrcWord

	MOV R6, #1 ; Since the hamming code starts with 1, R6 will starts to increment from one.

	MOV R7, #0 ; R7 will hold the memory location for the HCode.

	MOV R8, #0 ; R8 is for the purpose of using incrementing the address for the SrcWord.

	MOV R11, #0 ; For the purpose of counting ones.
	
	
	MOV R5, #1 ;For the sake of not having the loop not end right at the moment it begins.

putBitsIntoSrcWord

		CMP R5, #0 ; Compare the R5 with null, if null, finish the loop

		BEQ Done

		LDRB R5, [R3, R7] ;Load byte by byte from the matrials of the HCode.
	
		;But if it is a check bit, I need to skip the thing...

		MOV R9, R6 ; Move R6 into the R9, for the purpose of checking if the bit is a check bit.

		BL countOnes

		CMP R11, #1 ; If one, then ANDing only happened once; thus, the bit is a data bit.
		
		BEQ skipCheckBit	

		;If not check bit, then store the material into the SrcWord.
		
		STRB R5, [R4, R8] ;Store the LSB into the address of the SrcWord

		ADDNE R8, #1 ; As Mr.John have suggested.

skipCheckBit

		ADD R6, #1 ;Incrementing the Hamming Code's index.	
		
		ADD R7, #1 ;Incrementing the location of the memory.

		MOV R11, #0 ;Reset R11 so when counting ones happen again, it won't cause a logic error.

		B putBitsIntoSrcWord

Done
	
	MOV R5, #0;
	
	STRB R5, [R4, R8] ; To wrap up things with null-terminator.
	
	SWI #0x11


countOnes ; while(R9 != 0)

;For counting ones, expression of (n) & (n-1) is used.

	CMP R9, #0	

	BXEQ LR ; Instruction so I can return. 

	SUB R10, R9, #1 ; To make n-1
	
	AND R9, R9, R10 ; (n) & (n - 1)

	ADD R11, #1 ; Officially counting. 
	
	B countOnes
	
	ALIGN
	AREA DOffMyOwn, DATA, READWRITE
		
	EXPORT adrHCode
			
	EXPORT adrSrcWord
		
MAX_LEN EQU 100		
	
HCode DCB "0010111", 0
	
	ALIGN

SrcWord SPACE MAX_LEN+1
	
	ALIGN
	
adrHCode DCD HCode	
	
	ALIGN
	
adrSrcWord DCD SrcWord	
	
	ALIGN
	
	END