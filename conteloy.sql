/*
SQLyog Ultimate v12.09 (64 bit)
MySQL - 8.0.41 : Database - sysven_bdconteloy
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/* Trigger structure for table `fe_caja` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `logcaja` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `logcaja` AFTER DELETE ON `fe_caja` FOR EACH ROW begin
insert fe_acaja(fech,usuario,detalle,hora,importe,autorizo,moneda)
values(curdate(),old.usua,concat("Se Anulo:",old.ndoc),curtime(),old.impo,old.usua,old.tmon);
end */$$


DELIMITER ;

/* Trigger structure for table `fe_cheques` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaCheques` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaCheques` AFTER UPDATE ON `fe_cheques` FOR EACH ROW begin
insert into fe_acheques(ache_fech,ache_idus,ache_idu1,ache_irch,ache_iche)
values(localtime,new.cheq_idu1,new.cheq_idu0,old.cheq_idrc,old.cheq_idch);
end */$$


DELIMITER ;

/* Trigger structure for table `fe_cred` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `Acreditos` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `Acreditos` AFTER UPDATE ON `fe_cred` FOR EACH ROW begin
if new.acti="I" then
   update fe_caja set acti='I' where idcred=old.idcred;
   insert into fe_acreditos(fech,hora,acre_idus,ndoc,impo,acta,idclie)
   values(current_date,current_time,old.idusua,old.ndoc,old.impo,old.acta,old.idclie);
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_cred` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `anulacaja` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `anulacaja` AFTER DELETE ON `fe_cred` FOR EACH ROW begin
insert fe_acreditos(fech,hora,usuario,ndoc,detalle,impo,acta,idclie)
  values(curdate(),curtime(),old.usua,old.ndoc,concat("Se Anulo:",old.ndoc),old.impo,old.acta,old.idclie);
  delete from fe_caja where idcred=old.idcred;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_dcanjes` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaRetencionesCanjeadas` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaRetencionesCanjeadas` AFTER UPDATE ON `fe_dcanjes` FOR EACH ROW begin
if new.canj_acti='I' and old.canj_rete>0 then
   call ProDesactivaRetenciones(old.canj_rete);
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_dret` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaDeudas1` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaDeudas1` AFTER UPDATE ON `fe_dret` FOR EACH ROW begin
if new.dret_acti='I' then
   update fe_deu set acti='I' where iddeu=old.dret_idrd;
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_kar` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `ActualizaStock` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `ActualizaStock` AFTER UPDATE ON `fe_kar` FOR EACH ROW begin
  if new.acti='I' then
    call astock(old.idart,old.alma,old.cant,if(old.tipo="C","V","C"));
  end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_kar` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `anula_mvtos` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `anula_mvtos` AFTER DELETE ON `fe_kar` FOR EACH ROW begin
  insert fe_akardex(fech,usuario1,detalle,hora,idart,cant,prec,usuario2,ndoc,tdoc,idauto)
  values(curdate(),old.usua,concat("Se Anulo:",old.ndoc),curtime(),old.idart,old.cant,old.prec,
  old.usua,old.ndoc,old.tdoc,old.idauto);
  call astock(old.idart,old.alma,old.cant,if(old.tipo="C","V","C"));
end */$$


DELIMITER ;

/* Trigger structure for table `fe_rcom` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `ActualizaResumen` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `ActualizaResumen` AFTER UPDATE ON `fe_rcom` FOR EACH ROW begin
if new.acti='I' then
   update fe_kar set acti='I' where idauto=old.idauto;
      if old.tipom='C'  or old.tipom='G' then
        update fe_rdeu set rdeu_acti='I' where rdeu_idau=old.idauto;
        update fe_deu1 set acti='I' where idauto=old.idauto;
        update fe_rcon set rcon_acti='I' where idauto=old.idauto;
     else
      update fe_cred set acti='I' where idauto=old.idauto;
      update fe_rven set acti='I' where idauto=old.idauto;
   end if;
   insert into fe_aresumen(lres_fech,lres_idau,lres_idus)values(localtime,old.idauto,new.idusua1);
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_rcon` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaRCompras` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaRCompras` AFTER UPDATE ON `fe_rcon` FOR EACH ROW begin
if new.rcon_acti='I' then
  update fe_refe set acti='I' where idrcon=old.idrcon;
  update fe_ectasc set ecta_acti='I' where idrcon=old.idrcon;
  update fe_lcaja  set lcaj_acti='I' where lcaj_idac=old.idrcon and lcaj_acre<>0;
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_rdeu` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaDeudas` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaDeudas` AFTER UPDATE ON `fe_rdeu` FOR EACH ROW begin
if new.rdeu_acti='I' then
   update fe_deu set acti='I',deud_idu1=new.rdeu_idus1 where deud_idrd=old.rdeu_idrd;
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_rven` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaRvtas` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaRvtas` AFTER UPDATE ON `fe_rven` FOR EACH ROW begin
if new.acti='I' then
  update fe_refe set acti='I' where idrven=old.idrven;
  update fe_ectas set acti='I' where idrven=old.idrven;
  update fe_lcaja set lcaj_acti='I' where lcaj_idau=old.idrven and lcaj_deud<>0;
end if;
end */$$


DELIMITER ;

/* Function  structure for function  `DCorrelativo` */

/*!50003 DROP FUNCTION IF EXISTS `DCorrelativo` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `DCorrelativo`(nm INTEGER,ctipo CHAR) RETURNS varchar(20) CHARSET latin1
BEGIN
DECLARE nauto INTEGER;
DECLARE cmes VARCHAR(45);
DECLARE nb VARCHAR(20);
DECLARE cauto VARCHAR(20);
DECLARE CONTINUE HANDLER FOR NOT FOUND SET cauto='',nauto=0,cmes='';
IF ctipo='C' THEN
   UPDATE fe_autos SET autogc=autogc+1 WHERE idautos=nm;
   SELECT autogc,mess INTO nauto,cmes FROM fe_autos WHERE idautos=nm;
  ELSE
   UPDATE fe_autos SET autogv=autogv+1 WHERE idautos=nm;
   SELECT autogv,mess INTO nauto,cmes FROM fe_autos WHERE idautos=nm;
END IF;
SET nb=CONCAT(CONCAT(LEFT(cmes,3),'-'),RIGHT(CONCAT('00000000',TRIM(CONVERT(nauto,CHAR))),8));
RETURN nb;
END */$$
DELIMITER ;

/* Function  structure for function  `DtipoCambio` */

/*!50003 DROP FUNCTION IF EXISTS `DtipoCambio` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `DtipoCambio`(dfecha date,ctipo char) RETURNS float
BEGIN
declare nvalor float;
set nvalor=0;
if ctipo='V' then
   SELECT venta into nvalor FROM fe_mon WHERE fech=dfecha;
  else
   SELECT valor into nvalor FROM fe_mon WHERE fech=dfecha;
end if;
return nvalor;
END */$$
DELIMITER ;

/* Function  structure for function  `FunBuscaRucCliente` */

/*!50003 DROP FUNCTION IF EXISTS `FunBuscaRucCliente` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunBuscaRucCliente`(cruc varchar(11)) RETURNS int
BEGIN
declare cv INTEGER default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET cv=0;
select idclie into cv from fe_clie where nruc=cruc;
if cv=0 then
    set cv=0;
end if;
return cv;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaBancos` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaBancos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaBancos`(cnombre varchar(100),nidco varchar(2)) RETURNS int
BEGIN
declare nid integer;
insert into fe_bancos(banc_nomb,banc_idco)values(cnombre,nidco);
select last_insert_id() into nid from fe_bancos group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaCliente` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaCliente` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaCliente`(cruc varchar(11),
crazo varchar(60),cdire varchar(60),cciud varchar(50),cfono varchar(15),cfax varchar(15),cdni varchar(10),
nidusua integer,cpc varchar(50)) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_clie(nruc,razo,dire,ciud,fono,fax,ndni,fechclie,usuaclie,idpcclie)
VALUES (cruc,crazo,cdire,cciud,cfono,cfax,cdni,curdate(),nidusua,cpc);
select last_insert_id() into nid from fe_clie group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaCLientecd` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaCLientecd` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaCLientecd`(cruc varchar(11),crazo varchar(100),
cdire varchar(100),cciud varchar(100),cfono varchar(15),cfax varchar(15),cdni varchar (11),
ctipo char,cemail varchar(45),nidven integer,nidus integer,cpc varchar(45),ccelu varchar(15),
crefe varchar(255),linea float,crpm varchar(10),nidz integer,nidop integer,
cdist varchar(100),cdire1 varchar(100),cciud1 varchar(100)) RETURNS int
BEGIN
declare nid integer default 0;
INSERT INTO fe_clie(nruc,razo,dire,ciud,fono,fax,ndni,clie_tipo,clie_corr,
clie_codv,clie_idus,idpcclie,
fechclie,celu,refe,clie_lcre,clie_rpm,clie_idzo,clie_idpt,clie_dist,clie_dir1,clie_ciu1)
VALUES (cruc,crazo,cdire,cciud,cfono,cfax,cdni,ctipo,cemail,nidven,nidus,cpc,
localtime,ccelu,crefe,linea,crpm,nidz,nidop,cdist,cdire1,cciud1);
select last_insert_id() into nid from fe_clie group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaCtasBancos` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaCtasBancos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaCtasBancos`(cta VARCHAR(100),idb1 INTEGER,cmone CHAR,cdeta VARCHAR(100),nidctap INTEGER,nidalma integer) RETURNS int
BEGIN
DECLARE idb INTEGER;
INSERT INTO fe_ctasb(ctas_ctas,ctas_idba,ctas_mone,ctas_deta,ctas_ncta,ctas_codt)
VALUES(cta,idb1,cmone,cdeta,nidctap,nidalma);
SELECT LAST_INSERT_ID() INTO idb FROM fe_ctasb GROUP BY LAST_INSERT_ID();
RETURN idb;
END */$$
DELIMITER ;

/* Function  structure for function  `FuncreaIngresochequesCr` */

/*!50003 DROP FUNCTION IF EXISTS `FuncreaIngresochequesCr` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FuncreaIngresochequesCr`(nidch integer,nidcr integer) RETURNS int
begin
declare id integer default 0;
insert into fe_ecrch(ecch_idch,ecch_idcr)values(nidch,nidcr);
select last_insert_id() into id from fe_ecrch group by last_insert_id();
return id;
end */$$
DELIMITER ;

/* Function  structure for function  `FunCreaPlanCuentas` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaPlanCuentas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaPlanCuentas`(cn varchar(8),cdes varchar(120),
cdd varchar(8),cdh varchar(8),cuenta varchar(12),cope char) RETURNS int
BEGIN
declare nid integer;
INSERT INTO fe_plan(ncta,nomb,cdestinod,cdestinoh,tipocta,plan_oper)values(cn,cdes,cdd,cdh,cuenta,cope);
select last_insert_id() into nid from fe_plan group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaProveedor` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaProveedor` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaProveedor`(
cruc varchar(11),crazon varchar(100),cdire varchar(100),cciud varchar(100),
cfono varchar(15),cfax varchar(15),crpm varchar(15),cemail varchar(45),crefe varchar(200),ccelu varchar(10),
nidusua integer,cpc varchar(50)) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_prov(nruc,razo,dire,ciud,fono,fax,fechprov,idusua,idpcprov,refe,email,celu)
VALUES (cruc,crazon,cdire,cciud,cfono,cfax,localtime,nidusua,cpc,crefe,cemail,ccelu);
select last_insert_id() into nid from fe_prov group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaSeriesDctos` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaSeriesDctos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaSeriesDctos`(cserie INTEGER,cnume INTEGER,ctdoc VARCHAR(2),nitems INTEGER,ntda INTEGER) RETURNS int
BEGIN
DECLARE ids INTEGER DEFAULT 0;
INSERT INTO fe_serie(tdoc,serie,nume,codt,items,seri_idal)
VALUES(ctdoc,cserie,cnume,ntda,nitems,ntda);
SELECT LAST_INSERT_ID() INTO ids FROM fe_serie GROUP BY LAST_INSERT_ID();
RETURN ids;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaTransportista` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaTransportista` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaTransportista`(cplaca varchar(10),crazo varchar(50),
cdir varchar(50),nruc varchar(11),chofe varchar(50),cbreve varchar(25),
cmarca varchar(50),ccons varchar(40),nidus integer,cplaca1 varchar(10)) RETURNS int
BEGIN
declare nid integer default 0;
INSERT  INTO fe_tra(placa,razon,dirtr,ructr,nombr,breve,marca,cons,tran_idus,placa1)
values(cplaca,crazo,cdir,nruc,chofe,cbreve,cmarca,ccons,nidus,cplaca1);
select last_insert_id() into nid from fe_tra group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunDtipoCambio` */

/*!50003 DROP FUNCTION IF EXISTS `FunDtipoCambio` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunDtipoCambio`(dfecha date,ctipo char) RETURNS decimal(6,4)
BEGIN
declare nvalor decimal(6,4);
set nvalor=0;
if ctipo='V' then
   SELECT venta into nvalor FROM fe_mon WHERE fech=dfecha;
  else
   SELECT valor into nvalor FROM fe_mon WHERE fech=dfecha;
end if;
return nvalor;
END */$$
DELIMITER ;

/* Function  structure for function  `FunHayCompra` */

/*!50003 DROP FUNCTION IF EXISTS `FunHayCompra` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunHayCompra`(cdcto varchar(10),ctdoc varchar(2),idp integer,nidauto integer) RETURNS int
BEGIN
declare sw integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET sw=0;
if nidauto=0 then
   select idauto into sw from fe_rcom where ndoc=cdcto and tdoc=ctdoc and idprov=idp and tipom='C' and acti<>'I'  group by idauto;
  else
   select idauto into sw from fe_rcom where ndoc=cdcto and tdoc=ctdoc and idprov=idp and tipom='C' and idauto<>nidauto and acti<>'I' group by idauto;
end if;
return sw;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngGuias` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngGuias` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngGuias`(dfech date,idauto integer,cptop varchar(100),
cptoll varchar(100),nidclie integer,dfect date,nidus integer,nidtra integer,cndoc varchar(10),nidtda integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
insert into fe_rguias(rgui_fech,rgui_idau,rgui_ptop,rgui_ptoll,rgui_idcl,rgui_fect,rgui_idus,
rgui_fope,rgui_idtr,rgui_ndoc,rgui_codt)values(dfech,idauto,cptop,cptoll,nidclie,dfect,nidus,curdate(),nidtra,cndoc,nidtda);
select last_insert_id() into nid from fe_rguias group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCabeceraCotizacion` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCabeceraCotizacion` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCabeceraCotizacion`(dfech datetime,nidclie integer,
cndoc varchar(10),ctdoc varchar(2),nimpo float,cform char,cusua integer,cidpcped varchar(45),nidven integer,nidtienda integer,ctp char,
caten varchar(80),cforma varchar(80),cplazo varchar(80),cvalidez varchar(80),centrega varchar(80),cdetalle varchar(150),cmone char) RETURNS int
BEGIN
declare nid integer default 0;
INSERT INTO fe_rped(fech,idclie,ndoc,tdoc,impo,form,rped_idus,idpcped,fecho,idven,idtienda,tipopedido,aten,forma,plazo,validez,entrega,detalle,rped_mone)
VALUES(dfech,nidclie,cndoc,ctdoc,nimpo,cform,cusua,cidpcped,localtime,nidven,nidtienda,ctp,caten,cforma,cplazo,cvalidez,centrega,cdetalle,cmone);
select last_insert_id() into nid from fe_rped group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCabeceraCV` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCabeceraCV` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCabeceraCV`(
ctdoc varchar(2),cform char,cndoc varchar(12),dfecha date,dfechar date,cdetalle varchar(220),
nv decimal(12,2),nigv decimal(12,2),nt decimal(12,2),cndo2 varchar(10),cm char,
ndolar decimal(6,4),ni decimal(6,4),ctg char,ccodp integer,cmvto char,nus integer,opt integer,nidcodt integer,
n1 integer,n2 integer,n3 integer,nitem integer,idtr decimal(10,2)) RETURNS int
BEGIN
declare nid,ntdoc integer;
declare ctipo char;
set ntdoc=0;
set nid=0;
select idtdoc into ntdoc from fe_tdoc where tdoc=ctdoc group by idtdoc;
if opt=0 then
    if (ctdoc='01' or ctdoc='09' or ctdoc='II' or ctdoc='07' or ctdoc='08') and ucase(ctg)='K' then
      set ctipo='C';
     else
      set ctipo='I';
   end if;
   INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,dolar,vigv,tcom,idprov,tipom,fusua,idusua,codt,rcom_tipo)
   VALUES (ctdoc,cform,cndoc,dfecha,dfechar,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,ctg,ccodp,cmvto,localtime,nus,nidcodt,ctipo);
   select last_insert_id() into nid from fe_rcom group by last_insert_id();
   if n1>0 and n2>0 and n3>0 then
   Call ProIngresaRcompras(ccodp,ntdoc,cform,cndoc,dfecha,dfecha,cm,ndolar,ni,cdetalle,dfecha,nidcodt,ctg,nus,nv,nigv,nt,n1,n2,n3,nid);
   end if;
  else
  if ctdoc='20' then
      set ctipo='I';
    else
      set ctipo='C';
   end if;
   INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,dolar,vigv,tcom,idcliente,tipom,fusua,idusua,codt,pimpo,rcom_tipo)
   VALUES (ctdoc,cform,cndoc,dfecha,dfecha,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,ctg,ccodp,cmvto,localtime,nus,nidcodt,idtr,ctipo);
   select last_insert_id() into nid from fe_rcom group by last_insert_id();
 if n1>0 and n2>0 and n3>0 then
   call ProIngresaRVentas(ccodp,ntdoc,cform,cndoc,dfecha,dfecha,dfecha,cm,ndolar,ni,nid,nus,nv,nigv,nt,n1,n2,n3,idtr);
end if ;
end if;
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCaja` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCaja` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCaja`(
na integer,dfecha date,nt1 float,cmvtoc char,cform char,cm1 char,cndoc varchar(12),nidcon integer,
cu integer,cdetalle varchar(120),cor varchar(2),nimp1 float,cm2 char,tcvta float,nidcodt integer,cajas char,nidcr integer,ide integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_caja(idauto,fech,impo,tipo,forma,tmon,ndoc,idcon,idusua,fechao,deta,origen,nimpo,mone,dola,codt)
VALUES (na,dfecha,nt1,cmvtoc,cform,cm1,cndoc,nidcon,cu,localtime,cdetalle,cor,nimp1,cm2,tcvta,nidcodt);
select last_insert_id() into nid from fe_caja group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCajaBancos` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCajaBancos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCajaBancos`(idb integer,dfecha date,nop varchar(20),idmp integer,
cdeta varchar(120),idpr integer,idcl integer,cndoc varchar(20),idcta integer,debe decimal(12,2),
haber decimal(12,2),norden integer,nidclpr integer) RETURNS int
BEGIN
declare id integer;
insert into fe_cbancos(cban_idba,cban_nume,cban_fech,cban_idmp,cban_deta,cban_idpr,cban_idcl,cban_ndoc,cban_idct,
cban_debe,cban_haber,cban_orde,cban_clpr)values(idb,nop,dfecha,idmp,cdeta,idpr,idcl,cndoc,idcta,debe,haber,norden,nidclpr);
select last_insert_id() into id from fe_cbancos group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCajaBancosT` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCajaBancosT` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCajaBancosT`(idb integer,dfecha date,nop varchar(20),idmp integer,
cdeta varchar(120),idpr integer,idcl integer,cndoc varchar(20),idcta integer,debe decimal(12,2),
haber decimal(12,2),norden integer,nidclpr integer) RETURNS int
BEGIN
declare id integer;
insert into fe_cbancos(cban_idba,cban_nume,cban_fech,cban_idmp,cban_deta,cban_idpr,cban_idcl,cban_ndoc,cban_idct,
cban_debe,cban_haber,cban_orde,cban_idca)values(idb,nop,dfecha,idmp,cdeta,idpr,idcl,cndoc,idcta,debe,haber,norden,nidclpr);
select last_insert_id() into id from fe_cbancos group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCajaBancosTran` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCajaBancosTran` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCajaBancosTran`(idb integer,dfecha date,nop varchar(20),idmp integer,
cdeta varchar(120),idpr integer,idcl integer,cndoc varchar(20),idcta integer,debe decimal(12,2),
haber decimal(12,2),norden integer,nidclpr integer) RETURNS int
BEGIN
declare id integer;
insert into fe_cbancos(cban_idba,cban_nume,cban_fech,cban_idmp,cban_deta,cban_idpr,cban_idcl,cban_ndoc,cban_idct,
cban_debe,cban_haber,cban_orde,cban_clpr,cban_tran,cban_ttra)values
(idb,nop,dfecha,idmp,cdeta,idpr,idcl,cndoc,idcta,debe,haber,norden,nidclpr,'T','T');
select last_insert_id() into id from fe_cbancos group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCheques` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCheques` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCheques`(cbanco varchar(45),cnumero varchar(45),dfechag date,
dfechac date,cmone char,nimpo float,nidch integer,nidus integer) RETURNS int
BEGIN
declare nid integer;
insert into fe_cheques(cheq_banc,cheq_nume,cheq_fecg,cheq_fecc,cheq_mone,cheq_impo,cheq_idrc,cheq_fech,cheq_idus)
values(cbanco,cnumero,dfechag,dfechac,cmone,nimpo,nidch,localtime(),nidus);
select last_insert_id() into nid from fe_cheques group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCreditos` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCreditos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCreditos`(
nauto integer,nidcl integer,cndoc varchar(10),cest char,cmon char,crefe varchar(120),
dfecha date,dfevto date,ctipo char,cdocp varchar(10),ndolar float,csitua varchar(2),
nimpo float,ni float,idven integer,nimpoo float,cusua integer,nidaval integer,ndscto float,
cpc varchar(50),nidcodt integer,nidch integer,nidch1 integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_cred(idauto,idclie,ndoc,estd,mone,banc,fech,fevto,tipo,docd,dola,situa,impo,
inic,idven,impc,idusua,idaval,dscto,cre_idpc,cre_fope,codt,cre_idrc,cre_idch)values(nauto,nidcl,cndoc,cest,cmon,crefe,dfecha,dfevto,
ctipo,cdocp,ndolar,csitua,nimpo,ni,idven,nimpoo,cusua,nidaval,ndscto,cpc,curdate(),nidcodt,nidch,nidch1);
select last_insert_id() into nid from fe_cred group by last_insert_id();
UPDATE fe_cred SET ncontrol=nid,inic=ni WHERE idcred=nid;
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCtasCtesC` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCtasCtesC` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCtasCtesC`(nid integer,dfech date,nidlc integer,ct char,nimpo float,mone char,idpr integer) RETURNS int
BEGIN
declare id integer;
if ct='D' then
   INSERT INTO fe_ctasctesc(ctcc_idau,ctcc_fech,ctcc_idlc,ctcc_tipo,ctcc_debe,ctcc_mone,ctcc_idpr)
   values(nid,dfech,nidlc,ct,nimpo,mone,idpr);
  else
   INSERT INTO fe_ctasctesc(ctcc_idau,ctcc_fech,ctcc_idlc,ctcc_tipo,ctcc_haber,ctcc_mone,ctcc_idpr)
   values(nid,dfech,nidlc,ct,nimpo,mone,idpr);
end if;
select last_insert_id() into id from fe_ctasctesc group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCtasCtesV` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCtasCtesV` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCtasCtesV`(nid integer,dfech date,nidlc integer,ct char,nimpo float,mone char,idcl integer) RETURNS int
BEGIN
declare id integer;
if ct='D' then
   INSERT INTO fe_ctasctesv(ctcv_idau,ctcv_fech,ctcv_idlc,ctcv_tipo,ctcv_debe,ctcv_mone,ctcv_idcl)
   values(nid,dfech,nidlc,ct,nimpo,mone,idcl);
  else
   INSERT INTO fe_ctasctesv(ctcv_idau,ctcv_fech,ctcv_idlc,ctcv_tipo,ctcv_haber,ctcv_mone,ctcv_idcl)
   values(nid,dfech,nidlc,ct,nimpo,mone,idcl);
end if;
select last_insert_id() into id from fe_ctasctesv group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaDatosLibroDiario` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDatosLibroDiario` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDatosLibroDiario`(dfech datetime,ndebe decimal(12,2),nhaber decimal(12,2),cglosa varchar(200),
ct char(1),cnume varchar(14),nidcta integer,ccond char,nit integer,ncomp varchar(15),nidcl integer,
nidpr integer,cmone char,ctran char,nimtd decimal (12,2),nimth decimal(12,2),nidt integer) RETURNS int
BEGIN
declare iddiario integer default 0;
insert into fe_ldiario(ldia_fech,ldia_debe,ldia_haber,ldia_glosa,ldia_tipo,
ldia_nume,ldia_idcta,ldia_cond,ldia_item,ldia_comp,ldia_idcv,ldia_idcc,ldia_mone,ldia_tran,ldia_itrd,ldia_itrh,ldia_codt)
values(dfech,ndebe,nhaber,cglosa,ct,cnume,nidcta,ccond,nit,ncomp,nidcl,nidpr,cmone,ctran,nimtd,nimth,nidt);
select last_insert_id() into iddiario from fe_ldiario group by last_insert_id();
return iddiario;
END */$$
DELIMITER ;

