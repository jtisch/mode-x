.186
dosseg

INTER   EQU     8
ADDR_6845      EQU     63h

; this is a macro used by copybitmapstovram function ONLY!
; may be modified for other uses

cbmmacro MACRO planeout
        local   l1,l2,l3
        push    di
        push    si
        mov     dx,3c4h
        mov     ax,0002h+256*planeout
        out     dx,ax
        mov     cx,320/4
l1:     lodsb
        cmp     al,254
        jb      l2
        inc     di
        jmp     l3
l2:     stosb
l3:     add     si,3
        loop    l1
        pop     si
        pop     di
        inc     si
        ENDM

sine    MACRO ;ax=sin(ax)*32768
        push    bx
        and     ax,255
        shl     ax,1
        mov     bx,ax
        mov     ax,cs:sintable[bx]
        pop     bx
        ENDM

cosine  MACRO ;ax=cos(ax)*32768
        push    bx
        add     ax,64
        and     ax,255
        shl     ax,1
        mov     bx,ax
        mov     ax,cs:sintable[bx]
        pop     bx
        ENDM



data    segment byte    public  'DATA'
text    db      '                              '
        db      ' HELLO AND WELCOME TO THIS WIERD MODE X     IT SEEMS TO WORK'
        db      ' OK BUT IT IS MOST SCREWED UP      BUT WHAT I WOULD LIKE TO'
        db      ' SAY IS THAT IT ALSO IS VERY FAST              I WOULD LIKE'
        db      ' TO THANK THE GRAND ELF FOR HIS ARTWORK AND           '
        db      ' FOR THE MUSIC         THIS DEMO WAS CODED BY THE NECROMANCER'
        db      ' FOR THG FX AS I HAVE DECIDED TO JOIN IN THEIR EFFORTS'
        db      ' TOWARDS BEING THE BEST VGA DEMO GROUP IN THE USA'
        db      ' BUT OF COURSE I CANT TAKE ALL CREDIT FOR WHAT YOU SEE    '
        db      ' THEIR ARE MANY OTHERS INVOLVED IN THE OVERALL EFFORT'
        db      '      THIS PARTICULAR DEMO YOU CURRENTLY ARE VIEWING WAS '
        db      'CODED ONE HUNDRED PERCENT IN ASSEMBLY LANGUAGE    MY FIRST '
        db      '     IT WAS ALMOST LIKE GETTING LAID FOR THE FIRST TIME    '
        db      ' YOU KNOW WHAT YOU WANT    YOU JUST HAVE A HARD TIME FEELING'
        db      ' YOUR WAY AROUND WITHOUT ERROR'
        db      '                   WRAP AROUND            q'

special dw 00d06h,03e07h,04109h,0ea10h,0ac11h,0df12h,00014h,0e715h
        dw 00616h,0e317h
include   default.pal
fontchar        dw      0
fonttable       dw      19200,19207,19214,19221,19228,19235,19242,19249
                dw      19256,19263,19270,21600,21607,21614,21621,21628
                dw      21635,21642,21649,21656,21663,21670
                dw      24000,24007,24014,24021,24028,24035,24042,24049
                dw      24056,24063,24070
bounceme        dw      400     DUP(0)

;--------------------------------------------------------------------------|
;  These are the tables for placing the objetcs                            |
;--------------------------------------------------------------------------|
horiztables     dw      19200,15,1,0,34016,14,0,0,9848,9,1,0,14680,8,0,0
verttables      dw      20800,7,1,0,16076,12,0,0,11280,4,1,0,16076,12,0,0
barbertables    dw      20820,1,20858,0,20820,1,20858,0
compresstables  dw      32720,8640,32720,32720

