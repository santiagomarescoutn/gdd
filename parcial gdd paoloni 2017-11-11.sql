/*
11/11/2017
1er Parcial Gestión de Datos - Tema 1
Martín E. Paoloni
Leg. 118256-0
martinpaoloni@gmail.com
*/

use gd2015c1
go

-- Practica
/*
1. Realizar una consulta SQL que retorne, para cada producto con más de 2 artículos distintos en su
composición la siguiente información.
1) Detalle del producto
2) Rubro del producto
3) Cantidad de veces que fue vendido

El resultado deberá mostrar ordenado por la cantidad de los productos que lo componen.

*NOTA:* No se permite el uso de sub-selects en el FROM ni funciones definidas por el usuario para este punto.
*/

select
  p.prod_detalle,
  r.rubr_detalle,
  (select count(*) from item_factura where item_producto = p.prod_codigo) cantidad_ventas
from producto p
join rubro r on p.prod_rubro = r.rubr_id
where
  p.prod_codigo in
    (select c.comp_producto from composicion c group by c.comp_producto having count(comp_componente) > 2) -- cambiar por >= para que me muestre algo
order by (select sum(comp_cantidad) from composicion where comp_producto = p.prod_codigo) desc -- cantidad de componentes, en su cantidad correspondiente
go

/*
2. Agregar el/los objetos necesarios para que se permita mantener la siguiente restricción:
Nunca un jefe va a poder tener más de 20 personas a cargo y menos de 1.
Nota: Considerar solo 1 nivel de la relación empleado-jefe.
*/

-- drop trigger
drop trigger dbo.tr_personas_a_cargo
go

-- resolucion
create trigger dbo.tr_personas_a_cargo
on dbo.empleado
after insert, update
as
if update(empl_jefe)
begin tran
-- valido que los jefes de los empleados inserted y deleted cumplen con la restriccion.
  if exists (
      select 1 from empleado e
	  where e.empl_codigo in (select i.empl_jefe from inserted i union select d.empl_jefe from deleted d)
	  and (select count(*) from empleado e1 where e1.empl_jefe = e.empl_codigo) not between 1 and 20
	  )
    begin
      raiserror('No se cumpliria la condicion de que un jefe solo puede tener a cargo entre 1 y 20 personas',16,1)
	  rollback tran
    end
commit tran

-- Teoria
/*
1. Sin considerar los bytes adicionales debido a los atributos que muestran.
Determinar por qué la siguiente afirmación es verdadera.
 SELECT * FROM T WHERE ID = 1 es menos performante que
 SELECT ID FROM T WHERE ID = 1 sabiendo que existe un indice Arbol B en T sobre el atributo ID.
*/
/*
En un Arbol B, las hojas contienen punteros a los datos. Al hacer SELECT *, tengo que seguir esos punteros,
para ir a buscar todos los registros correspondientes a ese ID.
En cambio, si hago SELECT ID no tengo que seguir ese puntero, ya que toda la información que necesito está
en el arbol.
*/