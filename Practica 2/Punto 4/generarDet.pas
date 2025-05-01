
Program generar_detalles;

Const 
  valorAlto = 'ZZZZZZZZZZ';

Type 
  venta = Record
    cod: string[10];
    cant: integer;
  End;

  detalle = file Of venta;

  // ================================
  // Procedimiento para generar los 30 detalles
  // ================================

// ================================
// Función auxiliar para convertir número a string
// (porque Pascal estándar no tiene IntToStr directo)
// ================================
Function IntToStr(num: integer): string;

Var 
  s: string;
Begin
  str(num, s);
  IntToStr := s;
End;


Procedure generarDetalles;

Var 
  vecDet: array[1..30] Of detalle;
  i: integer;
  v: venta;
Begin
  // Asignar y abrir todos los archivos
  For i := 1 To 30 Do
    Begin
      assign(vecDet[i], 'detalle' + IntToStr(i) + '.dat');
      rewrite(vecDet[i]);
    End;

  // Detalle 1: ventas normales
  v.cod := 'P001';
  v.cant := 5;
  write(vecDet[1], v);
  v.cod := 'P002';
  v.cant := 3;
  write(vecDet[1], v);

  // Detalle 2: baja importante de stock
  v.cod := 'P005';
  v.cant := 40;
  write(vecDet[2], v);

  // Detalle 3: varias ventas del mismo producto
  v.cod := 'P004';
  v.cant := 10;
  write(vecDet[3], v);
  v.cod := 'P004';
  v.cant := 8;
  write(vecDet[3], v);

  // Detalle 4: venta mínima (1 unidad)
  v.cod := 'P003';
  v.cant := 1;
  write(vecDet[4], v);

  // Detalle 5: archivo vacío (sin registros)

  // Detalle 6: venta de un producto que no se va a vender en otros detalles
  v.cod := 'P006';
  v.cant := 2;
  write(vecDet[6], v);

  // Detalle 7: producto que no sufre bajas
  v.cod := 'P007';
  v.cant := 0;
  write(vecDet[7], v);

  // Detalle 8: venta inexistente (producto inexistente)
  v.cod := 'P999';
  v.cant := 10;
  write(vecDet[8], v);

  // Detalles 9 a 30: algunos con ventas, otros vacíos
  For i := 9 To 30 Do
    Begin
      If (i Mod 3 = 0) Then
        Begin
          // archivos vacíos para algunos
        End
      Else
        Begin
          v.cod := 'P001';
          v.cant := i;
          write(vecDet[i], v);
        End;
    End;

  // Cerrar todos los archivos
  For i := 1 To 30 Do
    close(vecDet[i]);
End;


// ================================
// Programa principal
// ================================
Begin
  generarDetalles;
End.
