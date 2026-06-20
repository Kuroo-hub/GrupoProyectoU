-- ==========================================================
-- PROCEDIMIENTOS DE LA BIBLIOTECA
-- ==========================================================
CREATE OR REPLACE PROCEDURE sp_procesar_prestamo(
   -- Parametros 
   p_id_socio INT,
   p_id_empleado INT,
   p_id_ejemplar INT,
   p_fecha_limite DATE
)
LANGUAGE plpgsql
AS 
$$
DECLARE 
-- Variables
   v_estado_ejemplar VARCHAR(20);
   v_multas_pendientes INT;
   v_prestamos_activos INT;
   v_id_prestamo INT;
BEGIN 
   
   -- 1. Verificar estado del ejemplar
   SELECT estado 
   INTO v_estado_ejemplar
   FROM ejemplar
   WHERE id_ejemplar = p_id_ejemplar;

   -- Validacion si esta nulo el estado del ejemplar
   IF v_estado_ejemplar IS NULL THEN
      RAISE EXCEPTION 'El ejemplar no existe';
   END IF;

   -- Validacion si el estado del ejemplar no es LIBRE
   IF v_estado_ejemplar <> 'LIBRE' THEN
      RAISE EXCEPTION 'El ejemplar no esta disponible';
   END IF;

   -- 2. Verificar que el socio no tenga multas y su limite de prestamos.
   SELECT COUNT(*) 
   INTO v_multas_pendientes
   FROM multa m 
   INNER JOIN prestamo p 
   ON m.id_prestamo = p.id_prestamo
   WHERE p.id_socio = p_id_socio
   AND m.estado = 'PENDIENTE';

   IF v_multas_pendientes > 0 THEN
      RAISE EXCEPTION 'El socio tiene multas pendientes, prestamo negado';
   END IF;

   -- 3. Verificar los prestamos del socio
   SELECT COUNT(*) 
   INTO v_prestamos_activos
   FROM prestamo 
   WHERE id_socio = p_id_socio
   AND estado = 'ACTIVO';

   IF v_prestamos_activos >= 3 THEN
      RAISE EXCEPTION 'El socio tiene 3 prestamos activos';
   END IF;

   -- 4. Registrar prestamo 
   INSERT INTO prestamo(fecha_limite, estado, id_empleado, id_socio)
   VALUES(p_fecha_limite, 'ACTIVO', p_id_empleado, p_id_socio)
   RETURNING id_prestamo INTO v_id_prestamo;

   -- 5. Relacionar prestamo con ejemplar
   INSERT INTO prestamo_ejemplar(id_prestamo, id_ejemplar) 
   VALUES(v_id_prestamo, p_id_ejemplar);

   -- 6. Cambiar estado del ejemplar
   UPDATE ejemplar
   SET estado = 'PRESTADO'
   WHERE id_ejemplar = p_id_ejemplar;

END;
$$;

-- ================================================
-- Llamada del procedimiento
-- ================================================

-- PROCEDURE, el primero es id_socio, id_empleado, id_ejemplar y fecha_limite que son los parametros
CALL sp_procesar_prestamo(2, 1, 1, '2026-08-15');
------------------------------------------------
CALL sp_procesar_prestamo(2, 1, 1, '2026-08-15');

-- Consulta de verificación para demostrar el cambio de estado
SELECT * FROM ejemplar WHERE id_ejemplar = 1; -- Debería mostrar 'PRESTADO'
SELECT * FROM prestamo ORDER BY id_prestamo DESC LIMIT 1; -- Muestra el registro creado


-- CASO 2: Prueba de validación de error (Intento de prestar el mismo ejemplar ya ocupado)
-- Debería lanzar la excepción: "ERROR: El ejemplar no esta disponible"
CALL sp_procesar_prestamo(3, 1, 1, '2026-08-20');