
Program ej6;

Const 
  valorAlto = 'ZZZZZZZZ';
  corte = '-1';
  dimf = 10;

Type 

  regDet = Record
    // Orden 1
    codLoc : string;
    // Orden 2
    codCep : string;
    // Cantidades
    casAct : integer;
    casNue : integer;
    casRec : integer;
    casFall : integer;
  End;

  regMae = Record
    // Orden 1
    codLoc : string;
    // Orden 2
    codCep : string;

    nomLoc : string;
    nomCep : string;

    // Cantidades
    casAct : integer;
    casNue : integer;
    casRec : integer;
    casFall : integer;
  End;

  detalle = file Of regDet;
  maestro = file Of regMae;

  vecReg = array [1..dimF] Of regDet;
  vecDetalle = array [1..dimf] Of detalle;


Procedure leer (Var x : detalle; Var R : regDet);
Begin
  If Eof(X) Then
    R.codLoc := valorAlto
  Else
    read(X,R)
End;



Procedure minimoCorte (vd : vecDetalle;Var vr : vecReg; Var minimo: regDet);
{Procedure minimo, para un corte de control de 2 claves}

Var 
  pos:   integer;
  i : integer;
Begin
  //inicializamos el minimo
  minimo.codLoc := valorAlto;
  For i := 1 To dimF Do
    Begin
      If (vr[i].codLoc < minimo.codLoc) Or (vr[i].codLoc = minimo
         .codLoc) And (vr[i].codCep < minimo.codCep)  Then
        Begin
          minimo := vr[i];
          pos := i;
        End;
    End;
  If minimo.codLoc <> valorAlto Then
    Begin
      leer(vd[pos], vr[pos]);
    End;
End;


Procedure assignVecDet (Var vecDet : vecDetalle);

Var 
  i :   integer;
  ind :   string;
  nom :   string;
Begin
  // a todos los nombres logicos dentro del vector, les asigno un nombre fisico
  For i := 1 To dimF Do
    Begin
      nom := 'detalle';
      str(i,ind);
      nom := nom + ind + '.dat';
      assign (vecDet[i],nom);
      //writeln('intentando asignar detalle: ',i,' (',nom,')');
    End;
End;


Procedure CargarVecReg (Var vecDet : vecDetalle; Var vecR : vecReg);

Var 
  i :   integer;
Begin
  For i := 1 To dimf Do
    Begin
      //writeln('Antes de leer detalle: ',i);
      leer(vecDet[i],vecR[i]);
    End;
End;


Procedure corteControl (Var mae: maestro;Var vecDet : vecDetalle);

Var 
  min:   regDet;
  regM:   regMae;
  vecR:   vecReg;
  i,cant : integer;
  clN1, clN2:  string;
Begin
  Reset(mae);
  cant := 0;
  For i := 1 To dimF Do
    Begin
      Reset(vecDet[i]);
    End;

  CargarVecReg(vecDet,vecR);

  minimoCorte(vecDet,vecR,min);

  read(mae,regM);

  While (min.codLoc <> valorAlto) Do
    Begin

      //Busco lugar en el mae

      While Not(Eof(mae)) And ((min.codLoc <> regM.codLoc) Or
            (min.codCep <> regM.codCep)) Do
        Begin
          Read(mae,regM);
          If (regM.casAct > 50) Then
            Begin
              cant := cant + 1;
            End;
        End;

      If (Eof(mae)) Then
        writeln('Se llego al final del maestro, debe haber un error!!');
      // guardo clave actual
      clN1 := min.codLoc;
      While (clN1 = min.codLoc) Do
        Begin
          //writeln('Clave Nivel 2:', reg.ord2);
          clN2 := min.codCep;
          While (clN2 = min.codCep) And (clN1 = min.codLoc) Do
            Begin
              //sumo al tiempo total el tiempo del archivo detalle
              regM.casFall := regM.casFall + min.casFall;
              regM.casRec := regM.casRec + min.casRec;
              regM.casAct :=  min.casAct;
              regM.casNue :=  min.casNue;
              // Busco el siguiente registro en el detalle
              minimoCorte(vecDet,vecR,min);
            End;





