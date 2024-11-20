-- Crear tabla Rol
CREATE TABLE Rol (
    id INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);

-- Crear tabla Usuario
CREATE TABLE Usuario (
    id INT PRIMARY KEY,
    nombres VARCHAR(255) NOT NULL,
    apellidos VARCHAR(255) NOT NULL,
    correo VARCHAR(255) UNIQUE NOT NULL,
    contraseña VARCHAR(255) NOT NULL
);

-- Crear tabla Trabajador
CREATE TABLE Trabajador (
    id INT PRIMARY KEY,
    correo VARCHAR(255) NOT NULL,
    contraseña VARCHAR(255) NOT NULL,
    usuario_fk INT NOT NULL,
    rol_fk INT NOT NULL,
    FOREIGN KEY (usuario_fk) REFERENCES Usuario(id),
    FOREIGN KEY (rol_fk) REFERENCES Rol(id)
);

-- Crear tabla Cajero
CREATE TABLE Cajero (
    id INT PRIMARY KEY,
    trabajador_fk INT NOT NULL,
    FOREIGN KEY (trabajador_fk) REFERENCES Trabajador(id)
);

-- Crear tabla Mesa
CREATE TABLE Mesa (
    id INT PRIMARY KEY,
    capacidad INT NOT NULL,
    disponible BIT NOT NULL,
    mozo_fk INT NOT NULL,
    FOREIGN KEY (mozo_fk) REFERENCES Trabajador(id)
);

-- Crear tabla Gestor_de_Inventario
CREATE TABLE Gestor_de_Inventario (
    id INT PRIMARY KEY,
    usuario_fk INT NOT NULL,
    FOREIGN KEY (usuario_fk) REFERENCES Usuario(id)
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
    stock INT NOT NULL,
    precio FLOAT NOT NULL,
    categoria_fk INT NOT NULL,
    gestor_de_inventario_fk INT NOT NULL,
    FOREIGN KEY (categoria_fk) REFERENCES Categoria(id),
    FOREIGN KEY (gestor_de_inventario_fk) REFERENCES Gestor_de_Inventario(id)
);

-- Crear tabla Oferta
CREATE TABLE Oferta (
    id INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    precio_base FLOAT NOT NULL,
    porcentaje_descuento FLOAT,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL
);

-- Crear tabla Oferta_Producto
CREATE TABLE Oferta_Producto (
    id INT PRIMARY KEY,
    oferta_fk INT NOT NULL,
    producto_fk INT NOT NULL,
    cantidad INT NOT NULL,
    FOREIGN KEY (oferta_fk) REFERENCES Oferta(id),
    FOREIGN KEY (producto_fk) REFERENCES Producto(id)
);

-- Crear tabla Pedido
CREATE TABLE Pedido (
    id INT PRIMARY KEY,
    mesa_fk INT NOT NULL,
    monto FLOAT NOT NULL,
    estado VARCHAR(50) NOT NULL,
    fecha DATETIME NOT NULL,
    FOREIGN KEY (mesa_fk) REFERENCES Mesa(id)
);

-- Crear tabla Pedido_Producto
CREATE TABLE Pedido_Producto (
    id INT PRIMARY KEY,
    producto_fk INT NOT NULL,
    cantidad INT NOT NULL,
    precio FLOAT NOT NULL,
    descuento FLOAT,
    pedido_fk INT NOT NULL,
    FOREIGN KEY (producto_fk) REFERENCES Producto(id),
    FOREIGN KEY (pedido_fk) REFERENCES Pedido(id)
);

-- Crear tabla Pedido_Oferta
CREATE TABLE Pedido_Oferta (
    id INT PRIMARY KEY,
    oferta_fk INT NOT NULL,
    cantidad INT NOT NULL,
    precio FLOAT NOT NULL,
    descuento FLOAT,
    pedido_fk INT NOT NULL,
    FOREIGN KEY (oferta_fk) REFERENCES Oferta(id),
    FOREIGN KEY (pedido_fk) REFERENCES Pedido(id)
);

-- Crear tabla Factura
CREATE TABLE Factura (
    id INT PRIMARY KEY,
    pedido_fk INT NOT NULL,
    monto_final FLOAT NOT NULL,
    estado BIT NOT NULL,
    descuento FLOAT,
    trabajador_fk INT NOT NULL,
    FOREIGN KEY (pedido_fk) REFERENCES Pedido(id),
    FOREIGN KEY (trabajador_fk) REFERENCES Trabajador(id)
);

-- Crear tabla Metodo_Pago
CREATE TABLE Metodo_Pago (
    id INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);

-- Crear tabla Pago
CREATE TABLE Pago (
    id INT PRIMARY KEY,
    factura_fk INT NOT NULL,
    fecha DATETIME NOT NULL,
    metodo_pago_fk INT NOT NULL,
    monto_total FLOAT NOT NULL,
    monto_devuelto FLOAT,
    FOREIGN KEY (factura_fk) REFERENCES Factura(id),
    FOREIGN KEY (metodo_pago_fk) REFERENCES Metodo_Pago(id)
);