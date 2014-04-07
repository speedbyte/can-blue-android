   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.19 - 04 Sep 2013
   3                     ; Generator (Limited) V4.3.11 - 04 Sep 2013
  49                     ; 73 void I2C_SS_Init(void)
  49                     ; 74 {
  51                     	switch	.text
  52  0000               _I2C_SS_Init:
  56                     ; 76   I2C_SS_LowLevel_Init();
  58  0000 ad2a          	call	L3_I2C_SS_LowLevel_Init
  60                     ; 79   I2C_DeInit(STTS751_I2C);
  62  0002 ae5210        	ldw	x,#21008
  63  0005 cd0000        	call	_I2C_DeInit
  65                     ; 82 	I2C_Init(STTS751_I2C, STTS75_I2C_SPEED, 0x00, I2C_Mode_I2C,
  65                     ; 83            I2C_DutyCycle_2, I2C_Ack_Enable, I2C_AcknowledgedAddress_7bit);
  67  0008 4b00          	push	#0
  68  000a 4b04          	push	#4
  69  000c 4b00          	push	#0
  70  000e 4b00          	push	#0
  71  0010 5f            	clrw	x
  72  0011 89            	pushw	x
  73  0012 ae4e20        	ldw	x,#20000
  74  0015 89            	pushw	x
  75  0016 ae0000        	ldw	x,#0
  76  0019 89            	pushw	x
  77  001a ae5210        	ldw	x,#21008
  78  001d cd0000        	call	_I2C_Init
  80  0020 5b0a          	addw	sp,#10
  81                     ; 89   I2C_Cmd(STTS751_I2C, ENABLE);
  83  0022 4b01          	push	#1
  84  0024 ae5210        	ldw	x,#21008
  85  0027 cd0000        	call	_I2C_Cmd
  87  002a 84            	pop	a
  88                     ; 90 }
  91  002b 81            	ret
 116                     ; 97 static void I2C_SS_LowLevel_Init(void)
 116                     ; 98 {
 117                     	switch	.text
 118  002c               L3_I2C_SS_LowLevel_Init:
 122                     ; 100   CLK_PeripheralClockConfig(M24LR04E_I2C_CLK, ENABLE);
 124  002c ae0301        	ldw	x,#769
 125  002f cd0000        	call	_CLK_PeripheralClockConfig
 127                     ; 105 }
 130  0032 81            	ret
 180                     ; 118 void I2C_SS_Config ( uint16_t ConfigBytes ) 
 180                     ; 119 {
 181                     	switch	.text
 182  0033               _I2C_SS_Config:
 184  0033 89            	pushw	x
 185  0034 5204          	subw	sp,#4
 186       00000004      OFST:	set	4
 189                     ; 120 int32_t I2C_TimeOut = I2C_TIMEOUT;
 191  0036 ae00ff        	ldw	x,#255
 192  0039 1f03          	ldw	(OFST-1,sp),x
 193  003b ae0000        	ldw	x,#0
 194  003e 1f01          	ldw	(OFST-3,sp),x
 195                     ; 122 	I2C_AcknowledgeConfig(STTS751_I2C, ENABLE);	
 197  0040 4b01          	push	#1
 198  0042 ae5210        	ldw	x,#21008
 199  0045 cd0000        	call	_I2C_AcknowledgeConfig
 201  0048 84            	pop	a
 202                     ; 124   I2C_GenerateSTART(STTS751_I2C, ENABLE);
 204  0049 4b01          	push	#1
 205  004b ae5210        	ldw	x,#21008
 206  004e cd0000        	call	_I2C_GenerateSTART
 208  0051 84            	pop	a
 210  0052               L75:
 211                     ; 127   while( !I2C_CheckEvent(STTS751_I2C,I2C_EVENT_MASTER_MODE_SELECT)&& I2C_TimeOut-->0); 
 213  0052 ae0301        	ldw	x,#769
 214  0055 89            	pushw	x
 215  0056 ae5210        	ldw	x,#21008
 216  0059 cd0000        	call	_I2C_CheckEvent
 218  005c 85            	popw	x
 219  005d 4d            	tnz	a
 220  005e 2616          	jrne	L36
 222  0060 9c            	rvf
 223  0061 96            	ldw	x,sp
 224  0062 1c0001        	addw	x,#OFST-3
 225  0065 cd0000        	call	c_ltor
 227  0068 96            	ldw	x,sp
 228  0069 1c0001        	addw	x,#OFST-3
 229  006c a601          	ld	a,#1
 230  006e cd0000        	call	c_lgsbc
 232  0071 cd0000        	call	c_lrzmp
 234  0074 2cdc          	jrsgt	L75
 235  0076               L36:
 236                     ; 131   I2C_Send7bitAddress(STTS751_I2C, STTS751_ADDRESS, I2C_Direction_Transmitter);
 238  0076 4b00          	push	#0
 239  0078 4b72          	push	#114
 240  007a ae5210        	ldw	x,#21008
 241  007d cd0000        	call	_I2C_Send7bitAddress
 243  0080 85            	popw	x
 245  0081               L76:
 246                     ; 134 	while( !I2C_CheckEvent(STTS751_I2C,I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)&& I2C_TimeOut-->0);
 248  0081 ae0782        	ldw	x,#1922
 249  0084 89            	pushw	x
 250  0085 ae5210        	ldw	x,#21008
 251  0088 cd0000        	call	_I2C_CheckEvent
 253  008b 85            	popw	x
 254  008c 4d            	tnz	a
 255  008d 2616          	jrne	L37
 257  008f 9c            	rvf
 258  0090 96            	ldw	x,sp
 259  0091 1c0001        	addw	x,#OFST-3
 260  0094 cd0000        	call	c_ltor
 262  0097 96            	ldw	x,sp
 263  0098 1c0001        	addw	x,#OFST-3
 264  009b a601          	ld	a,#1
 265  009d cd0000        	call	c_lgsbc
 267  00a0 cd0000        	call	c_lrzmp
 269  00a3 2cdc          	jrsgt	L76
 270  00a5               L37:
 271                     ; 136 	I2C_GetFlagStatus(STTS751_I2C,I2C_FLAG_ADDR);
 273  00a5 ae0102        	ldw	x,#258
 274  00a8 89            	pushw	x
 275  00a9 ae5210        	ldw	x,#21008
 276  00ac cd0000        	call	_I2C_GetFlagStatus
 278  00af 85            	popw	x
 279                     ; 137 	(void)(STTS751_I2C->SR3);
 281  00b0 c65219        	ld	a,21017
 282                     ; 140   I2C_SendData(STTS751_I2C,(uint8_t)((ConfigBytes & 0xFF00) >> 8)); /* MSB */
 284  00b3 7b05          	ld	a,(OFST+1,sp)
 285  00b5 97            	ld	xl,a
 286  00b6 7b06          	ld	a,(OFST+2,sp)
 287  00b8 9f            	ld	a,xl
 288  00b9 a4ff          	and	a,#255
 289  00bb 97            	ld	xl,a
 290  00bc 4f            	clr	a
 291  00bd 02            	rlwa	x,a
 292  00be 4f            	clr	a
 293  00bf 01            	rrwa	x,a
 294  00c0 9f            	ld	a,xl
 295  00c1 88            	push	a
 296  00c2 ae5210        	ldw	x,#21008
 297  00c5 cd0000        	call	_I2C_SendData
 299  00c8 84            	pop	a
 301  00c9               L77:
 302                     ; 143   while (!I2C_CheckEvent(STTS751_I2C,I2C_EVENT_MASTER_BYTE_TRANSMITTING)&& I2C_TimeOut-->0);
 304  00c9 ae0780        	ldw	x,#1920
 305  00cc 89            	pushw	x
 306  00cd ae5210        	ldw	x,#21008
 307  00d0 cd0000        	call	_I2C_CheckEvent
 309  00d3 85            	popw	x
 310  00d4 4d            	tnz	a
 311  00d5 2616          	jrne	L301
 313  00d7 9c            	rvf
 314  00d8 96            	ldw	x,sp
 315  00d9 1c0001        	addw	x,#OFST-3
 316  00dc cd0000        	call	c_ltor
 318  00df 96            	ldw	x,sp
 319  00e0 1c0001        	addw	x,#OFST-3
 320  00e3 a601          	ld	a,#1
 321  00e5 cd0000        	call	c_lgsbc
 323  00e8 cd0000        	call	c_lrzmp
 325  00eb 2cdc          	jrsgt	L77
 326  00ed               L301:
 327                     ; 145 	I2C_SendData(STTS751_I2C,(uint8_t)((ConfigBytes & 0x00FF))); /* LSB */
 329  00ed 7b06          	ld	a,(OFST+2,sp)
 330  00ef a4ff          	and	a,#255
 331  00f1 88            	push	a
 332  00f2 ae5210        	ldw	x,#21008
 333  00f5 cd0000        	call	_I2C_SendData
 335  00f8 84            	pop	a
 337  00f9               L701:
 338                     ; 148   while (!I2C_CheckEvent(STTS751_I2C,I2C_EVENT_MASTER_BYTE_TRANSMITTING)&& I2C_TimeOut-->0);
 340  00f9 ae0780        	ldw	x,#1920
 341  00fc 89            	pushw	x
 342  00fd ae5210        	ldw	x,#21008
 343  0100 cd0000        	call	_I2C_CheckEvent
 345  0103 85            	popw	x
 346  0104 4d            	tnz	a
 347  0105 2616          	jrne	L311
 349  0107 9c            	rvf
 350  0108 96            	ldw	x,sp
 351  0109 1c0001        	addw	x,#OFST-3
 352  010c cd0000        	call	c_ltor
 354  010f 96            	ldw	x,sp
 355  0110 1c0001        	addw	x,#OFST-3
 356  0113 a601          	ld	a,#1
 357  0115 cd0000        	call	c_lgsbc
 359  0118 cd0000        	call	c_lrzmp
 361  011b 2cdc          	jrsgt	L701
 362  011d               L311:
 363                     ; 150 	I2C_GenerateSTOP(STTS751_I2C,ENABLE);
 365  011d 4b01          	push	#1
 366  011f ae5210        	ldw	x,#21008
 367  0122 cd0000        	call	_I2C_GenerateSTOP
 369  0125 84            	pop	a
 370                     ; 152 }
 373  0126 5b06          	addw	sp,#6
 374  0128 81            	ret
 445                     ; 164 void I2C_SS_BufferRead(uint8_t* pBuffer, uint8_t Pointer_Byte, uint8_t NumByteToRead)
 445                     ; 165 {  
 446                     	switch	.text
 447  0129               _I2C_SS_BufferRead:
 449  0129 89            	pushw	x
 450  012a 5204          	subw	sp,#4
 451       00000004      OFST:	set	4
 454                     ; 166 int32_t I2C_TimeOut = I2C_TIMEOUT;
 456  012c ae00ff        	ldw	x,#255
 457  012f 1f03          	ldw	(OFST-1,sp),x
 458  0131 ae0000        	ldw	x,#0
 459  0134 1f01          	ldw	(OFST-3,sp),x
 460                     ; 168 		I2C_AcknowledgeConfig(STTS751_I2C, ENABLE);
 462  0136 4b01          	push	#1
 463  0138 ae5210        	ldw	x,#21008
 464  013b cd0000        	call	_I2C_AcknowledgeConfig
 466  013e 84            	pop	a
 467                     ; 171   I2C_GenerateSTART(STTS751_I2C, ENABLE);
 469  013f 4b01          	push	#1
 470  0141 ae5210        	ldw	x,#21008
 471  0144 cd0000        	call	_I2C_GenerateSTART
 473  0147 84            	pop	a
 475  0148               L151:
 476                     ; 174   while (!I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_MODE_SELECT)&& I2C_TimeOut-->0)  // EV5 
 478  0148 ae0301        	ldw	x,#769
 479  014b 89            	pushw	x
 480  014c ae5210        	ldw	x,#21008
 481  014f cd0000        	call	_I2C_CheckEvent
 483  0152 85            	popw	x
 484  0153 4d            	tnz	a
 485  0154 2616          	jrne	L551
 487  0156 9c            	rvf
 488  0157 96            	ldw	x,sp
 489  0158 1c0001        	addw	x,#OFST-3
 490  015b cd0000        	call	c_ltor
 492  015e 96            	ldw	x,sp
 493  015f 1c0001        	addw	x,#OFST-3
 494  0162 a601          	ld	a,#1
 495  0164 cd0000        	call	c_lgsbc
 497  0167 cd0000        	call	c_lrzmp
 499  016a 2cdc          	jrsgt	L151
 500  016c               L551:
 501                     ; 179   I2C_Send7bitAddress(STTS751_I2C, STTS751_ADDRESS, I2C_Direction_Transmitter);
 503  016c 4b00          	push	#0
 504  016e 4b72          	push	#114
 505  0170 ae5210        	ldw	x,#21008
 506  0173 cd0000        	call	_I2C_Send7bitAddress
 508  0176 85            	popw	x
 510  0177               L161:
 511                     ; 181   while ( !I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)&& I2C_TimeOut-->0);
 513  0177 ae0782        	ldw	x,#1922
 514  017a 89            	pushw	x
 515  017b ae5210        	ldw	x,#21008
 516  017e cd0000        	call	_I2C_CheckEvent
 518  0181 85            	popw	x
 519  0182 4d            	tnz	a
 520  0183 2616          	jrne	L561
 522  0185 9c            	rvf
 523  0186 96            	ldw	x,sp
 524  0187 1c0001        	addw	x,#OFST-3
 525  018a cd0000        	call	c_ltor
 527  018d 96            	ldw	x,sp
 528  018e 1c0001        	addw	x,#OFST-3
 529  0191 a601          	ld	a,#1
 530  0193 cd0000        	call	c_lgsbc
 532  0196 cd0000        	call	c_lrzmp
 534  0199 2cdc          	jrsgt	L161
 535  019b               L561:
 536                     ; 182   I2C_GetFlagStatus(STTS751_I2C, I2C_FLAG_ADDR);
 538  019b ae0102        	ldw	x,#258
 539  019e 89            	pushw	x
 540  019f ae5210        	ldw	x,#21008
 541  01a2 cd0000        	call	_I2C_GetFlagStatus
 543  01a5 85            	popw	x
 544                     ; 183 	(void)(STTS751_I2C->SR3);
 546  01a6 c65219        	ld	a,21017
 547                     ; 185 	I2C_SendData(STTS751_I2C, (Pointer_Byte)); /* LSB */
 549  01a9 7b09          	ld	a,(OFST+5,sp)
 550  01ab 88            	push	a
 551  01ac ae5210        	ldw	x,#21008
 552  01af cd0000        	call	_I2C_SendData
 554  01b2 84            	pop	a
 556  01b3               L171:
 557                     ; 187   while (!I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_BYTE_TRANSMITTED)&& I2C_TimeOut-->0);
 559  01b3 ae0784        	ldw	x,#1924
 560  01b6 89            	pushw	x
 561  01b7 ae5210        	ldw	x,#21008
 562  01ba cd0000        	call	_I2C_CheckEvent
 564  01bd 85            	popw	x
 565  01be 4d            	tnz	a
 566  01bf 2616          	jrne	L571
 568  01c1 9c            	rvf
 569  01c2 96            	ldw	x,sp
 570  01c3 1c0001        	addw	x,#OFST-3
 571  01c6 cd0000        	call	c_ltor
 573  01c9 96            	ldw	x,sp
 574  01ca 1c0001        	addw	x,#OFST-3
 575  01cd a601          	ld	a,#1
 576  01cf cd0000        	call	c_lgsbc
 578  01d2 cd0000        	call	c_lrzmp
 580  01d5 2cdc          	jrsgt	L171
 581  01d7               L571:
 582                     ; 190 	I2C_GenerateSTART(STTS751_I2C, ENABLE);
 584  01d7 4b01          	push	#1
 585  01d9 ae5210        	ldw	x,#21008
 586  01dc cd0000        	call	_I2C_GenerateSTART
 588  01df 84            	pop	a
 590  01e0               L102:
 591                     ; 193   while (!I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_MODE_SELECT)&& I2C_TimeOut-->0);
 593  01e0 ae0301        	ldw	x,#769
 594  01e3 89            	pushw	x
 595  01e4 ae5210        	ldw	x,#21008
 596  01e7 cd0000        	call	_I2C_CheckEvent
 598  01ea 85            	popw	x
 599  01eb 4d            	tnz	a
 600  01ec 2616          	jrne	L502
 602  01ee 9c            	rvf
 603  01ef 96            	ldw	x,sp
 604  01f0 1c0001        	addw	x,#OFST-3
 605  01f3 cd0000        	call	c_ltor
 607  01f6 96            	ldw	x,sp
 608  01f7 1c0001        	addw	x,#OFST-3
 609  01fa a601          	ld	a,#1
 610  01fc cd0000        	call	c_lgsbc
 612  01ff cd0000        	call	c_lrzmp
 614  0202 2cdc          	jrsgt	L102
 615  0204               L502:
 616                     ; 196   I2C_Send7bitAddress(STTS751_I2C, STTS751_ADDRESS, I2C_Direction_Receiver);
 618  0204 4b01          	push	#1
 619  0206 4b72          	push	#114
 620  0208 ae5210        	ldw	x,#21008
 621  020b cd0000        	call	_I2C_Send7bitAddress
 623  020e 85            	popw	x
 625  020f               L112:
 626                     ; 198   while (!I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED)&& I2C_TimeOut-->0);
 628  020f ae0302        	ldw	x,#770
 629  0212 89            	pushw	x
 630  0213 ae5210        	ldw	x,#21008
 631  0216 cd0000        	call	_I2C_CheckEvent
 633  0219 85            	popw	x
 634  021a 4d            	tnz	a
 635  021b 2616          	jrne	L512
 637  021d 9c            	rvf
 638  021e 96            	ldw	x,sp
 639  021f 1c0001        	addw	x,#OFST-3
 640  0222 cd0000        	call	c_ltor
 642  0225 96            	ldw	x,sp
 643  0226 1c0001        	addw	x,#OFST-3
 644  0229 a601          	ld	a,#1
 645  022b cd0000        	call	c_lgsbc
 647  022e cd0000        	call	c_lrzmp
 649  0231 2cdc          	jrsgt	L112
 650  0233               L512:
 651                     ; 199   I2C_GetFlagStatus(STTS751_I2C, I2C_FLAG_ADDR);
 653  0233 ae0102        	ldw	x,#258
 654  0236 89            	pushw	x
 655  0237 ae5210        	ldw	x,#21008
 656  023a cd0000        	call	_I2C_GetFlagStatus
 658  023d 85            	popw	x
 659                     ; 200 	(void)(STTS751_I2C->SR3);
 661  023e c65219        	ld	a,21017
 663  0241 2040          	jra	L122
 664  0243               L712:
 665                     ; 206 		if(NumByteToRead == 1)
 667  0243 7b0a          	ld	a,(OFST+6,sp)
 668  0245 a101          	cp	a,#1
 669  0247 260d          	jrne	L522
 670                     ; 209 			I2C_AcknowledgeConfig(STTS751_I2C,DISABLE);	
 672  0249 4b00          	push	#0
 673  024b ae5210        	ldw	x,#21008
 674  024e cd0000        	call	_I2C_AcknowledgeConfig
 676  0251 84            	pop	a
 677                     ; 210 			STTS751_I2C->CR2 |= 0x02;		
 679  0252 72125211      	bset	21009,#1
 680  0256               L522:
 681                     ; 214 		if(I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_BYTE_RECEIVED))
 683  0256 ae0340        	ldw	x,#832
 684  0259 89            	pushw	x
 685  025a ae5210        	ldw	x,#21008
 686  025d cd0000        	call	_I2C_CheckEvent
 688  0260 85            	popw	x
 689  0261 4d            	tnz	a
 690  0262 2712          	jreq	L722
 691                     ; 217 			*pBuffer = I2C_ReceiveData(STTS751_I2C);
 693  0264 ae5210        	ldw	x,#21008
 694  0267 cd0000        	call	_I2C_ReceiveData
 696  026a 1e05          	ldw	x,(OFST+1,sp)
 697  026c f7            	ld	(x),a
 698                     ; 220 			pBuffer++; 
 700  026d 1e05          	ldw	x,(OFST+1,sp)
 701  026f 1c0001        	addw	x,#1
 702  0272 1f05          	ldw	(OFST+1,sp),x
 703                     ; 223 			NumByteToRead--;    
 705  0274 0a0a          	dec	(OFST+6,sp)
 706  0276               L722:
 707                     ; 225 		if(NumByteToRead == 0)
 709  0276 0d0a          	tnz	(OFST+6,sp)
 710  0278 2609          	jrne	L122
 711                     ; 228 			I2C_GenerateSTOP(STTS751_I2C, ENABLE);
 713  027a 4b01          	push	#1
 714  027c ae5210        	ldw	x,#21008
 715  027f cd0000        	call	_I2C_GenerateSTOP
 717  0282 84            	pop	a
 718  0283               L122:
 719                     ; 204 	while( NumByteToRead&& I2C_TimeOut-->0)  
 721  0283 0d0a          	tnz	(OFST+6,sp)
 722  0285 2716          	jreq	L332
 724  0287 9c            	rvf
 725  0288 96            	ldw	x,sp
 726  0289 1c0001        	addw	x,#OFST-3
 727  028c cd0000        	call	c_ltor
 729  028f 96            	ldw	x,sp
 730  0290 1c0001        	addw	x,#OFST-3
 731  0293 a601          	ld	a,#1
 732  0295 cd0000        	call	c_lgsbc
 734  0298 cd0000        	call	c_lrzmp
 736  029b 2ca6          	jrsgt	L712
 737  029d               L332:
 738                     ; 233 	I2C_AckPositionConfig(STTS751_I2C,		I2C_AckPosition_Current);	
 740  029d 4b00          	push	#0
 741  029f ae5210        	ldw	x,#21008
 742  02a2 cd0000        	call	_I2C_AckPositionConfig
 744  02a5 84            	pop	a
 745                     ; 234 	I2C_GenerateSTOP(STTS751_I2C, ENABLE);
 747  02a6 4b01          	push	#1
 748  02a8 ae5210        	ldw	x,#21008
 749  02ab cd0000        	call	_I2C_GenerateSTOP
 751  02ae 84            	pop	a
 752                     ; 235 }
 755  02af 5b06          	addw	sp,#6
 756  02b1 81            	ret
 817                     ; 249 void I2C_SS_ReadOneByte(uint8_t *pBuffer, uint8_t Pointer_Byte)
 817                     ; 250 {  
 818                     	switch	.text
 819  02b2               _I2C_SS_ReadOneByte:
 821  02b2 89            	pushw	x
 822  02b3 5204          	subw	sp,#4
 823       00000004      OFST:	set	4
 826                     ; 251 int32_t I2C_TimeOut = I2C_TIMEOUT;
 828  02b5 ae00ff        	ldw	x,#255
 829  02b8 1f03          	ldw	(OFST-1,sp),x
 830  02ba ae0000        	ldw	x,#0
 831  02bd 1f01          	ldw	(OFST-3,sp),x
 832                     ; 253 		I2C_AcknowledgeConfig(STTS751_I2C, ENABLE);
 834  02bf 4b01          	push	#1
 835  02c1 ae5210        	ldw	x,#21008
 836  02c4 cd0000        	call	_I2C_AcknowledgeConfig
 838  02c7 84            	pop	a
 839                     ; 256   I2C_GenerateSTART(STTS751_I2C, ENABLE);
 841  02c8 4b01          	push	#1
 842  02ca ae5210        	ldw	x,#21008
 843  02cd cd0000        	call	_I2C_GenerateSTART
 845  02d0 84            	pop	a
 847  02d1               L562:
 848                     ; 259   while (!I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_MODE_SELECT)&& I2C_TimeOut-->0)  // EV5 
 850  02d1 ae0301        	ldw	x,#769
 851  02d4 89            	pushw	x
 852  02d5 ae5210        	ldw	x,#21008
 853  02d8 cd0000        	call	_I2C_CheckEvent
 855  02db 85            	popw	x
 856  02dc 4d            	tnz	a
 857  02dd 2616          	jrne	L172
 859  02df 9c            	rvf
 860  02e0 96            	ldw	x,sp
 861  02e1 1c0001        	addw	x,#OFST-3
 862  02e4 cd0000        	call	c_ltor
 864  02e7 96            	ldw	x,sp
 865  02e8 1c0001        	addw	x,#OFST-3
 866  02eb a601          	ld	a,#1
 867  02ed cd0000        	call	c_lgsbc
 869  02f0 cd0000        	call	c_lrzmp
 871  02f3 2cdc          	jrsgt	L562
 872  02f5               L172:
 873                     ; 264   I2C_Send7bitAddress(STTS751_I2C, STTS751_ADDRESS, I2C_Direction_Transmitter);
 875  02f5 4b00          	push	#0
 876  02f7 4b72          	push	#114
 877  02f9 ae5210        	ldw	x,#21008
 878  02fc cd0000        	call	_I2C_Send7bitAddress
 880  02ff 85            	popw	x
 882  0300               L572:
 883                     ; 266   while ( !I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)&& I2C_TimeOut-->0);
 885  0300 ae0782        	ldw	x,#1922
 886  0303 89            	pushw	x
 887  0304 ae5210        	ldw	x,#21008
 888  0307 cd0000        	call	_I2C_CheckEvent
 890  030a 85            	popw	x
 891  030b 4d            	tnz	a
 892  030c 2616          	jrne	L103
 894  030e 9c            	rvf
 895  030f 96            	ldw	x,sp
 896  0310 1c0001        	addw	x,#OFST-3
 897  0313 cd0000        	call	c_ltor
 899  0316 96            	ldw	x,sp
 900  0317 1c0001        	addw	x,#OFST-3
 901  031a a601          	ld	a,#1
 902  031c cd0000        	call	c_lgsbc
 904  031f cd0000        	call	c_lrzmp
 906  0322 2cdc          	jrsgt	L572
 907  0324               L103:
 908                     ; 267   I2C_GetFlagStatus(STTS751_I2C, I2C_FLAG_ADDR);
 910  0324 ae0102        	ldw	x,#258
 911  0327 89            	pushw	x
 912  0328 ae5210        	ldw	x,#21008
 913  032b cd0000        	call	_I2C_GetFlagStatus
 915  032e 85            	popw	x
 916                     ; 268 	(void)(STTS751_I2C->SR3);
 918  032f c65219        	ld	a,21017
 919                     ; 270 	I2C_SendData(STTS751_I2C, (Pointer_Byte)); /* LSB */
 921  0332 7b09          	ld	a,(OFST+5,sp)
 922  0334 88            	push	a
 923  0335 ae5210        	ldw	x,#21008
 924  0338 cd0000        	call	_I2C_SendData
 926  033b 84            	pop	a
 928  033c               L503:
 929                     ; 272   while (!I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_BYTE_TRANSMITTED)&& I2C_TimeOut-->0);
 931  033c ae0784        	ldw	x,#1924
 932  033f 89            	pushw	x
 933  0340 ae5210        	ldw	x,#21008
 934  0343 cd0000        	call	_I2C_CheckEvent
 936  0346 85            	popw	x
 937  0347 4d            	tnz	a
 938  0348 2616          	jrne	L113
 940  034a 9c            	rvf
 941  034b 96            	ldw	x,sp
 942  034c 1c0001        	addw	x,#OFST-3
 943  034f cd0000        	call	c_ltor
 945  0352 96            	ldw	x,sp
 946  0353 1c0001        	addw	x,#OFST-3
 947  0356 a601          	ld	a,#1
 948  0358 cd0000        	call	c_lgsbc
 950  035b cd0000        	call	c_lrzmp
 952  035e 2cdc          	jrsgt	L503
 953  0360               L113:
 954                     ; 275 	I2C_GenerateSTART(STTS751_I2C, ENABLE);
 956  0360 4b01          	push	#1
 957  0362 ae5210        	ldw	x,#21008
 958  0365 cd0000        	call	_I2C_GenerateSTART
 960  0368 84            	pop	a
 962  0369               L513:
 963                     ; 278   while (!I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_MODE_SELECT)&& I2C_TimeOut-->0);
 965  0369 ae0301        	ldw	x,#769
 966  036c 89            	pushw	x
 967  036d ae5210        	ldw	x,#21008
 968  0370 cd0000        	call	_I2C_CheckEvent
 970  0373 85            	popw	x
 971  0374 4d            	tnz	a
 972  0375 2616          	jrne	L123
 974  0377 9c            	rvf
 975  0378 96            	ldw	x,sp
 976  0379 1c0001        	addw	x,#OFST-3
 977  037c cd0000        	call	c_ltor
 979  037f 96            	ldw	x,sp
 980  0380 1c0001        	addw	x,#OFST-3
 981  0383 a601          	ld	a,#1
 982  0385 cd0000        	call	c_lgsbc
 984  0388 cd0000        	call	c_lrzmp
 986  038b 2cdc          	jrsgt	L513
 987  038d               L123:
 988                     ; 281   I2C_Send7bitAddress(STTS751_I2C, STTS751_ADDRESS, I2C_Direction_Receiver);
 990  038d 4b01          	push	#1
 991  038f 4b72          	push	#114
 992  0391 ae5210        	ldw	x,#21008
 993  0394 cd0000        	call	_I2C_Send7bitAddress
 995  0397 85            	popw	x
 997  0398               L523:
 998                     ; 284   while (!I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED)&& I2C_TimeOut-->0)  // EV6 
