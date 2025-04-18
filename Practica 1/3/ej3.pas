{3. Realizar un programa que presente un menú con opciones para:

a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.

b. Abrir el archivo anteriormente generado y

i. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado, el cual se proporciona desde el teclado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.

NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.

/////////////////////////////////////////////////////////////////////////////////////////

4. Agregar al menú del programa del ejercicio 3, opciones para:

a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
un número de empleado ya registrado (control de unicidad).

b. Modificar la edad de un empleado dado.

c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.

d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).

NOTA: Las búsquedas deben realizarse por número de empleado.
}

program ej3;
const
    // en caso de que alguien mas quiera detener el programa con otra palabra que no sea "fin"??
    corte = 'fin';
    line = '****************************';
    mayor = 70;
type
    empleado = record
        empNum : integer;
        apellido : string;
        nombre : string[15];
        edad : integer;
        dni : integer;
    end;

    archivo = file of empleado;



procedure agregarEmp (var empleados : archivo);

    procedure leerEmp (var emp : empleado);
    begin
      Write('Apellido: ');
      ReadLn(emp.apellido);
     // halt;//
      if (emp.apellido <> corte)then
       begin  
         write('Nombre: ');
         readln(emp.nombre);
         Write('Edad: ');
         readln(emp.edad);
         write('DNI: ');
         readln(emp.dni);
         write('Numero de empleado: ');
         readln(emp.empNum);
      end;
    end;

var
  emp : empleado;
begin
  reset(empleados);
  leerEmp(emp);
  while (emp.apellido <> corte) Do
    begin
      write(empleados,emp);
      leerEmp(emp);  
    end;
  //close(empleados);
end;



procedure impEmp (emp : empleado);
begin
    write('Nombre: ',emp.nombre,'/ Apellido: ',emp.apellido,'/ Numero de empleado: ',emp.empNum,'/ Edad: ',emp.edad,'/DNI: ',emp.dni);
end;

procedure buscarNom (var empleados : archivo);
var
    buscNom : string;
    emp : empleado;
begin
  Reset(empleados);
  
    write('Inserte el nombre o apellido a buscar: ');
    ReadLn(buscNom);

  while (not(Eof(empleados))) do
    begin
      read(empleados,emp);
      if (emp.apellido = buscNom) or (emp.nombre = buscNom) then
        begin
            impEmp(emp);
            writeln();
        end;
    end;
  close(empleados);
end;

procedure menu ();
begin
    Write(line);
    writeln();

    WriteLn('Menu de opciones para archivos de empleados: ');
    writeln('1- Crear o sobrescribir un archivo de empleados');
    writeln('2- Buscar todos los empleados que tengan un nombre o apellido en especifico');
    writeln('3- Mostrar en pantalla a todos los empleados');
    writeln('4- Mostrar en pantalla a todos los empleados mayores de 70 años');
    writeln('5- Finalizar y salir del programa');

    writeln();
    Write(line);
    writeln();
  
end;




procedure mayoresQ (var empleados : archivo);
var
   emp : empleado;
begin
    writeln(line);
    writeln('Empleados proximos a jubilarse: ');
    writeln();
    while not(Eof(empleados)) do
      begin
        read(empleados,emp);
        if (emp.edad > 70) then
        begin
          impEmp(emp);
          writeln();
        end;
      end;
end;

procedure impTodos (var empleados : archivo);
var
    emp : empleado;
begin
    Reset(empleados);
    while not(Eof(empleados)) do
      begin
        Read(empleados,emp);
        impEmp(emp);
        writeln();
      end;
    //close(empleados);  
end;


var
    name : string;
    emp : archivo;
    opcion : Integer;
begin

    writeln(line);
   
    menu();

    write('Inserte la opcion que quiera ejecutar: ');
    readln(opcion);

    while (opcion <> 5) do
     begin
         case opcion of
        
            1: begin
             writeln(line);
             Write('Inserte nombre o ruta del archivo:');
             ReadLn(name);
             Writeln(line);
             Assign(emp,name);
             Rewrite(emp);
             agregarEmp(emp);
             close(emp);
            end;

            2: begin
             Write('Inserte nombre o ruta del archivo:');
             ReadLn(name);
             Assign(emp,name);
             Writeln(line);
             Reset(emp);
             buscarNom(emp);
             //Close(emp);
           end;
  
           3: begin
             Write('Inserte nombre o ruta del archivo:');
             ReadLn(name);
             Writeln(line);
             Assign(emp,name);
             Reset(emp);
             impTodos(emp);
           end;
        
           4: begin
             Write('Inserte nombre o ruta del archivo:');
             ReadLn(name);
             Writeln(line);
             Assign(emp,name);
             Reset(emp);
             mayoresQ(emp);
             //Close(emp)
           end;
         end;
         writeln(line);
   
        menu();
        write('Inserte la opcion que quiera ejecutar: ');
        readln(opcion);
        writeln(line);
     end;

end.