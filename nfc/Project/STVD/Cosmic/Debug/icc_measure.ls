   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.9.10 - 10 Feb 2011
   3                     ; Generator (Limited) V4.3.6 - 15 Feb 2011
  47                     ; 33 void GPIO_LowPower_Config(void)
  47                     ; 34 {
  49                     	switch	.text
  50  0000               _GPIO_LowPower_Config:
  54                     ; 37   GPIO_Init(GPIOA,GPIO_Pin_2|GPIO_Pin_3|GPIO_Pin_4|GPIO_Pin_5|GPIO_Pin_6|GPIO_Pin_7 ,GPIO_Mode_Out_PP_Low_Slow);
  56  0000 4bc0          	push	#192
  57  0002 4bfc          	push	#252
  58  0004 ae5000        	ldw	x,#20480
  59  0007 cd0000        	call	_GPIO_Init
  61  000a 85            	popw	x
  62                     ; 40   GPIO_Init(GPIOB, GPIO_Pin_All, GPIO_Mode_Out_PP_Low_Slow);
  64  000b 4bc0          	push	#192
  65  000d 4bff          	push	#255
  66  000f ae5005        	ldw	x,#20485
  67  0012 cd0000        	call	_GPIO_Init
  69  0015 85            	popw	x
  70                     ; 43   GPIO_Init(GPIOC, GPIO_Pin_0|GPIO_Pin_2|GPIO_Pin_3|GPIO_Pin_5|GPIO_Pin_6, GPIO_Mode_Out_PP_Low_Slow);
  72  0016 4bc0          	push	#192
  73  0018 4b6d          	push	#109
  74  001a ae500a        	ldw	x,#20490
  75  001d cd0000        	call	_GPIO_Init
  77  0020 85            	popw	x
  78                     ; 46   GPIO_Init(GPIOD, GPIO_Pin_All, GPIO_Mode_Out_PP_Low_Slow);
  80  0021 4bc0          	push	#192
  81  0023 4bff          	push	#255
  82  0025 ae500f        	ldw	x,#20495
  83  0028 cd0000        	call	_GPIO_Init
  85  002b 85            	popw	x
  86                     ; 49   GPIO_Init(GPIOE, GPIO_Pin_0|GPIO_Pin_1|GPIO_Pin_2|GPIO_Pin_3|GPIO_Pin_5, GPIO_Mode_Out_PP_Low_Slow);
  88  002c 4bc0          	push	#192
  89  002e 4b2f          	push	#47
  90  0030 ae5014        	ldw	x,#20500
  91  0033 cd0000        	call	_GPIO_Init
  93  0036 85            	popw	x
  94                     ; 53   GPIO_Init(GPIOF,GPIO_Pin_1|GPIO_Pin_2|GPIO_Pin_3|GPIO_Pin_5|GPIO_Pin_6|GPIO_Pin_7 ,GPIO_Mode_Out_PP_Low_Slow);
  96  0037 4bc0          	push	#192
  97  0039 4bee          	push	#238
  98  003b ae5019        	ldw	x,#20505
  99  003e cd0000        	call	_GPIO_Init
 101  0041 85            	popw	x
 102                     ; 55   GPIO_Init(GPIOC, GPIO_Pin_1, GPIO_Mode_Out_PP_High_Slow);
 104  0042 4bd0          	push	#208
 105  0044 4b02          	push	#2
 106  0046 ae500a        	ldw	x,#20490
 107  0049 cd0000        	call	_GPIO_Init
 109  004c 85            	popw	x
 110                     ; 56 }
 113  004d 81            	ret
 168                     ; 64 u16 ADC_Supply(void)
 168                     ; 65 {
 169                     	switch	.text
 170  004e               _ADC_Supply:
 172  004e 5203          	subw	sp,#3
 173       00000003      OFST:	set	3
 176                     ; 70   CLK_PeripheralClockConfig(CLK_Peripheral_ADC1, ENABLE);
 178  0050 ae1001        	ldw	x,#4097
 179  0053 cd0000        	call	_CLK_PeripheralClockConfig
 181                     ; 73   ADC_DeInit(ADC1);
 183  0056 ae5340        	ldw	x,#21312
 184  0059 cd0000        	call	_ADC_DeInit
 186                     ; 83   ADC_VrefintCmd(ENABLE);
 188  005c a601          	ld	a,#1
 189  005e cd0000        	call	_ADC_VrefintCmd
 191                     ; 84   delay_10us(3);
 193  0061 ae0003        	ldw	x,#3
 194  0064 cd0000        	call	_delay_10us
 196                     ; 87   ADC_Cmd(ADC1, ENABLE);	 
 198  0067 4b01          	push	#1
 199  0069 ae5340        	ldw	x,#21312
 200  006c cd0000        	call	_ADC_Cmd
 202  006f 84            	pop	a
 203                     ; 88   ADC_Init(ADC1, ADC_ConversionMode_Single,
 203                     ; 89   ADC_Resolution_12Bit, ADC_Prescaler_1);
 205  0070 4b00          	push	#0
 206  0072 4b00          	push	#0
 207  0074 4b00          	push	#0
 208  0076 ae5340        	ldw	x,#21312
 209  0079 cd0000        	call	_ADC_Init
 211  007c 5b03          	addw	sp,#3
 212                     ; 91   ADC_SamplingTimeConfig(ADC1, ADC_Group_FastChannels, ADC_SamplingTime_9Cycles);
 214  007e 4b01          	push	#1
 215  0080 4b01          	push	#1
 216  0082 ae5340        	ldw	x,#21312
 217  0085 cd0000        	call	_ADC_SamplingTimeConfig
 219  0088 85            	popw	x
 220                     ; 92   ADC_ChannelCmd(ADC1, ADC_Channel_Vrefint, ENABLE);
 222  0089 4b01          	push	#1
 223  008b ae0010        	ldw	x,#16
 224  008e 89            	pushw	x
 225  008f ae5340        	ldw	x,#21312
 226  0092 cd0000        	call	_ADC_ChannelCmd
 228  0095 5b03          	addw	sp,#3
 229                     ; 93   delay_10us(3);
 231  0097 ae0003        	ldw	x,#3
 232  009a cd0000        	call	_delay_10us
 234                     ; 96   res = 0;
 236  009d 5f            	clrw	x
 237  009e 1f01          	ldw	(OFST-2,sp),x
 238                     ; 97   for(i=8; i>0; i--)
 240  00a0 a608          	ld	a,#8
 241  00a2 6b03          	ld	(OFST+0,sp),a
 242  00a4               L34:
 243                     ; 100     ADC_SoftwareStartConv(ADC1);
 245  00a4 ae5340        	ldw	x,#21312
 246  00a7 cd0000        	call	_ADC_SoftwareStartConv
 249  00aa               L35:
 250                     ; 102     while( ADC_GetFlagStatus(ADC1, ADC_FLAG_EOC) == 0 );
 252  00aa 4b01          	push	#1
 253  00ac ae5340        	ldw	x,#21312
 254  00af cd0000        	call	_ADC_GetFlagStatus
 256  00b2 5b01          	addw	sp,#1
 257  00b4 4d            	tnz	a
 258  00b5 27f3          	jreq	L35
 259                     ; 104     res += ADC_GetConversionValue(ADC1);
 261  00b7 ae5340        	ldw	x,#21312
 262  00ba cd0000        	call	_ADC_GetConversionValue
 264  00bd 72fb01        	addw	x,(OFST-2,sp)
 265  00c0 1f01          	ldw	(OFST-2,sp),x
 266                     ; 97   for(i=8; i>0; i--)
 268  00c2 0a03          	dec	(OFST+0,sp)
 271  00c4 0d03          	tnz	(OFST+0,sp)
 272  00c6 26dc          	jrne	L34
 273                     ; 108   ADC_VrefintCmd(DISABLE);
 275  00c8 4f            	clr	a
 276  00c9 cd0000        	call	_ADC_VrefintCmd
 278                     ; 110   ADC_DeInit(ADC1);
 280  00cc ae5340        	ldw	x,#21312
 281  00cf cd0000        	call	_ADC_DeInit
 283                     ; 113   ADC_SchmittTriggerConfig(ADC1, ADC_Channel_24, DISABLE);
 285  00d2 4b00          	push	#0
 286  00d4 ae0001        	ldw	x,#1
 287  00d7 89            	pushw	x
 288  00d8 ae5340        	ldw	x,#21312
 289  00db cd0000        	call	_ADC_SchmittTriggerConfig
 291  00de 5b03          	addw	sp,#3
 292                     ; 115   CLK_PeripheralClockConfig(CLK_Peripheral_ADC1, DISABLE);
 294  00e0 ae1000        	ldw	x,#4096
 295  00e3 cd0000        	call	_CLK_PeripheralClockConfig
 297                     ; 116   ADC_ChannelCmd(ADC1, ADC_Channel_Vrefint, DISABLE);
 299  00e6 4b00          	push	#0
 300  00e8 ae0010        	ldw	x,#16
 301  00eb 89            	pushw	x
 302  00ec ae5340        	ldw	x,#21312
 303  00ef cd0000        	call	_ADC_ChannelCmd
 305  00f2 5b03          	addw	sp,#3
 306                     ; 118   return (res>>3);
 308  00f4 1e01          	ldw	x,(OFST-2,sp)
 309  00f6 54            	srlw	x
 310  00f7 54            	srlw	x
 311  00f8 54            	srlw	x
 314  00f9 5b03          	addw	sp,#3
 315  00fb 81            	ret
 343                     ; 168 void Halt_Init(void)
 343                     ; 169 {
 344                     	switch	.text
 345  00fc               _Halt_Init:
 349                     ; 172   PWR->CSR2 = 0x2;
 351  00fc 350250b3      	mov	20659,#2
 352                     ; 174   LCD_Cmd(DISABLE);
 354  0100 4f            	clr	a
 355  0101 cd0000        	call	_LCD_Cmd
 358  0104               L17:
 359                     ; 177   while ((LCD->CR3 & 0x40) != 0x00);
 361  0104 c65402        	ld	a,21506
 362  0107 a540          	bcp	a,#64
 363  0109 26f9          	jrne	L17
 364                     ; 180   GPIO_LowPower_Config();
 366  010b cd0000        	call	_GPIO_LowPower_Config
 368                     ; 183   CLK_RTCClockConfig(CLK_RTCCLKSource_Off, CLK_RTCCLKDiv_1);
 370  010e 5f            	clrw	x
 371  010f cd0000        	call	_CLK_RTCClockConfig
 373                     ; 189     CLK_LSICmd(DISABLE);
 375  0112 4f            	clr	a
 376  0113 cd0000        	call	_CLK_LSICmd
 379  0116               L77:
 380                     ; 190     while ((CLK->ICKCR & 0x04) != 0x00);
 382  0116 c650c2        	ld	a,20674
 383  0119 a504          	bcp	a,#4
 384  011b 26f9          	jrne	L77
 385                     ; 194   CLK_PeripheralClockConfig(CLK_Peripheral_RTC, DISABLE);
 387  011d ae1200        	ldw	x,#4608
 388  0120 cd0000        	call	_CLK_PeripheralClockConfig
 390                     ; 195   CLK_PeripheralClockConfig(CLK_Peripheral_LCD, DISABLE);
 392  0123 ae1300        	ldw	x,#4864
 393  0126 cd0000        	call	_CLK_PeripheralClockConfig
 395                     ; 196 }
 398  0129 81            	ret
 411                     	xdef	_Halt_Init
 412                     	xref	_delay_10us
 413                     	xdef	_GPIO_LowPower_Config
 414                     	xdef	_ADC_Supply
 415                     	xref	_ADC_GetFlagStatus
 416                     	xref	_ADC_GetConversionValue
 417                     	xref	_ADC_SchmittTriggerConfig
 418                     	xref	_ADC_SamplingTimeConfig
 419                     	xref	_ADC_SoftwareStartConv
 420                     	xref	_ADC_VrefintCmd
 421                     	xref	_ADC_Cmd
 422                     	xref	_ADC_ChannelCmd
 423                     	xref	_ADC_Init
 424                     	xref	_ADC_DeInit
 425                     	xref	_LCD_Cmd
 426                     	xref	_GPIO_Init
 427                     	xref	_CLK_PeripheralClockConfig
 428                     	xref	_CLK_RTCClockConfig
 429                     	xref	_CLK_LSICmd
 448                     	end
