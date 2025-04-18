{5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:

a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares deben contener: código de celular, nombre,
descripción, marca, precio, stock mínimo y stock disponible.

b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.

c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.

d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2.

NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el
usuario.

NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique
en tres líneas consecutivas. En la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”.
}



program ej5;
uses SysUtils;
const
    valorAlto = 9999;
    line = '*************';
type

    celular = record
        precio : real;
        cod : integer;
        minStock : integer; //Stock minimo
        dispStock : integer; //Stock disponible
        nombre : string[20];
        desc : string;
        marca : string[10];
    end;
    //  precio, cod, minStock, dispStock
    //nombre
    //desc
    //marca
    

    archCelular = File of celular;


{readln(texto, reg.cod, reg.precio, reg.stockMin, reg.stockAct, reg.desc);
  readln(texto, reg.marca);
  write(binario, reg);
}

procedure impCel (cel : celular);
begin
  writeLn('Codigo: ',cel.cod,
    ' Precio: ',cel.precio,
    ' Stock minimo: ',cel.minStock,
    ' Stock disponible: ',cel.dispStock,
    ' Nombre: ',cel.nombre,
    ' Marca: ',cel.marca);
  writeln('Descripcion: ',cel.desc);
end;

procedure cargarBin (var celulares : archCelular;var textCel : Text);// carga el archivo binario con el txt
{carga un archivo binario en base al archivo de texto}
var
  cel : celular;
begin
  rewrite(celulares);
  while not Eof(textCel) do
    begin
      readln(textCel, cel.cod,cel.precio,cel.marca);//leo todo lo que esta en la linea, y lo guardo en esos campos
      readln(textCel,cel.dispStock,cel.minStock,cel.desc);
      readln(textCel,cel.nombre);
      //ahora en teoria, el registro esa lleno de datos y esta listo para entrar en el binario
      Write(celulares,cel);
    end;
  close(celulares);
end;

procedure leer (var archivo : archCelular;var celu : celular);
{lee un registro del archivo}
begin
  if not Eof(archivo) then
    Read(archivo,celu)
  else
    celu.cod := valorAlto;
end;


procedure menorMin (var arch : archCelular);
{Imprime los celulares cuyo stock disponible es menor al minimo}
var
  cel : celular;
begin
  reset(arch);
  leer(arch,cel);

  writeLn(line);
  writeLn('Estos son los celulares cuyo stock disponible es menor al minimo: ');
  
  while cel.cod <> valorAlto do
    begin
      if cel.dispStock < cel.minStock then
        impCel(cel);
      leer(arch,cel);
    end;
  close(arch);
end;

procedure buscarCelu (var arch : archCelular);
{imprime los celulares que tienen cierta palabra dentro de su descripcion}
var
  cel : celular;
  desc : string;
begin
  reset(arch);
  writeln(line);
  write('Inserte la cadena que quiera buscar: ');
  read(desc);
  leer(arch,cel);
  while cel.cod <> valorAlto do
  begin
    
    // DEBUGGING imprimir todas las posiciones en las que aparece la palabra, solo para ver que hace
    
    writeln(Pos (desc,cel.desc));

    // en caso de que no tire error si es que la palabra no existe, supongo que devolvera un valor generico, como 0, en es caso
    //  quiero usar ese valor para evaluar si la palabra esta en la descripcion
    
    { if print(Pos (desc,celu.desc)) <> x then
        impCel(cel);
    }
    leer(arch,cel);
  end;
  close(arch);
end;



procedure menu ();
begin

  WriteLn('Menu de opciones para archivos de celulares: ');
  writeln();
  writeln(line);

  writeln('1- Crear archivo de celulares en base al archivo de texto "celulares.txt"');
  WriteLn('2- Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo');
  writeln('3- Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario');
  writeln('4- hacer exportar archivo a txt');
  writeln('5- cerrar programa');
end;



{Programa Principal}


var
    opcion : string[1];
    cel_fis : String; //nombre fisico del arch
    cel_log : archCelular; //nombre logico del archivo de celulares
    cel_txt : Text;
begin
  menu();
  write('Inserte la opcion que quiera ejecutar: ');
  readln(opcion);
  while (opcion <> '5') do
  begin
    case opcion of
      '1': begin
      {carga un archivo binario en base al archivo de texto}
        write('inserte nombre o ruta del achivo binario a crear: ');
        readln(cel_fis);
        assign(cel_log,cel_fis);
        assign(cel_txt,'celulares.txt');
        cargarBin(cel_log,cel_txt);
        end;

      '2': begin
        write('inserte nombre o ruta del achivo binario: ');
        readln(cel_fis);
        if FileExists(cel_fis)then
        begin  
          assign(cel_log,cel_fis);
          assign(cel_txt,'celulares.txt');
          menorMin(cel_log);
        end
        else
          writeln('El archivo no esxiste!!');
      end;

     end;
   end;
end.