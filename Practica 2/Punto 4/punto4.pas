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
*precio de aquellos productos que tengan stock disponible por debajo del stock mínimo

Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado 
(analizar ventajas/desventajas en cada caso).

Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.

}

program practica2_4;
const
    valorAlto = 'ZZZZZZZZZZ';
type

    producto = record
        cod : string[10];
        nom : string[20];
        des : string;
        dispStock : integer;
        minStock : integer;
        precio : real;
    end;

    venta = record
        cod : string[10];
        // cantidad vendida
        cant : integer;
    end;

    maestro = file of producto;
    detalle = file of venta;








begin

end.