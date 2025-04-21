{
A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un archivo que contiene los siguientes datos: 

*nombre de provincia
*cantidad de personas alfabetizadas 
*total de encuestados

Se reciben dos archivos detalle provenientes de dos agencias de censo diferentes, dichos archivos contienen: 

*nombre de la provincia 
*código de localidad
*cantidad de alfabetizados 
*cantidad de encuestados

Se pide realizar los módulos necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.

NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.
}


program practica2_3;
const
    valorAlto = 'ZZZZZZ';
type

    provincia = record
        nombre : string;
        cantAlf : integer;
        cantEnc : integer;
    end;

    localidad = record
        nomProv : string;
        codLoc : String;
        cantAlf : integer;
        cantEnc : integer;
    end;

    maestro = file of provincia;
    detalle = file of localidad;


procedure leer (var x : detalle; var R : localidad);
begin
  if Eof(X) then
    R.nomProv := valorAlto
  else
    read(X,R)
end;




procedure minimo (var R1 : localidad; 
                  var R2 : localidad;  
                  var Min : localidad;
                  var Det1 : detalle;
                  var Det2 : detalle);
begin
// num = nomProv
    if (R1.nomProv <= R2.nomProv) then 
    begin
        Min := R1;
        leer(Det1,R1)
    end
    else 
    begin
        Min := R2;
        leer(Det2,R2)
    end;
end;



procedure actualizacion2 (var mae : maestro; 
                          var det1 : detalle; 
                          var det2 : detalle);
var
    // variables para guardar los registros del detalle
    RegD1,RegD2 : localidad;
    RegM : provincia;
    min : localidad;
begin
  Reset(det1); Reset (det2); Reset(mae);

  leer(det1, RegD1); leer(det2, RegD2);
  minimo(regd1, regd2, min, det1, det2);
  while (min.nomProv <> valoralto) do 
    begin
        read(mae,regm);
        while (regm.nombre <> min.nomProv) do
            read(mae,regm);
        while (regm.nombre= min.nomProv) do 
        begin
            
            regm.cantAlf := regm.cantAlf + min.cantAlf;
            
            minimo(regd1, regd2, min, det1, det2);
        end;
    seek (mae, filepos(mae)-1);
    write(mae,regm);
    end;

    close(det1); close(det2); close(mae);
end;


var
    det1 : detalle; det2 : detalle;
    mae : maestro;
begin
    Assign(det1,'Detalle 1'); Assign(det2,'Detalle 2');
    Assign(mae,'Maestro');
    actualizacion2(mae,det1,det2);
    writeln('Fin del programa');  
end.