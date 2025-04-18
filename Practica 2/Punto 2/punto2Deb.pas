program debug;
const
    valorAlto = '9999';
type

    producto = record
        cod : string[10];
        nombre : string[100];
        precio : real;
        actStock : integer;
        minStock : integer;
    end;

    venta = record
        cod : string[10];
        cantVen : integer;
    end;


    arch_det = file of venta;
    arch_mast = file of producto;

procedure cargar (var mast : arch_mast);

    procedure leerProd (var prod : producto);
    begin
      write('Codigo de producto: '); readln(prod.cod);
      if prod.cod <> '-1' then
      begin  
         write('Nombre comercial: '); readln(prod.nombre); 
         write('Precio unitario: '); readln(prod.precio);
         write('Stock actual: '); readln(prod.actStock);
         write('Stock minimo: '); readln(prod.minStock);
      end;
    end;

var
    prod : producto;
begin
    rewrite(mast);

    leerProd(prod);
    while prod.cod <> '-1' do
    begin
        write(mast,prod);
        leerProd(prod);
    end;
    
    close(mast);
end;


procedure cargarDet (var det : arch_det);

    procedure leerVen (var ven : venta);
    begin
      write('Codigo de producto: '); readln(ven.cod);
      if (ven.cod <> '-1') then
        write('Cantidad vendida: '); readln(ven.cantVen);
    end;

var
    ven : venta;
begin
    rewrite(det);

    leerVen(ven);
    while ven.cod <> '-1' do
    begin
        write(det,ven);
        leerVen(ven);
    end;

    close(det);
end;




procedure impDet (var det : arch_det);

    procedure leer (var det : arch_det; var ven : venta);
    begin
        if Eof(det) then
            ven.cod := valorAlto
        else
            read(det,ven);
    end;

    procedure impVen (ven : venta);
    begin
        writeln('Codigo: ',ven.cod,' | Cantidad vendida: ',ven.cantVen);
    end;

var
    ven : venta;
begin

    reset(det);

    leer(det,ven);
    while (ven.cod <> valorAlto) do
    begin
        impVen(ven);
        leer(det,ven);
    end;

    close(det);
end;




procedure impArch (var mast : arch_mast);

    procedure impProd (prod : producto);
    begin
       writeln(
       ' Producto numero: ',prod.cod,
       ' | Nombre: ',prod.nombre,
       ' | Precio: ',prod.precio:0:2,
       ' | Stock actual: ',prod.actStock,
       ' | Stock minimo: ',prod.minStock)
    end;

    procedure leer (var mast : arch_mast; var prod : producto);
    begin
      if Eof(mast) then
         prod.cod := valorAlto
      else
         read(mast,prod);
    end;

var
    prod : producto;
begin
    reset(mast);

    leer(mast,prod);
    while (prod.cod <> valorAlto) do
    begin
        impProd(prod);
        leer(mast,prod);
    end;

    close(mast);
end;



{Programa principal}


var
    opcion : char;
    mast : arch_mast;
    det : arch_det;
begin
    writeln('Opciones: '); 
    writeln('1 = crear Maestro');
    writeln('2 = crear Detalle');
    readln(opcion);

    case opcion of

        '1': begin
          assign(mast,'Maestro.dat');
          cargar(mast);
          impArch(mast);
        end;

        '2': begin
            assign(det,'Detalle.dat');
            cargarDet(det);
            impDet(det);
        end;
    end;
end.
