-- ==========================================================
-- DATOS PARA LA BASE DE DATOS BIBLIOTECA
-- ==========================================================


-- ==========================================================
-- 1. EMPLEADOS
-- ==========================================================
INSERT INTO empleado (id_empleado, dui, nombre, apellido, fecha_nacimiento, sexo)
OVERRIDING SYSTEM VALUE
VALUES
(1, '12345678-9', 'Carlos', 'Martinez', '1990-05-10', 'M'),
(2, '98765432-1', 'Ana', 'Lopez', '1995-09-20', 'F'),
(3, '33333333-3', 'Pedro', 'Ramirez', '1988-01-12', 'M'),
(4, '44444444-4', 'Lucia', 'Fernandez', '1992-11-25', 'F'),
(5, '55555555-5', 'Miguel', 'Castro', '1985-06-18', 'M');


-- ==========================================================
-- 2. SOCIOS
-- ==========================================================
INSERT INTO socio (id_socio, dui, nombre, apellido, fecha_nacimiento, sexo)
OVERRIDING SYSTEM VALUE
VALUES
(1, '11111111-1', 'Luis', 'Hernandez', '2000-02-15', 'M'),
(2, '22222222-2', 'Maria', 'Gonzalez', '1998-07-30', 'F'),
(3, '66666666-6', 'Jose', 'Mendoza', '2001-03-14', 'M'),
(4, '77777777-7', 'Elena', 'Ruiz', '1999-08-22', 'F'),
(5, '88888888-8', 'Ricardo', 'Flores', '1997-12-05', 'M'),
(6, '99999999-9', 'Sofia', 'Alvarado', '2002-04-09', 'F');


-- ==========================================================
-- 3. EDITORIALES
-- ==========================================================
INSERT INTO editorial (id_editorial, nombre, correo, telefono, direccion)
OVERRIDING SYSTEM VALUE
VALUES
(1, 'Planeta', 'contacto@planeta.com', '2222-1111', 'San Salvador'),
(2, 'Santillana', 'info@santillana.com', '2233-4455', 'Santa Ana'),
(3, 'Alfaguara', 'contacto@alfaguara.com', '2244-5566', 'San Miguel'),
(4, 'Oceano', 'info@oceano.com', '2255-6677', 'La Libertad'),
(5, 'Pearson', 'ventas@pearson.com', '2266-7788', 'Sonsonate');


-- ==========================================================
-- 4. GENEROS
-- ==========================================================
INSERT INTO genero (id_genero, nombre)
OVERRIDING SYSTEM VALUE
VALUES
(1, 'Fantasia'),
(2, 'Aventura'),
(3, 'Drama'),
(4, 'Ciencia Ficcion'),
(5, 'Romance'),
(6, 'Suspenso');


-- ==========================================================
-- 5. AUTORES
-- ==========================================================
INSERT INTO autor (id_autor, nombre, apellido, fecha_nacimiento, sexo)
OVERRIDING SYSTEM VALUE
VALUES
(1, 'Gabriel', 'Garcia Marquez', '1927-03-06', 'M'),
(2, 'J.K.', 'Rowling', '1965-07-31', 'F'),
(3, 'George', 'Orwell', '1903-06-25', 'M'),
(4, 'Jane', 'Austen', '1775-12-16', 'F'),
(5, 'Stephen', 'King', '1947-09-21', 'M'),
(6, 'Julio', 'Cortazar', '1914-08-26', 'M'),
(7, 'Isabel', 'Allende', '1942-08-02', 'F');


-- ==========================================================
-- 6. LIBROS
-- ==========================================================
INSERT INTO libro (id_libro, nombre, fecha_publicacion)
OVERRIDING SYSTEM VALUE
VALUES
(1, 'Cien anios de soledad', '1967-05-30'),
(2, 'Harry Potter y la piedra filosofal', '1997-06-26'),
(3, '1984', '1949-06-08'),
(4, 'Orgullo y prejuicio', '1813-01-28'),
(5, 'It', '1986-09-15'),
(6, 'Rayuela', '1963-06-28'),
(7, 'La casa de los espiritus', '1982-01-01'),
(8, 'Antologia latinoamericana', '2005-03-15');