; for horizontal pulleys
leftpull        dw      32,36,40,44
rightpull       dw      64,68,72,76
; for vertical pulleys
leftvert        dw      1312,1316,1320,1324
rightvert       dw      1264,1268,1272,1276
; for horizontal belts
horiztop        dw      48,52,56,60
horizbottom     dw      1008,1012,1016,1020
; for vertical belts
verttop         dw      1248,1252,1256,1260
; for barber poles
barberpoles     dw      2560,2564,2568,2572
; for the compressor
compressor      dw      0,8,16,24
; for the boxes
;boxes           dw      5040,5046,5052,5058
;boxloc          dw      8570,8571,8572,8573,8574,8575,8576,8577,8578,8579
;                dw      8580,8581,8582,8583,8584,8585,8586,8587,8588,8589
;                dw      8590,8591,8592,8593,8594,8595,8596,8597,8598,8599,8600
;                dw      8601,8602,8603,8604,8605,8606,8607,8608,8609,8610
;                dw      8611,8691,8771,8851,8931,9011,9091,9171,9251,9331
;boxnew          dw      1

pullength       dw      0
conveyor        dw      0
picstuff        dw      ?
bouncecnt       dw      195
bounceadd       dw      0
bouncedir       dw      0
fontspot        dw      ?
fontcount       dw      10
RGBpal          db      768     dup(0)
frametime       dw      ?
frametimeb      dw      ?
oldint8         dd      ?
counter         dw      400
pulldelay       dw      0

sintable LABEL WORD ;sintable for 256 degrees
dw  0,804,1608,2410,3212,4011,4808 
dw  5602,6393,7179,7962,8739,9512,10278 
dw  11039,11793,12539,13279,14010,14732,15446 
dw  16151,16846,17530,18204,18868,19519,20159 
dw  20787,21403,22005,22594,23170,23731,24279 
dw  24811,25329,25832,26319,26790,27245,27683 
dw  28105,28510,28898,29268,29621,29956,30273 
dw  30571,30852,31113,31356,31580,31785,31971 
dw  32137,32285,32412,32521,32609,32678,32728 
dw  32757,32767,32757,32728,32678,32609,32521 
dw  32412,32285,32137,31971,31785,31580,31356 
dw  31113,30852,30571,30273,29956,29621,29268 
dw  28898,28510,28105,27683,27245,26790,26319 
dw  25832,25329,24811,24279,23731,23170,22594 
dw  22005,21403,20787,20159,19519,18868,18204 
dw  17530,16846,16151,15446,14732,14010,13279 
dw  12539,11793,11039,10278,9512,8739,7962 
dw  7179,6393,5602,4808,4011,3212,2410 
dw  1608,804,0,-804,-1608,-2410,-3212 
dw -4011,-4808,-5602,-6393,-7179,-7962,-8739 
dw -9512,-10278,-11039,-11793,-12539,-13279,-14010 
dw -14732,-15446,-16151,-16846,-17530,-18204,-18868 
dw -19519,-20159,-20787,-21403,-22005,-22594,-23170 
dw -23731,-24279,-24811,-25329,-25832,-26319,-26790 
dw -27245,-27683,-28105,-28510,-28898,-29268,-29621 
dw -29956,-30273,-30571,-30852,-31113,-31356,-31580 
dw -31785,-31971,-32137,-32285,-32412,-32521,-32609 
dw -32678,-32728,-32757,-32767,-32757,-32728,-32678 
dw -32609,-32521,-32412,-32285,-32137,-31971,-31785 
dw -31580,-31356,-31113,-30852,-30571,-30273,-29956 
dw -29621,-29268,-28898,-28510,-28105,-27683,-27245 
dw -26790,-26319,-25832,-25329,-24811,-24279,-23731 
dw -23170,-22594,-22005,-21403,-20787,-20159,-19519 
dw -18868,-18204,-17530,-16846,-16151,-15446,-14732 
dw -14010,-13279,-12539,-11793,-11039,-10278,-9512 
dw -8739,-7962,-7179,-6393,-5602,-4808,-4011 
dw -3212,-2410,-1608,-804
rows    dw      400 dup(0)
stars   dw      45
seed1   dw      1234
seed2   dw      5678
seed3   dw      1234h
seed4   dw      5678h
drunkenstars dw  20
vram    dw      0a000h
stx     dw      150 dup(-1,-1)   ;x
sty     dw      150 dup(-1,-1)   ;y
stm     db      150 dup(0,0,0,0)         ;misc: color,maxcol/speed,processed,0
stox1   dw      ?
stoy1   dw      ?
stox2   dw      ?
stoy2   dw      ?
srot    dw      64
bordercnt dw    ?
height  dw      399
data    ends

