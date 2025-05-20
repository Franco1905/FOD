{
8. Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse. Este archivo debe ser mantenido realizando bajas
lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:
    a. BuscarDistribucion: módulo que recibe por parámetro el archivo, un
        nombre de distribución y devuelve la posición dentro del archivo donde se
        encuentra el registro correspondiente a la distribución dada (si existe) o
        devuelve -1 en caso de que no exista..
    b. AltaDistribucion: módulo que recibe como parámetro el archivo y el registro
        que contiene los datos de una nueva distribución, y se encarga de agregar
        la distribución al archivo reutilizando espacio disponible en caso de que
        exista. (El control de unicidad lo debe realizar utilizando el módulo anterior).
        En caso de que la distribución que se quiere agregar ya exista se debe
        informar “ya existe la distribución”.
    c. BajaDistribucion: módulo que recibe como parámetro el archivo y el
        nombre de una distribución, y se encarga de dar de baja lógicamente la
        distribución dada. Para marcar una distribución como borrada se debe
        utilizar el campo cantidad de desarrolladores para mantener actualizada
        la lista invertida. Para verificar que la distribución a borrar exista debe utilizar
        el módulo BuscarDistribucion. En caso de no existir se debe informar
        “Distribución no existente”.


}

program punto8;
const
    valoralto = 9999;
type
    distribucion = record
        nombre: string[20];
        anio: integer;
        version: integer;
        cantDev : integer;
        des: string[50];
    end;

    archDistro = file of distribucion;

procedure BuscarDistribucion (var a : archDistro; nombre: string; var pos: integer);
var
    d: distribucion;
begin
    pos := -1;
    reset(a);
    while (not eof(a)) and (pos = -1) do begin
        read(a, d);
        if (d.nombre = nombre) then
            pos := filepos(a) - 1;
    end;
    close(a);
end;

procedure AltaDistribucion (var a : archDistro;nueReg : distribucion);
var
    ind : Integer;
    reg : distribucion;
    ok : integer;
begin
    reset(a);
    read(a, reg);
    ok := BuscarDistribucion(a, nueReg.nombre, ind);
    if ok = -1 then
        begin
            if reg.cantDev <> 0 then
                begin
                    // hay espacio libre, el codigo ya es negativo
                    ind := reg.cantDev;
                    // paso el indice a positivo para hacer el seek
                    seek(a, ind * -1);
                    read(a, reg);
                    seek(a,FilePos(a) - 1);
       
                    write(a, nueReg);
                    // ya es negativo, ya que el registro esta borrado logicamente
                    ind := reg.cantDev;
                    Seek(a, 0);
                    Read(a,reg);
                    reg.cantDev := ind;
                    Write(a,reg);
                end
            else
                begin
                    seek(a,FileSize(a));
                    write(a, nueReg);
                end;
        end
        else
            WriteLn('La distro ya existe!!');
    close(a);
end;


procedure BajaDistribucion (var a : archDistro;borrar :string);
var
    reg : distribucion;
    ind : integer;
    cabecera: integer;
begin
    Reset(a);
    read(a,reg);
    
    // guardo valor de la cabecera
    cabecera := reg.codigo;  
    seek(a, 1);
    Read(a, reg);
    BuscarDistribucion(a,borrar,ind);

    if ind <> -1 then
        begin
            seek(a,ind);
            // le pongo el codigo de la cabecera al registro borrado
            reg.codigo := cabecera;
            write(a, reg);

            // actualizo la cabecera con la posición del registro borrado
            seek(a, 0);
            reg.codigo := ind * -1;  // convierto a negativo el índice
            write(a, reg);
            close(a);
        end;
end;



begin
  
end.