-- Trigger para actualizar el stock de productos al crear un pedido
CREATE TRIGGER trg_ActualizarStockPedidoProducto
ON Pedido_Producto
AFTER INSERT
AS
BEGIN
    DECLARE @productoId INT, @cantidad INT;

    -- Obtener el ID del producto y la cantidad del pedido insertado
    SELECT @productoId = producto_fk, @cantidad = cantidad
    FROM inserted;

    -- Actualizar el stock del producto
    UPDATE Producto
    SET stock = stock - @cantidad
    WHERE id = @productoId;

    -- Asegurar que el stock no sea negativo
    IF EXISTS (SELECT 1 FROM Producto WHERE id = @productoId AND stock < 0)
    BEGIN
        PRINT 'Error: El stock del producto no puede ser negativo';
        ROLLBACK TRANSACTION;
    END
END;
GO
  
-- Trigger para actualizar el stock de productos al crear un pedido en la tabla Pedido_Oferta
CREATE TRIGGER trg_ActualizarStockPedidoOferta
ON Pedido_Oferta
AFTER INSERT
AS
BEGIN
    DECLARE @ofertaId INT, @productoId INT, @cantidad INT;

    -- Obtener el ID de la oferta, ID del producto y la cantidad del pedido insertado
    SELECT @ofertaId = oferta_fk, @productoId = producto_fk, @cantidad = cantidad
    FROM inserted;

    -- Actualizar el stock del producto
    UPDATE Producto
    SET stock = stock - @cantidad
    WHERE id = @productoId;

    -- Asegurar que el stock no sea negativo
    IF EXISTS (SELECT 1 FROM Producto WHERE id = @productoId AND stock < 0)
    BEGIN
        PRINT 'Error: El stock del producto no puede ser negativo';
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Trigger para actualizar el estado del pedido a 'En Proceso' al crearse un pedido
CREATE TRIGGER trg_ActualizarEstadoPedidoEnProceso
ON Pedido
AFTER INSERT
AS
BEGIN
    -- Actualizar el estado de los pedidos nuevos a 'En Proceso'
    UPDATE Pedido
    SET estado = 'En Proceso'
    WHERE id IN (SELECT id FROM inserted);
END;
GO

-- Trigger para actualizar el estado del pedido a 'Pagado' al realizarse un pago
CREATE TRIGGER trg_ActualizarEstadoPedidoPagado
ON Pago
AFTER INSERT
AS
BEGIN
    DECLARE @pedidoId INT;

    -- Obtener el ID del pedido relacionado con el pago
    SELECT @pedidoId = p.pedido_fk
    FROM inserted i
    JOIN Factura f ON i.factura_fk = f.id
    JOIN Pedido p ON f.pedido_fk = p.id;

    -- Actualizar el estado del pedido a 'Pagado'
    UPDATE Pedido
    SET estado = 'Pagado'
    WHERE id = @pedidoId;
END;
GO

-- Trigger para actualizar el estado de la factura al realizarse un pago
CREATE TRIGGER trg_ActualizarEstadoFactura
ON Pago
AFTER INSERT
AS
BEGIN
    DECLARE @facturaId INT;

    -- Obtener el ID de la factura relacionada con el pago
    SELECT @facturaId = factura_fk
    FROM inserted;

    -- Actualizar el estado de la factura a 'Pagada'
    UPDATE Factura
    SET estado = 1 -- 1 para pagado
    WHERE id = @facturaId;
END;
GO

-- Trigger para cambiar el estado de la mesa a 0 (no disponible) cuando se crea un pedido
CREATE TRIGGER trg_ActualizarEstadoMesa
ON Pedido
AFTER INSERT
AS
BEGIN
    DECLARE @mesaId INT;

    -- Obtener el ID de la mesa asociada al pedido
    SELECT @mesaId = mesa_fk
    FROM inserted
    WHERE mesa_fk IS NOT NULL;

    -- Actualizar la mesa para marcarla como no disponible (0)
    IF @mesaId IS NOT NULL
    BEGIN
        UPDATE Mesa
        SET disponible = 0
        WHERE id = @mesaId;
    END
END;
GO
