-- ==========================================================
-- POBLACION PARA LA BASE DE DATOS BIBLIOTECA
-- ==========================================================


-- EMPLEADO (10 registros)
INSERT INTO empleado (id_empleado, dui, nombre, apellido, fecha_nacimiento, sexo)
OVERRIDING SYSTEM VALUE
VALUES
(1, '12345678-9', 'Carlos', 'Martinez', '1990-05-10', 'M'),
(2, '98765432-1', 'Ana', 'Lopez', '1995-09-20', 'F'),
(3, '33333333-3', 'Pedro', 'Ramirez', '1988-01-12', 'M'),
(4, '44444444-4', 'Lucia', 'Fernandez', '1992-11-25', 'F'),
(5, '55555555-5', 'Miguel', 'Castro', '1985-06-18', 'M'),
(6, '12121212-1', 'Raquel', 'Mendez', '1991-02-14', 'F'),
(7, '13131313-1', 'Javier', 'Santos', '1989-09-09', 'M'),
(8, '14141414-1', 'Daniela', 'Torres', '1996-12-01', 'F'),
(9, '15151515-1', 'Roberto', 'Vargas', '1983-04-22', 'M'),
(10, '16161616-1', 'Andrea', 'Molina', '1994-08-17', 'F');

-- SOCIO (20 registros)
INSERT INTO socio (id_socio, dui, nombre, apellido, fecha_nacimiento, sexo)
OVERRIDING SYSTEM VALUE
VALUES
(1, '11111111-1', 'Luis', 'Hernandez', '2000-02-15', 'M'),
(2, '22222222-2', 'Maria', 'Gonzalez', '1998-07-30', 'F'),
(3, '66666666-6', 'Jose', 'Mendoza', '2001-03-14', 'M'),
(4, '77777777-7', 'Elena', 'Ruiz', '1999-08-22', 'F'),
(5, '88888888-8', 'Ricardo', 'Flores', '1997-12-05', 'M'),
(6, '99999999-9', 'Sofia', 'Alvarado', '2002-04-09', 'F'),
(7, '10101010-1', 'Daniel', 'Perez', '2001-01-10', 'M'),
(8, '20202020-2', 'Patricia', 'Lopez', '1998-05-12', 'F'),
(9, '30303030-3', 'Kevin', 'Rojas', '2000-03-18', 'M'),
(10, '40404040-4', 'Carla', 'Martinez', '1999-07-22', 'F'),
(11, '50505050-5', 'Andres', 'Castillo', '2002-11-30', 'M'),
(12, '60606060-6', 'Gabriela', 'Morales', '2001-06-11', 'F'),
(13, '70707070-7', 'Fernando', 'Diaz', '1996-10-02', 'M'),
(14, '80808080-8', 'Valeria', 'Reyes', '2003-01-19', 'F'),
(15, '90909090-9', 'Oscar', 'Campos', '1995-03-25', 'M'),
(16, '11223344-5', 'Karla', 'Navarro', '1997-09-14', 'F'),
(17, '22334455-6', 'Emilio', 'Aguilar', '1994-12-08', 'M'),
(18, '33445566-7', 'Monica', 'Salazar', '2000-04-04', 'F'),
(19, '44556677-8', 'Hector', 'Pineda', '1993-05-21', 'M'),
(20, '55667788-9', 'Natalia', 'Cruz', '2002-07-07', 'F');

-- EDITORIAL (10 registros)
INSERT INTO editorial (id_editorial, nombre, correo, telefono, direccion)
OVERRIDING SYSTEM VALUE
VALUES
(1, 'Planeta', 'contacto@planeta.com', '2222-1111', 'San Salvador'),
(2, 'Santillana', 'info@santillana.com', '2233-4455', 'Santa Ana'),
(3, 'Alfaguara', 'contacto@alfaguara.com', '2244-5566', 'San Miguel'),
(4, 'Oceano', 'info@oceano.com', '2255-6677', 'La Libertad'),
(5, 'Pearson', 'ventas@pearson.com', '2266-7788', 'Sonsonate'),
(6, 'Anaya', 'contacto@anaya.com', '2277-8899', 'San Salvador'),
(7, 'Norma', 'info@norma.com', '2288-9900', 'Santa Tecla'),
(8, 'McGraw Hill', 'servicio@mcgraw.com', '2299-0011', 'Antiguo Cuscatlan'),
(9, 'Siglo XXI', 'editorial@sigloxxi.com', '2300-1122', 'San Salvador'),
(10, 'Fondo de Cultura', 'contacto@fondocultura.com', '2311-2233', 'San Miguel');

-- GENERO (10 registros)
INSERT INTO genero (id_genero, nombre)
OVERRIDING SYSTEM VALUE
VALUES
(1, 'Fantasia'),
(2, 'Aventura'),
(3, 'Drama'),
(4, 'Ciencia Ficcion'),
(5, 'Romance'),
(6, 'Suspenso'),
(7, 'Historia'),
(8, 'Terror'),
(9, 'Educativo'),
(10, 'Poesia');