stacks  segment byte    stack   'STACK'
stackd  db      512     dup(0)
stacks  ends

code    segment para public  'code'
        assume  cs:code, ds:data, ss:stacks, es:data

start:
        mov     ax,data
        mov     es,ax
        mov     ds,ax
        mov     si,offset       bounceme
        mov     cx,400
        mov     bx,0
        mov     ax,3600
st1:    mov     ds:[si+bx],ax
        add     ax,80
        add     bx,2
        loop    st1
        mov     si,offset       rows
        mov     cx,400
        mov     bx,0
        mov     ax,8560
nst2:   mov     ds:[si+bx],ax
        add     ax,80
        add     bx,2
        loop    nst2

        call    fade
;---------------------------
; Start Part One of The Demo
;---------------------------
        call    set240
        call    copybitmaps
        call    scanset
        mov     cx,4b00h
        call    screenset
        call    updatepals
        ;mov     cx,8570
        ;call    grabbox
        mov     ax,data
        mov     ds,ax
        call    maindemo1
finish: call    fade
        mov     ax,3h
        int     10h
        mov     ax,4c00h
        int     21h
; The end

include int13h.asm
include draw.asm
include stars.asm

;----------------------------------------------
;  The main loop for the program at this point!
;----------------------------------------------
maindemo1        proc    near
ntopit: cli
        mov     dx,3dah
nwbr2: in      al,dx
        test    al,8
        jz      nwbr2
        call    writemode0
        call    starfield
        call    writemode1
        mov     ah,15
        call    setplanes
        call    bouncescreen
        call    scrollstuff
        call    writefont
        call    misc1
        sti
        
;-----------------------------------------------|
; Check For Keyhit                              |
;-----------------------------------------------|
        mov     ah,1
        int     16h
        jz      ntopit
        mov     ah,0
        int     16h
        cmp     al,27
        je      nfinish
        cmp     al,'+'
        je      nagn1
        cmp     al,'-'
        je      nagn2
        jmp     ntopit
nagn1:   add     bounceadd,1
        jmp     ntopit
nagn2:   cmp     bounceadd,0
        je      ntopit
        sub     bounceadd,1
        jmp     ntopit
nfinish: ret
maindemo1        endp


;------------------------------------------------------------
; function used to draw the pulleys and all other misc stuff
;------------------------------------------------------------
misc1   proc    near
        mov     bx,pulldelay
        shl     bx,2
        push    bx
        push    bx
        push    bx
        shl     bx,1
        mov     si,offset       horiztables
        mov     ax,ds:[si+bx]
        mov     dx,ds:[si+bx+2]
        mov     cx,ds:[si+bx+4]
        call    horizpulleys
        mov     si,offset       verttables
        pop     bx
        shl     bx,1
        mov     ax,ds:[si+bx]
        mov     dx,ds:[si+bx+2]
        mov     cx,ds:[si+bx+4]
        call    vertpulleys
        mov     si,offset       barbertables
        pop     bx
        mov     ax,ds:[si+bx]
        mov     cx,ds:[si+bx+2]
        call    drawbarber
        mov     si,offset       compresstables
        pop     bx
        shr     bx,1
        mov     ax,ds:[si+bx]
        call    drawcomp

        add     pulldelay,1
        cmp     pulldelay,4
        jge     miscreset
        ret
