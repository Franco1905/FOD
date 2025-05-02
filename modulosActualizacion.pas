
Program modulosActualizacion;

Const 
  valorAlto =   9999;
  corte =   -1;
  dimF =   30;

Type 
  registro =   Record
    //orden
    num :   real;
    cant :   integer;
    ord1 :   integer;
    ord2 :   integer;
    ord3 :   integer;
    monto :   real;
    vendedor :   string;
  End;

  archivo =   file Of registro;

  vecDetalle =   array [1..30] Of archivo;
  vecReg =   array [1..30] Of registro;


Procedure leer (Var x : archivo; Var R : registro);


{
lee un registro de un archivo, si el archivo no tiene mas elementos, devuelve "valoralto"
}
Begin
  If Eof(X) Then
    R.num := valorAlto
  Else
    read(X,R)
End;


// actualizacion del maestro para 1 archivo detalle
Procedure actualizacion1 (Var det:archivo;Var mae : archivo);
{
 Actualiza un archivo maestro en base a UN archivo detalle
}

Var 
  RegM :   registro;
  RegD :   registro;
  cod_actual :   Real;
  tot_vendido :   integer;
Begin
  reset(mae);
  reset (det);
  While Not(EOF(det)) Do
    Begin
      read(mae, RegM);
      // Lectura archivo maestro
      read(det, RegD);
      // Lectura archivo detalle
     {Se busca en el maestro el producto del detalle}
      While (RegM.num <> RegD.num) Do
        read(mae, regm);
        {Se totaliza la cantidad vendida del detalle}
      cod_actual := regd.num;
      tot_vendido := 0;
      While (regd.num = cod_actual) Do
        Begin
          tot_vendido := tot_vendido+regd.cant;
          read(det, regd);
        End;
        {Se actualiza la cantidad}
      regm.cant := regm.cant - tot_vendido;
        {se reubica el puntero en el maestro}
      seek(mae, filepos(mae)-1);
        {se actualiza el maestro}
      write(mae, regm);
    End;
  close (mae);
  close (det);
End;


Procedure actualizacion2 (Var mae : archivo;
                          Var det1 : archivo;
                          Var det2 : archivo;
                          Var det3 : archivo);
{
Actualiza un archivo maestro en base a 3 archivos detalle
}

Var 
  // variables para guardar los registros del detalle
  RegD1,RegD2,RegD3 :   registro;
  RegM :   registro;
  min :   registro;
Begin
  Reset(det1);
  Reset (det2);
  Reset(det3);
  Reset(mae);

  leer(det1, RegD1);
  leer(det2, RegD2);
  leer(det3, RegD3);
  minimo(regd1, regd2, regd3, min, det1, det2, det3);
  While (min.num <> valoralto) Do
    Begin
      read(mae,regm);
      While (regm.num <> min.num) Do
        read(mae,regm);
      While (regm.num = min.num) Do
        Begin









       // aca es donde se suma o resta la cantidad de lo que se quiera procesar 
          // (se resta el stock, se suma la cantidad de X cosa, etc)
          regm.cant := regm.cant - min.cant;

          minimo(regd1, regd2, regd3, min,det1,det2,det3);
        End;
      seek (mae, filepos(mae)-1);
      write(mae,regm);
    End;

  close(det1);
  close(det2);
  close(det3);
  close(mae);
End;

Procedure actualizacion3 (Var mae : maestro;Var txt : Text);

{s}

Procedure assignVecDet (Var vecDet : vecDetalle);

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
