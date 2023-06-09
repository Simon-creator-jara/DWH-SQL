USE staging
GO

CREATE OR ALTER VIEW dbo.uvw_Tr_TH_Pedidos_Detalle

AS


SELECT 
	ISNULL(Ex_Pedidos.IdPedido,-99) AS CodPedido, 
	ISNULL(CAST(Ex_Pedidos.IdCliente AS nvarchar(10)),'-99') AS CodCliente, 
	ISNULL(CAST(Ex_Pedidos.IdEmpleado AS nvarchar(10)),'-99') AS CodEmpleado, 
	ISNULL(CAST(Ex_Pedidos.IdDespachador AS nvarchar(10)),'-99') AS CodDespachador, 
	ISNULL(Ex_PedidosDetalles.IdProducto,-99) AS CodProducto,
	ISNULL(Ex_Pedidos.FPedido,'1990-12-31 00:00:00.000') AS CodTiempo, 
	CHECKSUM(
		ISNULL(LTRIM(UPPER(Ex_Pedidos.EntregaCiudad)),'_Sin Ciudad'),
		ISNULL(LTRIM(UPPER(Ex_Pedidos.EntregaRegion)),'_Sin Region'),
		ISNULL(LTRIM(UPPER(Ex_Pedidos.EntregaPais)),'_Sin Pais')
	) AS CodGeografia,
	--Metricas
	--Naturales
	ISNULL(Ex_PedidosDetalles.PrecioUnd,0) AS PrecioUnd, 
	ISNULL(Ex_PedidosDetalles.Cantidad,0) AS Cantidad, 
	ISNULL(Ex_PedidosDetalles.Descuento,0) AS PrcDcto,
	--Artificiales
	--Bruto
	ISNULL(Ex_PedidosDetalles.PrecioUnd,0) * ISNULL(Ex_PedidosDetalles.Cantidad,0) AS _Vlr_Bruto,
	--Valor descuento
	ISNULL(Ex_PedidosDetalles.PrecioUnd,0) * ISNULL(Ex_PedidosDetalles.Cantidad,0)*ISNULL(Ex_PedidosDetalles.Descuento,0) AS _Vlr_Dscto,
	--Valor neto
	ISNULL(Ex_PedidosDetalles.PrecioUnd,0) * ISNULL(Ex_PedidosDetalles.Cantidad,0)*(1-ISNULL(Ex_PedidosDetalles.Descuento,0)) AS _Vlr_Neto,

	Ex_PedidosDetalles.Start_Date As BI_Control_Extraccion
FROM     Ex_Pedidos LEFT OUTER JOIN
                  Ex_PedidosDetalles ON Ex_Pedidos.IdPedido = Ex_PedidosDetalles.IdPedido


GO