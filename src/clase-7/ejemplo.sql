select * from f2006_estadios

select id from f2006_estadios

select nombre from f2006_estadios

select * from f2006_estadios
where f2006_estadios.id_estadio = '10'

## Filtrar por nombre de estadio que empiece con la letra H
select * from f2006_estadios
where f2006_estadios.nombre like 'H%'

## Filtrar por nombre de estadio que tenga la letra H
select * from f2006_estadios
where f2006_estadios.nombre like '%h%'

## Filtrar por nombre de estadio que tenga la letra h
select * from f2006_estadios
where lower(nombre) like '%h%'

## Transformar el id_estadio a entero y filtrar por los estadios cuyo id_estadio sea 0, 1, 2 o 3
select * from f2006_estadios
where cast(id_estadio as integer) between 0 and 3

## ordenar por id_estadio de forma descendente
select * from f2006_arbitros
order by id_arbitro desc

## seleccionar el maximo de estatura
select max(estatura)
from f2006_arbitros

select nombre, estatura from f2006_arbitros
where estatura = (
select max(estatura)
from f2006_arbitros
)
order by estatura desc

select * from f2006_arbitros
where nacionalidad like 'M_xico'
and estatura = (
    select max(estatura)
    from f2006_arbitros
    where nacionalidad like 'M_xico'
) 


SELECT nombre, estatura, id_arbitro, (
    SELECT count(id_partido)
    FROM f2006_partidos as x
    WHERE x.id_arbitro = a.id_arbitro) as num_partidos
FROM f2006_arbitros a