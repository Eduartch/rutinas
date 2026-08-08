/*
SQLyog Ultimate v12.09 (64 bit)
MySQL - 11.4.10-MariaDB : Database - sysven_bdgigantes
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `vmuestracompras1` */

DROP TABLE IF EXISTS `vmuestracompras1`;

/*!50001 DROP VIEW IF EXISTS `vmuestracompras1` */;
/*!50001 DROP TABLE IF EXISTS `vmuestracompras1` */;

/*!50001 CREATE TABLE  `vmuestracompras1`(
 `idauto` int(11) ,
 `alma` int(11) ,
 `idkar` int(11) ,
 `idart` int(11) ,
 `incl` char(1) ,
 `descri` varchar(180) ,
 `unid` varchar(20) ,
 `peso` float ,
 `cant` decimal(12,2) ,
 `prec` float ,
 `tipo` varchar(1) ,
 `dsnc` int(11) ,
 `dsnd` int(11) ,
 `gast` int(11) 
)*/;

/*Table structure for table `vlcajacl` */

DROP TABLE IF EXISTS `vlcajacl`;

/*!50001 DROP VIEW IF EXISTS `vlcajacl` */;
/*!50001 DROP TABLE IF EXISTS `vlcajacl` */;

/*!50001 CREATE TABLE  `vlcajacl`(
 `lcaj_idca` int(11) ,
 `razo` varchar(100) 
)*/;

/*Table structure for table `vmuestravtas` */

DROP TABLE IF EXISTS `vmuestravtas`;

/*!50001 DROP VIEW IF EXISTS `vmuestravtas` */;
/*!50001 DROP TABLE IF EXISTS `vmuestravtas` */;

/*!50001 CREATE TABLE  `vmuestravtas`(
 `idusua` int(10) unsigned ,
 `kar_comi` float ,
 `codv` int(11) ,
 `idauto` int(11) ,
 `alma` int(11) ,
 `idcosto` int(11) ,
 `idkar` int(11) ,
 `Coda` int(11) ,
 `cant` decimal(12,2) ,
 `prec` float ,
 `valor` decimal(12,2) ,
 `igv` decimal(12,2) ,
 `impo` decimal(12,2) ,
 `fech` date ,
 `fecr` date ,
 `form` varchar(1) ,
 `deta` varchar(200) ,
 `exon` varchar(1) ,
 `ndo2` varchar(10) ,
 `idclie` int(11) ,
 `razo` varchar(100) ,
 `nruc` varchar(11) ,
 `dire` varchar(100) ,
 `ciud` varchar(100) ,
 `ndni` varchar(11) ,
 `tipo` varchar(1) ,
 `tdoc` varchar(2) ,
 `ndoc` varchar(14) ,
 `dolar` decimal(7,3) ,
 `mone` varchar(1) ,
 `vigv` float ,
 `dsnc` int(11) ,
 `dsnd` int(11) ,
 `gast` int(11) ,
 `idcliente` int(11) ,
 `codt` int(11) ,
 `fusua` datetime ,
 `descri` varchar(180) ,
 `unid` varchar(20) ,
 `usuario` varchar(45) 
)*/;

/*Table structure for table `vutilidad` */

DROP TABLE IF EXISTS `vutilidad`;

/*!50001 DROP VIEW IF EXISTS `vutilidad` */;
/*!50001 DROP TABLE IF EXISTS `vutilidad` */;

/*!50001 CREATE TABLE  `vutilidad`(
 `fecha` date ,
 `Documento` varchar(14) ,
 `Cliente` varchar(100) ,
 `costo` double(19,2) ,
 `precio` double ,
 `Vendedor` varchar(100) ,
 `usuario` varchar(45) ,
 `FechaHora` datetime ,
 `x` varchar(2) ,
 `idauto` int(11) ,
 `codv` int(11) 
)*/;

/*Table structure for table `vguiasventas` */

DROP TABLE IF EXISTS `vguiasventas`;

/*!50001 DROP VIEW IF EXISTS `vguiasventas` */;
/*!50001 DROP TABLE IF EXISTS `vguiasventas` */;

/*!50001 CREATE TABLE  `vguiasventas`(
 `idguia` int(10) unsigned ,
 `coda` int(11) ,
 `descri` varchar(180) ,
 `unid` varchar(20) ,
 `ndoc` varchar(12) ,
 `fech` date ,
 `fect` date ,
 `ptoll` varchar(150) ,
 `detalle` varchar(150) ,
 `cant` decimal(12,2) ,
 `placa` varchar(10) ,
 `Transportista` varchar(50) ,
 `ructr` varchar(11) ,
 `Chofer` varchar(50) ,
 `Brevete` varchar(25) ,
 `Constancia` varchar(40) ,
 `marca` varchar(50) ,
 `Direccion` varchar(50) ,
 `usuario` varchar(45) ,
 `cliente` varchar(100) ,
 `idcliente` int(11) ,
 `refe` varchar(14) ,
 `tdoc` varchar(2) ,
 `guia_mens` varchar(120) ,
 `guia_arch` varchar(120) ,
 `clie_corr` varchar(45) ,
 `guia_hash` varchar(100) ,
 `guia_feen` datetime ,
 `guia_codt` int(10) unsigned ,
 `guia_tick` varchar(40) 
)*/;

/*Table structure for table `vkardexc` */

DROP TABLE IF EXISTS `vkardexc`;

/*!50001 DROP VIEW IF EXISTS `vkardexc` */;
/*!50001 DROP TABLE IF EXISTS `vkardexc` */;

/*!50001 CREATE TABLE  `vkardexc`(
 `idart` int(11) ,
 `tipo` varchar(1) ,
 `cant` decimal(12,2) 
)*/;

/*Table structure for table `vpentregas` */

DROP TABLE IF EXISTS `vpentregas`;

/*!50001 DROP VIEW IF EXISTS `vpentregas` */;
/*!50001 DROP TABLE IF EXISTS `vpentregas` */;

/*!50001 CREATE TABLE  `vpentregas`(
 `idped` int(10) unsigned ,
 `entregado` decimal(13,2) ,
 `pent_idpr` int(10) unsigned ,
 `pent_idpe` int(10) unsigned 
)*/;

/*Table structure for table `vlcajapr` */

DROP TABLE IF EXISTS `vlcajapr`;

/*!50001 DROP VIEW IF EXISTS `vlcajapr` */;
/*!50001 DROP TABLE IF EXISTS `vlcajapr` */;

/*!50001 CREATE TABLE  `vlcajapr`(
 `lcaj_idca` int(11) ,
 `razo` varchar(100) 
)*/;

/*Table structure for table `vpdtespagocompras` */

DROP TABLE IF EXISTS `vpdtespagocompras`;

/*!50001 DROP VIEW IF EXISTS `vpdtespagocompras` */;
/*!50001 DROP TABLE IF EXISTS `vpdtespagocompras` */;

/*!50001 CREATE TABLE  `vpdtespagocompras`(
 `saldo` decimal(35,2) ,
 `ncontrol` int(11) ,
 `fevto` date ,
 `rdeu_idpr` int(11) ,
 `rdeu_mone` char(1) 
)*/;

/*Table structure for table `vgr` */

DROP TABLE IF EXISTS `vgr`;

/*!50001 DROP VIEW IF EXISTS `vgr` */;
/*!50001 DROP TABLE IF EXISTS `vgr` */;

/*!50001 CREATE TABLE  `vgr`(
 `tdoc` varchar(2) ,
 `ndoc` varchar(14) ,
 `fech` date ,
 `dolar` decimal(7,3) ,
 `guic_idac` int(10) unsigned ,
 `guic_idau` int(10) unsigned ,
 `mone` varchar(1) 
)*/;

/*Table structure for table `vcambioanterior` */

DROP TABLE IF EXISTS `vcambioanterior`;

/*!50001 DROP VIEW IF EXISTS `vcambioanterior` */;
/*!50001 DROP TABLE IF EXISTS `vcambioanterior` */;

/*!50001 CREATE TABLE  `vcambioanterior`(
 `ndoc` varchar(14) ,
 `tdoc` varchar(2) ,
 `razo` varchar(100) ,
 `impo` decimal(12,2) ,
 `nomb` varchar(45) ,
 `fusua` datetime ,
 `descri` varchar(180) ,
 `unid` varchar(20) ,
 `cant` decimal(12,2) ,
 `prec` float ,
 `importe` double(19,2) ,
 `camb_idaa` int(11) ,
 `camb_fope` datetime ,
 `idauto` int(11) ,
 `acti` char(1) 
)*/;

/*Table structure for table `vlistaprecios` */

DROP TABLE IF EXISTS `vlistaprecios`;

/*!50001 DROP VIEW IF EXISTS `vlistaprecios` */;
/*!50001 DROP TABLE IF EXISTS `vlistaprecios` */;

/*!50001 CREATE TABLE  `vlistaprecios`(
 `idart` int(11) ,
 `descri` varchar(180) ,
 `unid` varchar(20) ,
 `uno` float ,
 `dos` float ,
 `tre` float ,
 `cua` float ,
 `cero` float ,
 `pre1` double(19,2) ,
 `pre2` double(19,2) ,
 `pre3` double(19,2) ,
 `costo` double(19,2) ,
 `idgrupo` int(10) unsigned ,
 `dcat` varchar(100) ,
 `prod_dola` float ,
 `costosf` double(19,2) ,
 `flete` decimal(10,4) ,
 `costor` double(10,2) ,
 `precr` double ,
 `moner` varchar(1) ,
 `cost_idco` bigint(20) unsigned ,
 `fleter` double ,
 `dolar` double ,
 `peso` float ,
 `prec` float ,
 `tipro` varchar(1) ,
 `idmar` int(11) ,
 `idcat` int(11) ,
 `cost` float ,
 `tmon` varchar(1) ,
 `idflete` int(11) ,
 `prod_uti1` decimal(10,8) ,
 `prod_uti2` decimal(10,8) ,
 `prod_uti3` decimal(10,8) ,
 `prod_come` float ,
 `prod_comc` float ,
 `ulpc` int(11) ,
 `prod_idus` int(11) ,
 `prod_uact` int(11) ,
 `prod_fact` datetime ,
 `fechc` datetime ,
 `prod_smax` float ,
 `prod_smin` float ,
 `proveedor` varchar(100) ,
 `ndoc` varchar(14) ,
 `fech` varchar(10) ,
 `ulfc` date 
)*/;

/*Table structure for table `vguiasdevolucion` */

DROP TABLE IF EXISTS `vguiasdevolucion`;

/*!50001 DROP VIEW IF EXISTS `vguiasdevolucion` */;
/*!50001 DROP TABLE IF EXISTS `vguiasdevolucion` */;

/*!50001 CREATE TABLE  `vguiasdevolucion`(
 `idguia` int(10) unsigned ,
 `coda` int(11) ,
 `descri` varchar(180) ,
 `unid` varchar(20) ,
 `ndoc` varchar(12) ,
 `fech` date ,
 `fect` date ,
 `ptoll` varchar(150) ,
 `detalle` varchar(150) ,
 `cant` decimal(12,2) ,
 `placa` varchar(10) ,
 `Transportista` varchar(50) ,
 `ructr` varchar(11) ,
 `Chofer` varchar(50) ,
 `Brevete` varchar(25) ,
 `Constancia` varchar(40) ,
 `marca` varchar(50) ,
 `Direccion` varchar(50) ,
 `usuario` varchar(45) ,
 `cliente` varchar(100) ,
 `idprov` int(11) ,
 `refe` varchar(14) ,
 `tdoc` varchar(2) ,
 `guia_mens` varchar(120) ,
 `guia_arch` varchar(120) ,
 `email` varchar(45) ,
 `guia_hash` varchar(100) ,
 `guia_feen` datetime ,
 `guia_codt` int(10) unsigned ,
 `guia_tick` varchar(40) 
)*/;

