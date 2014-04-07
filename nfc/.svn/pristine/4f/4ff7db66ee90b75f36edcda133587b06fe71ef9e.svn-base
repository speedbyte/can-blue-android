   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.13 - 06 Dec 2012
   3                     ; Generator (Limited) V4.3.9 - 06 Dec 2012
  45                     ; 46 void EXTI_DeInit(void)
  45                     ; 47 {
  47                     	switch	.text
  48  0000               _EXTI_DeInit:
  52                     ; 48   EXTI->CR1 = EXTI_CR1_RESET_VALUE;
  54  0000 725f50a0      	clr	20640
  55                     ; 49   EXTI->CR2 = EXTI_CR2_RESET_VALUE;
  57  0004 725f50a1      	clr	20641
  58                     ; 50   EXTI->CR3 = EXTI_CR3_RESET_VALUE;
  60  0008 725f50a2      	clr	20642
  61                     ; 51   EXTI->CR4 = EXTI_CR4_RESET_VALUE;
  63  000c 725f50aa      	clr	20650
  64                     ; 52   EXTI->SR1 = 0xFF; /* Setting SR1 bits in order to clear flags */
  66  0010 35ff50a3      	mov	20643,#255
  67                     ; 53   EXTI->SR2 = 0xFF; /* Setting SR2 bits in order to clear flags */
  69  0014 35ff50a4      	mov	20644,#255
  70                     ; 54   EXTI->CONF1 = EXTI_CONF1_RESET_VALUE;
  72  0018 725f50a5      	clr	20645
  73                     ; 55   EXTI->CONF2 = EXTI_CONF2_RESET_VALUE;
  75  001c 725f50ab      	clr	20651
  76                     ; 56 }
  79  0020 81            	ret
 211                     ; 71 void EXTI_SetPortSensitivity(EXTI_Port_TypeDef EXTI_Port,
 211                     ; 72                              EXTI_Trigger_TypeDef EXTI_Trigger)
 211                     ; 73 {
 212                     	switch	.text
 213  0021               _EXTI_SetPortSensitivity:
 215  0021 89            	pushw	x
 216       00000000      OFST:	set	0
 219                     ; 75   assert_param(IS_EXTI_PORT(EXTI_Port));
 221                     ; 76   assert_param(IS_EXTI_TRIGGER(EXTI_Trigger));
 223                     ; 79   if ((EXTI_Port & 0xF0) == 0x00)
 225  0022 9e            	ld	a,xh
 226  0023 a5f0          	bcp	a,#240
 227  0025 2629          	jrne	L77
 228                     ; 82     EXTI->CR3 &= (uint8_t) (~(uint8_t)((uint8_t)0x03 << EXTI_Port));
 230  0027 7b01          	ld	a,(OFST+1,sp)
 231  0029 5f            	clrw	x
 232  002a 97            	ld	xl,a
 233  002b a603          	ld	a,#3
 234  002d 5d            	tnzw	x
 235  002e 2704          	jreq	L01
 236  0030               L21:
 237  0030 48            	sll	a
 238  0031 5a            	decw	x
 239  0032 26fc          	jrne	L21
 240  0034               L01:
 241  0034 43            	cpl	a
 242  0035 c450a2        	and	a,20642
 243  0038 c750a2        	ld	20642,a
 244                     ; 84     EXTI->CR3 |= (uint8_t)((uint8_t)(EXTI_Trigger) << EXTI_Port);
 246  003b 7b01          	ld	a,(OFST+1,sp)
 247  003d 5f            	clrw	x
 248  003e 97            	ld	xl,a
 249  003f 7b02          	ld	a,(OFST+2,sp)
 250  0041 5d            	tnzw	x
 251  0042 2704          	jreq	L41
 252  0044               L61:
 253  0044 48            	sll	a
 254  0045 5a            	decw	x
 255  0046 26fc          	jrne	L61
 256  0048               L41:
 257  0048 ca50a2        	or	a,20642
 258  004b c750a2        	ld	20642,a
 260  004e 202b          	jra	L101
 261  0050               L77:
 262                     ; 89     EXTI->CR4 &= (uint8_t) (~(uint8_t)((uint8_t)0x03 << (EXTI_Port & 0x0F)));
 264  0050 7b01          	ld	a,(OFST+1,sp)
 265  0052 a40f          	and	a,#15
 266  0054 5f            	clrw	x
 267  0055 97            	ld	xl,a
 268  0056 a603          	ld	a,#3
 269  0058 5d            	tnzw	x
 270  0059 2704          	jreq	L02
 271  005b               L22:
 272  005b 48            	sll	a
 273  005c 5a            	decw	x
 274  005d 26fc          	jrne	L22
 275  005f               L02:
 276  005f 43            	cpl	a
 277  0060 c450aa        	and	a,20650
 278  0063 c750aa        	ld	20650,a
 279                     ; 91     EXTI->CR4 |= (uint8_t)(EXTI_Trigger << (EXTI_Port & 0x0F));
 281  0066 7b01          	ld	a,(OFST+1,sp)
 282  0068 a40f          	and	a,#15
 283  006a 5f            	clrw	x
 284  006b 97            	ld	xl,a
 285  006c 7b02          	ld	a,(OFST+2,sp)
 286  006e 5d            	tnzw	x
 287  006f 2704          	jreq	L42
 288  0071               L62:
 289  0071 48            	sll	a
 290  0072 5a            	decw	x
 291  0073 26fc          	jrne	L62
 292  0075               L42:
 293  0075 ca50aa        	or	a,20650
 294  0078 c750aa        	ld	20650,a
 295  007b               L101:
 296                     ; 93 }
 299  007b 85            	popw	x
 300  007c 81            	ret
 408                     ; 108 void EXTI_SetPinSensitivity(EXTI_Pin_TypeDef EXTI_Pin,
 408                     ; 109                             EXTI_Trigger_TypeDef EXTI_Trigger)
 408                     ; 110 {
 409                     	switch	.text
 410  007d               _EXTI_SetPinSensitivity:
 412  007d 89            	pushw	x
 413       00000000      OFST:	set	0
 416                     ; 113   assert_param(IS_EXTI_PINNUM(EXTI_Pin));
 418                     ; 114   assert_param(IS_EXTI_TRIGGER(EXTI_Trigger));
 420                     ; 117   switch (EXTI_Pin)
 422  007e 9e            	ld	a,xh
 424                     ; 151     default:
 424                     ; 152       break;
 425  007f 4d            	tnz	a
 426  0080 272f          	jreq	L301
 427  0082 a002          	sub	a,#2
 428  0084 274a          	jreq	L501
 429  0086 a002          	sub	a,#2
 430  0088 2765          	jreq	L701
 431  008a a002          	sub	a,#2
 432  008c 2603cc010e    	jreq	L111
 433  0091 a00a          	sub	a,#10
 434  0093 2603          	jrne	L27
 435  0095 cc012b        	jp	L311
 436  0098               L27:
 437  0098 a002          	sub	a,#2
 438  009a 2603          	jrne	L47
 439  009c cc014a        	jp	L511
 440  009f               L47:
 441  009f a002          	sub	a,#2
 442  00a1 2603          	jrne	L67
 443  00a3 cc0169        	jp	L711
 444  00a6               L67:
 445  00a6 a002          	sub	a,#2
 446  00a8 2603          	jrne	L001
 447  00aa cc0188        	jp	L121
 448  00ad               L001:
 449  00ad aca501a5      	jpf	L571
 450  00b1               L301:
 451                     ; 119     case EXTI_Pin_0:
 451                     ; 120       EXTI->CR1 &=  (uint8_t)(~EXTI_CR1_P0IS);
 453  00b1 c650a0        	ld	a,20640
 454  00b4 a4fc          	and	a,#252
 455  00b6 c750a0        	ld	20640,a
 456                     ; 121       EXTI->CR1 |= (uint8_t)((uint8_t)(EXTI_Trigger) << EXTI_Pin);
 458  00b9 7b01          	ld	a,(OFST+1,sp)
 459  00bb 5f            	clrw	x
 460  00bc 97            	ld	xl,a
 461  00bd 7b02          	ld	a,(OFST+2,sp)
 462  00bf 5d            	tnzw	x
 463  00c0 2704          	jreq	L23
 464  00c2               L43:
 465  00c2 48            	sll	a
 466  00c3 5a            	decw	x
 467  00c4 26fc          	jrne	L43
 468  00c6               L23:
 469  00c6 ca50a0        	or	a,20640
 470  00c9 c750a0        	ld	20640,a
 471                     ; 122       break;
 473  00cc aca501a5      	jpf	L571
 474  00d0               L501:
 475                     ; 123     case EXTI_Pin_1:
 475                     ; 124       EXTI->CR1 &=  (uint8_t)(~EXTI_CR1_P1IS);
 477  00d0 c650a0        	ld	a,20640
 478  00d3 a4f3          	and	a,#243
 479  00d5 c750a0        	ld	20640,a
 480                     ; 125       EXTI->CR1 |= (uint8_t)((uint8_t)(EXTI_Trigger) << EXTI_Pin);
 482  00d8 7b01          	ld	a,(OFST+1,sp)
 483  00da 5f            	clrw	x
 484  00db 97            	ld	xl,a
 485  00dc 7b02          	ld	a,(OFST+2,sp)
 486  00de 5d            	tnzw	x
 487  00df 2704          	jreq	L63
 488  00e1               L04:
 489  00e1 48            	sll	a
 490  00e2 5a            	decw	x
 491  00e3 26fc          	jrne	L04
 492  00e5               L63:
 493  00e5 ca50a0        	or	a,20640
 494  00e8 c750a0        	ld	20640,a
 495                     ; 126       break;
 497  00eb aca501a5      	jpf	L571
 498  00ef               L701:
 499                     ; 127     case EXTI_Pin_2:
 499                     ; 128       EXTI->CR1 &=  (uint8_t)(~EXTI_CR1_P2IS);
 501  00ef c650a0        	ld	a,20640
 502  00f2 a4cf          	and	a,#207
 503  00f4 c750a0        	ld	20640,a
 504                     ; 129       EXTI->CR1 |= (uint8_t)((uint8_t)(EXTI_Trigger) << EXTI_Pin);
 506  00f7 7b01          	ld	a,(OFST+1,sp)
 507  00f9 5f            	clrw	x
 508  00fa 97            	ld	xl,a
 509  00fb 7b02          	ld	a,(OFST+2,sp)
 510  00fd 5d            	tnzw	x
 511  00fe 2704          	jreq	L24
 512  0100               L44:
 513  0100 48            	sll	a
 514  0101 5a            	decw	x
 515  0102 26fc          	jrne	L44
 516  0104               L24:
 517  0104 ca50a0        	or	a,20640
 518  0107 c750a0        	ld	20640,a
 519                     ; 130       break;
 521  010a aca501a5      	jpf	L571
 522  010e               L111:
 523                     ; 131     case EXTI_Pin_3:
 523                     ; 132       EXTI->CR1 &=  (uint8_t)(~EXTI_CR1_P3IS);
 525  010e c650a0        	ld	a,20640
 526  0111 a43f          	and	a,#63
 527  0113 c750a0        	ld	20640,a
 528                     ; 133       EXTI->CR1 |= (uint8_t)((uint8_t)(EXTI_Trigger) << EXTI_Pin);
 530  0116 7b01          	ld	a,(OFST+1,sp)
 531  0118 5f            	clrw	x
 532  0119 97            	ld	xl,a
 533  011a 7b02          	ld	a,(OFST+2,sp)
 534  011c 5d            	tnzw	x
 535  011d 2704          	jreq	L64
 536  011f               L05:
 537  011f 48            	sll	a
 538  0120 5a            	decw	x
 539  0121 26fc          	jrne	L05
 540  0123               L64:
 541  0123 ca50a0        	or	a,20640
 542  0126 c750a0        	ld	20640,a
 543                     ; 134       break;
 545  0129 207a          	jra	L571
 546  012b               L311:
 547                     ; 135     case EXTI_Pin_4:
 547                     ; 136       EXTI->CR2 &=  (uint8_t)(~EXTI_CR2_P4IS);
 549  012b c650a1        	ld	a,20641
 550  012e a4fc          	and	a,#252
 551  0130 c750a1        	ld	20641,a
 552                     ; 137       EXTI->CR2 |= (uint8_t)((uint8_t)(EXTI_Trigger) << ((uint8_t)EXTI_Pin & (uint8_t)0xEF));
 554  0133 7b01          	ld	a,(OFST+1,sp)
 555  0135 a4ef          	and	a,#239
 556  0137 5f            	clrw	x
 557  0138 97            	ld	xl,a
 558  0139 7b02          	ld	a,(OFST+2,sp)
 559  013b 5d            	tnzw	x
 560  013c 2704          	jreq	L25
 561  013e               L45:
 562  013e 48            	sll	a
 563  013f 5a            	decw	x
 564  0140 26fc          	jrne	L45
 565  0142               L25:
 566  0142 ca50a1        	or	a,20641
 567  0145 c750a1        	ld	20641,a
 568                     ; 138       break;
 570  0148 205b          	jra	L571
 571  014a               L511:
 572                     ; 139     case EXTI_Pin_5:
 572                     ; 140       EXTI->CR2 &=  (uint8_t)(~EXTI_CR2_P5IS);
 574  014a c650a1        	ld	a,20641
 575  014d a4f3          	and	a,#243
 576  014f c750a1        	ld	20641,a
 577                     ; 141       EXTI->CR2 |= (uint8_t)((uint8_t)(EXTI_Trigger) << ((uint8_t)EXTI_Pin & (uint8_t)0xEF));
 579  0152 7b01          	ld	a,(OFST+1,sp)
 580  0154 a4ef          	and	a,#239
 581  0156 5f            	clrw	x
 582  0157 97            	ld	xl,a
 583  0158 7b02          	ld	a,(OFST+2,sp)
 584  015a 5d            	tnzw	x
 585  015b 2704          	jreq	L65
 586  015d               L06:
 587  015d 48            	sll	a
 588  015e 5a            	decw	x
 589  015f 26fc          	jrne	L06
 590  0161               L65:
 591  0161 ca50a1        	or	a,20641
 592  0164 c750a1        	ld	20641,a
 593                     ; 142       break;
 595  0167 203c          	jra	L571
 596  0169               L711:
 597                     ; 143     case EXTI_Pin_6:
 597                     ; 144       EXTI->CR2 &=  (uint8_t)(~EXTI_CR2_P6IS);
 599  0169 c650a1        	ld	a,20641
 600  016c a4cf          	and	a,#207
 601  016e c750a1        	ld	20641,a
 602                     ; 145       EXTI->CR2 |= (uint8_t)((uint8_t)(EXTI_Trigger) << ((uint8_t)EXTI_Pin & (uint8_t)0xEF));
 604  0171 7b01          	ld	a,(OFST+1,sp)
 605  0173 a4ef          	and	a,#239
 606  0175 5f            	clrw	x
 607  0176 97            	ld	xl,a
 608  0177 7b02          	ld	a,(OFST+2,sp)
 609  0179 5d            	tnzw	x
 610  017a 2704          	jreq	L26
 611  017c               L46:
 612  017c 48            	sll	a
 613  017d 5a            	decw	x
 614  017e 26fc          	jrne	L46
 615  0180               L26:
 616  0180 ca50a1        	or	a,20641
 617  0183 c750a1        	ld	20641,a
 618                     ; 146       break;
 620  0186 201d          	jra	L571
 621  0188               L121:
 622                     ; 147     case EXTI_Pin_7:
 622                     ; 148       EXTI->CR2 &=  (uint8_t)(~EXTI_CR2_P7IS);
 624  0188 c650a1        	ld	a,20641
 625  018b a43f          	and	a,#63
 626  018d c750a1        	ld	20641,a
 627                     ; 149       EXTI->CR2 |= (uint8_t)((uint8_t)(EXTI_Trigger) << ((uint8_t)EXTI_Pin & (uint8_t)0xEF));
 629  0190 7b01          	ld	a,(OFST+1,sp)
 630  0192 a4ef          	and	a,#239
 631  0194 5f            	clrw	x
 632  0195 97            	ld	xl,a
 633  0196 7b02          	ld	a,(OFST+2,sp)
 634  0198 5d            	tnzw	x
 635  0199 2704          	jreq	L66
 636  019b               L07:
 637  019b 48            	sll	a
 638  019c 5a            	decw	x
 639  019d 26fc          	jrne	L07
 640  019f               L66:
 641  019f ca50a1        	or	a,20641
 642  01a2 c750a1        	ld	20641,a
 643                     ; 150       break;
 645  01a5               L321:
 646                     ; 151     default:
 646                     ; 152       break;
 648  01a5               L571:
 649                     ; 154 }
 652  01a5 85            	popw	x
 653  01a6 81            	ret
 688                     ; 162 void EXTI_SelectPort(EXTI_Port_TypeDef EXTI_Port)
 688                     ; 163 {
 689                     	switch	.text
 690  01a7               _EXTI_SelectPort:
 692  01a7 88            	push	a
 693       00000000      OFST:	set	0
 696                     ; 165   assert_param(IS_EXTI_PORT(EXTI_Port));
 698                     ; 167   if (EXTI_Port == EXTI_Port_B)
 700  01a8 4d            	tnz	a
 701  01a9 2606          	jrne	L512
 702                     ; 170     EXTI->CONF2 &= (uint8_t) (~EXTI_CONF2_PGBS);
 704  01ab 721b50ab      	bres	20651,#5
 706  01af 2034          	jra	L712
 707  01b1               L512:
 708                     ; 172   else if (EXTI_Port == EXTI_Port_D)
 710  01b1 7b01          	ld	a,(OFST+1,sp)
 711  01b3 a102          	cp	a,#2
 712  01b5 2606          	jrne	L122
 713                     ; 175     EXTI->CONF2 &= (uint8_t) (~EXTI_CONF2_PHDS);
 715  01b7 721d50ab      	bres	20651,#6
 717  01bb 2028          	jra	L712
 718  01bd               L122:
 719                     ; 177   else if (EXTI_Port == EXTI_Port_E)
 721  01bd 7b01          	ld	a,(OFST+1,sp)
 722  01bf a104          	cp	a,#4
 723  01c1 2606          	jrne	L522
 724                     ; 180     EXTI->CONF1 &= (uint8_t) (~EXTI_CONF1_PFES);
 726  01c3 721f50a5      	bres	20645,#7
 728  01c7 201c          	jra	L712
 729  01c9               L522:
 730                     ; 182   else if (EXTI_Port == EXTI_Port_F)
 732  01c9 7b01          	ld	a,(OFST+1,sp)
 733  01cb a106          	cp	a,#6
 734  01cd 2606          	jrne	L132
 735                     ; 185     EXTI->CONF1 |= (uint8_t) (EXTI_CONF1_PFES);
 737  01cf 721e50a5      	bset	20645,#7
 739  01d3 2010          	jra	L712
 740  01d5               L132:
 741                     ; 187   else if (EXTI_Port == EXTI_Port_G)
 743  01d5 7b01          	ld	a,(OFST+1,sp)
 744  01d7 a110          	cp	a,#16
 745  01d9 2606          	jrne	L532
 746                     ; 190     EXTI->CONF2 |= (uint8_t) (EXTI_CONF2_PGBS);
 748  01db 721a50ab      	bset	20651,#5
 750  01df 2004          	jra	L712
 751  01e1               L532:
 752                     ; 195     EXTI->CONF2 |= (uint8_t) (EXTI_CONF2_PHDS);
 754  01e1 721c50ab      	bset	20651,#6
 755  01e5               L712:
 756                     ; 197 }
 759  01e5 84            	pop	a
 760  01e6 81            	ret
 928                     ; 211 void EXTI_SetHalfPortSelection(EXTI_HalfPort_TypeDef EXTI_HalfPort,
 928                     ; 212                                FunctionalState NewState)
 928                     ; 213 {
 929                     	switch	.text
 930  01e7               _EXTI_SetHalfPortSelection:
 932  01e7 89            	pushw	x
 933       00000000      OFST:	set	0
 936                     ; 215   assert_param(IS_EXTI_HALFPORT(EXTI_HalfPort));
 938                     ; 216   assert_param(IS_FUNCTIONAL_STATE(NewState));
 940                     ; 218   if ((EXTI_HalfPort & 0x80) == 0x00)
 942  01e8 9e            	ld	a,xh
 943  01e9 a580          	bcp	a,#128
 944  01eb 2619          	jrne	L723
 945                     ; 220     if (NewState != DISABLE)
 947  01ed 0d02          	tnz	(OFST+2,sp)
 948  01ef 270a          	jreq	L133
 949                     ; 223       EXTI->CONF1 |= (uint8_t)EXTI_HalfPort;
 951  01f1 c650a5        	ld	a,20645
 952  01f4 1a01          	or	a,(OFST+1,sp)
 953  01f6 c750a5        	ld	20645,a
 955  01f9 2026          	jra	L533
 956  01fb               L133:
 957                     ; 228       EXTI->CONF1 &= (uint8_t)(~(uint8_t)EXTI_HalfPort);
 959  01fb 7b01          	ld	a,(OFST+1,sp)
 960  01fd 43            	cpl	a
 961  01fe c450a5        	and	a,20645
 962  0201 c750a5        	ld	20645,a
 963  0204 201b          	jra	L533
 964  0206               L723:
 965                     ; 233     if (NewState != DISABLE)
 967  0206 0d02          	tnz	(OFST+2,sp)
 968  0208 270c          	jreq	L733
 969                     ; 236       EXTI->CONF2 |= (uint8_t)(EXTI_HalfPort & (uint8_t)0x7F);
 971  020a 7b01          	ld	a,(OFST+1,sp)
 972  020c a47f          	and	a,#127
 973  020e ca50ab        	or	a,20651
 974  0211 c750ab        	ld	20651,a
 976  0214 200b          	jra	L533
 977  0216               L733:
 978                     ; 241       EXTI->CONF2 &= (uint8_t)(~(uint8_t) (EXTI_HalfPort & (uint8_t)0x7F));
 980  0216 7b01          	ld	a,(OFST+1,sp)
 981  0218 a47f          	and	a,#127
 982  021a 43            	cpl	a
 983  021b c450ab        	and	a,20651
 984  021e c750ab        	ld	20651,a
 985  0221               L533:
 986                     ; 244 }
 989  0221 85            	popw	x
 990  0222 81            	ret
