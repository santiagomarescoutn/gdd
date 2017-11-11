select p1.prod_codigo, p1.prod_detalle, c.comp_cantidad, c.comp_producto, c.comp_componente, p.prod_detalle from producto p1
join Composicion c on p1.prod_codigo = c.comp_producto
join Producto p on c.comp_componente = p.prod_codigo