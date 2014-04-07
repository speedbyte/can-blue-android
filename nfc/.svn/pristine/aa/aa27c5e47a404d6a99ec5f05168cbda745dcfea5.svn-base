   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.9.10 - 10 Feb 2011
   3                     ; Generator (Limited) V4.3.6 - 15 Feb 2011
  46                     ; 87 void M24LR16E_DeInit(void)
  46                     ; 88 {
  48                     	switch	.text
  49  0000               _M24LR16E_DeInit:
  53                     ; 89   M24LR16E_LowLevel_DeInit();
  55  0000 cd0871        	call	L3_M24LR16E_LowLevel_DeInit
  57                     ; 90 }
  60  0003 81            	ret
  87                     ; 97 void M24LR16E_Init(void)
  87                     ; 98 {
  88                     	switch	.text
  89  0004               _M24LR16E_Init:
  93                     ; 100   M24LR16E_LowLevel_Init();
  95  0004 cd089d        	call	L5_M24LR16E_LowLevel_Init
  97                     ; 103   I2C_DeInit(M24LR16E_I2C);
  99  0007 ae5210        	ldw	x,#21008
 100  000a cd0000        	call	_I2C_DeInit
 102                     ; 109 	I2C_Init(M24LR16E_I2C, M24LR16E_I2C_SPEED, 0x00, I2C_Mode_I2C,
 102                     ; 110            I2C_DutyCycle_2, I2C_Ack_Enable, I2C_AcknowledgedAddress_7bit);
 104  000d 4b00          	push	#0
 105  000f 4b04          	push	#4
 106  0011 4b00          	push	#0
 107  0013 4b00          	push	#0
 108  0015 5f            	clrw	x
 109  0016 89            	pushw	x
 110  0017 ae4e20        	ldw	x,#20000
 111  001a 89            	pushw	x
 112  001b ae0000        	ldw	x,#0
 113  001e 89            	pushw	x
 114  001f ae5210        	ldw	x,#21008
 115  0022 cd0000        	call	_I2C_Init
 117  0025 5b0a          	addw	sp,#10
 118                     ; 116   I2C_Cmd(M24LR16E_I2C, ENABLE);
 120  0027 4b01          	push	#1
 121  0029 ae5210        	ldw	x,#21008
 122  002c cd0000        	call	_I2C_Cmd
 124  002f 84            	pop	a
 125                     ; 117 }
 128  0030 81            	ret
 189                     ; 124 ErrorStatus M24LR16E_GetStatus(void)
 189                     ; 125 {
 190                     	switch	.text
 191  0031               _M24LR16E_GetStatus:
 193  0031 5204          	subw	sp,#4
 194       00000004      OFST:	set	4
 197                     ; 126   uint32_t I2C_TimeOut = I2C_TIMEOUT;
 199  0033 ae00ff        	ldw	x,#255
 200  0036 1f03          	ldw	(OFST-1,sp),x
 201  0038 ae0000        	ldw	x,#0
 202  003b 1f01          	ldw	(OFST-3,sp),x
 203                     ; 129   I2C_ClearFlag(M24LR16E_I2C, I2C_FLAG_AF);
 205  003d ae0204        	ldw	x,#516
 206  0040 89            	pushw	x
 207  0041 ae5210        	ldw	x,#21008
 208  0044 cd0000        	call	_I2C_ClearFlag
 210  0047 85            	popw	x
 211                     ; 132   I2C_AcknowledgeConfig(M24LR16E_I2C, ENABLE);
 213  0048 4b01          	push	#1
 214  004a ae5210        	ldw	x,#21008
 215  004d cd0000        	call	_I2C_AcknowledgeConfig
 217  0050 84            	pop	a
 218                     ; 137   I2C_GenerateSTART(M24LR16E_I2C, ENABLE);
 220  0051 4b01          	push	#1
 221  0053 ae5210        	ldw	x,#21008
 222  0056 cd0000        	call	_I2C_GenerateSTART
 224  0059 84            	pop	a
 226  005a 2009          	jra	L56
 227  005c               L36:
 228                     ; 142     I2C_TimeOut--;
 230  005c 96            	ldw	x,sp
 231  005d 1c0001        	addw	x,#OFST-3
 232  0060 a601          	ld	a,#1
 233  0062 cd0000        	call	c_lgsbc
 235  0065               L56:
 236                     ; 140   while ((!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_MODE_SELECT)) && I2C_TimeOut)  /* EV5 */
 238  0065 ae0301        	ldw	x,#769
 239  0068 89            	pushw	x
 240  0069 ae5210        	ldw	x,#21008
 241  006c cd0000        	call	_I2C_CheckEvent
 243  006f 85            	popw	x
 244  0070 4d            	tnz	a
 245  0071 2609          	jrne	L17
 247  0073 96            	ldw	x,sp
 248  0074 1c0001        	addw	x,#OFST-3
 249  0077 cd0000        	call	c_lzmp
 251  007a 26e0          	jrne	L36
 252  007c               L17:
 253                     ; 144   if (I2C_TimeOut == 0)
 255  007c 96            	ldw	x,sp
 256  007d 1c0001        	addw	x,#OFST-3
 257  0080 cd0000        	call	c_lzmp
 259  0083 2603          	jrne	L37
 260                     ; 146     return ERROR;
 262  0085 4f            	clr	a
 264  0086 204f          	jra	L21
 265  0088               L37:
 266                     ; 148   I2C_TimeOut = I2C_TIMEOUT;
 268  0088 ae00ff        	ldw	x,#255
 269  008b 1f03          	ldw	(OFST-1,sp),x
 270  008d ae0000        	ldw	x,#0
 271  0090 1f01          	ldw	(OFST-3,sp),x
 272                     ; 151   I2C_Send7bitAddress(M24LR16E_I2C, M24LR16E_ADDR, I2C_Direction_Transmitter);
 274  0092 4b00          	push	#0
 275  0094 4b90          	push	#144
 276  0096 ae5210        	ldw	x,#21008
 277  0099 cd0000        	call	_I2C_Send7bitAddress
 279  009c 85            	popw	x
 281  009d 2009          	jra	L77
 282  009f               L57:
 283                     ; 155     I2C_TimeOut--;
 285  009f 96            	ldw	x,sp
 286  00a0 1c0001        	addw	x,#OFST-3
 287  00a3 a601          	ld	a,#1
 288  00a5 cd0000        	call	c_lgsbc
 290  00a8               L77:
 291                     ; 153   while ((!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)) && I2C_TimeOut)/* EV6 */
 293  00a8 ae0782        	ldw	x,#1922
 294  00ab 89            	pushw	x
 295  00ac ae5210        	ldw	x,#21008
 296  00af cd0000        	call	_I2C_CheckEvent
 298  00b2 85            	popw	x
 299  00b3 4d            	tnz	a
 300  00b4 2609          	jrne	L301
 302  00b6 96            	ldw	x,sp
 303  00b7 1c0001        	addw	x,#OFST-3
 304  00ba cd0000        	call	c_lzmp
 306  00bd 26e0          	jrne	L57
 307  00bf               L301:
 308                     ; 158   if ((I2C_GetFlagStatus(M24LR16E_I2C, I2C_FLAG_AF) != 0x00) || (I2C_TimeOut == 0))
 310  00bf ae0204        	ldw	x,#516
 311  00c2 89            	pushw	x
 312  00c3 ae5210        	ldw	x,#21008
 313  00c6 cd0000        	call	_I2C_GetFlagStatus
 315  00c9 85            	popw	x
 316  00ca 4d            	tnz	a
 317  00cb 2609          	jrne	L701
 319  00cd 96            	ldw	x,sp
 320  00ce 1c0001        	addw	x,#OFST-3
 321  00d1 cd0000        	call	c_lzmp
 323  00d4 2604          	jrne	L501
 324  00d6               L701:
 325                     ; 160     return ERROR;
 327  00d6 4f            	clr	a
 329  00d7               L21:
 331  00d7 5b04          	addw	sp,#4
 332  00d9 81            	ret
 333  00da               L501:
 334                     ; 164     return SUCCESS;
 336  00da a601          	ld	a,#1
 338  00dc 20f9          	jra	L21
 389                     ; 176 uint16_t M24LR16E_ReadReg(uint8_t RegName)
 389                     ; 177 {
 390                     	switch	.text
 391  00de               _M24LR16E_ReadReg:
 393  00de 88            	push	a
 394  00df 89            	pushw	x
 395       00000002      OFST:	set	2
 398                     ; 178   __IO uint16_t RegValue = 0;
 400  00e0 5f            	clrw	x
 401  00e1 1f01          	ldw	(OFST-1,sp),x
 402                     ; 181   I2C_AcknowledgeConfig(M24LR16E_I2C, ENABLE);
 404  00e3 4b01          	push	#1
 405  00e5 ae5210        	ldw	x,#21008
 406  00e8 cd0000        	call	_I2C_AcknowledgeConfig
 408  00eb 84            	pop	a
 409                     ; 185   I2C_GenerateSTART(M24LR16E_I2C, ENABLE);
 411  00ec 4b01          	push	#1
 412  00ee ae5210        	ldw	x,#21008
 413  00f1 cd0000        	call	_I2C_GenerateSTART
 415  00f4 84            	pop	a
 417  00f5               L731:
 418                     ; 188   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_MODE_SELECT))  /* EV5 */
 420  00f5 ae0301        	ldw	x,#769
 421  00f8 89            	pushw	x
 422  00f9 ae5210        	ldw	x,#21008
 423  00fc cd0000        	call	_I2C_CheckEvent
 425  00ff 85            	popw	x
 426  0100 4d            	tnz	a
 427  0101 27f2          	jreq	L731
 428                     ; 193   I2C_Send7bitAddress(M24LR16E_I2C, M24LR16E_ADDR, I2C_Direction_Transmitter);
 430  0103 4b00          	push	#0
 431  0105 4b90          	push	#144
 432  0107 ae5210        	ldw	x,#21008
 433  010a cd0000        	call	_I2C_Send7bitAddress
 435  010d 85            	popw	x
 437  010e               L541:
 438                     ; 196   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)) /* EV6 */
 440  010e ae0782        	ldw	x,#1922
 441  0111 89            	pushw	x
 442  0112 ae5210        	ldw	x,#21008
 443  0115 cd0000        	call	_I2C_CheckEvent
 445  0118 85            	popw	x
 446  0119 4d            	tnz	a
 447  011a 27f2          	jreq	L541
 448                     ; 201   I2C_SendData(M24LR16E_I2C, RegName);
 450  011c 7b03          	ld	a,(OFST+1,sp)
 451  011e 88            	push	a
 452  011f ae5210        	ldw	x,#21008
 453  0122 cd0000        	call	_I2C_SendData
 455  0125 84            	pop	a
 457  0126               L351:
 458                     ; 204   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_BYTE_TRANSMITTED)) /* EV8 */
 460  0126 ae0784        	ldw	x,#1924
 461  0129 89            	pushw	x
 462  012a ae5210        	ldw	x,#21008
 463  012d cd0000        	call	_I2C_CheckEvent
 465  0130 85            	popw	x
 466  0131 4d            	tnz	a
 467  0132 27f2          	jreq	L351
 468                     ; 210   I2C_GenerateSTART(M24LR16E_I2C, ENABLE);
 470  0134 4b01          	push	#1
 471  0136 ae5210        	ldw	x,#21008
 472  0139 cd0000        	call	_I2C_GenerateSTART
 474  013c 84            	pop	a
 476  013d               L161:
 477                     ; 213   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_MODE_SELECT))  /* EV5 */
 479  013d ae0301        	ldw	x,#769
 480  0140 89            	pushw	x
 481  0141 ae5210        	ldw	x,#21008
 482  0144 cd0000        	call	_I2C_CheckEvent
 484  0147 85            	popw	x
 485  0148 4d            	tnz	a
 486  0149 27f2          	jreq	L161
 487                     ; 218   I2C_Send7bitAddress(M24LR16E_I2C, M24LR16E_ADDR, I2C_Direction_Receiver);
 489  014b 4b01          	push	#1
 490  014d 4b90          	push	#144
 491  014f ae5210        	ldw	x,#21008
 492  0152 cd0000        	call	_I2C_Send7bitAddress
 494  0155 85            	popw	x
 496  0156               L761:
 497                     ; 221   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED))  /* EV6 */
 499  0156 ae0302        	ldw	x,#770
 500  0159 89            	pushw	x
 501  015a ae5210        	ldw	x,#21008
 502  015d cd0000        	call	_I2C_CheckEvent
 504  0160 85            	popw	x
 505  0161 4d            	tnz	a
 506  0162 27f2          	jreq	L761
 508  0164               L571:
 509                     ; 226   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_BYTE_RECEIVED))  /* EV7 */
 511  0164 ae0340        	ldw	x,#832
 512  0167 89            	pushw	x
 513  0168 ae5210        	ldw	x,#21008
 514  016b cd0000        	call	_I2C_CheckEvent
 516  016e 85            	popw	x
 517  016f 4d            	tnz	a
 518  0170 27f2          	jreq	L571
 519                     ; 231   RegValue = (uint16_t)(I2C_ReceiveData(M24LR16E_I2C) << 8);
 521  0172 ae5210        	ldw	x,#21008
 522  0175 cd0000        	call	_I2C_ReceiveData
 524  0178 5f            	clrw	x
 525  0179 97            	ld	xl,a
 526  017a 4f            	clr	a
 527  017b 02            	rlwa	x,a
 528  017c 1f01          	ldw	(OFST-1,sp),x
 529                     ; 234   I2C_AcknowledgeConfig(M24LR16E_I2C, DISABLE);
 531  017e 4b00          	push	#0
 532  0180 ae5210        	ldw	x,#21008
 533  0183 cd0000        	call	_I2C_AcknowledgeConfig
 535  0186 84            	pop	a
 536                     ; 237   I2C_GenerateSTOP(M24LR16E_I2C, ENABLE);
 538  0187 4b01          	push	#1
 539  0189 ae5210        	ldw	x,#21008
 540  018c cd0000        	call	_I2C_GenerateSTOP
 542  018f 84            	pop	a
 544  0190               L302:
 545                     ; 240   while (I2C_GetFlagStatus(M24LR16E_I2C, I2C_FLAG_RXNE) == RESET)
 547  0190 ae0140        	ldw	x,#320
 548  0193 89            	pushw	x
 549  0194 ae5210        	ldw	x,#21008
 550  0197 cd0000        	call	_I2C_GetFlagStatus
 552  019a 85            	popw	x
 553  019b 4d            	tnz	a
 554  019c 27f2          	jreq	L302
 555                     ; 244   RegValue |= I2C_ReceiveData(M24LR16E_I2C);
 557  019e ae5210        	ldw	x,#21008
 558  01a1 cd0000        	call	_I2C_ReceiveData
 560  01a4 5f            	clrw	x
 561  01a5 97            	ld	xl,a
 562  01a6 01            	rrwa	x,a
 563  01a7 1a02          	or	a,(OFST+0,sp)
 564  01a9 01            	rrwa	x,a
 565  01aa 1a01          	or	a,(OFST-1,sp)
 566  01ac 01            	rrwa	x,a
 567  01ad 1f01          	ldw	(OFST-1,sp),x
 568                     ; 247   return (RegValue);
 570  01af 1e01          	ldw	x,(OFST-1,sp)
 573  01b1 5b03          	addw	sp,#3
 574  01b3 81            	ret
 622                     ; 259 void M24LR16E_WriteReg(uint8_t RegName, uint16_t RegValue)
 622                     ; 260 {
 623                     	switch	.text
 624  01b4               _M24LR16E_WriteReg:
 626  01b4 88            	push	a
 627       00000000      OFST:	set	0
 630                     ; 263   I2C_GenerateSTART(M24LR16E_I2C, ENABLE);
 632  01b5 4b01          	push	#1
 633  01b7 ae5210        	ldw	x,#21008
 634  01ba cd0000        	call	_I2C_GenerateSTART
 636  01bd 84            	pop	a
 638  01be               L332:
 639                     ; 266   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_MODE_SELECT))  /* EV5 */
 641  01be ae0301        	ldw	x,#769
 642  01c1 89            	pushw	x
 643  01c2 ae5210        	ldw	x,#21008
 644  01c5 cd0000        	call	_I2C_CheckEvent
 646  01c8 85            	popw	x
 647  01c9 4d            	tnz	a
 648  01ca 27f2          	jreq	L332
 649                     ; 271   I2C_Send7bitAddress(M24LR16E_I2C, M24LR16E_ADDR, I2C_Direction_Transmitter);
 651  01cc 4b00          	push	#0
 652  01ce 4b90          	push	#144
 653  01d0 ae5210        	ldw	x,#21008
 654  01d3 cd0000        	call	_I2C_Send7bitAddress
 656  01d6 85            	popw	x
 658  01d7               L142:
 659                     ; 274   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)) /* EV6 */
 661  01d7 ae0782        	ldw	x,#1922
 662  01da 89            	pushw	x
 663  01db ae5210        	ldw	x,#21008
 664  01de cd0000        	call	_I2C_CheckEvent
 666  01e1 85            	popw	x
 667  01e2 4d            	tnz	a
 668  01e3 27f2          	jreq	L142
 669                     ; 279   I2C_SendData(M24LR16E_I2C, RegName);
 671  01e5 7b01          	ld	a,(OFST+1,sp)
 672  01e7 88            	push	a
 673  01e8 ae5210        	ldw	x,#21008
 674  01eb cd0000        	call	_I2C_SendData
 676  01ee 84            	pop	a
 678  01ef               L742:
 679                     ; 282   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_BYTE_TRANSMITTED)) /* EV8 */
 681  01ef ae0784        	ldw	x,#1924
 682  01f2 89            	pushw	x
 683  01f3 ae5210        	ldw	x,#21008
 684  01f6 cd0000        	call	_I2C_CheckEvent
 686  01f9 85            	popw	x
 687  01fa 4d            	tnz	a
 688  01fb 27f2          	jreq	L742
 689                     ; 287   I2C_SendData(M24LR16E_I2C, (uint8_t)(RegValue >> 8));
 691  01fd 7b04          	ld	a,(OFST+4,sp)
 692  01ff 88            	push	a
 693  0200 ae5210        	ldw	x,#21008
 694  0203 cd0000        	call	_I2C_SendData
 696  0206 84            	pop	a
 698  0207               L552:
 699                     ; 290   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_BYTE_TRANSMITTED)) /* EV8 */
 701  0207 ae0784        	ldw	x,#1924
 702  020a 89            	pushw	x
 703  020b ae5210        	ldw	x,#21008
 704  020e cd0000        	call	_I2C_CheckEvent
 706  0211 85            	popw	x
 707  0212 4d            	tnz	a
 708  0213 27f2          	jreq	L552
 709                     ; 295   I2C_SendData(M24LR16E_I2C, (uint8_t)RegValue);
 711  0215 7b05          	ld	a,(OFST+5,sp)
 712  0217 88            	push	a
 713  0218 ae5210        	ldw	x,#21008
 714  021b cd0000        	call	_I2C_SendData
 716  021e 84            	pop	a
 718  021f               L362:
 719                     ; 298   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_BYTE_TRANSMITTED)) /* EV8 */
 721  021f ae0784        	ldw	x,#1924
 722  0222 89            	pushw	x
 723  0223 ae5210        	ldw	x,#21008
 724  0226 cd0000        	call	_I2C_CheckEvent
 726  0229 85            	popw	x
 727  022a 4d            	tnz	a
 728  022b 27f2          	jreq	L362
 729                     ; 303   I2C_GenerateSTOP(M24LR16E_I2C, ENABLE);
 731  022d 4b01          	push	#1
 732  022f ae5210        	ldw	x,#21008
 733  0232 cd0000        	call	_I2C_GenerateSTOP
 735  0235 84            	pop	a
 736                     ; 304 }
 739  0236 84            	pop	a
 740  0237 81            	ret
 811                     ; 318 void M24LR16E_ReadOneByte (uint8_t EE_address, uint16_t ReadAddr,uint8_t* pBuffer)
 811                     ; 319 {
 812                     	switch	.text
 813  0238               _M24LR16E_ReadOneByte:
 815  0238 88            	push	a
 816  0239 5204          	subw	sp,#4
 817       00000004      OFST:	set	4
 820                     ; 320 int32_t I2C_TimeOut = I2C_TIMEOUT;
 822  023b ae00ff        	ldw	x,#255
 823  023e 1f03          	ldw	(OFST-1,sp),x
 824  0240 ae0000        	ldw	x,#0
 825  0243 1f01          	ldw	(OFST-3,sp),x
 826                     ; 323   I2C_AcknowledgeConfig(M24LR16E_I2C, ENABLE);
 828  0245 4b01          	push	#1
 829  0247 ae5210        	ldw	x,#21008
 830  024a cd0000        	call	_I2C_AcknowledgeConfig
 832  024d 84            	pop	a
 833                     ; 327   I2C_GenerateSTART(M24LR16E_I2C, ENABLE);
 835  024e 4b01          	push	#1
 836  0250 ae5210        	ldw	x,#21008
 837  0253 cd0000        	call	_I2C_GenerateSTART
 839  0256 84            	pop	a
 841  0257               L323:
 842                     ; 330   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_MODE_SELECT) && I2C_TimeOut-->0)  // EV5 
 844  0257 ae0301        	ldw	x,#769
 845  025a 89            	pushw	x
 846  025b ae5210        	ldw	x,#21008
 847  025e cd0000        	call	_I2C_CheckEvent
 849  0261 85            	popw	x
 850  0262 4d            	tnz	a
 851  0263 2616          	jrne	L723
 853  0265 9c            	rvf
 854  0266 96            	ldw	x,sp
 855  0267 1c0001        	addw	x,#OFST-3
 856  026a cd0000        	call	c_ltor
 858  026d 96            	ldw	x,sp
 859  026e 1c0001        	addw	x,#OFST-3
 860  0271 a601          	ld	a,#1
 861  0273 cd0000        	call	c_lgsbc
 863  0276 cd0000        	call	c_lrzmp
 865  0279 2cdc          	jrsgt	L323
 866  027b               L723:
 867                     ; 336   I2C_Send7bitAddress(M24LR16E_I2C, EE_address , I2C_Direction_Transmitter);
 869  027b 4b00          	push	#0
 870  027d 7b06          	ld	a,(OFST+2,sp)
 871  027f 88            	push	a
 872  0280 ae5210        	ldw	x,#21008
 873  0283 cd0000        	call	_I2C_Send7bitAddress
 875  0286 85            	popw	x
 877  0287               L333:
 878                     ; 339   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)&& I2C_TimeOut-->0) // EV6 
 880  0287 ae0782        	ldw	x,#1922
 881  028a 89            	pushw	x
 882  028b ae5210        	ldw	x,#21008
 883  028e cd0000        	call	_I2C_CheckEvent
 885  0291 85            	popw	x
 886  0292 4d            	tnz	a
 887  0293 2616          	jrne	L733
 889  0295 9c            	rvf
 890  0296 96            	ldw	x,sp
 891  0297 1c0001        	addw	x,#OFST-3
 892  029a cd0000        	call	c_ltor
 894  029d 96            	ldw	x,sp
 895  029e 1c0001        	addw	x,#OFST-3
 896  02a1 a601          	ld	a,#1
 897  02a3 cd0000        	call	c_lgsbc
 899  02a6 cd0000        	call	c_lrzmp
 901  02a9 2cdc          	jrsgt	L333
 902  02ab               L733:
 903                     ; 344 	I2C_SendData(M24LR16E_I2C,(uint8_t)(ReadAddr >> 8)); // MSB 
 905  02ab 7b08          	ld	a,(OFST+4,sp)
 906  02ad 88            	push	a
 907  02ae ae5210        	ldw	x,#21008
 908  02b1 cd0000        	call	_I2C_SendData
 910  02b4 84            	pop	a
 912  02b5               L343:
 913                     ; 349   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_BYTE_TRANSMITTED)&& I2C_TimeOut-->0) // EV8 
 915  02b5 ae0784        	ldw	x,#1924
 916  02b8 89            	pushw	x
 917  02b9 ae5210        	ldw	x,#21008
 918  02bc cd0000        	call	_I2C_CheckEvent
 920  02bf 85            	popw	x
 921  02c0 4d            	tnz	a
 922  02c1 2616          	jrne	L743
 924  02c3 9c            	rvf
 925  02c4 96            	ldw	x,sp
 926  02c5 1c0001        	addw	x,#OFST-3
 927  02c8 cd0000        	call	c_ltor
 929  02cb 96            	ldw	x,sp
 930  02cc 1c0001        	addw	x,#OFST-3
 931  02cf a601          	ld	a,#1
 932  02d1 cd0000        	call	c_lgsbc
 934  02d4 cd0000        	call	c_lrzmp
 936  02d7 2cdc          	jrsgt	L343
 937  02d9               L743:
 938                     ; 354 	I2C_SendData(M24LR16E_I2C,(uint8_t)ReadAddr); // LSB 
 940  02d9 7b09          	ld	a,(OFST+5,sp)
 941  02db 88            	push	a
 942  02dc ae5210        	ldw	x,#21008
 943  02df cd0000        	call	_I2C_SendData
 945  02e2 84            	pop	a
 947  02e3               L353:
 948                     ; 357   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_BYTE_TRANSMITTED)&& I2C_TimeOut-->0) // EV8 
 950  02e3 ae0784        	ldw	x,#1924
 951  02e6 89            	pushw	x
 952  02e7 ae5210        	ldw	x,#21008
 953  02ea cd0000        	call	_I2C_CheckEvent
 955  02ed 85            	popw	x
 956  02ee 4d            	tnz	a
 957  02ef 2616          	jrne	L753
 959  02f1 9c            	rvf
 960  02f2 96            	ldw	x,sp
 961  02f3 1c0001        	addw	x,#OFST-3
 962  02f6 cd0000        	call	c_ltor
 964  02f9 96            	ldw	x,sp
 965  02fa 1c0001        	addw	x,#OFST-3
 966  02fd a601          	ld	a,#1
 967  02ff cd0000        	call	c_lgsbc
 969  0302 cd0000        	call	c_lrzmp
 971  0305 2cdc          	jrsgt	L353
 972  0307               L753:
 973                     ; 363   I2C_GenerateSTART(M24LR16E_I2C, ENABLE);
 975  0307 4b01          	push	#1
 976  0309 ae5210        	ldw	x,#21008
 977  030c cd0000        	call	_I2C_GenerateSTART
 979  030f 84            	pop	a
 981  0310               L363:
 982                     ; 366   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_MODE_SELECT)&& I2C_TimeOut-->0)  // EV5 
 984  0310 ae0301        	ldw	x,#769
 985  0313 89            	pushw	x
 986  0314 ae5210        	ldw	x,#21008
 987  0317 cd0000        	call	_I2C_CheckEvent
 989  031a 85            	popw	x
 990  031b 4d            	tnz	a
 991  031c 2616          	jrne	L763
 993  031e 9c            	rvf
 994  031f 96            	ldw	x,sp
 995  0320 1c0001        	addw	x,#OFST-3
 996  0323 cd0000        	call	c_ltor
 998  0326 96            	ldw	x,sp
 999  0327 1c0001        	addw	x,#OFST-3
