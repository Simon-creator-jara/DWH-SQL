SELECT 
P.*
FROM Norte.dbo.Pedidos P
	WHERE P.IdPedido > 
	(
		SELECT ValorDelta FROM Staging.dbo.ADM_Deltas
			WHERE NombreDelta = 'PEDIDOSDETALLE'
	)



SELECT 
P.*
FROM Norte.dbo.Pedidos_Detalles P
	WHERE P.IdPedido > 
	(
		SELECT ValorDelta FROM Staging.dbo.ADM_Deltas
			WHERE NombreDelta = 'PEDIDOSDETALLE'
	)
