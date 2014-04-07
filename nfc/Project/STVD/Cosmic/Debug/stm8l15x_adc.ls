   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.19 - 04 Sep 2013
   3                     ; Generator (Limited) V4.3.11 - 04 Sep 2013
 176                     ; 45 void ADC_DeInit(ADC_TypeDef* ADCx)
 176                     ; 46 {
 178                     	switch	.text
 179  0000               _ADC_DeInit:
 183                     ; 48   ADCx->CR1 =  ADC_CR1_RESET_VALUE;
 185  0000 7f            	clr	(x)
 186                     ; 49   ADCx->CR2 =  ADC_CR2_RESET_VALUE;
 188  0001 6f01          	clr	(1,x)
 189                     ; 50   ADCx->CR3 =  ADC_CR3_RESET_VALUE;
 191  0003 a61f          	ld	a,#31
 192  0005 e702          	ld	(2,x),a
 193                     ; 53   ADCx->SR =  (uint8_t)~ADC_SR_RESET_VALUE;
 195  0007 a6ff          	ld	a,#255
 196  0009 e703          	ld	(3,x),a
 197                     ; 56   ADCx->HTRH =  ADC_HTRH_RESET_VALUE;
 199  000b a60f          	ld	a,#15
 200  000d e706          	ld	(6,x),a
 201                     ; 57   ADCx->HTRL =  ADC_HTRL_RESET_VALUE;
 203  000f a6ff          	ld	a,#255
 204  0011 e707          	ld	(7,x),a
 205                     ; 60   ADCx->LTRH =  ADC_LTRH_RESET_VALUE;
 207  0013 6f08          	clr	(8,x)
 208                     ; 61   ADCx->LTRL =  ADC_LTRL_RESET_VALUE;
 210  0015 6f09          	clr	(9,x)
 211                     ; 64   ADCx->SQR[0] =  ADC_SQR1_RESET_VALUE;
 213  0017 6f0a          	clr	(10,x)
 214                     ; 65   ADCx->SQR[1] =  ADC_SQR2_RESET_VALUE;
 216  0019 6f0b          	clr	(11,x)
 217                     ; 66   ADCx->SQR[2] =  ADC_SQR3_RESET_VALUE;
 219  001b 6f0c          	clr	(12,x)
 220                     ; 67   ADCx->SQR[3] =  ADC_SQR4_RESET_VALUE;
 222  001d 6f0d          	clr	(13,x)
 223                     ; 70   ADCx->TRIGR[0] =  ADC_TRIGR1_RESET_VALUE;
 225  001f 6f0e          	clr	(14,x)
 226                     ; 71   ADCx->TRIGR[1] =  ADC_TRIGR2_RESET_VALUE;
 228  0021 6f0f          	clr	(15,x)
 229                     ; 72   ADCx->TRIGR[2] =  ADC_TRIGR3_RESET_VALUE;
 231  0023 6f10          	clr	(16,x)
 232                     ; 73   ADCx->TRIGR[3] =  ADC_TRIGR4_RESET_VALUE;
 234  0025 6f11          	clr	(17,x)
 235                     ; 74 }
 238  0027 81            	ret
 385                     ; 87 void ADC_Init(ADC_TypeDef* ADCx,
 385                     ; 88               ADC_ConversionMode_TypeDef ADC_ConversionMode,
 385                     ; 89               ADC_Resolution_TypeDef ADC_Resolution,
 385                     ; 90               ADC_Prescaler_TypeDef ADC_Prescaler)
 385                     ; 91 {
 386                     	switch	.text
 387  0028               _ADC_Init:
 389  0028 89            	pushw	x
 390       00000000      OFST:	set	0
 393                     ; 93   assert_param(IS_ADC_CONVERSION_MODE(ADC_ConversionMode));
 395                     ; 94   assert_param(IS_ADC_RESOLUTION(ADC_Resolution));
 397                     ; 95   assert_param(IS_ADC_PRESCALER(ADC_Prescaler));
 399                     ; 98   ADCx->CR1 &= (uint8_t)~(ADC_CR1_CONT | ADC_CR1_RES);
 401  0029 f6            	ld	a,(x)
 402  002a a49b          	and	a,#155
 403  002c f7            	ld	(x),a
 404                     ; 101   ADCx->CR1 |= (uint8_t)((uint8_t)ADC_ConversionMode | (uint8_t)ADC_Resolution);
 406  002d 7b05          	ld	a,(OFST+5,sp)
 407  002f 1a06          	or	a,(OFST+6,sp)
 408  0031 fa            	or	a,(x)
 409  0032 f7            	ld	(x),a
 410                     ; 104   ADCx->CR2 &= (uint8_t)~(ADC_CR2_PRESC );
 412  0033 e601          	ld	a,(1,x)
 413  0035 a47f          	and	a,#127
 414  0037 e701          	ld	(1,x),a
 415                     ; 107   ADCx->CR2 |= (uint8_t) ADC_Prescaler;
 417  0039 e601          	ld	a,(1,x)
 418  003b 1a07          	or	a,(OFST+7,sp)
 419  003d e701          	ld	(1,x),a
 420                     ; 108 }
 423  003f 85            	popw	x
 424  0040 81            	ret
 756                     ; 124 void ADC_ChannelCmd(ADC_TypeDef* ADCx,
 756                     ; 125                     ADC_Channel_TypeDef ADC_Channels,
 756                     ; 126                     FunctionalState NewState)
 756                     ; 127 {
 757                     	switch	.text
 758  0041               _ADC_ChannelCmd:
 760  0041 89            	pushw	x
 761  0042 88            	push	a
 762       00000001      OFST:	set	1
 765                     ; 128   uint8_t regindex = 0;
 767                     ; 130   assert_param(IS_FUNCTIONAL_STATE(NewState));
 769                     ; 132   regindex = (uint8_t)((uint16_t)ADC_Channels >> 8);
 771  0043 7b06          	ld	a,(OFST+5,sp)
 772  0045 6b01          	ld	(OFST+0,sp),a
 773                     ; 134   if (NewState != DISABLE)
 775  0047 0d08          	tnz	(OFST+7,sp)
 776  0049 270f          	jreq	L163
 777                     ; 137     ADCx->SQR[regindex] |= (uint8_t)(ADC_Channels);
 779  004b 01            	rrwa	x,a
 780  004c 1b01          	add	a,(OFST+0,sp)
 781  004e 2401          	jrnc	L21
 782  0050 5c            	incw	x
 783  0051               L21:
 784  0051 02            	rlwa	x,a
 785  0052 e60a          	ld	a,(10,x)
 786  0054 1a07          	or	a,(OFST+6,sp)
 787  0056 e70a          	ld	(10,x),a
 789  0058 2012          	jra	L363
 790  005a               L163:
 791                     ; 142     ADCx->SQR[regindex] &= (uint8_t)(~(uint8_t)(ADC_Channels));
 793  005a 7b02          	ld	a,(OFST+1,sp)
 794  005c 97            	ld	xl,a
 795  005d 7b03          	ld	a,(OFST+2,sp)
 796  005f 1b01          	add	a,(OFST+0,sp)
 797  0061 2401          	jrnc	L41
 798  0063 5c            	incw	x
 799  0064               L41:
 800  0064 02            	rlwa	x,a
 801  0065 7b07          	ld	a,(OFST+6,sp)
 802  0067 43            	cpl	a
 803  0068 e40a          	and	a,(10,x)
 804  006a e70a          	ld	(10,x),a
 805  006c               L363:
 806                     ; 144 }
 809  006c 5b03          	addw	sp,#3
 810  006e 81            	ret
 857                     ; 153 void ADC_Cmd(ADC_TypeDef* ADCx,
 857                     ; 154              FunctionalState NewState)
 857                     ; 155 {
 858                     	switch	.text
 859  006f               _ADC_Cmd:
 861  006f 89            	pushw	x
 862       00000000      OFST:	set	0
 865                     ; 157   assert_param(IS_FUNCTIONAL_STATE(NewState));
 867                     ; 159   if (NewState != DISABLE)
 869  0070 0d05          	tnz	(OFST+5,sp)
 870  0072 2706          	jreq	L114
 871                     ; 162     ADCx->CR1 |= ADC_CR1_ADON;
 873  0074 f6            	ld	a,(x)
 874  0075 aa01          	or	a,#1
 875  0077 f7            	ld	(x),a
 877  0078 2006          	jra	L314
 878  007a               L114:
 879                     ; 167     ADCx->CR1 &= (uint8_t)~ADC_CR1_ADON;
 881  007a 1e01          	ldw	x,(OFST+1,sp)
 882  007c f6            	ld	a,(x)
 883  007d a4fe          	and	a,#254
 884  007f f7            	ld	(x),a
 885  0080               L314:
 886                     ; 169 }
 889  0080 85            	popw	x
 890  0081 81            	ret
 974                     ; 180 void ADC_ITConfig(ADC_TypeDef* ADCx,
 974                     ; 181                   ADC_IT_TypeDef ADC_IT,
 974                     ; 182                   FunctionalState NewState)
 974                     ; 183 {
 975                     	switch	.text
 976  0082               _ADC_ITConfig:
 978  0082 89            	pushw	x
 979       00000000      OFST:	set	0
 982                     ; 185   assert_param(IS_FUNCTIONAL_STATE(NewState));
 984                     ; 186   assert_param(IS_ADC_IT(ADC_IT));
 986                     ; 188   if (NewState != DISABLE)
 988  0083 0d06          	tnz	(OFST+6,sp)
 989  0085 2706          	jreq	L754
 990                     ; 191     ADCx->CR1 |= (uint8_t) ADC_IT;
 992  0087 f6            	ld	a,(x)
 993  0088 1a05          	or	a,(OFST+5,sp)
 994  008a f7            	ld	(x),a
 996  008b 2007          	jra	L164
 997  008d               L754:
 998                     ; 196     ADCx->CR1 &= (uint8_t)(~ADC_IT);
1000  008d 1e01          	ldw	x,(OFST+1,sp)
1001  008f 7b05          	ld	a,(OFST+5,sp)
1002  0091 43            	cpl	a
1003  0092 f4            	and	a,(x)
1004  0093 f7            	ld	(x),a
1005  0094               L164:
1006                     ; 198 }
1009  0094 85            	popw	x
1010  0095 81            	ret
1057                     ; 207 void ADC_DMACmd(ADC_TypeDef* ADCx,
1057                     ; 208                 FunctionalState NewState)
1057                     ; 209 {
1058                     	switch	.text
1059  0096               _ADC_DMACmd:
1061  0096 89            	pushw	x
1062       00000000      OFST:	set	0
1065                     ; 211   assert_param(IS_FUNCTIONAL_STATE(NewState));
1067                     ; 213   if (NewState != DISABLE)
1069  0097 0d05          	tnz	(OFST+5,sp)
1070  0099 2708          	jreq	L705
1071                     ; 216     ADCx->SQR[0] &= (uint8_t)~ADC_SQR1_DMAOFF;
1073  009b e60a          	ld	a,(10,x)
1074  009d a47f          	and	a,#127
1075  009f e70a          	ld	(10,x),a
1077  00a1 2008          	jra	L115
1078  00a3               L705:
1079                     ; 221     ADCx->SQR[0] |= ADC_SQR1_DMAOFF;
1081  00a3 1e01          	ldw	x,(OFST+1,sp)
1082  00a5 e60a          	ld	a,(10,x)
1083  00a7 aa80          	or	a,#128
1084  00a9 e70a          	ld	(10,x),a
1085  00ab               L115:
1086                     ; 223 }
1089  00ab 85            	popw	x
1090  00ac 81            	ret
1125                     ; 231 void ADC_TempSensorCmd(FunctionalState NewState)
1125                     ; 232 {
1126                     	switch	.text
1127  00ad               _ADC_TempSensorCmd:
1131                     ; 234   assert_param(IS_FUNCTIONAL_STATE(NewState));
1133                     ; 236   if (NewState != DISABLE)
1135  00ad 4d            	tnz	a
1136  00ae 2706          	jreq	L135
1137                     ; 239     ADC1->TRIGR[0] |= (uint8_t)(ADC_TRIGR1_TSON);
1139  00b0 721a534e      	bset	21326,#5
1141  00b4 2004          	jra	L335
1142  00b6               L135:
1143                     ; 244     ADC1->TRIGR[0] &= (uint8_t)(~ADC_TRIGR1_TSON);
1145  00b6 721b534e      	bres	21326,#5
1146  00ba               L335:
1147                     ; 246 }
1150  00ba 81            	ret
1185                     ; 254 void ADC_VrefintCmd(FunctionalState NewState)
1185                     ; 255 {
1186                     	switch	.text
1187  00bb               _ADC_VrefintCmd:
1191                     ; 257   assert_param(IS_FUNCTIONAL_STATE(NewState));
1193                     ; 259   if (NewState != DISABLE)
1195  00bb 4d            	tnz	a
1196  00bc 2706          	jreq	L355
1197                     ; 262     ADC1->TRIGR[0] |= (uint8_t)(ADC_TRIGR1_VREFINTON);
1199  00be 7218534e      	bset	21326,#4
1201  00c2 2004          	jra	L555
1202  00c4               L355:
1203                     ; 267     ADC1->TRIGR[0] &= (uint8_t)(~ADC_TRIGR1_VREFINTON);
1205  00c4 7219534e      	bres	21326,#4
1206  00c8               L555:
1207                     ; 269 }
1210  00c8 81            	ret
1248                     ; 276 void ADC_SoftwareStartConv(ADC_TypeDef* ADCx)
1248                     ; 277 {
1249                     	switch	.text
1250  00c9               _ADC_SoftwareStartConv:
1254                     ; 279   ADCx->CR1 |= ADC_CR1_START;
1256  00c9 f6            	ld	a,(x)
1257  00ca aa02          	or	a,#2
1258  00cc f7            	ld	(x),a
1259                     ; 280 }
1262  00cd 81            	ret
1412                     ; 291 void ADC_SamplingTimeConfig(ADC_TypeDef* ADCx,
1412                     ; 292                             ADC_Group_TypeDef ADC_GroupChannels,
1412                     ; 293                             ADC_SamplingTime_TypeDef ADC_SamplingTime)
1412                     ; 294 {
1413                     	switch	.text
1414  00ce               _ADC_SamplingTimeConfig:
1416  00ce 89            	pushw	x
1417       00000000      OFST:	set	0
1420                     ; 296   assert_param(IS_ADC_GROUP(ADC_GroupChannels));
1422                     ; 297   assert_param(IS_ADC_SAMPLING_TIME_CYCLES(ADC_SamplingTime));
1424                     ; 299   if ( ADC_GroupChannels != ADC_Group_SlowChannels)
1426  00cf 0d05          	tnz	(OFST+5,sp)
1427  00d1 2712          	jreq	L366
1428                     ; 302     ADCx->CR3 &= (uint8_t)~ADC_CR3_SMPT2;
1430  00d3 e602          	ld	a,(2,x)
1431  00d5 a41f          	and	a,#31
1432  00d7 e702          	ld	(2,x),a
1433                     ; 303     ADCx->CR3 |= (uint8_t)(ADC_SamplingTime << 5);
1435  00d9 7b06          	ld	a,(OFST+6,sp)
1436  00db 4e            	swap	a
1437  00dc 48            	sll	a
1438  00dd a4e0          	and	a,#224
1439  00df ea02          	or	a,(2,x)
1440  00e1 e702          	ld	(2,x),a
1442  00e3 2010          	jra	L566
1443  00e5               L366:
1444                     ; 308     ADCx->CR2 &= (uint8_t)~ADC_CR2_SMPT1;
1446  00e5 1e01          	ldw	x,(OFST+1,sp)
1447  00e7 e601          	ld	a,(1,x)
1448  00e9 a4f8          	and	a,#248
1449  00eb e701          	ld	(1,x),a
1450                     ; 309     ADCx->CR2 |= (uint8_t)ADC_SamplingTime;
1452  00ed 1e01          	ldw	x,(OFST+1,sp)
1453  00ef e601          	ld	a,(1,x)
1454  00f1 1a06          	or	a,(OFST+6,sp)
1455  00f3 e701          	ld	(1,x),a
1456  00f5               L566:
1457                     ; 311 }
1460  00f5 85            	popw	x
1461  00f6 81            	ret
1528                     ; 322 void ADC_SchmittTriggerConfig(ADC_TypeDef* ADCx,
1528                     ; 323                               ADC_Channel_TypeDef ADC_Channels,
1528                     ; 324                               FunctionalState NewState)
1528                     ; 325 {
1529                     	switch	.text
1530  00f7               _ADC_SchmittTriggerConfig:
1532  00f7 89            	pushw	x
1533  00f8 88            	push	a
1534       00000001      OFST:	set	1
1537                     ; 326   uint8_t regindex = 0;
1539                     ; 328   assert_param(IS_FUNCTIONAL_STATE(NewState));
1541                     ; 330   regindex = (uint8_t)((uint16_t)ADC_Channels >> 8);
1543  00f9 7b06          	ld	a,(OFST+5,sp)
1544  00fb 6b01          	ld	(OFST+0,sp),a
1545                     ; 332   if (NewState != DISABLE)
1547  00fd 0d08          	tnz	(OFST+7,sp)
1548  00ff 2710          	jreq	L327
1549                     ; 335     ADCx->TRIGR[regindex] &= (uint8_t)(~(uint8_t)ADC_Channels);
1551  0101 01            	rrwa	x,a
1552  0102 1b01          	add	a,(OFST+0,sp)
1553  0104 2401          	jrnc	L63
1554  0106 5c            	incw	x
1555  0107               L63:
1556  0107 02            	rlwa	x,a
1557  0108 7b07          	ld	a,(OFST+6,sp)
1558  010a 43            	cpl	a
1559  010b e40e          	and	a,(14,x)
1560  010d e70e          	ld	(14,x),a
1562  010f 2011          	jra	L527
1563  0111               L327:
1564                     ; 340     ADCx->TRIGR[regindex] |= (uint8_t)(ADC_Channels);
1566  0111 7b02          	ld	a,(OFST+1,sp)
1567  0113 97            	ld	xl,a
1568  0114 7b03          	ld	a,(OFST+2,sp)
1569  0116 1b01          	add	a,(OFST+0,sp)
1570  0118 2401          	jrnc	L04
1571  011a 5c            	incw	x
1572  011b               L04:
1573  011b 02            	rlwa	x,a
1574  011c e60e          	ld	a,(14,x)
1575  011e 1a07          	or	a,(OFST+6,sp)
1576  0120 e70e          	ld	(14,x),a
1577  0122               L527:
1578                     ; 342 }
1581  0122 5b03          	addw	sp,#3
1582  0124 81            	ret
1710                     ; 353 void ADC_ExternalTrigConfig(ADC_TypeDef* ADCx,
1710                     ; 354                             ADC_ExtEventSelection_TypeDef ADC_ExtEventSelection,
1710                     ; 355                             ADC_ExtTRGSensitivity_TypeDef ADC_ExtTRGSensitivity)
1710                     ; 356 {
1711                     	switch	.text
1712  0125               _ADC_ExternalTrigConfig:
1714  0125 89            	pushw	x
1715       00000000      OFST:	set	0
1718                     ; 358   assert_param(IS_ADC_EXT_EVENT_SELECTION(ADC_ExtEventSelection));
1720                     ; 359   assert_param(IS_ADC_EXT_TRG_SENSITIVITY(ADC_ExtTRGSensitivity));
1722                     ; 362   ADCx->CR2 &= (uint8_t)~(ADC_CR2_TRIGEDGE | ADC_CR2_EXTSEL);
1724  0126 e601          	ld	a,(1,x)
1725  0128 a487          	and	a,#135
1726  012a e701          	ld	(1,x),a
1727                     ; 365   ADCx->CR2 |= (uint8_t)( (uint8_t)ADC_ExtTRGSensitivity | (uint8_t)ADC_ExtEventSelection);
1729  012c 7b06          	ld	a,(OFST+6,sp)
1730  012e 1a05          	or	a,(OFST+5,sp)
1731  0130 ea01          	or	a,(1,x)
1732  0132 e701          	ld	(1,x),a
1733                     ; 366 }
1736  0134 85            	popw	x
1737  0135 81            	ret
1784                     ; 374 uint16_t ADC_GetConversionValue(ADC_TypeDef* ADCx)
1784                     ; 375 {
1785                     	switch	.text
1786  0136               _ADC_GetConversionValue:
1788  0136 89            	pushw	x
1789  0137 89            	pushw	x
1790       00000002      OFST:	set	2
1793                     ; 376   uint16_t tmpreg = 0;
1795                     ; 379   tmpreg = (uint16_t)(ADCx->DRH);
1797  0138 e604          	ld	a,(4,x)
1798  013a 5f            	clrw	x
1799  013b 97            	ld	xl,a
1800  013c 1f01          	ldw	(OFST-1,sp),x
1801                     ; 380   tmpreg = (uint16_t)((uint16_t)((uint16_t)tmpreg << 8) | ADCx->DRL);
1803  013e 1e01          	ldw	x,(OFST-1,sp)
1804  0140 1603          	ldw	y,(OFST+1,sp)
1805  0142 90e605        	ld	a,(5,y)
1806  0145 02            	rlwa	x,a
1807  0146 1f01          	ldw	(OFST-1,sp),x
1808                     ; 383   return (uint16_t)(tmpreg) ;
1810  0148 1e01          	ldw	x,(OFST-1,sp)
1813  014a 5b04          	addw	sp,#4
1814  014c 81            	ret
2128                     ; 395 void ADC_AnalogWatchdogChannelSelect(ADC_TypeDef* ADCx,
2128                     ; 396                                      ADC_AnalogWatchdogSelection_TypeDef ADC_AnalogWatchdogSelection)
2128                     ; 397 {
2129                     	switch	.text
2130  014d               _ADC_AnalogWatchdogChannelSelect:
2132  014d 89            	pushw	x
2133       00000000      OFST:	set	0
2136                     ; 399   assert_param(IS_ADC_ANALOGWATCHDOG_SELECTION(ADC_AnalogWatchdogSelection));
2138                     ; 402   ADCx->CR3 &= ((uint8_t)~ADC_CR3_CHSEL);
2140  014e e602          	ld	a,(2,x)
2141  0150 a4e0          	and	a,#224
2142  0152 e702          	ld	(2,x),a
2143                     ; 405   ADCx->CR3 |= (uint8_t)ADC_AnalogWatchdogSelection;
2145  0154 e602          	ld	a,(2,x)
2146  0156 1a05          	or	a,(OFST+5,sp)
2147  0158 e702          	ld	(2,x),a
2148                     ; 406 }
2151  015a 85            	popw	x
2152  015b 81            	ret
2208                     ; 417 void ADC_AnalogWatchdogThresholdsConfig(ADC_TypeDef* ADCx,
2208                     ; 418                                         uint16_t HighThreshold,
2208                     ; 419                                         uint16_t LowThreshold)
2208                     ; 420 {
2209                     	switch	.text
2210  015c               _ADC_AnalogWatchdogThresholdsConfig:
2212  015c 89            	pushw	x
2213       00000000      OFST:	set	0
2216                     ; 422   assert_param(IS_ADC_THRESHOLD(HighThreshold));
2218                     ; 423   assert_param(IS_ADC_THRESHOLD(LowThreshold));
2220                     ; 426   ADCx->HTRH = (uint8_t)(HighThreshold >> 8);
2222  015d 7b05          	ld	a,(OFST+5,sp)
2223  015f 1e01          	ldw	x,(OFST+1,sp)
2224  0161 e706          	ld	(6,x),a
2225                     ; 427   ADCx->HTRL = (uint8_t)(HighThreshold);
2227  0163 7b06          	ld	a,(OFST+6,sp)
2228  0165 1e01          	ldw	x,(OFST+1,sp)
2229  0167 e707          	ld	(7,x),a
2230                     ; 430   ADCx->LTRH = (uint8_t)(LowThreshold >> 8);
2232  0169 7b07          	ld	a,(OFST+7,sp)
2233  016b 1e01          	ldw	x,(OFST+1,sp)
2234  016d e708          	ld	(8,x),a
2235                     ; 431   ADCx->LTRL = (uint8_t)(LowThreshold);
2237  016f 7b08          	ld	a,(OFST+8,sp)
2238  0171 1e01          	ldw	x,(OFST+1,sp)
2239  0173 e709          	ld	(9,x),a
2240                     ; 432 }
2243  0175 85            	popw	x
2244  0176 81            	ret
2311                     ; 446 void ADC_AnalogWatchdogConfig(ADC_TypeDef* ADCx,
2311                     ; 447                               ADC_AnalogWatchdogSelection_TypeDef ADC_AnalogWatchdogSelection,
2311                     ; 448                               uint16_t HighThreshold,
2311                     ; 449                               uint16_t LowThreshold)
2311                     ; 450 {
2312                     	switch	.text
2313  0177               _ADC_AnalogWatchdogConfig:
2315  0177 89            	pushw	x
2316       00000000      OFST:	set	0
2319                     ; 452   assert_param(IS_ADC_ANALOGWATCHDOG_SELECTION(ADC_AnalogWatchdogSelection));
2321                     ; 453   assert_param(IS_ADC_THRESHOLD(HighThreshold));
2323                     ; 454   assert_param(IS_ADC_THRESHOLD(LowThreshold));
2325                     ; 457   ADCx->CR3 &= ((uint8_t)~ADC_CR3_CHSEL);
2327  0178 e602          	ld	a,(2,x)
2328  017a a4e0          	and	a,#224
2329  017c e702          	ld	(2,x),a
2330                     ; 460   ADCx->CR3 |= (uint8_t)ADC_AnalogWatchdogSelection;
2332  017e e602          	ld	a,(2,x)
2333  0180 1a05          	or	a,(OFST+5,sp)
2334  0182 e702          	ld	(2,x),a
2335                     ; 463   ADCx->HTRH = (uint8_t)(HighThreshold >> 8);
2337  0184 7b06          	ld	a,(OFST+6,sp)
2338  0186 1e01          	ldw	x,(OFST+1,sp)
2339  0188 e706          	ld	(6,x),a
2340                     ; 464   ADCx->HTRL = (uint8_t)(HighThreshold);
2342  018a 7b07          	ld	a,(OFST+7,sp)
2343  018c 1e01          	ldw	x,(OFST+1,sp)
2344  018e e707          	ld	(7,x),a
2345                     ; 467   ADCx->LTRH = (uint8_t)(LowThreshold >> 8);
2347  0190 7b08          	ld	a,(OFST+8,sp)
2348  0192 1e01          	ldw	x,(OFST+1,sp)
2349  0194 e708          	ld	(8,x),a
2350                     ; 468   ADCx->LTRL = (uint8_t)LowThreshold;
2352  0196 7b09          	ld	a,(OFST+9,sp)
2353  0198 1e01          	ldw	x,(OFST+1,sp)
2354  019a e709          	ld	(9,x),a
2355                     ; 469 }
2358  019c 85            	popw	x
2359  019d 81            	ret
2464                     ; 478 FlagStatus ADC_GetFlagStatus(ADC_TypeDef* ADCx, ADC_FLAG_TypeDef ADC_FLAG)
2464                     ; 479 {
2465                     	switch	.text
2466  019e               _ADC_GetFlagStatus:
2468  019e 89            	pushw	x
2469  019f 88            	push	a
2470       00000001      OFST:	set	1
2473                     ; 480   FlagStatus flagstatus = RESET;
2475                     ; 483   assert_param(IS_ADC_GET_FLAG(ADC_FLAG));
2477                     ; 486   if ((ADCx->SR & ADC_FLAG) != (uint8_t)RESET)
2479  01a0 e603          	ld	a,(3,x)
2480  01a2 1506          	bcp	a,(OFST+5,sp)
2481  01a4 2706          	jreq	L3131
2482                     ; 489     flagstatus = SET;
2484  01a6 a601          	ld	a,#1
2485  01a8 6b01          	ld	(OFST+0,sp),a
2487  01aa 2002          	jra	L5131
2488  01ac               L3131:
2489                     ; 494     flagstatus = RESET;
2491  01ac 0f01          	clr	(OFST+0,sp)
2492  01ae               L5131:
2493                     ; 498   return  flagstatus;
2495  01ae 7b01          	ld	a,(OFST+0,sp)
2498  01b0 5b03          	addw	sp,#3
2499  01b2 81            	ret
2546                     ; 508 void ADC_ClearFlag(ADC_TypeDef* ADCx,
2546                     ; 509                    ADC_FLAG_TypeDef ADC_FLAG)
2546                     ; 510 {
2547                     	switch	.text
2548  01b3               _ADC_ClearFlag:
2550  01b3 89            	pushw	x
2551       00000000      OFST:	set	0
2554                     ; 512   assert_param(IS_ADC_CLEAR_FLAG(ADC_FLAG));
2556                     ; 515   ADCx->SR = (uint8_t)~ADC_FLAG;
2558  01b4 7b05          	ld	a,(OFST+5,sp)
2559  01b6 43            	cpl	a
2560  01b7 1e01          	ldw	x,(OFST+1,sp)
2561  01b9 e703          	ld	(3,x),a
2562                     ; 516 }
2565  01bb 85            	popw	x
2566  01bc 81            	ret
2642                     ; 526 ITStatus ADC_GetITStatus(ADC_TypeDef* ADCx,
2642                     ; 527                          ADC_IT_TypeDef ADC_IT)
2642                     ; 528 {
2643                     	switch	.text
2644  01bd               _ADC_GetITStatus:
2646  01bd 89            	pushw	x
2647  01be 5203          	subw	sp,#3
2648       00000003      OFST:	set	3
2651                     ; 529   ITStatus itstatus = RESET;
2653                     ; 530   uint8_t itmask = 0, enablestatus = 0;
2657                     ; 533   assert_param(IS_ADC_GET_IT(ADC_IT));
2659                     ; 536   itmask = (uint8_t)(ADC_IT >> 3);
2661  01c0 7b08          	ld	a,(OFST+5,sp)
2662  01c2 44            	srl	a
2663  01c3 44            	srl	a
2664  01c4 44            	srl	a
2665  01c5 6b03          	ld	(OFST+0,sp),a
2666                     ; 537   itmask =  (uint8_t)((uint8_t)((uint8_t)(itmask & (uint8_t)0x10) >> 2) | (uint8_t)(itmask & (uint8_t)0x03));
2668  01c7 7b03          	ld	a,(OFST+0,sp)
2669  01c9 a403          	and	a,#3
2670  01cb 6b01          	ld	(OFST-2,sp),a
2671  01cd 7b03          	ld	a,(OFST+0,sp)
2672  01cf a410          	and	a,#16
2673  01d1 44            	srl	a
2674  01d2 44            	srl	a
2675  01d3 1a01          	or	a,(OFST-2,sp)
2676  01d5 6b03          	ld	(OFST+0,sp),a
2677                     ; 540   enablestatus = (uint8_t)(ADCx->CR1 & (uint8_t)ADC_IT) ;
2679  01d7 f6            	ld	a,(x)
2680  01d8 1408          	and	a,(OFST+5,sp)
2681  01da 6b02          	ld	(OFST-1,sp),a
2682                     ; 543   if (((ADCx->SR & itmask) != (uint8_t)RESET) && enablestatus)
2684  01dc e603          	ld	a,(3,x)
2685  01de 1503          	bcp	a,(OFST+0,sp)
2686  01e0 270a          	jreq	L3041
2688  01e2 0d02          	tnz	(OFST-1,sp)
2689  01e4 2706          	jreq	L3041
2690                     ; 546     itstatus = SET;
2692  01e6 a601          	ld	a,#1
2693  01e8 6b03          	ld	(OFST+0,sp),a
2695  01ea 2002          	jra	L5041
2696  01ec               L3041:
2697                     ; 551     itstatus = RESET;
2699  01ec 0f03          	clr	(OFST+0,sp)
2700  01ee               L5041:
2701                     ; 555   return  itstatus;
2703  01ee 7b03          	ld	a,(OFST+0,sp)
2706  01f0 5b05          	addw	sp,#5
2707  01f2 81            	ret
2764                     ; 565 void ADC_ClearITPendingBit(ADC_TypeDef* ADCx,
2764                     ; 566                            ADC_IT_TypeDef ADC_IT)
2764                     ; 567 {
2765                     	switch	.text
2766  01f3               _ADC_ClearITPendingBit:
2768  01f3 89            	pushw	x
2769  01f4 89            	pushw	x
2770       00000002      OFST:	set	2
2773                     ; 568   uint8_t itmask = 0;
2775                     ; 571   assert_param(IS_ADC_IT(ADC_IT));
2777                     ; 574   itmask = (uint8_t)(ADC_IT >> 3);
2779  01f5 7b07          	ld	a,(OFST+5,sp)
2780  01f7 44            	srl	a
2781  01f8 44            	srl	a
2782  01f9 44            	srl	a
2783  01fa 6b02          	ld	(OFST+0,sp),a
2784                     ; 575   itmask =  (uint8_t)((uint8_t)(((uint8_t)(itmask & (uint8_t)0x10)) >> 2) | (uint8_t)(itmask & (uint8_t)0x03));
2786  01fc 7b02          	ld	a,(OFST+0,sp)
2787  01fe a403          	and	a,#3
2788  0200 6b01          	ld	(OFST-1,sp),a
2789  0202 7b02          	ld	a,(OFST+0,sp)
2790  0204 a410          	and	a,#16
2791  0206 44            	srl	a
2792  0207 44            	srl	a
2793  0208 1a01          	or	a,(OFST-1,sp)
2794  020a 6b02          	ld	(OFST+0,sp),a
2795                     ; 578   ADCx->SR = (uint8_t)~itmask;
2797  020c 7b02          	ld	a,(OFST+0,sp)
2798  020e 43            	cpl	a
2799  020f 1e03          	ldw	x,(OFST+1,sp)
2800  0211 e703          	ld	(3,x),a
2801                     ; 579 }
2804  0213 5b04          	addw	sp,#4
2805  0215 81            	ret
2818                     	xdef	_ADC_ClearITPendingBit
2819                     	xdef	_ADC_GetITStatus
2820                     	xdef	_ADC_ClearFlag
2821                     	xdef	_ADC_GetFlagStatus
2822                     	xdef	_ADC_AnalogWatchdogConfig
2823                     	xdef	_ADC_AnalogWatchdogThresholdsConfig
2824                     	xdef	_ADC_AnalogWatchdogChannelSelect
2825                     	xdef	_ADC_GetConversionValue
2826                     	xdef	_ADC_ExternalTrigConfig
2827                     	xdef	_ADC_SchmittTriggerConfig
2828                     	xdef	_ADC_SamplingTimeConfig
2829                     	xdef	_ADC_SoftwareStartConv
2830                     	xdef	_ADC_VrefintCmd
2831                     	xdef	_ADC_TempSensorCmd
2832                     	xdef	_ADC_DMACmd
2833                     	xdef	_ADC_ITConfig
2834                     	xdef	_ADC_Cmd
2835                     	xdef	_ADC_ChannelCmd
2836                     	xdef	_ADC_Init
2837                     	xdef	_ADC_DeInit
2856                     	end
