---PATRICK PAREDES NEIRA


--CREATE SCHEMA compras;
--CREATE SCHEMA inventario;
--CREATE SCHEMA almacen;

--CREATE TABLE compras.RESPONSABLES(  
--    nombre VARCHAR(255),
--    DNI VARCHAR(255) UNIQUE
--);

/*DROP table compras.ORDEN_CONTRAACTUAL;

create TABLE compras.SOLICITUDES(
    id_solicitud SERIAL NOT NULL PRIMARY KEY,
    id_item integer,
    centro_costos VARCHAR(255),
    rubro_presupuestal decimal,
    fecha date,
    dni_responsable VARCHAR(255)
--    foreign key (dni_responsable) references compras.RESPONSABLES(DNI),
--    foreign key (id_item) references compras.ITEMS(id_item)
);

CREATE TABLE compras.ITEMS( 
    id_item SERIAL NOT NULL PRIMARY KEY, 
    nombre_items VARCHAR(255),
    cantidad INTEGER,
    unidad_medida INTEGER,
    valor_unitario decimal,
    valor_total decimal
); 

insert into compras.ITEMS(id_item, nombre_items, cantidad, unidad_medida, valor_unitario, valor_total) values(1,'leche',20,2.25,2.25,10.25);
insert into compras.ITEMS(id_item, nombre_items, cantidad, unidad_medida, valor_unitario, valor_total) values(2,'yogurt',30,3.25,1.25,12.25);
insert into compras.ITEMS(id_item, nombre_items, cantidad, unidad_medida, valor_unitario, valor_total) values(3,'miel',40,4.25,0.25,13.25);
insert into compras.ITEMS(id_item, nombre_items, cantidad, unidad_medida, valor_unitario, valor_total) values(4,'cuaker',50,6.25,6.25,14.25);

select * from compras.ITEMS;


CREATE TABLE compras.ORDEN_CONTRAACTUAL(  
    id_orden SERIAL NOT NULL PRIMARY KEY,
    id_item integer,
    nit VARCHAR(255),
    nom_proveedor VARCHAR(255),
    fecha DATE,
    fecha_entrega DATE,
    monto decimal
    --foreign key (id_item) references compras.ITEMS(id_item)
);
insert into compras.ORDEN_CONTRAACTUAL(id_orden,id_item,nit,nom_proveedor,fecha,fecha_entrega,monto) values(1,1,'2015454','gloria','2014-10-29','2022-10-30',102.50);
insert into compras.ORDEN_CONTRAACTUAL(id_orden,id_item,nit,nom_proveedor,fecha,fecha_entrega,monto) values(2,2,'2015464','laive','2014-10-29','2022-10-30',122.50);
insert into compras.ORDEN_CONTRAACTUAL(id_orden,id_item,nit,nom_proveedor,fecha,fecha_entrega,monto) values(3,3,'2015474','otra mas','2014-10-29','2022-10-30',132.50);
insert into compras.ORDEN_CONTRAACTUAL(id_orden,id_item,nit,nom_proveedor,fecha,fecha_entrega,monto) values(4,4,'2015484','tottus','2014-10-29','2022-10-30',142.50);
insert into compras.ORDEN_CONTRAACTUAL(id_orden,id_item,nit,nom_proveedor,fecha,fecha_entrega,monto) values(5,5,'2015494','metro','2014-10-29','2022-10-30',152.50);

select * from compras.ORDEN_CONTRAACTUAL ;



*/
select compras.ORDEN_CONTRAACTUAL.nom_proveedor,compras.ORDEN_CONTRAACTUAL.fecha,compras.ORDEN_CONTRAACTUAL.fecha_entrega,compras.ORDEN_CONTRAACTUAL.monto  from compras.ORDEN_CONTRAACTUAL left join compras.ITEMS on compras.ORDEN_CONTRAACTUAL.id_item = compras.ITEMS.id_item where compras.ORDEN_CONTRAACTUAL.id_item = compras.ITEMS.id_item order by compras.ORDEN_CONTRAACTUAL.nom_proveedor; 





create or replace procedure mostrar_productos(id_productos int)
language plpgsql    
as $$
begin
  
	select compras.ORDEN_CONTRAACTUAL.nom_proveedor,compras.ORDEN_CONTRAACTUAL.fecha_entrega from compras.ORDEN_CONTRAACTUAL where id_productos = compras.ORDEN_CONTRAACTUAL.id_orden; 
	raise notice '% %',compras.ORDEN_CONTRAACTUAL.nom_proveedor,compras.ORDEN_CONTRAACTUAL.fecha_entrega; 

end;$$




----ejemplo de actualizacion

create or replace procedure actualizar_monto(id_orden_act compras.ORDEN_CONTRAACTUAL.id_orden%type)
language plpgsql    
as $$
begin
    
    update compras.ORDEN_CONTRAACTUAL 
    set monto = monto*1.3
    where id_orden = id_orden_act;

    commit;
end;$$


----ejemplo con funciones


create or replace function find_film_by_id(id int) 
returns film 
language sql
as 
  'select * from film 
   where film_id = id';
--select find_film_by_id(1);  

create or replace function mas_vendido(id int) 
returns numeric
language sql
as 
$$
  select max(monto) from compras.ORDEN_CONTRAACTUAL
  where id_orden = id;  
$$; 


call actualizar_monto(2);
SELECT * FROM compras.orden_contraactual;



-----usando auditoria