1000  032a a601          	ld	a,#1
1001  032c cd0000        	call	c_lgsbc
1003  032f cd0000        	call	c_lrzmp
1005  0332 2cdc          	jrsgt	L363
1006  0334               L763:
1007                     ; 371   I2C_Send7bitAddress(M24LR16E_I2C, EE_address, I2C_Direction_Receiver);
1009  0334 4b01          	push	#1
1010  0336 7b06          	ld	a,(OFST+2,sp)
1011  0338 88            	push	a
1012  0339 ae5210        	ldw	x,#21008
1013  033c cd0000        	call	_I2C_Send7bitAddress
1015  033f 85            	popw	x
1017  0340               L373:
1018                     ; 374   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED)&& I2C_TimeOut-->0)  // EV6 
1020  0340 ae0302        	ldw	x,#770
1021  0343 89            	pushw	x
1022  0344 ae5210        	ldw	x,#21008
1023  0347 cd0000        	call	_I2C_CheckEvent
1025  034a 85            	popw	x
1026  034b 4d            	tnz	a
1027  034c 2616          	jrne	L304
1029  034e 9c            	rvf
1030  034f 96            	ldw	x,sp
1031  0350 1c0001        	addw	x,#OFST-3
1032  0353 cd0000        	call	c_ltor
1034  0356 96            	ldw	x,sp
1035  0357 1c0001        	addw	x,#OFST-3
1036  035a a601          	ld	a,#1
1037  035c cd0000        	call	c_lgsbc
1039  035f cd0000        	call	c_lrzmp
1041  0362 2cdc          	jrsgt	L373
1042  0364               L304:
1043                     ; 379   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_BYTE_RECEIVED)&& I2C_TimeOut-->0)  // EV7 
1045  0364 ae0340        	ldw	x,#832
1046  0367 89            	pushw	x
1047  0368 ae5210        	ldw	x,#21008
1048  036b cd0000        	call	_I2C_CheckEvent
1050  036e 85            	popw	x
1051  036f 4d            	tnz	a
1052  0370 2616          	jrne	L704
1054  0372 9c            	rvf
1055  0373 96            	ldw	x,sp
1056  0374 1c0001        	addw	x,#OFST-3
1057  0377 cd0000        	call	c_ltor
1059  037a 96            	ldw	x,sp
1060  037b 1c0001        	addw	x,#OFST-3
1061  037e a601          	ld	a,#1
1062  0380 cd0000        	call	c_lgsbc
1064  0383 cd0000        	call	c_lrzmp
1066  0386 2cdc          	jrsgt	L304
1067  0388               L704:
1068                     ; 384   *pBuffer = I2C_ReceiveData(M24LR16E_I2C);
1070  0388 ae5210        	ldw	x,#21008
1071  038b cd0000        	call	_I2C_ReceiveData
1073  038e 1e0a          	ldw	x,(OFST+6,sp)
1074  0390 f7            	ld	(x),a
1075                     ; 387   I2C_AcknowledgeConfig(M24LR16E_I2C, DISABLE);
1077  0391 4b00          	push	#0
1078  0393 ae5210        	ldw	x,#21008
1079  0396 cd0000        	call	_I2C_AcknowledgeConfig
1081  0399 84            	pop	a
1082                     ; 390   I2C_GenerateSTOP(M24LR16E_I2C, ENABLE);
1084  039a 4b01          	push	#1
1085  039c ae5210        	ldw	x,#21008
1086  039f cd0000        	call	_I2C_GenerateSTOP
1088  03a2 84            	pop	a
1090  03a3               L314:
1091                     ; 393   while (I2C_GetFlagStatus(M24LR16E_I2C, I2C_FLAG_RXNE) == RESET && I2C_TimeOut-->0)
1093  03a3 ae0140        	ldw	x,#320
1094  03a6 89            	pushw	x
1095  03a7 ae5210        	ldw	x,#21008
1096  03aa cd0000        	call	_I2C_GetFlagStatus
1098  03ad 85            	popw	x
1099  03ae 4d            	tnz	a
1100  03af 2616          	jrne	L714
1102  03b1 9c            	rvf
1103  03b2 96            	ldw	x,sp
1104  03b3 1c0001        	addw	x,#OFST-3
1105  03b6 cd0000        	call	c_ltor
1107  03b9 96            	ldw	x,sp
1108  03ba 1c0001        	addw	x,#OFST-3
1109  03bd a601          	ld	a,#1
1110  03bf cd0000        	call	c_lgsbc
1112  03c2 cd0000        	call	c_lrzmp
1114  03c5 2cdc          	jrsgt	L314
1115  03c7               L714:
1116                     ; 401 }
1119  03c7 5b05          	addw	sp,#5
1120  03c9 81            	ret
1187                     ; 409 void M24LR16E_WriteOneByte (uint8_t EE_address, uint16_t ReadAddr,uint8_t pBuffer)
1187                     ; 410 {
1188                     	switch	.text
1189  03ca               _M24LR16E_WriteOneByte:
1191  03ca 88            	push	a
1192  03cb 5204          	subw	sp,#4
1193       00000004      OFST:	set	4
1196                     ; 411 int32_t I2C_TimeOut = I2C_TIMEOUT;
1198  03cd ae00ff        	ldw	x,#255
1199  03d0 1f03          	ldw	(OFST-1,sp),x
1200  03d2 ae0000        	ldw	x,#0
1201  03d5 1f01          	ldw	(OFST-3,sp),x
1202                     ; 414   I2C_GenerateSTART(M24LR16E_I2C, ENABLE);
1204  03d7 4b01          	push	#1
1205  03d9 ae5210        	ldw	x,#21008
1206  03dc cd0000        	call	_I2C_GenerateSTART
1208  03df 84            	pop	a
1210  03e0               L554:
1211                     ; 417   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_MODE_SELECT)&& I2C_TimeOut-->0)  /* EV5 */
1213  03e0 ae0301        	ldw	x,#769
1214  03e3 89            	pushw	x
1215  03e4 ae5210        	ldw	x,#21008
1216  03e7 cd0000        	call	_I2C_CheckEvent
1218  03ea 85            	popw	x
1219  03eb 4d            	tnz	a
1220  03ec 2616          	jrne	L164
1222  03ee 9c            	rvf
1223  03ef 96            	ldw	x,sp
1224  03f0 1c0001        	addw	x,#OFST-3
1225  03f3 cd0000        	call	c_ltor
1227  03f6 96            	ldw	x,sp
1228  03f7 1c0001        	addw	x,#OFST-3
1229  03fa a601          	ld	a,#1
1230  03fc cd0000        	call	c_lgsbc
1232  03ff cd0000        	call	c_lrzmp
1234  0402 2cdc          	jrsgt	L554
1235  0404               L164:
1236                     ; 422   I2C_Send7bitAddress(M24LR16E_I2C, EE_address, I2C_Direction_Transmitter);
1238  0404 4b00          	push	#0
1239  0406 7b06          	ld	a,(OFST+2,sp)
1240  0408 88            	push	a
1241  0409 ae5210        	ldw	x,#21008
1242  040c cd0000        	call	_I2C_Send7bitAddress
1244  040f 85            	popw	x
1246  0410               L564:
1247                     ; 425   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)&& I2C_TimeOut-->0) /* EV6 */
1249  0410 ae0782        	ldw	x,#1922
1250  0413 89            	pushw	x
1251  0414 ae5210        	ldw	x,#21008
1252  0417 cd0000        	call	_I2C_CheckEvent
1254  041a 85            	popw	x
1255  041b 4d            	tnz	a
1256  041c 2616          	jrne	L174
1258  041e 9c            	rvf
1259  041f 96            	ldw	x,sp
1260  0420 1c0001        	addw	x,#OFST-3
1261  0423 cd0000        	call	c_ltor
1263  0426 96            	ldw	x,sp
1264  0427 1c0001        	addw	x,#OFST-3
1265  042a a601          	ld	a,#1
1266  042c cd0000        	call	c_lgsbc
1268  042f cd0000        	call	c_lrzmp
1270  0432 2cdc          	jrsgt	L564
1271  0434               L174:
1272                     ; 430 	I2C_SendData(M24LR16E_I2C,(uint8_t)(ReadAddr >> 8)); // MSB 
1274  0434 7b08          	ld	a,(OFST+4,sp)
1275  0436 88            	push	a
1276  0437 ae5210        	ldw	x,#21008
1277  043a cd0000        	call	_I2C_SendData
1279  043d 84            	pop	a
1281  043e               L574:
1282                     ; 433   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_BYTE_TRANSMITTED)&& I2C_TimeOut-->0) // EV8 
1284  043e ae0784        	ldw	x,#1924
1285  0441 89            	pushw	x
1286  0442 ae5210        	ldw	x,#21008
1287  0445 cd0000        	call	_I2C_CheckEvent
1289  0448 85            	popw	x
1290  0449 4d            	tnz	a
1291  044a 2616          	jrne	L105
1293  044c 9c            	rvf
1294  044d 96            	ldw	x,sp
1295  044e 1c0001        	addw	x,#OFST-3
1296  0451 cd0000        	call	c_ltor
1298  0454 96            	ldw	x,sp
1299  0455 1c0001        	addw	x,#OFST-3
1300  0458 a601          	ld	a,#1
1301  045a cd0000        	call	c_lgsbc
1303  045d cd0000        	call	c_lrzmp
1305  0460 2cdc          	jrsgt	L574
1306  0462               L105:
1307                     ; 438 	I2C_SendData(M24LR16E_I2C,(uint8_t)ReadAddr); // LSB 
1309  0462 7b09          	ld	a,(OFST+5,sp)
1310  0464 88            	push	a
1311  0465 ae5210        	ldw	x,#21008
1312  0468 cd0000        	call	_I2C_SendData
1314  046b 84            	pop	a
1316  046c               L505:
1317                     ; 440   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_BYTE_TRANSMITTED)&& I2C_TimeOut-->0) // EV8 
1319  046c ae0784        	ldw	x,#1924
1320  046f 89            	pushw	x
1321  0470 ae5210        	ldw	x,#21008
1322  0473 cd0000        	call	_I2C_CheckEvent
1324  0476 85            	popw	x
1325  0477 4d            	tnz	a
1326  0478 2616          	jrne	L115
1328  047a 9c            	rvf
1329  047b 96            	ldw	x,sp
1330  047c 1c0001        	addw	x,#OFST-3
1331  047f cd0000        	call	c_ltor
1333  0482 96            	ldw	x,sp
1334  0483 1c0001        	addw	x,#OFST-3
1335  0486 a601          	ld	a,#1
1336  0488 cd0000        	call	c_lgsbc
1338  048b cd0000        	call	c_lrzmp
1340  048e 2cdc          	jrsgt	L505
1341  0490               L115:
1342                     ; 445   I2C_SendData(M24LR16E_I2C, pBuffer);
1344  0490 7b0a          	ld	a,(OFST+6,sp)
1345  0492 88            	push	a
1346  0493 ae5210        	ldw	x,#21008
1347  0496 cd0000        	call	_I2C_SendData
1349  0499 84            	pop	a
1351  049a               L515:
1352                     ; 448   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_BYTE_TRANSMITTED)&& I2C_TimeOut-->0) /* EV8 */
1354  049a ae0784        	ldw	x,#1924
1355  049d 89            	pushw	x
1356  049e ae5210        	ldw	x,#21008
1357  04a1 cd0000        	call	_I2C_CheckEvent
1359  04a4 85            	popw	x
1360  04a5 4d            	tnz	a
1361  04a6 2616          	jrne	L125
1363  04a8 9c            	rvf
1364  04a9 96            	ldw	x,sp
1365  04aa 1c0001        	addw	x,#OFST-3
1366  04ad cd0000        	call	c_ltor
1368  04b0 96            	ldw	x,sp
1369  04b1 1c0001        	addw	x,#OFST-3
1370  04b4 a601          	ld	a,#1
1371  04b6 cd0000        	call	c_lgsbc
1373  04b9 cd0000        	call	c_lrzmp
1375  04bc 2cdc          	jrsgt	L515
1376  04be               L125:
1377                     ; 453   I2C_GenerateSTOP(M24LR16E_I2C, ENABLE);
1379  04be 4b01          	push	#1
1380  04c0 ae5210        	ldw	x,#21008
1381  04c3 cd0000        	call	_I2C_GenerateSTOP
1383  04c6 84            	pop	a
1384                     ; 454 }
1387  04c7 5b05          	addw	sp,#5
1388  04c9 81            	ret
1468                     ; 469 void M24LR16E_ReadBuffer (uint8_t EE_address, uint16_t ReadAddr, uint8_t NumByteToRead,uint8_t* pBuffer)
1468                     ; 470 {
1469                     	switch	.text
1470  04ca               _M24LR16E_ReadBuffer:
1472  04ca 88            	push	a
1473  04cb 5204          	subw	sp,#4
1474       00000004      OFST:	set	4
1477                     ; 471 int32_t I2C_TimeOut = I2C_TIMEOUT;
1479  04cd ae00ff        	ldw	x,#255
1480  04d0 1f03          	ldw	(OFST-1,sp),x
1481  04d2 ae0000        	ldw	x,#0
1482  04d5 1f01          	ldw	(OFST-3,sp),x
1483                     ; 476   I2C_AcknowledgeConfig(M24LR16E_I2C, ENABLE);
1485  04d7 4b01          	push	#1
1486  04d9 ae5210        	ldw	x,#21008
1487  04dc cd0000        	call	_I2C_AcknowledgeConfig
1489  04df 84            	pop	a
1490                     ; 480   I2C_GenerateSTART(M24LR16E_I2C, ENABLE);
1492  04e0 4b01          	push	#1
1493  04e2 ae5210        	ldw	x,#21008
1494  04e5 cd0000        	call	_I2C_GenerateSTART
1496  04e8 84            	pop	a
1498  04e9               L365:
1499                     ; 483   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_MODE_SELECT)&& I2C_TimeOut-->0)  // EV5 
1501  04e9 ae0301        	ldw	x,#769
1502  04ec 89            	pushw	x
1503  04ed ae5210        	ldw	x,#21008
1504  04f0 cd0000        	call	_I2C_CheckEvent
1506  04f3 85            	popw	x
1507  04f4 4d            	tnz	a
1508  04f5 2616          	jrne	L765
1510  04f7 9c            	rvf
1511  04f8 96            	ldw	x,sp
1512  04f9 1c0001        	addw	x,#OFST-3
1513  04fc cd0000        	call	c_ltor
1515  04ff 96            	ldw	x,sp
1516  0500 1c0001        	addw	x,#OFST-3
1517  0503 a601          	ld	a,#1
1518  0505 cd0000        	call	c_lgsbc
1520  0508 cd0000        	call	c_lrzmp
1522  050b 2cdc          	jrsgt	L365
1523  050d               L765:
1524                     ; 488   I2C_Send7bitAddress(M24LR16E_I2C, EE_address , I2C_Direction_Transmitter);
1526  050d 4b00          	push	#0
1527  050f 7b06          	ld	a,(OFST+2,sp)
1528  0511 88            	push	a
1529  0512 ae5210        	ldw	x,#21008
1530  0515 cd0000        	call	_I2C_Send7bitAddress
1532  0518 85            	popw	x
1534  0519               L375:
1535                     ; 491   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)&& I2C_TimeOut-->0) // EV6 
1537  0519 ae0782        	ldw	x,#1922
1538  051c 89            	pushw	x
1539  051d ae5210        	ldw	x,#21008
1540  0520 cd0000        	call	_I2C_CheckEvent
1542  0523 85            	popw	x
1543  0524 4d            	tnz	a
1544  0525 2616          	jrne	L775
1546  0527 9c            	rvf
1547  0528 96            	ldw	x,sp
1548  0529 1c0001        	addw	x,#OFST-3
1549  052c cd0000        	call	c_ltor
1551  052f 96            	ldw	x,sp
1552  0530 1c0001        	addw	x,#OFST-3
1553  0533 a601          	ld	a,#1
1554  0535 cd0000        	call	c_lgsbc
1556  0538 cd0000        	call	c_lrzmp
1558  053b 2cdc          	jrsgt	L375
1559  053d               L775:
1560                     ; 496 	I2C_SendData(M24LR16E_I2C,(uint8_t)(ReadAddr >> 8)); // MSB 
1562  053d 7b08          	ld	a,(OFST+4,sp)
1563  053f 88            	push	a
1564  0540 ae5210        	ldw	x,#21008
1565  0543 cd0000        	call	_I2C_SendData
1567  0546 84            	pop	a
1569  0547               L306:
1570                     ; 501   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_BYTE_TRANSMITTED)&& I2C_TimeOut-->0) // EV8 
1572  0547 ae0784        	ldw	x,#1924
1573  054a 89            	pushw	x
1574  054b ae5210        	ldw	x,#21008
1575  054e cd0000        	call	_I2C_CheckEvent
1577  0551 85            	popw	x
1578  0552 4d            	tnz	a
1579  0553 2616          	jrne	L706
1581  0555 9c            	rvf
1582  0556 96            	ldw	x,sp
1583  0557 1c0001        	addw	x,#OFST-3
1584  055a cd0000        	call	c_ltor
1586  055d 96            	ldw	x,sp
1587  055e 1c0001        	addw	x,#OFST-3
1588  0561 a601          	ld	a,#1
1589  0563 cd0000        	call	c_lgsbc
1591  0566 cd0000        	call	c_lrzmp
1593  0569 2cdc          	jrsgt	L306
1594  056b               L706:
1595                     ; 506 	I2C_SendData(M24LR16E_I2C,(uint8_t)ReadAddr); // LSB 
1597  056b 7b09          	ld	a,(OFST+5,sp)
1598  056d 88            	push	a
1599  056e ae5210        	ldw	x,#21008
1600  0571 cd0000        	call	_I2C_SendData
1602  0574 84            	pop	a
1604  0575               L316:
1605                     ; 509   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_BYTE_TRANSMITTED)&& I2C_TimeOut-->0) // EV8 
1607  0575 ae0784        	ldw	x,#1924
1608  0578 89            	pushw	x
1609  0579 ae5210        	ldw	x,#21008
1610  057c cd0000        	call	_I2C_CheckEvent
1612  057f 85            	popw	x
1613  0580 4d            	tnz	a
1614  0581 2616          	jrne	L716
1616  0583 9c            	rvf
1617  0584 96            	ldw	x,sp
1618  0585 1c0001        	addw	x,#OFST-3
1619  0588 cd0000        	call	c_ltor
1621  058b 96            	ldw	x,sp
1622  058c 1c0001        	addw	x,#OFST-3
1623  058f a601          	ld	a,#1
1624  0591 cd0000        	call	c_lgsbc
1626  0594 cd0000        	call	c_lrzmp
1628  0597 2cdc          	jrsgt	L316
1629  0599               L716:
1630                     ; 515   I2C_GenerateSTART(M24LR16E_I2C, ENABLE);
1632  0599 4b01          	push	#1
1633  059b ae5210        	ldw	x,#21008
1634  059e cd0000        	call	_I2C_GenerateSTART
1636  05a1 84            	pop	a
1638  05a2               L326:
1639                     ; 518   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_MODE_SELECT)&& I2C_TimeOut-->0)  // EV5 
1641  05a2 ae0301        	ldw	x,#769
1642  05a5 89            	pushw	x
1643  05a6 ae5210        	ldw	x,#21008
1644  05a9 cd0000        	call	_I2C_CheckEvent
1646  05ac 85            	popw	x
1647  05ad 4d            	tnz	a
1648  05ae 2616          	jrne	L726
1650  05b0 9c            	rvf
1651  05b1 96            	ldw	x,sp
1652  05b2 1c0001        	addw	x,#OFST-3
1653  05b5 cd0000        	call	c_ltor
1655  05b8 96            	ldw	x,sp
1656  05b9 1c0001        	addw	x,#OFST-3
1657  05bc a601          	ld	a,#1
1658  05be cd0000        	call	c_lgsbc
1660  05c1 cd0000        	call	c_lrzmp
1662  05c4 2cdc          	jrsgt	L326
1663  05c6               L726:
1664                     ; 523   I2C_Send7bitAddress(M24LR16E_I2C, EE_address, I2C_Direction_Receiver);
1666  05c6 4b01          	push	#1
1667  05c8 7b06          	ld	a,(OFST+2,sp)
1668  05ca 88            	push	a
1669  05cb ae5210        	ldw	x,#21008
1670  05ce cd0000        	call	_I2C_Send7bitAddress
1672  05d1 85            	popw	x
1674  05d2               L336:
1675                     ; 526   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED)&& I2C_TimeOut-->0)  // EV6 
1677  05d2 ae0302        	ldw	x,#770
1678  05d5 89            	pushw	x
1679  05d6 ae5210        	ldw	x,#21008
1680  05d9 cd0000        	call	_I2C_CheckEvent
1682  05dc 85            	popw	x
1683  05dd 4d            	tnz	a
1684  05de 266a          	jrne	L346
1686  05e0 9c            	rvf
1687  05e1 96            	ldw	x,sp
1688  05e2 1c0001        	addw	x,#OFST-3
1689  05e5 cd0000        	call	c_ltor
1691  05e8 96            	ldw	x,sp
1692  05e9 1c0001        	addw	x,#OFST-3
1693  05ec a601          	ld	a,#1
1694  05ee cd0000        	call	c_lgsbc
1696  05f1 cd0000        	call	c_lrzmp
1698  05f4 2cdc          	jrsgt	L336
1699  05f6 2052          	jra	L346
1700  05f8               L156:
1701                     ; 536 		while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_BYTE_RECEIVED)&& I2C_TimeOut-->0)  
1703  05f8 ae0340        	ldw	x,#832
1704  05fb 89            	pushw	x
1705  05fc ae5210        	ldw	x,#21008
1706  05ff cd0000        	call	_I2C_CheckEvent
1708  0602 85            	popw	x
1709  0603 4d            	tnz	a
1710  0604 2616          	jrne	L556
1712  0606 9c            	rvf
1713  0607 96            	ldw	x,sp
1714  0608 1c0001        	addw	x,#OFST-3
1715  060b cd0000        	call	c_ltor
1717  060e 96            	ldw	x,sp
1718  060f 1c0001        	addw	x,#OFST-3
1719  0612 a601          	ld	a,#1
1720  0614 cd0000        	call	c_lgsbc
1722  0617 cd0000        	call	c_lrzmp
1724  061a 2cdc          	jrsgt	L156
1725  061c               L556:
1726                     ; 541 		*pBuffer = I2C_ReceiveData(M24LR16E_I2C);
1728  061c ae5210        	ldw	x,#21008
1729  061f cd0000        	call	_I2C_ReceiveData
1731  0622 1e0b          	ldw	x,(OFST+7,sp)
1732  0624 f7            	ld	(x),a
1733                     ; 544 		if(NumByteToRead == 1)
1735  0625 7b0a          	ld	a,(OFST+6,sp)
1736  0627 a101          	cp	a,#1
1737  0629 2609          	jrne	L756
1738                     ; 547 			I2C_AcknowledgeConfig(M24LR16E_I2C, DISABLE);
1740  062b 4b00          	push	#0
1741  062d ae5210        	ldw	x,#21008
1742  0630 cd0000        	call	_I2C_AcknowledgeConfig
1744  0633 84            	pop	a
1745  0634               L756:
1746                     ; 552     pBuffer++; 
1748  0634 1e0b          	ldw	x,(OFST+7,sp)
1749  0636 1c0001        	addw	x,#1
1750  0639 1f0b          	ldw	(OFST+7,sp),x
1751                     ; 554     NumByteToRead--; 
1753  063b 0a0a          	dec	(OFST+6,sp)
1754                     ; 556     if(NumByteToRead == 0)
1756  063d 0d0a          	tnz	(OFST+6,sp)
1757  063f 2609          	jrne	L346
1758                     ; 559 			I2C_GenerateSTOP(M24LR16E_I2C, ENABLE);
1760  0641 4b01          	push	#1
1761  0643 ae5210        	ldw	x,#21008
1762  0646 cd0000        	call	_I2C_GenerateSTOP
1764  0649 84            	pop	a
1765  064a               L346:
1766                     ; 532   while(NumByteToRead )  
1768  064a 0d0a          	tnz	(OFST+6,sp)
1769  064c 26aa          	jrne	L156
1770                     ; 566 	*pBuffer = I2C_ReceiveData(M24LR16E_I2C);
1772  064e ae5210        	ldw	x,#21008
1773  0651 cd0000        	call	_I2C_ReceiveData
1775  0654 1e0b          	ldw	x,(OFST+7,sp)
1776  0656 f7            	ld	(x),a
1778  0657               L766:
1779                     ; 569   while (I2C_GetFlagStatus(M24LR16E_I2C, I2C_FLAG_RXNE) == RESET&& I2C_TimeOut-->0)
1781  0657 ae0140        	ldw	x,#320
1782  065a 89            	pushw	x
1783  065b ae5210        	ldw	x,#21008
1784  065e cd0000        	call	_I2C_GetFlagStatus
1786  0661 85            	popw	x
1787  0662 4d            	tnz	a
1788  0663 2616          	jrne	L376
1790  0665 9c            	rvf
1791  0666 96            	ldw	x,sp
1792  0667 1c0001        	addw	x,#OFST-3
1793  066a cd0000        	call	c_ltor
1795  066d 96            	ldw	x,sp
1796  066e 1c0001        	addw	x,#OFST-3
1797  0671 a601          	ld	a,#1
1798  0673 cd0000        	call	c_lgsbc
1800  0676 cd0000        	call	c_lrzmp
1802  0679 2cdc          	jrsgt	L766
1803  067b               L376:
1804                     ; 572 }
1807  067b 5b05          	addw	sp,#5
1808  067d 81            	ret
1850                     ; 579 uint16_t M24LR16E_ReadTemp(void)
1850                     ; 580 {
1851                     	switch	.text
1852  067e               _M24LR16E_ReadTemp:
1854  067e 89            	pushw	x
1855       00000002      OFST:	set	2
1858                     ; 581   __IO uint16_t RegValue = 0;
1860  067f 5f            	clrw	x
1861  0680 1f01          	ldw	(OFST-1,sp),x
1862                     ; 584   I2C_AcknowledgeConfig(M24LR16E_I2C, ENABLE);
1864  0682 4b01          	push	#1
1865  0684 ae5210        	ldw	x,#21008
1866  0687 cd0000        	call	_I2C_AcknowledgeConfig
1868  068a 84            	pop	a
1869                     ; 588   I2C_GenerateSTART(M24LR16E_I2C, ENABLE);
1871  068b 4b01          	push	#1
1872  068d ae5210        	ldw	x,#21008
1873  0690 cd0000        	call	_I2C_GenerateSTART
1875  0693 84            	pop	a
1877  0694               L517:
1878                     ; 591   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_MODE_SELECT))  /* EV5 */
1880  0694 ae0301        	ldw	x,#769
1881  0697 89            	pushw	x
1882  0698 ae5210        	ldw	x,#21008
1883  069b cd0000        	call	_I2C_CheckEvent
1885  069e 85            	popw	x
1886  069f 4d            	tnz	a
1887  06a0 27f2          	jreq	L517
1888                     ; 596   I2C_Send7bitAddress(M24LR16E_I2C, M24LR16E_ADDR, I2C_Direction_Transmitter);
1890  06a2 4b00          	push	#0
1891  06a4 4b90          	push	#144
1892  06a6 ae5210        	ldw	x,#21008
1893  06a9 cd0000        	call	_I2C_Send7bitAddress
1895  06ac 85            	popw	x
1897  06ad               L327:
1898                     ; 599   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)) /* EV6 */
1900  06ad ae0782        	ldw	x,#1922
1901  06b0 89            	pushw	x
1902  06b1 ae5210        	ldw	x,#21008
1903  06b4 cd0000        	call	_I2C_CheckEvent
1905  06b7 85            	popw	x
1906  06b8 4d            	tnz	a
1907  06b9 27f2          	jreq	L327
1908                     ; 604   I2C_SendData(M24LR16E_I2C, M24LR16E_REG_TEMP);
1910  06bb 4b00          	push	#0
1911  06bd ae5210        	ldw	x,#21008
1912  06c0 cd0000        	call	_I2C_SendData
1914  06c3 84            	pop	a
1916  06c4               L137:
1917                     ; 607   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_BYTE_TRANSMITTED)) /* EV8 */
1919  06c4 ae0784        	ldw	x,#1924
1920  06c7 89            	pushw	x
1921  06c8 ae5210        	ldw	x,#21008
1922  06cb cd0000        	call	_I2C_CheckEvent
1924  06ce 85            	popw	x
1925  06cf 4d            	tnz	a
1926  06d0 27f2          	jreq	L137
1927                     ; 613   I2C_GenerateSTART(M24LR16E_I2C, ENABLE);
1929  06d2 4b01          	push	#1
1930  06d4 ae5210        	ldw	x,#21008
1931  06d7 cd0000        	call	_I2C_GenerateSTART
1933  06da 84            	pop	a
1935  06db               L737:
1936                     ; 616   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_MODE_SELECT))  /* EV5 */
1938  06db ae0301        	ldw	x,#769
1939  06de 89            	pushw	x
1940  06df ae5210        	ldw	x,#21008
1941  06e2 cd0000        	call	_I2C_CheckEvent
1943  06e5 85            	popw	x
1944  06e6 4d            	tnz	a
1945  06e7 27f2          	jreq	L737
1946                     ; 621   I2C_Send7bitAddress(M24LR16E_I2C, M24LR16E_ADDR, I2C_Direction_Receiver);
1948  06e9 4b01          	push	#1
1949  06eb 4b90          	push	#144
1950  06ed ae5210        	ldw	x,#21008
1951  06f0 cd0000        	call	_I2C_Send7bitAddress
1953  06f3 85            	popw	x
1955  06f4               L547:
1956                     ; 624   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED))  /* EV6 */
1958  06f4 ae0302        	ldw	x,#770
1959  06f7 89            	pushw	x
1960  06f8 ae5210        	ldw	x,#21008
1961  06fb cd0000        	call	_I2C_CheckEvent
1963  06fe 85            	popw	x
1964  06ff 4d            	tnz	a
1965  0700 27f2          	jreq	L547
1967  0702               L357:
1968                     ; 629   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_BYTE_RECEIVED))  /* EV7 */
1970  0702 ae0340        	ldw	x,#832
1971  0705 89            	pushw	x
1972  0706 ae5210        	ldw	x,#21008
1973  0709 cd0000        	call	_I2C_CheckEvent
1975  070c 85            	popw	x
1976  070d 4d            	tnz	a
1977  070e 27f2          	jreq	L357
1978                     ; 634   RegValue = I2C_ReceiveData(M24LR16E_I2C) << 8;
1980  0710 ae5210        	ldw	x,#21008
1981  0713 cd0000        	call	_I2C_ReceiveData
1983  0716 5f            	clrw	x
1984  0717 97            	ld	xl,a
1985  0718 4f            	clr	a
1986  0719 02            	rlwa	x,a
1987  071a 1f01          	ldw	(OFST-1,sp),x
1988                     ; 637   I2C_AcknowledgeConfig(M24LR16E_I2C, DISABLE);
1990  071c 4b00          	push	#0
1991  071e ae5210        	ldw	x,#21008
1992  0721 cd0000        	call	_I2C_AcknowledgeConfig
1994  0724 84            	pop	a
1995                     ; 640   I2C_GenerateSTOP(M24LR16E_I2C, ENABLE);
1997  0725 4b01          	push	#1
1998  0727 ae5210        	ldw	x,#21008
1999  072a cd0000        	call	_I2C_GenerateSTOP
2001  072d 84            	pop	a
2003  072e               L167:
2004                     ; 643   while (I2C_GetFlagStatus(M24LR16E_I2C, I2C_FLAG_RXNE) == RESET)
2006  072e ae0140        	ldw	x,#320
2007  0731 89            	pushw	x
2008  0732 ae5210        	ldw	x,#21008
2009  0735 cd0000        	call	_I2C_GetFlagStatus
2011  0738 85            	popw	x
2012  0739 4d            	tnz	a
2013  073a 27f2          	jreq	L167
2014                     ; 647   RegValue |= I2C_ReceiveData(M24LR16E_I2C);
2016  073c ae5210        	ldw	x,#21008
2017  073f cd0000        	call	_I2C_ReceiveData
2019  0742 5f            	clrw	x
2020  0743 97            	ld	xl,a
2021  0744 01            	rrwa	x,a
2022  0745 1a02          	or	a,(OFST+0,sp)
2023  0747 01            	rrwa	x,a
2024  0748 1a01          	or	a,(OFST-1,sp)
2025  074a 01            	rrwa	x,a
2026  074b 1f01          	ldw	(OFST-1,sp),x
2027                     ; 650   return (RegValue >> 7);
2029  074d 1e01          	ldw	x,(OFST-1,sp)
2030  074f 4f            	clr	a
2031  0750 01            	rrwa	x,a
2032  0751 48            	sll	a
2033  0752 59            	rlcw	x
2036  0753 5b02          	addw	sp,#2
2037  0755 81            	ret
2080                     ; 658 uint8_t M24LR16E_ReadConfReg(void)
2080                     ; 659 {
2081                     	switch	.text
2082  0756               _M24LR16E_ReadConfReg:
2084  0756 88            	push	a
2085       00000001      OFST:	set	1
2088                     ; 660   __IO uint8_t RegValue = 0;
2090  0757 0f01          	clr	(OFST+0,sp)
2091                     ; 663   I2C_AcknowledgeConfig(M24LR16E_I2C, ENABLE);
2093  0759 4b01          	push	#1
2094  075b ae5210        	ldw	x,#21008
2095  075e cd0000        	call	_I2C_AcknowledgeConfig
2097  0761 84            	pop	a
2098                     ; 666   I2C_GenerateSTART(M24LR16E_I2C, ENABLE);
2100  0762 4b01          	push	#1
2101  0764 ae5210        	ldw	x,#21008
2102  0767 cd0000        	call	_I2C_GenerateSTART
2104  076a 84            	pop	a
2106  076b               L5001:
2107                     ; 669   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_MODE_SELECT))  /* EV5 */
2109  076b ae0301        	ldw	x,#769
2110  076e 89            	pushw	x
2111  076f ae5210        	ldw	x,#21008
2112  0772 cd0000        	call	_I2C_CheckEvent
2114  0775 85            	popw	x
2115  0776 4d            	tnz	a
2116  0777 27f2          	jreq	L5001
2117                     ; 674   I2C_Send7bitAddress(M24LR16E_I2C, M24LR16E_ADDR, I2C_Direction_Transmitter);
2119  0779 4b00          	push	#0
2120  077b 4b90          	push	#144
2121  077d ae5210        	ldw	x,#21008
2122  0780 cd0000        	call	_I2C_Send7bitAddress
2124  0783 85            	popw	x
2126  0784               L3101:
2127                     ; 677   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)) /* EV6 */
2129  0784 ae0782        	ldw	x,#1922
2130  0787 89            	pushw	x
2131  0788 ae5210        	ldw	x,#21008
2132  078b cd0000        	call	_I2C_CheckEvent
2134  078e 85            	popw	x
2135  078f 4d            	tnz	a
2136  0790 27f2          	jreq	L3101
2137                     ; 682   I2C_SendData(M24LR16E_I2C, M24LR16E_REG_CONF);
2139  0792 4b01          	push	#1
2140  0794 ae5210        	ldw	x,#21008
2141  0797 cd0000        	call	_I2C_SendData
2143  079a 84            	pop	a
2145  079b               L1201:
2146                     ; 685   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_BYTE_TRANSMITTED)) /* EV8 */
2148  079b ae0784        	ldw	x,#1924
2149  079e 89            	pushw	x
2150  079f ae5210        	ldw	x,#21008
2151  07a2 cd0000        	call	_I2C_CheckEvent
2153  07a5 85            	popw	x
2154  07a6 4d            	tnz	a
2155  07a7 27f2          	jreq	L1201
2156                     ; 691   I2C_GenerateSTART(M24LR16E_I2C, ENABLE);
2158  07a9 4b01          	push	#1
2159  07ab ae5210        	ldw	x,#21008
2160  07ae cd0000        	call	_I2C_GenerateSTART
2162  07b1 84            	pop	a
2164  07b2               L7201:
2165                     ; 694   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_MODE_SELECT))  /* EV5 */
2167  07b2 ae0301        	ldw	x,#769
2168  07b5 89            	pushw	x
2169  07b6 ae5210        	ldw	x,#21008
2170  07b9 cd0000        	call	_I2C_CheckEvent
2172  07bc 85            	popw	x
2173  07bd 4d            	tnz	a
2174  07be 27f2          	jreq	L7201
2175                     ; 699   I2C_Send7bitAddress(M24LR16E_I2C, M24LR16E_ADDR, I2C_Direction_Receiver);
2177  07c0 4b01          	push	#1
2178  07c2 4b90          	push	#144
2179  07c4 ae5210        	ldw	x,#21008
2180  07c7 cd0000        	call	_I2C_Send7bitAddress
2182  07ca 85            	popw	x
2184  07cb               L5301:
2185                     ; 702   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED))  /* EV6 */
2187  07cb ae0302        	ldw	x,#770
2188  07ce 89            	pushw	x
2189  07cf ae5210        	ldw	x,#21008
2190  07d2 cd0000        	call	_I2C_CheckEvent
2192  07d5 85            	popw	x
2193  07d6 4d            	tnz	a
2194  07d7 27f2          	jreq	L5301
2195                     ; 707   I2C_AcknowledgeConfig(M24LR16E_I2C, DISABLE);
2197  07d9 4b00          	push	#0
2198  07db ae5210        	ldw	x,#21008
2199  07de cd0000        	call	_I2C_AcknowledgeConfig
2201  07e1 84            	pop	a
2202                     ; 710   I2C_GenerateSTOP(M24LR16E_I2C, ENABLE);
2204  07e2 4b01          	push	#1
2205  07e4 ae5210        	ldw	x,#21008
2206  07e7 cd0000        	call	_I2C_GenerateSTOP
2208  07ea 84            	pop	a
2210  07eb               L3401:
2211                     ; 713   while (I2C_GetFlagStatus(M24LR16E_I2C, I2C_FLAG_RXNE) == RESET);
2213  07eb ae0140        	ldw	x,#320
2214  07ee 89            	pushw	x
2215  07ef ae5210        	ldw	x,#21008
2216  07f2 cd0000        	call	_I2C_GetFlagStatus
2218  07f5 85            	popw	x
2219  07f6 4d            	tnz	a
2220  07f7 27f2          	jreq	L3401
2221                     ; 716   RegValue = I2C_ReceiveData(M24LR16E_I2C);
2223  07f9 ae5210        	ldw	x,#21008
2224  07fc cd0000        	call	_I2C_ReceiveData
2226  07ff 6b01          	ld	(OFST+0,sp),a
2227                     ; 719   return (RegValue);
2229  0801 7b01          	ld	a,(OFST+0,sp)
2232  0803 5b01          	addw	sp,#1
2233  0805 81            	ret
2273                     ; 728 void M24LR16E_WriteConfReg(uint8_t RegValue)
2273                     ; 729 {
2274                     	switch	.text
2275  0806               _M24LR16E_WriteConfReg:
2277  0806 88            	push	a
2278       00000000      OFST:	set	0
2281                     ; 732   I2C_GenerateSTART(M24LR16E_I2C, ENABLE);
2283  0807 4b01          	push	#1
2284  0809 ae5210        	ldw	x,#21008
2285  080c cd0000        	call	_I2C_GenerateSTART
2287  080f 84            	pop	a
2289  0810               L7601:
2290                     ; 735   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_MODE_SELECT))  /* EV5 */
2292  0810 ae0301        	ldw	x,#769
2293  0813 89            	pushw	x
2294  0814 ae5210        	ldw	x,#21008
2295  0817 cd0000        	call	_I2C_CheckEvent
2297  081a 85            	popw	x
2298  081b 4d            	tnz	a
2299  081c 27f2          	jreq	L7601
2300                     ; 740   I2C_Send7bitAddress(M24LR16E_I2C, M24LR16E_ADDR, I2C_Direction_Transmitter);
2302  081e 4b00          	push	#0
2303  0820 4b90          	push	#144
2304  0822 ae5210        	ldw	x,#21008
2305  0825 cd0000        	call	_I2C_Send7bitAddress
2307  0828 85            	popw	x
2309  0829               L5701:
2310                     ; 743   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)) /* EV6 */
2312  0829 ae0782        	ldw	x,#1922
2313  082c 89            	pushw	x
2314  082d ae5210        	ldw	x,#21008
2315  0830 cd0000        	call	_I2C_CheckEvent
2317  0833 85            	popw	x
2318  0834 4d            	tnz	a
2319  0835 27f2          	jreq	L5701
2320                     ; 748   I2C_SendData(M24LR16E_I2C, M24LR16E_REG_CONF);
2322  0837 4b01          	push	#1
2323  0839 ae5210        	ldw	x,#21008
2324  083c cd0000        	call	_I2C_SendData
2326  083f 84            	pop	a
2328  0840               L3011:
2329                     ; 751   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_BYTE_TRANSMITTED)) /* EV8 */
2331  0840 ae0784        	ldw	x,#1924
2332  0843 89            	pushw	x
2333  0844 ae5210        	ldw	x,#21008
2334  0847 cd0000        	call	_I2C_CheckEvent
2336  084a 85            	popw	x
2337  084b 4d            	tnz	a
2338  084c 27f2          	jreq	L3011
2339                     ; 756   I2C_SendData(M24LR16E_I2C, RegValue);
2341  084e 7b01          	ld	a,(OFST+1,sp)
2342  0850 88            	push	a
2343  0851 ae5210        	ldw	x,#21008
2344  0854 cd0000        	call	_I2C_SendData
2346  0857 84            	pop	a
2348  0858               L1111:
2349                     ; 759   while (!I2C_CheckEvent(M24LR16E_I2C, I2C_EVENT_MASTER_BYTE_TRANSMITTED)) /* EV8 */
2351  0858 ae0784        	ldw	x,#1924
2352  085b 89            	pushw	x
2353  085c ae5210        	ldw	x,#21008
2354  085f cd0000        	call	_I2C_CheckEvent
2356  0862 85            	popw	x
2357  0863 4d            	tnz	a
2358  0864 27f2          	jreq	L1111
2359                     ; 764   I2C_GenerateSTOP(M24LR16E_I2C, ENABLE);
2361  0866 4b01          	push	#1
2362  0868 ae5210        	ldw	x,#21008
2363  086b cd0000        	call	_I2C_GenerateSTOP
2365  086e 84            	pop	a
2366                     ; 765 }
2369  086f 84            	pop	a
2370  0870 81            	ret
2398                     ; 885 static void M24LR16E_LowLevel_DeInit(void)
2398                     ; 886 {
2399                     	switch	.text
2400  0871               L3_M24LR16E_LowLevel_DeInit:
2404                     ; 888   I2C_Cmd(M24LR16E_I2C, DISABLE);
2406  0871 4b00          	push	#0
2407  0873 ae5210        	ldw	x,#21008
2408  0876 cd0000        	call	_I2C_Cmd
2410  0879 84            	pop	a
2411                     ; 890   I2C_DeInit(M24LR16E_I2C);
2413  087a ae5210        	ldw	x,#21008
2414  087d cd0000        	call	_I2C_DeInit
2416                     ; 893   CLK_PeripheralClockConfig(M24LR16E_I2C_CLK, DISABLE);
2418  0880 ae0300        	ldw	x,#768
2419  0883 cd0000        	call	_CLK_PeripheralClockConfig
2421                     ; 896   GPIO_Init(M24LR16E_I2C_SCL_GPIO_PORT, M24LR16E_I2C_SCL_PIN, GPIO_Mode_In_PU_No_IT);
2423  0886 4b40          	push	#64
2424  0888 4b02          	push	#2
2425  088a ae500a        	ldw	x,#20490
2426  088d cd0000        	call	_GPIO_Init
2428  0890 85            	popw	x
2429                     ; 899   GPIO_Init(M24LR16E_I2C_SDA_GPIO_PORT, M24LR16E_I2C_SDA_PIN, GPIO_Mode_In_PU_No_IT);
2431  0891 4b40          	push	#64
2432  0893 4b01          	push	#1
2433  0895 ae500a        	ldw	x,#20490
2434  0898 cd0000        	call	_GPIO_Init
2436  089b 85            	popw	x
2437                     ; 903 }
2440  089c 81            	ret
2465                     ; 910 static void M24LR16E_LowLevel_Init(void)
2465                     ; 911 {
2466                     	switch	.text
2467  089d               L5_M24LR16E_LowLevel_Init:
2471                     ; 913   CLK_PeripheralClockConfig(M24LR16E_I2C_CLK, ENABLE);
2473  089d ae0301        	ldw	x,#769
2474  08a0 cd0000        	call	_CLK_PeripheralClockConfig
2476                     ; 918 }
2479  08a3 81            	ret
2492                     	xdef	_M24LR16E_WriteOneByte
2493                     	xdef	_M24LR16E_ReadBuffer
2494                     	xdef	_M24LR16E_ReadOneByte
2495                     	xdef	_M24LR16E_WriteConfReg
2496                     	xdef	_M24LR16E_ReadConfReg
2497                     	xdef	_M24LR16E_WriteReg
2498                     	xdef	_M24LR16E_ReadReg
2499                     	xdef	_M24LR16E_ReadTemp
2500                     	xdef	_M24LR16E_GetStatus
2501                     	xdef	_M24LR16E_Init
2502                     	xdef	_M24LR16E_DeInit
2503                     	xref	_I2C_ClearFlag
2504                     	xref	_I2C_GetFlagStatus
2505                     	xref	_I2C_CheckEvent
2506                     	xref	_I2C_Send7bitAddress
2507                     	xref	_I2C_ReceiveData
2508                     	xref	_I2C_SendData
2509                     	xref	_I2C_AcknowledgeConfig
2510                     	xref	_I2C_GenerateSTOP
2511                     	xref	_I2C_GenerateSTART
2512                     	xref	_I2C_Cmd
2513                     	xref	_I2C_Init
2514                     	xref	_I2C_DeInit
2515                     	xref	_GPIO_Init
2516                     	xref	_CLK_PeripheralClockConfig
2535                     	xref	c_lrzmp
2536                     	xref	c_ltor
2537                     	xref	c_lzmp
2538                     	xref	c_lgsbc
2539                     	end
