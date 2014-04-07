   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.13 - 06 Dec 2012
   3                     ; Generator (Limited) V4.3.9 - 06 Dec 2012
  57                     ; 30 void delay_ms(u16 n_ms)
  57                     ; 31 {
  59                     	switch	.text
  60  0000               _delay_ms:
  62  0000 89            	pushw	x
  63       00000000      OFST:	set	0
  66                     ; 33   CLK_PeripheralClockConfig(CLK_Peripheral_TIM4, ENABLE);
  68  0001 ae0201        	ldw	x,#513
  69  0004 cd0000        	call	_CLK_PeripheralClockConfig
  71                     ; 36   TIM4->PSCR = 6;
  73  0007 350652e8      	mov	21224,#6
  74                     ; 39   TIM4->ARR = 250;
  76  000b 35fa52e9      	mov	21225,#250
  77                     ; 42   TIM4->CNTR = 2;
  79  000f 350252e7      	mov	21223,#2
  80                     ; 45   TIM4->SR1 &= ~TIM4_SR1_UIF;
  82  0013 721152e5      	bres	21221,#0
  83                     ; 48   TIM4->CR1 |= TIM4_CR1_CEN;
  85  0017 721052e0      	bset	21216,#0
  87  001b 200b          	jra	L13
  88  001d               L73:
  89                     ; 52     while((TIM4->SR1 & TIM4_SR1_UIF) == 0) ;
  91  001d c652e5        	ld	a,21221
  92  0020 a501          	bcp	a,#1
  93  0022 27f9          	jreq	L73
  94                     ; 53     TIM4->SR1 &= ~TIM4_SR1_UIF;
  96  0024 721152e5      	bres	21221,#0
  97  0028               L13:
  98                     ; 50   while(n_ms--)
 100  0028 1e01          	ldw	x,(OFST+1,sp)
 101  002a 1d0001        	subw	x,#1
 102  002d 1f01          	ldw	(OFST+1,sp),x
 103  002f 1c0001        	addw	x,#1
 104  0032 a30000        	cpw	x,#0
 105  0035 26e6          	jrne	L73
 106                     ; 57   TIM4->CR1 &= ~TIM4_CR1_CEN;
 108  0037 721152e0      	bres	21216,#0
 109                     ; 58 }
 112  003b 85            	popw	x
 113  003c 81            	ret
 148                     ; 66 void delay_10us(u16 n_10us)
 148                     ; 67 {
 149                     	switch	.text
 150  003d               _delay_10us:
 152  003d 89            	pushw	x
 153       00000000      OFST:	set	0
 156                     ; 69   CLK_PeripheralClockConfig(CLK_Peripheral_TIM4, ENABLE);
 158  003e ae0201        	ldw	x,#513
 159  0041 cd0000        	call	_CLK_PeripheralClockConfig
 161                     ; 72   TIM4->PSCR = 0;
 163  0044 725f52e8      	clr	21224
 164                     ; 75   TIM4->ARR = 160;
 166  0048 35a052e9      	mov	21225,#160
 167                     ; 78   TIM4->CNTR = 10;
 169  004c 350a52e7      	mov	21223,#10
 170                     ; 81   TIM4->SR1 &= ~TIM4_SR1_UIF;
 172  0050 721152e5      	bres	21221,#0
 173                     ; 84   TIM4->CR1 |= TIM4_CR1_CEN;
 175  0054 721052e0      	bset	21216,#0
 177  0058 200b          	jra	L36
 178  005a               L17:
 179                     ; 88     while((TIM4->SR1 & TIM4_SR1_UIF) == 0) ;
 181  005a c652e5        	ld	a,21221
 182  005d a501          	bcp	a,#1
 183  005f 27f9          	jreq	L17
 184                     ; 89     TIM4->SR1 &= ~TIM4_SR1_UIF;
 186  0061 721152e5      	bres	21221,#0
 187  0065               L36:
 188                     ; 86   while(n_10us--)
 190  0065 1e01          	ldw	x,(OFST+1,sp)
 191  0067 1d0001        	subw	x,#1
 192  006a 1f01          	ldw	(OFST+1,sp),x
 193  006c 1c0001        	addw	x,#1
 194  006f a30000        	cpw	x,#0
 195  0072 26e6          	jrne	L17
 196                     ; 93   TIM4->CR1 &= ~TIM4_CR1_CEN;
 198  0074 721152e0      	bres	21216,#0
 199                     ; 94  CLK_PeripheralClockConfig(CLK_Peripheral_TIM4, DISABLE);
 201  0078 ae0200        	ldw	x,#512
 202  007b cd0000        	call	_CLK_PeripheralClockConfig
 204                     ; 96 }
 207  007e 85            	popw	x
 208  007f 81            	ret
 247                     ; 98 void delayLFO_ms (u16 n_ms)
 247                     ; 99 {
 248                     	switch	.text
 249  0080               _delayLFO_ms:
 251  0080 89            	pushw	x
 252       00000000      OFST:	set	0
 255                     ; 109 		CLK_SYSCLKDivConfig(CLK_SYSCLKDiv_1);
 257  0081 4f            	clr	a
 258  0082 cd0000        	call	_CLK_SYSCLKDivConfig
 260                     ; 110 		CLK_SYSCLKSourceConfig(CLK_SYSCLKSource_LSI);
 262  0085 a602          	ld	a,#2
 263  0087 cd0000        	call	_CLK_SYSCLKSourceConfig
 265                     ; 111 		CLK_SYSCLKSourceSwitchCmd(ENABLE);
 267  008a a601          	ld	a,#1
 268  008c cd0000        	call	_CLK_SYSCLKSourceSwitchCmd
 271  008f               L511:
 272                     ; 112 		while (((CLK->SWCR)& 0x01)==0x01);
 274  008f c650c9        	ld	a,20681
 275  0092 a401          	and	a,#1
 276  0094 a101          	cp	a,#1
 277  0096 27f7          	jreq	L511
 278                     ; 113 		CLK_HSICmd(DISABLE);
 280  0098 4f            	clr	a
 281  0099 cd0000        	call	_CLK_HSICmd
 283                     ; 114 		CLK->ECKCR &= ~0x01; 
 285  009c 721150c6      	bres	20678,#0
 286                     ; 118 	delay_ms(n_ms);
 288  00a0 1e01          	ldw	x,(OFST+1,sp)
 289  00a2 cd0000        	call	_delay_ms
 291                     ; 130 		CLK_SYSCLKDivConfig(CLK_SYSCLKDiv_2);
 293  00a5 a601          	ld	a,#1
 294  00a7 cd0000        	call	_CLK_SYSCLKDivConfig
 296                     ; 132 		CLK_SYSCLKSourceConfig(CLK_SYSCLKSource_HSE);
 298  00aa a604          	ld	a,#4
 299  00ac cd0000        	call	_CLK_SYSCLKSourceConfig
 302  00af               L321:
 303                     ; 134 		while (((CLK->SWCR)& 0x01)==0x01);
 305  00af c650c9        	ld	a,20681
 306  00b2 a401          	and	a,#1
 307  00b4 a101          	cp	a,#1
 308  00b6 27f7          	jreq	L321
 309                     ; 136 		CLK_SYSCLKSourceSwitchCmd(ENABLE);
 311  00b8 a601          	ld	a,#1
 312  00ba cd0000        	call	_CLK_SYSCLKSourceSwitchCmd
 314                     ; 138 }
 317  00bd 85            	popw	x
 318  00be 81            	ret
 331                     	xdef	_delayLFO_ms
 332                     	xref	_CLK_PeripheralClockConfig
 333                     	xref	_CLK_SYSCLKSourceSwitchCmd
 334                     	xref	_CLK_SYSCLKDivConfig
 335                     	xref	_CLK_SYSCLKSourceConfig
 336                     	xref	_CLK_HSICmd
 337                     	xdef	_delay_10us
 338                     	xdef	_delay_ms
 357                     	end
