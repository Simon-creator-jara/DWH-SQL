USE Staging 
GO

CREATE OR ALTER PROC dbo.usp_TL_TH_Pedidos_Detalle

AS

/*
Pasos:
1. Control de llaves huerfanas (Existen en la tabla de hechos pero no en las dimensiones)
2. Manejo de dimensiones de tiempo
3. Inserción de datoss nuevos (Left Join) entre Staging y Datamart
4. Control deltas
5. (Vista) Contiene las transformaciones
*/
DECLARE 
--Dim_Tiempo
@datFechaIni as datetime, @datFechaFin as Datetime,
--Delta PEDIDOSDETALLE
@numCodPedido as Bigint
-- 2. Manejo de dimensiones de tiempo
-- Recupero de la vista el rango de fechas
SELECT @datFechaIni=MIN(Stg.[CodTiempo]),
	@datFechaFin=MAX(Stg.[CodTiempo])
FROM [Staging].[dbo].[uvw_Tr_TH_Pedidos_Detalle] Stg
IF @datFechaIni IS NULL
	SET @datFechaIni = GETDATE()
IF @datFechaFin IS NULL
	SET @datFechaIni = GETDATE()
EXEC [dbo].[usp_LD_DimTiempo] @datFechaIni, @datFechaFin



--3. Inserción de datoss nuevos (Left Join) entre Staging y Datamart

INSERT INTO Datamart_EIA.[dbo].[TH_Pedidos_Detalles]
           ([CodPedido]
           ,[IdCliente]
           ,[IdEmpleado]
           ,[IdDespachador]
           ,[IdProducto]
           ,[IdTiempo]
           ,[IdGeografia]
           ,[PrecioUnd]
           ,[Cantidad]
           ,[PrcDcto]
           ,[_Vlr_Bruto]
           ,[_Vlr_Dscto]
           ,[_Vlr_Neto]
           ,[BI_Control_Extraccion])
           (SELECT Stg.[CodPedido]
      ,C.IdTercero as IdCliente--Stg.[CodCliente]
      ,E.IdTercero as IdEmpleado --Stg.[CodEmpleado]
      ,D.Idtercero as IdDespachador --Stg.[CodDespachador]
      ,P.IdProducto --Stg.[CodProducto]
      ,T.IdTiempo --Stg.[CodTiempo]
      ,G.IdGeografia --Stg.[CodGeografia]
      ,Stg.[PrecioUnd]
      ,Stg.[Cantidad]
      ,Stg.[PrcDcto]
      ,Stg.[_Vlr_Bruto]
      ,Stg.[_Vlr_Dscto]
      ,Stg.[_Vlr_Neto]
      ,Stg.[BI_Control_Extraccion]
	  --INTO Datamart_EIA.dbo.TH_Pedidos_Detalles
  FROM [dbo].[uvw_Tr_TH_Pedidos_Detalle] Stg
  -- Obtenemos las llaves sustitutas o subrogadas
  -- Productos
	LEFT JOIN Datamart_EIA.dbo.Dim_Productos P
		ON Stg.CodProducto=P.CodProducto
--Geografia
	LEFT JOIN Datamart_EIA.dbo.Dim_Geografia G
		ON Stg.CodGeografia=G.CodGeografia
--Tiempo
	LEFT JOIN Datamart_EIA.dbo.Dim_Tiempo T
		ON Stg.CodTiempo=T.Fecha

--Clientes
	LEFT JOIN Datamart_EIA.dbo.Dim_Terceros C
		ON Stg.CodCliente=C.CodTercero
		AND C.Es_Cliente=1
--Empleado
	LEFT JOIN Datamart_EIA.dbo.Dim_Terceros E
		ON Stg.CodEmpleado=E.CodTercero
		AND E.Es_Empleado=1
--Despachador
	LEFT JOIN Datamart_EIA.dbo.Dim_Terceros D
		ON Stg.CodDespachador=D.CodTercero
		AND D.Es_Despachador=1
)
--¿Qué hacer para evitar rejecucion con problemas de insercion por clave?

--4. Control Deltas

SELECT @numCodPedido=MAX(CodPedido) FROM Datamart_EIA.[dbo].[TH_Pedidos_Detalles]
IF @numCodPedido IS NULL
	SET @numCodPedido=0
-- Actualizo el Delta
	UPDATE D
		SET D.ValorDelta = @numCodPedido,
		D.BI_Control_Modificacion = GETDATE()
		FROM [Staging].dbo.[ADM_Deltas] D
		WHERE D.[NombreDelta] = 'PEDIDOSDETALLE'

GO



