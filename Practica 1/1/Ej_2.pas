{2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.}

program ej_2;
const
  line = '*************************************************';
  mayor = 1500;
type

	archivo = File of integer;

function promedio (suma : real;cant : real) : real;
begin
    promedio := suma / cant;    
end;

procedure procesar (var numeros : archivo);
var
  num : integer;
  cont : integer;
  suma : Real;
begin
  cont := 0;
  suma := 0;
  reset(numeros);
  while (not (Eof(numeros))) do
    begin
      Read(numeros,num); // guardo el numero en num
      suma := suma + num;
      if (num > mayor) then
        cont := cont + 1;
    end;
  if (cont <> 0) then
    begin
      Writeln(line);
      write('La cantidad de numeros mayores que ',mayor,' en el archivo, es: ',cont);
      Writeln(line);
    end
  else
    WriteLn('No hay numeros mayores a ',mayor,' en el archivo');
    Writeln(line);

  // asumimos que el archivo tiene numeros
  
  WriteLn('El promedio de los numeros es de: ',promedio(suma,FileSize(numeros)):0:2);
  Writeln(line);
 // Me tira error si cierro el archivo dentro del modulo
 // close(numeros);
end;


var
    numeros : archivo; 
    name : string;
begin
    WriteLn(line);
    write('Inserte el nombre del archivo a leer: ');
    readln(name);
    writeln(line);
    Assign (numeros,name);
    reset(numeros);
    //hago las consignas
    procesar(numeros);
    writeln('Fin del programa');
    Writeln(line);
    close(numeros);
end.