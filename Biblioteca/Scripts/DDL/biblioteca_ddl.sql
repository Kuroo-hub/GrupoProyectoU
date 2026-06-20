-- ==========================================================
-- PARTE ADMINISTRATIVA DE LA BIBLIOTECA
-- ==========================================================

-- Tabla Empleados
CREATE TABLE empleado
(
   id_empleado INT GENERATED ALWAYS AS IDENTITY,
   dui VARCHAR(10) NOT NULL,
   nombre VARCHAR(100) NOT NULL,
   apellido VARCHAR(100) NOT NULL,
   fecha_nacimiento DATE NOT NULL,
   sexo CHAR(1) NOT NULL,

   CONSTRAINT pk_empleado PRIMARY KEY (id_empleado),
   CONSTRAINT uq_dui_empleado UNIQUE(dui),
   CONSTRAINT ck_sexo_empleado CHECK(sexo IN ('M', 'F'))
);

-- Tabla Socio
CREATE TABLE socio
(
   id_socio INT GENERATED ALWAYS AS IDENTITY,
   dui VARCHAR(10) NOT NULL,
   nombre VARCHAR(100) NOT NULL,
   apellido VARCHAR(100) NOT NULL,
   fecha_nacimiento DATE NOT NULL,
   sexo CHAR(1) NOT NULL,

   CONSTRAINT pk_socio PRIMARY KEY (id_socio),
   CONSTRAINT uq_dui_socio UNIQUE(dui),
   CONSTRAINT ck_sexo_socio CHECK(sexo IN ('M', 'F'))
);

