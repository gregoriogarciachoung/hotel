-- phpMyAdmin SQL Dump
-- version 4.4.14
-- http://www.phpmyadmin.net
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 06-12-2017 a las 20:51:04
-- Versión del servidor: 5.6.26
-- Versión de PHP: 5.6.12
drop database if exists hotel;
CREATE DATABASE hotel;
use hotel;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `hotel`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ps_consultarHospedajePorCodigo`(cod char(7))
begin
	select h.codigo, r.codigo, r.cliente, r.nombreCompleto, r.fechaInicio, r.fechaFin, r.estado
	from hospedaje h
	join reserva r
	on h.reserva = r.codigo
	where r.codigo = cod
	and r.estado = 1;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ps_consultarHospedajePorHabitacion`(cod int)
begin
	select dh.habitacion, dh.descripcion, r.fechaInicio, r.fechaFin, r.nombreCompleto, r.codigo
	from reserva r
	join hospedaje h
	on r.codigo = h.reserva
	join detalleHospedaje dh
	on h.codigo = dh.hospedaje
	where dh.habitacion = cod
	and curdate() between r.fechaInicio and r.fechaFin; 
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ps_insertaServicioALaHabitacion`(ser int, can int, hab int, res char(7))
begin
	insert into detalleServicioHabitacion values(ser, can, hab, res);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ps_listarHabitacionesPorReserva`(fecIni date, fecFin date)
select t.id, t.nombre, t.precio, count(*) as 'nHabitaciones',  t.numPersonas
from habitacion h
join tipoHabitacion t
on h.tipo = t.id
where h.numHabitacion not in
(select rh.habitacion 
from reservaHabitacion rh
join reserva r
on rh.codigo = r.codigo
where fecIni between r.fechaInicio and r.fechaFin
or
fecFin between r.fechaInicio and r.fechaFin
or 
r.fechaInicio >= fecIni and r.fechaFin <=fecFin)
group by h.tipo$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ps_listarHabitacionesPorReserva2`(res char(7))
begin
	select h.numHabitacion, th.nombre, th.precio
	from reservaHabitacion rh
	join habitacion h
	on rh.habitacion = h.numHabitacion
	join tipoHabitacion th
	on th.id = h.tipo where rh.codigo = res; 
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ps_listarHabitacionPorHospedaje`(cod char(7))
begin
	select habitacion, descripcion from detallehospedaje where hospedaje = cod;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ps_listarServicioAHabitacionPorHospedaje`(cod char(7))
begin
	select dsh.habitacion, sh.nombre, sh.precio * dsh.cantidad
	from detalleserviciohabitacion dsh
	join servicioHabitacion sh
	on dsh.servicio = sh.id
	where reserva = cod;
end$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ps_reservarHabitacion`(tipoHabit varchar(45), cantHabit int, pdni char(9), fecIni date, fecFin date)
 begin
 DECLARE done BOOLEAN DEFAULT FALSE;
DECLARE a int;
declare resv char(7);
-- lee el id de la tabla1 y guarda los valores en c1
 DECLARE c1 CURSOR FOR
       select h.numHabitacion
from habitacion h
join tipoHabitacion t
on h.tipo = t.id
where h.numHabitacion not in
(select rh.habitacion 
from reservaHabitacion rh
join reserva r
on rh.codigo = r.codigo
where r.fechaInicio between fecIni and fecFin or r.fechaFin between fecIni and fecFin
)
and t.id = fn_idTipoHabitacion(tipoHabit) limit cantHabit;
        

      DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = TRUE;
     open c1;
	  	c1_loop: LOOP
	  	-- fetch c1 into a dice-> a = id)
			fetch c1 into a;
         IF done THEN LEAVE c1_loop; END IF; 
         -- "busque ese nro en otra tabla(2)"
         -- ese nro = a
         -- "y si en 2 ese nro no esta que genere un registro nuevo con el valor"
    -- select a;
     set resv = (select codigo from reserva where cliente = pdni and fechaInicio = fecIni and fechaFin = fecFin);       
   
     insert into reservaHabitacion(codigo, habitacion)values(resv,a);
   
		END LOOP c1_loop;
	CLOSE c1;