/* Function  structure for function  `FuningresaDCotizacion` */

/*!50003 DROP FUNCTION IF EXISTS `FuningresaDCotizacion` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FuningresaDCotizacion`(ncoda integer,ncant float,nprec float,nidauto integer) RETURNS int
BEGIN
declare id integer default 0;
INSERT INTO fe_ped(idart,cant,prec,idautop)VALUES(ncoda,ncant,nprec,nidauto);
select last_insert_id() into id from fe_ped group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaDeudas` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDeudas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDeudas`(nidrd integer,
cndoc varchar(12),cest char,dfecha date,dfevto date,ctipo char,ndolar float,
nimpo float,cusua integer,cpc varchar(50),nidcodt integer,cnrou varchar(15),
cdeta varchar(80),csitua varchar(2)) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_deu(fech,fevto,impo,nrou,ndoc,estd,banc,situa,tipo,dola,deud_idus,deud_idrd,deud_fope)
values(dfecha,dfevto,nimpo,cnrou,cndoc,'C',cdeta,csitua,ctipo,ndolar,cusua,nidrd,localtime);
select last_insert_id() into nid from fe_deu group by last_insert_id();
UPDATE fe_deu SET ncontrol=nid WHERE iddeu=nid;
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaDeudas1` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDeudas1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDeudas1`(
nauto integer,nidpr integer,cndoc varchar(12),cest char,cmon char,crefe varchar(120),
dfecha date,dfevto date,ctipo char,cdocp varchar(12),ndolar float,
nimpo float,cusua integer,cpc varchar(50),nidcodt integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_deu1(idauto,idprov,ndoc,estd,mone,banc,fech,fevto,tipo,docd,dola,impo,
impc,idusua,deu_idpc,deu_fope,codt)values(nauto,nidpr,cndoc,cest,cmon,crefe,dfecha,dfevto,
ctipo,cdocp,ndolar,nimpo,nimpo,cusua,cpc,localtime,nidcodt);
select last_insert_id() into nid from fe_cred group by last_insert_id();
UPDATE fe_deu1 SET ncontrol=nid WHERE iddeu=nid;
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaDPedidos` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDPedidos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDPedidos`(ncoda integer,ncant float,nprec float,nidauto integer) RETURNS int
BEGIN
declare id integer default 0;
INSERT INTO fe_ped(idart,cant,prec,idautop)
VALUES(ncoda,ncant,nprec,nidauto);
select last_insert_id() into id from fe_ped group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaKardex1` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaKardex1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaKardex1`(nid integer,cc integer,ct char,npr float,
nct float,cincl char,tmvto char,ccodv integer,calma integer,nidcosto1 integer,vcom float) RETURNS int
BEGIN
declare nidk integer default 0;
if ct='C' then
  INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,ttip,incl,alma,codv)
  VALUES (nid,cc,ct,npr,nct,tmvto,cincl,calma,ccodv);
 else
  INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,ttip,incl,alma,codv)
  VALUES (nid,cc,ct,npr,nct,tmvto,cincl,calma,ccodv);
end if;
select last_insert_id() into nidk from fe_kar group by last_insert_id();
return nidk;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaKardex2` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaKardex2` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaKardex2`(nid integer,cc integer,ct char,npr float,
nct float,cincl char,tmvto char,ccodv integer,calma integer,nidcosto1 integer,vcom float,nper decimal(5,2)) RETURNS int
BEGIN
declare nidk integer default 0;
if ct='C' then
  INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,ttip,incl,alma,codv)
  VALUES (nid,cc,ct,npr,nct,tmvto,cincl,calma,ccodv);
 else
  INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,ttip,incl,alma,codv,kar_perc)
  VALUES (nid,cc,ct,npr,nct,tmvto,cincl,calma,ccodv,nper);
end if;
select last_insert_id() into nidk from fe_kar group by last_insert_id();
return nidk;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaOtrasCompras` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaOtrasCompras` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaOtrasCompras`(nidprov integer,
ctdoc integer,cform char,cndoc varchar(12),dfecha date,dfechar date,cmon char,ndolar float,nigv1 float,cdetalle varchar(80),
nauto varchar(20),dfevto date,nidalma integer,ctipo char,cusua varchar(45),autorc integer) RETURNS int
BEGIN
declare id integer;
INSERT INTO fe_rcon(idprov,idtdoc,form,ndoc,fech,fecr,mone,dolar,vigv,detalle,auto,fevto,idalma,tipo,usua,fusua,idauto)
values(nidprov,ctdoc,cform,cndoc,dfecha,dfechar,cmon,ndolar,nigv1,cdetalle,nauto,dfevto,nidalma,ctipo,cusua,localtime,autorc);
select last_insert_id() into id from fe_rcon group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaPagosCreditos` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosCreditos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosCreditos`(nidclie integer,cndoc varchar(10),
cdocp varchar(10),nacta float,cesta char,cmone char,cb1 varchar(80),
dfech date,dfevto date,ctipo char,ndola float,cbco varchar(40),csitua varchar(2),
nimpc float,nctrl integer,nidven integer,nu integer,cnrou varchar(60),
nauto integer,nidaval integer,cfo CHAR,ndscto float,cpc varchar(45),nidtda integer,nidch integer,nidch1 integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_cred(idclie,ndoc,docd,acta,estd,mone,banc,fech,fevto,tipo,dola,banco,situa,impc,ncontrol,idven,
idusua,nrou,idauto,idaval,form,dscto,codt,cre_idpc,cre_fope,cre_idrc,cre_idch)values
(nidclie,cndoc,cdocp,nacta,cesta,cmone,cb1,dfech,dfevto,ctipo,ndola,
cbco,csitua,nimpc,nctrl,nidven,nu,cnrou,nauto,nidaval,cfo,ndscto,nidtda,cpc,curdate(),nidch,nidch1);
select last_insert_id() into nid from fe_cred group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaPagosDeudas` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosDeudas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosDeudas`(dfech datetime,
dfevto datetime,nacta float,cndoc varchar(12),cesta char,cmone char,cb1 varchar(100),ctipo char,
nidrc integer,idusua integer,nctrl integer,cnrou varchar(25),cpc varchar(45),ndolar float) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_deu(fech,fevto,acta,ndoc,estd,banc,tipo,deud_idrd,deud_idus,deud_fope,ncontrol,nrou,deud_idpc,dola)
values(dfech,dfevto,nacta,cndoc,cesta,cb1,ctipo,nidrc,idusua,localtime,nctrl,cnrou,cpc,ndolar);
select last_insert_id() into nid from fe_deu group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaPagosDeudas1` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosDeudas1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosDeudas1`(dfech datetime,
dfevto datetime,nacta float,cndoc varchar(10),cesta char,cmone char,cb1 varchar(100),ctipo char,
nctrl integer,cnrou varchar(25)) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_deu(fech,fevto,acta,ndoc,estd,banc,tipo,ncontrol,nrou,mone)
values(dfech,dfevto,nacta,cndoc,cesta,cb1,ctipo,nctrl,cnrou,cmone);
select last_insert_id() into nid from fe_deu group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaRRetencion` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaRRetencion` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaRRetencion`(dfecha date,nidpr integer,importe decimal(12,2),ndoc varchar(12),moneda char(1),
dolar decimal(6,4),nidus integer) RETURNS int
begin
declare vd integer default 0;
insert into fe_rret(rete_fech,rete_idpr,rete_impo,rete_ndoc,rete_dola,rete_mone,rete_idus,rete_fope)values(dfecha,nidpr,importe,ndoc,dolar,moneda,nidus,localtime);
select last_insert_id() into vd from fe_rret group by last_insert_id();
return vd;
end */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaRventas` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaRventas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaRventas`(
nidclie INTEGER,ntdoc INTEGER,cform CHAR,cndoc VARCHAR(12),
dfecha DATE,dfecha1 DATE,dfevto DATE,cm CHAR,ndolar FLOAT,ni FLOAT,nus INTEGER,
nt1 FLOAT,nt2 FLOAT,nt3 FLOAT,
nidcta1 INTEGER,nidcta2 INTEGER,nidcta3 INTEGER,nt4 DECIMAL(12,2),nidcta4 INTEGER,nidalma INTEGER,
nidcta5 INTEGER,nt5 DECIMAL(12,2)) RETURNS int
BEGIN
DECLARE nid1,nmes INTEGER;
DECLARE cauto VARCHAR(20);
DECLARE nimpo1,nimpo2,nimpo3,ndd,nddd,nimpo4,nimpo5 DECIMAL(12,2);
SET nid1=0;
SET nddd=0;
SET ndd=0;
SET nmes=MONTH(dfecha);
SELECT dcorrelativo(nmes,'V') INTO cauto;
SELECT dtipocambio(dfecha,'V') INTO ndd;
IF ndd>0 THEN
   SET nddd=ndd;
  ELSE
   SELECT dola INTO nddd FROM fe_gene WHERE idgene=1;
END IF;
INSERT INTO fe_rven(auto,idclie,idtdoc,form,ndoc,fech,fecr,fevto,mone,dolar,vigv,idauto,idusua,fusua,dolao,pimpo,idalma)
VALUES(cauto,nidclie,ntdoc,cform,cndoc,dfecha,dfecha1,dfevto,cm,ndd,ni,0,nus,LOCALTIME,nddd,nt4,nidalma);
SELECT LAST_INSERT_ID() INTO nid1 FROM fe_rven GROUP BY LAST_INSERT_ID();
SET nimpo1=IF(cm='D',nt1*nddd,nt1);
SET nimpo2=IF(cm='D',nt2*nddd,nt2);
SET nimpo3=IF(cm='D',nt3*nddd,nt3);
SET nimpo4=IF(cm='D',nt4*nddd,nt4);
SET nimpo5=IF(cm='D',nt5*nddd,nt5);
CALL ProIngresaCuentasV(nimpo1,nimpo2,nimpo3,nidcta1,nidcta2,nidcta3,nid1,nimpo4,nidcta4,nimpo5,nidcta5);
RETURN nid1;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaRventas1` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaRventas1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaRventas1`(
nidclie integer,ntdoc integer,cform char,cndoc varchar(12),
dfecha date,dfecha1 date,dfevto date,cm char,ndolar float,ni float,nus integer,
nt1 float,nt2 float,nt3 float,nidcta1 integer,nidcta2 integer,nidcta3 integer,nt4 decimal(12,2),nidcta4 integer,nidalma integer) RETURNS int
BEGIN
declare nid1,nmes integer;
declare cauto varchar(20);
declare nimpo1,nimpo2,nimpo3,ndd,nddd,nimpo4 float;
set nid1=0;
set nddd=0;
set ndd=0;
set nmes=MONTH(dfecha);
SELECT dcorrelativo(nmes,'V') into cauto;
SELECT dtipocambio(dfecha,'V') into ndd;
IF ndd>0 then
   set nddd=ndd;
  else
   select dola into nddd from fe_gene where idgene=1;
ENd if;
INSERT INTO fe_rven(auto,idclie,idtdoc,form,ndoc,fech,fecr,fevto,mone,dolar,vigv,idauto,idusua,fusua,dolao,pimpo,idalma,arreg)
values(cauto,nidclie,ntdoc,cform,cndoc,dfecha,dfecha1,dfevto,cm,ndd,ni,0,nus,curdate(),nddd,nt4,nidalma,'I');
select last_insert_id() into nid1 from fe_rven group by last_insert_id();
set nimpo1=if(cm='D',nt1*nddd,nt1);
set nimpo2=if(cm='D',nt2*nddd,nt2);
set nimpo3=if(cm='D',nt3*nddd,nt3);
set nimpo4=if(cm='D',nt4*nddd,nt4);
call ProIngresaCuentasV(nimpo1,nimpo2,nimpo3,nidcta1,nidcta2,nidcta3,nid1,nimpo4,nidcta4);
return nid1;
END */$$
DELIMITER ;

/* Function  structure for function  `FunMuestraCostosxProdcucto` */

/*!50003 DROP FUNCTION IF EXISTS `FunMuestraCostosxProdcucto` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunMuestraCostosxProdcucto`(nidart integer) RETURNS float
begin
declare costop float default 0;
select ifnull(precio/tr,0) into costop from(select ifnull(sum(prec),0) as precio,count(*) as tr from(
select prec from vcostoproducto where idart=nidart limit 2) as x) as y;
return costop;
end */$$
DELIMITER ;

/* Function  structure for function  `FunRegistraDeudas` */

/*!50003 DROP FUNCTION IF EXISTS `FunRegistraDeudas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunRegistraDeudas`(nauto integer,nid integer,
cmon char,dfecha date,nimpoo float,nidus integer,nidtda integer,cpc varchar(45)) RETURNS int
BEGIN
declare id integer default 0;
insert into fe_rdeu(rdeu_idpr,rdeu_fech,rdeu_idau,rdeu_impc,rdeu_idus,rdeu_codt,rdeu_idpc,rdeu_mone)
values(nid,dfecha,nauto,nimpoo,nidus,nidtda,cpc,cmon);
select last_insert_id() into id from fe_rdeu group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunRegistraDeudasCCtas` */

/*!50003 DROP FUNCTION IF EXISTS `FunRegistraDeudasCCtas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunRegistraDeudasCCtas`(nauto integer,nid integer,
cmon char,dfecha date,nimpoo float,nidus integer,nidtda integer,cpc varchar(45),nidcta integer) RETURNS int
BEGIN
declare id integer default 0;
insert into fe_rdeu(rdeu_idpr,rdeu_fech,rdeu_idau,rdeu_impc,rdeu_idus,rdeu_codt,rdeu_idpc,rdeu_mone,rdeu_idct)
values(nid,dfecha,nauto,nimpoo,nidus,nidtda,cpc,cmon,nidcta);
select last_insert_id() into id from fe_rdeu group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunRRcheques` */

/*!50003 DROP FUNCTION IF EXISTS `FunRRcheques` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunRRcheques`(nidclie integer,nidtda integer) RETURNS int
BEGIN
declare nid integer default 0;
insert into fe_rcheq(rche_idcl,rche_codt)values(nidclie,nidtda);
select last_insert_id() into nid from fe_rcheq group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunTraspasoDatosLcajaE` */

/*!50003 DROP FUNCTION IF EXISTS `FunTraspasoDatosLcajaE` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunTraspasoDatosLcajaE`(dfecha DATETIME,cndoc VARCHAR(10),cdeta VARCHAR(100),idcta INTEGER,sdeudor DECIMAL(12,2),
sacreedor DECIMAL(12,2),cmone CHAR,ndolar DECIMAL(5,3),nidus INTEGER,nidcp INTEGER,nidalma INTEGER) RETURNS int
BEGIN
DECLARE id INTEGER;
INSERT INTO fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,lcaj_idus,lcaj_clpr,
lcaj_tran,lcaj_codt)VALUES
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,'T',nidalma);
SELECT LAST_INSERT_ID() INTO id FROM fe_lcaja GROUP BY LAST_INSERT_ID();
RETURN id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunValidaCajaTda` */

/*!50003 DROP FUNCTION IF EXISTS `FunValidaCajaTda` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunValidaCajaTda`(dfecha date,nidalma integer) RETURNS int
begin
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
if year(dfecha)<2013 then
  return 0;
 else
  SELECT idcaja into vdvto FROM fe_caja WHERE fech=dfecha AND estado="C" AND acti='A' and codt=nidalma group by estado;
   if vdvto>0 then
      return 0;
     else
      return 1;
    end if;
end if;
end */$$
DELIMITER ;

/* Function  structure for function  `FunValidaDctos` */

/*!50003 DROP FUNCTION IF EXISTS `FunValidaDctos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunValidaDctos`(cmvto char,cdcto varchar(10),ctdoc varchar(2)) RETURNS int
BEGIN
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
SELECT idauto into vdvto FROM fe_rcom WHERE ndoc=cdcto and tdoc=ctdoc and tipom=cmvto AND acti<>'I';
return vdvto;
END */$$
DELIMITER ;

