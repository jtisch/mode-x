waitit  proc    near
        push    ax
        push    dx
        mov     dx,3dah
dwait:  in      al,dx
        test    al,8
        jz      dwait
        pop     dx
        pop     ax
        ret
waitit endp

getraster proc  near
        cli
        xor     al,al
        out     43h,al
        in      al,40h
        mov     dl,al
        in      al,40h
        mov     dh,al
        shr     dx,1
        mov     ax,ds:frametime
        sub     ax,dx
        mov     cx,400
        mul     cx
        mov     cx,ds:frametime
        div     cx
        sti
        ret
getraster endp

waitborder proc near
        push    ax
        push    dx
        mov     dx,3dah
wbr111: in      al,dx
        test    al,8
        jnz     wbr111
wbr222: in      al,dx
        test    al,8
        jz      wbr222
        pop     dx
        pop     ax
        ret
waitborder  endp

initmisc PROC NEAR
	cld
	ret
initmisc ENDP

intti8 PROC FAR
	;timer interrupt
	push	ax
        push    ds
        mov     ax,data
        mov     ds,ax
        cli
	call	demointti
        sti
	mov	al,20h
	out	20h,al
	call	waitborder
	mov	al,36h
	out	43h,al
        mov     al,byte ptr ds:frametimeb[0]
	out	40h,al
        mov     al,byte ptr ds:frametimeb[1]
	out	40h,al
        pop     ds
	pop	ax
	iret
intti8 ENDP

setints proc    near
        push    es
        push    ds
	cli
        mov     ax,data
        mov     ds,ax
	xor	ax,ax
	mov	es,ax
	mov	ax,es:[INTER*4]
        mov     WORD PTR ds:oldint8,ax
	mov	ax,es:[INTER*4+2]
        mov     WORD PTR ds:oldint8[2],ax
	mov	ax,OFFSET intti8
	mov	es:[INTER*4],ax
	mov	es:[INTER*4+2],cs
	sti
	call	waitborder
	;reset ints now!
	mov	al,36h
	out	43h,al
	mov	al,0
	out	40h,al
	mov	al,0
	out	40h,al
	call	waitborder
	xor	al,al
	out	43h,al
	in	al,40h
	mov	ah,al
	in	al,40h
	xchg	al,ah
	neg	ax
	shr	ax,1
        mov     ds:frametime,ax
	mov	dx,ax
	mov	al,ah
	xor	ah,ah
	sub	dx,ax
	shl	dx,1
        mov     ds:frametimeb,dx
	mov	al,36h
	out	43h,al
	mov	al,dl
	out	40h,al
	mov	al,dh
	out	40h,al
        pop     es
        pop     ds
setints ENDP

clearints PROC  near
        push    ds
        push    es
	cli
        mov     ax,data
        mov     ds,ax
	mov	ax,0
	mov	es,ax
        mov     ax,WORD PTR ds:oldint8
        mov     dx,WORD PTR ds:oldint8[2]
	mov	es:[INTER*4],ax
	mov	es:[INTER*4+2],dx
	sti
	mov	al,36h
	out	43h,al
	mov	al,0
	out	40h,al
	mov	al,0
	out	40h,al
        pop     es
        pop     ds
clearints ENDP

demointti       proc near
push    es
pop     es
ret
demointti       endp