/*Table structure for table `vguiascompras` */

DROP TABLE IF EXISTS `vguiascompras`;

/*!50001 DROP VIEW IF EXISTS `vguiascompras` */;
/*!50001 DROP TABLE IF EXISTS `vguiascompras` */;

/*!50001 CREATE TABLE  `vguiascompras`(
 `guic_idau` int(10) unsigned ,
 `guic_tipo` char(1) ,
 `guic_idac` bigint(11) 
)*/;

/*Table structure for table `vpedidosvtas` */

DROP TABLE IF EXISTS `vpedidosvtas`;

/*!50001 DROP VIEW IF EXISTS `vpedidosvtas` */;
/*!50001 DROP TABLE IF EXISTS `vpedidosvtas` */;

/*!50001 CREATE TABLE  `vpedidosvtas`(
 `idauto` int(11) ,
 `alma` int(11) ,
 `idart` int(11) ,
 `idkar` int(11) ,
 `Pedido` decimal(12,2) ,
 `codv` int(11) 
)*/;

/*Table structure for table `vsaldosctaspagar` */

DROP TABLE IF EXISTS `vsaldosctaspagar`;

/*!50001 DROP VIEW IF EXISTS `vsaldosctaspagar` */;
/*!50001 DROP TABLE IF EXISTS `vsaldosctaspagar` */;

/*!50001 CREATE TABLE  `vsaldosctaspagar`(
 `rdeu_idrd` int(10) unsigned ,
 `Saldo` decimal(35,2) ,
 `ncontrol` int(11) 
)*/;

/*Table structure for table `vmuestractascompras` */

DROP TABLE IF EXISTS `vmuestractascompras`;

/*!50001 DROP VIEW IF EXISTS `vmuestractascompras` */;
/*!50001 DROP TABLE IF EXISTS `vmuestractascompras` */;

/*!50001 CREATE TABLE  `vmuestractascompras`(
 `tdoc` varchar(3) ,
 `ndoc` varchar(14) ,
 `fecr` date ,
 `ncta` varchar(8) ,
 `razo` varchar(100) ,
 `Debe` decimal(17,2) ,
 `Haber` decimal(17,2) ,
 `idcta` int(10) unsigned ,
 `fech` date ,
 `nomb` varchar(60) ,
 `tipo` char(1) ,
 `idrcon` int(11) ,
 `mone` varchar(1) ,
 `idprov` int(11) ,
 `idectas` int(10) unsigned 
)*/;

/*Table structure for table `vregcompras` */

DROP TABLE IF EXISTS `vregcompras`;

/*!50001 DROP VIEW IF EXISTS `vregcompras` */;
/*!50001 DROP TABLE IF EXISTS `vregcompras` */;

/*!50001 CREATE TABLE  `vregcompras`(
 `fech` date ,
 `fecr` date ,
 `tdoc` varchar(2) ,
 `ndoc` varchar(14) ,
 `idprov` int(11) ,
 `vigv` float ,
 `ndo2` varchar(10) ,
 `mone` varchar(1) ,
 `valor` decimal(12,2) ,
 `igv` decimal(12,2) ,
 `impo` decimal(12,2) ,
 `codt` int(11) ,
 `dola` decimal(7,3) ,
 `form` varchar(1) ,
 `idauto` int(11) ,
 `usuario` varchar(45) ,
 `fusua` datetime ,
 `razo` varchar(100) ,
 `nruc` varchar(11) ,
 `dire` varchar(100) ,
 `ciud` varchar(100) ,
 `fono` varchar(15) 
)*/;

/*Table structure for table `ventregas` */

DROP TABLE IF EXISTS `ventregas`;

/*!50001 DROP VIEW IF EXISTS `ventregas` */;
/*!50001 DROP TABLE IF EXISTS `ventregas` */;

/*!50001 CREATE TABLE  `ventregas`(
 `entr_idkar` int(10) unsigned ,
 `entregado` decimal(34,2) 
)*/;

/*Table structure for table `vpdtespagoc` */

DROP TABLE IF EXISTS `vpdtespagoc`;

/*!50001 DROP VIEW IF EXISTS `vpdtespagoc` */;
/*!50001 DROP TABLE IF EXISTS `vpdtespagoc` */;

/*!50001 CREATE TABLE  `vpdtespagoc`(
 `idclie` int(11) ,
 `ndoc` varchar(12) ,
 `importe` decimal(33,2) ,
 `mone` varchar(1) ,
 `banc` varchar(180) ,
 `fech` date ,
 `razo` varchar(100) ,
 `fono` varchar(15) ,
 `dire` varchar(100) ,
 `ciud` varchar(100) ,
 `fevto` date ,
 `tipo` varchar(1) ,
 `dola` float ,
 `docd` varchar(14) ,
 `nrou` varchar(40) ,
 `banco` varchar(120) ,
 `idcred` int(11) ,
 `idauto` int(10) unsigned ,
 `nomv` varchar(100) ,
 `ncontrol` int(11) 
)*/;

/*Table structure for table `vcambioactual` */

DROP TABLE IF EXISTS `vcambioactual`;

/*!50001 DROP VIEW IF EXISTS `vcambioactual` */;
/*!50001 DROP TABLE IF EXISTS `vcambioactual` */;

/*!50001 CREATE TABLE  `vcambioactual`(
 `ndoc` varchar(14) ,
 `tdoc` varchar(2) ,
 `razo` varchar(100) ,
 `impo` decimal(12,2) ,
 `nomb` varchar(45) ,
 `fusua` datetime ,
 `descri` varchar(180) ,
 `unid` varchar(20) ,
 `cant` decimal(12,2) ,
 `prec` float ,
 `importe` double(19,2) ,
 `camb_idac` int(11) ,
 `camb_idaa` int(11) ,
 `camb_fope` datetime ,
 `fech` date ,
 `idauto` int(11) 
)*/;

/*Table structure for table `vpdtesvtas` */

DROP TABLE IF EXISTS `vpdtesvtas`;

/*!50001 DROP VIEW IF EXISTS `vpdtesvtas` */;
/*!50001 DROP TABLE IF EXISTS `vpdtesvtas` */;

/*!50001 CREATE TABLE  `vpdtesvtas`(
 `idauto` int(11) ,
 `idkar` int(11) ,
 `Pedido` decimal(12,2) ,
 `Entregado` bigint(20) unsigned 
)*/;

/*Table structure for table `vguiasrcompras` */

DROP TABLE IF EXISTS `vguiasrcompras`;

/*!50001 DROP VIEW IF EXISTS `vguiasrcompras` */;
/*!50001 DROP TABLE IF EXISTS `vguiasrcompras` */;

/*!50001 CREATE TABLE  `vguiasrcompras`(
 `idguia` int(10) unsigned ,
 `coda` int(11) ,
 `descri` varchar(180) ,
 `unid` varchar(20) ,
 `ndoc` varchar(12) ,
 `fech` date ,
 `fect` date ,
 `ptoll` varchar(150) ,
 `detalle` varchar(150) ,
 `cant` decimal(12,2) ,
 `placa` varchar(10) ,
 `Transportista` varchar(50) ,
 `ructr` varchar(11) ,
 `Chofer` varchar(50) ,
 `Brevete` varchar(25) ,
 `Constancia` varchar(40) ,
 `marca` varchar(50) ,
 `Direccion` varchar(50) ,
 `usuario` varchar(45) ,
 `cliente` varchar(100) ,
 `idprov` int(11) ,
 `refe` varchar(12) ,
 `tdoc` varchar(2) ,
 `guia_mens` varchar(120) ,
 `guia_arch` varchar(120) ,
 `email` varchar(100) ,
 `guia_hash` varchar(100) ,
 `guia_feen` datetime ,
 `guia_codt` int(10) unsigned ,
 `guia_tick` varchar(40) 
)*/;

/*Table structure for table `vcambio` */

DROP TABLE IF EXISTS `vcambio`;

/*!50001 DROP VIEW IF EXISTS `vcambio` */;
/*!50001 DROP TABLE IF EXISTS `vcambio` */;

/*!50001 CREATE TABLE  `vcambio`(
 `nomb` varchar(45) ,
 `fusua` datetime ,
 `descri` varchar(180) ,
 `unid` varchar(20) ,
 `camb_cant` float ,
 `camb_prec` float ,
 `importe` double(19,2) ,
 `camb_idac` int(11) ,
 `camb_fope` datetime 
)*/;

/*Table structure for table `vrdespachos` */

DROP TABLE IF EXISTS `vrdespachos`;

/*!50001 DROP VIEW IF EXISTS `vrdespachos` */;
/*!50001 DROP TABLE IF EXISTS `vrdespachos` */;

/*!50001 CREATE TABLE  `vrdespachos`(
 `idusuaPedido` int(10) unsigned ,
 `entr_idkar` int(10) unsigned ,
 `Entregado` decimal(12,2) ,
 `FechaEntrega` date ,
 `IdusuaEntrega` int(10) unsigned ,
 `idauto` int(11) ,
 `idkar` int(11) ,
 `idart` int(11) ,
 `Pedido` decimal(12,2) ,
 `tdoc` varchar(2) ,
 `ndoc` varchar(14) ,
 `FechaPedido` date ,
 `Cliente` varchar(100) ,
 `idclie` int(11) ,
 `entr_acti` char(1) 
)*/;

/*Table structure for table `vmuestracotizaciones` */

DROP TABLE IF EXISTS `vmuestracotizaciones`;

/*!50001 DROP VIEW IF EXISTS `vmuestracotizaciones` */;
/*!50001 DROP TABLE IF EXISTS `vmuestracotizaciones` */;

/*!50001 CREATE TABLE  `vmuestracotizaciones`(
 `idart` int(10) unsigned ,
 `descri` varchar(180) ,
 `unid` varchar(20) ,
 `cant` float ,
 `idven` int(11) ,
 `Vendedor` varchar(100) ,
 `prec` float ,
 `premay` float ,
 `premen` float ,
 `fech` date ,
 `idautop` int(10) unsigned ,
 `impo` decimal(12,2) ,
 `ndoc` varchar(10) ,
 `aten` varchar(45) ,
 `forma` varchar(45) ,
 `plazo` varchar(45) ,
 `validez` varchar(45) ,
 `entrega` varchar(45) ,
 `detalle` varchar(80) ,
 `idclie` int(11) ,
 `razo` varchar(100) ,
 `nruc` varchar(11) ,
 `dire` varchar(100) ,
 `rped_mone` char(1) ,
 `ciud` varchar(100) ,
 `fono` varchar(15) ,
 `fax` varchar(15) ,
 `nreg` int(10) unsigned 
)*/;

/*Table structure for table `vsolopdtes` */

DROP TABLE IF EXISTS `vsolopdtes`;

/*!50001 DROP VIEW IF EXISTS `vsolopdtes` */;
/*!50001 DROP TABLE IF EXISTS `vsolopdtes` */;

/*!50001 CREATE TABLE  `vsolopdtes`(
 `codv` int(11) ,
 `idauto` int(11) ,
 `alma` int(11) ,
 `idart` int(11) ,
 `idkar` int(11) ,
 `Pedido` decimal(12,2) ,
 `Entregado` bigint(20) unsigned ,
 `estado` varchar(1) 
)*/;

