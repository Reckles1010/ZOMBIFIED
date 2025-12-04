CREATE SCHEMA `zombified` ;

CREATE TABLE `zombified`.`jugadores` (
  `id_jugadores` INT NOT NULL AUTO_INCREMENT,
  `nombre_usuario` VARCHAR(45) NOT NULL,
  `fecha_registro` DATE NOT NULL,
  PRIMARY KEY (`id_jugadores`),
  UNIQUE INDEX `nombre_usuario_UNIQUE` (`nombre_usuario` ASC) VISIBLE);

CREATE TABLE `zombified`.`localizaciones` (
  `id_localizacion` INT NOT NULL AUTO_INCREMENT,
  `nombre_localizacion` VARCHAR(45) NOT NULL,
  `descripcion` TEXT(100) NOT NULL,
  PRIMARY KEY (`id_localizacion`));

CREATE TABLE `zombified`.`items` (
  `id_item` INT NOT NULL AUTO_INCREMENT,
  `nombre_item` VARCHAR(45) NOT NULL,
  `tipo` ENUM('arma', 'objeto') NOT NULL,
  `descripcion` TEXT(100) NOT NULL,
  PRIMARY KEY (`id_item`));

CREATE TABLE `zombified`.`inventario` (
  `id_inventario` INT NOT NULL,
  `id_jugador` INT NOT NULL,
  PRIMARY KEY (`id_inventario`),
  INDEX `fk_inventario_jugador_idx` (`id_jugador` ASC) VISIBLE,
  CONSTRAINT `fk_inventario_jugador`
    FOREIGN KEY (`id_jugador`)
    REFERENCES `zombified`.`jugadores` (`id_jugadores`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT);




CREATE TABLE `zombified`.`enemigos` (
  `id_enemigo` INT NOT NULL AUTO_INCREMENT,
  `daño` INT NOT NULL,
  `vida_enemigo` INT NOT NULL,
  `tiempo_esquiva` INT NOT NULL,
  `tipo_enemigo` ENUM('zombie', 'persona', 'encapuchado') NOT NULL,
  `subtipo_enemigo` ENUM('zombie', 'zombie blindado', 'zomblin', 'persona', 'encapuchado') NOT NULL,
  `descripcion` TEXT(100) NOT NULL,
  PRIMARY KEY (`id_enemigo`));



CREATE TABLE `zombified`.`estadisticas_jugador` (
  `id_jugador` INT NOT NULL,
  `horas_jugadas` INT NOT NULL DEFAULT 0,
  `id_localizacion` INT NOT NULL,
  `nivel` INT NOT NULL DEFAULT 1,
  `numero_decisiones` INT NOT NULL DEFAULT 0,
  `vida_jugador` INT NOT NULL DEFAULT 100,
  `daño` INT NOT NULL DEFAULT 10,
  `progreso` INT NOT NULL DEFAULT 0,
  INDEX `fk_jugadores_estadisticas_idx` (`id_jugador` ASC) VISIBLE,
  INDEX `fk_localizacion_estadisticas_idx` (`id_localizacion` ASC) VISIBLE,
  CONSTRAINT `fk_jugadores_estadisticas`
    FOREIGN KEY (`id_jugador`)
    REFERENCES `zombified`.`jugadores` (`id_jugadores`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_mapas_estadisticas`
    FOREIGN KEY (`id_localizacion`)
    REFERENCES `zombified`.`localizaciones` (`id_localizacion`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT);


CREATE TABLE `zombified`.`combate` (
  `id_combate` INT NOT NULL AUTO_INCREMENT,
  `id_jugador` INT NOT NULL,
  `id_enemigo` INT NOT NULL,
  `numero_turnos` INT NULL,
  `resultado` ENUM('victoria', 'derrota', 'en curso') NOT NULL,
  PRIMARY KEY (`id_combate`),
  INDEX `fk_jugadores_combate_idx` (`id_jugador` ASC) VISIBLE,
  INDEX `fk_enemigos_combate_idx` (`id_enemigo` ASC) VISIBLE,
  CONSTRAINT `fk_jugadores_combate`
    FOREIGN KEY (`id_jugador`)
    REFERENCES `zombified`.`jugadores` (`id_jugadores`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_enemigos_combate`
    FOREIGN KEY (`id_enemigo`)
    REFERENCES `zombified`.`enemigos` (`id_enemigo`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT);




CREATE TABLE `zombified`.`contenido_inventario` (
  `id_inventario` INT NOT NULL,
  `id_jugador` INT NOT NULL,
  `id_item` INT NOT NULL,
  INDEX `fk_item_inventario_idx` (`id_item` ASC) VISIBLE,
  INDEX `fk_jugador_inventario_idx` (`id_jugador` ASC) VISIBLE,
  CONSTRAINT `fk_jugador_inventario`
    FOREIGN KEY (`id_jugador`)
    REFERENCES `zombified`.`jugadores` (`id_jugadores`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_inventario_contenido`
    FOREIGN KEY (`id_inventario`)
    REFERENCES `zombified`.`inventario` (`id_inventario`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_item_inentario`
    FOREIGN KEY (`id_item`)
    REFERENCES `zombified`.`items` (`id_item`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

