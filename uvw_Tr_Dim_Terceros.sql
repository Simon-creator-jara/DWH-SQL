USE Staging
GO

CREATE OR ALTER VIEW dbo.uvw_Tr_Dim_Terceros

AS

SELECT COALESCE(Ex_Clientes.[IdCliente],'-99') AS CodTercero,
		ISNULL(LTRIM(UPPER(Ex_Clientes.[Compania])),'_Sin nombre tercero') AS Nombre_Tercero, 
		ISNULL(LTRIM(UPPER(Ex_Clientes.[Direccion])),'_Sin dirección') AS Direccion,
		ISNULL(LTRIM(UPPER(Ex_Clientes.[Telefono])),'_Sin telefono') AS Telefono,
		ISNULL(LTRIM(UPPER(Ex_Clientes.[Ciudad])),'_Sin ciudad') AS Ciudad,
		ISNULL(LTRIM(UPPER(Ex_Clientes.[Region])),'_Sin region') AS Region,
		ISNULL(LTRIM(UPPER(Ex_Clientes.[Pais])),'_Sin pais') AS Pais,
		'Sin jefe' AS Jefe,
		1 AS Es_Cliente,
		0 AS Es_Empleado,
		0 AS Es_Despachador,
		Ex_Clientes.[Start_Date] as [BI_Control_Extraccion],
		GETDATE() AS BI_Control_Transformacion
  FROM [STAGING].[dbo].[Ex_Clientes] 
UNION ALL 
SELECT 
		ISNULL(CAST (e.[IdEmpleado] AS NVARCHAR(10)),'-99') AS CodTercero,
		ISNULL(LTRIM(UPPER(CONCAT(e.[Nombres],' ',e.[Apellidos]))),'_Sin nombre tercero') AS Nombre_Tercero, 
		ISNULL(LTRIM(UPPER(e.[Direccion])),'_Sin dirección') AS Direccion,
		ISNULL(LTRIM(UPPER(e.[TelCasa])),'_Sin telefono') AS Telefono,
		ISNULL(LTRIM(UPPER(e.[Ciudad])),'_Sin ciudad') AS Ciudad,
		ISNULL(LTRIM(UPPER(e.[Region])),'_Sin region') AS Region,
		ISNULL(LTRIM(UPPER(e.[Pais])),'_Sin pais') AS Pais,
		ISNULL(LTRIM(UPPER(CONCAT(j.[Nombres],' ',j.[Apellidos]))),'_Sin jefe') AS Jefe, 
		0 AS Es_Cliente,
		1 AS Es_Empleado,
		0 AS Es_Despachador,
		e.[Start_Date] as [BI_Control_Extraccion],
		GETDATE() AS BI_Control_Transformacion
  FROM [dbo].[Ex_Empleados] AS e
		LEFT JOIN [dbo].[Ex_Empleados] as j ON e.Reporta_A = j.IdEmpleado
UNION ALL
SELECT 
		ISNULL(CAST (Ex_Despachadores.[IdDespachador] AS NVARCHAR(10)),'-99') AS CodTercero,
		ISNULL(LTRIM(UPPER(Ex_Despachadores.[Compania])),'_Sin nombre tercero') AS Nombre_Tercero, 
		'_Sin dirección' AS Direccion,
		ISNULL(LTRIM(UPPER(Ex_Despachadores.[Telefono])),'_Sin telefono') AS Telefono,
		'_Sin ciudad' AS Ciudad,
		'_Sin region' AS Region,
		'_Sin pais' AS Pais,
		'_Sin jefe' AS Jefe, 
		0 AS Es_Cliente,
		0 AS Es_Empleado,
		1 AS Es_Despachador,
		Ex_Despachadores.[Start_Date] as [BI_Control_Extraccion],
		GETDATE() AS BI_Control_Transformacion
  FROM [dbo].[Ex_Despachadores]

GO