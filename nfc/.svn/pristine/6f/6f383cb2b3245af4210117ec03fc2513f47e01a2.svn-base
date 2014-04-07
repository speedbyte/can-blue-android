   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.13 - 06 Dec 2012
   3                     ; Generator (Limited) V4.3.9 - 06 Dec 2012
 201                     ; 101 void I2C_DeInit(I2C_TypeDef* I2Cx)
 201                     ; 102 {
 203                     	switch	.text
 204  0000               _I2C_DeInit:
 208                     ; 103   I2Cx->CR1 = I2C_CR1_RESET_VALUE;
 210  0000 7f            	clr	(x)
 211                     ; 104   I2Cx->CR2 = I2C_CR2_RESET_VALUE;
 213  0001 6f01          	clr	(1,x)
 214                     ; 105   I2Cx->FREQR = I2C_FREQR_RESET_VALUE;
 216  0003 6f02          	clr	(2,x)
 217                     ; 106   I2Cx->OARL = I2C_OARL_RESET_VALUE;
 219  0005 6f03          	clr	(3,x)
 220                     ; 107   I2Cx->OARH = I2C_OARH_RESET_VALUE;
 222  0007 6f04          	clr	(4,x)
 223                     ; 108   I2Cx->OAR2 = I2C_OAR2_RESET_VALUE;
 225  0009 6f05          	clr	(5,x)
 226                     ; 109   I2Cx->ITR = I2C_ITR_RESET_VALUE;
 228  000b 6f0a          	clr	(10,x)
 229                     ; 110   I2Cx->CCRL = I2C_CCRL_RESET_VALUE;
 231  000d 6f0b          	clr	(11,x)
 232                     ; 111   I2Cx->CCRH = I2C_CCRH_RESET_VALUE;
 234  000f 6f0c          	clr	(12,x)
 235                     ; 112   I2Cx->TRISER = I2C_TRISER_RESET_VALUE;
 237  0011 a602          	ld	a,#2
 238  0013 e70d          	ld	(13,x),a
 239                     ; 113 }
 242  0015 81            	ret
 466                     .const:	section	.text
 467  0000               L01:
 468  0000 000f4240      	dc.l	1000000
 469  0004               L21:
 470  0004 000186a1      	dc.l	100001
 471  0008               L41:
 472  0008 00000004      	dc.l	4
 473                     ; 133 void I2C_Init(I2C_TypeDef* I2Cx, uint32_t OutputClockFrequency, uint16_t OwnAddress,
 473                     ; 134               I2C_Mode_TypeDef I2C_Mode, I2C_DutyCycle_TypeDef I2C_DutyCycle,
 473                     ; 135               I2C_Ack_TypeDef I2C_Ack, I2C_AcknowledgedAddress_TypeDef I2C_AcknowledgedAddress)
 473                     ; 136 {
 474                     	switch	.text
 475  0016               _I2C_Init:
 477  0016 89            	pushw	x
 478  0017 520c          	subw	sp,#12
 479       0000000c      OFST:	set	12
 482                     ; 137   uint32_t result = 0x0004;
 484                     ; 138   uint16_t tmpval = 0;
 486                     ; 139   uint8_t tmpccrh = 0;
 488  0019 0f07          	clr	(OFST-5,sp)
 489                     ; 140   uint8_t input_clock = 0;
 491                     ; 143   assert_param(IS_I2C_MODE(I2C_Mode));
 493                     ; 144   assert_param(IS_I2C_ACK_STATE(I2C_Ack));
 495                     ; 145   assert_param(IS_I2C_ACKNOWLEDGE_ADDRESS(I2C_AcknowledgedAddress));
 497                     ; 146   assert_param(IS_I2C_DUTY_CYCLE(I2C_DutyCycle));
 499                     ; 147   assert_param(IS_I2C_OWN_ADDRESS(OwnAddress));
 501                     ; 148   assert_param(IS_I2C_OUTPUT_CLOCK_FREQ(OutputClockFrequency));
 503                     ; 152   input_clock = (uint8_t) (CLK_GetClockFreq() / 1000000);
 505  001b cd0000        	call	_CLK_GetClockFreq
 507  001e ae0000        	ldw	x,#L01
 508  0021 cd0000        	call	c_ludv
 510  0024 b603          	ld	a,c_lreg+3
 511  0026 6b08          	ld	(OFST-4,sp),a
 512                     ; 156   I2Cx->FREQR &= (uint8_t)(~I2C_FREQR_FREQ);
 514  0028 1e0d          	ldw	x,(OFST+1,sp)
 515  002a e602          	ld	a,(2,x)
 516  002c a4c0          	and	a,#192
 517  002e e702          	ld	(2,x),a
 518                     ; 158   I2Cx->FREQR |= input_clock;
 520  0030 1e0d          	ldw	x,(OFST+1,sp)
 521  0032 e602          	ld	a,(2,x)
 522  0034 1a08          	or	a,(OFST-4,sp)
 523  0036 e702          	ld	(2,x),a
 524                     ; 162   I2Cx->CR1 &= (uint8_t)(~I2C_CR1_PE);
 526  0038 1e0d          	ldw	x,(OFST+1,sp)
 527  003a f6            	ld	a,(x)
 528  003b a4fe          	and	a,#254
 529  003d f7            	ld	(x),a
 530                     ; 165   I2Cx->CCRH &= (uint8_t)(~(I2C_CCRH_FS | I2C_CCRH_DUTY | I2C_CCRH_CCR));
 532  003e 1e0d          	ldw	x,(OFST+1,sp)
 533  0040 e60c          	ld	a,(12,x)
 534  0042 a430          	and	a,#48
 535  0044 e70c          	ld	(12,x),a
 536                     ; 166   I2Cx->CCRL &= (uint8_t)(~I2C_CCRL_CCR);
 538  0046 1e0d          	ldw	x,(OFST+1,sp)
 539  0048 6f0b          	clr	(11,x)
 540                     ; 169   if (OutputClockFrequency > I2C_MAX_STANDARD_FREQ) /* FAST MODE */
 542  004a 96            	ldw	x,sp
 543  004b 1c0011        	addw	x,#OFST+5
 544  004e cd0000        	call	c_ltor
 546  0051 ae0004        	ldw	x,#L21
 547  0054 cd0000        	call	c_lcmp
 549  0057 2403          	jruge	L61
 550  0059 cc00f7        	jp	L362
 551  005c               L61:
 552                     ; 172     tmpccrh = I2C_CCRH_FS;
 554  005c a680          	ld	a,#128
 555  005e 6b07          	ld	(OFST-5,sp),a
 556                     ; 174     if (I2C_DutyCycle == I2C_DutyCycle_2)
 558  0060 0d18          	tnz	(OFST+12,sp)
 559  0062 2633          	jrne	L562
 560                     ; 177       result = (uint32_t) ((input_clock * 1000000) / (OutputClockFrequency * 3));
 562  0064 96            	ldw	x,sp
 563  0065 1c0011        	addw	x,#OFST+5
 564  0068 cd0000        	call	c_ltor
 566  006b a603          	ld	a,#3
 567  006d cd0000        	call	c_smul
 569  0070 96            	ldw	x,sp
 570  0071 1c0001        	addw	x,#OFST-11
 571  0074 cd0000        	call	c_rtol
 573  0077 7b08          	ld	a,(OFST-4,sp)
 574  0079 b703          	ld	c_lreg+3,a
 575  007b 3f02          	clr	c_lreg+2
 576  007d 3f01          	clr	c_lreg+1
 577  007f 3f00          	clr	c_lreg
 578  0081 ae0000        	ldw	x,#L01
 579  0084 cd0000        	call	c_lmul
 581  0087 96            	ldw	x,sp
 582  0088 1c0001        	addw	x,#OFST-11
 583  008b cd0000        	call	c_ludv
 585  008e 96            	ldw	x,sp
 586  008f 1c0009        	addw	x,#OFST-3
 587  0092 cd0000        	call	c_rtol
 590  0095 2037          	jra	L762
 591  0097               L562:
 592                     ; 182       result = (uint32_t) ((input_clock * 1000000) / (OutputClockFrequency * 25));
 594  0097 96            	ldw	x,sp
 595  0098 1c0011        	addw	x,#OFST+5
 596  009b cd0000        	call	c_ltor
 598  009e a619          	ld	a,#25
 599  00a0 cd0000        	call	c_smul
 601  00a3 96            	ldw	x,sp
 602  00a4 1c0001        	addw	x,#OFST-11
 603  00a7 cd0000        	call	c_rtol
 605  00aa 7b08          	ld	a,(OFST-4,sp)
 606  00ac b703          	ld	c_lreg+3,a
 607  00ae 3f02          	clr	c_lreg+2
 608  00b0 3f01          	clr	c_lreg+1
 609  00b2 3f00          	clr	c_lreg
 610  00b4 ae0000        	ldw	x,#L01
 611  00b7 cd0000        	call	c_lmul
 613  00ba 96            	ldw	x,sp
 614  00bb 1c0001        	addw	x,#OFST-11
 615  00be cd0000        	call	c_ludv
 617  00c1 96            	ldw	x,sp
 618  00c2 1c0009        	addw	x,#OFST-3
 619  00c5 cd0000        	call	c_rtol
 621                     ; 184       tmpccrh |= I2C_CCRH_DUTY;
 623  00c8 7b07          	ld	a,(OFST-5,sp)
 624  00ca aa40          	or	a,#64
 625  00cc 6b07          	ld	(OFST-5,sp),a
 626  00ce               L762:
 627                     ; 188     if (result < (uint16_t)0x01)
 629  00ce 96            	ldw	x,sp
 630  00cf 1c0009        	addw	x,#OFST-3
 631  00d2 cd0000        	call	c_lzmp
 633  00d5 260a          	jrne	L172
 634                     ; 191       result = (uint16_t)0x0001;
 636  00d7 ae0001        	ldw	x,#1
 637  00da 1f0b          	ldw	(OFST-1,sp),x
 638  00dc ae0000        	ldw	x,#0
 639  00df 1f09          	ldw	(OFST-3,sp),x
 640  00e1               L172:
 641                     ; 197     tmpval = ((input_clock * 3) / 10) + 1;
 643  00e1 7b08          	ld	a,(OFST-4,sp)
 644  00e3 97            	ld	xl,a
 645  00e4 a603          	ld	a,#3
 646  00e6 42            	mul	x,a
 647  00e7 a60a          	ld	a,#10
 648  00e9 cd0000        	call	c_sdivx
 650  00ec 5c            	incw	x
 651  00ed 1f05          	ldw	(OFST-7,sp),x
 652                     ; 198     I2Cx->TRISER = (uint8_t)tmpval;
 654  00ef 7b06          	ld	a,(OFST-6,sp)
 655  00f1 1e0d          	ldw	x,(OFST+1,sp)
 656  00f3 e70d          	ld	(13,x),a
 658  00f5 205c          	jra	L372
 659  00f7               L362:
 660                     ; 205     result = (uint16_t)((input_clock * 1000000) / (OutputClockFrequency << (uint8_t)1));
 662  00f7 96            	ldw	x,sp
 663  00f8 1c0011        	addw	x,#OFST+5
 664  00fb cd0000        	call	c_ltor
 666  00fe 3803          	sll	c_lreg+3
 667  0100 3902          	rlc	c_lreg+2
 668  0102 3901          	rlc	c_lreg+1
 669  0104 3900          	rlc	c_lreg
 670  0106 96            	ldw	x,sp
 671  0107 1c0001        	addw	x,#OFST-11
 672  010a cd0000        	call	c_rtol
 674  010d 7b08          	ld	a,(OFST-4,sp)
 675  010f b703          	ld	c_lreg+3,a
 676  0111 3f02          	clr	c_lreg+2
 677  0113 3f01          	clr	c_lreg+1
 678  0115 3f00          	clr	c_lreg
 679  0117 ae0000        	ldw	x,#L01
 680  011a cd0000        	call	c_lmul
 682  011d 96            	ldw	x,sp
 683  011e 1c0001        	addw	x,#OFST-11
 684  0121 cd0000        	call	c_ludv
 686  0124 b602          	ld	a,c_lreg+2
 687  0126 97            	ld	xl,a
 688  0127 b603          	ld	a,c_lreg+3
 689  0129 cd0000        	call	c_uitol
 691  012c 96            	ldw	x,sp
 692  012d 1c0009        	addw	x,#OFST-3
 693  0130 cd0000        	call	c_rtol
 695                     ; 208     if (result < (uint16_t)0x0004)
 697  0133 96            	ldw	x,sp
 698  0134 1c0009        	addw	x,#OFST-3
 699  0137 cd0000        	call	c_ltor
 701  013a ae0008        	ldw	x,#L41
 702  013d cd0000        	call	c_lcmp
 704  0140 240a          	jruge	L572
 705                     ; 211       result = (uint16_t)0x0004;
 707  0142 ae0004        	ldw	x,#4
 708  0145 1f0b          	ldw	(OFST-1,sp),x
 709  0147 ae0000        	ldw	x,#0
 710  014a 1f09          	ldw	(OFST-3,sp),x
 711  014c               L572:
 712                     ; 217     I2Cx->TRISER = (uint8_t)((uint8_t)input_clock + (uint8_t)1);
 714  014c 7b08          	ld	a,(OFST-4,sp)
 715  014e 4c            	inc	a
 716  014f 1e0d          	ldw	x,(OFST+1,sp)
 717  0151 e70d          	ld	(13,x),a
 718  0153               L372:
 719                     ; 222   I2Cx->CCRL = (uint8_t)result;
 721  0153 7b0c          	ld	a,(OFST+0,sp)
 722  0155 1e0d          	ldw	x,(OFST+1,sp)
 723  0157 e70b          	ld	(11,x),a
 724                     ; 223   I2Cx->CCRH = (uint8_t)((uint8_t)((uint8_t)((uint8_t)result >> 8) & I2C_CCRH_CCR) | tmpccrh);
 726  0159 7b07          	ld	a,(OFST-5,sp)
 727  015b 1e0d          	ldw	x,(OFST+1,sp)
 728  015d e70c          	ld	(12,x),a
 729                     ; 226   I2Cx->CR1 |= (uint8_t)(I2C_CR1_PE | I2C_Mode);
 731  015f 1e0d          	ldw	x,(OFST+1,sp)
 732  0161 7b17          	ld	a,(OFST+11,sp)
 733  0163 aa01          	or	a,#1
 734  0165 fa            	or	a,(x)
 735  0166 f7            	ld	(x),a
 736                     ; 229   I2Cx->CR2 |= (uint8_t)I2C_Ack;
 738  0167 1e0d          	ldw	x,(OFST+1,sp)
 739  0169 e601          	ld	a,(1,x)
 740  016b 1a19          	or	a,(OFST+13,sp)
 741  016d e701          	ld	(1,x),a
 742                     ; 232   I2Cx->OARL = (uint8_t)(OwnAddress);
 744  016f 7b16          	ld	a,(OFST+10,sp)
 745  0171 1e0d          	ldw	x,(OFST+1,sp)
 746  0173 e703          	ld	(3,x),a
 747                     ; 233   I2Cx->OARH = (uint8_t)((uint8_t)(I2C_AcknowledgedAddress | I2C_OARH_ADDCONF ) | \
 747                     ; 234                          (uint8_t)((uint16_t)( (uint16_t)OwnAddress &  (uint16_t)0x0300) >> 7));
 749  0175 7b15          	ld	a,(OFST+9,sp)
 750  0177 97            	ld	xl,a
 751  0178 7b16          	ld	a,(OFST+10,sp)
 752  017a 9f            	ld	a,xl
 753  017b a403          	and	a,#3
 754  017d 97            	ld	xl,a
 755  017e 4f            	clr	a
 756  017f 02            	rlwa	x,a
 757  0180 4f            	clr	a
 758  0181 01            	rrwa	x,a
 759  0182 48            	sll	a
 760  0183 59            	rlcw	x
 761  0184 9f            	ld	a,xl
 762  0185 6b04          	ld	(OFST-8,sp),a
 763  0187 7b1a          	ld	a,(OFST+14,sp)
 764  0189 aa40          	or	a,#64
 765  018b 1a04          	or	a,(OFST-8,sp)
 766  018d 1e0d          	ldw	x,(OFST+1,sp)
 767  018f e704          	ld	(4,x),a
 768                     ; 235 }
 771  0191 5b0e          	addw	sp,#14
 772  0193 81            	ret
 839                     ; 244 void I2C_Cmd(I2C_TypeDef* I2Cx, FunctionalState NewState)
 839                     ; 245 {
 840                     	switch	.text
 841  0194               _I2C_Cmd:
 843  0194 89            	pushw	x
 844       00000000      OFST:	set	0
 847                     ; 248   assert_param(IS_FUNCTIONAL_STATE(NewState));
 849                     ; 250   if (NewState != DISABLE)
 851  0195 0d05          	tnz	(OFST+5,sp)
 852  0197 2706          	jreq	L333
 853                     ; 253     I2Cx->CR1 |= I2C_CR1_PE;
 855  0199 f6            	ld	a,(x)
 856  019a aa01          	or	a,#1
 857  019c f7            	ld	(x),a
 859  019d 2006          	jra	L533
 860  019f               L333:
 861                     ; 258     I2Cx->CR1 &= (uint8_t)(~I2C_CR1_PE);
 863  019f 1e01          	ldw	x,(OFST+1,sp)
 864  01a1 f6            	ld	a,(x)
 865  01a2 a4fe          	and	a,#254
 866  01a4 f7            	ld	(x),a
 867  01a5               L533:
 868                     ; 260 }
 871  01a5 85            	popw	x
 872  01a6 81            	ret
