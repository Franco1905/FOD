program practica2_1;
const
    valoralto = '9999';
type
    comEmp = record
        codEmp : string[10];
        nombre : string;
        monto : real;
    end;

    archivo_emp = file of comEmp;



procedure leerCom (var com : comEmp);
begin
    writeln ('Codigo de empleado: ');
    readln (com.codEmp);
    writeln ('Nombre: ');
    readln (com.codEmp);
    writeln('Monto de comision: ');
    readln(com.monto);
end;

procedure agregarCom (var archivo : archivo_emp);
var
    i : integer;
    com : comEmp;
begin
    rewrite(archivo);
    for i := 1 to 8 do
    begin
        leerCom(com);
        write(archivo,com);
    end;

    close(archivo);
end;


procedure leer (var archivo : archivo_emp; var com : comEmp);
begin
    if Eof(archivo) then
        com.codEmp := valoralto
    else
        read(archivo,com);
end;


procedure imprimirCom (com : comEmp);
begin
    writeln('Codigo: ',com.codEmp,' | Nombre: ',com.nombre,' | Monto:',com.monto:0:2);
end;


procedure imprimirArch (var archivo : archivo_emp);
var
    com : comEmp;
begin
    reset(archivo);
    leer (archivo,com);

    while (com.codEmp <> valoralto) do
    begin
        imprimirCom(com);
        leer(archivo,com);
    end;

    close(archivo);
end;

var
    comision : archivo_emp;
    nombre : string;
    opcion : string[1];
begin
    write('Opcion: ');
    readln(opcion);
    case opcion of
        '1': begin
           writeln('Nombre de nuevo archivo: '); readln(nombre);
           assign(comision,nombre);
           // agrega 8 comisiones
           agregarCom(comision);
        end;
        '2': begin
           writeln('Nombre del archivo de comisiones: '); readln(nombre);
           assign(comision,nombre);
           imprimirArch(comision);
        end;
    end;
end.