{ una vez se cambio de fecha (no necesariamente de usuario), 
          ya se puede asumir que sera otro registro del maestro}
          If (regM.casAct > 50) Then
            cant := cant + 1;

          writeln('Cant = ',cant);

          seek(mae, filepos(mae) - 1);
          write(mae,regM);
          Read(mae,regM);
        End;
    End;
  For i := 1 To dimF Do
    Begin
      close(vecDet[i]);
    End;

  While Not(Eof(mae)) Do
    Begin
      If (regM.casAct > 50) Then
        cant := cant + 1;
      Read(mae,regM);
    End;

  Writeln('Cantidad de  localidades con mas de 50 casos activos: ',cant);

  close(mae);
End;

Procedure cargarMae (Var X : maestro);
Procedure leerReg (Var R : regMae);
Begin
  write('Codigo localidad: ');
  readln(R.codLoc);
  If (R.codLoc <> corte) Then
    Begin
      write('Nombre: ');
      ReadLn(R.nomLoc);
      write('Codigo de cepa: ');
      ReadLn(R.codCep);
      writeln('Inserte 1 si quiere agregar los demas datos a mano');
      ReadLn(R.casAct);
      If (R.casAct = 1) Then
        Begin
          write('Casos actuales: ');
          ReadLn(R.casAct);
          write('Casos nuevos: ');
          ReadLn(R.casNue);
          Write('Fallecidos: ');
          ReadLn(R.casFall);
          Write('Recuperados: ');
          ReadLn(R.casRec);
        End;
    End;
End;

Var 
  R :   regMae;
Begin
  Rewrite(X);
  writeln('Cargando maestro: ');
  leerReg(R);
  While (R.codLoc <> corte) Do
    Begin
      write(X,R);
      leerReg(R);
    End;
  close(X);
End;


Procedure cargarDet (Var X : vecDetalle);
Procedure leerReg (Var R : regDet);
Begin
  write('Codigo localidad: ');
  readln(R.codLoc);
  If (R.codLoc <> corte) Then
    Begin
      write('Codigo de cepa: ');
      ReadLn(R.codCep);
      write('Casos actuales: ');
      ReadLn(R.casAct);
      write('Casos nuevos: ');
      ReadLn(R.casNue);
      Write('Fallecidos: ');
      ReadLn(R.casFall);
      Write('Recuperados: ');
      ReadLn(R.casRec);
    End;
End;

Var 
  i : integer;
  R :   regDet;
Begin
  For i := 1 To dimF Do
    Begin
      Rewrite(X[i]);
      writeln('Cargando detalle numero: ',i);
      leerReg(R);
      While (R.codLoc <> corte) Do
        Begin
          write(x[i],R);
          leerReg(R);
        End;
      close(X[i]);
    End;
End;

//// Programa principal ///

Var 

  vecDet : vecDetalle;
  mae : maestro;
Begin
  Assign(mae,'Maestro');
  cargarMae(mae);
  assignVecDet(vecDet);
  cargarDet(vecDet);
  corteControl(mae,vecDet);
End.



















































{Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, 
la información contenida en los mismos es la siguiente: 

código de localidad 
código cepa 
cantidad de casos activos
cantidad de casos nuevos
cantidad de casos recuperados 
cantidad de casos fallecidos

El ministerio cuenta con un archivo maestro con la siguiente información: 

código localidad
nombre localidad 
código cepa 
nombre cepa
cantidad de casos activos
cantidad de casos nuevos 
cantidad de recuperados 
cantidad de fallecidos

Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.

Para la actualización se debe proceder de la siguiente manera:

1.​ Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2.​ Idem anterior para los recuperados.
3.​ Los casos activos se actualizan con el valor recibido en el detalle.
4.​ Idem anterior para los casos nuevos hallados.

Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).}
