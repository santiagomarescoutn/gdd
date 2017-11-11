/*--Ejercicio 8
select prod_detalle, prod_codigo, max(stoc_cantidad) as stoc_max
from STOCK , Producto 
where stoc_cantidad > 0 AND prod_codigo = stoc_producto
group by prod_detalle, prod_codigo
having count(stoc_deposito) = (select count(*) from DEPOSITO)
*/

/*--Ejercicio 10
select  prod_codigo, (select top 1 f.fact_cliente from Factura f, Item_Factura itf
	where itf.item_tipo=f.fact_tipo AND 
	f.fact_sucursal=itf.item_sucursal AND 
	f.fact_numero=itf.item_numero AND
	itf.item_producto = prod_codigo
	group by f.fact_cliente 
	order by sum(itf.item_cantidad)) as cliente from Producto

where prod_codigo in (select top 10 item_producto from Item_Factura 
group by item_producto
order by sum(item_cantidad) DESC)

or prod_codigo in (select top 10 item_producto from Item_Factura 
group by item_producto
order by sum(item_cantidad) ASC) 
*/

--Ejercicio 11
--select fami_detalle,

--Ejercicio 15
/*
select p1.prod_codigo, p1.prod_detalle, p2.prod_codigo, p2.prod_detalle, count(i1.item_tipo+i1.item_sucursal+i1.item_numero)
from Producto p1, Producto p2, Item_Factura i1, Item_Factura i2
where p1.prod_codigo = i1.item_producto AND p2.prod_codigo = i2.item_producto AND
	i1.item_tipo = i2.item_tipo AND 
	i1.item_sucursal = i2.item_sucursal AND 
	i1.item_numero = i2.item_numero AND
	p1.prod_codigo>p2.prod_codigo
group by p1.prod_codigo, p1.prod_detalle, p2.prod_codigo, p2.prod_detalle
having count(i1.item_tipo+i1.item_sucursal+i1.item_numero) >500
order by count(i1.item_tipo+i1.item_sucursal+i1.item_numero)ASC
*/

--Ejercicio 17

--PRACTICA PL

--Ejercicio 1
create function ejercicio1 (@articulo char(8), @depo char(2))
returns nvarchar(50)
	as begin 
		declare @cantidad int
		declare @ret nvarchar(50)

		set @cantidad=(select stoc_cantidad from STOCK
		where @depo = stoc_deposito AND @articulo = stoc_producto)

		declare @espaciomax int

		select @espacioMax=stoc_stock_maximo from STOCK
		where @depo = stoc_deposito AND @articulo = stoc_producto

		if @cantidad >= @espaciomax
			begin
				set @ret = 'deposito completo'
			end
		else
			begin
				declare @porcentaje int
				set @porcentaje = @cantidad / 100 * @espaciomax

				set @ret = 'ocupacion del deposito %' + cast(isnull(@porcentaje,0)as char)
			end

		return  @ret
end
go

--Ejercicio 2 

create function ejercicio2(@prod char(8), @fecha smalldatetime)
returns int
	as begin
		declare @vendidos_hasta_fecha int
		
		select @vendidos_hasta_fecha = sum(isnull(item_cantidad,0)) from Item_Factura
		join Factura on item_tipo=fact_tipo AND item_sucursal=fact_sucursal AND fact_numero=item_numero
		where item_producto = @prod AND fact_fecha=@fecha
		
		return @vendidos_hasta_fecha
end
go