miscreset: mov  pulldelay,0
        ;mov     bx,conveyor
        ;shl     bx,1
        ;call    boxstuff
        add     conveyor,1
        cmp     conveyor,3
        jle     nseeya
        mov     conveyor,0
        ;add     boxnew,1
        ;cmp     boxnew,50
        ;jle     nseeya
        ;mov     boxnew,0
nseeya: ret
misc1   endp


;----------------------------------------------------------------
; This fucntion merely copies the default.pal palette to the card
;----------------------------------------------------------------
updatepals      proc    near
        mov     ax,data
        mov     ds,ax
        mov     dx,03c8h
        mov     al,0
        out     dx,al
        inc     dx
        mov     si,offset       mainpal
        mov     cx,768
        rep     outsb
        ret
updatepals      endp


;--------------------------------------------------------
; this function takes care of the screen bouncing ability
;--------------------------------------------------------
bouncescreen    proc    near
        mov     bx,bouncecnt
        shl     bx,1
        mov     si,offset       bounceme
        mov     cx,ds:[si+bx]
        call    screenset
        mov     ax,bounceadd
        mov     bx,bouncedir
        cmp     bx,0
        je      bnc1
        sub     bouncecnt,ax    ;1
        jmp     check
bnc1:   add     bouncecnt,ax    ;1
check:  mov     bx,bouncecnt
        cmp     bx,50
        jle     endbn
        cmp     bx,350
        jl      endbnce
        mov     bouncedir,1
        sub     bouncecnt,ax   ;1
        ret
endbn:  mov     bouncedir,0
        add     bouncecnt,ax   ;1
endbnce: ret
bouncescreen    endp

;-----------------------------------------------------------------------
; well this is probably obvious, umm moves across the screen at a steady
; rate?, ummm doesnt flicker?, ummmm make up of a information?, umm oh
; yeah a scroller
;------------------------------------------------------------------------
scrollstuff     proc    near
        push    ds
        mov     ax,0a000h
        mov     es,ax
        mov     ds,ax
        mov     ax,400
        mov     di,ax
        mov     si,ax
        inc     si
        mov     bx,28
doscroll: mov     cx,79
        rep     movsb
        add     ax,80
        mov     di,ax
        mov     si,ax
        inc     si
        dec     bx
        jnz     doscroll
        pop     ds
        ret
scrollstuff     endp

;-------------------------
; the font drawing routine
;-------------------------
writefont        proc    near
        push    ds
        xor     ax,ax
        mov     bx,fontcount
        add     fontcount,1
        cmp     bx,5
        jle     dwscr
        cmp     bx,6
        je      dwscr1
try1:   mov     si,offset       text
        mov     bx,fontchar
        mov     al,ds:[si+bx]
        cmp     al,'q'
        je      endsc1
        cmp     al,32
        je      endsc2
        sub     al,65
        mov     bx,ax
        shl     bx,1
        mov     si,offset fonttable
        mov     ax,ds:[si+bx]
        add     ax,37760
        mov     fontspot,ax
        mov     fontcount,0
        add     fontchar,1
        jmp     dwscr
endsc1: mov     fontchar,0
        jmp     try1
endsc2: mov     fontcount,0
        add     fontchar,1
dwscr1: mov     fontspot,45760
dwscr:  mov     si,fontspot
        add     si,fontcount
        mov     ax,0a000h
        mov     es,ax
        mov     ds,ax
        call    writemode1
        mov     ah,0fh
        call    setplanes
        mov     di,479
        mov     bx,28
dosc2:  movsb
        add     di,79
        add     si,79
        dec     bx
        jnz     dosc2
        pop     ds
        ret
writefont       endp


