/* EJERCICIO 3 */

select d.depa_detalle as departamento, count(empl_departamento) cant_empl_depart,
--nombre del empleado mas joven x departamento
(select top 1 empl_nombre from Empleado
	where empl_departamento = d.depa_codigo
	group by empl_nombre, empl_nacimiento
	order by empl_nacimiento DESC) nom_empl_mas_joven,
--apellido del empleado mas joven x departamento
(select top 1 empl_apellido from Empleado
	where empl_departamento = d.depa_codigo
	group by empl_apellido, empl_nacimiento
	order by empl_nacimiento DESC) nom_empl_mas_joven
from Empleado
	join Departamento d on empl_departamento = d.depa_codigo
	join Zona z on d.depa_zona = z.zona_codigo
--solo considero los departamentos de la zona de CONCORDIA
where z.zona_detalle = 'ZONA CONCORDIA' 
group by d.depa_codigo, d.depa_detalle, empl_departamento
--donde la cantidad de empleados es mayor a 5
having count(empl_departamento) > 5
--ordeno primero (1) los que tengan el salario promedio entre 10000 y 18000 y luego (0) el resto
order by (select top 1 CASE WHEN AVG(empl_salario) between 10000 and 18000 THEN 1 else 0 END from Empleado e
		WHERE e.empl_departamento = d.depa_codigo
		group by empl_codigo)


/* EJERCICIO 4 */
--Store procedure al cual le mandas un año deseado y te devuelve una tabla con los codigos de los clientes
--candidatos a obtener el 50% de descuento (compras en el anio  > (compras en el anio -1) * 1.25 )

CREATE PROCEDURE candidatos_a_descuentos
	@anio int
AS
BEGIN
	select clie_codigo from Cliente
	join Factura on clie_codigo = fact_cliente
	group by clie_codigo
	having (select top 1 isnull(sum(itf.item_cantidad*itf.item_precio),0) from Factura f
						join Item_Factura itf on f.fact_tipo = itf.item_tipo AND
						f.fact_sucursal = itf.item_sucursal AND
						f.fact_numero = itf.item_numero 
						where f.fact_cliente = clie_codigo AND YEAR(f.fact_fecha) = @anio) >
			(select top 1 isnull(sum(itf.item_cantidad*itf.item_precio),0) from Factura f
						join Item_Factura itf on f.fact_tipo = itf.item_tipo AND
						f.fact_sucursal = itf.item_sucursal AND
						f.fact_numero = itf.item_numero 
						where f.fact_cliente = clie_codigo AND YEAR(f.fact_fecha) = @anio -1) * 1.25
END
GO