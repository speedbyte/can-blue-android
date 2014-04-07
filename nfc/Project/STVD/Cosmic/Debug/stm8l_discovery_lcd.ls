   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.19 - 04 Sep 2013
   3                     ; Generator (Limited) V4.3.11 - 04 Sep 2013
  17                     	bsct
  18  0000               _KeyPressed:
  19  0000 00            	dc.b	0
  20  0001               _t_bar:
  21  0001 00            	dc.b	0
  22  0002 00            	dc.b	0
  23                     .const:	section	.text
  24  0000               _CapLetterMap:
  25  0000 fe00          	dc.w	-512
  26  0002 6711          	dc.w	26385
  27  0004 1d00          	dc.w	7424
  28  0006 4711          	dc.w	18193
  29  0008 9d00          	dc.w	-25344
  30  000a 9c00          	dc.w	-25600
  31  000c 3f00          	dc.w	16128
  32  000e fa00          	dc.w	-1536
  33  0010 0011          	dc.w	17
  34  0012 5300          	dc.w	21248
  35  0014 9844          	dc.w	-26556
  36  0016 1900          	dc.w	6400
  37  0018 5a42          	dc.w	23106
  38  001a 5a06          	dc.w	23046
  39  001c 5f00          	dc.w	24320
  40  001e fc00          	dc.w	-1024
  41  0020 5f04          	dc.w	24324
  42  0022 fc04          	dc.w	-1020
  43  0024 af00          	dc.w	-20736
  44  0026 0411          	dc.w	1041
  45  0028 5b00          	dc.w	23296
  46  002a 18c0          	dc.w	6336
  47  002c 5a84          	dc.w	23172
  48  002e 00c6          	dc.w	198
  49  0030 0052          	dc.w	82
  50  0032 05c0          	dc.w	1472
  51  0034               _NumberMap:
  52  0034 5f00          	dc.w	24320
  53  0036 4200          	dc.w	16896
  54  0038 f500          	dc.w	-2816
  55  003a 6700          	dc.w	26368
  56  003c ea00          	dc.w	-5632
  57  003e af00          	dc.w	-20736
  58  0040 bf00          	dc.w	-16640
  59  0042 4600          	dc.w	17920
  60  0044 ff00          	dc.w	-256
  61  0046 ef00          	dc.w	-4352
  99                     ; 91 void LCD_GLASS_Init(void)
  99                     ; 92 {
 101                     	switch	.text
 102  0000               _LCD_GLASS_Init:
 106                     ; 95   CLK_PeripheralClockConfig(CLK_Peripheral_RTC, ENABLE);
 108  0000 ae1201        	ldw	x,#4609
 109  0003 cd0000        	call	_CLK_PeripheralClockConfig
 111                     ; 96   CLK_PeripheralClockConfig(CLK_Peripheral_LCD, ENABLE);
 113  0006 ae1301        	ldw	x,#4865
 114  0009 cd0000        	call	_CLK_PeripheralClockConfig
 116                     ; 101     CLK_RTCClockConfig(CLK_RTCCLKSource_LSI, CLK_RTCCLKDiv_1);
 118  000c ae0400        	ldw	x,#1024
 119  000f cd0000        	call	_CLK_RTCClockConfig
 121                     ; 105   LCD_Init(LCD_Prescaler_2, LCD_Divider_31, LCD_Duty_1_4, 
 121                     ; 106                                    LCD_Bias_1_3, LCD_VoltageSource_Internal);
 123  0012 4b00          	push	#0
 124  0014 4b00          	push	#0
 125  0016 4b06          	push	#6
 126  0018 ae100f        	ldw	x,#4111
 127  001b cd0000        	call	_LCD_Init
 129  001e 5b03          	addw	sp,#3
 130                     ; 111   LCD_PortMaskConfig(LCD_PortMaskRegister_0, 0xFF);
 132  0020 ae00ff        	ldw	x,#255
 133  0023 cd0000        	call	_LCD_PortMaskConfig
 135                     ; 112   LCD_PortMaskConfig(LCD_PortMaskRegister_1, 0xFF);
 137  0026 ae01ff        	ldw	x,#511
 138  0029 cd0000        	call	_LCD_PortMaskConfig
 140                     ; 113   LCD_PortMaskConfig(LCD_PortMaskRegister_2, 0xff);
 142  002c ae02ff        	ldw	x,#767
 143  002f cd0000        	call	_LCD_PortMaskConfig
 145                     ; 116   LCD_ContrastConfig(LCD_Contrast_3V0);
 147  0032 a608          	ld	a,#8
 148  0034 cd0000        	call	_LCD_ContrastConfig
 150                     ; 118   LCD_DeadTimeConfig(LCD_DeadTime_0);
 152  0037 4f            	clr	a
 153  0038 cd0000        	call	_LCD_DeadTimeConfig
 155                     ; 119   LCD_PulseOnDurationConfig(LCD_PulseOnDuration_1);
 157  003b a620          	ld	a,#32
 158  003d cd0000        	call	_LCD_PulseOnDurationConfig
 160                     ; 122   LCD_Cmd(ENABLE);
 162  0040 a601          	ld	a,#1
 163  0042 cd0000        	call	_LCD_Cmd
 165                     ; 123 }
 168  0045 81            	ret
 267                     ; 130 void LCD_contrast()
 267                     ; 131 {
 268                     	switch	.text
 269  0046               _LCD_contrast:
 271  0046 88            	push	a
 272       00000001      OFST:	set	1
 275                     ; 135   contrast = (LCD_Contrast_TypeDef) (LCD->CR2 & LCD_Contrast_3V3);
 277  0047 c65401        	ld	a,21505
 278  004a a40e          	and	a,#14
 279  004c 6b01          	ld	(OFST+0,sp),a
 281  004e 2017          	jra	L17
 282  0050               L56:
 283                     ; 139     contrast+=2;	
 285  0050 0c01          	inc	(OFST+0,sp)
 286  0052 0c01          	inc	(OFST+0,sp)
 287                     ; 140     if (contrast>LCD_Contrast_3V3)
 289  0054 7b01          	ld	a,(OFST+0,sp)
 290  0056 a10f          	cp	a,#15
 291  0058 2502          	jrult	L57
 292                     ; 141      contrast=LCD_Contrast_2V6;
 294  005a 0f01          	clr	(OFST+0,sp)
 295  005c               L57:
 296                     ; 143     LCD_ContrastConfig(contrast);
 298  005c 7b01          	ld	a,(OFST+0,sp)
 299  005e cd0000        	call	_LCD_ContrastConfig
 301                     ; 144     delay_ms(100);
 303  0061 ae0064        	ldw	x,#100
 304  0064 cd0000        	call	_delay_ms
 306  0067               L17:
 307                     ; 137   while ((GPIOC->IDR & USER_GPIO_PIN) == 0x0)
 309  0067 c6500b        	ld	a,20491
 310  006a a580          	bcp	a,#128
 311  006c 27e2          	jreq	L56
 312                     ; 146 }
 315  006e 84            	pop	a
 316  006f 81            	ret
 340                     ; 153 void LCD_bar()
 340                     ; 154 {
 341                     	switch	.text
 342  0070               _LCD_bar:
 346                     ; 156   LCD->RAM[LCD_RAMRegister_11] &= 0x5f;
 348  0070 c65417        	ld	a,21527
 349  0073 a45f          	and	a,#95
 350  0075 c75417        	ld	21527,a
 351                     ; 157   LCD->RAM[LCD_RAMRegister_11] |= t_bar[0]&0xa0;
 353  0078 b601          	ld	a,_t_bar
 354  007a a4a0          	and	a,#160
 355  007c ca5417        	or	a,21527
 356  007f c75417        	ld	21527,a
 357                     ; 160   LCD->RAM[LCD_RAMRegister_8] &= 0xf5;
 359  0082 c65414        	ld	a,21524
 360  0085 a4f5          	and	a,#245
 361  0087 c75414        	ld	21524,a
 362                     ; 161   LCD->RAM[LCD_RAMRegister_8] |= t_bar[1]&0x0a;
 364  008a b602          	ld	a,_t_bar+1
 365  008c a40a          	and	a,#10
 366  008e ca5414        	or	a,21524
 367  0091 c75414        	ld	21524,a
 368                     ; 162 }
 371  0094 81            	ret
 485                     	switch	.const
 486  0048               L61:
 487  0048 00e1          	dc.w	L121
 488  004a 00f8          	dc.w	L521
 489  004c 00f8          	dc.w	L521
 490  004e 00e8          	dc.w	L321
 491  0050 00e8          	dc.w	L321
 492  0052 00e8          	dc.w	L321
 493  0054 00e8          	dc.w	L321
 494  0056 00e8          	dc.w	L321
 495  0058 00e8          	dc.w	L321
 496  005a 00e8          	dc.w	L321
 497  005c 00e8          	dc.w	L321
 498  005e 00e8          	dc.w	L321
 499  0060 00e8          	dc.w	L321
 500                     ; 175 static void LCD_Conv_Char_Seg(uint8_t* c,bool point,bool column, uint8_t* digit)
 500                     ; 176 {
 501                     	switch	.text
 502  0095               L3_LCD_Conv_Char_Seg:
 504  0095 89            	pushw	x
 505  0096 5204          	subw	sp,#4
 506       00000004      OFST:	set	4
 509                     ; 177   uint16_t ch = 0 ;
 511  0098 5f            	clrw	x
 512  0099 1f03          	ldw	(OFST-1,sp),x
 513                     ; 180   switch (*c)
 515  009b 1e05          	ldw	x,(OFST+1,sp)
 516  009d f6            	ld	a,(x)
 518                     ; 230       break;
 519  009e a02d          	sub	a,#45
 520  00a0 a10d          	cp	a,#13
 521  00a2 2407          	jruge	L41
 522  00a4 5f            	clrw	x
 523  00a5 97            	ld	xl,a
 524  00a6 58            	sllw	x
 525  00a7 de0048        	ldw	x,(L61,x)
 526  00aa fc            	jp	(x)
 527  00ab               L41:
 528  00ab a0f3          	sub	a,#-13
 529  00ad 2711          	jreq	L701
 530  00af a00a          	sub	a,#10
 531  00b1 2712          	jreq	L111
 532  00b3 a043          	sub	a,#67
 533  00b5 271c          	jreq	L511
 534  00b7 4a            	dec	a
 535  00b8 2720          	jreq	L711
 536  00ba a047          	sub	a,#71
 537  00bc 270e          	jreq	L311
 538  00be 2038          	jra	L521
 539  00c0               L701:
 540                     ; 182     case ' ' : 
 540                     ; 183       ch = 0x00;
 542  00c0 5f            	clrw	x
 543  00c1 1f03          	ldw	(OFST-1,sp),x
 544                     ; 184       break;
 546  00c3 206b          	jra	L702
 547  00c5               L111:
 548                     ; 186     case '*':
 548                     ; 187       ch = star;
 550  00c5 aea0d7        	ldw	x,#41175
 551  00c8 1f03          	ldw	(OFST-1,sp),x
 552                     ; 188       break;
 554  00ca 2064          	jra	L702
 555  00cc               L311:
 556                     ; 190     case 'µ' :
 556                     ; 191       ch = C_UMAP;
 558  00cc ae6081        	ldw	x,#24705
 559  00cf 1f03          	ldw	(OFST-1,sp),x
 560                     ; 192       break;
 562  00d1 205d          	jra	L702
 563  00d3               L511:
 564                     ; 194     case 'm' :
 564                     ; 195       ch = C_mMap;
 566  00d3 aeb210        	ldw	x,#45584
 567  00d6 1f03          	ldw	(OFST-1,sp),x
 568                     ; 196       break;
 570  00d8 2056          	jra	L702
 571  00da               L711:
 572                     ; 198     case 'n' :
 572                     ; 199       ch = C_nMap;
 574  00da ae2210        	ldw	x,#8720
 575  00dd 1f03          	ldw	(OFST-1,sp),x
 576                     ; 200       break;					
 578  00df 204f          	jra	L702
 579  00e1               L121:
 580                     ; 202     case '-' :
 580                     ; 203       ch = C_minus;
 582  00e1 aea000        	ldw	x,#40960
 583  00e4 1f03          	ldw	(OFST-1,sp),x
 584                     ; 204       break;
 586  00e6 2048          	jra	L702
 587  00e8               L321:
 588                     ; 206     case '0':
 588                     ; 207     case '1':
 588                     ; 208     case '2':
 588                     ; 209     case '3':
 588                     ; 210     case '4':
 588                     ; 211     case '5':
 588                     ; 212     case '6':
 588                     ; 213     case '7':
 588                     ; 214     case '8':
 588                     ; 215     case '9':			
 588                     ; 216       ch = NumberMap[*c-0x30];		
 590  00e8 1e05          	ldw	x,(OFST+1,sp)
 591  00ea f6            	ld	a,(x)
 592  00eb 5f            	clrw	x
 593  00ec 97            	ld	xl,a
 594  00ed 58            	sllw	x
 595  00ee 1d0060        	subw	x,#96
 596  00f1 de0034        	ldw	x,(_NumberMap,x)
 597  00f4 1f03          	ldw	(OFST-1,sp),x
 598                     ; 217       break;
 600  00f6 2038          	jra	L702
 601  00f8               L521:
 602                     ; 219     default:
 602                     ; 220       /* The character c is one letter in upper case*/
 602                     ; 221       if ( (*c < 0x5b) && (*c > 0x40) )
 604  00f8 1e05          	ldw	x,(OFST+1,sp)
 605  00fa f6            	ld	a,(x)
 606  00fb a15b          	cp	a,#91
 607  00fd 2415          	jruge	L112
 609  00ff 1e05          	ldw	x,(OFST+1,sp)
 610  0101 f6            	ld	a,(x)
 611  0102 a141          	cp	a,#65
 612  0104 250e          	jrult	L112
 613                     ; 223         ch = CapLetterMap[*c-'A'];
 615  0106 1e05          	ldw	x,(OFST+1,sp)
 616  0108 f6            	ld	a,(x)
 617  0109 5f            	clrw	x
 618  010a 97            	ld	xl,a
 619  010b 58            	sllw	x
 620  010c 1d0082        	subw	x,#130
 621  010f de0000        	ldw	x,(_CapLetterMap,x)
 622  0112 1f03          	ldw	(OFST-1,sp),x
 623  0114               L112:
 624                     ; 226       if ( (*c <0x7b) && ( *c> 0x60) )
 626  0114 1e05          	ldw	x,(OFST+1,sp)
 627  0116 f6            	ld	a,(x)
 628  0117 a17b          	cp	a,#123
 629  0119 2415          	jruge	L702
 631  011b 1e05          	ldw	x,(OFST+1,sp)
 632  011d f6            	ld	a,(x)
 633  011e a161          	cp	a,#97
 634  0120 250e          	jrult	L702
 635                     ; 228         ch = CapLetterMap[*c-'a'];
 637  0122 1e05          	ldw	x,(OFST+1,sp)
 638  0124 f6            	ld	a,(x)
 639  0125 5f            	clrw	x
 640  0126 97            	ld	xl,a
 641  0127 58            	sllw	x
 642  0128 1d00c2        	subw	x,#194
 643  012b de0000        	ldw	x,(_CapLetterMap,x)
 644  012e 1f03          	ldw	(OFST-1,sp),x
 645  0130               L702:
 646                     ; 234   if (point)
 648  0130 0d09          	tnz	(OFST+5,sp)
 649  0132 2706          	jreq	L512
 650                     ; 236     ch |= 0x0008;
 652  0134 7b04          	ld	a,(OFST+0,sp)
 653  0136 aa08          	or	a,#8
 654  0138 6b04          	ld	(OFST+0,sp),a
 655  013a               L512:
 656                     ; 240   if (column)
 658  013a 0d0a          	tnz	(OFST+6,sp)
 659  013c 2706          	jreq	L712
 660                     ; 242     ch |= 0x0020;
 662  013e 7b04          	ld	a,(OFST+0,sp)
 663  0140 aa20          	or	a,#32
 664  0142 6b04          	ld	(OFST+0,sp),a
 665  0144               L712:
 666                     ; 245   for (i = 12,j=0 ;j<4; i-=4,j++)
 668  0144 a60c          	ld	a,#12
 669  0146 6b01          	ld	(OFST-3,sp),a
 670  0148 0f02          	clr	(OFST-2,sp)
 671  014a               L122:
 672                     ; 247     digit[j] = (ch >> i) & 0x0f; //To isolate the less signifiant dibit
 674  014a 7b0b          	ld	a,(OFST+7,sp)
 675  014c 97            	ld	xl,a
 676  014d 7b0c          	ld	a,(OFST+8,sp)
 677  014f 1b02          	add	a,(OFST-2,sp)
 678  0151 2401          	jrnc	L02
 679  0153 5c            	incw	x
 680  0154               L02:
 681  0154 02            	rlwa	x,a
 682  0155 89            	pushw	x
 683  0156 1e05          	ldw	x,(OFST+1,sp)
 684  0158 7b03          	ld	a,(OFST-1,sp)
 685  015a 4d            	tnz	a
 686  015b 2704          	jreq	L22
 687  015d               L42:
 688  015d 54            	srlw	x
 689  015e 4a            	dec	a
 690  015f 26fc          	jrne	L42
 691  0161               L22:
 692  0161 01            	rrwa	x,a
 693  0162 a40f          	and	a,#15
 694  0164 5f            	clrw	x
 695  0165 85            	popw	x
 696  0166 f7            	ld	(x),a
 697                     ; 245   for (i = 12,j=0 ;j<4; i-=4,j++)
 699  0167 7b01          	ld	a,(OFST-3,sp)
 700  0169 a004          	sub	a,#4
 701  016b 6b01          	ld	(OFST-3,sp),a
 702  016d 0c02          	inc	(OFST-2,sp)
 705  016f 7b02          	ld	a,(OFST-2,sp)
 706  0171 a104          	cp	a,#4
 707  0173 25d5          	jrult	L122
 708                     ; 249 }
 711  0175 5b06          	addw	sp,#6
 712  0177 81            	ret
 789                     ; 264 void LCD_GLASS_WriteChar(uint8_t* ch, bool point, bool column, uint8_t position)
 789                     ; 265 {
 790                     	switch	.text
 791  0178               _LCD_GLASS_WriteChar:
 793  0178 89            	pushw	x
 794  0179 5204          	subw	sp,#4
 795       00000004      OFST:	set	4
 798                     ; 269   LCD_Conv_Char_Seg(ch,point,column,digit);
 800  017b 96            	ldw	x,sp
 801  017c 1c0001        	addw	x,#OFST-3
 802  017f 89            	pushw	x
 803  0180 7b0c          	ld	a,(OFST+8,sp)
 804  0182 88            	push	a
 805  0183 7b0c          	ld	a,(OFST+8,sp)
 806  0185 88            	push	a
 807  0186 1e09          	ldw	x,(OFST+5,sp)
 808  0188 cd0095        	call	L3_LCD_Conv_Char_Seg
 810  018b 5b04          	addw	sp,#4
 811                     ; 271   switch (position)
 813  018d 7b0b          	ld	a,(OFST+7,sp)
 815                     ; 438       default:
 815                     ; 439               break;
 816  018f 4a            	dec	a
 817  0190 2722          	jreq	L722
 818  0192 4a            	dec	a
 819  0193 2603          	jrne	L03
 820  0195 cc025b        	jp	L132
 821  0198               L03:
 822  0198 4a            	dec	a
 823  0199 2603          	jrne	L23
 824  019b cc0303        	jp	L332
 825  019e               L23:
 826  019e 4a            	dec	a
 827  019f 2603          	jrne	L43
 828  01a1 cc03ad        	jp	L532
 829  01a4               L43:
 830  01a4 4a            	dec	a
 831  01a5 2603          	jrne	L63
 832  01a7 cc0458        	jp	L732
 833  01aa               L63:
 834  01aa 4a            	dec	a
 835  01ab 2603          	jrne	L04
 836  01ad cc04f7        	jp	L142
 837  01b0               L04:
 838  01b0 ac930593      	jpf	L503
 839  01b4               L722:
 840                     ; 274     case 1:
 840                     ; 275       LCD->RAM[LCD_RAMRegister_0] &= 0x0fc;
 842  01b4 c6540c        	ld	a,21516
 843  01b7 a4fc          	and	a,#252
 844  01b9 c7540c        	ld	21516,a
 845                     ; 276       LCD->RAM[LCD_RAMRegister_0] |= (uint8_t)(digit[0]& 0x03); // 1M 1E	
 847  01bc 7b01          	ld	a,(OFST-3,sp)
 848  01be a403          	and	a,#3
 849  01c0 ca540c        	or	a,21516
 850  01c3 c7540c        	ld	21516,a
 851                     ; 278       LCD->RAM[LCD_RAMRegister_2] &= 0x3f;
 853  01c6 c6540e        	ld	a,21518
 854  01c9 a43f          	and	a,#63
 855  01cb c7540e        	ld	21518,a
 856                     ; 279       LCD->RAM[LCD_RAMRegister_2] |= (uint8_t)((digit[0]<<4) & 0xc0); // 1G 1B
 858  01ce 7b01          	ld	a,(OFST-3,sp)
 859  01d0 97            	ld	xl,a
 860  01d1 a610          	ld	a,#16
 861  01d3 42            	mul	x,a
 862  01d4 9f            	ld	a,xl
 863  01d5 a4c0          	and	a,#192
 864  01d7 ca540e        	or	a,21518
 865  01da c7540e        	ld	21518,a
 866                     ; 281       LCD->RAM[LCD_RAMRegister_3] &= 0x0cf;
 868  01dd c6540f        	ld	a,21519
 869  01e0 a4cf          	and	a,#207
 870  01e2 c7540f        	ld	21519,a
 871                     ; 282       LCD->RAM[LCD_RAMRegister_3] |= (uint8_t)(digit[1]<<4 & 0x30); // 1C 1D
 873  01e5 7b02          	ld	a,(OFST-2,sp)
 874  01e7 97            	ld	xl,a
 875  01e8 a610          	ld	a,#16
 876  01ea 42            	mul	x,a
 877  01eb 9f            	ld	a,xl
 878  01ec a430          	and	a,#48
 879  01ee ca540f        	or	a,21519
 880  01f1 c7540f        	ld	21519,a
 881                     ; 284       LCD->RAM[LCD_RAMRegister_6] &= 0xf3;
 883  01f4 c65412        	ld	a,21522
 884  01f7 a4f3          	and	a,#243
 885  01f9 c75412        	ld	21522,a
 886                     ; 285       LCD->RAM[LCD_RAMRegister_6] |= (uint8_t)(digit[1]&0x0c); // 1F 1A
 888  01fc 7b02          	ld	a,(OFST-2,sp)
 889  01fe a40c          	and	a,#12
 890  0200 ca5412        	or	a,21522
 891  0203 c75412        	ld	21522,a
 892                     ; 287       LCD->RAM[LCD_RAMRegister_7] &= 0x0fc;
 894  0206 c65413        	ld	a,21523
 895  0209 a4fc          	and	a,#252
 896  020b c75413        	ld	21523,a
 897                     ; 288       LCD->RAM[LCD_RAMRegister_7] |= (uint8_t)(digit[2]&0x03); // 1Col 1P		
 899  020e 7b03          	ld	a,(OFST-1,sp)
 900  0210 a403          	and	a,#3
 901  0212 ca5413        	or	a,21523
 902  0215 c75413        	ld	21523,a
 903                     ; 290       LCD->RAM[LCD_RAMRegister_9] &= 0x3f;
 905  0218 c65415        	ld	a,21525
 906  021b a43f          	and	a,#63
 907  021d c75415        	ld	21525,a
 908                     ; 291       LCD->RAM[LCD_RAMRegister_9] |= (uint8_t)((digit[2]<<4) & 0xc0); // 1Q 1K										
 910  0220 7b03          	ld	a,(OFST-1,sp)
 911  0222 97            	ld	xl,a
 912  0223 a610          	ld	a,#16
 913  0225 42            	mul	x,a
 914  0226 9f            	ld	a,xl
 915  0227 a4c0          	and	a,#192
 916  0229 ca5415        	or	a,21525
 917  022c c75415        	ld	21525,a
 918                     ; 293       LCD->RAM[LCD_RAMRegister_10] &= 0xcf;
 920  022f c65416        	ld	a,21526
 921  0232 a4cf          	and	a,#207
 922  0234 c75416        	ld	21526,a
 923                     ; 294       LCD->RAM[LCD_RAMRegister_10] |= (uint8_t)((digit[3]<<2)& 0x30); // 1DP 1N	
 925  0237 7b04          	ld	a,(OFST+0,sp)
 926  0239 48            	sll	a
 927  023a 48            	sll	a
 928  023b a430          	and	a,#48
 929  023d ca5416        	or	a,21526
 930  0240 c75416        	ld	21526,a
 931                     ; 296       LCD->RAM[LCD_RAMRegister_13] &= 0xf3;
 933  0243 c65419        	ld	a,21529
 934  0246 a4f3          	and	a,#243
 935  0248 c75419        	ld	21529,a
 936                     ; 297       LCD->RAM[LCD_RAMRegister_13] |= (uint8_t)((digit[3]<<2) & 0x0c); // 1H 1J
 938  024b 7b04          	ld	a,(OFST+0,sp)
 939  024d 48            	sll	a
 940  024e 48            	sll	a
 941  024f a40c          	and	a,#12
 942  0251 ca5419        	or	a,21529
 943  0254 c75419        	ld	21529,a
 944                     ; 298       break;
 946  0257 ac930593      	jpf	L503
 947  025b               L132:
 948                     ; 301     case 2:
 948                     ; 302       LCD->RAM[LCD_RAMRegister_0] &= 0x0f3;
 950  025b c6540c        	ld	a,21516
 951  025e a4f3          	and	a,#243
 952  0260 c7540c        	ld	21516,a
 953                     ; 303       LCD->RAM[LCD_RAMRegister_0] |= (uint8_t)((digit[0]<<2)&0x0c); // 2M 2E	
 955  0263 7b01          	ld	a,(OFST-3,sp)
 956  0265 48            	sll	a
 957  0266 48            	sll	a
 958  0267 a40c          	and	a,#12
 959  0269 ca540c        	or	a,21516
 960  026c c7540c        	ld	21516,a
 961                     ; 305       LCD->RAM[LCD_RAMRegister_2] &= 0xcf;
 963  026f c6540e        	ld	a,21518
 964  0272 a4cf          	and	a,#207
 965  0274 c7540e        	ld	21518,a
 966                     ; 306       LCD->RAM[LCD_RAMRegister_2] |= (uint8_t)((digit[0]<<2)&0x30); // 2G 2B
 968  0277 7b01          	ld	a,(OFST-3,sp)
 969  0279 48            	sll	a
 970  027a 48            	sll	a
 971  027b a430          	and	a,#48
 972  027d ca540e        	or	a,21518
 973  0280 c7540e        	ld	21518,a
 974                     ; 308       LCD->RAM[LCD_RAMRegister_3] &= 0x3f;
 976  0283 c6540f        	ld	a,21519
 977  0286 a43f          	and	a,#63
 978  0288 c7540f        	ld	21519,a
 979                     ; 309       LCD->RAM[LCD_RAMRegister_3] |= (uint8_t)((digit[1]<<6) & 0xc0); // 2C 2D
 981  028b 7b02          	ld	a,(OFST-2,sp)
 982  028d 97            	ld	xl,a
 983  028e a640          	ld	a,#64
 984  0290 42            	mul	x,a
 985  0291 9f            	ld	a,xl
 986  0292 a4c0          	and	a,#192
 987  0294 ca540f        	or	a,21519
 988  0297 c7540f        	ld	21519,a
 989                     ; 311       LCD->RAM[LCD_RAMRegister_6] &= 0xfc;
 991  029a c65412        	ld	a,21522
 992  029d a4fc          	and	a,#252
 993  029f c75412        	ld	21522,a
 994                     ; 312       LCD->RAM[LCD_RAMRegister_6] |= (uint8_t)((digit[1]>>2)&0x03); // 2F 2A
 996  02a2 7b02          	ld	a,(OFST-2,sp)
 997  02a4 44            	srl	a
 998  02a5 44            	srl	a
 999  02a6 a403          	and	a,#3
1000  02a8 ca5412        	or	a,21522
1001  02ab c75412        	ld	21522,a
1002                     ; 314       LCD->RAM[LCD_RAMRegister_7] &= 0xf3;
1004  02ae c65413        	ld	a,21523
1005  02b1 a4f3          	and	a,#243
1006  02b3 c75413        	ld	21523,a
1007                     ; 315       LCD->RAM[LCD_RAMRegister_7] |= (uint8_t)((digit[2]<<2)& 0x0c); // 2Col 2P		
1009  02b6 7b03          	ld	a,(OFST-1,sp)
1010  02b8 48            	sll	a
1011  02b9 48            	sll	a
1012  02ba a40c          	and	a,#12
1013  02bc ca5413        	or	a,21523
1014  02bf c75413        	ld	21523,a
1015                     ; 317       LCD->RAM[LCD_RAMRegister_9] &= 0xcf;
1017  02c2 c65415        	ld	a,21525
1018  02c5 a4cf          	and	a,#207
1019  02c7 c75415        	ld	21525,a
1020                     ; 318       LCD->RAM[LCD_RAMRegister_9] |= (uint8_t)((digit[2]<<2)&0x30); // 2Q 2K										
1022  02ca 7b03          	ld	a,(OFST-1,sp)
1023  02cc 48            	sll	a
1024  02cd 48            	sll	a
1025  02ce a430          	and	a,#48
1026  02d0 ca5415        	or	a,21525
1027  02d3 c75415        	ld	21525,a
1028                     ; 320       LCD->RAM[LCD_RAMRegister_10] &= 0x3f;
1030  02d6 c65416        	ld	a,21526
1031  02d9 a43f          	and	a,#63
1032  02db c75416        	ld	21526,a
1033                     ; 321       LCD->RAM[LCD_RAMRegister_10] |= (uint8_t)((digit[3]<<4)& 0xC0); // 2DP 2N	
1035  02de 7b04          	ld	a,(OFST+0,sp)
1036  02e0 97            	ld	xl,a
1037  02e1 a610          	ld	a,#16
1038  02e3 42            	mul	x,a
1039  02e4 9f            	ld	a,xl
1040  02e5 a4c0          	and	a,#192
1041  02e7 ca5416        	or	a,21526
1042  02ea c75416        	ld	21526,a
1043                     ; 323       LCD->RAM[LCD_RAMRegister_13] &= 0xfc;
1045  02ed c65419        	ld	a,21529
1046  02f0 a4fc          	and	a,#252
1047  02f2 c75419        	ld	21529,a
1048                     ; 324       LCD->RAM[LCD_RAMRegister_13] |= (uint8_t)((digit[3])& 0x03); // 2H 2J
1050  02f5 7b04          	ld	a,(OFST+0,sp)
1051  02f7 a403          	and	a,#3
1052  02f9 ca5419        	or	a,21529
1053  02fc c75419        	ld	21529,a
1054                     ; 325       break;
1056  02ff ac930593      	jpf	L503
1057  0303               L332:
1058                     ; 328     case 3:
1058                     ; 329       LCD->RAM[LCD_RAMRegister_0] &= 0xcf;
1060  0303 c6540c        	ld	a,21516
1061  0306 a4cf          	and	a,#207
1062  0308 c7540c        	ld	21516,a
1063                     ; 330       LCD->RAM[LCD_RAMRegister_0] |= (uint8_t)(digit[0]<<4) & 0x30; // 3M 3E	
1065  030b 7b01          	ld	a,(OFST-3,sp)
1066  030d 97            	ld	xl,a
1067  030e a610          	ld	a,#16
1068  0310 42            	mul	x,a
1069  0311 9f            	ld	a,xl
1070  0312 a430          	and	a,#48
1071  0314 ca540c        	or	a,21516
1072  0317 c7540c        	ld	21516,a
1073                     ; 332       LCD->RAM[LCD_RAMRegister_2] &= 0xf3;
1075  031a c6540e        	ld	a,21518
1076  031d a4f3          	and	a,#243
1077  031f c7540e        	ld	21518,a
1078                     ; 333       LCD->RAM[LCD_RAMRegister_2] |= (uint8_t)(digit[0]) & 0x0c; // 3G 3B
1080  0322 7b01          	ld	a,(OFST-3,sp)
1081  0324 a40c          	and	a,#12
1082  0326 ca540e        	or	a,21518
1083  0329 c7540e        	ld	21518,a
1084                     ; 335       LCD->RAM[LCD_RAMRegister_4] &= 0xfc;
1086  032c c65410        	ld	a,21520
1087  032f a4fc          	and	a,#252
1088  0331 c75410        	ld	21520,a
1089                     ; 336       LCD->RAM[LCD_RAMRegister_4] |= (uint8_t)(digit[1]) & 0x03; // 3C 3D
1091  0334 7b02          	ld	a,(OFST-2,sp)
1092  0336 a403          	and	a,#3
1093  0338 ca5410        	or	a,21520
1094  033b c75410        	ld	21520,a
1095                     ; 338       LCD->RAM[LCD_RAMRegister_5] &= 0x3f;
1097  033e c65411        	ld	a,21521
1098  0341 a43f          	and	a,#63
1099  0343 c75411        	ld	21521,a
1100                     ; 339       LCD->RAM[LCD_RAMRegister_5] |= (uint8_t)(digit[1]<<4) & 0xc0; // 3F 3A
1102  0346 7b02          	ld	a,(OFST-2,sp)
1103  0348 97            	ld	xl,a
1104  0349 a610          	ld	a,#16
1105  034b 42            	mul	x,a
1106  034c 9f            	ld	a,xl
1107  034d a4c0          	and	a,#192
1108  034f ca5411        	or	a,21521
1109  0352 c75411        	ld	21521,a
1110                     ; 341       LCD->RAM[LCD_RAMRegister_7] &= 0xcf;
1112  0355 c65413        	ld	a,21523
1113  0358 a4cf          	and	a,#207
1114  035a c75413        	ld	21523,a
1115                     ; 342       LCD->RAM[LCD_RAMRegister_7] |= (uint8_t)(digit[2]<<4)&0x30; // 3Col 3P		
1117  035d 7b03          	ld	a,(OFST-1,sp)
1118  035f 97            	ld	xl,a
1119  0360 a610          	ld	a,#16
1120  0362 42            	mul	x,a
1121  0363 9f            	ld	a,xl
1122  0364 a430          	and	a,#48
1123  0366 ca5413        	or	a,21523
1124  0369 c75413        	ld	21523,a
1125                     ; 344       LCD->RAM[LCD_RAMRegister_9] &= 0xf3;
1127  036c c65415        	ld	a,21525
1128  036f a4f3          	and	a,#243
1129  0371 c75415        	ld	21525,a
1130                     ; 345       LCD->RAM[LCD_RAMRegister_9] |= (uint8_t)(digit[2]) & 0x0C;  // 3Q 3K										
1132  0374 7b03          	ld	a,(OFST-1,sp)
1133  0376 a40c          	and	a,#12
1134  0378 ca5415        	or	a,21525
1135  037b c75415        	ld	21525,a
1136                     ; 347       LCD->RAM[LCD_RAMRegister_11] &= 0xfc;
1138  037e c65417        	ld	a,21527
1139  0381 a4fc          	and	a,#252
1140  0383 c75417        	ld	21527,a
1141                     ; 348       LCD->RAM[LCD_RAMRegister_11] |= (uint8_t)(digit[3]>>2) & 0x03 ; // 3DP 3N	
1143  0386 7b04          	ld	a,(OFST+0,sp)
1144  0388 44            	srl	a
1145  0389 44            	srl	a
1146  038a a403          	and	a,#3
1147  038c ca5417        	or	a,21527
1148  038f c75417        	ld	21527,a
1149                     ; 350       LCD->RAM[LCD_RAMRegister_12] &= 0x3f;
1151  0392 c65418        	ld	a,21528
1152  0395 a43f          	and	a,#63
1153  0397 c75418        	ld	21528,a
1154                     ; 351       LCD->RAM[LCD_RAMRegister_12] |= (uint8_t)(digit[3]<<6) & 0xc0; // 3H 3J
1156  039a 7b04          	ld	a,(OFST+0,sp)
1157  039c 97            	ld	xl,a
1158  039d a640          	ld	a,#64
1159  039f 42            	mul	x,a
1160  03a0 9f            	ld	a,xl
1161  03a1 a4c0          	and	a,#192
1162  03a3 ca5418        	or	a,21528
1163  03a6 c75418        	ld	21528,a
1164                     ; 352       break;
1166  03a9 ac930593      	jpf	L503
1167  03ad               L532:
1168                     ; 355     case 4:
1168                     ; 356       LCD->RAM[LCD_RAMRegister_0] &= 0x3f;
1170  03ad c6540c        	ld	a,21516
1171  03b0 a43f          	and	a,#63
1172  03b2 c7540c        	ld	21516,a
1173                     ; 357       LCD->RAM[LCD_RAMRegister_0] |= (uint8_t)(digit[0]<<6) & 0xc0; // 4M 4E	
1175  03b5 7b01          	ld	a,(OFST-3,sp)
1176  03b7 97            	ld	xl,a
1177  03b8 a640          	ld	a,#64
1178  03ba 42            	mul	x,a
1179  03bb 9f            	ld	a,xl
1180  03bc a4c0          	and	a,#192
1181  03be ca540c        	or	a,21516
1182  03c1 c7540c        	ld	21516,a
1183                     ; 359       LCD->RAM[LCD_RAMRegister_2] &= 0xfc;
1185  03c4 c6540e        	ld	a,21518
1186  03c7 a4fc          	and	a,#252
1187  03c9 c7540e        	ld	21518,a
1188                     ; 360       LCD->RAM[LCD_RAMRegister_2] |= (uint8_t)(digit[0]>>2) & 0x03; // 4G 4B
1190  03cc 7b01          	ld	a,(OFST-3,sp)
1191  03ce 44            	srl	a
1192  03cf 44            	srl	a
1193  03d0 a403          	and	a,#3
1194  03d2 ca540e        	or	a,21518
1195  03d5 c7540e        	ld	21518,a
1196                     ; 362       LCD->RAM[LCD_RAMRegister_4] &= 0xf3;
1198  03d8 c65410        	ld	a,21520
1199  03db a4f3          	and	a,#243
1200  03dd c75410        	ld	21520,a
1201                     ; 363       LCD->RAM[LCD_RAMRegister_4] |= (uint8_t)(digit[1]<<2) & 0x0C; // 4C 4D
1203  03e0 7b02          	ld	a,(OFST-2,sp)
1204  03e2 48            	sll	a
1205  03e3 48            	sll	a
1206  03e4 a40c          	and	a,#12
1207  03e6 ca5410        	or	a,21520
1208  03e9 c75410        	ld	21520,a
1209                     ; 365       LCD->RAM[LCD_RAMRegister_5] &= 0xcf;
1211  03ec c65411        	ld	a,21521
1212  03ef a4cf          	and	a,#207
1213  03f1 c75411        	ld	21521,a
1214                     ; 366       LCD->RAM[LCD_RAMRegister_5] |= (uint8_t)(digit[1]<<2) & 0x30; // 4F 4A
1216  03f4 7b02          	ld	a,(OFST-2,sp)
1217  03f6 48            	sll	a
1218  03f7 48            	sll	a
1219  03f8 a430          	and	a,#48
1220  03fa ca5411        	or	a,21521
1221  03fd c75411        	ld	21521,a
1222                     ; 368       LCD->RAM[LCD_RAMRegister_7] &= 0x3f;
1224  0400 c65413        	ld	a,21523
1225  0403 a43f          	and	a,#63
1226  0405 c75413        	ld	21523,a
1227                     ; 369       LCD->RAM[LCD_RAMRegister_7] |= (uint8_t)(digit[2]<<6) & 0xC0; // 4Col 4P		
1229  0408 7b03          	ld	a,(OFST-1,sp)
1230  040a 97            	ld	xl,a
1231  040b a640          	ld	a,#64
1232  040d 42            	mul	x,a
1233  040e 9f            	ld	a,xl
1234  040f a4c0          	and	a,#192
1235  0411 ca5413        	or	a,21523
1236  0414 c75413        	ld	21523,a
1237                     ; 371       LCD->RAM[LCD_RAMRegister_9] &= 0xfc;				
1239  0417 c65415        	ld	a,21525
1240  041a a4fc          	and	a,#252
1241  041c c75415        	ld	21525,a
1242                     ; 372       LCD->RAM[LCD_RAMRegister_9] |= (uint8_t)(digit[2]>>2) & 0x03 ; // 4Q 4K										
1244  041f 7b03          	ld	a,(OFST-1,sp)
1245  0421 44            	srl	a
1246  0422 44            	srl	a
1247  0423 a403          	and	a,#3
1248  0425 ca5415        	or	a,21525
1249  0428 c75415        	ld	21525,a
1250                     ; 374       LCD->RAM[LCD_RAMRegister_11] &= 0xf3;				
1252  042b c65417        	ld	a,21527
1253  042e a4f3          	and	a,#243
1254  0430 c75417        	ld	21527,a
1255                     ; 375       LCD->RAM[LCD_RAMRegister_11] |= (uint8_t)(digit[3]) & 0x0C; // 4DP 4N	
1257  0433 7b04          	ld	a,(OFST+0,sp)
1258  0435 a40c          	and	a,#12
1259  0437 ca5417        	or	a,21527
1260  043a c75417        	ld	21527,a
1261                     ; 377       LCD->RAM[LCD_RAMRegister_12] &= 0xcf;				
1263  043d c65418        	ld	a,21528
1264  0440 a4cf          	and	a,#207
1265  0442 c75418        	ld	21528,a
1266                     ; 378       LCD->RAM[LCD_RAMRegister_12] |= (uint8_t)(digit[3]<<4) & 0x30; // 4H 4J
1268  0445 7b04          	ld	a,(OFST+0,sp)
1269  0447 97            	ld	xl,a
1270  0448 a610          	ld	a,#16
1271  044a 42            	mul	x,a
1272  044b 9f            	ld	a,xl
1273  044c a430          	and	a,#48
1274  044e ca5418        	or	a,21528
1275  0451 c75418        	ld	21528,a
1276                     ; 379       break;
1278  0454 ac930593      	jpf	L503
1279  0458               L732:
1280                     ; 382     case 5:
1280                     ; 383       LCD->RAM[LCD_RAMRegister_1] &= 0xfc;
1282  0458 c6540d        	ld	a,21517
1283  045b a4fc          	and	a,#252
1284  045d c7540d        	ld	21517,a
1285                     ; 384       LCD->RAM[LCD_RAMRegister_1] |=  (uint8_t)(digit[0]) & 0x03; // 5M 5E	
1287  0460 7b01          	ld	a,(OFST-3,sp)
1288  0462 a403          	and	a,#3
1289  0464 ca540d        	or	a,21517
1290  0467 c7540d        	ld	21517,a
1291                     ; 386       LCD->RAM[LCD_RAMRegister_1] &= 0x3f;
1293  046a c6540d        	ld	a,21517
1294  046d a43f          	and	a,#63
1295  046f c7540d        	ld	21517,a
1296                     ; 387       LCD->RAM[LCD_RAMRegister_1] |=  (uint8_t)(digit[0]<<4) & 0xc0; // 5G 5B
1298  0472 7b01          	ld	a,(OFST-3,sp)
1299  0474 97            	ld	xl,a
1300  0475 a610          	ld	a,#16
1301  0477 42            	mul	x,a
1302  0478 9f            	ld	a,xl
1303  0479 a4c0          	and	a,#192
1304  047b ca540d        	or	a,21517
1305  047e c7540d        	ld	21517,a
1306                     ; 389       LCD->RAM[LCD_RAMRegister_4] &= 0xcf;				
1308  0481 c65410        	ld	a,21520
1309  0484 a4cf          	and	a,#207
1310  0486 c75410        	ld	21520,a
1311                     ; 390       LCD->RAM[LCD_RAMRegister_4] |= (uint8_t)(digit[1]<<4) & 0x30; // 5C 5D
1313  0489 7b02          	ld	a,(OFST-2,sp)
1314  048b 97            	ld	xl,a
1315  048c a610          	ld	a,#16
1316  048e 42            	mul	x,a
1317  048f 9f            	ld	a,xl
1318  0490 a430          	and	a,#48
1319  0492 ca5410        	or	a,21520
1320  0495 c75410        	ld	21520,a
1321                     ; 392       LCD->RAM[LCD_RAMRegister_5] &= 0xf3;				
1323  0498 c65411        	ld	a,21521
1324  049b a4f3          	and	a,#243
1325  049d c75411        	ld	21521,a
1326                     ; 393       LCD->RAM[LCD_RAMRegister_5] |=  (uint8_t)(digit[1]) & 0x0c; // 5F 5A
1328  04a0 7b02          	ld	a,(OFST-2,sp)
1329  04a2 a40c          	and	a,#12
1330  04a4 ca5411        	or	a,21521
1331  04a7 c75411        	ld	21521,a
1332                     ; 397       LCD->RAM[LCD_RAMRegister_8] &= 0xfe;
1334  04aa 72115414      	bres	21524,#0
1335                     ; 398       LCD->RAM[LCD_RAMRegister_8] |=  (uint8_t)(digit[2]) & 0x01; //  5P	
1337  04ae 7b03          	ld	a,(OFST-1,sp)
1338  04b0 a401          	and	a,#1
1339  04b2 ca5414        	or	a,21524
1340  04b5 c75414        	ld	21524,a
1341                     ; 400       LCD->RAM[LCD_RAMRegister_8] &= 0x3f;					
1343  04b8 c65414        	ld	a,21524
1344  04bb a43f          	and	a,#63
1345  04bd c75414        	ld	21524,a
1346                     ; 401       LCD->RAM[LCD_RAMRegister_8] |=  (uint8_t)(digit[2]<<4) & 0xc0; // 5Q 5K										
1348  04c0 7b03          	ld	a,(OFST-1,sp)
1349  04c2 97            	ld	xl,a
1350  04c3 a610          	ld	a,#16
1351  04c5 42            	mul	x,a
1352  04c6 9f            	ld	a,xl
1353  04c7 a4c0          	and	a,#192
1354  04c9 ca5414        	or	a,21524
1355  04cc c75414        	ld	21524,a
1356                     ; 403       LCD->RAM[LCD_RAMRegister_11] &= 0xef;				
1358  04cf 72195417      	bres	21527,#4
1359                     ; 404       LCD->RAM[LCD_RAMRegister_11] |=  (uint8_t)(digit[3]<<2) & 0x10; // 5N	
1361  04d3 7b04          	ld	a,(OFST+0,sp)
1362  04d5 48            	sll	a
1363  04d6 48            	sll	a
1364  04d7 a410          	and	a,#16
1365  04d9 ca5417        	or	a,21527
1366  04dc c75417        	ld	21527,a
1367                     ; 406       LCD->RAM[LCD_RAMRegister_12] &= 0xf3;				
1369  04df c65418        	ld	a,21528
1370  04e2 a4f3          	and	a,#243
1371  04e4 c75418        	ld	21528,a
1372                     ; 407       LCD->RAM[LCD_RAMRegister_12] |=  (uint8_t)(digit[3]<<2) & 0x0C; // 5H 5J
1374  04e7 7b04          	ld	a,(OFST+0,sp)
1375  04e9 48            	sll	a
1376  04ea 48            	sll	a
1377  04eb a40c          	and	a,#12
1378  04ed ca5418        	or	a,21528
1379  04f0 c75418        	ld	21528,a
1380                     ; 408       break;
1382  04f3 ac930593      	jpf	L503
1383  04f7               L142:
1384                     ; 411     case 6:
1384                     ; 412       LCD->RAM[LCD_RAMRegister_1] &= 0xf3;
1386  04f7 c6540d        	ld	a,21517
1387  04fa a4f3          	and	a,#243
1388  04fc c7540d        	ld	21517,a
1389                     ; 413       LCD->RAM[LCD_RAMRegister_1] |=  (uint8_t)(digit[0]<<2) & 0x0C; // 6M 6E	
1391  04ff 7b01          	ld	a,(OFST-3,sp)
1392  0501 48            	sll	a
1393  0502 48            	sll	a
1394  0503 a40c          	and	a,#12
1395  0505 ca540d        	or	a,21517
1396  0508 c7540d        	ld	21517,a
1397                     ; 415       LCD->RAM[LCD_RAMRegister_1] &= 0xcf;				
1399  050b c6540d        	ld	a,21517
1400  050e a4cf          	and	a,#207
1401  0510 c7540d        	ld	21517,a
1402                     ; 416       LCD->RAM[LCD_RAMRegister_1] |=  (uint8_t)(digit[0]<<2) & 0x30; // 6G 6B
1404  0513 7b01          	ld	a,(OFST-3,sp)
1405  0515 48            	sll	a
1406  0516 48            	sll	a
1407  0517 a430          	and	a,#48
1408  0519 ca540d        	or	a,21517
1409  051c c7540d        	ld	21517,a
1410                     ; 418       LCD->RAM[LCD_RAMRegister_4] &= 0x3f;				
1412  051f c65410        	ld	a,21520
1413  0522 a43f          	and	a,#63
1414  0524 c75410        	ld	21520,a
1415                     ; 419       LCD->RAM[LCD_RAMRegister_4] |= (uint8_t)(digit[1]<<6) & 0xc0; // 6C 6D
1417  0527 7b02          	ld	a,(OFST-2,sp)
1418  0529 97            	ld	xl,a
1419  052a a640          	ld	a,#64
1420  052c 42            	mul	x,a
1421  052d 9f            	ld	a,xl
1422  052e a4c0          	and	a,#192
1423  0530 ca5410        	or	a,21520
1424  0533 c75410        	ld	21520,a
1425                     ; 421       LCD->RAM[LCD_RAMRegister_5] &= 0xfc;				
1427  0536 c65411        	ld	a,21521
1428  0539 a4fc          	and	a,#252
1429  053b c75411        	ld	21521,a
1430                     ; 422       LCD->RAM[LCD_RAMRegister_5] |=  (uint8_t)(digit[1]>>2) & 0x03; // 6F 6A
1432  053e 7b02          	ld	a,(OFST-2,sp)
1433  0540 44            	srl	a
1434  0541 44            	srl	a
1435  0542 a403          	and	a,#3
1436  0544 ca5411        	or	a,21521
1437  0547 c75411        	ld	21521,a
1438                     ; 424       LCD->RAM[LCD_RAMRegister_8] &= 0xfb;
1440  054a 72155414      	bres	21524,#2
1441                     ; 425       LCD->RAM[LCD_RAMRegister_8] |=  (uint8_t)(digit[2]<<2) & 0x04; //  6P	
1443  054e 7b03          	ld	a,(OFST-1,sp)
1444  0550 48            	sll	a
1445  0551 48            	sll	a
1446  0552 a404          	and	a,#4
1447  0554 ca5414        	or	a,21524
1448  0557 c75414        	ld	21524,a
1449                     ; 428       LCD->RAM[LCD_RAMRegister_8] &= 0xcf;					
1451  055a c65414        	ld	a,21524
1452  055d a4cf          	and	a,#207
1453  055f c75414        	ld	21524,a
1454                     ; 429       LCD->RAM[LCD_RAMRegister_8] |=  (uint8_t)(digit[2]<<2) & 0x30; // 6Q 6K	
1456  0562 7b03          	ld	a,(OFST-1,sp)
1457  0564 48            	sll	a
1458  0565 48            	sll	a
1459  0566 a430          	and	a,#48
1460  0568 ca5414        	or	a,21524
1461  056b c75414        	ld	21524,a
1462                     ; 431       LCD->RAM[LCD_RAMRegister_11] &= 0xbf;				
1464  056e 721d5417      	bres	21527,#6
1465                     ; 432       LCD->RAM[LCD_RAMRegister_11] |=  (uint8_t)(digit[3]<<4) & 0x40; // 6N	
1467  0572 7b04          	ld	a,(OFST+0,sp)
1468  0574 97            	ld	xl,a
1469  0575 a610          	ld	a,#16
1470  0577 42            	mul	x,a
1471  0578 9f            	ld	a,xl
1472  0579 a440          	and	a,#64
1473  057b ca5417        	or	a,21527
1474  057e c75417        	ld	21527,a
1475                     ; 434       LCD->RAM[LCD_RAMRegister_12] &= 0xfc;				
1477  0581 c65418        	ld	a,21528
1478  0584 a4fc          	and	a,#252
1479  0586 c75418        	ld	21528,a
1480                     ; 435       LCD->RAM[LCD_RAMRegister_12] |= (uint8_t)(digit[3]) & 0x03; // 6H	6J
1482  0589 7b04          	ld	a,(OFST+0,sp)
1483  058b a403          	and	a,#3
1484  058d ca5418        	or	a,21528
1485  0590 c75418        	ld	21528,a
1486                     ; 436       break;
1488  0593               L342:
1489                     ; 438       default:
1489                     ; 439               break;
1491  0593               L503:
1492                     ; 443 	LCD_bar();
1494  0593 cd0070        	call	_LCD_bar
1496                     ; 444 }
1499  0596 5b06          	addw	sp,#6
1500  0598 81            	ret
1547                     ; 451 void LCD_GLASS_DisplayString(uint8_t* ptr)
1547                     ; 452 {
1548                     	switch	.text
1549  0599               _LCD_GLASS_DisplayString:
1551  0599 89            	pushw	x
1552  059a 88            	push	a
1553       00000001      OFST:	set	1
1556                     ; 453   uint8_t i = 0x01;
1558  059b a601          	ld	a,#1
1559  059d 6b01          	ld	(OFST+0,sp),a
1560                     ; 455 	LCD_GLASS_Clear();
1562  059f cd063c        	call	_LCD_GLASS_Clear
1565  05a2 2017          	jra	L333
1566  05a4               L133:
1567                     ; 460     LCD_GLASS_WriteChar(ptr, FALSE, FALSE, i);
1569  05a4 7b01          	ld	a,(OFST+0,sp)
1570  05a6 88            	push	a
1571  05a7 4b00          	push	#0
1572  05a9 4b00          	push	#0
1573  05ab 1e05          	ldw	x,(OFST+4,sp)
1574  05ad cd0178        	call	_LCD_GLASS_WriteChar
1576  05b0 5b03          	addw	sp,#3
1577                     ; 463     ptr++;
1579  05b2 1e02          	ldw	x,(OFST+1,sp)
1580  05b4 1c0001        	addw	x,#1
1581  05b7 1f02          	ldw	(OFST+1,sp),x
1582                     ; 466     i++;
1584  05b9 0c01          	inc	(OFST+0,sp)
1585  05bb               L333:
1586                     ; 457   while ((*ptr != 0) & (i < 8))
1588  05bb 1e02          	ldw	x,(OFST+1,sp)
1589  05bd 7d            	tnz	(x)
1590  05be 2706          	jreq	L733
1592  05c0 7b01          	ld	a,(OFST+0,sp)
1593  05c2 a108          	cp	a,#8
1594  05c4 25de          	jrult	L133
1595  05c6               L733:
1596                     ; 468 }
1599  05c6 5b03          	addw	sp,#3
1600  05c8 81            	ret
1656                     ; 476 void LCD_GLASS_DisplayStrDeci(uint16_t* ptr)
1656                     ; 477 {
1657                     	switch	.text
1658  05c9               _LCD_GLASS_DisplayStrDeci:
1660  05c9 89            	pushw	x
1661  05ca 89            	pushw	x
1662       00000002      OFST:	set	2
1665                     ; 478   uint8_t i = 0x01;
1667  05cb a601          	ld	a,#1
1668  05cd 6b02          	ld	(OFST+0,sp),a
1669                     ; 481 	LCD_GLASS_Clear();
1671  05cf ad6b          	call	_LCD_GLASS_Clear
1674  05d1 2059          	jra	L773
1675  05d3               L573:
1676                     ; 485     char_tmp = (*ptr) & 0x00ff;
1678  05d3 1e03          	ldw	x,(OFST+1,sp)
1679  05d5 e601          	ld	a,(1,x)
1680  05d7 a4ff          	and	a,#255
1681  05d9 6b01          	ld	(OFST-1,sp),a
1682                     ; 487     switch ((*ptr) & 0xf000)
1684  05db 1e03          	ldw	x,(OFST+1,sp)
1685  05dd fe            	ldw	x,(x)
1686  05de 01            	rrwa	x,a
1687  05df 9f            	ld	a,xl
1688  05e0 a4f0          	and	a,#240
1689  05e2 97            	ld	xl,a
1690  05e3 4f            	clr	a
1691  05e4 02            	rlwa	x,a
1693                     ; 499           break;
1694  05e5 1d4000        	subw	x,#16384
1695  05e8 2729          	jreq	L343
1696  05ea 1d4000        	subw	x,#16384
1697  05ed 2712          	jreq	L143
1698  05ef               L543:
1699                     ; 497       default:
1699                     ; 498           LCD_GLASS_WriteChar(&char_tmp, POINT_OFF, COLUMN_OFF, i);		
1701  05ef 7b02          	ld	a,(OFST+0,sp)
1702  05f1 88            	push	a
1703  05f2 4b00          	push	#0
1704  05f4 4b00          	push	#0
1705  05f6 96            	ldw	x,sp
1706  05f7 1c0004        	addw	x,#OFST+2
1707  05fa cd0178        	call	_LCD_GLASS_WriteChar
1709  05fd 5b03          	addw	sp,#3
1710                     ; 499           break;
1712  05ff 2022          	jra	L504
1713  0601               L143:
1714                     ; 489       case DOT:
1714                     ; 490           /* Display one character on LCD with decimal point */
1714                     ; 491           LCD_GLASS_WriteChar(&char_tmp, POINT_ON, COLUMN_OFF, i);
1716  0601 7b02          	ld	a,(OFST+0,sp)
1717  0603 88            	push	a
1718  0604 4b00          	push	#0
1719  0606 4b01          	push	#1
1720  0608 96            	ldw	x,sp
1721  0609 1c0004        	addw	x,#OFST+2
1722  060c cd0178        	call	_LCD_GLASS_WriteChar
1724  060f 5b03          	addw	sp,#3
1725                     ; 492           break;
1727  0611 2010          	jra	L504
1728  0613               L343:
1729                     ; 493       case DOUBLE_DOT:
1729                     ; 494           /* Display one character on LCD with decimal point */
1729                     ; 495           LCD_GLASS_WriteChar(&char_tmp, POINT_OFF, COLUMN_ON, i);
1731  0613 7b02          	ld	a,(OFST+0,sp)
1732  0615 88            	push	a
1733  0616 4b01          	push	#1
1734  0618 4b00          	push	#0
1735  061a 96            	ldw	x,sp
1736  061b 1c0004        	addw	x,#OFST+2
1737  061e cd0178        	call	_LCD_GLASS_WriteChar
1739  0621 5b03          	addw	sp,#3
1740                     ; 496           break;
1742  0623               L504:
1743                     ; 501     ptr++;
1745  0623 1e03          	ldw	x,(OFST+1,sp)
1746  0625 1c0002        	addw	x,#2
1747  0628 1f03          	ldw	(OFST+1,sp),x
1748                     ; 504     i++;
1750  062a 0c02          	inc	(OFST+0,sp)
1751  062c               L773:
1752                     ; 483   while ((*ptr != 0) & (i < 8))
1754  062c 1e03          	ldw	x,(OFST+1,sp)
1755  062e e601          	ld	a,(1,x)
1756  0630 fa            	or	a,(x)
1757  0631 2706          	jreq	L704
1759  0633 7b02          	ld	a,(OFST+0,sp)
1760  0635 a108          	cp	a,#8
1761  0637 259a          	jrult	L573
1762  0639               L704:
1763                     ; 506 }
1766  0639 5b04          	addw	sp,#4
1767  063b 81            	ret
1801                     ; 513 void LCD_GLASS_Clear(void)
1801                     ; 514 {
1802                     	switch	.text
1803  063c               _LCD_GLASS_Clear:
1805  063c 88            	push	a
1806       00000001      OFST:	set	1
1809                     ; 515   uint8_t counter = 0;
1811                     ; 517   for (counter = 0; counter <= LCD_RAMRegister_13; counter++)
1813  063d 0f01          	clr	(OFST+0,sp)
1814  063f               L724:
1815                     ; 519     LCD->RAM[counter] = LCD_RAM_RESET_VALUE;
1817  063f 7b01          	ld	a,(OFST+0,sp)
1818  0641 5f            	clrw	x
1819  0642 97            	ld	xl,a
1820  0643 724f540c      	clr	(21516,x)
1821                     ; 517   for (counter = 0; counter <= LCD_RAMRegister_13; counter++)
1823  0647 0c01          	inc	(OFST+0,sp)
1826  0649 7b01          	ld	a,(OFST+0,sp)
1827  064b a10e          	cp	a,#14
1828  064d 25f0          	jrult	L724
1829                     ; 521 }
1832  064f 84            	pop	a
1833  0650 81            	ret
1836                     	switch	.const
1837  0062               L534_str:
1838  0062 00            	dc.b	0
1839  0063 000000000000  	ds.b	6
1942                     ; 533 void LCD_GLASS_ScrollSentence(uint8_t* ptr, uint16_t nScroll, uint16_t ScrollSpeed)
1942                     ; 534 {
1943                     	switch	.text
1944  0651               _LCD_GLASS_ScrollSentence:
1946  0651 89            	pushw	x
1947  0652 520c          	subw	sp,#12
1948       0000000c      OFST:	set	12
1951                     ; 538   uint8_t str[7]="";
1953  0654 96            	ldw	x,sp
1954  0655 1c0002        	addw	x,#OFST-10
1955  0658 90ae0062      	ldw	y,#L534_str
1956  065c a607          	ld	a,#7
1957  065e cd0000        	call	c_xymvx
1959                     ; 541   if (ptr == 0) return;
1961  0661 1e0d          	ldw	x,(OFST+1,sp)
1962  0663 2603          	jrne	L45
1963  0665 cc072d        	jp	L25
1964  0668               L45:
1967                     ; 544   for (ptr1=ptr,Str_size = 0 ; *ptr1 != 0; Str_size++,ptr1++) ;
1969  0668 1e0d          	ldw	x,(OFST+1,sp)
1970  066a 1f09          	ldw	(OFST-3,sp),x
1971  066c 0f0b          	clr	(OFST-1,sp)
1973  066e 2009          	jra	L715
1974  0670               L315:
1978  0670 0c0b          	inc	(OFST-1,sp)
1979  0672 1e09          	ldw	x,(OFST-3,sp)
1980  0674 1c0001        	addw	x,#1
1981  0677 1f09          	ldw	(OFST-3,sp),x
1982  0679               L715:
1985  0679 1e09          	ldw	x,(OFST-3,sp)
1986  067b 7d            	tnz	(x)
1987  067c 26f2          	jrne	L315
1988                     ; 546   ptr1 = ptr;
1990  067e 1e0d          	ldw	x,(OFST+1,sp)
1991  0680 1f09          	ldw	(OFST-3,sp),x
1992                     ; 548   LCD_GLASS_DisplayString(ptr);
1994  0682 1e0d          	ldw	x,(OFST+1,sp)
1995  0684 cd0599        	call	_LCD_GLASS_DisplayString
1997                     ; 549   delay_ms(ScrollSpeed);
1999  0687 1e13          	ldw	x,(OFST+7,sp)
2000  0689 cd0000        	call	_delay_ms
2002                     ; 552   for (Repetition=0; Repetition<nScroll; Repetition++)
2004  068c 0f01          	clr	(OFST-11,sp)
2006  068e ac510751      	jpf	L725
2007  0692               L325:
2008                     ; 554     for (Char_Nb=0; Char_Nb<Str_size-10; Char_Nb++)
2010  0692 0f0c          	clr	(OFST+0,sp)
2012  0694 ac370737      	jpf	L735
2013  0698               L335:
2014                     ; 556       *(str) =* (ptr1+((Char_Nb+1)%Str_size));
2016  0698 7b0c          	ld	a,(OFST+0,sp)
2017  069a 5f            	clrw	x
2018  069b 97            	ld	xl,a
2019  069c 5c            	incw	x
2020  069d 7b0b          	ld	a,(OFST-1,sp)
2021  069f 905f          	clrw	y
2022  06a1 9097          	ld	yl,a
2023  06a3 cd0000        	call	c_idiv
2025  06a6 51            	exgw	x,y
2026  06a7 72fb09        	addw	x,(OFST-3,sp)
2027  06aa f6            	ld	a,(x)
2028  06ab 6b02          	ld	(OFST-10,sp),a
2029                     ; 557       *(str+1) =* (ptr1+((Char_Nb+2)%Str_size));
2031  06ad 7b0c          	ld	a,(OFST+0,sp)
2032  06af 5f            	clrw	x
2033  06b0 97            	ld	xl,a
2034  06b1 5c            	incw	x
2035  06b2 5c            	incw	x
2036  06b3 7b0b          	ld	a,(OFST-1,sp)
2037  06b5 905f          	clrw	y
2038  06b7 9097          	ld	yl,a
2039  06b9 cd0000        	call	c_idiv
2041  06bc 51            	exgw	x,y
2042  06bd 72fb09        	addw	x,(OFST-3,sp)
2043  06c0 f6            	ld	a,(x)
2044  06c1 6b03          	ld	(OFST-9,sp),a
2045                     ; 558       *(str+2) =* (ptr1+((Char_Nb+3)%Str_size));
2047  06c3 7b0c          	ld	a,(OFST+0,sp)
2048  06c5 5f            	clrw	x
2049  06c6 97            	ld	xl,a
2050  06c7 1c0003        	addw	x,#3
2051  06ca 7b0b          	ld	a,(OFST-1,sp)
2052  06cc 905f          	clrw	y
2053  06ce 9097          	ld	yl,a
2054  06d0 cd0000        	call	c_idiv
2056  06d3 51            	exgw	x,y
2057  06d4 72fb09        	addw	x,(OFST-3,sp)
2058  06d7 f6            	ld	a,(x)
2059  06d8 6b04          	ld	(OFST-8,sp),a
2060                     ; 559       *(str+3) =* (ptr1+((Char_Nb+4)%Str_size));
2062  06da 7b0c          	ld	a,(OFST+0,sp)
2063  06dc 5f            	clrw	x
2064  06dd 97            	ld	xl,a
2065  06de 1c0004        	addw	x,#4
2066  06e1 7b0b          	ld	a,(OFST-1,sp)
2067  06e3 905f          	clrw	y
2068  06e5 9097          	ld	yl,a
2069  06e7 cd0000        	call	c_idiv
2071  06ea 51            	exgw	x,y
2072  06eb 72fb09        	addw	x,(OFST-3,sp)
2073  06ee f6            	ld	a,(x)
2074  06ef 6b05          	ld	(OFST-7,sp),a
2075                     ; 560       *(str+4) =* (ptr1+((Char_Nb+5)%Str_size));
2077  06f1 7b0c          	ld	a,(OFST+0,sp)
2078  06f3 5f            	clrw	x
2079  06f4 97            	ld	xl,a
2080  06f5 1c0005        	addw	x,#5
2081  06f8 7b0b          	ld	a,(OFST-1,sp)
2082  06fa 905f          	clrw	y
2083  06fc 9097          	ld	yl,a
2084  06fe cd0000        	call	c_idiv
2086  0701 51            	exgw	x,y
2087  0702 72fb09        	addw	x,(OFST-3,sp)
2088  0705 f6            	ld	a,(x)
2089  0706 6b06          	ld	(OFST-6,sp),a
2090                     ; 561       *(str+5) =* (ptr1+((Char_Nb+6)%Str_size));
2092  0708 7b0c          	ld	a,(OFST+0,sp)
2093  070a 5f            	clrw	x
2094  070b 97            	ld	xl,a
2095  070c 1c0006        	addw	x,#6
2096  070f 7b0b          	ld	a,(OFST-1,sp)
2097  0711 905f          	clrw	y
2098  0713 9097          	ld	yl,a
2099  0715 cd0000        	call	c_idiv
2101  0718 51            	exgw	x,y
2102  0719 72fb09        	addw	x,(OFST-3,sp)
2103  071c f6            	ld	a,(x)
2104  071d 6b07          	ld	(OFST-5,sp),a
2105                     ; 562       LCD_GLASS_Clear();
2107  071f cd063c        	call	_LCD_GLASS_Clear
2109                     ; 563       LCD_GLASS_DisplayString(str);
2111  0722 96            	ldw	x,sp
2112  0723 1c0002        	addw	x,#OFST-10
2113  0726 cd0599        	call	_LCD_GLASS_DisplayString
2115                     ; 566       if (KeyPressed)
2117  0729 3d00          	tnz	_KeyPressed
2118  072b 2703          	jreq	L345
2119                     ; 567               return;   		
2120  072d               L25:
2123  072d 5b0e          	addw	sp,#14
2124  072f 81            	ret
2125  0730               L345:
2126                     ; 568       delay_ms(ScrollSpeed);
2128  0730 1e13          	ldw	x,(OFST+7,sp)
2129  0732 cd0000        	call	_delay_ms
2131                     ; 554     for (Char_Nb=0; Char_Nb<Str_size-10; Char_Nb++)
2133  0735 0c0c          	inc	(OFST+0,sp)
2134  0737               L735:
2137  0737 9c            	rvf
2138  0738 7b0b          	ld	a,(OFST-1,sp)
2139  073a 5f            	clrw	x
2140  073b 97            	ld	xl,a
2141  073c 1d000a        	subw	x,#10
2142  073f 7b0c          	ld	a,(OFST+0,sp)
2143  0741 905f          	clrw	y
2144  0743 9097          	ld	yl,a
2145  0745 90bf00        	ldw	c_y,y
2146  0748 b300          	cpw	x,c_y
2147  074a 2d03          	jrsle	L65
2148  074c cc0698        	jp	L335
2149  074f               L65:
2150                     ; 552   for (Repetition=0; Repetition<nScroll; Repetition++)
2152  074f 0c01          	inc	(OFST-11,sp)
2153  0751               L725:
2156  0751 7b01          	ld	a,(OFST-11,sp)
2157  0753 5f            	clrw	x
2158  0754 97            	ld	xl,a
2159  0755 1311          	cpw	x,(OFST+5,sp)
2160  0757 2403          	jruge	L06
2161  0759 cc0692        	jp	L325
2162  075c               L06:
2163                     ; 572 }
2165  075c 20cf          	jra	L25
2168                     	switch	.const
2169  0069               L545_str:
2170  0069 00            	dc.b	0
2171  006a 000000000000  	ds.b	6
2264                     ; 584 void LCD_GLASS_ScrollSentenceNbCar(uint8_t* ptr, uint16_t ScrollSpeed,uint8_t NbCar)
2264                     ; 585 {
2265                     	switch	.text
2266  075e               _LCD_GLASS_ScrollSentenceNbCar:
2268  075e 89            	pushw	x
2269  075f 520b          	subw	sp,#11
2270       0000000b      OFST:	set	11
2273                     ; 587   uint8_t Char_Nb =0;
2275  0761 0f03          	clr	(OFST-8,sp)
2276                     ; 589   uint8_t str[7]="";
2278  0763 96            	ldw	x,sp
2279  0764 1c0004        	addw	x,#OFST-7
2280  0767 90ae0069      	ldw	y,#L545_str
2281  076b a607          	ld	a,#7
2282  076d cd0000        	call	c_xymvx
2284                     ; 590   uint8_t Str_size= NbCar;
2286  0770 7b12          	ld	a,(OFST+7,sp)
2287  0772 6b0b          	ld	(OFST+0,sp),a
2288                     ; 592   if (ptr == 0) return;
2290  0774 1e0c          	ldw	x,(OFST+1,sp)
2291  0776 2603          	jrne	L66
2292  0778 cc082b        	jp	L46
2293  077b               L66:
2296                     ; 597   ptr1 = ptr;
2298  077b 1e0c          	ldw	x,(OFST+1,sp)
2299  077d 1f01          	ldw	(OFST-10,sp),x
2300                     ; 599   LCD_GLASS_DisplayString(ptr);
2302  077f 1e0c          	ldw	x,(OFST+1,sp)
2303  0781 cd0599        	call	_LCD_GLASS_DisplayString
2305                     ; 601 	delay_10us(ScrollSpeed);
2307  0784 1e10          	ldw	x,(OFST+5,sp)
2308  0786 cd0000        	call	_delay_10us
2310  0789               L716:
2311                     ; 607 		*(str) =* (ptr1+((Char_Nb+1)%Str_size));
2313  0789 7b03          	ld	a,(OFST-8,sp)
2314  078b 5f            	clrw	x
2315  078c 97            	ld	xl,a
2316  078d 5c            	incw	x
2317  078e 7b0b          	ld	a,(OFST+0,sp)
2318  0790 905f          	clrw	y
2319  0792 9097          	ld	yl,a
2320  0794 cd0000        	call	c_idiv
2322  0797 51            	exgw	x,y
2323  0798 72fb01        	addw	x,(OFST-10,sp)
2324  079b f6            	ld	a,(x)
2325  079c 6b04          	ld	(OFST-7,sp),a
2326                     ; 608 		*(str+1) =* (ptr1+((Char_Nb+2)%Str_size));
2328  079e 7b03          	ld	a,(OFST-8,sp)
2329  07a0 5f            	clrw	x
2330  07a1 97            	ld	xl,a
2331  07a2 5c            	incw	x
2332  07a3 5c            	incw	x
2333  07a4 7b0b          	ld	a,(OFST+0,sp)
2334  07a6 905f          	clrw	y
2335  07a8 9097          	ld	yl,a
2336  07aa cd0000        	call	c_idiv
2338  07ad 51            	exgw	x,y
2339  07ae 72fb01        	addw	x,(OFST-10,sp)
2340  07b1 f6            	ld	a,(x)
2341  07b2 6b05          	ld	(OFST-6,sp),a
2342                     ; 609 		*(str+2) =* (ptr1+((Char_Nb+3)%Str_size));
2344  07b4 7b03          	ld	a,(OFST-8,sp)
2345  07b6 5f            	clrw	x
2346  07b7 97            	ld	xl,a
2347  07b8 1c0003        	addw	x,#3
2348  07bb 7b0b          	ld	a,(OFST+0,sp)
2349  07bd 905f          	clrw	y
2350  07bf 9097          	ld	yl,a
2351  07c1 cd0000        	call	c_idiv
2353  07c4 51            	exgw	x,y
2354  07c5 72fb01        	addw	x,(OFST-10,sp)
2355  07c8 f6            	ld	a,(x)
2356  07c9 6b06          	ld	(OFST-5,sp),a
2357                     ; 610 		*(str+3) =* (ptr1+((Char_Nb+4)%Str_size));
2359  07cb 7b03          	ld	a,(OFST-8,sp)
2360  07cd 5f            	clrw	x
2361  07ce 97            	ld	xl,a
2362  07cf 1c0004        	addw	x,#4
2363  07d2 7b0b          	ld	a,(OFST+0,sp)
2364  07d4 905f          	clrw	y
2365  07d6 9097          	ld	yl,a
2366  07d8 cd0000        	call	c_idiv
2368  07db 51            	exgw	x,y
2369  07dc 72fb01        	addw	x,(OFST-10,sp)
2370  07df f6            	ld	a,(x)
2371  07e0 6b07          	ld	(OFST-4,sp),a
2372                     ; 611 		*(str+4) =* (ptr1+((Char_Nb+5)%Str_size));
2374  07e2 7b03          	ld	a,(OFST-8,sp)
2375  07e4 5f            	clrw	x
2376  07e5 97            	ld	xl,a
2377  07e6 1c0005        	addw	x,#5
2378  07e9 7b0b          	ld	a,(OFST+0,sp)
2379  07eb 905f          	clrw	y
2380  07ed 9097          	ld	yl,a
2381  07ef cd0000        	call	c_idiv
2383  07f2 51            	exgw	x,y
2384  07f3 72fb01        	addw	x,(OFST-10,sp)
2385  07f6 f6            	ld	a,(x)
2386  07f7 6b08          	ld	(OFST-3,sp),a
2387                     ; 612 		*(str+5) =* (ptr1+((Char_Nb+6)%Str_size));
2389  07f9 7b03          	ld	a,(OFST-8,sp)
2390  07fb 5f            	clrw	x
2391  07fc 97            	ld	xl,a
2392  07fd 1c0006        	addw	x,#6
2393  0800 7b0b          	ld	a,(OFST+0,sp)
2394  0802 905f          	clrw	y
2395  0804 9097          	ld	yl,a
2396  0806 cd0000        	call	c_idiv
2398  0809 51            	exgw	x,y
2399  080a 72fb01        	addw	x,(OFST-10,sp)
2400  080d f6            	ld	a,(x)
2401  080e 6b09          	ld	(OFST-2,sp),a
2402                     ; 614 		LCD_GLASS_DisplayString(str);
2404  0810 96            	ldw	x,sp
2405  0811 1c0004        	addw	x,#OFST-7
2406  0814 cd0599        	call	_LCD_GLASS_DisplayString
2408                     ; 615 		delay_10us(ScrollSpeed);
2410  0817 1e10          	ldw	x,(OFST+5,sp)
2411  0819 cd0000        	call	_delay_10us
2413                     ; 616 	} while (++Char_Nb < Str_size && state_machine == STATE_CHECKNDEFMESSAGE); 
2415  081c 0c03          	inc	(OFST-8,sp)
2416  081e 7b03          	ld	a,(OFST-8,sp)
2417  0820 110b          	cp	a,(OFST+0,sp)
2418  0822 2407          	jruge	L526
2420  0824 3d00          	tnz	_state_machine
2421  0826 2603          	jrne	L07
2422  0828 cc0789        	jp	L716
2423  082b               L07:
2424  082b               L526:
2425                     ; 623 	}	
2426  082b               L46:
2429  082b 5b0d          	addw	sp,#13
2430  082d 81            	ret
2433                     	switch	.const
2434  0070               L726_str:
2435  0070 00            	dc.b	0
2436  0071 000000000000  	ds.b	6
2520                     ; 637 void LCD_GLASS_ScrollSentenceNbCarLP(uint8_t* ptr, uint8_t NbCar)
2520                     ; 638 {
2521                     	switch	.text
2522  082e               _LCD_GLASS_ScrollSentenceNbCarLP:
2524  082e 89            	pushw	x
2525  082f 520b          	subw	sp,#11
2526       0000000b      OFST:	set	11
2529                     ; 640   uint8_t Char_Nb =0;
2531  0831 0f03          	clr	(OFST-8,sp)
2532                     ; 642   uint8_t str[7]="";
2534  0833 96            	ldw	x,sp
2535  0834 1c0004        	addw	x,#OFST-7
2536  0837 90ae0070      	ldw	y,#L726_str
2537  083b a607          	ld	a,#7
2538  083d cd0000        	call	c_xymvx
2540                     ; 643   uint8_t Str_size= NbCar;
2542  0840 7b10          	ld	a,(OFST+5,sp)
2543  0842 6b0b          	ld	(OFST+0,sp),a
2544                     ; 645   if (ptr == 0) return;
2546  0844 1e0c          	ldw	x,(OFST+1,sp)
2547  0846 2603          	jrne	L67
2548  0848 cc08fd        	jp	L47
2549  084b               L67:
2552                     ; 647   ptr1 = ptr;
2554  084b 1e0c          	ldw	x,(OFST+1,sp)
2555  084d 1f01          	ldw	(OFST-10,sp),x
2556                     ; 649   LCD_GLASS_DisplayString(ptr);
2558  084f 1e0c          	ldw	x,(OFST+1,sp)
2559  0851 cd0599        	call	_LCD_GLASS_DisplayString
2561                     ; 650 	delay_10us(SCROLL_SPEED_L);
2563  0854 ae0028        	ldw	x,#40
2564  0857 cd0000        	call	_delay_10us
2566  085a               L576:
2567                     ; 655 		*(str) =* (ptr1+((Char_Nb+1)%Str_size));
2569  085a 7b03          	ld	a,(OFST-8,sp)
2570  085c 5f            	clrw	x
2571  085d 97            	ld	xl,a
2572  085e 5c            	incw	x
2573  085f 7b0b          	ld	a,(OFST+0,sp)
2574  0861 905f          	clrw	y
2575  0863 9097          	ld	yl,a
2576  0865 cd0000        	call	c_idiv
2578  0868 51            	exgw	x,y
2579  0869 72fb01        	addw	x,(OFST-10,sp)
2580  086c f6            	ld	a,(x)
2581  086d 6b04          	ld	(OFST-7,sp),a
2582                     ; 656 		*(str+1) =* (ptr1+((Char_Nb+2)%Str_size));
2584  086f 7b03          	ld	a,(OFST-8,sp)
2585  0871 5f            	clrw	x
2586  0872 97            	ld	xl,a
2587  0873 5c            	incw	x
2588  0874 5c            	incw	x
2589  0875 7b0b          	ld	a,(OFST+0,sp)
2590  0877 905f          	clrw	y
2591  0879 9097          	ld	yl,a
2592  087b cd0000        	call	c_idiv
2594  087e 51            	exgw	x,y
2595  087f 72fb01        	addw	x,(OFST-10,sp)
2596  0882 f6            	ld	a,(x)
2597  0883 6b05          	ld	(OFST-6,sp),a
2598                     ; 657 		*(str+2) =* (ptr1+((Char_Nb+3)%Str_size));
2600  0885 7b03          	ld	a,(OFST-8,sp)
2601  0887 5f            	clrw	x
2602  0888 97            	ld	xl,a
2603  0889 1c0003        	addw	x,#3
2604  088c 7b0b          	ld	a,(OFST+0,sp)
2605  088e 905f          	clrw	y
2606  0890 9097          	ld	yl,a
2607  0892 cd0000        	call	c_idiv
2609  0895 51            	exgw	x,y
2610  0896 72fb01        	addw	x,(OFST-10,sp)
2611  0899 f6            	ld	a,(x)
2612  089a 6b06          	ld	(OFST-5,sp),a
2613                     ; 658 		*(str+3) =* (ptr1+((Char_Nb+4)%Str_size));
2615  089c 7b03          	ld	a,(OFST-8,sp)
2616  089e 5f            	clrw	x
2617  089f 97            	ld	xl,a
2618  08a0 1c0004        	addw	x,#4
2619  08a3 7b0b          	ld	a,(OFST+0,sp)
2620  08a5 905f          	clrw	y
2621  08a7 9097          	ld	yl,a
2622  08a9 cd0000        	call	c_idiv
2624  08ac 51            	exgw	x,y
2625  08ad 72fb01        	addw	x,(OFST-10,sp)
2626  08b0 f6            	ld	a,(x)
2627  08b1 6b07          	ld	(OFST-4,sp),a
2628                     ; 659 		*(str+4) =* (ptr1+((Char_Nb+5)%Str_size));
2630  08b3 7b03          	ld	a,(OFST-8,sp)
2631  08b5 5f            	clrw	x
2632  08b6 97            	ld	xl,a
2633  08b7 1c0005        	addw	x,#5
2634  08ba 7b0b          	ld	a,(OFST+0,sp)
2635  08bc 905f          	clrw	y
2636  08be 9097          	ld	yl,a
2637  08c0 cd0000        	call	c_idiv
2639  08c3 51            	exgw	x,y
2640  08c4 72fb01        	addw	x,(OFST-10,sp)
2641  08c7 f6            	ld	a,(x)
2642  08c8 6b08          	ld	(OFST-3,sp),a
2643                     ; 660 		*(str+5) =* (ptr1+((Char_Nb+6)%Str_size));
2645  08ca 7b03          	ld	a,(OFST-8,sp)
2646  08cc 5f            	clrw	x
2647  08cd 97            	ld	xl,a
2648  08ce 1c0006        	addw	x,#6
2649  08d1 7b0b          	ld	a,(OFST+0,sp)
2650  08d3 905f          	clrw	y
2651  08d5 9097          	ld	yl,a
2652  08d7 cd0000        	call	c_idiv
2654  08da 51            	exgw	x,y
2655  08db 72fb01        	addw	x,(OFST-10,sp)
2656  08de f6            	ld	a,(x)
2657  08df 6b09          	ld	(OFST-2,sp),a
2658                     ; 662 		LCD_GLASS_DisplayString(str);
2660  08e1 96            	ldw	x,sp
2661  08e2 1c0004        	addw	x,#OFST-7
2662  08e5 cd0599        	call	_LCD_GLASS_DisplayString
2664                     ; 664 		delay_10us(SCROLL_SPEED_L);
2666  08e8 ae0028        	ldw	x,#40
2667  08eb cd0000        	call	_delay_10us
2669                     ; 665 	} while (++Char_Nb < Str_size && state_machine == STATE_CHECKNDEFMESSAGE); 
2671  08ee 0c03          	inc	(OFST-8,sp)
2672  08f0 7b03          	ld	a,(OFST-8,sp)
2673  08f2 110b          	cp	a,(OFST+0,sp)
2674  08f4 2407          	jruge	L307
2676  08f6 3d00          	tnz	_state_machine
2677  08f8 2603          	jrne	L001
2678  08fa cc085a        	jp	L576
2679  08fd               L001:
2680  08fd               L307:
2681                     ; 667 }
2682  08fd               L47:
2685  08fd 5b0d          	addw	sp,#13
2686  08ff 81            	ret
2741                     	xdef	_LCD_contrast
2742                     	xdef	_NumberMap
2743                     	xdef	_CapLetterMap
2744                     	xdef	_t_bar
2745                     	xref.b	_state_machine
2746                     	xdef	_KeyPressed
2747                     	xdef	_LCD_GLASS_ScrollSentenceNbCarLP
2748                     	xdef	_LCD_GLASS_ScrollSentenceNbCar
2749                     	xdef	_LCD_GLASS_ScrollSentence
2750                     	xdef	_LCD_GLASS_Clear
2751                     	xdef	_LCD_GLASS_DisplayStrDeci
2752                     	xdef	_LCD_GLASS_DisplayString
2753                     	xdef	_LCD_GLASS_WriteChar
2754                     	xdef	_LCD_GLASS_Init
2755                     	xdef	_LCD_bar
2756                     	xref	_LCD_PortMaskConfig
2757                     	xref	_LCD_ContrastConfig
2758                     	xref	_LCD_DeadTimeConfig
2759                     	xref	_LCD_PulseOnDurationConfig
2760                     	xref	_LCD_Cmd
2761                     	xref	_LCD_Init
2762                     	xref	_CLK_PeripheralClockConfig
2763                     	xref	_CLK_RTCClockConfig
2764                     	xref	_delay_10us
2765                     	xref	_delay_ms
2766                     	xref.b	c_x
2767                     	xref.b	c_y
2786                     	xref	c_idiv
2787                     	xref	c_xymvx
2788                     	end