/*Table structure for table `vcred` */

DROP TABLE IF EXISTS `vcred`;

/*!50001 DROP VIEW IF EXISTS `vcred` */;
/*!50001 DROP TABLE IF EXISTS `vcred` */;

/*!50001 CREATE TABLE  `vcred`(
 `idrc` int(10) unsigned ,
 `impo` decimal(10,2) 
)*/;

/*Table structure for table `vsaldos` */

DROP TABLE IF EXISTS `vsaldos`;

/*!50001 DROP VIEW IF EXISTS `vsaldos` */;
/*!50001 DROP TABLE IF EXISTS `vsaldos` */;

/*!50001 CREATE TABLE  `vsaldos`(
 `pdte_idar` int(11) ,
 `Pedido` decimal(10,2) ,
 `Entregado` decimal(10,2) ,
 `pdte_idau` int(11) ,
 `pdte_idus` int(10) unsigned ,
 `idin` decimal(10,0) 
)*/;

/*Table structure for table `vpdtespago` */

DROP TABLE IF EXISTS `vpdtespago`;

/*!50001 DROP VIEW IF EXISTS `vpdtespago` */;
/*!50001 DROP TABLE IF EXISTS `vpdtespago` */;

/*!50001 CREATE TABLE  `vpdtespago`(
 `ndoc` varchar(14) ,
 `fech` date ,
 `dola` float ,
 `nrou` varchar(25) ,
 `banc` varchar(180) ,
 `iddeu` int(11) ,
 `fevto` date ,
 `saldo` decimal(35,2) ,
 `Idpr` int(11) ,
 `ImporteC` decimal(12,2) ,
 `situa` varchar(1) ,
 `Idauto` int(10) unsigned ,
 `ncontrol` int(11) ,
 `tipo` varchar(1) ,
 `banco` varchar(45) ,
 `docd` varchar(14) ,
 `tdoc` varchar(2) ,
 `Moneda` char(1) ,
 `Codt` int(10) unsigned ,
 `Idrd` int(10) unsigned ,
 `rdeu_idct` int(10) unsigned 
)*/;

/*Table structure for table `rvendedores` */

DROP TABLE IF EXISTS `rvendedores`;

/*!50001 DROP VIEW IF EXISTS `rvendedores` */;
/*!50001 DROP TABLE IF EXISTS `rvendedores` */;

/*!50001 CREATE TABLE  `rvendedores`(
 `idauto` int(11) ,
 `codv` int(11) 
)*/;

/*Table structure for table `vpdtesentrega` */

DROP TABLE IF EXISTS `vpdtesentrega`;

/*!50001 DROP VIEW IF EXISTS `vpdtesentrega` */;
/*!50001 DROP TABLE IF EXISTS `vpdtesentrega` */;

/*!50001 CREATE TABLE  `vpdtesentrega`(
 `Producto` varchar(180) ,
 `Unidad` varchar(20) ,
 `peso` float ,
 `uno` float ,
 `dos` float ,
 `idart` int(11) ,
 `Pedido` decimal(32,2) ,
 `Entregado` decimal(32,2) ,
 `Saldo` decimal(33,2) ,
 `idin` decimal(10,0) ,
 `tdoc` varchar(2) ,
 `ndoc` varchar(14) ,
 `idauto` int(11) ,
 `Cliente` varchar(100) ,
 `dire` varchar(100) ,
 `ciud` varchar(100) ,
 `nruc` varchar(11) ,
 `fech` date ,
 `ndni` varchar(11) ,
 `idclie` int(11) ,
 `Usuario` varchar(45) 
)*/;

/*Table structure for table `vguiasventas1` */

DROP TABLE IF EXISTS `vguiasventas1`;

/*!50001 DROP VIEW IF EXISTS `vguiasventas1` */;
/*!50001 DROP TABLE IF EXISTS `vguiasventas1` */;

/*!50001 CREATE TABLE  `vguiasventas1`(
 `idguia` int(10) unsigned ,
 `ndoc` varchar(12) ,
 `fech` date ,
 `fect` date ,
 `ptoll` varchar(150) ,
 `detalle` varchar(150) ,
 `cant` decimal(10,2) ,
 `placa` varchar(10) ,
 `Transportista` varchar(50) ,
 `ructr` varchar(11) ,
 `Chofer` varchar(50) ,
 `Brevete` varchar(25) ,
 `Constancia` varchar(40) ,
 `marca` varchar(50) ,
 `Direccion` varchar(50) ,
 `usuario` varchar(45) ,
 `cliente` varchar(100) ,
 `idcliente` int(11) ,
 `refe` varchar(14) ,
 `tdoc` varchar(2) 
)*/;

/*Table structure for table `vmuestraordencompra` */

DROP TABLE IF EXISTS `vmuestraordencompra`;

/*!50001 DROP VIEW IF EXISTS `vmuestraordencompra` */;
/*!50001 DROP TABLE IF EXISTS `vmuestraordencompra` */;

/*!50001 CREATE TABLE  `vmuestraordencompra`(
 `doco_iddo` int(10) unsigned ,
 `doco_coda` int(10) unsigned ,
 `doco_cant` float ,
 `doco_prec` float ,
 `descri` varchar(180) ,
 `prod_smin` float ,
 `unid` varchar(20) ,
 `prod_smax` float ,
 `ocom_valor` float ,
 `ocom_igv` float ,
 `ocom_impo` float ,
 `ocom_idroc` int(10) unsigned ,
 `ocom_fech` date ,
 `ocom_idpr` int(11) ,
 `ocom_desp` varchar(200) ,
 `ocom_form` varchar(100) ,
 `ocom_mone` char(1) ,
 `ocom_ndoc` varchar(10) ,
 `ocom_tigv` char(1) ,
 `ocom_obse` varchar(200) ,
 `ocom_aten` varchar(200) ,
 `ocom_deta` varchar(200) ,
 `ocom_idus` int(10) unsigned ,
 `ocom_fope` datetime ,
 `ocom_idpc` varchar(45) ,
 `ocom_idac` int(10) unsigned ,
 `ocom_fact` datetime ,
 `razo` varchar(100) ,
 `nomb` varchar(45) 
)*/;

/*Table structure for table `vmuestraventas` */

DROP TABLE IF EXISTS `vmuestraventas`;

/*!50001 DROP VIEW IF EXISTS `vmuestraventas` */;
/*!50001 DROP TABLE IF EXISTS `vmuestraventas` */;

/*!50001 CREATE TABLE  `vmuestraventas`(
 `rcom_icbper` decimal(6,2) ,
 `kar_icbper` decimal(6,2) ,
 `rcom_mens` varchar(100) ,
 `idusua` int(10) unsigned ,
 `kar_comi` float ,
 `codv` int(11) ,
 `idauto` int(11) ,
 `alma` int(11) ,
 `idcosto` int(11) ,
 `idkar` int(11) ,
 `Coda` int(11) ,
 `cant` decimal(12,2) ,
 `prec` float ,
 `valor` decimal(12,2) ,
 `igv` decimal(12,2) ,
 `impo` decimal(12,2) ,
 `fech` date ,
 `fecr` date ,
 `form` varchar(1) ,
 `deta` varchar(200) ,
 `exon` varchar(1) ,
 `ndo2` varchar(10) ,
 `rcom_entr` char(1) ,
 `idclie` int(11) ,
 `razo` varchar(100) ,
 `nruc` varchar(11) ,
 `dire` varchar(100) ,
 `ciud` varchar(100) ,
 `ndni` varchar(11) ,
 `tipo` varchar(1) ,
 `tdoc` varchar(2) ,
 `ndoc` varchar(14) ,
 `dolar` decimal(7,3) ,
 `mone` varchar(1) ,
 `descri` varchar(180) ,
 `idcaja` int(11) ,
 `unid` varchar(20) ,
 `pre1` double(19,2) ,
 `peso` float ,
 `pre2` double(19,2) ,
 `nidrv` decimal(10,0) ,
 `vigv` float ,
 `dsnc` int(11) ,
 `dsnd` int(11) ,
 `gast` int(11) ,
 `idcliente` int(11) ,
 `codt` int(11) ,
 `pre3` double(19,2) ,
 `costo` float ,
 `uno` float ,
 `dos` float ,
 `TAlma` double ,
 `fusua` datetime ,
 `Vendedor` varchar(100) ,
 `Usuario` varchar(45) ,
 `rcom_idtr` int(10) unsigned ,
 `rcom_tipo` char(1) 
)*/;

/*Table structure for table `vmuestractasdiario` */

DROP TABLE IF EXISTS `vmuestractasdiario`;

/*!50001 DROP VIEW IF EXISTS `vmuestractasdiario` */;
/*!50001 DROP TABLE IF EXISTS `vmuestractasdiario` */;

/*!50001 CREATE TABLE  `vmuestractasdiario`(
 `Fecha` date ,
 `ncta` varchar(8) ,
 `Glosa` varchar(150) ,
 `Debe` decimal(12,2) ,
 `Haber` decimal(12,2) ,
 `Idcta` int(10) unsigned 
)*/;

/*Table structure for table `vpdtesx` */

DROP TABLE IF EXISTS `vpdtesx`;

/*!50001 DROP VIEW IF EXISTS `vpdtesx` */;
/*!50001 DROP TABLE IF EXISTS `vpdtesx` */;

/*!50001 CREATE TABLE  `vpdtesx`(
 `entregado` decimal(34,2) ,
 `saldo` decimal(35,2) ,
 `idauto` int(11) ,
 `idkar` int(11) ,
 `idart` int(11) 
)*/;

/*Table structure for table `vmuestractasventas` */

DROP TABLE IF EXISTS `vmuestractasventas`;

/*!50001 DROP VIEW IF EXISTS `vmuestractasventas` */;
/*!50001 DROP TABLE IF EXISTS `vmuestractasventas` */;

/*!50001 CREATE TABLE  `vmuestractasventas`(
 `tdoc` varchar(3) ,
 `ndoc` varchar(14) ,
 `fech` date ,
 `ncta` varchar(8) ,
 `razo` varchar(100) ,
 `Debe` decimal(12,2) ,
 `Haber` decimal(12,2) ,
 `tipo` char(1) ,
 `idcta` int(10) unsigned ,
 `nomb` varchar(60) ,
 `idrven` int(11) ,
 `mone` varchar(1) ,
 `idectas` int(10) unsigned ,
 `idclie` int(11) 
)*/;

/*Table structure for table `vrcompras` */

DROP TABLE IF EXISTS `vrcompras`;

/*!50001 DROP VIEW IF EXISTS `vrcompras` */;
/*!50001 DROP TABLE IF EXISTS `vrcompras` */;

/*!50001 CREATE TABLE  `vrcompras`(
 `ndoc` varchar(14) ,
 `valor` decimal(12,2) ,
 `igv` decimal(12,2) ,
 `impo` decimal(12,2) ,
 `pimpo` float ,
 `fech` date ,
 `fecr` date ,
 `form` varchar(1) ,
 `exon` varchar(1) ,
 `ndo2` varchar(10) ,
 `idauto` int(11) ,
 `deta` varchar(200) ,
 `tcom` varchar(1) ,
 `vigv` float ,
 `idprov` int(11) ,
 `tdoc` varchar(2) ,
 `dolar` decimal(7,3) ,
 `mone` varchar(1) ,
 `razo` varchar(100) ,
 `dire` varchar(100) ,
 `ciud` varchar(100) ,
 `nruc` varchar(11) ,
 `Idcaja` int(11) ,
 `codt` int(11) ,
 `fusua` datetime ,
 `Usuario` varchar(45) 
)*/;