/* Function  structure for function  `FunVerificabancos` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificabancos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificabancos`(nid integer) RETURNS int
BEGIN
declare id integer default 0;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET id = 0;
select banc_idba into id from fe_cheques where cheq_idba=nid;
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FUnVerificaBloqueo` */

/*!50003 DROP FUNCTION IF EXISTS `FUnVerificaBloqueo` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FUnVerificaBloqueo`(dfecha date) RETURNS int
begin
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
if year(dfecha)<2013 then
  return 0;
 else
   select idauto into vdvto from fe_rcom where month(fecr)=month(dfecha) and
   year(fecr)=year(dfecha) and acti='A' and rcom_bloq='C' and idcliente>0 group by rcom_bloq;
   if vdvto>0 then
      return 0;
     else
      return 1;
    end if;
end if;
end */$$
DELIMITER ;

/* Function  structure for function  `FUnVerificaBloqueo1` */

/*!50003 DROP FUNCTION IF EXISTS `FUnVerificaBloqueo1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FUnVerificaBloqueo1`(dfecha date) RETURNS int
begin
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
if year(dfecha)<2013 then
  return 0;
 else
   select idrcon as idauto into vdvto from fe_rcon where month(fecr)=month(dfecha) and
   year(fecr)=year(dfecha) and rcon_acti='A' and rcon_bloq='C' group by rcon_bloq;
   if vdvto>0 then
      return 0;
     else
      return 1;
    end if;
end if;
end */$$
DELIMITER ;

/* Function  structure for function  `FUnVerificaBloqueoBcos` */

/*!50003 DROP FUNCTION IF EXISTS `FUnVerificaBloqueoBcos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FUnVerificaBloqueoBcos`(dfecha date,nid integer) RETURNS int
begin
declare vdvto integer default 0;
select cban_idco into vdvto from fe_cbancos where month(cban_fech)=month(dfecha) and year(cban_fech)=year(dfecha)
 and cban_acti='A' and cban_bloq='C' and cban_idba=nid group by cban_bloq;
if vdvto>0 then
   return 0;
  else
   return 1;
end if;
end */$$
DELIMITER ;

/* Function  structure for function  `FUnVerificaBloqueoCajaEfectivo` */

/*!50003 DROP FUNCTION IF EXISTS `FUnVerificaBloqueoCajaEfectivo` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FUnVerificaBloqueoCajaEfectivo`(dfecha date) RETURNS int
begin
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
if year(dfecha)<2013 then
  return 0;
 else
   select lcaj_idca  into vdvto from fe_lcaja where month(lcaj_fech)=month(dfecha) and
   year(lcaj_fech)=year(dfecha) and lcaj_acti='A' and lcaj_bloq='C' group by lcaj_bloq;
   if vdvto>0 then
      return 0;
     else
      return 1;
    end if;
end if;
end */$$
DELIMITER ;

/* Function  structure for function  `FUnVerificaBloqueoComprasM` */

/*!50003 DROP FUNCTION IF EXISTS `FUnVerificaBloqueoComprasM` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FUnVerificaBloqueoComprasM`(dfecha date) RETURNS int
begin
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
if year(dfecha)<2013 then
  return 0;
 else
   select idauto into vdvto from fe_rcom where month(fecr)=month(dfecha) and
   year(fecr)=year(dfecha) and acti='A' and rcom_bloq='C' and idprov>0 group by rcom_bloq;
   if vdvto>0 then
      return 0;
     else
      return 1;
    end if;
end if;
end */$$
DELIMITER ;

/* Function  structure for function  `FUnVerificaBloqueoCreditos` */

/*!50003 DROP FUNCTION IF EXISTS `FUnVerificaBloqueoCreditos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FUnVerificaBloqueoCreditos`(dfecha date) RETURNS int
begin
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
if year(dfecha)<2013 then
  return 0;
 else
   select idcred into vdvto from fe_cred where fech=dfecha and acti='A' and cred_bloq='C' group by cred_bloq;
   if vdvto>0 then
      return 0;
     else
      return 1;
    end if;
end if;
end */$$
DELIMITER ;

/* Function  structure for function  `FUnVerificaBloqueoVentasM` */

/*!50003 DROP FUNCTION IF EXISTS `FUnVerificaBloqueoVentasM` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FUnVerificaBloqueoVentasM`(dfecha date) RETURNS int
begin
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
if year(dfecha)<2013 then
  return 0;
 else
   select idauto into vdvto from fe_rcom where month(fecr)=month(dfecha) and
   year(fecr)=year(dfecha) and acti='A' and rcom_bloq='C' and idcliente>0 group by rcom_bloq;
   if vdvto>0 then
      return 0;
     else
      return 1;
    end if;
end if;
end */$$
DELIMITER ;

/* Function  structure for function  `FUNVERIFICACAJA` */

/*!50003 DROP FUNCTION IF EXISTS `FUNVERIFICACAJA` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FUNVERIFICACAJA`(df datetime) RETURNS int
BEGIN
declare tr integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET tr=0;
SELECT COUNT(*) into tr FROM fe_caja WHERE fech=df AND estado="C" AND acti<>'I';
return tr;
END */$$
DELIMITER ;

/* Function  structure for function  `FunVerificaEstadoDeuda` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaEstadoDeuda` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaEstadoDeuda`(nidauto integer) RETURNS int
BEGIN
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
set vdvto=(select a.rdeu_idau from fe_rdeu as a inner join fe_deu as b on b.deud_idrd=a.rdeu_idrd
where rdeu_idau=nidauto  and a.rdeu_acti<>'I' and b.acti<>'I' and b.acta>0 group by rdeu_idau);
return vdvto;
END */$$
DELIMITER ;

/* Function  structure for function  `FunVerificaPagos` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaPagos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaPagos`(nid integer) RETURNS int
BEGIN
declare sw,sw1 integer;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET sw=0,sw1=0;
set sw:=(SELECT count(rcre_idau) FROM fe_cred as b inner join fe_rcreD as a
on(a.rcre_idrc=b.cred_idrc) WHERE b.acta>0 AND a.rcre_idau=nid AND acti<>'I'group by a.rcre_idau);
set sw1:=(SELECT count(rcre_idau)  FROM fe_rcred as b WHERE b.rcre_inic>0 AND b.rcre_idau=nid AND b.rcre_acti<>'I'group by b.rcre_idau);
if sw>0 or sw1>0 then
   return 1;
  else
   return 0;
end if;
END */$$
DELIMITER ;

/* Function  structure for function  `FunVerificaRetencion` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaRetencion` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaRetencion`(cndoc varchar(12)) RETURNS int
begin
declare idr integer default 0;
select rete_idre into idr from fe_rret where rete_ndoc=cndoc and rete_Acti='A' group by rete_idre;
return idr;
end */$$
DELIMITER ;

/* Function  structure for function  `FunVerificaSiestaCajaB` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaSiestaCajaB` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaSiestaCajaB`(nid integer) RETURNS int
begin
declare xid integer default 0;
set xid:=(select ifnull(cban_clpr,0) from fe_cbancos where cban_clpr=nid group by cban_clpr);
if xid=0 or isnull(xid) then
   return 0;
 else
   return 1;
end if;
end */$$
DELIMITER ;

/* Function  structure for function  `FunVerificaSiestaCanjeadoD` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaSiestaCanjeadoD` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaSiestaCanjeadoD`(nidc integer) RETURNS int
begin
declare vdvto integer default 0;
select canj_idrc into vdvto from fe_dcanjes where canj_idrc=nidc and canj_acti='A'  group by canj_idrc;
if vdvto>0 then
   return 0;
 else
   return 1;
end if;
end */$$
DELIMITER ;

/* Function  structure for function  `FunVerificaSiestaPagadod` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaSiestaPagadod` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaSiestaPagadod`(nidc integer) RETURNS int
begin
declare vdvto integer default 0;
select ncontrol into vdvto from fe_deu where ncontrol=nidc and acta>0 and acti='A' group by ncontrol;
if vdvto>0 then
   return 0;
  else
   return 1;
end if;
end */$$
DELIMITER ;

/* Function  structure for function  `FunVerificaSiPagoestaenRetenciones` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaSiPagoestaenRetenciones` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaSiPagoestaenRetenciones`(nid integer) RETURNS int
begin
declare xid integer default 0;
set xid:=(select ifnull(dret_idrd,0) from fe_dret where dret_idrd=nid group by dret_idrd);
if xid=0 or isnull(xid) then
   return 0;
 else
   return 1;
end if;
end */$$
DELIMITER ;

/* Function  structure for function  `IngresaCuentas` */

/*!50003 DROP FUNCTION IF EXISTS `IngresaCuentas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `IngresaCuentas`(nv1 float,
nv2 float,nv3 float,nv4 float,nv5 float,nv6 float,nv7 float,
nid1 integer,nid2 integer,nid3 integer,nid4 integer,nid5 integer,nid6 integer,nid7 integer,
ct1 char,ct2 char,ct3 char,ct4 char,ct5 char,ct6 char, ct7 char) RETURNS int
BEGIN
declare nid integer;
set nid=0;
select last_insert_id() into nid from fe_rcon group by last_insert_id();
insert into fe_ectasc(idrcon,impo,idcta,nitem,ecta_tipo)
values(nid,nv1,nid1,1,ct1);
insert into fe_ectasc(idrcon,impo,idcta,nitem,ecta_tipo)
values(nid,nv2,nid2,2,ct2);
insert into fe_ectasc(idrcon,impo,idcta,nitem,ecta_tipo)
values(nid,nv3,nid3,3,ct3);
insert into fe_ectasc(idrcon,impo,idcta,nitem,ecta_tipo)
values(nid,nv4,nid4,4,ct4);
insert into fe_ectasc(idrcon,impo,idcta,nitem,ecta_tipo)
values(nid,nv5,nid5,5,ct5);
insert into fe_ectasc(idrcon,impo,idcta,nitem,ecta_tipo)
values(nid,nv6,nid6,6,ct6);
insert into fe_ectasc(idrcon,impo,idcta,nitem,ecta_tipo)
values(nid,nv7,nid7,7,ct7);
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `IngresaCuentasv` */

/*!50003 DROP FUNCTION IF EXISTS `IngresaCuentasv` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `IngresaCuentasv`(nv1 float,
nv2 float,nv3 float,nid1 integer,nid2 integer,nid3 integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
select last_insert_id() into nid from fe_rven group by last_insert_id();
insert into fe_ectas(idrven,impo,idcta,nitem,tipo)
values(nid,nv1,nid1,1,'H');
insert into fe_ectas(idrven,impo,idcta,nitem,tipo)
values(nid,nv2,nid2,2,'H');
insert into fe_ectas(idrven,impo,idcta,nitem,tipo)
values(nid,nv3,nid3,3,'D');
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `ProVerificaBloqueo` */

/*!50003 DROP FUNCTION IF EXISTS `ProVerificaBloqueo` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `ProVerificaBloqueo`(dfecha date) RETURNS int
begin
declare vdvto integer default 0;
select idauto into vdvto from fe_rcom where
month(fecr)=month(dfecha) and year(fecr)=year(dfecha) and acti='A' and rcom_bloq='C' group by rcom_bloq;
if vdvto>0 then
   return 0;
  else
   return 1;
end if;
end */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaDatosLibroDiarioCP` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDatosLibroDiarioCP` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDatosLibroDiarioCP`(dfech DATETIME,ndebe DECIMAL(12,2),
nhaber DECIMAL(12,2),cglosa VARCHAR(180),ct CHAR(1),cnume VARCHAR(10),nidcta INTEGER,ccond CHAR,nit INTEGER,
ncomp VARCHAR(15),nidcl INTEGER,
nidpr INTEGER,cmone CHAR,ctran CHAR,nimtd DECIMAL (12,2),nimth DECIMAL(12,2),nidb INTEGER,ncodt integer) RETURNS int
BEGIN
DECLARE iddiario INTEGER DEFAULT 0;
INSERT INTO fe_ldiario(ldia_fech,ldia_debe,ldia_haber,ldia_glosa,ldia_tipo,
ldia_nume,ldia_idcta,ldia_cond,ldia_item,ldia_comp,ldia_idcv,ldia_idcc,ldia_mone,ldia_tran,ldia_itrd,ldia_itrh,ldia_idca,ldia_codt)
VALUES(dfech,ndebe,nhaber,cglosa,ct,cnume,nidcta,ccond,nit,ncomp,nidcl,nidpr,cmone,ctran,nimtd,nimth,nidb,ncodt);
SELECT LAST_INSERT_ID() INTO iddiario FROM fe_ldiario GROUP BY LAST_INSERT_ID();
RETURN iddiario;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaPagosCreditosCe` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosCreditosCe` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosCreditosCe`(
cndoc VARCHAR(12),nacta FLOAT,cesta CHAR,cmone CHAR,cb1 VARCHAR(100),dfech DATE,
dfevto DATE,ctipo CHAR,nctrl INTEGER,cnrou VARCHAR(40),nidrc FLOAT,cpc VARCHAR(45),
idusua INTEGER,idce INTEGER) RETURNS int
BEGIN
DECLARE nid INTEGER;
SET nid=0;
INSERT INTO fe_cred(fech,fevto,acta,ndoc,estd,mone,banc,tipo,cred_idrc,cred_idus,cred_fope,ncontrol,nrou,cred_idpc,cred_idce)
VALUES(dfech,dfevto,nacta,cndoc,cesta,cmone,cb1,ctipo,nidrc,idusua,CURRENT_DATE(),nctrl,cnrou,cpc,idce);
SELECT LAST_INSERT_ID() INTO nid FROM fe_cred GROUP BY LAST_INSERT_ID();
RETURN nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaPagosDeudasCE` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosDeudasCE` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosDeudasCE`(dfech DATETIME,
dfevto DATETIME,nacta FLOAT,cndoc VARCHAR(10),cesta CHAR,cmone CHAR,cb1 VARCHAR(100),ctipo CHAR,
nidrc INTEGER,idusua INTEGER,nctrl INTEGER,cnrou VARCHAR(25),cpc VARCHAR(45),ndolar FLOAT,idce INTEGER) RETURNS int
BEGIN
DECLARE nid INTEGER;
SET nid=0;
INSERT INTO fe_deu(fech,fevto,acta,ndoc,estd,banc,tipo,deud_idrd,deud_idus,deud_fope,ncontrol,nrou,deud_idpc,dola,deud_idce)
VALUES(dfech,dfevto,nacta,cndoc,cesta,cb1,ctipo,nidrc,idusua,LOCALTIME,nctrl,cnrou,cpc,ndolar,idce);
SELECT LAST_INSERT_ID() INTO nid FROM fe_deu GROUP BY LAST_INSERT_ID();
RETURN nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaDatosLcajaE` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDatosLcajaE` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDatosLcajaE`(dfecha DATE,cndoc VARCHAR(10),cdeta VARCHAR(100),idcta INTEGER,sdeudor DECIMAL(12,2),
sacreedor DECIMAL(12,2),cmone CHAR,ndolar DECIMAL(5,3),nidus INTEGER,nidcp INTEGER,nidalma integer) RETURNS int
BEGIN
DECLARE id INTEGER;
INSERT INTO fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,lcaj_idus,lcaj_clpr,lcaj_codt)VALUES
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,nidalma);
SELECT LAST_INSERT_ID() INTO id FROM fe_lcaja GROUP BY LAST_INSERT_ID();
RETURN id;
END */$$
DELIMITER ;

/* Procedure structure for procedure `AbrirCaja` */

/*!50003 DROP PROCEDURE IF EXISTS  `AbrirCaja` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `AbrirCaja`(in dfecha date)
BEGIN
update fe_caja set estado=' ' where fech=dfecha;
END */$$
DELIMITER ;

/* Procedure structure for procedure `AbrirCajaTda` */

/*!50003 DROP PROCEDURE IF EXISTS  `AbrirCajaTda` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `AbrirCajaTda`(dfecha date,nidalma integer)
BEGIN
update fe_caja set estado='A' where fech=dfecha and acti='A' and codt=nidalma;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ActualizaCuentasc` */

/*!50003 DROP PROCEDURE IF EXISTS  `ActualizaCuentasc` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ActualizaCuentasc`(in nv1 float,
in nv2 float,in nv3 float,in nv4 float,in nv5 float,in nv6 float,
in nv7 float,in nv8 decimal(12,2),in nid1 integer,in nid2 integer,nid3 integer,
in nid4 integer,in nid5 integer,nid6 integer,in nid7 integer,in nid8 integer,
in idv1 integer,in idv2 integer, in idv3 integer,
in idv4 integer,in idv5 integer, in idv6 integer,in idv7 integer,in idv8 integer,
in ct1 char,in ct2 char,in ct3 char,in ct4 char,in ct5 char,in ct6 char, in ct7 char,ct8 char)
BEGIN
update fe_ectasc set impo=nv1,idcta=nid1,ecta_tipo=ct1 where idectas=idv1;
update fe_ectasc set impo=nv2,idcta=nid2,ecta_tipo=ct2 where idectas=idv2;
update fe_ectasc set impo=nv3,idcta=nid3,ecta_tipo=ct3 where idectas=idv3;
update fe_ectasc set impo=nv4,idcta=nid4,ecta_tipo=ct4 where idectas=idv4;
update fe_ectasc set impo=nv5,idcta=nid5,ecta_tipo=ct5 where idectas=idv5;
update fe_ectasc set impo=nv6,idcta=nid6,ecta_tipo=ct6 where idectas=idv6;
update fe_ectasc set impo=nv7,idcta=nid7,ecta_tipo=ct7 where idectas=idv7;
update fe_ectasc set impo=nv8,idcta=nid8,ecta_tipo=ct8 where idectas=idv8;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ActualizaCuentasv` */

/*!50003 DROP PROCEDURE IF EXISTS  `ActualizaCuentasv` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ActualizaCuentasv`(nv1 DECIMAL(12,2),
nv2 DECIMAL(12,2),nv3 DECIMAL(12,2),nid1 INTEGER,nid2 INTEGER,nid3 INTEGER,idv1 INTEGER,
idv2 INTEGER,idv3 INTEGER,ct1 CHAR,ct2 CHAR,ct3 CHAR,nv4 DECIMAL(12,2),nid4 INTEGER,idv4 INTEGER,ct4 CHAR,
nv5 DECIMAL(12,2),nid5 INTEGER,idv5 INTEGER,ct5 CHAR)
BEGIN
UPDATE fe_ectas SET impo=nv1,idcta=nid1,tipo=ct1 WHERE idectas=idv1;
UPDATE fe_ectas SET impo=nv2,idcta=nid2,tipo=ct2 WHERE idectas=idv2;
UPDATE fe_ectas SET impo=nv3,idcta=nid3,tipo=ct3 WHERE idectas=idv3;
UPDATE fe_ectas SET impo=nv4,idcta=nid4,tipo=ct4 WHERE idectas=idv4;
UPDATE fe_ectas SET impo=nv5,idcta=nid5,tipo=ct5 WHERE idectas=idv5;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ActualizaTipoCambio` */

/*!50003 DROP PROCEDURE IF EXISTS  `ActualizaTipoCambio` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ActualizaTipoCambio`(in nmes integer,in na integer,in ctipo varchar(1))
BEGIN
DECLARE done INT DEFAULT 0;
declare tcom float default 0;
declare tven float default 0;
declare dfecha date;
declare cursor1 cursor for
select a.fech,a.valor,a.venta from fe_mon as a where month(fech)=nmes and year(fech)=na;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
open cursor1;
start transaction;
call actualizatipocambio1(nmes,na);
repeat
    fetch cursor1 into dfecha,tcom,tven;
    if ctipo='V' then
       update fe_rven set dolar=tven where fech=dfecha;
     else
       update fe_rcon set dolar=tcom where fecr=dfecha;
       update fe_rcom set dolar=tcom where fecr=dfecha;
    end if;
until done end repeat;
commit;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ActualizaTipoCambio1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ActualizaTipoCambio1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ActualizaTipoCambio1`(in nm integer,in na integer)
BEGIN
DECLARE done INT DEFAULT 0;
declare nv,ni,nt,nd float default 0;
declare nidectas,nit integer default 0;
declare cursor1 cursor for
select a.valor,a.igv,a.impo,b.dolar,c.idectas,c.nitem from
fe_rcom as a inner join fe_rven as b on(b.idauto=a.idauto) inner join fe_ectas  as c
on (c.idrven=b.idrven) where month(b.fech)=nm and year(b.fech)=na and b.mone='D' and b.acti<>'I';
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
open cursor1;
start transaction;
repeat
    fetch cursor1 into nv,ni,nt,nd,nidectas,nit;
    if nit=1 then
      update fe_ectas set impo=round(nv*nd,2) where idectas=nidectas and nitem=nit;
    end if;
    if nit=2 then
      update fe_ectas set impo=round(ni*nd,2) where idectas=nidectas and nitem=nit;
    end if;
    if nit=3 then
      update fe_ectas set impo=round(nt*nd,2) where idectas=nidectas and nitem=nit;
    end if;
    until done end repeat;
commit;
END */$$
DELIMITER ;

