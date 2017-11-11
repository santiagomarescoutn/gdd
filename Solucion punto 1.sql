SELECT p.prod_codigo,
		(CASE WHEN p.prod_codigo IN (SELECT comp_producto FROM Composicion) THEN 'Producto Compuesto'
		ELSE e.enva_detalle 
		END)
FROM
	Producto p
JOIN
	Envases e ON p.prod_envase = e.enva_codigo
WHERE
	p.prod_codigo IN (SELECT TOP 50 p.prod_codigo
						FROM Producto p
						JOIN Item_Factura i ON p.prod_codigo = i.item_producto
						JOIN Factura f ON f.fact_numero = i.item_numero AND f.fact_sucursal = i.item_sucursal AND f.fact_tipo = i.item_tipo
						WHERE YEAR(f.fact_fecha) = 2011
						GROUP BY p.prod_codigo 
						ORDER BY SUM(i.item_cantidad))
GROUP BY 
	p.prod_codigo, p.prod_detalle, e.enva_detalle
ORDER BY
	(SELECT SUM(i1.item_cantidad) FROM Item_Factura i1
	JOIN Factura f ON f.fact_numero = i1.item_numero AND f.fact_sucursal = i1.item_sucursal AND f.fact_tipo = i1.item_tipo
	WHERE YEAR(f.fact_fecha) = 2010 AND i1.item_producto = p.prod_codigo) DESC