/*Table structure for table `vmuestracompras` */

DROP TABLE IF EXISTS `vmuestracompras`;

/*!50001 DROP VIEW IF EXISTS `vmuestracompras` */;
/*!50001 DROP TABLE IF EXISTS `vmuestracompras` */;

/*!50001 CREATE TABLE  `vmuestracompras`(
 `idauto` int(11) ,
 `alma` int(11) ,
 `idkar` int(11) ,
 `descri` varchar(180) ,
 `peso` float ,
 `prod_idco` int(10) unsigned ,
 `unid` varchar(20) ,
 `tipro` varchar(1) ,
 `idart` int(11) ,
 `incl` char(1) ,
 `ndoc` varchar(14) ,
 `valor` decimal(12,2) ,
 `igv` decimal(12,2) ,
 `impo` decimal(12,2) ,
 `pimpo` float ,
 `cant` decimal(12,2) ,
 `prec` float ,
 `fech` date ,
 `fecr` date ,
 `form` varchar(1) ,
 `exon` varchar(1) ,
 `ndo2` varchar(10) ,
 `vigv` float ,
 `idprov` int(11) ,
 `tipo` varchar(1) ,
 `tdoc` varchar(2) ,
 `dolar` decimal(7,3) ,
 `mone` varchar(1) ,
 `razo` varchar(100) ,
 `dire` varchar(100) ,
 `ciud` varchar(100) ,
 `nruc` varchar(11) ,
 `codt` int(11) ,
 `dsnc` int(11) ,
 `dsnd` int(11) ,
 `gast` int(11) ,
 `fusua` datetime ,
 `idusua` int(10) unsigned ,
 `Usuario` varchar(45) 
)*/;

/*View structure for view vmuestracompras1 */

/*!50001 DROP TABLE IF EXISTS `vmuestracompras1` */;
/*!50001 DROP VIEW IF EXISTS `vmuestracompras1` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestracompras1` AS select `a`.`idauto` AS `idauto`,`a`.`alma` AS `alma`,`a`.`idkar` AS `idkar`,`a`.`idart` AS `idart`,`a`.`incl` AS `incl`,`b`.`descri` AS `descri`,`b`.`unid` AS `unid`,`b`.`peso` AS `peso`,`a`.`cant` AS `cant`,`a`.`prec` AS `prec`,`a`.`tipo` AS `tipo`,`a`.`dsnc` AS `dsnc`,`a`.`dsnd` AS `dsnd`,`a`.`gast` AS `gast` from (`fe_kar` `a` join `fe_art` `b` on(`b`.`idart` = `a`.`idart`)) where `a`.`acti` = 'A' */;

/*View structure for view vlcajacl */

/*!50001 DROP TABLE IF EXISTS `vlcajacl` */;
/*!50001 DROP VIEW IF EXISTS `vlcajacl` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vlcajacl` AS select `a`.`lcaj_idca` AS `lcaj_idca`,`b`.`razo` AS `razo` from (`fe_lcaja` `a` join `fe_clie` `b` on(`b`.`idclie` = `a`.`lcaj_clpr`)) where `a`.`lcaj_acti` = 'A' and `a`.`lcaj_deud` > 0 */;

/*View structure for view vmuestravtas */

/*!50001 DROP TABLE IF EXISTS `vmuestravtas` */;
/*!50001 DROP VIEW IF EXISTS `vmuestravtas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestravtas` AS select `c`.`idusua` AS `idusua`,`a`.`kar_comi` AS `kar_comi`,`a`.`codv` AS `codv`,`a`.`idauto` AS `idauto`,`c`.`codt` AS `alma`,`a`.`kar_idco` AS `idcosto`,`a`.`idkar` AS `idkar`,`a`.`idart` AS `Coda`,`a`.`cant` AS `cant`,`a`.`prec` AS `prec`,`c`.`valor` AS `valor`,`c`.`igv` AS `igv`,`c`.`impo` AS `impo`,`c`.`fech` AS `fech`,`c`.`fecr` AS `fecr`,`c`.`form` AS `form`,`c`.`deta` AS `deta`,`c`.`exon` AS `exon`,`c`.`ndo2` AS `ndo2`,`c`.`idcliente` AS `idclie`,`d`.`razo` AS `razo`,`d`.`nruc` AS `nruc`,`d`.`dire` AS `dire`,`d`.`ciud` AS `ciud`,`d`.`ndni` AS `ndni`,`a`.`tipo` AS `tipo`,`c`.`tdoc` AS `tdoc`,`c`.`ndoc` AS `ndoc`,`c`.`dolar` AS `dolar`,`c`.`mone` AS `mone`,`c`.`vigv` AS `vigv`,`a`.`dsnc` AS `dsnc`,`a`.`dsnd` AS `dsnd`,`a`.`gast` AS `gast`,`c`.`idcliente` AS `idcliente`,`c`.`codt` AS `codt`,`c`.`fusua` AS `fusua`,`b`.`descri` AS `descri`,`b`.`unid` AS `unid`,`g`.`nomb` AS `usuario` from ((((`fe_kar` `a` left join `fe_rcom` `c` on(`c`.`idauto` = `a`.`idauto`)) join `fe_clie` `d` on(`c`.`idcliente` = `d`.`idclie`)) join `fe_art` `b` on(`b`.`idart` = `a`.`idart`)) join `fe_usua` `g` on(`g`.`idusua` = `c`.`idusua`)) where `c`.`acti` <> 'I' and `a`.`acti` <> 'I' */;

/*View structure for view vutilidad */

/*!50001 DROP TABLE IF EXISTS `vutilidad` */;
/*!50001 DROP VIEW IF EXISTS `vutilidad` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vutilidad` AS select `a`.`fech` AS `fecha`,`a`.`ndoc` AS `Documento`,`b`.`razo` AS `Cliente`,sum(`c`.`cost_cost` * `d`.`cant`) AS `costo`,sum(`d`.`prec` * `d`.`cant`) AS `precio`,`e`.`nomv` AS `Vendedor`,`f`.`nomb` AS `usuario`,`a`.`fusua` AS `FechaHora`,'00' AS `x`,`a`.`idauto` AS `idauto`,`d`.`codv` AS `codv` from (((((`fe_rcom` `a` join `fe_clie` `b` on(`b`.`idclie` = `a`.`idcliente`)) join `fe_kar` `d` on(`d`.`idauto` = `a`.`idauto`)) join `fe_costos` `c` on(`c`.`cost_idco` = `d`.`kar_idco`)) join `fe_vend` `e` on(`e`.`idven` = `d`.`codv`)) join `fe_usua` `f` on(`f`.`idusua` = `a`.`idusua`)) where `a`.`acti` <> 'I' and `d`.`acti` <> 'I' and `d`.`tipo` = 'V' group by `a`.`idauto` */;

/*View structure for view vguiasventas */

/*!50001 DROP TABLE IF EXISTS `vguiasventas` */;
/*!50001 DROP VIEW IF EXISTS `vguiasventas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vguiasventas` AS select `b`.`guia_idgui` AS `idguia`,`a`.`idart` AS `coda`,`a`.`descri` AS `descri`,`a`.`unid` AS `unid`,`b`.`guia_ndoc` AS `ndoc`,`b`.`guia_fech` AS `fech`,`b`.`guia_fect` AS `fect`,`b`.`guia_ptoll` AS `ptoll`,`b`.`guia_deta` AS `detalle`,`x`.`entr_cant` AS `cant`,`y`.`placa` AS `placa`,ifnull(`y`.`razon`,'') AS `Transportista`,`y`.`ructr` AS `ructr`,`y`.`nombr` AS `Chofer`,`y`.`breve` AS `Brevete`,`y`.`cons` AS `Constancia`,`y`.`marca` AS `marca`,`y`.`dirtr` AS `Direccion`,`p`.`nomb` AS `usuario`,`d`.`razo` AS `cliente`,`d`.`idclie` AS `idcliente`,`c`.`ndoc` AS `refe`,`c`.`tdoc` AS `tdoc`,`b`.`guia_mens` AS `guia_mens`,`b`.`guia_arch` AS `guia_arch`,`d`.`clie_corr` AS `clie_corr`,`b`.`guia_hash` AS `guia_hash`,`b`.`guia_feen` AS `guia_feen`,`b`.`guia_codt` AS `guia_codt`,`b`.`guia_tick` AS `guia_tick` from (((((((`fe_guias` `b` join `fe_ent` `x` on(`x`.`entr_idgu` = `b`.`guia_idgui`)) left join `fe_tra` `y` on(`y`.`idtra` = `b`.`guia_idtr`)) join `fe_kar` `s` on(`s`.`idkar` = `x`.`entr_idkar`)) join `fe_art` `a` on(`a`.`idart` = `s`.`idart`)) join `fe_usua` `p` on(`p`.`idusua` = `b`.`guia_idus`)) join `fe_rcom` `c` on(`c`.`idauto` = `b`.`guia_idau`)) join `fe_clie` `d` on(`d`.`idclie` = `c`.`idcliente`)) where `b`.`guia_acti` <> 'I' */;

/*View structure for view vkardexc */

/*!50001 DROP TABLE IF EXISTS `vkardexc` */;
/*!50001 DROP VIEW IF EXISTS `vkardexc` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vkardexc` AS select `a`.`idart` AS `idart`,`a`.`tipo` AS `tipo`,`a`.`cant` AS `cant` from (`fe_kar` `a` join `fe_rcom` `b` on(`b`.`idauto` = `a`.`idauto`)) where `b`.`acti` = 'A' and `a`.`acti` = 'A' and `b`.`rcom_tipo` = 'C' and `b`.`rcom_fech` >= '2014-01-01' order by `a`.`idart` */;

/*View structure for view vpentregas */

/*!50001 DROP TABLE IF EXISTS `vpentregas` */;
/*!50001 DROP VIEW IF EXISTS `vpentregas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpentregas` AS select `fe_pentregas`.`pent_idin` AS `idped`,`fe_pentregas`.`pent_cant` + `fe_pentregas`.`pent_canr` AS `entregado`,`fe_pentregas`.`pent_idpr` AS `pent_idpr`,`fe_pentregas`.`pent_idpe` AS `pent_idpe` from `fe_pentregas` where `fe_pentregas`.`pent_acti` = 'A' order by `fe_pentregas`.`pent_idin` */;

/*View structure for view vlcajapr */

/*!50001 DROP TABLE IF EXISTS `vlcajapr` */;
/*!50001 DROP VIEW IF EXISTS `vlcajapr` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vlcajapr` AS select `a`.`lcaj_idca` AS `lcaj_idca`,`b`.`razo` AS `razo` from (`fe_lcaja` `a` join `fe_prov` `b` on(`b`.`idprov` = `a`.`lcaj_clpr`)) where `a`.`lcaj_acti` = 'A' and `a`.`lcaj_acre` > 0 */;

/*View structure for view vpdtespagocompras */

/*!50001 DROP TABLE IF EXISTS `vpdtespagocompras` */;
/*!50001 DROP VIEW IF EXISTS `vpdtespagocompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpdtespagocompras` AS select round(sum(`d`.`impo` - `d`.`acta`),2) AS `saldo`,`d`.`ncontrol` AS `ncontrol`,max(`d`.`fevto`) AS `fevto`,`r`.`rdeu_idpr` AS `rdeu_idpr`,`r`.`rdeu_mone` AS `rdeu_mone` from (`fe_rdeu` `r` join `fe_deu` `d` on(`d`.`deud_idrd` = `r`.`rdeu_idrd`)) where `d`.`acti` = 'A' and `r`.`rdeu_Acti` = 'A' group by `r`.`rdeu_idpr`,`d`.`ncontrol`,`r`.`rdeu_mone` having round(sum(`d`.`impo` - `d`.`acta`),2) > 0.1 */;

