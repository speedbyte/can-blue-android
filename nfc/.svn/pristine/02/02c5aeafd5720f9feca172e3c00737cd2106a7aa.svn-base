   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.13 - 06 Dec 2012
   3                     ; Generator (Limited) V4.3.9 - 06 Dec 2012
  45                     ; 46 void PWR_DeInit(void)
  45                     ; 47 {
  47                     	switch	.text
  48  0000               _PWR_DeInit:
  52                     ; 48   PWR->CSR1 = PWR_CSR1_PVDIF;
  54  0000 352050b2      	mov	20658,#32
  55                     ; 49   PWR->CSR2 = PWR_CSR2_RESET_VALUE;
  57  0004 725f50b3      	clr	20659
  58                     ; 50 }
  61  0008 81            	ret
 116                     ; 57 void PWR_FastWakeUpCmd(FunctionalState NewState)
 116                     ; 58 {
 117                     	switch	.text
 118  0009               _PWR_FastWakeUpCmd:
 122                     ; 60   assert_param(IS_FUNCTIONAL_STATE(NewState));
 124                     ; 62   if (NewState != DISABLE)
 126  0009 4d            	tnz	a
 127  000a 2706          	jreq	L74
 128                     ; 65     PWR->CSR2 |= PWR_CSR2_FWU;
 130  000c 721450b3      	bset	20659,#2
 132  0010 2004          	jra	L15
 133  0012               L74:
 134                     ; 70     PWR->CSR2 &= (uint8_t)(~PWR_CSR2_FWU);
 136  0012 721550b3      	bres	20659,#2
 137  0016               L15:
 138                     ; 72 }
 141  0016 81            	ret
 177                     ; 79 void PWR_UltraLowPowerCmd(FunctionalState NewState)
 177                     ; 80 {
 178                     	switch	.text
 179  0017               _PWR_UltraLowPowerCmd:
 183                     ; 82   assert_param(IS_FUNCTIONAL_STATE(NewState));
 185                     ; 84   if (NewState != DISABLE)
 187  0017 4d            	tnz	a
 188  0018 2706          	jreq	L17
 189                     ; 87     PWR->CSR2 |= PWR_CSR2_ULP;
 191  001a 721250b3      	bset	20659,#1
 193  001e 2004          	jra	L37
 194  0020               L17:
 195                     ; 92     PWR->CSR2 &= (uint8_t)(~PWR_CSR2_ULP);
 197  0020 721350b3      	bres	20659,#1
 198  0024               L37:
 199                     ; 94 }
 202  0024 81            	ret
 237                     ; 101 void PWR_PVDCmd(FunctionalState NewState)
 237                     ; 102 {
 238                     	switch	.text
 239  0025               _PWR_PVDCmd:
 243                     ; 104   assert_param(IS_FUNCTIONAL_STATE(NewState));
 245                     ; 106   if (NewState != DISABLE)
 247  0025 4d            	tnz	a
 248  0026 2706          	jreq	L311
 249                     ; 109     PWR->CSR1 |= PWR_CSR1_PVDE;
 251  0028 721050b2      	bset	20658,#0
 253  002c 2004          	jra	L511
 254  002e               L311:
 255                     ; 114     PWR->CSR1 &= (uint8_t)(~PWR_CSR1_PVDE);
 257  002e 721150b2      	bres	20658,#0
 258  0032               L511:
 259                     ; 116 }
 262  0032 81            	ret
 297                     ; 123 void PWR_PVDITConfig(FunctionalState NewState)
 297                     ; 124 {
 298                     	switch	.text
 299  0033               _PWR_PVDITConfig:
 303                     ; 126   assert_param(IS_FUNCTIONAL_STATE(NewState));
 305                     ; 128   if (NewState != DISABLE)
 307  0033 4d            	tnz	a
 308  0034 2706          	jreq	L531
 309                     ; 131     PWR->CSR1 |= PWR_CSR1_PVDIEN;
 311  0036 721850b2      	bset	20658,#4
 313  003a 2004          	jra	L731
 314  003c               L531:
 315                     ; 136     PWR->CSR1 &= (uint8_t)(~PWR_CSR1_PVDIEN);
 317  003c 721950b2      	bres	20658,#4
 318  0040               L731:
 319                     ; 138 }
 322  0040 81            	ret
 419                     ; 146 void PWR_PVDLevelConfig(PWR_PVDLevel_TypeDef PWR_PVDLevel)
 419                     ; 147 {
 420                     	switch	.text
 421  0041               _PWR_PVDLevelConfig:
 423  0041 88            	push	a
 424       00000000      OFST:	set	0
 427                     ; 149   assert_param(IS_PWR_PVD_LEVEL(PWR_PVDLevel));
 429                     ; 152   PWR->CSR1 &= (uint8_t)(~PWR_CSR1_PLS);
 431  0042 c650b2        	ld	a,20658
 432  0045 a4f1          	and	a,#241
 433  0047 c750b2        	ld	20658,a
 434                     ; 155   PWR->CSR1 |= PWR_PVDLevel;
 436  004a c650b2        	ld	a,20658
 437  004d 1a01          	or	a,(OFST+1,sp)
 438  004f c750b2        	ld	20658,a
 439                     ; 157 }
 442  0052 84            	pop	a
 443  0053 81            	ret
 536                     ; 165 FlagStatus PWR_GetFlagStatus(PWR_FLAG_TypeDef PWR_FLAG)
 536                     ; 166 {
 537                     	switch	.text
 538  0054               _PWR_GetFlagStatus:
 540  0054 88            	push	a
 541  0055 88            	push	a
 542       00000001      OFST:	set	1
 545                     ; 167   FlagStatus bitstatus = RESET;
 547                     ; 170   assert_param(IS_PWR_FLAG(PWR_FLAG));
 549                     ; 172   if ((PWR_FLAG & PWR_FLAG_VREFINTF) != 0)
 551  0056 a501          	bcp	a,#1
 552  0058 2711          	jreq	L742
 553                     ; 174     if ((PWR->CSR2 & PWR_CR2_VREFINTF) != (uint8_t)RESET )
 555  005a c650b3        	ld	a,20659
 556  005d a501          	bcp	a,#1
 557  005f 2706          	jreq	L152
 558                     ; 176       bitstatus = SET;
 560  0061 a601          	ld	a,#1
 561  0063 6b01          	ld	(OFST+0,sp),a
 563  0065 2013          	jra	L552
 564  0067               L152:
 565                     ; 180       bitstatus = RESET;
 567  0067 0f01          	clr	(OFST+0,sp)
 568  0069 200f          	jra	L552
 569  006b               L742:
 570                     ; 185     if ((PWR->CSR1 & PWR_FLAG) != (uint8_t)RESET )
 572  006b c650b2        	ld	a,20658
 573  006e 1502          	bcp	a,(OFST+1,sp)
 574  0070 2706          	jreq	L752
 575                     ; 187       bitstatus = SET;
 577  0072 a601          	ld	a,#1
 578  0074 6b01          	ld	(OFST+0,sp),a
 580  0076 2002          	jra	L552
 581  0078               L752:
 582                     ; 191       bitstatus = RESET;
 584  0078 0f01          	clr	(OFST+0,sp)
 585  007a               L552:
 586                     ; 196   return((FlagStatus)bitstatus);
 588  007a 7b01          	ld	a,(OFST+0,sp)
 591  007c 85            	popw	x
 592  007d 81            	ret
 615                     ; 203 void PWR_PVDClearFlag(void)
 615                     ; 204 {
 616                     	switch	.text
 617  007e               _PWR_PVDClearFlag:
 621                     ; 206   PWR->CSR1 |= PWR_CSR1_PVDIF;
 623  007e 721a50b2      	bset	20658,#5
 624                     ; 207 }
 627  0082 81            	ret
 681                     ; 214 ITStatus PWR_PVDGetITStatus(void)
 681                     ; 215 {
 682                     	switch	.text
 683  0083               _PWR_PVDGetITStatus:
 685  0083 89            	pushw	x
 686       00000002      OFST:	set	2
 689                     ; 216   ITStatus bitstatus = RESET;
 691                     ; 218   uint8_t PVD_itStatus = 0x0, PVD_itEnable = 0x0;
 695                     ; 220   PVD_itStatus = (uint8_t)(PWR->CSR1 & (uint8_t)PWR_CSR1_PVDIF);
 697  0084 c650b2        	ld	a,20658
 698  0087 a420          	and	a,#32
 699  0089 6b01          	ld	(OFST-1,sp),a
 700                     ; 221   PVD_itEnable = (uint8_t)(PWR->CSR1 & (uint8_t)PWR_CSR1_PVDIEN);
 702  008b c650b2        	ld	a,20658
 703  008e a410          	and	a,#16
 704  0090 6b02          	ld	(OFST+0,sp),a
 705                     ; 223   if ((PVD_itStatus != (uint8_t)RESET ) && (PVD_itEnable != (uint8_t)RESET))
 707  0092 0d01          	tnz	(OFST-1,sp)
 708  0094 270a          	jreq	L123
 710  0096 0d02          	tnz	(OFST+0,sp)
 711  0098 2706          	jreq	L123
 712                     ; 225     bitstatus = (ITStatus)SET;
 714  009a a601          	ld	a,#1
 715  009c 6b02          	ld	(OFST+0,sp),a
 717  009e 2002          	jra	L323
 718  00a0               L123:
 719                     ; 229     bitstatus = (ITStatus)RESET;
 721  00a0 0f02          	clr	(OFST+0,sp)
 722  00a2               L323:
 723                     ; 231   return ((ITStatus)bitstatus);
 725  00a2 7b02          	ld	a,(OFST+0,sp)
 728  00a4 85            	popw	x
 729  00a5 81            	ret
 753                     ; 239 void PWR_PVDClearITPendingBit(void)
 753                     ; 240 {
 754                     	switch	.text
 755  00a6               _PWR_PVDClearITPendingBit:
 759                     ; 242   PWR->CSR1 |= PWR_CSR1_PVDIF;
 761  00a6 721a50b2      	bset	20658,#5
 762                     ; 243 }
 765  00aa 81            	ret
 778                     	xdef	_PWR_PVDClearITPendingBit
 779                     	xdef	_PWR_PVDGetITStatus
 780                     	xdef	_PWR_PVDClearFlag
 781                     	xdef	_PWR_GetFlagStatus
 782                     	xdef	_PWR_PVDLevelConfig
 783                     	xdef	_PWR_PVDITConfig
 784                     	xdef	_PWR_PVDCmd
 785                     	xdef	_PWR_UltraLowPowerCmd
 786                     	xdef	_PWR_FastWakeUpCmd
 787                     	xdef	_PWR_DeInit
 806                     	end
