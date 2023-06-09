USE Staging 
GO

CREATE OR ALTER PROC dbo.usp_TL_Dim_Terceros

AS
--PASO 1:
IF NOT EXISTS (SELECT IdTercero FROM [Datamart_EIA].[dbo].[Dim_Terceros]
					WHERE IdTercero = -99)
BEGIN
	--Apague el Identity
	SET IDENTITY_INSERT [Datamart_EIA].[dbo].[Dim_Terceros] ON 

		INSERT INTO [Datamart_EIA].[dbo].[Dim_Terceros]
           ([IdTercero]
		   ,[CodTercero]
           ,[Nombre_Tercero]
           ,[Direccion]
           ,[Telefono]
           ,[Ciudad]
           ,[Region]
           ,[Pais]
           ,[Jefe]
           ,[Es_Cliente]
           ,[Es_Empleado]
           ,[Es_Despachador]
           ,[BI_Control_Extraccion]
           ,[BI_Control_Transformacion])
			 VALUES
				   (-99
				   ,'-99'
				   ,'_Sin Nombre'
				   ,'_Sin Direccion'
				   ,'_Sin Telefono'
				   ,'_Sin Ciudad'
				   ,'_Sin Region'
				   ,'_Sin Pais'
				   ,'_Sin Jefe'
				   ,0
				   ,0
				   ,0
				   ,GETDATE()
				   ,GETDATE())
	--Encienda el Identity
	SET IDENTITY_INSERT [Datamart_EIA].[dbo].[Dim_Terceros] OFF 

END

--PASO 2:
UPDATE Dtm
   SET 
      Dtm.[Nombre_Tercero] = Stg.[Nombre_Tercero]
      ,Dtm.[Direccion] = Stg.[Direccion]
      ,Dtm.[Telefono] = Stg.[Telefono] 
      ,Dtm.[Ciudad] = Stg.[Ciudad]
      ,Dtm.[Region] = Stg.[Region]
      ,Dtm.[Pais] = Stg.[Pais]
      ,Dtm.[Jefe] = Stg.[Jefe]
      ,Dtm.[BI_Control_Extraccion] = Stg.[BI_Control_Extraccion]
      ,Dtm.[BI_Control_Transformacion] = Stg.[BI_Control_Transformacion]
	    FROM [Staging].[dbo].[uvw_Tr_Dim_Terceros] AS Stg
	INNER JOIN [Datamart_EIA].dbo.Dim_Terceros AS Dtm
		-- Comparo por llaves de negocio
		ON Stg.CodTercero = Dtm.CodTercero AND Stg.Es_Cliente = Dtm.Es_Cliente AND Stg.Es_Empleado = Dtm.Es_Empleado AND Stg.Es_Despachador = Dtm.Es_Despachador


--PASO 3:

INSERT INTO [Datamart_EIA].[dbo].[Dim_Terceros]
           ([CodTercero]
           ,[Nombre_Tercero]
           ,[Direccion]
           ,[Telefono]
           ,[Ciudad]
           ,[Region]
           ,[Pais]
           ,[Jefe]
           ,[Es_Cliente]
           ,[Es_Empleado]
           ,[Es_Despachador]
           ,[BI_Control_Extraccion]
           ,[BI_Control_Transformacion])

--PASO 4:

(SELECT Stg.[CodTercero]
      ,Stg.[Nombre_Tercero] 
      ,Stg.[Direccion]
      ,Stg.[Telefono]
      ,Stg.[Ciudad]
      ,Stg.[Region]
      ,Stg.[Pais]
      ,Stg.[Jefe]
      ,Stg.[Es_Cliente]
      ,Stg.[Es_Empleado]
      ,Stg.[Es_Despachador]
      ,Stg.[BI_Control_Extraccion]
      ,Stg.[BI_Control_Transformacion]
	  --INTO [Datamart_EIA].dbo.Dim_Terceros
  FROM [Staging].[dbo].[uvw_Tr_Dim_Terceros] as Stg
  	LEFT JOIN [Datamart_EIA].dbo.Dim_Terceros AS Dtm
		ON Stg.CodTercero = Dtm.CodTercero AND Stg.Es_Cliente = Dtm.Es_Cliente AND Stg.Es_Empleado = Dtm.Es_Empleado AND Stg.Es_Despachador = Dtm.Es_Despachador
	WHERE Dtm.CodTercero IS NULL)

GO