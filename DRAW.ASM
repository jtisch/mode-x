
;boxstuff        proc    near
; set BX to which box motion we are in (0-3)
;        push    ds
;        push    bx
;
;        mov     si,offset       boxloc
;        mov     bx,boxnew
;        shl     bx,1
;        mov     cx,ds:[si+bx]
;
;        mov     si,offset       boxes
;        pop     bx
;        mov     ax,ds:[si+bx]   ; contains the box offset (0-3)
;
;        push    ax      ; this is for the box original locatiobn
;        push    cx      ; this is for the new/old box location
;        push    cx
;        push    cx
;
;        mov     ax,0a000h
;        mov     es,ax
;        mov     ds,ax
;        call    writemode1
;        pop     cx
;        call    replacebox
;        pop     cx
;        call    grabbox
;        pop     ax
;        pop     cx
;        mov     bx,16
;        mov     dx,6
;        call    drawobject
;        pop     ds
;        ret
;boxstuff        endp





;grabbox         proc    near
;       set CX for the location to grab
;
;        mov     di,54400
;        mov     si,cx
;        sub     si,81
;        mov     bx,18
;ngrab:  mov     cx,8
;        rep     movsb
;        add     si,72
;        add     di,72
;        dec     bx
;        jnz     ngrab
;        ret
;grabbox         endp

;replacebox      proc    near
;       set CX to the destination to draw old pic
;        mov     si,54400
;        mov     di,cx
;        sub     di,81
;        mov     bx,18
;nrep:   mov     cx,8
;        rep     movsb
;        add     si,72
;        add     di,72
;        dec     bx
;        jnz     ngrab
;        ret
;replacebox   endp


drawcomp        proc    near
; Set AX= The Destination of the compressor
        push    ds
        mov     bx,conveyor
        shl     bx,1
        mov     si,offset       compressor
        mov     cx,ds:[si+bx]
        push    cx
        push    ax
        mov     ax,0a000h
        mov     es,ax
        mov     ds,ax
        call    writemode1
        pop     ax
        pop     cx
        mov     bx,30
        mov     dx,8
        call    drawobject
        pop     ds
        ret
drawcomp        endp


drawbarber      proc    near
; set AX to the destination of the pic
        push    ds
        push    ax
        mov     bx,conveyor
        cmp     cx,0
        je      ndb1
        mov     ax,3
        sub     ax,bx
        mov     bx,ax
ndb1:   pop     ax
        shl     bx,1
        mov     si,offset       barberpoles
        mov     cx,ds:[si+bx]
        push    cx
        push    ax
        mov     ax,0a000h
        mov     es,ax
        mov     ds,ax
        call    writemode1
        pop     ax
        pop     cx
        mov     bx,30
        mov     dx,4
        call    drawobject
        pop     ds
        ret
drawbarber      endp

;---------------------------------------------------------------------
; main draw vertical pulley w/belt function has one other spawn it  it
;---------------------------------------------------------------------
vertpulleys     proc    near
; set   DX   to length of vertical conveyor
; set   AX   to the destination to start drawing object
; set   CX   for the direction
        push    ds
        push    ax
        mov     bx,conveyor
        cmp     cx,0
        je      ndov1
        mov     ax,3
        sub     ax,bx
        mov     bx,ax
ndov1:  pop     ax
        shl     bx,1
dovert1:mov     si,offset       rightvert
        mov     cx,ds:[si+bx]
        push    ax
        push    cx
        push    dx
        mov     si,offset       verttop
        mov     cx,ds:[si+bx]
        push    dx
        push    ax
        push    cx
        mov     si,offset       leftvert
        mov     cx,ds:[si+bx]
        push    ax
        mov     ax,0a000h
        mov     es,ax
        mov     ds,ax
        call    writemode1
; start of the upper left gear
        pop     ax
        mov     bx,15
        mov     dx,4
        call    drawobject
; start of the left belt
        pop     cx
        pop     ax
        pop     bx
        add     ax,1200
        call    vertbelt
; start of the right belt
        pop     cx
        mov     bx,0
vrt1:   add     bx,1280
        loop    vrt1
        pop     cx
        pop     ax
        add     ax,bx
        add     ax,1200
        mov     dx,4
        mov     bx,15
        call    drawobject
        pop     ds
        ret
vertpulleys     endp

