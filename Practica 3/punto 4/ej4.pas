{
4. Dada la siguiente estructura:

Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
a. Implemente el siguiente módulo:

b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.
}

program ej4;
const
    valorAlto = 9999; // valor alto para el campo codigo
type


    reg_flor = record
        nombre: String[45];
        codigo: integer;
    end;

    tArchFlores = file of reg_flor;


{Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descrita anteriormente}

// el enlace esta en el campo CODIGO

procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);
var
    ind : Integer;
    reg : reg_flor;
begin
    reset(a);
    read(a, reg);
    // evaluo cabecera
    if reg.codigo <> 0 then
      begin
        // hay espacio libre, el codigo ya es negativo
        ind := reg.codigo;
        // paso el indice a positivo para hacer el seek
        seek(a, ind * -1);
        read(a, reg);
        seek(a,FilePos(a) - 1);
        // ya es negativo, ya que el registro esta borrado logicamente
        ind := reg.codigo;
        reg.codigo := codigo;
        reg.nombre := nombre;
        write(a, Reg);
        Seek(a, 0);
        Read(a,reg);
        reg.codigo := ind;
        Write(a,reg);
      end
    else
        begin
          seek(a,FileSize(a));
          reg.codigo := codigo;
          reg.nombre := nombre;
          write(a,Reg);
        end;
    close(a);
end;
procedure leer(var a: tArchFlores; var reg: reg_flor);
begin
    if not eof(a) then
      read(a, reg)
    else
      reg.codigo := valorAlto;
end;

procedure listarFlores(var a: tArchFlores);
var
    reg: reg_flor;
begin
    reset(a);
    leer(a, reg);
    while reg.codigo <> valorAlto do
      begin
        if reg.codigo > 0 then
          begin
            writeln('Nombre: ', reg.nombre);
            writeln('Codigo: ', reg.codigo);
          end;
        leer(a, reg);
      end;
    close(a);
end;

// Procedimiento para cargar el archivo con registros de prueba
procedure cargarArchivoPrueba(var a: tArchFlores);
var
    reg: reg_flor;
begin
    // Crear archivo y escribir cabecera (sin registros borrados)
    Rewrite(a);
    reg.codigo := 0; // cabecera: 0 = sin registros borrados
    reg.nombre := '';
    Write(a, reg);

    // Registro 1: activo
    reg.codigo := 1;
    reg.nombre := 'Rosa';
    Write(a, reg);

    // Registro 2: activo
    reg.codigo := 2;
    reg.nombre := 'Tulipan';
    Write(a, reg);

    // Registro 3: activo
    reg.codigo := 3;
    reg.nombre := 'Margarita';
    Write(a, reg);

    // Registro 4: activo
    reg.codigo := 4;
    reg.nombre := 'Lirio';
    Write(a, reg);

    // Registro 5: activo
    reg.codigo := 5;
    reg.nombre := 'Girasol';
    Write(a, reg);

    Close(a);
end;

procedure Eliminar (var a : tArchFlores;borrar : integer);
var
    reg : reg_flor;
    ind : integer;
    cabecera: integer;
begin
    Reset(a);
    read(a,reg);
    
    // guardo valor de la cabecera
    cabecera := reg.codigo;  
    seek(a, 1);
    Read(a, reg);
    while (reg.codigo <> borrar) do
    begin
        read(a, reg);
    end;

    seek(a,FilePos(a) -1);
    ind := FilePos(a);  // guardo la posición del registro que voy a borrar
    // le pongo el codigo de la cabecera al registro borrado
    reg.codigo := cabecera;
    write(a, reg);

    // actualizo la cabecera con la posición del registro borrado
    seek(a, 0);
    reg.codigo := ind * -1;  // convierto a negativo el índice
    write(a, reg);
    close(a);
end;
// al parecer debo asumir que existen registros borrados
var
    a: tArchFlores;
begin
  Assign(a, 'flores.dat');
  // Cargar archivo con registros de prueba
  cargarArchivoPrueba(a);
  WriteLn('-----------------');
  WriteLn('Listado de flores:');
  listarFlores(a);
  writeln('-----------------');
  writeln('Eliminando flor con codigo 2...');
  Eliminar(a, 2);
  writeln('-----------------');
  listarFlores(a);
  agregarFlor(a, 'Orquidea', 6);
  writeln('-----------------');
  writeln('Agregando flor con codigo 6...');
  listarFlores(a);

end.