1036                     ; 252 EXTI_Trigger_TypeDef EXTI_GetPortSensitivity(EXTI_Port_TypeDef EXTI_Port)
1036                     ; 253 {
1037                     	switch	.text
1038  0223               _EXTI_GetPortSensitivity:
1040  0223 88            	push	a
1041  0224 88            	push	a
1042       00000001      OFST:	set	1
1045                     ; 254   uint8_t portsensitivity = 0;
1047                     ; 257   assert_param(IS_EXTI_PORT(EXTI_Port));
1049                     ; 260   if ((EXTI_Port & 0xF0) == 0x00)
1051  0225 a5f0          	bcp	a,#240
1052  0227 2614          	jrne	L563
1053                     ; 263     portsensitivity = (uint8_t)((uint8_t)0x03 & (uint8_t)(EXTI->CR3 >> EXTI_Port));
1055  0229 7b02          	ld	a,(OFST+1,sp)
1056  022b 5f            	clrw	x
1057  022c 97            	ld	xl,a
1058  022d c650a2        	ld	a,20642
1059  0230 5d            	tnzw	x
1060  0231 2704          	jreq	L011
1061  0233               L211:
1062  0233 44            	srl	a
1063  0234 5a            	decw	x
1064  0235 26fc          	jrne	L211
1065  0237               L011:
1066  0237 a403          	and	a,#3
1067  0239 6b01          	ld	(OFST+0,sp),a
1069  023b 2014          	jra	L763
1070  023d               L563:
1071                     ; 269     portsensitivity = (uint8_t)((uint8_t)0x03 & (uint8_t)(EXTI->CR4 >> (EXTI_Port & 0x0F)));
1073  023d 7b02          	ld	a,(OFST+1,sp)
1074  023f a40f          	and	a,#15
1075  0241 5f            	clrw	x
1076  0242 97            	ld	xl,a
1077  0243 c650aa        	ld	a,20650
1078  0246 5d            	tnzw	x
1079  0247 2704          	jreq	L411
1080  0249               L611:
1081  0249 44            	srl	a
1082  024a 5a            	decw	x
1083  024b 26fc          	jrne	L611
1084  024d               L411:
1085  024d a403          	and	a,#3
1086  024f 6b01          	ld	(OFST+0,sp),a
1087  0251               L763:
1088                     ; 272   return((EXTI_Trigger_TypeDef)portsensitivity);
1090  0251 7b01          	ld	a,(OFST+0,sp)
1093  0253 85            	popw	x
1094  0254 81            	ret
1140                     ; 281 EXTI_Trigger_TypeDef EXTI_GetPinSensitivity(EXTI_Pin_TypeDef EXTI_Pin)
1140                     ; 282 {
1141                     	switch	.text
1142  0255               _EXTI_GetPinSensitivity:
1144  0255 88            	push	a
1145       00000001      OFST:	set	1
1148                     ; 283   uint8_t value = 0;
1150  0256 0f01          	clr	(OFST+0,sp)
1151                     ; 286   assert_param(IS_EXTI_PINNUM(EXTI_Pin));
1153                     ; 288   switch (EXTI_Pin)
1156                     ; 314     default:
1156                     ; 315       break;
1157  0258 4d            	tnz	a
1158  0259 271e          	jreq	L173
1159  025b a002          	sub	a,#2
1160  025d 2723          	jreq	L373
1161  025f a002          	sub	a,#2
1162  0261 272a          	jreq	L573
1163  0263 a002          	sub	a,#2
1164  0265 2732          	jreq	L773
1165  0267 a00a          	sub	a,#10
1166  0269 273c          	jreq	L104
1167  026b a002          	sub	a,#2
1168  026d 2741          	jreq	L304
1169  026f a002          	sub	a,#2
1170  0271 2748          	jreq	L504
1171  0273 a002          	sub	a,#2
1172  0275 2750          	jreq	L704
1173  0277 205a          	jra	L734
1174  0279               L173:
1175                     ; 290     case EXTI_Pin_0:
1175                     ; 291       value = (uint8_t)(EXTI->CR1 & EXTI_CR1_P0IS);
1177  0279 c650a0        	ld	a,20640
1178  027c a403          	and	a,#3
1179  027e 6b01          	ld	(OFST+0,sp),a
1180                     ; 292       break;
1182  0280 2051          	jra	L734
1183  0282               L373:
1184                     ; 293     case EXTI_Pin_1:
1184                     ; 294       value = (uint8_t)((uint8_t)(EXTI->CR1 & EXTI_CR1_P1IS) >> EXTI_Pin_1);
1186  0282 c650a0        	ld	a,20640
1187  0285 a40c          	and	a,#12
1188  0287 44            	srl	a
1189  0288 44            	srl	a
1190  0289 6b01          	ld	(OFST+0,sp),a
1191                     ; 295       break;
1193  028b 2046          	jra	L734
1194  028d               L573:
1195                     ; 296     case EXTI_Pin_2:
1195                     ; 297       value = (uint8_t)((uint8_t)(EXTI->CR1 & EXTI_CR1_P2IS) >> EXTI_Pin_2);
1197  028d c650a0        	ld	a,20640
1198  0290 a430          	and	a,#48
1199  0292 4e            	swap	a
1200  0293 a40f          	and	a,#15
1201  0295 6b01          	ld	(OFST+0,sp),a
1202                     ; 298       break;
1204  0297 203a          	jra	L734
1205  0299               L773:
1206                     ; 299     case EXTI_Pin_3:
1206                     ; 300       value = (uint8_t)((uint8_t)(EXTI->CR1 & EXTI_CR1_P3IS) >> EXTI_Pin_3);
1208  0299 c650a0        	ld	a,20640
1209  029c a4c0          	and	a,#192
1210  029e 4e            	swap	a
1211  029f 44            	srl	a
1212  02a0 44            	srl	a
1213  02a1 a403          	and	a,#3
1214  02a3 6b01          	ld	(OFST+0,sp),a
1215                     ; 301       break;
1217  02a5 202c          	jra	L734
1218  02a7               L104:
1219                     ; 302     case EXTI_Pin_4:
1219                     ; 303       value = (uint8_t)(EXTI->CR2 & EXTI_CR2_P4IS);
1221  02a7 c650a1        	ld	a,20641
1222  02aa a403          	and	a,#3
1223  02ac 6b01          	ld	(OFST+0,sp),a
1224                     ; 304       break;
1226  02ae 2023          	jra	L734
1227  02b0               L304:
1228                     ; 305     case EXTI_Pin_5:
1228                     ; 306       value = (uint8_t)((uint8_t)(EXTI->CR2 & EXTI_CR2_P5IS) >> ((uint8_t)EXTI_Pin_5 & (uint8_t)0x0F));
1230  02b0 c650a1        	ld	a,20641
1231  02b3 a40c          	and	a,#12
1232  02b5 44            	srl	a
1233  02b6 44            	srl	a
1234  02b7 6b01          	ld	(OFST+0,sp),a
1235                     ; 307       break;
1237  02b9 2018          	jra	L734
1238  02bb               L504:
1239                     ; 308     case EXTI_Pin_6:
1239                     ; 309       value = (uint8_t)((uint8_t)(EXTI->CR2 & EXTI_CR2_P6IS) >> ((uint8_t)EXTI_Pin_6 & (uint8_t)0x0F));
1241  02bb c650a1        	ld	a,20641
1242  02be a430          	and	a,#48
1243  02c0 4e            	swap	a
1244  02c1 a40f          	and	a,#15
1245  02c3 6b01          	ld	(OFST+0,sp),a
1246                     ; 310       break;
1248  02c5 200c          	jra	L734
1249  02c7               L704:
1250                     ; 311     case EXTI_Pin_7:
1250                     ; 312       value = (uint8_t)((uint8_t)(EXTI->CR2 & EXTI_CR2_P7IS) >> ((uint8_t)EXTI_Pin_7 & (uint8_t)0x0F));
1252  02c7 c650a1        	ld	a,20641
1253  02ca a4c0          	and	a,#192
1254  02cc 4e            	swap	a
1255  02cd 44            	srl	a
1256  02ce 44            	srl	a
1257  02cf a403          	and	a,#3
1258  02d1 6b01          	ld	(OFST+0,sp),a
1259                     ; 313       break;
1261  02d3               L114:
1262                     ; 314     default:
1262                     ; 315       break;
1264  02d3               L734:
1265                     ; 317   return((EXTI_Trigger_TypeDef)value);
1267  02d3 7b01          	ld	a,(OFST+0,sp)
1270  02d5 5b01          	addw	sp,#1
1271  02d7 81            	ret
1441                     ; 327 ITStatus EXTI_GetITStatus(EXTI_IT_TypeDef EXTI_IT)
1441                     ; 328 {
1442                     	switch	.text
1443  02d8               _EXTI_GetITStatus:
1445  02d8 89            	pushw	x
1446  02d9 88            	push	a
1447       00000001      OFST:	set	1
1450                     ; 329   ITStatus status = RESET;
1452                     ; 331   assert_param(IS_EXTI_ITPENDINGBIT(EXTI_IT));
1454                     ; 333   if (((uint16_t)EXTI_IT & (uint16_t)0xFF00) == 0x0100)
1456  02da 01            	rrwa	x,a
1457  02db 9f            	ld	a,xl
1458  02dc a4ff          	and	a,#255
1459  02de 97            	ld	xl,a
1460  02df 4f            	clr	a
1461  02e0 02            	rlwa	x,a
1462  02e1 a30100        	cpw	x,#256
1463  02e4 260b          	jrne	L335
1464                     ; 335     status = (ITStatus)(EXTI->SR2 & (uint8_t)((uint16_t)EXTI_IT & (uint16_t)0x00FF));
1466  02e6 7b03          	ld	a,(OFST+2,sp)
1467  02e8 a4ff          	and	a,#255
1468  02ea c450a4        	and	a,20644
1469  02ed 6b01          	ld	(OFST+0,sp),a
1471  02ef 2009          	jra	L535
1472  02f1               L335:
1473                     ; 339     status = (ITStatus)(EXTI->SR1 & ((uint8_t)((uint16_t)EXTI_IT & (uint16_t)0x00FF)));
1475  02f1 7b03          	ld	a,(OFST+2,sp)
1476  02f3 a4ff          	and	a,#255
1477  02f5 c450a3        	and	a,20643
1478  02f8 6b01          	ld	(OFST+0,sp),a
1479  02fa               L535:
1480                     ; 341   return((ITStatus)status);
1482  02fa 7b01          	ld	a,(OFST+0,sp)
1485  02fc 5b03          	addw	sp,#3
1486  02fe 81            	ret
1531                     ; 350 void EXTI_ClearITPendingBit(EXTI_IT_TypeDef EXTI_IT)
1531                     ; 351 {
1532                     	switch	.text
1533  02ff               _EXTI_ClearITPendingBit:
1535  02ff 89            	pushw	x
1536  0300 89            	pushw	x
1537       00000002      OFST:	set	2
1540                     ; 352   uint16_t tempvalue = 0;
1542                     ; 355   assert_param(IS_EXTI_ITPENDINGBIT(EXTI_IT));
1544                     ; 357   tempvalue = ((uint16_t)EXTI_IT & (uint16_t)0xFF00);
1546  0301 01            	rrwa	x,a
1547  0302 9f            	ld	a,xl
1548  0303 a4ff          	and	a,#255
1549  0305 97            	ld	xl,a
1550  0306 4f            	clr	a
1551  0307 02            	rlwa	x,a
1552  0308 1f01          	ldw	(OFST-1,sp),x
1553  030a 01            	rrwa	x,a
1554                     ; 359   if ( tempvalue == 0x0100)
1556  030b 1e01          	ldw	x,(OFST-1,sp)
1557  030d a30100        	cpw	x,#256
1558  0310 2609          	jrne	L165
1559                     ; 361     EXTI->SR2 = (uint8_t)((uint16_t)EXTI_IT & (uint16_t)0x00FF);
1561  0312 7b04          	ld	a,(OFST+2,sp)
1562  0314 a4ff          	and	a,#255
1563  0316 c750a4        	ld	20644,a
1565  0319 2005          	jra	L365
1566  031b               L165:
1567                     ; 365     EXTI->SR1 = (uint8_t) (EXTI_IT);
1569  031b 7b04          	ld	a,(OFST+2,sp)
1570  031d c750a3        	ld	20643,a
1571  0320               L365:
1572                     ; 367 }
1575  0320 5b04          	addw	sp,#4
1576  0322 81            	ret
1589                     	xdef	_EXTI_ClearITPendingBit
1590                     	xdef	_EXTI_GetITStatus
1591                     	xdef	_EXTI_GetPinSensitivity
1592                     	xdef	_EXTI_GetPortSensitivity
1593                     	xdef	_EXTI_SetHalfPortSelection
1594                     	xdef	_EXTI_SelectPort
1595                     	xdef	_EXTI_SetPinSensitivity
1596                     	xdef	_EXTI_SetPortSensitivity
1597                     	xdef	_EXTI_DeInit
1616                     	end
