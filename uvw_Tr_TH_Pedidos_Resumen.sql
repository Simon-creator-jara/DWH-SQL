USE Staging
GO

CREATE OR ALTER VIEW dbo.uvw_Tr_TH_Pedidos_Resumen

AS

SELECT D.[CodPedido]
      ,D.[CodCliente]
      ,D.[CodEmpleado]
      ,D.[CodDespachador]
      ,D.[CodTiempo]
      ,D.[CodGeografia]
	  ,MAX(P.Flete) AS Flete
	  ,SUM(D.[_Vlr_Bruto]) AS VlrBruto
      ,SUM(D.[_Vlr_Neto]) AS VlrNeto
	  ,SUM(D.[_Vlr_Dscto]) AS VlrDcto
      ,AVG(D.[_Vlr_Neto]) AS PromedioVta
      ,AVG(D.[Cantidad]) AS PromedioCantidad
      ,D.[BI_Control_Extraccion]
      ,GETDATE() AS BI_Control_Transformacion
 
 FROM [dbo].[uvw_Tr_TH_Pedidos_Detalle] D LEFT OUTER JOIN
                         Ex_Pedidos P ON P.IdPedido = D.CodPedido

	GROUP BY D.[CodPedido]
      ,D.[CodCliente]
      ,D.[CodEmpleado]
      ,D.[CodDespachador]
      ,D.[CodTiempo]
      ,D.[CodGeografia]
	  ,P.Flete
	  ,D.[BI_Control_Extraccion]

GO