CREATE TABLE auditoria_actualizacion(

	operacion char(1) NOT NULL,
	id_us	text NOT NULL,
	id_rent integer NOT NULL,
	id_custom smallint NOT NULL
);

CREATE OR REPLACE FUNCTION process_auditoria_actualizacion() RETURNS
TRIGGER AS $auditoria_actualizacion$
BEGIN
	IF (TG_OP = 'UPDATE') THEN
		INSERT INTO auditoria_pagos SELECT 'U', user, NEW.id_rent, NEW.id_custom;
		RETURN NEW;
	END IF;
	RETURN NULL;
END;
$auditoria_actualizacion$ LANGUAGE plpgsql;

CREATE TRIGGER auditoria_actualizacion
AFTER INSERT OR UPDATE OR DELETE ON monto
FOR EACH ROW EXECUTE PROCEDURE process_auditoria_actualizacion();


---cursor nuevo 

CREATE OR REPLACE FUNCTION expl_cursor1() RETURNS SETOF customer AS
$$
DECLARE
    -- Declaración EXPLICITA del cursor
    cur_compras CURSOR FOR SELECT * FROM compras.ITEMS; 
    registro compras.ITEMS%ROWTYPE;
BEGIN
   -- Procesa el cursor
   FOR registro IN cur_compras LOOP
       RETURN NEXT registro..valor_unitario;
   END LOOP;
   RETURN;
END $$ LANGUAGE 'plpgsql'


---cursor anidado

--compras.ITEMS----------------nombre_items
--compras.ORDEN_CONTRAACTUAL----nom_proveedor---monto

select * from compras.items;
create or replace function cursor_opcional() returns VOID as 
$BODY$
DECLARE
	reg RECORD;
	cur_ayudin cursor for select * from compras.ITEMS order by unidad_medida;
begin 
	open cur_ayudin;
	fetch cur_ayudin into reg;
	while(found) loop
		raise notice 'PROCESANDO % ,  %',reg.nombre_items,reg.valor_total;
		fetch cur_ayudin into reg;
	end loop;
end
$BODY$
LANGUAGE 'plpgsql';


----OTRO CURSOR
CREATE OR REPLACE FUNCTION cursorclientes() RETURNS VOID AS
$BODY$
DECLARE
    reg  RECORD;
    cur_proveedor CURSOR FOR SELECT * FROM compras.ORDEN_CONTRAACTUAL ORDER BY monto;
BEGIN
   OPEN cur_proveedor;
   FETCH cur_proveedor INTO reg;
   WHILE( FOUND ) LOOP
       RAISE NOTICE ' PROCESANDO  % , % ', reg.nom_proveedor,reg.monto;
       FETCH cur_proveedor INTO reg;
      -- 2docursor
      declare 
          reg2 RECORD;
  		  cur_detalles CURSOR FOR SELECT * FROM compras.ITEMS where id_item = reg.id_item;
      BEGIN
		   OPEN cur_detalles;
		   FETCH cur_detalles INTO reg2;
		   WHILE( FOUND ) LOOP
		       RAISE NOTICE ' DETALLES  %', reg2.nombre_items;
		       FETCH cur_detalles INTO reg2;
		      	--3ER CURSO
		   END LOOP ;
		   RETURN;
		end;
      -- ------------------
   END LOOP ;
   RETURN;
END
$BODY$
LANGUAGE 'plpgsql';

/*

CREATE TABLE inventario.BIEN(  
    id_bien SERIAL NOT NULL PRIMARY KEY,
    dni_responsable VARCHAR(255),
    fecha_entrega date,
    direccion VARCHAR(255)
    --foreign key (dni_responsable) references compras.RESPONSABLES(DNI)
);
insert into inventario.BIEN(id_bien, dni_responsable, fecha_entrega, direccion) values (1,'130226','2020-10-12','las palmeras 122');
insert into inventario.BIEN(id_bien, dni_responsable, fecha_entrega, direccion) values (2,'130227','2020-10-13','las palmeras 123');
insert into inventario.BIEN(id_bien, dni_responsable, fecha_entrega, direccion) values (3,'130228','2020-10-14','las palmeras 124');
insert into inventario.BIEN(id_bien, dni_responsable, fecha_entrega, direccion) values (4,'130229','2020-10-15','2022-09-12','las palmeras 125');
insert into inventario.BIEN(id_bien, dni_responsable, fecha_entrega, direccion) values (5,'130220','2020-10-16','2022-08-12','las palmeras 126');

select * from inventario.BIEN;


CREATE TABLE almacen.FACTURA(  
    id_factura SERIAL NOT NULL PRIMARY KEY,
    id_item integer,
    fecha DATE,
    proveedor VARCHAR(255),
    total_bienes integer,
    valor_total decimal,
    num_entrada decimal
    --foreign key (id_item) references compras.ITEMS(id_item)
    
);
CREATE TABLE almacen.SALIDAS_ALMACEN(
	id_salida SERIAL NOT NULL PRIMARY key,
    dni_empleado VARCHAR(255),
    fecha_salida DATE,
    fecha_entrega DATE
    --foreign key (dni_empleado) references compras.RESPONSABLES(DNI)
    
);

*/
--Diccionario de datos

select * from information_schema."tables" t ;


select t1.TABLE_NAME as tabla_nombre,
PG_CATALOG.OBJ_DESCRIPTION(t2.OID,'pg_class') as tabla_descripcion
from
information_schema.tables t1
inner join pg_class t2 on (t2.relname = t1.table_name)
where
t1.table_schema ='inventario'
order by
t1.table_name;