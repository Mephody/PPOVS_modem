	.def	_c_int00
	.text
_c_int00:

	ld	#sin, DP

	
	rsbx ova
	rsbx ovb
	rsbx ovm
	rsbx c16
	rsbx frct
	rsbx cmpt
	rsbx cpl
	rsbx hm
	rsbx sxm


	stm	#output, AR3

	stm	#sin,	AR2
	ld	#9, b


M:
	stm	#sin,	AR2
	ld	word_to_code,	A
	and	mask,	A
	
	ld	#6, b
	bc	s16,	agt
;-----------------------
;kodiruem 0
	ld	#9, b
s10:
	ld	*AR2, A
	stl	A, *AR3+

	ldm AR2, A
	add	#10, A
	stlm A, AR2

	
	sub #1, B
	bc	s10, bgt
					
	b	end_copy
;------------------------
;kodiruem 1 dvumya periodami	

	
s16:
	ld	*AR2, A
	stl	A, *AR3+
	
	ldm AR2, A
	add	#16, A
	stlm A, AR2
	
	sub #1, B
	bc	s16, bgt

	
	ld	#3, b
	
	ldm AR2, A
	sub	#74, A
	stlm A, AR2
	
	;st #0, *AR3+
;---------perviy
	
s16_2:
	ld	*AR2, A
	stl	A, *AR3+
	
	ldm AR2, A
	add	#16, A
	stlm A, AR2
	
	sub #1, B
	bc	s16_2, bgt
	
	;st #0, *AR3+	
;------vtotoy
;---------------------	

	
;sohranyaem kontecst	
end_copy:
	ld	word_to_code, a
	ror	a
	stl	a, word_to_code
	
	ld	main_counter, b
	sub	#1, b
	stl	b, main_counter
	
	bc	M, bgt
;	rptb M
;-------------------------------	

;-------------------------------	

;---------------------------------------------
	NOP
	NOP
	NOP

;---------------3 laba
	stm	#decod, AR4
	stm	#output, AR3;x(n-2)
	stm	#output, AR2;x(n-1)
	ld *AR2+, A

decoding:
	
	ld	*AR3, B;x(n-2) 
	ld	*AR3+, A;x(n-2)
	sftl A, 1;x(n-2)*2
	sftl B, -2;x(n-2)/4=x(n-2)*0,25
	
	add B, 0, A;x(n-2)*(2+0,25)
	sftl A, -1;A/2

	;sftl A,
	ld *AR2+, B;x(n-1)
	sftl B, -1;x(n-1)/2
	add B, 0, A;x(n-1)/2+(2*0,25)*x(n-2)=y(n)
	
	stl A, *AR4+;sohranyaem v pamyat
	
	ld	dcounter, b;umenshaem schetchik na 1
	sub	#1, b
	stl	b, dcounter
	
	bc	decoding, bgt

	NOP
	NOP;-----------------
	NOP
;------------------------4 laba	
	ssbx	ovm
	ssbx	ova
	ssbx	ovb
	
;------------------------	
	
	stm	#decod, AR2;x(n)
	stm	#decod, AR3;x(n-1)
	stm	#decod, AR4;x(n-2)
	
	stm #detect, AR5;y(n)
	stm #detect, AR6;y(n-1)
	stm	#detect, AR7;y(n-2)
	
	ld	*AR2+, A
	ld	*AR2+, A
	
	ld	*AR3+, A
	
	ld	*AR5+, A
	ld	*AR5+, A
	
	ld	*AR6+, A
	
	
detecting:
	ld A, 0
	mpy *AR2+, #0xa0f, a ;a0*x(n)
	add a, 0, b	
	
	mpy *AR3+, #0xfc7, a ;a1*x(n-1)
	add a, 0, b	
	
	mpy *AR4+, #0xa0f, a ;a2*x(n-2)
	add a, 0, b	
	
	mpy *AR6, #0x4434, a ;b1/2*y(n-1)
	add a, 0, b
	mpy *AR6+, #0x4434, a ;b1/2*y(n-1)
	add a, 0, b	
	
	mpy *AR7+, #0xd3b3, a ;b2*y(n-2)
	add a, 0, b	
	

	sth	b, *AR5+;sohranyaem
	
	ld dcounter2, B
	sub	#1, b
	stl b, dcounter2
	
	bc detecting, bgt
	
	NOP
	NOP
	NOP
	
;-------------------------------
	stm	#detect, AR2;x(n)
	stm	#detect, AR3;x(n-1)
	stm	#detect, AR4;x(n-2)
	
	stm #detect2, AR5;y(n)
	stm #detect2, AR6;y(n-1)
	stm	#detect2, AR7;y(n-2)
	
	ld	*AR2+, A
	ld	*AR2+, A
	
	ld	*AR3+, A
	
	ld	*AR5+, A
	ld	*AR5+, A
	
	ld	*AR6+, A
	
	
