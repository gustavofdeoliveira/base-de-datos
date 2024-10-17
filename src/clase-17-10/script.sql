--
select g.id_jugador, count(g.id_partido) from f2006_goles g
group by g.id_jugador

select g.id_jugador, count(g.id_partido) from f2006_goles g
left join f2006_jugadores j on j.id_jugador = g.id_jugador AND j.id_seleccion = g.id_seleccion
group by g.id_jugador

-- 
select j.nombre, j.id_jugador, j.id_seleccion
from f2006_jugadores j
where (j.id_jugador, j.id_seleccion) in (
    select distinct id_jugador, id_seleccion from f2006_goles
)

select j.nombre, j.id_jugador, j.id_seleccion
from f2006_jugadores j
where exists (
    select 1 from f2006_goles g
    where g.id_jugador = j.id_jugador and g.id_seleccion = j.id_seleccion
)