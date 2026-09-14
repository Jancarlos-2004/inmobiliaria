-- Base de datos para Inmobiliaria UTS (MySQL)
-- Creacion de tablas y restricciones

CREATE TABLE IF NOT EXISTS roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS ciudades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS tipos_propiedades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS caracteristicas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    correo VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(64) NOT NULL,
    password_salt VARCHAR(32) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'activo' -- activo, inactivo
);

-- Relacion Muchos a Muchos: usuarios_roles
CREATE TABLE IF NOT EXISTS usuarios_roles (
    id_usuario INT NOT NULL,
    id_rol INT NOT NULL,
    PRIMARY KEY (id_usuario, id_rol),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (id_rol) REFERENCES roles(id) ON DELETE CASCADE
);

-- Relacion Uno a Uno (1:1): usuarios y perfiles
CREATE TABLE IF NOT EXISTS perfiles (
    id_usuario INT PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    documento VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    direccion VARCHAR(200),
    foto VARCHAR(255),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Relacion Uno a Muchos (1:N): propiedades publicadas por agentes
CREATE TABLE IF NOT EXISTS propiedades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    direccion VARCHAR(200) NOT NULL,
    precio DECIMAL(12,2) NOT NULL,
    matricula_inmobiliaria VARCHAR(50) NOT NULL UNIQUE,
    id_ciudad INT NOT NULL,
    id_tipo INT NOT NULL,
    id_agente INT NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'disponible', -- disponible, arrendado, vendido, inactivo (baja logica)
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_ciudad) REFERENCES ciudades(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_tipo) REFERENCES tipos_propiedades(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_agente) REFERENCES usuarios(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Relacion Uno a Muchos (1:N): imagenes de una propiedad
CREATE TABLE IF NOT EXISTS imagenes_propiedades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    url_imagen VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_propiedad) REFERENCES propiedades(id) ON DELETE CASCADE
);

-- Relacion Muchos a Muchos (N:M): propiedades y caracteristicas
CREATE TABLE IF NOT EXISTS propiedades_caracteristicas (
    id_propiedad INT NOT NULL,
    id_caracteristica INT NOT NULL,
    PRIMARY KEY (id_propiedad, id_caracteristica),
    FOREIGN KEY (id_propiedad) REFERENCES propiedades(id) ON DELETE CASCADE,
    FOREIGN KEY (id_caracteristica) REFERENCES caracteristicas(id) ON DELETE CASCADE
);

-- Relacion Uno a Muchos (1:N): Citas de clientes para propiedades
CREATE TABLE IF NOT EXISTS citas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    id_cliente INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'pendiente', -- pendiente, aceptada, cancelada, completada
    notas TEXT,
    UNIQUE (id_propiedad, fecha_hora), -- Impedir dos visitas al mismo tiempo en la misma propiedad
    FOREIGN KEY (id_propiedad) REFERENCES propiedades(id) ON DELETE CASCADE,
    FOREIGN KEY (id_cliente) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Relacion Uno a Muchos (1:N): Solicitudes de compra/arriendo
CREATE TABLE IF NOT EXISTS solicitudes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    id_cliente INT NOT NULL,
    tipo_solicitud VARCHAR(20) NOT NULL, -- compra, arriendo
    estado VARCHAR(20) NOT NULL DEFAULT 'pendiente', -- pendiente, aprobada, rechazada
    fecha_solicitud TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_propiedad) REFERENCES propiedades(id) ON DELETE CASCADE,
    FOREIGN KEY (id_cliente) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Relacion Uno a Muchos (1:N): Documentos adjuntos a una solicitud
CREATE TABLE IF NOT EXISTS documentos_solicitudes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_solicitud INT NOT NULL,
    nombre_archivo VARCHAR(150) NOT NULL,
    ruta_archivo VARCHAR(255) NOT NULL,
    tipo_documento VARCHAR(50) NOT NULL, -- identificacion, ingresos, contrato, otro
    FOREIGN KEY (id_solicitud) REFERENCES solicitudes(id) ON DELETE CASCADE
);

-- Relacion Muchos a Muchos (N:M): Favoritos de clientes
CREATE TABLE IF NOT EXISTS favoritos (
    id_usuario INT NOT NULL,
    id_propiedad INT NOT NULL,
    PRIMARY KEY (id_usuario, id_propiedad),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (id_propiedad) REFERENCES propiedades(id) ON DELETE CASCADE
);

-- Auditoria de la aplicacion
CREATE TABLE IF NOT EXISTS auditoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT, -- NULL para acciones de visitantes (login fallido)
    accion VARCHAR(100) NOT NULL,
    tabla_afectada VARCHAR(50),
    registro_id INT,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    detalles TEXT,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE SET NULL
);
