
Program generar_maestro_productos;

Const 
  valorAlto = 'ZZZZZZZZZZ';
  // Valor que no se usa en este programa pero se suele definir igual

Type 
  producto = Record
    cod: string[10];
    nom: string[20];
    des: string;
    dispStock: integer;
    minStock: integer;
    precio: real;
  End;

  maestro = file Of producto;

  // ================================
  // Procedimiento para generar el archivo maestro
  // ================================
Procedure generarMaestro(Var mae: maestro);

Var 
  p: producto;
Begin
  rewrite(mae);

  // Producto P001: ventas normales
  p.cod := 'P001';
  p.nom := 'Pizza';
  p.des := 'Pizza congelada de muzzarella';
  p.dispStock := 100;
  p.minStock := 20;
  p.precio := 1200.50;
  write(mae, p);

  // Producto P002: ventas normales
  p.cod := 'P002';
  p.nom := 'Empanadas';
  p.des := 'Docena de empanadas congeladas';
  p.dispStock := 80;
  p.minStock := 15;
  p.precio := 950.00;
  write(mae, p);

  // Producto P003: baja justo al mínimo
  p.cod := 'P003';
  p.nom := 'Helado';
  p.des := 'Helado de crema americana';
  p.dispStock := 40;
  p.minStock := 20;
  p.precio := 800.00;
  write(mae, p);

  // Producto P004: baja debajo del mínimo
  p.cod := 'P004';
  p.nom := 'Hamburguesas';
  p.des := 'Caja de 8 hamburguesas congeladas';
  p.dispStock := 45;
  p.minStock := 30;
  p.precio := 1400.75;
  write(mae, p);

  // Producto P005: muchas ventas
  p.cod := 'P005';
  p.nom := 'Papas fritas';
  p.des := 'Bolsa de papas congeladas';
  p.dispStock := 50;
  p.minStock := 10;
  p.precio := 600.00;
  write(mae, p);

  // Producto P006: venta con cantidad cero
  p.cod := 'P006';
  p.nom := 'Tarta';
  p.des := 'Tarta congelada de verduras';
  p.dispStock := 30;
  p.minStock := 10;
  p.precio := 900.00;
  write(mae, p);

  // Producto P007: no se vende
  p.cod := 'P007';
  p.nom := 'Sopa';
  p.des := 'Sopa instantánea congelada';
  p.dispStock := 60;
  p.minStock := 15;
  p.precio := 300.00;
  write(mae, p);

  // Producto P008: no se vende
  p.cod := 'P008';
  p.nom := 'Lasaña';
  p.des := 'Lasaña congelada de carne';
  p.dispStock := 25;
  p.minStock := 5;
  p.precio := 1100.00;
  write(mae, p);

  close(mae);
End;

// ================================
// Programa principal
// ================================

Var 
  mae: maestro;
Begin
  assign(mae, 'maestro.dat');
  generarMaestro(mae);
End.
