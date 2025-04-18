{
El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: 
código de producto, 
nombre comercial, 
precio de venta, 
stock actual y 
stock mínimo. 
Diariamente se genera un archivo detalle donde se registran todas las ventas de productos realizadas. 
De cada venta se registran: 
código de producto y 
cantidad de unidades vendidas. 

Se pide realizar un programa con opciones para:

a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:

● Ambos archivos están ordenados por código de producto.

● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.

● El archivo detalle sólo contiene registros que están en el archivo maestro.

b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.
}


program practica2_1;
const
    // codigo de producto
    valorAlto = '9999999999';
type

    producto = record
        cod : string[10];
        nombre : string[100];
        precio : real;
        actStock : integer;
        minStock : integer;
    end;

    venta = record
        cod : string;
        cantVen : integer;
    end;

    arch_mast = file of producto;
    arch_det = file of venta;

procedure leer (var archivo : arch_det;var ven : venta);
begin
    if Eof(archivo) then
        ven.cod := valorAlto
    else
        read(archivo,ven)
end;


procedure actualizar (var maestro : arch_mast; var detalle : arch_det);
var
    cantVen : integer;
    ven : venta;
    prod : producto; 
begin
    Reset(detalle); reset (maestro);

    leer(detalle,ven);

    while (ven.cod <> valorAlto) do
    begin
        
        read(maestro,prod);



        cantVen := 0;

        while ven.cod = aux.cod do
        begin
          cantVen := ven.cantVen;
          leer(detalle,ven);
        end;


        // mientras no encuentre el producto del detalle en el maestro
        while ven.cod <> prod.cod do
        begin
           read(prod.cod);
        end;

        seek(maestro,filepos(maestro)-1);

        prod.actStock := prod.actStock - cantVen;

        write(maestro,prod);
    end;
    close(maestro); close(detalle);
end;


procedure exportar (var mae : arch_mast; var texto : text);

procedure leer (var )

var
    prod : producto;
begin
    rewrite(texto); reset(mae);

    leer(mae,prod);

    while prod.cod <> valoralto  do
    begin
        if (prod.actStock < prod.minStock) then
        begin
            write(texto,prod.precio,prod.actStock,prod.minStock,prod.cod);
            writeln(texto,prod.nombre);
        end;
        read(mae,prod);
    end;

    close(texto); close(mae);
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




{programa principal}

var

    mae : arch_mast;
    det : arch_det;
    opcion : char;
    texto : text;
begin
    while true do
    begin
    writeln('Inserte opcion:');
    writeln(' 1 = Actualizar archivo maestro');
    writeln(' 2 = Exportar datos del maestro a un archivo txt');
    writeln(' 3 = Imprimir archivo maestro');
    write('   :');
    readln(opcion);

    case opcion of
        '1': begin
            assign (mae,'Maestro'); assign (det,'Detalle');
            Actualizar(mae,det);
        end;
        '2': begin
            assign(mae,'Maestro'); assign(texto,'stock_minimo.txt');
            exportar(mae,texto);
        end;

        '3': begin
            assign(mae,'Maestro');
            impArch(mae);
        end;
    end;
    end;
end.