END$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_procesarAhora`(pres char(7))
 begin
 DECLARE done BOOLEAN DEFAULT FALSE;
DECLARE a int;
declare resv char(7);
declare ultHospedaje char(7);
-- lee el id de la tabla1 y guarda los valores en c1
 DECLARE c1 CURSOR FOR
      select habitacion from reservahabitacion where codigo = pres;
        

      DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = TRUE;
      update reserva set estado = 1 where codigo = pres;
		insert into hospedaje values (fn_generaCodigoHospedaje(), curdate(), pres);
		set ultHospedaje = (select codigo from hospedaje where reserva = pres);
     open c1;
	  	c1_loop: LOOP
	  	-- fetch c1 into a dice-> a = id)
			fetch c1 into a;
         IF done THEN LEAVE c1_loop; END IF; 
         -- "busque ese nro en otra tabla(2)"
         -- ese nro = a
         -- "y si en 2 ese nro no esta que genere un registro nuevo con el valor"
    -- select a;
     -- set resv = (select codigo from reserva where cliente = pdni and fechaInicio = fecIni and fechaFin = fecFin);       
   	
     	insert into detalleHospedaje values (ultHospedaje, a, 'Sin Nombre');
   
		END LOOP c1_loop;
	CLOSE c1;
END$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ps_verReserva`(cod char(7))
begin
	select codigo, cliente, nombreCompleto, fechaInicio, fechaFin, estado from reserva where codigo = cod;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ps_verReservaPorDni`(cod char(8))
begin
	select codigo, cliente, nombreCompleto, fechaInicio, fechaFin, estado from reserva where cliente = cod and fechaInicio = curdate();

end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_checkIn`(codReserva char(7))
begin
	update reserva set estado = 1 where codigo = codReserva;
	insert into hospedaje values (fn_generaCodigoHospedaje(), curdate(), codReserva);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_checkInDetalle`(numHabit int, descrip varchar(90), presv char(7))
begin
	declare ultHospedaje char(7);
	set ultHospedaje = (select codigo from hospedaje where reserva = presv);
	insert into detalleHospedaje values (ultHospedaje, numHabit, descrip);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_mostrarUltimaReserva`()
select codigo, nombreCompleto,fechaInicio, fechaFin  from Reserva order by codigo desc limit 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registraReserva`(fecIni date, fecFin date, dni char(8), nom varchar(90))
insert into reserva values (fn_generaCodigoReserva(), fecIni, fecfin, dni, nom, 0)$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_generaCodigoHospedaje`() RETURNS char(7) CHARSET latin1
begin
declare getCod char(7);
declare numero int;
declare setCod char(7);
declare validar int;

set validar = (select count(*) from hospedaje);

set getCod = (select codigo from hospedaje order by codigo desc limit 1);
set numero = subString(getCod,2,7);

if(validar = 0)then
	set setCod = concat('H00000',1);
else
		if(numero < 9)then
		set setCod = concat('H00000',numero+1);
	elseif(numero < 99)then
		set setCod = concat('H0000',numero+1);
	elseif(numero < 999)then
		set setCod = concat('H000',numero+1);
	elseif(numero < 9999)then
		set setCod = concat('H00',numero+1);
	elseif(numero < 99999)then
		set setCod = concat('H0',numero+1);
	elseif(numero < 999999)then
		set setCod = concat('H',numero+1);
	end if;
