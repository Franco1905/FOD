


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

Program ej5;

Const 
  valorAlto = 'ZZZZZZZ';

Type 

  log = Record
    cod_usuario : string;
    fecha : string;
    tiempo_session : string;
  End;

  usuario = Record
    cod_usuario : string;
    fecha : string;
    tiempo_total : string;
  End;

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
