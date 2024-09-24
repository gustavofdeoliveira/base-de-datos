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