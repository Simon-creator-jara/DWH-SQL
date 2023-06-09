USE Datamart_EIA
GO
TRUNCATE TABLE [Datamart_EIA].[dbo].[TH_Pedidos_Detalles]
TRUNCATE TABLE [Datamart_EIA].[dbo].[TH_Pedidos_resumen]
DELETE FROM [Datamart_EIA].[dbo].[Dim_Geografia]
DELETE FROM [Datamart_EIA].[dbo].[Dim_Productos]
DELETE FROM [Datamart_EIA].[dbo].[Dim_Terceros]

UPDATE Stg
SET
	Stg.ValorDelta=0,
	Stg.BI_Control_Modificacion=GETDATE()
FROM Staging.dbo.ADM_Deltas Stg
	WHERE Stg.NombreDelta ='PEDIDOSDETALLE'