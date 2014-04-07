   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.19 - 04 Sep 2013
   3                     ; Generator (Limited) V4.3.11 - 04 Sep 2013
 111                     ; 45 void GPIO_DeInit(GPIO_TypeDef* GPIOx)
 111                     ; 46 {
 113                     	switch	.text
 114  0000               _GPIO_DeInit:
 118                     ; 47   GPIOx->CR2 = GPIO_CR2_RESET_VALUE; /* Reset Control Register 2 */
 120  0000 6f04          	clr	(4,x)
 121                     ; 48   GPIOx->ODR = GPIO_ODR_RESET_VALUE; /* Reset Output Data Register */
 123  0002 7f            	clr	(x)
 124                     ; 49   GPIOx->DDR = GPIO_DDR_RESET_VALUE; /* Reset Data Direction Register */
 126  0003 6f02          	clr	(2,x)
 127                     ; 50   GPIOx->CR1 = GPIO_CR1_RESET_VALUE; /* Reset Control Register 1 */
 129  0005 6f03          	clr	(3,x)
 130                     ; 51 }
 133  0007 81            	ret
 289                     ; 63 void GPIO_Init(GPIO_TypeDef* GPIOx,
 289                     ; 64                uint8_t GPIO_Pin,
 289                     ; 65                GPIO_Mode_TypeDef GPIO_Mode)
 289                     ; 66 {
 290                     	switch	.text
 291  0008               _GPIO_Init:
 293  0008 89            	pushw	x
 294       00000000      OFST:	set	0
 297                     ; 71   assert_param(IS_GPIO_MODE(GPIO_Mode));
 299                     ; 72   assert_param(IS_GPIO_PIN(GPIO_Pin));
 301                     ; 75   GPIOx->CR2 &= (uint8_t)(~(GPIO_Pin));
 303  0009 7b05          	ld	a,(OFST+5,sp)
 304  000b 43            	cpl	a
 305  000c e404          	and	a,(4,x)
 306  000e e704          	ld	(4,x),a
 307                     ; 81   if ((((uint8_t)(GPIO_Mode)) & (uint8_t)0x80) != (uint8_t)0x00) /* Output mode */
 309  0010 7b06          	ld	a,(OFST+6,sp)
 310  0012 a580          	bcp	a,#128
 311  0014 271d          	jreq	L541
 312                     ; 83     if ((((uint8_t)(GPIO_Mode)) & (uint8_t)0x10) != (uint8_t)0x00) /* High level */
 314  0016 7b06          	ld	a,(OFST+6,sp)
 315  0018 a510          	bcp	a,#16
 316  001a 2706          	jreq	L741
 317                     ; 85       GPIOx->ODR |= GPIO_Pin;
 319  001c f6            	ld	a,(x)
 320  001d 1a05          	or	a,(OFST+5,sp)
 321  001f f7            	ld	(x),a
 323  0020 2007          	jra	L151
 324  0022               L741:
 325                     ; 88       GPIOx->ODR &= (uint8_t)(~(GPIO_Pin));
 327  0022 1e01          	ldw	x,(OFST+1,sp)
 328  0024 7b05          	ld	a,(OFST+5,sp)
 329  0026 43            	cpl	a
 330  0027 f4            	and	a,(x)
 331  0028 f7            	ld	(x),a
 332  0029               L151:
 333                     ; 91     GPIOx->DDR |= GPIO_Pin;
 335  0029 1e01          	ldw	x,(OFST+1,sp)
 336  002b e602          	ld	a,(2,x)
 337  002d 1a05          	or	a,(OFST+5,sp)
 338  002f e702          	ld	(2,x),a
 340  0031 2009          	jra	L351
 341  0033               L541:
 342                     ; 95     GPIOx->DDR &= (uint8_t)(~(GPIO_Pin));
 344  0033 1e01          	ldw	x,(OFST+1,sp)
 345  0035 7b05          	ld	a,(OFST+5,sp)
 346  0037 43            	cpl	a
 347  0038 e402          	and	a,(2,x)
 348  003a e702          	ld	(2,x),a
 349  003c               L351:
 350                     ; 102   if ((((uint8_t)(GPIO_Mode)) & (uint8_t)0x40) != (uint8_t)0x00) /* Pull-Up or Push-Pull */
 352  003c 7b06          	ld	a,(OFST+6,sp)
 353  003e a540          	bcp	a,#64
 354  0040 270a          	jreq	L551
 355                     ; 104     GPIOx->CR1 |= GPIO_Pin;
 357  0042 1e01          	ldw	x,(OFST+1,sp)
 358  0044 e603          	ld	a,(3,x)
 359  0046 1a05          	or	a,(OFST+5,sp)
 360  0048 e703          	ld	(3,x),a
 362  004a 2009          	jra	L751
 363  004c               L551:
 364                     ; 107     GPIOx->CR1 &= (uint8_t)(~(GPIO_Pin));
 366  004c 1e01          	ldw	x,(OFST+1,sp)
 367  004e 7b05          	ld	a,(OFST+5,sp)
 368  0050 43            	cpl	a
 369  0051 e403          	and	a,(3,x)
 370  0053 e703          	ld	(3,x),a
 371  0055               L751:
 372                     ; 114   if ((((uint8_t)(GPIO_Mode)) & (uint8_t)0x20) != (uint8_t)0x00) /* Interrupt or Slow slope */
 374  0055 7b06          	ld	a,(OFST+6,sp)
 375  0057 a520          	bcp	a,#32
 376  0059 270a          	jreq	L161
 377                     ; 116     GPIOx->CR2 |= GPIO_Pin;
 379  005b 1e01          	ldw	x,(OFST+1,sp)
 380  005d e604          	ld	a,(4,x)
 381  005f 1a05          	or	a,(OFST+5,sp)
 382  0061 e704          	ld	(4,x),a
 384  0063 2009          	jra	L361
 385  0065               L161:
 386                     ; 119     GPIOx->CR2 &= (uint8_t)(~(GPIO_Pin));
 388  0065 1e01          	ldw	x,(OFST+1,sp)
 389  0067 7b05          	ld	a,(OFST+5,sp)
 390  0069 43            	cpl	a
 391  006a e404          	and	a,(4,x)
 392  006c e704          	ld	(4,x),a
 393  006e               L361:
 394                     ; 122 }
 397  006e 85            	popw	x
 398  006f 81            	ret
 444                     ; 132 void GPIO_Write(GPIO_TypeDef* GPIOx, uint8_t GPIO_PortVal)
 444                     ; 133 {
 445                     	switch	.text
 446  0070               _GPIO_Write:
 448  0070 89            	pushw	x
 449       00000000      OFST:	set	0
 452                     ; 134   GPIOx->ODR = GPIO_PortVal;
 454  0071 7b05          	ld	a,(OFST+5,sp)
 455  0073 1e01          	ldw	x,(OFST+1,sp)
 456  0075 f7            	ld	(x),a
 457                     ; 135 }
 460  0076 85            	popw	x
 461  0077 81            	ret
 621                     ; 146 void GPIO_WriteBit(GPIO_TypeDef* GPIOx, GPIO_Pin_TypeDef GPIO_Pin, BitAction GPIO_BitVal)
 621                     ; 147 {
 622                     	switch	.text
 623  0078               _GPIO_WriteBit:
 625  0078 89            	pushw	x
 626       00000000      OFST:	set	0
 629                     ; 149   assert_param(IS_GPIO_PIN(GPIO_Pin));
 631                     ; 150   assert_param(IS_STATE_VALUE(GPIO_BitVal));
 633                     ; 152   if (GPIO_BitVal != RESET)
 635  0079 0d06          	tnz	(OFST+6,sp)
 636  007b 2706          	jreq	L303
 637                     ; 154     GPIOx->ODR |= GPIO_Pin;
 639  007d f6            	ld	a,(x)
 640  007e 1a05          	or	a,(OFST+5,sp)
 641  0080 f7            	ld	(x),a
 643  0081 2007          	jra	L503
 644  0083               L303:
 645                     ; 159     GPIOx->ODR &= (uint8_t)(~GPIO_Pin);
 647  0083 1e01          	ldw	x,(OFST+1,sp)
 648  0085 7b05          	ld	a,(OFST+5,sp)
 649  0087 43            	cpl	a
 650  0088 f4            	and	a,(x)
 651  0089 f7            	ld	(x),a
 652  008a               L503:
 653                     ; 161 }
 656  008a 85            	popw	x
 657  008b 81            	ret
 703                     ; 170 void GPIO_SetBits(GPIO_TypeDef* GPIOx, uint8_t GPIO_Pin)
 703                     ; 171 {
 704                     	switch	.text
 705  008c               _GPIO_SetBits:
 707  008c 89            	pushw	x
 708       00000000      OFST:	set	0
 711                     ; 172   GPIOx->ODR |= GPIO_Pin;
 713  008d f6            	ld	a,(x)
 714  008e 1a05          	or	a,(OFST+5,sp)
 715  0090 f7            	ld	(x),a
 716                     ; 173 }
 719  0091 85            	popw	x
 720  0092 81            	ret
 766                     ; 183 void GPIO_ResetBits(GPIO_TypeDef* GPIOx, uint8_t GPIO_Pin)
 766                     ; 184 {
 767                     	switch	.text
 768  0093               _GPIO_ResetBits:
 770  0093 89            	pushw	x
 771       00000000      OFST:	set	0
 774                     ; 185   GPIOx->ODR &= (uint8_t)(~GPIO_Pin);
 776  0094 7b05          	ld	a,(OFST+5,sp)
 777  0096 43            	cpl	a
 778  0097 f4            	and	a,(x)
 779  0098 f7            	ld	(x),a
 780                     ; 186 }
 783  0099 85            	popw	x
 784  009a 81            	ret
 830                     ; 195 void GPIO_ToggleBits(GPIO_TypeDef* GPIOx, uint8_t GPIO_Pin)
 830                     ; 196 {
 831                     	switch	.text
 832  009b               _GPIO_ToggleBits:
 834  009b 89            	pushw	x
 835       00000000      OFST:	set	0
 838                     ; 197   GPIOx->ODR ^= GPIO_Pin;
 840  009c f6            	ld	a,(x)
 841  009d 1805          	xor	a,	(OFST+5,sp)
 842  009f f7            	ld	(x),a
 843                     ; 198 }
 846  00a0 85            	popw	x
 847  00a1 81            	ret
 884                     ; 206 uint8_t GPIO_ReadInputData(GPIO_TypeDef* GPIOx)
 884                     ; 207 {
 885                     	switch	.text
 886  00a2               _GPIO_ReadInputData:
 890                     ; 208   return ((uint8_t)GPIOx->IDR);
 892  00a2 e601          	ld	a,(1,x)
 895  00a4 81            	ret
 933                     ; 217 uint8_t GPIO_ReadOutputData(GPIO_TypeDef* GPIOx)
 933                     ; 218 {
 934                     	switch	.text
 935  00a5               _GPIO_ReadOutputData:
 939                     ; 219   return ((uint8_t)GPIOx->ODR);
 941  00a5 f6            	ld	a,(x)
 944  00a6 81            	ret
 993                     ; 228 BitStatus GPIO_ReadInputDataBit(GPIO_TypeDef* GPIOx, GPIO_Pin_TypeDef GPIO_Pin)
 993                     ; 229 {
 994                     	switch	.text
 995  00a7               _GPIO_ReadInputDataBit:
 997  00a7 89            	pushw	x
 998       00000000      OFST:	set	0
1001                     ; 230   return ((BitStatus)(GPIOx->IDR & (uint8_t)GPIO_Pin));
1003  00a8 e601          	ld	a,(1,x)
1004  00aa 1405          	and	a,(OFST+5,sp)
1007  00ac 85            	popw	x
1008  00ad 81            	ret
1057                     ; 239 BitStatus GPIO_ReadOutputDataBit(GPIO_TypeDef* GPIOx, GPIO_Pin_TypeDef GPIO_Pin)
1057                     ; 240 {
1058                     	switch	.text
1059  00ae               _GPIO_ReadOutputDataBit:
1061  00ae 89            	pushw	x
1062       00000000      OFST:	set	0
1065                     ; 241   return ((BitStatus)(GPIOx->ODR & (uint8_t)GPIO_Pin));
1067  00af f6            	ld	a,(x)
1068  00b0 1405          	and	a,(OFST+5,sp)
1071  00b2 85            	popw	x
1072  00b3 81            	ret
1149                     ; 251 void GPIO_ExternalPullUpConfig(GPIO_TypeDef* GPIOx, uint8_t GPIO_Pin, FunctionalState NewState)
1149                     ; 252 {
1150                     	switch	.text
1151  00b4               _GPIO_ExternalPullUpConfig:
1153  00b4 89            	pushw	x
1154       00000000      OFST:	set	0
1157                     ; 254   assert_param(IS_GPIO_PIN(GPIO_Pin));
1159                     ; 255   assert_param(IS_FUNCTIONAL_STATE(NewState));
1161                     ; 257   if (NewState != DISABLE) /* External Pull-Up Set*/
1163  00b5 0d06          	tnz	(OFST+6,sp)
1164  00b7 2708          	jreq	L355
1165                     ; 259     GPIOx->CR1 |= GPIO_Pin;
1167  00b9 e603          	ld	a,(3,x)
1168  00bb 1a05          	or	a,(OFST+5,sp)
1169  00bd e703          	ld	(3,x),a
1171  00bf 2009          	jra	L555
1172  00c1               L355:
1173                     ; 262     GPIOx->CR1 &= (uint8_t)(~(GPIO_Pin));
1175  00c1 1e01          	ldw	x,(OFST+1,sp)
1176  00c3 7b05          	ld	a,(OFST+5,sp)
1177  00c5 43            	cpl	a
1178  00c6 e403          	and	a,(3,x)
1179  00c8 e703          	ld	(3,x),a
1180  00ca               L555:
1181                     ; 264 }
1184  00ca 85            	popw	x
1185  00cb 81            	ret
1198                     	xdef	_GPIO_ExternalPullUpConfig
1199                     	xdef	_GPIO_ReadOutputDataBit
1200                     	xdef	_GPIO_ReadInputDataBit
1201                     	xdef	_GPIO_ReadOutputData
1202                     	xdef	_GPIO_ReadInputData
1203                     	xdef	_GPIO_ToggleBits
1204                     	xdef	_GPIO_ResetBits
1205                     	xdef	_GPIO_SetBits
1206                     	xdef	_GPIO_WriteBit
1207                     	xdef	_GPIO_Write
1208                     	xdef	_GPIO_Init
1209                     	xdef	_GPIO_DeInit
1228                     	end
