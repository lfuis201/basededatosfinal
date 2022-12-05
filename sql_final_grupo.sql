--INSERCION DATOS
--INSERT INTO mi_tabla (id, nombre, ciudad) VALUES (1, 'Pepito', 'Sevilla');
--INSERT INTO compras.responsables (nombre, DNI) VALUES ('Juan', 77513213);
select * from compras.responsables r ;
INSERT INTO compras.responsables(nombre, DNI) values ( ' gloppy ' , 72504723 ) ;
INSERT INTO compras.responsables(nombre, DNI) values ( ' homely ' , 72505723 ) ;
INSERT INTO compras.responsables(nombre, DNI) values ( ' cheeky ' , 72506723 ) ;
INSERT INTO compras.responsables(nombre, DNI) values ( ' freaky ' , 72507723 ) ;
INSERT INTO compras.responsables(nombre, DNI) values ( ' wiggy ' , 72508723 ) ;
INSERT INTO compras.responsables(nombre, DNI) values ( ' homey ' , 72509723 ) ;
INSERT INTO compras.responsables(nombre, DNI) values ( ' breezy ' , 72510723 ) ;
INSERT INTO compras.responsables(nombre, DNI) values ( ' sleazy ' , 72511723 ) ;
INSERT INTO compras.responsables(nombre, DNI) values ( ' fuzzy ' , 72512723 ) ;
INSERT INTO compras.responsables(nombre, DNI) values ( ' muggy ' , 72513723 ) ;
INSERT INTO compras.responsables(nombre, DNI) values ( ' nerdy ' , 72514723 ) ;
INSERT INTO compras.responsables(nombre, DNI) values ( ' queasy ' , 72515723 ) ;
INSERT INTO compras.responsables(nombre, DNI) values ( ' crabby ' , 72516723 ) ;
INSERT INTO compras.responsables(nombre, DNI) values ( ' sunny ' , 72517723 ) ;
INSERT INTO compras.responsables(nombre, DNI) values ( ' gamy ' , 72518723 ) ;
INSERT INTO compras.responsables(nombre, DNI) values ( ' shaggy ' , 72519723 ) ;
INSERT INTO compras.responsables(nombre, DNI) values ( ' stinky ' , 72520723 ) ;
INSERT INTO compras.responsables(nombre, DNI) values ( ' stinky ' , 72521723 ) ;
INSERT INTO compras.responsables(nombre, DNI) values ( ' tasty ' , 72522723 ) ;
INSERT INTO compras.responsables(nombre, DNI) values ( ' lovely ' , 72523723 ) ;

select * from compras.items i ;
insert into compras.items(id_item,nombre_items, cantidad, unidad_medida, valor_unitario,valor_total) values (1,'Pepsi Six pack',2,2,3.5,21.0);
insert into compras.solicitudes (id_solicitud, id_item,centro_costos, rubro_presupuestal, fecha, dni_responsable ) 
values (100, 1, 'El cobro', 16.5, '2022-12-12', 72504723);
-- Consultas 1 y n tablas: Mostrar la solicitud de cada responsable, 
-- mostrando el ID del responsable y su nombre, 
-- el rubro presupuestal y la fecha en que se hizo la solicitud. 

select * from compras.responsables r ; 
select * from compras.responsables r ;
select r.nombre , r.dni, s.rubro_presupuestal ,s.fecha  from compras.responsables r inner join compras.solicitudes s 
on  r.dni =s.dni_responsable;
-- Funciones para cálculos: Mostrar la cantidad de solicitudes de cada responsable con su 
-- respectivo ID y nombre del responsable.  
select count(id_solicitud), r.dni , r.nombre from compras.solicitudes s inner join compras.responsables r 
on s.dni_responsable =r.dni 
group by r.dni, r.nombre  ;


create or replace function cant_solic(
    out cant decimal,
    out dni text ,
    out nombre text) 
language plpgsql
as $$
begin
  
  select count(id_solicitud), r.dni , r.nombre from compras.solicitudes s into cant, dni, nombre inner join compras.responsables r 
on s.dni_responsable =r.dni 
group by r.dni, r.nombre  ;

end;$$

select * from cant_solic();


-- Detonadores para control de modificaciones: Promedio de todas las ordenes contractuales

-- Reportes con cursores simples: Mostrar la factura, donde se muestra el ID factura, 
-- el nombre del proveedor. Además mostrar también el nombre del item, id y la cantidad.      

 
select i.id_item,i.nombre_items,i.cantidad  from compras.items i ;
select f.id_factura ,f.proveedor from almacen.factura f ;

select i.id_item,i.nombre_items,i.cantidad,f.id_factura ,f.proveedor from compras.items i inner join almacen.factura f  
on i.id_item  =f.id_item ;

create or replace function cur_fact_item()
 RETURNS VOID as 
$BODY$
declare
    cur_c cursor for select i.id_item,i.nombre_items,i.cantidad,f.id_factura ,f.proveedor from compras.items i inner join almacen.factura f  
on i.id_item  =f.id_item ; 
rec_c   record; 
begin
open cur_c;
	FETCH cur_c INTO rec_c;    -- 1era linea
	   	WHILE( FOUND ) LOOP
	       RAISE NOTICE ' PROCESANDO  % - % - % - % - %', rec_c.id_item, rec_c.nombre_items, rec_c.cantidad, rec_c.id_factura,rec_c.proveedor;
	       FETCH cur_c INTO rec_c;   -- 2da en adelante
	   	END LOOP ;
   RETURN;
close cur_c;
end;
$BODY$
language plpgsql;

select cur_fact_item();

-- Reportes con cursores anidados: Mostrar identificador de la factura con el nombre del proveedor, 
-- donde se registra la salida del almacén, mostrando el número de salida 
-- y el nombre del empleado asignado. 