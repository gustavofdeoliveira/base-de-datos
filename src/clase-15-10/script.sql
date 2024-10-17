--inner

select p.id_partido, p.fecha, p.equipo1, p.equipo1, g.id_jugador, g.id_seleccion, g.minuto 
from f2006_partidos p
left join f2006_goles g on g.id_partido = p.id_partido

select a.nacionalidad, count(a.id_arbitro) as num_arbitros
from f2006_arbitros a
group by a.nacionalidad

select a.nacionalidad, count(a.id_arbitro) as num_arbitros
from f2006_arbitros a
group by a.nacionalidad
having count(a.id_arbitro) > 1

select a.nacionalidad, count(a.id_arbitro) as num_arbitros
from f2006_arbitros a
group by a.nacionalidad
order by a.nacionalidad asc

select a.nacionalidad, count(a.id_arbitro) as num_arbitros
from f2006_arbitros a
group by a.nacionalidad
order by a.nacionalidad desc