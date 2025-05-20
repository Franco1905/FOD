{
2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.
}
program punto2;
uses
    sysutils;
const
    valoralto = 9999; // Valor alto para el campo nro

type
    asistente = record
        nro : Integer;
        apellido : String[20];
        nombre : String[20];
        email : String[30];
        telefono : String[15];
        dni : String[10];
    end;

    archivo_asistentes = file of asistente;

procedure leer (var arch: archivo_asistentes; var reg: asistente);
begin
    if not eof(arch) then
        read(arch, reg)
    else
        reg.nro := valoralto;
end;

procedure eliminar_logico (var arch: archivo_asistentes);
var
    reg: asistente;
begin
    reset(arch);
    leer(arch, reg);
    while (reg.nro <> valoralto) do begin
        if (reg.nro < 1000) then begin
            reg.nombre := '@' + reg.nombre;
            seek(arch, filepos(arch)-1);
            write(arch, reg);
        end;
        leer(arch, reg);
    end;
    close(arch);
end;

procedure generar_archivo_de_prueba(var arch: archivo_asistentes);
var
    reg: asistente;
    i: Integer;
begin
    rewrite(arch);

    for i := 1 to 10 do begin
        reg.nro := i;

        case i of
            1: begin reg.apellido := 'Perez'; reg.nombre := 'Juan'; end;
            2: begin reg.apellido := 'Garcia'; reg.nombre := 'Maria'; end;
            3: begin reg.apellido := 'Lopez'; reg.nombre := 'Carlos'; end;
            4: begin reg.apellido := 'Martinez'; reg.nombre := 'Ana'; end;
            5: begin reg.apellido := 'Gomez'; reg.nombre := 'Luis'; end;
            6: begin reg.apellido := 'Saldaño'; reg.nombre := 'Raul'; end;
            7: begin reg.apellido := 'Rodriguez'; reg.nombre := 'Jose'; end;
            8: begin reg.apellido := 'Martinez'; reg.nombre := 'Javier'; end;
            9: begin reg.apellido := 'Fernandez'; reg.nombre := 'Sofia'; end;
           10: begin reg.apellido := 'Diaz'; reg.nombre := 'Carlos'; end;
        end;

        reg.email := 'test' + IntToStr(i) + '@mail.com';
        reg.telefono := '111111111' + Chr(48 + i);
        reg.dni := '1234567' + Chr(48 + i);

        write(arch, reg);
    end;

    close(arch);
end;

procedure imprimir_archivo(var archivo: archivo_asistentes);
var
    reg: asistente;
begin
    reset(archivo);
    writeln('--- Listado de Asistentes ---');
    while not eof(archivo) do
    begin
        read(archivo, reg);
        writeln('Nro: ', reg.nro);
        writeln('Apellido: ', reg.apellido);
        writeln('Nombre: ', reg.nombre);
        writeln('Email: ', reg.email);
        writeln('Telefono: ', reg.telefono);
        writeln('DNI: ', reg.dni);
        writeln('--------------------------');
    end;
    close(archivo);
end;



var
    arch: archivo_asistentes;
begin
    assign(arch, 'arch_asistentes.dat');
    generar_archivo_de_prueba(arch);
    writeln('--- Listado de Asistentes antes de eliminar logico ---');
    imprimir_archivo(arch);
    eliminar_logico(arch);
    writeln('--- Listado de Asistentes luego de eliminar logico ---');
    imprimir_archivo(arch);
end.
