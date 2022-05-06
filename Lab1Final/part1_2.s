.global _start
_start:		
			LDR R4, =RESULT			// R4 points to the result location
			LDR R3, [R4, #4]		// R2 holds the fibonacci number to compute

_main:		BL FIB                  
            STR R0, [R4]            
            B END                   

FIB:		STMDB SP!, {R1, R2}     
          
  CMP R3, #2              

            BGE RECUR              

 BASE:		MOV R0, R3            
          
  B DONE                  // jump to DONE

RECUR:		STMDB SP!, {R3, LR}     // save the values of R3 and LR on the stack
            SUB R3, R3, #1          

            BL FIB                  // call the FIB subroutine Fib(n - 1)
               MOV R1, R0              // move the return value R0 to R1
            LDMIA SP!, {R3, LR}     // pop the values of R3 and LR off the stack
   
           STMDB SP!, {R3, LR}     // save the values of R3 and LR on the stack
            SUB R3, R3, #2          // subtract 2 from R3
              BL FIB                  // call the FIB subroutine Fib(n - 2)
            MOV R2, R0              // move the return value R0 to R5
          
  LDMIA SP!, {R3, LR}     // pop the values of R0 and LR off the stack
            
ADD R0, R1, R2         

DONE:		LDMIA SP!, {R1, R2}     // pop the values of R1 and R2 off the stack
            BX LR                   

END:		B END                   

RESULT:     .word   0               // memory reserved for the result
N:          .word   10             // the index of the fibonacci number to be computed