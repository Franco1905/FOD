program practica2_3_Debug;
const
    valorAlto = 'ZZZZZZ';
type

    provincia = record
        nombre : string;
        cantAlf : integer;
        cantEnc : integer;
    end;

    localidad = record
        nomProv : string;
        codLoc : String;
        cantAlf : integer;
        cantEnc : integer;
    end;

    maestro = file of provincia;
    detalle = file of localidad;

procedure cargarMae (var mae : maestro);
var
    p : provincia;
    name : string;
begin
    rewrite(mae);
    writeln('Condicion de corte: nombre de provincia = -1'); writeln();
    WriteLn('Inserte los nombres de las provincias que desea agregar al archivo maestro: ');
    write(':'); ReadLn(name);
    while (name <> '-1') do
    begin
      p.cantAlf := 0; p.cantEnc := 0;
      p.nombre := name;
      write(mae,p);
      write(':'); ReadLn(name);
    end;
    close(mae);
end;

procedure cargarDet (var det : detalle);

    procedure leerloc (var l : localidad);
    begin
      write('Inserte nombre de la provincia a la que pertenece la localidad: '); readln(l.nomProv);
       if (l.nomProv <> '-1') then
       begin   
          write('Codigo de localidad: '); readln(l.codLoc);
          write('Cantidad de alfabetizados: '); ReadLn(l.cantAlf);
          write('Cantidad de encuestados: '); ReadLn(l.cantEnc);
       end;
    end;
var
    l : localidad;
begin
    Rewrite(det);
    leerloc(l);
    while (l.nomProv <> '-1') do
    begin
        Write(det,l);      
        leerloc(l);
    end;
    close(det);
end;

procedure impMae (var mae : maestro);
    function impProv (p : prov): string
    begin
      impProv := 
           'Nombre : ' + p.nombre 
       + ' | Cantidad de alfabrtizados: ' + p.cantAlf 
       + ' | Cantidad de encuestados: '   + p.cantEnc;
    end;
    procedure leer (var mae : maestro; p : provincia);
    begin
      if Eof(mae) then
        p.nombre := valorAlto
      else
        read(mae,p);
    end;
var
    p : provincia;
begin
    reset(mae);
    leer(mae,p);
    while p.nombre <> valorAlto do
    begin
      impProv(p);
      leer(mae,p);
    end;
    close(mae);
end;

procedure impDet (var det : detalle);
    function impLoc (l : localidad): string
    begin
      impLoc := 
           'Nombre provincia : ' + l.nomProv
       + ' | Codigo de localidad: ' + l.codLoc
       + ' | Cantidad de alfabrtizados: ' + p.cantAlf 
       + ' | Cantidad de encuestados: '   + p.cantEnc;
    end;
    procedure leer (var det : detalle; l : localidad);
    begin
      if Eof(det) then
        l.nomProv := valorAlto
      else
        read(det,l);
    end;
var
    l : localidad;
begin
    reset(det);
    leer(det,l);
    while l.nomProv <> valorAlto do
    begin
      impLoc(l);
      leer(det,l);
    end;
    close(det);
end;




var

    opcion : char;
    mae : maestro;
    det : detalle;

begin
    WriteLn('Menu debug de practica 2 punto 3');
    WriteLn('1 = crear e imptimir Maestro');
    Writeln('2 = crear e imprimir Detalle');

    readln(opcion);

    case opcion of


  
end.