/*View structure for view vgr */

/*!50001 DROP TABLE IF EXISTS `vgr` */;
/*!50001 DROP VIEW IF EXISTS `vgr` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vgr` AS select `b`.`tdoc` AS `tdoc`,`b`.`ndoc` AS `ndoc`,`b`.`fech` AS `fech`,`b`.`dolar` AS `dolar`,`a`.`guic_idac` AS `guic_idac`,`a`.`guic_idau` AS `guic_idau`,`b`.`mone` AS `mone` from (`fe_guiac` `a` join `fe_rcom` `b` on(`b`.`idauto` = `a`.`guic_idac`)) where `b`.`acti` = 'A' and `a`.`guic_acti` = 'A' and `b`.`tipom` = 'C' and `a`.`guic_idac` > 0 group by `a`.`guic_idau` order by `a`.`guic_idau` */;

/*View structure for view vcambioanterior */

/*!50001 DROP TABLE IF EXISTS `vcambioanterior` */;
/*!50001 DROP VIEW IF EXISTS `vcambioanterior` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vcambioanterior` AS select `a`.`ndoc` AS `ndoc`,`a`.`tdoc` AS `tdoc`,`b`.`razo` AS `razo`,`a`.`impo` AS `impo`,`c`.`nomb` AS `nomb`,`a`.`fusua` AS `fusua`,`y`.`descri` AS `descri`,`y`.`unid` AS `unid`,`p`.`cant` AS `cant`,`p`.`prec` AS `prec`,round(`p`.`cant` * `p`.`prec`,2) AS `importe`,`z`.`camb_idaa` AS `camb_idaa`,`z`.`camb_fope` AS `camb_fope`,`a`.`idauto` AS `idauto`,`w`.`acti` AS `acti` from ((((((`fe_rcom` `a` join `fe_clie` `b` on(`b`.`idclie` = `a`.`idcliente`)) join `fe_usua` `c` on(`a`.`idusua` = `c`.`idusua`)) join `fe_kar` `p` on(`p`.`idauto` = `a`.`idauto`)) join `fe_cambiosvtas` `z` on(`z`.`camb_idaa` = `a`.`idauto`)) join `fe_art` `y` on(`y`.`idart` = `z`.`camb_idart`)) join `fe_rcom` `w` on(`w`.`idauto` = `z`.`camb_idac`)) where `w`.`acti` <> 'I' group by `z`.`camb_idca` */;

/*View structure for view vlistaprecios */

/*!50001 DROP TABLE IF EXISTS `vlistaprecios` */;
/*!50001 DROP VIEW IF EXISTS `vlistaprecios` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vlistaprecios` AS select `a`.`idart` AS `idart`,`a`.`descri` AS `descri`,`a`.`unid` AS `unid`,`a`.`uno` AS `uno`,`a`.`dos` AS `dos`,`a`.`tre` AS `tre`,`a`.`cua` AS `cua`,`a`.`cero` AS `cero`,ifnull(round(if(`a`.`tmon` = 'S',(`a`.`prec` * `v`.`igv` + `b`.`prec`) * `a`.`prod_uti1`,(`a`.`prec` * `v`.`igv` * `v`.`dola` + `b`.`prec`) * `a`.`prod_uti1`),2),0) AS `pre1`,ifnull(round(if(`a`.`tmon` = 'S',(`a`.`prec` * `v`.`igv` + `b`.`prec`) * `a`.`prod_uti2`,(`a`.`prec` * `v`.`igv` * `v`.`dola` + `b`.`prec`) * `a`.`prod_uti2`),2),0) AS `pre2`,ifnull(round(if(`a`.`tmon` = 'S',(`a`.`prec` * `v`.`igv` + `b`.`prec`) * `a`.`prod_uti3`,(`a`.`prec` * `v`.`igv` * `v`.`dola` + `b`.`prec`) * `a`.`prod_uti3`),2),0) AS `pre3`,round(if(`a`.`tmon` = 'S',`a`.`prec` * `v`.`igv` + `b`.`prec`,`a`.`prec` * `v`.`igv` * `v`.`dola` + `b`.`prec`),2) AS `costo`,`c`.`idgrupo` AS `idgrupo`,`c`.`dcat` AS `dcat`,`a`.`prod_dola` AS `prod_dola`,round(if(`a`.`tmon` = 'S',`a`.`prec` * `v`.`igv`,`a`.`prec` * `y`.`vigv` * `v`.`dola`),2) AS `costosf`,`b`.`prec` AS `flete`,ifnull(`d`.`cost_cost`,0) AS `costor`,ifnull(`d`.`cost_prec`,0) AS `precr`,ifnull(`d`.`cost_mone`,'') AS `moner`,cast(ifnull(`d`.`cost_idco`,0) as unsigned) AS `cost_idco`,ifnull(`d`.`cost_flet`,0) AS `fleter`,ifnull(`d`.`cost_dola`,0) AS `dolar`,`a`.`peso` AS `peso`,`a`.`prec` AS `prec`,`a`.`tipro` AS `tipro`,`a`.`idmar` AS `idmar`,`a`.`idcat` AS `idcat`,`a`.`cost` AS `cost`,`a`.`tmon` AS `tmon`,`a`.`idflete` AS `idflete`,`a`.`prod_uti1` AS `prod_uti1`,`a`.`prod_uti2` AS `prod_uti2`,`a`.`prod_uti3` AS `prod_uti3`,`a`.`prod_come` AS `prod_come`,`a`.`prod_comc` AS `prod_comc`,`a`.`ulpc` AS `ulpc`,`a`.`prod_idus` AS `prod_idus`,`a`.`prod_uact` AS `prod_uact`,`a`.`prod_fact` AS `prod_fact`,`a`.`fechc` AS `fechc`,`a`.`prod_smax` AS `prod_smax`,`a`.`prod_smin` AS `prod_smin`,ifnull(`o`.`razo`,'') AS `proveedor`,ifnull(`y`.`ndoc`,'') AS `ndoc`,ifnull(`y`.`fech`,'') AS `fech`,`a`.`ulfc` AS `ulfc` from ((((((`fe_art` `a` join `fe_fletes` `b` on(`b`.`idflete` = `a`.`idflete`)) join `fe_cat` `c` on(`c`.`idcat` = `a`.`idcat`)) left join `fe_costos` `d` on(`d`.`cost_idco` = `a`.`prod_idco`)) left join `fe_rcom` `y` on(`y`.`idauto` = `a`.`prod_idau`)) left join `fe_prov` `o` on(`o`.`idprov` = `y`.`idprov`)) join `fe_gene` `v`) */;

/*View structure for view vguiasdevolucion */

/*!50001 DROP TABLE IF EXISTS `vguiasdevolucion` */;
/*!50001 DROP VIEW IF EXISTS `vguiasdevolucion` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vguiasdevolucion` AS select `b`.`guia_idgui` AS `idguia`,`a`.`idart` AS `coda`,`a`.`descri` AS `descri`,`a`.`unid` AS `unid`,`b`.`guia_ndoc` AS `ndoc`,`b`.`guia_fech` AS `fech`,`b`.`guia_fect` AS `fect`,`b`.`guia_ptoll` AS `ptoll`,`b`.`guia_deta` AS `detalle`,`x`.`entr_cant` AS `cant`,`y`.`placa` AS `placa`,ifnull(`y`.`razon`,'') AS `Transportista`,`y`.`ructr` AS `ructr`,`y`.`nombr` AS `Chofer`,`y`.`breve` AS `Brevete`,`y`.`cons` AS `Constancia`,`y`.`marca` AS `marca`,`y`.`dirtr` AS `Direccion`,`p`.`nomb` AS `usuario`,`d`.`razo` AS `cliente`,`d`.`idprov` AS `idprov`,`c`.`ndoc` AS `refe`,`c`.`tdoc` AS `tdoc`,`b`.`guia_mens` AS `guia_mens`,`b`.`guia_arch` AS `guia_arch`,`d`.`email` AS `email`,`b`.`guia_hash` AS `guia_hash`,`b`.`guia_feen` AS `guia_feen`,`b`.`guia_codt` AS `guia_codt`,`b`.`guia_tick` AS `guia_tick` from (((((((`fe_guias` `b` join `fe_ent` `x` on(`x`.`entr_idgu` = `b`.`guia_idgui`)) left join `fe_tra` `y` on(`y`.`idtra` = `b`.`guia_idtr`)) join `fe_kar` `s` on(`s`.`idkar` = `x`.`entr_idkar`)) join `fe_art` `a` on(`a`.`idart` = `s`.`idart`)) join `fe_usua` `p` on(`p`.`idusua` = `b`.`guia_idus`)) join `fe_rcom` `c` on(`c`.`idauto` = `b`.`guia_idau`)) join `fe_prov` `d` on(`d`.`idprov` = `c`.`idprov`)) where `b`.`guia_acti` <> 'I' and `x`.`entr_acti` = 'A' and `b`.`guia_moti` = 'D' */;

/*View structure for view vguiascompras */

/*!50001 DROP TABLE IF EXISTS `vguiascompras` */;
/*!50001 DROP VIEW IF EXISTS `vguiascompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vguiascompras` AS select `fe_guiac`.`guic_idau` AS `guic_idau`,`fe_guiac`.`guic_tipo` AS `guic_tipo`,cast(ifnull(`fe_guiac`.`guic_idac`,0) as signed) AS `guic_idac` from `fe_guiac` where `fe_guiac`.`guic_acti` = 'A' group by `fe_guiac`.`guic_idau` */;

/*View structure for view vpedidosvtas */

/*!50001 DROP TABLE IF EXISTS `vpedidosvtas` */;
/*!50001 DROP VIEW IF EXISTS `vpedidosvtas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpedidosvtas` AS select `a`.`idauto` AS `idauto`,`a`.`alma` AS `alma`,`a`.`idart` AS `idart`,`a`.`idkar` AS `idkar`,`a`.`cant` AS `Pedido`,`a`.`codv` AS `codv` from `fe_kar` `a` where `a`.`tipo` = 'V' and `a`.`acti` <> 'I' order by `a`.`idkar` */;

/*View structure for view vsaldosctaspagar */

/*!50001 DROP TABLE IF EXISTS `vsaldosctaspagar` */;
/*!50001 DROP VIEW IF EXISTS `vsaldosctaspagar` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vsaldosctaspagar` AS select `a`.`rdeu_idrd` AS `rdeu_idrd`,sum(`b`.`impo` - `b`.`acta`) AS `Saldo`,`b`.`ncontrol` AS `ncontrol` from (`fe_rdeu` `a` join `fe_deu` `b` on(`b`.`deud_idrd` = `a`.`rdeu_idrd`)) where `a`.`rdeu_Acti` <> 'I' and `b`.`acti` <> 'I' group by `b`.`ncontrol` */;

/*View structure for view vmuestractascompras */

