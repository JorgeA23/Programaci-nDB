drop database if exists fruver;
create database fruver;
use fruver;

drop table if exists vendedor;
create table vendedor(
id int primary key auto_increment,
nombre varchar(30)
);

drop table if exists productos;
create table productos(
idProduct int primary key auto_increment,
nombre varchar(30),
cantidad int unsigned,
precio int
);

drop table if exists ventas;
create table ventas(
idVenta int primary key auto_increment,
nombreVendedor varchar(30),
cantVentas int
);

insert into vendedor(nombre) values("Charlie"),
("Maria"),
("Daniel"),
("Jose");

insert into productos(nombre,cantidad,precio) values("Manzana",25, 1500),
("Banano",37,600),
("Piña",14,3800),
("Durazno",30,1000),
("Fresa",80,500);


DELIMITER °°
create procedure ventaProductos(in nomVendedor varchar(30),in idProducto int, in cantidades int)
begin
    declare v_cantidad int;
    declare v_vendedor varchar(30);
        declare exit handler for 1690   begin    select 'Ocurrió un error. La venta fue cancelada.';    rollback;    end; 
    select cantidad into v_cantidad from productos where idProduct = idProducto;
    set v_vendedor = (select nombreVendedor from ventas where nombreVendedor like nomVendedor);
    
    start transaction;
    if v_vendedor is null then
		INSERT INTO ventas (nombreVendedor, cantVentas) VALUES (nomVendedor,cantidades);
        update productos set cantidad = cantidad - cantidades where idProduct = idProducto;
	elseif v_vendedor = nomVendedor then
		update ventas set cantVentas= cantVentas + cantidades where nombreVendedor = v_vendedor;
        update productos set cantidad = cantidad - cantidades where idProduct = idProducto;
    end if;
    commit;
    select 'La venta se completó correctamente.';
end
°°
-- Comando para deshabilitar los safe Updates
SET SQL_SAFE_UPDATES = 0;

call ventaProductos("Maria",1,6);

select * from productos;

select * from ventas;
