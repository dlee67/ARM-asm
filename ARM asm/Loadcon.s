		AREA     Loadcon, CODE, READONLY
        ENTRY                      ; Mark first instruction to execute

		;EXPORT	main		;required by the startup code
		EXPORT	adrLargeTable	;needed in debugging


main						;required by the startup code
        BL		func1             ; Branch to first subroutine
        BL		func2             ; Branch to second subroutine
stop
        MOV		r0, #0x18		; angel_SWIreason_ReportException
        LDR		r1, =0x20026	; ADP_Stopped_ApplicationExit
		SVC		#0x11	; previously SWI
		;BKPT #0xAB for semihosting isn't supported in Keil's uV

func1
        LDR      r2, =42           ; => MOV R2, #42
        LDR      r3, =0x87654321   ; => LDR R3, [PC, #offset to
                                   ; Literal Pool 1]
        LDR      r4, =0xFFFFFFFF   ; => MVN R4, #0
        BX       lr				; return
		
        LTORG                      ; Literal Pool 1 contains
                                   ; literal 0x87654321

func2
        LDR.W		r5, =0x87654321	; without .W it will fail, because 
									; Literal Pool 1 is backward
        ;LDR 	r6, =0x89ABCDEF		; It will fail, because Literal
									; Pool 2 is out of reach
        BX       lr				; return
		
		;LTORG			; to make Literal Pool 2 available
		
		ALIGN
			
adrLargeTable
		DCD	LargeTable		; needed in debugging
	
LargeTable
        SPACE    4200              ; Starting at the current location,
                                   ; clears a 4200 byte area of memory
                                   ; to zero

		END                        ; Literal Pool 2 is inserted here, 
                                   ; but is out of range of the LDR
                                   ; pseudo-instruction that needs it