;----------------------------------------------------------------------|
; this actually updates the starting address of the                    |
; actual viewing image you see                                         |
;----------------------------------------------------------------------|
screenset       proc    near
        ;       set CL for Address Low Value
        ;       set CH for address High Value
        mov     dx,3d4h
        mov     al,0ch
        mov     ah,ch
        out     dx,ax
        mov     dx,3d4h
        mov     al,0dh
        mov     ah,cl
        out     dx,ax
        ret
screenset       endp


;-----------------------------------------------------------------------|
; this sets the proper scanline setting for the split                   |
; screen effect hehehehehe! neato, this is what allows you to           |
; move the top havlf without the bottm being affected..                 |
;-----------------------------------------------------------------------|
scanset proc    near
;include entry
        mov     ax,data
        mov     ds,ax
        mov     ax,40h
        mov     es,ax
        mov     dx,es:[ADDR_6845]
        mov     ax,counter
        mov     bh,ah
        mov     bl,bh
        and     bx,0201h
        mov     cl,4
        shl     bx,cl
        shl     bh,1
        mov     ah,al
        mov     al,18h
        out     dx,ax
        mov     al,7
        out     dx,al
        inc     dx
        in      al,dx
        dec     dx
        mov     ah,al
        and     ah,11101111b
        or      ah,bl
        mov     al,7
        out     dx,ax
        mov     al,9
        out     dx,al
        inc     dx
        in      al,dx
        dec     dx
        mov     ah,al
        and     ah,10111111b
        or      ah,bh
        mov     al,9
        out     dx,ax
;include exit
        ret
scanset     endp

;----------------------------------------------------------------------------
; Set240  - Sets up 320x240 (X Mode) - Page Flipping / VGA Hardware assists |
;         - offscreen memory - 4x faster then 320x200 when moving data      |
;         - 8x faster when filling with REP STOSW on 16 bit VGA's           |
;         - on 8 bit VGA, 4x faster when filling with REP STOSW             |
;                                                                           |
;         - The Memeory Layout Structure is As Follows                      |
;          ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿                                                   |
;          ³  1st Page  ³    A000:0000-A000:4B00                            |
;          ÃÄÄÄÄÄÄÄÄÄÄÄÄ´                                                   |
;          ³  2nd Page  ³    A000:4B01-A000:                                |
;          ÃÄÄÄÄÄÄÄÄÄÄÄÄ´                                                   |
;          ³  3rd Page  ³                                                   |
;          ÃÄÄÄÄÄÄÄÄÄÄÄÄ´                                                   |
;          ³  4th Page  ³                                                   |
;          ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ                                                   |
;---------------------------------------------------------------------------|
Set240  PROC    near
        push    ds
        mov     ax,13h                 ;let the BIOS set standard 256-color
        int     10h                    ; mode (320x200 linear)

        mov     dx,03c4h
        mov     ax,0604h
        out     dx,ax                  ;disable chain4 mode
        mov     ax,0100h
        out     dx,ax                  ;synchronous reset while switching clocks

        mov     dx,03c2h
        mov     al,0e3h                ; 0e7 dot rate
        out     dx,al                  ;select 28 MHz dot clock & 60 Hz scanning rate

        mov     dx,03c4h
        mov     ax,0300h
        out     dx,ax                  ;undo reset (restart sequencer)

        mov     dx,03d4h               ;reprogram the CRT Controller
        mov     al,11h                 ;VSync End reg contains register write
        out     dx,al                  ; protect bit
        inc     dx                     ;CRT Controller Data register
        in      al,dx                  ;get current VSync End register setting
        and     al,7fh                 ;remove write protect on various
        out     dx,al                  ; CRTC registers
        dec     dx                     ;CRT Controller Index
        cld
        mov     si,offset special      ;point to CRT parameter table
        mov     cx,10                  ;# of table entries
