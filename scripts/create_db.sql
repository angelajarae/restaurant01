-- Drop the database if it exists
IF DB_ID('restaurant01') IS NOT NULL
BEGIN
    DROP DATABASE restaurant01;
END;

-- Create the database again
CREATE DATABASE restaurant01;
GO

-- Use the newly created database
USE restaurant01;
GO

-- Tabla de Roles
CREATE TABLE Roles (
    id INT PRIMARY KEY,
    nombre VARCHAR(50)
);

-- Tabla Persona
CREATE TABLE Persona (
    id INT PRIMARY KEY,
    nombres VARCHAR(255),
    apellidos VARCHAR(255),
    dni VARCHAR(50)
);

-- Tabla Usuario
CREATE TABLE Usuario (
    id INT PRIMARY KEY,
    correo VARCHAR(255),
    contrasena VARCHAR(255),
    persona INT,
    rol INT,
    FOREIGN KEY (persona) REFERENCES Persona(id),
    FOREIGN KEY (rol) REFERENCES Roles(id)
);

-- Tabla Cajero
CREATE TABLE Cajero (
    id INT PRIMARY KEY,
    usuario INT,
    FOREIGN KEY (usuario) REFERENCES Usuario(id)
);

-- Tabla Cliente
CREATE TABLE Cliente (
    id INT PRIMARY KEY,
    usuario INT,
    FOREIGN KEY (usuario) REFERENCES Usuario(id)
);

-- Tabla Mozo
CREATE TABLE Mozo (
    id INT PRIMARY KEY,
    usuario INT,
    FOREIGN KEY (usuario) REFERENCES Usuario(id)
);

-- Tabla Metodo de Pago
CREATE TABLE Metodo_Pago (
    id INT PRIMARY KEY,
    nombre VARCHAR(255)
);

-- Tabla Mesa con referencia al mozo actual
CREATE TABLE Mesa (
    id INT PRIMARY KEY,
    capacidad INT,
    disponible INT,
    mozo INT,
    FOREIGN KEY (mozo) REFERENCES Mozo(id)
);

-- Tabla Pedido con estado
CREATE TABLE Pedido (
    id INT PRIMARY KEY,
    mesa INT,
    monto FLOAT,
    estado VARCHAR(50),
    fecha DATETIME,
    FOREIGN KEY (mesa) REFERENCES Mesa(id)
);

-- Tabla para Producto y Categoria de Producto
CREATE TABLE Categoria (
    id INT PRIMARY KEY,
    nombre VARCHAR(255)
);

CREATE TABLE Producto (
    id INT PRIMARY KEY,
    nombre VARCHAR(255),
    descripcion VARCHAR(255),
    stock INT,
    precio FLOAT,
    categoria INT,
    FOREIGN KEY (categoria) REFERENCES Categoria(id)
);

-- Tabla Oferta
CREATE TABLE Oferta (
    id INT PRIMARY KEY,
    nombre VARCHAR(255),
    precio FLOAT,
    precio_base FLOAT,
    porcentaje_descuento FLOAT,
    fecha_inicio DATETIME,
    fecha_fin DATETIME
);

-- Tabla de relación Oferta-Producto
CREATE TABLE Oferta_Producto (
    id INT PRIMARY KEY,
    oferta INT,
    producto INT,
    cantidad INT,
    FOREIGN KEY (oferta) REFERENCES Oferta(id),
    FOREIGN KEY (producto) REFERENCES Producto(id)
);

-- Tablas de Relación de Pedido-Producto y Pedido-Oferta
CREATE TABLE Pedido_Producto (
    id INT PRIMARY KEY,
    producto INT,
    cantidad INT,
    precio FLOAT,
    pedido INT,
    FOREIGN KEY (producto) REFERENCES Producto(id),
    FOREIGN KEY (pedido) REFERENCES Pedido(id)
);

CREATE TABLE Pedido_Oferta (
    id INT PRIMARY KEY,
    oferta INT,
    cantidad INT,
    precio FLOAT,
    descuento FLOAT,
    pedido INT,
    FOREIGN KEY (oferta) REFERENCES Oferta(id),
    FOREIGN KEY (pedido) REFERENCES Pedido(id)
);

-- Tabla Factura con relación al cliente y al cajero
CREATE TABLE Factura (
    id INT PRIMARY KEY,
    pedido INT,
    cliente INT,
    monto_final FLOAT,
    estado INT,
    descuento FLOAT,
    cajero INT,
    FOREIGN KEY (pedido) REFERENCES Pedido(id),
    FOREIGN KEY (cliente) REFERENCES Cliente(id),
    FOREIGN KEY (cajero) REFERENCES Cajero(id)
);

-- Tabla Pago
CREATE TABLE Pago (
    id INT PRIMARY KEY,
    factura INT,
    fecha DATETIME,
    metodo_pago INT,
    monto_total FLOAT,
    monto_devuelto FLOAT,
    FOREIGN KEY (factura) REFERENCES Factura(id),
    FOREIGN KEY (metodo_pago) REFERENCES Metodo_Pago(id)
);

-- Tabla Interacciones (registro de interacciones entre cliente y mozo)
CREATE TABLE Interaccion (
    id INT PRIMARY KEY,
    cliente INT,
    mozo INT,
    tipo_interaccion VARCHAR(255),
    fecha DATETIME,
    FOREIGN KEY (cliente) REFERENCES Cliente(id),
    FOREIGN KEY (mozo) REFERENCES Mozo(id)
);

-- Tabla Entrega de Pedidos (registro de entrega de pedido a la mesa)
CREATE TABLE Entrega_Pedido (
    id INT PRIMARY KEY,
    pedido INT,
    mozo INT,
    fecha DATETIME,
    FOREIGN KEY (pedido) REFERENCES Pedido(id),
    FOREIGN KEY (mozo) REFERENCES Mozo(id)
);