detecting2:
	ld A, 0
	mpy *AR2+, #0x216c, a ;a0*x(n)
	add a, 0, b	
	
	mpy *AR3+, #0xd32, a ;a1*x(n-1)
	add a, 0, b	
	
	mpy *AR4+, #0x216c, a ;a2*x(n-2)
	add a, 0, b	
	
	mpy *AR6, #0x45ae, a ;b1/2*y(n-1)
	add a, 0, b
	mpy *AR6+, #0x45ae, a ;b1/2*y(n-1)
	add a, 0, b	
	
	mpy *AR7+, #0xa3ac, a ;b2*y(n-2)
	add a, 0, b	
	

	sth	b, *AR5+
	
	ld dcounter3, B
	sub	#1, b
	stl b, dcounter3
	
	bc detecting2, bgt
;-----------------------------------------------------	
;------------detector	
	
	rsbx ova
	rsbx ovb
	rsbx ovm
	rsbx c16
	rsbx frct
	rsbx cmpt
	rsbx cpl
	rsbx hm
	ssbx sxm
	
	
	
	stm #word_to_decode, AR3
	stm	#detect, AR2
	
	;detect: 0 - 100
	;detect+100: -> 100
	;
	
	
	ldm	AR2, A;A->sohr znacheniya
	ADD dcounter4, A;
	stlm A, AR2
	
todec:
	
	ld	*AR2, A;A -> znach posle filtra
	and #0x8000, A; AND 1000 0000 0000 0000
	
	bc otric, ANEQ
	
	ld	*AR2-, A
	sub #250, A
	bc to_end, ALT
	;dld B, word_to_decode
	dld word_to_decode, B
	add #1, B
	sftl B, 1
	dst B, word_to_decode; dobavim edenicu
	b to_end
	;0000
	;255
	;255-250
	;5
	;0000
	;0000<- 1
	;+1
	;0001
	
	;0001
	;-5167+5000
	;-167
	;0001<- 1
	;0010
	;
	
	
otric:
	ld	*AR2-, A
	add #5000, A
	bc to_end, AGT
	dld word_to_decode, B 
	sftl B, 1
	dst B, word_to_decode;dobavim 0
	
to_end:
	
	
	
	ld dcounter4, b
	sub #1, b
	stl	b, dcounter4

	bc todec, bgt
	
	
	dld word_to_decode, B 
	sftl B, -1
	dst B, word_to_decode
	
	
	
	
	NOP
	NOP
	NOP
		
	.align
	.data
	
sin	.word    0x0000, 0x08EE, 0x11D0, 0x1A9D, 0x2348, 0x2BC7, 0x3410, 0x3C17, 0x43D4, 0x4B3C, 0x5246, 0x58EA, 0x5F1F, 0x64DD, 0x6A1D, 0x6ED9, 0x730B, 0x76AD, 0x79BB, 0x7C32, 0x7E0D, 0x7F4B, 0x7FEB, 0x7FEB, 0x7F4B, 0x7E0D, 0x7C32, 0x79BB, 0x76AD, 0x730B, 0x6ED9, 0x6A1D, 0x64DD, 0x5F1F, 0x58EA, 0x5246, 0x4B3C, 0x43D4, 0x3C17, 0x3410, 0x2BC7, 0x2348, 0x1A9D, 0x11D0, 0x08EE, 0xFFFF, 0xF711, 0xEE2F, 0xE562, 0xDCB7, 0xD438, 0xCBEF, 0xC3E8, 0xBC2B, 0xB4C3, 0xADB9, 0xA715, 0xA0E0, 0x9B22, 0x95E2, 0x9126, 0x8CF4, 0x8952, 0x8644, 0x83CD, 0x81F2, 0x80B4, 0x8014, 0x8014, 0x80B4, 0x81F2, 0x83CD, 0x8644, 0x8952, 0x8CF4, 0x9126, 0x95E2, 0x9B22, 0xA0E0, 0xA715, 0xADB9, 0xB4C3, 0xBC2B, 0xC3E8, 0xCBEF, 0xD438, 0xDCB7, 0xE562, 0xEE2F, 0xF711

mask	.word	0x0001
word_to_code	.word	0xF0F2

main_counter	.word	16

dcounter	.word	146
dcounter2	.word   146
dcounter3	.word   146
dcounter4	.word   146

word_to_decode	.long	0

output	.space	4000

decod	.space	16*300
detect	.space	16*300
detect2	.space	16*300
