.global _start
	
_start:
        bl      draw_test_screen
		//bl     VGA_clear_pixelbuff_ASM
		 //bl     VGA_clear_charbuff_ASM
end:
        b       end

@ TODO: Insert VGA driver functions here.
VGA_clear_pixelbuff_ASM:
	LDR R3, =0xC8000000//pixel buffer adress
	MOV R0, #0//initialise x
    //V R2, #0 
	PUSH {R4-R5}
	//R R1,=1
PLX:
	LDR R1, =1// initialise y
    //R R8,=2
	//L R9,R0,R8
	ADD R4, R3, R0, LSL#1//calculates pixel address using formula
    
PLY:
	ADD R5, R4, R1, LSL #10// pixel address after y is incremented
	
	STRH R2, [R5]//stores pixel address
	
	ADD R1, R1, #1 //increment y by 1
	TST R1, #240
	CMP R1, #240//check if y reached 240
	BLT PLY// if y is not 240, loop reiterates
	
	ADD R0, R0, #1 // increment x by 1
	//T R0,#20
	CMP R0, #320 //check if x reached 320
	BLT PLX //if x is not 320, barnches to PLX

	POP {R4-R5}
	BX LR
	
	
VGA_draw_point_ASM:
	//V R3, #320
	//P R0, #0
	//LT LR
	//P R1, #0
	//LT LR
	TST R0,#320
	CMP R0, #320// check if x is below 320
	BXGT LR
	CMP R1, #240// check if y is below 240
	BXGT LR
	
	LDR R3, =0xC8000000 // base address of pixel buffer

	
	ADD R3, R3, R1, LSL #10 //pixel address when y is incremented by 1
	ADD R3, R3, R0, LSL #1  // pixel address when x is incremented by 1

	STRH R2, [R3]   //writes pixel data to memmory

	BX LR
	
VGA_write_char_ASM:
	CMP R0, #80		//check if x is greaterthan 80
	BGE end
	//P R0, #0
	//T end
	TST R1,#60
	CMP R1, #60// check if y is greater than 80
	BGE end 
	TST R1, #0
	//P R1, #0
	//T end

	PUSH {R4-R5}
	LDR R3, =0xC9000000 //load character buffer base address
	
	ADD R4, R3, R0		//address calculaion
	ADD R5, R4, R1, LSL #7 // pixel address for y

	STRB R2, [R5] // store in memory

	POP {R4-R5}
	BX LR
	
	

	

VGA_clear_charbuff_ASM:
	PUSH {R4-R5}	
	//MOV R2, #0
	LDR R3, =0xC9000000 //load character buffer base address

	MOV R0, #0//initialise x
	
CLX:
    LDR R2, =0
	LDR R1, =0 //initialise y
	ADD R4, R3, R0// pixel address
CLY: 
	ADD R5, R4, R1, LSL #7 //pixel address
	//STRH R2,[R5]
	STRB R2, [R5]
	//P R0, #0
	//LT LR
	//P R1, #0
	//LT LR
	ADD R1, R1, #1//increment y
	TST R1,#60
	CMP R1, #60 //check if y less than 60
	BLT CLY
	
	ADD R0, R0, #1 //increment x
	CMP R0, #80// check if x less than 80
	BLT CLX
	
	POP {R4-R5}
	BX LR

draw_test_screen:
        push    {r4, r5, r6, r7, r8, r9, r10, lr}
        bl      VGA_clear_pixelbuff_ASM
        bl      VGA_clear_charbuff_ASM
        mov     r6, #0
        ldr     r10, .draw_test_screen_L8
        ldr     r9, .draw_test_screen_L8+4
        ldr     r8, .draw_test_screen_L8+8
        b       .draw_test_screen_L2
.draw_test_screen_L7:
        add     r6, r6, #1
        cmp     r6, #320
        beq     .draw_test_screen_L4
.draw_test_screen_L2:
        smull   r3, r7, r10, r6
        asr     r3, r6, #31
        rsb     r7, r3, r7, asr #2
        lsl     r7, r7, #5
        lsl     r5, r6, #5
        mov     r4, #0
.draw_test_screen_L3:
        smull   r3, r2, r9, r5
        add     r3, r2, r5
        asr     r2, r5, #31
        rsb     r2, r2, r3, asr #9
        orr     r2, r7, r2, lsl #11
        lsl     r3, r4, #5
        smull   r0, r1, r8, r3
        add     r1, r1, r3
        asr     r3, r3, #31
        rsb     r3, r3, r1, asr #7
        orr     r2, r2, r3
        mov     r1, r4
        mov     r0, r6
        bl      VGA_draw_point_ASM
        add     r4, r4, #1
        add     r5, r5, #32
        cmp     r4, #240
        bne     .draw_test_screen_L3
        b       .draw_test_screen_L7
.draw_test_screen_L4:
        mov     r2, #72
        mov     r1, #5
        mov     r0, #20
        bl      VGA_write_char_ASM
        mov     r2, #101
        mov     r1, #5
        mov     r0, #21
        bl      VGA_write_char_ASM
        mov     r2, #108
        mov     r1, #5
        mov     r0, #22
        bl      VGA_write_char_ASM
        mov     r2, #108
        mov     r1, #5
        mov     r0, #23
        bl      VGA_write_char_ASM
        mov     r2, #111
        mov     r1, #5
        mov     r0, #24
        bl      VGA_write_char_ASM
        mov     r2, #32
        mov     r1, #5
        mov     r0, #25
        bl      VGA_write_char_ASM
        mov     r2, #87
        mov     r1, #5
        mov     r0, #26
        bl      VGA_write_char_ASM
        mov     r2, #111
        mov     r1, #5
        mov     r0, #27
        bl      VGA_write_char_ASM
        mov     r2, #114
        mov     r1, #5
        mov     r0, #28
        bl      VGA_write_char_ASM
        mov     r2, #108
        mov     r1, #5
        mov     r0, #29
        bl      VGA_write_char_ASM
        mov     r2, #100
        mov     r1, #5
        mov     r0, #30
        bl      VGA_write_char_ASM
        mov     r2, #33
        mov     r1, #5
        mov     r0, #31
        bl      VGA_write_char_ASM
        pop     {r4, r5, r6, r7, r8, r9, r10, pc}
.draw_test_screen_L8:
        .word   1717986919
        .word   -368140053
        .word   -2004318071
