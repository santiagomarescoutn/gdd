CREATE TABLE reposicion(
	repo_producto char(8),
	repo_deposito char(2),
	repo_cantidad decimal(12, 2)
	PRIMARY KEY (repo_producto, repo_deposito),
	FOREIGN KEY(repo_producto, repo_deposito)
	REFERENCES STOCK(stoc_producto), stoc_deposito)


create trigger after_update_stock
on STOCK
AFTER INSTER, UPDATE
AS
	IF UPDATE(stoc_cantidad) or UPDATE(stoc_punto_reposicion)
		BEGIN
			declare @depo char(2), @prod char(8), @cant decimal(12,2), @punto_repo decimal(12,2)
			declare my_cur cursor for
				select stoc_deposito, stoc_producto, stoc_cantidad, stoc_punto_reposicion
				from inserted
			open my_cur
			fetch my_cur into @depo, @prod, @cant, @punto_repo
				while @@FETCH_STATUS = 0
					begin
						delete from reposicion where repo_producto = @prod and repo.deposito = @depo
						if @punto_repo >= 1.1 * @cant
							begin
								insert into reposicion (repo_producto, repo_deposito, repo_cantidad) values
									(@prod, @depo, @punto_repo - @cant)
							end
				close my_cur
				deallocate my_cur
			end


ALTER TABLE STOCK
	ADD CONSTRAINT controlMax CHECK (stoc_cantidad <= stoc_maximo)

