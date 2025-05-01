
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


Procedure leer (Var x : maestro; Var R : regDet);
Begin
  If Eof(X) Then
    R.codLoc := valorAlto
  Else
    read(X,R)
End;





//// Programa principal ///
Begin

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
