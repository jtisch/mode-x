starfield proc  near
        mov     ax,0a000h
        mov     es,ax
	;calc 'rotating' center
        mov     cx,drunkenstars
        mov     ax,srot
        ;sine
        cosine
	imul	cx
	mov	ax,dx
	add	ax,160
        mov     stox1,ax
	sub	ax,(320-256)/2
        mov     stox2,ax
        mov     ax,srot
        ;cosine
        sine
	imul	cx
	mov	ax,dx
	add	ax,100
        mov     stoy1,ax
	sub	ax,(200-128)/2
        mov     stoy2,ax
        inc     srot
        and     srot,255
	;do stars
	mov	cx,stars
	xor	si,si
sf01:   mov     stm[si+2],0
	add	si,4
	loop	sf01
        mov     ds:bordercnt,0
	mov	cx,stars
	mov	bp,0
	xor	si,si
	call	starfield2
;sf02:   setborder 0
;        call    getrasterline
;        cmp     ax,160
;        jb      sf02
	mov	cx,stars
	mov	bp,1
	xor	si,si
	call	starfield2
        ret
starfield ENDP

starfield2 PROC NEAR
sf1:	push	cx
	cmp	ds:stm[si+2],0
	je	sf14
	jmp	sf3
sf14:
	mov	dx,ds:stx[si+2]
	cmp	dx,-1
	jne	sf5
	;add new
	call	rand
	and	ax,127
	mov	dx,ax
	call	rand
	and	ax,127
	add	dx,ax
	add	dx,(320-256)/2
	mov	ds:stx[si+2],dx
	call	rand
	and	ax,63
	mov	dx,ax
	call	rand
	and	ax,63
	add	dx,ax
	add	dx,(200-128)/2
	mov	ds:sty[si+2],dx
	call	rand
	and	al,15
	add	al,128+64
	mov	ds:stm[si+1],al
	mov	al,128+64+31
	mov	ds:stm[si],al
	mov	dx,ds:stx[si+2]
	mov	bx,ds:sty[si+2]
	jmp	sf2
sf5:	;undraw old
	mov	bx,ds:sty[si+2]
sf2:	cmp	bp,1
	je	sf12
	cmp	bx,70
	jnb	sf11
sf13:	jmp	sf3
sf12:	cmp	bx,70
	jnb	sf13
sf11:	mov	ds:stm[si+2],1	
        call    pget
	cmp	al,128+64
	jb	sf4
	cmp	al,128+64+31
	ja	sf4
	mov	dx,ds:stx[si+2]
	mov	bx,ds:sty[si+2]
	xor	al,al
        call    pset
sf4:	;move
	mov	ah,128+63
	sub	ah,ds:stm[si+1]
	add	ah,32
	xor	al,al
	mov	cl,2
	shr	ax,cl
	mov	cx,ax
	mov	ax,ds:stx[si+2]
	sub	ax,ds:stox1
	imul	cx
	add	ds:stx[si],ax
	adc	ds:stx[si+2],dx
	mov	ax,ds:sty[si+2]
	sub	ax,ds:stoy1
	imul	cx
	add	ds:sty[si],ax
	adc	ds:sty[si+2],dx
	;redraw new/check for overflow
	mov	dx,ds:stx[si+2]
	cmp	dx,320
	jb	sf9
sf10:	mov	ds:stx[si+2],-1
	jmp	sf3
sf9:	mov	bx,ds:sty[si+2]
        cmp     bx,height
	ja	sf10
        call    pget
	cmp	al,0
	jne	sf3
	mov	dx,ds:stx[si+2]
	mov	bx,ds:sty[si+2]
	mov	al,ds:stm[si]
	cmp	al,ds:stm[si+1]
	jna	sf7
	dec	al
sf7:	mov	ds:stm[si],al
        call    pset
sf3:	pop	cx
	add	si,4
	loop	sf1x
	ret
sf1x:	jmp	sf1
starfield2 ENDP

rand    PROC    NEAR
	push	bx
	push	cx
	push	dx
	mov	ax,ds:seed1
	mov	bx,ds:seed2
	mov	cx,ds:seed3
	mov	dx,ds:seed4
	add	ax,bx
	rol	ax,cl
	xor	ax,dx
	xchg	cl,ch
	add	bx,cx
	add	dx,bx
	add	cx,ax
	ror	bx,1
	sbb	ax,dx
	mov	ds:seed4,dx
	mov	ds:seed3,dx
	mov	ds:seed2,dx
	mov	ds:seed1,ax
	pop	dx
	pop	cx
	pop	bx
	ret
rand    ENDP

pset    PROC    NEAR
	;(dx,bx)=al, es must be 0a000h
	;uses/changes ax,bx,cx,dx
	mov	ch,al
	mov	cl,dl
	shl	bx,1
        mov     bx,ds:rows[bx]
	sar	dx,1
	sar	dx,1
	add	bx,dx
	and	cl,3
	mov	ax,102h
	mov	dx,03c4h
	shl	ah,cl
	out	dx,ax
	mov	es:[bx],ch
	ret
pset	ENDP

pget	PROC	NEAR
	;al=(dx,bx), es must be 0a000h
	;uses/changes ax,bx,cx,dx

	mov	cl,dl
	shl	bx,1
        mov     bx,ds:rows[bx]
	sar	dx,1
	sar	dx,1
	add	bx,dx
	and	cl,3
	mov	ah,cl
	mov	al,4h
	mov	dx,03ceh
	out	dx,ax
	mov	al,es:[bx]
	ret
pget    ENDP
