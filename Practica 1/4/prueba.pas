program prueba;

type
    lista = ^nodo;

    
    empleado = record
        empNum : integer;
        apellido : string;
        nombre : string[15];
        edad : integer;
        dni : integer;
    end;

    nodo = record
        elem : empleado;
        sig : lista;
    end;

    archivo = file of empleado;

procedure sobrescribirArch (var arch_log : archivo; L : lista);
var
    AuxEmp : empleado;
begin
  Rewrite(arch_log);
  while (L <> nil) do
    begin
      AuxEmp := L^.elem;
      write(arch_log,AuxEmp);
      L := L^.sig;
    end;
    Close(arch_log);
end;


procedure agregarOrd (var L : lista;emp : empleado);
var
    ant,act,nue : lista;
begin
    new(nue);
    nue^.elem := emp;
    nue^.sig := nil;
    act := L;
    ant := act;
    while (act <> Nil) and (emp.empNum < act^.elem.empNum) do
        begin
            ant := act;
            act := act^.sig;
        end;
    if (ant = act) then
        L := nue   
    else
        begin
          ant^.sig := nue;
          nue^.sig := act;
        end;
end;


procedure ordenar (var arch_log : archivo);
var
    L : lista;
    emp : empleado;

begin
    L := nil;
    Reset(arch_log);
    while (not(eof(arch_log))) do
      begin
        Read(arch_log,emp);
        agregarOrd(L,emp);    
      end;
    sobrescribirArch(arch_log,L);
    Close(arch_log);
end;
    


var
    arch_log : archivo;
    name : String;
begin
  //asumimos que el archivo existe con los empleados ya cargados
    Write('nombre del archivo ya existente: ');
    readln(name);

    Assign(arch_log,name);

    Reset(arch_log);
    ordenar(arch_log);

    close(arch_log);

end.