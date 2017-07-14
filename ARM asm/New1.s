	AREA New1,CODE,READONLY
	
	ENTRY
	
	EXPORT main
	
main

	LDR R5, =0x87349999

	MOV R6, #0
	
	MOV R7, #0
	
	ADD R6, #55
	
	ADD R7, #55

	LTORG
	
	B rout_one
	
rout_one

	LDR R6, =0x94823489

	LTORG
	
	END