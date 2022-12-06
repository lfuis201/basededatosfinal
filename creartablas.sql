CREATE SCHEMA compras;
CREATE SCHEMA inventario;
CREATE SCHEMA almacen;

CREATE TABLE compras.RESPONSABLES(  
    nombre VARCHAR(255),
    DNI VARCHAR(255) UNIQUE
);


create  TABLE compras.ITEMS( 
    id_item SERIAL NOT NULL PRIMARY KEY, 
    nombre_items VARCHAR(255),
    cantidad INTEGER,
    unidad_medida VARCHAR(255),
    valor_unitario decimal,
    valor_total decimal
); 

create TABLE compras.SOLICITUDES(
    id_solicitud SERIAL NOT NULL PRIMARY KEY,
    id_item integer,
    centro_costos VARCHAR(255),
    rubro_presupuestal decimal,
    fecha date,
    dni_responsable VARCHAR(255),
    foreign key (dni_responsable) references compras.RESPONSABLES(DNI),
    foreign key (id_item) references compras.ITEMS(id_item)
);


CREATE TABLE compras.ORDEN_CONTRAACTUAL(  
    id_orden SERIAL NOT NULL PRIMARY KEY,
    id_item integer,
    nit VARCHAR(255),
    nom_proveedor VARCHAR(255),
    fecha DATE,
    fecha_entrega DATE,
    monto decimal,
    foreign key (id_item) references compras.ITEMS(id_item)
);

CREATE TABLE inventario.BIEN(  
    id_bien SERIAL NOT NULL PRIMARY KEY,
    dni_responsable VARCHAR(255),
    fecha_entrega date,
    direccion VARCHAR(255),
    foreign key (dni_responsable) references compras.RESPONSABLES(DNI)
);


CREATE TABLE almacen.FACTURA(  
    id_factura SERIAL NOT NULL PRIMARY KEY,
    id_item integer,
    fecha DATE,
    proveedor VARCHAR(255),
    total_bienes integer,
    valor_total decimal,
    num_entrada decimal,
    foreign key (id_item) references compras.ITEMS(id_item)
    
);
CREATE TABLE almacen.SALIDAS_ALMACEN(
	id_salida SERIAL NOT NULL PRIMARY key,
    dni_empleado VARCHAR(255),
    fecha_salida DATE,
    fecha_entrega DATE,
    foreign key (dni_empleado) references compras.RESPONSABLES(DNI)
    
);

