{1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
archivo debe ser proporcionado por el usuario desde teclado.}


program Ej_1_1;
type
	archivo = File of integer;
var
	name : string;
	num : Integer;
	numeros : archivo;
BEGIN
	Write('Inserte nombre del archivo a crear, si quiere puede poner la ruta en la que quiere guardarlo: ');
	ReadLn(name);
	Assign (numeros,name);
	Rewrite (numeros);
	write('Inserte un numero entero: ');
	ReadLn(num);
	while (num <> 30000) do
	  begin
		Write(numeros,num);	
		Write('Inserte un numero entero: ');
		Read(num);
	  end;
	close (numeros);
END.
