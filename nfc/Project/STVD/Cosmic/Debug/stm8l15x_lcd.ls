   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.19 - 04 Sep 2013
   3                     ; Generator (Limited) V4.3.11 - 04 Sep 2013
  56                     ; 45 void LCD_DeInit(void)
  56                     ; 46 {
  58                     	switch	.text
  59  0000               _LCD_DeInit:
  61  0000 88            	push	a
  62       00000001      OFST:	set	1
  65                     ; 47   uint8_t counter = 0;
  67                     ; 49   LCD->CR1 = LCD_CR1_RESET_VALUE;
  69  0001 725f5400      	clr	21504
  70                     ; 50   LCD->CR2 = LCD_CR2_RESET_VALUE;
  72  0005 725f5401      	clr	21505
  73                     ; 51   LCD->CR3 = LCD_CR3_RESET_VALUE;
  75  0009 725f5402      	clr	21506
  76                     ; 52   LCD->FRQ = LCD_FRQ_RESET_VALUE;
  78  000d 725f5403      	clr	21507
  79                     ; 54   for (counter = 0;counter < 0x05; counter++)
  81  0011 0f01          	clr	(OFST+0,sp)
  82  0013               L72:
  83                     ; 56     LCD->PM[counter] = LCD_PM_RESET_VALUE;
  85  0013 7b01          	ld	a,(OFST+0,sp)
  86  0015 5f            	clrw	x
  87  0016 97            	ld	xl,a
  88  0017 724f5404      	clr	(21508,x)
  89                     ; 54   for (counter = 0;counter < 0x05; counter++)
  91  001b 0c01          	inc	(OFST+0,sp)
  94  001d 7b01          	ld	a,(OFST+0,sp)
  95  001f a105          	cp	a,#5
  96  0021 25f0          	jrult	L72
  97                     ; 59   for (counter = 0;counter < 0x16; counter++)
  99  0023 0f01          	clr	(OFST+0,sp)
 100  0025               L53:
 101                     ; 61     LCD->RAM[counter] =  LCD_RAM_RESET_VALUE;
 103  0025 7b01          	ld	a,(OFST+0,sp)
 104  0027 5f            	clrw	x
 105  0028 97            	ld	xl,a
 106  0029 724f540c      	clr	(21516,x)
 107                     ; 59   for (counter = 0;counter < 0x16; counter++)
 109  002d 0c01          	inc	(OFST+0,sp)
 112  002f 7b01          	ld	a,(OFST+0,sp)
 113  0031 a116          	cp	a,#22
 114  0033 25f0          	jrult	L53
 115                     ; 64   LCD->CR4 = LCD_CR4_RESET_VALUE;
 117  0035 725f542f      	clr	21551
 118                     ; 66 }
 121  0039 84            	pop	a
 122  003a 81            	ret
 525                     ; 77 void LCD_Init(LCD_Prescaler_TypeDef LCD_Prescaler, LCD_Divider_TypeDef LCD_Divider,
 525                     ; 78               LCD_Duty_TypeDef LCD_Duty, LCD_Bias_TypeDef LCD_Bias,
 525                     ; 79               LCD_VoltageSource_TypeDef LCD_VoltageSource)
 525                     ; 80 {
 526                     	switch	.text
 527  003b               _LCD_Init:
 529  003b 89            	pushw	x
 530       00000000      OFST:	set	0
 533                     ; 82   assert_param(IS_LCD_CLOCK_PRESCALER(LCD_Prescaler));
 535                     ; 83   assert_param(IS_LCD_CLOCK_DIVIDER(LCD_Divider));
 537                     ; 84   assert_param(IS_LCD_DUTY(LCD_Duty));
 539                     ; 85   assert_param(IS_LCD_BIAS(LCD_Bias));
 541                     ; 86   assert_param(IS_LCD_VOLTAGE_SOURCE(LCD_VoltageSource));
 543                     ; 88   LCD->FRQ &= (uint8_t)(~LCD_FRQ_PS);     /* Clear the prescaler bits */
 545  003c c65403        	ld	a,21507
 546  003f a40f          	and	a,#15
 547  0041 c75403        	ld	21507,a
 548                     ; 89   LCD->FRQ |= LCD_Prescaler;
 550  0044 9e            	ld	a,xh
 551  0045 ca5403        	or	a,21507
 552  0048 c75403        	ld	21507,a
 553                     ; 91   LCD->FRQ &= (uint8_t)(~LCD_FRQ_DIV);     /* Clear the divider bits */
 555  004b c65403        	ld	a,21507
 556  004e a4f0          	and	a,#240
 557  0050 c75403        	ld	21507,a
 558                     ; 92   LCD->FRQ |= LCD_Divider;
 560  0053 9f            	ld	a,xl
 561  0054 ca5403        	or	a,21507
 562  0057 c75403        	ld	21507,a
 563                     ; 95   LCD->CR1 &= (uint8_t)(~LCD_CR1_DUTY);    /* Clear the duty bits */
 565  005a c65400        	ld	a,21504
 566  005d a4f9          	and	a,#249
 567  005f c75400        	ld	21504,a
 568                     ; 96   LCD->CR4 &= (uint8_t)(~LCD_CR4_DUTY8);   /* Clear the DUTY8 bit */
 570  0062 7213542f      	bres	21551,#1
 571                     ; 98   if (LCD_Duty == LCD_Duty_1_8)
 573  0066 7b05          	ld	a,(OFST+5,sp)
 574  0068 a120          	cp	a,#32
 575  006a 260f          	jrne	L152
 576                     ; 100     LCD->CR4 |= (uint8_t)((uint8_t)((uint8_t)LCD_Duty & (uint8_t)0xF0) >> 4);
 578  006c 7b05          	ld	a,(OFST+5,sp)
 579  006e a4f0          	and	a,#240
 580  0070 4e            	swap	a
 581  0071 a40f          	and	a,#15
 582  0073 ca542f        	or	a,21551
 583  0076 c7542f        	ld	21551,a
 585  0079 200a          	jra	L352
 586  007b               L152:
 587                     ; 104     LCD->CR1 |= (uint8_t)((uint8_t)LCD_Duty & (uint8_t)0x0F);
 589  007b 7b05          	ld	a,(OFST+5,sp)
 590  007d a40f          	and	a,#15
 591  007f ca5400        	or	a,21504
 592  0082 c75400        	ld	21504,a
 593  0085               L352:
 594                     ; 108   LCD->CR1 &= (uint8_t)(~LCD_CR1_B2);      /* Clear the B2 bit */
 596  0085 72115400      	bres	21504,#0
 597                     ; 109   LCD->CR4 &= (uint8_t)(~LCD_CR4_B4);      /* Clear the B4 bit */
 599  0089 7211542f      	bres	21551,#0
 600                     ; 111   if (LCD_Bias == LCD_Bias_1_4)
 602  008d 7b06          	ld	a,(OFST+6,sp)
 603  008f a110          	cp	a,#16
 604  0091 2619          	jrne	L552
 605                     ; 113     LCD->CR1 |= (uint8_t)((uint8_t)LCD_Bias & (uint8_t)0x0F);
 607  0093 7b06          	ld	a,(OFST+6,sp)
 608  0095 a40f          	and	a,#15
 609  0097 ca5400        	or	a,21504
 610  009a c75400        	ld	21504,a
 611                     ; 114     LCD->CR4 |= (uint8_t)((uint8_t)((uint8_t)LCD_Bias & (uint8_t)0xF0) >> 4);
 613  009d 7b06          	ld	a,(OFST+6,sp)
 614  009f a4f0          	and	a,#240
 615  00a1 4e            	swap	a
 616  00a2 a40f          	and	a,#15
 617  00a4 ca542f        	or	a,21551
 618  00a7 c7542f        	ld	21551,a
 620  00aa 200a          	jra	L752
 621  00ac               L552:
 622                     ; 118     LCD->CR1 |= (uint8_t)((uint8_t)LCD_Bias & (uint8_t)0x0F);
 624  00ac 7b06          	ld	a,(OFST+6,sp)
 625  00ae a40f          	and	a,#15
 626  00b0 ca5400        	or	a,21504
 627  00b3 c75400        	ld	21504,a
 628  00b6               L752:
 629                     ; 121   LCD->CR2 &= (uint8_t)(~LCD_CR2_VSEL);    /* Clear the voltage source bit */
 631  00b6 72115401      	bres	21505,#0
 632                     ; 122   LCD->CR2 |= LCD_VoltageSource;
 634  00ba c65401        	ld	a,21505
 635  00bd 1a07          	or	a,(OFST+7,sp)
 636  00bf c75401        	ld	21505,a
 637                     ; 124 }
 640  00c2 85            	popw	x
 641  00c3 81            	ret
 696                     ; 132 void LCD_Cmd(FunctionalState NewState)
 696                     ; 133 {
 697                     	switch	.text
 698  00c4               _LCD_Cmd:
 702                     ; 135   assert_param(IS_FUNCTIONAL_STATE(NewState));
 704                     ; 137   if (NewState != DISABLE)
 706  00c4 4d            	tnz	a
 707  00c5 2706          	jreq	L703
 708                     ; 139     LCD->CR3 |= LCD_CR3_LCDEN; /* Enable the LCD peripheral*/
 710  00c7 721c5402      	bset	21506,#6
 712  00cb 2004          	jra	L113
 713  00cd               L703:
 714                     ; 143     LCD->CR3 &= (uint8_t)(~LCD_CR3_LCDEN); /* Disable the LCD peripheral*/
 716  00cd 721d5402      	bres	21506,#6
 717  00d1               L113:
 718                     ; 146 }
 721  00d1 81            	ret
 756                     ; 154 void LCD_ITConfig(FunctionalState NewState)
 756                     ; 155 {
 757                     	switch	.text
 758  00d2               _LCD_ITConfig:
 762                     ; 157   assert_param(IS_FUNCTIONAL_STATE(NewState));
 764                     ; 159   if (NewState != DISABLE)
 766  00d2 4d            	tnz	a
 767  00d3 2706          	jreq	L133
 768                     ; 161     LCD->CR3 |= LCD_CR3_SOFIE; /* Enable interrupt*/
 770  00d5 721a5402      	bset	21506,#5
 772  00d9 2004          	jra	L333
 773  00db               L133:
 774                     ; 165     LCD->CR3 &= (uint8_t)(~LCD_CR3_SOFIE); /* Disable interrupt*/
 776  00db 721b5402      	bres	21506,#5
 777  00df               L333:
 778                     ; 168 }
 781  00df 81            	ret
 816                     ; 175 void LCD_HighDriveCmd(FunctionalState NewState)
 816                     ; 176 {
 817                     	switch	.text
 818  00e0               _LCD_HighDriveCmd:
 822                     ; 178   assert_param(IS_FUNCTIONAL_STATE(NewState));
 824                     ; 180   if (NewState != DISABLE)
 826  00e0 4d            	tnz	a
 827  00e1 2706          	jreq	L353
 828                     ; 182     LCD->CR2 |= LCD_CR2_HD; /* Permanently enable low resistance divider */
 830  00e3 72185401      	bset	21505,#4
 832  00e7 2004          	jra	L553
 833  00e9               L353:
 834                     ; 186     LCD->CR2 &= (uint8_t)(~LCD_CR2_HD); /* Permanently disable low resistance divider */
 836  00e9 72195401      	bres	21505,#4
 837  00ed               L553:
 838                     ; 189 }
 841  00ed 81            	ret
 948                     ; 197 void LCD_PulseOnDurationConfig(LCD_PulseOnDuration_TypeDef LCD_PulseOnDuration)
 948                     ; 198 {
 949                     	switch	.text
 950  00ee               _LCD_PulseOnDurationConfig:
 952  00ee 88            	push	a
 953       00000000      OFST:	set	0
 956                     ; 200   assert_param(IS_LCD_PULSE_DURATION(LCD_PulseOnDuration));
 958                     ; 202   LCD->CR2 &= (uint8_t)(~LCD_CR2_PON); /* Clear the pulses on duration bits */
 960  00ef c65401        	ld	a,21505
 961  00f2 a41f          	and	a,#31
 962  00f4 c75401        	ld	21505,a
 963                     ; 203   LCD->CR2 |= LCD_PulseOnDuration;
 965  00f7 c65401        	ld	a,21505
 966  00fa 1a01          	or	a,(OFST+1,sp)
 967  00fc c75401        	ld	21505,a
 968                     ; 205 }
 971  00ff 84            	pop	a
 972  0100 81            	ret
