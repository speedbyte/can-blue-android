   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.19 - 04 Sep 2013
   3                     ; Generator (Limited) V4.3.11 - 04 Sep 2013
  17                     .const:	section	.text
  18  0000               _ErrorMessage:
  19  0000 4e            	dc.b	78
  20  0001 4f            	dc.b	79
  21  0002 54            	dc.b	84
  22  0003 20            	dc.b	32
  23  0004 41            	dc.b	65
  24  0005 20            	dc.b	32
  25  0006 4e            	dc.b	78
  26  0007 44            	dc.b	68
  27  0008 45            	dc.b	69
  28  0009 46            	dc.b	70
  29  000a 20            	dc.b	32
  30  000b 54            	dc.b	84
  31  000c 45            	dc.b	69
  32  000d 58            	dc.b	88
  33  000e 54            	dc.b	84
  34  000f 20            	dc.b	32
  35  0010 4d            	dc.b	77
  36  0011 45            	dc.b	69
  37  0012 53            	dc.b	83
  38  0013 53            	dc.b	83
  39  0014 41            	dc.b	65
  40  0015 47            	dc.b	71
  41  0016 45            	dc.b	69
  42  0017 20            	dc.b	32
  43  0018 20            	dc.b	32
  44  0019 20            	dc.b	32
  45  001a 20            	dc.b	32
  46  001b 20            	dc.b	32
  47  001c 20            	dc.b	32
  48  001d 20            	dc.b	32
  49  001e 20            	dc.b	32
  50  001f 20            	dc.b	32
  51  0020 20            	dc.b	32
  52  0021 20            	dc.b	32
  53  0022 20            	dc.b	32
  54  0023 20            	dc.b	32
  55  0024 20            	dc.b	32
  56  0025 20            	dc.b	32
  57  0026 20            	dc.b	32
  58  0027 20            	dc.b	32
  59  0028 20            	dc.b	32
  68                     .eeprom:	section	.data
  69  0000               _EEInitial:
  70  0000 00            	dc.b	0
  71                     	switch	.const
  72  0029               _FirmwareVersion:
  73  0029 13            	dc.b	19
  74  002a 00            	dc.b	0
 163                     ; 115 void main(void)
 163                     ; 116 { 
 165                     	switch	.text
 166  0000               _main:
 168  0000 5204          	subw	sp,#4
 169       00000004      OFST:	set	4
 172                     ; 122 	DeInitClock();
 174  0002 cd09ac        	call	L71_DeInitClock
 176                     ; 123 	DeInitGPIO();
 178  0005 cd0a35        	call	L12_DeInitGPIO
 180                     ; 127 		CLK_SYSCLKSourceConfig(CLK_SYSCLKSource_HSI);
 182  0008 a601          	ld	a,#1
 183  000a cd0000        	call	_CLK_SYSCLKSourceConfig
 185                     ; 128 		CLK_SYSCLKDivConfig(CLK_SYSCLKDiv_16);	
 187  000d a604          	ld	a,#4
 188  000f cd0000        	call	_CLK_SYSCLKDivConfig
 190                     ; 138   LCD_GLASS_Init();
 192  0012 cd0000        	call	_LCD_GLASS_Init
 194                     ; 142 	GPIO_Init( LED_GPIO_PORT, LED_GPIO_PIN, GPIO_Mode_Out_PP_Low_Fast);
 196  0015 4be0          	push	#224
 197  0017 4b40          	push	#64
 198  0019 ae5014        	ldw	x,#20500
 199  001c cd0000        	call	_GPIO_Init
 201  001f 85            	popw	x
 202                     ; 144 	GPIOE->ODR &= ~LED_GPIO_PIN;
 204  0020 721d5014      	bres	20500,#6
 205                     ; 147   GPIO_Init( BUTTON_GPIO_PORT, USER_GPIO_PIN, GPIO_Mode_In_FL_IT);
 207  0024 4b20          	push	#32
 208  0026 4b80          	push	#128
 209  0028 ae500a        	ldw	x,#20490
 210  002b cd0000        	call	_GPIO_Init
 212  002e 85            	popw	x
 213                     ; 148 	EXTI_SetPinSensitivity(EXTI_Pin_7, EXTI_Trigger_Falling);
 215  002f ae1602        	ldw	x,#5634
 216  0032 cd0000        	call	_EXTI_SetPinSensitivity
 218                     ; 151   BAR0_OFF;
 220  0035 721f0000      	bres	_t_bar,#7
 221                     ; 152   BAR1_OFF;
 223  0039 72170001      	bres	_t_bar+1,#3
 224                     ; 153   BAR2_OFF;
 226  003d 721b0000      	bres	_t_bar,#5
 227                     ; 154   BAR3_OFF;	
 229  0041 72130001      	bres	_t_bar+1,#1
 230                     ; 156 	enableInterrupts();
 233  0045 9a            rim
 235                     ; 160 	bufMessage = NDEFmessage;
 238                     ; 162 	if (EEMenuState > STATE_TEMPMEAS) 
 240  0046 c6000e        	ld	a,_EEMenuState
 241  0049 a103          	cp	a,#3
 242  004b 2507          	jrult	L531
 243                     ; 163 		EEMenuState = STATE_CHECKNDEFMESSAGE;
 245  004d 4f            	clr	a
 246  004e ae000e        	ldw	x,#_EEMenuState
 247  0051 cd0000        	call	c_eewrc
 249  0054               L531:
 250                     ; 165 	FLASH_Unlock(FLASH_MemType_Data );
 252  0054 a6f7          	ld	a,#247
 253  0056 cd0000        	call	_FLASH_Unlock
 255                     ; 167 	state_machine = EEMenuState ; 
 257  0059 55000e0042    	mov	_state_machine,_EEMenuState
 258                     ; 169 	delayLFO_ms (1);
 260  005e ae0001        	ldw	x,#1
 261  0061 cd0000        	call	_delayLFO_ms
 263                     ; 175 	if (EEInitial == 0 )
 265  0064 725d0000      	tnz	_EEInitial
 266  0068 260b          	jrne	L141
 267                     ; 177 			User_WriteFirmwareVersion ();
 269  006a cd06d1        	call	L34_User_WriteFirmwareVersion
 271                     ; 178 			EEInitial =1;
 273  006d a601          	ld	a,#1
 274  006f ae0000        	ldw	x,#_EEInitial
 275  0072 cd0000        	call	c_eewrc
 277  0075               L141:
 278                     ; 184 		switch (state_machine)
 280  0075 b642          	ld	a,_state_machine
 282                     ; 256         break;
 283  0077 4d            	tnz	a
 284  0078 2723          	jreq	L37
 285  007a 4a            	dec	a
 286  007b 2715          	jreq	L17
 287  007d 4a            	dec	a
 288  007e 2603cc0109    	jreq	L57
 289  0083               L77:
 290                     ; 252         default:
 290                     ; 253 					LCD_GLASS_Clear();
 293  0083 cd0000        	call	_LCD_GLASS_Clear
 295                     ; 254 					LCD_GLASS_DisplayString("Error");
 297  0086 ae002b        	ldw	x,#L371
 298  0089 cd0000        	call	_LCD_GLASS_DisplayString
 300                     ; 255 					state_machine = STATE_VREF;
 302  008c 35010042      	mov	_state_machine,#1
 303                     ; 256         break;
 305  0090 20e3          	jra	L141
 306  0092               L17:
 307                     ; 187 				case STATE_VREF:
 307                     ; 188 					// measure the voltage available at the output of the M24LR04E-R
 307                     ; 189 					Vref_measure();
 309  0092 cd0000        	call	_Vref_measure
 311                     ; 191 					delayLFO_ms (2);
 313  0095 ae0002        	ldw	x,#2
 314  0098 cd0000        	call	_delayLFO_ms
 316                     ; 194         break;
 318  009b 20d8          	jra	L141
 319  009d               L37:
 320                     ; 196         case STATE_CHECKNDEFMESSAGE:
 320                     ; 197 				
 320                     ; 198 				
 320                     ; 199 				if(User_ReadNDEFMessage (&PayloadLength) == SUCCESS)
 322  009d 96            	ldw	x,sp
 323  009e 1c0003        	addw	x,#OFST-1
 324  00a1 cd01a1        	call	L13_User_ReadNDEFMessage
 326  00a4 a101          	cp	a,#1
 327  00a6 2657          	jrne	L151
 328                     ; 202 					if(Check_Code_Length() == SUCCESS)
 330  00a8 cd0227        	call	L16_Check_Code_Length
 332  00ab a101          	cp	a,#1
 333  00ad 263e          	jrne	L351
 334                     ; 204 						LCD_GLASS_Clear();
 336  00af cd0000        	call	_LCD_GLASS_Clear
 338                     ; 209 						if( EE_Buf_Flag[0] == 0x00 ) // geoeffnete Zustand
 340  00b2 725d0001      	tnz	_EE_Buf_Flag
 341  00b6 2617          	jrne	L551
 342                     ; 211 							GPIO_ResetBits(LED_GPIO_PORT,GPIO_Pin_6);
 344  00b8 4b40          	push	#64
 345  00ba ae5014        	ldw	x,#20500
 346  00bd cd0000        	call	_GPIO_ResetBits
 348  00c0 84            	pop	a
 349                     ; 212 							State_DisplayMessage ("OPEN", 4);
 351  00c1 4b04          	push	#4
 352  00c3 ae005a        	ldw	x,#L751
 353  00c6 cd0655        	call	L75_State_DisplayMessage
 355  00c9 84            	pop	a
 356                     ; 213 							Copy_Units_in_other_memory(); //Zustands Transaktion von geoffnet nach geschlossen
 358  00ca cd04c1        	call	L54_Copy_Units_in_other_memory
 361  00cd 2030          	jra	L151
 362  00cf               L551:
 363                     ; 216 						else if( EE_Buf_Flag[0] == 0xFF ) // geschlossene Zustand
 365  00cf c60001        	ld	a,_EE_Buf_Flag
 366  00d2 a1ff          	cp	a,#255
 367  00d4 2629          	jrne	L151
 368                     ; 218 							GPIO_SetBits(LED_GPIO_PORT,GPIO_Pin_6);
 370  00d6 4b40          	push	#64
 371  00d8 ae5014        	ldw	x,#20500
 372  00db cd0000        	call	_GPIO_SetBits
 374  00de 84            	pop	a
 375                     ; 219 							State_DisplayMessage ("CLOSED", 6);
 377  00df 4b06          	push	#6
 378  00e1 ae0053        	ldw	x,#L561
 379  00e4 cd0655        	call	L75_State_DisplayMessage
 381  00e7 84            	pop	a
 382                     ; 220 							Read_Units_from_memory();   //Zustands Transaktion von geschlossen nach geoffnet
 384  00e8 cd0367        	call	L35_Read_Units_from_memory
 386  00eb 2012          	jra	L151
 387  00ed               L351:
 388                     ; 225 							LCD_GLASS_Clear();
 390  00ed cd0000        	call	_LCD_GLASS_Clear
 392                     ; 226 							User_DisplayMessage ("ONLY 4 CHARACTERS ENTER PIN AGAIN", 30);
 394  00f0 4b1e          	push	#30
 395  00f2 ae0031        	ldw	x,#L171
 396  00f5 cd0719        	call	L33_User_DisplayMessage
 398  00f8 84            	pop	a
 399                     ; 227 							delayLFO_ms (2);
 401  00f9 ae0002        	ldw	x,#2
 402  00fc cd0000        	call	_delayLFO_ms
 404  00ff               L151:
 405                     ; 234 					delayLFO_ms (2);
 407  00ff ae0002        	ldw	x,#2
 408  0102 cd0000        	call	_delayLFO_ms
 410                     ; 236         break;
 412  0105 ac750075      	jpf	L141
 413  0109               L57:
 414                     ; 238 				case STATE_TEMPMEAS:
 414                     ; 239 						
 414                     ; 240 						// read the ambiant tempserature from the STTS751
 414                     ; 241 						User_GetOneTemperature (&data_sensor);
 416  0109 96            	ldw	x,sp
 417  010a 1c0004        	addw	x,#OFST+0
 418  010d ad12          	call	L73_User_GetOneTemperature
 420                     ; 243 						User_DisplayOneTemperature (data_sensor);
 422  010f 7b04          	ld	a,(OFST+0,sp)
 423  0111 ad40          	call	L14_User_DisplayOneTemperature
 425                     ; 245 						delayLFO_ms (2);
 427  0113 ae0002        	ldw	x,#2
 428  0116 cd0000        	call	_delayLFO_ms
 430                     ; 247 				break;
 432  0119 ac750075      	jpf	L141
 433  011d               L741:
 434                     ; 256         break;
 435  011d ac750075      	jpf	L141
 485                     ; 269 static void User_GetOneTemperature (uint8_t *data_sensor)
 485                     ; 270 {
 486                     	switch	.text
 487  0121               L73_User_GetOneTemperature:
 489  0121 89            	pushw	x
 490  0122 88            	push	a
 491       00000001      OFST:	set	1
 494                     ; 271 	uint8_t 	Pointer_temperature = 0x00;					// temperature access 
 496  0123 0f01          	clr	(OFST+0,sp)
 497                     ; 274 	data_sensor[0] = 0x00;
 499  0125 7f            	clr	(x)
 500                     ; 276 	I2C_SS_Init();
 502  0126 cd0000        	call	_I2C_SS_Init
 504                     ; 277 	I2C_SS_Config(STTS751_STOP);
 506  0129 ae0340        	ldw	x,#832
 507  012c cd0000        	call	_I2C_SS_Config
 509                     ; 279 	delayLFO_ms (1);
 511  012f ae0001        	ldw	x,#1
 512  0132 cd0000        	call	_delayLFO_ms
 514                     ; 280 	I2C_SS_Config(STTS751_ONESHOTMODE);
 516  0135 ae0f00        	ldw	x,#3840
 517  0138 cd0000        	call	_I2C_SS_Config
 519                     ; 282 	delayLFO_ms (1);
 521  013b ae0001        	ldw	x,#1
 522  013e cd0000        	call	_delayLFO_ms
 524                     ; 284 	I2C_SS_ReadOneByte(data_sensor,Pointer_temperature);
 526  0141 7b01          	ld	a,(OFST+0,sp)
 527  0143 88            	push	a
 528  0144 1e03          	ldw	x,(OFST+2,sp)
 529  0146 cd0000        	call	_I2C_SS_ReadOneByte
 531  0149 84            	pop	a
 532                     ; 286 	delayLFO_ms (1);
 534  014a ae0001        	ldw	x,#1
 535  014d cd0000        	call	_delayLFO_ms
 537                     ; 288 }
 540  0150 5b03          	addw	sp,#3
 541  0152 81            	ret
 587                     ; 295 static void User_DisplayOneTemperature (uint8_t data_sensor)
 587                     ; 296 {
 588                     	switch	.text
 589  0153               L14_User_DisplayOneTemperature:
 591  0153 88            	push	a
 592  0154 520c          	subw	sp,#12
 593       0000000c      OFST:	set	12
 596                     ; 299 	TempChar16[5] = 'C';
 598  0156 ae0043        	ldw	x,#67
 599  0159 1f0b          	ldw	(OFST-1,sp),x
 600                     ; 300 	TempChar16[4] = ' ';
 602  015b ae0020        	ldw	x,#32
 603  015e 1f09          	ldw	(OFST-3,sp),x
 604                     ; 302 	if ((data_sensor & 0x80) != 0)
 606  0160 a580          	bcp	a,#128
 607  0162 270d          	jreq	L142
 608                     ; 304 		data_sensor = (~data_sensor) +1;
 610  0164 7b0d          	ld	a,(OFST+1,sp)
 611  0166 43            	cpl	a
 612  0167 4c            	inc	a
 613  0168 6b0d          	ld	(OFST+1,sp),a
 614                     ; 305 		TempChar16[1] = '-';
 616  016a ae002d        	ldw	x,#45
 617  016d 1f03          	ldw	(OFST-9,sp),x
 619  016f 2005          	jra	L342
 620  0171               L142:
 621                     ; 308 		TempChar16[1] = ' ';							
 623  0171 ae0020        	ldw	x,#32
 624  0174 1f03          	ldw	(OFST-9,sp),x
 625  0176               L342:
 626                     ; 310 	TempChar16[3] = (data_sensor %10) + 0x30 ;
 628  0176 7b0d          	ld	a,(OFST+1,sp)
 629  0178 5f            	clrw	x
 630  0179 97            	ld	xl,a
 631  017a a60a          	ld	a,#10
 632  017c cd0000        	call	c_smodx
 634  017f 1c0030        	addw	x,#48
 635  0182 1f07          	ldw	(OFST-5,sp),x
 636                     ; 311 	TempChar16[2] = (data_sensor /10) + 0x30;
 638  0184 7b0d          	ld	a,(OFST+1,sp)
 639  0186 5f            	clrw	x
 640  0187 97            	ld	xl,a
 641  0188 a60a          	ld	a,#10
 642  018a cd0000        	call	c_sdivx
 644  018d 1c0030        	addw	x,#48
 645  0190 1f05          	ldw	(OFST-7,sp),x
 646                     ; 312 	TempChar16[0] = ' ';
 648  0192 ae0020        	ldw	x,#32
 649  0195 1f01          	ldw	(OFST-11,sp),x
 650                     ; 313 	LCD_GLASS_DisplayStrDeci(TempChar16);		
 652  0197 96            	ldw	x,sp
 653  0198 1c0001        	addw	x,#OFST-11
 654  019b cd0000        	call	_LCD_GLASS_DisplayStrDeci
 656                     ; 314 }
 659  019e 5b0d          	addw	sp,#13
 660  01a0 81            	ret
 725                     ; 322 static int8_t User_ReadNDEFMessage ( uint8_t *PayloadLength )			
 725                     ; 323 {
 726                     	switch	.text
 727  01a1               L13_User_ReadNDEFMessage:
 729  01a1 89            	pushw	x
 730  01a2 89            	pushw	x
 731       00000002      OFST:	set	2
 734                     ; 324 uint8_t NthAttempt=0, 
 736                     ; 325 				NbAttempt = 2;
 738  01a3 a602          	ld	a,#2
 739  01a5 6b01          	ld	(OFST-1,sp),a
 740                     ; 328 	*PayloadLength = 0;
 742  01a7 7f            	clr	(x)
 743                     ; 330 	for (NthAttempt = 0; NthAttempt < NbAttempt ; NthAttempt++)
 745  01a8 0f02          	clr	(OFST+0,sp)
 747  01aa 2071          	jra	L772
 748  01ac               L372:
 749                     ; 332 		M24LR04E_Init();
 751  01ac cd0000        	call	_M24LR04E_Init
 753                     ; 334 		if (User_CheckNDEFMessage() == SUCCESS)
 755  01af cd07c8        	call	L11_User_CheckNDEFMessage
 757  01b2 a101          	cp	a,#1
 758  01b4 2659          	jrne	L303
 759                     ; 336 			User_GetPayloadLength(PayloadLength);
 761  01b6 1e03          	ldw	x,(OFST+1,sp)
 762  01b8 cd07ff        	call	L7_User_GetPayloadLength
 764                     ; 338 			CodeLength = *PayloadLength;					// Länge der NDEF Message Bestimmen.
 766  01bb 1e03          	ldw	x,(OFST+1,sp)
 767  01bd f6            	ld	a,(x)
 768  01be 5f            	clrw	x
 769  01bf 97            	ld	xl,a
 770  01c0 bf40          	ldw	L76_CodeLength,x
 771                     ; 339 			CodeLength -=3;												//
 773  01c2 be40          	ldw	x,L76_CodeLength
 774  01c4 1d0003        	subw	x,#3
 775  01c7 bf40          	ldw	L76_CodeLength,x
 776                     ; 341 			if (PayloadLength !=0x00)
 778  01c9 1e03          	ldw	x,(OFST+1,sp)
 779  01cb 2742          	jreq	L303
 780                     ; 343 				(*PayloadLength) -=2;
 782  01cd 1e03          	ldw	x,(OFST+1,sp)
 783  01cf 7a            	dec	(x)
 784  01d0 7a            	dec	(x)
 785                     ; 345 				InitializeBuffer (NDEFmessage,(*PayloadLength)+10);
 787  01d1 1e03          	ldw	x,(OFST+1,sp)
 788  01d3 f6            	ld	a,(x)
 789  01d4 ab0a          	add	a,#10
 790  01d6 88            	push	a
 791  01d7 ae0000        	ldw	x,#_NDEFmessage
 792  01da cd0a81        	call	L72_InitializeBuffer
 794  01dd 84            	pop	a
 795                     ; 346 				User_GetNDEFMessage(*PayloadLength,NDEFmessage);
 797  01de ae0000        	ldw	x,#_NDEFmessage
 798  01e1 89            	pushw	x
 799  01e2 1e05          	ldw	x,(OFST+3,sp)
 800  01e4 f6            	ld	a,(x)
 801  01e5 cd081b        	call	L31_User_GetNDEFMessage
 803  01e8 85            	popw	x
 804                     ; 347 				I2C_Cmd(M24LR04E_I2C, DISABLE);			
 806  01e9 4b00          	push	#0
 807  01eb ae5210        	ldw	x,#21008
 808  01ee cd0000        	call	_I2C_Cmd
 810  01f1 84            	pop	a
 811                     ; 349 				CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
 813  01f2 ae0300        	ldw	x,#768
 814  01f5 cd0000        	call	_CLK_PeripheralClockConfig
 816                     ; 351 				GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
 818  01f8 7212500a      	bset	20490,#1
 819                     ; 352 				GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
 821  01fc 7210500a      	bset	20490,#0
 822                     ; 354 				ToUpperCase (*PayloadLength,NDEFmessage);
 824  0200 ae0000        	ldw	x,#_NDEFmessage
 825  0203 89            	pushw	x
 826  0204 1e05          	ldw	x,(OFST+3,sp)
 827  0206 f6            	ld	a,(x)
 828  0207 cd084a        	call	L51_ToUpperCase
 830  020a 85            	popw	x
 831                     ; 356 				return SUCCESS;
 833  020b a601          	ld	a,#1
 835  020d 2015          	jra	L41
 836  020f               L303:
 837                     ; 360 		M24LR04E_DeInit();
 839  020f cd0000        	call	_M24LR04E_DeInit
 841                     ; 361 		I2C_Cmd(M24LR04E_I2C, DISABLE);
 843  0212 4b00          	push	#0
 844  0214 ae5210        	ldw	x,#21008
 845  0217 cd0000        	call	_I2C_Cmd
 847  021a 84            	pop	a
 848                     ; 330 	for (NthAttempt = 0; NthAttempt < NbAttempt ; NthAttempt++)
 850  021b 0c02          	inc	(OFST+0,sp)
 851  021d               L772:
 854  021d 7b02          	ld	a,(OFST+0,sp)
 855  021f 1101          	cp	a,(OFST-1,sp)
 856  0221 2589          	jrult	L372
 857                     ; 364 	return ERROR;
 859  0223 4f            	clr	a
 861  0224               L41:
 863  0224 5b04          	addw	sp,#4
 864  0226 81            	ret
 888                     ; 380 static uint8_t Check_Code_Length(void)
 888                     ; 381 {
 889                     	switch	.text
 890  0227               L16_Check_Code_Length:
 894                     ; 382 	if(CodeLength == 0x05)
 896  0227 be40          	ldw	x,L76_CodeLength
 897  0229 a30005        	cpw	x,#5
 898  022c 2603          	jrne	L713
 899                     ; 384 		return SUCCESS;
 901  022e a601          	ld	a,#1
 904  0230 81            	ret
 905  0231               L713:
 906                     ; 386 	else return ERROR;
 908  0231 4f            	clr	a
 911  0232 81            	ret
1022                     ; 390 static void OverwriteAll_CODE_EEPROM(void)
1022                     ; 391 {
1023                     	switch	.text
1024  0233               L56_OverwriteAll_CODE_EEPROM:
1026  0233 5210          	subw	sp,#16
1027       00000010      OFST:	set	16
1030                     ; 393 	uint8_t *OneByteMemory2 = EE_Buffer_2;
1032  0235 ae0003        	ldw	x,#_EE_Buffer_2
1033  0238 1f01          	ldw	(OFST-15,sp),x
1034                     ; 394 	uint8_t *OneByteMemory3 = EE_Buffer_3;
1036  023a ae0004        	ldw	x,#_EE_Buffer_3
1037  023d 1f03          	ldw	(OFST-13,sp),x
1038                     ; 395 	uint8_t *OneByteMemory4 = EE_Buffer_4;
1040  023f ae0005        	ldw	x,#_EE_Buffer_4
1041  0242 1f05          	ldw	(OFST-11,sp),x
1042                     ; 396 	uint8_t *OneByteMemory5 = EE_Buffer_5;
1044  0244 ae0006        	ldw	x,#_EE_Buffer_5
1045  0247 1f07          	ldw	(OFST-9,sp),x
1046                     ; 398 	uint16_t ReadAddr_Byte2 = 0x000E;
1048  0249 ae000e        	ldw	x,#14
1049  024c 1f09          	ldw	(OFST-7,sp),x
1050                     ; 399 	uint16_t ReadAddr_Byte3 = 0x000F;
1052  024e ae000f        	ldw	x,#15
1053  0251 1f0b          	ldw	(OFST-5,sp),x
1054                     ; 400 	uint16_t ReadAddr_Byte4 = 0x0010;
1056  0253 ae0010        	ldw	x,#16
1057  0256 1f0d          	ldw	(OFST-3,sp),x
1058                     ; 401 	uint16_t ReadAddr_Byte5 = 0x0011;
1060  0258 ae0011        	ldw	x,#17
1061  025b 1f0f          	ldw	(OFST-1,sp),x
1062                     ; 405 		M24LR04E_Init();
1064  025d cd0000        	call	_M24LR04E_Init
1066                     ; 406 		M24LR04E_WriteOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte2, (uint8_t)( 0x20 ) );	
1068  0260 4b20          	push	#32
1069  0262 1e0a          	ldw	x,(OFST-6,sp)
1070  0264 89            	pushw	x
1071  0265 a6a6          	ld	a,#166
1072  0267 cd0000        	call	_M24LR04E_WriteOneByte
1074  026a 5b03          	addw	sp,#3
1075                     ; 408 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
1077  026c 4b00          	push	#0
1078  026e ae5210        	ldw	x,#21008
1079  0271 cd0000        	call	_I2C_Cmd
1081  0274 84            	pop	a
1082                     ; 409 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
1084  0275 ae0300        	ldw	x,#768
1085  0278 cd0000        	call	_CLK_PeripheralClockConfig
1087                     ; 410 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
1089  027b 7212500a      	bset	20490,#1
1090                     ; 411 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
1092  027f 7210500a      	bset	20490,#0
1093                     ; 414 		delayLFO_ms (1);
1095  0283 ae0001        	ldw	x,#1
1096  0286 cd0000        	call	_delayLFO_ms
1098                     ; 417 		M24LR04E_Init();
1100  0289 cd0000        	call	_M24LR04E_Init
1102                     ; 418 		M24LR04E_WriteOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte3, (uint8_t)( 0x20 ) );	
1104  028c 4b20          	push	#32
1105  028e 1e0c          	ldw	x,(OFST-4,sp)
1106  0290 89            	pushw	x
1107  0291 a6a6          	ld	a,#166
1108  0293 cd0000        	call	_M24LR04E_WriteOneByte
1110  0296 5b03          	addw	sp,#3
1111                     ; 420 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
1113  0298 4b00          	push	#0
1114  029a ae5210        	ldw	x,#21008
1115  029d cd0000        	call	_I2C_Cmd
1117  02a0 84            	pop	a
1118                     ; 421 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
1120  02a1 ae0300        	ldw	x,#768
1121  02a4 cd0000        	call	_CLK_PeripheralClockConfig
1123                     ; 422 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
1125  02a7 7212500a      	bset	20490,#1
1126                     ; 423 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
1128  02ab 7210500a      	bset	20490,#0
1129                     ; 425 		delayLFO_ms (1);
1131  02af ae0001        	ldw	x,#1
1132  02b2 cd0000        	call	_delayLFO_ms
1134                     ; 428 		M24LR04E_Init();
1136  02b5 cd0000        	call	_M24LR04E_Init
1138                     ; 429 		M24LR04E_WriteOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte4, (uint8_t)( 0x20 ) );	
1140  02b8 4b20          	push	#32
1141  02ba 1e0e          	ldw	x,(OFST-2,sp)
1142  02bc 89            	pushw	x
1143  02bd a6a6          	ld	a,#166
1144  02bf cd0000        	call	_M24LR04E_WriteOneByte
1146  02c2 5b03          	addw	sp,#3
1147                     ; 431 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
1149  02c4 4b00          	push	#0
1150  02c6 ae5210        	ldw	x,#21008
1151  02c9 cd0000        	call	_I2C_Cmd
1153  02cc 84            	pop	a
1154                     ; 432 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
1156  02cd ae0300        	ldw	x,#768
1157  02d0 cd0000        	call	_CLK_PeripheralClockConfig
1159                     ; 433 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
1161  02d3 7212500a      	bset	20490,#1
1162                     ; 434 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
1164  02d7 7210500a      	bset	20490,#0
1165                     ; 437 		delayLFO_ms (1);
1167  02db ae0001        	ldw	x,#1
1168  02de cd0000        	call	_delayLFO_ms
1170                     ; 439 		M24LR04E_Init();
1172  02e1 cd0000        	call	_M24LR04E_Init
1174                     ; 440 		M24LR04E_WriteOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte5, (uint8_t)( 0x20 ) );	
1176  02e4 4b20          	push	#32
1177  02e6 1e10          	ldw	x,(OFST+0,sp)
1178  02e8 89            	pushw	x
1179  02e9 a6a6          	ld	a,#166
1180  02eb cd0000        	call	_M24LR04E_WriteOneByte
1182  02ee 5b03          	addw	sp,#3
1183                     ; 442 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
1185  02f0 4b00          	push	#0
1186  02f2 ae5210        	ldw	x,#21008
1187  02f5 cd0000        	call	_I2C_Cmd
1189  02f8 84            	pop	a
1190                     ; 443 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
1192  02f9 ae0300        	ldw	x,#768
1193  02fc cd0000        	call	_CLK_PeripheralClockConfig
1195                     ; 444 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
1197  02ff 7212500a      	bset	20490,#1
1198                     ; 445 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
1200  0303 7210500a      	bset	20490,#0
1201                     ; 448 }
1204  0307 5b10          	addw	sp,#16
1205  0309 81            	ret
1335                     ; 450 static void Overwrite_dollar_EEPROM(void)
1335                     ; 451 {
1336                     	switch	.text
1337  030a               L36_Overwrite_dollar_EEPROM:
1339  030a 5214          	subw	sp,#20
1340       00000014      OFST:	set	20
1343                     ; 452 	uint8_t *OneByteMemory1 = EE_Buffer_1;
1345  030c ae0002        	ldw	x,#_EE_Buffer_1
1346  030f 1f01          	ldw	(OFST-19,sp),x
1347                     ; 453 	uint8_t *OneByteMemory2 = EE_Buffer_2;
1349  0311 ae0003        	ldw	x,#_EE_Buffer_2
1350  0314 1f03          	ldw	(OFST-17,sp),x
1351                     ; 454 	uint8_t *OneByteMemory3 = EE_Buffer_3;
1353  0316 ae0004        	ldw	x,#_EE_Buffer_3
1354  0319 1f05          	ldw	(OFST-15,sp),x
1355                     ; 455 	uint8_t *OneByteMemory4 = EE_Buffer_4;
1357  031b ae0005        	ldw	x,#_EE_Buffer_4
1358  031e 1f07          	ldw	(OFST-13,sp),x
1359                     ; 456 	uint8_t *OneByteMemory5 = EE_Buffer_5;
1361  0320 ae0006        	ldw	x,#_EE_Buffer_5
1362  0323 1f09          	ldw	(OFST-11,sp),x
1363                     ; 458 	uint16_t ReadAddr_Byte1 = 0x000D;
1365  0325 ae000d        	ldw	x,#13
1366  0328 1f13          	ldw	(OFST-1,sp),x
1367                     ; 459 	uint16_t ReadAddr_Byte2 = 0x000E;
1369  032a ae000e        	ldw	x,#14
1370  032d 1f0b          	ldw	(OFST-9,sp),x
1371                     ; 460 	uint16_t ReadAddr_Byte3 = 0x000F;
1373  032f ae000f        	ldw	x,#15
1374  0332 1f0d          	ldw	(OFST-7,sp),x
1375                     ; 461 	uint16_t ReadAddr_Byte4 = 0x0010;
1377  0334 ae0010        	ldw	x,#16
1378  0337 1f0f          	ldw	(OFST-5,sp),x
1379                     ; 462 	uint16_t ReadAddr_Byte5 = 0x0011;
1381  0339 ae0011        	ldw	x,#17
1382  033c 1f11          	ldw	(OFST-3,sp),x
1383                     ; 466 		M24LR04E_Init();
1385  033e cd0000        	call	_M24LR04E_Init
1387                     ; 467 		M24LR04E_WriteOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte1, (uint8_t)( 0x20 ) );	
1389  0341 4b20          	push	#32
1390  0343 1e14          	ldw	x,(OFST+0,sp)
1391  0345 89            	pushw	x
1392  0346 a6a6          	ld	a,#166
1393  0348 cd0000        	call	_M24LR04E_WriteOneByte
1395  034b 5b03          	addw	sp,#3
1396                     ; 469 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
1398  034d 4b00          	push	#0
1399  034f ae5210        	ldw	x,#21008
1400  0352 cd0000        	call	_I2C_Cmd
1402  0355 84            	pop	a
1403                     ; 470 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
1405  0356 ae0300        	ldw	x,#768
1406  0359 cd0000        	call	_CLK_PeripheralClockConfig
1408                     ; 471 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
1410  035c 7212500a      	bset	20490,#1
1411                     ; 472 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
1413  0360 7210500a      	bset	20490,#0
1414                     ; 474 }
1417  0364 5b14          	addw	sp,#20
1418  0366 81            	ret
1553                     ; 478 static void Read_Units_from_memory(void)
1553                     ; 479 {
1554                     	switch	.text
1555  0367               L35_Read_Units_from_memory:
1557  0367 5214          	subw	sp,#20
1558       00000014      OFST:	set	20
1561                     ; 480 	uint8_t *OneByteMemory1 = EE_Buffer_1;
1563  0369 ae0002        	ldw	x,#_EE_Buffer_1
1564  036c 1f11          	ldw	(OFST-3,sp),x
1565                     ; 481 	uint8_t *OneByteMemory2 = EE_Buffer_2;
1567  036e ae0003        	ldw	x,#_EE_Buffer_2
1568  0371 1f01          	ldw	(OFST-19,sp),x
1569                     ; 482 	uint8_t *OneByteMemory3 = EE_Buffer_3;
1571  0373 ae0004        	ldw	x,#_EE_Buffer_3
1572  0376 1f03          	ldw	(OFST-17,sp),x
1573                     ; 483 	uint8_t *OneByteMemory4 = EE_Buffer_4;
1575  0378 ae0005        	ldw	x,#_EE_Buffer_4
1576  037b 1f05          	ldw	(OFST-15,sp),x
1577                     ; 484 	uint8_t *OneByteMemory5 = EE_Buffer_5;
1579  037d ae0006        	ldw	x,#_EE_Buffer_5
1580  0380 1f07          	ldw	(OFST-13,sp),x
1581                     ; 486 	uint16_t ReadAddr_Byte1 = 0x000D;
1583  0382 ae000d        	ldw	x,#13
1584  0385 1f13          	ldw	(OFST-1,sp),x
1585                     ; 487 	uint16_t ReadAddr_Byte2 = 0x000E;
1587  0387 ae000e        	ldw	x,#14
1588  038a 1f09          	ldw	(OFST-11,sp),x
1589                     ; 488 	uint16_t ReadAddr_Byte3 = 0x000F;
1591  038c ae000f        	ldw	x,#15
1592  038f 1f0b          	ldw	(OFST-9,sp),x
1593                     ; 489 	uint16_t ReadAddr_Byte4 = 0x0010;
1595  0391 ae0010        	ldw	x,#16
1596  0394 1f0d          	ldw	(OFST-7,sp),x
1597                     ; 490 	uint16_t ReadAddr_Byte5 = 0x0011;
1599  0396 ae0011        	ldw	x,#17
1600  0399 1f0f          	ldw	(OFST-5,sp),x
1601                     ; 494 	M24LR04E_Init();
1603  039b cd0000        	call	_M24LR04E_Init
1605                     ; 496 	M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte1, OneByteMemory1);	
1607  039e 1e11          	ldw	x,(OFST-3,sp)
1608  03a0 89            	pushw	x
1609  03a1 1e15          	ldw	x,(OFST+1,sp)
1610  03a3 89            	pushw	x
1611  03a4 a6a6          	ld	a,#166
1612  03a6 cd0000        	call	_M24LR04E_ReadOneByte
1614  03a9 5b04          	addw	sp,#4
1615                     ; 499 	I2C_Cmd(M24LR04E_I2C, DISABLE);		
1617  03ab 4b00          	push	#0
1618  03ad ae5210        	ldw	x,#21008
1619  03b0 cd0000        	call	_I2C_Cmd
1621  03b3 84            	pop	a
1622                     ; 500 	CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
1624  03b4 ae0300        	ldw	x,#768
1625  03b7 cd0000        	call	_CLK_PeripheralClockConfig
1627                     ; 501 	GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
1629  03ba 7212500a      	bset	20490,#1
1630                     ; 502 	GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
1632  03be 7210500a      	bset	20490,#0
1633                     ; 504 	EE_Buffer_1[0] = EE_Buffer_1[0];
1635  03c2 c60002        	ld	a,_EE_Buffer_1
1636                     ; 506 	if ( EE_Buffer_1[0] == '$')
1638  03c5 c60002        	ld	a,_EE_Buffer_1
1639  03c8 a124          	cp	a,#36
1640  03ca 2703          	jreq	L62
1641  03cc cc04be        	jp	L145
1642  03cf               L62:
1643                     ; 510 		Overwrite_dollar_EEPROM();
1645  03cf cd030a        	call	L36_Overwrite_dollar_EEPROM
1647                     ; 512 		M24LR04E_Init();
1649  03d2 cd0000        	call	_M24LR04E_Init
1651                     ; 514 		M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte1, OneByteMemory1);
1653  03d5 1e11          	ldw	x,(OFST-3,sp)
1654  03d7 89            	pushw	x
1655  03d8 1e15          	ldw	x,(OFST+1,sp)
1656  03da 89            	pushw	x
1657  03db a6a6          	ld	a,#166
1658  03dd cd0000        	call	_M24LR04E_ReadOneByte
1660  03e0 5b04          	addw	sp,#4
1661                     ; 516 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
1663  03e2 4b00          	push	#0
1664  03e4 ae5210        	ldw	x,#21008
1665  03e7 cd0000        	call	_I2C_Cmd
1667  03ea 84            	pop	a
1668                     ; 517 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
1670  03eb ae0300        	ldw	x,#768
1671  03ee cd0000        	call	_CLK_PeripheralClockConfig
1673                     ; 518 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
1675  03f1 7212500a      	bset	20490,#1
1676                     ; 519 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
1678  03f5 7210500a      	bset	20490,#0
1679                     ; 521 		EE_Buffer_1[0] = EE_Buffer_1[0];
1681  03f9 c60002        	ld	a,_EE_Buffer_1
1682                     ; 525 		M24LR04E_Init();
1684  03fc cd0000        	call	_M24LR04E_Init
1686                     ; 527 		M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte2, OneByteMemory2);	
1688  03ff 1e01          	ldw	x,(OFST-19,sp)
1689  0401 89            	pushw	x
1690  0402 1e0b          	ldw	x,(OFST-9,sp)
1691  0404 89            	pushw	x
1692  0405 a6a6          	ld	a,#166
1693  0407 cd0000        	call	_M24LR04E_ReadOneByte
1695  040a 5b04          	addw	sp,#4
1696                     ; 529 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
1698  040c 4b00          	push	#0
1699  040e ae5210        	ldw	x,#21008
1700  0411 cd0000        	call	_I2C_Cmd
1702  0414 84            	pop	a
1703                     ; 530 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
1705  0415 ae0300        	ldw	x,#768
1706  0418 cd0000        	call	_CLK_PeripheralClockConfig
1708                     ; 531 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
1710  041b 7212500a      	bset	20490,#1
1711                     ; 532 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
1713  041f 7210500a      	bset	20490,#0
1714                     ; 534 		EE_Buffer_2[0] = EE_Buffer_2[0];
1716  0423 c60003        	ld	a,_EE_Buffer_2
1717                     ; 535 		GPIO_SetBits(LED_GPIO_PORT,GPIO_Pin_6); 
1719  0426 4b40          	push	#64
1720  0428 ae5014        	ldw	x,#20500
1721  042b cd0000        	call	_GPIO_SetBits
1723  042e 84            	pop	a
1724                     ; 538 		M24LR04E_Init();
1726  042f cd0000        	call	_M24LR04E_Init
1728                     ; 540 		M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte3, OneByteMemory3);	
1730  0432 1e03          	ldw	x,(OFST-17,sp)
1731  0434 89            	pushw	x
1732  0435 1e0d          	ldw	x,(OFST-7,sp)
1733  0437 89            	pushw	x
1734  0438 a6a6          	ld	a,#166
1735  043a cd0000        	call	_M24LR04E_ReadOneByte
1737  043d 5b04          	addw	sp,#4
1738                     ; 542 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
1740  043f 4b00          	push	#0
1741  0441 ae5210        	ldw	x,#21008
1742  0444 cd0000        	call	_I2C_Cmd
1744  0447 84            	pop	a
1745                     ; 543 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
1747  0448 ae0300        	ldw	x,#768
1748  044b cd0000        	call	_CLK_PeripheralClockConfig
1750                     ; 544 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
1752  044e 7212500a      	bset	20490,#1
1753                     ; 545 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
1755  0452 7210500a      	bset	20490,#0
1756                     ; 547 		EE_Buffer_3[0] = EE_Buffer_3[0];		
1758  0456 c60004        	ld	a,_EE_Buffer_3
1759                     ; 550 		M24LR04E_Init();
1761  0459 cd0000        	call	_M24LR04E_Init
1763                     ; 551 		M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte4, OneByteMemory4);	
1765  045c 1e05          	ldw	x,(OFST-15,sp)
1766  045e 89            	pushw	x
1767  045f 1e0f          	ldw	x,(OFST-5,sp)
1768  0461 89            	pushw	x
1769  0462 a6a6          	ld	a,#166
1770  0464 cd0000        	call	_M24LR04E_ReadOneByte
1772  0467 5b04          	addw	sp,#4
1773                     ; 553 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
1775  0469 4b00          	push	#0
1776  046b ae5210        	ldw	x,#21008
1777  046e cd0000        	call	_I2C_Cmd
1779  0471 84            	pop	a
1780                     ; 554 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
1782  0472 ae0300        	ldw	x,#768
1783  0475 cd0000        	call	_CLK_PeripheralClockConfig
1785                     ; 555 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
1787  0478 7212500a      	bset	20490,#1
1788                     ; 556 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
1790  047c 7210500a      	bset	20490,#0
1791                     ; 558 		EE_Buffer_4[0] = EE_Buffer_4[0];
1793  0480 c60005        	ld	a,_EE_Buffer_4
1794                     ; 561 		M24LR04E_Init();
1796  0483 cd0000        	call	_M24LR04E_Init
1798                     ; 562 		M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte5, OneByteMemory5);	
1800  0486 1e07          	ldw	x,(OFST-13,sp)
1801  0488 89            	pushw	x
1802  0489 1e11          	ldw	x,(OFST-3,sp)
1803  048b 89            	pushw	x
1804  048c a6a6          	ld	a,#166
1805  048e cd0000        	call	_M24LR04E_ReadOneByte
1807  0491 5b04          	addw	sp,#4
1808                     ; 564 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
1810  0493 4b00          	push	#0
1811  0495 ae5210        	ldw	x,#21008
1812  0498 cd0000        	call	_I2C_Cmd
1814  049b 84            	pop	a
1815                     ; 565 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
1817  049c ae0300        	ldw	x,#768
1818  049f cd0000        	call	_CLK_PeripheralClockConfig
1820                     ; 566 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
1822  04a2 7212500a      	bset	20490,#1
1823                     ; 567 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
1825  04a6 7210500a      	bset	20490,#0
1826                     ; 569 		EE_Buffer_5[0] = EE_Buffer_5[0];
1828  04aa c60006        	ld	a,_EE_Buffer_5
1829                     ; 573 		if ( Check_PID_Buffer_Equal() == SUCCESS ) 
1831  04ad cd0630        	call	L74_Check_PID_Buffer_Equal
1833  04b0 a101          	cp	a,#1
1834  04b2 260a          	jrne	L145
1835                     ; 576 				EE_Buf_Flag[0] = 0x00;
1837  04b4 4f            	clr	a
1838  04b5 ae0001        	ldw	x,#_EE_Buf_Flag
1839  04b8 cd0000        	call	c_eewrc
1841                     ; 577 				OverwriteAll_CODE_EEPROM();
1843  04bb cd0233        	call	L56_OverwriteAll_CODE_EEPROM
1846  04be               L145:
1847                     ; 585 }
1850  04be 5b14          	addw	sp,#20
1851  04c0 81            	ret
1988                     ; 590 static void Copy_Units_in_other_memory(void)
1988                     ; 591 {
1989                     	switch	.text
1990  04c1               L54_Copy_Units_in_other_memory:
1992  04c1 5214          	subw	sp,#20
1993       00000014      OFST:	set	20
1996                     ; 592 	uint8_t *OneByteMemory1 = EE_Buffer_1;
1998  04c3 ae0002        	ldw	x,#_EE_Buffer_1
1999  04c6 1f11          	ldw	(OFST-3,sp),x
2000                     ; 593 	uint8_t *OneByteMemory2 = EE_Buffer_2;
2002  04c8 ae0003        	ldw	x,#_EE_Buffer_2
2003  04cb 1f01          	ldw	(OFST-19,sp),x
2004                     ; 594 	uint8_t *OneByteMemory3 = EE_Buffer_3;
2006  04cd ae0004        	ldw	x,#_EE_Buffer_3
2007  04d0 1f03          	ldw	(OFST-17,sp),x
2008                     ; 595 	uint8_t *OneByteMemory4 = EE_Buffer_4;
2010  04d2 ae0005        	ldw	x,#_EE_Buffer_4
2011  04d5 1f05          	ldw	(OFST-15,sp),x
2012                     ; 596 	uint8_t *OneByteMemory5 = EE_Buffer_5;
2014  04d7 ae0006        	ldw	x,#_EE_Buffer_5
2015  04da 1f07          	ldw	(OFST-13,sp),x
2016                     ; 598 	uint16_t ReadAddr_Byte1 = 0x000D;
2018  04dc ae000d        	ldw	x,#13
2019  04df 1f13          	ldw	(OFST-1,sp),x
2020                     ; 599 	uint16_t ReadAddr_Byte2 = 0x000E;
2022  04e1 ae000e        	ldw	x,#14
2023  04e4 1f09          	ldw	(OFST-11,sp),x
2024                     ; 600 	uint16_t ReadAddr_Byte3 = 0x000F;
2026  04e6 ae000f        	ldw	x,#15
2027  04e9 1f0b          	ldw	(OFST-9,sp),x
2028                     ; 601 	uint16_t ReadAddr_Byte4 = 0x0010;
2030  04eb ae0010        	ldw	x,#16
2031  04ee 1f0d          	ldw	(OFST-7,sp),x
2032                     ; 602 	uint16_t ReadAddr_Byte5 = 0x0011;
2034  04f0 ae0011        	ldw	x,#17
2035  04f3 1f0f          	ldw	(OFST-5,sp),x
2036                     ; 605 	M24LR04E_Init();
2038  04f5 cd0000        	call	_M24LR04E_Init
2040                     ; 607 	M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte1, OneByteMemory1);
2042  04f8 1e11          	ldw	x,(OFST-3,sp)
2043  04fa 89            	pushw	x
2044  04fb 1e15          	ldw	x,(OFST+1,sp)
2045  04fd 89            	pushw	x
2046  04fe a6a6          	ld	a,#166
2047  0500 cd0000        	call	_M24LR04E_ReadOneByte
2049  0503 5b04          	addw	sp,#4
2050                     ; 609 	I2C_Cmd(M24LR04E_I2C, DISABLE);		
2052  0505 4b00          	push	#0
2053  0507 ae5210        	ldw	x,#21008
2054  050a cd0000        	call	_I2C_Cmd
2056  050d 84            	pop	a
2057                     ; 610 	CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
2059  050e ae0300        	ldw	x,#768
2060  0511 cd0000        	call	_CLK_PeripheralClockConfig
2062                     ; 611 	GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
2064  0514 7212500a      	bset	20490,#1
2065                     ; 612 	GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
2067  0518 7210500a      	bset	20490,#0
2068                     ; 614 	EE_Buffer_1[0] = EE_Buffer_1[0];
2070  051c c60002        	ld	a,_EE_Buffer_1
2071                     ; 616 if ( EE_Buffer_1[0] == '$')
2073  051f c60002        	ld	a,_EE_Buffer_1
2074  0522 a124          	cp	a,#36
2075  0524 2703          	jreq	L23
2076  0526 cc062d        	jp	L136
2077  0529               L23:
2078                     ; 619 		Overwrite_dollar_EEPROM();
2080  0529 cd030a        	call	L36_Overwrite_dollar_EEPROM
2082                     ; 621 		M24LR04E_Init();
2084  052c cd0000        	call	_M24LR04E_Init
2086                     ; 623 		M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte1, OneByteMemory1);
2088  052f 1e11          	ldw	x,(OFST-3,sp)
2089  0531 89            	pushw	x
2090  0532 1e15          	ldw	x,(OFST+1,sp)
2091  0534 89            	pushw	x
2092  0535 a6a6          	ld	a,#166
2093  0537 cd0000        	call	_M24LR04E_ReadOneByte
2095  053a 5b04          	addw	sp,#4
2096                     ; 625 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
2098  053c 4b00          	push	#0
2099  053e ae5210        	ldw	x,#21008
2100  0541 cd0000        	call	_I2C_Cmd
2102  0544 84            	pop	a
2103                     ; 626 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
2105  0545 ae0300        	ldw	x,#768
2106  0548 cd0000        	call	_CLK_PeripheralClockConfig
2108                     ; 627 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
2110  054b 7212500a      	bset	20490,#1
2111                     ; 628 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
2113  054f 7210500a      	bset	20490,#0
2114                     ; 630 		EE_Buffer_1[0] = EE_Buffer_1[0];
2116  0553 c60002        	ld	a,_EE_Buffer_1
2117                     ; 633 		M24LR04E_Init();
2119  0556 cd0000        	call	_M24LR04E_Init
2121                     ; 635 		M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte2, OneByteMemory2);	
2123  0559 1e01          	ldw	x,(OFST-19,sp)
2124  055b 89            	pushw	x
2125  055c 1e0b          	ldw	x,(OFST-9,sp)
2126  055e 89            	pushw	x
2127  055f a6a6          	ld	a,#166
2128  0561 cd0000        	call	_M24LR04E_ReadOneByte
2130  0564 5b04          	addw	sp,#4
2131                     ; 637 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
2133  0566 4b00          	push	#0
2134  0568 ae5210        	ldw	x,#21008
2135  056b cd0000        	call	_I2C_Cmd
2137  056e 84            	pop	a
2138                     ; 638 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
2140  056f ae0300        	ldw	x,#768
2141  0572 cd0000        	call	_CLK_PeripheralClockConfig
2143                     ; 639 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
2145  0575 7212500a      	bset	20490,#1
2146                     ; 640 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
2148  0579 7210500a      	bset	20490,#0
2149                     ; 642 		EE_Buffer_2[0] = EE_Buffer_2[0];
2151  057d c60003        	ld	a,_EE_Buffer_2
2152                     ; 645 		M24LR04E_Init();
2154  0580 cd0000        	call	_M24LR04E_Init
2156                     ; 647 		M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte3, OneByteMemory3);	
2158  0583 1e03          	ldw	x,(OFST-17,sp)
2159  0585 89            	pushw	x
2160  0586 1e0d          	ldw	x,(OFST-7,sp)
2161  0588 89            	pushw	x
2162  0589 a6a6          	ld	a,#166
2163  058b cd0000        	call	_M24LR04E_ReadOneByte
2165  058e 5b04          	addw	sp,#4
2166                     ; 649 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
2168  0590 4b00          	push	#0
2169  0592 ae5210        	ldw	x,#21008
2170  0595 cd0000        	call	_I2C_Cmd
2172  0598 84            	pop	a
2173                     ; 650 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
2175  0599 ae0300        	ldw	x,#768
2176  059c cd0000        	call	_CLK_PeripheralClockConfig
2178                     ; 651 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
2180  059f 7212500a      	bset	20490,#1
2181                     ; 652 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
2183  05a3 7210500a      	bset	20490,#0
2184                     ; 654 		EE_Buffer_3[0] = EE_Buffer_3[0];
2186  05a7 c60004        	ld	a,_EE_Buffer_3
2187                     ; 658 		M24LR04E_Init();
2189  05aa cd0000        	call	_M24LR04E_Init
2191                     ; 660 		M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte4, OneByteMemory4);	
2193  05ad 1e05          	ldw	x,(OFST-15,sp)
2194  05af 89            	pushw	x
2195  05b0 1e0f          	ldw	x,(OFST-5,sp)
2196  05b2 89            	pushw	x
2197  05b3 a6a6          	ld	a,#166
2198  05b5 cd0000        	call	_M24LR04E_ReadOneByte
2200  05b8 5b04          	addw	sp,#4
2201                     ; 662 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
2203  05ba 4b00          	push	#0
2204  05bc ae5210        	ldw	x,#21008
2205  05bf cd0000        	call	_I2C_Cmd
2207  05c2 84            	pop	a
2208                     ; 663 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
2210  05c3 ae0300        	ldw	x,#768
2211  05c6 cd0000        	call	_CLK_PeripheralClockConfig
2213                     ; 664 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
2215  05c9 7212500a      	bset	20490,#1
2216                     ; 665 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
2218  05cd 7210500a      	bset	20490,#0
2219                     ; 667 		EE_Buffer_4[0] = EE_Buffer_4[0];
2221  05d1 c60005        	ld	a,_EE_Buffer_4
2222                     ; 671 		M24LR04E_Init();
2224  05d4 cd0000        	call	_M24LR04E_Init
2226                     ; 673 		M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte5, OneByteMemory5);	
2228  05d7 1e07          	ldw	x,(OFST-13,sp)
2229  05d9 89            	pushw	x
2230  05da 1e11          	ldw	x,(OFST-3,sp)
2231  05dc 89            	pushw	x
2232  05dd a6a6          	ld	a,#166
2233  05df cd0000        	call	_M24LR04E_ReadOneByte
2235  05e2 5b04          	addw	sp,#4
2236                     ; 675 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
2238  05e4 4b00          	push	#0
2239  05e6 ae5210        	ldw	x,#21008
2240  05e9 cd0000        	call	_I2C_Cmd
2242  05ec 84            	pop	a
2243                     ; 676 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
2245  05ed ae0300        	ldw	x,#768
2246  05f0 cd0000        	call	_CLK_PeripheralClockConfig
2248                     ; 677 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
2250  05f3 7212500a      	bset	20490,#1
2251                     ; 678 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
2253  05f7 7210500a      	bset	20490,#0
2254                     ; 680 		EE_Buffer_5[0] = EE_Buffer_5[0];
2256  05fb c60006        	ld	a,_EE_Buffer_5
2257                     ; 683 		EE_Buffer_10[0] = EE_Buffer_5[0];
2259  05fe c60006        	ld	a,_EE_Buffer_5
2260  0601 ae000b        	ldw	x,#_EE_Buffer_10
2261  0604 cd0000        	call	c_eewrc
2263                     ; 684 		EE_Buffer_9[0] = EE_Buffer_4[0];
2265  0607 c60005        	ld	a,_EE_Buffer_4
2266  060a ae000a        	ldw	x,#_EE_Buffer_9
2267  060d cd0000        	call	c_eewrc
2269                     ; 685 		EE_Buffer_8[0] = EE_Buffer_3[0];
2271  0610 c60004        	ld	a,_EE_Buffer_3
2272  0613 ae0009        	ldw	x,#_EE_Buffer_8
2273  0616 cd0000        	call	c_eewrc
2275                     ; 686 		EE_Buffer_7[0] = EE_Buffer_2[0];
2277  0619 c60003        	ld	a,_EE_Buffer_2
2278  061c ae0008        	ldw	x,#_EE_Buffer_7
2279  061f cd0000        	call	c_eewrc
2281                     ; 694 		EE_Buf_Flag[0] = 0xFF;
2283  0622 a6ff          	ld	a,#255
2284  0624 ae0001        	ldw	x,#_EE_Buf_Flag
2285  0627 cd0000        	call	c_eewrc
2287                     ; 696 		OverwriteAll_CODE_EEPROM();
2289  062a cd0233        	call	L56_OverwriteAll_CODE_EEPROM
2291  062d               L136:
2292                     ; 698 }
2295  062d 5b14          	addw	sp,#20
2296  062f 81            	ret
2328                     ; 703 static uint8_t Check_PID_Buffer_Equal(void)
2328                     ; 704 {
2329                     	switch	.text
2330  0630               L74_Check_PID_Buffer_Equal:
2334                     ; 706 	if((EE_Buffer_10[0] == EE_Buffer_5[0]) &&
2334                     ; 707 			(EE_Buffer_9[0] == EE_Buffer_4[0]) &&
2334                     ; 708 				(EE_Buffer_8[0] == EE_Buffer_3[0]) && 
2334                     ; 709 					(EE_Buffer_7[0] == EE_Buffer_2[0])
2334                     ; 710 			 )
2336  0630 c6000b        	ld	a,_EE_Buffer_10
2337  0633 c10006        	cp	a,_EE_Buffer_5
2338  0636 261b          	jrne	L346
2340  0638 c6000a        	ld	a,_EE_Buffer_9
2341  063b c10005        	cp	a,_EE_Buffer_4
2342  063e 2613          	jrne	L346
2344  0640 c60009        	ld	a,_EE_Buffer_8
2345  0643 c10004        	cp	a,_EE_Buffer_3
2346  0646 260b          	jrne	L346
2348  0648 c60008        	ld	a,_EE_Buffer_7
2349  064b c10003        	cp	a,_EE_Buffer_2
2350  064e 2603          	jrne	L346
2351                     ; 712 			return SUCCESS;
2353  0650 a601          	ld	a,#1
2356  0652 81            	ret
2357  0653               L346:
2358                     ; 714 	else return ERROR;
2360  0653 4f            	clr	a
2363  0654 81            	ret
2404                     ; 723 static void State_DisplayMessage (uint8_t message[],uint8_t PayloadLength )
2404                     ; 724 {
2405                     	switch	.text
2406  0655               L75_State_DisplayMessage:
2408  0655 89            	pushw	x
2409       00000000      OFST:	set	0
2412                     ; 735 		CLK_SYSCLKDivConfig(CLK_SYSCLKDiv_1);
2414  0656 4f            	clr	a
2415  0657 cd0000        	call	_CLK_SYSCLKDivConfig
2417                     ; 736 		CLK_SYSCLKSourceConfig(CLK_SYSCLKSource_LSI);
2419  065a a602          	ld	a,#2
2420  065c cd0000        	call	_CLK_SYSCLKSourceConfig
2422                     ; 737 		CLK_SYSCLKSourceSwitchCmd(ENABLE);
2424  065f a601          	ld	a,#1
2425  0661 cd0000        	call	_CLK_SYSCLKSourceSwitchCmd
2428  0664               L766:
2429                     ; 738 		while (((CLK->SWCR)& 0x01)==0x01);
2431  0664 c650c9        	ld	a,20681
2432  0667 a401          	and	a,#1
2433  0669 a101          	cp	a,#1
2434  066b 27f7          	jreq	L766
2435                     ; 739 		CLK_HSICmd(DISABLE);
2437  066d 4f            	clr	a
2438  066e cd0000        	call	_CLK_HSICmd
2440                     ; 740 		CLK->ECKCR &= ~0x01; 
2442  0671 721150c6      	bres	20678,#0
2443                     ; 743 		LCD_GLASS_DisplayString_1(message);
2445  0675 1e01          	ldw	x,(OFST+1,sp)
2446  0677 ad28          	call	_LCD_GLASS_DisplayString_1
2448                     ; 747 			CLK_SYSCLKDivConfig(CLK_SYSCLKDiv_16);
2450  0679 a604          	ld	a,#4
2451  067b cd0000        	call	_CLK_SYSCLKDivConfig
2453                     ; 748 			CLK_HSICmd(ENABLE);
2455  067e a601          	ld	a,#1
2456  0680 cd0000        	call	_CLK_HSICmd
2459  0683               L576:
2460                     ; 749 			while (((CLK->ICKCR)& 0x02)!=0x02);			
2462  0683 c650c2        	ld	a,20674
2463  0686 a402          	and	a,#2
2464  0688 a102          	cp	a,#2
2465  068a 26f7          	jrne	L576
2466                     ; 750 			CLK_SYSCLKSourceConfig(CLK_SYSCLKSource_HSI);
2468  068c a601          	ld	a,#1
2469  068e cd0000        	call	_CLK_SYSCLKSourceConfig
2471                     ; 751 			CLK_SYSCLKSourceSwitchCmd(ENABLE);
2473  0691 a601          	ld	a,#1
2474  0693 cd0000        	call	_CLK_SYSCLKSourceSwitchCmd
2477  0696               L307:
2478                     ; 752 			while (((CLK->SWCR)& 0x01)==0x01);
2480  0696 c650c9        	ld	a,20681
2481  0699 a401          	and	a,#1
2482  069b a101          	cp	a,#1
2483  069d 27f7          	jreq	L307
2484                     ; 762 }
2487  069f 85            	popw	x
2488  06a0 81            	ret
2535                     ; 771 void LCD_GLASS_DisplayString_1(uint8_t* ptr)
2535                     ; 772 {
2536                     	switch	.text
2537  06a1               _LCD_GLASS_DisplayString_1:
2539  06a1 89            	pushw	x
2540  06a2 88            	push	a
2541       00000001      OFST:	set	1
2544                     ; 773   uint8_t i = 0x01;
2546  06a3 a601          	ld	a,#1
2547  06a5 6b01          	ld	(OFST+0,sp),a
2548                     ; 775 	LCD_GLASS_Clear();
2550  06a7 cd0000        	call	_LCD_GLASS_Clear
2553  06aa 2017          	jra	L337
2554  06ac               L137:
2555                     ; 780     LCD_GLASS_WriteChar(ptr, FALSE, FALSE, i);
2557  06ac 7b01          	ld	a,(OFST+0,sp)
2558  06ae 88            	push	a
2559  06af 4b00          	push	#0
2560  06b1 4b00          	push	#0
2561  06b3 1e05          	ldw	x,(OFST+4,sp)
2562  06b5 cd0000        	call	_LCD_GLASS_WriteChar
2564  06b8 5b03          	addw	sp,#3
2565                     ; 783     ptr++;
2567  06ba 1e02          	ldw	x,(OFST+1,sp)
2568  06bc 1c0001        	addw	x,#1
2569  06bf 1f02          	ldw	(OFST+1,sp),x
2570                     ; 786     i++;
2572  06c1 0c01          	inc	(OFST+0,sp)
2573  06c3               L337:
2574                     ; 777   while ((*ptr != 0) & (i < 8))
2576  06c3 1e02          	ldw	x,(OFST+1,sp)
2577  06c5 7d            	tnz	(x)
2578  06c6 2706          	jreq	L737
2580  06c8 7b01          	ld	a,(OFST+0,sp)
2581  06ca a108          	cp	a,#8
2582  06cc 25de          	jrult	L137
2583  06ce               L737:
2584                     ; 788 }
2587  06ce 5b03          	addw	sp,#3
2588  06d0 81            	ret
2639                     ; 805 static int8_t User_WriteFirmwareVersion ( void )			
2639                     ; 806 {
2640                     	switch	.text
2641  06d1               L34_User_WriteFirmwareVersion:
2643  06d1 5204          	subw	sp,#4
2644       00000004      OFST:	set	4
2647                     ; 807 uint8_t *OneByte = 0x00;
2649  06d3 5f            	clrw	x
2650  06d4 1f01          	ldw	(OFST-3,sp),x
2651                     ; 808 uint16_t WriteAddr = 0x01FC;				
2653  06d6 ae01fc        	ldw	x,#508
2654  06d9 1f03          	ldw	(OFST-1,sp),x
2655                     ; 811 	M24LR04E_Init();
2657  06db cd0000        	call	_M24LR04E_Init
2659                     ; 813 	M24LR04E_WriteOneByte (M24LR16_EEPROM_ADDRESS_USER, WriteAddr++, FirmwareVersion [0]);			
2661  06de 4b13          	push	#19
2662  06e0 1604          	ldw	y,(OFST+0,sp)
2663  06e2 0c05          	inc	(OFST+1,sp)
2664  06e4 2602          	jrne	L44
2665  06e6 0c04          	inc	(OFST+0,sp)
2666  06e8               L44:
2667  06e8 9089          	pushw	y
2668  06ea a6a6          	ld	a,#166
2669  06ec cd0000        	call	_M24LR04E_WriteOneByte
2671  06ef 5b03          	addw	sp,#3
2672                     ; 816 	I2C_Cmd(M24LR04E_I2C, DISABLE);			
2674  06f1 4b00          	push	#0
2675  06f3 ae5210        	ldw	x,#21008
2676  06f6 cd0000        	call	_I2C_Cmd
2678  06f9 84            	pop	a
2679                     ; 818 	CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
2681  06fa ae0300        	ldw	x,#768
2682  06fd cd0000        	call	_CLK_PeripheralClockConfig
2684                     ; 820 	GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
2686  0700 7212500a      	bset	20490,#1
2687                     ; 821 	GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
2689  0704 7210500a      	bset	20490,#0
2690                     ; 824 	M24LR04E_DeInit();
2692  0708 cd0000        	call	_M24LR04E_DeInit
2694                     ; 825 	I2C_Cmd(M24LR04E_I2C, DISABLE);
2696  070b 4b00          	push	#0
2697  070d ae5210        	ldw	x,#21008
2698  0710 cd0000        	call	_I2C_Cmd
2700  0713 84            	pop	a
2701                     ; 828 	return SUCCESS;
2703  0714 a601          	ld	a,#1
2706  0716 5b04          	addw	sp,#4
2707  0718 81            	ret
2757                     ; 836 static void User_DisplayMessage (uint8_t message[],uint8_t PayloadLength )
2757                     ; 837 {
2758                     	switch	.text
2759  0719               L33_User_DisplayMessage:
2761  0719 89            	pushw	x
2762       00000000      OFST:	set	0
2765                     ; 848 		CLK_SYSCLKDivConfig(CLK_SYSCLKDiv_1);
2767  071a 4f            	clr	a
2768  071b cd0000        	call	_CLK_SYSCLKDivConfig
2770                     ; 849 		CLK_SYSCLKSourceConfig(CLK_SYSCLKSource_LSI);
2772  071e a602          	ld	a,#2
2773  0720 cd0000        	call	_CLK_SYSCLKSourceConfig
2775                     ; 850 		CLK_SYSCLKSourceSwitchCmd(ENABLE);
2777  0723 a601          	ld	a,#1
2778  0725 cd0000        	call	_CLK_SYSCLKSourceSwitchCmd
2781  0728               L7001:
2782                     ; 851 		while (((CLK->SWCR)& 0x01)==0x01);
2784  0728 c650c9        	ld	a,20681
2785  072b a401          	and	a,#1
2786  072d a101          	cp	a,#1
2787  072f 27f7          	jreq	L7001
2788                     ; 852 		CLK_HSICmd(DISABLE);
2790  0731 4f            	clr	a
2791  0732 cd0000        	call	_CLK_HSICmd
2793                     ; 853 		CLK->ECKCR &= ~0x01; 
2795  0735 721150c6      	bres	20678,#0
2796                     ; 856 		LCD_GLASS_ScrollSentenceNbCar(message,30,PayloadLength+6);		
2798  0739 7b05          	ld	a,(OFST+5,sp)
2799  073b ab06          	add	a,#6
2800  073d 88            	push	a
2801  073e ae001e        	ldw	x,#30
2802  0741 89            	pushw	x
2803  0742 1e04          	ldw	x,(OFST+4,sp)
2804  0744 cd0000        	call	_LCD_GLASS_ScrollSentenceNbCar
2806  0747 5b03          	addw	sp,#3
2807                     ; 860 			CLK_SYSCLKDivConfig(CLK_SYSCLKDiv_16);
2809  0749 a604          	ld	a,#4
2810  074b cd0000        	call	_CLK_SYSCLKDivConfig
2812                     ; 861 			CLK_HSICmd(ENABLE);
2814  074e a601          	ld	a,#1
2815  0750 cd0000        	call	_CLK_HSICmd
2818  0753               L5101:
2819                     ; 862 			while (((CLK->ICKCR)& 0x02)!=0x02);			
2821  0753 c650c2        	ld	a,20674
2822  0756 a402          	and	a,#2
2823  0758 a102          	cp	a,#2
2824  075a 26f7          	jrne	L5101
2825                     ; 863 			CLK_SYSCLKSourceConfig(CLK_SYSCLKSource_HSI);
2827  075c a601          	ld	a,#1
2828  075e cd0000        	call	_CLK_SYSCLKSourceConfig
2830                     ; 864 			CLK_SYSCLKSourceSwitchCmd(ENABLE);
2832  0761 a601          	ld	a,#1
2833  0763 cd0000        	call	_CLK_SYSCLKSourceSwitchCmd
2836  0766               L3201:
2837                     ; 865 			while (((CLK->SWCR)& 0x01)==0x01);
2839  0766 c650c9        	ld	a,20681
2840  0769 a401          	and	a,#1
2841  076b a101          	cp	a,#1
2842  076d 27f7          	jreq	L3201
2843                     ; 875 }
2846  076f 85            	popw	x
2847  0770 81            	ret
2890                     ; 882 static void User_DisplayMessageActiveHaltMode ( uint8_t PayloadLength )
2890                     ; 883 {
2891                     	switch	.text
2892  0771               L53_User_DisplayMessageActiveHaltMode:
2896                     ; 895 			CLK_SYSCLKDivConfig(CLK_SYSCLKDiv_1);
2898  0771 4f            	clr	a
2899  0772 cd0000        	call	_CLK_SYSCLKDivConfig
2901                     ; 896 			CLK_SYSCLKSourceConfig(CLK_SYSCLKSource_LSI);
2903  0775 a602          	ld	a,#2
2904  0777 cd0000        	call	_CLK_SYSCLKSourceConfig
2906                     ; 897 			CLK_SYSCLKSourceSwitchCmd(ENABLE);
2908  077a a601          	ld	a,#1
2909  077c cd0000        	call	_CLK_SYSCLKSourceSwitchCmd
2912  077f               L7401:
2913                     ; 898 			while (((CLK->SWCR)& 0x01)==0x01);
2915  077f c650c9        	ld	a,20681
2916  0782 a401          	and	a,#1
2917  0784 a101          	cp	a,#1
2918  0786 27f7          	jreq	L7401
2919                     ; 899 			CLK_HSICmd(DISABLE);
2921  0788 4f            	clr	a
2922  0789 cd0000        	call	_CLK_HSICmd
2924                     ; 900 			CLK->ECKCR &= ~0x01; 
2926  078c 721150c6      	bres	20678,#0
2927                     ; 904 		sim();
2930  0790 9b            sim
2932                     ; 907 			if (!(_fctcpy('D')))
2935  0791 a644          	ld	a,#68
2936  0793 cd0000        	call	__fctcpy
2938  0796 a30000        	cpw	x,#0
2939  0799 2602          	jrne	L3501
2940  079b               L5501:
2941                     ; 908 				while(1);
2943  079b 20fe          	jra	L5501
2944  079d               L3501:
2945                     ; 911 			Display_Ram (); // Call in RAM
2947  079d cd0000        	call	_Display_Ram
2949                     ; 917 			CLK_SYSCLKDivConfig(CLK_SYSCLKDiv_16);
2951  07a0 a604          	ld	a,#4
2952  07a2 cd0000        	call	_CLK_SYSCLKDivConfig
2954                     ; 918 			CLK_HSICmd(ENABLE);
2956  07a5 a601          	ld	a,#1
2957  07a7 cd0000        	call	_CLK_HSICmd
2960  07aa               L3601:
2961                     ; 919 			while (((CLK->ICKCR)& 0x02)!=0x02);			
2963  07aa c650c2        	ld	a,20674
2964  07ad a402          	and	a,#2
2965  07af a102          	cp	a,#2
2966  07b1 26f7          	jrne	L3601
2967                     ; 920 			CLK_SYSCLKSourceConfig(CLK_SYSCLKSource_HSI);
2969  07b3 a601          	ld	a,#1
2970  07b5 cd0000        	call	_CLK_SYSCLKSourceConfig
2972                     ; 921 			CLK_SYSCLKSourceSwitchCmd(ENABLE);
2974  07b8 a601          	ld	a,#1
2975  07ba cd0000        	call	_CLK_SYSCLKSourceSwitchCmd
2978  07bd               L1701:
2979                     ; 922 			while (((CLK->SWCR)& 0x01)==0x01);
2981  07bd c650c9        	ld	a,20681
2982  07c0 a401          	and	a,#1
2983  07c2 a101          	cp	a,#1
2984  07c4 27f7          	jreq	L1701
2985                     ; 934 		rim();
2988  07c6 9a            rim
2990                     ; 937 }
2994  07c7 81            	ret
3061                     ; 948 static ErrorStatus User_CheckNDEFMessage(void)
3061                     ; 949 {
3062                     	switch	.text
3063  07c8               L11_User_CheckNDEFMessage:
3065  07c8 5204          	subw	sp,#4
3066       00000004      OFST:	set	4
3069                     ; 950 uint8_t *OneByte = 0x00;
3071  07ca 5f            	clrw	x
3072  07cb 1f03          	ldw	(OFST-1,sp),x
3073                     ; 951 uint16_t ReadAddr = 0x0000;
3075                     ; 954 	M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr, OneByte);	
3077  07cd 5f            	clrw	x
3078  07ce 89            	pushw	x
3079  07cf 5f            	clrw	x
3080  07d0 89            	pushw	x
3081  07d1 a6a6          	ld	a,#166
3082  07d3 cd0000        	call	_M24LR04E_ReadOneByte
3084  07d6 5b04          	addw	sp,#4
3085                     ; 955 	if (*OneByte != 0xE1)
3087  07d8 1e03          	ldw	x,(OFST-1,sp)
3088  07da f6            	ld	a,(x)
3089  07db a1e1          	cp	a,#225
3090  07dd 2703          	jreq	L7211
3091                     ; 956 		return ERROR;
3093  07df 4f            	clr	a
3095  07e0 2016          	jra	L45
3096  07e2               L7211:
3097                     ; 958 	ReadAddr = 0x0009;
3099                     ; 959 	M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr, OneByte);	
3101  07e2 1e03          	ldw	x,(OFST-1,sp)
3102  07e4 89            	pushw	x
3103  07e5 ae0009        	ldw	x,#9
3104  07e8 89            	pushw	x
3105  07e9 a6a6          	ld	a,#166
3106  07eb cd0000        	call	_M24LR04E_ReadOneByte
3108  07ee 5b04          	addw	sp,#4
3109                     ; 961 	if (*OneByte != 0x54 /*&& *OneByte != 0x55*/)
3111  07f0 1e03          	ldw	x,(OFST-1,sp)
3112  07f2 f6            	ld	a,(x)
3113  07f3 a154          	cp	a,#84
3114  07f5 2704          	jreq	L1311
3115                     ; 962 		return ERROR;
3117  07f7 4f            	clr	a
3119  07f8               L45:
3121  07f8 5b04          	addw	sp,#4
3122  07fa 81            	ret
3123  07fb               L1311:
3124                     ; 964 	return SUCCESS;	
3126  07fb a601          	ld	a,#1
3128  07fd 20f9          	jra	L45
3175                     ; 973 static ErrorStatus User_GetPayloadLength(uint8_t *PayloadLength)
3175                     ; 974 {
3176                     	switch	.text
3177  07ff               L7_User_GetPayloadLength:
3179  07ff 89            	pushw	x
3180  0800 89            	pushw	x
3181       00000002      OFST:	set	2
3184                     ; 975 uint16_t ReadAddr = 0x0008;
3186                     ; 977 	*PayloadLength = 0x00;
3188  0801 7f            	clr	(x)
3189                     ; 979 	M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr, PayloadLength);	
3191  0802 89            	pushw	x
3192  0803 ae0008        	ldw	x,#8
3193  0806 89            	pushw	x
3194  0807 a6a6          	ld	a,#166
3195  0809 cd0000        	call	_M24LR04E_ReadOneByte
3197  080c 5b04          	addw	sp,#4
3198                     ; 980 	if (*PayloadLength == 0x00)
3200  080e 1e03          	ldw	x,(OFST+1,sp)
3201  0810 7d            	tnz	(x)
3202  0811 2603          	jrne	L5511
3203                     ; 981 		return ERROR;
3205  0813 4f            	clr	a
3207  0814 2002          	jra	L06
3208  0816               L5511:
3209                     ; 983 	return SUCCESS;	
3211  0816 a601          	ld	a,#1
3213  0818               L06:
3215  0818 5b04          	addw	sp,#4
3216  081a 81            	ret
3272                     ; 994 static ErrorStatus User_GetNDEFMessage(uint8_t  PayloadLength,uint8_t *NDEFmessage)
3272                     ; 995 {
3273                     	switch	.text
3274  081b               L31_User_GetNDEFMessage:
3276  081b 88            	push	a
3277  081c 89            	pushw	x
3278       00000002      OFST:	set	2
3281                     ; 996 uint16_t ReadAddr = 0x000D;
3283                     ; 998 	if (PayloadLength == 0x00)
3285  081d 4d            	tnz	a
3286  081e 2604          	jrne	L5021
3287                     ; 999 		return SUCCESS;		
3289  0820 a601          	ld	a,#1
3291  0822 2013          	jra	L46
3292  0824               L5021:
3293                     ; 1001 	M24LR04E_ReadBuffer (M24LR16_EEPROM_ADDRESS_USER, ReadAddr,PayloadLength, NDEFmessage);	
3295  0824 1e06          	ldw	x,(OFST+4,sp)
3296  0826 89            	pushw	x
3297  0827 7b05          	ld	a,(OFST+3,sp)
3298  0829 88            	push	a
3299  082a ae000d        	ldw	x,#13
3300  082d 89            	pushw	x
3301  082e a6a6          	ld	a,#166
3302  0830 cd0000        	call	_M24LR04E_ReadBuffer
3304  0833 5b05          	addw	sp,#5
3305                     ; 1003 	return SUCCESS;	
3307  0835 a601          	ld	a,#1
3309  0837               L46:
3311  0837 5b03          	addw	sp,#3
3312  0839 81            	ret
3348                     ; 1012 static void User_DesactivateEnergyHarvesting ( void )
3348                     ; 1013 {
3349                     	switch	.text
3350  083a               L32_User_DesactivateEnergyHarvesting:
3352  083a 89            	pushw	x
3353       00000002      OFST:	set	2
3356                     ; 1014 uint16_t WriteAddr = 0x0920;
3358                     ; 1015 	M24LR04E_WriteOneByte (M24LR16_EEPROM_ADDRESS_SYSTEM, WriteAddr,0x00)	;
3360  083b 4b00          	push	#0
3361  083d ae0920        	ldw	x,#2336
3362  0840 89            	pushw	x
3363  0841 a6ae          	ld	a,#174
3364  0843 cd0000        	call	_M24LR04E_WriteOneByte
3366  0846 5b03          	addw	sp,#3
3367                     ; 1016 }
3370  0848 85            	popw	x
3371  0849 81            	ret
3443                     ; 1024 static void ToUpperCase (uint8_t  NbCar ,uint8_t *StringToConvert)
3443                     ; 1025 {
3444                     	switch	.text
3445  084a               L51_ToUpperCase:
3447  084a 88            	push	a
3448  084b 52ff          	subw	sp,#255
3449  084d 5212          	subw	sp,#18
3450       00000111      OFST:	set	273
3453                     ; 1027 				i=3,
3455                     ; 1028 				NbSpace = 6;
3457  084f a606          	ld	a,#6
3458  0851 6b11          	ld	(OFST-256,sp),a
3459                     ; 1030 	for (i=0;i<NbSpace;i++)
3461  0853 96            	ldw	x,sp
3462  0854 1c0111        	addw	x,#OFST+0
3463  0857 7f            	clr	(x)
3465  0858 201a          	jra	L7621
3466  085a               L3621:
3467                     ; 1031 			Buffer[i] = ' ';
3469  085a 96            	ldw	x,sp
3470  085b 1c0012        	addw	x,#OFST-255
3471  085e 9f            	ld	a,xl
3472  085f 5e            	swapw	x
3473  0860 9096          	ldw	y,sp
3474  0862 72a90111      	addw	y,#OFST+0
3475  0866 90fb          	add	a,(y)
3476  0868 2401          	jrnc	L27
3477  086a 5c            	incw	x
3478  086b               L27:
3479  086b 02            	rlwa	x,a
3480  086c a620          	ld	a,#32
3481  086e f7            	ld	(x),a
3482                     ; 1030 	for (i=0;i<NbSpace;i++)
3484  086f 96            	ldw	x,sp
3485  0870 1c0111        	addw	x,#OFST+0
3486  0873 7c            	inc	(x)
3487  0874               L7621:
3490  0874 96            	ldw	x,sp
3491  0875 1c0111        	addw	x,#OFST+0
3492  0878 f6            	ld	a,(x)
3493  0879 1111          	cp	a,(OFST-256,sp)
3494  087b 25dd          	jrult	L3621
3495                     ; 1033 	for (i=0;i<NbCar;i++)
3497  087d 96            	ldw	x,sp
3498  087e 1c0111        	addw	x,#OFST+0
3499  0881 7f            	clr	(x)
3501  0882 2030          	jra	L7721
3502  0884               L3721:
3503                     ; 1034 			Buffer[i+NbSpace] = StringToConvert[i];
3505  0884 96            	ldw	x,sp
3506  0885 1c0012        	addw	x,#OFST-255
3507  0888 1f0f          	ldw	(OFST-258,sp),x
3508  088a 96            	ldw	x,sp
3509  088b 1c0111        	addw	x,#OFST+0
3510  088e f6            	ld	a,(x)
3511  088f 5f            	clrw	x
3512  0890 1b11          	add	a,(OFST-256,sp)
3513  0892 2401          	jrnc	L47
3514  0894 5c            	incw	x
3515  0895               L47:
3516  0895 02            	rlwa	x,a
3517  0896 72fb0f        	addw	x,(OFST-258,sp)
3518  0899 89            	pushw	x
3519  089a 96            	ldw	x,sp
3520  089b 1c0117        	addw	x,#OFST+6
3521  089e fe            	ldw	x,(x)
3522  089f 01            	rrwa	x,a
3523  08a0 9096          	ldw	y,sp
3524  08a2 72a90113      	addw	y,#OFST+2
3525  08a6 90fb          	add	a,(y)
3526  08a8 2401          	jrnc	L67
3527  08aa 5c            	incw	x
3528  08ab               L67:
3529  08ab 02            	rlwa	x,a
3530  08ac f6            	ld	a,(x)
3531  08ad 85            	popw	x
3532  08ae f7            	ld	(x),a
3533                     ; 1033 	for (i=0;i<NbCar;i++)
3535  08af 96            	ldw	x,sp
3536  08b0 1c0111        	addw	x,#OFST+0
3537  08b3 7c            	inc	(x)
3538  08b4               L7721:
3541  08b4 96            	ldw	x,sp
3542  08b5 1c0111        	addw	x,#OFST+0
3543  08b8 f6            	ld	a,(x)
3544  08b9 96            	ldw	x,sp
3545  08ba 1c0112        	addw	x,#OFST+1
3546  08bd f1            	cp	a,(x)
3547  08be 25c4          	jrult	L3721
3548                     ; 1036 	for (i=0;i<NbCar+NbSpace;i++)
3550  08c0 96            	ldw	x,sp
3551  08c1 1c0111        	addw	x,#OFST+0
3552  08c4 7f            	clr	(x)
3554  08c5 cc094f        	jra	L7031
3555  08c8               L3031:
3556                     ; 1038 		if (Buffer[i] >= 0x61 && Buffer[i] <= 0x7A)
3558  08c8 96            	ldw	x,sp
3559  08c9 1c0012        	addw	x,#OFST-255
3560  08cc 9f            	ld	a,xl
3561  08cd 5e            	swapw	x
3562  08ce 9096          	ldw	y,sp
3563  08d0 72a90111      	addw	y,#OFST+0
3564  08d4 90fb          	add	a,(y)
3565  08d6 2401          	jrnc	L001
3566  08d8 5c            	incw	x
3567  08d9               L001:
3568  08d9 02            	rlwa	x,a
3569  08da f6            	ld	a,(x)
3570  08db a161          	cp	a,#97
3571  08dd 2543          	jrult	L3131
3573  08df 96            	ldw	x,sp
3574  08e0 1c0012        	addw	x,#OFST-255
3575  08e3 9f            	ld	a,xl
3576  08e4 5e            	swapw	x
3577  08e5 9096          	ldw	y,sp
3578  08e7 72a90111      	addw	y,#OFST+0
3579  08eb 90fb          	add	a,(y)
3580  08ed 2401          	jrnc	L201
3581  08ef 5c            	incw	x
3582  08f0               L201:
3583  08f0 02            	rlwa	x,a
3584  08f1 f6            	ld	a,(x)
3585  08f2 a17b          	cp	a,#123
3586  08f4 242c          	jruge	L3131
3587                     ; 1039 			StringToConvert[i] = Buffer[i]-32;
3589  08f6 96            	ldw	x,sp
3590  08f7 1c0115        	addw	x,#OFST+4
3591  08fa fe            	ldw	x,(x)
3592  08fb 01            	rrwa	x,a
3593  08fc 9096          	ldw	y,sp
3594  08fe 72a90111      	addw	y,#OFST+0
3595  0902 90fb          	add	a,(y)
3596  0904 2401          	jrnc	L401
3597  0906 5c            	incw	x
3598  0907               L401:
3599  0907 02            	rlwa	x,a
3600  0908 89            	pushw	x
3601  0909 96            	ldw	x,sp
3602  090a 1c0014        	addw	x,#OFST-253
3603  090d 9f            	ld	a,xl
3604  090e 5e            	swapw	x
3605  090f 9096          	ldw	y,sp
3606  0911 72a90113      	addw	y,#OFST+2
3607  0915 90fb          	add	a,(y)
3608  0917 2401          	jrnc	L601
3609  0919 5c            	incw	x
3610  091a               L601:
3611  091a 02            	rlwa	x,a
3612  091b f6            	ld	a,(x)
3613  091c a020          	sub	a,#32
3614  091e 85            	popw	x
3615  091f f7            	ld	(x),a
3617  0920 2028          	jra	L5131
3618  0922               L3131:
3619                     ; 1041 			StringToConvert[i] = Buffer[i];
3621  0922 96            	ldw	x,sp
3622  0923 1c0115        	addw	x,#OFST+4
3623  0926 fe            	ldw	x,(x)
3624  0927 01            	rrwa	x,a
3625  0928 9096          	ldw	y,sp
3626  092a 72a90111      	addw	y,#OFST+0
3627  092e 90fb          	add	a,(y)
3628  0930 2401          	jrnc	L011
3629  0932 5c            	incw	x
3630  0933               L011:
3631  0933 02            	rlwa	x,a
3632  0934 89            	pushw	x
3633  0935 96            	ldw	x,sp
3634  0936 1c0014        	addw	x,#OFST-253
3635  0939 9f            	ld	a,xl
3636  093a 5e            	swapw	x
3637  093b 9096          	ldw	y,sp
3638  093d 72a90113      	addw	y,#OFST+2
3639  0941 90fb          	add	a,(y)
3640  0943 2401          	jrnc	L211
3641  0945 5c            	incw	x
3642  0946               L211:
3643  0946 02            	rlwa	x,a
3644  0947 f6            	ld	a,(x)
3645  0948 85            	popw	x
3646  0949 f7            	ld	(x),a
3647  094a               L5131:
3648                     ; 1036 	for (i=0;i<NbCar+NbSpace;i++)
3650  094a 96            	ldw	x,sp
3651  094b 1c0111        	addw	x,#OFST+0
3652  094e 7c            	inc	(x)
3653  094f               L7031:
3656  094f 9c            	rvf
3657  0950 96            	ldw	x,sp
3658  0951 1c0111        	addw	x,#OFST+0
3659  0954 f6            	ld	a,(x)
3660  0955 5f            	clrw	x
3661  0956 97            	ld	xl,a
3662  0957 1f0f          	ldw	(OFST-258,sp),x
3663  0959 96            	ldw	x,sp
3664  095a 1c0112        	addw	x,#OFST+1
3665  095d f6            	ld	a,(x)
3666  095e 5f            	clrw	x
3667  095f 1b11          	add	a,(OFST-256,sp)
3668  0961 2401          	jrnc	L411
3669  0963 5c            	incw	x
3670  0964               L411:
3671  0964 02            	rlwa	x,a
3672  0965 130f          	cpw	x,(OFST-258,sp)
3673  0967 2d03          	jrsle	L221
3674  0969 cc08c8        	jp	L3031
3675  096c               L221:
3676                     ; 1043 	StringToConvert[NbCar+NbSpace] = ' ';
3678  096c 96            	ldw	x,sp
3679  096d 1c0112        	addw	x,#OFST+1
3680  0970 f6            	ld	a,(x)
3681  0971 5f            	clrw	x
3682  0972 1b11          	add	a,(OFST-256,sp)
3683  0974 2401          	jrnc	L611
3684  0976 5c            	incw	x
3685  0977               L611:
3686  0977 02            	rlwa	x,a
3687  0978 9096          	ldw	y,sp
3688  097a 72a90115      	addw	y,#OFST+4
3689  097e 90fe          	ldw	y,(y)
3690  0980 90bf00        	ldw	c_x,y
3691  0983 72bb0000      	addw	x,c_x
3692  0987 a620          	ld	a,#32
3693  0989 f7            	ld	(x),a
3694                     ; 1044 	StringToConvert[NbCar+NbSpace+1] = 0;
3696  098a 96            	ldw	x,sp
3697  098b 1c0112        	addw	x,#OFST+1
3698  098e f6            	ld	a,(x)
3699  098f 5f            	clrw	x
3700  0990 1b11          	add	a,(OFST-256,sp)
3701  0992 2401          	jrnc	L021
3702  0994 5c            	incw	x
3703  0995               L021:
3704  0995 02            	rlwa	x,a
3705  0996 9096          	ldw	y,sp
3706  0998 72a90115      	addw	y,#OFST+4
3707  099c 90fe          	ldw	y,(y)
3708  099e 90bf00        	ldw	c_x,y
3709  09a1 72bb0000      	addw	x,c_x
3710  09a5 6f01          	clr	(1,x)
3711                     ; 1046 }
3714  09a7 5bff          	addw	sp,#255
3715  09a9 5b13          	addw	sp,#19
3716  09ab 81            	ret
3740                     ; 1053 static void DeInitClock ( void )
3740                     ; 1054 {
3741                     	switch	.text
3742  09ac               L71_DeInitClock:
3746                     ; 1055 	CLK_PeripheralClockConfig(CLK_Peripheral_TIM2, DISABLE);
3748  09ac 5f            	clrw	x
3749  09ad cd0000        	call	_CLK_PeripheralClockConfig
3751                     ; 1056 	CLK_PeripheralClockConfig(CLK_Peripheral_TIM3, DISABLE);
3753  09b0 ae0100        	ldw	x,#256
3754  09b3 cd0000        	call	_CLK_PeripheralClockConfig
3756                     ; 1057 	CLK_PeripheralClockConfig(CLK_Peripheral_TIM4, DISABLE);
3758  09b6 ae0200        	ldw	x,#512
3759  09b9 cd0000        	call	_CLK_PeripheralClockConfig
3761                     ; 1058 	CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);
3763  09bc ae0300        	ldw	x,#768
3764  09bf cd0000        	call	_CLK_PeripheralClockConfig
3766                     ; 1059 	CLK_PeripheralClockConfig(CLK_Peripheral_SPI1, DISABLE);
3768  09c2 ae0400        	ldw	x,#1024
3769  09c5 cd0000        	call	_CLK_PeripheralClockConfig
3771                     ; 1060 	CLK_PeripheralClockConfig(CLK_Peripheral_USART1, DISABLE);
3773  09c8 ae0500        	ldw	x,#1280
3774  09cb cd0000        	call	_CLK_PeripheralClockConfig
3776                     ; 1061 	CLK_PeripheralClockConfig(CLK_Peripheral_BEEP, DISABLE);
3778  09ce ae0600        	ldw	x,#1536
3779  09d1 cd0000        	call	_CLK_PeripheralClockConfig
3781                     ; 1062 	CLK_PeripheralClockConfig(CLK_Peripheral_DAC, DISABLE);
3783  09d4 ae0700        	ldw	x,#1792
3784  09d7 cd0000        	call	_CLK_PeripheralClockConfig
3786                     ; 1063 	CLK_PeripheralClockConfig(CLK_Peripheral_ADC1, DISABLE);
3788  09da ae1000        	ldw	x,#4096
3789  09dd cd0000        	call	_CLK_PeripheralClockConfig
3791                     ; 1064 	CLK_PeripheralClockConfig(CLK_Peripheral_TIM1, DISABLE);
3793  09e0 ae1100        	ldw	x,#4352
3794  09e3 cd0000        	call	_CLK_PeripheralClockConfig
3796                     ; 1065 	CLK_PeripheralClockConfig(CLK_Peripheral_RTC, DISABLE);
3798  09e6 ae1200        	ldw	x,#4608
3799  09e9 cd0000        	call	_CLK_PeripheralClockConfig
3801                     ; 1066 	CLK_PeripheralClockConfig(CLK_Peripheral_LCD, DISABLE);
3803  09ec ae1300        	ldw	x,#4864
3804  09ef cd0000        	call	_CLK_PeripheralClockConfig
3806                     ; 1067 	CLK_PeripheralClockConfig(CLK_Peripheral_ADC1, DISABLE);
3808  09f2 ae1000        	ldw	x,#4096
3809  09f5 cd0000        	call	_CLK_PeripheralClockConfig
3811                     ; 1068 	CLK_PeripheralClockConfig(CLK_Peripheral_DMA1, DISABLE);
3813  09f8 ae1400        	ldw	x,#5120
3814  09fb cd0000        	call	_CLK_PeripheralClockConfig
3816                     ; 1069 	CLK_PeripheralClockConfig(CLK_Peripheral_ADC1, DISABLE);
3818  09fe ae1000        	ldw	x,#4096
3819  0a01 cd0000        	call	_CLK_PeripheralClockConfig
3821                     ; 1070 	CLK_PeripheralClockConfig(CLK_Peripheral_BOOTROM, DISABLE);
3823  0a04 ae1700        	ldw	x,#5888
3824  0a07 cd0000        	call	_CLK_PeripheralClockConfig
3826                     ; 1071 	CLK_PeripheralClockConfig(CLK_Peripheral_AES, DISABLE);
3828  0a0a ae2000        	ldw	x,#8192
3829  0a0d cd0000        	call	_CLK_PeripheralClockConfig
3831                     ; 1072 	CLK_PeripheralClockConfig(CLK_Peripheral_ADC1, DISABLE);
3833  0a10 ae1000        	ldw	x,#4096
3834  0a13 cd0000        	call	_CLK_PeripheralClockConfig
3836                     ; 1073 	CLK_PeripheralClockConfig(CLK_Peripheral_TIM5, DISABLE);
3838  0a16 ae2100        	ldw	x,#8448
3839  0a19 cd0000        	call	_CLK_PeripheralClockConfig
3841                     ; 1074 	CLK_PeripheralClockConfig(CLK_Peripheral_SPI2, DISABLE);
3843  0a1c ae2200        	ldw	x,#8704
3844  0a1f cd0000        	call	_CLK_PeripheralClockConfig
3846                     ; 1075 	CLK_PeripheralClockConfig(CLK_Peripheral_USART2, DISABLE);
3848  0a22 ae2300        	ldw	x,#8960
3849  0a25 cd0000        	call	_CLK_PeripheralClockConfig
3851                     ; 1076 	CLK_PeripheralClockConfig(CLK_Peripheral_USART3, DISABLE);
3853  0a28 ae2400        	ldw	x,#9216
3854  0a2b cd0000        	call	_CLK_PeripheralClockConfig
3856                     ; 1077 	CLK_PeripheralClockConfig(CLK_Peripheral_CSSLSE, DISABLE);
3858  0a2e ae2500        	ldw	x,#9472
3859  0a31 cd0000        	call	_CLK_PeripheralClockConfig
3861                     ; 1079 }
3864  0a34 81            	ret
3888                     ; 1085 static void DeInitGPIO ( void )
3888                     ; 1086 {
3889                     	switch	.text
3890  0a35               L12_DeInitGPIO:
3894                     ; 1088 	GPIO_Init( GPIOA, GPIO_Pin_All, GPIO_Mode_Out_OD_Low_Fast);
3896  0a35 4ba0          	push	#160
3897  0a37 4bff          	push	#255
3898  0a39 ae5000        	ldw	x,#20480
3899  0a3c cd0000        	call	_GPIO_Init
3901  0a3f 85            	popw	x
3902                     ; 1089 	GPIO_Init( GPIOB, GPIO_Pin_All, GPIO_Mode_Out_OD_Low_Fast);
3904  0a40 4ba0          	push	#160
3905  0a42 4bff          	push	#255
3906  0a44 ae5005        	ldw	x,#20485
3907  0a47 cd0000        	call	_GPIO_Init
3909  0a4a 85            	popw	x
3910                     ; 1091   GPIO_Init( GPIOC, GPIO_Pin_2 | GPIO_Pin_3 | GPIO_Pin_4 | GPIO_Pin_5 |\
3910                     ; 1092 	           GPIO_Pin_5 | GPIO_Pin_6 |GPIO_Pin_7, GPIO_Mode_Out_OD_Low_Fast);
3912  0a4b 4ba0          	push	#160
3913  0a4d 4bfc          	push	#252
3914  0a4f ae500a        	ldw	x,#20490
3915  0a52 cd0000        	call	_GPIO_Init
3917  0a55 85            	popw	x
3918                     ; 1093 	GPIO_Init( GPIOD, GPIO_Pin_All, GPIO_Mode_Out_OD_Low_Fast);
3920  0a56 4ba0          	push	#160
3921  0a58 4bff          	push	#255
3922  0a5a ae500f        	ldw	x,#20495
3923  0a5d cd0000        	call	_GPIO_Init
3925  0a60 85            	popw	x
3926                     ; 1094 	GPIO_Init( GPIOE, GPIO_Pin_All, GPIO_Mode_Out_OD_Low_Fast);
3928  0a61 4ba0          	push	#160
3929  0a63 4bff          	push	#255
3930  0a65 ae5014        	ldw	x,#20500
3931  0a68 cd0000        	call	_GPIO_Init
3933  0a6b 85            	popw	x
3934                     ; 1096 	GPIOA->ODR = 0xFF;
3936  0a6c 35ff5000      	mov	20480,#255
3937                     ; 1097 	GPIOB->ODR = 0xFF;
3939  0a70 35ff5005      	mov	20485,#255
3940                     ; 1098 	GPIOC->ODR = 0xFF;
3942  0a74 35ff500a      	mov	20490,#255
3943                     ; 1099 	GPIOD->ODR = 0xFF;
3945  0a78 35ff500f      	mov	20495,#255
3946                     ; 1100 	GPIOE->ODR = 0xFF;
3948  0a7c 35ff5014      	mov	20500,#255
3949                     ; 1102 }
3952  0a80 81            	ret
3996                     ; 1110 static void InitializeBuffer (uint8_t *Buffer ,uint8_t NbCar)
3996                     ; 1111 {
3997                     	switch	.text
3998  0a81               L72_InitializeBuffer:
4000  0a81 89            	pushw	x
4001       00000000      OFST:	set	0
4004  0a82               L1631:
4005                     ; 1115 		Buffer[NbCar]= 0;
4007  0a82 7b01          	ld	a,(OFST+1,sp)
4008  0a84 97            	ld	xl,a
4009  0a85 7b02          	ld	a,(OFST+2,sp)
4010  0a87 1b05          	add	a,(OFST+5,sp)
4011  0a89 2401          	jrnc	L231
4012  0a8b 5c            	incw	x
4013  0a8c               L231:
4014  0a8c 02            	rlwa	x,a
4015  0a8d 7f            	clr	(x)
4016                     ; 1116 	}	while (NbCar--);
4018  0a8e 7b05          	ld	a,(OFST+5,sp)
4019  0a90 0a05          	dec	(OFST+5,sp)
4020  0a92 4d            	tnz	a
4021  0a93 26ed          	jrne	L1631
4022                     ; 1117 }
4025  0a95 85            	popw	x
4026  0a96 81            	ret
4264                     	xdef	_main
4265                     	switch	.eeprom
4266  0001               _EE_Buf_Flag:
4267  0001 00            	ds.b	1
4268                     	xdef	_EE_Buf_Flag
4269  0002               _EE_Buffer_1:
4270  0002 00            	ds.b	1
4271                     	xdef	_EE_Buffer_1
4272  0003               _EE_Buffer_2:
4273  0003 00            	ds.b	1
4274                     	xdef	_EE_Buffer_2
4275  0004               _EE_Buffer_3:
4276  0004 00            	ds.b	1
4277                     	xdef	_EE_Buffer_3
4278  0005               _EE_Buffer_4:
4279  0005 00            	ds.b	1
4280                     	xdef	_EE_Buffer_4
4281  0006               _EE_Buffer_5:
4282  0006 00            	ds.b	1
4283                     	xdef	_EE_Buffer_5
4284  0007               _EE_Buffer_6:
4285  0007 00            	ds.b	1
4286                     	xdef	_EE_Buffer_6
4287  0008               _EE_Buffer_7:
4288  0008 00            	ds.b	1
4289                     	xdef	_EE_Buffer_7
4290  0009               _EE_Buffer_8:
4291  0009 00            	ds.b	1
4292                     	xdef	_EE_Buffer_8
4293  000a               _EE_Buffer_9:
4294  000a 00            	ds.b	1
4295                     	xdef	_EE_Buffer_9
4296  000b               _EE_Buffer_10:
4297  000b 00            	ds.b	1
4298                     	xdef	_EE_Buffer_10
4299  000c               _EE_Buffer_11:
4300  000c 00            	ds.b	1
4301                     	xdef	_EE_Buffer_11
4302  000d               _EE_Pay_Lengt:
4303  000d 00            	ds.b	1
4304                     	xdef	_EE_Pay_Lengt
4305                     	xdef	_FirmwareVersion
4306                     	xdef	_EEInitial
4307  000e               _EEMenuState:
4308  000e 00            	ds.b	1
4309                     	xdef	_EEMenuState
4310                     	xdef	_ErrorMessage
4311                     	switch	.ubsct
4312  0000               _NDEFmessage:
4313  0000 000000000000  	ds.b	64
4314                     	xdef	_NDEFmessage
4315                     	xref.b	_t_bar
4316  0040               L76_CodeLength:
4317  0040 0000          	ds.b	2
4318                     	xdef	_LCD_GLASS_DisplayString_1
4319  0042               _state_machine:
4320  0042 00            	ds.b	1
4321                     	xdef	_state_machine
4322                     	xref	_delayLFO_ms
4323                     	xref	_Display_Ram
4324                     	xref	_Vref_measure
4325                     	xref	__fctcpy
4326                     	xref	_I2C_SS_ReadOneByte
4327                     	xref	_I2C_SS_Config
4328                     	xref	_I2C_SS_Init
4329                     	xref	_M24LR04E_WriteOneByte
4330                     	xref	_M24LR04E_ReadBuffer
4331                     	xref	_M24LR04E_ReadOneByte
4332                     	xref	_M24LR04E_Init
4333                     	xref	_M24LR04E_DeInit
4334                     	xref	_I2C_Cmd
4335                     	xref	_LCD_GLASS_ScrollSentenceNbCar
4336                     	xref	_LCD_GLASS_Clear
4337                     	xref	_LCD_GLASS_DisplayStrDeci
4338                     	xref	_LCD_GLASS_DisplayString
4339                     	xref	_LCD_GLASS_WriteChar
4340                     	xref	_LCD_GLASS_Init
4341                     	xref	_GPIO_ResetBits
4342                     	xref	_GPIO_SetBits
4343                     	xref	_GPIO_Init
4344                     	xref	_FLASH_Unlock
4345                     	xref	_EXTI_SetPinSensitivity
4346                     	xref	_CLK_PeripheralClockConfig
4347                     	xref	_CLK_SYSCLKSourceSwitchCmd
4348                     	xref	_CLK_SYSCLKDivConfig
4349                     	xref	_CLK_SYSCLKSourceConfig
4350                     	xref	_CLK_HSICmd
4351                     	switch	.const
4352  002b               L371:
4353  002b 4572726f7200  	dc.b	"Error",0
4354  0031               L171:
4355  0031 4f4e4c592034  	dc.b	"ONLY 4 CHARACTERS "
4356  0043 454e54455220  	dc.b	"ENTER PIN AGAIN",0
4357  0053               L561:
4358  0053 434c4f534544  	dc.b	"CLOSED",0
4359  005a               L751:
4360  005a 4f50454e00    	dc.b	"OPEN",0
4361                     	xref.b	c_x
4381                     	xref	c_sdivx
4382                     	xref	c_smodx
4383                     	xref	c_eewrc
4384                     	end
