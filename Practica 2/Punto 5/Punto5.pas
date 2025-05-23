
Program ej5;

Const 
  valorAlto = 'ZZZZZZZ';
  dimF = 5;
  corte = '-1';

Type 

  log = Record
    cod_usuario : string;
    fecha : string;
    tiempo_session : integer;
  End;

  usuario = Record
    cod_usuario : string;
    fecha : string;
    tiempo_total : integer;
  End;

  detalle = file Of log;
  maestro = file Of usuario;

  vecDetalle = Array [1..dimF] Of detalle;
  vecReg = Array [1..dimF] Of log;


Procedure leer (Var x : detalle; Var R : log);




{
lee un registro de un archivo, si el archivo no tiene mas elementos, devuelve "valoralto"
}
Begin
  If Eof(X) Then
    R.cod_usuario := valorAlto
  Else
    read(X,R)
End;

Procedure cargarArchDet (Var X : detalle);




{
Carga los datos ingresados desde teclado a un registro, y luego carga ese registro a un archivo
}
Procedure leerReg (Var R : log);
Begin
  write('Cod usuario: ');
  readln(R.cod_usuario);
  If (R.cod_usuario <> corte) Then
    Begin
      // leo los demas datos 
      write('Fecha: ');
      ReadLn(R.fecha);
      Write('Tiempo de sesion en el dia: ');
      ReadLn(R.tiempo_session);
    End;
End;

Var 
  R :   log;
Begin
  Rewrite(X);
  leerReg(R);
  While (R.cod_usuario <> corte) Do
    Begin
      write(X,R);
      leerReg(R);
    End;
  Close(X);
End;


Procedure cargarVecDet (Var vecDet : vecDetalle);

Var 
  i :   integer;
  ind :   string;
  nom :   string;
Begin

  // a todos los nombres logicos dentro del vector, les asigno un nombre fisico
  // e inicializo sus registros
  nom := 'detalle';
  For i := 1 To dimF Do
    Begin
      str(i,ind);
      nom := nom + ind + '.dat';
      assign (vecDet[i],nom);
      writeln('Cargando datos del detalle numero: ',i);
      cargarArchDet(vecDet[i]);
      nom := 'detalle';
    End;
End;


Procedure CargarVecReg (Var vecDet : vecDetalle; Var vecR : vecReg);

Var 
  i :   integer;
Begin
  //writeln('Entrando CargarVecReg');
  // ahora deberia "leer" cada registro
  // en realidad, leo los 30 primeros registros de los detalle
  For i := 1 To dimF Do
    Begin
      //writeln('Antes de leer detalle: ',i);
      leer(vecDet[i],vecR[i]);
    End;
End;


Procedure minimo2 (vd : vecDetalle;Var vr : vecReg; Var minimo: log);

Var 
  pos:   integer;
  i : integer;
Begin
  //inicializamos el minimo
  minimo.cod_usuario := valorAlto;

  For i := 1 To dimF Do
    Begin
      If (vr[i].cod_usuario < minimo.cod_usuario) Then
        Begin
          minimo := vr[i];
          pos := i;
        End
      Else
        Begin
          If (vr[i].cod_usuario = minimo.cod_usuario) Then
            Begin
              If (vr[i].fecha < minimo.fecha) Then
                Begin
                  minimo := vr[i];
                  pos := i;
                End;
            End;
        End;
    End;
  If minimo.cod_usuario <> valorAlto Then
    Begin
      leer(vd[pos], vr[pos]);
    End;
End;




Procedure corteControl(Var mae: maestro;Var vecDet : vecDetalle);

Var 
  min:   log;
  regM:   usuario;
  vecR:   vecReg;
  i : integer;
  clN1, clN2:  string;
  // clN = Clave nivel 1, 2, 3, etc
  // totN = valor que se este acumulando
Begin
  Rewrite(mae);

  For i := 1 To dimF Do
    Begin
      Reset(vecDet[i]);
    End;

  // valor que se acumula: tiempo_sesion.
  // reg = registro maestro

  CargarVecReg(vecDet,vecR);

  minimo2(vecDet,vecR,min);

  While (min.cod_usuario <> valorAlto) Do
    Begin
      //writeln('Clave Nivel 1:', reg.ord1);

      // guardo clave actual
      clN1 := min.cod_usuario;

      //inicio el registro maestro

      While (clN1 = min.cod_usuario) Do
        Begin
          //writeln('Clave Nivel 2:', reg.ord2);
          clN2 := min.fecha;

          regM.cod_usuario := min.cod_usuario;
          regM.fecha := min.fecha;
          regM.tiempo_total := 0;

          While (clN2 = min.fecha) And (clN1 = min.cod_usuario) Do
            Begin
              //sumo al tiempo total el tiempo del archivo detalle
              regM.tiempo_total := regM.tiempo_total + min.tiempo_session;
              // Busco el siguiente registro en el detalle
              minimo2(vecDet,vecR,min);
            End;

{ una vez se cambio de fecha (no necesariamente de usuario), ya se puede asumir que sera otro registro del maestro}
          write(mae,regM);
        End;

    End;
  For i := 1 To dimF Do
    Begin
      close(vecDet[i]);
    End;

  close(mae);
End;

Var 
  mae : maestro;
  vecDet : vecDetalle;
Begin
  Assign(mae,'var/log/Maestro.dat');
  cargarVecDet(vecDet);
  corteControl(mae,vecDet);
End.





{
    Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue
construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. 
Cada archivo detalle contiene los siguientes campos:

cod_usuario,
fecha,
tiempo_sesion. 
  
  Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: 

cod_usuario,
fecha,
tiempo_total_de_sesiones_abiertas.

Notas:

●​ Cada archivo detalle está ordenado por cod_usuario y fecha.
●​ Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
inclusive, en diferentes máquinas.
●​ El archivo maestro debe crearse en la siguiente ubicación física: /var/log.
}