/*!50001 DROP TABLE IF EXISTS `vmuestractascompras` */;
/*!50001 DROP VIEW IF EXISTS `vmuestractascompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestractascompras` AS select left(`p`.`nomb`,3) AS `tdoc`,`b`.`ndoc` AS `ndoc`,`b`.`fecr` AS `fecr`,`a`.`ncta` AS `ncta`,`c`.`razo` AS `razo`,case `x`.`ecta_tipo` when 'D' then if(`b`.`mone` = 'S',`x`.`impo`,round(`x`.`impo` * `b`.`dolar`,2)) else 0 end AS `Debe`,case `x`.`ecta_tipo` when 'H' then if(`b`.`mone` = 'S',`x`.`impo`,round(`x`.`impo` * `b`.`dolar`,2)) else 0 end AS `Haber`,`a`.`idcta` AS `idcta`,`b`.`fech` AS `fech`,`a`.`nomb` AS `nomb`,`x`.`ecta_tipo` AS `tipo`,`b`.`idauto` AS `idrcon`,`b`.`mone` AS `mone`,`c`.`idprov` AS `idprov`,`x`.`idectas` AS `idectas` from ((((`fe_ectasc` `x` join `fe_plan` `a` on(`a`.`idcta` = `x`.`idcta`)) join `fe_rcom` `b` on(`b`.`idauto` = `x`.`idrcon`)) join `fe_prov` `c` on(`c`.`idprov` = `b`.`idprov`)) join `fe_tdoc` `p` on(`p`.`tdoc` = `b`.`tdoc`)) where `x`.`impo` <> 0 and `b`.`acti` = 'A' and `p`.`dcto_acti` = 'A' and `x`.`ecta_acti` = 'A' */;

/*View structure for view vregcompras */

/*!50001 DROP TABLE IF EXISTS `vregcompras` */;
/*!50001 DROP VIEW IF EXISTS `vregcompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vregcompras` AS select `x`.`fech` AS `fech`,`x`.`fecr` AS `fecr`,`x`.`tdoc` AS `tdoc`,`x`.`ndoc` AS `ndoc`,`x`.`idprov` AS `idprov`,`x`.`vigv` AS `vigv`,`x`.`ndo2` AS `ndo2`,`x`.`mone` AS `mone`,`x`.`valor` AS `valor`,`x`.`igv` AS `igv`,`x`.`impo` AS `impo`,`x`.`codt` AS `codt`,`x`.`dolar` AS `dola`,`x`.`form` AS `form`,`x`.`idauto` AS `idauto`,`y`.`nomb` AS `usuario`,`x`.`fusua` AS `fusua`,`p`.`razo` AS `razo`,`p`.`nruc` AS `nruc`,`p`.`dire` AS `dire`,`p`.`ciud` AS `ciud`,`p`.`fono` AS `fono` from ((`fe_rcom` `x` join `fe_usua` `y` on(`y`.`idusua` = `x`.`idusua`)) join `fe_prov` `p` on(`p`.`idprov` = `x`.`idprov`)) where `x`.`acti` = 'A' */;

/*View structure for view ventregas */

/*!50001 DROP TABLE IF EXISTS `ventregas` */;
/*!50001 DROP VIEW IF EXISTS `ventregas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `ventregas` AS select `fe_ent`.`entr_idkar` AS `entr_idkar`,sum(`fe_ent`.`entr_cant`) AS `entregado` from `fe_ent` where `fe_ent`.`entr_acti` <> 'I' group by `fe_ent`.`entr_idkar` */;

/*View structure for view vpdtespagoc */

/*!50001 DROP TABLE IF EXISTS `vpdtespagoc` */;
/*!50001 DROP VIEW IF EXISTS `vpdtespagoc` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpdtespagoc` AS select `b`.`rcre_idcl` AS `idclie`,`a`.`ndoc` AS `ndoc`,round(sum(`a`.`impo` - `a`.`acta`),2) AS `importe`,`a`.`mone` AS `mone`,`a`.`banc` AS `banc`,`b`.`rcre_fech` AS `fech`,`x`.`razo` AS `razo`,`x`.`fono` AS `fono`,`x`.`dire` AS `dire`,`x`.`ciud` AS `ciud`,max(`a`.`fevto`) AS `fevto`,`a`.`tipo` AS `tipo`,`a`.`dola` AS `dola`,ifnull(`c`.`ndoc`,'') AS `docd`,`a`.`nrou` AS `nrou`,`a`.`banco` AS `banco`,`a`.`idcred` AS `idcred`,`b`.`rcre_idau` AS `idauto`,`d`.`nomv` AS `nomv`,`a`.`ncontrol` AS `ncontrol` from ((((`fe_cred` `a` join `fe_rcred` `b` on(`b`.`rcre_idrc` = `a`.`cred_idrc`)) left join `fe_rcom` `c` on(`c`.`idauto` = `b`.`rcre_idau`)) join `fe_vend` `d` on(`d`.`idven` = `b`.`rcre_codv`)) join `fe_clie` `x` on(`x`.`idclie` = `b`.`rcre_idcl`)) where `a`.`acti` <> 'I' and `b`.`rcre_Acti` <> 'I' group by `a`.`ncontrol` having round(sum(`a`.`impo` - `a`.`acta`),2) <> 0 order by max(`a`.`fevto`),`c`.`ndoc` */;

/*View structure for view vcambioactual */

/*!50001 DROP TABLE IF EXISTS `vcambioactual` */;
/*!50001 DROP VIEW IF EXISTS `vcambioactual` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vcambioactual` AS select `a`.`ndoc` AS `ndoc`,`a`.`tdoc` AS `tdoc`,`b`.`razo` AS `razo`,`a`.`impo` AS `impo`,`c`.`nomb` AS `nomb`,`a`.`fusua` AS `fusua`,`y`.`descri` AS `descri`,`y`.`unid` AS `unid`,`p`.`cant` AS `cant`,`p`.`prec` AS `prec`,round(`p`.`cant` * `p`.`prec`,2) AS `importe`,`z`.`camb_idac` AS `camb_idac`,`z`.`camb_idaa` AS `camb_idaa`,`z`.`camb_fope` AS `camb_fope`,`a`.`fech` AS `fech`,`a`.`idauto` AS `idauto` from (((((`fe_rcom` `a` join `fe_clie` `b` on(`b`.`idclie` = `a`.`idcliente`)) join `fe_usua` `c` on(`a`.`idusua` = `c`.`idusua`)) join `fe_kar` `p` on(`p`.`idauto` = `a`.`idauto`)) join `fe_cambiosvtas` `z` on(`z`.`camb_idac` = `a`.`idauto`)) join `fe_art` `y` on(`y`.`idart` = `z`.`camb_idart`)) where `a`.`acti` <> 'I' group by `z`.`camb_idca` */;

/*View structure for view vpdtesvtas */

/*!50001 DROP TABLE IF EXISTS `vpdtesvtas` */;
/*!50001 DROP VIEW IF EXISTS `vpdtesvtas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpdtesvtas` AS select `a`.`idauto` AS `idauto`,`a`.`idkar` AS `idkar`,`a`.`cant` AS `Pedido`,cast(ifnull(sum(`b`.`entr_cant`),0) as unsigned) AS `Entregado` from (`fe_kar` `a` left join `fe_ent` `b` on(`b`.`entr_idkar` = `a`.`idkar`)) where `a`.`tipo` = 'V' and `a`.`acti` <> 'I' group by `a`.`idart`,`a`.`idkar` */;

/*View structure for view vguiasrcompras */

/*!50001 DROP TABLE IF EXISTS `vguiasrcompras` */;
/*!50001 DROP VIEW IF EXISTS `vguiasrcompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vguiasrcompras` AS select `b`.`guia_idgui` AS `idguia`,`a`.`idart` AS `coda`,`a`.`descri` AS `descri`,`a`.`unid` AS `unid`,`b`.`guia_ndoc` AS `ndoc`,`b`.`guia_fech` AS `fech`,`b`.`guia_fect` AS `fect`,`b`.`guia_ptoll` AS `ptoll`,`b`.`guia_deta` AS `detalle`,`x`.`entr_cant` AS `cant`,`y`.`placa` AS `placa`,ifnull(`y`.`razon`,'') AS `Transportista`,`y`.`ructr` AS `ructr`,`y`.`nombr` AS `Chofer`,`y`.`breve` AS `Brevete`,`y`.`cons` AS `Constancia`,`y`.`marca` AS `marca`,`y`.`dirtr` AS `Direccion`,`p`.`nomb` AS `usuario`,`pp`.`razo` AS `cliente`,`b`.`guia_idpr` AS `idprov`,`b`.`guia_ndoc` AS `refe`,'09' AS `tdoc`,`b`.`guia_mens` AS `guia_mens`,`b`.`guia_arch` AS `guia_arch`,`d`.`correo` AS `email`,`b`.`guia_hash` AS `guia_hash`,`b`.`guia_feen` AS `guia_feen`,`b`.`guia_codt` AS `guia_codt`,`b`.`guia_tick` AS `guia_tick` from ((((((`fe_guias` `b` join `fe_ent` `x` on(`x`.`entr_idgu` = `b`.`guia_idgui`)) join `fe_tra` `y` on(`y`.`idtra` = `b`.`guia_idtr`)) join `fe_art` `a` on(`a`.`idart` = `x`.`entr_idar`)) join `fe_usua` `p` on(`p`.`idusua` = `b`.`guia_idus`)) join `fe_prov` `pp` on(`pp`.`idprov` = `b`.`guia_idpr`)) join `fe_gene` `d`) where `b`.`guia_acti` <> 'I' and `b`.`guia_moti` = 'C' and `x`.`entr_acti` = 'A' */;

/*View structure for view vcambio */

/*!50001 DROP TABLE IF EXISTS `vcambio` */;
/*!50001 DROP VIEW IF EXISTS `vcambio` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vcambio` AS select `c`.`nomb` AS `nomb`,`a`.`fusua` AS `fusua`,`y`.`descri` AS `descri`,`y`.`unid` AS `unid`,`p`.`camb_cant` AS `camb_cant`,`p`.`camb_prec` AS `camb_prec`,round(`p`.`camb_cant` * `p`.`camb_prec`,2) AS `importe`,`p`.`camb_idac` AS `camb_idac`,`p`.`camb_fope` AS `camb_fope` from ((((`fe_rcom` `a` join `fe_clie` `b` on(`b`.`idclie` = `a`.`idcliente`)) join `fe_usua` `c` on(`a`.`idusua` = `c`.`idusua`)) join `fe_cambiosvtas` `p` on(`p`.`camb_idac` = `a`.`idauto`)) join `fe_art` `y` on(`y`.`idart` = `p`.`camb_idart`)) */;

/*View structure for view vrdespachos */

/*!50001 DROP TABLE IF EXISTS `vrdespachos` */;
/*!50001 DROP VIEW IF EXISTS `vrdespachos` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vrdespachos` AS select `d`.`idusua` AS `idusuaPedido`,`a`.`entr_idkar` AS `entr_idkar`,`a`.`entr_cant` AS `Entregado`,`b`.`guia_fech` AS `FechaEntrega`,`b`.`guia_idus` AS `IdusuaEntrega`,`x`.`idauto` AS `idauto`,`x`.`idkar` AS `idkar`,`x`.`idart` AS `idart`,`x`.`cant` AS `Pedido`,`d`.`tdoc` AS `tdoc`,`d`.`ndoc` AS `ndoc`,`d`.`fech` AS `FechaPedido`,`e`.`razo` AS `Cliente`,`e`.`idclie` AS `idclie`,`a`.`entr_acti` AS `entr_acti` from ((((`fe_kar` `x` join `fe_rcom` `d` on(`d`.`idauto` = `x`.`idauto`)) join `fe_clie` `e` on(`e`.`idclie` = `d`.`idcliente`)) left join `fe_ent` `a` on(`x`.`idkar` = `a`.`entr_idkar`)) left join `fe_guias` `b` on(`b`.`guia_idgui` = `a`.`entr_idgu`)) where `x`.`acti` = 'A' and `d`.`acti` = 'A' and (`a`.`entr_acti` = 'A' or `a`.`entr_acti` is null) */;

