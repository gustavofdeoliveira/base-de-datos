CREATE Function eross_get_cant_libros(_rut text)
RETURNS int language plpgsql AS $$
DECLARE
    _count integer;
BEGIN
    SELECT COUNT
    INTO _count
    FROM eross_libros
    WHERE rut_autor = _rut;

    return _count;

END;
$$;