end if;
return setCod;
end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_generaCodigoReserva`() RETURNS char(7) CHARSET latin1
begin
declare getCod char(7);
declare numero int;
declare setCod char(7);
declare validar int;

set validar = (select count(*) from reserva);

set getCod = (select codigo from reserva order by codigo desc limit 1);
set numero = subString(getCod,2,7);

if(validar = 0)then
	set setCod = concat('R00000',1);
else
		if(numero < 9)then
		set setCod = concat('R00000',numero+1);
	elseif(numero < 99)then
		set setCod = concat('R0000',numero+1);
	elseif(numero < 999)then
		set setCod = concat('R000',numero+1);
	elseif(numero < 9999)then
		set setCod = concat('R00',numero+1);
	elseif(numero < 99999)then
		set setCod = concat('R0',numero+1);
	elseif(numero < 999999)then
		set setCod = concat('R',numero+1);
	end if;
end if;
return setCod;
end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_idTipoHabitacion`(p_nom varchar(45)) RETURNS int(11)
begin
return (select id from tipoHabitacion where nombre = p_nom);
end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_nomTipoHabitacion`(p_id int) RETURNS varchar(45) CHARSET latin1
begin
return (select nombre from tipoHabitacion where id = p_id);
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detallehospedaje`
--

CREATE TABLE IF NOT EXISTS `detallehospedaje` (
  `hospedaje` char(7) DEFAULT NULL,
  `habitacion` int(11) DEFAULT NULL,
  `descripcion` varchar(90) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalleserviciohabitacion`
--

CREATE TABLE IF NOT EXISTS `detalleserviciohabitacion` (
  `servicio` int(11) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `habitacion` int(11) DEFAULT NULL,
  `reserva` char(7) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `habitacion`
--

CREATE TABLE IF NOT EXISTS `habitacion` (
  `numHabitacion` int(11) NOT NULL,
  `tipo` int(11) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `habitacion`
--

INSERT INTO `habitacion` (`numHabitacion`, `tipo`, `estado`) VALUES
(1, 3, 0),
(2, 3, 0),
(3, 3, 0),
(4, 2, 0),
(5, 1, 0),
(6, 1, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `habitacion_mantenimiento`
--

CREATE TABLE IF NOT EXISTS `habitacion_mantenimiento` (
  `codigo` char(7) NOT NULL,
  `fechaInicio` date DEFAULT NULL,
  `fechaFin` date DEFAULT NULL,
  `habitacion` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `hospedaje`
--

CREATE TABLE IF NOT EXISTS `hospedaje` (
  `codigo` char(7) NOT NULL,
  `fechaLlegada` date DEFAULT NULL,
  `reserva` char(7) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reserva`
--

CREATE TABLE IF NOT EXISTS `reserva` (
  `codigo` char(7) NOT NULL,
  `fechaInicio` date DEFAULT NULL,
  `fechaFin` date DEFAULT NULL,
  `cliente` char(8) DEFAULT NULL,
  `nombreCompleto` varchar(90) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reservahabitacion`
--

CREATE TABLE IF NOT EXISTS `reservahabitacion` (
  `codigo` char(7) DEFAULT NULL,
  `habitacion` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `serviciohabitacion`
--

CREATE TABLE IF NOT EXISTS `serviciohabitacion` (
  `id` int(11) NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `descripcion` varchar(45) DEFAULT NULL,
  `precio` double DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `serviciohabitacion`
--

INSERT INTO `serviciohabitacion` (`id`, `nombre`, `descripcion`, `precio`) VALUES
(1, 'Lavenderia', 'servicio de lavado de ropa', 30),
(2, 'Desayuno', 'servicio de desyuno', 10),
(3, 'Almuerzo', 'servicio de almuerzo', 10),
(4, 'Cena', 'servicio de cena', 10),
(5, 'Spa', 'servicio de spa', 100),
(6, 'Relax', 'servicio de relax', 100);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipohabitacion`
--

CREATE TABLE IF NOT EXISTS `tipohabitacion` (
  `id` int(11) NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `descripcion` varchar(45) DEFAULT NULL,
  `numPersonas` int(11) DEFAULT NULL,
  `precio` double DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `tipohabitacion`
--

INSERT INTO `tipohabitacion` (`id`, `nombre`, `descripcion`, `numPersonas`, `precio`) VALUES
(1, 'Especial', 'abc', 3, 350),
(2, 'Matrimonial', 'abc', 2, 300),
(3, 'Simple', 'abc', 1, 30);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `detallehospedaje`
--
ALTER TABLE `detallehospedaje`
  ADD KEY `hospedaje` (`hospedaje`),
  ADD KEY `habitacion` (`habitacion`);

--
-- Indices de la tabla `detalleserviciohabitacion`
--
ALTER TABLE `detalleserviciohabitacion`
  ADD KEY `servicio` (`servicio`),
  ADD KEY `habitacion` (`habitacion`),
  ADD KEY `reserva` (`reserva`);

--
-- Indices de la tabla `habitacion`
--
ALTER TABLE `habitacion`
  ADD PRIMARY KEY (`numHabitacion`),
  ADD KEY `tipo` (`tipo`);

--
-- Indices de la tabla `habitacion_mantenimiento`
--
ALTER TABLE `habitacion_mantenimiento`
  ADD PRIMARY KEY (`codigo`),
  ADD KEY `habitacion` (`habitacion`);

--
-- Indices de la tabla `hospedaje`
--
ALTER TABLE `hospedaje`
  ADD PRIMARY KEY (`codigo`),
  ADD KEY `reserva` (`reserva`);

--
-- Indices de la tabla `reserva`
--
ALTER TABLE `reserva`
  ADD PRIMARY KEY (`codigo`);

--
-- Indices de la tabla `reservahabitacion`
--
ALTER TABLE `reservahabitacion`
  ADD KEY `codigo` (`codigo`),
  ADD KEY `habitacion` (`habitacion`);

--
-- Indices de la tabla `serviciohabitacion`
--
ALTER TABLE `serviciohabitacion`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tipohabitacion`
--
ALTER TABLE `tipohabitacion`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `habitacion`
--
ALTER TABLE `habitacion`
  MODIFY `numHabitacion` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT de la tabla `serviciohabitacion`
--
ALTER TABLE `serviciohabitacion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT de la tabla `tipohabitacion`
--
ALTER TABLE `tipohabitacion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detallehospedaje`
--
ALTER TABLE `detallehospedaje`
  ADD CONSTRAINT `detallehospedaje_ibfk_1` FOREIGN KEY (`hospedaje`) REFERENCES `hospedaje` (`codigo`),
  ADD CONSTRAINT `detallehospedaje_ibfk_2` FOREIGN KEY (`habitacion`) REFERENCES `habitacion` (`numHabitacion`);

--
-- Filtros para la tabla `detalleserviciohabitacion`
--
ALTER TABLE `detalleserviciohabitacion`
  ADD CONSTRAINT `detalleserviciohabitacion_ibfk_1` FOREIGN KEY (`servicio`) REFERENCES `serviciohabitacion` (`id`),
  ADD CONSTRAINT `detalleserviciohabitacion_ibfk_2` FOREIGN KEY (`habitacion`) REFERENCES `habitacion` (`numHabitacion`),
  ADD CONSTRAINT `detalleserviciohabitacion_ibfk_3` FOREIGN KEY (`reserva`) REFERENCES `reserva` (`codigo`);

--
-- Filtros para la tabla `habitacion`
--
ALTER TABLE `habitacion`
  ADD CONSTRAINT `habitacion_ibfk_1` FOREIGN KEY (`tipo`) REFERENCES `tipohabitacion` (`id`);

--
-- Filtros para la tabla `habitacion_mantenimiento`
--
ALTER TABLE `habitacion_mantenimiento`
  ADD CONSTRAINT `habitacion_mantenimiento_ibfk_1` FOREIGN KEY (`habitacion`) REFERENCES `habitacion` (`numHabitacion`);

--
-- Filtros para la tabla `hospedaje`
--
ALTER TABLE `hospedaje`
  ADD CONSTRAINT `hospedaje_ibfk_1` FOREIGN KEY (`reserva`) REFERENCES `reserva` (`codigo`);

--
-- Filtros para la tabla `reservahabitacion`
--
ALTER TABLE `reservahabitacion`
  ADD CONSTRAINT `reservahabitacion_ibfk_1` FOREIGN KEY (`codigo`) REFERENCES `reserva` (`codigo`),
  ADD CONSTRAINT `reservahabitacion_ibfk_2` FOREIGN KEY (`habitacion`) REFERENCES `habitacion` (`numHabitacion`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
