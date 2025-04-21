program generico;
const
    valorAlto = 9999;
    corte = -1;
    dimF = 30;
type
    registro = record
        //orden
        num : real;
        cant : integer;
        ord1 : integer;
        ord2 : integer;
        ord3 : integer;
        monto : real;
        vendedor : string;
    end;

    archivo = file of registro;

    vecDetalle = array [1..30] of archivo;
    vecReg = array [1..30] of registro;


// procedimiento que lee un registro de un archivo X  
procedure leer (var x : archivo; var R : registro);
begin
  if Eof(X) then
    R.num := valorAlto
  else
    read(X,R)
end;


procedure minimo (var R1 : registro; 
                  var R2: registro; 
                  var R3: registro; var Min:registro;
                  var Det1 : archivo;
                  var Det2 : archivo;
                  var Det3 : archivo);
begin
    if (R1.num <= R2.num) and (R1.num <= R3.num) then 
    begin
        Min := r1;
        leer(Det1,R1)
    end
    else 
    begin
        if (R2.num <= R3.num) then 
        begin
            Min := R2;
            leer(Det2,R2)
        end
        else 
        begin  
            Min := R3;
            leer(Det3,R3)
        end;
    end;
end;


//{{{}}}



//asumimos que se quiere insertar un registro a un vector X
procedure inserOrd (var v : vecReg; var dl : integer; elem : registro);
var
    i,pos : integer;
begin
   //busco la posicion a insertar
    i := 1;
    while (v[i] < elem.num) do
     begin
       i := i + 1;
     end;
    pos := i;
    //inserto ordenado

    for i:= dl downto pos do
      begin
        v[i+ i] := v[i];
      end;
    
    v[pos] := elem;
    dl := dl + 1;
end;



procedure cargarVecDet (var mae : archivo; var vecDet : vecDetalle);
 var
    i : integer;
    ind : string;
    nom : string;
begin
    // a todos los nombres logicos dentro del vector, les asigno un nombre fisico
    nom := 'Detalle ';
    for i := 1 to 30 do
    begin
        str(i,ind);
        nom := nom + ind;
        assign (vecDet[i],nom);
        nom := nom - ind;
    end;
end;


procedure CargarVecReg (var vecDet : vecDetalle; var vecR : vecReg; var dl : Integer);
var
    i : integer;
    R : registro;
    cant : integer;
    ultimo : Boolean;
begin
    ultimo := False;
    dl := 0;
    // ahora deberia "leer" cada registro
    // en realidad, leo los 30 primeros registros de los detalle
    for i := 1 to 30 do
      begin
        leer(vecDet[i],R);
        insertOrd(vecR,dl,R);
        
      end;
end;


procedure actualizacion3 (var mae : maestro);
var
    dimL : integer;
    vecDet : vecDetalle;
    vecR : vecReg;
    R : registro;
    regM : registro;
begin
    dimL := 0;
    cargarVecDet(mae,vecDet);

    reset(mae);
    for i := 1 to dimf do
      reset(vecDet[i]);

    i := 1;

    CargarVecReg(vecDet,vecReg,dimL);
    
    while vecR[i].num <> valorAlto do
      begin
        read(mae,regM);
        while (regM.num <> vecR[i].num) do
          read(mae,regM);
        
        
        
        while (regM.num = vecR[i].num) do
          begin
            if (dimL <= dimF) then
               begin
                 regM.cant := regM.cant - vecR[i].cant; 
                 i := i + 1;
               end
            else  
                CargarVecReg(vecDet,vecR,dimL);
          end;  
          
      end;



    close(mae);
    for i := 1 to dimf do
      close(vecDet[i]);

end;


//{{}{}}

//actualizacion del maestro con N detalles (teniendo en cuenta que N es un numero "chico") 
//en el ejemplo se usan 3, pero el algoritmo en general vale para mas
procedure actualizacion2 (var mae : archivo; 
                          var det1 : archivo; 
                          var det2 : archivo; 
                          var det3 : archivo);
var
    // variables para guardar los registros del detalle
    RegD1,RegD2,RegD3 : registro;
    RegM : registro;
    min : registro;
