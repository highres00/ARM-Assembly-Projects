

.equ SW_MEMORY, 0xFF200040
.equ LED_MEMORY, 0xFF200000

.equ HEX123, 0xff200020

.equ loadRegister, 0xFFFEC600
.equ counterRegister, 0xFFFEC604
.equ controlRegister, 0xFFFEC608
.equ interruptStatus, 0xFFFEC60C
.equ dataRegister, 0xff200050
.equ buttonsInterruptmask_register, 0xff200058
.equ buttonsEdgecapture_register, 0xff20005c


Initial_value: 	.word 0xBEBC200		
Config_bits:	.word 0x3 			

.global _start
_start:
	PUSH {LR}
	BL ARM_TIM_config_ASM
	POP {LR}
	
	MOV R3, #0 
	
loop:
	BL ARM_TIM_read_INT_ASM
	BL write_LEDs_ASM
	BL HEX_write_ASM
	BL ARM_TIM_clear_INT_ASM
	B loop
	
ARM_TIM_config_ASM:
     PUSH {R6}
	LDR R2, =loadRegister
	LDR R0, Initial_value 
	
	LDR R2, =controlRegister
	BX LR
	
ARM_TIM_read_INT_ASM:
	PUSH {R6}
	LDR R2, =interruptStatus
	LDR R6, [R2]
	TST R6, #1
	
	
ARM_TIM_clear_INT_ASM:
	PUSH {R6}
	LDR R2, =interruptStatus
	LDR R6, [R2]
	
	
write_LEDs_ASM:
    LDR R2, =LED_MEMORY
    STR R1, [R0]
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
	