/* Procedure structure for procedure `Anula_rcompras` */

/*!50003 DROP PROCEDURE IF EXISTS  `Anula_rcompras` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `Anula_rcompras`(in nid integer)
BEGIN
update fe_rcon set rcon_Acti='I'  where idrcon=nid;
update fe_rdeu set rdeu_acti='I' where rdeu_idau=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `anula_rvtas` */

/*!50003 DROP PROCEDURE IF EXISTS  `anula_rvtas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `anula_rvtas`(in nauto integer)
begin
start transaction;
update fe_rven  set acti="I" where idrven=nauto;
update fe_ectas  set acti="I" where idrven=nauto;
update fe_refe  set acti="I" where idrven=nauto;
commit;
END */$$
DELIMITER ;

/* Procedure structure for procedure `astock` */

/*!50003 DROP PROCEDURE IF EXISTS  `astock` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `astock`(in coda integer,in nalma integer(3),in ccant float,in ctipo varchar(1))
BEGIN
if ctipo='C' then
    if nalma=1 then
          UPDATE fe_art SET uno=uno+ccant WHERE idart=coda;
    end if;
    if nalma=2 then
     UPDATE fe_art SET dos=dos+ccant WHERE idart=coda;
  end if;
  if nalma=3 then
          UPDATE fe_art SET tre=tre+ccant WHERE idart=coda;
  end if;
     if nalma=4 then
          UPDATE fe_art SET cua=cua+ccant WHERE idart=coda;
end if;
   if  nalma=8 then
          UPDATE fe_art SET sei=sei+ccant WHERE idart=coda;
end if;
    if nalma=9 then
          UPDATE fe_art SET cin=cin+ccant WHERE idart=coda;
  end if;
end if;
 if ctipo='V' then
    if nalma=1 then
          UPDATE fe_art SET uno=uno-ccant WHERE idart=coda;
end if;
     if nalma=2 then
          UPDATE fe_art SET dos=dos-ccant WHERE idart=coda;
       end if;
     if nalma=3 then
       UPDATE fe_art SET tre=tre-ccant WHERE idart=coda;
     end if;
   if nalma=4 then
          UPDATE fe_art SET cua=cua-ccant WHERE idart=coda;
end if;
   if nalma=8 then
          UPDATE fe_art SET sei=sei-ccant WHERE idart=coda;
end if;
    if  nalma=9 then
          UPDATE fe_art SET cin=cin-ccant WHERE idart=coda;
  end if;
end if;
 if   ctipo="I" then
      if  nalma=1 then
          UPDATE fe_art SET uno=ccant WHERE idart=coda;
end if;
     if   nalma=2 then
          UPDATE fe_art SET dos=ccant WHERE idart=coda;
end if;
     if nalma=3 then
          UPDATE fe_art SET tre=ccant WHERE idart=coda;
end if;
   if nalma=4 then
          UPDATE fe_art SET cua=ccant WHERE idart=coda;
end if;
   if nalma=8 then
          UPDATE fe_art SET sei=ccant WHERE idart=coda;
end if;
    if  nalma=9 then
          UPDATE fe_art SET cin=ccant WHERE idart=coda;
    end if;
 end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `CalcularStock` */

/*!50003 DROP PROCEDURE IF EXISTS  `CalcularStock` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `CalcularStock`()
BEGIN
DECLARE done INT DEFAULT 0;
declare ct varchar(1) default 'I';
declare saldo float;
declare ccoda integer;
declare calma integer;
declare tcompras float;
declare tventas float;
declare cursor1 cursor for
select a.idart,a.tcompras,a.tventas,a.alma
from (select b.idart,sum(if(b.tipo='C',b.cant,0)) as tcompras,
sum(if(b.tipo='V',b.cant,0)) as tventas,b.alma from fe_kar as b where b.acti<>'I' group by  idart,alma) as a;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
open cursor1;
start transaction;
UPDATE fe_art SET uno=0,dos=0,tre=0,cua=0,cin=0,sei=0;
repeat
    fetch cursor1 into ccoda,tcompras,tventas,calma;
    call astock(ccoda,calma,tcompras-tventas,ct);
until done end repeat;
commit;
END */$$
DELIMITER ;

/* Procedure structure for procedure `CierraCaja` */

/*!50003 DROP PROCEDURE IF EXISTS  `CierraCaja` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `CierraCaja`(in dfecha date)
BEGIN
update fe_caja set estado='C' where fech=dfecha;
END */$$
DELIMITER ;

/* Procedure structure for procedure `CierraCajaTda` */

/*!50003 DROP PROCEDURE IF EXISTS  `CierraCajaTda` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `CierraCajaTda`(dfecha date,nidalma integer)
BEGIN
update fe_caja set estado='C' where fech=dfecha and acti='A' and codt=nidalma;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ingresacaja` */

/*!50003 DROP PROCEDURE IF EXISTS  `ingresacaja` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ingresacaja`(in nauto integer,in cdcto varchar(10),in dfecha date,
in nimpo float,in nimpo1 float,in cdeta varchar(120),in cusua varchar(45),in cmon varchar(1),
in idcreditos integer,in cf varchar(1),in nimporte1 float,in cmon1 varchar(1),in ndola1 float)
BEGIN
declare nidcon integer;
if cf="E" then
    select idcon from fe_con where tdoc="PCE" into nidcon;
  else
    select idcon from fe_con where tdoc="XTC" into nidcon;
end if;
if nimpo>0 then
    INSERT INTO fe_caja(forma,tipo,idauto,ndoc,fech,impo,deta,usua,tmon,idcred,idcon,origen,fechao,mone,dola,nimpo)
    values(cf,"I",nauto,cdcto,dfecha,nimpo,cdeta,cusua,cmon,idcreditos,nidcon,"CA",now(),cmon1,ndola1,nimporte1);
end if;
if nimpo1>0 then
     INSERT INTO fe_caja(forma,tipo,idauto,ndoc,fech,impo,deta,usua,tmon,idcred,idcon,origen,fechao,mone,dola,nimpo)
     values(cf,"I",nauto,cdcto,dfecha,nimpo1,cdeta,cusua,cmon,idcreditos,nidcon,"CA",now(),cmon1,ndola1,nimporte1);
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `IngresaCuentas` */

/*!50003 DROP PROCEDURE IF EXISTS  `IngresaCuentas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `IngresaCuentas`(nv1 float,
nv2 float,nv3 float,nv4 float,nv5 float,nv6 float,nv7 float,nv8 float,
nid1 integer,nid2 integer,nid3 integer,nid4 integer,nid5 integer,nid6 integer,nid7 integer,nid8 integer,
ct1 char,ct2 char,ct3 char,ct4 char,ct5 char,ct6 char, ct7 char,ct8 char(1),nid integer)
BEGIN
insert into fe_ectasc(idrcon,impo,idcta,nitem,ecta_tipo)
values(nid,nv1,nid1,1,ct1);
insert into fe_ectasc(idrcon,impo,idcta,nitem,ecta_tipo)
values(nid,nv2,nid2,2,ct2);
insert into fe_ectasc(idrcon,impo,idcta,nitem,ecta_tipo)
values(nid,nv3,nid3,3,ct3);
insert into fe_ectasc(idrcon,impo,idcta,nitem,ecta_tipo)
values(nid,nv4,nid4,4,ct4);
insert into fe_ectasc(idrcon,impo,idcta,nitem,ecta_tipo)
values(nid,nv5,nid5,5,ct5);
insert into fe_ectasc(idrcon,impo,idcta,nitem,ecta_tipo)
values(nid,nv6,nid6,6,ct6);
insert into fe_ectasc(idrcon,impo,idcta,nitem,ecta_tipo)
values(nid,nv7,nid7,7,ct7);
insert into fe_ectasc(idrcon,impo,idcta,nitem,ecta_tipo)
values(nid,nv8,nid8,8,ct8);
END */$$
DELIMITER ;

/* Procedure structure for procedure `ingresa_anulada` */

/*!50003 DROP PROCEDURE IF EXISTS  `ingresa_anulada` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ingresa_anulada`(in dfecha Datetime,in cndoc varchar(10),in ctdoc varchar(2),in cu varchar(40),in nidcon integer)
begin
 select @nc:=idclie from fe_clie where nruc='***********';
 insert into fe_rcom(idcliente,fech,fecr,ndoc,tdoc,tipom,ncta,deta,ndo2,tcom,form,mone,exon,fusua,usua)
 values(@nc,dfecha,dfecha,cndoc,ctdoc,'V','','','','K','','S','N',now(),cu);
 SELECT @na:=LAST_INSERT_ID() FROM fe_rcom;
 INSERT INTO fe_caja(idauto,fech,impo,tipo,forma,tmon,ndoc,idcon,usua,fechao,deta,origen)
 VALUES (@na,dfecha,0,"I","E","S",cndoc,nidcon,cu,now(),"*** ANULADA ***","CK");
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaBancos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaBancos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaBancos`(nid integer,cnombre varchar(100),opt integer,nidco varchar(2))
BEGIN
if opt=1 then
   update fe_bancos set banc_nomb=cnombre,banc_idco=nidco where banc_idba=nid;
  else
   update fe_bancos set banc_acti='I' where banc_idba=nid;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCajaBancos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCajaBancos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCajaBancos`(idb integer,dfecha date,nope varchar(20),idmp integer,
cdeta varchar(120),idpr integer,idcl integer,cndoc varchar(20),idcta integer,debe float,haber float,norden integer,id integer,opt integer)
BEGIN
if opt=0 then
   update fe_cbancos set cban_acti='I' where cban_idco=id;
  else
   update fe_cbancos set cban_nume=nope,cban_idba=idb,cban_fech=dfecha,cban_idmp=idmp,
   cban_deta=cdeta,cban_idpr=idpr,cban_idcl=idcl,cban_ndoc=cndoc,cban_idct=idcta,
   cban_debe=debe,cban_haber=haber,cban_orde=norden  where cban_idco=id;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizacanjesD` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizacanjesD` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizacanjesD`(anidc integer,anidcc integer,opt integer)
begin
if opt=1 then
   update fe_dcanjes set canj_idca=anidc where canj_idca=anidcc;
  else
   update fe_dcanjes set canj_acti='I' where canj_idca=anidcc;
   update fe_rdeu set rdeu_acti='I' where rdeu_idrd=anidcc;
end if;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaClienteCD` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaClienteCD` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaClienteCD`(nid integer,cruc varchar(11),crazo varchar(100),
cdire varchar(100),cciud varchar(100),cfono varchar(15),cfax varchar(15),cdni varchar (11),
ctipo char,cemail varchar(45),nidven integer,nidus integer,ccelu varchar(15),crefe varchar(255),linea float,
crpm varchar(10),nidz integer,nidpto integer,cdist varchar(100),cdire1 varchar (100),cciud1 varchar(100))
BEGIN
update fe_clie set
nruc=cruc,razo=crazo,dire=cdire,ciud=cciud,fono=cfono,fax=cfax,ndni=cdni,clie_tipo=ctipo,clie_corr=cemail,
clie_codv=nidven,clie_actu=nidus,clie_feac=localtime,celu=ccelu,refe=crefe,
clie_lcre=linea,clie_rpm=crpm,clie_idzo=nidz,
clie_idpt=nidpto,clie_dist=cdist,clie_dir1=cdire1,clie_ciu1=cciud1 where idclie=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCotizacion` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCotizacion` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCotizacion`(dfech datetime,nidclie integer,
cndoc varchar(10),ctdoc varchar(2),nimpo float,cform char,cusua integer,nidven integer,nidtienda integer,ctp char,
caten varchar(80),cforma varchar(80),cplazo varchar(80),cvalidez varchar(80),centrega varchar(80),cdetalle varchar(150),cmone char,nidauto integer)
BEGIN
UPDATE fe_rped SET fech=dfech,idclie=nidclie,ndoc=cndoc,impo=nimpo,form=cform,idven=nidven,facturado='N',tdoc=ctdoc,
tipopedido='P',aten=caten,forma=cforma,plazo=cplazo,validez=cvalidez,entrega=centrega,detalle=cdetalle WHERE idautop=nidauto;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCtasBancos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCtasBancos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCtasBancos`(cta VARCHAR(100),idb INTEGER,cmone CHAR,cdeta VARCHAR(100),nidcta INTEGER,opt INTEGER,nidctap INTEGER,nidalma integer)
BEGIN
IF opt=1 THEN
   UPDATE fe_ctasb SET ctas_acti='I' WHERE ctas_idct=nidcta;
  ELSE
   UPDATE fe_ctasb SET ctas_ctas=cta,ctas_idba=idb,ctas_mone=cmone,ctas_deta=cdeta,ctas_ncta=nidctap,ctas_codt=nidalma WHERE ctas_idct=nidcta;
END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCtasCtesC` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCtasCtesC` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCtasCtesC`(nid integer,dfech date,nidlc integer,ct char,nimpo float,mone char,idcl integer,idrv integer)
BEGIN
declare id integer;
if ct='D' then
   update fe_ctasctesc set ctcc_idau=nid,ctcc_fech=dfech,ctcc_idlc=nidlc,ctcc_tipo=ct,ctcc_debe=nimpo,
   ctcc_mone=cmone,ctcc_idpr=idcl where ctcc_idct=idrv;
  else
   update fe_ctasctesc set ctcc_idau=nid,ctcc_fech=dfech,ctcc_idlc=nidlc,ctcc_tipo=ct,ctcc_haber=nimpo,
   ctcc_mone=cmone,ctcc_idpr=idcl where ctcc_idct=idrv;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCtasCtesV` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCtasCtesV` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCtasCtesV`(nid integer,dfech date,nidlc integer,ct char,nimpo float,cmone char,idcl integer,idrv integer)
BEGIN
declare id integer;
if ct='D' then
   update fe_ctasctesv set ctcv_idau=nid,ctcv_fech=dfech,ctcv_idlc=nidlc,ctcv_tipo=ct,ctcv_debe=nimpo,
   ctcv_mone=cmone,ctcv_idcl=idcl where ctcv_idct=idrv;
  else
   update fe_ctasctesv set ctcv_idau=nid,ctcv_fech=dfech,ctcv_idlc=nidlc,ctcv_tipo=ct,ctcv_haber=nimpo,
   ctcv_mone=cmone,ctcv_idcl=idcl where ctcv_idct=idrv;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROACTUALIZADATOSDIARIO` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROACTUALIZADATOSDIARIO` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROACTUALIZADATOSDIARIO`(dfech datetime,ndebe decimal(12,2)
,nhaber decimal(12,2),cglosa varchar(200),ct char(1),cnume varchar(14),nidcta integer,idd integer,opt integer,ccond char,
nit integer,ncomp varchar(15),nidcl integer,nidpr integer,cmone char,ctran char,nidt integer)
BEGIN
if opt=0 then
   update fe_ldiario set ldia_acti='I' where ldia_idld=idd;
 else
   update fe_ldiario set ldia_fech=dfech,ldia_debe=ndebe,ldia_haber=nhaber,ldia_glosa=cglosa,ldia_tipo=ct,ldia_nume=cnume,
   ldia_idcta=nidcta,ldia_cond=ccond,ldia_item=nit,ldia_comp=ncomp,
   ldia_idcv=nidcl,ldia_idcc=nidpr,ldia_mone=cmone,ldia_tran=ctran,ldia_codt=nidt  where ldia_idld=idd;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaDatosLCaja` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaDatosLCaja` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaDatosLCaja`(idb integer,dfecha date,nop varchar(20),idmp integer,
cdeta varchar(120),idpr integer,idcl integer,cndoc varchar(20),idcta integer,debe float,haber float,norden integer,nidl integer,op integer)
BEGIN
if op=0 then
   update fe_cbancos set cban_acti=0 where cban_idco=nidl;
  else
   update fe_cbancos set cban_idba=idb,cban_nume=nop,cban_fech=dfecha,cban_idmp=idmp,
   cban_deta=cdeta,cban_idpr=idpr,cban_idcl=idcl,cban_ndoc=cndoc,cban_idct=idcta,cban_debe=debe,
   cban_haber=haber,cban_orde=norden where cban_idco=nidl;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaDatosLcajaE1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaDatosLcajaE1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaDatosLcajaE1`(nid integer)
begin
update fe_lcaja set lcaj_acti='I' where lcaj_idau=nid;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaDcotizacion` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaDcotizacion` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaDcotizacion`(ncoda integer,ncant float,nprec float,nr integer,opt integer)
BEGIN
if opt=0 then
   UPDATE fe_ped SET acti='I' WHERE idped=nr;
  else
   UPDATE fe_ped SET idart=ncoda,cant=ncant,prec=nprec WHERE idped=nr;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaDetallePedidos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaDetallePedidos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaDetallePedidos`(ncoda integer,ncant float,nprec float,nr integer,ctipoa char)
BEGIN
if ctipoa='A' then
     UPDATE fe_ped SET acti='A' WHERE idped=nr;
   else
    UPDATE fe_ped SET idart=ncoda,cant=ncant,prec=nprec WHERE idped=nr;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaDeudas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaDeudas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaDeudas`(nauto integer,nu integer)
BEGIN
update fe_rdeu set rdeu_acti='I',rdeu_idus1=nu where rdeu_idau=nauto;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaOtrasCompras` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaOtrasCompras` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaOtrasCompras`(nidprov integer,
ctdoc integer,cform char,cndoc varchar(12),dfecha date,dfechar date,cmon char,ndolar float,nigv1 float,cdetalle varchar(80),
nauto varchar(20),dfevto date,nidalma integer,ctipo char,cusua varchar(45),nidrc integer)
BEGIN
UPDATE fe_rcon SET idprov=nidprov,idtdoc=ctdoc,form=cform,ndoc=cndoc,
fech=dfecha,fecr=dfechar,mone=cmon,dolar=ndolar,vigv=nigv1,detalle=cdetalle,auto=nauto,fevto=dfevto,
idalma=nidalma,tipo=ctipo,usua=cusua,fusua=localtime where idrcon=nidrc;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaPlanCuentas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaPlanCuentas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaPlanCuentas`(cn varchar(8),cdes varchar(120),
cdd varchar(8),cdh varchar(8),cuenta varchar(12),cope char,nid integer)
BEGIN
UPDATE fe_plan SET ncta=cn,nomb=cdes,cdestinod=cdd,cdestinoh=cdh,tipocta=cuenta,
plan_oper=cope WHERE idcta=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaPreciosProducto` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaPreciosProducto` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaPreciosProducto`(
cc integer,dfe date,npr decimal(12,6),cnd varchar(12),idp integer,cmda char,ni decimal(6,4))
BEGIN
SELECT convert('00/00/0000',char) into @ufc FROM fe_art WHERE idart=cc;
IF @ufc<=dfe then
   UPDATE fe_art SET cost=npr,uldc=cnd,ulpc=idp,tmon=cmda,ulfc=dfe WHERE idart=cc;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaProveedor` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaProveedor` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaProveedor`(nid integer,cruc varchar(11),crazo varchar(100),
cdire varchar(100),cciud varchar(100),cfono varchar(15),cfax varchar(15),
cemail varchar(45),nidus integer,ccelu varchar(15),crefe varchar(200),crpm varchar(10))
BEGIN
update fe_prov set
nruc=cruc,razo=crazo,dire=cdire,ciud=cciud,fono=cfono,fax=cfax,email=cemail,
prov_actu=nidus,prov_feac=localtime,celu=ccelu,refe=crefe,prov_rpm=crpm
where idprov=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROActualizaTipoCambio` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROActualizaTipoCambio` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROActualizaTipoCambio`(in nmes integer,in na integer,in ctipo varchar(1))
BEGIN
DECLARE done INT DEFAULT 0;
declare ndolar float default 0;
declare ndolao float default 0;
declare nidrven integer default 0;
declare dfecha date;
declare cursor1 cursor for
select a.dolar,a.idrven from fe_rven as a where month(fech)=nmes and year(fech)=na
and mone='D';
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
open cursor1;
start transaction;
repeat
    fetch cursor1 into ndolar,nidrven;
    update fe_rven set arreg="A" where idrven=nidrven;
    update fe_ectas set impo=impo/2.85599401 where idrven=nidrven;
    update fe_ectas set impo=impo*ndolar where idrven=nidrven;
until done end repeat;
commit;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaTransportista` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaTransportista` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaTransportista`(cplaca VARCHAR(10),crazo VARCHAR(50),
cdire VARCHAR(50),cruc VARCHAR(11),cchofer VARCHAR(50),cbreve varchar(25),cmarca varchar(50),ccons varchar(30),nid integer,cplaca1 varchar(11))
BEGIN
UPDATE fe_tra SET ructr=cruc,razon=crazo,nombr=cchofer,marca=cmarca,placa=cplaca,dirtr=cdire,
breve=cbreve,cons=ccons,placa1=cplaca1 where idtra=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActulizaSeriesDctos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActulizaSeriesDctos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActulizaSeriesDctos`(cserie INTEGER,cnume INTEGER,ctdoc VARCHAR(2),nitems INTEGER,ntda INTEGER,nidserie INTEGER)
BEGIN
UPDATE fe_serie SET tdoc=ctdoc,nume=cnume,items=nitems,codt=ntda,seri_idal=ntda WHERE idserie=nidserie;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaCheques` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaCheques` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaCheques`(nid integer,nidu0 integer,nidu1 integer)
BEGIN
update fe_cred set acti='I' where cre_idrc=nid;
update fe_rcheq set rche_acti='I' where rche_idrc=nid;
update fe_cheques set cheq_Acti='I',cheq_idu0=nidu0,cheq_idu1=nidu1 where cheq_idrc=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROANULAGUIASVTAS` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROANULAGUIASVTAS` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROANULAGUIASVTAS`(in nidauto integer)
BEGIN
update fe_rguias set rgui_acti='I' where rgui_idrg=nidauto;
update fe_dguias set dgui_acti='I' where dgui_idrg=nidauto;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaIngresoCtaCteC` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaIngresoCtaCteC` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaIngresoCtaCteC`(nid integer)
BEGIN
delete from fe_ctasctesc where ctcc_idct=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaIngresoCtaCteV` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaIngresoCtaCteV` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaIngresoCtaCteV`(nid integer)
BEGIN
delete from fe_ctasctesv where ctcv_idct=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROANULALCAJA` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROANULALCAJA` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROANULALCAJA`(idcaja integer)
begin
update fe_cbancos set cban_acti='I' where cban_idco=idcaja;
end */$$
DELIMITER ;

