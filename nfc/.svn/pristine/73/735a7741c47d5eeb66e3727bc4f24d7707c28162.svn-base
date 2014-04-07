   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.13 - 06 Dec 2012
   3                     ; Generator (Limited) V4.3.9 - 06 Dec 2012
  78                     ; 85 void FLASH_Unlock(FLASH_MemType_TypeDef FLASH_MemType)
  78                     ; 86 {
  80                     	switch	.text
  81  0000               _FLASH_Unlock:
  83  0000 88            	push	a
  84       00000000      OFST:	set	0
  87                     ; 88   assert_param(IS_FLASH_MEMORY_TYPE(FLASH_MemType));
  89                     ; 91   if (FLASH_MemType == FLASH_MemType_Program)
  91  0001 a1fd          	cp	a,#253
  92  0003 2608          	jrne	L73
  93                     ; 93     FLASH->PUKR = FLASH_RASS_KEY1;
  95  0005 35565052      	mov	20562,#86
  96                     ; 94     FLASH->PUKR = FLASH_RASS_KEY2;
  98  0009 35ae5052      	mov	20562,#174
  99  000d               L73:
 100                     ; 98   if (FLASH_MemType == FLASH_MemType_Data)
 102  000d 7b01          	ld	a,(OFST+1,sp)
 103  000f a1f7          	cp	a,#247
 104  0011 2608          	jrne	L14
 105                     ; 100     FLASH->DUKR = FLASH_RASS_KEY2; /* Warning: keys are reversed on data memory !!! */
 107  0013 35ae5053      	mov	20563,#174
 108                     ; 101     FLASH->DUKR = FLASH_RASS_KEY1;
 110  0017 35565053      	mov	20563,#86
 111  001b               L14:
 112                     ; 103 }
 115  001b 84            	pop	a
 116  001c 81            	ret
 151                     ; 111 void FLASH_Lock(FLASH_MemType_TypeDef FLASH_MemType)
 151                     ; 112 {
 152                     	switch	.text
 153  001d               _FLASH_Lock:
 157                     ; 114   assert_param(IS_FLASH_MEMORY_TYPE(FLASH_MemType));
 159                     ; 116   FLASH->IAPSR &= (uint8_t)FLASH_MemType;
 161  001d c45054        	and	a,20564
 162  0020 c75054        	ld	20564,a
 163                     ; 117 }
 166  0023 81            	ret
 189                     ; 124 void FLASH_DeInit(void)
 189                     ; 125 {
 190                     	switch	.text
 191  0024               _FLASH_DeInit:
 195                     ; 126   FLASH->CR1 = FLASH_CR1_RESET_VALUE;
 197  0024 725f5050      	clr	20560
 198                     ; 127   FLASH->CR2 = FLASH_CR2_RESET_VALUE;
 200  0028 725f5051      	clr	20561
 201                     ; 128   FLASH->IAPSR = FLASH_IAPSR_RESET_VALUE;
 203  002c 35405054      	mov	20564,#64
 204                     ; 129   (void) FLASH->IAPSR; /* Reading of this register causes the clearing of status flags */
 206  0030 c65054        	ld	a,20564
 207                     ; 130 }
 210  0033 81            	ret
 265                     ; 138 void FLASH_ITConfig(FunctionalState NewState)
 265                     ; 139 {
 266                     	switch	.text
 267  0034               _FLASH_ITConfig:
 271                     ; 142   assert_param(IS_FUNCTIONAL_STATE(NewState));
 273                     ; 144   if (NewState != DISABLE)
 275  0034 4d            	tnz	a
 276  0035 2706          	jreq	L711
 277                     ; 147     FLASH->CR1 |= FLASH_CR1_IE;
 279  0037 72125050      	bset	20560,#1
 281  003b 2004          	jra	L121
 282  003d               L711:
 283                     ; 152     FLASH->CR1 &= (uint8_t)(~FLASH_CR1_IE);
 285  003d 72135050      	bres	20560,#1
 286  0041               L121:
 287                     ; 154 }
 290  0041 81            	ret
 324                     ; 161 void FLASH_EraseByte(uint32_t Address)
 324                     ; 162 {
 325                     	switch	.text
 326  0042               _FLASH_EraseByte:
 328       00000000      OFST:	set	0
 331                     ; 164   assert_param(IS_FLASH_ADDRESS(Address));
 333                     ; 166   *(PointerAttr uint8_t*) (uint16_t)Address = FLASH_CLEAR_BYTE; /* Erase byte */
 335  0042 1e05          	ldw	x,(OFST+5,sp)
 336  0044 7f            	clr	(x)
 337                     ; 167 }
 340  0045 81            	ret
 383                     ; 174 void FLASH_ProgramByte(uint32_t Address, uint8_t Data)
 383                     ; 175 {
 384                     	switch	.text
 385  0046               _FLASH_ProgramByte:
 387       00000000      OFST:	set	0
 390                     ; 177   assert_param(IS_FLASH_ADDRESS(Address));
 392                     ; 179   *(PointerAttr uint8_t*) (uint16_t)Address = Data;
 394  0046 7b07          	ld	a,(OFST+7,sp)
 395  0048 1e05          	ldw	x,(OFST+5,sp)
 396  004a f7            	ld	(x),a
 397                     ; 180 }
 400  004b 81            	ret
 443                     ; 188 void FLASH_ProgramWord(uint32_t Address, uint32_t Data)
 443                     ; 189 {
 444                     	switch	.text
 445  004c               _FLASH_ProgramWord:
 447       00000000      OFST:	set	0
 450                     ; 191   assert_param(IS_FLASH_ADDRESS(Address));
 452                     ; 193   FLASH->CR2 |= FLASH_CR2_WPRG;
 454  004c 721c5051      	bset	20561,#6
 455                     ; 196   *((PointerAttr uint8_t*)(uint16_t)Address)       = *((uint8_t*)(&Data));   
 457  0050 7b07          	ld	a,(OFST+7,sp)
 458  0052 1e05          	ldw	x,(OFST+5,sp)
 459  0054 f7            	ld	(x),a
 460                     ; 198   *(((PointerAttr uint8_t*)(uint16_t)Address) + 1) = *((uint8_t*)(&Data) + 1);
 462  0055 7b08          	ld	a,(OFST+8,sp)
 463  0057 1e05          	ldw	x,(OFST+5,sp)
 464  0059 e701          	ld	(1,x),a
 465                     ; 200   *(((PointerAttr uint8_t*)(uint16_t)Address) + 2) = *((uint8_t*)(&Data) + 2); 
 467  005b 7b09          	ld	a,(OFST+9,sp)
 468  005d 1e05          	ldw	x,(OFST+5,sp)
 469  005f e702          	ld	(2,x),a
 470                     ; 202   *(((PointerAttr uint8_t*)(uint16_t)Address) + 3) = *((uint8_t*)(&Data) + 3); 
 472  0061 7b0a          	ld	a,(OFST+10,sp)
 473  0063 1e05          	ldw	x,(OFST+5,sp)
 474  0065 e703          	ld	(3,x),a
 475                     ; 203 }
 478  0067 81            	ret
 523                     ; 211 void FLASH_ProgramOptionByte(uint16_t Address, uint8_t Data)
 523                     ; 212 {
 524                     	switch	.text
 525  0068               _FLASH_ProgramOptionByte:
 527  0068 89            	pushw	x
 528       00000000      OFST:	set	0
 531                     ; 214   assert_param(IS_OPTION_BYTE_ADDRESS(Address));
 533                     ; 217   FLASH->CR2 |= FLASH_CR2_OPT;
 535  0069 721e5051      	bset	20561,#7
 536                     ; 220   *((PointerAttr uint8_t*)Address) = Data;
 538  006d 7b05          	ld	a,(OFST+5,sp)
 539  006f 1e01          	ldw	x,(OFST+1,sp)
 540  0071 f7            	ld	(x),a
 541                     ; 222   FLASH_WaitForLastOperation(FLASH_MemType_Program);
 543  0072 a6fd          	ld	a,#253
 544  0074 cd0112        	call	_FLASH_WaitForLastOperation
 546                     ; 225   FLASH->CR2 &= (uint8_t)(~FLASH_CR2_OPT);
 548  0077 721f5051      	bres	20561,#7
 549                     ; 226 }
 552  007b 85            	popw	x
 553  007c 81            	ret
 589                     ; 233 void FLASH_EraseOptionByte(uint16_t Address)
 589                     ; 234 {
 590                     	switch	.text
 591  007d               _FLASH_EraseOptionByte:
 595                     ; 236   assert_param(IS_OPTION_BYTE_ADDRESS(Address));
 597                     ; 239   FLASH->CR2 |= FLASH_CR2_OPT;
 599  007d 721e5051      	bset	20561,#7
 600                     ; 242   *((PointerAttr uint8_t*)Address) = FLASH_CLEAR_BYTE;
 602  0081 7f            	clr	(x)
 603                     ; 244   FLASH_WaitForLastOperation(FLASH_MemType_Program);
 605  0082 a6fd          	ld	a,#253
 606  0084 cd0112        	call	_FLASH_WaitForLastOperation
 608                     ; 247   FLASH->CR2 &= (uint8_t)(~FLASH_CR2_OPT);
 610  0087 721f5051      	bres	20561,#7
 611                     ; 248 }
 614  008b 81            	ret
 648                     ; 255 uint8_t FLASH_ReadByte(uint32_t Address)
 648                     ; 256 {
 649                     	switch	.text
 650  008c               _FLASH_ReadByte:
 652       00000000      OFST:	set	0
 655                     ; 258   return(*(PointerAttr uint8_t *) (uint16_t)Address);
 657  008c 1e05          	ldw	x,(OFST+5,sp)
 658  008e f6            	ld	a,(x)
 661  008f 81            	ret
 719                     ; 266 void FLASH_SetProgrammingTime(FLASH_ProgramTime_TypeDef FLASH_ProgTime)
 719                     ; 267 {
 720                     	switch	.text
 721  0090               _FLASH_SetProgrammingTime:
 725                     ; 269   assert_param(IS_FLASH_PROGRAM_TIME(FLASH_ProgTime));
 727                     ; 271   FLASH->CR1 &= (uint8_t)(~FLASH_CR1_FIX);
 729  0090 72115050      	bres	20560,#0
 730                     ; 272   FLASH->CR1 |= (uint8_t)FLASH_ProgTime;
 732  0094 ca5050        	or	a,20560
 733  0097 c75050        	ld	20560,a
 734                     ; 273 }
 737  009a 81            	ret
 793                     ; 283 void FLASH_PowerWaitModeConfig(FLASH_Power_TypeDef FLASH_Power)
 793                     ; 284 {
 794                     	switch	.text
 795  009b               _FLASH_PowerWaitModeConfig:
 799                     ; 286   assert_param(IS_FLASH_POWER(FLASH_Power));
 801                     ; 289   if (FLASH_Power != FLASH_Power_On)
 803  009b a101          	cp	a,#1
 804  009d 2706          	jreq	L733
 805                     ; 291     FLASH->CR1 |= (uint8_t)FLASH_CR1_WAITM;
 807  009f 72145050      	bset	20560,#2
 809  00a3 2004          	jra	L143
 810  00a5               L733:
 811                     ; 296     FLASH->CR1 &= (uint8_t)(~FLASH_CR1_WAITM);
 813  00a5 72155050      	bres	20560,#2
 814  00a9               L143:
 815                     ; 298 }
 818  00a9 81            	ret
 843                     ; 305 FLASH_ProgramTime_TypeDef FLASH_GetProgrammingTime(void)
 843                     ; 306 {
 844                     	switch	.text
 845  00aa               _FLASH_GetProgrammingTime:
 849                     ; 307   return((FLASH_ProgramTime_TypeDef)(FLASH->CR1 & FLASH_CR1_FIX));
 851  00aa c65050        	ld	a,20560
 852  00ad a401          	and	a,#1
 855  00af 81            	ret
 889                     ; 315 uint16_t FLASH_GetBootSize(void)
 889                     ; 316 {
 890                     	switch	.text
 891  00b0               _FLASH_GetBootSize:
 893  00b0 89            	pushw	x
 894       00000002      OFST:	set	2
 897                     ; 317   uint16_t temp = 0;
 899                     ; 320   temp = (uint16_t)((uint16_t)OPT->UBC * (uint16_t)128);
 901  00b1 c64802        	ld	a,18434
 902  00b4 5f            	clrw	x
 903  00b5 97            	ld	xl,a
 904  00b6 4f            	clr	a
 905  00b7 02            	rlwa	x,a
 906  00b8 44            	srl	a
 907  00b9 56            	rrcw	x
 908  00ba 1f01          	ldw	(OFST-1,sp),x
 909                     ; 323   if (OPT->UBC > 0x7F)
 911  00bc c64802        	ld	a,18434
 912  00bf a180          	cp	a,#128
 913  00c1 2505          	jrult	L173
 914                     ; 325     temp = 8192;
 916  00c3 ae2000        	ldw	x,#8192
 917  00c6 1f01          	ldw	(OFST-1,sp),x
 918  00c8               L173:
 919                     ; 329   return(temp);
 921  00c8 1e01          	ldw	x,(OFST-1,sp)
 924  00ca 5b02          	addw	sp,#2
 925  00cc 81            	ret
 959                     ; 338 uint16_t FLASH_GetCodeSize(void)
 959                     ; 339 {
 960                     	switch	.text
 961  00cd               _FLASH_GetCodeSize:
 963  00cd 89            	pushw	x
 964       00000002      OFST:	set	2
 967                     ; 340   uint16_t temp = 0;
 969                     ; 343   temp = (uint16_t)((uint16_t)OPT->PCODESIZE * (uint16_t)128);
 971  00ce c64807        	ld	a,18439
 972  00d1 5f            	clrw	x
 973  00d2 97            	ld	xl,a
 974  00d3 4f            	clr	a
 975  00d4 02            	rlwa	x,a
 976  00d5 44            	srl	a
 977  00d6 56            	rrcw	x
 978  00d7 1f01          	ldw	(OFST-1,sp),x
 979                     ; 346   if (OPT->PCODESIZE > 0x7F)
 981  00d9 c64807        	ld	a,18439
 982  00dc a180          	cp	a,#128
 983  00de 2505          	jrult	L114
 984                     ; 348     temp = 8192;
 986  00e0 ae2000        	ldw	x,#8192
 987  00e3 1f01          	ldw	(OFST-1,sp),x
 988  00e5               L114:
 989                     ; 352   return(temp);
 991  00e5 1e01          	ldw	x,(OFST-1,sp)
 994  00e7 5b02          	addw	sp,#2
 995  00e9 81            	ret
1032                     ; 361 FunctionalState FLASH_GetReadOutProtectionStatus(void)
1032                     ; 362 {
1033                     	switch	.text
1034  00ea               _FLASH_GetReadOutProtectionStatus:
1036  00ea 88            	push	a
1037       00000001      OFST:	set	1
1040                     ; 363   FunctionalState state = DISABLE;
1042                     ; 365   if (OPT->ROP == FLASH_READOUTPROTECTION_KEY)
1044  00eb c64800        	ld	a,18432
1045  00ee a1aa          	cp	a,#170
1046  00f0 2606          	jrne	L134
1047                     ; 368     state =  ENABLE;
1049  00f2 a601          	ld	a,#1
1050  00f4 6b01          	ld	(OFST+0,sp),a
1052  00f6 2002          	jra	L334
1053  00f8               L134:
1054                     ; 373     state =  DISABLE;
1056  00f8 0f01          	clr	(OFST+0,sp)
1057  00fa               L334:
1058                     ; 376   return state;
1060  00fa 7b01          	ld	a,(OFST+0,sp)
1063  00fc 5b01          	addw	sp,#1
1064  00fe 81            	ret
1173                     ; 386 FlagStatus FLASH_GetFlagStatus(FLASH_FLAG_TypeDef FLASH_FLAG)
1173                     ; 387 {
1174                     	switch	.text
1175  00ff               _FLASH_GetFlagStatus:
1177  00ff 88            	push	a
1178       00000001      OFST:	set	1
1181                     ; 388   FlagStatus status = RESET;
1183                     ; 389   assert_param(IS_FLASH_FLAGS(FLASH_FLAG));
1185                     ; 392   if ((FLASH->IAPSR  & (uint8_t)FLASH_FLAG) != (uint8_t)RESET)
1187  0100 c45054        	and	a,20564
1188  0103 2706          	jreq	L505
1189                     ; 394     status = SET; /* Flash_FLAG is set*/
1191  0105 a601          	ld	a,#1
1192  0107 6b01          	ld	(OFST+0,sp),a
1194  0109 2002          	jra	L705
1195  010b               L505:
1196                     ; 398     status = RESET; /* Flash_FLAG is reset*/
1198  010b 0f01          	clr	(OFST+0,sp)
1199  010d               L705:
1200                     ; 402   return status;
1202  010d 7b01          	ld	a,(OFST+0,sp)
1205  010f 5b01          	addw	sp,#1
1206  0111 81            	ret
1291                     ; 524 FLASH_Status_TypeDef FLASH_WaitForLastOperation(FLASH_MemType_TypeDef FLASH_MemType) IN_RAM
1291                     ; 525 {
1292                     	switch	.text
1293  0112               _FLASH_WaitForLastOperation:
1295  0112 5205          	subw	sp,#5
1296       00000005      OFST:	set	5
1299                     ; 526   uint32_t timeout = OPERATION_TIMEOUT;
1301  0114 aeffff        	ldw	x,#65535
1302  0117 1f03          	ldw	(OFST-2,sp),x
1303  0119 ae0000        	ldw	x,#0
1304  011c 1f01          	ldw	(OFST-4,sp),x
1305                     ; 527   uint8_t flagstatus = 0x00;
1307  011e 0f05          	clr	(OFST+0,sp)
1308                     ; 529   if (FLASH_MemType == FLASH_MemType_Program)
1310  0120 a1fd          	cp	a,#253
1311  0122 2631          	jrne	L765
1313  0124 2010          	jra	L555
1314  0126               L355:
1315                     ; 533       flagstatus = (uint8_t)(FLASH->IAPSR & (uint8_t)(FLASH_IAPSR_EOP |
1315                     ; 534                              FLASH_IAPSR_WR_PG_DIS));
1317  0126 c65054        	ld	a,20564
1318  0129 a405          	and	a,#5
1319  012b 6b05          	ld	(OFST+0,sp),a
1320                     ; 535       timeout--;
1322  012d 96            	ldw	x,sp
1323  012e 1c0001        	addw	x,#OFST-4
1324  0131 a601          	ld	a,#1
1325  0133 cd0000        	call	c_lgsbc
1327  0136               L555:
1328                     ; 531   while ((flagstatus == 0x00) && (timeout != 0x00))
1330  0136 0d05          	tnz	(OFST+0,sp)
1331  0138 2628          	jrne	L365
1333  013a 96            	ldw	x,sp
1334  013b 1c0001        	addw	x,#OFST-4
1335  013e cd0000        	call	c_lzmp
1337  0141 26e3          	jrne	L355
1338  0143 201d          	jra	L365
1339  0145               L565:
1340                     ; 542       flagstatus = (uint8_t)(FLASH->IAPSR & (uint8_t)(FLASH_IAPSR_HVOFF |
1340                     ; 543                              FLASH_IAPSR_WR_PG_DIS));
1342  0145 c65054        	ld	a,20564
1343  0148 a441          	and	a,#65
1344  014a 6b05          	ld	(OFST+0,sp),a
1345                     ; 544       timeout--;
1347  014c 96            	ldw	x,sp
1348  014d 1c0001        	addw	x,#OFST-4
1349  0150 a601          	ld	a,#1
1350  0152 cd0000        	call	c_lgsbc
1352  0155               L765:
1353                     ; 540     while ((flagstatus == 0x00) && (timeout != 0x00))
1355  0155 0d05          	tnz	(OFST+0,sp)
1356  0157 2609          	jrne	L365
1358  0159 96            	ldw	x,sp
1359  015a 1c0001        	addw	x,#OFST-4
1360  015d cd0000        	call	c_lzmp
1362  0160 26e3          	jrne	L565
1363  0162               L365:
1364                     ; 547   if (timeout == 0x00 )
1366  0162 96            	ldw	x,sp
1367  0163 1c0001        	addw	x,#OFST-4
1368  0166 cd0000        	call	c_lzmp
1370  0169 2604          	jrne	L575
1371                     ; 549   flagstatus = FLASH_Status_TimeOut;
1373  016b a602          	ld	a,#2
1374  016d 6b05          	ld	(OFST+0,sp),a
1375  016f               L575:
1376                     ; 552   return((FLASH_Status_TypeDef)flagstatus);
1378  016f 7b05          	ld	a,(OFST+0,sp)
1381  0171 5b05          	addw	sp,#5
1382  0173 81            	ret
1418                     ; 567 void FLASH_PowerRunModeConfig(FLASH_Power_TypeDef FLASH_Power) IN_RAM
1418                     ; 568 {
1419                     	switch	.text
1420  0174               _FLASH_PowerRunModeConfig:
1424                     ; 570   assert_param(IS_FLASH_POWER(FLASH_Power));
1426                     ; 572   if (FLASH_Power != FLASH_Power_On)
1428  0174 a101          	cp	a,#1
1429  0176 2706          	jreq	L516
1430                     ; 574   FLASH->CR1 |= (uint8_t)FLASH_CR1_EEPM;
1432  0178 72165050      	bset	20560,#3
1434  017c 2004          	jra	L716
1435  017e               L516:
1436                     ; 578     FLASH->CR1 &= (uint8_t)(~FLASH_CR1_EEPM);
1438  017e 72175050      	bres	20560,#3
1439  0182               L716:
1440                     ; 580 }
1443  0182 81            	ret
1507                     ; 593 FLASH_PowerStatus_TypeDef FLASH_GetPowerStatus(void) IN_RAM
1507                     ; 594 {
1508                     	switch	.text
1509  0183               _FLASH_GetPowerStatus:
1513                     ; 595   return((FLASH_PowerStatus_TypeDef)(FLASH->CR1 & (uint8_t)0x0C));
1515  0183 c65050        	ld	a,20560
1516  0186 a40c          	and	a,#12
1519  0188 81            	ret
1623                     ; 611 void FLASH_ProgramBlock(uint16_t BlockNum, FLASH_MemType_TypeDef FLASH_MemType,
1623                     ; 612                         FLASH_ProgramMode_TypeDef FLASH_ProgMode, uint8_t *Buffer) IN_RAM
1623                     ; 613 {
1624                     	switch	.text
1625  0189               _FLASH_ProgramBlock:
1627  0189 89            	pushw	x
1628  018a 5206          	subw	sp,#6
1629       00000006      OFST:	set	6
1632                     ; 614   uint16_t Count = 0;
1634                     ; 615   uint32_t startaddress = 0;
1636                     ; 618   assert_param(IS_FLASH_MEMORY_TYPE(FLASH_MemType));
1638                     ; 619   assert_param(IS_FLASH_PROGRAM_MODE(FLASH_ProgMode));
1640                     ; 620   if (FLASH_MemType == FLASH_MemType_Program)
1642  018c 7b0b          	ld	a,(OFST+5,sp)
1643  018e a1fd          	cp	a,#253
1644  0190 260c          	jrne	L717
1645                     ; 622   assert_param(IS_FLASH_PROGRAM_BLOCK_NUMBER(BlockNum));
1647                     ; 623     startaddress = FLASH_PROGRAM_START_PHYSICAL_ADDRESS;
1649  0192 ae8000        	ldw	x,#32768
1650  0195 1f03          	ldw	(OFST-3,sp),x
1651  0197 ae0000        	ldw	x,#0
1652  019a 1f01          	ldw	(OFST-5,sp),x
1654  019c 200a          	jra	L127
1655  019e               L717:
1656                     ; 627     assert_param(IS_FLASH_DATA_EEPROM_BLOCK_NUMBER(BlockNum));
1658                     ; 628     startaddress = FLASH_DATA_EEPROM_START_PHYSICAL_ADDRESS;
1660  019e ae1000        	ldw	x,#4096
1661  01a1 1f03          	ldw	(OFST-3,sp),x
1662  01a3 ae0000        	ldw	x,#0
1663  01a6 1f01          	ldw	(OFST-5,sp),x
1664  01a8               L127:
1665                     ; 632   startaddress = startaddress + ((uint32_t)BlockNum * FLASH_BLOCK_SIZE);
1667  01a8 1e07          	ldw	x,(OFST+1,sp)
1668  01aa a680          	ld	a,#128
1669  01ac cd0000        	call	c_cmulx
1671  01af 96            	ldw	x,sp
1672  01b0 1c0001        	addw	x,#OFST-5
1673  01b3 cd0000        	call	c_lgadd
1675                     ; 635   if (FLASH_ProgMode == FLASH_ProgramMode_Standard)
1677  01b6 0d0c          	tnz	(OFST+6,sp)
1678  01b8 2606          	jrne	L327
1679                     ; 638   FLASH->CR2 |= FLASH_CR2_PRG;
1681  01ba 72105051      	bset	20561,#0
1683  01be 2004          	jra	L527
1684  01c0               L327:
1685                     ; 643   FLASH->CR2 |= FLASH_CR2_FPRG;
1687  01c0 72185051      	bset	20561,#4
1688  01c4               L527:
1689                     ; 647   for (Count = 0; Count < FLASH_BLOCK_SIZE; Count++)
1691  01c4 5f            	clrw	x
1692  01c5 1f05          	ldw	(OFST-1,sp),x
1693  01c7               L727:
1694                     ; 650   *((PointerAttr uint8_t*) (uint16_t)startaddress + Count) = ((uint8_t)(Buffer[Count]));
1696  01c7 1e0d          	ldw	x,(OFST+7,sp)
1697  01c9 72fb05        	addw	x,(OFST-1,sp)
1698  01cc f6            	ld	a,(x)
1699  01cd 1e03          	ldw	x,(OFST-3,sp)
1700  01cf 72fb05        	addw	x,(OFST-1,sp)
1701  01d2 f7            	ld	(x),a
1702                     ; 647   for (Count = 0; Count < FLASH_BLOCK_SIZE; Count++)
1704  01d3 1e05          	ldw	x,(OFST-1,sp)
1705  01d5 1c0001        	addw	x,#1
1706  01d8 1f05          	ldw	(OFST-1,sp),x
1709  01da 1e05          	ldw	x,(OFST-1,sp)
1710  01dc a30080        	cpw	x,#128
1711  01df 25e6          	jrult	L727
1712                     ; 655 }
1715  01e1 5b08          	addw	sp,#8
1716  01e3 81            	ret
1779                     ; 668 void FLASH_EraseBlock(uint16_t BlockNum, FLASH_MemType_TypeDef FLASH_MemType) IN_RAM
1779                     ; 669 {
1780                     	switch	.text
1781  01e4               _FLASH_EraseBlock:
1783  01e4 89            	pushw	x
1784  01e5 5206          	subw	sp,#6
1785       00000006      OFST:	set	6
1788                     ; 670   uint32_t startaddress = 0;
1790                     ; 678   assert_param(IS_FLASH_MEMORY_TYPE(FLASH_MemType));
1792                     ; 679   if (FLASH_MemType == FLASH_MemType_Program)
1794  01e7 7b0b          	ld	a,(OFST+5,sp)
1795  01e9 a1fd          	cp	a,#253
1796  01eb 260c          	jrne	L767
1797                     ; 681   assert_param(IS_FLASH_PROGRAM_BLOCK_NUMBER(BlockNum));
1799                     ; 682     startaddress = FLASH_PROGRAM_START_PHYSICAL_ADDRESS;
1801  01ed ae8000        	ldw	x,#32768
1802  01f0 1f05          	ldw	(OFST-1,sp),x
1803  01f2 ae0000        	ldw	x,#0
1804  01f5 1f03          	ldw	(OFST-3,sp),x
1806  01f7 200a          	jra	L177
1807  01f9               L767:
1808                     ; 686     assert_param(IS_FLASH_DATA_EEPROM_BLOCK_NUMBER(BlockNum));
1810                     ; 687     startaddress = FLASH_DATA_EEPROM_START_PHYSICAL_ADDRESS;
1812  01f9 ae1000        	ldw	x,#4096
1813  01fc 1f05          	ldw	(OFST-1,sp),x
1814  01fe ae0000        	ldw	x,#0
1815  0201 1f03          	ldw	(OFST-3,sp),x
1816  0203               L177:
1817                     ; 692   pwFlash = (PointerAttr uint32_t *)(uint16_t)(startaddress + ((uint32_t)BlockNum * FLASH_BLOCK_SIZE));
1819  0203 1e07          	ldw	x,(OFST+1,sp)
1820  0205 a680          	ld	a,#128
1821  0207 cd0000        	call	c_cmulx
1823  020a 96            	ldw	x,sp
1824  020b 1c0003        	addw	x,#OFST-3
1825  020e cd0000        	call	c_ladd
1827  0211 be02          	ldw	x,c_lreg+2
1828  0213 1f01          	ldw	(OFST-5,sp),x
1829                     ; 698   FLASH->CR2 |= FLASH_CR2_ERASE;
1831  0215 721a5051      	bset	20561,#5
1832                     ; 701   *pwFlash = (uint32_t)0;
1834  0219 1e01          	ldw	x,(OFST-5,sp)
1835  021b a600          	ld	a,#0
1836  021d e703          	ld	(3,x),a
1837  021f a600          	ld	a,#0
1838  0221 e702          	ld	(2,x),a
1839  0223 a600          	ld	a,#0
1840  0225 e701          	ld	(1,x),a
1841  0227 a600          	ld	a,#0
1842  0229 f7            	ld	(x),a
1843                     ; 708 }
1846  022a 5b08          	addw	sp,#8
1847  022c 81            	ret
1860                     	xdef	_FLASH_EraseBlock
1861                     	xdef	_FLASH_ProgramBlock
1862                     	xdef	_FLASH_GetPowerStatus
1863                     	xdef	_FLASH_PowerRunModeConfig
1864                     	xdef	_FLASH_WaitForLastOperation
1865                     	xdef	_FLASH_GetFlagStatus
1866                     	xdef	_FLASH_PowerWaitModeConfig
1867                     	xdef	_FLASH_GetReadOutProtectionStatus
1868                     	xdef	_FLASH_GetCodeSize
1869                     	xdef	_FLASH_GetBootSize
1870                     	xdef	_FLASH_SetProgrammingTime
1871                     	xdef	_FLASH_GetProgrammingTime
1872                     	xdef	_FLASH_EraseOptionByte
1873                     	xdef	_FLASH_ProgramOptionByte
1874                     	xdef	_FLASH_ReadByte
1875                     	xdef	_FLASH_ProgramWord
1876                     	xdef	_FLASH_EraseByte
1877                     	xdef	_FLASH_ProgramByte
1878                     	xdef	_FLASH_ITConfig
1879                     	xdef	_FLASH_Lock
1880                     	xdef	_FLASH_Unlock
1881                     	xdef	_FLASH_DeInit
1882                     	xref.b	c_lreg
1901                     	xref	c_ladd
1902                     	xref	c_lgadd
1903                     	xref	c_cmulx
1904                     	xref	c_lzmp
1905                     	xref	c_lgsbc
1906                     	end
