-- Drop the database if it exists
IF DB_ID('restaurante_db') IS NOT NULL
BEGIN
    DROP DATABASE restaurante_db;
END;

-- Create the database again
CREATE DATABASE restaurante_db;
GO

-- Use the newly created database
USE restaurante_db;
GO

-- Crear tabla Usuario
CREATE TABLE Usuario (
    id INT PRIMARY KEY,
    nombres VARCHAR(255) NOT NULL,
    apellidos VARCHAR(255) NOT NULL,
    correo VARCHAR(255) UNIQUE NOT NULL,
    contraseña VARCHAR(255) NOT NULL
);

-- Crear tabla Rol
CREATE TABLE Rol (
    id INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);

-- Crear tabla Trabajador
CREATE TABLE Trabajador (
    id INT PRIMARY KEY,
    usuario_fk INT NOT NULL,
    rol_fk INT NOT NULL,
    FOREIGN KEY (usuario_fk) REFERENCES Usuario(id) ON DELETE CASCADE,
    FOREIGN KEY (rol_fk) REFERENCES Rol(id) ON DELETE SET NULL
);

-- Crear tabla Cajero
CREATE TABLE Cajero (
    id INT PRIMARY KEY,
    trabajador_fk INT NOT NULL,
    FOREIGN KEY (trabajador_fk) REFERENCES Trabajador(id) ON DELETE CASCADE
);

-- Crear tabla Gestor_de_Inventario
CREATE TABLE Gestor_de_Inventario (
    id INT PRIMARY KEY,
    trabajador_fk INT NOT NULL,
    FOREIGN KEY (trabajador_fk) REFERENCES Trabajador(id) ON DELETE CASCADE
);

-- Crear tabla Mozo
CREATE TABLE Mozo (
    id INT PRIMARY KEY,
    trabajador_fk INT NOT NULL,
    FOREIGN KEY (trabajador_fk) REFERENCES Trabajador(id) ON DELETE CASCADE
);

-- Crear tabla Mesa
CREATE TABLE Mesa (
    id INT PRIMARY KEY,
    capacidad INT NOT NULL CHECK (capacidad > 0),  -- Capacity must be greater than 0
    disponible BIT NOT NULL DEFAULT 1,  -- Default to available
    mozo_fk INT,
    FOREIGN KEY (mozo_fk) REFERENCES Mozo(id) ON DELETE SET NULL
);

-- Crear tabla Categoria
CREATE TABLE Categoria (
    id INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);

-- Crear tabla Producto
CREATE TABLE Producto (
    id INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion VARCHAR(255),
    stock INT NOT NULL CHECK (stock >= 0),  -- Ensure stock is non-negative
    precio FLOAT NOT NULL CHECK (precio >= 0),  -- Ensure price is non-negative
    categoria_fk INT,
    gestor_de_inventario_fk INT,
    FOREIGN KEY (categoria_fk) REFERENCES Categoria(id) ON DELETE SET NULL,
    FOREIGN KEY (gestor_de_inventario_fk) REFERENCES Gestor_de_Inventario(id) ON DELETE SET NULL
);

-- Crear tabla Oferta
CREATE TABLE Oferta (
    id INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    precio FLOAT NOT NULL CHECK (precio >= 0),  -- Ensure base price is non-negative
    descuento FLOAT CHECK (descuento >= 0 AND descuento <= 1),  -- Discount percentage between 0 and 100
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL,
    CHECK (fecha_inicio < fecha_fin)  -- Ensure the start date is before the end date
);

-- Crear tabla Oferta_Producto
CREATE TABLE Oferta_Producto (
    id INT PRIMARY KEY,
    oferta_fk INT NOT NULL,
    producto_fk INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),  -- Quantity must be positive
    FOREIGN KEY (oferta_fk) REFERENCES Oferta(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_fk) REFERENCES Producto(id) ON DELETE CASCADE
);

-- Crear tabla Pedido
CREATE TABLE Pedido (
    id INT PRIMARY KEY,
    mesa_fk INT,
    precio FLOAT NOT NULL CHECK (precio >= 0),  -- Ensure precio is non-negative
    estado VARCHAR(50) NOT NULL DEFAULT 'Pendiente' CHECK (estado IN ('Pendiente', 'Entregado', 'Pagado')),  -- Default state to 'Pendiente' with check constraint
    fecha DATETIME NOT NULL DEFAULT GETDATE(),  -- Default to the current date and time
    FOREIGN KEY (mesa_fk) REFERENCES Mesa(id) ON DELETE SET NULL
);

-- Crear tabla Pedido_Producto
CREATE TABLE Pedido_Producto (
    id INT PRIMARY KEY,
    producto_fk INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),  -- Quantity must be positive
    precio FLOAT NOT NULL CHECK (precio >= 0),  -- Ensure price is non-negative
    descuento FLOAT CHECK (descuento >= 0 AND descuento <= 1),  -- Discount between 0 and 100
    pedido_fk INT NOT NULL,
    FOREIGN KEY (producto_fk) REFERENCES Producto(id) ON DELETE CASCADE,
    FOREIGN KEY (pedido_fk) REFERENCES Pedido(id) ON DELETE CASCADE
);

-- Crear tabla Pedido_Oferta
CREATE TABLE Pedido_Oferta (
    id INT PRIMARY KEY,
    oferta_fk INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),  -- Quantity must be positive
    precio FLOAT NOT NULL CHECK (precio >= 0),  -- Ensure price is non-negative
    descuento FLOAT CHECK (descuento >= 0 AND descuento <= 1),  -- Discount between 0 and 100
    pedido_fk INT NOT NULL,
    FOREIGN KEY (oferta_fk) REFERENCES Oferta(id) ON DELETE CASCADE,
    FOREIGN KEY (pedido_fk) REFERENCES Pedido(id) ON DELETE CASCADE
);

-- Crear tabla Factura
CREATE TABLE Factura (
    id INT PRIMARY KEY,
    pedido_fk INT NOT NULL,
    monto_final FLOAT NOT NULL CHECK (monto_final >= 0),  -- Ensure final amount is non-negative
    estado BIT NOT NULL DEFAULT 0,  -- Default to 'not paid' (0)
    descuento FLOAT CHECK (descuento >= 0 AND descuento <= 1),  -- Discount between 0 and 100
    cajero_fk INT NOT NULL,
    FOREIGN KEY (pedido_fk) REFERENCES Pedido(id) ON DELETE CASCADE,
    FOREIGN KEY (cajero_fk) REFERENCES Cajero(id) ON DELETE SET NULL
);

-- Crear tabla Pago
CREATE TABLE Pago (
    id INT PRIMARY KEY,
    factura_fk INT NOT NULL,
    fecha DATETIME NOT NULL DEFAULT GETDATE(),  -- Default to the current date and time
    metodo_pago_fk INT NOT NULL,
    monto_total FLOAT NOT NULL CHECK (monto_total >= 0),  -- Ensure total amount is non-negative
    monto_devuelto FLOAT CHECK (monto_devuelto >= 0),  -- Ensure refund is non-negative
    FOREIGN KEY (factura_fk) REFERENCES Factura(id) ON DELETE CASCADE,
    FOREIGN KEY (metodo_pago_fk) REFERENCES Metodo_Pago(id) ON DELETE SET NULL
);

-- Crear tabla Metodo_Pago
CREATE TABLE Metodo_Pago (
    id INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);