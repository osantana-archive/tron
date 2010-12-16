{


                                                                       (R)
       \ÜÜÜÜÜ   \Ü   \Ü  \ÜÜ  \Ü   \ÜÜÜÜ   \ÜÜÜÜÜÜ   \ÜÜÜÜ   \ÜÜ  \Ü
        \Ü  \Ü  \Ü   \Ü  \Ü\Ü \Ü  \Ü       \Ü       \Ü   \Ü  \Ü\Ü \Ü
        \Ü  \Ü  \Ü   \Ü  \Ü \Ü\Ü  \Ü \ÜÜ   \ÜÜÜ     \Ü   \Ü  \Ü \Ü\Ü
        \Ü  \Ü  \Ü   \Ü  \Ü  \ÜÜ  \Ü   \Ü  \Ü       \Ü   \Ü  \Ü  \ÜÜ
       \ÜÜÜÜÜ    \ÜÜÜÜ   \Ü   \Ü   \ÜÜÜÜ   \ÜÜÜÜÜÜ   \ÜÜÜÜ   \Ü   \Ü



                            ÚÄÄ      ÚÄÄ  ÚÄÄÄÄ
                            ÚÄÄ      ÚÄÄ  ÚÄ   ÚÄ
                            ÚÄÄ      ÚÄÄ  ÚÄÄÄÄ
                            ÚÄÄ      ÚÄÄ  ÚÄ   ÚÄ
                            ÚÄÄÄÄÄÄ  ÚÄÄ  ÚÄÄÄÄ



}

{$G+}

Unit Dungeon;

interface

uses dos,crt,graph;

var winnbr : word;

const inof  = false ;
      outof = true  ;

type rgb = record
         r : byte;
         g : byte;
         b : byte;
      end;
      mouse = object
         function  start : word                     ;
         procedure show                             ;
         procedure hide                             ;
         function  button    (wht : byte) : boolean ;
         function  x : word                         ;
         function  y : word                         ;
         function  area(x1,y1,x2,y2: word) : boolean;
         procedure setxy     (xi,yi : word)         ;
         procedure setarea   (x1,y1,x2,y2 : word)   ;
         procedure setnoarea (x1,y1,x2,y2 : word)   ;
         procedure sethandle (pt:pointer;evt:word)  ;
      end;
      paletype = array[0..255,1..3] of shortint     ;
      headtype = record
         signature : array[1..2] of char;
         nfiles    : byte;
      end;
      entrytype = record
         filename   : string[12];
         startentry : longint;
         length     : longint;
      end;

