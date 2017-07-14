	AREA Fib, CODE, READONLY
	
	ENTRY
	
	EXPORT main
	
main

	MOV R5, #1 ; R5 will hold a_k. Will start out as the innitial value 1.
	
	MOV R6, #1 ; R6 will hold a_(k-1). Will start out as the innitial value 1.
	
	MOV R7, #0 ; R7 will hold a_(k-2). Should become 2 in the innitial run. Also, should show result.
	
	MOV R8, #0 ; R8 holds the value to display, incase the loop ends.
	
	MOV R9, #0 ; R9 will hold the count control, which represents n+1.
	
	ADD R10, R9, #2
	
loop 

	CMP R10, #3
	
	BEQ loopDone

	ADD R7, R6, R5 ; a_k = a_(k-1)+a_(k-2)
	
	MOV R8, R7 ; In case the loop ends in this iteration, MOV value of a_k to R8.
	
	MOV R5, R6 ; For next iteration, I need to store the R6's value into a_(k-2).
	
	MOV R6, R7 ; For next iteration, I should store the R7's value into a_(k-1).
	
	MOV R7, #0 ; Clear off the R7 in order to prepare for the next itereation.
	
	ADD R10, #1 ; Increment the counter.
	
	B loop

loopDone
	
	SWI #0x11 ; Whatever value that is in the R8 is the result.
	
	END