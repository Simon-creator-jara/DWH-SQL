USE Staging 
GO

CREATE OR ALTER PROC dbo.usp_TL_TH_Pedidos_Resumen
AS


--PASO 3: 
--Insertar Datos nuevos entre Staging y DataMart

INSERT INTO [Datamart_EIA].[dbo].[TH_Pedidos_Resumen]
           ([CodPedido]
           ,[IdCliente]
           ,[IdEmpleado]
           ,[IdDespachador]
           ,[IdTiempo]
           ,[IdGeografia]
           ,[Flete]
           ,[VlrBruto]
           ,[VlrNeto]
           ,[VlrDcto]
           ,[PromedioVta]
           ,[PromedioCantidad]
           ,[BI_Control_Extraccion]
           ,[BI_Control_Transformacion])

(SELECT Stg.[CodPedido]
      ,C.IdTercero   AS IdCliente   --Stg.[CodCliente]
      ,E.IdTercero   AS IdEmpleado --Stg.[CodEmpleado]
      ,D.IdTercero   AS IdDespachador   --Stg.[CodDespachador]
      ,T.IdTiempo       --Stg.[CodTiempo]
      ,G.IdGeografia    --Stg.[CodGeografia]
	  ,Stg.Flete
    ,Stg.[VlrBruto]
    ,Stg.[VlrNeto]
    ,Stg.[VlrDcto]
    ,Stg.[PromedioVta]
	,Stg.[PromedioCantidad]
      ,Stg.[BI_Control_Extraccion]
      ,Stg.[BI_Control_Transformacion]
	  --INTO [Datamart_EIA].dbo.TH_Pedidos_Resumen

  FROM [dbo].[uvw_Tr_TH_Pedidos_Resumen] AS Stg
  --Obtenemos llaves nuevas (Las sustitutas o subrogadas)
  --Productos
	LEFT JOIN Datamart_EIA.dbo.Dim_Geografia G
		ON Stg.CodGeografia = G.CodGeografia
	LEFT JOIN Datamart_EIA.dbo.Dim_Tiempo T
		ON Stg.CodTiempo = T.Fecha
	LEFT JOIN Datamart_EIA.dbo.Dim_Terceros C
		ON Stg.CodCliente = C.CodTercero AND C.Es_Cliente = 1
	LEFT JOIN Datamart_EIA.dbo.Dim_Terceros E
		ON Stg.CodEmpleado = E.CodTercero AND E.Es_Empleado = 1
	LEFT JOIN Datamart_EIA.dbo.Dim_Terceros D
		ON Stg.CodDespachador = D.CodTercero AND D.Es_Despachador = 1

	)

GO