CREATE TABLE usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE.
    password VARCHAR(255) NOT NULL,
    foto_perfil BLOB,
    biografia TEXT,
    isAdmin BOOLEAN DEFAULT FALSE
);

CREATE TABLE recetas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT,
    titulo VARCHAR(100) NOT NULL,
    pasos TEXT NOT NULL,
    tiempo_preparacion INT,
    dificultad ENUM('Facil', 'Media', 'Dificil'),
    likes INT DEFAULT 0,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE caracteristicas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre ENUM('Vegetariano','Vegano','Sin gluten','Healthy') NOT NULL
);

CREATE TABLE receta_caracteristica (
    receta_id INT,
    caracteristica_id INT,
    PRIMARY KEY(receta_id, caracteristica_id),
    FOREIGN KEY (receta_id) REFERENCES recetas(id) ON DELETE CASCADE,
    FOREIGN KEY (caracteristica_id) REFERENCES caracteristicas(id) ON DELETE CASCADE
);

CREATE TABLE amigos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT,
    amigo_id INT,
    estado ENUM('Pendiente', 'Aceptado', 'Rechazado') DEFAULT 'Pendiente',
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (amigo_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE notificaciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_destino_id INT,
    usuario_origen_id INT,
    tipo ENUM('Solicitud de amistad', 'Like en receta', 'Comentario en receta'),    
    leido BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (usuario_destino_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_origen_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE comentarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    receta_id INT,
    usuario_id INT,
    texto TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (receta_id) REFERENCES recetas(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE mensajes_privados (
    id INT PRIMARY KEY AUTO_INCREMENT,
    remitente_id INT,
    destinatario_id INT,
    texto TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    leido BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (remitente_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (destinatario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);