/* Procedure structure for procedure `PROANULASIENTODIARIO` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROANULASIENTODIARIO` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROANULASIENTODIARIO`(nid varchar(14))
BEGIN
update fe_ldiario set ldia_acti='I' where ldia_nume=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaTransacciones` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaTransacciones` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaTransacciones`(OUT estado varchar(500),in ctdoc varchar(2),in cndoc varchar(12),
in ctipo char,IN nidauto integer,in nu integer, in w char,dfecha date,uauto integer)
BEGIN
declare nid,nidconcepto integer;
declare cconcepto varchar(3);
declare cdeta varchar(80);
declare cusuario varchar(50);
DECLARE EXIT HANDLER FOR SQLEXCEPTION,SQLWARNING,NOT FOUND
begin
   rollback;
   set estado:="No se ejecuto Correctamente las Transacciones";
end;
start transaction;
set nid=0;
if nidauto=0 then
   set @ct:=ctdoc;
   set @cn1:=cndoc;
   set @df:=dfecha;
   select @idclave:=idauto from fe_rcom where tdoc=ctdoc and ndoc=cndoc and tipom =ctipo and acti='A'  group by ndoc,tdoc,tipom;
   set nid=ifnull(@idclave,0);
  else
   set nid=nidauto;
end if;
if nid>0 then
   update fe_rcom set acti='I',idusua1=uauto where idauto=nid;
   select @nidguias:=rgui_idrg  from fe_rguias  where rgui_idau=nid;
   call proanulaguiasvtas(@nidguias);
end if;
if w='S' and ctipo='V' then
   set nidconcepto=0;
   if nid>0 then
      select @ct:=tdoc,@cn1:=ndoc,@df:=fech from fe_rcom where idauto=nid;
   end if;
   if @ct='07' or @ct='08' then
       set cconcepto:=concat('01','E');
      else
      set cconcepto:=concat(trim(@ct),'E');
   end if;
   SELECT idcon into nidconcepto FROM fe_con WHERE tdoc=cconcepto and tipo='I' group by idcon;
   if w='S' then
      call PROingresa_anulada(@df,@cn1,@ct,nu,3);
   end if;
end if;
set estado=null;
select nomb into cusuario from fe_usua where idusua=nu;
set cdeta:="Se Anulo";
call proingresaAcaja(curdate(),cusuario,cdeta,0,'S');
call proingresaAkardex(cusuario,cdeta,0,0,0,nid,@cn1,@ct);
commit;
set estado:="Ok";
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAplicaTCBancos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAplicaTCBancos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAplicaTCBancos`(nid integer,ntc decimal(6,4))
begin
update fe_cbancos set cban_dola=ntc where cban_idco=nid;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProAplicaTCCaja` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAplicaTCCaja` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAplicaTCCaja`(nid integer,ntc decimal(6,4))
begin
update fe_lcaja set lcaj_dola=ntc where lcaj_idca=nid;
end */$$
DELIMITER ;

/* Procedure structure for procedure `PROAplicaTcCompras` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROAplicaTcCompras` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROAplicaTcCompras`(nidrc integer,nidauto integer,tc decimal(8,4))
begin
update fe_rcon set dolar=tc where idrcon=nidrc;
update fe_rcom set dolar=tc where idauto=nidauto;
end */$$
DELIMITER ;

/* Procedure structure for procedure `PROAplicaTcVentas` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROAplicaTcVentas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROAplicaTcVentas`(nidrv integer,nidauto integer,tc decimal(8,4))
begin
update fe_rven set dolar=tc where idrven=nidrv;
update fe_rcom set dolar=tc where idauto=nidauto;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProBloqueaBcos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProBloqueaBcos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProBloqueaBcos`(nmes integer,na integer,nid integer,opt integer)
begin
if opt=0 then
   update fe_cbancos set cban_bloq='C' where month(cban_fech)=nmes and year(cban_fech)=na and cban_idba=nid and cban_acti='A';
 else
   update fe_cbancos set cban_bloq='A' where month(cban_fech)=nmes and year(cban_fech)=na and cban_idba=nid and cban_acti='A';
end if;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProBloqueaCajaEfectivo` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProBloqueaCajaEfectivo` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProBloqueaCajaEfectivo`(nmes integer,na integer,opt integer)
begin
if opt=0 then
   update fe_lcaja set lcaj_bloq='C' where month(lcaj_fech)=nmes and year(lcaj_fech)=na and lcaj_acti='A';
 else
   update fe_lcaja set lcaj_bloq='A' where month(lcaj_fech)=nmes and year(lcaj_fech)=na and lcaj_acti='A';
end if;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProBloqueaD` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProBloqueaD` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProBloqueaD`(nmes integer,na integer,opt integer)
begin
if opt=0 then
   update fe_rcom set rcom_bloq='C' where month(fecr)=nmes and year(fecr)=na and acti='A';
 else
   update fe_rcom set rcom_bloq='A' where month(fecr)=nmes and year(fecr)=na and acti='A';
end if;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProBloqueaD1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProBloqueaD1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProBloqueaD1`(nmes integer,na integer,opt integer)
begin
if opt=0 then
   update fe_rcon set rcon_bloq='C' where month(fecr)=nmes and year(fecr)=na and rcon_acti='A';
 else
   update fe_rcon set rcon_bloq='A' where month(fecr)=nmes and year(fecr)=na and rcon_acti='A';
end if;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProBloqueaDCompras` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProBloqueaDCompras` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProBloqueaDCompras`(nmes integer,na integer,opt integer)
begin
if opt=0 then
   update fe_rcom set rcom_bloq='C' where month(fecr)=nmes and year(fecr)=na and acti='A' and idprov>0;
 else
   update fe_rcom set rcom_bloq='A' where month(fecr)=nmes and year(fecr)=na and acti='A' and idprov>0;
end if;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProBloqueaDVentas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProBloqueaDVentas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProBloqueaDVentas`(nmes integer,na integer,opt integer)
begin
if opt=0 then
   update fe_rcom set rcom_bloq='C' where month(fecr)=nmes and year(fecr)=na and acti='A' and idcliente>0;
 else
   update fe_rcom set rcom_bloq='A' where month(fecr)=nmes and year(fecr)=na and acti='A' and idcliente>0;
end if;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProBloqueoD` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProBloqueoD` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProBloqueoD`(nmes integer,na integer,opt integer)
begin
if opt=0 then
   update fe_rcom set rcom_bloq='C' where month(fecr)=nmes and year(fecr)=na and acti='A';
 else
   update fe_rcom set rcom_bloq='A' where month(fecr)=nmes and year(fecr)=na and acti='A';
end if;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProBloqueoPagosClientes` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProBloqueoPagosClientes` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProBloqueoPagosClientes`(dfecha date,opt integer)
begin
if opt=0 then
   update fe_cred set cred_bloq='C' where fech<=dfecha and acti='A' and cred_bloq='A';
 else
   update fe_cred set cred_bloq='A' where fech<=dfecha and acti='A' and cred_bloq='C';
end if;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProBuscaSeries` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProBuscaSeries` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProBuscaSeries`(nserie integer,ctdoc varchar(2))
BEGIN
SELECT nume,items,idserie FROM fe_serie WHERE serie=nserie AND tdoc=ctdoc;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProCalculaSaldosProveedor` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProCalculaSaldosProveedor` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProCalculaSaldosProveedor`(nidclie integer)
BEGIN
if nidclie>0 then
   SELECT IF(acta>0,-acta,impo) as impsoles,000000.00 as impdolares FROM fe_deu  as a
   inner join fe_rdeu as b on(b.rdeu_idrd=a.deud_idrd) WHERE b.rdeu_idpr=nidclie
   and a.acti<>'I' AND b.rdeu_mone="S" and b.rdeu_acti<>'I' UNION ALL SELECT 0000000.00 as impsoles,IF(acta>0,-acta,impo) as impdolares FROM fe_deu as a
   inner join fe_rdeu as b on(b.rdeu_idrd=a.deud_idrd) WHERE b.rdeu_idpr=nidclie AND b.rdeu_mone="D" and a.acti<>'I' and b.rdeu_acti<>'I';
 else
   SELECT IF(acta>0,-acta,impo) as impsoles,000000.00 as impdolares FROM fe_deu  as a
   inner join fe_rdeu as b on(b.rdeu_idrd=a.deud_idrd) WHERE a.acti<>'I' AND b.rdeu_mone="S" and b.rdeu_acti<>"I"
   UNION ALL SELECT 0000000.00 as impsoles,IF(acta>0,-acta,impo) as impdolares FROM fe_deu as a
   inner join fe_rdeu as b on(b.rdeu_idrd=a.deud_idrd) WHERE b.rdeu_mone="D" and a.acti<>"I" and b.rdeu_acti<>"I";
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProCambios` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProCambios` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProCambios`(out estado varchar(500),idclie0 integer,idclie1 integer,nu integer,ct varchar(50))
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION,SQLWARNING,NOT FOUND
begin
   rollback;
   set estado:="No se ejecuto Correctamente las Transacciones";
end;
start transaction;
if trim(ct)="Clientes" then
   update fe_cred set idclie=idclie1 where idclie=idclie0;
   update fe_rcom set idcliente=idclie1 where idcliente=idclie0;
   update fe_kar set idclie=idclie1 where idclie=idclie0;
   update fe_clie set clie_acti='I' where idclie=idclie0;
   update fe_rven set idclie=idclie1 where idclie=idclie0;
   insert into fe_cambios(camb_fech,camb_idan,camb_idac,camb_tipo,camb_idus)
   values(curdate(),idclie0,idclie1,"Clientes",nu);
end if;
if trim(ct)="Proveedores" then
   update fe_rdeu set rdeu_idpr=idclie1 where rdeu_idpr=idclie0;
   update fe_rcom set idprov=idclie1 where idprov=idclie0;
   update fe_kar set idprov=idclie1 where idprov=idclie0;
   update fe_prov set prov_acti='I' where idprov=idclie0;
   update fe_rcon set idprov=idclie1 where idprov=idclie0;
   update fe_rret set rete_idpr=idclie1 where rete_idpr=idclie0;
   insert into fe_cambios(camb_fech,camb_idan,camb_idac,camb_tipo,camb_idus)
   values(curdate(),idclie0,idclie1,"Proveedores",nu);
end if;
if trim(ct)="Productos" then
   update fe_kar set idart=idclie1 where idart=idclie0;
   update fe_art set prod_acti='I' where idart=idclie0;
   insert into fe_cambios(camb_fech,camb_idan,camb_idac,camb_tipo,camb_idus)
   values(curdate(),idclie0,idclie1,"Productos",nu);
end if;
commit;
set estado:="Ok";
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProCancelaCheques` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProCancelaCheques` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProCancelaCheques`(out estado varchar(100),in nid integer,in sw char, in cdeta varchar(80),
in cpc varchar(50),in nidu integer,dfecha date)
BEGIN
DECLARE done INT DEFAULT 0;
declare nidclie integer default 0;
declare nctrl,nidven,nauto,nidaval,nidtda,nidrch integer;
declare cndoc,cdocp varchar(10);
declare cmone,cfo char;
declare dfevto date;
declare nacta,nimpc,ndscto float;
DECLARE EXIT HANDLER FOR SQLEXCEPTION,SQLWARNING,NOT FOUND
begin
   rollback;
   set estado:="No se ejecuto Correctamente las Transacciones";
end;
start transaction;
if sw='C' then
   select idclie,ndoc,docd,impo,mone,fevto,impc,ncontrol,idven,
   idauto,idaval,form,dscto,codt,cre_idrc into nidclie,cndoc,cdocp,nacta,cmone,
   dfevto,nimpc,nctrl,nidven,nauto,nidaval,cfo,ndscto,nidtda,nidrch from fe_cred where cre_idch=nid and acti<>'I';
   select funingresapagoscreditos(nidclie,cndoc,cdocp,nacta,'P',cmone,"Cheque Cancelado",dfecha,dfevto,'C',2.85,'','C',nimpc,nctrl,nidven,nidu,'',nauto,nidaval,cfo,ndscto,cpc,nidtda,nidrch,nid) as x;
   update fe_cheques set cheq_cobr='S',cheq_deta=cdeta,cheq_fecc=dfecha where cheq_idch=nid;
end if;
if sw='E' then
   update fe_cheques set cheq_cobr='N',cheq_deta=cdeta,cheq_fecc=dfecha where cheq_idch=nid;
   update fe_cred set acti='I' where cre_idch=nid and estd='P';
end if;
if sw='D' then
    update fe_cheques set cheq_cobr='D',cheq_deta=cdeta,cheq_fecc=dfecha where cheq_idch=nid;
end if;
commit;
set estado=null;
set estado:="Ok";
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProDesactivaCaja` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaCaja` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaCaja`(in nid integer)
BEGIN
update fe_caja set acti='I' where idcaja=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProdesactivaCDeudas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProdesactivaCDeudas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProdesactivaCDeudas`(id integer)
BEGIN
update fe_rdeu set rdeu_acti='I' where rdeu_idrd=id;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProDesactivacheques` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivacheques` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivacheques`(nidcr integer)
BEGIN
update fe_cheques set cheq_acti='I' where cheq_idcr=nidcr;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProDesactivaCreditos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaCreditos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaCreditos`(in nid integer)
BEGIN
update fe_cred set acti='I' where idcred=nid;
update fe_cheques set cheq_Acti='I' where cheq_idcr=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProDesactivaDeudas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaDeudas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaDeudas`(in nid integer)
BEGIN
update fe_deu set acti='I' where iddeu=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProDesactivaRetenciones` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaRetenciones` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaRetenciones`(nidr integer)
begin
update fe_dret set dret_acti='I' where dret_idre=nidr;
update fe_rret set rete_acti='I' where rete_idre=nidr;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProdGuias` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProdGuias` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProdGuias`(nidguia integer,nidart integer,ncanp float,ncane float)
BEGIN
insert into fe_dguias(dgui_idrg,dgui_idart,dgui_canp,dgui_cane)
values(nidguia,nidart,ncanp,ncane);
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProeditaCliente` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProeditaCliente` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProeditaCliente`(
cdire varchar(60),cciud varchar(60),cfono varchar(15),cfax varchar(15),cdni varchar(10),
icl integer)
BEGIN
UPDATE fe_clie SET dire=cdire,ciud=cciud,fono=cfono,fax=cfax,ndni=cdni WHERE idclie=icl;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProEditaDireccion1Cliente` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProEditaDireccion1Cliente` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProEditaDireccion1Cliente`(cdire1 varchar (100),cciud1 varchar(100),nid integer)
begin
update fe_clie set clie_dir1=cdire1,clie_ciu1=cciud1 where idclie=nid;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProeditaProveedor` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProeditaProveedor` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProeditaProveedor`(cfono varchar(15),cfax varchar(15),
cdire varchar(60),cciud varchar(50),nid integer)
BEGIN
UPDATE fe_prov SET dire=cdire,ciud=cciud,fono=cfono,fax=cfax WHERE idprov=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProFacturaPedido` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProFacturaPedido` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProFacturaPedido`(nautop integer)
BEGIN
UPDATE fe_rped SET facturado="S" WHERE idautop=nautop;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProGeneraCorrelativo` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProGeneraCorrelativo` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProGeneraCorrelativo`(nn decimal(15),ns integer)
BEGIN
UPDATE fe_serie SET nume=nn WHERE idserie=ns;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaAcaja` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaAcaja` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaAcaja`(in df date,in cu varchar(50),
in cd varchar(80),in impo float,in cm char)
BEGIN
insert into fe_acaja(fech,usuario,detalle,hora,autorizo,importe,moneda)
values(df,cu,cd,localtime(),cu,impo,cm);
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProingresaAKardex` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProingresaAKardex` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProingresaAKardex`(in cu varchar(50),in cd varchar(80),
in nidart integer,in ncant float,in nprec float,in nid integer,in cndoc varchar(10),in ctdoc varchar(2))
BEGIN
insert into fe_akardex(usuario1,detalle,hora,usuario2,idart,cant,prec,idauto,ndoc,
tdoc,fech)values(cu,cd,localtime(),cu,nidart,ncant,nprec,nid,cndoc,ctdoc,curdate());
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROingresacaja` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROingresacaja` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROingresacaja`(in nauto integer,in cdcto varchar(10),in dfecha date,
in nimpo float,in nimpo1 float,in cdeta varchar(120),in cusua varchar(45),in cmon varchar(1),
in idcreditos integer,in cf varchar(1),in nimporte1 float,in cmon1 varchar(1),in ndola1 float,nidcodt integer,nidu integer)
BEGIN
declare nidcon integer;
if cf="E" then
    select idcon from fe_con where tdoc="PCE" into nidcon;
  else
    select idcon from fe_con where tdoc="XTC" into nidcon;
end if;
if nimpo>0 then
    INSERT INTO fe_caja(forma,tipo,idauto,ndoc,fech,impo,deta,usua,tmon,idcred,idcon,origen,fechao,mone,dola,nimpo,codt,idusua)
    values(cf,"I",nauto,cdcto,dfecha,nimpo,cdeta,cusua,cmon,idcreditos,nidcon,"CA",now(),cmon1,ndola1,nimporte1,nidcodt,nidu);
end if;
if nimpo1>0 then
     INSERT INTO fe_caja(forma,tipo,idauto,ndoc,fech,impo,deta,usua,tmon,idcred,idcon,origen,fechao,mone,dola,nimpo,codt,idusua)
     values(cf,"I",nauto,cdcto,dfecha,nimpo1,cdeta,cusua,cmon,idcreditos,nidcon,"CA",now(),cmon1,ndola1,nimporte1,nidcodt,nidu);
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaCanjesD` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaCanjesD` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaCanjesD`(nidc integer,niddc integer,nidcc1 integer,nidrc integer)
begin
if nidc=0 then
   insert into fe_dcanjes(canj_idca,canj_idan,canj_idac,canj_idrc)values(nidc,niddc,nidcc1,nidrc);
  else
   insert into fe_dcanjes(canj_idca,canj_idac)values(nidc,niddc);
end if;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaCanjesDRetencion` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaCanjesDRetencion` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaCanjesDRetencion`(nidc integer,niddc integer,nidcc1 integer,nidrc integer,crete integer)
begin
if nidc=0 then
   insert into fe_dcanjes(canj_idca,canj_idan,canj_idac,canj_idrc,canj_rete)values(nidc,niddc,nidcc1,nidrc,crete);
end if;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaCheques` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaCheques` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaCheques`(cbanco varchar(45),cnumero varchar(45),dfechag date,
dfechac date,cmone char,nimpo float,nidch integer)
BEGIN
insert into fe_cheques(cheq_banc,cheq_nume,cheq_fecg,cheq_fecc,cheq_mone,cheq_impo,cheq_idrc,cheq_fech)
values(cbanco,cnumero,dfechag,dfechac,cmone,nimpo,nidch,localtime());
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaCuentasv` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaCuentasv` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaCuentasv`(nv1 DECIMAL(12,2),
nv2 DECIMAL(12,2),nv3 DECIMAL(12,2),nid1 INTEGER,nid2 INTEGER,nid3 INTEGER,
nid INTEGER,tper DECIMAL(12,2),ctaper INTEGER,nv5 DECIMAL(12,2),nid5 INTEGER)
BEGIN
INSERT INTO fe_ectas(idrven,impo,idcta,nitem,tipo)
VALUES(nid,nv1,nid1,1,"H");
INSERT INTO fe_ectas(idrven,impo,idcta,nitem,tipo)
VALUES(nid,nv2,nid2,2,"H");
INSERT INTO fe_ectas(idrven,impo,idcta,nitem,tipo,ecta_total)
VALUES(nid,nv3,nid3,3,"D",tper);
INSERT INTO fe_ectas(idrven,impo,idcta,nitem,tipo)
VALUES(nid,tper,ctaper,4,"H");
INSERT INTO fe_ectas(idrven,impo,idcta,nitem,tipo)
VALUES(nid,nv5,nid5,5,"H");
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDetalleCompra` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDetalleCompra` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDetalleCompra`(nidkar integer,cfracm varchar(60),
cfracn varchar(60),nequi1 float,nequi2 float,nd1 float,nd2 float,nd3 float,nprec float)
BEGIN
insert into fe_detallec(detc_idkar,detc_fracm,detc_fracn,detc_equi1,detc_equi2,detc_dcto1,
detc_dcto2,detc_dcto3,detc_prec)values(nidkar,cfracm,cfracn,nequi1,nequi2,nd1,nd2,nd3,nprec);
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaRCompras` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaRCompras` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaRCompras`(
nidprov integer,ntdoc integer,cform char,cndoc varchar(12),dfecha date,dfecha1 date,cm char,ndolar decimal(8,4),
ni decimal(5,3),cdetalle varchar(80),dfevto date,nidalma integer,ctipo char,nus integer,nv decimal(12,2),
nigv decimal(12,2),nt decimal(12,2),n1 integer,n5 integer,n8 integer,nrc integer)
BEGIN
declare nid1,nmes,idce integer;
declare cauto varchar(12);
declare btdoc varchar(2) default '';
set nmes=MONTH(dfecha);
select gene_idce into idce from fe_gene where idgene=1;
select tdoc into btdoc from fe_tdoc where idtdoc=ntdoc;
SELECT dcorrelativo(nmes,'C') into cauto;
select FunIngresaOtrasCompras(nidprov,ntdoc,cform,cndoc,dfecha,dfecha1,cm,ndolar,ni,cdetalle,cauto,dfevto,nidalma,ctipo,nus,nrc) into nid1;
call IngresaCuentas(nv,0,0,0,nigv,0,0,nt,n1,0,0,0,n5,0,0,n8,"D","D","D","D","D","D","D","H",nid1);
if idce>0 and cform='E' and (btdoc<>'07' or btdoc<>'08') then
      Call ProIngresaDatosLcajaE1(dfecha,"",concat("Compra al Contado No Dcto ",cndoc),idce,0,nt,cm,ndolar,nus,nidprov,nid1);
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaRVentas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaRVentas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaRVentas`(
nidclie integer,ntdoc integer,cform char,cndoc varchar(10),
dfecha date,dfecha1 date,dfevto date,cm char,ndolar float,ni float,nid integer,nus integer,
nt1 float,nt2 float,nt3 float,nidcta1 integer,nidcta2 integer,nidcta3 integer,tper decimal(12,2))
BEGIN
declare nid1,nmes,nidctaper,idve integer;
declare cauto varchar(20);
declare nimpo1,nimpo2,nimpo3,ndd,nddd float;
declare btdoc varchar(2) default '';
set nid1=0;
set nddd=0;
set ndd=0;
set nmes=MONTH(dfecha);
SELECT dcorrelativo(nmes,'V') into cauto;
SELECT dtipocambio(dfecha,'V') into ndd;
IF ndd>0 then
   set nddd=ndd;
  else
   select dola into nddd from fe_gene where idgene=1;
ENd if;
select gene_ctpe into nidctaper  from fe_gene where idgene=1;
select gene_idve into idve from fe_gene where idgene=1;
select tdoc into btdoc from fe_tdoc where idtdoc=ntdoc;
INSERT INTO fe_rven(auto,idclie,idtdoc,form,ndoc,fech,fecr,fevto,mone,dolar,vigv,idauto,idusua,fusua,dolao,pimpo)
values(cauto,nidclie,ntdoc,cform,cndoc,dfecha,dfecha1,dfevto,cm,nddd,ni,nid,nus,localtime,nddd,tper);
select last_insert_id() into nid1 from fe_rven group by last_insert_id();
call ProIngresaCuentasV(nt1,nt2,nt3,nidcta1,nidcta2,nidcta3,nid1,tper,nidctaper);
if idve>0 and cform='E'and (btdoc<>'07' or btdoc<>'08') then
      Call ProIngresaDatosLcajaE1(dfecha,"",concat("Venta ",cndoc),idve,nt3+tper,0,cm,nddd,nus,nidclie,nid1);
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaRventas1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaRventas1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaRventas1`(
nidclie integer,ntdoc integer,cform char,cndoc varchar(12),
dfecha date,dfecha1 date,dfevto date,cm char,ndolar float,ni float,nus integer,
nt1 float,nt2 float,nt3 float,nidcta1 integer,nidcta2 integer,nidcta3 integer,nidcta4 integer,cauto VARCHAR(15),nidalma integer)
BEGIN
declare nid1 integer;
set nid1=0;
INSERT INTO fe_rven(auto,idclie,idtdoc,form,ndoc,fech,fecr,fevto,mone,dolar,vigv,idauto,idusua,fusua,dolao,pimpo,idalma,arreg)
values(cauto,nidclie,ntdoc,cform,cndoc,dfecha,dfecha1,dfevto,cm,ndolar,ni,0,nus,localtime,ndolar,0,nidalma,'I');
select last_insert_id() into nid1 from fe_rven group by last_insert_id();
call ProIngresaCuentasV(nt1,nt2,nt3,nidcta1,nidcta2,nidcta3,nid1,0,nidcta4);
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROingresa_anulada` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROingresa_anulada` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROingresa_anulada`(in dfecha Date,in cndoc varchar(12),in ctdoc varchar(2),in nu integer,in nidcon integer)
begin
 declare cauto varchar(20);
 declare nid1 integer default 0;
 declare nidtda integer default 0;
 if left(cndoc,3)="001" then
    set nidtda=1;
 end if;
 if left(cndoc,3)="004" then
    set nidtda=2;
 end if;
 if left(cndoc,3)="003" then
    set nidtda=3;
 end if;
 if left(cndoc,3)="006" then
    set nidtda=4;
 end if;
 select @nc:=idclie from fe_clie where nruc='***********';
 insert into fe_rcom(idcliente,fech,fecr,ndoc,tdoc,tipom,ncta,deta,ndo2,tcom,form,mone,exon,fusua,idusua,codt)
 values(@nc,dfecha,dfecha,cndoc,ctdoc,'V','','','','K','','S','N',now(),nu,nidtda);
 SELECT @na:=LAST_INSERT_ID() FROM fe_rcom group by last_insert_id();
 INSERT INTO fe_caja(idauto,fech,impo,tipo,forma,tmon,ndoc,idcon,idusua,fechao,deta,origen,codt)
 VALUES (@na,dfecha,0,"I","E","S",cndoc,nidcon,nu,now(),"*** ANULADA ***","CK",nidtda);
 select @ntdoc:=idtdoc from fe_tdoc where tdoc=ctdoc;
 SELECT dcorrelativo(month(dfecha),'V') into cauto;
 INSERT INTO fe_rven(auto,idclie,idtdoc,form,ndoc,fech,fecr,fevto,mone,dolar,vigv,idauto,idusua,fusua,dolao,idalma)
 values(cauto,@nc,@ntdoc,'',cndoc,dfecha,dfecha,dfecha,'S',2.85,1.19,@na,nu,curdate(),2.85,nidtda);
 select last_insert_id() into nid1 from fe_rven group by last_insert_id();
 call ProIngresaCuentasV(0,0,0,1,1,1,nid1,0,0);
END */$$
DELIMITER ;

