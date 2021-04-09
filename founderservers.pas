program foundersvs;

uses crt;

type Tficha=record
  	 id:integer;
     estado:boolean;
 	   nome:string[30];
  	 jogo:string[5];
  	 admin:string[10];
 	   ip:string[20];
  	 customip:string[50];
 	   payment:string[15];
		 end;
		 
 TLista=^Lista;
 Lista = record
     id:integer;
     estado:boolean;
 	   nome:string[30];
  	 jogo:string[5];
  	 admin:string[10];
 	   ip:string[20];
  	 customip:string[50];
 	   payment:string[15];
		 end;

var  ficha,ficha1,ficha2,ficha3:Tficha;
		 ficheiro:file of Tficha;
		 txt:text;
		 index:integer;
		 op:char;
		 ipnums:integer;
		 ipnumstr:string[5];
		 ipfixo:string[20];
		 ptr_ficha,ptr_novo:TLista;

procedure add(var ficha:Tficha);
begin	
  index:=filesize(ficheiro);
  seek(ficheiro, index);
  ficha.id:=index+1;
  write(ficheiro,ficha);
end;

procedure sv_jogo; // jogo do servidor
begin
  clrscr;
  writeln('Para que jogo irá o servidor trabalhar?');
  writeln('1 - Counter-Strike 1.6');
  writeln('2 - Counter-Strike Source');
  writeln('3 - Counter-Strike Global Offensive');
  writeln('4 - Team Fortress 2');
  writeln('5 - Left 4 Dead 2');
  writeln('6 - Trackmania United Forever');
  ptr_ficha^.jogo:=readkey; // armazenar o readkey no ponteiro
  
  {dar o nome do jogo no ficheiro à string do valor armazenado no ponteiro}
  if ptr_ficha^.jogo='1' then ficha.jogo:='CS1.6';
  if ptr_ficha^.jogo='2' then ficha.jogo:='CSS';
  if ptr_ficha^.jogo='3' then ficha.jogo:='CSGO';
  if ptr_ficha^.jogo='4' then ficha.jogo:='TF2';
  if ptr_ficha^.jogo='5' then ficha.jogo:='L4D2';
  if ptr_ficha^.jogo='6' then ficha.jogo:='TMUF'; 
  {fim}
  
end;

procedure sv_data; // dados do servidor
begin
  clrscr;
  writeln('Qual irá ser o nome do servidor apresentado no HUD?');
  readln(ptr_ficha^.nome);
  write('Username do Administrador do Servidor: ');
  readln(ptr_ficha^.admin);
  writeln('Insira o Custom IP pelo qual o jogador se irá conectar ao servidor');
  readln(ptr_ficha^.customip);
  {inserir valores do ponteiro no ficheiro}
  ficha.nome:=ptr_ficha^.nome;
  ficha.admin:=ptr_ficha^.admin;
  ficha.customip:=ptr_ficha^.customip;
end;

procedure sv_pagamento; // método de pagamento
begin
  clrscr;
  writeln('Método de pagamento escolhido pelo admin');
  writeln('1 - Paypal');
  writeln('2 - Paysafecard');
  writeln('3 - Transferência Bancária');
  writeln('4 - Transferência via telemóvel');
  ptr_ficha^.payment:=readkey;
  if ptr_ficha^.payment='1' then ficha.payment:='Paypal';
  if ptr_ficha^.payment='2' then ficha.payment:='PaySafeCard';
  if ptr_ficha^.payment='3' then ficha.payment:='Banco';
  if ptr_ficha^.payment='4' then ficha.payment:='Telemóvel';
end;

procedure ftxt;
var c:char;
 begin (* Abrir Ficheiro origem para Leitura *)
  assign(txt,'c:\founderservers\founderservers\ServersON.txt');
  reset(txt);
  while not
  eof(txt) do
  begin (* Copiar uma Linha *)
    while not eoln(txt) do
    begin (* Copiar um caracter *)
      read(txt, c);
      write(c);
    end;
    readln(txt);
    writeln;
  end;
  readln;
end;


procedure SERVERON; // Procedimento final - servidor já ligado
begin
 clrscr;
  randomize;
	 repeat
 	  ipnums:=random(55555);
   until (ipnums>9999) and (ipnums<99999); 
	str(ipnums, ipnumstr);                                   
  ficha.ip:=ipfixo+'.'+ipnumstr;   
	writeln('ESTE SERVIDOR ESTÁ AGORA LIGADO COM O ID Nº',ficha.id); 
  writeln('Vá ao menu do jogo e faça "connect ',ficha.customip,'" ou "connect ',ficha.ip,'"');
  delay(500);
  assign(txt,'C:\FounderServers\FounderServers\ServersON.txt');
  {$i-}
  append(txt);
  {$i+}
  if ioresult<>0 then
  rewrite(txt)
  else
  writeln('A carregar ficheiro de texto...');
  delay(500);
  writeln('Ficheiro de texto aberto com sucesso!');
  writeln('');
  write(txt,'JOGO: ');  
  writeln(txt,ficha.jogo);
  write(txt,'IP: ');
  writeln(txt,ficha.ip);
  write(txt,'CUSTOM IP: ');
  write(txt,ficha.customip);
  writeln(txt,'.founderplay.pt');
  writeln('Ficheiro de texto atualizado');
  readln;
  close(txt);
end; 

