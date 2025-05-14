program aa;
type
    empleado = record
        nombre: string[20];
        dni: integer;
        sueldo: real;
    end;

    archivo_empleados = file of empleado;

procedure eliminar_fisico (var archivo: archivo_empleados; var archivo_nuevo: archivo_empleados);
var
  	reg: empleado;
begin {se sabe que existe Carlos Garcia}
  	assign (archivo, 'arch_empleados');
  	assign (archivo_nuevo, 'arch_nuevo');
  	reset (archivo);
  	rewrite (archivo_nuevo);
  	leer (archivo, reg);
	{se copian los registros previos a Carlos Garcia}
  	while (reg.nombre <> ‘Carlos Garcia’) do begin 
		write (archivo_nuevo, reg);
		leer (archivo, reg);
	end;
    {se descarta a Carlos Garcia}
	leer(archivo, reg);
    {se copian los registros restantes}
	while (reg.nombre <> valoralto) do begin	    
		write(archivo_nuevo, reg);
		leer(archivo, reg);
	end;
    close(archivo_nuevo);
	close(archivo);
    {renombrar el archivo original para dejarlo como respaldo}
    rename(archivo,’arch_empleados_old’);
    {renombrar el archivo temporal con el nombre del original}
    rename(archivo_nuevo, ‘arch_empleados’);
end.


procedure eliminar_logico (var archivo: archivo_empleados);
var
  	reg: empleado;
Begin {se sabe que existe Carlos Garcia}
	assign(archivo, 'arch_empleados');
	reset(archivo);
	leer(archivo, reg);
	{Se avanza hasta Carlos Garcia}
	while (reg.nombre <> ‘Carlos Garcia’) do	    
		leer(archivo, reg);
	{Se genera una marca de borrado}
	reg.nombre := ‘***’;	
	{Se borra lógicamente a Carlos Garcia}
	seek(archivo, filepos(archivo)-1 );
	write(archivo, reg);
	close(archivo);
end.

var
    archivo: archivo_empleados;
    archivo_nuevo: archivo_empleados;
    archivo_borrado: archivo_empleados;
    archivo_logico: archivo_empleados;
begin
    {eliminar_fisico(archivo, archivo_nuevo);}
    {eliminar_logico(archivo_logico);}
    {eliminar_fisico(archivo_borrado, archivo_nuevo);}
    {eliminar_logico(archivo_logico);}
end.