-- Tabla Prestamo
CREATE TABLE prestamo
(
   id_prestamo INT GENERATED ALWAYS AS IDENTITY,
   fecha_prestamo TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   fecha_limite DATE NOT NULL,
   fecha_devolucion TIMESTAMP,
   estado VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
   id_empleado INT NOT NULL,
   id_socio INT NOT NULL,

   CONSTRAINT pk_prestamo PRIMARY KEY(id_prestamo),
   
   CONSTRAINT ck_estado_prestamo 
   CHECK(estado IN ('ACTIVO','DEVUELTO', 'ATRASADO')),
   
   CONSTRAINT fk_id_empleado_prestamo FOREIGN KEY(id_empleado) REFERENCES 
   empleado(id_empleado) ON UPDATE CASCADE ON DELETE RESTRICT,
   
   CONSTRAINT fk_id_socio_prestamo FOREIGN KEY(id_socio) REFERENCES 
   socio(id_socio) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Tabla Multa
CREATE TABLE multa
(
   id_multa INT GENERATED ALWAYS AS IDENTITY,
   fecha_multa DATE NOT NULL,
   estado VARCHAR(15) NOT NULL DEFAULT 'PENDIENTE',
   monto NUMERIC(10,2) NOT NULL, 
   id_prestamo INT NOT NULL,

   CONSTRAINT pk_multa PRIMARY KEY(id_multa),
   
   CONSTRAINT ck_estado_multa 
   CHECK(estado IN ('PENDIENTE','PAGADO', 'CANCELADO')),
   CONSTRAINT ck_monto_multa CHECK(monto > 0),
   
   CONSTRAINT fk_id_prestamo_multa FOREIGN KEY(id_prestamo) REFERENCES
   prestamo(id_prestamo) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Tabla Ejemplar
CREATE TABLE ejemplar
(
   id_ejemplar INT GENERATED ALWAYS AS IDENTITY,
   estado VARCHAR(20) NOT NULL DEFAULT 'LIBRE',
   id_libro INT NOT NULL,

   CONSTRAINT pk_ejemplar PRIMARY KEY(id_ejemplar),

   CONSTRAINT ck_estado_ejemplar 
   CHECK(estado IN ('LIBRE', 'PRESTADO', 'RESERVADO', 'FUERA_SERVICIO')),

   CONSTRAINT fk_id_libro_ejemplar FOREIGN KEY(id_libro) REFERENCES
   libro(id_libro) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Tabla Prestamo Ejemplar
CREATE TABLE prestamo_ejemplar
(
   id_prestamo INT NOT NULL,
   id_ejemplar INT NOT NULL,

   CONSTRAINT pk_prestamo_ejemplar PRIMARY KEY(id_prestamo, id_ejemplar),

   CONSTRAINT fk_id_prestamo_prestamo_ejemplar FOREIGN KEY(id_prestamo)
   REFERENCES prestamo(id_prestamo) ON UPDATE CASCADE ON DELETE RESTRICT,

   CONSTRAINT fk_id_ejemplar_prestamo_ejemplar FOREIGN KEY(id_ejemplar)
   REFERENCES ejemplar(id_ejemplar) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ==========================================================
-- PARTE DE LIBROS DE LA BIBLIOTECA
-- ==========================================================

-- Tabla Editorial
CREATE TABLE editorial
(
   id_editorial INT GENERATED ALWAYS AS IDENTITY,
   nombre VARCHAR(150) NOT NULL,
   correo VARCHAR(150) NOT NULL,
   telefono VARCHAR(20) NOT NULL,
   direccion VARCHAR(250) NOT NULL,
   
   CONSTRAINT pk_editorial PRIMARY KEY(id_editorial),

   CONSTRAINT uq_nombre_editorial UNIQUE(nombre),
   CONSTRAINT uq_correo_editorial UNIQUE(correo),

   CONSTRAINT ck_correo_editorial CHECK(correo LIKE '%@%'),
   CONSTRAINT ck_telefono_editorial CHECK (telefono ~ '^[0-9+\- ]+$')
);

-- Tabla Libro
CREATE TABLE libro
(
   id_libro INT GENERATED ALWAYS AS IDENTITY,
   nombre VARCHAR(150) NOT NULL,
   fecha_publicacion DATE NOT NULL,

   CONSTRAINT pk_libro PRIMARY KEY(id_libro)
);

-- Tabla Libro Editorial
CREATE TABLE libro_editorial
(
   id_libro INT NOT NULL,
   id_editorial INT NOT NULL,

   CONSTRAINT pk_libro_editorial PRIMARY KEY(id_libro, id_editorial),
   
   CONSTRAINT fk_id_libro_libro_editorial FOREIGN KEY(id_libro) REFERENCES
   libro(id_libro) ON UPDATE CASCADE ON DELETE RESTRICT,

   CONSTRAINT fk_id_editorial_libro_editorial FOREIGN KEY(id_editorial) 
   REFERENCES editorial(id_editorial) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Tabla Autor
CREATE TABLE autor
(
   id_autor INT GENERATED ALWAYS AS IDENTITY,
   nombre VARCHAR(100) NOT NULL,
   apellido VARCHAR(100) NOT NULL,
   fecha_nacimiento DATE NOT NULL,
   sexo CHAR(1) NOT NULL,

   CONSTRAINT pk_autor PRIMARY KEY(id_autor),

   CONSTRAINT ck_sexo_autor CHECK(sexo IN ('M', 'F'))
);

-- Tabla Genero
CREATE TABLE genero
(
   id_genero INT GENERATED ALWAYS AS IDENTITY,
   nombre VARCHAR(150) NOT NULL,
   
   CONSTRAINT pk_genero PRIMARY KEY(id_genero),

   CONSTRAINT uq_nombre_genero UNIQUE(nombre)
);

-- Tabla Libro Genero
CREATE TABLE libro_genero
(
   id_genero INT NOT NULL,
   id_libro INT NOT NULL,

   CONSTRAINT pk_libro_genero PRIMARY KEY(id_genero, id_libro),

   CONSTRAINT fk_id_genero_libro_genero FOREIGN KEY(id_genero) REFERENCES
   genero(id_genero) ON UPDATE CASCADE ON DELETE RESTRICT,

   CONSTRAINT fk_id_libro_libro_genero FOREIGN KEY(id_libro) REFERENCES
   libro(id_libro) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Tabla Libro Autor
CREATE TABLE libro_autor 
(
   id_libro INT NOT NULL,
   id_autor INT NOT NULL,

   CONSTRAINT pk_libro_autor PRIMARY KEY(id_libro, id_autor),

   CONSTRAINT fk_id_libro_libro_autor FOREIGN KEY(id_libro) REFERENCES
   libro(id_libro) ON UPDATE CASCADE ON DELETE RESTRICT,

   CONSTRAINT fk_id_autor_libro_autor FOREIGN KEY(id_autor) REFERENCES
   autor(id_autor) ON UPDATE CASCADE ON DELETE RESTRICT
);