procedure adquirir(var ficha:Tficha); // ADQUIRIR DADOS DO SERVIDOR
begin
  ptr_ficha^.id:=ptr_ficha^.id+1;
	sv_jogo;
  sv_data;
  sv_pagamento;
  ficha.estado:=true;
  SERVERON;   	
end;

procedure ler(id:integer); // LER DADOS DE UM ID
var fc:Tficha;
begin
  seek(ficheiro,ptr_ficha^.id-1);
  read(ficheiro,fc);
  if fc.estado then
   begin
    writeln('ID do Server: ',fc.id);
    writeln('IP: ',fc.ip);
    writeln('Jogo: ',fc.jogo);
    writeln('Nome: ',fc.nome);
    writeln('Admin do Server: ',fc.admin);
    writeln('Custom IP: ',fc.customip);
    writeln('Pagamento: ',fc.payment);
    writeln('Estado (1 - ON/0 - OFF): ',fc.estado);
    writeln;
   end
  else
  writeln('ID não existe');
  readln;
end;

procedure todos; // VER TODOS OS SERVIDORES ATIVOS + DADOS
var fc:Tficha;
    i,pag:integer;

begin
  pag:=0;
  clrscr;
  for i:=0 to filesize(ficheiro)-1 do
  begin
    seek(ficheiro,i);
    read(ficheiro,fc);
    if fc.estado then
    begin
      writeln('ID do Server: ',fc.id:4);
      writeln('IP: ',fc.ip);
      writeln('Jogo: ',fc.jogo);
      writeln('Nome: ',fc.nome);
      writeln('Admin do Server: ',fc.admin);
      writeln('Custom IP: ',fc.customip);
      writeln('Pagamento: ',fc.payment);
      writeln('Estado (1 - ON/0 - OFF): ',fc.estado);
      writeln;
      if pag>24 then
      begin
        readln;
        pag:=0;
        clrscr;
      end
      else
      pag:=pag+3;
    end;
  end;
  writeln('Enter para continuar');
  readln;
end;

function totalFichas:integer; // Função que permite fazer a gestão das fichas
var fc:Tficha;
	  i,pag:integer;

begin
  pag:=0;
  clrscr;
  for i:=0 to filesize(ficheiro)-1 do
  begin
    seek(ficheiro,i);
    read(ficheiro,fc);
    if fc.estado then
    pag:=pag+1;
  end;
  totalFichas:=pag;
end;


procedure apagar(id:integer); // Procedimento que permite apagar uma ficha
var fc:Tficha;
begin
  seek(ficheiro,id-1);
  read(ficheiro,fc);
  fc.estado:=false;
  seek(ficheiro,id-1);
  write(ficheiro,fc);
  writeln('Servidor apagado com sucesso');
end;

procedure menu; // Menu
var op:char;
id:integer;

begin
  repeat
    textbackground(4);
    clrscr;
    id:=totalFichas;
    textcolor(10);
    writeln('   Total de servidores ativos: ',ptr_ficha^.id);
    delay(100);
    textcolor(14);
    writeln('      1 - Novo Servidor');
    delay(100);
    writeln('       2 - Ver ID do Servidor');
    delay(100);
    writeln('        3 - Ver Todos os Servidores Ativos');
    delay(100);
    writeln('         4 - Desativar Servidor');
    delay(100);
    writeln('        5 - Alterar IP fixo (Neste momento é: ',ipfixo,')');
    delay(100);
    writeln('       6 - Ficheiro de texto');
    delay(100);
    writeln('      S - Sair');
    delay(1000);
    writeln('');
    writeln('Carregue nas teclas 1,2,3,4,5 e S para continuar...');
    op:=readkey;
    case op of
      '1':begin
        adquirir(ficha1);
        add(ficha1);
      end;
      '2':begin
        writeln('');
        writeln('ID=?');
        readln(id);
        ler(id);
      end;
      '3':begin
        todos;
      end;
      '4':begin
        writeln('');
        writeln('ID=?');
        readln(id);
        apagar(id);
      end;
      '5':begin
        clrscr;
        writeln('Qual é o novo IP que quer que seja usado?');
        readln(ipfixo);
        end;
      '6':ftxt;
    end;
  until op='s';
end;


begin
	new(ptr_ficha);
  textcolor(10);
  textbackground(0);
  clrscr;
  assign(ficheiro,'C:\FounderServers\FounderServers\data.dat');
  {$i-}
  reset(ficheiro);
  {$i+}
  if ioresult<>0 then
  rewrite(ficheiro)
  else
  writeln('A carregar ficheiro de dados...');
  writeln('Ficheiro de dados aberto com sucesso!');
  delay(500);
  writeln('A carregar menus...');
  delay(500);
  writeln('A carregar definições...');
  delay(500);
  writeln('');
  textcolor(12);
  writeln('Carregamento completo!');
  delay(200);
	writeln('Programa carregado com sucesso!'); 
	delay(200);
	writeln('Programa vai abrir em...');
  write('3...');
  delay(1000);
  write('2...');
  delay(1000);
  writeln('1...');
  delay(1000);
  textbackground(1);
  clrscr;
  writeln('Bem vindo ao gestor de servidores da FounderServers!');
  delay(1000);
  writeln('');
  textcolor(9); 
  writeln('Qual é o IP fixo onde os servidores irão ser hospedados?');
  textcolor(14);
  writeln('');
  readln(ipfixo);
  menu;
  close(ficheiro);
  dispose(ptr_ficha);
end.