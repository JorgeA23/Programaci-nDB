	/*Creamos la base de datos*/
drop database if exists fruver;
create database fruver;
use fruver;

	/*Creamos las tablas con sus relaciones*/
drop table if exists vendedor;
create table vendedor(
Cedula int(18) primary key,
Nombre varchar(30)
);
drop table if exists clientes;
create table clientes(
Cedula int(18) primary key,
Nombre varchar(30)
);
drop table if exists productos;
create table productos(
idProducto int(18) primary key,
nombreProducto varchar(30),
valorUnit int(18)
);
drop table if exists factura;
create table factura(
numeroFactura int(18),
idProducto int(18),
idVendedor int(18),
idCliente int(18),
cantidadProductos int,
CONSTRAINT IdProductos foreign key (idProducto) references productos(idProducto),
CONSTRAINT IdVendedor foreign key (idVendedor) references vendedor(Cedula),
CONSTRAINT IdCliente foreign key (idCliente) references clientes(Cedula)
);
drop table if exists ventas;
create table ventas(
idVenta int primary key auto_increment,
idVendedor int(18),
nombreVendedor varchar(30),
cantidadProductos int
);

	/*Insertamos datos*/
insert into vendedor values(111111,"Javier Vasquez");
insert into vendedor values(222222,"Oscar Mute");
insert into vendedor values(333333,"Ana Mora");
insert into vendedor values(444444,"José José");
insert into vendedor values(555555,"Michael Velez");

insert into clientes values(123456,"Doña Margot");
insert into clientes values(234567,"Hugo Lopez");
insert into clientes values(345678,"Jaime Cortez");
insert into clientes values(456789,"Arturo Bondia");
insert into clientes values(567890,"Elsa Patricia");

insert into productos values(100,"Arroz",3000);
insert into productos values(200,"Manzana",1200);
insert into productos values(300,"Gaseosa 1.5L",3600);
insert into productos values(400,"Papa Criolla",2800);
insert into productos values(500,"Platano Maduro",1200);

  /*  CURSOR  */
DELIMITER °°
create procedure ESQUENOSE()

BEGIN
  /*  Declaramos las variables*/
  DECLARE lista_nombre VARCHAR(20000) DEFAULT 'NOMBRE PRODUCTOS: ';
  DECLARE nombre varchar(30);
  DECLARE var_final INTEGER DEFAULT 0;
  
  /*  Declaramos el nombre del cursor y la consulta que usará*/
  DECLARE cursorUSB CURSOR FOR 
	SELECT nombreProducto FROM productos;
	
  /*	HANDLER --- 	Nos ayuda q cambiar el valor de la variable "var_final" a 1 cuando el cursor llegue al ultimo registro	*/
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET var_final = 1;
  
  /*	OPEN indica el comiendo del cursor	*/
  OPEN cursorUSB;
  
  /*	Bucle donde por cada ciclo se agrega el nombre del producto a una lista		*/
  bucle: LOOP
    FETCH cursorUSB INTO nombre;
    IF var_final = 1 THEN
      LEAVE bucle;
    END IF;
	SET lista_nombre = CONCAT(lista_nombre, ', ',nombre );
	/*	Cierre del bucle y el cursor	*/
  END LOOP bucle;
  CLOSE cursorUSB;
  
  /*	Consulta que nos muestra laa lista final	*/
  SELECT lista_nombre;
END
°°

/*	llamdo del procedimiento almacenado*/
CALL ESQUENOSE;