/*View structure for view vmuestracotizaciones */

/*!50001 DROP TABLE IF EXISTS `vmuestracotizaciones` */;
/*!50001 DROP VIEW IF EXISTS `vmuestracotizaciones` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestracotizaciones` AS select `a`.`idart` AS `idart`,`b`.`descri` AS `descri`,`b`.`unid` AS `unid`,`a`.`cant` AS `cant`,ifnull(`m`.`idven`,0) AS `idven`,ifnull(`m`.`nomv`,'') AS `Vendedor`,`a`.`prec` AS `prec`,`b`.`premay` AS `premay`,`b`.`premen` AS `premen`,`c`.`fech` AS `fech`,`c`.`idautop` AS `idautop`,`c`.`impo` AS `impo`,`c`.`ndoc` AS `ndoc`,`c`.`aten` AS `aten`,`c`.`forma` AS `forma`,`c`.`plazo` AS `plazo`,`c`.`validez` AS `validez`,`c`.`entrega` AS `entrega`,`c`.`detalle` AS `detalle`,ifnull(`d`.`idclie`,0) AS `idclie`,ifnull(`d`.`razo`,'') AS `razo`,ifnull(`d`.`nruc`,'') AS `nruc`,ifnull(`d`.`dire`,'') AS `dire`,`c`.`rped_mone` AS `rped_mone`,ifnull(`d`.`ciud`,'') AS `ciud`,`d`.`fono` AS `fono`,`d`.`fax` AS `fax`,`a`.`idped` AS `nreg` from ((((`fe_ped` `a` join `fe_rped` `c` on(`a`.`idautop` = `c`.`idautop`)) join `fe_art` `b` on(`b`.`idart` = `a`.`idart`)) left join `fe_clie` `d` on(`d`.`idclie` = `c`.`idclie`)) left join `fe_vend` `m` on(`m`.`idven` = `c`.`idven`)) where `a`.`acti` <> 'I' and `c`.`acti` <> 'I' */;

/*View structure for view vsolopdtes */

/*!50001 DROP TABLE IF EXISTS `vsolopdtes` */;
/*!50001 DROP VIEW IF EXISTS `vsolopdtes` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vsolopdtes` AS select `a`.`codv` AS `codv`,`a`.`idauto` AS `idauto`,`a`.`alma` AS `alma`,`a`.`idart` AS `idart`,`a`.`idkar` AS `idkar`,`a`.`Pedido` AS `Pedido`,cast(ifnull(`b`.`entregado`,0) as unsigned) AS `Entregado`,if(`a`.`Pedido` - `b`.`entregado` = 0,'E','P') AS `estado` from (`vpedidosvtas` `a` left join `ventregas` `b` on(`b`.`entr_idkar` = `a`.`idkar`)) order by `a`.`idkar` */;

/*View structure for view vcred */

/*!50001 DROP TABLE IF EXISTS `vcred` */;
/*!50001 DROP VIEW IF EXISTS `vcred` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vcred` AS select `w`.`cred_idrc` AS `idrc`,`w`.`impo` AS `impo` from (`fe_cred` `w` join `fe_rcred` `s` on(`s`.`rcre_idrc` = `w`.`cred_idrc`)) where `w`.`acti` = 'A' and `s`.`rcre_Acti` = 'A' and `w`.`impo` > 0 */;

/*View structure for view vsaldos */

/*!50001 DROP TABLE IF EXISTS `vsaldos` */;
/*!50001 DROP VIEW IF EXISTS `vsaldos` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vsaldos` AS select `a`.`pdte_idar` AS `pdte_idar`,`a`.`pdte_cant` AS `Pedido`,0 AS `Entregado`,`a`.`pdte_idau` AS `pdte_idau`,`a`.`pdte_idus` AS `pdte_idus`,`a`.`pdte_idin` AS `idin` from `fe_ipdtes` `a` where `a`.`pdte_Acti` <> 'I' union all select `a`.`pdte_idar` AS `pdte_idar`,0 AS `Pedido`,ifnull(`b`.`entr_cant`,0) AS `Entregado`,`a`.`pdte_idau` AS `pdte_idau`,`a`.`pdte_idus` AS `pdte_idus`,`b`.`entr_idin` AS `idin` from (`fe_ipdtes` `a` left join `fe_entregas` `b` on(`b`.`entr_idin` = `a`.`pdte_idin`)) where `b`.`entr_acti` <> 'I' */;

/*View structure for view vpdtespago */

/*!50001 DROP TABLE IF EXISTS `vpdtespago` */;
/*!50001 DROP VIEW IF EXISTS `vpdtespago` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpdtespago` AS select `a`.`ndoc` AS `ndoc`,`a`.`fech` AS `fech`,`a`.`dola` AS `dola`,`a`.`nrou` AS `nrou`,`a`.`banc` AS `banc`,`a`.`iddeu` AS `iddeu`,`s`.`fevto` AS `fevto`,`s`.`saldo` AS `saldo`,`s`.`rdeu_idpr` AS `Idpr`,`b`.`rdeu_impc` AS `ImporteC`,'C' AS `situa`,`b`.`rdeu_idau` AS `Idauto`,`s`.`ncontrol` AS `ncontrol`,`a`.`tipo` AS `tipo`,`a`.`banco` AS `banco`,ifnull(`c`.`ndoc`,'0') AS `docd`,ifnull(`c`.`tdoc`,'0') AS `tdoc`,`b`.`rdeu_mone` AS `Moneda`,`b`.`rdeu_codt` AS `Codt`,`b`.`rdeu_idrd` AS `Idrd`,`b`.`rdeu_idct` AS `rdeu_idct` from ((((`vpdtespagocompras` `s` join `fe_prov` `z` on(`z`.`idprov` = `s`.`rdeu_idpr`)) join `fe_deu` `a` on(`a`.`iddeu` = `s`.`ncontrol`)) join `fe_rdeu` `b` on(`b`.`rdeu_idrd` = `a`.`deud_idrd`)) left join `fe_rcom` `c` on(`c`.`idauto` = `b`.`rdeu_idau`)) order by `s`.`fevto` */;

/*View structure for view rvendedores */

/*!50001 DROP TABLE IF EXISTS `rvendedores` */;
/*!50001 DROP VIEW IF EXISTS `rvendedores` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `rvendedores` AS select `fe_kar`.`idauto` AS `idauto`,`fe_kar`.`codv` AS `codv` from `fe_kar` where `fe_kar`.`acti` = 'A' group by `fe_kar`.`idauto` */;

/*View structure for view vpdtesentrega */

/*!50001 DROP TABLE IF EXISTS `vpdtesentrega` */;
/*!50001 DROP VIEW IF EXISTS `vpdtesentrega` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpdtesentrega` AS select `a`.`descri` AS `Producto`,`a`.`unid` AS `Unidad`,`a`.`peso` AS `peso`,`a`.`uno` AS `uno`,`a`.`dos` AS `dos`,`a`.`idart` AS `idart`,sum(`p`.`Pedido`) AS `Pedido`,sum(`p`.`Entregado`) AS `Entregado`,sum(`p`.`Pedido`) - sum(`p`.`Entregado`) AS `Saldo`,`p`.`idin` AS `idin`,`d`.`tdoc` AS `tdoc`,`d`.`ndoc` AS `ndoc`,`d`.`idauto` AS `idauto`,`e`.`razo` AS `Cliente`,`e`.`dire` AS `dire`,`e`.`ciud` AS `ciud`,`e`.`nruc` AS `nruc`,`d`.`fech` AS `fech`,`e`.`ndni` AS `ndni`,`e`.`idclie` AS `idclie`,`f`.`nomb` AS `Usuario` from ((((`vsaldos` `p` join `fe_art` `a` on(`a`.`idart` = `p`.`pdte_idar`)) join `fe_rcom` `d` on(`d`.`idauto` = `p`.`pdte_idau`)) join `fe_clie` `e` on(`e`.`idclie` = `d`.`idcliente`)) join `fe_usua` `f` on(`f`.`idusua` = `p`.`pdte_idus`)) group by `p`.`idin`,`p`.`pdte_idar` having sum(`p`.`Pedido` - `p`.`Entregado`) > 0 */;

/*View structure for view vguiasventas1 */

/*!50001 DROP TABLE IF EXISTS `vguiasventas1` */;
/*!50001 DROP VIEW IF EXISTS `vguiasventas1` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vguiasventas1` AS select `b`.`guia_idgui` AS `idguia`,`b`.`guia_ndoc` AS `ndoc`,`b`.`guia_fech` AS `fech`,`b`.`guia_fect` AS `fect`,`b`.`guia_ptoll` AS `ptoll`,`b`.`guia_deta` AS `detalle`,`x`.`entr_cant` AS `cant`,`y`.`placa` AS `placa`,`y`.`razon` AS `Transportista`,`y`.`ructr` AS `ructr`,`y`.`nombr` AS `Chofer`,`y`.`breve` AS `Brevete`,`y`.`cons` AS `Constancia`,`y`.`marca` AS `marca`,`y`.`dirtr` AS `Direccion`,`p`.`nomb` AS `usuario`,`d`.`razo` AS `cliente`,`d`.`idclie` AS `idcliente`,`c`.`ndoc` AS `refe`,`c`.`tdoc` AS `tdoc` from (((((`fe_guias` `b` join `fe_entregas` `x` on(`x`.`entr_idgu` = `b`.`guia_idgui`)) left join `fe_tra` `y` on(`y`.`idtra` = `b`.`guia_idtr`)) join `fe_usua` `p` on(`p`.`idusua` = `b`.`guia_idus`)) join `fe_rcom` `c` on(`c`.`idauto` = `b`.`guia_idau`)) join `fe_clie` `d` on(`d`.`idclie` = `c`.`idcliente`)) where `b`.`guia_acti` <> 'I' */;

/*View structure for view vmuestraordencompra */

/*!50001 DROP TABLE IF EXISTS `vmuestraordencompra` */;
/*!50001 DROP VIEW IF EXISTS `vmuestraordencompra` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestraordencompra` AS select `b`.`doco_iddo` AS `doco_iddo`,`b`.`doco_coda` AS `doco_coda`,`b`.`doco_cant` AS `doco_cant`,`b`.`doco_prec` AS `doco_prec`,`c`.`descri` AS `descri`,`c`.`prod_smin` AS `prod_smin`,`c`.`unid` AS `unid`,`c`.`prod_smax` AS `prod_smax`,`a`.`ocom_valor` AS `ocom_valor`,`a`.`ocom_igv` AS `ocom_igv`,`a`.`ocom_impo` AS `ocom_impo`,`a`.`ocom_idroc` AS `ocom_idroc`,`a`.`ocom_fech` AS `ocom_fech`,`a`.`ocom_idpr` AS `ocom_idpr`,`a`.`ocom_desp` AS `ocom_desp`,`a`.`ocom_form` AS `ocom_form`,`a`.`ocom_mone` AS `ocom_mone`,`a`.`ocom_ndoc` AS `ocom_ndoc`,`a`.`ocom_tigv` AS `ocom_tigv`,`a`.`ocom_obse` AS `ocom_obse`,`a`.`ocom_aten` AS `ocom_aten`,`a`.`ocom_deta` AS `ocom_deta`,`a`.`ocom_idus` AS `ocom_idus`,`a`.`ocom_fope` AS `ocom_fope`,`a`.`ocom_idpc` AS `ocom_idpc`,`a`.`ocom_idac` AS `ocom_idac`,`a`.`ocom_fact` AS `ocom_fact`,`d`.`razo` AS `razo`,`e`.`nomb` AS `nomb` from ((((`fe_rocom` `a` join `fe_docom` `b` on(`b`.`doco_idro` = `a`.`ocom_idroc`)) join `fe_art` `c` on(`b`.`doco_coda` = `c`.`idart`)) join `fe_prov` `d` on(`d`.`idprov` = `a`.`ocom_idpr`)) join `fe_usua` `e` on(`e`.`idusua` = `a`.`ocom_idus`)) where `a`.`ocom_acti` <> 'I' and `b`.`doco_acti` <> 'I' */;

