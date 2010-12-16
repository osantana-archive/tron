Program TRONRunner;

{$G+}
{$M 30000,0,170000}

uses dos,crt,graph,dungeon;

const cima     = 1 ;
      direita  = 2 ;
      baixo    = 3 ;
      esquerda = 4 ;
var   x1,y1,x2,y2  : integer  ; { Coordenadas das motos  }
      d1,d2        : integer  ; { Dire‡„o das motos      }
      time         : word     ; { Retardo de tempo       }
      bl,re,tot    : byte     ; { Totais de vit. e part. }
      mouseinst    : boolean  ; { Mouse instalado ?      }
      music        : boolean  ; { Musica ?               }
      comeca       : boolean  ; { Comeca ?               }
      loop1,loop2  : boolean  ; { controle de loop       }
      tmouse       : mouse    ; { OOP de mouse           }
      vib          : shortint ; { Oscila‡„o no fundo     }
      vib_delay    : byte     ; { Tempo de vibra‡„o      }
      vib_inc      : shortint ; { Incremento             }
      inteligence  : boolean  ; { Computador ?           }
      ch           : char     ; { caracter de uso geral  }
      nconta       : boolean  ; { nao conta?             }

procedure startgraphmode;
var driver      : integer;
    mode        : integer;
begin
   driver  := VGA;
   mode    := VGAHi;
   initgraph(driver,mode,'.\');
   if graphresult <> grok then begin
      clrscr;
      textattr := 79;
      write('Erro ao inicializar o modo gr fico...');
      textattr := 07;
      writeln       ;
      halt(1)       ;
   end;
end;

procedure tronlogo(x,y : integer;color : boolean);
var cor : byte;
begin
     if not color then begin
        setcolor(black)                 ;
        setfillstyle(solidfill,black)   ;
        cor := black                    ;
     end                                ;
     if color then begin
        setcolor(magenta)               ; {T}
        setfillstyle(solidfill,magenta) ;
        cor := magenta                  ;
     end                                ;
     rectangle(x    ,y    ,x+100,y+020) ;
     line     (x    ,y+040,x+020,y+040) ;
     line     (x    ,y+040,x    ,y+080) ;
     line     (x+020,y+040,x+020,y+080) ;
     arc(x+25,y+80,180,270,05)          ;
     arc(x+25,y+80,180,270,25)          ;
     line     (x+025,y+105,x+100,y+105) ;
     line     (x+025,y+085,x+100,y+085) ;
     line     (x+100,y+085,x+100,y+105) ;
     floodfill(x+001,y+001,cor    )     ;
     floodfill(x+001,y+041,cor    )     ;
     inc(x,120)                         ;
     if color then begin
        setcolor(green )                ; {R}
        setfillstyle(solidfill,green )  ;
        cor := green                    ;
     end                                ;
     arc(x+70,y+30,270,90,30)           ;
     arc(x+70,y+30,270,90,10)           ;
     line(x    ,y    ,x    ,y+020)      ;
     line(x    ,y    ,x+070,y    )      ;
     line(x    ,y+020,x+070,y+020)      ;
     line(x    ,y+040,x    ,y+060)      ;
     line(x    ,y+040,x+070,y+040)      ;
     line(x    ,y+060,x+050,y+060)      ;
     line(x+080,y+105,x+100,y+105)      ;
     line(x+050,y+060,x+080,y+105)      ;
     line(x+070,y+060,x+100,y+105)      ;
     floodfill(x+1,y+1,cor )            ;
     inc(x,120)                         ;
     if color then begin
        setcolor(cyan)                  ; {O}
        setfillstyle(solidfill,cyan)    ;
        cor := cyan                     ;
     end                                ;
     line(x+040,y    ,x+040,y+020)      ;
     line(x    ,y+040,x+020,y+040)      ;
     line(x+040,y    ,x+075,y    )      ;
     line(x+040,y+020,x+075,y+020)      ;
     line(x+100,y+025,x+100,y+080)      ;
     line(x+080,y+025,x+080,y+080)      ;
     line(x    ,y+040,x    ,y+080)      ;
     line(x+020,y+040,x+020,y+080)      ;
     line(x+025,y+085,x+075,y+085)      ;
     line(x+025,y+105,x+075,y+105)      ;
     arc(x+075,y+025,000,090,05)        ;
     arc(x+075,y+025,000,090,25)        ;
     arc(x+075,y+080,270,000,05)        ;
     arc(x+075,y+080,270,000,25)        ;
     arc(x+025,y+080,180,270,05)        ;
     arc(x+025,y+080,180,270,25)        ;
     floodfill(x+001,y+041,cor )        ;
     floodfill(x+041,y+001,cor )        ;
     inc(x,120);
     if color then begin
        setcolor(blue)                  ; {N}
        setfillstyle(solidfill,blue)    ;
        cor := blue                     ;
     end                                ;
     line(x+000,y    ,x+075,y    )      ;
     line(x+020,y+020,x+075,y+020)      ;
     line(x+100,y+025,x+100,y+105)      ;
     line(x+080,y+025,x+080,y+105)      ;
     line(x    ,y    ,x    ,y+105)      ;
     line(x+020,y+020,x+020,y+105)      ;
     line(x    ,y+105,x+020,y+105)      ;
     line(x+080,y+105,x+100,y+105)      ;
     arc(x+075,y+025,000,090,05)        ;
     arc(x+075,y+025,000,090,25)        ;
     floodfill(x+001,y+001,cor)         ;
end;

procedure sai;
var traco : word;
    rgb   : byte;
begin
   if mouseinst then tmouse.hide;
   for traco := 2 to 239 do begin
      setcolor(lightgray);
      line(1,traco,640,traco);
      line(1,480-traco,640,480-traco);
      setcolor(black);
      line(1,traco-1,640,traco-1);
      line(1,480-traco+1,640,480-traco+1);
   end;
   for traco := 1 to 318 do begin
      line(traco,230,traco,250);
      line(640-traco,230,640-traco,250);
      delay(5);
   end;
   for rgb := 32 downto 0 do begin
      setrgb(lightgray,rgb,rgb,rgb);
      delay(5);
   end;
   for rgb := 0 to 63 do begin
      setrgb(lightgray,rgb,rgb,rgb);
      delay(5);
   end;
   for rgb := 32 downto 0 do begin
      setrgb(lightgray,rgb,rgb,rgb);
      delay(5);
   end;
   closegraph     ;
   clrscr         ;
   halt(0)        ;
end;

procedure botao(x1,y1,x2,y2 : integer; text : string; press : boolean);
begin
   press := not press ;
   box3d(x1,y1,x2,y2,3,press,lightgray) ;
   settextstyle(defaultfont,horizdir,1) ;
   setcolor(black)                      ;
   if press = true then
      outtextxy((x2 - x1) div 2 + x1 + 1,
                (y2 - y1) div 2 + y1 + 1, text)
   else
      outtextxy((x2 - x1) div 2 + x1 + 2,
                (y2 - y1) div 2 + y1 + 2, text) ;
   setcolor(white)                              ;
   outtextxy((x2 - x1) div 2 + x1,
             (y2 - y1) div 2 + y1, text)        ;
end;

procedure print(x,y : integer; t : string; clr,sombr : byte);
begin
   setcolor(black)              ;
   outtextxy(x+sombr,y+sombr,t) ;
   setcolor(clr)                ;
   outtextxy(x,y,t)             ;
end;

procedure abertura;
var ch        : char;
    buttons   : word;
begin
   video(0)                                  ;
   if comeca and mouseinst then tmouse.hide  ;
   box3d(001,001,638,478,10,outof,lightgray) ;
   box3d(050,020,590,160,05,outof,lightgray) ;
   box3d(058,028,582,152,05, inof,lightgray) ;
   tronlogo(093,39,false)                    ;
   tronlogo(090,36,true )                    ;
   settextjustify(centertext,centertext)     ;
   settextstyle(defaultfont,horizdir,01)     ;
   botao(050,400,150,450,'Jogar',false)      ;
   botao(490,400,590,450,'Sair',false)       ;
   box3d(526,305,614,362,03,inof,lightgray)  ;
   print(570,316,'Jogadores',white,1)        ;
   botao(538,328,564,354,'1',    inteligence);
   botao(575,328,601,354,'2',not inteligence);
   box3d(325,397,375,453,3,inof,lightgray)   ;
   box3d(265,397,315,453,3,inof,lightgray)   ;
   print(320,385,'Vit¢rias',white,1)         ;
   box3d(050,165,505,365,03,outof,lightgray) ;
   box3d(055,170,500,360,03, inof,lightgray) ;
   print(280,195,'T r o n',white,1)          ;
   settextjustify(lefttext,centertext)       ;
   print(515,170,'by Vardo',white,1)         ;

   print(66,220,'O objetivo  deste jogo ‚ n„o bater  no rastro da moto',white,1);
   print(66,235,'advers ria,  nem tampouco nos cantos da arena.  A mo-',white,1);
   print(66,250,'to de Cor Azul movimenta-se com as teclas  "Z"  e "X"',white,1);
   print(66,265,'sendo respectivamente esquerda e direita.   A moto de',white,1);
   print(66,280,'Cor  Vermelha movimenta-se  com as  teclas  "N" e "M"',white,1);
   print(66,295,'tambem com os mesmos movimentos (esquerda e direita).',white,1);
   print(66,310,'Para ajustar a velocidade das motos, use  "+" ou "-".',white,1);
   settextjustify(centertext,centertext)              ;
   setfillstyle(solidfill,lightred)                   ; { estatistica Red  }
   if tot = 0 then begin
      tot := 1;
      re  := 1;
      bl  := 1;
   end;
   bar(329,450-(50*(re*100 div tot) div 100),371,450) ;
   setfillstyle(solidfill,lightblue)                  ; { estatistica Blue }
   bar(269,450-(50*(bl*100 div tot) div 100),311,450) ;
   video(1)        ; { reativa video                 }
   bl     := 0     ; { partidas ganhas por Blue  }
   re     := 0     ; { partidas ganhas por Red   }
   tot    := 0     ; { total de partidas         }
   if mouseinst then begin
      buttons := tmouse.start     ;
      tmouse.show                 ;
      tmouse.setxy(320,240)       ;
      tmouse.setarea(0,0,630,461) ;
   end;
   while true do begin
      if mouseinst and tmouse.button(1) then begin
         if tmouse.area(050,400,150,450) then begin   { Jogar }
            tmouse.hide                          ;
            botao(050,400,150,450,'Jogar',true)  ;
            tmouse.show                          ;
            while tmouse.button(1) do            ;
            exit                                 ;
            tmouse.hide                          ;
            botao(050,400,150,450,'Jogar',false) ;
            tmouse.show                          ;
         end                                     ;
         if tmouse.area(490,400,590,450) then begin   { Sair }
            tmouse.hide                         ;
            botao(490,400,590,450,'Sair',true)  ;
            tmouse.show                         ;
            while tmouse.button(1) do           ;
            tmouse.hide                         ;
            botao(490,400,590,450,'Sair',false) ;
            tmouse.show                         ;
            sai                                 ;
         end                                    ;
         if tmouse.area(538,328,564,354) and not inteligence then begin   { 1 }
            inteligence := true                 ;
            tmouse.hide                         ;
            botao(538,328,564,354,'1',    inteligence);
            botao(575,328,601,354,'2',not inteligence);
            tmouse.show                         ;
         end                                    ;
         if tmouse.area(575,328,601,354) and inteligence then begin   { 2 }
            inteligence := false                ;
            tmouse.hide                         ;
            botao(538,328,564,354,'1',    inteligence);
            botao(575,328,601,354,'2',not inteligence);
            tmouse.show                         ;
         end                                    ;
      end;
      if keypressed then begin
         ch := upcase(readkey);
         if ch = 'S' then sai  ;
         if ch = 'J' then exit ;
         if (ch = '1') and (not inteligence) then begin
            inteligence := true;
            if mouseinst then tmouse.hide;
            botao(538,328,564,354,'1',    inteligence);
            botao(575,328,601,354,'2',not inteligence);
            if mouseinst then tmouse.show;
         end;
         if (ch = '2') and inteligence then begin
            inteligence := false;
            if mouseinst then tmouse.hide;
            botao(538,328,564,354,'1',    inteligence);
            botao(575,328,601,354,'2',not inteligence);
            if mouseinst then tmouse.show;
         end;
      end;
      setrgb(magenta ,0,0,32);
      setrgb(green   ,0,0,32);
      setrgb(cyan    ,0,0,32);
      setrgb(blue    ,0,0,32);
   end;
end;

function verifyblue : boolean;
var tmp : boolean;
begin
   if (getpixel(x1,y1) <> magenta) and
      (getpixel(x1,y1) <> black)   then
         tmp := true else tmp := false;
   verifyblue := tmp;
end;

function verifyred : boolean;
var tmp : boolean;
begin
   if (getpixel(x2,y2) <> magenta) and
      (getpixel(x2,y2) <> black)   then
         tmp := true else tmp := false;
   verifyred := tmp;
end;

procedure vitoria;
var mens   : string;
begin
   mens := '';
   if verifyblue then begin
      inc(re);
      Mens := 'Vermelho Venceu !';
      box3d(90,90,550,390,5,outof,lightred);
   end else begin
      inc(bl);
      Mens := 'Azul Venceu !';
      box3d(90,90,550,390,5,outof,lightblue);
   end;
   inc(tot);
   settextstyle(1,Horizdir,2);
   settextjustify(centertext,centertext);
   setcolor(black);
   outtextxy(328,152,mens);
   outtextxy(328,212,'Pressione qualquer tecla para continuar');
   outtextxy(328,262,'ou');
   outtextxy(328,312,'Pressione ESC para retornar ao menu');
   setcolor(white);
   outtextxy(325,150,mens);
   outtextxy(325,210,'Pressione qualquer tecla para continuar');
   outtextxy(325,260,'ou');
   outtextxy(325,310,'Pressione ESC para retornar ao menu');
   repeat until keypressed;
   if readkey = #27 then loop2 := false;
end;

procedure drawmoto           ;
begin
   putpixel(x1,y1,lightblue) ;
   putpixel(x2,y2,lightred)  ;
end                          ;

function pnt(x,y : integer) : boolean;
begin
   if (getpixel(x,y) <> magenta) and (getpixel(x,y) <> black) then
      pnt := true else pnt := false;
end;

function scanpnt : boolean;
var tmpresp : boolean;
    coordi  : integer;
    coordf  : integer;
    espaco  : integer;
    incdec  : integer;
begin
   tmpresp := false;
   espaco  := random(15) + 1;
   if (d1 = cima) or (d1 = baixo) then begin
      incdec  := ifint(d1 = cima,-1,1);
      coordi  := y1 + incdec;
      coordf  := y1 + (espaco*incdec);
      while (coordi <> coordf) and (not tmpresp) do begin
         if pnt(x1,coordi) then tmpresp := true;
         coordi := coordi + incdec;
      end;
   end;
   if (d1 = esquerda) or (d1 = direita) then begin
      incdec  := ifint(d1 = esquerda,-1,1);
      coordi  := x1 + incdec;
      coordf  := x1 + (espaco*incdec);
      while (coordi <> coordf) and (not tmpresp) do begin
         if pnt(coordi,y1) then tmpresp := true;
         coordi := coordi + incdec;
      end;
   end;
   scanpnt := tmpresp;
end;

function resolution: integer;
var tmp       : integer;
    okloop    : boolean;
    resp      : integer;
begin
   resp := 0;
   if scanpnt then begin
      okloop := true;
      if (d1 = cima) or (d1 = baixo) then begin
         tmp    := 1;
         while okloop do begin
            if pnt(x1+tmp,y1) then begin
               okloop := false;
               resp   := ifint(d1=cima,-1,1);
            end;
            if pnt(x1-tmp,y1) and (resp = 0) then begin
               okloop := false;
               resp   := ifint(d1=cima,1,-1);
            end;
            tmp := tmp + 1;
         end;
      end;
      if (d1 = esquerda) or (d1 = direita) then begin
         tmp    := 1;
         while okloop do begin
            if pnt(x1,y1+tmp) then begin
               okloop := false;
               resp   := ifint(d1=esquerda,1,-1);
            end;
            if pnt(x1,y1-tmp) and (resp = 0) then begin
               okloop := false;
               resp   := ifint(d1=esquerda,-1,1);
            end;
            tmp := tmp + 1;
         end;
      end;
   end;
   resolution := resp;
end;

procedure keyboard;
var ch : char;
begin
   if keypressed then begin
      ch := upcase(readkey);
      if not inteligence then begin
         if (ch = 'X') then if d1 = esquerda then d1 := cima     else inc(d1);
         if (ch = 'Z') then if d1 = cima     then d1 := esquerda else dec(d1);
      end;
      if ch = 'M' then if d2 = esquerda then d2 := cima     else inc(d2);
      if ch = 'N' then if d2 = cima     then d2 := esquerda else dec(d2);
      if (ch = '+') and (time > 00) then dec(time);
      if (ch = '-') and (time < 65000) then inc(time);
      if ch = #27 then begin
         nconta := true;
         loop1 := false;
         loop2 := false;
      end;
   end;
   if inteligence then begin
      d1 := d1 + resolution ;
      if d1 > 4 then d1 := 1;
      if d1 < 1 then d1 := 4;
   end;
   case d1 of
      cima     : dec(y1);
      baixo    : inc(y1);
      direita  : inc(x1);
      esquerda : dec(x1);
   end;
   case d2 of
      cima     : dec(y2);
      baixo    : inc(y2);
      direita  : inc(x2);
      esquerda : dec(x2);
   end;
end;

procedure initmouse;
begin
   if tmouse.start = 0 then begin
      mouseinst := false ;
      textattr  := 79    ;
      write('Driver de Mouse n„o dispon¡vel');
      textattr  := 07    ;
      writeln;
      writeln('Utilize:');
      writeln('J - Jogar             ');
      writeln('S - Sair              ');
      writeln('L - Ligar m£sica      ');
      writeln('D - Desligar m£sica   ');
      writeln('1 - Um jogador        ');
      writeln('2 - Dois jogadores    ');
      writeln('+ - Aumenta Velocidade');
      writeln('- - Diminui Velocidade');
      writeln; writeln;
      repeat until keypressed;
   end else mouseinst := true;
end;

procedure initgame;
begin
   if mouseinst then tmouse.hide;
   cleardevice       ;  { Limpa a tela                   }
   d1 := direita     ;  { Moto 1 andando para direita    }
   d2 := esquerda    ;  { Moto 2 andando para a esquerda }
   x1 := 040         ;  { Posicao da primeira moto       }
   y1 := 240         ;  {                                }
   x2 := 600         ;  { Posicao da segunda moto        }
   y2 := 240         ;  {                                }
   vib       := 1    ;  { inicializa vibracao            }
   loop1     := true ;  { loop da partida                }
   vib_delay := 1    ;  { tempo de vibracao              }
   vib_inc   := 1    ;  { incremento vibracao            }
   video(0)          ;  { Desliga o v¡deo                }
   setrgb(magenta,0,0,0)                  ; { Ajusta mag. p/ blk  }
   box3d(001,001,638,478,5,outof,green)   ; { Desenha a arena     }
   box3d(011,011,627,467,5, inof,magenta) ; { pinta de magenta    }
   tronlogo(090,187,false)                ; { logotipo central    }
   settextstyle(defaultfont,horizdir,1)   ; { letra normal        }
   outtextxy(515,305,'by Vardo')          ; { feito preu          }
   video(1)                               ; { Liga o v¡deo        }
end;

begin
   randomize               ; { inicializa aleatorio          }
   clrscr                  ; { Limpa a tela texto            }
   textattr := 31          ; { Branco / Azul                 }
   textattr := 07          ; { Branco / Negro                }
   initmouse               ; { inicializa mouse              }
   comeca := true          ; { Comeca                        }
   inteligence := false    ; { Computador ligado             }
   startgraphmode          ; { inicializa o modo grafico     }
   time  := 100            ; { ----- Define Tempo -----      }
   bl    := 1              ; { partidas ganhas por Blue      }
   re    := 1              ; { partidas ganhas por Red       }
   tot   := 1              ; { total de partidas             }
   nconta := false;
   while true do begin     ; { inicio do loop do jogo        }
      abertura             ; { Abertura do Jogo              }
      loop2 := true        ; { Loop de varias partidas       }
      while loop2 do begin
         initgame;
         nconta := false;
         while loop1 do begin
            if not ((verifyblue) or (verifyred)) then begin
               drawmoto         ;
               keyboard         ;
               delay(time)      ;
            end
            else loop1 := false ;
            inc(vib_delay)      ;
            if vib_delay >= 7 then begin
               vib_delay := 0   ;
               inc(vib,vib_inc) ;
               if (vib < 20) and (vib > 00) then
                  setrgb(magenta,0,vib,0);
            end;
            if vib > +30 then vib_inc := -1 ;
            if vib < -10 then vib_inc := +1 ;
         end     ;
         if not nconta then
            vitoria ;
      end;
   end;
end.
