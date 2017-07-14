* Data movement & addition in registers

		AREA     ARMex, CODE, READONLY
                                ; Name this block of code ARMex
		ENTRY                   ; Mark first instruction to execute

		EXPORT	main		;required by the startup code

main						;required by the startup code
        MOV      r5, #10        ; Set up parameters
        MOV      r6, #3
        ADD      r5, r5, r6     ; r5 <- r5 + r6
		
stop
        MOV      r0, #0x18      ; angel_SWIreason_ReportException
        LDR      r1, =0x20026   ; ADP_Stopped_ApplicationExit
		SVC		#0x11	; previously SWI
		;BKPT #0xAB for semihosting isn't supported in Keil's uV

		ALIGN

		AREA     ARMexData, DATA, READWRITE
                                ; Name this block of data ARMexData
								; which MUST be different from the 
								; name of the code area
		EXPORT	adrStr1
		EXPORT	adrShortXs
		EXPORT	adrIntYs
		EXPORT	adrBuffer
		EXPORT	adrZ
			
adrStr1		DCD		str1
adrShortXs	DCD		shortXs
adrIntYs	DCD		intYs
adrBuffer	DCD		buffer
adrZ		DCD		z


str1	DCB		"Hello World!", 0
		ALIGN
shortXs	DCW		-15, 2038, 0xA9, 0x12, 12 
		ALIGN
intYs	DCD		-15, 2038, 0xA9, 0x12, 12
	
buffer	SPACE 20

z		DCD		0xABCDEF89
	
		END                     ; Mark end of file