1069                     ; 212 void LCD_DeadTimeConfig(LCD_DeadTime_TypeDef LCD_DeadTime)
1069                     ; 213 {
1070                     	switch	.text
1071  0101               _LCD_DeadTimeConfig:
1073  0101 88            	push	a
1074       00000000      OFST:	set	0
1077                     ; 215   assert_param(IS_LCD_DEAD_TIME(LCD_DeadTime));
1079                     ; 217   LCD->CR3 &= (uint8_t)(~LCD_CR3_DEAD);  /* Clear the dead time bits  */
1081  0102 c65402        	ld	a,21506
1082  0105 a4f8          	and	a,#248
1083  0107 c75402        	ld	21506,a
1084                     ; 219   LCD->CR3 |= LCD_DeadTime;
1086  010a c65402        	ld	a,21506
1087  010d 1a01          	or	a,(OFST+1,sp)
1088  010f c75402        	ld	21506,a
1089                     ; 221 }
1092  0112 84            	pop	a
1093  0113 81            	ret
1245                     ; 233 void LCD_BlinkConfig(LCD_BlinkMode_TypeDef LCD_BlinkMode,
1245                     ; 234                      LCD_BlinkFrequency_TypeDef LCD_BlinkFrequency)
1245                     ; 235 {
1246                     	switch	.text
1247  0114               _LCD_BlinkConfig:
1251                     ; 237   assert_param(IS_LCD_BLINK_MODE(LCD_BlinkMode));
1253                     ; 238   assert_param(IS_LCD_BLINK_FREQUENCY(LCD_BlinkFrequency));
1255                     ; 240   LCD->CR1 &= (uint8_t)(~LCD_CR1_BLINK); /* Clear the blink mode bits */
1257  0114 c65400        	ld	a,21504
1258  0117 a43f          	and	a,#63
1259  0119 c75400        	ld	21504,a
1260                     ; 241   LCD->CR1 |= LCD_BlinkMode; /* Config the LCD Blink Mode */
1262  011c 9e            	ld	a,xh
1263  011d ca5400        	or	a,21504
1264  0120 c75400        	ld	21504,a
1265                     ; 243   LCD->CR1 &= (uint8_t)(~LCD_CR1_BLINKF); /* Clear the blink frequency bits */
1267  0123 c65400        	ld	a,21504
1268  0126 a4c7          	and	a,#199
1269  0128 c75400        	ld	21504,a
1270                     ; 244   LCD->CR1 |= LCD_BlinkFrequency; /* Config the LCD Blink Frequency */
1272  012b 9f            	ld	a,xl
1273  012c ca5400        	or	a,21504
1274  012f c75400        	ld	21504,a
1275                     ; 246 }
1278  0132 81            	ret
1375                     ; 254 void LCD_ContrastConfig(LCD_Contrast_TypeDef LCD_Contrast)
1375                     ; 255 {
1376                     	switch	.text
1377  0133               _LCD_ContrastConfig:
1379  0133 88            	push	a
1380       00000000      OFST:	set	0
1383                     ; 257   assert_param(IS_LCD_CONTRAST(LCD_Contrast));
1385                     ; 259   LCD->CR2 &= (uint8_t)(~LCD_CR2_CC); /* Clear the contrast bits  */
1387  0134 c65401        	ld	a,21505
1388  0137 a4f1          	and	a,#241
1389  0139 c75401        	ld	21505,a
1390                     ; 260   LCD->CR2 |= LCD_Contrast; /* Select the maximum voltage value Vlcd */
1392  013c c65401        	ld	a,21505
1393  013f 1a01          	or	a,(OFST+1,sp)
1394  0141 c75401        	ld	21505,a
1395                     ; 262 }
1398  0144 84            	pop	a
1399  0145 81            	ret
1498                     ; 272 void LCD_PortMaskConfig(LCD_PortMaskRegister_TypeDef LCD_PortMaskRegister, uint8_t LCD_Mask)
1498                     ; 273 {
1499                     	switch	.text
1500  0146               _LCD_PortMaskConfig:
1502  0146 89            	pushw	x
1503       00000000      OFST:	set	0
1506                     ; 275   assert_param(IS_LCD_PORT_MASK(LCD_PortMaskRegister));
1508                     ; 278   LCD->PM[LCD_PortMaskRegister] =  LCD_Mask;
1510  0147 9e            	ld	a,xh
1511  0148 5f            	clrw	x
1512  0149 97            	ld	xl,a
1513  014a 7b02          	ld	a,(OFST+2,sp)
1514  014c d75404        	ld	(21508,x),a
1515                     ; 280 }
1518  014f 85            	popw	x
1519  0150 81            	ret
1723                     ; 290 void LCD_WriteRAM(LCD_RAMRegister_TypeDef LCD_RAMRegister, uint8_t LCD_Data)
1723                     ; 291 {
1724                     	switch	.text
1725  0151               _LCD_WriteRAM:
1727  0151 89            	pushw	x
1728       00000000      OFST:	set	0
1731                     ; 293   assert_param(IS_LCD_RAM_REGISTER(LCD_RAMRegister));
1733                     ; 296   LCD->RAM[LCD_RAMRegister] =  LCD_Data;
1735  0152 9e            	ld	a,xh
1736  0153 5f            	clrw	x
1737  0154 97            	ld	xl,a
1738  0155 7b02          	ld	a,(OFST+2,sp)
1739  0157 d7540c        	ld	(21516,x),a
1740                     ; 298 }
1743  015a 85            	popw	x
1744  015b 81            	ret
1801                     ; 307 void LCD_PageSelect(LCD_PageSelection_TypeDef LCD_PageSelection)
1801                     ; 308 {
1802                     	switch	.text
1803  015c               _LCD_PageSelect:
1807                     ; 310   assert_param(IS_LCD_PAGE_SELECT(LCD_PageSelection));
1809                     ; 312   LCD->CR4 &= (uint8_t)(~LCD_CR4_PAGECOM); /* Clear the PAGE COM bit */
1811  015c 7215542f      	bres	21551,#2
1812                     ; 313   LCD->CR4 |= LCD_PageSelection; /* Select the LCD page */
1814  0160 ca542f        	or	a,21551
1815  0163 c7542f        	ld	21551,a
1816                     ; 315 }
1819  0166 81            	ret
1875                     ; 321 FlagStatus LCD_GetFlagStatus(void)
1875                     ; 322 {
1876                     	switch	.text
1877  0167               _LCD_GetFlagStatus:
1879  0167 88            	push	a
1880       00000001      OFST:	set	1
1883                     ; 323   FlagStatus status = RESET;
1885                     ; 326   if ((LCD->CR3 & (uint8_t)LCD_CR3_SOF) != (uint8_t)RESET)
1887  0168 c65402        	ld	a,21506
1888  016b a510          	bcp	a,#16
1889  016d 2706          	jreq	L7201
1890                     ; 328     status = SET; /* Flag is set */
1892  016f a601          	ld	a,#1
1893  0171 6b01          	ld	(OFST+0,sp),a
1895  0173 2002          	jra	L1301
1896  0175               L7201:
1897                     ; 332     status = RESET; /* Flag is reset*/
1899  0175 0f01          	clr	(OFST+0,sp)
1900  0177               L1301:
1901                     ; 335   return status;
1903  0177 7b01          	ld	a,(OFST+0,sp)
1906  0179 5b01          	addw	sp,#1
1907  017b 81            	ret
1930                     ; 344 void LCD_ClearFlag(void)
1930                     ; 345 {
1931                     	switch	.text
1932  017c               _LCD_ClearFlag:
1936                     ; 347   LCD->CR3 |= (uint8_t)(LCD_CR3_SOFC);
1938  017c 72165402      	bset	21506,#3
1939                     ; 349 }
1942  0180 81            	ret
1987                     ; 356 ITStatus LCD_GetITStatus(void)
1987                     ; 357 {
1988                     	switch	.text
1989  0181               _LCD_GetITStatus:
1991  0181 88            	push	a
1992       00000001      OFST:	set	1
1995                     ; 358   ITStatus pendingbitstatus = RESET;
1997                     ; 359   uint8_t enablestatus = 0;
1999                     ; 361   enablestatus = (uint8_t)((uint8_t)LCD->CR3 & LCD_CR3_SOFIE);
2001  0182 c65402        	ld	a,21506
2002  0185 a420          	and	a,#32
2003  0187 6b01          	ld	(OFST+0,sp),a
2004                     ; 363   if (((LCD->CR3 & LCD_CR3_SOF) != RESET) && enablestatus)
2006  0189 c65402        	ld	a,21506
2007  018c a510          	bcp	a,#16
2008  018e 270a          	jreq	L5601
2010  0190 0d01          	tnz	(OFST+0,sp)
2011  0192 2706          	jreq	L5601
2012                     ; 366     pendingbitstatus = SET;
2014  0194 a601          	ld	a,#1
2015  0196 6b01          	ld	(OFST+0,sp),a
2017  0198 2002          	jra	L7601
2018  019a               L5601:
2019                     ; 371     pendingbitstatus = RESET;
2021  019a 0f01          	clr	(OFST+0,sp)
2022  019c               L7601:
2023                     ; 374   return  pendingbitstatus;
2025  019c 7b01          	ld	a,(OFST+0,sp)
2028  019e 5b01          	addw	sp,#1
2029  01a0 81            	ret
2053                     ; 383 void LCD_ClearITPendingBit(void)
2053                     ; 384 {
2054                     	switch	.text
2055  01a1               _LCD_ClearITPendingBit:
2059                     ; 386   LCD->CR3 |= (uint8_t)(LCD_CR3_SOFC);
2061  01a1 72165402      	bset	21506,#3
2062                     ; 388 }
2065  01a5 81            	ret
2078                     	xdef	_LCD_ClearITPendingBit
2079                     	xdef	_LCD_GetITStatus
2080                     	xdef	_LCD_ClearFlag
2081                     	xdef	_LCD_GetFlagStatus
2082                     	xdef	_LCD_PageSelect
2083                     	xdef	_LCD_WriteRAM
2084                     	xdef	_LCD_PortMaskConfig
2085                     	xdef	_LCD_BlinkConfig
2086                     	xdef	_LCD_ContrastConfig
2087                     	xdef	_LCD_DeadTimeConfig
2088                     	xdef	_LCD_PulseOnDurationConfig
2089                     	xdef	_LCD_HighDriveCmd
2090                     	xdef	_LCD_ITConfig
2091                     	xdef	_LCD_Cmd
2092                     	xdef	_LCD_Init
2093                     	xdef	_LCD_DeInit
2112                     	end