-- AUTOR (15 registros)
INSERT INTO autor (id_autor, nombre, apellido, fecha_nacimiento, sexo)
OVERRIDING SYSTEM VALUE
VALUES
(1, 'Gabriel', 'Garcia Marquez', '1927-03-06', 'M'),
(2, 'J.K.', 'Rowling', '1965-07-31', 'F'),
(3, 'George', 'Orwell', '1903-06-25', 'M'),
(4, 'Jane', 'Austen', '1775-12-16', 'F'),
(5, 'Stephen', 'King', '1947-09-21', 'M'),
(6, 'Julio', 'Cortazar', '1914-08-26', 'M'),
(7, 'Isabel', 'Allende', '1942-08-02', 'F'),
(8, 'Mario', 'Vargas Llosa', '1936-03-28', 'M'),
(9, 'Paulo', 'Coelho', '1947-08-24', 'M'),
(10, 'Jorge', 'Borges', '1899-08-24', 'M'),
(11, 'Miguel', 'Cervantes', '1547-09-29', 'M'),
(12, 'Ernest', 'Hemingway', '1899-07-21', 'M'),
(13, 'Agatha', 'Christie', '1890-09-15', 'F'),
(14, 'Mary', 'Shelley', '1797-08-30', 'F'),
(15, 'Edgar', 'Poe', '1809-01-19', 'M');

-- LIBRO (25 registros)
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
(8, 'Antologia latinoamericana', '2005-03-15'),
(9, 'La ciudad y los perros', '1963-01-01'),
(10, 'El alquimista', '1988-01-01'),
(11, 'Ficciones', '1944-01-01'),
(12, 'Don Quijote de la Mancha', '1605-01-16'),
(13, 'El viejo y el mar', '1952-01-01'),
(14, 'Asesinato en el Orient Express', '1934-01-01'),
(15, 'Frankenstein', '1818-01-01'),
(16, 'El cuervo', '1845-01-29'),
(17, 'Rebelion en la granja', '1945-08-17'),
(18, 'Harry Potter y la camara secreta', '1998-07-02'),
(19, 'Carrie', '1974-04-05'),
(20, 'El amor en los tiempos del colera', '1985-01-01'),
(21, 'La tregua', '1960-01-01'),
(22, 'Manual de bases de datos', '2015-08-12'),
(23, 'Introduccion a la programacion', '2018-02-20'),
(24, 'Historia universal', '2010-09-10'),
(25, 'Poesia reunida', '2001-11-11');

-- LIBRO_AUTOR (30 registros)
INSERT INTO libro_autor (id_libro, id_autor)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 1),
(8, 6),
(8, 7),
(9, 8),
(10, 9),
(11, 10),
(12, 11),
(13, 12),
(14, 13),
(15, 14),
(16, 15),
(17, 3),
(18, 2),
(19, 5),
(20, 1),
(21, 6),
(22, 8),
(22, 10),
(23, 3),
(23, 8),
(24, 10),
(25, 15),
(25, 6);

-- LIBRO_GENERO (35 registros)
INSERT INTO libro_genero (id_genero, id_libro)
VALUES
(3, 1),
(1, 2),
(2, 2),
(4, 3),
(5, 4),
(6, 5),
(8, 5),
(3, 6),
(3, 7),
(2, 8),
(3, 8),
(3, 9),
(2, 9),
(5, 10),
(2, 10),
(4, 11),
(3, 11),
(2, 12),
(7, 12),
(3, 13),
(6, 14),
(8, 15),
(8, 16),
(10, 16),
(4, 17),
(1, 18),
(2, 18),
(8, 19),
(3, 20),
(5, 20),
(3, 21),
(9, 22),
(9, 23),
(7, 24),
(10, 25);

-- LIBRO_EDITORIAL (27 registros)
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
(8, 3),
(9, 3),
(10, 1),
(11, 9),
(12, 10),
(13, 4),
(14, 6),
(15, 7),
(16, 9),
(17, 5),
(18, 2),
(19, 4),
(20, 1),
(21, 3),
(22, 8),
(23, 8),
(24, 10),
(25, 9),
(25, 10);

-- EJEMPLAR (35 registros)
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
(12, 'LIBRE', 8),
(13, 'LIBRE', 9),
(14, 'LIBRE', 9),
(15, 'PRESTADO', 10),
(16, 'LIBRE', 10),
(17, 'LIBRE', 11),
(18, 'PRESTADO', 11),
(19, 'LIBRE', 12),
(20, 'LIBRE', 12),
(21, 'LIBRE', 13),
(22, 'PRESTADO', 13),
(23, 'LIBRE', 14),
(24, 'PRESTADO', 15),
(25, 'LIBRE', 16),
(26, 'LIBRE', 17),
(27, 'LIBRE', 18),
(28, 'PRESTADO', 19),
(29, 'LIBRE', 20),
(30, 'RESERVADO', 21),
(31, 'LIBRE', 22),
(32, 'LIBRE', 23),
(33, 'FUERA_SERVICIO', 24),
(34, 'LIBRE', 25),
(35, 'LIBRE', 25);