/*View structure for view vmuestraventas */

/*!50001 DROP TABLE IF EXISTS `vmuestraventas` */;
/*!50001 DROP VIEW IF EXISTS `vmuestraventas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestraventas` AS select `c`.`rcom_icbper` AS `rcom_icbper`,`a`.`kar_icbper` AS `kar_icbper`,`c`.`rcom_mens` AS `rcom_mens`,`c`.`idusua` AS `idusua`,`a`.`kar_comi` AS `kar_comi`,`a`.`codv` AS `codv`,`a`.`idauto` AS `idauto`,`a`.`alma` AS `alma`,`a`.`kar_idco` AS `idcosto`,`a`.`idkar` AS `idkar`,`a`.`idart` AS `Coda`,`a`.`cant` AS `cant`,`a`.`prec` AS `prec`,`c`.`valor` AS `valor`,`c`.`igv` AS `igv`,`c`.`impo` AS `impo`,`c`.`fech` AS `fech`,`c`.`fecr` AS `fecr`,`c`.`form` AS `form`,`c`.`deta` AS `deta`,`c`.`exon` AS `exon`,`c`.`ndo2` AS `ndo2`,`c`.`rcom_entr` AS `rcom_entr`,`c`.`idcliente` AS `idclie`,`d`.`razo` AS `razo`,`d`.`nruc` AS `nruc`,`d`.`dire` AS `dire`,`d`.`ciud` AS `ciud`,`d`.`ndni` AS `ndni`,`a`.`tipo` AS `tipo`,`c`.`tdoc` AS `tdoc`,`c`.`ndoc` AS `ndoc`,`c`.`dolar` AS `dolar`,`c`.`mone` AS `mone`,`b`.`descri` AS `descri`,ifnull(`x`.`idcaja`,0) AS `idcaja`,`b`.`unid` AS `unid`,`b`.`pre1` AS `pre1`,`b`.`peso` AS `peso`,`b`.`pre2` AS `pre2`,ifnull(`z`.`vend_idrv`,0) AS `nidrv`,`c`.`vigv` AS `vigv`,`a`.`dsnc` AS `dsnc`,`a`.`dsnd` AS `dsnd`,`a`.`gast` AS `gast`,`c`.`idcliente` AS `idcliente`,`c`.`codt` AS `codt`,`b`.`pre3` AS `pre3`,`b`.`cost` AS `costo`,`b`.`uno` AS `uno`,`b`.`dos` AS `dos`,`b`.`uno` + `b`.`dos` AS `TAlma`,`c`.`fusua` AS `fusua`,`p`.`nomv` AS `Vendedor`,`q`.`nomb` AS `Usuario`,`c`.`rcom_idtr` AS `rcom_idtr`,`c`.`rcom_tipo` AS `rcom_tipo` from (((((((`fe_rcom` `c` join `fe_kar` `a` on(`a`.`idauto` = `c`.`idauto`)) join `vlistaprecios` `b` on(`b`.`idart` = `a`.`idart`)) left join `fe_caja` `x` on(`x`.`idauto` = `c`.`idauto`)) join `fe_clie` `d` on(`d`.`idclie` = `c`.`idcliente`)) left join `fe_vend` `p` on(`p`.`idven` = `a`.`codv`)) join `fe_usua` `q` on(`q`.`idusua` = `c`.`idusua`)) join `fe_rvendedor` `z` on(`z`.`vend_idau` = `c`.`idauto`)) where `c`.`acti` <> 'I' and `a`.`acti` <> 'I' */;

/*View structure for view vmuestractasdiario */

/*!50001 DROP TABLE IF EXISTS `vmuestractasdiario` */;
/*!50001 DROP VIEW IF EXISTS `vmuestractasdiario` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestractasdiario` AS select `a`.`ldia_fech` AS `Fecha`,`b`.`ncta` AS `ncta`,`a`.`ldia_glosa` AS `Glosa`,`a`.`ldia_debe` AS `Debe`,`a`.`ldia_haber` AS `Haber`,`a`.`ldia_idcta` AS `Idcta` from (`fe_ldiario` `a` join `fe_plan` `b` on(`b`.`idcta` = `a`.`ldia_idcta`)) where `a`.`ldia_acti` = 'A' */;

/*View structure for view vpdtesx */

/*!50001 DROP TABLE IF EXISTS `vpdtesx` */;
/*!50001 DROP VIEW IF EXISTS `vpdtesx` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpdtesx` AS select sum(ifnull(`f`.`entr_cant`,0)) AS `entregado`,`b`.`cant` - sum(ifnull(`f`.`entr_cant`,0)) AS `saldo`,`a`.`idauto` AS `idauto`,`b`.`idkar` AS `idkar`,`b`.`idart` AS `idart` from (((`fe_kar` `b` join `fe_rcom` `a` on(`a`.`idauto` = `b`.`idauto`)) left join `fe_ent` `f` on(`f`.`entr_idkar` = `b`.`idkar`)) left join `fe_guias` `w` on(`w`.`guia_idgui` = `f`.`entr_idgu`)) where `a`.`acti` = 'A' and `b`.`acti` = 'A' and `a`.`idcliente` > 0 or `f`.`entr_acti` = 'A' or `f`.`entr_acti` is null group by `b`.`idkar`,`a`.`idauto`,`b`.`idart` */;

/*View structure for view vmuestractasventas */

/*!50001 DROP TABLE IF EXISTS `vmuestractasventas` */;
/*!50001 DROP VIEW IF EXISTS `vmuestractasventas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestractasventas` AS select left(`p`.`nomb`,3) AS `tdoc`,`b`.`ndoc` AS `ndoc`,`b`.`fech` AS `fech`,`a`.`ncta` AS `ncta`,`c`.`razo` AS `razo`,case `x`.`tipo` when 'D' then `x`.`impo` else 0 end AS `Debe`,case `x`.`tipo` when 'H' then `x`.`impo` else 0 end AS `Haber`,`x`.`tipo` AS `tipo`,`a`.`idcta` AS `idcta`,`a`.`nomb` AS `nomb`,`b`.`idauto` AS `idrven`,`b`.`mone` AS `mone`,`x`.`idectas` AS `idectas`,`c`.`idclie` AS `idclie` from ((((`fe_ectas` `x` join `fe_plan` `a` on(`a`.`idcta` = `x`.`idcta`)) join `fe_rcom` `b` on(`b`.`idauto` = `x`.`idrven`)) join `fe_clie` `c` on(`c`.`idclie` = `b`.`idcliente`)) join `fe_tdoc` `p` on(`p`.`tdoc` = `b`.`tdoc`)) where `x`.`impo` <> 0 and `b`.`acti` <> 'I' and `p`.`dcto_acti` = 'A' and `x`.`acti` = 'A' */;

/*View structure for view vrcompras */

/*!50001 DROP TABLE IF EXISTS `vrcompras` */;
/*!50001 DROP VIEW IF EXISTS `vrcompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vrcompras` AS select `c`.`ndoc` AS `ndoc`,`c`.`valor` AS `valor`,`c`.`igv` AS `igv`,`c`.`impo` AS `impo`,`c`.`pimpo` AS `pimpo`,`c`.`fech` AS `fech`,`c`.`fecr` AS `fecr`,`c`.`form` AS `form`,`c`.`exon` AS `exon`,`c`.`ndo2` AS `ndo2`,`c`.`idauto` AS `idauto`,`c`.`deta` AS `deta`,`c`.`tcom` AS `tcom`,`c`.`vigv` AS `vigv`,`c`.`idprov` AS `idprov`,`c`.`tdoc` AS `tdoc`,`c`.`dolar` AS `dolar`,`c`.`mone` AS `mone`,`p`.`razo` AS `razo`,`p`.`dire` AS `dire`,`p`.`ciud` AS `ciud`,`p`.`nruc` AS `nruc`,ifnull(`x`.`idcaja`,0) AS `Idcaja`,`c`.`codt` AS `codt`,`c`.`fusua` AS `fusua`,`w`.`nomb` AS `Usuario` from (((`fe_rcom` `c` join `fe_prov` `p` on(`p`.`idprov` = `c`.`idprov`)) left join `fe_caja` `x` on(`x`.`idauto` = `c`.`idauto`)) join `fe_usua` `w` on(`w`.`idusua` = `c`.`idusua`)) where `c`.`acti` = 'A' */;

/*View structure for view vmuestracompras */

/*!50001 DROP TABLE IF EXISTS `vmuestracompras` */;
/*!50001 DROP VIEW IF EXISTS `vmuestracompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestracompras` AS select `a`.`idauto` AS `idauto`,`a`.`alma` AS `alma`,`a`.`idkar` AS `idkar`,`b`.`descri` AS `descri`,`b`.`peso` AS `peso`,`b`.`prod_idco` AS `prod_idco`,`b`.`unid` AS `unid`,`b`.`tipro` AS `tipro`,`a`.`idart` AS `idart`,`a`.`incl` AS `incl`,`c`.`ndoc` AS `ndoc`,`c`.`valor` AS `valor`,`c`.`igv` AS `igv`,`c`.`impo` AS `impo`,`c`.`pimpo` AS `pimpo`,`a`.`cant` AS `cant`,`a`.`prec` AS `prec`,`c`.`fech` AS `fech`,`c`.`fecr` AS `fecr`,`c`.`form` AS `form`,`c`.`exon` AS `exon`,`c`.`ndo2` AS `ndo2`,`c`.`vigv` AS `vigv`,`c`.`idprov` AS `idprov`,`a`.`tipo` AS `tipo`,`c`.`tdoc` AS `tdoc`,`c`.`dolar` AS `dolar`,`c`.`mone` AS `mone`,`p`.`razo` AS `razo`,`p`.`dire` AS `dire`,`p`.`ciud` AS `ciud`,`p`.`nruc` AS `nruc`,`c`.`codt` AS `codt`,`a`.`dsnc` AS `dsnc`,`a`.`dsnd` AS `dsnd`,`a`.`gast` AS `gast`,`c`.`fusua` AS `fusua`,`c`.`idusua` AS `idusua`,`w`.`nomb` AS `Usuario` from ((((`fe_rcom` `c` left join `fe_kar` `a` on(`c`.`idauto` = `a`.`idauto`)) left join `fe_art` `b` on(`b`.`idart` = `a`.`idart`)) join `fe_prov` `p` on(`p`.`idprov` = `c`.`idprov`)) join `fe_usua` `w` on(`w`.`idusua` = `c`.`idusua`)) where `c`.`acti` <> 'I' and `a`.`acti` <> 'I' */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
