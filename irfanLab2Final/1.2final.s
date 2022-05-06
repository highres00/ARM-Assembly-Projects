.equ SW_MEMORY, 0xFF200040
.equ LED_MEMORY, 0xFF200000

.equ HEX123, 0xff200020
.equ HEX45, 0xff200030

.equ dataRegister, 0xff200050
.equ interruptmaskRegister, 0xff200058
.equ edgecaptureRegister, 0xFF20005C
.global _start
_start:
	
	
	loop:
	BL read_slider_switches_ASM
	BL write_LEDs_ASM
	BL HEX_clear_ASM
	BL read_PB_edgecp_ASM
	BL HEX_write_ASM
	BL PB_clear_edgecp_ASM
	B loop
	
	read_PB_edgecp_ASM:
	LDR R0, =edgecaptureRegister
	LDR R2, [R0] 
	BX LR
	
	write_LEDs_ASM:
    LDR R0, =LED_MEMORY
    STR R1, [R0]
    BX  LR
	
	read_slider_switches_ASM:
    LDR R0, =SW_MEMORY
    LDR R1, [R0] // R1 keeps track of ON switches
    BX  LR
	
	HEX_write_ASM:
	CMP R2, #0
	BXEQ LR
	PUSH {R4, LR}
	LDR R0, = 0xff200020
	LDR R4, [R0]
	TST R2, #0x00000001
	POP {R4, LR}
	BX LR
	
	HEX_clear_ASM:
	CMP R1, #0x200
	BXEQ LR
	LDR R0, 0xff200020
    STR R3, [R0]
	BX LR
	
	PB_clear_edgecp_ASM:
	CMP R2, #0
	BXEQ LR
	LDR R0, =edgecaptureRegister
	LDR R2, [R0]
	STR R2, [R0]
	BX LR
	
	

  
	