/* Procedure structure for procedure `Proingresa_Anulada1` */

/*!50003 DROP PROCEDURE IF EXISTS  `Proingresa_Anulada1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `Proingresa_Anulada1`(out estado varchar(200),in cauto varchar(20),in dfecha Date,in cndoc varchar(12),in ntdoc integer,in nu integer,in nidrven integer)
BEGIN
 declare nid1 integer default 0;
 declare nidtda integer default 0;
DECLARE EXIT HANDLER FOR SQLEXCEPTION,SQLWARNING,NOT FOUND
begin
   rollback;
   set estado:="No se ejecuto Correctamente las Transacciones";
end;
start transaction;
 if left(cndoc,3)="001" then
    set nidtda=1;
 end if;
 if left(cndoc,3)="004" then
    set nidtda=2;
 end if;
 if left(cndoc,3)="003" then
    set nidtda=3;
 end if;
 if left(cndoc,3)="006" then
    set nidtda=4;
 end if;
if nidrven>0 then
   update fe_rven set acti='I' where idrven=nidrven;
   update fe_refe set acti='I' where idrven=nidrven;
   update fe_ectas set acti='I' where idrven=nidrven;
end if;
 set estado=null;
 select @nc:=idclie from fe_clie where nruc='***********';
 INSERT INTO fe_rven(auto,idclie,idtdoc,form,ndoc,fech,fecr,fevto,mone,dolar,vigv,idauto,idusua,fusua,dolao,idalma)
 values(cauto,@nc,ntdoc,'',cndoc,dfecha,dfecha,dfecha,'S',2.85,1.19,@na,nu,curdate(),2.85,nidtda);
 select last_insert_id() into nid1 from fe_rven group by last_insert_id();
 call ProIngresaCuentasV(0,0,0,1,1,1,nid1,0,0);
 commit;
 set estado:="Ok";
END */$$
DELIMITER ;

/* Procedure structure for procedure `Proingresa_Anulada2` */

/*!50003 DROP PROCEDURE IF EXISTS  `Proingresa_Anulada2` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `Proingresa_Anulada2`(out estado varchar(200),
in cauto varchar(20),in dfecha Date,in cndoc varchar(12),in ntdoc integer,in nu integer,in nidrven integer,nidtda integer)
BEGIN
 declare nid1 integer default 0;
DECLARE EXIT HANDLER FOR SQLEXCEPTION,SQLWARNING,NOT FOUND
begin
   rollback;
   set estado:="No se ejecuto Correctamente las Transacciones";
end;
start transaction;
if nidrven>0 then
   update fe_rven set acti='I' where idrven=nidrven;
   update fe_refe set acti='I' where idrven=nidrven;
   update fe_ectas set acti='I' where idrven=nidrven;
end if;
 set estado=null;
 select @nc:=idclie from fe_clie where nruc='***********';
 INSERT INTO fe_rven(auto,idclie,idtdoc,form,ndoc,fech,fecr,fevto,mone,dolar,vigv,idauto,idusua,fusua,dolao,idalma)
 values(cauto,@nc,ntdoc,'',cndoc,dfecha,dfecha,dfecha,'S',2.85,1.19,@na,nu,curdate(),2.85,nidtda);
 select last_insert_id() into nid1 from fe_rven group by last_insert_id();
 call ProIngresaCuentasV(0,0,0,1,1,1,nid1,0,0);
 commit;
 set estado:="Ok";
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraAlmacenes` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraAlmacenes` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraAlmacenes`()
BEGIN
SELECT nomb,idalma,dire,ciud,sucuidserie FROM fe_sucu order by nomb;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PromuestraBancos` */

/*!50003 DROP PROCEDURE IF EXISTS  `PromuestraBancos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PromuestraBancos`(cb varchar(20))
BEGIN
declare cb1 varchar(20);
set cb1=concat('%',trim(cb),'%');
select banc_nomb,banc_idba,banc_idco from fe_bancos where banc_nomb like cb1 order by banc_nomb;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PromuestraBancosT` */

/*!50003 DROP PROCEDURE IF EXISTS  `PromuestraBancosT` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PromuestraBancosT`()
BEGIN
select banc_nomb,banc_idco1 as banc_idco from fe_tbancos order by banc_nomb;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraCheques` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraCheques` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraCheques`(nid integer)
BEGIN
SELECT a.cheq_banc,a.cheq_nume,a.cheq_fecg,a.cheq_fecc,a.cheq_mone,a.cheq_impo,
case a.cheq_cobr when 'S' then 'Cobrado    '
                 when 'N' then ' No Cobrado'
                 when 'D' then ' Deveuelto'
                 when 'E' then ' Extornado'
end as condicion, b.rche_idcl
from fe_cheques as a inner join fe_rcheq as b on(b.rche_idrc=a.cheq_idrc)
where b.rche_idcl=nid  and (a.cheq_cobr='N' or a.cheq_cobr='D')  and a.cheq_acti<>'I' order by a.cheq_fecc;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROMuestraClientes` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROMuestraClientes` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROMuestraClientes`(in cbusca varchar(80),in opt integer,in nid integer)
BEGIN
declare cbuscar varchar(80);
set cbuscar=concat('%',trim(cbusca),+'%');
case
 when opt=0 then
   select idclie,nruc,razo,ndni,dire,ciud,fono,fax,celu,refe,clie_dir1,clie_ciu1
   from fe_clie where razo like cbuscar and clie_acti<>'I' order by razo;
 when opt=1 then
   select idclie,nruc,razo,ndni,dire,ciud,fono,fax,celu,refe,clie_dir1,clie_ciu1
   from fe_clie where nruc like cbuscar  and clie_acti<>'I' order by nruc;
 when opt=2 then
   select idclie,nruc,razo,ndni,dire,ciud,fono,fax,celu,refe,clie_dir1,clie_ciu1
   from fe_clie where ndni like cbuscar and clie_acti<>'I'  order by ndni;
 when opt=3 then
   select idclie,nruc,razo,ndni,dire,ciud,fono,fax,celu,refe,clie_dir1,clie_ciu1
   from fe_clie where idclie =nid and clie_acti<>'I' order by idclie;
 when opt=4 then
   select idclie,nruc,razo,ndni,dire,ciud,fono,fax,celu,refe,clie_dir1,clie_ciu1
   from fe_clie where ciud like cbuscar and clie_acti<>'I' order by idclie;
end case;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROMuestraClientes1` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROMuestraClientes1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROMuestraClientes1`(in cbusca varchar(80),in opt integer,in nid integer)
BEGIN
declare cbuscar varchar(80);
set cbuscar=concat('%',trim(cbusca),+'%');
case
 when opt=0 then
   select idclie,nruc,razo,ndni,dire,ciud,fono,fax,celu,refe,
   clie_idpt,ifnull(dpto_nomb,'') as dpto,clie_dist as distrito,clie_dir1,clie_ciu1
   from fe_clie  a left join fe_dpto b on b.dpto_idpt=a.clie_idpt
   where razo like cbuscar and clie_acti<>'I' order by razo;
 when opt=1 then
   select idclie,nruc,razo,ndni,dire,ciud,fono,fax,celu,refe,
   clie_idpt,ifnull(dpto_nomb,'') as dpto,clie_dist as distrito,clie_dir1,clie_ciu1
   from fe_clie a left join fe_dpto b on b.dpto_idpt=a.clie_idpt
   where nruc like cbuscar  and clie_acti<>'I' order by nruc;
 when opt=2 then
   select idclie,nruc,razo,ndni,dire,ciud,fono,fax,celu,refe,
   clie_idpt,ifnull(dpto_nomb,'') as dpto,clie_dist as distrito,clie_dir1,clie_ciu1
   from fe_clie a left join fe_dpto b on b.dpto_idpt=a.clie_idpt
   where ndni like cbuscar and clie_acti<>'I'  order by ndni;
 when opt=3 then
   select idclie,nruc,razo,ndni,dire,ciud,fono,fax,celu,refe,
   clie_idpt,ifnull(dpto_nomb,'') as dpto,clie_dist as distrito,clie_dir1,clie_ciu1
   from fe_clie a left join fe_dpto b on b.dpto_idpt=a.clie_idpt
   where idclie =nid and clie_acti<>'I' order by idclie;
 when opt=4 then
   select idclie,nruc,razo,ndni,dire,ciud,fono,fax,celu,refe,
   clie_idpt,ifnull(dpto_nomb,'') as dpto,clie_dist as distrito,clie_dir1,clie_ciu1
   from fe_clie a left join fe_dpto b on b.dpto_idpt=a.clie_idpt
   where ciud like cbuscar and clie_acti<>'I' order by idclie;
end case;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraCostosParaVenta` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraCostosParaVenta` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraCostosParaVenta`(lw varchar(60))
BEGIN
declare vigv decimal(8,5);
declare cb varchar(60);
set cb=concat("%",trim(lw),"%");
select igv into vigv from fe_gene where idgene=1;
SELECT idart,descri,unid,uno,dos,tre,cua,cin,sei,cost*vigv as costo,if(tmon="S","Soles","Dólares") as tmon,
FunMuestraCostosxProdcucto(a.idart) as costop,
pre1,pre2,pre3,peso,prod_perc FROM fe_art  as a  WHERE descri LIKE cb and prod_acti<>'I'   ORDER BY descri;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraCuentas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraCuentas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraCuentas`(cb varchar(50),opt integer)
BEGIN
declare cb1 varchar(50);
set cb1=concat('%',trim(cb),'%');
if opt=1 then
   select ncta,nomb,idcta,cdestinod,cdestinoh,tipocta,plan_oper from fe_plan where ncta like cb1 order by ncta;
  else
   select ncta,nomb,idcta,cdestinod,cdestinoh,tipocta,plan_oper from fe_plan where nomb like cb1 order by ncta;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraCuentasx` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraCuentasx` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraCuentasx`(cb VARCHAR(50),opt INTEGER)
BEGIN
DECLARE cb1 VARCHAR(50);
SET cb1=CONCAT('%',TRIM(cb),'%');
IF opt=1 THEN
   SELECT ncta,nomb,idcta,cdestinod,cdestinoh,tipocta,ctasunat,IFNULL(ctas_desc,'') AS ctas_desc,plan_oper,plan_ncta,plan_desc
   FROM fe_plan p
   WHERE plan_acti='A'  AND ncta LIKE cb1 ORDER BY ncta;
  ELSE
   SELECT ncta,nomb,idcta,cdestinod,cdestinoh,tipocta,ctasunat,IFNULL(ctas_desc,'') AS ctas_desc,plan_oper,plan_ncta,plan_desc FROM fe_plan p
   WHERE nomb LIKE cb1  AND plan_acti='A' ORDER BY ncta;
END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraDctos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraDctos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraDctos`(cbusca varchar(20))
BEGIN
declare cbuscar varchar(20);
set cbuscar=concat('%',trim(cbusca),+'%');
SELECT tdoc,nomb,idtdoc FROM fe_tdoc WHERE nomb LIKE cbuscar and dcto_acti<>'I' ORDER BY nomb;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROMUESTRADIARIO` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROMUESTRADIARIO` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROMUESTRADIARIO`(cndoc varchar(14),ntienda integer)
BEGIN
select b.ncta,b.nomb,a.ldia_glosa as glosa,ldia_debe as debe,ldia_haber as haber,ldia_tipo as tipo,a.ldia_idcta as idcta,
a.ldia_idld as nreg,ldia_fech as fecha,ldia_cond as cond,a.ldia_comp as Comp,ifnull(p.razo,'') as Cliente,ifnull(q.razo,'') as Proveedor,
ifnull(a.ldia_idcv,0) as idcliente,ifnull(a.ldia_idcc,0) as idproveedor  from fe_ldiario as a 
inner join fe_plan as b on b.idcta=a.ldia_idcta
left join fe_ctasctesv as m on m.ctcv_idct=a.ldia_idcv 
left join fe_clie as p on p.idclie=m.ctcv_idcl 
left join fe_ctasctesc as n on n.ctcc_idct=a.ldia_idcc
left join fe_prov as q on q.idprov=n.ctcc_idpr 
where ldia_nume=cndoc and ldia_acti<>'I' and ldia_codt=ntienda;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraDptos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraDptos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraDptos`()
begin
Select dpto_nomb,dpto_idpt from fe_dpto where dpto_acti='A' order by dpto_nomb;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraFletes` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraFletes` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraFletes`(in abuscar varchar(20))
BEGIN
declare cbusca varchar(20);
set cbusca=concat('%',trim(abuscar),+'%');
SELECT idflete,desflete,prec FROM fe_fletes WHERE desflete LIKE cbusca and flet_acti<>'I'  ORDER BY desflete;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraLCaja` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraLCaja` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraLCaja`(cndoc varchar(20))
begin
select a.cban_nume,a.cban_fech,b.pago_codi,b.pago_deta,a.cban_deta,if(a.cban_debe>0,m.razo,n.razo) as razon,a.cban_idba,
a.cban_ndoc,c.ncta,c.nomb,a.cban_debe,a.cban_haber,a.cban_idct,a.cban_idmp,a.cban_idco,a.cban_idcl,a.cban_idpr,cban_clpr,a.cban_idca from fe_cbancos as a inner join fe_mpago as b on
b.pago_idpa=a.cban_idmp left join fe_clie as m on m.idclie=a.cban_idcl left join fe_prov as n on n.idprov=a.cban_idpr
inner join fe_plan as c on c.idcta=a.cban_idct where a.cban_acti='A' AND trim(a.cban_ndoc)=trim(cndoc);
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraLcajaE` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraLcajaE` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraLcajaE`(cndoc varchar(10),ntienda integer)
begin
select a.lcaj_idca,a.lcaj_fech,a.lcaj_ndoc,a.lcaj_deta,a.lcaj_deud,a.lcaj_acre,a.lcaj_idct,b.ncta,b.nomb,lcaj_mone,lcaj_dola,lcaj_idus,lcaj_clpr,lcaj_tran
from fe_lcaja as a 
inner join fe_plan as b on b.idcta=a.lcaj_idct where a.lcaj_acti='A' AND trim(a.lcaj_ndoc)=trim(cndoc) and lcaj_codt=ntienda and lcaj_tran='N' ;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraLineas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraLineas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraLineas`( abuscar varchar(20),nidgrupo integer)
BEGIN
declare cbusca varchar(20);
set cbusca=concat('%',trim(abuscar),+'%');
if nidgrupo=0 then
   SELECT a.idcat,a.dcat,a.util1,a.util2,ifnull(count(b.idart),0) as Total_Productos
   FROM fe_cat as a left join fe_art as b on b.idcat=a.idcat
   WHERE dcat LIKE cbusca  group by a.idcat ORDER BY dcat;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROMuestraMarcas` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROMuestraMarcas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROMuestraMarcas`(in cbusca varchar(80),in opt integer,in nid integer)
BEGIN
declare cbuscar varchar(80);
set cbuscar=concat('%',trim(cbusca),+'%');
if opt=0 then
   select idmar,dmar from fe_mar where dmar like cbuscar order by dmar;
end if;
if opt=3 then
   select idmar,dmar from fe_mar where idmar=nid order by idmar;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraMediosPago` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraMediosPago` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraMediosPago`()
BEGIN
SELECT pago_deta,pago_codi,pago_idpa  FROM fe_mpago  where pago_acti='A' order by pago_deta;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraMenu` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraMenu` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraMenu`(nid varchar(5),ct char)
BEGIN
SELECT Menu_idme as iKey,Menu_text as Texto,menu_enla as Parent,menu_clav as clave from fe_menus where menu_tipo=ct;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PromuestraP1` */

