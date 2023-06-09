USE Staging
GO

CREATE OR ALTER PROC dbo.usp_TL_Dim_Geografia

AS 

/*
Pasos:
1. Creación o validación del registro dummy (Completitud)
2. Actualización de datos exitentes (Join) entre Staging y Datamart
3. Inserción de datoss nuevos (Left Join) entre Staging y Datamart
4. Vista Contiene las transformaciones
orden del 4 -1
*/

--Paso 1. Creación o validación del registro dummy (Completitud)
IF NOT EXISTS (SELECT IdGeografia FROM [Datamart_EIA].dbo.Dim_Geografia
					WHERE IdGeografia=-99)
BEGIN 
	SET IDENTITY_INSERT [Datamart_EIA].dbo.Dim_Geografia ON
	

		INSERT INTO [Datamart_EIA].dbo.[Dim_Geografia]
				   (IdGeografia,
				   [CodGeografia]
					,[CodCiudad]
					,[Ciudad_Nombre]
					,[CodRegion]
					,[Region_Nombre]
					,[CodPais]
					,[Pais_Nombre]
					,[BI_Control_Extraccion]
					,[BI_Control_Transformacion])
			 VALUES
				   (-99,
				   -99
				   ,-99
				   ,'_Sin Ciudad'
				   ,-99
				   ,'_Sin Region'
				   ,-99
				   ,'_Sin Pais'
				   ,GETDATE()
				   ,GETDATE())
	SET IDENTITY_INSERT [Datamart_EIA].[dbo].[Dim_Geografia] OFF 

END




--Paso 2. Actualización de datos exitentes (Join) entre Staging y Datamart

--Paso 3 --> Inserción de datoss nuevos (Left Join) entre Staging y Datamart
-- En este paso y en tiempo de desarrollo se crea la dimension en el datamart 




INSERT INTO [Datamart_EIA].[dbo].[Dim_Geografia]
           ([CodGeografia]
			,[CodCiudad]
			,[Ciudad_Nombre]
			,[CodRegion]
			,[Region_Nombre]
			,[CodPais]
			,[Pais_Nombre]
			,[BI_Control_Extraccion]
			,[BI_Control_Transformacion])


(SELECT stg.[CodGeografia]
      ,stg.[CodCiudad]
      ,stg.[Ciudad_Nombre]
      ,stg.[CodRegion]
      ,stg.[Region_Nombre]
      ,stg.[CodPais]
      ,stg.[Pais_Nombre]
      ,stg.[BI_Control_Extraccion]
      ,stg.[BI_Control_Transformacion]
	  --INTO [Datamart_EIA].dbo.Dim_Geografia
  FROM [dbo].[uvw_Tr_Dim_Geografia] AS stg 
  LEFT JOIN [Datamart_EIA].dbo.Dim_Geografia AS Dtm
		ON stg.CodGeografia = Dtm.CodGeografia
		WHERE Dtm.CodGeografia IS NULL)

GO




GO