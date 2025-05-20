{
3. Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.
El programa debe presentar un menú con las siguientes opciones:
    a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.
    b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a), se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de “enlace” de la lista (utilice el código de
novela como enlace), se debe especificar los números de registro
referenciados con signo negativo, . Una vez abierto el archivo, brindar
operaciones para:
     i. Dar de alta una novela leyendo la información desde teclado. Para
esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre.
     ii. Modificar los datos de una novela leyendo la información desde
teclado. El código de novela no puede ser modificado.
     iii. Eliminar una novela cuyo código es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el
registro en la posición 8 debe copiarse el antiguo registro cabecera.
    c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.

NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
proporcionado por el usuario.

}

program ej3;
const
    valoralto = 9999;
type
    novela = record
        codigo  : integer;
        genero : string;
        nombre : string;
        duracion : integer;
        director : string;
        precio : real;
    end;

    archivo = file of novela;
    
procedure crearArchivo(var a : archivo);
var
    n : novela;
    nombreArchivo : string;
begin
    writeln('Ingrese el nombre del archivo:');
    readln(nombreArchivo);
    assign(a, nombreArchivo);
    rewrite(a);
    
    n.codigo := 0; // Cabecera de la lista invertida
    n.genero := '';
    n.nombre := '';
    n.duracion := 0;
    n.director := '';
    n.precio := 0.0;
    write(a, n); // Escribimos la cabecera en el archivo
    
    writeln('Ingrese el codigo de la novela (0 para terminar):');
    readln(n.codigo);

    while n.codigo <> 0 do
        begin
            writeln('Ingrese el genero:');
            readln(n.genero);
            writeln('Ingrese el nombre:');
            readln(n.nombre);
            writeln('Ingrese la duracion:');
            readln(n.duracion);
            writeln('Ingrese el director:');
            readln(n.director);
            writeln('Ingrese el precio:');
            readln(n.precio);
            
            write(a, n);
            
            writeln('Ingrese el codigo de la novela (0 para terminar):');
            readln(n.codigo);
        end;
end;    


procedure leer (var a : archivo; var n : novela);
begin
    if not eof(a) then
        read(a, n)
    else
        n.codigo := valoralto;
end;

procedure Eliminar (var a : archivo;borrar : integer);
var
    reg : novela;
    ind : integer;
begin
    Reset(a);
    read(a, reg);
    
    ind := reg.codigo;

    while (reg.codigo <> borrar) do
    begin
        read(a, reg);
    end;

    seek(a,FilePos(a) -1);
    reg.codigo := ind;
    ind := FilePos(a) - 1;
    write(a, reg);

    // modificamos el codigo de la cabecera
        
    seek(a, 0);
    read(a, reg);
    reg.codigo := ind * -1;
    write(a, reg);
    close(a);
end; 

procedure alta (var a : archivo;nueReg : novela);
var
    ind : Integer;
    reg : novela;
begin
    reset(a);
    read(a, reg);
    if reg.codigo <> 0 then
      begin
        // hay espacio libre, el codigo ya es negativo
        ind := reg.codigo;
        // paso el indice a positivo para hacer el seek
        seek(a, ind * -1);
        read(a, reg);
        seek(a,FilePos(a) - 1);
        write(a, nueReg);
        // ya es negativo, ya que el registro esta borrado logicamente
        ind := reg.codigo;
        Seek(a, 0);
        Read(a,reg);
        reg.codigo := ind;
        Write(a,reg);
      end
    else
        begin
          seek(a,FileSize(a));
          write(a, nueReg);
        end;
    close(a);
end;

procedure ModificarNovel (var a : archivo);
    procedure leerNovela(var reg : novela);
    begin
      // leo todos los campos del registro exepto el campo de codigo
        writeln('Ingrese el genero:');
        readln(reg.genero);
        writeln('Ingrese el nombre:');
        readln(reg.nombre);
        writeln('Ingrese la duracion:');
        readln(reg.duracion);
        writeln('Ingrese el director:');
        readln(reg.director);
        writeln('Ingrese el precio:');
        readln(reg.precio);
    end;
var
    reg : novela;
    regAux : novela;
begin
    leerNovela(reg);
    Reset(a);
    Read(a, regAux);
    while (regAux.codigo <> reg.codigo) do
     begin
         read(a, regAux);
     end;
    seek(a, FilePos(a) - 1);
    reg.codigo := regAux.codigo;
    write(a, reg);  
    Close(a);
end;




var
    a : archivo;
begin
  
end.