*Inputs : a positive integer, a, and a positive integer, b
*    each of which is given in a null-terminated string 
*Logic :
* Convert a and -b into their 2's complements and add them together
* Store the result of a + (- b) to result
*     for any invalid case, just leave 0x00000000 at result

	AREA	AddIntsIn2sComp, CODE, READONLY
	EXPORT	main		;required by the startup code
	ENTRY

main					;required by the startup code
	LDR R9, =a		;[R9]<-the address of a's MSD
	BL Dec2Bin
	TST R2, #0x80000000		;is [R2]'s MSB 0?
	BNE DONE		;[R2]'s MSB is 1!
	MOV R5, R2		;[R5]<--a's 2's complement

	LDR R9, =b		;[R9]<-the address of b's MSD
	BL Dec2Bin
	TST R2, #0x80000000	;is [R2]'s MSB 0?
	BNE DONE		;[R2]'s MSB is 1!
	MVN R6, R2		;[R6]<-b's 1's complement
	ADD R6, R6, #1	;[R6]<-b's 2's complement

	ADD R7, R5, R6	;[R7]<- a + (-b)	
	LDR R8, =result
	STR R7, [R8]	;store a + (-b) at result

DONE
	MOV		r0, #0x18      ; angel_SWIreason_ReportException
	LDR		r1, =0x20026   ; ADP_Stopped_ApplicationExit
	SVC		#0x11	; previously SWI
	;BKPT #0xAB for semihosting isn't supported in Keil's uV

* subroutine converting positive dec to bin
*    range of dec: 0 ~ $7FFFFFFF
*  inputs: R9 - address of the MSD in ASCII,
*  	where the decimal string is null-terminated
*  outputs: R2 - binary pattern of dec
*    [R2] <-- 0xFFFFFFFF if an invalid dec
*  tmp registers used: R3, R4
Dec2Bin		
	MOV R2, #0	;clear result register

LOOP_Dec2Bin
	LDRB R3, [R9], #1	;read one ascii of dec
	CBZ R3, DONE_Dec2Bin ;break if it's a null terminator (0x0)

	SUB	R3, R3, #'0'	;convert ascii to digit
	CMP R3, #0		;is it lower then 0
	BLO InvalidDec	;not a valid digit
	CMP R3, #9		;is it higher then 9
	BHI InvalidDec	;not a valid digit

			;Next, [R2]<--[R2]*10+[R3]

	MOVS R4, R2, LSL #1	;[R4]<--original [R2] * 2
	BMI InvalidDec	;[R4]'s MSB is 1 ([R4] is negative)

	MOVS R4, R4, LSL #1	;[R4]<--original [R2] * 4
	BMI InvalidDec	;[R4]'s MSB is 1 ([R4] is negative)

	MOVS R4, R4, LSL #1	;[R4]<--original [R2] * 8
	BMI InvalidDec	;[R4]'s MSB is 1 ([R4] is negative)

	MOVS R2, R2, LSL #1	;[R2]<--original [R2] * 2
	BMI InvalidDec	;[R2]'s MSB is 1 ([R2] is negative)

	ADDS R2, R2, R4  ;[R2]<--original [R2]*10
	BMI InvalidDec	;[R2]'s MSB is 1 ([R2] is negative)

	ADDS R2, R2, R3	;[R2]<--original [R2]*10 + [R3]
	BMI InvalidDec	;[R2]'s MSB is 1 ([R2] is negative)

	B LOOP_Dec2Bin
	
InvalidDec	;a digit beyond 0-9 or overflow
	MOV	R2, #0xFFFFFFFF	;0xFFFFFFFF is a valid Thumb modified
						;immdediate

DONE_Dec2Bin
	BX	LR	;return of Dec2Bin

	AREA	intData, DATA, READWRITE
		
	EXPORT	adrA		;needed for displaying addr in command-window
	EXPORT	adrB		;needed ...
	EXPORT	adrResult	;needed ...

adrA	DCD		a		;needed for displaying addr in command-window
adrB	DCD		b		;needed ...
adrResult	DCD	result	;needed ...
	
a	DCB	"1234", 0	; the number a
	ALIGN
 
b	DCB	"1234 ", 0	; the number b
	ALIGN

result
	DCD	0	; the result of a + (-b)
	
	END