{FUNCTIONS}
function ifbyte  (valor : boolean; v1,v2 : byte   ) : byte;  {IF's}
function ifword  (valor : boolean; v1,v2 : word   ) : word;
function ifchar  (valor : boolean; v1,v2 : char   ) : char;
function ifstring(valor : boolean; v1,v2 : string ) : string;
function ifint   (valor : boolean; v1,v2 : integer) : integer;
function getpoint(x,y : word) : byte;
function replicate(ch : char; qtd : byte) : string;
function space(qtd : byte) : string;
function alltrim(strini : string) : string;
function upper(str:string) : string;
function byteval(str : string) : byte;
function wordval(str : string) : word;
function min(a,b : integer) : integer;
function max(a,b : integer) : integer;
function exist(fname : string) : boolean;
function fsize(fname : string) : longint;
function openbigfile(nfin : string; var fin : file) : byte;

{PROCEDURES}
procedure swapbyte(var v1,v2 : byte);
procedure swapword(var v1,v2 : word);
procedure cursor(lin_ini,lin_fin : byte);
procedure pchar(x,y : byte; ch : char);
procedure say(x,y : byte; msg : string);
procedure modifycolor(x,y,cor : byte);
procedure box(x1,y1,x2,y2 : byte; frame : string);
procedure setrgb(cor,r,g,b : byte);
procedure getrgb(color : word; var trgb : rgb);
procedure setcolorfill(x : word);
procedure box3d(x1,y1,x2,y2 : word; elev : byte; efct : boolean; int : word);
procedure win(x1,y1,x2,y2 : word; title : string);
procedure init320x200;
procedure textmode;
procedure video(est : byte);
procedure putpoint(x,y : word; cor : byte);
procedure putline(x,y,x1,y1 : word; cor : byte);
procedure closingpalette(tempo : word);
procedure wait;
procedure filebiginfo(var fin : file; var entry : entrytype; arq : byte);
procedure filebigpos(var fin : file; arq : byte);

implementation
                                                           { Object Mouse }
function mouse.start; assembler;
asm
         xor ax,ax
         int 33h
         cmp ax,0FFFFh
         jnz @naodiz
         mov ax,bx
         jmp @fim
@naodiz: xor ax,ax
@fim   :
end; {mouse.start}

procedure mouse.show; assembler;
asm
   mov ax,0001h
   int 33h
end; {mouse.show}

procedure mouse.hide; assembler;
asm
   mov ax,0002h
   int 33h
end; {mouse.hide}

function mouse.button(wht : byte) : boolean; assembler;
asm
      mov ax,0003h
      int 33h
      mov cl, wht
      shr bx, cl
      jc  @1
@0:   xor ax,ax
      jmp @fim
@1:   mov ax,0001
@fim:
end; {mouse.button}

function mouse.x : word; assembler;
asm
   mov ax,0003h
   int 33h
   mov ax,cx
end; {mouse.x}

function mouse.y : word; assembler;
asm
   mov ax,0003h
   int 33h
   mov ax,dx
end; {mouse.y}

function mouse.area(x1,y1,x2,y2 : word) : boolean;
var resptmp : boolean;
begin
   if ((mouse.x > x1) and (mouse.y > y1)) and
      ((mouse.x < x2) and (mouse.y < y2)) then
         resptmp := true
   else
         resptmp := false;
   area := resptmp;
end; {mouse.area}

procedure mouse.setxy(xi,yi : word); assembler;
asm
   mov ax, 0004h
   mov cx, xi
   mov dx, yi
   int 33h
end; {mouse.setxy}

procedure mouse.setarea(x1,y1,x2,y2 : word); assembler;
asm
   mov ax, 0007h
   mov cx, x1
   mov dx, x2
   int 33h
   mov ax, 0008h
   mov cx, y1
   mov dx, y2
   int 33h
end; {mouse.setarea}

procedure mouse.setnoarea(x1,y1,x2,y2 : word); assembler;
asm
   mov ax,0010h
   mov cx, x1
   mov dx, y1
   mov si, x2
   mov di, y2
   int 33h
end; {mouse.setnoarea}

procedure mouse.sethandle(pt : pointer;evt : word); assembler;
asm
   les dx, pt
   mov ax, 000Ch
   mov cx, evt
   int 33h
end; {mouse.sethandle}

{=====================================================}
{                Funcoes de tela texto                }
{=====================================================}

procedure cursor(lin_ini,lin_fin : byte); assembler;
asm
   mov ah, 01h
   mov ch, lin_ini
   mov cl, lin_fin
   int 10h
end; {cursor}

procedure pchar(x,y : byte; ch : char);
begin
   dec(x);
   dec(y);
   mem[$B800:(y*80+x)*2] := ord(ch);
end;

procedure say(x,y : byte; msg : string);
var aux : word;
begin
   dec(x);
   dec(y);
   for aux := 1 to length(msg) do
      mem[$B800:((y*80+x)*2)+(aux*2)-2] := ord(msg[aux]);
end;

procedure modifycolor(x,y,cor : byte);
begin
   dec(x); dec(y);
   mem[$B800:(((y*80) + x) shl 1) + 1] := cor;
end;

procedure box(x1,y1,x2,y2 : byte; frame : string);
var aux : byte;
begin
   if length(frame) < 8 then
      frame := frame + space(8-length(frame));
   if x1 > x2 then swapbyte(x1,x2);
   if y1 > y2 then swapbyte(y1,y2);
   pchar(x1,y1,ifchar(y1=y2,
                     frame[2],
                  ifchar(x1=x2,
                     frame[4],
                     frame[1])));
   pchar(x2,y1,ifchar(y1=y2,
                     frame[2],
                  ifchar(x1=x2,
                     frame[4],
                     frame[3])));
   pchar(x1,y2,ifchar(y1=y2,
                     frame[2],
                  ifchar(x1=x2,
                     frame[4],
                     frame[7])));
   pchar(x2,y2,ifchar(y1=y2,
                     frame[2],
                  ifchar(x1=x2,
                     frame[4],
                     frame[5])));
   if x2 > x1 then
      for aux := x1 + 1 to x2 - 1 do begin
         pchar(aux,y1,frame[2]);
         pchar(aux,y2,frame[6]);
      end;
   if y2 > y1 then
      for aux := y1 + 1 to y2 - 1 do begin
         pchar(x1,aux,frame[8]);
         pchar(x2,aux,frame[4]);
      end;
end;

{=====================================================}
{                Funcoes de tela grafica              }
{=====================================================}

procedure setrgb(cor,r,g,b : byte);
begin
   port[$03C8] := cor;
   port[$03C9] := r;
   port[$03C9] := g;
   port[$03C9] := b;
end;

procedure getrgb(color : word; var trgb : rgb);
var regs : registers;
begin
   regs.ax := $1015  ;
   regs.bx := color  ;
   intr($10,regs)    ;
   trgb.r := regs.dh ;
   trgb.g := regs.ch ;
   trgb.b := regs.cl ;
end;

procedure setcolorfill(x : word);
begin
   setfillstyle(solidfill,x);
end;

procedure box3d(x1,y1,x2,y2 : word; elev : byte; efct : boolean; int : word);
begin
   if x1 > x2 then swapword(x1,x2);
   if y1 > y2 then swapword(y1,y2);
   if (elev > x2-x1) or (elev > y2-y1) then elev := min(x2-x1,y2-y1);
   setcolorfill (white)        ;
   bar          (x1,y1,x2,y2)  ;
   setcolorfill (int)          ;
   bar          (x1+elev,y1+elev,x2-elev,y2-elev);
   setcolor     (black)        ;
   rectangle    (x1,y1,x2,y2)  ;
   rectangle    (x1+elev,y1+elev,x2-elev,y2-elev);
   line         (x1,y1,x1+elev,y1+elev) ;
   line         (x2,y1,x2-elev,y1+elev) ;
   line         (x1,y2,x1+elev,y2-elev) ;
   line         (x2,y2,x2-elev,y2-elev) ;
   setcolorfill (darkgray);
   if efct = outof then begin
      floodfill(x2 - 1,y2 - 2,black);
      floodfill(x2 - 2,y2 - 1,black);
   end
   else begin
      floodfill(x1 + 1,y1 + 2,black);
      floodfill(x1 + 2,y1 + 1,black);
   end;
end;

procedure win(x1,y1,x2,y2 : word; title : string);
var alltitle : string;
begin
   inc (winnbr           ) ;
   str (winnbr:3,alltitle) ;
   alltitle := alltitle + ': ' + title;
   settextstyle   (defaultfont,horizdir,1)        ;
   settextjustify (lefttext,toptext)              ;
   box3d          (x1,y1,x2,y2,3,outof,lightgray) ;
   box3d(x1+6,y1+6,x2-6,y1+textheight(alltitle)+13,2,outof,blue);
   setcolor(black);
   outtextxy(x1+21,y1+11,alltitle);
   setcolor(white);
   outtextxy(x1+20,y1+10,alltitle);
   box3d(x1+6,y1+24,x2-6,y2-6,3,inof,black);
end;

procedure init320x200; assembler;
asm
   mov     ax, 19
   int     10h
end;

procedure textmode; assembler;
asm
   mov     ax, 3
   int     10h
end;

procedure video(est : byte); assembler;
asm
       cmp est,1
       je  @cont
       mov est,1
       jmp @do
@cont: mov est,0
@do:   mov ah,12h
       mov al,est
       mov bl,36h
       int 10h
end;

procedure putpoint(x,y : word; cor : byte); assembler;
asm
   MOV     CX, y
   MOV     DX, x
   MOV     AX, CX
   SHL     AX, 8
   SHL     CX, 6
   ADD     CX, AX
   ADD     CX, DX
   MOV     AX, 0A000h
   MOV     ES, AX
   MOV     SI, CX
   MOV     AL, cor
   MOV     [ES:SI], AL
end;

function getpoint(x,y : word) : byte; assembler;
asm
   MOV     CX, y
   MOV     DX, x
   MOV     AX, CX
   SHL     AX, 8
   SHL     CX, 6
   ADD     CX, AX
   ADD     CX, DX
   MOV     AX, 0A000h
   MOV     ES, AX
   MOV     SI, CX
   MOV     al, [ES:SI]
end;

procedure putline(x,y,x1,y1 : word; cor : byte); assembler;
var xd, dy, ddx, ddy, l, b : word;
asm
               PUSH    x
               PUSH    y
               MOV     AL,cor
               MOV     AH,0
               PUSH    AX
               CALL    putpoint
               MOV     AX, x1
               SUB     AX, x
               JNC     @naonega1
               NEG     AX
               MOV     BX, -1h
               JMP     @guarda1

   @naonega1:  MOV     BX, 01h
    @guarda1:  MOV     xd, BX
               MOV     x1, AX
               MOV     AX, y1
               SUB     AX, y
               JNC     @naonega2
               NEG     AX
               MOV     BX, -1h
               JMP     @guarda2

   @naonega2:  MOV     BX, 01h
    @guarda2:  MOV     dy, BX
               MOV     y1, AX
               CMP     AX, x1
               JC      @op1
               JZ      @op1

               MOV     b, AX
               MOV     AX, x1
               MOV     l, AX
               XOR     AX, AX
               MOV     ddx, AX
               MOV     AX, dy
               MOV     ddy, AX
               JMP     @calc

        @op1:  OR      AX, x1
               JZ      @fim
               MOV     AX, y1
               MOV     l, AX
               MOV     AX, x1
               MOV     b, AX
               XOR     AX, AX
               MOV     ddy, AX
               MOV     AX, xd
               MOV     ddx, AX

       @calc:  MOV     SI, b
               MOV     BX, SI
               SHR     SI, 1

      @ciclo:  ADD     SI, l
               CMP     SI, b
               JC      @dd
               SUB     SI, b
               MOV     CX, dy
               MOV     DX, xd
               JMP     @pponto

         @dd:  MOV     CX, ddy
               MOV     DX, ddx

     @pponto:  OR      DX, DX
               JZ      @ok1
               DEC     DX
               JNZ     @nega1
               INC     x
               JMP     @ok1

      @nega1:  DEC     x
        @ok1:  MOV     DX, x
               OR      CX, CX
               JZ      @ok2
               DEC     CX
               JNZ     @nega2
               INC     y
               JMP     @ok2
      @nega2:  DEC     y
        @ok2:  MOV     CX, y

               PUSH    SI
               MOV     AX, CX
               SHL     CX, 8
               SHL     AX, 6
               ADD     CX, AX
               ADD     CX, DX
               MOV     AX, 0A000h
               MOV     ES, AX
               MOV     SI, CX
               MOV     al,cor
               MOV     [ES:SI], AL
               POP     SI

               DEC     BX
               JNZ     @ciclo
        @fim:
end;

procedure closingpalette(tempo : word); assembler;
var palini : paletype;
    maior  : byte;
asm
        PUSH   DS
        PUSH   ES
        MOV    AX, 1017h
        XOR    BX, BX
        MOV    CX, 255
        PUSH   DS
        POP    ES
        LEA    DX, palini
        INT    10h
        CLD
        MOV    CX, 3*256
        MOV    maior, 0
        LEA    SI, palini
@ler:   LODSB
        CMP    maior, AL
        JL     @seta
        LOOP   @ler
        JMP    @fim
@seta:  MOV    maior, AL
        LOOP   @ler
@fim:   XOR    CX, CX
        MOV    CL, maior
@0:     PUSH   CX
        LEA    SI, palini
        MOV    DI, SI
        XOR    AX, AX
        XOR    BX, BX
@1:     MOV    DX, 3C8h
        MOV    CX, 3
        MOV    AX, BX
        OUT    DX, AL
        INC    DX
@2:     LODSB
        OR     AX, AX
        JZ     @3
        DEC    AX
@3:     STOSB
        OUT    DX, AL
        LOOP   @2
        CMP    BX, 255
        JE     @4
        INC    BX
        JMP    @1
@4:     MOV    CX, tempo
@5:     LOOP   @5
        POP    CX
        LOOP   @0
        POP    ES
        POP    DS
end;

{=====================================================}
{                Funcoes de teclado                   }
{=====================================================}

procedure wait; assembler;
asm
   push ax
   xor ax,ax
   int 16h
   pop ax
end;

{=====================================================}
{                Funcoes de string                    }
{=====================================================}

function replicate(ch : char; qtd : byte) : string;
var aux : string;
    tmp : byte  ;
begin
   aux := '';
   for tmp := 0 to qtd do
      aux := aux + ch;
   replicate := aux;
end;

function space(qtd : byte) : string;
begin
   space := replicate(#32,qtd);
end;

function alltrim(strini : string) : string;
var inicio : byte    ;
    fim    : byte    ;
begin
   inicio := 1;
   fim    := length(strini);
   while (inicio <= length(strini)) and (strini[inicio] = #32) do
      inc(inicio);
   while (fim > 0) and (strini[fim] = #32) do
      dec(fim);
   alltrim := copy(strini,inicio,fim - inicio + 1);
end;

function upper(str:string) : string;
var loopi  : byte;
begin
   for loopi := 1 to length(str) do
      str[loopi] := upcase(str[loopi]);
   upper := str;
end;

{=====================================================}
{                Funcoes de Tipos                     }
{=====================================================}

function ifbyte(valor : boolean; v1,v2 : byte) : byte;
begin
   if valor then ifbyte := v1 else ifbyte := v2;
end;
function ifword(valor : boolean; v1,v2 : word) : word;
begin
   if valor then ifword := v1 else ifword := v2;
end;
function ifchar(valor : boolean; v1,v2 : char) : char;
begin
   if valor then ifchar := v1 else ifchar := v2;
end;
function ifstring(valor : boolean; v1,v2 : string) : string;
begin
   if valor then ifstring := v1 else ifstring := v2;
end;
function ifint(valor : boolean; v1,v2 : integer) : integer;
begin
   if valor then ifint := v1 else ifint := v2;
end;

procedure swapbyte(var v1,v2 : byte);
var v3 : byte;
begin
   v3 := v1  ;
   v1 := v2  ;
   v2 := v3  ;
end;
procedure swapword(var v1,v2 : word);
var v3 : word;
begin
   v3 := v1  ;
   v1 := v2  ;
   v2 := v3  ;
end;

function byteval(str : string) : byte;
var resp : byte;
    err  : integer;
begin
   val(str,resp,err);
   if err <> 0 then resp := 0;
   byteval := resp;
end;
function wordval(str : string) : word;
var resp : word;
    err  : integer;
begin
   val(str,resp,err);
   if err <> 0 then resp := 0;
   wordval := resp;
end;

function min(a,b : integer) : integer;
begin
   if a < b then min := a else min := b;
end;
function max(a,b : integer) : integer;
begin
   if a > b then max := a else max := b;
end;

{=====================================================}
{                Funcoes de Arquivos                  }
{=====================================================}

function exist(fname : string) : boolean;
var f : file;
begin
   {i-}
   assign(f,fname);
   reset(f);
   {$i+}
   if ioresult <> 0 then exist := false else begin
      close(f);
      exist := true;
   end;
end;

function fsize(fname : string) : longint;
var f : file;
begin
   {i-}
   assign(f,fname);
   reset(f,1);
   {$i+}
   if ioresult <> 0 then fsize := -1 else begin
      fsize := filesize(f);
      close(f);
   end;
end;

function openbigfile(nfin : string; var fin : file) : byte;
var header : headtype;
begin
   assign(fin,nfin);
   {$i-}
   reset(fin,1);
   {$i+}
   if ioresult <> 0 then
      openbigfile := 0
   else begin
      blockread(fin,header,sizeof(header));
      if header.signature <> 'SC' then
         openbigfile := 0
      else
         openbigfile := header.nfiles;
   end;
end;

procedure filebiginfo(var fin : file; var entry : entrytype; arq : byte);
var reads : word;
    posant: longint;
begin
   posant := filepos(fin);
   seek(fin,(arq-1)*sizeof(entrytype)+sizeof(headtype));
   {$i-}
   blockread(fin,entry,sizeof(entry),reads);
   {$i+}
   seek(fin,posant);
   if reads <> sizeof(entry) then entry.filename := '';
end;

procedure filebigpos(var fin : file; arq : byte);
var entry : entrytype;
begin
   filebiginfo(fin,entry,arq);
   seek(fin,entry.startentry);
end;

begin
end.