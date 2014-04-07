   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.13 - 06 Dec 2012
   3                     ; Generator (Limited) V4.3.9 - 06 Dec 2012
  17                     .dataeeprom:	section	.bss
  18  0000               _Bias_Current:
  19  0000 00            	ds.b	1
  64                     ; 57 void FLASH_ProgramBias(uint8_t Data)
  64                     ; 58 {
  66                     	switch	.text
  67  0000               _FLASH_ProgramBias:
  69  0000 88            	push	a
  70       00000000      OFST:	set	0
  73                     ; 59   FLASH_Unlock(FLASH_MemType_Data);
  75  0001 a6f7          	ld	a,#247
  76  0003 cd0000        	call	_FLASH_Unlock
  78                     ; 60   Bias_Current = Data;
  80  0006 7b01          	ld	a,(OFST+1,sp)
  81  0008 c70000        	ld	_Bias_Current,a
  82                     ; 61   FLASH_WaitForLastOperation(FLASH_MemType_Data);
  84  000b a6f7          	ld	a,#247
  85  000d cd0000        	call	_FLASH_WaitForLastOperation
  87                     ; 62   FLASH_Lock(FLASH_MemType_Data);
  89  0010 a6f7          	ld	a,#247
  90  0012 cd0000        	call	_FLASH_Lock
  92                     ; 63 }	
  95  0015 84            	pop	a
  96  0016 81            	ret
 185                     ; 359 void convert_into_char(uint16_t number, uint16_t *p_tab)
 185                     ; 360 {
 186                     	switch	.text
 187  0017               _convert_into_char:
 189  0017 89            	pushw	x
 190  0018 520a          	subw	sp,#10
 191       0000000a      OFST:	set	10
 194                     ; 361   uint16_t units=0, tens=0, hundreds=0, thousands=0, misc=0;
 204                     ; 363   units = (((number%10000)%1000)%100)%10;
 206  001a 90ae2710      	ldw	y,#10000
 207  001e 65            	divw	x,y
 208  001f 51            	exgw	x,y
 209  0020 90ae03e8      	ldw	y,#1000
 210  0024 65            	divw	x,y
 211  0025 51            	exgw	x,y
 212  0026 a664          	ld	a,#100
 213  0028 62            	div	x,a
 214  0029 5f            	clrw	x
 215  002a 97            	ld	xl,a
 216  002b a60a          	ld	a,#10
 217  002d 62            	div	x,a
 218  002e 5f            	clrw	x
 219  002f 97            	ld	xl,a
 220  0030 1f09          	ldw	(OFST-1,sp),x
 221                     ; 364   tens = ((((number-units)/10)%1000)%100)%10;
 223  0032 1e0b          	ldw	x,(OFST+1,sp)
 224  0034 72f009        	subw	x,(OFST-1,sp)
 225  0037 a60a          	ld	a,#10
 226  0039 62            	div	x,a
 227  003a 90ae03e8      	ldw	y,#1000
 228  003e 65            	divw	x,y
 229  003f 51            	exgw	x,y
 230  0040 a664          	ld	a,#100
 231  0042 62            	div	x,a
 232  0043 5f            	clrw	x
 233  0044 97            	ld	xl,a
 234  0045 a60a          	ld	a,#10
 235  0047 62            	div	x,a
 236  0048 5f            	clrw	x
 237  0049 97            	ld	xl,a
 238  004a 1f07          	ldw	(OFST-3,sp),x
 239                     ; 365   hundreds = (((number-tens-units)/100))%100%10;
 241  004c 1e0b          	ldw	x,(OFST+1,sp)
 242  004e 72f007        	subw	x,(OFST-3,sp)
 243  0051 72f009        	subw	x,(OFST-1,sp)
 244  0054 a664          	ld	a,#100
 245  0056 62            	div	x,a
 246  0057 a664          	ld	a,#100
 247  0059 62            	div	x,a
 248  005a 5f            	clrw	x
 249  005b 97            	ld	xl,a
 250  005c a60a          	ld	a,#10
 251  005e 62            	div	x,a
 252  005f 5f            	clrw	x
 253  0060 97            	ld	xl,a
 254  0061 1f05          	ldw	(OFST-5,sp),x
 255                     ; 366   thousands = ((number-hundreds-tens-units)/1000)%10;
 257  0063 1e0b          	ldw	x,(OFST+1,sp)
 258  0065 72f005        	subw	x,(OFST-5,sp)
 259  0068 72f007        	subw	x,(OFST-3,sp)
 260  006b 72f009        	subw	x,(OFST-1,sp)
 261  006e 90ae03e8      	ldw	y,#1000
 262  0072 65            	divw	x,y
 263  0073 a60a          	ld	a,#10
 264  0075 62            	div	x,a
 265  0076 5f            	clrw	x
 266  0077 97            	ld	xl,a
 267  0078 1f03          	ldw	(OFST-7,sp),x
 268                     ; 367   misc = ((number-thousands-hundreds-tens-units)/10000);
 270  007a 1e0b          	ldw	x,(OFST+1,sp)
 271  007c 72f003        	subw	x,(OFST-7,sp)
 272  007f 72f005        	subw	x,(OFST-5,sp)
 273  0082 72f007        	subw	x,(OFST-3,sp)
 274  0085 72f009        	subw	x,(OFST-1,sp)
 275  0088 90ae2710      	ldw	y,#10000
 276  008c 65            	divw	x,y
 277  008d 1f01          	ldw	(OFST-9,sp),x
 278                     ; 369   *(p_tab+4) = units + 0x30;
 280  008f 1e09          	ldw	x,(OFST-1,sp)
 281  0091 1c0030        	addw	x,#48
 282  0094 160f          	ldw	y,(OFST+5,sp)
 283  0096 90ef08        	ldw	(8,y),x
 284                     ; 370   *(p_tab+3) = tens + 0x30;
 286  0099 1e07          	ldw	x,(OFST-3,sp)
 287  009b 1c0030        	addw	x,#48
 288  009e 160f          	ldw	y,(OFST+5,sp)
 289  00a0 90ef06        	ldw	(6,y),x
 290                     ; 371   *(p_tab+2) = hundreds + 0x30;
 292  00a3 1e05          	ldw	x,(OFST-5,sp)
 293  00a5 1c0030        	addw	x,#48
 294  00a8 160f          	ldw	y,(OFST+5,sp)
 295  00aa 90ef04        	ldw	(4,y),x
 296                     ; 372   *(p_tab+1) = thousands + 0x30;
 298  00ad 1e03          	ldw	x,(OFST-7,sp)
 299  00af 1c0030        	addw	x,#48
 300  00b2 160f          	ldw	y,(OFST+5,sp)
 301  00b4 90ef02        	ldw	(2,y),x
 302                     ; 373   *(p_tab) = misc + 0x30;
 304  00b7 1e01          	ldw	x,(OFST-9,sp)
 305  00b9 1c0030        	addw	x,#48
 306  00bc 160f          	ldw	y,(OFST+5,sp)
 307  00be 90ff          	ldw	(y),x
 308                     ; 375 }
 311  00c0 5b0c          	addw	sp,#12
 312  00c2 81            	ret
 358                     ; 442 void	Display_Ram(void)
 358                     ; 443 #endif
 358                     ; 444 { 
 359                     .DISPLAY:	section	.text
 360  0000               _Display_Ram:
 362  0000 89            	pushw	x
 363       00000002      OFST:	set	2
 366                     ; 445   uint8_t NbCar = 0;
 368  0001 0f02          	clr	(OFST+0,sp)
 369                     ; 446   uint8_t i = 0;
 371  0003 0f01          	clr	(OFST-1,sp)
 372                     ; 455   FLASH->CR1 = 0x08;
 374  0005 35085050      	mov	20560,#8
 376  0009               L321:
 377                     ; 456   while(((CLK->REGCSR)&0x80)==0x80);
 379  0009 c650cf        	ld	a,20687
 380  000c a480          	and	a,#128
 381  000e a180          	cp	a,#128
 382  0010 27f7          	jreq	L321
 383                     ; 469   WFE->CR2 = 0x08;
 385  0012 350850a7      	mov	20647,#8
 386                     ; 470   GPIOC->CR2 = 0x80;
 388  0016 3580500e      	mov	20494,#128
 390  001a 2006          	jra	L331
 391  001c               L721:
 392                     ; 479 	NbCar +=3;
 394  001c 7b02          	ld	a,(OFST+0,sp)
 395  001e ab03          	add	a,#3
 396  0020 6b02          	ld	(OFST+0,sp),a
 397  0022               L331:
 398                     ; 477 	while(NDEFmessage[NbCar++] != 0)
 400  0022 7b02          	ld	a,(OFST+0,sp)
 401  0024 97            	ld	xl,a
 402  0025 0c02          	inc	(OFST+0,sp)
 403  0027 9f            	ld	a,xl
 404  0028 5f            	clrw	x
 405  0029 97            	ld	xl,a
 406  002a 6d00          	tnz	(_NDEFmessage,x)
 407  002c 26ee          	jrne	L721
 408                     ; 480 	LCD_GLASS_ScrollSentenceNbCarLP(NDEFmessage, NbCar);
 410  002e 7b02          	ld	a,(OFST+0,sp)
 411  0030 88            	push	a
 412  0031 ae0000        	ldw	x,#_NDEFmessage
 413  0034 cd0000        	call	_LCD_GLASS_ScrollSentenceNbCarLP
 415  0037 84            	pop	a
 416                     ; 483   wfe();
 419  0038 728f          wfe
 421                     ; 485   EXTI->SR1 |= 0x40;
 424  003a 721c50a3      	bset	20643,#6
 425                     ; 486   WFE->CR2 = 0x00;
 427  003e 725f50a7      	clr	20647
 428                     ; 489   CLK->REGCSR = 0x00;
 430  0042 725f50cf      	clr	20687
 432  0046               L341:
 433                     ; 490   while(((CLK->REGCSR)&0x1) != 0x1);		
 435  0046 c650cf        	ld	a,20687
 436  0049 a401          	and	a,#1
 437  004b a101          	cp	a,#1
 438  004d 26f7          	jrne	L341
 439                     ; 493 }
 442  004f 85            	popw	x
 443  0050 81            	ret
 497                     ; 572 float Vdd_appli(void)
 497                     ; 573 {
 498                     	switch	.text
 499  00c3               _Vdd_appli:
 501  00c3 520c          	subw	sp,#12
 502       0000000c      OFST:	set	12
 505                     ; 578   P_VREFINT_Factory = VREFINT_Factory_CONV_ADDRESS;
 507                     ; 581   MeasurINT = ADC_Supply();	
 509  00c5 cd0000        	call	_ADC_Supply
 511  00c8 1f07          	ldw	(OFST-5,sp),x
 512                     ; 603     f_Vdd_appli = (VREF/MeasurINT) * ADC_CONV;
 514  00ca 1e07          	ldw	x,(OFST-5,sp)
 515  00cc cd0000        	call	c_uitof
 517  00cf 96            	ldw	x,sp
 518  00d0 1c0001        	addw	x,#OFST-11
 519  00d3 cd0000        	call	c_rtol
 521  00d6 ae0004        	ldw	x,#L102
 522  00d9 cd0000        	call	c_ltor
 524  00dc 96            	ldw	x,sp
 525  00dd 1c0001        	addw	x,#OFST-11
 526  00e0 cd0000        	call	c_fdiv
 528  00e3 ae0000        	ldw	x,#L112
 529  00e6 cd0000        	call	c_fmul
 531  00e9 96            	ldw	x,sp
 532  00ea 1c0009        	addw	x,#OFST-3
 533  00ed cd0000        	call	c_rtol
 535                     ; 607   f_Vdd_appli *= 1000L;
 537  00f0 ae03e8        	ldw	x,#1000
 538  00f3 cd0000        	call	c_itof
 540  00f6 96            	ldw	x,sp
 541  00f7 1c0009        	addw	x,#OFST-3
 542  00fa cd0000        	call	c_fgmul
 544                     ; 609   return f_Vdd_appli;
 546  00fd 96            	ldw	x,sp
 547  00fe 1c0009        	addw	x,#OFST-3
 548  0101 cd0000        	call	c_ltor
 552  0104 5b0c          	addw	sp,#12
 553  0106 81            	ret
 600                     ; 618 uint16_t Vref_measure(void)
 600                     ; 619 {
 601                     	switch	.text
 602  0107               _Vref_measure:
 604  0107 520e          	subw	sp,#14
 605       0000000e      OFST:	set	14
 608                     ; 623   Vdd_mV = (uint16_t)Vdd_appli();
 610  0109 adb8          	call	_Vdd_appli
 612  010b cd0000        	call	c_ftoi
 614  010e 1f01          	ldw	(OFST-13,sp),x
 615                     ; 625   convert_into_char (Vdd_mV, tab);
 617  0110 96            	ldw	x,sp
 618  0111 1c0003        	addw	x,#OFST-11
 619  0114 89            	pushw	x
 620  0115 1e03          	ldw	x,(OFST-11,sp)
 621  0117 cd0017        	call	_convert_into_char
 623  011a 85            	popw	x
 624                     ; 628   tab[5] = 'V';
 626  011b ae0056        	ldw	x,#86
 627  011e 1f0d          	ldw	(OFST-1,sp),x
 628                     ; 629   tab[4] = ' ';
 630  0120 ae0020        	ldw	x,#32
 631  0123 1f0b          	ldw	(OFST-3,sp),x
 632                     ; 630   tab[1] |= DOT; /* To add decimal point for display in volt */
 634  0125 7b05          	ld	a,(OFST-9,sp)
 635  0127 aa80          	or	a,#128
 636  0129 6b05          	ld	(OFST-9,sp),a
 637                     ; 631   tab[0] = ' ';
 639  012b ae0020        	ldw	x,#32
 640  012e 1f03          	ldw	(OFST-11,sp),x
 641                     ; 633   LCD_GLASS_DisplayStrDeci(tab);
 643  0130 96            	ldw	x,sp
 644  0131 1c0003        	addw	x,#OFST-11
 645  0134 cd0000        	call	_LCD_GLASS_DisplayStrDeci
 647                     ; 635   return Vdd_mV;
 649  0137 1e01          	ldw	x,(OFST-13,sp)
 652  0139 5b0e          	addw	sp,#14
 653  013b 81            	ret
 677                     	xdef	_Bias_Current
 678                     	xref.b	_NDEFmessage
 679                     	xref	_LCD_GLASS_ScrollSentenceNbCarLP
 680                     	xref	_LCD_GLASS_DisplayStrDeci
 681                     	xdef	_Display_Ram
 682                     	xdef	_Vdd_appli
 683                     	xdef	_FLASH_ProgramBias
 684                     	xdef	_Vref_measure
 685                     	xdef	_convert_into_char
 686                     	xref	_FLASH_WaitForLastOperation
 687                     	xref	_FLASH_Lock
 688                     	xref	_FLASH_Unlock
 689                     	xref	_ADC_Supply
 690                     .const:	section	.text
 691  0000               L112:
 692  0000 45800000      	dc.w	17792,0
 693  0004               L102:
 694  0004 3f9cac08      	dc.w	16284,-21496
 695                     	xref.b	c_x
 715                     	xref	c_ftoi
 716                     	xref	c_fgmul
 717                     	xref	c_itof
 718                     	xref	c_fmul
 719                     	xref	c_fdiv
 720                     	xref	c_rtol
 721                     	xref	c_uitof
 722                     	xref	c_ltor
 723                     	end
