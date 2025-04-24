
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
*precio 

de aquellos productos que tengan stock disponible por debajo del stock mínimo

Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado 
(analizar ventajas/desventajas en cada caso).

Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.

}

Program practica2_4;

Const 
  valorAlto =   'ZZZZZZZZZZ';

Type 
  producto =   Record
    cod :   string[10];
    nom :   string[20];
    des :   string;
    dispStock :   integer;
    minStock :   integer;
    precio :   real;
  End;

  venta =   Record
    cod :   string[10];
    // cantidad vendida
    cant :   integer;
  End;

  maestro =   file Of producto;
  detalle =   file Of venta;

  vecReg =   array [1..30] Of venta;
  vecDetalle =   array [1..30] Of detalle;



Procedure actualizacion3 (Var mae : maestro);

Procedure cargarVecDet (Var vecDet : vecDetalle);

Var 
  i :   integer;
  ind :   string;
  nom :   string;
Begin

  // a todos los nombres logicos dentro del vector, les asigno un nombre fisico
  nom := 'Detalle ';
  For i := 1 To 30 Do
    Begin
      str(i,ind);
      nom := nom + ind;
      assign (vecDet[i],nom);
      nom := nom - ind;
    End;
End;


Procedure CargarVecReg (Var vecDet : vecDetalle; Var vecR : vecReg);

Var 
  i :   integer;
Begin
  dl := 0;
  // ahora deberia "leer" cada registro
  // en realidad, leo los 30 primeros registros de los detalle
  For i := 1 To 30 Do
    Begin
      leer(vecDet[i],vecR[i]);
    End;
End;




Procedure minimo2 (vd : vectorDetalle; vr : vectorReg; Var minimo: venta);

Var 
  pos:   integer
       Begin
         //inicializamos el minimo
         minimo.cod := valorAlto;

         For i := 1 To dimF Do
           Begin
             If vr[i].cod < minimo.cod Then
               Begin
                 minimo := vr[i];
                 pos := i;
               End;
           End;
         If minimo.cod <> valorAlto Then
           leer(vd[pos], vr[pos]);
       End;

Var 
  dimL :   integer;
  vecDet :   vecDetalle;
  vecR :   vecReg;
  min :   venta;
  regM :   producto;
Begin
  dimL := 0;
  cargarVecDet(mae,vecDet);

  reset(mae);

  For i := 1 To dimf Do
    reset(vecDet[i]);

  i := 1;


  leer(mae,regM);

  CargarVecReg(vecDet,vecReg);
  minimo(vecDet,vecR,min);

  While (min.num <> regM.num) Do
    leer(mae,regM);

  While (min.num <> valorAlto) Do
    Begin

      While (min.num = regM.num) And (min.num <> valorAlto) Do
        Begin
          regM.dispStock := regM.dispStock - min.cant;
          minimo2(vecDet,vecR,min);
        End;

      seek (mae,FilePos(mae)-1);
      write(mae,regM);
    End;

  close(mae);
  For i := 1 To dimf Do
    close(vecDet[i]);
End;




Begin

End.
