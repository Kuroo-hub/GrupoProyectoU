-- ==========================================================
-- TRIGGERS DE LA BIBLIOTECA
-- ==========================================================

-- Validacion de generar multas
CREATE OR REPLACE FUNCTION fn_generar_multa_por_retraso()
RETURNS TRIGGER AS
$$
DECLARE
   -- Variables
   dias_retraso INT;
   monto_por_dia NUMERIC(10,2) := 2.50;
BEGIN 
   -- Validacion de multa
   IF NEW.fecha_devolucion IS NOT NULL
      AND NEW.fecha_devolucion::DATE > NEW.fecha_limite THEN

      dias_retraso := NEW.fecha_devolucion::DATE - NEW.fecha_limite;
   
   -- Registro de la multa automatica
      INSERT INTO multa(fecha_multa, estado, monto, id_prestamo) 
      VALUES(
         CURRENT_DATE,
         'PENDIENTE', 
         dias_retraso * monto_por_dia,
         NEW.id_prestamo
      );

   END IF;

   RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_generar_multa_por_retraso
AFTER UPDATE OF fecha_devolucion ON prestamo
FOR EACH ROW
EXECUTE FUNCTION fn_generar_multa_por_retraso();

-- ================================================
-- Consulta para probar el disparador
-- ================================================

-- TRIGGER cuando se haya hecho la devolucion del libro se actualiza a la fecha que lo devolvio
UPDATE prestamo
SET fecha_devolucion = '2026-07-30 10:00:00',
    estado = 'DEVUELTO'
WHERE id_prestamo = 1;