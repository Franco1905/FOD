








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

Uses sysUtils;

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



Procedure leer (Var x : detalle; Var R : venta);









{
lee un registro de un archivo, si el archivo no tiene mas elementos, devuelve "valoralto"
}
Begin
  writeln('Entrando a leer');
  If Eof(X) Then
    R.cod := valorAlto
  Else
    read(X,R)
End;

Procedure actualizacion3 (Var mae : maestro;Var txt : Text);

{s}

Procedure cargarVecDet (Var vecDet : vecDetalle);

Var 
  i :   integer;
  ind :   string;
  nom :   string;
Begin

  // a todos los nombres logicos dentro del vector, les asigno un nombre fisico
  nom := 'detalle';
  For i := 1 To 30 Do
    Begin
      str(i,ind);
      nom := nom + ind + '.dat';
      If fileExists(nom) Then
        Begin
          assign (vecDet[i],nom);
          writeln('intentando asignar detalle: ',i,' (',nom,')');
        End
      Else
        writeln(nom,'no existe o esta vacio');
      nom := 'detalle';
    End;
End;


Procedure CargarVecReg (Var vecDet : vecDetalle; Var vecR : vecReg);

Var 
  i :   integer;
Begin
  writeln('Entrando CargarVecReg');
  // ahora deberia "leer" cada registro
  // en realidad, leo los 30 primeros registros de los detalle
  For i := 1 To 30 Do
    Begin
      writeln('Antes de leer detalle: ',i);
      leer(vecDet[i],vecR[i]);
    End;
End;


Procedure minimo2 (vd : vecDetalle;Var vr : vecReg; Var minimo: venta);

Var 
  pos:   integer;
  i : integer;
Begin
  //inicializamos el minimo
  minimo.cod := valorAlto;

  For i := 1 To 30 Do
    Begin
      If vr[i].cod < minimo.cod Then
        Begin
          minimo := vr[i];
          pos := i;
        End;
    End;
  If minimo.cod <> valorAlto Then
    Begin
      writeln('Minimo 2 - antes de leer detalle: ',pos);
      leer(vd[pos], vr[pos]);
    End;
End;

// programa principal del modulo actualizacion 3

Var 
  i:   integer;
  vecDet :   vecDetalle;
  vecR :   vecReg;
  min :   venta;
  regM :   producto;
Begin

  cargarVecDet(vecDet);

  reset(mae);
  Rewrite(txt);

  For i := 1 To 30 Do
    Begin
      reset(vecDet[i]);
    End;

  If Not Eof(mae) Then
    Read(mae,regM)
  Else
    regM.cod := valorAlto;

  CargarVecReg(vecDet,vecR);

  minimo2(vecDet,vecR,min);

  While (min.cod <> valorAlto) Or (regM.cod <> valorAlto ) Do
    Begin
      If (regM.cod < min.cod) Or (min.cod = valorAlto) Then
        Begin
          If regM.cod <> valorAlto Then
            Begin
              If Not(Eof(mae)) Then
                read(mae,regM)
              Else
                regM.cod := valorAlto;
            End
        End
      Else If (min.cod < regM.cod) Or (regM.cod = valorAlto) Then
             Begin
               If min.cod <> valorAlto Then
                 Begin
                   writeln('Alerta: Venta para producto ', min.cod,
                           ' sin maestro correspondiente (maestro está en ',
                           regM.cod, ')');
                   minimo2(vecDet, vecR, min);
                 End
             End
      Else
        Begin
          While (min.cod = regM.cod) And (min.cod <> valorAlto) Do
            Begin
              regM.dispStock := regM.dispStock - min.cant;
              minimo2(vecDet, vecR, min);
            End;

          If (regM.dispStock < regM.minStock) Then
            Begin
              WriteLn(txt, regM.nom);
              WriteLn(txt, regM.des, ' ', regM.dispStock, ' ', regM.precio:0:2);
            End;

          seek(mae, FilePos(mae) - 1);
          write(mae, regM);

          If Not(Eof(mae)) Then
            read(mae, regM)
          Else
            regM.cod := valorAlto;
        End;
    End;

  close(mae);
  For i := 1 To 30 Do
    close(vecDet[i]);
  close(txt);
End;

// fin del modulo actualizacion 3


Procedure cargarTxt (Var arch : maestro;Var txt : Text);









{
  Exporta el contenido de un archivo binario a un archivo de texto
  Despues de que este haya sido creado
}

Var 
  R : producto;
Begin
  Reset(arch);
  Rewrite (txt);{crea archivo de texto}
  While (Not eof(arch)) Do
    Begin
      Read(arch, R); {lee datos del arch binario}
      If (R.dispStock < R.minStock) Then
        Begin









     //escribe en el archivo texto los campos separados por el carácter blanco}
          WriteLn(txt,R.nom);
          WriteLn(txt,
                  R.des,
                  R.dispStock,
                  R.precio);
        End;
    End;
  Close(arch);
End;

Var 

  mae : maestro;
  texto : Text;
Begin
  Assign(mae,'maestro.dat');
  Assign(texto,'minStock.txt');
  actualizacion3(mae,texto);
End.