-- PRESTAMO (25 registros)
INSERT INTO prestamo (id_prestamo, fecha_prestamo, fecha_limite, fecha_devolucion, estado, id_empleado, id_socio)
OVERRIDING SYSTEM VALUE
VALUES
(1, '2026-05-01 10:00:00', '2026-05-08', NULL, 'ACTIVO', 1, 1),
(2, '2026-04-10 09:30:00', '2026-04-17', '2026-04-16 15:00:00', 'DEVUELTO', 2, 2),
(3, '2026-04-01 08:00:00', '2026-04-08', '2026-04-12 11:20:00', 'ATRASADO', 3, 3),
(4, '2026-05-15 09:30:00', '2026-05-22', NULL, 'ACTIVO', 4, 4),
(5, '2026-03-05 14:00:00', '2026-03-12', '2026-03-15 10:10:00', 'ATRASADO', 5, 5),
(6, '2026-06-01 13:45:00', '2026-06-08', '2026-06-07 16:40:00', 'DEVUELTO', 1, 6),
(7, '2026-06-10 10:00:00', '2026-06-17', NULL, 'ACTIVO', 2, 1),
(8, '2026-06-11 11:00:00', '2026-06-18', NULL, 'ACTIVO', 3, 1),
(9, '2026-06-12 09:15:00', '2026-06-19', NULL, 'ACTIVO', 6, 7),
(10, '2026-05-20 12:00:00', '2026-05-27', '2026-05-26 09:00:00', 'DEVUELTO', 7, 8),
(11, '2026-05-21 12:30:00', '2026-05-28', '2026-06-01 10:00:00', 'ATRASADO', 8, 9),
(12, '2026-06-02 14:30:00', '2026-06-09', NULL, 'ACTIVO', 9, 10),
(13, '2026-06-03 15:20:00', '2026-06-10', '2026-06-09 08:30:00', 'DEVUELTO', 10, 11),
(14, '2026-06-04 10:10:00', '2026-06-11', '2026-06-15 09:10:00', 'ATRASADO', 1, 12),
(15, '2026-06-05 09:00:00', '2026-06-12', NULL, 'ACTIVO', 2, 13),
(16, '2026-06-06 09:00:00', '2026-06-13', NULL, 'ACTIVO', 3, 14),
(17, '2026-04-12 11:00:00', '2026-04-19', '2026-04-18 17:30:00', 'DEVUELTO', 4, 15),
(18, '2026-04-15 11:00:00', '2026-04-22', '2026-04-25 11:10:00', 'ATRASADO', 5, 16),
(19, '2026-04-20 13:00:00', '2026-04-27', NULL, 'ACTIVO', 6, 17),
(20, '2026-05-01 13:30:00', '2026-05-08', '2026-05-07 15:00:00', 'DEVUELTO', 7, 18),
(21, '2026-05-04 10:00:00', '2026-05-11', '2026-05-15 10:00:00', 'ATRASADO', 8, 19),
(22, '2026-05-08 08:00:00', '2026-05-15', NULL, 'ACTIVO', 9, 20),
(23, '2026-06-13 16:00:00', '2026-06-20', '2026-06-19 12:00:00', 'DEVUELTO', 10, 2),
(24, '2026-06-14 16:10:00', '2026-06-21', NULL, 'ACTIVO', 1, 3),
(25, '2026-06-15 17:00:00', '2026-06-22', '2026-06-25 10:30:00', 'ATRASADO', 2, 4);

-- PRESTAMO_EJEMPLAR (25 registros)
INSERT INTO prestamo_ejemplar (id_prestamo, id_ejemplar)
VALUES
(1, 2),
(2, 3),
(3, 4),
(4, 7),
(5, 11),
(6, 10),
(7, 5),
(8, 12),
(9, 15),
(10, 16),
(11, 18),
(12, 22),
(13, 21),
(14, 24),
(15, 26),
(16, 27),
(17, 23),
(18, 25),
(19, 28),
(20, 29),
(21, 30),
(22, 31),
(23, 32),
(24, 6),
(25, 8);

-- MULTA (12 registros)
INSERT INTO multa (id_multa, fecha_multa, estado, monto, id_prestamo)
OVERRIDING SYSTEM VALUE
VALUES
(1, '2026-04-12', 'PENDIENTE', 10.0, 3),
(2, '2026-03-15', 'PAGADO', 7.5, 5),
(3, '2026-03-16', 'PENDIENTE', 5.0, 5),
(4, '2026-06-01', 'PENDIENTE', 10.0, 11),
(5, '2026-06-15', 'PAGADO', 10.0, 14),
(6, '2026-04-25', 'PENDIENTE', 7.5, 18),
(7, '2026-05-15', 'PAGADO', 10.0, 21),
(8, '2026-06-25', 'PENDIENTE', 7.5, 25),
(9, '2026-04-13', 'ANULADO', 2.5, 3),
(10, '2026-05-16', 'PENDIENTE', 5.0, 21),
(11, '2026-06-26', 'PAGADO', 7.5, 25),
(12, '2026-06-16', 'PENDIENTE', 2.5, 14);

