CREATE SCHEMA compras;
CREATE SCHEMA inventario;
CREATE SCHEMA almacen;

create table almacen.areas(
	id_area SERIAL NOT NULL PRIMARY KEY,
	nombre varchar(255)

);

create table almacen.empleados(
	id_empleado  SERIAL NOT NULL PRIMARY KEY,
	id_area integer,
	nombre varchar(255),
	dni varchar(255) unique, 
	cargo varchar(255),
	direccion varchar(255),
	telefono varchar(255),
	foreign key (id_area) references almacen.areas(id_area)

);

create table almacen.responsables(
	id_responsable SERIAL NOT NULL PRIMARY KEY,
	id_empleado integer,
	foreign key (id_empleado) references almacen.empleados(id_empleado)
	
);


create table compras.items(
	id_item  SERIAL NOT NULL PRIMARY KEY,
	nombre varchar(255),
	cantidad  integer,
	valor_unitario decimal,
	representante varchar(255)
	
);

create table compras.solicitudes(
	id_solicitud  SERIAL NOT NULL PRIMARY KEY,
	id_item  integer,
	fecha date,
	id_responsable  integer,
	foreign key (id_responsable) references almacen.responsables (id_responsable),
	foreign key (id_item) references compras.items(id_item)
);


create table compras.envios(
	id_envio  SERIAL NOT NULL PRIMARY KEY,
	via_envio varchar(255),
	metodo_envio  varchar(255),
	condicion_envio varchar(255),
	dia_entrega date
	
);

create table compras.proveedores(
	id_proveedor  SERIAL NOT NULL PRIMARY KEY,
	nombre varchar(255),
	direccion  varchar(255),
	RUC varchar(255),
	fecha date,
	ciudad varchar(255)
	
);

create table compras.orden_compra_adicionales(
	id_adicionales  SERIAL NOT NULL PRIMARY KEY,
	descuento decimal,
	impuesto decimal
);

create table compras.orden_compra(
	id_ordencompra  SERIAL NOT NULL PRIMARY KEY,
	id_proveedor integer,
	id_solicitud integer,
	id_envio integer,
	descripcion varchar,
	impuesto decimal,
	precio decimal,
	id_adicionales integer,
	foreign key (id_proveedor) references compras.proveedores(id_proveedor),
	foreign key (id_solicitud) references compras.solicitudes(id_solicitud),
	foreign key (id_envio) references compras.envios(id_envio),
	foreign key (id_adicionales) references compras.orden_compra_adicionales(id_adicionales)
	
);

create table almacen.entrada(
	id_entrada SERIAL NOT NULL PRIMARY KEY,
	id_ordencompra integer,
	fecha_entrega date,
	foreign key (id_ordencompra) references compras.orden_compra(id_ordencompra)
	
);


create table almacen.salidas(
	id_salida SERIAL NOT NULL PRIMARY KEY,
	id_entrada integer,
	fecha_salida date,
	fecha_entrega date,
	foreign key (id_entrada) references almacen.entrada(id_entrada)
	
);


CREATE TABLE inventario.bien(  
    id_bien SERIAL NOT NULL PRIMARY KEY,
    id_salida integer,
    nombre varchar(255),
   	cantidad integer,
    fecha_entrega date,
    foreign key (id_salida) references almacen.salidas(id_salida)
    
);