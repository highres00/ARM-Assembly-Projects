.global _start
sum: .space 4
_start:
	mov r0,#1// SUM  (F(N))
	mov r1,#0 //f(0)


mov r2,#1 //f(1)
	  mov r3,#2 //i=2
	
mov r4,#6 // n
	
LOOP: 
   
   CMP r3, r4  // compares the iteration value to n(condition for loop)
     
STR r0, sum
   
BGT END    // if i-n>0, loop terminates
   MOV r5, r0  //stores the original sum r0 in a temporary register
   ADD r0, r1,r2 // adds f(n-1) and f(n-2) and stores it in r0
 
  MOV r2, r0    //stores the new sum in n-1
   
 MOV r1, r5    // stores the original sum in n-2
   
   ADD r3,r3,#1
   B LOOP
END: 
        B END
   
   

