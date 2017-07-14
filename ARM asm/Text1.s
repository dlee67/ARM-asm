	AREA Text1, CODE, READONLY

	EXPORT main
	
	ENTRY
	
main 

	MOV r6, #10
	
	 MOV r7, #1
	
loop ADD r7, r7, #1

	 CMP r6, r7

	 BEQ loop
	
	 END
	