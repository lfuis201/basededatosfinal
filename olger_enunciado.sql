-- Consultas 1 y n tablas: Consultar el area a la que pertenece el empleado, id del empleado
-- , nombre y el area.

select * from compras.solicitudes s ; 
select * from compras.orden_compra oc ;
select * from almacen.areas a ;
select * from almacen.empleados e ;
select e.id_empleado, e.nombre, a.nombre from almacen.empleados e inner join almacen.areas a 
on e.id_area  =a.id_area; 

-- Funciones para cálculos: Mostrar la cantidad de solicitudes del responsable con su 
-- respectivo ID y nombre del responsable.  
select count(id_solicitud), r.id_responsable, e.nombre from compras.solicitudes s inner join almacen.responsables r  
on s.id_responsable  =r.id_responsable inner join almacen.empleados e on r.id_empleado =e.id_empleado
where r.id_responsable = 2
group by r.id_responsable, e.nombre 
order by r.id_responsable;

create or replace function cant_solic2(
	in id_ int,
    out cant decimal,
    out id text ,
    out nombre text) 
language plpgsql
as $$
begin
  select count(id_solicitud), r.id_responsable, e.nombre from compras.solicitudes s 
  into cant,id,nombre inner join almacen.responsables r  
on s.id_responsable  =r.id_responsable inner join almacen.empleados e on r.id_empleado =e.id_empleado
where r.id_responsable = id_
group by r.id_responsable, e.nombre 
order by r.id_responsable;

end;$$

select * from cant_solic2(2);

-- Detonadores para control de modificaciones: Promedio de todas las ordenes contractuales

-- Reportes con cursores simples: Mostrar la bien, su nombre, fecha_entreda y fecha_salida 
-- el nombre del proveedor. Además mostrar también el nombre del item, id y la cantidad.      

 
select * from inventario.bien b ;
select * from almacen.entrada e;
select * from almacen.salidas s ;
select b.nombre, e.fecha_entrega, s.fecha_salida from inventario.bien b 
inner join almacen.salidas s on b.id_salida =s.id_salida 
inner join almacen.entrada e  on s.id_entrada  =e.id_entrada;


create or replace function bien_e_s()
 RETURNS VOID as 
$BODY$
declare
    cur_c cursor for select b.nombre, e.fecha_entrega, s.fecha_salida from inventario.bien b 
inner join almacen.salidas s on b.id_salida =s.id_salida 
inner join almacen.entrada e  on s.id_entrada  =e.id_entrada;
rec_c   record; 
begin
open cur_c;
	FETCH cur_c INTO rec_c;    -- 1era linea
	   	WHILE( FOUND ) LOOP
	       RAISE NOTICE '  Nombre Bien: % Entrega: %  Salida: %', rec_c.nombre, rec_c.fecha_entrega, rec_c.fecha_salida;
	       FETCH cur_c INTO rec_c;   -- 2da en adelante
	   	END LOOP ;
   RETURN;
close cur_c;
end;
$BODY$
language plpgsql;

select bien_e_s();

-- Carga masiva prueba en tabla areas
select * from almacen.areas a ;

copy almacen.areas from 'D:\registros\areas.csv' DELIMITER ',' CSV HEADER;


select * from almacen.areas a;