-- ==========================================================
-- 7. RELACION LIBRO - AUTOR
-- ==========================================================
INSERT INTO libro_autor (id_libro, id_autor)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),

-- Libro con multiples autores para probar relacion muchos a muchos
(8, 1),
(8, 6),
(8, 7);


-- ==========================================================
-- 8. RELACION LIBRO - GENERO
-- ==========================================================
INSERT INTO libro_genero (id_genero, id_libro)
VALUES
(3, 1),
(1, 2),
(2, 2),
(4, 3),
(5, 4),
(6, 5),
(3, 6),
(3, 7),
(2, 8),
(3, 8);


-- ==========================================================
-- 9. RELACION LIBRO - EDITORIAL
-- ==========================================================
INSERT INTO libro_editorial (id_libro, id_editorial)
VALUES
(1, 1),
(2, 2),
(3, 5),
(4, 3),
(5, 4),
(6, 1),
(7, 3),
(8, 1),
(8, 3);


-- ==========================================================
-- 10. EJEMPLARES FISICOS
-- ==========================================================
INSERT INTO ejemplar (id_ejemplar, estado, id_libro)
OVERRIDING SYSTEM VALUE
VALUES
(1, 'LIBRE', 1),
(2, 'PRESTADO', 1),
(3, 'LIBRE', 2),
(4, 'PRESTADO', 2),
(5, 'RESERVADO', 2),
(6, 'LIBRE', 3),
(7, 'PRESTADO', 4),
(8, 'LIBRE', 5),
(9, 'FUERA_SERVICIO', 5),
(10, 'LIBRE', 6),
(11, 'PRESTADO', 7),
(12, 'LIBRE', 8);


-- ==========================================================
-- 11. PRESTAMOS
-- ==========================================================
INSERT INTO prestamo (
   id_prestamo,
   fecha_prestamo,
   fecha_limite,
   fecha_devolucion,
   estado,
   id_empleado,
   id_socio
)
OVERRIDING SYSTEM VALUE
VALUES
-- Prestamo activo
(1, '2026-05-01 10:00:00', '2026-05-08', NULL, 'ACTIVO', 1, 1),

-- Prestamo devuelto a tiempo
(2, '2026-04-10 09:30:00', '2026-04-17', '2026-04-16 15:00:00', 'DEVUELTO', 2, 2),

-- Prestamo devuelto tarde
(3, '2026-04-01 08:00:00', '2026-04-08', '2026-04-12 11:20:00', 'ATRASADO', 3, 3),

-- Prestamo activo
(4, '2026-05-15 09:30:00', '2026-05-22', NULL, 'ACTIVO', 4, 4),

-- Prestamo devuelto tarde
(5, '2026-03-05 14:00:00', '2026-03-12', '2026-03-15 10:10:00', 'ATRASADO', 5, 5),

-- Prestamo devuelto a tiempo
(6, '2026-06-01 13:45:00', '2026-06-08', '2026-06-07 16:40:00', 'DEVUELTO', 1, 6),

-- Prestamo activo para probar limite de prestamos
(7, '2026-06-10 10:00:00', '2026-06-17', NULL, 'ACTIVO', 2, 1),

-- Otro prestamo activo para que socio 1 tenga varios activos
(8, '2026-06-11 11:00:00', '2026-06-18', NULL, 'ACTIVO', 3, 1);


-- ==========================================================
-- 12. RELACION PRESTAMO - EJEMPLAR
-- ==========================================================
INSERT INTO prestamo_ejemplar (id_prestamo, id_ejemplar)
VALUES
(1, 2),
(2, 3),
(3, 4),
(4, 7),
(5, 11),
(6, 10),
(7, 5),
(8, 12);


-- ==========================================================
-- 13. MULTAS
-- ==========================================================
INSERT INTO multa (id_multa, fecha_multa, estado, monto, id_prestamo)
OVERRIDING SYSTEM VALUE
VALUES
-- Multa pendiente: sirve para probar que el socio no pueda prestar
(1, '2026-04-12', 'PENDIENTE', 10.00, 3),

-- Multa pagada
(2, '2026-03-15', 'PAGADO', 7.50, 5),

-- Otra multa pendiente
(3, '2026-03-16', 'PENDIENTE', 5.00, 5);