1061                     ; 270 void I2C_ITConfig(I2C_TypeDef* I2Cx, I2C_IT_TypeDef I2C_IT, FunctionalState NewState)
1061                     ; 271 {
1062                     	switch	.text
1063  01a7               _I2C_ITConfig:
1065  01a7 89            	pushw	x
1066       00000000      OFST:	set	0
1069                     ; 273   assert_param(IS_I2C_CONFIG_IT(I2C_IT));
1071                     ; 274   assert_param(IS_FUNCTIONAL_STATE(NewState));
1073                     ; 276   if (NewState != DISABLE)
1075  01a8 0d07          	tnz	(OFST+7,sp)
1076  01aa 2708          	jreq	L734
1077                     ; 279     I2Cx->ITR |= (uint8_t)I2C_IT;
1079  01ac e60a          	ld	a,(10,x)
1080  01ae 1a06          	or	a,(OFST+6,sp)
1081  01b0 e70a          	ld	(10,x),a
1083  01b2 2009          	jra	L144
1084  01b4               L734:
1085                     ; 284     I2Cx->ITR &= (uint8_t)(~(uint8_t)I2C_IT);
1087  01b4 1e01          	ldw	x,(OFST+1,sp)
1088  01b6 7b06          	ld	a,(OFST+6,sp)
1089  01b8 43            	cpl	a
1090  01b9 e40a          	and	a,(10,x)
1091  01bb e70a          	ld	(10,x),a
1092  01bd               L144:
1093                     ; 286 }
1096  01bd 85            	popw	x
1097  01be 81            	ret
1144                     ; 294 void I2C_DMACmd(I2C_TypeDef* I2Cx, FunctionalState NewState)
1144                     ; 295 {
1145                     	switch	.text
1146  01bf               _I2C_DMACmd:
1148  01bf 89            	pushw	x
1149       00000000      OFST:	set	0
1152                     ; 297   assert_param(IS_FUNCTIONAL_STATE(NewState));
1154                     ; 299   if (NewState != DISABLE)
1156  01c0 0d05          	tnz	(OFST+5,sp)
1157  01c2 2708          	jreq	L764
1158                     ; 302     I2Cx->ITR |= I2C_ITR_DMAEN;
1160  01c4 e60a          	ld	a,(10,x)
1161  01c6 aa08          	or	a,#8
1162  01c8 e70a          	ld	(10,x),a
1164  01ca 2008          	jra	L174
1165  01cc               L764:
1166                     ; 307     I2Cx->ITR &= (uint8_t)(~I2C_ITR_DMAEN);
1168  01cc 1e01          	ldw	x,(OFST+1,sp)
1169  01ce e60a          	ld	a,(10,x)
1170  01d0 a4f7          	and	a,#247
1171  01d2 e70a          	ld	(10,x),a
1172  01d4               L174:
1173                     ; 309 }
1176  01d4 85            	popw	x
1177  01d5 81            	ret
1225                     ; 318 void I2C_DMALastTransferCmd(I2C_TypeDef* I2Cx, FunctionalState NewState)
1225                     ; 319 {
1226                     	switch	.text
1227  01d6               _I2C_DMALastTransferCmd:
1229  01d6 89            	pushw	x
1230       00000000      OFST:	set	0
1233                     ; 321   assert_param(IS_FUNCTIONAL_STATE(NewState));
1235                     ; 323   if (NewState != DISABLE)
1237  01d7 0d05          	tnz	(OFST+5,sp)
1238  01d9 2708          	jreq	L715
1239                     ; 326     I2Cx->ITR |= I2C_ITR_LAST;
1241  01db e60a          	ld	a,(10,x)
1242  01dd aa10          	or	a,#16
1243  01df e70a          	ld	(10,x),a
1245  01e1 2008          	jra	L125
1246  01e3               L715:
1247                     ; 331     I2Cx->ITR &= (uint8_t)(~I2C_ITR_LAST);
1249  01e3 1e01          	ldw	x,(OFST+1,sp)
1250  01e5 e60a          	ld	a,(10,x)
1251  01e7 a4ef          	and	a,#239
1252  01e9 e70a          	ld	(10,x),a
1253  01eb               L125:
1254                     ; 333 }
1257  01eb 85            	popw	x
1258  01ec 81            	ret
1305                     ; 342 void I2C_GeneralCallCmd(I2C_TypeDef* I2Cx, FunctionalState NewState)
1305                     ; 343 {
1306                     	switch	.text
1307  01ed               _I2C_GeneralCallCmd:
1309  01ed 89            	pushw	x
1310       00000000      OFST:	set	0
1313                     ; 346   assert_param(IS_FUNCTIONAL_STATE(NewState));
1315                     ; 348   if (NewState != DISABLE)
1317  01ee 0d05          	tnz	(OFST+5,sp)
1318  01f0 2706          	jreq	L745
1319                     ; 351     I2Cx->CR1 |= I2C_CR1_ENGC;
1321  01f2 f6            	ld	a,(x)
1322  01f3 aa40          	or	a,#64
1323  01f5 f7            	ld	(x),a
1325  01f6 2006          	jra	L155
1326  01f8               L745:
1327                     ; 356     I2Cx->CR1 &= (uint8_t)(~I2C_CR1_ENGC);
1329  01f8 1e01          	ldw	x,(OFST+1,sp)
1330  01fa f6            	ld	a,(x)
1331  01fb a4bf          	and	a,#191
1332  01fd f7            	ld	(x),a
1333  01fe               L155:
1334                     ; 358 }
1337  01fe 85            	popw	x
1338  01ff 81            	ret
1385                     ; 369 void I2C_GenerateSTART(I2C_TypeDef* I2Cx, FunctionalState NewState)
1385                     ; 370 {
1386                     	switch	.text
1387  0200               _I2C_GenerateSTART:
1389  0200 89            	pushw	x
1390       00000000      OFST:	set	0
1393                     ; 373   assert_param(IS_FUNCTIONAL_STATE(NewState));
1395                     ; 375   if (NewState != DISABLE)
1397  0201 0d05          	tnz	(OFST+5,sp)
1398  0203 2708          	jreq	L775
1399                     ; 378     I2Cx->CR2 |= I2C_CR2_START;
1401  0205 e601          	ld	a,(1,x)
1402  0207 aa01          	or	a,#1
1403  0209 e701          	ld	(1,x),a
1405  020b 2008          	jra	L106
1406  020d               L775:
1407                     ; 383     I2Cx->CR2 &= (uint8_t)(~I2C_CR2_START);
1409  020d 1e01          	ldw	x,(OFST+1,sp)
1410  020f e601          	ld	a,(1,x)
1411  0211 a4fe          	and	a,#254
1412  0213 e701          	ld	(1,x),a
1413  0215               L106:
1414                     ; 385 }
1417  0215 85            	popw	x
1418  0216 81            	ret
1465                     ; 394 void I2C_GenerateSTOP(I2C_TypeDef* I2Cx, FunctionalState NewState)
1465                     ; 395 {
1466                     	switch	.text
1467  0217               _I2C_GenerateSTOP:
1469  0217 89            	pushw	x
1470       00000000      OFST:	set	0
1473                     ; 398   assert_param(IS_FUNCTIONAL_STATE(NewState));
1475                     ; 400   if (NewState != DISABLE)
1477  0218 0d05          	tnz	(OFST+5,sp)
1478  021a 2708          	jreq	L726
1479                     ; 403     I2Cx->CR2 |= I2C_CR2_STOP;
1481  021c e601          	ld	a,(1,x)
1482  021e aa02          	or	a,#2
1483  0220 e701          	ld	(1,x),a
1485  0222 2008          	jra	L136
1486  0224               L726:
1487                     ; 408     I2Cx->CR2 &= (uint8_t)(~I2C_CR2_STOP);
1489  0224 1e01          	ldw	x,(OFST+1,sp)
1490  0226 e601          	ld	a,(1,x)
1491  0228 a4fd          	and	a,#253
1492  022a e701          	ld	(1,x),a
1493  022c               L136:
1494                     ; 410 }
1497  022c 85            	popw	x
1498  022d 81            	ret
1546                     ; 419 void I2C_SoftwareResetCmd(I2C_TypeDef* I2Cx, FunctionalState NewState)
1546                     ; 420 {
1547                     	switch	.text
1548  022e               _I2C_SoftwareResetCmd:
1550  022e 89            	pushw	x
1551       00000000      OFST:	set	0
1554                     ; 422   assert_param(IS_FUNCTIONAL_STATE(NewState));
1556                     ; 424   if (NewState != DISABLE)
1558  022f 0d05          	tnz	(OFST+5,sp)
1559  0231 2708          	jreq	L756
1560                     ; 427     I2Cx->CR2 |= I2C_CR2_SWRST;
1562  0233 e601          	ld	a,(1,x)
1563  0235 aa80          	or	a,#128
1564  0237 e701          	ld	(1,x),a
1566  0239 2008          	jra	L166
1567  023b               L756:
1568                     ; 432     I2Cx->CR2 &= (uint8_t)(~I2C_CR2_SWRST);
1570  023b 1e01          	ldw	x,(OFST+1,sp)
1571  023d e601          	ld	a,(1,x)
1572  023f a47f          	and	a,#127
1573  0241 e701          	ld	(1,x),a
1574  0243               L166:
1575                     ; 434 }
1578  0243 85            	popw	x
1579  0244 81            	ret
1627                     ; 443 void I2C_StretchClockCmd(I2C_TypeDef* I2Cx, FunctionalState NewState)
1627                     ; 444 {
1628                     	switch	.text
1629  0245               _I2C_StretchClockCmd:
1631  0245 89            	pushw	x
1632       00000000      OFST:	set	0
1635                     ; 446   assert_param(IS_FUNCTIONAL_STATE(NewState));
1637                     ; 448   if (NewState != DISABLE)
1639  0246 0d05          	tnz	(OFST+5,sp)
1640  0248 2706          	jreq	L707
1641                     ; 451     I2Cx->CR1 &= (uint8_t)(~I2C_CR1_NOSTRETCH);
1643  024a f6            	ld	a,(x)
1644  024b a47f          	and	a,#127
1645  024d f7            	ld	(x),a
1647  024e 2006          	jra	L117
1648  0250               L707:
1649                     ; 457     I2Cx->CR1 |= I2C_CR1_NOSTRETCH;
1651  0250 1e01          	ldw	x,(OFST+1,sp)
1652  0252 f6            	ld	a,(x)
1653  0253 aa80          	or	a,#128
1654  0255 f7            	ld	(x),a
1655  0256               L117:
1656                     ; 459 }
1659  0256 85            	popw	x
1660  0257 81            	ret
1707                     ; 468 void I2C_ARPCmd(I2C_TypeDef* I2Cx, FunctionalState NewState)
1707                     ; 469 {
1708                     	switch	.text
1709  0258               _I2C_ARPCmd:
1711  0258 89            	pushw	x
1712       00000000      OFST:	set	0
1715                     ; 471   assert_param(IS_FUNCTIONAL_STATE(NewState));
1717                     ; 473   if (NewState != DISABLE)
1719  0259 0d05          	tnz	(OFST+5,sp)
1720  025b 2706          	jreq	L737
1721                     ; 476     I2Cx->CR1 |= I2C_CR1_ARP;
1723  025d f6            	ld	a,(x)
1724  025e aa10          	or	a,#16
1725  0260 f7            	ld	(x),a
1727  0261 2006          	jra	L147
1728  0263               L737:
1729                     ; 482     I2Cx->CR1 &= (uint8_t)(~I2C_CR1_ARP);
1731  0263 1e01          	ldw	x,(OFST+1,sp)
1732  0265 f6            	ld	a,(x)
1733  0266 a4ef          	and	a,#239
1734  0268 f7            	ld	(x),a
1735  0269               L147:
1736                     ; 484 }
1739  0269 85            	popw	x
1740  026a 81            	ret
1788                     ; 493 void I2C_AcknowledgeConfig(I2C_TypeDef* I2Cx, FunctionalState NewState)
1788                     ; 494 {
1789                     	switch	.text
1790  026b               _I2C_AcknowledgeConfig:
1792  026b 89            	pushw	x
1793       00000000      OFST:	set	0
1796                     ; 496   assert_param(IS_FUNCTIONAL_STATE(NewState));
1798                     ; 498   if (NewState != DISABLE)
1800  026c 0d05          	tnz	(OFST+5,sp)
1801  026e 2708          	jreq	L767
1802                     ; 501     I2Cx->CR2 |= I2C_CR2_ACK;
1804  0270 e601          	ld	a,(1,x)
1805  0272 aa04          	or	a,#4
1806  0274 e701          	ld	(1,x),a
1808  0276 2008          	jra	L177
1809  0278               L767:
1810                     ; 506     I2Cx->CR2 &= (uint8_t)(~I2C_CR2_ACK);
1812  0278 1e01          	ldw	x,(OFST+1,sp)
1813  027a e601          	ld	a,(1,x)
1814  027c a4fb          	and	a,#251
1815  027e e701          	ld	(1,x),a
1816  0280               L177:
1817                     ; 508 }
1820  0280 85            	popw	x
1821  0281 81            	ret
1877                     ; 516 void I2C_OwnAddress2Config(I2C_TypeDef* I2Cx, uint8_t Address)
1877                     ; 517 {
1878                     	switch	.text
1879  0282               _I2C_OwnAddress2Config:
1881  0282 89            	pushw	x
1882  0283 88            	push	a
1883       00000001      OFST:	set	1
1886                     ; 518   uint8_t tmpreg = 0;
1888                     ; 521   tmpreg = I2Cx->OAR2;
1890  0284 e605          	ld	a,(5,x)
1891  0286 6b01          	ld	(OFST+0,sp),a
1892                     ; 524   tmpreg &= (uint8_t)(~I2C_OAR2_ADD2);
1894  0288 7b01          	ld	a,(OFST+0,sp)
1895  028a a401          	and	a,#1
1896  028c 6b01          	ld	(OFST+0,sp),a
1897                     ; 527   tmpreg |= (uint8_t) ((uint8_t)Address & (uint8_t)0xFE);
1899  028e 7b06          	ld	a,(OFST+5,sp)
1900  0290 a4fe          	and	a,#254
1901  0292 1a01          	or	a,(OFST+0,sp)
1902  0294 6b01          	ld	(OFST+0,sp),a
1903                     ; 530   I2Cx->OAR2 = tmpreg;
1905  0296 7b01          	ld	a,(OFST+0,sp)
1906  0298 1e02          	ldw	x,(OFST+1,sp)
1907  029a e705          	ld	(5,x),a
1908                     ; 531 }
1911  029c 5b03          	addw	sp,#3
1912  029e 81            	ret
1959                     ; 540 void I2C_DualAddressCmd(I2C_TypeDef* I2Cx, FunctionalState NewState)
1959                     ; 541 {
1960                     	switch	.text
1961  029f               _I2C_DualAddressCmd:
1963  029f 89            	pushw	x
1964       00000000      OFST:	set	0
1967                     ; 543   assert_param(IS_FUNCTIONAL_STATE(NewState));
1969                     ; 545   if (NewState != DISABLE)
1971  02a0 0d05          	tnz	(OFST+5,sp)
1972  02a2 2708          	jreq	L7401
1973                     ; 548     I2Cx->OAR2 |= I2C_OAR2_ENDUAL;
1975  02a4 e605          	ld	a,(5,x)
1976  02a6 aa01          	or	a,#1
1977  02a8 e705          	ld	(5,x),a
1979  02aa 2008          	jra	L1501
1980  02ac               L7401:
1981                     ; 553     I2Cx->OAR2 &= (uint8_t)(~I2C_OAR2_ENDUAL);
1983  02ac 1e01          	ldw	x,(OFST+1,sp)
1984  02ae e605          	ld	a,(5,x)
1985  02b0 a4fe          	and	a,#254
1986  02b2 e705          	ld	(5,x),a
1987  02b4               L1501:
1988                     ; 555 }
1991  02b4 85            	popw	x
1992  02b5 81            	ret
2062                     ; 565 void I2C_AckPositionConfig(I2C_TypeDef* I2Cx, I2C_AckPosition_TypeDef I2C_AckPosition)
2062                     ; 566 {
2063                     	switch	.text
2064  02b6               _I2C_AckPositionConfig:
2066  02b6 89            	pushw	x
2067       00000000      OFST:	set	0
2070                     ; 568   assert_param(IS_I2C_ACK_POSITION(I2C_AckPosition));
2072                     ; 571   I2Cx->CR2 &= (uint8_t)(~I2C_CR2_POS);
2074  02b7 e601          	ld	a,(1,x)
2075  02b9 a4f7          	and	a,#247
2076  02bb e701          	ld	(1,x),a
2077                     ; 573   I2Cx->CR2 |= (uint8_t)I2C_AckPosition;
2079  02bd e601          	ld	a,(1,x)
2080  02bf 1a05          	or	a,(OFST+5,sp)
2081  02c1 e701          	ld	(1,x),a
2082                     ; 574 }
2085  02c3 85            	popw	x
2086  02c4 81            	ret
2156                     ; 584 void I2C_PECPositionConfig(I2C_TypeDef* I2Cx, I2C_PECPosition_TypeDef I2C_PECPosition)
2156                     ; 585 {
2157                     	switch	.text
2158  02c5               _I2C_PECPositionConfig:
2160  02c5 89            	pushw	x
2161       00000000      OFST:	set	0
2164                     ; 587   assert_param(IS_I2C_PEC_POSITION(I2C_PECPosition));
2166                     ; 590   I2Cx->CR2 &= (uint8_t)(~I2C_CR2_POS);
2168  02c6 e601          	ld	a,(1,x)
2169  02c8 a4f7          	and	a,#247
2170  02ca e701          	ld	(1,x),a
2171                     ; 592   I2Cx->CR2 |= (uint8_t)I2C_PECPosition;
2173  02cc e601          	ld	a,(1,x)
2174  02ce 1a05          	or	a,(OFST+5,sp)
2175  02d0 e701          	ld	(1,x),a
2176                     ; 593 }
2179  02d2 85            	popw	x
2180  02d3 81            	ret
2249                     ; 602 void I2C_SMBusAlertConfig(I2C_TypeDef* I2Cx, I2C_SMBusAlert_TypeDef I2C_SMBusAlert)
2249                     ; 603 {
2250                     	switch	.text
2251  02d4               _I2C_SMBusAlertConfig:
2253  02d4 89            	pushw	x
2254       00000000      OFST:	set	0
2257                     ; 606   assert_param(IS_I2C_SMBUS_ALERT(I2C_SMBusAlert));
2259                     ; 608   if (I2C_SMBusAlert != I2C_SMBusAlert_High)
2261  02d5 0d05          	tnz	(OFST+5,sp)
2262  02d7 2708          	jreq	L7711
2263                     ; 611     I2Cx->CR2 |= (uint8_t)I2C_CR2_ALERT;
2265  02d9 e601          	ld	a,(1,x)
2266  02db aa20          	or	a,#32
2267  02dd e701          	ld	(1,x),a
2269  02df 2008          	jra	L1021
2270  02e1               L7711:
2271                     ; 616     I2Cx->CR2 &= (uint8_t)(~I2C_CR2_ALERT);
2273  02e1 1e01          	ldw	x,(OFST+1,sp)
2274  02e3 e601          	ld	a,(1,x)
2275  02e5 a4df          	and	a,#223
2276  02e7 e701          	ld	(1,x),a
2277  02e9               L1021:
2278                     ; 618 }
2281  02e9 85            	popw	x
2282  02ea 81            	ret
2329                     ; 627 void I2C_TransmitPEC(I2C_TypeDef* I2Cx, FunctionalState NewState)
2329                     ; 628 {
2330                     	switch	.text
2331  02eb               _I2C_TransmitPEC:
2333  02eb 89            	pushw	x
2334       00000000      OFST:	set	0
2337                     ; 630   assert_param(IS_FUNCTIONAL_STATE(NewState));
2339                     ; 632   if (NewState != DISABLE)
2341  02ec 0d05          	tnz	(OFST+5,sp)
2342  02ee 2708          	jreq	L7221
2343                     ; 635     I2Cx->CR2 |= I2C_CR2_PEC;
2345  02f0 e601          	ld	a,(1,x)
2346  02f2 aa10          	or	a,#16
2347  02f4 e701          	ld	(1,x),a
2349  02f6 2008          	jra	L1321
2350  02f8               L7221:
2351                     ; 640     I2Cx->CR2 &= (uint8_t)(~I2C_CR2_PEC);
2353  02f8 1e01          	ldw	x,(OFST+1,sp)
2354  02fa e601          	ld	a,(1,x)
2355  02fc a4ef          	and	a,#239
2356  02fe e701          	ld	(1,x),a
2357  0300               L1321:
2358                     ; 642 }
2361  0300 85            	popw	x
2362  0301 81            	ret
2409                     ; 651 void I2C_CalculatePEC(I2C_TypeDef* I2Cx, FunctionalState NewState)
2409                     ; 652 {
2410                     	switch	.text
2411  0302               _I2C_CalculatePEC:
2413  0302 89            	pushw	x
2414       00000000      OFST:	set	0
2417                     ; 654   assert_param(IS_FUNCTIONAL_STATE(NewState));
2419                     ; 656   if (NewState != DISABLE)
2421  0303 0d05          	tnz	(OFST+5,sp)
2422  0305 2706          	jreq	L7521
2423                     ; 659     I2Cx->CR1 |= I2C_CR1_ENPEC;
2425  0307 f6            	ld	a,(x)
2426  0308 aa20          	or	a,#32
2427  030a f7            	ld	(x),a
2429  030b 2006          	jra	L1621
2430  030d               L7521:
2431                     ; 664     I2Cx->CR1 &= (uint8_t)(~I2C_CR1_ENPEC);
2433  030d 1e01          	ldw	x,(OFST+1,sp)
2434  030f f6            	ld	a,(x)
2435  0310 a4df          	and	a,#223
2436  0312 f7            	ld	(x),a
2437  0313               L1621:
2438                     ; 666 }
2441  0313 85            	popw	x
2442  0314 81            	ret
2490                     ; 676 void I2C_FastModeDutyCycleConfig(I2C_TypeDef* I2Cx, I2C_DutyCycle_TypeDef I2C_DutyCycle)
2490                     ; 677 {
2491                     	switch	.text
2492  0315               _I2C_FastModeDutyCycleConfig:
2494  0315 89            	pushw	x
2495       00000000      OFST:	set	0
2498                     ; 680   assert_param(IS_I2C_DUTY_CYCLE(I2C_DutyCycle));
2500                     ; 682   if (I2C_DutyCycle == I2C_DutyCycle_16_9)
2502  0316 7b05          	ld	a,(OFST+5,sp)
2503  0318 a140          	cp	a,#64
2504  031a 2608          	jrne	L7031
2505                     ; 685     I2Cx->CCRH |= I2C_CCRH_DUTY;
2507  031c e60c          	ld	a,(12,x)
2508  031e aa40          	or	a,#64
2509  0320 e70c          	ld	(12,x),a
2511  0322 2008          	jra	L1131
2512  0324               L7031:
2513                     ; 690     I2Cx->CCRH &= (uint8_t)(~I2C_CCRH_DUTY);
2515  0324 1e01          	ldw	x,(OFST+1,sp)
2516  0326 e60c          	ld	a,(12,x)
2517  0328 a4bf          	and	a,#191
2518  032a e70c          	ld	(12,x),a
2519  032c               L1131:
2520                     ; 692 }
2523  032c 85            	popw	x
2524  032d 81            	ret
2561                     ; 700 uint8_t I2C_ReceiveData(I2C_TypeDef* I2Cx)
2561                     ; 701 {
2562                     	switch	.text
2563  032e               _I2C_ReceiveData:
2567                     ; 703   return ((uint8_t)I2Cx->DR);
2569  032e e606          	ld	a,(6,x)
2572  0330 81            	ret
2651                     ; 715 void I2C_Send7bitAddress(I2C_TypeDef* I2Cx, uint8_t Address, I2C_Direction_TypeDef I2C_Direction)
2651                     ; 716 {
2652                     	switch	.text
2653  0331               _I2C_Send7bitAddress:
2655  0331 89            	pushw	x
2656       00000000      OFST:	set	0
2659                     ; 718   assert_param(IS_I2C_ADDRESS(Address));
2661                     ; 719   assert_param(IS_I2C_DIRECTION(I2C_Direction));
2663                     ; 722   if (I2C_Direction != I2C_Direction_Transmitter)
2665  0332 0d06          	tnz	(OFST+6,sp)
2666  0334 2708          	jreq	L3731
2667                     ; 725     Address |= OAR1_ADD0_Set;
2669  0336 7b05          	ld	a,(OFST+5,sp)
2670  0338 aa01          	or	a,#1
2671  033a 6b05          	ld	(OFST+5,sp),a
2673  033c 2006          	jra	L5731
2674  033e               L3731:
2675                     ; 730     Address &= OAR1_ADD0_Reset;
2677  033e 7b05          	ld	a,(OFST+5,sp)
2678  0340 a4fe          	and	a,#254
2679  0342 6b05          	ld	(OFST+5,sp),a
2680  0344               L5731:
2681                     ; 733   I2Cx->DR = Address;
2683  0344 7b05          	ld	a,(OFST+5,sp)
2684  0346 1e01          	ldw	x,(OFST+1,sp)
2685  0348 e706          	ld	(6,x),a
2686                     ; 734 }
2689  034a 85            	popw	x
2690  034b 81            	ret
2736                     ; 742 void I2C_SendData(I2C_TypeDef* I2Cx, uint8_t Data)
2736                     ; 743 {
2737                     	switch	.text
2738  034c               _I2C_SendData:
2740  034c 89            	pushw	x
2741       00000000      OFST:	set	0
2744                     ; 745   I2Cx->DR = Data;
2746  034d 7b05          	ld	a,(OFST+5,sp)
2747  034f 1e01          	ldw	x,(OFST+1,sp)
2748  0351 e706          	ld	(6,x),a
2749                     ; 746 }
2752  0353 85            	popw	x
2753  0354 81            	ret
2790                     ; 754 uint8_t I2C_GetPEC(I2C_TypeDef* I2Cx)
2790                     ; 755 {
2791                     	switch	.text
2792  0355               _I2C_GetPEC:
2796                     ; 757   return (I2Cx->PECR);
2798  0355 e60e          	ld	a,(14,x)
2801  0357 81            	ret
2962                     ; 768 uint8_t I2C_ReadRegister(I2C_TypeDef* I2Cx, I2C_Register_TypeDef I2C_Register)
2962                     ; 769 {
2963                     	switch	.text
2964  0358               _I2C_ReadRegister:
2966  0358 89            	pushw	x
2967  0359 5204          	subw	sp,#4
2968       00000004      OFST:	set	4
2971                     ; 770   __IO uint16_t tmp = 0;
2973  035b 5f            	clrw	x
2974  035c 1f03          	ldw	(OFST-1,sp),x
2975                     ; 772   assert_param(IS_I2C_REGISTER(I2C_Register));
2977                     ; 774   tmp = (uint16_t) I2Cx;
2979  035e 1e05          	ldw	x,(OFST+1,sp)
2980  0360 1f03          	ldw	(OFST-1,sp),x
2981                     ; 775   tmp += I2C_Register;
2983  0362 7b09          	ld	a,(OFST+5,sp)
2984  0364 5f            	clrw	x
2985  0365 97            	ld	xl,a
2986  0366 1f01          	ldw	(OFST-3,sp),x
2987  0368 1e03          	ldw	x,(OFST-1,sp)
2988  036a 72fb01        	addw	x,(OFST-3,sp)
2989  036d 1f03          	ldw	(OFST-1,sp),x
2990                     ; 778   return (*(__IO uint8_t *) tmp);
2992  036f 1e03          	ldw	x,(OFST-1,sp)
2993  0371 f6            	ld	a,(x)
2996  0372 5b06          	addw	sp,#6
2997  0374 81            	ret
3251                     ; 896 ErrorStatus I2C_CheckEvent(I2C_TypeDef* I2Cx, I2C_Event_TypeDef I2C_Event)
3251                     ; 897 {
3252                     	switch	.text
3253  0375               _I2C_CheckEvent:
3255  0375 89            	pushw	x
3256  0376 5206          	subw	sp,#6
3257       00000006      OFST:	set	6
3260                     ; 898   __IO uint16_t lastevent = 0x00;
3262  0378 5f            	clrw	x
3263  0379 1f04          	ldw	(OFST-2,sp),x
3264                     ; 899   uint8_t flag1 = 0x00 ;
3266                     ; 900   uint8_t flag2 = 0x00;
3268                     ; 901   ErrorStatus status = ERROR;
3270                     ; 904   assert_param(IS_I2C_EVENT(I2C_Event));
3272                     ; 906   if (I2C_Event == I2C_EVENT_SLAVE_ACK_FAILURE)
3274  037b 1e0b          	ldw	x,(OFST+5,sp)
3275  037d a30004        	cpw	x,#4
3276  0380 260c          	jrne	L5561
3277                     ; 908     lastevent = I2Cx->SR2 & I2C_SR2_AF;
3279  0382 1e07          	ldw	x,(OFST+1,sp)
3280  0384 e608          	ld	a,(8,x)
3281  0386 a404          	and	a,#4
3282  0388 5f            	clrw	x
3283  0389 97            	ld	xl,a
3284  038a 1f04          	ldw	(OFST-2,sp),x
3286  038c 2021          	jra	L7561
3287  038e               L5561:
3288                     ; 912     flag1 = I2Cx->SR1;
3290  038e 1e07          	ldw	x,(OFST+1,sp)
3291  0390 e607          	ld	a,(7,x)
3292  0392 6b03          	ld	(OFST-3,sp),a
3293                     ; 913     flag2 = I2Cx->SR3;
3295  0394 1e07          	ldw	x,(OFST+1,sp)
3296  0396 e609          	ld	a,(9,x)
3297  0398 6b06          	ld	(OFST+0,sp),a
3298                     ; 914     lastevent = ((uint16_t)((uint16_t)flag2 << (uint16_t)8) | (uint16_t)flag1);
3300  039a 7b03          	ld	a,(OFST-3,sp)
3301  039c 5f            	clrw	x
3302  039d 97            	ld	xl,a
3303  039e 1f01          	ldw	(OFST-5,sp),x
3304  03a0 7b06          	ld	a,(OFST+0,sp)
3305  03a2 5f            	clrw	x
3306  03a3 97            	ld	xl,a
3307  03a4 4f            	clr	a
3308  03a5 02            	rlwa	x,a
3309  03a6 01            	rrwa	x,a
3310  03a7 1a02          	or	a,(OFST-4,sp)
3311  03a9 01            	rrwa	x,a
3312  03aa 1a01          	or	a,(OFST-5,sp)
3313  03ac 01            	rrwa	x,a
3314  03ad 1f04          	ldw	(OFST-2,sp),x
3315  03af               L7561:
3316                     ; 917   if (((uint16_t)lastevent & (uint16_t)I2C_Event) == (uint16_t)I2C_Event)
3318  03af 1e04          	ldw	x,(OFST-2,sp)
3319  03b1 01            	rrwa	x,a
3320  03b2 140c          	and	a,(OFST+6,sp)
3321  03b4 01            	rrwa	x,a
3322  03b5 140b          	and	a,(OFST+5,sp)
3323  03b7 01            	rrwa	x,a
3324  03b8 130b          	cpw	x,(OFST+5,sp)
3325  03ba 2606          	jrne	L1661
3326                     ; 920     status = SUCCESS;
3328  03bc a601          	ld	a,#1
3329  03be 6b06          	ld	(OFST+0,sp),a
3331  03c0 2002          	jra	L3661
3332  03c2               L1661:
3333                     ; 925     status = ERROR;
3335  03c2 0f06          	clr	(OFST+0,sp)
3336  03c4               L3661:
3337                     ; 929   return status;
3339  03c4 7b06          	ld	a,(OFST+0,sp)
3342  03c6 5b08          	addw	sp,#8
3343  03c8 81            	ret
3408                     ; 947 I2C_Event_TypeDef I2C_GetLastEvent(I2C_TypeDef* I2Cx)
3408                     ; 948 {
3409                     	switch	.text
3410  03c9               _I2C_GetLastEvent:
3412  03c9 89            	pushw	x
3413  03ca 5206          	subw	sp,#6
3414       00000006      OFST:	set	6
3417                     ; 949   __IO uint16_t lastevent = 0;
3419  03cc 5f            	clrw	x
3420  03cd 1f05          	ldw	(OFST-1,sp),x
3421                     ; 950   uint16_t flag1 = 0;
3423                     ; 951   uint16_t flag2 = 0;
3425                     ; 953   if ((I2Cx->SR2 & I2C_SR2_AF) != 0x00)
3427  03cf 1e07          	ldw	x,(OFST+1,sp)
3428  03d1 e608          	ld	a,(8,x)
3429  03d3 a504          	bcp	a,#4
3430  03d5 2707          	jreq	L1271
3431                     ; 955     lastevent = I2C_EVENT_SLAVE_ACK_FAILURE;
3433  03d7 ae0004        	ldw	x,#4
3434  03da 1f05          	ldw	(OFST-1,sp),x
3436  03dc 201d          	jra	L3271
3437  03de               L1271:
3438                     ; 960     flag1 = I2Cx->SR1;
3440  03de 1e07          	ldw	x,(OFST+1,sp)
3441  03e0 e607          	ld	a,(7,x)
3442  03e2 5f            	clrw	x
3443  03e3 97            	ld	xl,a
3444  03e4 1f01          	ldw	(OFST-5,sp),x
3445                     ; 961     flag2 = I2Cx->SR3;
3447  03e6 1e07          	ldw	x,(OFST+1,sp)
3448  03e8 e609          	ld	a,(9,x)
3449  03ea 5f            	clrw	x
3450  03eb 97            	ld	xl,a
3451  03ec 1f03          	ldw	(OFST-3,sp),x
3452                     ; 964     lastevent = ((uint16_t)((uint16_t)flag2 << 8) | (uint16_t)flag1);
3454  03ee 1e03          	ldw	x,(OFST-3,sp)
3455  03f0 4f            	clr	a
3456  03f1 02            	rlwa	x,a
3457  03f2 01            	rrwa	x,a
3458  03f3 1a02          	or	a,(OFST-4,sp)
3459  03f5 01            	rrwa	x,a
3460  03f6 1a01          	or	a,(OFST-5,sp)
3461  03f8 01            	rrwa	x,a
3462  03f9 1f05          	ldw	(OFST-1,sp),x
3463  03fb               L3271:
3464                     ; 967   return (I2C_Event_TypeDef)lastevent;
3466  03fb 1e05          	ldw	x,(OFST-1,sp)
3469  03fd 5b08          	addw	sp,#8
3470  03ff 81            	ret
3727                     ; 1003 FlagStatus I2C_GetFlagStatus(I2C_TypeDef* I2Cx, I2C_FLAG_TypeDef I2C_FLAG)
3727                     ; 1004 {
3728                     	switch	.text
3729  0400               _I2C_GetFlagStatus:
3731  0400 89            	pushw	x
3732  0401 89            	pushw	x
3733       00000002      OFST:	set	2
3736                     ; 1005   uint8_t tempreg = 0;
3738  0402 0f02          	clr	(OFST+0,sp)
3739                     ; 1006   uint8_t regindex = 0;
3741                     ; 1007   FlagStatus bitstatus = RESET;
3743                     ; 1010   assert_param(IS_I2C_GET_FLAG(I2C_FLAG));
3745                     ; 1013   regindex = (uint8_t)((uint16_t)I2C_FLAG >> 8);
3747  0404 7b07          	ld	a,(OFST+5,sp)
3748  0406 6b01          	ld	(OFST-1,sp),a
3749                     ; 1015   switch (regindex)
3751  0408 7b01          	ld	a,(OFST-1,sp)
3753                     ; 1032     default:
3753                     ; 1033       break;
3754  040a 4a            	dec	a
3755  040b 2708          	jreq	L5271
3756  040d 4a            	dec	a
3757  040e 270d          	jreq	L7271
3758  0410 4a            	dec	a
3759  0411 2712          	jreq	L1371
3760  0413 2016          	jra	L7602
3761  0415               L5271:
3762                     ; 1018     case 0x01:
3762                     ; 1019       tempreg = (uint8_t)I2Cx->SR1;
3764  0415 1e03          	ldw	x,(OFST+1,sp)
3765  0417 e607          	ld	a,(7,x)
3766  0419 6b02          	ld	(OFST+0,sp),a
3767                     ; 1020       break;
3769  041b 200e          	jra	L7602
3770  041d               L7271:
3771                     ; 1023     case 0x02:
3771                     ; 1024       tempreg = (uint8_t)I2Cx->SR2;
3773  041d 1e03          	ldw	x,(OFST+1,sp)
3774  041f e608          	ld	a,(8,x)
3775  0421 6b02          	ld	(OFST+0,sp),a
3776                     ; 1025       break;
3778  0423 2006          	jra	L7602
3779  0425               L1371:
3780                     ; 1028     case 0x03:
3780                     ; 1029       tempreg = (uint8_t)I2Cx->SR3;
3782  0425 1e03          	ldw	x,(OFST+1,sp)
3783  0427 e609          	ld	a,(9,x)
3784  0429 6b02          	ld	(OFST+0,sp),a
3785                     ; 1030       break;
3787  042b               L3371:
3788                     ; 1032     default:
3788                     ; 1033       break;
3790  042b               L7602:
3791                     ; 1037   if ((tempreg & (uint8_t)I2C_FLAG ) != 0)
3793  042b 7b08          	ld	a,(OFST+6,sp)
3794  042d 1502          	bcp	a,(OFST+0,sp)
3795  042f 2706          	jreq	L1702
3796                     ; 1040     bitstatus = SET;
3798  0431 a601          	ld	a,#1
3799  0433 6b02          	ld	(OFST+0,sp),a
3801  0435 2002          	jra	L3702
3802  0437               L1702:
3803                     ; 1045     bitstatus = RESET;
3805  0437 0f02          	clr	(OFST+0,sp)
3806  0439               L3702:
3807                     ; 1048   return bitstatus;
3809  0439 7b02          	ld	a,(OFST+0,sp)
3812  043b 5b04          	addw	sp,#4
3813  043d 81            	ret
3869                     ; 1086 void I2C_ClearFlag(I2C_TypeDef* I2Cx, I2C_FLAG_TypeDef I2C_FLAG)
3869                     ; 1087 {
3870                     	switch	.text
3871  043e               _I2C_ClearFlag:
3873  043e 89            	pushw	x
3874  043f 89            	pushw	x
3875       00000002      OFST:	set	2
3878                     ; 1088   uint16_t flagpos = 0;
3880                     ; 1090   assert_param(IS_I2C_CLEAR_FLAG(I2C_FLAG));
3882                     ; 1093   flagpos = (uint16_t)I2C_FLAG & FLAG_Mask;
3884  0440 7b07          	ld	a,(OFST+5,sp)
3885  0442 97            	ld	xl,a
3886  0443 7b08          	ld	a,(OFST+6,sp)
3887  0445 a4ff          	and	a,#255
3888  0447 5f            	clrw	x
3889  0448 02            	rlwa	x,a
3890  0449 1f01          	ldw	(OFST-1,sp),x
3891  044b 01            	rrwa	x,a
3892                     ; 1095   I2Cx->SR2 = (uint8_t)((uint16_t)(~flagpos));
3894  044c 7b02          	ld	a,(OFST+0,sp)
3895  044e 43            	cpl	a
3896  044f 1e03          	ldw	x,(OFST+1,sp)
3897  0451 e708          	ld	(8,x),a
3898                     ; 1096 }
3901  0453 5b04          	addw	sp,#4
3902  0455 81            	ret
3978                     ; 1122 ITStatus I2C_GetITStatus(I2C_TypeDef* I2Cx, I2C_IT_TypeDef I2C_IT)
3978                     ; 1123 {
3979                     	switch	.text
3980  0456               _I2C_GetITStatus:
3982  0456 89            	pushw	x
3983  0457 5204          	subw	sp,#4
3984       00000004      OFST:	set	4
3987                     ; 1124   ITStatus bitstatus = RESET;
3989                     ; 1125   __IO uint8_t enablestatus = 0;
3991  0459 0f03          	clr	(OFST-1,sp)
3992                     ; 1126   uint16_t tempregister = 0;
3994                     ; 1129   assert_param(IS_I2C_GET_IT(I2C_IT));
3996                     ; 1131   tempregister = (uint8_t)( ((uint16_t)((uint16_t)I2C_IT & ITEN_Mask)) >> 8);
3998  045b 7b09          	ld	a,(OFST+5,sp)
3999  045d 97            	ld	xl,a
4000  045e 7b0a          	ld	a,(OFST+6,sp)
4001  0460 9f            	ld	a,xl
4002  0461 a407          	and	a,#7
4003  0463 97            	ld	xl,a
4004  0464 4f            	clr	a
4005  0465 02            	rlwa	x,a
4006  0466 4f            	clr	a
4007  0467 01            	rrwa	x,a
4008  0468 9f            	ld	a,xl
4009  0469 5f            	clrw	x
4010  046a 97            	ld	xl,a
4011  046b 1f01          	ldw	(OFST-3,sp),x
4012                     ; 1134   enablestatus = (uint8_t)(I2Cx->ITR & ( uint8_t)tempregister);
4014  046d 1e05          	ldw	x,(OFST+1,sp)
4015  046f e60a          	ld	a,(10,x)
4016  0471 1402          	and	a,(OFST-2,sp)
4017  0473 6b03          	ld	(OFST-1,sp),a
4018                     ; 1136   if ((uint16_t)((uint16_t)I2C_IT & REGISTER_Mask) == REGISTER_SR1_Index)
4020  0475 7b09          	ld	a,(OFST+5,sp)
4021  0477 97            	ld	xl,a
4022  0478 7b0a          	ld	a,(OFST+6,sp)
4023  047a 9f            	ld	a,xl
4024  047b a430          	and	a,#48
4025  047d 97            	ld	xl,a
4026  047e 4f            	clr	a
4027  047f 02            	rlwa	x,a
4028  0480 a30100        	cpw	x,#256
4029  0483 2616          	jrne	L5612
4030                     ; 1139     if (((I2Cx->SR1 & (uint8_t)I2C_IT) != RESET) && enablestatus)
4032  0485 1e05          	ldw	x,(OFST+1,sp)
4033  0487 e607          	ld	a,(7,x)
4034  0489 150a          	bcp	a,(OFST+6,sp)
4035  048b 270a          	jreq	L7612
4037  048d 0d03          	tnz	(OFST-1,sp)
4038  048f 2706          	jreq	L7612
4039                     ; 1142       bitstatus = SET;
4041  0491 a601          	ld	a,#1
4042  0493 6b04          	ld	(OFST+0,sp),a
4044  0495 2018          	jra	L3712
4045  0497               L7612:
4046                     ; 1147       bitstatus = RESET;
4048  0497 0f04          	clr	(OFST+0,sp)
4049  0499 2014          	jra	L3712
4050  049b               L5612:
4051                     ; 1153     if (((I2Cx->SR2 & (uint8_t)I2C_IT) != RESET) && enablestatus)
4053  049b 1e05          	ldw	x,(OFST+1,sp)
4054  049d e608          	ld	a,(8,x)
4055  049f 150a          	bcp	a,(OFST+6,sp)
4056  04a1 270a          	jreq	L5712
4058  04a3 0d03          	tnz	(OFST-1,sp)
4059  04a5 2706          	jreq	L5712
4060                     ; 1156       bitstatus = SET;
4062  04a7 a601          	ld	a,#1
4063  04a9 6b04          	ld	(OFST+0,sp),a
4065  04ab 2002          	jra	L3712
4066  04ad               L5712:
4067                     ; 1161       bitstatus = RESET;
4069  04ad 0f04          	clr	(OFST+0,sp)
4070  04af               L3712:
4071                     ; 1165   return  bitstatus;
4073  04af 7b04          	ld	a,(OFST+0,sp)
4076  04b1 5b06          	addw	sp,#6
4077  04b3 81            	ret
4134                     ; 1205 void I2C_ClearITPendingBit(I2C_TypeDef* I2Cx, I2C_IT_TypeDef I2C_IT)
4134                     ; 1206 {
4135                     	switch	.text
4136  04b4               _I2C_ClearITPendingBit:
4138  04b4 89            	pushw	x
4139  04b5 89            	pushw	x
4140       00000002      OFST:	set	2
4143                     ; 1207   uint16_t flagpos = 0;
4145                     ; 1210   assert_param(IS_I2C_CLEAR_IT(I2C_IT));
4147                     ; 1213   flagpos = (uint16_t)I2C_IT & FLAG_Mask;
4149  04b6 7b07          	ld	a,(OFST+5,sp)
4150  04b8 97            	ld	xl,a
4151  04b9 7b08          	ld	a,(OFST+6,sp)
4152  04bb a4ff          	and	a,#255
4153  04bd 5f            	clrw	x
4154  04be 02            	rlwa	x,a
4155  04bf 1f01          	ldw	(OFST-1,sp),x
4156  04c1 01            	rrwa	x,a
4157                     ; 1216   I2Cx->SR2 = (uint8_t)((uint16_t)~flagpos);
4159  04c2 7b02          	ld	a,(OFST+0,sp)
4160  04c4 43            	cpl	a
4161  04c5 1e03          	ldw	x,(OFST+1,sp)
4162  04c7 e708          	ld	(8,x),a
4163                     ; 1217 }
4166  04c9 5b04          	addw	sp,#4
4167  04cb 81            	ret
4180                     	xdef	_I2C_ClearITPendingBit
4181                     	xdef	_I2C_GetITStatus
4182                     	xdef	_I2C_ClearFlag
4183                     	xdef	_I2C_GetFlagStatus
4184                     	xdef	_I2C_GetLastEvent
4185                     	xdef	_I2C_CheckEvent
4186                     	xdef	_I2C_GetPEC
4187                     	xdef	_I2C_CalculatePEC
4188                     	xdef	_I2C_TransmitPEC
4189                     	xdef	_I2C_ReadRegister
4190                     	xdef	_I2C_Send7bitAddress
4191                     	xdef	_I2C_ReceiveData
4192                     	xdef	_I2C_SendData
4193                     	xdef	_I2C_PECPositionConfig
4194                     	xdef	_I2C_SMBusAlertConfig
4195                     	xdef	_I2C_FastModeDutyCycleConfig
4196                     	xdef	_I2C_AckPositionConfig
4197                     	xdef	_I2C_ITConfig
4198                     	xdef	_I2C_DualAddressCmd
4199                     	xdef	_I2C_OwnAddress2Config
4200                     	xdef	_I2C_AcknowledgeConfig
4201                     	xdef	_I2C_GenerateSTOP
4202                     	xdef	_I2C_GenerateSTART
4203                     	xdef	_I2C_ARPCmd
4204                     	xdef	_I2C_StretchClockCmd
4205                     	xdef	_I2C_SoftwareResetCmd
4206                     	xdef	_I2C_GeneralCallCmd
4207                     	xdef	_I2C_DMALastTransferCmd
4208                     	xdef	_I2C_DMACmd
4209                     	xdef	_I2C_Cmd
4210                     	xdef	_I2C_Init
4211                     	xdef	_I2C_DeInit
4212                     	xref	_CLK_GetClockFreq
4213                     	xref.b	c_lreg
4214                     	xref.b	c_x
4233                     	xref	c_uitol
4234                     	xref	c_sdivx
4235                     	xref	c_lzmp
4236                     	xref	c_rtol
4237                     	xref	c_smul
4238                     	xref	c_lmul
4239                     	xref	c_lcmp
4240                     	xref	c_ltor
4241                     	xref	c_ludv
4242                     	end
