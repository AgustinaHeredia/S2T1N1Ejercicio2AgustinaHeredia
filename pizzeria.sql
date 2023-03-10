-- MySQL Script generated by MySQL Workbench
-- Mon Feb 27 20:08:29 2023
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Pizzeria
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Pizzeria
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Pizzeria` DEFAULT CHARACTER SET utf8 ;
USE `Pizzeria` ;

-- -----------------------------------------------------
-- Table `Pizzeria`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pizzeria`.`cliente` (
  `idcliente` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido` VARCHAR(45) NOT NULL,
  `direccion` VARCHAR(150) NOT NULL,
  `codigo_postal` INT NOT NULL,
  `ciudad` VARCHAR(45) NOT NULL,
  `provincia` VARCHAR(45) NOT NULL,
  `telefono` INT NOT NULL,
  PRIMARY KEY (`idcliente`),
  UNIQUE INDEX `idcliente_UNIQUE` (`idcliente` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Pizzeria`.`categoria_pizza`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pizzeria`.`categoria_pizza` (
  `idcategoria_pizza` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idcategoria_pizza`),
  UNIQUE INDEX `idcategoria_pizza_UNIQUE` (`idcategoria_pizza` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Pizzeria`.`producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pizzeria`.`producto` (
  `id_producto` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(25) NOT NULL,
  `descripcion` VARCHAR(115) NOT NULL,
  `imagen` BLOB NULL,
  `precio` DECIMAL(10,2) NOT NULL,
  `tipo_producto` ENUM("pizza", "Hamburguesa", "Bebida") NOT NULL,
  `idcategoria` INT NULL,
  PRIMARY KEY (`id_producto`),
  UNIQUE INDEX `idpizza_UNIQUE` (`id_producto` ASC) VISIBLE,
  INDEX `categoria_idx` (`idcategoria` ASC) VISIBLE,
  CONSTRAINT `categoria`
    FOREIGN KEY (`idcategoria`)
    REFERENCES `Pizzeria`.`categoria_pizza` (`idcategoria_pizza`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Pizzeria`.`tienda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pizzeria`.`tienda` (
  `idtienda` INT NOT NULL AUTO_INCREMENT,
  `direccion` VARCHAR(45) NOT NULL,
  `codigo_postal` INT NOT NULL,
  `localidad` VARCHAR(45) NOT NULL,
  `provincia` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idtienda`),
  UNIQUE INDEX `idtienda_UNIQUE` (`idtienda` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Pizzeria`.`empleado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pizzeria`.`empleado` (
  `idempleado` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido` VARCHAR(45) NOT NULL,
  `NIF` VARCHAR(9) NOT NULL,
  `tefelono` INT NOT NULL,
  `categoria` VARCHAR(45) NOT NULL,
  `tienda` INT NOT NULL,
  PRIMARY KEY (`idempleado`),
  UNIQUE INDEX `idempleado_UNIQUE` (`idempleado` ASC) VISIBLE,
  INDEX `tienda_idx` (`tienda` ASC) VISIBLE,
  CONSTRAINT `tienda`
    FOREIGN KEY (`tienda`)
    REFERENCES `Pizzeria`.`tienda` (`idtienda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Pizzeria`.`comanda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pizzeria`.`comanda` (
  `idcomanda` INT NOT NULL AUTO_INCREMENT,
  `fecha_hora` DATETIME NOT NULL,
  `cliente` INT NOT NULL,
  `tipo_recogida` ENUM("Domicilio", "En tienda") NOT NULL,
  `repartidor` INT NOT NULL DEFAULT 0,
  `hora_entrega` DATETIME NULL,
  `tienda` INT NOT NULL,
  `precio_total` INT NULL,
  PRIMARY KEY (`idcomanda`),
  UNIQUE INDEX `idcomanda_UNIQUE` (`idcomanda` ASC) VISIBLE,
  INDEX `cliente_idx` (`cliente` ASC) VISIBLE,
  INDEX `repartidor_idx` (`repartidor` ASC) VISIBLE,
  INDEX `tienda_idx` (`tienda` ASC) VISIBLE,
  CONSTRAINT `cliente`
    FOREIGN KEY (`cliente`)
    REFERENCES `Pizzeria`.`cliente` (`idcliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `repartidor`
    FOREIGN KEY (`repartidor`)
    REFERENCES `Pizzeria`.`empleado` (`idempleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ref_tienda`
    FOREIGN KEY (`tienda`)
    REFERENCES `Pizzeria`.`tienda` (`idtienda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Pizzeria`.`comanda_detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pizzeria`.`comanda_detail` (
  `id_detalle` INT NOT NULL AUTO_INCREMENT,
  `id_comanda` INT NOT NULL,
  `id_productos` INT NOT NULL,
  `cantifdad` INT NOT NULL,
  PRIMARY KEY (`id_detalle`),
  INDEX `productos_comanda1_idx` (`id_productos` ASC) VISIBLE,
  INDEX `pedido_idx` (`id_comanda` ASC) VISIBLE,
  CONSTRAINT `productos_comanda1`
    FOREIGN KEY (`id_productos`)
    REFERENCES `Pizzeria`.`producto` (`id_producto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `pedido`
    FOREIGN KEY (`id_comanda`)
    REFERENCES `Pizzeria`.`comanda` (`idcomanda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- ingreso dos tiendas en la tabla de tienda
USE Pizzeria;
INSERT INTO tienda (direccion, codigo_postal, localidad, provincia) 
VALUES ("Arago 33", 08001, "Barcelona","Barcelona"), ("Girona 45", 08003, "Sitges","Barcelona");
SELECT * FROM tienda;

-- ingreso dos empleados en cada tienda
 USE Pizzeria;
INSERT INTO empleado (nombre, apellido, NIF, tefelono, categoria, tienda) 
VALUES 
("Pablo", "Perez", "12345678A", 666666666, "cocinero", 1), 
("Martin", "Martinez", "12345678B", 677777777, "repartidor", 1),
("Juan", "Juarez", "12345678C", 688888888, "cocinero", 2), 
("Luciano", "Lopez", "12345678D", 699999999, "repartidor", 2);
SELECT * FROM empleado;

-- ingreso bebibas
USE Pizzeria;
INSERT INTO producto (nombre, descripcion, precio, tipo_producto) 
VALUES 
("Cerveza", "lata de cerveza de 300 ml", 2.5, "Bebida"), 
("Refresco", "lata de refresco a elegir", 2.00, "Bebida"),
("Agua", "botella de 500ml", 1.30, "Bebida"), 
("Vino", "Vino de la casa", 7.45, "Bebida");
SELECT * FROM producto;

USE Pizzeria;
INSERT INTO producto (nombre, descripcion, precio, tipo_producto) 
VALUES 
("Vacuno", "Carne vacuna, lechuga, tomate", 15.5, "Hamburguesa"), 
("Pollo", "Carne de pollo, lechuga, tomate", 11.00, "Hamburguesa"),
("Vegana", "Hambueguesa vegetal, lechuga, tomate", 9.30, "Hamburguesa"); 
SELECT * FROM producto;

-- ingrreso pizzas
USE Pizzeria;
INSERT INTO categoria_pizza (nombre) 
VALUES 
("clasica"), 
("gourmet");
SELECT * FROM categoria_pizza;

INSERT INTO producto (nombre, descripcion, precio, tipo_producto, idcategoria) 
VALUES 
("Margarita", "Mozzarella, tomate", 9.50,"pizza", 1), 
("Rucula", "Mozzarella, rucula, parmesano, tomate", 11.00, "pizza",2),
("Burrata", "Mozzarella, burrata, tomate seco", 14.30, "pizza", 2); 
SELECT * FROM producto;

-- ingreso 4 clientes
USE Pizzeria;
INSERT INTO cliente (nombre, apellido, direccion, codigo_postal, ciudad, provincia, telefono) 
VALUES 
("Ana", "Aguero", "Llanca 3", 08001, "Barcelona","Barcelona", 664321111), 
("Nuria", "Navarra", "Roma 6", 08003, "Barcelona","Barcelona", 664321112),
("Pilar", "Puig", "Paseo Maritimo 45", 08123, "Sitges","Barcelona", 664321113), 
("Luis", "Loque", "Vic 67", 08123, "Sitges","Barcelona", 664321114);
SELECT * FROM cliente;

-- ingreso comandas
USE Pizzeria;
INSERT INTO comanda (fecha_hora, cliente, tipo_recogida, repartidor, hora_entrega, tienda) 
VALUES 
("2023-02-23 21:22:00", 1, "Domicilio", 2,  "2023-02-23 22:22:00", 1);
SELECT * FROM comanda;
INSERT INTO comanda_detail (id_comanda, id_productos, cantifdad) 
VALUES 
( 1, 3 , 4);
SELECT * FROM comanda_detail;

-- para consultar las bebidas vendidas en una ciudad en particular
SELECT COUNT(DISTINCT comanda.idcomanda) AS cantidad_bebidas
FROM comanda
INNER JOIN productos_comanda ON comanda.idcomanda = comanda_detail.idcomanda
INNER JOIN productos ON comanda_detail.idproducto = productos.idproducto
INNER JOIN bebida ON productos.producto = bebida.idbebida
INNER JOIN cliente ON comanda.idcliente = cliente.idcliente
WHERE cliente.localidad = "Barcelona";

-- para consultar comandas que hizo un determinado empleado
SELECT COUNT(*) AS comanda
FROM comanda
WHERE repartidor = 2;