/*!50003 DROP PROCEDURE IF EXISTS  `PromuestraP1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PromuestraP1`(ncoda integer,nd float)
BEGIN
SELECT idart,descri,unid,uno,dos,tre,cua
FROM fe_art  as a WHERE idart=ncoda and prod_acti<>'I' ORDER BY DESCRI;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraPlanCuentas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraPlanCuentas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraPlanCuentas`(cb varchar(50),nid integer)
BEGIN
declare cb1 varchar(50);
set cb1=concat('%',trim(cb),'%');
SELECT ncta,idcta,nomb,cdestinod,cdestinoh,tipocta,plan_oper FROM fe_plan where ncta like cb1 and plan_acti='A'  ORDER BY ncta;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraPresentacionesXProducto` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraPresentacionesXProducto` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraPresentacionesXProducto`(nidart integer,nd decimal(6,4))
BEGIN
declare nu integer default 0;
select pmvtas into nu from fe_gene where idgene=1;
SELECT a.pres_desc,if(b.epta_cost>0,
if(b.epta_mone='S',if(b.epta_esti='M',round(b.epta_cost*((b.epta_marg/100)+1),2),round(b.epta_cost*((b.epta_marg/100)+1),2)),
if(b.epta_esti='M',round(b.epta_cost*nd*((b.epta_marg/100)+1),2),round(b.epta_cost*nd*((b.epta_marg/100)+1),2))),b.epta_prec) as epta_prec,
if(b.epta_mone='S',b.epta_cost,round(b.epta_cost*nd,2)) as costo,
if(b.epta_mone='S',round(b.epta_cost/((100-nu)/100),2),round((b.epta_cost*nd)/((100-nu)/100),2)) as precio1,
b.epta_cant,b.epta_idar,b.epta_idep,b.epta_esti FROM fe_epta  as b inner join fe_presentaciones as a
on a.pres_idpr=b.epta_pres where b.epta_acti='A' and b.epta_idar=nidart order by b.epta_prec desc;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROMuestraProductos` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROMuestraProductos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROMuestraProductos`(in abuscar varchar(80))
BEGIN
declare cbuscar varchar(80);
set cbuscar=concat('%',trim(abuscar),+'%');
SELECT idart,descri,unid,uno,dos,tre,cua,cin,sei,pre1,
pre2,pre3,peso,prec,tipro,idmar,idcat,cost,tmon,idflete,prod_perc,prod_mode,prod_ccai
FROM fe_art WHERE descri LIKE cbuscar and prod_acti<>'I' ORDER BY DESCRI;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraProveedor` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraProveedor` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraProveedor`(in abuscar varchar(60),in opt integer,in nid integer)
BEGIN
declare cbuscar varchar(60);
set cbuscar=concat('%',trim(abuscar),+'%');
if opt=0 then
   select idprov,nruc,razo,ndni,dire,ciud,fono,fax,email,celu,refe,prov_rpm,idusua,prov_actu,fechprov,prov_feac
   from fe_prov where razo like cbuscar and prov_acti<>'I' order by razo ;
end if;
if opt=1 then
   select idprov,nruc,razo,ndni,dire,ciud,fono,fax,email,celu,refe,prov_rpm,idusua,prov_actu,fechprov,prov_feac
   from fe_prov where nruc like cbuscar and prov_acti<>'I' order by nruc;
end if;
if opt=2 then
   select idprov,nruc,razo,ndni,dire,ciud,fono,fax,email,celu,refe,prov_rpm,idusua,prov_actu,fechprov,prov_feac
   from fe_prov where idprov=nid and prov_acti<>'I' order by razo;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraProveedorES` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraProveedorES` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraProveedorES`(in abuscar varchar(60),in opt integer,in nid integer)
BEGIN
declare cbuscar varchar(60);
set cbuscar=concat('%',trim(abuscar),+'%');
if opt=0 then
   select idprov,nruc,razo,ndni,dire,ciud,fono,fax,refe,celu,email
   from fe_prov where razo like cbuscar  and prov_acti<>'I' ORDER BY RAZO;
end if;
if opt=1 then
   select idprov,nruc,razo,ndni,dire,ciud,fono,fax,refe,celu,email
   from fe_prov where nruc like cbuscar  and prov_acti<>'I' ORDER BY RAZO;
end if;
if opt=2 then
   select idprov,nruc,razo,ndni,dire,ciud,fono,fax,refe,celu,email
   from fe_prov where idprov=nid and prov_acti<>'I' ORDER BY IDPROV;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraTransportista` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraTransportista` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraTransportista`(cb varchar(20),opt integer)
BEGIN
declare cb1 varchar(20);
set cb1=concat('%',trim(cb),'%');
if opt=1 then
  SELECT placa,razon,ructr,cons,nombr,breve,cons,marca,ifnull(placa1,'') as placa1,dirtr,idtra FROM fe_tra WHERE razon LIKE cb1;
 else
  SELECT placa,razon,ructr,cons,nombr,breve,cons,marca,ifnull(placa1,'') as placa1,dirtr,idtra FROM fe_tra WHERE placa LIKE cb1;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraVendedores` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraVendedores` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraVendedores`(in cbusca varchar(20))
BEGIN
declare cbuscar varchar(80);
set cbuscar=concat('%',trim(cbusca),+'%');
select nomv,idven from fe_vend where nomv like cbuscar and vend_acti<>'I' order by nomv;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProRegistraDretencion` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProRegistraDretencion` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProRegistraDretencion`(nidr integer,idauto integer,
nimpo decimal(12,2),valor decimal(4,2),nidd integer,ctdoc varchar(2),cndoc varchar(12),nimpo1 decimal(12,2),dfecha date)
begin
insert into fe_dret(dret_idre,dret_idau,dret_impo,dret_valor,dret_idrd,dret_tdoc,dret_ndoc,dret_imp1,dret_fech)
values(nidr,idauto,nimpo,valor,nidd,ctdoc,cndoc,nimpo1,dfecha);
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProReiniciaMvtos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProReiniciaMvtos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProReiniciaMvtos`()
BEGIN
delete from fe_aval;
delete from fe_cheques;
delete from fe_ctasctesc;
delete from fe_ctasctesv;
delete from fe_dcanjes;
delete from fe_dguias;
delete from fe_dret;
delete from fe_ecrch;
delete from fe_rcheq;
delete from fe_rcon;
delete from fe_refe;
delete from fe_rguias;
delete from fe_rven;
delete from fe_rcon;
delete from fe_tra;
delete from fe_acaja;
delete from fe_acreditos;
delete from fe_akardex;
delete from fe_aresumen;
delete from fe_acheques;
delete from fe_cbancos;
alter table fe_cbancos Auto_increment=0 ;
delete from fe_acheques;
delete from fe_ctasb;
delete from fe_ectas;
alter table fe_ectas Auto_increment=0 ;
delete from fe_ectasc;
alter table fe_ectasc Auto_increment=0 ;
delete from fe_lcaja;
alter table fe_lcaja Auto_increment=0 ;
delete from fe_ldiario;
alter table fe_ldiario Auto_increment=0 ;
delete from fe_kar;
alter table fe_kar Auto_increment=0 ;
delete from fe_rcom;
alter table fe_rcom Auto_increment=0 ;
delete from fe_cred;
alter table fe_cred Auto_increment=0 ;
delete from fe_caja;
alter table fe_caja Auto_increment=0 ;
delete from fe_deu;
alter table fe_deu Auto_increment=0 ;
delete from fe_rdeu;
alter table fe_rdeu Auto_increment=0 ;
delete from fe_ped;
alter table fe_ped Auto_increment=1 ;
delete from fe_rped;
alter table fe_rped Auto_increment=1 ;
delete from fe_art;
alter table fe_art Auto_increment=0 ;
delete from fe_cat;
alter table fe_cat Auto_increment=1 ;
delete from fe_mar;
alter table fe_mar Auto_increment=1 ;
delete from fe_clie;
alter table fe_clie Auto_increment=1 ;
delete from fe_prov;
alter table fe_prov Auto_increment=1 ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProSoloDatoCuenta` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProSoloDatoCuenta` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProSoloDatoCuenta`(cta varchar(8))
BEGIN
select idcta,nomb,ncta from fe_plan where ncta=cta;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProSoloDatoCuenta1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProSoloDatoCuenta1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProSoloDatoCuenta1`(nidcta integer)
BEGIN
select idcta,nomb,ncta from fe_plan where idcta=nidcta;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraCtasBancos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraCtasBancos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraCtasBancos`(na integer)
BEGIN
select a.ctas_ctas,b.banc_nomb,a.ctas_mone,a.ctas_deta,a.ctas_idct,a.ctas_idba,a.ctas_ncta,b.banc_idco,ctas_codt,ctas_seri
from fe_ctasb as a
inner join fe_bancos as b on b.banc_idba=a.ctas_idba 
where a.ctas_acti='A' and ctas_codt=na order by a.ctas_ctas;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDatosLcajaE1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDatosLcajaE1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDatosLcajaE1`(dfecha DATE,cndoc VARCHAR(12),cdeta VARCHAR(100),idcta INTEGER,sdeudor DECIMAL(12,2),
sacreedor DECIMAL(12,2),cmone CHAR,ndolar DECIMAL(5,3),nidus INTEGER,nidcp INTEGER,nidauto INTEGER,nidalma INTEGER)
BEGIN
if sdeudor<>0 then
   INSERT INTO fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,
   lcaj_idus,lcaj_clpr,lcaj_idau,lcaj_codt)VALUES
  (dfecha,cndoc,cdeta,idcta,sdeudor,0,cmone,ndolar,nidus,nidcp,nidauto,nidalma);
else
   INSERT INTO fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,
   lcaj_idus,lcaj_clpr,lcaj_idac,lcaj_codt)VALUES
  (dfecha,cndoc,cdeta,idcta,0,sacreedor,cmone,ndolar,nidus,nidcp,nidauto,nidalma);
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaDatosLcajaE` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaDatosLcajaE` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaDatosLcajaE`(dfecha datetime,cndoc varchar(10),cdeta varchar(100),idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),nid integer,opt integer,cmone char,ndolar decimal(5,3))
begin
IF opt=0 THEN
   UPDATE fe_lcaja  SET lcaj_acti='I' WHERE lcaj_idca=nid;
   UPDATE fe_ldiario SET ldia_acti='I' WHERE ldia_idca=nid;
  ELSE
    UPDATE fe_lcaja  SET lcaj_fech=dfecha,lcaj_ndoc=cndoc,lcaj_deta=cdeta,lcaj_idct=idcta,
    lcaj_deud=sdeudor,lcaj_acre=sacreedor,lcaj_mone=cmone,lcaj_dola=ndolar WHERE lcaj_idca=nid;
END IF;
end */$$
DELIMITER ;

/*Table structure for table `vcostoproducto` */

DROP TABLE IF EXISTS `vcostoproducto`;

/*!50001 DROP VIEW IF EXISTS `vcostoproducto` */;
/*!50001 DROP TABLE IF EXISTS `vcostoproducto` */;

/*!50001 CREATE TABLE  `vcostoproducto`(
 `idart` int ,
 `prec` double ,
 `mone` varchar(1) ,
 `fech` date 
)*/;

/*Table structure for table `vlcajacl` */

DROP TABLE IF EXISTS `vlcajacl`;

/*!50001 DROP VIEW IF EXISTS `vlcajacl` */;
/*!50001 DROP TABLE IF EXISTS `vlcajacl` */;

/*!50001 CREATE TABLE  `vlcajacl`(
 `lcaj_idca` int ,
 `razo` varchar(100) 
)*/;

/*Table structure for table `vlcajapr` */

DROP TABLE IF EXISTS `vlcajapr`;

/*!50001 DROP VIEW IF EXISTS `vlcajapr` */;
/*!50001 DROP TABLE IF EXISTS `vlcajapr` */;

/*!50001 CREATE TABLE  `vlcajapr`(
 `lcaj_idca` int ,
 `razo` varchar(100) ,
 `lcaj_clpr` int unsigned ,
 `ncta` varchar(8) 
)*/;

/*Table structure for table `vmuestracompras` */

DROP TABLE IF EXISTS `vmuestracompras`;

/*!50001 DROP VIEW IF EXISTS `vmuestracompras` */;
/*!50001 DROP TABLE IF EXISTS `vmuestracompras` */;

/*!50001 CREATE TABLE  `vmuestracompras`(
 `idauto` int ,
 `alma` int ,
 `idkar` int ,
 `descri` varchar(60) ,
 `peso` float ,
 `unid` varchar(5) ,
 `tipro` varchar(1) ,
 `idart` int ,
 `incl` varchar(1) ,
 `ndoc` varchar(12) ,
 `valor` float ,
 `igv` float ,
 `impo` float ,
 `pimpo` float ,
 `cant` float ,
 `prec` float ,
 `fech` date ,
 `fecr` date ,
 `form` varchar(1) ,
 `exon` char(1) ,
 `ndo2` varchar(12) ,
 `vigv` float ,
 `idprov` int ,
 `tipo` varchar(1) ,
 `tdoc` varchar(2) ,
 `dolar` float ,
 `mone` varchar(1) ,
 `razo` varchar(100) ,
 `dire` varchar(100) ,
 `ciud` varchar(100) ,
 `nruc` varchar(11) ,
 `Idcaja` bigint ,
 `codt` int unsigned ,
 `dsnc` int ,
 `dsnd` int ,
 `gast` int ,
 `fusua` datetime ,
 `Usuario` varchar(45) 
)*/;

/*Table structure for table `vmuestracotizaciones` */

DROP TABLE IF EXISTS `vmuestracotizaciones`;

/*!50001 DROP VIEW IF EXISTS `vmuestracotizaciones` */;
/*!50001 DROP TABLE IF EXISTS `vmuestracotizaciones` */;

/*!50001 CREATE TABLE  `vmuestracotizaciones`(
 `idart` int unsigned ,
 `descri` varchar(60) ,
 `unid` varchar(5) ,
 `cant` float ,
 `prec` float ,
 `premay` float ,
 `premen` float ,
 `fech` date ,
 `idautop` int unsigned ,
 `impo` float ,
 `ndoc` varchar(10) ,
 `aten` varchar(80) ,
 `forma` varchar(80) ,
 `plazo` varchar(80) ,
 `validez` varchar(80) ,
 `entrega` varchar(80) ,
 `detalle` varchar(150) ,
 `idclie` int ,
 `razo` varchar(100) ,
 `nruc` varchar(11) ,
 `dire` varchar(100) ,
 `rped_mone` char(1) ,
 `ciud` varchar(100) ,
 `fono` varchar(15) ,
 `fax` varchar(15) ,
 `nreg` int unsigned 
)*/;

/*Table structure for table `vmuestractascompras` */

DROP TABLE IF EXISTS `vmuestractascompras`;

/*!50001 DROP VIEW IF EXISTS `vmuestractascompras` */;
/*!50001 DROP TABLE IF EXISTS `vmuestractascompras` */;

/*!50001 CREATE TABLE  `vmuestractascompras`(
 `tdoc` varchar(3) ,
 `ndoc` varchar(12) ,
 `fecr` date ,
 `ncta` varchar(8) ,
 `razo` varchar(100) ,
 `Debe` double ,
 `Haber` double ,
 `idcta` int unsigned ,
 `fech` date ,
 `nomb` varchar(60) ,
 `tipo` char(1) ,
 `idrcon` int ,
 `mone` varchar(1) ,
 `idprov` int ,
 `idalma` int unsigned 
)*/;

/*Table structure for table `vmuestractasdiario` */

DROP TABLE IF EXISTS `vmuestractasdiario`;

/*!50001 DROP VIEW IF EXISTS `vmuestractasdiario` */;
/*!50001 DROP TABLE IF EXISTS `vmuestractasdiario` */;

/*!50001 CREATE TABLE  `vmuestractasdiario`(
 `Fecha` date ,
 `ncta` varchar(8) ,
 `Glosa` varchar(200) ,
 `Debe` decimal(12,2) ,
 `Haber` decimal(12,2) ,
 `Idcta` int unsigned 
)*/;

/*Table structure for table `vmuestractasventas` */

DROP TABLE IF EXISTS `vmuestractasventas`;

/*!50001 DROP VIEW IF EXISTS `vmuestractasventas` */;
/*!50001 DROP TABLE IF EXISTS `vmuestractasventas` */;

/*!50001 CREATE TABLE  `vmuestractasventas`(
 `tdoc` varchar(3) ,
 `ndoc` varchar(12) ,
 `fech` date ,
 `ncta` varchar(8) ,
 `razo` varchar(100) ,
 `Debe` double ,
 `Haber` double ,
 `tipo` char(1) ,
 `idcta` int unsigned ,
 `nomb` varchar(60) ,
 `idrven` int unsigned ,
 `mone` varchar(1) ,
 `idclie` int ,
 `idalma` int 
)*/;

/*Table structure for table `vmuestrarcompras` */

DROP TABLE IF EXISTS `vmuestrarcompras`;

/*!50001 DROP VIEW IF EXISTS `vmuestrarcompras` */;
/*!50001 DROP TABLE IF EXISTS `vmuestrarcompras` */;

