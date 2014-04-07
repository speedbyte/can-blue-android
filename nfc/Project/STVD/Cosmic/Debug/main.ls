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
 163                     ; 118 void main(void)
 163                     ; 119 { 
 165                     	switch	.text
 166  0000               _main:
 168  0000 5204          	subw	sp,#4
 169       00000004      OFST:	set	4
 172                     ; 125 	UnInitialize();
 174  0002 cd0000        	call	_UnInitialize
 176                     ; 129 		CLK_SYSCLKSourceConfig(CLK_SYSCLKSource_HSI);
 178  0005 a601          	ld	a,#1
 179  0007 cd0000        	call	_CLK_SYSCLKSourceConfig
 181                     ; 130 		CLK_SYSCLKDivConfig(CLK_SYSCLKDiv_16);	
 183  000a a604          	ld	a,#4
 184  000c cd0000        	call	_CLK_SYSCLKDivConfig
 186                     ; 140 	Initialize();
 188  000f cd0000        	call	_Initialize
 190                     ; 142 	enableInterrupts();
 193  0012 9a            rim
 195                     ; 145 	bufMessage = NDEFmessage;
 198                     ; 147 	if (EEMenuState > STATE_TEMPMEAS) 
 200  0013 c6000e        	ld	a,_EEMenuState
 201  0016 a103          	cp	a,#3
 202  0018 2507          	jrult	L131
 203                     ; 148 		EEMenuState = STATE_CHECKNDEFMESSAGE;
 205  001a 4f            	clr	a
 206  001b ae000e        	ldw	x,#_EEMenuState
 207  001e cd0000        	call	c_eewrc
 209  0021               L131:
 210                     ; 150 	FLASH_Unlock(FLASH_MemType_Data );
 212  0021 a6f7          	ld	a,#247
 213  0023 cd0000        	call	_FLASH_Unlock
 215                     ; 152 	state_machine = EEMenuState ; 
 217  0026 55000e004b    	mov	_state_machine,_EEMenuState
 218                     ; 154 	delayLFO_ms (1);
 220  002b ae0001        	ldw	x,#1
 221  002e cd0000        	call	_delayLFO_ms
 223                     ; 159 	if (EEInitial == 0 )
 225  0031 725d0000      	tnz	_EEInitial
 226  0035 260b          	jrne	L531
 227                     ; 161 			User_WriteFirmwareVersion ();
 229  0037 cd0715        	call	L73_User_WriteFirmwareVersion
 231                     ; 162 			EEInitial =1;
 233  003a a601          	ld	a,#1
 234  003c ae0000        	ldw	x,#_EEInitial
 235  003f cd0000        	call	c_eewrc
 237  0042               L531:
 238                     ; 168 		switch (state_machine)
 240  0042 b64b          	ld	a,_state_machine
 242                     ; 245 			break;
 243  0044 4d            	tnz	a
 244  0045 2723          	jreq	L76
 245  0047 4a            	dec	a
 246  0048 2715          	jreq	L56
 247  004a 4a            	dec	a
 248  004b 2603          	jrne	L6
 249  004d cc00e1        	jp	L17
 250  0050               L6:
 251  0050               L37:
 252                     ; 241 			default:
 252                     ; 242 				clearLCD();
 254  0050 cd0000        	call	_clearLCD
 256                     ; 243 				LCD_GLASS_DisplayString("Error");
 258  0053 ae0044        	ldw	x,#L761
 259  0056 cd0000        	call	_LCD_GLASS_DisplayString
 261                     ; 244 				state_machine = STATE_VREF;
 263  0059 3501004b      	mov	_state_machine,#1
 264                     ; 245 			break;
 266  005d 20e3          	jra	L531
 267  005f               L56:
 268                     ; 171 			case STATE_VREF:
 268                     ; 172 				// measure the voltage available at the output of the M24LR04E-R
 268                     ; 173 				Vref_measure();
 270  005f cd0000        	call	_Vref_measure
 272                     ; 175 				delayLFO_ms (2);
 274  0062 ae0002        	ldw	x,#2
 275  0065 cd0000        	call	_delayLFO_ms
 277                     ; 177 			break;
 279  0068 20d8          	jra	L531
 280  006a               L76:
 281                     ; 179 			case STATE_CHECKNDEFMESSAGE:
 281                     ; 180 						
 281                     ; 181 				if(User_ReadNDEFMessage (&PayloadLength) == SUCCESS)
 283  006a 96            	ldw	x,sp
 284  006b 1c0003        	addw	x,#OFST-1
 285  006e cd0179        	call	L52_User_ReadNDEFMessage
 287  0071 a101          	cp	a,#1
 288  0073 2662          	jrne	L541
 289                     ; 183 					if(Check_Code_Length() == SUCCESS)
 291  0075 cd01ff        	call	L55_Check_Code_Length
 293  0078 a101          	cp	a,#1
 294  007a 2649          	jrne	L741
 295                     ; 185 						clearLCD();
 297  007c cd0000        	call	_clearLCD
 299                     ; 187 						code[0]=EE_Buffer_2[0];
 301  007f 5500030005    	mov	_code,_EE_Buffer_2
 302                     ; 188 						code[1]=EE_Buffer_3[0];
 304  0084 5500040006    	mov	_code+1,_EE_Buffer_3
 305                     ; 189 						code[2]=EE_Buffer_4[0];
 307  0089 5500050007    	mov	_code+2,_EE_Buffer_4
 308                     ; 190 						code[3]=EE_Buffer_5[0];
 310  008e 5500060008    	mov	_code+3,_EE_Buffer_5
 311                     ; 203 						if( EE_Buf_Flag[0] == 0x00 ) // geoeffnete Zustand
 313  0093 725d0001      	tnz	_EE_Buf_Flag
 314  0097 2612          	jrne	L151
 315                     ; 205 							setLED(0); // turn LED off
 317  0099 4f            	clr	a
 318  009a cd0000        	call	_setLED
 320                     ; 206 							State_DisplayMessage ("OPEN", 4);
 322  009d 4b04          	push	#4
 323  009f ae0073        	ldw	x,#L351
 324  00a2 cd0699        	call	L35_State_DisplayMessage
 326  00a5 84            	pop	a
 327                     ; 207 							Copy_Units_in_other_memory(); //Zustands Transaktion von geoffnet nach geschlossen
 329  00a6 cd0495        	call	L14_Copy_Units_in_other_memory
 332  00a9 202c          	jra	L541
 333  00ab               L151:
 334                     ; 210 						else if( EE_Buf_Flag[0] == 0xFF ) // geschlossene Zustand
 336  00ab c60001        	ld	a,_EE_Buf_Flag
 337  00ae a1ff          	cp	a,#255
 338  00b0 2625          	jrne	L541
 339                     ; 212 							setLED(1); // turn LED on
 341  00b2 a601          	ld	a,#1
 342  00b4 cd0000        	call	_setLED
 344                     ; 213 							State_DisplayMessage ("CLOSED", 6);
 346  00b7 4b06          	push	#6
 347  00b9 ae006c        	ldw	x,#L161
 348  00bc cd0699        	call	L35_State_DisplayMessage
 350  00bf 84            	pop	a
 351                     ; 214 							Read_Units_from_memory();   //Zustands Transaktion von geschlossen nach geoffnet
 353  00c0 cd033f        	call	L74_Read_Units_from_memory
 355  00c3 2012          	jra	L541
 356  00c5               L741:
 357                     ; 219 							clearLCD();
 359  00c5 cd0000        	call	_clearLCD
 361                     ; 220 							User_DisplayMessage ("ONLY 4 CHARACTERS ENTER PIN AGAIN", 30);
 363  00c8 4b1e          	push	#30
 364  00ca ae004a        	ldw	x,#L561
 365  00cd cd075d        	call	L72_User_DisplayMessage
 367  00d0 84            	pop	a
 368                     ; 221 							delayLFO_ms (2);
 370  00d1 ae0002        	ldw	x,#2
 371  00d4 cd0000        	call	_delayLFO_ms
 373  00d7               L541:
 374                     ; 225 				delayLFO_ms (2);
 376  00d7 ae0002        	ldw	x,#2
 377  00da cd0000        	call	_delayLFO_ms
 379                     ; 227 			break;
 381  00dd ac420042      	jpf	L531
 382  00e1               L17:
 383                     ; 229 			case STATE_TEMPMEAS:
 383                     ; 230 						
 383                     ; 231 				// read the ambiant tempserature from the STTS751
 383                     ; 232 				User_GetOneTemperature (&data_sensor);
 385  00e1 96            	ldw	x,sp
 386  00e2 1c0004        	addw	x,#OFST+0
 387  00e5 ad12          	call	L33_User_GetOneTemperature
 389                     ; 234 				User_DisplayOneTemperature (data_sensor);
 391  00e7 7b04          	ld	a,(OFST+0,sp)
 392  00e9 ad40          	call	L53_User_DisplayOneTemperature
 394                     ; 236 				delayLFO_ms (2);
 396  00eb ae0002        	ldw	x,#2
 397  00ee cd0000        	call	_delayLFO_ms
 399                     ; 238 			break;
 401  00f1 ac420042      	jpf	L531
 402  00f5               L341:
 403                     ; 245 			break;
 404  00f5 ac420042      	jpf	L531
 454                     ; 257 static void User_GetOneTemperature (uint8_t *data_sensor)
 454                     ; 258 {
 455                     	switch	.text
 456  00f9               L33_User_GetOneTemperature:
 458  00f9 89            	pushw	x
 459  00fa 88            	push	a
 460       00000001      OFST:	set	1
 463                     ; 259 	uint8_t 	Pointer_temperature = 0x00;					// temperature access 
 465  00fb 0f01          	clr	(OFST+0,sp)
 466                     ; 261 	data_sensor[0] = 0x00;
 468  00fd 7f            	clr	(x)
 469                     ; 263 	I2C_SS_Init();
 471  00fe cd0000        	call	_I2C_SS_Init
 473                     ; 264 	I2C_SS_Config(STTS751_STOP);
 475  0101 ae0340        	ldw	x,#832
 476  0104 cd0000        	call	_I2C_SS_Config
 478                     ; 266 	delayLFO_ms (1);
 480  0107 ae0001        	ldw	x,#1
 481  010a cd0000        	call	_delayLFO_ms
 483                     ; 267 	I2C_SS_Config(STTS751_ONESHOTMODE);
 485  010d ae0f00        	ldw	x,#3840
 486  0110 cd0000        	call	_I2C_SS_Config
 488                     ; 269 	delayLFO_ms (1);
 490  0113 ae0001        	ldw	x,#1
 491  0116 cd0000        	call	_delayLFO_ms
 493                     ; 271 	I2C_SS_ReadOneByte(data_sensor,Pointer_temperature);
 495  0119 7b01          	ld	a,(OFST+0,sp)
 496  011b 88            	push	a
 497  011c 1e03          	ldw	x,(OFST+2,sp)
 498  011e cd0000        	call	_I2C_SS_ReadOneByte
 500  0121 84            	pop	a
 501                     ; 273 	delayLFO_ms (1);
 503  0122 ae0001        	ldw	x,#1
 504  0125 cd0000        	call	_delayLFO_ms
 506                     ; 275 }
 509  0128 5b03          	addw	sp,#3
 510  012a 81            	ret
 556                     ; 282 static void User_DisplayOneTemperature (uint8_t data_sensor)
 556                     ; 283 {
 557                     	switch	.text
 558  012b               L53_User_DisplayOneTemperature:
 560  012b 88            	push	a
 561  012c 520c          	subw	sp,#12
 562       0000000c      OFST:	set	12
 565                     ; 285 	TempChar16[5] = 'C';
 567  012e ae0043        	ldw	x,#67
 568  0131 1f0b          	ldw	(OFST-1,sp),x
 569                     ; 286 	TempChar16[4] = ' ';
 571  0133 ae0020        	ldw	x,#32
 572  0136 1f09          	ldw	(OFST-3,sp),x
 573                     ; 288 	if ((data_sensor & 0x80) != 0)
 575  0138 a580          	bcp	a,#128
 576  013a 270d          	jreq	L532
 577                     ; 290 		data_sensor = (~data_sensor) +1;
 579  013c 7b0d          	ld	a,(OFST+1,sp)
 580  013e 43            	cpl	a
 581  013f 4c            	inc	a
 582  0140 6b0d          	ld	(OFST+1,sp),a
 583                     ; 291 		TempChar16[1] = '-';
 585  0142 ae002d        	ldw	x,#45
 586  0145 1f03          	ldw	(OFST-9,sp),x
 588  0147 2005          	jra	L732
 589  0149               L532:
 590                     ; 294 		TempChar16[1] = ' ';							
 592  0149 ae0020        	ldw	x,#32
 593  014c 1f03          	ldw	(OFST-9,sp),x
 594  014e               L732:
 595                     ; 296 	TempChar16[3] = (data_sensor %10) + 0x30 ;
 597  014e 7b0d          	ld	a,(OFST+1,sp)
 598  0150 5f            	clrw	x
 599  0151 97            	ld	xl,a
 600  0152 a60a          	ld	a,#10
 601  0154 cd0000        	call	c_smodx
 603  0157 1c0030        	addw	x,#48
 604  015a 1f07          	ldw	(OFST-5,sp),x
 605                     ; 297 	TempChar16[2] = (data_sensor /10) + 0x30;
 607  015c 7b0d          	ld	a,(OFST+1,sp)
 608  015e 5f            	clrw	x
 609  015f 97            	ld	xl,a
 610  0160 a60a          	ld	a,#10
 611  0162 cd0000        	call	c_sdivx
 613  0165 1c0030        	addw	x,#48
 614  0168 1f05          	ldw	(OFST-7,sp),x
 615                     ; 298 	TempChar16[0] = ' ';
 617  016a ae0020        	ldw	x,#32
 618  016d 1f01          	ldw	(OFST-11,sp),x
 619                     ; 299 	LCD_GLASS_DisplayStrDeci(TempChar16);		
 621  016f 96            	ldw	x,sp
 622  0170 1c0001        	addw	x,#OFST-11
 623  0173 cd0000        	call	_LCD_GLASS_DisplayStrDeci
 625                     ; 300 }
 628  0176 5b0d          	addw	sp,#13
 629  0178 81            	ret
 694                     ; 308 static int8_t User_ReadNDEFMessage ( uint8_t *PayloadLength )			
 694                     ; 309 {
 695                     	switch	.text
 696  0179               L52_User_ReadNDEFMessage:
 698  0179 89            	pushw	x
 699  017a 89            	pushw	x
 700       00000002      OFST:	set	2
 703                     ; 310 uint8_t NthAttempt=0, 
 705                     ; 311 				NbAttempt = 2;
 707  017b a602          	ld	a,#2
 708  017d 6b01          	ld	(OFST-1,sp),a
 709                     ; 314 	*PayloadLength = 0;
 711  017f 7f            	clr	(x)
 712                     ; 316 	for (NthAttempt = 0; NthAttempt < NbAttempt ; NthAttempt++)
 714  0180 0f02          	clr	(OFST+0,sp)
 716  0182 2071          	jra	L372
 717  0184               L762:
 718                     ; 318 		M24LR04E_Init();
 720  0184 cd0000        	call	_M24LR04E_Init
 722                     ; 320 		if (User_CheckNDEFMessage() == SUCCESS)
 724  0187 cd080c        	call	L11_User_CheckNDEFMessage
 726  018a a101          	cp	a,#1
 727  018c 2659          	jrne	L772
 728                     ; 322 			User_GetPayloadLength(PayloadLength);
 730  018e 1e03          	ldw	x,(OFST+1,sp)
 731  0190 cd0843        	call	L7_User_GetPayloadLength
 733                     ; 324 			CodeLength = *PayloadLength;					// Länge der NDEF Message Bestimmen.
 735  0193 1e03          	ldw	x,(OFST+1,sp)
 736  0195 f6            	ld	a,(x)
 737  0196 5f            	clrw	x
 738  0197 97            	ld	xl,a
 739  0198 bf49          	ldw	L36_CodeLength,x
 740                     ; 325 			CodeLength -=3;												//
 742  019a be49          	ldw	x,L36_CodeLength
 743  019c 1d0003        	subw	x,#3
 744  019f bf49          	ldw	L36_CodeLength,x
 745                     ; 327 			if (PayloadLength !=0x00)
 747  01a1 1e03          	ldw	x,(OFST+1,sp)
 748  01a3 2742          	jreq	L772
 749                     ; 329 				(*PayloadLength) -=2;
 751  01a5 1e03          	ldw	x,(OFST+1,sp)
 752  01a7 7a            	dec	(x)
 753  01a8 7a            	dec	(x)
 754                     ; 331 				InitializeBuffer (NDEFmessage,(*PayloadLength)+10);
 756  01a9 1e03          	ldw	x,(OFST+1,sp)
 757  01ab f6            	ld	a,(x)
 758  01ac ab0a          	add	a,#10
 759  01ae 88            	push	a
 760  01af ae0009        	ldw	x,#_NDEFmessage
 761  01b2 cd09f0        	call	L32_InitializeBuffer
 763  01b5 84            	pop	a
 764                     ; 332 				User_GetNDEFMessage(*PayloadLength,NDEFmessage);
 766  01b6 ae0009        	ldw	x,#_NDEFmessage
 767  01b9 89            	pushw	x
 768  01ba 1e05          	ldw	x,(OFST+3,sp)
 769  01bc f6            	ld	a,(x)
 770  01bd cd085f        	call	L31_User_GetNDEFMessage
 772  01c0 85            	popw	x
 773                     ; 333 				I2C_Cmd(M24LR04E_I2C, DISABLE);			
 775  01c1 4b00          	push	#0
 776  01c3 ae5210        	ldw	x,#21008
 777  01c6 cd0000        	call	_I2C_Cmd
 779  01c9 84            	pop	a
 780                     ; 335 				CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
 782  01ca ae0300        	ldw	x,#768
 783  01cd cd0000        	call	_CLK_PeripheralClockConfig
 785                     ; 337 				GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
 787  01d0 7212500a      	bset	20490,#1
 788                     ; 338 				GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
 790  01d4 7210500a      	bset	20490,#0
 791                     ; 340 				ToUpperCase (*PayloadLength,NDEFmessage);
 793  01d8 ae0009        	ldw	x,#_NDEFmessage
 794  01db 89            	pushw	x
 795  01dc 1e05          	ldw	x,(OFST+3,sp)
 796  01de f6            	ld	a,(x)
 797  01df cd088e        	call	L51_ToUpperCase
 799  01e2 85            	popw	x
 800                     ; 342 				return SUCCESS;
 802  01e3 a601          	ld	a,#1
 804  01e5 2015          	jra	L61
 805  01e7               L772:
 806                     ; 346 		M24LR04E_DeInit();
 808  01e7 cd0000        	call	_M24LR04E_DeInit
 810                     ; 347 		I2C_Cmd(M24LR04E_I2C, DISABLE);
 812  01ea 4b00          	push	#0
 813  01ec ae5210        	ldw	x,#21008
 814  01ef cd0000        	call	_I2C_Cmd
 816  01f2 84            	pop	a
 817                     ; 316 	for (NthAttempt = 0; NthAttempt < NbAttempt ; NthAttempt++)
 819  01f3 0c02          	inc	(OFST+0,sp)
 820  01f5               L372:
 823  01f5 7b02          	ld	a,(OFST+0,sp)
 824  01f7 1101          	cp	a,(OFST-1,sp)
 825  01f9 2589          	jrult	L762
 826                     ; 350 	return ERROR;
 828  01fb 4f            	clr	a
 830  01fc               L61:
 832  01fc 5b04          	addw	sp,#4
 833  01fe 81            	ret
 857                     ; 366 static uint8_t Check_Code_Length(void)
 857                     ; 367 {
 858                     	switch	.text
 859  01ff               L55_Check_Code_Length:
 863                     ; 368 	if(CodeLength == 0x05)
 865  01ff be49          	ldw	x,L36_CodeLength
 866  0201 a30005        	cpw	x,#5
 867  0204 2603          	jrne	L313
 868                     ; 370 		return SUCCESS;
 870  0206 a601          	ld	a,#1
 873  0208 81            	ret
 874  0209               L313:
 875                     ; 372 	else return ERROR;
 877  0209 4f            	clr	a
 880  020a 81            	ret
 991                     ; 376 static void OverwriteAll_CODE_EEPROM(void)
 991                     ; 377 {
 992                     	switch	.text
 993  020b               L16_OverwriteAll_CODE_EEPROM:
 995  020b 5210          	subw	sp,#16
 996       00000010      OFST:	set	16
 999                     ; 379 	uint8_t *OneByteMemory2 = EE_Buffer_2;
1001  020d ae0003        	ldw	x,#_EE_Buffer_2
1002  0210 1f01          	ldw	(OFST-15,sp),x
1003                     ; 380 	uint8_t *OneByteMemory3 = EE_Buffer_3;
1005  0212 ae0004        	ldw	x,#_EE_Buffer_3
1006  0215 1f03          	ldw	(OFST-13,sp),x
1007                     ; 381 	uint8_t *OneByteMemory4 = EE_Buffer_4;
1009  0217 ae0005        	ldw	x,#_EE_Buffer_4
1010  021a 1f05          	ldw	(OFST-11,sp),x
1011                     ; 382 	uint8_t *OneByteMemory5 = EE_Buffer_5;
1013  021c ae0006        	ldw	x,#_EE_Buffer_5
1014  021f 1f07          	ldw	(OFST-9,sp),x
1015                     ; 384 	uint16_t ReadAddr_Byte2 = 0x000E;
1017  0221 ae000e        	ldw	x,#14
1018  0224 1f09          	ldw	(OFST-7,sp),x
1019                     ; 385 	uint16_t ReadAddr_Byte3 = 0x000F;
1021  0226 ae000f        	ldw	x,#15
1022  0229 1f0b          	ldw	(OFST-5,sp),x
1023                     ; 386 	uint16_t ReadAddr_Byte4 = 0x0010;
1025  022b ae0010        	ldw	x,#16
1026  022e 1f0d          	ldw	(OFST-3,sp),x
1027                     ; 387 	uint16_t ReadAddr_Byte5 = 0x0011;
1029  0230 ae0011        	ldw	x,#17
1030  0233 1f0f          	ldw	(OFST-1,sp),x
1031                     ; 391 		M24LR04E_Init();
1033  0235 cd0000        	call	_M24LR04E_Init
1035                     ; 392 		M24LR04E_WriteOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte2, (uint8_t)( 0x20 ) );	
1037  0238 4b20          	push	#32
1038  023a 1e0a          	ldw	x,(OFST-6,sp)
1039  023c 89            	pushw	x
1040  023d a6a6          	ld	a,#166
1041  023f cd0000        	call	_M24LR04E_WriteOneByte
1043  0242 5b03          	addw	sp,#3
1044                     ; 394 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
1046  0244 4b00          	push	#0
1047  0246 ae5210        	ldw	x,#21008
1048  0249 cd0000        	call	_I2C_Cmd
1050  024c 84            	pop	a
1051                     ; 395 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
1053  024d ae0300        	ldw	x,#768
1054  0250 cd0000        	call	_CLK_PeripheralClockConfig
1056                     ; 396 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
1058  0253 7212500a      	bset	20490,#1
1059                     ; 397 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
1061  0257 7210500a      	bset	20490,#0
1062                     ; 400 		delayLFO_ms (1);
1064  025b ae0001        	ldw	x,#1
1065  025e cd0000        	call	_delayLFO_ms
1067                     ; 403 		M24LR04E_Init();
1069  0261 cd0000        	call	_M24LR04E_Init
1071                     ; 404 		M24LR04E_WriteOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte3, (uint8_t)( 0x20 ) );	
1073  0264 4b20          	push	#32
1074  0266 1e0c          	ldw	x,(OFST-4,sp)
1075  0268 89            	pushw	x
1076  0269 a6a6          	ld	a,#166
1077  026b cd0000        	call	_M24LR04E_WriteOneByte
1079  026e 5b03          	addw	sp,#3
1080                     ; 406 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
1082  0270 4b00          	push	#0
1083  0272 ae5210        	ldw	x,#21008
1084  0275 cd0000        	call	_I2C_Cmd
1086  0278 84            	pop	a
1087                     ; 407 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
1089  0279 ae0300        	ldw	x,#768
1090  027c cd0000        	call	_CLK_PeripheralClockConfig
1092                     ; 408 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
1094  027f 7212500a      	bset	20490,#1
1095                     ; 409 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
1097  0283 7210500a      	bset	20490,#0
1098                     ; 411 		delayLFO_ms (1);
1100  0287 ae0001        	ldw	x,#1
1101  028a cd0000        	call	_delayLFO_ms
1103                     ; 414 		M24LR04E_Init();
1105  028d cd0000        	call	_M24LR04E_Init
1107                     ; 415 		M24LR04E_WriteOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte4, (uint8_t)( 0x20 ) );	
1109  0290 4b20          	push	#32
1110  0292 1e0e          	ldw	x,(OFST-2,sp)
1111  0294 89            	pushw	x
1112  0295 a6a6          	ld	a,#166
1113  0297 cd0000        	call	_M24LR04E_WriteOneByte
1115  029a 5b03          	addw	sp,#3
1116                     ; 417 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
1118  029c 4b00          	push	#0
1119  029e ae5210        	ldw	x,#21008
1120  02a1 cd0000        	call	_I2C_Cmd
1122  02a4 84            	pop	a
1123                     ; 418 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
1125  02a5 ae0300        	ldw	x,#768
1126  02a8 cd0000        	call	_CLK_PeripheralClockConfig
1128                     ; 419 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
1130  02ab 7212500a      	bset	20490,#1
1131                     ; 420 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
1133  02af 7210500a      	bset	20490,#0
1134                     ; 423 		delayLFO_ms (1);
1136  02b3 ae0001        	ldw	x,#1
1137  02b6 cd0000        	call	_delayLFO_ms
1139                     ; 425 		M24LR04E_Init();
1141  02b9 cd0000        	call	_M24LR04E_Init
1143                     ; 426 		M24LR04E_WriteOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte5, (uint8_t)( 0x20 ) );	
1145  02bc 4b20          	push	#32
1146  02be 1e10          	ldw	x,(OFST+0,sp)
1147  02c0 89            	pushw	x
1148  02c1 a6a6          	ld	a,#166
1149  02c3 cd0000        	call	_M24LR04E_WriteOneByte
1151  02c6 5b03          	addw	sp,#3
1152                     ; 428 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
1154  02c8 4b00          	push	#0
1155  02ca ae5210        	ldw	x,#21008
1156  02cd cd0000        	call	_I2C_Cmd
1158  02d0 84            	pop	a
1159                     ; 429 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
1161  02d1 ae0300        	ldw	x,#768
1162  02d4 cd0000        	call	_CLK_PeripheralClockConfig
1164                     ; 430 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
1166  02d7 7212500a      	bset	20490,#1
1167                     ; 431 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
1169  02db 7210500a      	bset	20490,#0
1170                     ; 434 }
1173  02df 5b10          	addw	sp,#16
1174  02e1 81            	ret
1304                     ; 436 static void Overwrite_dollar_EEPROM(void)
1304                     ; 437 {
1305                     	switch	.text
1306  02e2               L75_Overwrite_dollar_EEPROM:
1308  02e2 5214          	subw	sp,#20
1309       00000014      OFST:	set	20
1312                     ; 438 	uint8_t *OneByteMemory1 = EE_Buffer_1;
1314  02e4 ae0002        	ldw	x,#_EE_Buffer_1
1315  02e7 1f01          	ldw	(OFST-19,sp),x
1316                     ; 439 	uint8_t *OneByteMemory2 = EE_Buffer_2;
1318  02e9 ae0003        	ldw	x,#_EE_Buffer_2
1319  02ec 1f03          	ldw	(OFST-17,sp),x
1320                     ; 440 	uint8_t *OneByteMemory3 = EE_Buffer_3;
1322  02ee ae0004        	ldw	x,#_EE_Buffer_3
1323  02f1 1f05          	ldw	(OFST-15,sp),x
1324                     ; 441 	uint8_t *OneByteMemory4 = EE_Buffer_4;
1326  02f3 ae0005        	ldw	x,#_EE_Buffer_4
1327  02f6 1f07          	ldw	(OFST-13,sp),x
1328                     ; 442 	uint8_t *OneByteMemory5 = EE_Buffer_5;
1330  02f8 ae0006        	ldw	x,#_EE_Buffer_5
1331  02fb 1f09          	ldw	(OFST-11,sp),x
1332                     ; 444 	uint16_t ReadAddr_Byte1 = 0x000D;
1334  02fd ae000d        	ldw	x,#13
1335  0300 1f13          	ldw	(OFST-1,sp),x
1336                     ; 445 	uint16_t ReadAddr_Byte2 = 0x000E;
1338  0302 ae000e        	ldw	x,#14
1339  0305 1f0b          	ldw	(OFST-9,sp),x
1340                     ; 446 	uint16_t ReadAddr_Byte3 = 0x000F;
1342  0307 ae000f        	ldw	x,#15
1343  030a 1f0d          	ldw	(OFST-7,sp),x
1344                     ; 447 	uint16_t ReadAddr_Byte4 = 0x0010;
1346  030c ae0010        	ldw	x,#16
1347  030f 1f0f          	ldw	(OFST-5,sp),x
1348                     ; 448 	uint16_t ReadAddr_Byte5 = 0x0011;
1350  0311 ae0011        	ldw	x,#17
1351  0314 1f11          	ldw	(OFST-3,sp),x
1352                     ; 452 		M24LR04E_Init();
1354  0316 cd0000        	call	_M24LR04E_Init
1356                     ; 453 		M24LR04E_WriteOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte1, (uint8_t)( 0x20 ) );	
1358  0319 4b20          	push	#32
1359  031b 1e14          	ldw	x,(OFST+0,sp)
1360  031d 89            	pushw	x
1361  031e a6a6          	ld	a,#166
1362  0320 cd0000        	call	_M24LR04E_WriteOneByte
1364  0323 5b03          	addw	sp,#3
1365                     ; 455 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
1367  0325 4b00          	push	#0
1368  0327 ae5210        	ldw	x,#21008
1369  032a cd0000        	call	_I2C_Cmd
1371  032d 84            	pop	a
1372                     ; 456 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
1374  032e ae0300        	ldw	x,#768
1375  0331 cd0000        	call	_CLK_PeripheralClockConfig
1377                     ; 457 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
1379  0334 7212500a      	bset	20490,#1
1380                     ; 458 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
1382  0338 7210500a      	bset	20490,#0
1383                     ; 460 }
1386  033c 5b14          	addw	sp,#20
1387  033e 81            	ret
1522                     ; 464 static void Read_Units_from_memory(void)
1522                     ; 465 {
1523                     	switch	.text
1524  033f               L74_Read_Units_from_memory:
1526  033f 5214          	subw	sp,#20
1527       00000014      OFST:	set	20
1530                     ; 466 	uint8_t *OneByteMemory1 = EE_Buffer_1;
1532  0341 ae0002        	ldw	x,#_EE_Buffer_1
1533  0344 1f11          	ldw	(OFST-3,sp),x
1534                     ; 467 	uint8_t *OneByteMemory2 = EE_Buffer_2;
1536  0346 ae0003        	ldw	x,#_EE_Buffer_2
1537  0349 1f01          	ldw	(OFST-19,sp),x
1538                     ; 468 	uint8_t *OneByteMemory3 = EE_Buffer_3;
1540  034b ae0004        	ldw	x,#_EE_Buffer_3
1541  034e 1f03          	ldw	(OFST-17,sp),x
1542                     ; 469 	uint8_t *OneByteMemory4 = EE_Buffer_4;
1544  0350 ae0005        	ldw	x,#_EE_Buffer_4
1545  0353 1f05          	ldw	(OFST-15,sp),x
1546                     ; 470 	uint8_t *OneByteMemory5 = EE_Buffer_5;
1548  0355 ae0006        	ldw	x,#_EE_Buffer_5
1549  0358 1f07          	ldw	(OFST-13,sp),x
1550                     ; 472 	uint16_t ReadAddr_Byte1 = 0x000D;
1552  035a ae000d        	ldw	x,#13
1553  035d 1f13          	ldw	(OFST-1,sp),x
1554                     ; 473 	uint16_t ReadAddr_Byte2 = 0x000E;
1556  035f ae000e        	ldw	x,#14
1557  0362 1f09          	ldw	(OFST-11,sp),x
1558                     ; 474 	uint16_t ReadAddr_Byte3 = 0x000F;
1560  0364 ae000f        	ldw	x,#15
1561  0367 1f0b          	ldw	(OFST-9,sp),x
1562                     ; 475 	uint16_t ReadAddr_Byte4 = 0x0010;
1564  0369 ae0010        	ldw	x,#16
1565  036c 1f0d          	ldw	(OFST-7,sp),x
1566                     ; 476 	uint16_t ReadAddr_Byte5 = 0x0011;
1568  036e ae0011        	ldw	x,#17
1569  0371 1f0f          	ldw	(OFST-5,sp),x
1570                     ; 480 	M24LR04E_Init();
1572  0373 cd0000        	call	_M24LR04E_Init
1574                     ; 482 	M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte1, OneByteMemory1);	
1576  0376 1e11          	ldw	x,(OFST-3,sp)
1577  0378 89            	pushw	x
1578  0379 1e15          	ldw	x,(OFST+1,sp)
1579  037b 89            	pushw	x
1580  037c a6a6          	ld	a,#166
1581  037e cd0000        	call	_M24LR04E_ReadOneByte
1583  0381 5b04          	addw	sp,#4
1584                     ; 485 	I2C_Cmd(M24LR04E_I2C, DISABLE);		
1586  0383 4b00          	push	#0
1587  0385 ae5210        	ldw	x,#21008
1588  0388 cd0000        	call	_I2C_Cmd
1590  038b 84            	pop	a
1591                     ; 486 	CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
1593  038c ae0300        	ldw	x,#768
1594  038f cd0000        	call	_CLK_PeripheralClockConfig
1596                     ; 487 	GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
1598  0392 7212500a      	bset	20490,#1
1599                     ; 488 	GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
1601  0396 7210500a      	bset	20490,#0
1602                     ; 490 	EE_Buffer_1[0] = EE_Buffer_1[0];
1604  039a c60002        	ld	a,_EE_Buffer_1
1605                     ; 492 	if ( EE_Buffer_1[0] == '$')
1607  039d c60002        	ld	a,_EE_Buffer_1
1608  03a0 a124          	cp	a,#36
1609  03a2 2703          	jreq	L03
1610  03a4 cc0492        	jp	L535
1611  03a7               L03:
1612                     ; 496 		Overwrite_dollar_EEPROM();
1614  03a7 cd02e2        	call	L75_Overwrite_dollar_EEPROM
1616                     ; 498 		M24LR04E_Init();
1618  03aa cd0000        	call	_M24LR04E_Init
1620                     ; 500 		M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte1, OneByteMemory1);
1622  03ad 1e11          	ldw	x,(OFST-3,sp)
1623  03af 89            	pushw	x
1624  03b0 1e15          	ldw	x,(OFST+1,sp)
1625  03b2 89            	pushw	x
1626  03b3 a6a6          	ld	a,#166
1627  03b5 cd0000        	call	_M24LR04E_ReadOneByte
1629  03b8 5b04          	addw	sp,#4
1630                     ; 502 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
1632  03ba 4b00          	push	#0
1633  03bc ae5210        	ldw	x,#21008
1634  03bf cd0000        	call	_I2C_Cmd
1636  03c2 84            	pop	a
1637                     ; 503 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
1639  03c3 ae0300        	ldw	x,#768
1640  03c6 cd0000        	call	_CLK_PeripheralClockConfig
1642                     ; 504 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
1644  03c9 7212500a      	bset	20490,#1
1645                     ; 505 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
1647  03cd 7210500a      	bset	20490,#0
1648                     ; 507 		EE_Buffer_1[0] = EE_Buffer_1[0];
1650  03d1 c60002        	ld	a,_EE_Buffer_1
1651                     ; 511 		M24LR04E_Init();
1653  03d4 cd0000        	call	_M24LR04E_Init
1655                     ; 513 		M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte2, OneByteMemory2);	
1657  03d7 1e01          	ldw	x,(OFST-19,sp)
1658  03d9 89            	pushw	x
1659  03da 1e0b          	ldw	x,(OFST-9,sp)
1660  03dc 89            	pushw	x
1661  03dd a6a6          	ld	a,#166
1662  03df cd0000        	call	_M24LR04E_ReadOneByte
1664  03e2 5b04          	addw	sp,#4
1665                     ; 515 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
1667  03e4 4b00          	push	#0
1668  03e6 ae5210        	ldw	x,#21008
1669  03e9 cd0000        	call	_I2C_Cmd
1671  03ec 84            	pop	a
1672                     ; 516 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
1674  03ed ae0300        	ldw	x,#768
1675  03f0 cd0000        	call	_CLK_PeripheralClockConfig
1677                     ; 517 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
1679  03f3 7212500a      	bset	20490,#1
1680                     ; 518 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
1682  03f7 7210500a      	bset	20490,#0
1683                     ; 520 		EE_Buffer_2[0] = EE_Buffer_2[0];
1685  03fb c60003        	ld	a,_EE_Buffer_2
1686                     ; 522 		setLED(1);	// turn LED on
1688  03fe a601          	ld	a,#1
1689  0400 cd0000        	call	_setLED
1691                     ; 525 		M24LR04E_Init();
1693  0403 cd0000        	call	_M24LR04E_Init
1695                     ; 527 		M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte3, OneByteMemory3);	
1697  0406 1e03          	ldw	x,(OFST-17,sp)
1698  0408 89            	pushw	x
1699  0409 1e0d          	ldw	x,(OFST-7,sp)
1700  040b 89            	pushw	x
1701  040c a6a6          	ld	a,#166
1702  040e cd0000        	call	_M24LR04E_ReadOneByte
1704  0411 5b04          	addw	sp,#4
1705                     ; 529 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
1707  0413 4b00          	push	#0
1708  0415 ae5210        	ldw	x,#21008
1709  0418 cd0000        	call	_I2C_Cmd
1711  041b 84            	pop	a
1712                     ; 530 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
1714  041c ae0300        	ldw	x,#768
1715  041f cd0000        	call	_CLK_PeripheralClockConfig
1717                     ; 531 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
1719  0422 7212500a      	bset	20490,#1
1720                     ; 532 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
1722  0426 7210500a      	bset	20490,#0
1723                     ; 535 		EE_Buffer_3[0] = EE_Buffer_3[0];		
1725  042a c60004        	ld	a,_EE_Buffer_3
1726                     ; 538 		M24LR04E_Init();
1728  042d cd0000        	call	_M24LR04E_Init
1730                     ; 539 		M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte4, OneByteMemory4);	
1732  0430 1e05          	ldw	x,(OFST-15,sp)
1733  0432 89            	pushw	x
1734  0433 1e0f          	ldw	x,(OFST-5,sp)
1735  0435 89            	pushw	x
1736  0436 a6a6          	ld	a,#166
1737  0438 cd0000        	call	_M24LR04E_ReadOneByte
1739  043b 5b04          	addw	sp,#4
1740                     ; 541 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
1742  043d 4b00          	push	#0
1743  043f ae5210        	ldw	x,#21008
1744  0442 cd0000        	call	_I2C_Cmd
1746  0445 84            	pop	a
1747                     ; 542 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
1749  0446 ae0300        	ldw	x,#768
1750  0449 cd0000        	call	_CLK_PeripheralClockConfig
1752                     ; 543 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
1754  044c 7212500a      	bset	20490,#1
1755                     ; 544 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
1757  0450 7210500a      	bset	20490,#0
1758                     ; 547 		EE_Buffer_4[0] = EE_Buffer_4[0];
1760  0454 c60005        	ld	a,_EE_Buffer_4
1761                     ; 550 		M24LR04E_Init();
1763  0457 cd0000        	call	_M24LR04E_Init
1765                     ; 551 		M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte5, OneByteMemory5);	
1767  045a 1e07          	ldw	x,(OFST-13,sp)
1768  045c 89            	pushw	x
1769  045d 1e11          	ldw	x,(OFST-3,sp)
1770  045f 89            	pushw	x
1771  0460 a6a6          	ld	a,#166
1772  0462 cd0000        	call	_M24LR04E_ReadOneByte
1774  0465 5b04          	addw	sp,#4
1775                     ; 553 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
1777  0467 4b00          	push	#0
1778  0469 ae5210        	ldw	x,#21008
1779  046c cd0000        	call	_I2C_Cmd
1781  046f 84            	pop	a
1782                     ; 554 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
1784  0470 ae0300        	ldw	x,#768
1785  0473 cd0000        	call	_CLK_PeripheralClockConfig
1787                     ; 555 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
1789  0476 7212500a      	bset	20490,#1
1790                     ; 556 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
1792  047a 7210500a      	bset	20490,#0
1793                     ; 559 		EE_Buffer_5[0] = EE_Buffer_5[0];
1795  047e c60006        	ld	a,_EE_Buffer_5
1796                     ; 563 		if ( Check_PID_Buffer_Equal() == SUCCESS ) 
1798  0481 cd0604        	call	L34_Check_PID_Buffer_Equal
1800  0484 a101          	cp	a,#1
1801  0486 260a          	jrne	L535
1802                     ; 565 				EE_Buf_Flag[0] = 0x00;
1804  0488 4f            	clr	a
1805  0489 ae0001        	ldw	x,#_EE_Buf_Flag
1806  048c cd0000        	call	c_eewrc
1808                     ; 566 				OverwriteAll_CODE_EEPROM();
1810  048f cd020b        	call	L16_OverwriteAll_CODE_EEPROM
1813  0492               L535:
1814                     ; 574 }
1817  0492 5b14          	addw	sp,#20
1818  0494 81            	ret
1955                     ; 579 static void Copy_Units_in_other_memory(void)
1955                     ; 580 {
1956                     	switch	.text
1957  0495               L14_Copy_Units_in_other_memory:
1959  0495 5214          	subw	sp,#20
1960       00000014      OFST:	set	20
1963                     ; 581 	uint8_t *OneByteMemory1 = EE_Buffer_1;
1965  0497 ae0002        	ldw	x,#_EE_Buffer_1
1966  049a 1f11          	ldw	(OFST-3,sp),x
1967                     ; 582 	uint8_t *OneByteMemory2 = EE_Buffer_2;
1969  049c ae0003        	ldw	x,#_EE_Buffer_2
1970  049f 1f01          	ldw	(OFST-19,sp),x
1971                     ; 583 	uint8_t *OneByteMemory3 = EE_Buffer_3;
1973  04a1 ae0004        	ldw	x,#_EE_Buffer_3
1974  04a4 1f03          	ldw	(OFST-17,sp),x
1975                     ; 584 	uint8_t *OneByteMemory4 = EE_Buffer_4;
1977  04a6 ae0005        	ldw	x,#_EE_Buffer_4
1978  04a9 1f05          	ldw	(OFST-15,sp),x
1979                     ; 585 	uint8_t *OneByteMemory5 = EE_Buffer_5;
1981  04ab ae0006        	ldw	x,#_EE_Buffer_5
1982  04ae 1f07          	ldw	(OFST-13,sp),x
1983                     ; 587 	uint16_t ReadAddr_Byte1 = 0x000D;
1985  04b0 ae000d        	ldw	x,#13
1986  04b3 1f13          	ldw	(OFST-1,sp),x
1987                     ; 588 	uint16_t ReadAddr_Byte2 = 0x000E;
1989  04b5 ae000e        	ldw	x,#14
1990  04b8 1f09          	ldw	(OFST-11,sp),x
1991                     ; 589 	uint16_t ReadAddr_Byte3 = 0x000F;
1993  04ba ae000f        	ldw	x,#15
1994  04bd 1f0b          	ldw	(OFST-9,sp),x
1995                     ; 590 	uint16_t ReadAddr_Byte4 = 0x0010;
1997  04bf ae0010        	ldw	x,#16
1998  04c2 1f0d          	ldw	(OFST-7,sp),x
1999                     ; 591 	uint16_t ReadAddr_Byte5 = 0x0011;
2001  04c4 ae0011        	ldw	x,#17
2002  04c7 1f0f          	ldw	(OFST-5,sp),x
2003                     ; 594 	M24LR04E_Init();
2005  04c9 cd0000        	call	_M24LR04E_Init
2007                     ; 596 	M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte1, OneByteMemory1);
2009  04cc 1e11          	ldw	x,(OFST-3,sp)
2010  04ce 89            	pushw	x
2011  04cf 1e15          	ldw	x,(OFST+1,sp)
2012  04d1 89            	pushw	x
2013  04d2 a6a6          	ld	a,#166
2014  04d4 cd0000        	call	_M24LR04E_ReadOneByte
2016  04d7 5b04          	addw	sp,#4
2017                     ; 598 	I2C_Cmd(M24LR04E_I2C, DISABLE);		
2019  04d9 4b00          	push	#0
2020  04db ae5210        	ldw	x,#21008
2021  04de cd0000        	call	_I2C_Cmd
2023  04e1 84            	pop	a
2024                     ; 599 	CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
2026  04e2 ae0300        	ldw	x,#768
2027  04e5 cd0000        	call	_CLK_PeripheralClockConfig
2029                     ; 600 	GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
2031  04e8 7212500a      	bset	20490,#1
2032                     ; 601 	GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
2034  04ec 7210500a      	bset	20490,#0
2035                     ; 603 	EE_Buffer_1[0] = EE_Buffer_1[0];
2037  04f0 c60002        	ld	a,_EE_Buffer_1
2038                     ; 605 if ( EE_Buffer_1[0] == '$')
2040  04f3 c60002        	ld	a,_EE_Buffer_1
2041  04f6 a124          	cp	a,#36
2042  04f8 2703          	jreq	L43
2043  04fa cc0601        	jp	L526
2044  04fd               L43:
2045                     ; 608 		Overwrite_dollar_EEPROM();
2047  04fd cd02e2        	call	L75_Overwrite_dollar_EEPROM
2049                     ; 610 		M24LR04E_Init();
2051  0500 cd0000        	call	_M24LR04E_Init
2053                     ; 612 		M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte1, OneByteMemory1);
2055  0503 1e11          	ldw	x,(OFST-3,sp)
2056  0505 89            	pushw	x
2057  0506 1e15          	ldw	x,(OFST+1,sp)
2058  0508 89            	pushw	x
2059  0509 a6a6          	ld	a,#166
2060  050b cd0000        	call	_M24LR04E_ReadOneByte
2062  050e 5b04          	addw	sp,#4
2063                     ; 614 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
2065  0510 4b00          	push	#0
2066  0512 ae5210        	ldw	x,#21008
2067  0515 cd0000        	call	_I2C_Cmd
2069  0518 84            	pop	a
2070                     ; 615 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
2072  0519 ae0300        	ldw	x,#768
2073  051c cd0000        	call	_CLK_PeripheralClockConfig
2075                     ; 616 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
2077  051f 7212500a      	bset	20490,#1
2078                     ; 617 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
2080  0523 7210500a      	bset	20490,#0
2081                     ; 619 		EE_Buffer_1[0] = EE_Buffer_1[0];
2083  0527 c60002        	ld	a,_EE_Buffer_1
2084                     ; 622 		M24LR04E_Init();
2086  052a cd0000        	call	_M24LR04E_Init
2088                     ; 624 		M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte2, OneByteMemory2);	
2090  052d 1e01          	ldw	x,(OFST-19,sp)
2091  052f 89            	pushw	x
2092  0530 1e0b          	ldw	x,(OFST-9,sp)
2093  0532 89            	pushw	x
2094  0533 a6a6          	ld	a,#166
2095  0535 cd0000        	call	_M24LR04E_ReadOneByte
2097  0538 5b04          	addw	sp,#4
2098                     ; 626 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
2100  053a 4b00          	push	#0
2101  053c ae5210        	ldw	x,#21008
2102  053f cd0000        	call	_I2C_Cmd
2104  0542 84            	pop	a
2105                     ; 627 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
2107  0543 ae0300        	ldw	x,#768
2108  0546 cd0000        	call	_CLK_PeripheralClockConfig
2110                     ; 628 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
2112  0549 7212500a      	bset	20490,#1
2113                     ; 629 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
2115  054d 7210500a      	bset	20490,#0
2116                     ; 631 		EE_Buffer_2[0] = EE_Buffer_2[0];
2118  0551 c60003        	ld	a,_EE_Buffer_2
2119                     ; 634 		M24LR04E_Init();
2121  0554 cd0000        	call	_M24LR04E_Init
2123                     ; 636 		M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte3, OneByteMemory3);	
2125  0557 1e03          	ldw	x,(OFST-17,sp)
2126  0559 89            	pushw	x
2127  055a 1e0d          	ldw	x,(OFST-7,sp)
2128  055c 89            	pushw	x
2129  055d a6a6          	ld	a,#166
2130  055f cd0000        	call	_M24LR04E_ReadOneByte
2132  0562 5b04          	addw	sp,#4
2133                     ; 638 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
2135  0564 4b00          	push	#0
2136  0566 ae5210        	ldw	x,#21008
2137  0569 cd0000        	call	_I2C_Cmd
2139  056c 84            	pop	a
2140                     ; 639 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
2142  056d ae0300        	ldw	x,#768
2143  0570 cd0000        	call	_CLK_PeripheralClockConfig
2145                     ; 640 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
2147  0573 7212500a      	bset	20490,#1
2148                     ; 641 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
2150  0577 7210500a      	bset	20490,#0
2151                     ; 643 		EE_Buffer_3[0] = EE_Buffer_3[0];
2153  057b c60004        	ld	a,_EE_Buffer_3
2154                     ; 647 		M24LR04E_Init();
2156  057e cd0000        	call	_M24LR04E_Init
2158                     ; 649 		M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte4, OneByteMemory4);	
2160  0581 1e05          	ldw	x,(OFST-15,sp)
2161  0583 89            	pushw	x
2162  0584 1e0f          	ldw	x,(OFST-5,sp)
2163  0586 89            	pushw	x
2164  0587 a6a6          	ld	a,#166
2165  0589 cd0000        	call	_M24LR04E_ReadOneByte
2167  058c 5b04          	addw	sp,#4
2168                     ; 651 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
2170  058e 4b00          	push	#0
2171  0590 ae5210        	ldw	x,#21008
2172  0593 cd0000        	call	_I2C_Cmd
2174  0596 84            	pop	a
2175                     ; 652 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
2177  0597 ae0300        	ldw	x,#768
2178  059a cd0000        	call	_CLK_PeripheralClockConfig
2180                     ; 653 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
2182  059d 7212500a      	bset	20490,#1
2183                     ; 654 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
2185  05a1 7210500a      	bset	20490,#0
2186                     ; 656 		EE_Buffer_4[0] = EE_Buffer_4[0];
2188  05a5 c60005        	ld	a,_EE_Buffer_4
2189                     ; 660 		M24LR04E_Init();
2191  05a8 cd0000        	call	_M24LR04E_Init
2193                     ; 662 		M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr_Byte5, OneByteMemory5);	
2195  05ab 1e07          	ldw	x,(OFST-13,sp)
2196  05ad 89            	pushw	x
2197  05ae 1e11          	ldw	x,(OFST-3,sp)
2198  05b0 89            	pushw	x
2199  05b1 a6a6          	ld	a,#166
2200  05b3 cd0000        	call	_M24LR04E_ReadOneByte
2202  05b6 5b04          	addw	sp,#4
2203                     ; 664 		I2C_Cmd(M24LR04E_I2C, DISABLE);		
2205  05b8 4b00          	push	#0
2206  05ba ae5210        	ldw	x,#21008
2207  05bd cd0000        	call	_I2C_Cmd
2209  05c0 84            	pop	a
2210                     ; 665 		CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
2212  05c1 ae0300        	ldw	x,#768
2213  05c4 cd0000        	call	_CLK_PeripheralClockConfig
2215                     ; 666 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
2217  05c7 7212500a      	bset	20490,#1
2218                     ; 667 		GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
2220  05cb 7210500a      	bset	20490,#0
2221                     ; 669 		EE_Buffer_5[0] = EE_Buffer_5[0];
2223  05cf c60006        	ld	a,_EE_Buffer_5
2224                     ; 672 		EE_Buffer_10[0] = EE_Buffer_5[0];
2226  05d2 c60006        	ld	a,_EE_Buffer_5
2227  05d5 ae000b        	ldw	x,#_EE_Buffer_10
2228  05d8 cd0000        	call	c_eewrc
2230                     ; 673 		EE_Buffer_9[0] = EE_Buffer_4[0];
2232  05db c60005        	ld	a,_EE_Buffer_4
2233  05de ae000a        	ldw	x,#_EE_Buffer_9
2234  05e1 cd0000        	call	c_eewrc
2236                     ; 674 		EE_Buffer_8[0] = EE_Buffer_3[0];
2238  05e4 c60004        	ld	a,_EE_Buffer_3
2239  05e7 ae0009        	ldw	x,#_EE_Buffer_8
2240  05ea cd0000        	call	c_eewrc
2242                     ; 675 		EE_Buffer_7[0] = EE_Buffer_2[0];
2244  05ed c60003        	ld	a,_EE_Buffer_2
2245  05f0 ae0008        	ldw	x,#_EE_Buffer_7
2246  05f3 cd0000        	call	c_eewrc
2248                     ; 681 		EE_Buf_Flag[0] = 0xFF;
2250  05f6 a6ff          	ld	a,#255
2251  05f8 ae0001        	ldw	x,#_EE_Buf_Flag
2252  05fb cd0000        	call	c_eewrc
2254                     ; 683 		OverwriteAll_CODE_EEPROM();
2256  05fe cd020b        	call	L16_OverwriteAll_CODE_EEPROM
2258  0601               L526:
2259                     ; 685 }
2262  0601 5b14          	addw	sp,#20
2263  0603 81            	ret
2298                     ; 690 static uint8_t Check_PID_Buffer_Equal(void)
2298                     ; 691 {
2299                     	switch	.text
2300  0604               L34_Check_PID_Buffer_Equal:
2304                     ; 692 		code2[0] = EE_Buffer_2[0];
2306  0604 5500030000    	mov	_code2,_EE_Buffer_2
2307                     ; 693 		code2[1] = EE_Buffer_3[0];
2309  0609 5500040001    	mov	_code2+1,_EE_Buffer_3
2310                     ; 694 		code2[2] = EE_Buffer_4[0];
2312  060e 5500050002    	mov	_code2+2,_EE_Buffer_4
2313                     ; 695 		code2[3] = EE_Buffer_5[0];
2315  0613 5500060003    	mov	_code2+3,_EE_Buffer_5
2316                     ; 697 		State_DisplayMessage("BUFF1",5);
2318  0618 4b05          	push	#5
2319  061a ae003e        	ldw	x,#L736
2320  061d ad7a          	call	L35_State_DisplayMessage
2322  061f 84            	pop	a
2323                     ; 698 		delayLFO_ms (1);
2325  0620 ae0001        	ldw	x,#1
2326  0623 cd0000        	call	_delayLFO_ms
2328                     ; 700 		State_DisplayMessage(code2,4);
2330  0626 4b04          	push	#4
2331  0628 ae0000        	ldw	x,#_code2
2332  062b ad6c          	call	L35_State_DisplayMessage
2334  062d 84            	pop	a
2335                     ; 701 		delayLFO_ms (1);
2337  062e ae0001        	ldw	x,#1
2338  0631 cd0000        	call	_delayLFO_ms
2340                     ; 703 		code2[0] = EE_Buffer_7[0];
2342  0634 5500080000    	mov	_code2,_EE_Buffer_7
2343                     ; 704 		code2[1] = EE_Buffer_8[0];
2345  0639 5500090001    	mov	_code2+1,_EE_Buffer_8
2346                     ; 705 		code2[2] = EE_Buffer_9[0];
2348  063e 55000a0002    	mov	_code2+2,_EE_Buffer_9
2349                     ; 706 		code2[3] = EE_Buffer_10[0];
2351  0643 55000b0003    	mov	_code2+3,_EE_Buffer_10
2352                     ; 708 		State_DisplayMessage("BUFF2",5);
2354  0648 4b05          	push	#5
2355  064a ae0038        	ldw	x,#L146
2356  064d ad4a          	call	L35_State_DisplayMessage
2358  064f 84            	pop	a
2359                     ; 709 		delayLFO_ms (1);
2361  0650 ae0001        	ldw	x,#1
2362  0653 cd0000        	call	_delayLFO_ms
2364                     ; 711 		State_DisplayMessage(code2,4);
2366  0656 4b04          	push	#4
2367  0658 ae0000        	ldw	x,#_code2
2368  065b ad3c          	call	L35_State_DisplayMessage
2370  065d 84            	pop	a
2371                     ; 712 		delayLFO_ms (1);
2373  065e ae0001        	ldw	x,#1
2374  0661 cd0000        	call	_delayLFO_ms
2376                     ; 715 	if((EE_Buffer_10[0] == EE_Buffer_5[0]) &&
2376                     ; 716 			(EE_Buffer_9[0] == EE_Buffer_4[0]) &&
2376                     ; 717 				(EE_Buffer_8[0] == EE_Buffer_3[0]) && 
2376                     ; 718 					(EE_Buffer_7[0] == EE_Buffer_2[0])
2376                     ; 719 			 )
2378  0664 c6000b        	ld	a,_EE_Buffer_10
2379  0667 c10006        	cp	a,_EE_Buffer_5
2380  066a 2623          	jrne	L346
2382  066c c6000a        	ld	a,_EE_Buffer_9
2383  066f c10005        	cp	a,_EE_Buffer_4
2384  0672 261b          	jrne	L346
2386  0674 c60009        	ld	a,_EE_Buffer_8
2387  0677 c10004        	cp	a,_EE_Buffer_3
2388  067a 2613          	jrne	L346
2390  067c c60008        	ld	a,_EE_Buffer_7
2391  067f c10003        	cp	a,_EE_Buffer_2
2392  0682 260b          	jrne	L346
2393                     ; 721 			State_DisplayMessage("SUCCES",6);
2395  0684 4b06          	push	#6
2396  0686 ae0031        	ldw	x,#L546
2397  0689 ad0e          	call	L35_State_DisplayMessage
2399  068b 84            	pop	a
2400                     ; 722 			return SUCCESS;
2402  068c a601          	ld	a,#1
2405  068e 81            	ret
2406  068f               L346:
2407                     ; 727 		State_DisplayMessage("ERROR",5);
2409  068f 4b05          	push	#5
2410  0691 ae002b        	ldw	x,#L156
2411  0694 ad03          	call	L35_State_DisplayMessage
2413  0696 84            	pop	a
2414                     ; 728 		return ERROR;
2416  0697 4f            	clr	a
2419  0698 81            	ret
2460                     ; 738 static void State_DisplayMessage (uint8_t message[],uint8_t PayloadLength )
2460                     ; 739 {
2461                     	switch	.text
2462  0699               L35_State_DisplayMessage:
2464  0699 89            	pushw	x
2465       00000000      OFST:	set	0
2468                     ; 750 		CLK_SYSCLKDivConfig(CLK_SYSCLKDiv_1);
2470  069a 4f            	clr	a
2471  069b cd0000        	call	_CLK_SYSCLKDivConfig
2473                     ; 751 		CLK_SYSCLKSourceConfig(CLK_SYSCLKSource_LSI);
2475  069e a602          	ld	a,#2
2476  06a0 cd0000        	call	_CLK_SYSCLKSourceConfig
2478                     ; 752 		CLK_SYSCLKSourceSwitchCmd(ENABLE);
2480  06a3 a601          	ld	a,#1
2481  06a5 cd0000        	call	_CLK_SYSCLKSourceSwitchCmd
2484  06a8               L376:
2485                     ; 753 		while (((CLK->SWCR)& 0x01)==0x01);
2487  06a8 c650c9        	ld	a,20681
2488  06ab a401          	and	a,#1
2489  06ad a101          	cp	a,#1
2490  06af 27f7          	jreq	L376
2491                     ; 754 		CLK_HSICmd(DISABLE);
2493  06b1 4f            	clr	a
2494  06b2 cd0000        	call	_CLK_HSICmd
2496                     ; 755 		CLK->ECKCR &= ~0x01; 
2498  06b5 721150c6      	bres	20678,#0
2499                     ; 758 		LCD_GLASS_DisplayString_1(message);
2501  06b9 1e01          	ldw	x,(OFST+1,sp)
2502  06bb ad28          	call	_LCD_GLASS_DisplayString_1
2504                     ; 762 			CLK_SYSCLKDivConfig(CLK_SYSCLKDiv_16);
2506  06bd a604          	ld	a,#4
2507  06bf cd0000        	call	_CLK_SYSCLKDivConfig
2509                     ; 763 			CLK_HSICmd(ENABLE);
2511  06c2 a601          	ld	a,#1
2512  06c4 cd0000        	call	_CLK_HSICmd
2515  06c7               L107:
2516                     ; 764 			while (((CLK->ICKCR)& 0x02)!=0x02);			
2518  06c7 c650c2        	ld	a,20674
2519  06ca a402          	and	a,#2
2520  06cc a102          	cp	a,#2
2521  06ce 26f7          	jrne	L107
2522                     ; 765 			CLK_SYSCLKSourceConfig(CLK_SYSCLKSource_HSI);
2524  06d0 a601          	ld	a,#1
2525  06d2 cd0000        	call	_CLK_SYSCLKSourceConfig
2527                     ; 766 			CLK_SYSCLKSourceSwitchCmd(ENABLE);
2529  06d5 a601          	ld	a,#1
2530  06d7 cd0000        	call	_CLK_SYSCLKSourceSwitchCmd
2533  06da               L707:
2534                     ; 767 			while (((CLK->SWCR)& 0x01)==0x01);
2536  06da c650c9        	ld	a,20681
2537  06dd a401          	and	a,#1
2538  06df a101          	cp	a,#1
2539  06e1 27f7          	jreq	L707
2540                     ; 777 }
2543  06e3 85            	popw	x
2544  06e4 81            	ret
2591                     ; 786 void LCD_GLASS_DisplayString_1(uint8_t* ptr)
2591                     ; 787 {
2592                     	switch	.text
2593  06e5               _LCD_GLASS_DisplayString_1:
2595  06e5 89            	pushw	x
2596  06e6 88            	push	a
2597       00000001      OFST:	set	1
2600                     ; 788 	uint8_t i = 0x01;
2602  06e7 a601          	ld	a,#1
2603  06e9 6b01          	ld	(OFST+0,sp),a
2604                     ; 790 	clearLCD();
2606  06eb cd0000        	call	_clearLCD
2609  06ee 2017          	jra	L737
2610  06f0               L537:
2611                     ; 795     LCD_GLASS_WriteChar(ptr, FALSE, FALSE, i);
2613  06f0 7b01          	ld	a,(OFST+0,sp)
2614  06f2 88            	push	a
2615  06f3 4b00          	push	#0
2616  06f5 4b00          	push	#0
2617  06f7 1e05          	ldw	x,(OFST+4,sp)
2618  06f9 cd0000        	call	_LCD_GLASS_WriteChar
2620  06fc 5b03          	addw	sp,#3
2621                     ; 798     ptr++;
2623  06fe 1e02          	ldw	x,(OFST+1,sp)
2624  0700 1c0001        	addw	x,#1
2625  0703 1f02          	ldw	(OFST+1,sp),x
2626                     ; 801     i++;
2628  0705 0c01          	inc	(OFST+0,sp)
2629  0707               L737:
2630                     ; 792   while ((*ptr != 0) & (i < 8))
2632  0707 1e02          	ldw	x,(OFST+1,sp)
2633  0709 7d            	tnz	(x)
2634  070a 2706          	jreq	L347
2636  070c 7b01          	ld	a,(OFST+0,sp)
2637  070e a108          	cp	a,#8
2638  0710 25de          	jrult	L537
2639  0712               L347:
2640                     ; 803 }
2643  0712 5b03          	addw	sp,#3
2644  0714 81            	ret
2695                     ; 820 static int8_t User_WriteFirmwareVersion ( void )			
2695                     ; 821 {
2696                     	switch	.text
2697  0715               L73_User_WriteFirmwareVersion:
2699  0715 5204          	subw	sp,#4
2700       00000004      OFST:	set	4
2703                     ; 822 uint8_t *OneByte = 0x00;
2705  0717 5f            	clrw	x
2706  0718 1f01          	ldw	(OFST-3,sp),x
2707                     ; 823 uint16_t WriteAddr = 0x01FC;				
2709  071a ae01fc        	ldw	x,#508
2710  071d 1f03          	ldw	(OFST-1,sp),x
2711                     ; 826 	M24LR04E_Init();
2713  071f cd0000        	call	_M24LR04E_Init
2715                     ; 828 	M24LR04E_WriteOneByte (M24LR16_EEPROM_ADDRESS_USER, WriteAddr++, FirmwareVersion [0]);			
2717  0722 4b13          	push	#19
2718  0724 1604          	ldw	y,(OFST+0,sp)
2719  0726 0c05          	inc	(OFST+1,sp)
2720  0728 2602          	jrne	L64
2721  072a 0c04          	inc	(OFST+0,sp)
2722  072c               L64:
2723  072c 9089          	pushw	y
2724  072e a6a6          	ld	a,#166
2725  0730 cd0000        	call	_M24LR04E_WriteOneByte
2727  0733 5b03          	addw	sp,#3
2728                     ; 831 	I2C_Cmd(M24LR04E_I2C, DISABLE);			
2730  0735 4b00          	push	#0
2731  0737 ae5210        	ldw	x,#21008
2732  073a cd0000        	call	_I2C_Cmd
2734  073d 84            	pop	a
2735                     ; 833 	CLK_PeripheralClockConfig(CLK_Peripheral_I2C1, DISABLE);	
2737  073e ae0300        	ldw	x,#768
2738  0741 cd0000        	call	_CLK_PeripheralClockConfig
2740                     ; 835 	GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SCL_PIN);	
2742  0744 7212500a      	bset	20490,#1
2743                     ; 836 	GPIO_HIGH(M24LR04E_I2C_SCL_GPIO_PORT,M24LR04E_I2C_SDA_PIN);	
2745  0748 7210500a      	bset	20490,#0
2746                     ; 839 	M24LR04E_DeInit();
2748  074c cd0000        	call	_M24LR04E_DeInit
2750                     ; 840 	I2C_Cmd(M24LR04E_I2C, DISABLE);
2752  074f 4b00          	push	#0
2753  0751 ae5210        	ldw	x,#21008
2754  0754 cd0000        	call	_I2C_Cmd
2756  0757 84            	pop	a
2757                     ; 843 	return SUCCESS;
2759  0758 a601          	ld	a,#1
2762  075a 5b04          	addw	sp,#4
2763  075c 81            	ret
2813                     ; 851 static void User_DisplayMessage (uint8_t message[],uint8_t PayloadLength )
2813                     ; 852 {
2814                     	switch	.text
2815  075d               L72_User_DisplayMessage:
2817  075d 89            	pushw	x
2818       00000000      OFST:	set	0
2821                     ; 863 		CLK_SYSCLKDivConfig(CLK_SYSCLKDiv_1);
2823  075e 4f            	clr	a
2824  075f cd0000        	call	_CLK_SYSCLKDivConfig
2826                     ; 864 		CLK_SYSCLKSourceConfig(CLK_SYSCLKSource_LSI);
2828  0762 a602          	ld	a,#2
2829  0764 cd0000        	call	_CLK_SYSCLKSourceConfig
2831                     ; 865 		CLK_SYSCLKSourceSwitchCmd(ENABLE);
2833  0767 a601          	ld	a,#1
2834  0769 cd0000        	call	_CLK_SYSCLKSourceSwitchCmd
2837  076c               L3101:
2838                     ; 866 		while (((CLK->SWCR)& 0x01)==0x01);
2840  076c c650c9        	ld	a,20681
2841  076f a401          	and	a,#1
2842  0771 a101          	cp	a,#1
2843  0773 27f7          	jreq	L3101
2844                     ; 867 		CLK_HSICmd(DISABLE);
2846  0775 4f            	clr	a
2847  0776 cd0000        	call	_CLK_HSICmd
2849                     ; 868 		CLK->ECKCR &= ~0x01; 
2851  0779 721150c6      	bres	20678,#0
2852                     ; 871 		LCD_GLASS_ScrollSentenceNbCar(message,30,PayloadLength+6);		
2854  077d 7b05          	ld	a,(OFST+5,sp)
2855  077f ab06          	add	a,#6
2856  0781 88            	push	a
2857  0782 ae001e        	ldw	x,#30
2858  0785 89            	pushw	x
2859  0786 1e04          	ldw	x,(OFST+4,sp)
2860  0788 cd0000        	call	_LCD_GLASS_ScrollSentenceNbCar
2862  078b 5b03          	addw	sp,#3
2863                     ; 875 			CLK_SYSCLKDivConfig(CLK_SYSCLKDiv_16);
2865  078d a604          	ld	a,#4
2866  078f cd0000        	call	_CLK_SYSCLKDivConfig
2868                     ; 876 			CLK_HSICmd(ENABLE);
2870  0792 a601          	ld	a,#1
2871  0794 cd0000        	call	_CLK_HSICmd
2874  0797               L1201:
2875                     ; 877 			while (((CLK->ICKCR)& 0x02)!=0x02);			
2877  0797 c650c2        	ld	a,20674
2878  079a a402          	and	a,#2
2879  079c a102          	cp	a,#2
2880  079e 26f7          	jrne	L1201
2881                     ; 878 			CLK_SYSCLKSourceConfig(CLK_SYSCLKSource_HSI);
2883  07a0 a601          	ld	a,#1
2884  07a2 cd0000        	call	_CLK_SYSCLKSourceConfig
2886                     ; 879 			CLK_SYSCLKSourceSwitchCmd(ENABLE);
2888  07a5 a601          	ld	a,#1
2889  07a7 cd0000        	call	_CLK_SYSCLKSourceSwitchCmd
2892  07aa               L7201:
2893                     ; 880 			while (((CLK->SWCR)& 0x01)==0x01);
2895  07aa c650c9        	ld	a,20681
2896  07ad a401          	and	a,#1
2897  07af a101          	cp	a,#1
2898  07b1 27f7          	jreq	L7201
2899                     ; 890 }
2902  07b3 85            	popw	x
2903  07b4 81            	ret
2946                     ; 897 static void User_DisplayMessageActiveHaltMode ( uint8_t PayloadLength )
2946                     ; 898 {
2947                     	switch	.text
2948  07b5               L13_User_DisplayMessageActiveHaltMode:
2952                     ; 910 			CLK_SYSCLKDivConfig(CLK_SYSCLKDiv_1);
2954  07b5 4f            	clr	a
2955  07b6 cd0000        	call	_CLK_SYSCLKDivConfig
2957                     ; 911 			CLK_SYSCLKSourceConfig(CLK_SYSCLKSource_LSI);
2959  07b9 a602          	ld	a,#2
2960  07bb cd0000        	call	_CLK_SYSCLKSourceConfig
2962                     ; 912 			CLK_SYSCLKSourceSwitchCmd(ENABLE);
2964  07be a601          	ld	a,#1
2965  07c0 cd0000        	call	_CLK_SYSCLKSourceSwitchCmd
2968  07c3               L3501:
2969                     ; 913 			while (((CLK->SWCR)& 0x01)==0x01);
2971  07c3 c650c9        	ld	a,20681
2972  07c6 a401          	and	a,#1
2973  07c8 a101          	cp	a,#1
2974  07ca 27f7          	jreq	L3501
2975                     ; 914 			CLK_HSICmd(DISABLE);
2977  07cc 4f            	clr	a
2978  07cd cd0000        	call	_CLK_HSICmd
2980                     ; 915 			CLK->ECKCR &= ~0x01; 
2982  07d0 721150c6      	bres	20678,#0
2983                     ; 919 		sim();
2986  07d4 9b            sim
2988                     ; 922 			if (!(_fctcpy('D')))
2991  07d5 a644          	ld	a,#68
2992  07d7 cd0000        	call	__fctcpy
2994  07da a30000        	cpw	x,#0
2995  07dd 2602          	jrne	L7501
2996  07df               L1601:
2997                     ; 923 				while(1);
2999  07df 20fe          	jra	L1601
3000  07e1               L7501:
3001                     ; 926 			Display_Ram (); // Call in RAM
3003  07e1 cd0000        	call	_Display_Ram
3005                     ; 932 			CLK_SYSCLKDivConfig(CLK_SYSCLKDiv_16);
3007  07e4 a604          	ld	a,#4
3008  07e6 cd0000        	call	_CLK_SYSCLKDivConfig
3010                     ; 933 			CLK_HSICmd(ENABLE);
3012  07e9 a601          	ld	a,#1
3013  07eb cd0000        	call	_CLK_HSICmd
3016  07ee               L7601:
3017                     ; 934 			while (((CLK->ICKCR)& 0x02)!=0x02);			
3019  07ee c650c2        	ld	a,20674
3020  07f1 a402          	and	a,#2
3021  07f3 a102          	cp	a,#2
3022  07f5 26f7          	jrne	L7601
3023                     ; 935 			CLK_SYSCLKSourceConfig(CLK_SYSCLKSource_HSI);
3025  07f7 a601          	ld	a,#1
3026  07f9 cd0000        	call	_CLK_SYSCLKSourceConfig
3028                     ; 936 			CLK_SYSCLKSourceSwitchCmd(ENABLE);
3030  07fc a601          	ld	a,#1
3031  07fe cd0000        	call	_CLK_SYSCLKSourceSwitchCmd
3034  0801               L5701:
3035                     ; 937 			while (((CLK->SWCR)& 0x01)==0x01);
3037  0801 c650c9        	ld	a,20681
3038  0804 a401          	and	a,#1
3039  0806 a101          	cp	a,#1
3040  0808 27f7          	jreq	L5701
3041                     ; 949 		rim();
3044  080a 9a            rim
3046                     ; 952 }
3050  080b 81            	ret
3117                     ; 963 static ErrorStatus User_CheckNDEFMessage(void)
3117                     ; 964 {
3118                     	switch	.text
3119  080c               L11_User_CheckNDEFMessage:
3121  080c 5204          	subw	sp,#4
3122       00000004      OFST:	set	4
3125                     ; 965 uint8_t *OneByte = 0x00;
3127  080e 5f            	clrw	x
3128  080f 1f03          	ldw	(OFST-1,sp),x
3129                     ; 966 uint16_t ReadAddr = 0x0000;
3131                     ; 969 	M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr, OneByte);	
3133  0811 5f            	clrw	x
3134  0812 89            	pushw	x
3135  0813 5f            	clrw	x
3136  0814 89            	pushw	x
3137  0815 a6a6          	ld	a,#166
3138  0817 cd0000        	call	_M24LR04E_ReadOneByte
3140  081a 5b04          	addw	sp,#4
3141                     ; 970 	if (*OneByte != 0xE1)
3143  081c 1e03          	ldw	x,(OFST-1,sp)
3144  081e f6            	ld	a,(x)
3145  081f a1e1          	cp	a,#225
3146  0821 2703          	jreq	L3311
3147                     ; 971 		return ERROR;
3149  0823 4f            	clr	a
3151  0824 2016          	jra	L65
3152  0826               L3311:
3153                     ; 973 	ReadAddr = 0x0009;
3155                     ; 974 	M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr, OneByte);	
3157  0826 1e03          	ldw	x,(OFST-1,sp)
3158  0828 89            	pushw	x
3159  0829 ae0009        	ldw	x,#9
3160  082c 89            	pushw	x
3161  082d a6a6          	ld	a,#166
3162  082f cd0000        	call	_M24LR04E_ReadOneByte
3164  0832 5b04          	addw	sp,#4
3165                     ; 976 	if (*OneByte != 0x54 /*&& *OneByte != 0x55*/)
3167  0834 1e03          	ldw	x,(OFST-1,sp)
3168  0836 f6            	ld	a,(x)
3169  0837 a154          	cp	a,#84
3170  0839 2704          	jreq	L5311
3171                     ; 977 		return ERROR;
3173  083b 4f            	clr	a
3175  083c               L65:
3177  083c 5b04          	addw	sp,#4
3178  083e 81            	ret
3179  083f               L5311:
3180                     ; 979 	return SUCCESS;	
3182  083f a601          	ld	a,#1
3184  0841 20f9          	jra	L65
3231                     ; 988 static ErrorStatus User_GetPayloadLength(uint8_t *PayloadLength)
3231                     ; 989 {
3232                     	switch	.text
3233  0843               L7_User_GetPayloadLength:
3235  0843 89            	pushw	x
3236  0844 89            	pushw	x
3237       00000002      OFST:	set	2
3240                     ; 990 uint16_t ReadAddr = 0x0008;
3242                     ; 992 	*PayloadLength = 0x00;
3244  0845 7f            	clr	(x)
3245                     ; 994 	M24LR04E_ReadOneByte (M24LR16_EEPROM_ADDRESS_USER, ReadAddr, PayloadLength);	
3247  0846 89            	pushw	x
3248  0847 ae0008        	ldw	x,#8
3249  084a 89            	pushw	x
3250  084b a6a6          	ld	a,#166
3251  084d cd0000        	call	_M24LR04E_ReadOneByte
3253  0850 5b04          	addw	sp,#4
3254                     ; 995 	if (*PayloadLength == 0x00)
3256  0852 1e03          	ldw	x,(OFST+1,sp)
3257  0854 7d            	tnz	(x)
3258  0855 2603          	jrne	L1611
3259                     ; 996 		return ERROR;
3261  0857 4f            	clr	a
3263  0858 2002          	jra	L26
3264  085a               L1611:
3265                     ; 998 	return SUCCESS;	
3267  085a a601          	ld	a,#1
3269  085c               L26:
3271  085c 5b04          	addw	sp,#4
3272  085e 81            	ret
3328                     ; 1009 static ErrorStatus User_GetNDEFMessage(uint8_t  PayloadLength,uint8_t *NDEFmessage)
3328                     ; 1010 {
3329                     	switch	.text
3330  085f               L31_User_GetNDEFMessage:
3332  085f 88            	push	a
3333  0860 89            	pushw	x
3334       00000002      OFST:	set	2
3337                     ; 1011 uint16_t ReadAddr = 0x000D;
3339                     ; 1013 	if (PayloadLength == 0x00)
3341  0861 4d            	tnz	a
3342  0862 2604          	jrne	L1121
3343                     ; 1014 		return SUCCESS;		
3345  0864 a601          	ld	a,#1
3347  0866 2013          	jra	L66
3348  0868               L1121:
3349                     ; 1016 	M24LR04E_ReadBuffer (M24LR16_EEPROM_ADDRESS_USER, ReadAddr,PayloadLength, NDEFmessage);	
3351  0868 1e06          	ldw	x,(OFST+4,sp)
3352  086a 89            	pushw	x
3353  086b 7b05          	ld	a,(OFST+3,sp)
3354  086d 88            	push	a
3355  086e ae000d        	ldw	x,#13
3356  0871 89            	pushw	x
3357  0872 a6a6          	ld	a,#166
3358  0874 cd0000        	call	_M24LR04E_ReadBuffer
3360  0877 5b05          	addw	sp,#5
3361                     ; 1018 	return SUCCESS;	
3363  0879 a601          	ld	a,#1
3365  087b               L66:
3367  087b 5b03          	addw	sp,#3
3368  087d 81            	ret
3404                     ; 1027 static void User_DesactivateEnergyHarvesting ( void )
3404                     ; 1028 {
3405                     	switch	.text
3406  087e               L71_User_DesactivateEnergyHarvesting:
3408  087e 89            	pushw	x
3409       00000002      OFST:	set	2
3412                     ; 1029 uint16_t WriteAddr = 0x0920;
3414                     ; 1030 	M24LR04E_WriteOneByte (M24LR16_EEPROM_ADDRESS_SYSTEM, WriteAddr,0x00)	;
3416  087f 4b00          	push	#0
3417  0881 ae0920        	ldw	x,#2336
3418  0884 89            	pushw	x
3419  0885 a6ae          	ld	a,#174
3420  0887 cd0000        	call	_M24LR04E_WriteOneByte
3422  088a 5b03          	addw	sp,#3
3423                     ; 1031 }
3426  088c 85            	popw	x
3427  088d 81            	ret
3499                     ; 1039 static void ToUpperCase (uint8_t  NbCar ,uint8_t *StringToConvert)
3499                     ; 1040 {
3500                     	switch	.text
3501  088e               L51_ToUpperCase:
3503  088e 88            	push	a
3504  088f 52ff          	subw	sp,#255
3505  0891 5212          	subw	sp,#18
3506       00000111      OFST:	set	273
3509                     ; 1042 				i=3,
3511                     ; 1043 				NbSpace = 6;
3513  0893 a606          	ld	a,#6
3514  0895 6b11          	ld	(OFST-256,sp),a
3515                     ; 1045 	for (i=0;i<NbSpace;i++)
3517  0897 96            	ldw	x,sp
3518  0898 1c0111        	addw	x,#OFST+0
3519  089b 7f            	clr	(x)
3521  089c 201a          	jra	L3721
3522  089e               L7621:
3523                     ; 1046 			Buffer[i] = ' ';
3525  089e 96            	ldw	x,sp
3526  089f 1c0012        	addw	x,#OFST-255
3527  08a2 9f            	ld	a,xl
3528  08a3 5e            	swapw	x
3529  08a4 9096          	ldw	y,sp
3530  08a6 72a90111      	addw	y,#OFST+0
3531  08aa 90fb          	add	a,(y)
3532  08ac 2401          	jrnc	L47
3533  08ae 5c            	incw	x
3534  08af               L47:
3535  08af 02            	rlwa	x,a
3536  08b0 a620          	ld	a,#32
3537  08b2 f7            	ld	(x),a
3538                     ; 1045 	for (i=0;i<NbSpace;i++)
3540  08b3 96            	ldw	x,sp
3541  08b4 1c0111        	addw	x,#OFST+0
3542  08b7 7c            	inc	(x)
3543  08b8               L3721:
3546  08b8 96            	ldw	x,sp
3547  08b9 1c0111        	addw	x,#OFST+0
3548  08bc f6            	ld	a,(x)
3549  08bd 1111          	cp	a,(OFST-256,sp)
3550  08bf 25dd          	jrult	L7621
3551                     ; 1048 	for (i=0;i<NbCar;i++)
3553  08c1 96            	ldw	x,sp
3554  08c2 1c0111        	addw	x,#OFST+0
3555  08c5 7f            	clr	(x)
3557  08c6 2030          	jra	L3031
3558  08c8               L7721:
3559                     ; 1049 			Buffer[i+NbSpace] = StringToConvert[i];
3561  08c8 96            	ldw	x,sp
3562  08c9 1c0012        	addw	x,#OFST-255
3563  08cc 1f0f          	ldw	(OFST-258,sp),x
3564  08ce 96            	ldw	x,sp
3565  08cf 1c0111        	addw	x,#OFST+0
3566  08d2 f6            	ld	a,(x)
3567  08d3 5f            	clrw	x
3568  08d4 1b11          	add	a,(OFST-256,sp)
3569  08d6 2401          	jrnc	L67
3570  08d8 5c            	incw	x
3571  08d9               L67:
3572  08d9 02            	rlwa	x,a
3573  08da 72fb0f        	addw	x,(OFST-258,sp)
3574  08dd 89            	pushw	x
3575  08de 96            	ldw	x,sp
3576  08df 1c0117        	addw	x,#OFST+6
3577  08e2 fe            	ldw	x,(x)
3578  08e3 01            	rrwa	x,a
3579  08e4 9096          	ldw	y,sp
3580  08e6 72a90113      	addw	y,#OFST+2
3581  08ea 90fb          	add	a,(y)
3582  08ec 2401          	jrnc	L001
3583  08ee 5c            	incw	x
3584  08ef               L001:
3585  08ef 02            	rlwa	x,a
3586  08f0 f6            	ld	a,(x)
3587  08f1 85            	popw	x
3588  08f2 f7            	ld	(x),a
3589                     ; 1048 	for (i=0;i<NbCar;i++)
3591  08f3 96            	ldw	x,sp
3592  08f4 1c0111        	addw	x,#OFST+0
3593  08f7 7c            	inc	(x)
3594  08f8               L3031:
3597  08f8 96            	ldw	x,sp
3598  08f9 1c0111        	addw	x,#OFST+0
3599  08fc f6            	ld	a,(x)
3600  08fd 96            	ldw	x,sp
3601  08fe 1c0112        	addw	x,#OFST+1
3602  0901 f1            	cp	a,(x)
3603  0902 25c4          	jrult	L7721
3604                     ; 1051 	for (i=0;i<NbCar+NbSpace;i++)
3606  0904 96            	ldw	x,sp
3607  0905 1c0111        	addw	x,#OFST+0
3608  0908 7f            	clr	(x)
3610  0909 cc0993        	jra	L3131
3611  090c               L7031:
3612                     ; 1053 		if (Buffer[i] >= 0x61 && Buffer[i] <= 0x7A)
3614  090c 96            	ldw	x,sp
3615  090d 1c0012        	addw	x,#OFST-255
3616  0910 9f            	ld	a,xl
3617  0911 5e            	swapw	x
3618  0912 9096          	ldw	y,sp
3619  0914 72a90111      	addw	y,#OFST+0
3620  0918 90fb          	add	a,(y)
3621  091a 2401          	jrnc	L201
3622  091c 5c            	incw	x
3623  091d               L201:
3624  091d 02            	rlwa	x,a
3625  091e f6            	ld	a,(x)
3626  091f a161          	cp	a,#97
3627  0921 2543          	jrult	L7131
3629  0923 96            	ldw	x,sp
3630  0924 1c0012        	addw	x,#OFST-255
3631  0927 9f            	ld	a,xl
3632  0928 5e            	swapw	x
3633  0929 9096          	ldw	y,sp
3634  092b 72a90111      	addw	y,#OFST+0
3635  092f 90fb          	add	a,(y)
3636  0931 2401          	jrnc	L401
3637  0933 5c            	incw	x
3638  0934               L401:
3639  0934 02            	rlwa	x,a
3640  0935 f6            	ld	a,(x)
3641  0936 a17b          	cp	a,#123
3642  0938 242c          	jruge	L7131
3643                     ; 1054 			StringToConvert[i] = Buffer[i]-32;
3645  093a 96            	ldw	x,sp
3646  093b 1c0115        	addw	x,#OFST+4
3647  093e fe            	ldw	x,(x)
3648  093f 01            	rrwa	x,a
3649  0940 9096          	ldw	y,sp
3650  0942 72a90111      	addw	y,#OFST+0
3651  0946 90fb          	add	a,(y)
3652  0948 2401          	jrnc	L601
3653  094a 5c            	incw	x
3654  094b               L601:
3655  094b 02            	rlwa	x,a
3656  094c 89            	pushw	x
3657  094d 96            	ldw	x,sp
3658  094e 1c0014        	addw	x,#OFST-253
3659  0951 9f            	ld	a,xl
3660  0952 5e            	swapw	x
3661  0953 9096          	ldw	y,sp
3662  0955 72a90113      	addw	y,#OFST+2
3663  0959 90fb          	add	a,(y)
3664  095b 2401          	jrnc	L011
3665  095d 5c            	incw	x
3666  095e               L011:
3667  095e 02            	rlwa	x,a
3668  095f f6            	ld	a,(x)
3669  0960 a020          	sub	a,#32
3670  0962 85            	popw	x
3671  0963 f7            	ld	(x),a
3673  0964 2028          	jra	L1231
3674  0966               L7131:
3675                     ; 1056 			StringToConvert[i] = Buffer[i];
3677  0966 96            	ldw	x,sp
3678  0967 1c0115        	addw	x,#OFST+4
3679  096a fe            	ldw	x,(x)
3680  096b 01            	rrwa	x,a
3681  096c 9096          	ldw	y,sp
3682  096e 72a90111      	addw	y,#OFST+0
3683  0972 90fb          	add	a,(y)
3684  0974 2401          	jrnc	L211
3685  0976 5c            	incw	x
3686  0977               L211:
3687  0977 02            	rlwa	x,a
3688  0978 89            	pushw	x
3689  0979 96            	ldw	x,sp
3690  097a 1c0014        	addw	x,#OFST-253
3691  097d 9f            	ld	a,xl
3692  097e 5e            	swapw	x
3693  097f 9096          	ldw	y,sp
3694  0981 72a90113      	addw	y,#OFST+2
3695  0985 90fb          	add	a,(y)
3696  0987 2401          	jrnc	L411
3697  0989 5c            	incw	x
3698  098a               L411:
3699  098a 02            	rlwa	x,a
3700  098b f6            	ld	a,(x)
3701  098c 85            	popw	x
3702  098d f7            	ld	(x),a
3703  098e               L1231:
3704                     ; 1051 	for (i=0;i<NbCar+NbSpace;i++)
3706  098e 96            	ldw	x,sp
3707  098f 1c0111        	addw	x,#OFST+0
3708  0992 7c            	inc	(x)
3709  0993               L3131:
3712  0993 9c            	rvf
3713  0994 96            	ldw	x,sp
3714  0995 1c0111        	addw	x,#OFST+0
3715  0998 f6            	ld	a,(x)
3716  0999 5f            	clrw	x
3717  099a 97            	ld	xl,a
3718  099b 1f0f          	ldw	(OFST-258,sp),x
3719  099d 96            	ldw	x,sp
3720  099e 1c0112        	addw	x,#OFST+1
3721  09a1 f6            	ld	a,(x)
3722  09a2 5f            	clrw	x
3723  09a3 1b11          	add	a,(OFST-256,sp)
3724  09a5 2401          	jrnc	L611
3725  09a7 5c            	incw	x
3726  09a8               L611:
3727  09a8 02            	rlwa	x,a
3728  09a9 130f          	cpw	x,(OFST-258,sp)
3729  09ab 2d03          	jrsle	L421
3730  09ad cc090c        	jp	L7031
3731  09b0               L421:
3732                     ; 1058 	StringToConvert[NbCar+NbSpace] = ' ';
3734  09b0 96            	ldw	x,sp
3735  09b1 1c0112        	addw	x,#OFST+1
3736  09b4 f6            	ld	a,(x)
3737  09b5 5f            	clrw	x
3738  09b6 1b11          	add	a,(OFST-256,sp)
3739  09b8 2401          	jrnc	L021
3740  09ba 5c            	incw	x
3741  09bb               L021:
3742  09bb 02            	rlwa	x,a
3743  09bc 9096          	ldw	y,sp
3744  09be 72a90115      	addw	y,#OFST+4
3745  09c2 90fe          	ldw	y,(y)
3746  09c4 90bf00        	ldw	c_x,y
3747  09c7 72bb0000      	addw	x,c_x
3748  09cb a620          	ld	a,#32
3749  09cd f7            	ld	(x),a
3750                     ; 1059 	StringToConvert[NbCar+NbSpace+1] = 0;
3752  09ce 96            	ldw	x,sp
3753  09cf 1c0112        	addw	x,#OFST+1
3754  09d2 f6            	ld	a,(x)
3755  09d3 5f            	clrw	x
3756  09d4 1b11          	add	a,(OFST-256,sp)
3757  09d6 2401          	jrnc	L221
3758  09d8 5c            	incw	x
3759  09d9               L221:
3760  09d9 02            	rlwa	x,a
3761  09da 9096          	ldw	y,sp
3762  09dc 72a90115      	addw	y,#OFST+4
3763  09e0 90fe          	ldw	y,(y)
3764  09e2 90bf00        	ldw	c_x,y
3765  09e5 72bb0000      	addw	x,c_x
3766  09e9 6f01          	clr	(1,x)
3767                     ; 1061 }
3770  09eb 5bff          	addw	sp,#255
3771  09ed 5b13          	addw	sp,#19
3772  09ef 81            	ret
3816                     ; 1071 static void InitializeBuffer (uint8_t *Buffer ,uint8_t NbCar)
3816                     ; 1072 {
3817                     	switch	.text
3818  09f0               L32_InitializeBuffer:
3820  09f0 89            	pushw	x
3821       00000000      OFST:	set	0
3824  09f1               L5431:
3825                     ; 1076 		Buffer[NbCar]= 0;
3827  09f1 7b01          	ld	a,(OFST+1,sp)
3828  09f3 97            	ld	xl,a
3829  09f4 7b02          	ld	a,(OFST+2,sp)
3830  09f6 1b05          	add	a,(OFST+5,sp)
3831  09f8 2401          	jrnc	L031
3832  09fa 5c            	incw	x
3833  09fb               L031:
3834  09fb 02            	rlwa	x,a
3835  09fc 7f            	clr	(x)
3836                     ; 1077 	}	while (NbCar--);
3838  09fd 7b05          	ld	a,(OFST+5,sp)
3839  09ff 0a05          	dec	(OFST+5,sp)
3840  0a01 4d            	tnz	a
3841  0a02 26ed          	jrne	L5431
3842                     ; 1078 }
3845  0a04 85            	popw	x
3846  0a05 81            	ret
4104                     	xdef	_main
4105                     	switch	.ubsct
4106  0000               _code2:
4107  0000 0000000000    	ds.b	5
4108                     	xdef	_code2
4109  0005               _code:
4110  0005 00000000      	ds.b	4
4111                     	xdef	_code
4112                     	switch	.eeprom
4113  0001               _EE_Buf_Flag:
4114  0001 00            	ds.b	1
4115                     	xdef	_EE_Buf_Flag
4116  0002               _EE_Buffer_1:
4117  0002 00            	ds.b	1
4118                     	xdef	_EE_Buffer_1
4119  0003               _EE_Buffer_2:
4120  0003 00            	ds.b	1
4121                     	xdef	_EE_Buffer_2
4122  0004               _EE_Buffer_3:
4123  0004 00            	ds.b	1
4124                     	xdef	_EE_Buffer_3
4125  0005               _EE_Buffer_4:
4126  0005 00            	ds.b	1
4127                     	xdef	_EE_Buffer_4
4128  0006               _EE_Buffer_5:
4129  0006 00            	ds.b	1
4130                     	xdef	_EE_Buffer_5
4131  0007               _EE_Buffer_6:
4132  0007 00            	ds.b	1
4133                     	xdef	_EE_Buffer_6
4134  0008               _EE_Buffer_7:
4135  0008 00            	ds.b	1
4136                     	xdef	_EE_Buffer_7
4137  0009               _EE_Buffer_8:
4138  0009 00            	ds.b	1
4139                     	xdef	_EE_Buffer_8
4140  000a               _EE_Buffer_9:
4141  000a 00            	ds.b	1
4142                     	xdef	_EE_Buffer_9
4143  000b               _EE_Buffer_10:
4144  000b 00            	ds.b	1
4145                     	xdef	_EE_Buffer_10
4146  000c               _EE_Buffer_11:
4147  000c 00            	ds.b	1
4148                     	xdef	_EE_Buffer_11
4149  000d               _EE_Pay_Lengt:
4150  000d 00            	ds.b	1
4151                     	xdef	_EE_Pay_Lengt
4152                     	xdef	_FirmwareVersion
4153                     	xdef	_EEInitial
4154  000e               _EEMenuState:
4155  000e 00            	ds.b	1
4156                     	xdef	_EEMenuState
4157                     	xdef	_ErrorMessage
4158                     	switch	.ubsct
4159  0009               _NDEFmessage:
4160  0009 000000000000  	ds.b	64
4161                     	xdef	_NDEFmessage
4162  0049               L36_CodeLength:
4163  0049 0000          	ds.b	2
4164                     	xdef	_LCD_GLASS_DisplayString_1
4165  004b               _state_machine:
4166  004b 00            	ds.b	1
4167                     	xdef	_state_machine
4168                     	xref	_Initialize
4169                     	xref	_UnInitialize
4170                     	xref	_clearLCD
4171                     	xref	_setLED
4172                     	xref	_delayLFO_ms
4173                     	xref	_Display_Ram
4174                     	xref	_Vref_measure
4175                     	xref	__fctcpy
4176                     	xref	_I2C_SS_ReadOneByte
4177                     	xref	_I2C_SS_Config
4178                     	xref	_I2C_SS_Init
4179                     	xref	_M24LR04E_WriteOneByte
4180                     	xref	_M24LR04E_ReadBuffer
4181                     	xref	_M24LR04E_ReadOneByte
4182                     	xref	_M24LR04E_Init
4183                     	xref	_M24LR04E_DeInit
4184                     	xref	_I2C_Cmd
4185                     	xref	_LCD_GLASS_ScrollSentenceNbCar
4186                     	xref	_LCD_GLASS_DisplayStrDeci
4187                     	xref	_LCD_GLASS_DisplayString
4188                     	xref	_LCD_GLASS_WriteChar
4189                     	xref	_FLASH_Unlock
4190                     	xref	_CLK_PeripheralClockConfig
4191                     	xref	_CLK_SYSCLKSourceSwitchCmd
4192                     	xref	_CLK_SYSCLKDivConfig
4193                     	xref	_CLK_SYSCLKSourceConfig
4194                     	xref	_CLK_HSICmd
4195                     	switch	.const
4196  002b               L156:
4197  002b 4552524f5200  	dc.b	"ERROR",0
4198  0031               L546:
4199  0031 535543434553  	dc.b	"SUCCES",0
4200  0038               L146:
4201  0038 425546463200  	dc.b	"BUFF2",0
4202  003e               L736:
4203  003e 425546463100  	dc.b	"BUFF1",0
4204  0044               L761:
4205  0044 4572726f7200  	dc.b	"Error",0
4206  004a               L561:
4207  004a 4f4e4c592034  	dc.b	"ONLY 4 CHARACTERS "
4208  005c 454e54455220  	dc.b	"ENTER PIN AGAIN",0
4209  006c               L161:
4210  006c 434c4f534544  	dc.b	"CLOSED",0
4211  0073               L351:
4212  0073 4f50454e00    	dc.b	"OPEN",0
4213                     	xref.b	c_x
4233                     	xref	c_sdivx
4234                     	xref	c_smodx
4235                     	xref	c_eewrc
4236                     	end
