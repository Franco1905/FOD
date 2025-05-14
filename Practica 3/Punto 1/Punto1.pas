{
1. Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
agregándole una opción para realizar bajas copiando el último registro del archivo en
la posición del registro a borrar y luego truncando el archivo en la posición del último
registro de forma tal de evitar duplicados.
}

program ej1;


uses SysUtils;


const
    // en caso de que alguien mas quiera detener el programa con otra palabra que no sea "fin"??
    corte = 'fin';
    line = '****************************';
    mayor = 70;
    valorAlto = 9999;
type
    
    empleado = record
        empNum : integer;
        apellido : string;
        nombre : string[15];
        edad : integer;
        dni : string[8];
    end;

    archivo = file of empleado;


procedure leer (var empleados : archivo;var emp : empleado);
begin
  if (not Eof(empleados)) then
    Read(empleados,emp)
  else
    emp.empNum := valorAlto;
end;

procedure leerEmp (var emp : empleado);
begin
   Write('Apellido: ');
   ReadLn(emp.apellido);
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

procedure crearArch (var empleados : archivo);
var
  emp : empleado;
begin
  Rewrite(empleados);
  leerEmp(emp);
  while (emp.apellido <> corte) Do
    begin
      write(empleados,emp);
      leerEmp(emp);  
    end;
  close(empleados);
end;


procedure impEmp (emp : empleado);
begin
    write('Nombre: ',emp.nombre,
    '/ Apellido: ',emp.apellido,
    '/ Numero de empleado: ',emp.empNum,
    '/ Edad: ',emp.edad,
    '/DNI: ',emp.dni);
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
    writeln('5- Agregar un empleado a un archivo existente');
    WriteLn('6- Modificar la edad de un empleado en especifico');
    WriteLn('7- Exportar el contenido del archivo a un archivo de texto llamado “todos_empleados.txt”');
    WriteLn('d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados que no tengan cargado el DNI');
    WriteLn('10. Finalizar y salir del programa');

    writeln();
    Write(line);
    writeln();
  
end;




procedure mayoresQ (var empleados : archivo);
var
   emp : empleado;
begin
    Reset(empleados);
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
    close(empleados);  
end;


procedure agregarAlArch (var archEmp : archivo);
var
    emp : empleado; //  nuevo epleado
    masEmp : empleado; //empleado existente
begin
    writeln('Inserte los datos del nuevo empleado que quiera agregar: ');
    leerEmp(emp); // leo el nuevo empleado
    reset(archEmp);
    leer(archEmp,masEmp); // leo el primer empleado del archivo
    while (masEmp.empNum <> valorAlto) and (masEmp.empNum <> emp.empNum) do
      leer(archEmp,masEmp);
    if (masEmp.empNum = valorAlto) then
      begin
       seek(archEmp,FilePos(archEmp)-1);
       Write(archEmp,emp)
      end
    else
      WriteLn('Ya existe un empleado con ese numero!!');
    close(archEmp);
end;



{procedure agregarAlArch (var archEmp : archivo);
var
    emp : empleado; //  nuevo epleado
    masEmp : empleado; //empleado existente
    flag : Boolean;
begin
    flag := False;
    writeln('Inserte los datos del nuevo empleado que quiera agregar: ');
    leerEmp(emp);
    reset(archEmp);
    read(archEmp,masEmp);
    
   
    while (not Eof(archEmp)) and (masEmp.empNum <> emp.empNum) do
    begin
      Read(archEmp,masEmp);
      if masEmp.empNum = emp.empNum then
        begin
          Flag := True;
        end;
    end;
    if (Flag = False) then
    begin
      Write(archEmp,emp);
    end
    else
      WriteLn('Ya existe un empleado con ese numero!!');
    close(archEmp);

end;}




procedure modfEdad (var empleados : archivo);
var
  emp : empleado;
  num : integer;
begin
  Reset(empleados);
  writeln('Inserte el numero del empleado al que quiera modificarle la edad: ');
  ReadLn(num);
  Read(empleados,emp);
  while(emp.empNum <> num) and (emp.empNum <> valorAlto) do
    begin
      leer(empleados,emp);
    end;
  if emp.empNum <> valorAlto then
    begin
      Write('Inserte la edad que le quiere asignar: ');
      Read(emp.edad);
      seek(empleados,FilePos(empleados)-1);
      write(empleados,emp);
    end
  else
    writeln('No se encontro el empleado, por favor verifique que se haya escrito correctamente');
  Close(empleados);
