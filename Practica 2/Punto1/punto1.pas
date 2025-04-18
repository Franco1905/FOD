{
Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.

Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.

NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.

dato guardado: COMISION de un empleado, no es el EMPLEADO en si, un empleado, puede haber tenido varias comisiones
}


program practica2_1;

const 
    valoralto = '99999';
type
    // este registro, sirve tanto para las comisiones que se disponen, como para el nuevo archivo
    comEmp = record
        codEmp : string[10];
        nombre : string;
        monto : real;
    end;

    archivo_emp = file of comEmp;


procedure leer (var archivo : archivo_emp; var com : comEmp);
begin
    if Eof(archivo) then
        com.codEmp := valoralto
    else
        read(archivo,com);
end;


procedure compactFile (var comisiones : archivo_emp; var empleados : archivo_emp);
var
    com : comEmp;
    
    // aca guardo el empleado actual
    empAct : string[10];
    
    // aca guardo el total de comision por empleado
    comTot : real;
    
    // valor auxiliar que guarda el codigo de empleado
    empAux : comEmp;
begin
    comTot := 0;
    reset(comisiones); rewrite (empleados);
    
    // primera lectura
    leer(comisiones,com);

    // recorro el archivo de comisiones
    while (com.codEmp <> valoralto) do
    begin
        
        empAct := com.codEmp;
        
        empAux.nombre := com.nombre;
        empAux.codEmp := empAct;

        while (empAct = com.codEmp) do
        begin
            comTot := comTot + com.monto;
            leer(comisiones,com);
        end;
        // agrego el monto de todas las comisiones al empleado auxiliar
        empAux.monto := comTot;
        comTot := 0;
        // agrego el empleado auxiliar al archivo
        if (empAct <> valoralto) then
            write(empleados,empAux);
    end;

    close(comisiones); close(empleados)
end;





procedure imprimirCom (com : comEmp);
begin
    writeln('Codigo: ',com.codEmp,' | Nombre: ',com.nombre,' | Monto:',com.monto:0:2);
end;


procedure imprimirArch (var archivo : archivo_emp);
var
    com : comEmp;
begin
    reset(archivo);
    leer (archivo,com);

    while (com.codEmp <> valoralto) do
    begin
        imprimirCom(com);
        leer(archivo,com);
    end;

    close(archivo);
end;



var
    // tiene cada comision por separado
    comision : archivo_emp;
    // tiene a cada empleado junto con el monto de todas sus comisiones 
    empleado : archivo_emp;    
    // nombres fisicos de los archivos
    comision_fis,empleado_fis : string;
begin
    // ERROR: el programa se cierra luego de ejecutar esta linea
    write('Inserte nombre o ruta del archivo con las comisiones: '); readln(comision_fis);
    write('Inserte nombre o ruta del nuevo archivo de empleados: '); readln(empleado_fis);
    assign (comision,comision_fis); assign (empleado,empleado_fis);

    compactFile(comision,empleado);
    imprimirArch(empleado);
end.