;-----------------------------------------------------------------
; Main horizontal pulley drawer function has one other spawn in it
;-----------------------------------------------------------------
horizpulleys proc    near
; set DX to length of conveyor
; set AX to destination to draw the damn thing
; Set CX for direction of conveyor
        push    ds
        push    ax
        mov     bx,conveyor
        cmp     cx,0
        je      ndp1
        mov     ax,3
        sub     ax,bx
        mov     bx,ax
        ;sub     bx,4
ndp1:   pop     ax
        shl     bx,1
dopull: mov     si,offset       rightpull
        mov     cx,ds:[si+bx]
        push    dx
        push    ax
        push    cx
        mov     si,offset       horizbottom
        mov     cx,ds:[si+bx]
        push    dx
        push    ax
        push    cx
        mov     si,offset       horiztop
        mov     cx,ds:[si+bx]
        push    dx
        push    ax
        push    cx
        push    ax
        mov     si,offset       leftpull
        mov     cx,ds:[si+bx]
        mov     ax,0a000h
        mov     es,ax
        mov     ds,ax
        call    writemode1
        pop     ax
        mov     bx,14
        mov     dx,4
        call    drawobject
        pop     cx
        pop     ax
        pop     bx
        add     ax,4
        call    horizbelt
        pop     cx
        pop     ax
        pop     bx
        add     ax,964
        call    horizbelt
        pop     cx
        pop     ax
        pop     dx
        shl     dx,2
        add     ax,dx
        add     ax,4
        mov     bx,14
        mov     dx,4
        call    drawobject
quitpull: pop     ds
        ret
horizpulleys endp

;----------------------------------------
; The spawn from the vertpulleys fucntion
;----------------------------------------
vertbelt     proc    near
; Set AX for destination
; set BX for the number of belts to draw
; Set CX for the starting location of bitmap
        mov     di,ax
        add     cx,48000
        mov     si,cx
        mov     dx,cx
        mov     ax,bx
vb2:    mov     bx,16
vb1:    mov     cx,4
        rep     movsb
        add     si,76
        add     di,76
        dec     bx
        jnz     vb1
        mov     si,dx
        dec     ax
        jnz     vb2
        ret
vertbelt        endp

;------------------------------
; the horizpulleys spawn function
;------------------------------
horizbelt    proc    near
; Set AX for Destination
; Set BX for the number of belts to draw
; Set CX for the starting location of bitmap
        push    bx
        mov     di,ax
        push    di
        add     cx,48000
        mov     si,cx
        mov     dx,cx
topb1:  mov     cx,4
        rep     movsb
        sub     si,4
        dec     bx
        jnz     topb1
        add     si,80
        pop     di
        add     di,80
        pop     bx
topb2:  mov     cx,4
        rep     movsb
        sub     si,4
        dec     bx
        jnz     topb2
        ret
horizbelt endp

;-------------------------------------------------------------
; used to draw certain bitmaps used for the pullleys and stuff
;-------------------------------------------------------------
drawobject      proc    near
; set AX=the destination
; set BX=the height of the bitmap
; set CX=startlocation of bitmap
; set DX=length in total bytes/4 to draw
        mov     di,ax
        add     cx,48000
        mov     si,cx
        mov     ax,80
        sub     ax,dx
drawbit: mov     cx,dx
        rep     movsb
        add     di,ax
        add     si,ax
        dec     bx
        jnz     drawbit
        ret
drawobject      endp

;----------------------------------------------
; this function copies the bitmaps to the VRAM
;----------------------------------------------
copybitmaps     proc    near
        mov     ax,0a000h
        mov     es,ax
        mov     ax,extraseg1
        mov     ds,ax
        mov     si,offset       fontx
        mov     di,56960
        mov     cx,88
        call    copybitmaptovram
        mov     si,offset       vgastuff
        mov     di,48000
        mov     cx,111
        call    copybitmaptovram
        mov     ax,extraseg2
        mov     ds,ax
        mov     si,offset       thgfx
        mov     di,23680
        mov     cx,78
        call    copybitmaptovram
        ret
copybitmaps ENDP


;-------------------------------------------
; a spawn function from copybitmaps function
;-------------------------------------------
copybitmaptovram PROC NEAR
cbm1:   push    cx
        push    si
        push    di
        ;plane 1
        cbmmacro 1
        ;plane 2
        cbmmacro 2
        ;plane 3
        cbmmacro 4
        ;plane 4
        cbmmacro 8
        pop     di
        pop     si
        pop     cx
        add     si,320
        add     di,80
        loop    cbm1x
        ret
cbm1x:  jmp     cbm1
copybitmaptovram ENDP
