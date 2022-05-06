.global _start
    
_start:
        bl      input_loop
end:
        b       end

@ TODO: copy VGA driver here.

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
@ TODO: insert PS/2 driver here.
read_PS2_data_ASM:
	LDR	R1, =0xFF200100//ps2 register address
	LDRB R2, [R1, #1]//
	LSR R2, R2, #7	//store RVALID bit in registrer R2	
	TST R2,#1//
	CMP R2, #1// check if RVALID bit is 0 or 1
	LDREQB R2, [R1]//load data from ps2 register
	STREQB R2, [R0]//first 8 bits in r0
	MOVEQ R0, #1
	BXEQ LR

	MOVNE R0, #0
	BX LR



write_hex_digit:
        push    {r4, lr}
        cmp     r2, #9
        addhi   r2, r2, #55
        addls   r2, r2, #48
        and     r2, r2, #255
        bl      VGA_write_char_ASM
        pop     {r4, pc}
write_byte:
        push    {r4, r5, r6, lr}
        mov     r5, r0
        mov     r6, r1
        mov     r4, r2
        lsr     r2, r2, #4
        bl      write_hex_digit
        and     r2, r4, #15
        mov     r1, r6
        add     r0, r5, #1
        bl      write_hex_digit
        pop     {r4, r5, r6, pc}
input_loop:
        push    {r4, r5, lr}
        sub     sp, sp, #12
        bl      VGA_clear_pixelbuff_ASM
        bl      VGA_clear_charbuff_ASM
        mov     r4, #0
        mov     r5, r4
        b       .input_loop_L9
.input_loop_L13:
        ldrb    r2, [sp, #7]
        mov     r1, r4
        mov     r0, r5
        bl      write_byte
        add     r5, r5, #3
        cmp     r5, #79
        addgt   r4, r4, #1
        movgt   r5, #0
.input_loop_L8:
        cmp     r4, #59
        bgt     .input_loop_L12
.input_loop_L9:
        add     r0, sp, #7
        bl      read_PS2_data_ASM
        cmp     r0, #0
        beq     .input_loop_L8
        b       .input_loop_L13
.input_loop_L12:
        add     sp, sp, #12
        pop     {r4, r5, pc}