1000  0398 ae0302        	ldw	x,#770
1001  039b 89            	pushw	x
1002  039c ae5210        	ldw	x,#21008
1003  039f cd0000        	call	_I2C_CheckEvent
1005  03a2 85            	popw	x
1006  03a3 4d            	tnz	a
1007  03a4 2616          	jrne	L533
1009  03a6 9c            	rvf
1010  03a7 96            	ldw	x,sp
1011  03a8 1c0001        	addw	x,#OFST-3
1012  03ab cd0000        	call	c_ltor
1014  03ae 96            	ldw	x,sp
1015  03af 1c0001        	addw	x,#OFST-3
1016  03b2 a601          	ld	a,#1
1017  03b4 cd0000        	call	c_lgsbc
1019  03b7 cd0000        	call	c_lrzmp
1021  03ba 2cdc          	jrsgt	L523
1022  03bc               L533:
1023                     ; 289   while (!I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_BYTE_RECEIVED)&& I2C_TimeOut-->0)  // EV7 
1025  03bc ae0340        	ldw	x,#832
1026  03bf 89            	pushw	x
1027  03c0 ae5210        	ldw	x,#21008
1028  03c3 cd0000        	call	_I2C_CheckEvent
1030  03c6 85            	popw	x
1031  03c7 4d            	tnz	a
1032  03c8 2616          	jrne	L143
1034  03ca 9c            	rvf
1035  03cb 96            	ldw	x,sp
1036  03cc 1c0001        	addw	x,#OFST-3
1037  03cf cd0000        	call	c_ltor
1039  03d2 96            	ldw	x,sp
1040  03d3 1c0001        	addw	x,#OFST-3
1041  03d6 a601          	ld	a,#1
1042  03d8 cd0000        	call	c_lgsbc
1044  03db cd0000        	call	c_lrzmp
1046  03de 2cdc          	jrsgt	L533
1047  03e0               L143:
1048                     ; 294   *pBuffer = I2C_ReceiveData(STTS751_I2C);
1050  03e0 ae5210        	ldw	x,#21008
1051  03e3 cd0000        	call	_I2C_ReceiveData
1053  03e6 1e05          	ldw	x,(OFST+1,sp)
1054  03e8 f7            	ld	(x),a
1055                     ; 297   I2C_AcknowledgeConfig(STTS751_I2C, DISABLE);
1057  03e9 4b00          	push	#0
1058  03eb ae5210        	ldw	x,#21008
1059  03ee cd0000        	call	_I2C_AcknowledgeConfig
1061  03f1 84            	pop	a
1062                     ; 300   I2C_GenerateSTOP(STTS751_I2C, ENABLE);
1064  03f2 4b01          	push	#1
1065  03f4 ae5210        	ldw	x,#21008
1066  03f7 cd0000        	call	_I2C_GenerateSTOP
1068  03fa 84            	pop	a
1070  03fb               L543:
1071                     ; 303   while (I2C_GetFlagStatus(STTS751_I2C, I2C_FLAG_RXNE) == RESET && I2C_TimeOut-->0)
1073  03fb ae0140        	ldw	x,#320
1074  03fe 89            	pushw	x
1075  03ff ae5210        	ldw	x,#21008
1076  0402 cd0000        	call	_I2C_GetFlagStatus
1078  0405 85            	popw	x
1079  0406 4d            	tnz	a
1080  0407 2616          	jrne	L153
1082  0409 9c            	rvf
1083  040a 96            	ldw	x,sp
1084  040b 1c0001        	addw	x,#OFST-3
1085  040e cd0000        	call	c_ltor
1087  0411 96            	ldw	x,sp
1088  0412 1c0001        	addw	x,#OFST-3
1089  0415 a601          	ld	a,#1
1090  0417 cd0000        	call	c_lgsbc
1092  041a cd0000        	call	c_lrzmp
1094  041d 2cdc          	jrsgt	L543
1095  041f               L153:
1096                     ; 305 }
1099  041f 5b06          	addw	sp,#6
1100  0421 81            	ret
1113                     	xdef	_I2C_SS_ReadOneByte
1114                     	xdef	_I2C_SS_BufferRead
1115                     	xdef	_I2C_SS_Config
1116                     	xdef	_I2C_SS_Init
1117                     	xref	_I2C_GetFlagStatus
1118                     	xref	_I2C_CheckEvent
1119                     	xref	_I2C_Send7bitAddress
1120                     	xref	_I2C_ReceiveData
1121                     	xref	_I2C_SendData
1122                     	xref	_I2C_AckPositionConfig
1123                     	xref	_I2C_AcknowledgeConfig
1124                     	xref	_I2C_GenerateSTOP
1125                     	xref	_I2C_GenerateSTART
1126                     	xref	_I2C_Cmd
1127                     	xref	_I2C_Init
1128                     	xref	_I2C_DeInit
1129                     	xref	_CLK_PeripheralClockConfig
1148                     	xref	c_lrzmp
1149                     	xref	c_lgsbc
1150                     	xref	c_ltor
1151                     	end
