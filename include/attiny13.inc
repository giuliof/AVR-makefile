; include file for assembly projects with attiny13
; POINTERS X, Y, Z
.def XL   = R26
.def XH   = R27
.def YL   = R28
.def YH   = R29
.def ZL   = R30
.def ZH   = R31
; I/O REGISTERS
.equ SREG, 	0x3F
.equ SP, 	0x3D
.equ PINB, 	0x16
.equ DDRB, 	0x17
.equ PORTB, 0x18
.equ PCMSK, 0x15		; Interrupt mask for single pins
.equ MCUCR, 0x35		; MCU Control Register: INTERRUPT and SLEEP
.equ GIMSK, 0x3B		; General Interrupt MaSK register
; VALUES of bits
.equ PB0,			0
.equ PB1,           1
.equ PB2,           2
.equ PB3,           3
.equ PB4,           4
.equ PB5,           5
.equ RAMEND, 		0x9F
.equ INT0_ENABLE, 	0b01000000		; Bit 6 of GIMSK
.equ INT0_LOW, 		0b00000000		; Bit 0 and 1 of MCUCR
.equ INT0_CHANGE, 	0b00000001		; Idem
.equ INT0_FALLING, 	0b00000010		; Idem
.equ INT0_RISING, 	0b00000011		; Idem
.equ POWER_DOWN, 	0b00010000		; Bit 3 and 4 of MCUCR
