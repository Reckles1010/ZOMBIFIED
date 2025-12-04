/*Nombre del jugador y la localización en la que está*/
SELECT j.nombre_usuario, l.nombre_localizacion
FROM jugadores j
JOIN estadisticas_jugador e ON j.id_jugadores = e.id_jugador
JOIN localizaciones l ON e.id_localizacion = l.id_localizacion;

/*Que jugador combate contra que enemigo*/
SELECT j.nombre_usuario, en.subtipo_enemigo
FROM jugadores j
JOIN combate c ON j.id_jugadores = c.id_jugador
JOIN enemigos en ON c.id_enemigo = en.id_enemigo;

/*Numero de jugadores que hay en cada localización y el nombre de esta y ordena de mayor a menor*/
SELECT COUNT(es.id_jugador) AS numero_jugadores, l.nombre_localizacion
FROM estadisticas_jugador es
JOIN localizaciones l ON es.id_localizacion = l.id_localizacion
GROUP BY l.nombre_localizacion
ORDER BY numero_jugadores DESC;

/*Daño promedio de los enemigos vencidos en la ciudad*/
SELECT AVG(en.daño) AS daño
FROM combate c
JOIN enemigos en ON c.id_enemigo = en.id_enemigo
WHERE c.resultado = 'victoria' AND c.id_jugador IN (
      SELECT id_jugador
      FROM estadisticas_jugador
      WHERE id_localizacion = 1
  );

/*Mostrar el nombre del jugador y su nivel*/
SELECT j.nombre_usuario, es.nivel
FROM jugadores j
JOIN estadisticas_jugador es ON j.id_jugadores = es.id_jugador;

/*Ver cual es el enemigo con el que se combate más veces*/
SELECT en.subtipo_enemigo, COUNT(c.id_combate) AS apariciones
FROM enemigos en
JOIN combate c ON en.id_enemigo = c.id_enemigo
GROUP BY en.subtipo_enemigo
ORDER BY apariciones DESC
LIMIT 1;

/*Jugadores que superan el nivel promedio del resto de jugadores*/
SELECT j.nombre_usuario, es.nivel
FROM jugadores j
JOIN estadisticas_jugador es ON j.id_jugadores = es.id_jugador
WHERE es.nivel > (
SELECT AVG(nivel) AS nivel
    FROM estadisticas_jugador
);

/*Mostrar los tres jugadores más antiguos y su nivel*/
SELECT j.nombre_usuario, j.fecha_registro, e.nivel
FROM jugadores j
JOIN estadisticas_jugador e ON j.id_jugadores = e.id_jugador
ORDER BY j.fecha_registro ASC
LIMIT 3;

/*El nombre del jugador y las armas obtenidas*/
SELECT j.nombre_usuario, i.nombre_item AS arma
FROM jugadores j
JOIN contenido_inventario con ON j.id_jugadores = con.id_jugador
JOIN items i ON con.id_item = i.id_item
WHERE i.tipo = 'arma'
ORDER BY j.nombre_usuario;

/*Mostrar el promedio de turnos de los jugadores en los combates ganados contra enemigos de tipo zombie*/
SELECT AVG(com.numero_turnos) AS promedio_turnos, en.subtipo_enemigo
FROM combate com
JOIN enemigos en ON com.id_enemigo = en.id_enemigo
WHERE com.resultado = 'victoria' AND en.vida_enemigo=(
SELECT MAX(vida_enemigo)
    FROM enemigos
    WHERE tipo_enemigo = 'zombie'
)
GROUP BY en.subtipo_enemigo;

/*Jugadores con nivel mayor al promedio y con más de dos armas*/
SELECT j.nombre_usuario, es.nivel, COUNT(i.id_item) AS num_armas
FROM jugadores j
JOIN estadisticas_jugador es ON j.id_jugadores = es.id_jugador
JOIN contenido_inventario con ON es.id_jugador = con.id_jugador
JOIN items i ON con .id_item = i.id_item
WHERE i.tipo = 'arma'
GROUP BY j.nombre_usuario, es.nivel
HAVING es.nivel > (
SELECT AVG(nivel)
    FROM estadisticas_jugador
);

/*Mostrar el número de combates por jugador*/
SELECT j.nombre_usuario, COUNT(c.id_jugador) AS num_combates
FROM jugadores j
JOIN combate c ON j.id_jugadores = c.id_jugador
GROUP BY j.nombre_usuario