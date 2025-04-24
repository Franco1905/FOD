
Program generico;

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


Procedure minimo1 (Var R1 : registro;
                   Var R2: registro;
                   Var R3: registro; Var Min:registro;
                   Var Det1 : archivo;
                   Var Det2 : archivo;
                   Var Det3 : archivo);

{
devuelve el minimo entre 3 archivos detalle
}
Begin
  If (R1.num <= R2.num) And (R1.num <= R3.num) Then
    Begin
      Min := r1;
      leer(Det1,R1)
    End
  Else
    Begin
      If (R2.num <= R3.num) Then
        Begin
          Min := R2;
          leer(Det2,R2)
        End
      Else
        Begin
          Min := R3;
          leer(Det3,R3)
        End;
    End;
End;



//asumimos que se quiere insertar un registro a un vector X
Procedure inserOrd (Var v : vecReg; Var dl : integer; elem : registro);
{
Insera ordenado en un vector
}

Var 
  i,pos :   integer;
Begin
  //busco la posicion a insertar
  i := 1;
  While (v[i].num < elem.num) Do
    Begin
      i := i + 1;
    End;
  pos := i;
  //inserto ordenado

  For i:= dl Downto pos Do
    Begin
      v[i+ i] := v[i];
    End;

  v[pos] := elem;
  dl := dl + 1;
End;

//{{{}}}


Procedure actualizacion3 (Var mae : archivo);

{
Actualiza el archivo maestro en base a 30 archivos detalle
}

Procedure cargarVecDet (Var vecDet : vecDetalle);





{
Carga un vector de DimF = 30 con 30 nombres logicos para los archivos detalle
}

Var 
  i :   integer;
  ind :   string;
  nom :   string;
Begin

  // a todos los nombres logicos dentro del vector, les asigno un nombre fisico
  For i := 1 To 30 Do
    Begin
      nom := 'Detalle ';
      str(i,ind);
      nom := nom + ind;
      assign (vecDet[i],nom);
    End;
End;


Procedure CargarVecReg (Var vecDet : vecDetalle; Var vecR : vecReg);




{
Carga el vector con los 30 primeros registros de cada uno de los 30 archivos detalle
}

Var 
  i :   integer;
Begin
  // ahora deberia "leer" cada registro
  // en realidad, leo los 30 primeros registros de los detalle
  For i := 1 To 30 Do
    Begin
      leer(vecDet[i],vecR[i]);
    End;
End;




Procedure minimo2 (vd : vecDetalle; vr : vecReg; Var minimo: registro);
{
busca el minimo entre los 30  primeros registros de los 30 archivos detalle
}

Var 
  pos:   integer;
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
  min :   registro;
  regM :   registro;
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
          regM.cant := regM.cant - min.cant;
          minimo2(vecDet,vecR,min);
        End;

      seek (mae,FilePos(mae)-1);
      write(mae,regM);
    End;

  close(mae);
  For i := 1 To dimf Do
    close(vecDet[i]);
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

Procedure cargarArch (Var X : archivo);




{
Carga los datos ingresados desde teclado a un registro, y luego carga ese registro a un archivo
}
Procedure leerReg (Var R : registro);
Begin
  write('Inserte dato: ');
  readln(R.num);
  If (R.num <> corte) Then
    Begin
      // leo los demas datos 
      write();
    End;
End;

Var 
  R :   registro;
Begin
  Rewrite(X);
  leerReg(R);
  While (R.num <> corte) Do
    Begin
      write(X,R);
      leerReg(R);
    End;
  close(X);
End;


Procedure impArch (Var X : archivo);
{
Imprime en pantalla el contenido de un archivo binario
}
Procedure impReg (R : registro);
Begin
  {
  Imprime el contenido de un registro en especifico
  }
  WriteLn('ELemento numero 1 del registro: ',r.num,
          '| elemento numero 2 (si hubiera): ');
End;

Var 
  R :   registro;
Begin
  Reset(X);
  leer(X,R);
  While (R.num <> valorAlto) Do
    Begin
      impReg(R);
      leer(X,R);
    End;
  Close(X);
End;





{
Parámetros:
    archivoEntrada  → arch.
Variables:
    totalGeneral    → totG.
    registroActual  → reg.
    totalNivel1     → totN1.
    totalNivel2     → totN2.
    totalNivel3     → totN3.
    claveNivel1     → clN1.
    claveNivel2     → clN2.
    claveNivel3     → clN3.
}

Procedure corteControl(Var arch: archivo);

Var 
  totG:   real;
  reg:   registro;
  totN1, totN2, totN3:   real;
  clN1, clN2, clN3:   integer;
Begin
  reset(arch);
  leer(arch, reg);
  totG := 0;
  While (reg.ord1 <> valorAlto) Do
    Begin
      writeln('Clave Nivel 1:', reg.ord1);
      clN1 := reg.ord1;
      totN1 := 0;
      While (clN1 = reg.ord1) Do
        Begin
          writeln('Clave Nivel 2:', reg.ord2);
          clN2 := reg.ord2;
          totN2 := 0;
          While (clN1 = reg.ord1) And (clN2 = reg.ord2) Do
            Begin
              writeln('Clave Nivel 3:', reg.ord3);
              clN3 := reg.ord3;
              totN3 := 0;
              While (clN1 = reg.ord1) And (clN2 = reg.ord2) And (
                    clN3 = reg.ord3) Do
                Begin
                  write('Vendedor:', reg.vendedor);
                  writeln(reg.monto);
                  totN3 := totN3 + reg.monto;
                  leer(arch, reg);
                End;
              writeln('Total Nivel 3:', totN3:0:2);
              totN2 := totN2 + totN3;
            End;
          writeln('Total Nivel 2:', totN2:0:2);
          totN1 := totN1 + totN2;
        End;
      writeln('Total Nivel 1:', totN1:0:2);
      totG := totG + totN1;
    End;
  writeln('Total General:', totG:0:2);
  close(arch);
End;

Procedure cargarTxt (Var arch : archivo;Var txt : Text);

{
  Exporta el contenido de un archivo binario a un archivo de texto
}

Var 
  nomArch : string;
  R : registro;
Begin
  Reset(arch);
  Rewrite (txt);{crea archivo de texto}
  While (Not eof(arch)) Do
    Begin
      Read(arch, R); {lee votos del arch binario}
      WriteLn(txt,carga,R.num,' ',R.cant,' ',R.ord1,
              ' ',R.monto,' ',R.vendedor);
    {escribe en el archivo texto los campos separados por el carácter blanco}
    End;
  Close(arch);
End;
Procedure cargarBin (Var arch : archivo; Var txt : Text);

Var 

  R : registro;
Begin
  Reset(arch);
  Reset(txt);
  While (Not eof(arch)) Do
    Begin
      {lectura del archivo de texto}
      ReadLn(txt,R.num,R.cant, R.monto,R.vendedor);
      {escribe binario}
      Write(arch, votos);
    End;
  {cierra los dos archivos}
  Close(arch);
  Close(txt);
End;

Begin
  writeln('Fin del programa');
End.
