   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.19 - 04 Sep 2013
   3                     ; Generator (Limited) V4.3.11 - 04 Sep 2013
  46                     ; 38 INTERRUPT_HANDLER(NonHandledInterrupt,0)
  46                     ; 39 {
  47                     	switch	.text
  48  0000               f_NonHandledInterrupt:
  52  0000               L12:
  53                     ; 43   while (1);
  55  0000 20fe          	jra	L12
  77                     ; 53 INTERRUPT_HANDLER_TRAP(TRAP_IRQHandler)
  77                     ; 54 {
  78                     	switch	.text
  79  0002               f_TRAP_IRQHandler:
  83  0002               L53:
  84                     ; 58   while (1);
  86  0002 20fe          	jra	L53
 108                     ; 68 INTERRUPT_HANDLER(FLASH_IRQHandler,1)
 108                     ; 69 {
 109                     	switch	.text
 110  0004               f_FLASH_IRQHandler:
 114  0004               L15:
 115                     ; 73   while (1);
 117  0004 20fe          	jra	L15
 140                     ; 83 INTERRUPT_HANDLER(DMA1_CHANNEL0_1_IRQHandler,2)
 140                     ; 84 {
 141                     	switch	.text
 142  0006               f_DMA1_CHANNEL0_1_IRQHandler:
 146  0006               L56:
 147                     ; 88   while (1);
 149  0006 20fe          	jra	L56
 172                     ; 98 INTERRUPT_HANDLER(DMA1_CHANNEL2_3_IRQHandler,3)
 172                     ; 99 {
 173                     	switch	.text
 174  0008               f_DMA1_CHANNEL2_3_IRQHandler:
 178  0008               L101:
 179                     ; 103   while (1);
 181  0008 20fe          	jra	L101
 203                     ; 114 INTERRUPT_HANDLER(RTC_IRQHandler,4)
 203                     ; 115 {
 204                     	switch	.text
 205  000a               f_RTC_IRQHandler:
 209  000a               L511:
 210                     ; 119   while (1);
 212  000a 20fe          	jra	L511
 235                     ; 129 INTERRUPT_HANDLER(EXTIE_F_PVD_IRQHandler,5)
 235                     ; 130 {
 236                     	switch	.text
 237  000c               f_EXTIE_F_PVD_IRQHandler:
 241  000c               L131:
 242                     ; 134   while (1);
 244  000c 20fe          	jra	L131
 266                     ; 145 INTERRUPT_HANDLER(EXTIB_IRQHandler,6)
 266                     ; 146 {
 267                     	switch	.text
 268  000e               f_EXTIB_IRQHandler:
 272  000e               L541:
 273                     ; 150   while (1);
 275  000e 20fe          	jra	L541
 297                     ; 161 INTERRUPT_HANDLER(EXTID_IRQHandler,7)
 297                     ; 162 {
 298                     	switch	.text
 299  0010               f_EXTID_IRQHandler:
 303  0010               L161:
 304                     ; 166   while (1);
 306  0010 20fe          	jra	L161
 328                     ; 178 INTERRUPT_HANDLER(EXTI0_IRQHandler,8)
 328                     ; 179 {
 329                     	switch	.text
 330  0012               f_EXTI0_IRQHandler:
 334  0012               L571:
 335                     ; 183   while (1);
 337  0012 20fe          	jra	L571
 359                     ; 194 INTERRUPT_HANDLER(EXTI1_IRQHandler,9)
 359                     ; 195 {
 360                     	switch	.text
 361  0014               f_EXTI1_IRQHandler:
 365  0014               L112:
 366                     ; 199    while (1);
 368  0014 20fe          	jra	L112
 390                     ; 212 INTERRUPT_HANDLER(EXTI2_IRQHandler,10)
 390                     ; 213 {
 391                     	switch	.text
 392  0016               f_EXTI2_IRQHandler:
 396  0016               L522:
 397                     ; 217   while (1);
 399  0016 20fe          	jra	L522
 421                     ; 228 INTERRUPT_HANDLER(EXTI3_IRQHandler,11)
 421                     ; 229 {
 422                     	switch	.text
 423  0018               f_EXTI3_IRQHandler:
 427  0018               L142:
 428                     ; 233   while (1);
 430  0018 20fe          	jra	L142
 452                     ; 244 INTERRUPT_HANDLER(EXTI4_IRQHandler,12)
 452                     ; 245 {
 453                     	switch	.text
 454  001a               f_EXTI4_IRQHandler:
 458  001a               L552:
 459                     ; 249   while (1);
 461  001a 20fe          	jra	L552
 483                     ; 260 INTERRUPT_HANDLER(EXTI5_IRQHandler,13)
 483                     ; 261 {
 484                     	switch	.text
 485  001c               f_EXTI5_IRQHandler:
 489  001c               L172:
 490                     ; 265   while (1);
 492  001c 20fe          	jra	L172
 514                     ; 276 INTERRUPT_HANDLER(EXTI6_IRQHandler,14)
 514                     ; 277 {// disableInterrupts();
 515                     	switch	.text
 516  001e               f_EXTI6_IRQHandler:
 520                     ; 284 }
 523  001e 80            	iret
 548                     ; 298 INTERRUPT_HANDLER(EXTI7_IRQHandler,15)
 548                     ; 299 {
 549                     	switch	.text
 550  001f               f_EXTI7_IRQHandler:
 552  001f 8a            	push	cc
 553  0020 84            	pop	a
 554  0021 a4bf          	and	a,#191
 555  0023 88            	push	a
 556  0024 86            	pop	cc
 557  0025 3b0002        	push	c_x+2
 558  0028 be00          	ldw	x,c_x
 559  002a 89            	pushw	x
 560  002b 3b0002        	push	c_y+2
 561  002e be00          	ldw	x,c_y
 562  0030 89            	pushw	x
 565                     ; 302   if ((GPIOC->IDR & USER_GPIO_PIN) == 0x0) 
 567  0031 c6500b        	ld	a,20491
 568  0034 a580          	bcp	a,#128
 569  0036 261f          	jrne	L523
 570                     ; 306 		switch (state_machine)
 572  0038 b600          	ld	a,_state_machine
 574                     ; 319 			break;
 575  003a 4d            	tnz	a
 576  003b 2716          	jreq	L113
 577  003d 4a            	dec	a
 578  003e 2709          	jreq	L503
 579  0040 4a            	dec	a
 580  0041 270c          	jreq	L703
 581  0043               L313:
 582                     ; 317 			default : 
 582                     ; 318 				state_machine = STATE_VREF;
 584  0043 35010000      	mov	_state_machine,#1
 585                     ; 319 			break;
 587  0047 200e          	jra	L523
 588  0049               L503:
 589                     ; 308 			case STATE_VREF: 
 589                     ; 309 				state_machine = STATE_TEMPMEAS;
 591  0049 35020000      	mov	_state_machine,#2
 592                     ; 310 			break;
 594  004d 2008          	jra	L523
 595  004f               L703:
 596                     ; 311 			case STATE_TEMPMEAS: 
 596                     ; 312 				state_machine = STATE_CHECKNDEFMESSAGE;
 598  004f 3f00          	clr	_state_machine
 599                     ; 313 			break;
 601  0051 2004          	jra	L523
 602  0053               L113:
 603                     ; 314 			case STATE_CHECKNDEFMESSAGE: 
 603                     ; 315 				state_machine = STATE_VREF;
 605  0053 35010000      	mov	_state_machine,#1
 606                     ; 316 			break;
 608  0057               L133:
 609  0057               L523:
 610                     ; 323   EEMenuState = state_machine;
 612  0057 b600          	ld	a,_state_machine
 613  0059 ae0000        	ldw	x,#_EEMenuState
 614  005c cd0000        	call	c_eewrc
 616                     ; 324   EXTI_ClearITPendingBit(EXTI_IT_Pin7);
 618  005f ae0080        	ldw	x,#128
 619  0062 cd0000        	call	_EXTI_ClearITPendingBit
 621                     ; 327 }
 624  0065 85            	popw	x
 625  0066 bf00          	ldw	c_y,x
 626  0068 320002        	pop	c_y+2
 627  006b 85            	popw	x
 628  006c bf00          	ldw	c_x,x
 629  006e 320002        	pop	c_x+2
 630  0071 80            	iret
 652                     ; 335 INTERRUPT_HANDLER(LCD_IRQHandler,16)
 652                     ; 336 {
 653                     	switch	.text
 654  0072               f_LCD_IRQHandler:
 658  0072               L343:
 659                     ; 340   while (1);
 661  0072 20fe          	jra	L343
 684                     ; 350 INTERRUPT_HANDLER(SWITCH_CSS_BREAK_DAC_IRQHandler,17)
 684                     ; 351 {
 685                     	switch	.text
 686  0074               f_SWITCH_CSS_BREAK_DAC_IRQHandler:
 690  0074               L753:
 691                     ; 355   while (1);
 693  0074 20fe          	jra	L753
 716                     ; 366 INTERRUPT_HANDLER(ADC1_COMP_IRQHandler,18)
 716                     ; 367 {
 717                     	switch	.text
 718  0076               f_ADC1_COMP_IRQHandler:
 722  0076               L373:
 723                     ; 371   while (1);
 725  0076 20fe          	jra	L373
 748                     ; 382 INTERRUPT_HANDLER(TIM2_UPD_OVF_TRG_BRK_IRQHandler,19)
 748                     ; 383 {
 749                     	switch	.text
 750  0078               f_TIM2_UPD_OVF_TRG_BRK_IRQHandler:
 754  0078               L704:
 755                     ; 387   while (1);
 757  0078 20fe          	jra	L704
 780                     ; 398 INTERRUPT_HANDLER(TIM2_CAP_IRQHandler,20)
 780                     ; 399 {
 781                     	switch	.text
 782  007a               f_TIM2_CAP_IRQHandler:
 786  007a               L324:
 787                     ; 403   while (1);
 789  007a 20fe          	jra	L324
 812                     ; 415 INTERRUPT_HANDLER(TIM3_UPD_OVF_TRG_BRK_IRQHandler,21)
 812                     ; 416 {
 813                     	switch	.text
 814  007c               f_TIM3_UPD_OVF_TRG_BRK_IRQHandler:
 818  007c               L734:
 819                     ; 420   while (1);
 821  007c 20fe          	jra	L734
 844                     ; 430 INTERRUPT_HANDLER(TIM3_CAP_IRQHandler,22)
 844                     ; 431 {
 845                     	switch	.text
 846  007e               f_TIM3_CAP_IRQHandler:
 850  007e               L354:
 851                     ; 435   while (1);
 853  007e 20fe          	jra	L354
 876                     ; 445 INTERRUPT_HANDLER(TIM1_UPD_OVF_TRG_COM_IRQHandler,23)
 876                     ; 446 {
 877                     	switch	.text
 878  0080               f_TIM1_UPD_OVF_TRG_COM_IRQHandler:
 882  0080               L764:
 883                     ; 450   while (1);
 885  0080 20fe          	jra	L764
 908                     ; 460 INTERRUPT_HANDLER(TIM1_CAP_IRQHandler,24)
 908                     ; 461 {
 909                     	switch	.text
 910  0082               f_TIM1_CAP_IRQHandler:
 914  0082               L305:
 915                     ; 465   while (1);
 917  0082 20fe          	jra	L305
 940                     ; 476 INTERRUPT_HANDLER(TIM4_UPD_OVF_TRG_IRQHandler,25)
 940                     ; 477 {
 941                     	switch	.text
 942  0084               f_TIM4_UPD_OVF_TRG_IRQHandler:
 946  0084               L715:
 947                     ; 482 	while (1);
 949  0084 20fe          	jra	L715
 971                     ; 492 INTERRUPT_HANDLER(SPI1_IRQHandler,26)
 971                     ; 493 {
 972                     	switch	.text
 973  0086               f_SPI1_IRQHandler:
 977  0086               L335:
 978                     ; 497   while (1);
 980  0086 20fe          	jra	L335
1003                     ; 508 INTERRUPT_HANDLER(USART1_TX_IRQHandler,27)
1003                     ; 509 {
1004                     	switch	.text
1005  0088               f_USART1_TX_IRQHandler:
1009  0088               L745:
1010                     ; 513   while (1);
1012  0088 20fe          	jra	L745
1035                     ; 524 INTERRUPT_HANDLER(USART1_RX_IRQHandler,28)
1035                     ; 525 {
1036                     	switch	.text
1037  008a               f_USART1_RX_IRQHandler:
1041  008a               L365:
1042                     ; 529   while (1);
1044  008a 20fe          	jra	L365
1066                     ; 540 INTERRUPT_HANDLER(I2C1_IRQHandler,29)
1066                     ; 541 {
1067                     	switch	.text
1068  008c               f_I2C1_IRQHandler:
1072  008c               L775:
1073                     ; 545   while (1);
1075  008c 20fe          	jra	L775
1087                     	xref	_EEMenuState
1088                     	xref.b	_state_machine
1089                     	xdef	f_I2C1_IRQHandler
1090                     	xdef	f_USART1_RX_IRQHandler
1091                     	xdef	f_USART1_TX_IRQHandler
1092                     	xdef	f_SPI1_IRQHandler
1093                     	xdef	f_TIM4_UPD_OVF_TRG_IRQHandler
1094                     	xdef	f_TIM1_CAP_IRQHandler
1095                     	xdef	f_TIM1_UPD_OVF_TRG_COM_IRQHandler
1096                     	xdef	f_TIM3_CAP_IRQHandler
1097                     	xdef	f_TIM3_UPD_OVF_TRG_BRK_IRQHandler
1098                     	xdef	f_TIM2_CAP_IRQHandler
1099                     	xdef	f_TIM2_UPD_OVF_TRG_BRK_IRQHandler
1100                     	xdef	f_ADC1_COMP_IRQHandler
1101                     	xdef	f_SWITCH_CSS_BREAK_DAC_IRQHandler
1102                     	xdef	f_LCD_IRQHandler
1103                     	xdef	f_EXTI7_IRQHandler
1104                     	xdef	f_EXTI6_IRQHandler
1105                     	xdef	f_EXTI5_IRQHandler
1106                     	xdef	f_EXTI4_IRQHandler
1107                     	xdef	f_EXTI3_IRQHandler
1108                     	xdef	f_EXTI2_IRQHandler
1109                     	xdef	f_EXTI1_IRQHandler
1110                     	xdef	f_EXTI0_IRQHandler
1111                     	xdef	f_EXTID_IRQHandler
1112                     	xdef	f_EXTIB_IRQHandler
1113                     	xdef	f_EXTIE_F_PVD_IRQHandler
1114                     	xdef	f_RTC_IRQHandler
1115                     	xdef	f_DMA1_CHANNEL2_3_IRQHandler
1116                     	xdef	f_DMA1_CHANNEL0_1_IRQHandler
1117                     	xdef	f_FLASH_IRQHandler
1118                     	xdef	f_TRAP_IRQHandler
1119                     	xdef	f_NonHandledInterrupt
1120                     	xref	_EXTI_ClearITPendingBit
1121                     	xref.b	c_x
1122                     	xref.b	c_y
1141                     	xref	c_eewrc
1142                     	end
