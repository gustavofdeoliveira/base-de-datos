CREATE FUNCTION control_create_cotizacion_function()
   RETURNS TRIGGER
   LANGUAGE PLPGSQL
AS $$
BEGIN
   IF EXISTS (SELECT 1 FROM ejecutor WHERE rut = NEW.rut_creador) THEN
        RAISE EXCEPTION 'El rut % no se puede hacer cotizacions', NEW.rut_creador;
   END IF;

   RETURN NULL;
END;
$$;


CREATE TRIGGER trigger_before_insert_update_cotizacion
BEFORE INSERT ON cotizacion
FOR EACH ROW
EXECUTE FUNCTION control_create_cotizacion_function();


CREATE FUNCTION control_status_cotizacion_function()
   RETURNS TRIGGER
   LANGUAGE PLPGSQL

AS $$

BEGIN
   IF NOT EXISTS (SELECT 1 FROM cotizacion WHERE id_cotizacion = NEW.id_cotizacion) THEN
        NEW.estado = 'creado';
        RETURNS NEW;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM cotizacion WHERE id_cotizacion = NEW.id_cotizacion AND estado = 'creado') THEN
        RAISE EXCEPTION 'No se puede cambiar el estado de la cotizacion %', NEW.id_cotizacion;

    IF EXISTS (SELECT 1 FROM cotizacion WHERE id_cotizacion = NEW.id_cotizacion AND estado = 'creado') THEN
        NEW.estado = 'aprobado';
        NEW.fecha = NOW();
        RETURNS NEW;   
    END IF;

    IF NOT EXISTS (SELECT 1 FROM cotizacion WHERE id_cotizacion = NEW.id_cotizacion AND estado = 'aprobado') THEN
        RAISE EXCEPTION 'No se puede cambiar el estado de la cotizacion %', NEW.id_cotizacion;
    END IF;

    IF EXISTS (SELECT 1 FROM cotizacion WHERE id_cotizacion = NEW.id_cotizacion AND estado = 'aprobado') THEN
        NEW.estado = 'terminado';
        NEW.fecha = NOW();
        RETURNS NEW;   
    END IF;

    IF NOT EXISTS (SELECT 1 FROM cotizacion WHERE id_cotizacion = NEW.id_cotizacion AND estado = 'terminado') THEN
        RAISE EXCEPTION 'No se puede cambiar el estado de la cotizacion %', NEW.id_cotizacion;
    END IF;

    IF EXISTS (SELECT 1 FROM cotizacion WHERE id_cotizacion = NEW.id_cotizacion AND estado = 'terminado') THEN
        NEW.estado = 'enviado';
        NEW.fecha = NOW();
        RETURNS NEW;   
    END IF;

   RETURN NEW;
END;
$$;

CREATE Trigger trigger_before_update_status_cotizacion
BEFORE UPDATE ON cotizacion
FOR EACH ROW
EXECUTE FUNCTION control_status_cotizacion_function();
