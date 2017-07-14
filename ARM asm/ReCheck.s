	AREA ReCheck, CODE, READONLY
	
	ENTRY
	
	EXPORT main
	
main

	LDR R5, =0x902E8C9A ; Pouring

	LDR R6, =0x20000000 ; Designating address
	
	STR R5, [R6] ;Chunking in

	LDRSB R7, [R6]	

	END