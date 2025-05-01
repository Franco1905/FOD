
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
      leer(vecDet[i],vecR[i]);
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
  R : registro;
Begin
  Reset(arch);
  Rewrite (txt);{crea archivo de texto}
  While (Not eof(arch)) Do
    Begin
      Read(arch, R); {lee votos del arch binario}
      WriteLn(txt,R.num,' ',R.cant,' ',R.ord1,
              ' ',R.monto,' ',R.vendedor);
    {escribe en el archivo texto los campos separados por el carácter blanco}
    End;
  Close(arch);
End;

Procedure cargarTxt2 (R : registro; Var txt : Text);



{
  Exporta el contenido de un archivo binario a un archivo de texto DURANTE
  un proceso de actualizacion
}
Begin


// Fuera del modulo, se debe hacer el "rewrite" del archivo txt, desligando esta funcion a lo que este por arriba
  WriteLn(txt,R.num,' ',R.cant,' ',R.ord1,
          ' ',R.monto,' ',R.vendedor);


End;

Procedure cargarBin (Var arch : archivo; Var txt : Text);
{
Importa el contenido de un archivo de texto a un archivo binario
}

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

Procedure merge (Var arch : archivo)

Var 
  total : integer;
  vecR : vecReg;
Begin

  minimo1(detalle,min);

  While (min.codigo <> valoralto) Do
    Begin
      aux := min;
      total := 0;
      While (min.codigo = aux.codigo) Do
        Begin
          total := total + min.cant;
          minimo (det1, det2, det3,
                  regd1, regd2, regd3, min);
        End;
      aux.cant := total;
      write (mae, aux);
    End;

End;
Begin
  writeln('Fin del programa');
End.