SPLP1:  lodsw                          ;get the next CRT Index/Data pair
        out     dx,ax                  ;set the next CRT Index/Data pair
        loop    SPLP1

        mov     dx,03c4h
        mov     ax,0f02h
        out     dx,ax                  ;enable writes to all four planes
        mov     ax,0a000h              ;now clear all display memory, 8 pixels
        mov     es,ax                  ; at a time
        xor     di,di                  ;point ES:DI to display memory
        xor     ax,ax                  ;clear to zero-value pixels
        mov     cx,32000               ;# of words in display memory
        rep     stosw
        pop     ds
        ret
Set240  ENDP


;------------------------------------------------------------
; Fade routines from Renegade Bithead, they work so i thought
; i'd give 'em a try instead of re-inventing the wheel!
;------------------------------------------------------------
Fade    PROC
        mov     ax,data
        mov     ds,ax
        mov     es,ax
        mov     dx,03dah
RetW1:  in      al,dx
        test    al,08h
        jz      RetW1
RetR1:  in      al,dx
        test    al,08h
        jnz     RetR1

        mov     dx,03c7h                   ; Read pallette entries
        xor     al,al                      ; set for read/write
        out     dx,al                      ; output the control
        add     dx,2                       ; setup dx to point to 03c9h

        mov     di,offset RGBpal           ; Sets up ES:DI to point to RGBpal
        mov     cx,768                     ; get 768 bytes from port 03c9h
        rep     insb                       ; read in palette


; This portion decrements and sets the pallette 64 times

        mov     cx,64
MFade:  push    cx
        xor     bx,bx                      ; reset bx
        mov     cx,768
DLoop:  cmp     Byte Ptr RGBpal[bx],0
        je      DecSk
        dec     Byte Ptr RGBpal[bx]
DecSk:  inc     bx                         ; point to next byte address
        dec     cx
        jnz     Dloop                      ; Repeat decrement 256 pal entries by 3 bytes

        mov     dx,03dah                   ; Point to status indicator
RetW2:  in      al,dx                      ; input byte
        test    al,08h                     ; Test Vsync Bit
        jz      RetW2
RetR2:  in      al,dx                      ; Point to status indicator
        test    al,08h                     ; input byte
        jnz     RetR2                      ; Test Vsync Bit

        mov     dx,03c8h                   ; Set pallete
        xor     al,al                      ; setup write
        out     dx,al                      ; output byte
        inc     dx                         ; point to 03c9h data port
        mov     si,offset RGBpal           ; set DS:SI point to RGBpal
        mov     cx,768                     ; move 768 bytes
        rep     outsb                      ; output to port 768 bytes of data
        pop     cx                         ; reload loop variable
        dec     cx                         ; dec until 0
        jnz     MFade                      ; check for zero, if so, continue
        ret
Fade    ENDP

;--------------------------------------------------------
; this function turns of the write mode 1 which is a mode
; which will move upto 4 bytes with one movsb
;--------------------------------------------------------
writemode1       proc    near
        mov     ah,01000001b           ; Read mode 0, Write mode 1, set mode
        mov     al,5                   ; Mode control register
        mov     dx,03ceh               ; graphics controller
        out     dx,ax                  ; Set up the mode - 6th bit on "just because"
        ret
writemode1       endp

writemode0      proc    near
        mov     ah,01000000b
        mov     al,5
        mov     dx,03ceh
        out     dx,ax
        ret
writemode0      endp

;------------------------------------------------------------------
; used to turn enable or disable which plane sare accessable during
; read and write operations
;------------------------------------------------------------------
setplanes       proc    near
; set AH to the value of planes to enable
; IE: 1=plane 0  3=planes 0&1  7=planes 0&1&2  15=planes 0&1&2&3
        mov     dx,3c4h
        mov     al,02h
        out     dx,ax
        ret
setplanes       endp

Code    ENDS


extraseg1       segment  byte   public
include font-x.pic
include vgastuff.pic
extraseg1       ends

extraseg2       segment byte    public
include thgfxlgo.pic
extraseg2       ends

        END     START