begin
  Reset(det1); Reset (det2); Reset(det3); Reset(mae);

  leer(det1, RegD1); leer(det2, RegD2); leer(det3, RegD3);
  minimo(regd1, regd2, regd3, min, det1, det2, det3);
  while (min.num <> valoralto) do 
    begin
        read(mae,regm);
        while (regm.num <> min.num) do
            read(mae,regm);
        while (regm.num = min.num) do 
        begin

            // aca es donde se suma o resta la cantidad de lo que se quiera procesar 
            // (se resta el stock, se suma la cantidad de X cosa, etc)
            regm.cant:=regm.cant - min.cant;
            
            minimo(regd1, regd2, regd3, min,det1,det2,det3);
        end;
    seek (mae, filepos(mae)-1);
    write(mae,regm);
    end;

    close(det1); close(det2); close(det3); close(mae);
end;


// actualizacion del maestro para 1 archivo detalle
procedure actualizacion1 (var det:archivo;var mae : archivo);
var
    RegM : registro; RegD : registro;
    cod_actual : Real;
    tot_vendido : integer;
begin
    reset(mae); reset (det);
    while not(EOF(det)) do begin 
	    read(mae, RegM); // Lectura archivo maestro
  	    read(det, RegD); // Lectura archivo detalle
	    {Se busca en el maestro el producto del detalle}	
        while (RegM.num <> RegD.num) do
   	    	read(mae, regm);
        {Se totaliza la cantidad vendida del detalle}
        cod_actual := regd.num;
        tot_vendido := 0; 		
        while (regd.num = cod_actual) do begin
        	tot_vendido := tot_vendido+regd.cant; 
 	        read(det, regd);
        end;
        {Se actualiza la cantidad}
        regm.cant := regm.cant - tot_vendido;
        {se reubica el puntero en el maestro}			
        seek(mae, filepos(mae)-1);
        {se actualiza el maestro}
        write(mae, regm);
	 end;
    close (mae); close (det);
end;    

procedure cargarArch (var X : archivo);

    procedure leerReg (var R : registro);
    begin
      write('Inserte dato: '); readln(R.num);
      if (R.num <> corte) then
      begin
        // leo los demas datos 
        write();
      end;
    end;

var
    R : registro;
begin
    Rewrite(X);
    leerReg(R);
    while (R.num <> corte) do
    begin
      write(X,R);
      leerReg(R);
    end;
    close(X);
end;


procedure impArch (var X : archivo);

    procedure impReg (R : registro);
    begin
      WriteLn('ELemento numero 1 del registro: ',r.num,'| elemento numero 2 (si hubiera): ');
    end;

var
    R : registro;
begin
    Reset(X);
    leer(X,R);
    while (R.num <> valorAlto) do
    begin
      impReg(R);
      leer(X,R);
    end;
    Close(X);
end;
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

procedure corteControl(var arch: archivo);
var
    totG: real;
    reg: registro;
    totN1, totN2, totN3: real;
    clN1, clN2, clN3: integer;
begin 
    reset(arch);
    leer(arch, reg);
    totG := 0;
    while (reg.ord1 <> valorAlto) do 
    begin
        writeln('Clave Nivel 1:', reg.ord1);
        clN1 := reg.ord1;
        totN1 := 0;
        while (clN1 = reg.ord1) do 
        begin
            writeln('Clave Nivel 2:', reg.ord2);
            clN2 := reg.ord2;
            totN2 := 0;
            while (clN1 = reg.ord1) and (clN2 = reg.ord2) do 
            begin
                writeln('Clave Nivel 3:', reg.ord3);
                clN3 := reg.ord3;
                totN3 := 0;
                while (clN1 = reg.ord1) and (clN2 = reg.ord2) and (clN3 = reg.ord3) do 
                begin
                    write('Vendedor:', reg.vendedor);
                    writeln(reg.monto);
                    totN3 := totN3 + reg.monto;
                    leer(arch, reg);
                end;
                writeln('Total Nivel 3:', totN3:0:2);
                totN2 := totN2 + totN3;
            end;
            writeln('Total Nivel 2:', totN2:0:2);
            totN1 := totN1 + totN2;
        end;
        writeln('Total Nivel 1:', totN1:0:2);
        totG := totG + totN1;
    end;
    writeln('Total General:', totG:0:2);
    close(arch);
end;





begin

end.