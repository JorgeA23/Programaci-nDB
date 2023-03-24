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
	/*Indicamos la creación y composición del Trigger*/
DELIMITER °°
CREATE TRIGGER ventasPorVendedor after insert on factura
for each row
	begin
		declare persona int;
		declare contador int;
        declare nombre varchar(30);
        select a.Cedula into persona from vendedor as a where a.Cedula=new.idVendedor;
        select a.Nombre into nombre from vendedor as a where a.Cedula=new.idVendedor;
        select count(*) into contador from ventas where idVendedor=new.idVendedor;
        if contador = 0 or persona <> new.idVendedor then
			insert into ventas(idVendedor, nombreVendedor, cantidadProductos)
            values(new.idVendedor, nombre, new.cantidadProductos);
		else 
			update ventas as v set v.cantidadProductos= v.cantidadProductos + new.cantidadProductos where v.idVendedor = new.idVendedor;
        end if;
    end;
°°
	/*Comando para eliminar el Trigger*/
drop trigger ventasPorVendedor;
	/*Consultamos las tablas*/
select * from ventas;
select * from factura;
	/*Insertamos datos e la tabla objetivo del Trigger*/
insert into factura(numeroFactura,idProducto,idVendedor,idCliente,cantidadProductos) values(1,100,111111,123456,1);
insert into factura(numeroFactura,idProducto,idVendedor,idCliente,cantidadProductos) values(2,200,111111,123456,2);
insert into factura(numeroFactura,idProducto,idVendedor,idCliente,cantidadProductos) values(2,300,111111,123456,7);
insert into factura(numeroFactura,idProducto,idVendedor,idCliente,cantidadProductos) values(3,200,222222,123456,7);
insert into factura(numeroFactura,idProducto,idVendedor,idCliente,cantidadProductos) values(3,100,222222,123456,2);
insert into factura(numeroFactura,idProducto,idVendedor,idCliente,cantidadProductos) values(4,400,222222,123456,5);
insert into factura(numeroFactura,idProducto,idVendedor,idCliente,cantidadProductos) values(4,100,333333,123456,2);
