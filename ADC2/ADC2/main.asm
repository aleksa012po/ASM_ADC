;
; ADC2.asm
;
; Created: 16/06/2022 16:51:15
; Author : Aleksandar Bogdanovic
;


.include "m328pdef.inc"
.org 0x00

init_ADC:
	LDI		R20, 0xFF	
	OUT		DDRD, R20	;postavlja port D kao izlazni za low byte rezultat
	OUT		DDRB, R20	;postavlja port B kao izlazni za low byte rezultat
	SBI		DDRC, 0		;postavlja pin PC0 kao ulazni za ADC0
	;--------------
	LDI		R20, 0xC0	;interni 1.1V, right-justified data, ADC0
	STS		ADMUX, R20
	LDI		R20, 0x87	;aktivira ADC, ADC prescaler CLK/128
	STS		ADCSRA, R20
	;------------
read_ADC:
	LDI		R20, 0xC7	;postavlja ADSC u ADCSRA da zapocne konverziju
	STS		ADCSRA, R20
	;-------------
wait_ADC:
	LDS		R21, ADCSRA	;proverava ADIF flag u ADCSRA
	SBRS	R21, 4		;preskace skok kada je konverzija zavrsena (flag set)
	RJMP	wait_ADC	;ponavlja dok ADIF flag ne bude postavljen
	;-------------
	LDI		R17, 0xD7	;postavlja ADIF flag ponovo
	STS		ADCSRA, R17	;da bi kontroler ocistio ADIF
	;--------------
	LDS		R18, ADCL	;dobija low-byte rezultat od ADCL
	LDS		R19, ADCH	;dobija high-byte rezultat od ADCH
	OUT		PORTD, R18	;salje low-byte na port D
	OUT		PORTB, R19	;salje high-byte na port B
	RJMP	read_ADC