/*!50001 CREATE TABLE  `vmuestrarcompras`(
 `ndoc` varchar(12) ,
 `fech` date ,
 `mone` varchar(1) ,
 `impo` decimal(34,2) ,
 `idauto` int ,
 `tdoc1` varchar(2) ,
 `dolar` float 
)*/;

/*Table structure for table `vpagosbancos` */

DROP TABLE IF EXISTS `vpagosbancos`;

/*!50001 DROP VIEW IF EXISTS `vpagosbancos` */;
/*!50001 DROP TABLE IF EXISTS `vpagosbancos` */;

/*!50001 CREATE TABLE  `vpagosbancos`(
 `ctasb` varchar(110) ,
 `cban_clpr` int unsigned 
)*/;

/*Table structure for table `vpdtespago` */

DROP TABLE IF EXISTS `vpdtespago`;

/*!50001 DROP VIEW IF EXISTS `vpdtespago` */;
/*!50001 DROP TABLE IF EXISTS `vpdtespago` */;

/*!50001 CREATE TABLE  `vpdtespago`(
 `ndoc` varchar(12) ,
 `fech` date ,
 `dola` float ,
 `nrou` varchar(25) ,
 `banc` varchar(80) ,
 `iddeu` int ,
 `fevto` date ,
 `saldo` decimal(12,2) ,
 `Idpr` int ,
 `ImporteC` decimal(12,2) ,
 `situa` varchar(1) ,
 `Idauto` int unsigned ,
 `ncontrol` int ,
 `tipo` varchar(1) ,
 `banco` varchar(45) ,
 `docd` varchar(12) ,
 `tdoc` varchar(2) ,
 `Moneda` char(1) ,
 `Codt` int unsigned ,
 `Idrd` int unsigned ,
 `rdeu_idct` int unsigned 
)*/;

/*Table structure for table `vpdtespagocompras` */

DROP TABLE IF EXISTS `vpdtespagocompras`;

/*!50001 DROP VIEW IF EXISTS `vpdtespagocompras` */;
/*!50001 DROP TABLE IF EXISTS `vpdtespagocompras` */;

/*!50001 CREATE TABLE  `vpdtespagocompras`(
 `saldo` decimal(12,2) ,
 `ncontrol` int ,
 `fevto` date ,
 `rdeu_idpr` int ,
 `rdeu_mone` char(1) 
)*/;

/*Table structure for table `vrcompras` */

DROP TABLE IF EXISTS `vrcompras`;

/*!50001 DROP VIEW IF EXISTS `vrcompras` */;
/*!50001 DROP TABLE IF EXISTS `vrcompras` */;

/*!50001 CREATE TABLE  `vrcompras`(
 `ndoc` varchar(12) ,
 `valor` float ,
 `igv` float ,
 `impo` float ,
 `pimpo` float ,
 `fech` date ,
 `fecr` date ,
 `form` varchar(1) ,
 `exon` char(1) ,
 `ndo2` varchar(12) ,
 `idauto` int ,
 `deta` varchar(220) ,
 `tcom` varchar(1) ,
 `vigv` float ,
 `idprov` int ,
 `tdoc` varchar(2) ,
 `dolar` float ,
 `mone` varchar(1) ,
 `razo` varchar(100) ,
 `dire` varchar(100) ,
 `ciud` varchar(100) ,
 `nruc` varchar(11) ,
 `Idcaja` bigint ,
 `codt` int unsigned ,
 `fusua` datetime ,
 `Usuario` varchar(45) 
)*/;

/*Table structure for table `vsaldosctaspagar` */

DROP TABLE IF EXISTS `vsaldosctaspagar`;

/*!50001 DROP VIEW IF EXISTS `vsaldosctaspagar` */;
/*!50001 DROP TABLE IF EXISTS `vsaldosctaspagar` */;

/*!50001 CREATE TABLE  `vsaldosctaspagar`(
 `rdeu_idrd` int unsigned ,
 `Saldo` double ,
 `ncontrol` int 
)*/;

/*View structure for view vcostoproducto */

/*!50001 DROP TABLE IF EXISTS `vcostoproducto` */;
/*!50001 DROP VIEW IF EXISTS `vcostoproducto` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vcostoproducto` AS select `a`.`idart` AS `idart`,if((`b`.`mone` = 'S'),((`a`.`prec` / `v`.`dola`) * `b`.`vigv`),(`a`.`prec` * `b`.`vigv`)) AS `prec`,`b`.`mone` AS `mone`,`b`.`fech` AS `fech` from ((`fe_kar` `a` join `fe_rcom` `b` on((`b`.`idauto` = `a`.`idauto`))) join `fe_gene` `v`) where ((`a`.`acti` = 'A') and (`b`.`acti` = 'A') and (`a`.`idprov` > 0)) order by `a`.`idart`,`b`.`fech` desc */;

/*View structure for view vlcajacl */

/*!50001 DROP TABLE IF EXISTS `vlcajacl` */;
/*!50001 DROP VIEW IF EXISTS `vlcajacl` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vlcajacl` AS select `a`.`lcaj_idca` AS `lcaj_idca`,`b`.`razo` AS `razo` from (`fe_lcaja` `a` join `fe_clie` `b` on((`b`.`idclie` = `a`.`lcaj_clpr`))) where ((`a`.`lcaj_acti` = 'A') and (`a`.`lcaj_deud` > 0)) */;

/*View structure for view vlcajapr */

/*!50001 DROP TABLE IF EXISTS `vlcajapr` */;
/*!50001 DROP VIEW IF EXISTS `vlcajapr` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vlcajapr` AS select `a`.`lcaj_idca` AS `lcaj_idca`,`b`.`razo` AS `razo`,`a`.`lcaj_clpr` AS `lcaj_clpr`,`w`.`ncta` AS `ncta` from ((`fe_lcaja` `a` join `fe_prov` `b` on((`b`.`idprov` = `a`.`lcaj_clpr`))) join (`fe_gene` `q` join `fe_plan` `w` on((`w`.`idcta` = `q`.`gene_idca`)))) where ((`a`.`lcaj_acti` = 'A') and (`a`.`lcaj_acre` > 0)) */;

/*View structure for view vmuestracompras */

/*!50001 DROP TABLE IF EXISTS `vmuestracompras` */;
/*!50001 DROP VIEW IF EXISTS `vmuestracompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestracompras` AS select `a`.`idauto` AS `idauto`,`a`.`alma` AS `alma`,`a`.`idkar` AS `idkar`,`b`.`descri` AS `descri`,`b`.`peso` AS `peso`,`b`.`unid` AS `unid`,`b`.`tipro` AS `tipro`,`a`.`idart` AS `idart`,`a`.`incl` AS `incl`,`c`.`ndoc` AS `ndoc`,`c`.`valor` AS `valor`,`c`.`igv` AS `igv`,`c`.`impo` AS `impo`,`c`.`pimpo` AS `pimpo`,`a`.`cant` AS `cant`,`a`.`prec` AS `prec`,`c`.`fech` AS `fech`,`c`.`fecr` AS `fecr`,`c`.`form` AS `form`,`c`.`exon` AS `exon`,`c`.`ndo2` AS `ndo2`,`c`.`vigv` AS `vigv`,`c`.`idprov` AS `idprov`,`a`.`tipo` AS `tipo`,`c`.`tdoc` AS `tdoc`,`c`.`dolar` AS `dolar`,`c`.`mone` AS `mone`,`p`.`razo` AS `razo`,`p`.`dire` AS `dire`,`p`.`ciud` AS `ciud`,`p`.`nruc` AS `nruc`,ifnull(`x`.`idcaja`,0) AS `Idcaja`,`c`.`codt` AS `codt`,`a`.`dsnc` AS `dsnc`,`a`.`dsnd` AS `dsnd`,`a`.`gast` AS `gast`,`c`.`fusua` AS `fusua`,`w`.`nomb` AS `Usuario` from (((((`fe_rcom` `c` left join `fe_kar` `a` on((`c`.`idauto` = `a`.`idauto`))) left join `fe_art` `b` on((`b`.`idart` = `a`.`idart`))) join `fe_prov` `p` on((`p`.`idprov` = `c`.`idprov`))) left join `fe_caja` `x` on((`x`.`idauto` = `c`.`idauto`))) join `fe_usua` `w` on((`w`.`idusua` = `c`.`idusua`))) where ((`c`.`tipom` = 'C') and (`c`.`acti` <> 'I') and (`a`.`acti` <> 'I')) */;

/*View structure for view vmuestracotizaciones */

/*!50001 DROP TABLE IF EXISTS `vmuestracotizaciones` */;
/*!50001 DROP VIEW IF EXISTS `vmuestracotizaciones` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestracotizaciones` AS select `a`.`idart` AS `idart`,`b`.`descri` AS `descri`,`b`.`unid` AS `unid`,`a`.`cant` AS `cant`,`a`.`prec` AS `prec`,`b`.`pre1` AS `premay`,`b`.`pre2` AS `premen`,`c`.`fech` AS `fech`,`c`.`idautop` AS `idautop`,`c`.`impo` AS `impo`,`c`.`ndoc` AS `ndoc`,`c`.`aten` AS `aten`,`c`.`forma` AS `forma`,`c`.`plazo` AS `plazo`,`c`.`validez` AS `validez`,`c`.`entrega` AS `entrega`,`c`.`detalle` AS `detalle`,`d`.`idclie` AS `idclie`,`d`.`razo` AS `razo`,`d`.`nruc` AS `nruc`,`d`.`dire` AS `dire`,`c`.`rped_mone` AS `rped_mone`,`d`.`ciud` AS `ciud`,`d`.`fono` AS `fono`,`d`.`fax` AS `fax`,`a`.`idped` AS `nreg` from (((`fe_ped` `a` join `fe_rped` `c` on((`a`.`idautop` = `c`.`idautop`))) join `fe_art` `b` on((`b`.`idart` = `a`.`idart`))) left join `fe_clie` `d` on((`d`.`idclie` = `c`.`idclie`))) where ((`a`.`acti` <> 'I') and (`c`.`acti` <> 'I')) */;

/*View structure for view vmuestractascompras */

/*!50001 DROP TABLE IF EXISTS `vmuestractascompras` */;
/*!50001 DROP VIEW IF EXISTS `vmuestractascompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestractascompras` AS select left(`p`.`nomb`,3) AS `tdoc`,`b`.`ndoc` AS `ndoc`,`b`.`fecr` AS `fecr`,`a`.`ncta` AS `ncta`,`c`.`razo` AS `razo`,(case `x`.`ecta_tipo` when 'D' then if((`b`.`mone` = 'S'),`x`.`impo`,round((`x`.`impo` * `b`.`dolar`),2)) else 0 end) AS `Debe`,(case `x`.`ecta_tipo` when 'H' then if((`b`.`mone` = 'S'),`x`.`impo`,round((`x`.`impo` * `b`.`dolar`),2)) else 0 end) AS `Haber`,`a`.`idcta` AS `idcta`,`b`.`fech` AS `fech`,`a`.`nomb` AS `nomb`,`x`.`ecta_tipo` AS `tipo`,`b`.`idrcon` AS `idrcon`,`b`.`mone` AS `mone`,`c`.`idprov` AS `idprov`,`b`.`idalma` AS `idalma` from ((((`fe_ectasc` `x` join `fe_plan` `a` on((`a`.`idcta` = `x`.`idcta`))) join `fe_rcon` `b` on((`b`.`idrcon` = `x`.`idrcon`))) join `fe_prov` `c` on((`c`.`idprov` = `b`.`idprov`))) join `fe_tdoc` `p` on((`p`.`idtdoc` = `b`.`idtdoc`))) where ((`x`.`impo` <> 0) and (`b`.`rcon_acti` = 'A')) */;

/*View structure for view vmuestractasdiario */

/*!50001 DROP TABLE IF EXISTS `vmuestractasdiario` */;
/*!50001 DROP VIEW IF EXISTS `vmuestractasdiario` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestractasdiario` AS select `a`.`ldia_fech` AS `Fecha`,`b`.`ncta` AS `ncta`,`a`.`ldia_glosa` AS `Glosa`,`a`.`ldia_debe` AS `Debe`,`a`.`ldia_haber` AS `Haber`,`a`.`ldia_idcta` AS `Idcta` from (`fe_ldiario` `a` join `fe_plan` `b` on((`b`.`idcta` = `a`.`ldia_idcta`))) where (`a`.`ldia_acti` = 'A') */;

/*View structure for view vmuestractasventas */

/*!50001 DROP TABLE IF EXISTS `vmuestractasventas` */;
/*!50001 DROP VIEW IF EXISTS `vmuestractasventas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestractasventas` AS select left(`p`.`nomb`,3) AS `tdoc`,`b`.`ndoc` AS `ndoc`,`b`.`fech` AS `fech`,`a`.`ncta` AS `ncta`,`c`.`razo` AS `razo`,(case `x`.`tipo` when 'D' then if((`b`.`mone` = 'S'),(`x`.`impo` + `x`.`ecta_total`),round(((`x`.`impo` + `x`.`ecta_total`) * `b`.`dolar`),2)) else 0 end) AS `Debe`,(case `x`.`tipo` when 'H' then if((`b`.`mone` = 'S'),(`x`.`impo` + `x`.`ecta_total`),round(((`x`.`impo` + `x`.`ecta_total`) * `b`.`dolar`),2)) else 0 end) AS `Haber`,`x`.`tipo` AS `tipo`,`a`.`idcta` AS `idcta`,`a`.`nomb` AS `nomb`,`b`.`idrven` AS `idrven`,`b`.`mone` AS `mone`,`c`.`idclie` AS `idclie`,`b`.`idalma` AS `idalma` from ((((`fe_ectas` `x` join `fe_plan` `a` on((`a`.`idcta` = `x`.`idcta`))) join `fe_rven` `b` on((`b`.`idrven` = `x`.`idrven`))) join `fe_clie` `c` on((`c`.`idclie` = `b`.`idclie`))) join `fe_tdoc` `p` on((`p`.`idtdoc` = `b`.`idtdoc`))) where ((`x`.`impo` <> 0) and (`b`.`acti` <> 'I')) */;

/*View structure for view vmuestrarcompras */

/*!50001 DROP TABLE IF EXISTS `vmuestrarcompras` */;
/*!50001 DROP VIEW IF EXISTS `vmuestrarcompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestrarcompras` AS select `a`.`ndoc` AS `ndoc`,`a`.`fech` AS `fech`,`a`.`mone` AS `mone`,sum((case `b`.`nitem` when 8 then `b`.`impo` else 0 end)) AS `impo`,`a`.`idrcon` AS `idauto`,`d`.`tdoc` AS `tdoc1`,`a`.`dolar` AS `dolar` from ((`fe_rcon` `a` join `fe_ectasc` `b` on((`b`.`idrcon` = `a`.`idrcon`))) join `fe_tdoc` `d` on((`d`.`idtdoc` = `a`.`idtdoc`))) where (`d`.`tdoc` = '01') group by `a`.`idrcon` order by `a`.`idrcon` */;

/*View structure for view vpagosbancos */

/*!50001 DROP TABLE IF EXISTS `vpagosbancos` */;
/*!50001 DROP VIEW IF EXISTS `vpagosbancos` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpagosbancos` AS select concat(convert(`w`.`ncta` using utf8mb4),'  ',convert(`v`.`ctas_ctas` using utf8mb4)) AS `ctasb`,`f`.`cban_clpr` AS `cban_clpr` from ((`fe_cbancos` `f` join `fe_ctasb` `v` on((`v`.`ctas_idct` = `f`.`cban_idba`))) join `fe_plan` `w` on((`w`.`idcta` = `v`.`ctas_ncta`))) where ((`f`.`cban_clpr` > 0) and (`f`.`cban_acti` = 'A')) order by `f`.`cban_clpr` */;

/*View structure for view vpdtespago */

/*!50001 DROP TABLE IF EXISTS `vpdtespago` */;
/*!50001 DROP VIEW IF EXISTS `vpdtespago` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpdtespago` AS select `a`.`ndoc` AS `ndoc`,`a`.`fech` AS `fech`,`a`.`dola` AS `dola`,`a`.`nrou` AS `nrou`,`a`.`banc` AS `banc`,`a`.`iddeu` AS `iddeu`,`s`.`fevto` AS `fevto`,`s`.`saldo` AS `saldo`,`s`.`rdeu_idpr` AS `Idpr`,`b`.`rdeu_impc` AS `ImporteC`,'C' AS `situa`,`b`.`rdeu_idau` AS `Idauto`,`s`.`ncontrol` AS `ncontrol`,`a`.`tipo` AS `tipo`,`a`.`banco` AS `banco`,ifnull(`c`.`ndoc`,'0') AS `docd`,ifnull(`c`.`tdoc`,'0') AS `tdoc`,`b`.`rdeu_mone` AS `Moneda`,`b`.`rdeu_codt` AS `Codt`,`b`.`rdeu_idrd` AS `Idrd`,`b`.`rdeu_idct` AS `rdeu_idct` from ((((`vpdtespagocompras` `s` join `fe_prov` `z` on((`z`.`idprov` = `s`.`rdeu_idpr`))) join `fe_deu` `a` on((`a`.`iddeu` = `s`.`ncontrol`))) join `fe_rdeu` `b` on((`b`.`rdeu_idrd` = `a`.`deud_idrd`))) left join `fe_rcom` `c` on((`c`.`idauto` = `b`.`rdeu_idau`))) order by `s`.`fevto` */;

/*View structure for view vpdtespagocompras */

/*!50001 DROP TABLE IF EXISTS `vpdtespagocompras` */;
/*!50001 DROP VIEW IF EXISTS `vpdtespagocompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpdtespagocompras` AS select cast(sum((`d`.`impo` - `d`.`acta`)) as decimal(12,2)) AS `saldo`,`d`.`ncontrol` AS `ncontrol`,max(`d`.`fevto`) AS `fevto`,`r`.`rdeu_idpr` AS `rdeu_idpr`,`r`.`rdeu_mone` AS `rdeu_mone` from (`fe_rdeu` `r` join `fe_deu` `d` on((`d`.`deud_idrd` = `r`.`rdeu_idrd`))) where ((`d`.`acti` = 'A') and (`r`.`rdeu_Acti` = 'A')) group by `r`.`rdeu_idpr`,`d`.`ncontrol`,`r`.`rdeu_mone` having (`saldo` <> 0) */;

/*View structure for view vrcompras */

/*!50001 DROP TABLE IF EXISTS `vrcompras` */;
/*!50001 DROP VIEW IF EXISTS `vrcompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vrcompras` AS select `c`.`ndoc` AS `ndoc`,`c`.`valor` AS `valor`,`c`.`igv` AS `igv`,`c`.`impo` AS `impo`,`c`.`pimpo` AS `pimpo`,`c`.`fech` AS `fech`,`c`.`fecr` AS `fecr`,`c`.`form` AS `form`,`c`.`exon` AS `exon`,`c`.`ndo2` AS `ndo2`,`c`.`idauto` AS `idauto`,`c`.`deta` AS `deta`,`c`.`tcom` AS `tcom`,`c`.`vigv` AS `vigv`,`c`.`idprov` AS `idprov`,`c`.`tdoc` AS `tdoc`,`c`.`dolar` AS `dolar`,`c`.`mone` AS `mone`,`p`.`razo` AS `razo`,`p`.`dire` AS `dire`,`p`.`ciud` AS `ciud`,`p`.`nruc` AS `nruc`,ifnull(`x`.`idcaja`,0) AS `Idcaja`,`c`.`codt` AS `codt`,`c`.`fusua` AS `fusua`,`w`.`nomb` AS `Usuario` from (((`fe_rcom` `c` join `fe_prov` `p` on((`p`.`idprov` = `c`.`idprov`))) left join `fe_caja` `x` on((`x`.`idauto` = `c`.`idauto`))) join `fe_usua` `w` on((`w`.`idusua` = `c`.`idusua`))) where ((`c`.`tipom` = 'C') and (`c`.`acti` <> 'I')) */;

/*View structure for view vsaldosctaspagar */

/*!50001 DROP TABLE IF EXISTS `vsaldosctaspagar` */;
/*!50001 DROP VIEW IF EXISTS `vsaldosctaspagar` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vsaldosctaspagar` AS select `a`.`rdeu_idrd` AS `rdeu_idrd`,sum((`b`.`impo` - `b`.`acta`)) AS `Saldo`,`b`.`ncontrol` AS `ncontrol` from (`fe_rdeu` `a` join `fe_deu` `b` on((`b`.`deud_idrd` = `a`.`rdeu_idrd`))) where ((`a`.`rdeu_Acti` <> 'I') and (`b`.`acti` <> 'I')) group by `b`.`ncontrol` */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
