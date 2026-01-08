SET SCHEMA APP;

-- Eliminar tablas en orden correcto (para evitar violación de FK)
-- En Derby, si la tabla no existe, el DROP fallará; en Java se puede capturar la excepción
DROP TABLE mensajes_privados;
DROP TABLE comentarios;
DROP TABLE notificaciones;
DROP TABLE amigos;
DROP TABLE receta_caracteristica;
DROP TABLE caracteristicas;
DROP TABLE recetas;
DROP TABLE usuarios;

-- Crear tablas
CREATE TABLE usuarios (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    foto_perfil VARCHAR(255),
    biografia VARCHAR(1000),
    isAdmin BOOLEAN DEFAULT FALSE
);

CREATE TABLE recetas (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    usuario_id INT,
    titulo VARCHAR(100) NOT NULL,
    pasos CLOB NOT NULL,
    tiempo_preparacion INT,
    dificultad VARCHAR(10) CHECK (dificultad IN ('Facil','Media','Dificil')),
    foto VARCHAR(255),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE likes (
    usuario_id INT,
    receta_id INT,
    PRIMARY KEY (usuario_id, receta_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (receta_id) REFERENCES recetas(id) ON DELETE CASCADE
);


CREATE TABLE caracteristicas (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    nombre VARCHAR(20) CHECK (nombre IN ('Vegetariano','Vegano','Sin gluten','Healthy')) NOT NULL
);

CREATE TABLE receta_caracteristica (
    receta_id INT,
    caracteristica_id INT,
    PRIMARY KEY(receta_id, caracteristica_id),
    FOREIGN KEY (receta_id) REFERENCES recetas(id) ON DELETE CASCADE,
    FOREIGN KEY (caracteristica_id) REFERENCES caracteristicas(id) ON DELETE CASCADE
);

CREATE TABLE amigos (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    usuario_id INT,
    amigo_id INT,
    estado VARCHAR(10) DEFAULT 'Pendiente' CHECK (estado IN ('Pendiente','Aceptado','Rechazado')),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (amigo_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE notificaciones (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    usuario_destino_id INT,
    usuario_origen_id INT,
    tipo VARCHAR(30) CHECK (tipo IN ('Solicitud de amistad','Like en receta','Comentario en receta')),    
    leido BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (usuario_destino_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_origen_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE comentarios (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    receta_id INT,
    usuario_id INT,
    texto CLOB NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (receta_id) REFERENCES recetas(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE mensajes_privados (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    remitente_id INT,
    destinatario_id INT,
    texto CLOB NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    leido BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (remitente_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (destinatario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Insertar datos de prueba
INSERT INTO usuarios (username, email, password, biografia, isAdmin) VALUES
('juan123', 'juan@mail.com', 'pass123', 'Amante de la cocina italiana', FALSE),
('maria456', 'maria@mail.com', 'pass456', 'Me encanta hornear', FALSE),
('admin', 'admin@mail.com', 'adminpass', 'Administrador del sitio', TRUE);

INSERT INTO caracteristicas (nombre) VALUES
('Vegetariano'),
('Vegano'),
('Sin gluten'),
('Healthy');

INSERT INTO recetas (usuario_id, titulo, pasos, tiempo_preparacion, dificultad, likes) VALUES
(1, 'Pasta al pesto', 'Cocer la pasta. Preparar el pesto. Mezclar y servir.', 25, 'Facil', 10),
(2, 'Tarta de manzana', 'Preparar masa. Hornear manzanas. Montar y hornear.', 60, 'Media', 5),
(1, 'Ensalada vegana', 'Cortar verduras. Mezclar con aderezo. Servir.', 15, 'Facil', 8);

INSERT INTO receta_caracteristica (receta_id, caracteristica_id) VALUES
(1, 1),
(2, 4),
(3, 2),
(3, 4);

INSERT INTO amigos (usuario_id, amigo_id, estado) VALUES
(1, 2, 'Aceptado'),
(2, 3, 'Pendiente');

INSERT INTO notificaciones (usuario_destino_id, usuario_origen_id, tipo, leido) VALUES
(2, 1, 'Solicitud de amistad', FALSE),
(1, 2, 'Like en receta', TRUE),
(3, 1, 'Comentario en receta', FALSE);

INSERT INTO comentarios (receta_id, usuario_id, texto) VALUES
(1, 2, '¡Me encantó esta receta!'),
(3, 1, 'Muy fresca y saludable');

INSERT INTO mensajes_privados (remitente_id, destinatario_id, texto, leido) VALUES
(1, 2, 'Hola Maria, ¿quieres probar mi nueva receta?', TRUE),
(2, 1, '¡Claro, envíamela!', FALSE);
