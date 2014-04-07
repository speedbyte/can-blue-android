   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.19 - 04 Sep 2013
   3                     ; Generator (Limited) V4.3.11 - 04 Sep 2013
  17                     .const:	section	.text
  18  0000               _SYSDivFactor:
  19  0000 01            	dc.b	1
  20  0001 02            	dc.b	2
  21  0002 04            	dc.b	4
  22  0003 08            	dc.b	8
  23  0004 10            	dc.b	16
  52                     ; 60 void CLK_DeInit(void)
  52                     ; 61 {
  54                     	switch	.text
  55  0000               _CLK_DeInit:
  59                     ; 62   CLK->ICKCR = CLK_ICKCR_RESET_VALUE;
  61  0000 351150c2      	mov	20674,#17
  62                     ; 63   CLK->ECKCR = CLK_ECKCR_RESET_VALUE;
  64  0004 725f50c6      	clr	20678
  65                     ; 64   CLK->CRTCR = CLK_CRTCR_RESET_VALUE;
  67  0008 725f50c1      	clr	20673
  68                     ; 65   CLK->CBEEPR = CLK_CBEEPR_RESET_VALUE;
  70  000c 725f50cb      	clr	20683
  71                     ; 66   CLK->SWR  = CLK_SWR_RESET_VALUE;
  73  0010 350150c8      	mov	20680,#1
  74                     ; 67   CLK->SWCR = CLK_SWCR_RESET_VALUE;
  76  0014 725f50c9      	clr	20681
  77                     ; 68   CLK->CKDIVR = CLK_CKDIVR_RESET_VALUE;
  79  0018 350350c0      	mov	20672,#3
  80                     ; 69   CLK->PCKENR1 = CLK_PCKENR1_RESET_VALUE;
  82  001c 725f50c3      	clr	20675
  83                     ; 70   CLK->PCKENR2 = CLK_PCKENR2_RESET_VALUE;
  85  0020 358050c4      	mov	20676,#128
  86                     ; 71   CLK->PCKENR3 = CLK_PCKENR3_RESET_VALUE;
  88  0024 725f50d0      	clr	20688
  89                     ; 72   CLK->CSSR = CLK_CSSR_RESET_VALUE;
  91  0028 725f50ca      	clr	20682
  92                     ; 73   CLK->CCOR = CLK_CCOR_RESET_VALUE;
  94  002c 725f50c5      	clr	20677
  95                     ; 74   CLK->HSITRIMR = CLK_HSITRIMR_RESET_VALUE;
  97  0030 725f50cd      	clr	20685
  98                     ; 75   CLK->HSICALR = CLK_HSICALR_RESET_VALUE;
 100  0034 725f50cc      	clr	20684
 101                     ; 76   CLK->HSIUNLCKR = CLK_HSIUNLCKR_RESET_VALUE;
 103  0038 725f50ce      	clr	20686
 104                     ; 77   CLK->REGCSR = CLK_REGCSR_RESET_VALUE;
 106  003c 35b950cf      	mov	20687,#185
 107                     ; 78 }
 110  0040 81            	ret
 165                     ; 85 void CLK_HSICmd(FunctionalState NewState)
 165                     ; 86 {
 166                     	switch	.text
 167  0041               _CLK_HSICmd:
 171                     ; 89   assert_param(IS_FUNCTIONAL_STATE(NewState));
 173                     ; 91   if (NewState != DISABLE)
 175  0041 4d            	tnz	a
 176  0042 2706          	jreq	L74
 177                     ; 94     CLK->ICKCR |= CLK_ICKCR_HSION;
 179  0044 721050c2      	bset	20674,#0
 181  0048 2004          	jra	L15
 182  004a               L74:
 183                     ; 99     CLK->ICKCR &= (uint8_t)(~CLK_ICKCR_HSION);
 185  004a 721150c2      	bres	20674,#0
 186  004e               L15:
 187                     ; 101 }
 190  004e 81            	ret
 226                     ; 108 void CLK_AdjustHSICalibrationValue(uint8_t CLK_HSICalibrationValue)
 226                     ; 109 {
 227                     	switch	.text
 228  004f               _CLK_AdjustHSICalibrationValue:
 232                     ; 111   CLK->HSIUNLCKR = 0xAC;
 234  004f 35ac50ce      	mov	20686,#172
 235                     ; 112   CLK->HSIUNLCKR = 0x35;
 237  0053 353550ce      	mov	20686,#53
 238                     ; 115   CLK->HSITRIMR = (uint8_t)CLK_HSICalibrationValue;
 240  0057 c750cd        	ld	20685,a
 241                     ; 116 }
 244  005a 81            	ret
 279                     ; 123 void CLK_LSICmd(FunctionalState NewState)
 279                     ; 124 {
 280                     	switch	.text
 281  005b               _CLK_LSICmd:
 285                     ; 127   assert_param(IS_FUNCTIONAL_STATE(NewState));
 287                     ; 129   if (NewState != DISABLE)
 289  005b 4d            	tnz	a
 290  005c 2706          	jreq	L701
 291                     ; 132     CLK->ICKCR |= CLK_ICKCR_LSION;
 293  005e 721450c2      	bset	20674,#2
 295  0062 2004          	jra	L111
 296  0064               L701:
 297                     ; 137     CLK->ICKCR &= (uint8_t)(~CLK_ICKCR_LSION);
 299  0064 721550c2      	bres	20674,#2
 300  0068               L111:
 301                     ; 139 }
 304  0068 81            	ret
 366                     ; 149 void CLK_HSEConfig(CLK_HSE_TypeDef CLK_HSE)
 366                     ; 150 {
 367                     	switch	.text
 368  0069               _CLK_HSEConfig:
 372                     ; 152   assert_param(IS_CLK_HSE(CLK_HSE));
 374                     ; 156   CLK->ECKCR &= (uint8_t)~CLK_ECKCR_HSEON;
 376  0069 721150c6      	bres	20678,#0
 377                     ; 159   CLK->ECKCR &= (uint8_t)~CLK_ECKCR_HSEBYP;
 379  006d 721950c6      	bres	20678,#4
 380                     ; 162   CLK->ECKCR |= (uint8_t)CLK_HSE;
 382  0071 ca50c6        	or	a,20678
 383  0074 c750c6        	ld	20678,a
 384                     ; 163 }
 387  0077 81            	ret
 449                     ; 173 void CLK_LSEConfig(CLK_LSE_TypeDef CLK_LSE)
 449                     ; 174 {
 450                     	switch	.text
 451  0078               _CLK_LSEConfig:
 455                     ; 176   assert_param(IS_CLK_LSE(CLK_LSE));
 457                     ; 180   CLK->ECKCR &= (uint8_t)~CLK_ECKCR_LSEON;
 459  0078 721550c6      	bres	20678,#2
 460                     ; 183   CLK->ECKCR &= (uint8_t)~CLK_ECKCR_LSEBYP;
 462  007c 721b50c6      	bres	20678,#5
 463                     ; 186   CLK->ECKCR |= (uint8_t)CLK_LSE;
 465  0080 ca50c6        	or	a,20678
 466  0083 c750c6        	ld	20678,a
 467                     ; 188 }
 470  0086 81            	ret
 544                     ; 196 void CLK_SYSCLKSourceConfig(CLK_SYSCLKSource_TypeDef CLK_SYSCLKSource)
 544                     ; 197 {
 545                     	switch	.text
 546  0087               _CLK_SYSCLKSourceConfig:
 550                     ; 199   assert_param(IS_CLK_SOURCE(CLK_SYSCLKSource));
 552                     ; 202   CLK->SWR = (uint8_t)CLK_SYSCLKSource;
 554  0087 c750c8        	ld	20680,a
 555                     ; 203 }
 558  008a 81            	ret
 656                     ; 211 void CLK_SYSCLKDivConfig(CLK_SYSCLKDiv_TypeDef CLK_SYSCLKDiv)
 656                     ; 212 {
 657                     	switch	.text
 658  008b               _CLK_SYSCLKDivConfig:
 662                     ; 214   assert_param(IS_CLK_SYSTEM_DIVIDER(CLK_SYSCLKDiv));
 664                     ; 216   CLK->CKDIVR = (uint8_t)(CLK_SYSCLKDiv);
 666  008b c750c0        	ld	20672,a
 667                     ; 217 }
 670  008e 81            	ret
 706                     ; 223 void CLK_SYSCLKSourceSwitchCmd(FunctionalState NewState)
 706                     ; 224 {
 707                     	switch	.text
 708  008f               _CLK_SYSCLKSourceSwitchCmd:
 712                     ; 226   assert_param(IS_FUNCTIONAL_STATE(NewState));
 714                     ; 228   if (NewState != DISABLE)
 716  008f 4d            	tnz	a
 717  0090 2706          	jreq	L503
 718                     ; 231     CLK->SWCR |= CLK_SWCR_SWEN;
 720  0092 721250c9      	bset	20681,#1
 722  0096 2004          	jra	L703
 723  0098               L503:
 724                     ; 236     CLK->SWCR &= (uint8_t)(~CLK_SWCR_SWEN);
 726  0098 721350c9      	bres	20681,#1
 727  009c               L703:
 728                     ; 238 }
 731  009c 81            	ret
 756                     ; 250 CLK_SYSCLKSource_TypeDef CLK_GetSYSCLKSource(void)
 756                     ; 251 {
 757                     	switch	.text
 758  009d               _CLK_GetSYSCLKSource:
 762                     ; 252   return ((CLK_SYSCLKSource_TypeDef)(CLK->SCSR));
 764  009d c650c7        	ld	a,20679
 767  00a0 81            	ret
 791                     ; 261 void CLK_ClockSecuritySystemEnable(void)
 791                     ; 262 {
 792                     	switch	.text
 793  00a1               _CLK_ClockSecuritySystemEnable:
 797                     ; 264   CLK->CSSR |= CLK_CSSR_CSSEN;
 799  00a1 721050ca      	bset	20682,#0
 800                     ; 265 }
 803  00a5 81            	ret
 839                     ; 272 void CLK_ClockSecuritySytemDeglitchCmd(FunctionalState NewState)
 839                     ; 273 {
 840                     	switch	.text
 841  00a6               _CLK_ClockSecuritySytemDeglitchCmd:
 845                     ; 275   assert_param(IS_FUNCTIONAL_STATE(NewState));
 847                     ; 277   if (NewState != DISABLE)
 849  00a6 4d            	tnz	a
 850  00a7 2706          	jreq	L743
 851                     ; 280     CLK->CSSR |= CLK_CSSR_CSSDGON;
 853  00a9 721850ca      	bset	20682,#4
 855  00ad 2004          	jra	L153
 856  00af               L743:
 857                     ; 285     CLK->CSSR &= (uint8_t)(~CLK_CSSR_CSSDGON);
 859  00af 721950ca      	bres	20682,#4
 860  00b3               L153:
 861                     ; 287 }
 864  00b3 81            	ret
 936                     ; 293 uint32_t CLK_GetClockFreq(void)
 936                     ; 294 {
 937                     	switch	.text
 938  00b4               _CLK_GetClockFreq:
 940  00b4 5209          	subw	sp,#9
 941       00000009      OFST:	set	9
 944                     ; 295   uint32_t clockfrequency = 0;
 946                     ; 296   uint32_t sourcefrequency = 0;
 948  00b6 ae0000        	ldw	x,#0
 949  00b9 1f07          	ldw	(OFST-2,sp),x
 950  00bb ae0000        	ldw	x,#0
 951  00be 1f05          	ldw	(OFST-4,sp),x
 952                     ; 297   CLK_SYSCLKSource_TypeDef clocksource = CLK_SYSCLKSource_HSI;
 954                     ; 298   uint8_t tmp = 0, presc = 0;
 958                     ; 301   clocksource = (CLK_SYSCLKSource_TypeDef)CLK->SCSR;
 960  00c0 c650c7        	ld	a,20679
 961  00c3 6b09          	ld	(OFST+0,sp),a
 962                     ; 303   if ( clocksource == CLK_SYSCLKSource_HSI)
 964  00c5 7b09          	ld	a,(OFST+0,sp)
 965  00c7 a101          	cp	a,#1
 966  00c9 260c          	jrne	L114
 967                     ; 305     sourcefrequency = HSI_VALUE;
 969  00cb ae2400        	ldw	x,#9216
 970  00ce 1f07          	ldw	(OFST-2,sp),x
 971  00d0 ae00f4        	ldw	x,#244
 972  00d3 1f05          	ldw	(OFST-4,sp),x
 974  00d5 2022          	jra	L314
 975  00d7               L114:
 976                     ; 307   else if ( clocksource == CLK_SYSCLKSource_LSI)
 978  00d7 7b09          	ld	a,(OFST+0,sp)
 979  00d9 a102          	cp	a,#2
 980  00db 260c          	jrne	L514
 981                     ; 309     sourcefrequency = LSI_VALUE;
 983  00dd ae9470        	ldw	x,#38000
 984  00e0 1f07          	ldw	(OFST-2,sp),x
 985  00e2 ae0000        	ldw	x,#0
 986  00e5 1f05          	ldw	(OFST-4,sp),x
 988  00e7 2010          	jra	L314
 989  00e9               L514:
 990                     ; 311   else if ( clocksource == CLK_SYSCLKSource_HSE)
 992  00e9 7b09          	ld	a,(OFST+0,sp)
 993  00eb a104          	cp	a,#4
 994  00ed 260a          	jrne	L124
 995                     ; 313     sourcefrequency = HSE_VALUE;
 997  00ef ae0900        	ldw	x,#2304
 998  00f2 1f07          	ldw	(OFST-2,sp),x
 999  00f4 ae003d        	ldw	x,#61
1000  00f7 1f05          	ldw	(OFST-4,sp),x
1002  00f9               L124:
1003                     ; 317     clockfrequency = LSE_VALUE;
1005  00f9               L314:
1006                     ; 321   tmp = (uint8_t)(CLK->CKDIVR & CLK_CKDIVR_CKM);
1008  00f9 c650c0        	ld	a,20672
1009  00fc a407          	and	a,#7
1010  00fe 6b09          	ld	(OFST+0,sp),a
1011                     ; 322   presc = SYSDivFactor[tmp];
1013  0100 7b09          	ld	a,(OFST+0,sp)
1014  0102 5f            	clrw	x
1015  0103 97            	ld	xl,a
1016  0104 d60000        	ld	a,(_SYSDivFactor,x)
1017  0107 6b09          	ld	(OFST+0,sp),a
1018                     ; 325   clockfrequency = sourcefrequency / presc;
1020  0109 7b09          	ld	a,(OFST+0,sp)
1021  010b b703          	ld	c_lreg+3,a
1022  010d 3f02          	clr	c_lreg+2
1023  010f 3f01          	clr	c_lreg+1
1024  0111 3f00          	clr	c_lreg
1025  0113 96            	ldw	x,sp
1026  0114 1c0001        	addw	x,#OFST-8
1027  0117 cd0000        	call	c_rtol
1029  011a 96            	ldw	x,sp
1030  011b 1c0005        	addw	x,#OFST-4
1031  011e cd0000        	call	c_ltor
1033  0121 96            	ldw	x,sp
1034  0122 1c0001        	addw	x,#OFST-8
1035  0125 cd0000        	call	c_ludv
1037  0128 96            	ldw	x,sp
1038  0129 1c0005        	addw	x,#OFST-4
1039  012c cd0000        	call	c_rtol
1041                     ; 327   return((uint32_t)clockfrequency);
1043  012f 96            	ldw	x,sp
1044  0130 1c0005        	addw	x,#OFST-4
1045  0133 cd0000        	call	c_ltor
1049  0136 5b09          	addw	sp,#9
1050  0138 81            	ret
1122                     ; 338 void CLK_ITConfig(CLK_IT_TypeDef CLK_IT, FunctionalState NewState)
1122                     ; 339 {
1123                     	switch	.text
1124  0139               _CLK_ITConfig:
1126  0139 89            	pushw	x
1127       00000000      OFST:	set	0
1130                     ; 342   assert_param(IS_CLK_IT(CLK_IT));
1132                     ; 343   assert_param(IS_FUNCTIONAL_STATE(NewState));
1134                     ; 345   if (NewState != DISABLE)
1136  013a 9f            	ld	a,xl
1137  013b 4d            	tnz	a
1138  013c 271d          	jreq	L164
1139                     ; 347     if (CLK_IT == CLK_IT_SWIF)
1141  013e 9e            	ld	a,xh
1142  013f a11c          	cp	a,#28
1143  0141 2606          	jrne	L364
1144                     ; 350       CLK->SWCR |= CLK_SWCR_SWIEN;
1146  0143 721450c9      	bset	20681,#2
1148  0147 202e          	jra	L374
1149  0149               L364:
1150                     ; 352     else if (CLK_IT == CLK_IT_LSECSSF)
1152  0149 7b01          	ld	a,(OFST+1,sp)
1153  014b a12c          	cp	a,#44
1154  014d 2606          	jrne	L764
1155                     ; 355       CSSLSE->CSR |= CSSLSE_CSR_CSSIE;
1157  014f 72145190      	bset	20880,#2
1159  0153 2022          	jra	L374
1160  0155               L764:
1161                     ; 360       CLK->CSSR |= CLK_CSSR_CSSDIE;
1163  0155 721450ca      	bset	20682,#2
1164  0159 201c          	jra	L374
1165  015b               L164:
1166                     ; 365     if (CLK_IT == CLK_IT_SWIF)
1168  015b 7b01          	ld	a,(OFST+1,sp)
1169  015d a11c          	cp	a,#28
1170  015f 2606          	jrne	L574
1171                     ; 368       CLK->SWCR  &= (uint8_t)(~CLK_SWCR_SWIEN);
1173  0161 721550c9      	bres	20681,#2
1175  0165 2010          	jra	L374
1176  0167               L574:
1177                     ; 370     else if (CLK_IT == CLK_IT_LSECSSF)
1179  0167 7b01          	ld	a,(OFST+1,sp)
1180  0169 a12c          	cp	a,#44
1181  016b 2606          	jrne	L105
1182                     ; 373       CSSLSE->CSR &= (uint8_t)(~CSSLSE_CSR_CSSIE);
1184  016d 72155190      	bres	20880,#2
1186  0171 2004          	jra	L374
1187  0173               L105:
1188                     ; 378       CLK->CSSR &= (uint8_t)(~CLK_CSSR_CSSDIE);
1190  0173 721550ca      	bres	20682,#2
1191  0177               L374:
1192                     ; 381 }
1195  0177 85            	popw	x
1196  0178 81            	ret
1337                     ; 391 void CLK_CCOConfig(CLK_CCOSource_TypeDef CLK_CCOSource, CLK_CCODiv_TypeDef CLK_CCODiv)
1337                     ; 392 {
1338                     	switch	.text
1339  0179               _CLK_CCOConfig:
1341  0179 89            	pushw	x
1342       00000000      OFST:	set	0
1345                     ; 394   assert_param(IS_CLK_OUTPUT(CLK_CCOSource));
1347                     ; 395   assert_param(IS_CLK_OUTPUT_DIVIDER(CLK_CCODiv));
1349                     ; 398   CLK->CCOR = (uint8_t)((uint8_t)CLK_CCOSource | (uint8_t)CLK_CCODiv);
1351  017a 9f            	ld	a,xl
1352  017b 1a01          	or	a,(OFST+1,sp)
1353  017d c750c5        	ld	20677,a
1354                     ; 399 }
1357  0180 85            	popw	x
1358  0181 81            	ret
1504                     ; 409 void CLK_RTCClockConfig(CLK_RTCCLKSource_TypeDef CLK_RTCCLKSource, CLK_RTCCLKDiv_TypeDef CLK_RTCCLKDiv)
1504                     ; 410 {
1505                     	switch	.text
1506  0182               _CLK_RTCClockConfig:
1508  0182 89            	pushw	x
1509       00000000      OFST:	set	0
1512                     ; 412   assert_param(IS_CLK_CLOCK_RTC(CLK_RTCCLKSource));
1514                     ; 413   assert_param(IS_CLK_CLOCK_RTC_DIV(CLK_RTCCLKDiv));
1516                     ; 416   CLK->CRTCR = (uint8_t)((uint8_t)CLK_RTCCLKSource | (uint8_t)CLK_RTCCLKDiv);
1518  0183 9f            	ld	a,xl
1519  0184 1a01          	or	a,(OFST+1,sp)
1520  0186 c750c1        	ld	20673,a
1521                     ; 417 }
1524  0189 85            	popw	x
1525  018a 81            	ret
1591                     ; 425 void CLK_BEEPClockConfig(CLK_BEEPCLKSource_TypeDef CLK_BEEPCLKSource)
1591                     ; 426 {
1592                     	switch	.text
1593  018b               _CLK_BEEPClockConfig:
1597                     ; 428   assert_param(IS_CLK_CLOCK_BEEP(CLK_BEEPCLKSource));
1599                     ; 431   CLK->CBEEPR = (uint8_t)(CLK_BEEPCLKSource);
1601  018b c750cb        	ld	20683,a
1602                     ; 433 }
1605  018e 81            	ret
1830                     ; 443 void CLK_PeripheralClockConfig(CLK_Peripheral_TypeDef CLK_Peripheral, FunctionalState NewState)
1830                     ; 444 {
1831                     	switch	.text
1832  018f               _CLK_PeripheralClockConfig:
1834  018f 89            	pushw	x
1835  0190 88            	push	a
1836       00000001      OFST:	set	1
1839                     ; 445   uint8_t reg = 0;
1841                     ; 448   assert_param(IS_CLK_PERIPHERAL(CLK_Peripheral));
1843                     ; 449   assert_param(IS_FUNCTIONAL_STATE(NewState));
1845                     ; 452   reg = (uint8_t)((uint8_t)CLK_Peripheral & (uint8_t)0xF0);
1847  0191 9e            	ld	a,xh
1848  0192 a4f0          	and	a,#240
1849  0194 6b01          	ld	(OFST+0,sp),a
1850                     ; 454   if ( reg == 0x00)
1852  0196 0d01          	tnz	(OFST+0,sp)
1853  0198 2635          	jrne	L5001
1854                     ; 456     if (NewState != DISABLE)
1856  019a 0d03          	tnz	(OFST+2,sp)
1857  019c 2719          	jreq	L7001
1858                     ; 459       CLK->PCKENR1 |= (uint8_t)((uint8_t)1 << ((uint8_t)CLK_Peripheral & (uint8_t)0x0F));
1860  019e 7b02          	ld	a,(OFST+1,sp)
1861  01a0 a40f          	and	a,#15
1862  01a2 5f            	clrw	x
1863  01a3 97            	ld	xl,a
1864  01a4 a601          	ld	a,#1
1865  01a6 5d            	tnzw	x
1866  01a7 2704          	jreq	L05
1867  01a9               L25:
1868  01a9 48            	sll	a
1869  01aa 5a            	decw	x
1870  01ab 26fc          	jrne	L25
1871  01ad               L05:
1872  01ad ca50c3        	or	a,20675
1873  01b0 c750c3        	ld	20675,a
1875  01b3 ac390239      	jpf	L3101
1876  01b7               L7001:
1877                     ; 464       CLK->PCKENR1 &= (uint8_t)(~(uint8_t)(((uint8_t)1 << ((uint8_t)CLK_Peripheral & (uint8_t)0x0F))));
1879  01b7 7b02          	ld	a,(OFST+1,sp)
1880  01b9 a40f          	and	a,#15
1881  01bb 5f            	clrw	x
1882  01bc 97            	ld	xl,a
1883  01bd a601          	ld	a,#1
1884  01bf 5d            	tnzw	x
1885  01c0 2704          	jreq	L45
1886  01c2               L65:
1887  01c2 48            	sll	a
1888  01c3 5a            	decw	x
1889  01c4 26fc          	jrne	L65
1890  01c6               L45:
1891  01c6 43            	cpl	a
1892  01c7 c450c3        	and	a,20675
1893  01ca c750c3        	ld	20675,a
1894  01cd 206a          	jra	L3101
1895  01cf               L5001:
1896                     ; 467   else if (reg == 0x10)
1898  01cf 7b01          	ld	a,(OFST+0,sp)
1899  01d1 a110          	cp	a,#16
1900  01d3 2633          	jrne	L5101
1901                     ; 469     if (NewState != DISABLE)
1903  01d5 0d03          	tnz	(OFST+2,sp)
1904  01d7 2717          	jreq	L7101
1905                     ; 472       CLK->PCKENR2 |= (uint8_t)((uint8_t)1 << ((uint8_t)CLK_Peripheral & (uint8_t)0x0F));
1907  01d9 7b02          	ld	a,(OFST+1,sp)
1908  01db a40f          	and	a,#15
1909  01dd 5f            	clrw	x
1910  01de 97            	ld	xl,a
1911  01df a601          	ld	a,#1
1912  01e1 5d            	tnzw	x
1913  01e2 2704          	jreq	L06
1914  01e4               L26:
1915  01e4 48            	sll	a
1916  01e5 5a            	decw	x
1917  01e6 26fc          	jrne	L26
1918  01e8               L06:
1919  01e8 ca50c4        	or	a,20676
1920  01eb c750c4        	ld	20676,a
1922  01ee 2049          	jra	L3101
1923  01f0               L7101:
1924                     ; 477       CLK->PCKENR2 &= (uint8_t)(~(uint8_t)(((uint8_t)1 << ((uint8_t)CLK_Peripheral & (uint8_t)0x0F))));
1926  01f0 7b02          	ld	a,(OFST+1,sp)
1927  01f2 a40f          	and	a,#15
1928  01f4 5f            	clrw	x
1929  01f5 97            	ld	xl,a
1930  01f6 a601          	ld	a,#1
1931  01f8 5d            	tnzw	x
1932  01f9 2704          	jreq	L46
1933  01fb               L66:
1934  01fb 48            	sll	a
1935  01fc 5a            	decw	x
1936  01fd 26fc          	jrne	L66
1937  01ff               L46:
1938  01ff 43            	cpl	a
1939  0200 c450c4        	and	a,20676
1940  0203 c750c4        	ld	20676,a
1941  0206 2031          	jra	L3101
1942  0208               L5101:
1943                     ; 482     if (NewState != DISABLE)
1945  0208 0d03          	tnz	(OFST+2,sp)
1946  020a 2717          	jreq	L5201
1947                     ; 485       CLK->PCKENR3 |= (uint8_t)((uint8_t)1 << ((uint8_t)CLK_Peripheral & (uint8_t)0x0F));
1949  020c 7b02          	ld	a,(OFST+1,sp)
1950  020e a40f          	and	a,#15
1951  0210 5f            	clrw	x
1952  0211 97            	ld	xl,a
1953  0212 a601          	ld	a,#1
1954  0214 5d            	tnzw	x
1955  0215 2704          	jreq	L07
1956  0217               L27:
1957  0217 48            	sll	a
1958  0218 5a            	decw	x
1959  0219 26fc          	jrne	L27
1960  021b               L07:
1961  021b ca50d0        	or	a,20688
1962  021e c750d0        	ld	20688,a
1964  0221 2016          	jra	L3101
1965  0223               L5201:
1966                     ; 490       CLK->PCKENR3 &= (uint8_t)(~(uint8_t)(((uint8_t)1 << ((uint8_t)CLK_Peripheral & (uint8_t)0x0F))));
1968  0223 7b02          	ld	a,(OFST+1,sp)
1969  0225 a40f          	and	a,#15
1970  0227 5f            	clrw	x
1971  0228 97            	ld	xl,a
1972  0229 a601          	ld	a,#1
1973  022b 5d            	tnzw	x
1974  022c 2704          	jreq	L47
1975  022e               L67:
1976  022e 48            	sll	a
1977  022f 5a            	decw	x
1978  0230 26fc          	jrne	L67
1979  0232               L47:
1980  0232 43            	cpl	a
1981  0233 c450d0        	and	a,20688
1982  0236 c750d0        	ld	20688,a
1983  0239               L3101:
1984                     ; 493 }
1987  0239 5b03          	addw	sp,#3
1988  023b 81            	ret
2063                     ; 503 void CLK_HaltConfig(CLK_Halt_TypeDef CLK_Halt, FunctionalState NewState)
2063                     ; 504 {
2064                     	switch	.text
2065  023c               _CLK_HaltConfig:
2067  023c 89            	pushw	x
2068       00000000      OFST:	set	0
2071                     ; 506   assert_param(IS_CLK_HALT(CLK_Halt));
2073                     ; 507   assert_param(IS_FUNCTIONAL_STATE(NewState));
2075                     ; 509   if (NewState != DISABLE)
2077  023d 9f            	ld	a,xl
2078  023e 4d            	tnz	a
2079  023f 2709          	jreq	L5601
2080                     ; 511     CLK->ICKCR |= (uint8_t)(CLK_Halt);
2082  0241 9e            	ld	a,xh
2083  0242 ca50c2        	or	a,20674
2084  0245 c750c2        	ld	20674,a
2086  0248 2009          	jra	L7601
2087  024a               L5601:
2088                     ; 515     CLK->ICKCR &= (uint8_t)(~CLK_Halt);
2090  024a 7b01          	ld	a,(OFST+1,sp)
2091  024c 43            	cpl	a
2092  024d c450c2        	and	a,20674
2093  0250 c750c2        	ld	20674,a
2094  0253               L7601:
2095                     ; 517 }
2098  0253 85            	popw	x
2099  0254 81            	ret
2135                     ; 527 void CLK_MainRegulatorCmd(FunctionalState NewState)
2135                     ; 528 {
2136                     	switch	.text
2137  0255               _CLK_MainRegulatorCmd:
2141                     ; 530   assert_param(IS_FUNCTIONAL_STATE(NewState));
2143                     ; 532   if (NewState != DISABLE)
2145  0255 4d            	tnz	a
2146  0256 2706          	jreq	L7011
2147                     ; 535     CLK->REGCSR &= (uint8_t)(~CLK_REGCSR_REGOFF);
2149  0258 721350cf      	bres	20687,#1
2151  025c 2004          	jra	L1111
2152  025e               L7011:
2153                     ; 540     CLK->REGCSR |= CLK_REGCSR_REGOFF;
2155  025e 721250cf      	bset	20687,#1
2156  0262               L1111:
2157                     ; 542 }
2160  0262 81            	ret
2383                     ; 549 FlagStatus CLK_GetFlagStatus(CLK_FLAG_TypeDef CLK_FLAG)
2383                     ; 550 {
2384                     	switch	.text
2385  0263               _CLK_GetFlagStatus:
2387  0263 88            	push	a
2388  0264 89            	pushw	x
2389       00000002      OFST:	set	2
2392                     ; 551   uint8_t reg = 0;
2394                     ; 552   uint8_t pos = 0;
2396                     ; 553   FlagStatus bitstatus = RESET;
2398                     ; 556   assert_param(IS_CLK_FLAGS(CLK_FLAG));
2400                     ; 559   reg = (uint8_t)((uint8_t)CLK_FLAG & (uint8_t)0xF0);
2402  0265 a4f0          	and	a,#240
2403  0267 6b02          	ld	(OFST+0,sp),a
2404                     ; 562   pos = (uint8_t)((uint8_t)CLK_FLAG & (uint8_t)0x0F);
2406  0269 7b03          	ld	a,(OFST+1,sp)
2407  026b a40f          	and	a,#15
2408  026d 6b01          	ld	(OFST-1,sp),a
2409                     ; 564   if (reg == 0x00) /* The flag to check is in CRTC Rregister */
2411  026f 0d02          	tnz	(OFST+0,sp)
2412  0271 2607          	jrne	L7221
2413                     ; 566     reg = CLK->CRTCR;
2415  0273 c650c1        	ld	a,20673
2416  0276 6b02          	ld	(OFST+0,sp),a
2418  0278 2060          	jra	L1321
2419  027a               L7221:
2420                     ; 568   else if (reg == 0x10) /* The flag to check is in ICKCR register */
2422  027a 7b02          	ld	a,(OFST+0,sp)
2423  027c a110          	cp	a,#16
2424  027e 2607          	jrne	L3321
2425                     ; 570     reg = CLK->ICKCR;
2427  0280 c650c2        	ld	a,20674
2428  0283 6b02          	ld	(OFST+0,sp),a
2430  0285 2053          	jra	L1321
2431  0287               L3321:
2432                     ; 572   else if (reg == 0x20) /* The flag to check is in CCOR register */
2434  0287 7b02          	ld	a,(OFST+0,sp)
2435  0289 a120          	cp	a,#32
2436  028b 2607          	jrne	L7321
2437                     ; 574     reg = CLK->CCOR;
2439  028d c650c5        	ld	a,20677
2440  0290 6b02          	ld	(OFST+0,sp),a
2442  0292 2046          	jra	L1321
2443  0294               L7321:
2444                     ; 576   else if (reg == 0x30) /* The flag to check is in ECKCR register */
2446  0294 7b02          	ld	a,(OFST+0,sp)
2447  0296 a130          	cp	a,#48
2448  0298 2607          	jrne	L3421
2449                     ; 578     reg = CLK->ECKCR;
2451  029a c650c6        	ld	a,20678
2452  029d 6b02          	ld	(OFST+0,sp),a
2454  029f 2039          	jra	L1321
2455  02a1               L3421:
2456                     ; 580   else if (reg == 0x40) /* The flag to check is in SWCR register */
2458  02a1 7b02          	ld	a,(OFST+0,sp)
2459  02a3 a140          	cp	a,#64
2460  02a5 2607          	jrne	L7421
2461                     ; 582     reg = CLK->SWCR;
2463  02a7 c650c9        	ld	a,20681
2464  02aa 6b02          	ld	(OFST+0,sp),a
2466  02ac 202c          	jra	L1321
2467  02ae               L7421:
2468                     ; 584   else if (reg == 0x50) /* The flag to check is in CSSR register */
2470  02ae 7b02          	ld	a,(OFST+0,sp)
2471  02b0 a150          	cp	a,#80
2472  02b2 2607          	jrne	L3521
2473                     ; 586     reg = CLK->CSSR;
2475  02b4 c650ca        	ld	a,20682
2476  02b7 6b02          	ld	(OFST+0,sp),a
2478  02b9 201f          	jra	L1321
2479  02bb               L3521:
2480                     ; 588   else if (reg == 0x70) /* The flag to check is in REGCSR register */
2482  02bb 7b02          	ld	a,(OFST+0,sp)
2483  02bd a170          	cp	a,#112
2484  02bf 2607          	jrne	L7521
2485                     ; 590     reg = CLK->REGCSR;
2487  02c1 c650cf        	ld	a,20687
2488  02c4 6b02          	ld	(OFST+0,sp),a
2490  02c6 2012          	jra	L1321
2491  02c8               L7521:
2492                     ; 592   else if (reg == 0x80) /* The flag to check is in CSSLSE_CSRregister */
2494  02c8 7b02          	ld	a,(OFST+0,sp)
2495  02ca a180          	cp	a,#128
2496  02cc 2607          	jrne	L3621
2497                     ; 594     reg = CSSLSE->CSR;
2499  02ce c65190        	ld	a,20880
2500  02d1 6b02          	ld	(OFST+0,sp),a
2502  02d3 2005          	jra	L1321
2503  02d5               L3621:
2504                     ; 598     reg = CLK->CBEEPR;
2506  02d5 c650cb        	ld	a,20683
2507  02d8 6b02          	ld	(OFST+0,sp),a
2508  02da               L1321:
2509                     ; 602   if ((reg & (uint8_t)((uint8_t)1 << (uint8_t)pos)) != (uint8_t)RESET)
2511  02da 7b01          	ld	a,(OFST-1,sp)
2512  02dc 5f            	clrw	x
2513  02dd 97            	ld	xl,a
2514  02de a601          	ld	a,#1
2515  02e0 5d            	tnzw	x
2516  02e1 2704          	jreq	L601
2517  02e3               L011:
2518  02e3 48            	sll	a
2519  02e4 5a            	decw	x
2520  02e5 26fc          	jrne	L011
2521  02e7               L601:
2522  02e7 1402          	and	a,(OFST+0,sp)
2523  02e9 2706          	jreq	L7621
2524                     ; 604     bitstatus = SET;
2526  02eb a601          	ld	a,#1
2527  02ed 6b02          	ld	(OFST+0,sp),a
2529  02ef 2002          	jra	L1721
2530  02f1               L7621:
2531                     ; 608     bitstatus = RESET;
2533  02f1 0f02          	clr	(OFST+0,sp)
2534  02f3               L1721:
2535                     ; 612   return((FlagStatus)bitstatus);
2537  02f3 7b02          	ld	a,(OFST+0,sp)
2540  02f5 5b03          	addw	sp,#3
2541  02f7 81            	ret
2564                     ; 620 void CLK_ClearFlag(void)
2564                     ; 621 {
2565                     	switch	.text
2566  02f8               _CLK_ClearFlag:
2570                     ; 624   CSSLSE->CSR &= (uint8_t)(~CSSLSE_CSR_CSSF);
2572  02f8 72175190      	bres	20880,#3
2573                     ; 625 }
2576  02fc 81            	ret
2622                     ; 633 ITStatus CLK_GetITStatus(CLK_IT_TypeDef CLK_IT)
2622                     ; 634 {
2623                     	switch	.text
2624  02fd               _CLK_GetITStatus:
2626  02fd 88            	push	a
2627  02fe 88            	push	a
2628       00000001      OFST:	set	1
2631                     ; 636   ITStatus bitstatus = RESET;
2633                     ; 639   assert_param(IS_CLK_IT(CLK_IT));
2635                     ; 641   if (CLK_IT == CLK_IT_SWIF)
2637  02ff a11c          	cp	a,#28
2638  0301 2611          	jrne	L5231
2639                     ; 644     if ((CLK->SWCR & (uint8_t)CLK_IT) == (uint8_t)0x0C)
2641  0303 c450c9        	and	a,20681
2642  0306 a10c          	cp	a,#12
2643  0308 2606          	jrne	L7231
2644                     ; 646       bitstatus = SET;
2646  030a a601          	ld	a,#1
2647  030c 6b01          	ld	(OFST+0,sp),a
2649  030e 202e          	jra	L3331
2650  0310               L7231:
2651                     ; 650       bitstatus = RESET;
2653  0310 0f01          	clr	(OFST+0,sp)
2654  0312 202a          	jra	L3331
2655  0314               L5231:
2656                     ; 653   else if (CLK_IT == CLK_IT_LSECSSF)
2658  0314 7b02          	ld	a,(OFST+1,sp)
2659  0316 a12c          	cp	a,#44
2660  0318 2613          	jrne	L5331
2661                     ; 656     if ((CSSLSE->CSR & (uint8_t)CLK_IT) == (uint8_t)0x0C)
2663  031a c65190        	ld	a,20880
2664  031d 1402          	and	a,(OFST+1,sp)
2665  031f a10c          	cp	a,#12
2666  0321 2606          	jrne	L7331
2667                     ; 658       bitstatus = SET;
2669  0323 a601          	ld	a,#1
2670  0325 6b01          	ld	(OFST+0,sp),a
2672  0327 2015          	jra	L3331
2673  0329               L7331:
2674                     ; 662       bitstatus = RESET;
2676  0329 0f01          	clr	(OFST+0,sp)
2677  032b 2011          	jra	L3331
2678  032d               L5331:
2679                     ; 668     if ((CLK->CSSR & (uint8_t)CLK_IT) == (uint8_t)0x0C)
2681  032d c650ca        	ld	a,20682
2682  0330 1402          	and	a,(OFST+1,sp)
2683  0332 a10c          	cp	a,#12
2684  0334 2606          	jrne	L5431
2685                     ; 670       bitstatus = SET;
2687  0336 a601          	ld	a,#1
2688  0338 6b01          	ld	(OFST+0,sp),a
2690  033a 2002          	jra	L3331
2691  033c               L5431:
2692                     ; 674       bitstatus = RESET;
2694  033c 0f01          	clr	(OFST+0,sp)
2695  033e               L3331:
2696                     ; 679   return bitstatus;
2698  033e 7b01          	ld	a,(OFST+0,sp)
2701  0340 85            	popw	x
2702  0341 81            	ret
2738                     ; 689 void CLK_ClearITPendingBit(CLK_IT_TypeDef CLK_IT)
2738                     ; 690 {
2739                     	switch	.text
2740  0342               _CLK_ClearITPendingBit:
2744                     ; 693   assert_param(IS_CLK_CLEAR_IT(CLK_IT));
2746                     ; 695   if ((uint8_t)((uint8_t)CLK_IT & (uint8_t)0xF0) == (uint8_t)0x20)
2748  0342 a4f0          	and	a,#240
2749  0344 a120          	cp	a,#32
2750  0346 2606          	jrne	L7631
2751                     ; 698     CSSLSE->CSR &= (uint8_t)(~CSSLSE_CSR_CSSF);
2753  0348 72175190      	bres	20880,#3
2755  034c 2004          	jra	L1731
2756  034e               L7631:
2757                     ; 703     CLK->SWCR &= (uint8_t)(~CLK_SWCR_SWIF);
2759  034e 721750c9      	bres	20681,#3
2760  0352               L1731:
2761                     ; 705 }
2764  0352 81            	ret
2788                     ; 713 void CLK_LSEClockSecuritySystemEnable(void)
2788                     ; 714 {
2789                     	switch	.text
2790  0353               _CLK_LSEClockSecuritySystemEnable:
2794                     ; 716   CSSLSE->CSR |= CSSLSE_CSR_CSSEN;
2796  0353 72105190      	bset	20880,#0
2797                     ; 717 }
2800  0357 81            	ret
2824                     ; 725 void CLK_RTCCLKSwitchOnLSEFailureEnable(void)
2824                     ; 726 {
2825                     	switch	.text
2826  0358               _CLK_RTCCLKSwitchOnLSEFailureEnable:
2830                     ; 728   CSSLSE->CSR |= CSSLSE_CSR_SWITCHEN;
2832  0358 72125190      	bset	20880,#1
2833                     ; 729 }
2836  035c 81            	ret
2861                     	xdef	_SYSDivFactor
2862                     	xdef	_CLK_RTCCLKSwitchOnLSEFailureEnable
2863                     	xdef	_CLK_LSEClockSecuritySystemEnable
2864                     	xdef	_CLK_ClearITPendingBit
2865                     	xdef	_CLK_GetITStatus
2866                     	xdef	_CLK_ClearFlag
2867                     	xdef	_CLK_GetFlagStatus
2868                     	xdef	_CLK_MainRegulatorCmd
2869                     	xdef	_CLK_HaltConfig
2870                     	xdef	_CLK_PeripheralClockConfig
2871                     	xdef	_CLK_BEEPClockConfig
2872                     	xdef	_CLK_RTCClockConfig
2873                     	xdef	_CLK_CCOConfig
2874                     	xdef	_CLK_ITConfig
2875                     	xdef	_CLK_GetClockFreq
2876                     	xdef	_CLK_ClockSecuritySytemDeglitchCmd
2877                     	xdef	_CLK_ClockSecuritySystemEnable
2878                     	xdef	_CLK_GetSYSCLKSource
2879                     	xdef	_CLK_SYSCLKSourceSwitchCmd
2880                     	xdef	_CLK_SYSCLKDivConfig
2881                     	xdef	_CLK_SYSCLKSourceConfig
2882                     	xdef	_CLK_LSEConfig
2883                     	xdef	_CLK_HSEConfig
2884                     	xdef	_CLK_LSICmd
2885                     	xdef	_CLK_AdjustHSICalibrationValue
2886                     	xdef	_CLK_HSICmd
2887                     	xdef	_CLK_DeInit
2888                     	xref.b	c_lreg
2889                     	xref.b	c_x
2908                     	xref	c_ludv
2909                     	xref	c_rtol
2910                     	xref	c_ltor
2911                     	end
