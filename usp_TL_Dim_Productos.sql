USE Staging
GO

CREATE OR ALTER PROC dbo.usp_TL_Dim_Productos

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
IF NOT EXISTS (SELECT IdProducto FROM [Datamart_EIA].dbo.Dim_Productos
					WHERE IdProducto=-99)
BEGIN 
	SET IDENTITY_INSERT [Datamart_EIA].dbo.Dim_Productos ON
	

		INSERT INTO [Datamart_EIA].dbo.Dim_Productos
				   (IdProducto
				   ,[CodProducto]
				   ,[Nombre_Producto]
				   ,[CodCategoria]
				   ,[Nombre_Categoria]
				   ,[Descontinuado]
				   ,[BI_Control_Extraccion]
				   ,[BI_Control_Transformacion])
			 VALUES
				   (-99
				   ,-99
				   ,'_Sin Nombre Producto'
				   ,-99
				   ,'_Sin Nombre Categoria'
				   ,'Inconsistente'
				   ,GETDATE()
				   ,GETDATE())
	SET IDENTITY_INSERT [Datamart_EIA].[dbo].[Dim_Productos] OFF 

END




--Paso 2. Actualización de datos exitentes (Join) entre Staging y Datamart
UPDATE Dtm
SET
	 Dtm.[CodProducto] = stg.[CodProducto]
      ,Dtm.[Nombre_Producto] = stg.[Nombre_Producto]
      ,Dtm.[CodCategoria] = stg.[CodCategoria]
      ,Dtm.[Nombre_Categoria] = stg.[Nombre_Categoria]
      ,Dtm.[Descontinuado] = stg.[Descontinuado] 
      ,Dtm.[BI_Control_Extraccion] = stg.[BI_Control_Extraccion]
      ,Dtm.[BI_Control_Transformacion] = stg.[BI_Control_Transformacion]
	  --INTO [Datamart_EIA].dbo.Dim_Productos
	  -- La sentencia INTO en tiempo de desarrollo me permite crear 
	  -- la dimensión en tiempo de desarrollo
  FROM [dbo].[uvw_Tr_Dim_Productos] AS stg
	INNER JOIN [Datamart_EIA].dbo.Dim_Productos AS Dtm
		ON stg.CodProducto = Dtm.CodProducto

--Paso 3 --> Inserción de datoss nuevos (Left Join) entre Staging y Datamart
-- En este paso y en tiempo de desarrollo se crea la dimension en el datamart 




INSERT INTO [Datamart_EIA].[dbo].[Dim_Productos]
           ([CodProducto]
           ,[Nombre_Producto]
           ,[CodCategoria]
           ,[Nombre_Categoria]
           ,[Descontinuado]
           ,[BI_Control_Extraccion]
           ,[BI_Control_Transformacion])


(SELECT stg.[CodProducto]
      ,stg.[Nombre_Producto]
      ,stg.[CodCategoria]
      ,stg.[Nombre_Categoria]
      ,stg.[Descontinuado]
      ,stg.[BI_Control_Extraccion]
      ,stg.[BI_Control_Transformacion]
	  --INTO [Datamart_EIA].dbo.Dim_Productos
	  -- La sentencia INTO en tiempo de desarrollo me permite crear 
	  -- la dimensión en tiempo de desarrollo
  FROM [dbo].[uvw_Tr_Dim_Productos] AS stg
	LEFT JOIN [Datamart_EIA].dbo.Dim_Productos AS Dtm
		ON stg.CodProducto = Dtm.CodProducto
		WHERE Dtm.CodProducto IS NULL)

GO



GO
