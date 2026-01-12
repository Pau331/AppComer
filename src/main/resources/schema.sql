SET SCHEMA APP;

DROP TABLE likes;
DROP TABLE receta_caracteristica;
DROP TABLE comentarios;
DROP TABLE mensajes_privados;
DROP TABLE notificaciones;
DROP TABLE amigos;
DROP TABLE recetas;
DROP TABLE caracteristicas;
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

-- AMISTAD CON SOLICITUDES: Pendiente hasta que el destinatario acepte
CREATE TABLE amigos (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    usuario_id INT NOT NULL,
    amigo_id INT NOT NULL,

    -- Pendiente: solicitud enviada | Aceptado: confirmado por ambos
    estado VARCHAR(10) DEFAULT 'Pendiente' NOT NULL CHECK (estado IN ('Pendiente','Aceptado')),

    -- usuario_id = quien envía la solicitud
    -- amigo_id = quien la recibe
    CONSTRAINT uq_amigos UNIQUE (usuario_id, amigo_id),

    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (amigo_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE notificaciones (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    usuario_destino_id INT,
    usuario_origen_id INT,
    tipo VARCHAR(30) CHECK (tipo IN ('Solicitud de amistad','Like en receta','Comentario en receta','Eres amigo de...')),    
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
INSERT INTO usuarios (username, email, password, biografia, isAdmin, foto_perfil) VALUES
('juan123', 'juan@mail.com', 'pass123', 'Amante de la cocina italiana', FALSE, 'juan.jpg'),
('maria456', 'maria@mail.com', 'pass456', 'Me encanta hornear', FALSE, 'maria.jpg'),
('admin', 'admin@mail.com', 'adminpass', 'Administrador del sitio', TRUE, 'default-avatar.jpg'),
('pedro789', 'pedro@mail.com', 'pass789', 'Fan de la comida saludable', FALSE, 'pedro.jpg'),
('laura321', 'laura@mail.com', 'pass321', 'Me gusta cocinar vegano', FALSE, 'laura.jpg');

INSERT INTO caracteristicas (nombre) VALUES
('Vegetariano'),
('Vegano'),
('Sin gluten'),
('Healthy');

INSERT INTO recetas (usuario_id, titulo, pasos, tiempo_preparacion, dificultad, foto) VALUES
(1, 'Pasta al pesto', 'Cocer la pasta. Preparar el pesto. Mezclar y servir.', 25, 'Facil', 'pasta_pesto.jpg'),
(2, 'Tarta de manzana', 'Preparar masa. Hornear manzanas. Montar y hornear.', 60, 'Media', 'tarta_manzana.jpg'),
(1, 'Ensalada vegana', 'Cortar verduras. Mezclar con aderezo. Servir.', 15, 'Facil', 'ensalada_vegana.jpg'),
(2, 'Bizcocho de chocolate', 'Mezclar ingredientes. Hornear. Dejar enfriar.', 45, 'Media', 'brownie.jpg'), 
(4, 'Smoothie verde', 'Licuar espinaca, plátano y manzana.', 10, 'Facil', 'batido_verde_v2.jpg');


INSERT INTO receta_caracteristica (receta_id, caracteristica_id) VALUES
(1, 1),
(2, 4),
(3, 2),
(3, 4),
(4, 4),
(5, 2), 
(5, 4);

INSERT INTO amigos (usuario_id, amigo_id, estado) VALUES
(1, 2, 'Aceptado'),
(1, 4, 'Aceptado'),
(2, 4, 'Aceptado');



INSERT INTO notificaciones (usuario_destino_id, usuario_origen_id, tipo, leido) VALUES
-- Para María (id=2): solicitud de amistad de Juan (no leída) y like de Pedro
(2, 1, 'Solicitud de amistad', FALSE),
(2, 4, 'Like en receta', FALSE),
-- Para Juan (id=1): varios eventos, algunos no leídos
(1, 2, 'Like en receta', TRUE),
(1, 4, 'Solicitud de amistad', FALSE),
(1, 5, 'Comentario en receta', FALSE),
(1, 2, 'Like en receta', FALSE),
(1, 5, 'Like en receta', FALSE),
-- Para otros usuarios
(3, 1, 'Comentario en receta', FALSE);

INSERT INTO comentarios (receta_id, usuario_id, texto) VALUES
(1, 2, '¡Me encantó esta receta!'),
(3, 1, 'Muy fresca y saludable'),
(4, 1, 'Delicioso bizcocho, María!'),
(5, 1, 'Perfecto para el desayuno');

INSERT INTO mensajes_privados (remitente_id, destinatario_id, texto, leido) VALUES
(1, 2, 'Hola Maria, ¿quieres probar mi nueva receta?', TRUE),
(2, 1, '¡Claro, envíamela!', FALSE);

-- Insertar likes de usuarios en recetas
INSERT INTO likes (usuario_id, receta_id) VALUES
(1, 2),  
(2, 1), 
(3, 1),  
(1, 3),
(1, 4),  
(4, 1);
