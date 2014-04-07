   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.19 - 04 Sep 2013
   3                     ; Generator (Limited) V4.3.11 - 04 Sep 2013
  84                     ; 37 void itoa(uint32_t val, uint8_t base,uint8_t *buf)
  84                     ; 38 {            
  86                     	switch	.text
  87  0000               _itoa:
  89  0000 5209          	subw	sp,#9
  90       00000009      OFST:	set	9
  93                     ; 40 uint8_t i = 30;
  95  0002 a61e          	ld	a,#30
  96  0004 6b09          	ld	(OFST+0,sp),a
  98  0006 206c          	jra	L74
  99  0008               L34:
 100                     ; 43 	 	buf[i] = "0123456789abcdef"[val % base];
 102  0008 7b11          	ld	a,(OFST+8,sp)
 103  000a 97            	ld	xl,a
 104  000b 7b12          	ld	a,(OFST+9,sp)
 105  000d 1b09          	add	a,(OFST+0,sp)
 106  000f 2401          	jrnc	L6
 107  0011 5c            	incw	x
 108  0012               L6:
 109  0012 02            	rlwa	x,a
 110  0013 89            	pushw	x
 111  0014 ae0000        	ldw	x,#L35
 112  0017 cd0000        	call	c_uitolx
 114  001a 96            	ldw	x,sp
 115  001b 1c0007        	addw	x,#OFST-2
 116  001e cd0000        	call	c_rtol
 118  0021 7b12          	ld	a,(OFST+9,sp)
 119  0023 b703          	ld	c_lreg+3,a
 120  0025 3f02          	clr	c_lreg+2
 121  0027 3f01          	clr	c_lreg+1
 122  0029 3f00          	clr	c_lreg
 123  002b 96            	ldw	x,sp
 124  002c 1c0003        	addw	x,#OFST-6
 125  002f cd0000        	call	c_rtol
 127  0032 96            	ldw	x,sp
 128  0033 1c000e        	addw	x,#OFST+5
 129  0036 cd0000        	call	c_ltor
 131  0039 96            	ldw	x,sp
 132  003a 1c0003        	addw	x,#OFST-6
 133  003d cd0000        	call	c_lumd
 135  0040 96            	ldw	x,sp
 136  0041 1c0007        	addw	x,#OFST-2
 137  0044 cd0000        	call	c_ladd
 139  0047 be02          	ldw	x,c_lreg+2
 140  0049 f6            	ld	a,(x)
 141  004a 85            	popw	x
 142  004b f7            	ld	(x),a
 143                     ; 42 	for(; val && i ; --i, val /= base)
 145  004c 0a09          	dec	(OFST+0,sp)
 146  004e 7b10          	ld	a,(OFST+7,sp)
 147  0050 b703          	ld	c_lreg+3,a
 148  0052 3f02          	clr	c_lreg+2
 149  0054 3f01          	clr	c_lreg+1
 150  0056 3f00          	clr	c_lreg
 151  0058 96            	ldw	x,sp
 152  0059 1c0005        	addw	x,#OFST-4
 153  005c cd0000        	call	c_rtol
 155  005f 96            	ldw	x,sp
 156  0060 1c000c        	addw	x,#OFST+3
 157  0063 cd0000        	call	c_ltor
 159  0066 96            	ldw	x,sp
 160  0067 1c0005        	addw	x,#OFST-4
 161  006a cd0000        	call	c_ludv
 163  006d 96            	ldw	x,sp
 164  006e 1c000c        	addw	x,#OFST+3
 165  0071 cd0000        	call	c_rtol
 167  0074               L74:
 170  0074 96            	ldw	x,sp
 171  0075 1c000c        	addw	x,#OFST+3
 172  0078 cd0000        	call	c_lzmp
 174  007b 2706          	jreq	L55
 176  007d 0d09          	tnz	(OFST+0,sp)
 177  007f 2702          	jreq	L01
 178  0081 2085          	jp	L34
 179  0083               L01:
 180  0083               L55:
 181                     ; 46 }
 184  0083 5b09          	addw	sp,#9
 185  0085 81            	ret
 198                     	xdef	_itoa
 199                     .const:	section	.text
 200  0000               L35:
 201  0000 303132333435  	dc.b	"0123456789abcdef",0
 202                     	xref.b	c_lreg
 203                     	xref.b	c_x
 223                     	xref	c_lzmp
 224                     	xref	c_ludv
 225                     	xref	c_ladd
 226                     	xref	c_uitolx
 227                     	xref	c_lumd
 228                     	xref	c_rtol
 229                     	xref	c_ltor
 230                     	end
