	AREA	HW6, CODE, READONLY

;EQU sets 'Constants'
_WRITE_CHAR		EQU		0x00	; writes single character by value from r0
_WRITE_STRING	EQU		0x02	; Writes string by pointer in r0
_READ_CHAR		EQU		0x04	; Reads a single character of input into r0
_EXIT			EQU 	0x11	; Terminates the program


MAX_LEN			EQU		100
	EXPORT	adrHCode
	EXPORT	adrSrcWord

	AREA Strings, DATA, READWRITE
		ALIGN
strNoError		DCB	"No Errors Detected. ^_^ \n",0
		ALIGN
strParityError 	DCB	"Error in parity bit! -_- \n",0
		ALIGN
strDataError 	DCB	"Error in data bit! >_< \n",0
		ALIGN
strEncodedData 	DCB	"Original encoded data:\n",0

		
	AREA AddressData, DATA, READWRITE
	
	EXPORT adrHCode
	EXPORT adrSrcWord
		
adrHCode 	DCD 	HCode
adrSrcWord 	DCD 	SrcWord



	AREA MainData, DATA, READWRITE
		;Underscore pushes the first '1' to index 1
HCode	DCB	"111111001001101",0
SrcWord	SPACE MAX_LEN
BUFFER	DCD 0x00


			;Stack is useful for calling subroutines
	AREA StackRegion, DATA, READWRITE
		ALIGN
stack		SPACE	1023
stack_end	DCB	0x00


	AREA ProgramArea, CODE, READONLY
		ALIGN
		ENTRY

		EXPORT main
		
main
	LDR		sp, =stack
	LDR		r4, =HCode
	LDR		r5, =SrcWord
	
	;See if we need to subtract one from the address of HCode
	LDRB 	r3, [r4] 	;
	CMP		r3, #'_'  	;
	SUBNE	r4, r4, #1	;
	
	
	MOV		r6, #1 ; index = 1 (hamming code starts at position 1)
	MOV		r7, #0 ; pRec - recieved parity bits
	MOV		r8, #0 ; pCalc - calculated parity bits
	

checkLoop	; while (true) {
	LDRB	r3,	[r4, r6]; c = HCode[index]
	CMP		r3, #0		; if (c == 0) 
	BEQ		checkDone	; 	break
	CMP		r6, #MAX_LEN; if (index > MAX_LEN) 
	BGE		checkDone	;	break
	
	; convert #'0' to a #0, and a #'1' to #1
	SUB		r3, r3, #'0' ; (c -= '0')
	
	MOV		r0, r6 ; pass argument index to count1s
	; Place variables onto stack
	STMIA	sp!, { r3, r4, r5, r6, r7, r8, r14 }
	
	; Call count1s method
	BL		count1s; count = count1s(index) // r1 = count
	
	; Restore variables from stack
	LDMDB	sp!, { r3, r4, r5, r6, r7, r8, r14 }
	CMP		r1, #1 ; if (count == 1) {
	BNE		handleDataBit
	; Parity bit!
	
	CMP		r3, #1	; if (c == 1)
	ORREQ	r7, r7, r6 ; pRec |= index; //(index must be a power of 2 here)
	
	ADD		r6, r6, #1 ; index++
	B	checkLoop
handleDataBit ;} else {
	
	CMP		r3, #1	; if (c == 1)
	EOREQ	r8, r8, r6 ; pCalc ^= index; //(index must be non-power of two here)
	; Data bit!
	
	ADD		r6, r6, #1 ; index++
	B 	checkLoop
checkDone   ; }
	;Done checking/processing encoded message
	; get index of error (if any)
	EOR		r6, r7, r8 ; index = pCalc ^ pRec
	
	MOV		r0, r6
	; Place variables onto stack
	STMIA	sp!, { r3, r4, r5, r6, r7, r8, r14 }
	
	; Call count1s method
	BL		count1s; count = count1s(index) // r1 = count
	
	; Restore variables from stack
	LDMDB	sp!, { r3, r4, r5, r6, r7, r8, r14 }
	; Show message based on count of 1s in error index
	CMP		r1, #1
	LDRLT	r0, =strNoError
	LDREQ	r0, =strParityError
	LDRGT	r0, =strDataError
	SWI		_WRITE_STRING
	
	
	
	
	CMP		r6, #0 ; if (index != 0) {
	; Correct error if it exists
	LDRNEB	r3, [r4, r6] ; c = HCode[index]
	EORNE	r3, r3, #1   ; flip '0' to '1' and '1' to '0'
	STRNEB	r3, [r4, r6] ; HCode[index] = c
	; }
	
	MOV	r6, #1 ; index set back to 1
	MOV	r7, #0 ; index2, offset in SrcWord to store at
	
extractLoop ; while (true) {
	
	LDRB	r3, [r4, r6] ; c = HCode[index]
	CMP		r3, #0			; if (c == 0)
	BEQ		extractDone		; 	break
	CMP		r6, #MAX_LEN	; if (index >= MAX_LEN)
	BGE		extractDone		;	break
	
	MOV		r0, r6	; put index into r0 to pass it to count1s
	; Place variables onto stack
	STMIA	sp!, { r3, r4, r5, r6, r7, r14 }
	
	; Call count1s method
	BL		count1s; count = count1s(index) // r1 = count
	
	; Restore variables from stack
	LDMDB	sp!, { r3, r4, r5, r6, r7, r14 }
	
	CMP		r1, #1	; if (count != 1) {
	STRNEB	r3, [r5, r7]	; SrcWord[index2] = c;
	ADDNE	r7, r7, #1		; index2++;
	; }
	
	ADD		r6, r6, #1		; index++;
	B		extractLoop 
extractDone ; }
	
	; Ensures built string always has null terminator
	MOV		r3, #0
	STRB	r3, [r5, r7]
	
	MOV		r0, r5;
	SWI		_WRITE_STRING
	
	SWI 	_EXIT

; Counts the number of 1s in a given number from r0
; puts the count of 1s in r1
; r0 = n
; r1 = count
count1s
	MOV		r1, #0		; count = 0

cnt1LOOP
	CMP		r0, #0		;if n == 0 // we're done
	MOVEQ	pc, lr		; return 
	
	SUB		r12, r0, #1	;
	AND		r0, r0, r12	; n = n & (n-1) // (this removes a single 1 from the number)
	ADD		r1, r1, #1	; count++
	
	B	cnt1LOOP
	END