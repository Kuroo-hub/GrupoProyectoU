--Consulta de libros disponibles
SELECT 
    e.id_ejemplar,
    l.id_libro,
    l.nombre AS libro,
    e.estado
FROM ejemplar e
INNER JOIN libro l 
    ON e.id_libro = l.id_libro
WHERE e.estado = 'LIBRE';

--Consulta de libros prestados
SELECT 
    p.id_prestamo,
    e.id_ejemplar,
    l.nombre AS libro,
    CONCAT(s.nombre, ' ', s.apellido) AS socio,
    p.fecha_prestamo,
    p.fecha_limite,
    p.estado
FROM prestamo p
INNER JOIN prestamo_ejemplar pe ON p.id_prestamo = pe.id_prestamo
INNER JOIN ejemplar e ON pe.id_ejemplar = e.id_ejemplar
INNER JOIN libro l ON e.id_libro = l.id_libro
INNER JOIN socio s ON p.id_socio = s.id_socio;

--Consultar préstamos activos
SELECT 
    p.id_prestamo,
    l.nombre AS libro,
    e.id_ejemplar,
    s.nombre || ' ' || s.apellido AS socio,
    p.fecha_prestamo,
    p.fecha_limite,
    p.estado
FROM prestamo p
INNER JOIN prestamo_ejemplar pe 
    ON p.id_prestamo = pe.id_prestamo
INNER JOIN ejemplar e 
    ON pe.id_ejemplar = e.id_ejemplar
INNER JOIN libro l 
    ON e.id_libro = l.id_libro
INNER JOIN socio s 
    ON p.id_socio = s.id_socio
WHERE p.estado = 'ACTIVO'
  AND p.fecha_devolucion IS NULL;

--Consultar préstamos retrasados
SELECT 
    p.id_prestamo,
    l.nombre AS libro,
    e.id_ejemplar,
    CONCAT(s.nombre, ' ', s.apellido) AS socio,
    p.fecha_prestamo,
    p.fecha_limite,
    EXTRACT(DAY FROM (CURRENT_TIMESTAMP - p.fecha_limite)) AS dias_retraso, 
    p.estado
FROM prestamo p
INNER JOIN prestamo_ejemplar pe ON p.id_prestamo = pe.id_prestamo
INNER JOIN ejemplar e ON pe.id_ejemplar = e.id_ejemplar
INNER JOIN libro l ON e.id_libro = l.id_libro
INNER JOIN socio s ON p.id_socio = s.id_socio
WHERE p.fecha_devolucion IS NULL
  AND p.fecha_limite < CURRENT_DATE;

--Consultar libros más prestados en los últimos tres meses
SELECT 
    l.id_libro,
    l.nombre AS libro,
    COUNT(*) AS total_prestamos
FROM prestamo p
INNER JOIN prestamo_ejemplar pe 
    ON p.id_prestamo = pe.id_prestamo
INNER JOIN ejemplar e 
    ON pe.id_ejemplar = e.id_ejemplar
INNER JOIN libro l 
    ON e.id_libro = l.id_libro
WHERE p.fecha_prestamo >= CURRENT_DATE - INTERVAL '3 months'
GROUP BY l.id_libro, l.nombre
ORDER BY total_prestamos DESC;

--Consultar autores con más libros
SELECT 
    a.id_autor,
    a.nombre || ' ' || a.apellido AS autor,
    COUNT(la.id_libro) AS total_libros
FROM autor a
INNER JOIN libro_autor la 
    ON a.id_autor = la.id_autor
GROUP BY a.id_autor, a.nombre, a.apellido
ORDER BY total_libros DESC;

--Consultar libros nunca prestados
SELECT 
    l.id_libro,
    l.nombre AS libro,
    l.fecha_publicacion
FROM libro l
LEFT JOIN ejemplar e 
    ON l.id_libro = e.id_libro
LEFT JOIN prestamo_ejemplar pe 
    ON e.id_ejemplar = pe.id_ejemplar
WHERE pe.id_prestamo IS NULL;

--Empleado con más préstamos
SELECT 
    em.id_empleado,
    UPPER(CONCAT(em.nombre, ' ', em.apellido)) AS empleado,
    COUNT(p.id_prestamo) AS total_prestamos
FROM empleado em
INNER JOIN prestamo p ON em.id_empleado = p.id_empleado
GROUP BY em.id_empleado, em.nombre, em.apellido
ORDER BY total_prestamos DESC
LIMIT 1;

-- Libros mas prestados
SELECT 
    l.id_libro,
    l.nombre AS titulo_libro,
    
    STRING_AGG(DISTINCT g.nombre, ', ') AS generos,
    
    STRING_AGG(DISTINCT CONCAT(a.nombre, ' ', a.apellido), ', ') AS autores,
    
    COUNT(DISTINCT e.id_ejemplar) AS total_ejemplares_disponibles,

    COUNT(pe.id_prestamo) AS total_veces_prestado

FROM libro l

LEFT JOIN ejemplar e ON l.id_libro = e.id_libro
LEFT JOIN prestamo_ejemplar pe ON e.id_ejemplar = pe.id_ejemplar

LEFT JOIN libro_autor la ON l.id_libro = la.id_libro
LEFT JOIN autor a ON la.id_autor = a.id_autor

LEFT JOIN libro_genero lg ON l.id_libro = lg.id_libro
LEFT JOIN genero g ON lg.id_genero = g.id_genero

GROUP BY l.id_libro, l.nombre

ORDER BY total_veces_prestado DESC;

-- Consultar socios con más multas acumuladas
SELECT 
    s.id_socio,
    UPPER(CONCAT(s.nombre, ' ', s.apellido)) AS socio,
    s.dui,
    COUNT(m.id_multa) AS total_multas_recibidas,
    COALESCE(SUM(m.monto), 0.00) AS monto_total_acumulado

FROM socio s
LEFT JOIN prestamo p ON s.id_socio = p.id_socio
LEFT JOIN multa m ON p.id_prestamo = m.id_prestamo
GROUP BY s.id_socio, s.nombre, s.apellido, s.dui
HAVING COUNT(m.id_multa) > 0
ORDER BY total_multas_recibidas DESC, monto_total_acumulado DESC;