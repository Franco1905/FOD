

{
Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: 

*código del producto 
*nombre
*descripción 
*stock disponible
*stock mínimo 
*precio del producto

Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: 

*código de producto 
*cantidad vendida. 

Además, se deberá informar en un archivo de texto: 

*nombre de producto
*descripción
*stock disponible 
*precio de aquellos productos que tengan stock disponible por debajo del stock mínimo

Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado 
(analizar ventajas/desventajas en cada caso).

Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.

}

program practica2_4;
const
    valorAlto = 'ZZZZZZZZZZ';
type
    producto = record
        cod : string[10];
        nom : string[20];
        des : string;
        dispStock : integer;
        minStock : integer;
        precio : real;
    end;

    venta = record
        cod : string[10];
        // cantidad vendida
        cant : integer;
    end;

    maestro = file of producto;
    detalle = file of venta;

    vecReg = array [1..30] of venta;
    vecDet = array [1..30] of detalle;

procedure inserOrd (var v : vecReg; var dl : integer; elem : registro);
var
    i,pos : integer;
begin
   //busco la posicion a insertar
    i := 1;
    while (v[i] < elem.num) do
     begin
       i := i + 1;
     end;
    pos := i;
    //inserto ordenado

    for i:= dl downto pos do
      begin
        v[i+ i] := v[i];
      end;
    
    v[pos] := elem;
    dl := dl + 1;
end;



procedure cargarVecDet (var mae : archivo; var vecDet : vecDetalle);
 var
    i : integer;
    ind : string;
    nom : string;
begin
    // a todos los nombres logicos dentro del vector, les asigno un nombre fisico
    nom := 'Detalle ';
    for i := 1 to 30 do
    begin
        str(i,ind);
        nom := nom + ind;
        assign (vecDet[i],nom);
        nom := nom - ind;
    end;
end;


procedure CargarVecReg (var vecDet : vecDetalle; var vecR : vecReg; var dl : Integer);
var
    i : integer;
    R : registro;
    cant : integer;
    ultimo : Boolean;
begin
    ultimo := False;
    dl := 0;
    // ahora deberia "leer" cada registro
    // en realidad, leo los 30 primeros registros de los detalle
    for i := 1 to 30 do
      begin
        leer(vecDet[i],R);
        if (R.num <> valorAlto) then
          insertOrd(vecR,dl,R);
      end;
end;


procedure actualizacion3 (var mae : maestro);
var
    dimL : integer;
    vecDet : vecDetalle;
    vecR : vecReg;
    R : registro;
    regM : registro;
begin
    dimL := 0;
    cargarVecDet(mae,vecDet);

    reset(mae);
    
    for i := 1 to dimf do
      reset(vecDet[i]);

    i := 1;

    CargarVecReg(vecDet,vecReg,dimL);
    
    while vecR[i].num <> valorAlto do
      begin
        read(mae,regM);
        while (regM.num <> vecR[i].num) do
          read(mae,regM);
      
        while (regM.num = vecR[i].num) do
          begin
            if (i <= dimL) then
               begin
                 regM.cant := regM.cant - vecR[i].cant; 
                 i := i + 1;
               end
            else  
                CargarVecReg(vecDet,vecR,dimL);
          end;  
        seek(mae,FilePos(mae)-1);
        Write(mae,regM);
      end;

    close(mae);
    for i := 1 to dimf do
      close(vecDet[i]);
end;








begin

end.