end;


procedure crearTxt (var texto : Text; var empleados : archivo);
var
  emp : empleado;
begin
  Reset(empleados);
  Rewrite(texto);
  while not Eof(empleados) do
    begin
      Read(empleados,emp);
      WriteLn(texto,'Nombre: ',emp.nombre,
    '/ Apellido: ',emp.apellido,
    '/ Numero de empleado: ',emp.empNum,
    '/ Edad: ',emp.edad,
    '/DNI: ',emp.dni);
    end;
  Close(empleados);
  Close(texto);

end;


procedure noDNI (var texto: Text;var empleados : archivo);
var
  emp : empleado;
begin
  Reset(empleados);
  Rewrite(texto);
  Read(empleados,emp);
  while not Eof(empleados) do
    begin
      if (emp.dni = '00') then
        begin
          WriteLn(texto,'Nombre: ',emp.nombre,
    '/ Apellido: ',emp.apellido,
    '/ Numero de empleado: ',emp.empNum,
    '/ Edad: ',emp.edad,
    '/DNI: ',emp.dni);
        end;
      Read(empleados,emp)
    end;
    Close(empleados);
    Close(texto);
end;

//Programa principal

var
    
    name : string;
    emp : archivo;
    opcion : Integer;
    texto : Text;
begin

    writeln(line);
   
    menu();

    write('Inserte la opcion que quiera ejecutar: ');
    readln(opcion);

    while (opcion <> 10) do
     begin
         case opcion of
            //1- Crear o sobrescribir un archivo de empleados
            1: begin
             writeln(line);
             Write('Inserte nombre o ruta del archivo:');
             ReadLn(name);
             Writeln(line);
             Assign(emp,name);
             crearArch(emp);
            end;

            //2- Buscar todos los empleados que tengan un nombre o apellido en especifico
            2: begin
             Write('Inserte nombre o ruta del archivo:');
             ReadLn(name);
             if FileExists(name)then
               begin 
                 Assign(emp,name);
                 Writeln(line);
                 buscarNom(emp);
               end
             else
               writeln('El archivo no existe');
           end;
           //3- Mostrar en pantalla a todos los empleados
           3: begin
             Write('Inserte nombre o ruta del archivo:');
             ReadLn(name);
             Writeln(line);
             if FileExists(name) then
               begin  
                 Assign(emp,name);
                 impTodos(emp);
               end   
              else
                writeln('El archivo no existe');
           end;
          //4- Mostrar en pantalla a todos los empleados mayores de 70 años
           4: begin
             Write('Inserte nombre o ruta del archivo:');
             ReadLn(name);
             Writeln(line);
             if FileExists(name) then
               begin
                 Assign(emp,name);
                 mayoresQ(emp);
               end;
           end;
          //5- Agregar un empleado a un archivo existente
          5: begin
            Write('Inserte nombre o ruta del archivo:');
            ReadLn(name);
            Writeln(line);
            if FileExists(name) then
              begin
                Assign(emp,name);
                agregarAlArch(emp);
              end;
          end;
         //6- Modificar la edad de un empleado en especifico
         6: begin
            Write('Inserte nombre o ruta del archivo:');
            ReadLn(name);
            Writeln(line);
            if (FileExists(name)) then
              begin
                Assign(emp,name);
                modfEdad(emp);
              end
            else
              writeln('El archivo no existe');
         end;
        //Exportar el contenido del archivo a un archivo de texto llamado “todos_empleados.txt”.
        7: begin
          Write('Inserte nombre o ruta del archivo:');
          ReadLn(name);
          Writeln(line);
          if (FileExists(name)) then
            begin
              Assign(texto,'todos_empleados.txt');
              Assign(emp,name);
              crearTxt(texto,emp);
            end
          else
            writeln('El archivo no existe');
        end;
        //Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados que no tengan cargado el DNI (DNI en 00).

        8 : begin
          Write('Inserte nombre o ruta del archivo:');
          ReadLn(name);
          Writeln(line);
          if (FileExists(name)) then
           begin
              Assign(texto,'faltaDNIEmpleado.txt');
              Assign(emp,name);
              noDNI(texto,emp);
            end
          else
            writeln('El archivo no existe');
        end;
         end;
         writeln(line);
   
        menu();
        write('Inserte la opcion que quiera ejecutar: ');
        readln(opcion);
        writeln(line);
     end;
    WriteLn('Fin del programa')
end.