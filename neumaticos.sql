/*
SQLyog Professional v12.09 (64 bit)
MySQL - 5.1.34-community : Database - bdn2020
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`bdn2020` /*!40100 DEFAULT CHARACTER SET latin1 */;

/* Trigger structure for table `fe_art` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `Productos` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `Productos` AFTER UPDATE ON `fe_art` FOR EACH ROW begin
if old.cost<>new.cost then
    insert into fe_aproductos(prod_idar,prod_idus,prod_fope)values(old.idart,new.prod_uact,localtime);
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_caja` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `Hcaja` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `Hcaja` AFTER UPDATE ON `fe_caja` FOR EACH ROW begin
if new.acti='I' then
  insert fe_acaja(fech,usuario,detalle,hora,importe,autorizo,moneda,acaj_idca)
  values(curdate(),old.usua,concat(old.deta),curtime(),old.impo,old.usua,old.tmon,old.idcaja);
end if;
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

/* Trigger structure for table `fe_rcom` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaMvtos` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaMvtos` AFTER UPDATE ON `fe_rcom` FOR EACH ROW BEGIN
if new.acti='I' then
   update fe_caja set acti='I' where idauto=old.idauto;
   update fe_kar set acti='I' where idauto=old.idauto;
      if old.idprov>0 then
        update fe_rdeu set rdeu_acti='I' where rdeu_idau=old.idauto;
        update fe_rcon set rcon_acti='I' where idauto=old.idauto;
     else
      update fe_cred set acti='I' where idauto=old.idauto;
      update fe_rven set acti='I' where idauto=old.idauto;
   end if;
   insert into fe_aresumen(lres_fech,lres_idau,lres_idus,lres_tipo,lres_deta)values(localtime,old.idauto,new.idusua1,'A','Anulada');
 else
   if new.idusua1>0 then
      insert into fe_aresumen(lres_fech,lres_idau,lres_idus,lres_tipo,lres_deta)values(localtime,old.idauto,new.idusua1,'E','Modificado');
   end if;
end if;
END */$$


DELIMITER ;

/* Trigger structure for table `fe_rcon` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaRCompras` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaRCompras` AFTER UPDATE ON `fe_rcon` FOR EACH ROW begin
if new.rcon_acti='I' then
  update fe_refe set acti='I' where idrcon=old.idrcon;
  update fe_ectasc set ecta_acti='I' where idrcon=old.idrcon;
  update fe_lcaja  set lcaj_acti='I' where lcaj_idau=old.idrcon;
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_rcon` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `BorrarCompras` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `BorrarCompras` AFTER DELETE ON `fe_rcon` FOR EACH ROW begin
delete from fe_ectasc where idrcon=old.idrcon;
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
  update fe_lcaja set lcaj_acti='I' where lcaj_idau=old.idrven;
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_rven` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `BorrarRVTas` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `BorrarRVTas` AFTER DELETE ON `fe_rven` FOR EACH ROW begin
delete from fe_ectas  where idrven=old.idrven;
end */$$


DELIMITER ;

/* Function  structure for function  `DCorrelativo` */

/*!50003 DROP FUNCTION IF EXISTS `DCorrelativo` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `DCorrelativo`(nm integer,ctipo char) RETURNS varchar(20) CHARSET latin1
BEGIN
declare nauto integer;
declare cmes varchar(45);
declare nb varchar(20);
declare cauto varchar(20);
DECLARE CONTINUE HANDLER FOR NOT FOUND SET cauto='',nauto=0,cmes='';
if ctipo='C' then
   update fe_autos set autogc=autogc+1 where idautos=nm;
   SELECT autogc,mess into nauto,cmes FROM fe_autos WHERE idautos=nm;
  else
   update fe_autos set autogv=autogv+1 where idautos=nm;
   SELECT autogv,mess into nauto,cmes FROM fe_autos WHERE idautos=nm;
end if;
lbl: loop
   set nb=concat(concat(left(cmes,3),'-'),righT(concat('00000000',trim(convert(nauto,char))),8));
   if ctipo='C' then
       SELECT auto into cauto FROM fe_rcon WHERE auto=nb and month(fecr)=nm;
     else
       SELECT auto into cauto FROM fe_rven WHERE auto=nb and month(fech)=nm;
   end if;
   IF cauto<>'' then
      if ctipo='C' then
         update fe_autos set autogc=nauto+1 where idautos=nm;
        else
         update fe_autos set autogv=nauto+1 where idautos=nm;
      end if;
      set nauto=nauto+1;
      iterate lbl;
     ELSE
       leave lbl;
   end if;
end loop lbl;
return nb;
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

/* Function  structure for function  `FunBuscaNombre` */

/*!50003 DROP FUNCTION IF EXISTS `FunBuscaNombre` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunBuscaNombre`(ct varchar(50),cb varchar(100),nid integer) RETURNS int(2)
BEGIN
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
case
when trim(ct)="Clientes" then
     if nid=0 then
         Select idclie into vdvto From fe_clie Where Trim(razo)=cb And clie_acti<>'I';
     else
   	    Select idclie into vdvto From fe_clie Where Trim(razo)=cb And idclie<>nid And clie_acti<>'I';
     end if;
when trim(ct)="Proveedores" then
     if nid=0 then
         Select idprov into vdvto From fe_prov Where Trim(razo)=cb And prov_acti<>'I';
     else
   	    Select idprov into vdvto From fe_prov Where Trim(razo)=cb And idprov<>nid And prov_acti<>'I';
     end if;
when trim(ct)="Productos" then
     if nid=0 then
         Select idart into vdvto From fe_art Where Trim(descri)=cb And prod_acti<>'I';
     else
   	    Select idart into vdvto From fe_art Where Trim(descri)=cb And idart<>nid And prod_acti<>'I';
     end if;
when trim(ct)="Marcas" then
     if nid=0 then
         Select idmar into vdvto From fe_mar Where Trim(dmar)=cb And marc_acti<>'I';
     else
   	    Select idmar into vdvto From fe_mar Where Trim(dmar)=cb And idmar<>nid And marc_acti<>'I';
     end if;
when trim(ct)="Lineas" then
     if nid=0 then
         Select idcat into vdvto From fe_cat Where Trim(dcat)=cb And line_acti<>'I';
     else
   	    Select idcat into vdvto From fe_cat Where Trim(dcat)=cb And idcat<>nid And line_acti<>'I';
     end if;
when trim(ct)="Grupos" then
     if nid=0 then
         Select idgrupo into vdvto From fe_grupo Where Trim(desgrupo)=cb And grup_acti<>'I';
     else
   	    Select idgrupo into vdvto From fe_grupo Where Trim(desgrupo)=cb And idgrupo<>nid And grup_acti<>'I';
     end if;
when trim(ct)="Presentaciones" then
     if nid=0 then
         Select pres_idpr into vdvto From fe_presentaciones Where Trim(pres_desc)=cb And pres_acti<>'I';
     else
   	    Select pres_idpr into vdvto From fe_presentaciones Where Trim(pres_desc)=cb And pres_idpr<>nid And pres_acti<>'I';
     end if;
when trim(ct)="Usuarios" then
     if nid=0 then
         Select idusua into vdvto From fe_usua Where Trim(nomb)=cb And activo<>'N';
     else
   	    Select idusua into vdvto From fe_usua Where Trim(nomb)=cb And idusua<>nid And activo<>'N';
     end if;
when trim(ct)="Empleados" then
     if nid=0 then
         Select empl_idem into vdvto From fe_empl Where Trim(empl_nomb)=cb And empl_acti<>'N';
     else
   	    Select empl_idem into vdvto From fe_empl Where Trim(empl_nomb)=cb And empl_idem<>nid And emp_acti<>'N';
     end if;
     end case;
if vdvto>0 then
   return 0;
else
   return 1;
end if;
END */$$
DELIMITER ;

/* Function  structure for function  `FunBuscaRucCliente` */

/*!50003 DROP FUNCTION IF EXISTS `FunBuscaRucCliente` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunBuscaRucCliente`(cruc varchar(11)) RETURNS int(11)
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

/* Function  structure for function  `FunCreaActivos` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaActivos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaActivos`(cdesc varchar(180),nvalor decimal(12,2),cdeta varchar(150)) RETURNS int(11)
BEGIN
declare nid integer default 0;
INSERT  INTO fe_activos(acti_desc,acti_valor,acti_deta)
values(cdesc,nvalor,cdeta);
select last_insert_id() into nid from fe_tra group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaBancos` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaBancos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaBancos`(cnombre varchar(100),nidco varchar(2)) RETURNS int(11)
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
nidusua integer,cpc varchar(50)) RETURNS int(11)
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

/*!50003 CREATE FUNCTION `FunCreaCLientecd`(cruc VARCHAR(11),crazo VARCHAR(100),
cdire VARCHAR(100),cciud VARCHAR(100),cfono VARCHAR(15),cfax VARCHAR(15),cdni VARCHAR (11),
ctipo CHAR,cemail VARCHAR(100),nidven INTEGER,nidus INTEGER,cpc VARCHAR(45),ccelu VARCHAR(15),
crefe VARCHAR(255),linea FLOAT,crpm VARCHAR(10),nidz INTEGER,nidop INTEGER,
cdist VARCHAR(100),cdire1 VARCHAR(100),cciud1 VARCHAR(100)) RETURNS int(11)
BEGIN
DECLARE nid INTEGER DEFAULT 0;
INSERT INTO fe_clie(nruc,razo,dire,ciud,fono,fax,ndni,clie_tipo,clie_corr,
clie_codv,clie_idus,idpcclie,
fechclie,celu,refe,clie_lcre,clie_rpm,clie_idzo,clie_idpt,clie_dist,clie_dir1,clie_ciu1)
VALUES (cruc,crazo,cdire,cciud,cfono,cfax,cdni,ctipo,cemail,nidven,nidus,cpc,
LOCALTIME,ccelu,crefe,linea,crpm,nidz,nidop,cdist,cdire1,cciud1);
SELECT LAST_INSERT_ID() INTO nid FROM fe_clie GROUP BY LAST_INSERT_ID();
RETURN nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaCtasBancos` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaCtasBancos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaCtasBancos`(cta varchar(100),idb1 integer,cmone char,cdeta varchar(100),nidctap integer) RETURNS int(11)
BEGIN
declare idb integer;
insert into fe_ctasb(ctas_ctas,ctas_idba,ctas_mone,ctas_deta,ctas_ncta)
values(cta,idb1,cmone,cdeta,nidctap);
select last_insert_id() into idb from fe_ctasb group by last_insert_id();
return idb;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaEmpleado` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaEmpleado` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaEmpleado`(crazo varchar(150),
cfono varchar(20),nsueldo decimal(12,2),nidus integer,cidpc varchar(45),crefe varchar(80),cndni varchar(20),ctipo varchar(2)) RETURNS int(11)
BEGIN
declare nid integer;
INSERT INTO fe_empl(empl_nomb,empl_fono,empl_suel,empl_idus,empl_fech,empl_idpc,empl_refe,empl_ndni,empl_tipo)
VALUES (crazo,cfono,nsueldo,nidus,localtime,cidpc,crefe,cndni,ctipo);
select last_insert_id() into nid from fe_empl group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FuncreaIngresochequesCr` */

/*!50003 DROP FUNCTION IF EXISTS `FuncreaIngresochequesCr` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FuncreaIngresochequesCr`(nidch integer,nidcr integer) RETURNS int(11)
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

/*!50003 CREATE FUNCTION `FunCreaPlanCuentas`(cn varchar(8),cdes varchar(60),
cdd varchar(8),cdh varchar(8),cuenta varchar(12),cope char) RETURNS int(11)
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
nidusua integer,cpc varchar(50)) RETURNS int(11)
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_prov(nruc,razo,dire,ciud,fono,fax,fechprov,idusua,idpcprov,refe,email,celu)
VALUES (cruc,crazon,cdire,cciud,cfono,cfax,localtime,nidusua,cpc,crefe,cemail,ccelu);
select last_insert_id() into nid from fe_prov group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaTransportista` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaTransportista` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaTransportista`(cplaca varchar(10),crazo varchar(50),
cdir varchar(50),nruc varchar(11),chofe varchar(50),cbreve varchar(25),
cmarca varchar(50),ccons varchar(40),nidus integer,cplaca1 varchar(10)) RETURNS int(11)
BEGIN
declare nid integer default 0;
INSERT  INTO fe_tra(placa,razon,dirtr,ructr,nombr,breve,marca,cons,tran_idus,placa1)
values(cplaca,crazo,cdir,nruc,chofe,cbreve,cmarca,ccons,nidus,cplaca1);
select last_insert_id() into nid from fe_tra group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaTransportista1` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaTransportista1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaTransportista1`(cplaca varchar(10),crazo varchar(50),
cdir varchar(50),nruc varchar(11),chofe varchar(50),cbreve varchar(25),
cmarca varchar(50),ccons varchar(40),nidus integer,cplaca1 varchar(10),nprop integer) RETURNS int(11)
BEGIN
declare nid integer default 0;
INSERT  INTO fe_tra(placa,razon,dirtr,ructr,nombr,breve,marca,cons,tran_idus,placa1,tran_prop)
values(cplaca,crazo,cdir,nruc,chofe,cbreve,cmarca,ccons,nidus,cplaca1,nprop);
select last_insert_id() into nid from fe_tra group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaVendedor` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaVendedor` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaVendedor`(cvendedor varchar(100),nidusua integer,
pc varchar(60),ccorreo varchar(100),cfono varchar(100),cdni varchar(100)) RETURNS int(11)
BEGIN
declare nid integer default 0;
INSERT INTO fe_vend(nomv,fechvend,vend_idus,idpcvend,vend_corr,vend_fono,vend_ndni)
    VALUES (cvendedor,localtime,nidusua,pc,ccorreo,cfono,cdni);
select last_insert_id() into nid from fe_vend group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunDetalleGuiaVentas` */

/*!50003 DROP FUNCTION IF EXISTS `FunDetalleGuiaVentas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunDetalleGuiaVentas`(nidk INTEGER,ncant FLOAT,nidg INTEGER) RETURNS int(11)
BEGIN
DECLARE idg INTEGER DEFAULT 0;
INSERT INTO fe_ent(entr_idkar,entr_cant,entr_idgu)VALUES(nidk,ncant,nidg);
SELECT LAST_INSERT_ID() INTO idg FROM fe_ent GROUP BY LAST_INSERT_ID();
RETURN idg;
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

/*!50003 CREATE FUNCTION `FunHayCompra`(cdcto varchar(12),ctdoc varchar(2),idp integer,nidauto integer) RETURNS int(11)
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

/* Function  structure for function  `FunHayTraspaso` */

/*!50003 DROP FUNCTION IF EXISTS `FunHayTraspaso` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunHayTraspaso`(cdcto varchar(10),ctdoc varchar(2)) RETURNS int(11)
BEGIN
declare sw integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET sw=0;
select idauto into sw from fe_rcom where ndoc=cdcto and tdoc=ctdoc and tcom='T' and acti<>'I';
return sw;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngGuias` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngGuias` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngGuias`(dfech date,idauto integer,cptop varchar(150),
cptoll varchar(150),nidclie integer,dfect date,nidus integer,nidtra integer,cndoc varchar(10),nidtda integer) RETURNS int(11)
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
caten varchar(80),cforma varchar(80),cplazo varchar(80),cvalidez varchar(80),centrega varchar(80),cdetalle varchar(150),cmone char) RETURNS int(11)
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
ctdoc VARCHAR(2),cform CHAR,cndoc VARCHAR(12),dfecha DATE,dfechar DATE,cdetalle VARCHAR(220),
nv DECIMAL(12,2),nigv DECIMAL(12,2),nt DECIMAL(12,2),cndo2 VARCHAR(10),cm CHAR,
ndolar DECIMAL(6,4),ni DECIMAL(6,4),ctg CHAR,ccodp INTEGER,cmvto CHAR,nus INTEGER,opt INTEGER,nidcodt INTEGER,
n1 INTEGER,n2 INTEGER,n3 INTEGER,ngratuitas DECIMAL(8,2),idtr DECIMAL(10,2)) RETURNS int(11)
BEGIN
DECLARE nid,ntdoc INTEGER;
DECLARE ctipo CHAR;
SET ntdoc=0;
SET nid=0;
SELECT idtdoc INTO ntdoc FROM fe_tdoc WHERE tdoc=ctdoc GROUP BY idtdoc;
IF opt=0 THEN
    IF (ctdoc='01' OR ctdoc='09' OR ctdoc='II' OR ctdoc='07' OR ctdoc='08') AND UCASE(ctg)='K' THEN
      SET ctipo='C';
     ELSE
      SET ctipo='I';
   END IF;
   INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,dolar,vigv,tcom,idprov,tipom,fusua,idusua,codt,rcom_tipo)
   VALUES (ctdoc,cform,cndoc,dfecha,dfechar,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,ctg,ccodp,cmvto,LOCALTIME,nus,nidcodt,ctipo);
   SELECT LAST_INSERT_ID() INTO nid FROM fe_rcom GROUP BY LAST_INSERT_ID();
   IF n1>0 AND n2>0 AND n3>0 THEN
   CALL ProIngresaRcompras(ccodp,ntdoc,cform,cndoc,dfecha,dfecha,cm,ndolar,ni,cdetalle,dfecha,nidcodt,ctg,nus,nv,nigv,nt,n1,n2,n3,nid);
   END IF;
ELSE
  IF ctdoc='20' THEN
      SET ctipo='I';
    ELSE
      SET ctipo='C';
   END IF;
   INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,dolar,vigv,tcom,idcliente,tipom,fusua,idusua,codt,pimpo,rcom_tipo,rcom_otro)
   VALUES (ctdoc,cform,cndoc,dfecha,dfecha,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,ctg,ccodp,cmvto,LOCALTIME,nus,nidcodt,idtr,ctipo,ngratuitas);
   SELECT LAST_INSERT_ID() INTO nid FROM fe_rcom GROUP BY LAST_INSERT_ID();
    IF n1>0 AND n2>0 AND n3>0 THEN
   CALL ProIngresaRVentas(ccodp,ntdoc,cform,cndoc,dfecha,dfecha,dfecha,cm,ndolar,ni,nid,nus,nv,nigv,nt,n1,n2,n3,idtr);
    END IF;
END IF;
RETURN nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FUNingresaCabeceraGratuito` */

/*!50003 DROP FUNCTION IF EXISTS `FUNingresaCabeceraGratuito` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FUNingresaCabeceraGratuito`(
ctdoc varchar(2),cform char,cndoc varchar(12),dfecha date,dfechar date,cdetalle varchar(220),
nv decimal(12,2),nigv decimal(12,2),nt decimal(12,2),cndo2 varchar(10),cm char,
ndolar decimal(6,4),ni decimal(6,4),ctg char,ccodp integer,cmvto char,nus integer,opt integer,nidcodt integer,
n1 integer,n2 integer,n3 integer,nitem integer,idtr decimal(10,2)) RETURNS int(11)
BEGIN
declare nid,ntdoc integer;
declare ctipo char;
set ntdoc=0;
set nid=0;
select idtdoc into ntdoc from fe_tdoc where tdoc=ctdoc group by idtdoc;
 if ctdoc='20' then
      set ctipo='I';
    else
      set ctipo='C';
   end if;
   INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,rcom_otro,ndo2,mone,dolar,vigv,tcom,idcliente,tipom,fusua,idusua,codt,pimpo,rcom_tipo)
   VALUES (ctdoc,cform,cndoc,dfecha,dfecha,cdetalle,nv,cndo2,cm,ndolar,ni,ctg,ccodp,cmvto,localtime,nus,nidcodt,idtr,ctipo);
   select last_insert_id() into nid from fe_rcom group by last_insert_id();
   call ProIngresaRVentas(ccodp,ntdoc,cform,cndoc,dfecha,dfecha,dfecha,cm,ndolar,ni,nid,nus,nv,nigv,nt,n1,n2,n3,-1);
 return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCabeceraTraspaso` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCabeceraTraspaso` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCabeceraTraspaso`(
ctdoc VARCHAR(2),cform CHAR,cndoc VARCHAR(10),dfecha DATE,dfechar DATE,cdetalle VARCHAR(120),
nv DECIMAL(12,2),nigv DECIMAL(12,2),nt DECIMAL(12,2),cndo2 VARCHAR(10),cm CHAR,
ndolar DECIMAL(6,4),ni DECIMAL(6,4),ctg CHAR,ccodp INTEGER,cmvto CHAR,nus INTEGER,opt INTEGER,nidcodt INTEGER,
n1 INTEGER,n2 INTEGER,n3 INTEGER,nitem INTEGER,npvta DECIMAL(12,2),cestado CHAR) RETURNS int(11)
BEGIN
DECLARE nid INTEGER;
SET nid=0;
INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,dolar,vigv,tcom,idcliente,tipom,fusua,idusua,codt,rcom_reci)
VALUES (ctdoc,cform,cndoc,dfecha,dfecha,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,ctg,ccodp,cmvto,LOCALTIME,nus,nidcodt,cestado);
SELECT LAST_INSERT_ID() INTO nid FROM fe_rcom GROUP BY LAST_INSERT_ID();
RETURN nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCaja` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCaja` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCaja`(
na integer,dfecha date,nt1 float,cmvtoc char,cform char,cm1 char,cndoc varchar(12),nidcon integer,
cu integer,cdetalle varchar(120),cor varchar(2),nimp1 float,cm2 char,tcvta float,nidcodt integer,cajas char,nidcr integer,ide integer) RETURNS int(11)
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
haber decimal(12,2),norden integer,nidclpr integer) RETURNS int(11)
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
haber decimal(12,2),norden integer,nidclpr integer) RETURNS int(11)
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
haber decimal(12,2),norden integer,nidclpr integer) RETURNS int(11)
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
dfechac date,cmone char,nimpo float,nidch integer,nidus integer) RETURNS int(11)
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
nauto integer,nidcl integer,cndoc varchar(12),cest char,cmon char,crefe varchar(120),
dfecha date,dfevto date,ctipo char,cdocp varchar(12),ndolar float,csitua varchar(2),
nimpo float,ni float,idven integer,nimpoo float,cusua integer,nidaval integer,ndscto float,
cpc varchar(50),nidcodt integer,nidch integer,nidch1 integer) RETURNS int(11)
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

/* Function  structure for function  `FunIngresaCreditosx` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCreditosx` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCreditosx`(
nauto INTEGER,nidcl INTEGER,cndoc VARCHAR(12),cest CHAR,cmon CHAR,crefe VARCHAR(120),
dfecha DATE,dfevto DATE,ctipo CHAR,cdocp VARCHAR(12),ndolar FLOAT,csitua VARCHAR(2),
nimpo FLOAT,ni FLOAT,idven INTEGER,nimpoo FLOAT,cusua INTEGER,nidaval INTEGER,ndscto FLOAT,
cpc VARCHAR(50),nidcodt INTEGER,nidch INTEGER,nidch1 INTEGER,nidrc INTEGER) RETURNS int(11)
BEGIN
DECLARE nid INTEGER;
SET nid=0;
INSERT INTO fe_cred(idauto,idclie,ndoc,estd,mone,banc,fech,fevto,tipo,docd,dola,situa,impo,
inic,idven,impc,idusua,idaval,dscto,cre_idpc,cre_fope,codt,cre_idrc,cre_idch,cred_idrc)VALUES(nauto,nidcl,cndoc,cest,cmon,crefe,dfecha,dfevto,
ctipo,cdocp,ndolar,csitua,nimpo,ni,idven,nimpoo,cusua,nidaval,ndscto,cpc,CURDATE(),nidcodt,nidch,nidch1,nidrc);
SELECT LAST_INSERT_ID() INTO nid FROM fe_cred GROUP BY LAST_INSERT_ID();
UPDATE fe_cred SET ncontrol=nid,inic=ni WHERE idcred=nid;
RETURN nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCtasCtesC` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCtasCtesC` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCtasCtesC`(nid integer,dfech date,nidlc integer,ct char,nimpo float,mone char,idpr integer) RETURNS int(11)
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

/*!50003 CREATE FUNCTION `FunIngresaCtasCtesV`(nid integer,dfech date,nidlc integer,ct char,nimpo float,mone char,idcl integer) RETURNS int(11)
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

/* Function  structure for function  `FunIngresaDatosLcajaE` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDatosLcajaE` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDatosLcajaE`(dfecha datetime,cndoc varchar(10),cdeta varchar(100),idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),cmone char,ndolar decimal(5,3),nidus integer,nidcp integer) RETURNS int(11)
begin
declare id integer;
insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,lcaj_idus,lcaj_clpr)values
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp);
select last_insert_id() into id from fe_lcaja group by last_insert_id();
return id;
end */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaDatosLibroDiario` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDatosLibroDiario` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDatosLibroDiario`(dfech datetime,ndebe decimal(12,2),nhaber decimal(12,2),cglosa varchar(200),
ct char(1),cnume varchar(14),nidcta integer,ccond char,nit integer,ncomp varchar(15),nidcl integer,
nidpr integer,cmone char,ctran char,nimtd decimal (12,2),nimth decimal(12,2)) RETURNS int(11)
BEGIN
declare iddiario integer default 0;
insert into fe_ldiario(ldia_fech,ldia_debe,ldia_haber,ldia_glosa,ldia_tipo,
ldia_nume,ldia_idcta,ldia_cond,ldia_item,ldia_comp,ldia_idcv,ldia_idcc,ldia_mone,ldia_tran,ldia_itrd,ldia_itrh)
values(dfech,ndebe,nhaber,cglosa,ct,cnume,nidcta,ccond,nit,ncomp,nidcl,nidpr,cmone,ctran,nimtd,nimth);
select last_insert_id() into iddiario from fe_ldiario group by last_insert_id();
return iddiario;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaDatosLibroDiarioPle5` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDatosLibroDiarioPle5` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDatosLibroDiarioPle5`(dfech datetime,ndebe decimal(12,2),
nhaber decimal(12,2),cglosa varchar(120),ct char(1),cnume varchar(12),nidcta integer,ccond char,nit integer,ncomp varchar(15),
nidcl integer,nidpr integer,cmone char,ctran char,nimtd decimal (12,2),nimth decimal(12,2),ctdoc varchar(2)) RETURNS int(11)
BEGIN
declare iddiario integer default 0;
insert into fe_ldiario(ldia_fech,ldia_debe,ldia_haber,ldia_glosa,ldia_tipo,
ldia_nume,ldia_idcta,ldia_cond,ldia_item,ldia_comp,ldia_idcv,ldia_idcc,ldia_mone,ldia_tran,ldia_itrd,ldia_itrh,ldia_tdoc)
values(dfech,ndebe,nhaber,cglosa,ct,cnume,nidcta,ccond,nit,ncomp,nidcl,nidpr,cmone,ctran,nimtd,nimth,ctdoc);
select last_insert_id() into iddiario from fe_ldiario group by last_insert_id();
return iddiario;
END */$$
DELIMITER ;

/* Function  structure for function  `FuningresaDCotizacion` */

/*!50003 DROP FUNCTION IF EXISTS `FuningresaDCotizacion` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FuningresaDCotizacion`(ncoda integer,ncant float,nprec float,nidauto integer) RETURNS int(11)
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
cdeta varchar(80),csitua varchar(2)) RETURNS int(11)
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
nimpo float,cusua integer,cpc varchar(50),nidcodt integer) RETURNS int(11)
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

/*!50003 CREATE FUNCTION `FunIngresaDPedidos`(ncoda integer,ncant float,nprec float,nidauto integer) RETURNS int(11)
BEGIN
declare id integer default 0;
INSERT INTO fe_ped(idart,cant,prec,idautop)
VALUES(ncoda,ncant,nprec,nidauto);
select last_insert_id() into id from fe_ped group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaGuias` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaGuias` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaGuias`(dfecha DATETIME,cptop VARCHAR(100),cptoll VARCHAR(150),nidauto INTEGER,
dfechat DATETIME,nidus INTEGER,cdeta VARCHAR(150),nidtr INTEGER,cndoc VARCHAR(12),nidtda INTEGER,cubigeo VARCHAR(8)) RETURNS int(11)
BEGIN
DECLARE id INTEGER;
INSERT INTO fe_guias(guia_fech,guia_ptop,guia_ptoll,guia_idau,guia_fect,guia_idus,guia_fope,guia_deta,guia_idtr,guia_ndoc,guia_moti,guia_codt,guia_ubig)
VALUES(dfecha,cptop,cptoll,nidauto,dfechat,nidus,LOCALTIME,cdeta,nidtr,cndoc,'V',nidtda,cubigeo);
SELECT LAST_INSERT_ID() INTO id FROM  fe_guias GROUP BY LAST_INSERT_ID();
RETURN id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaGuiasT` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaGuiasT` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaGuiasT`(`dfecha` DATETIME, `cptop` VARCHAR(100), `cptoll` VARCHAR(150), `nidauto` INTEGER, `dfechat` DATETIME, `nidus` INTEGER, `cdeta` VARCHAR(150), `nidtr` INTEGER, `cndoc` VARCHAR(12), `nidt` INTEGER,
cubiego VARCHAR(8)) RETURNS int(11)
BEGIN
DECLARE id INTEGER;
INSERT INTO fe_guias(guia_fech,guia_ptop,guia_ptoll,guia_idau,guia_fect,guia_idus,guia_fope,guia_deta,
guia_idtr,guia_ndoc,guia_moti,guia_codt,guia_ubig)
VALUES(dfecha,cptop,cptoll,nidauto,dfechat,nidus,LOCALTIME,cdeta,nidtr,cndoc,'T',nidt,cubiego);
SELECT LAST_INSERT_ID() INTO id FROM  fe_guias GROUP BY LAST_INSERT_ID();
RETURN id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaKardex` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaKardex` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaKardex`(nid INTEGER,cc INTEGER,ct CHAR,npr FLOAT,
nct FLOAT,cincl CHAR,tmvto CHAR,ccodv INTEGER,calma INTEGER,costo DECIMAL(8,4),vcom FLOAT,nper DECIMAL(5,2)) RETURNS int(11)
BEGIN
DECLARE nidk INTEGER DEFAULT 0;
INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,ttip,incl,alma,codv)
VALUES (nid,cc,ct,npr,nct,tmvto,cincl,calma,ccodv);
SELECT LAST_INSERT_ID() INTO nidk FROM fe_kar GROUP BY LAST_INSERT_ID();
RETURN nidk;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaKardex1` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaKardex1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaKardex1`(nid integer,cc integer,ct char,npr float,
nct float,cincl char,tmvto char,ccodv integer,calma integer,nidcosto1 integer,vcom float) RETURNS int(11)
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

/*!50003 CREATE FUNCTION `FunIngresaKardex2`(nid INTEGER,cc INTEGER,ct CHAR,npr FLOAT,
nct FLOAT,cincl CHAR,tmvto CHAR,ccodv INTEGER,calma INTEGER,costo DECIMAL(8,4),vcom FLOAT,nper DECIMAL(5,2)) RETURNS int(11)
BEGIN
DECLARE nidk INTEGER DEFAULT 0;
IF ct='C' THEN
  INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,ttip,incl,alma,codv)
  VALUES (nid,cc,ct,npr,nct,tmvto,cincl,calma,ccodv);
 ELSE
  INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,ttip,incl,alma,codv,kar_perc,kar_cost)
  VALUES (nid,cc,ct,npr,nct,tmvto,cincl,calma,ccodv,nper,costo);
END IF;
SELECT LAST_INSERT_ID() INTO nidk FROM fe_kar GROUP BY LAST_INSERT_ID();
RETURN nidk;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaKardexGratuito` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaKardexGratuito` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaKardexGratuito`(nid integer,cc integer,ct char,npr float,
nct float,cincl char,tmvto char,ccodv integer,calma integer,nidcosto1 decimal(12,2),vcom float) RETURNS int(11)
BEGIN
declare nidk integer default 0;
INSERT INTO fe_kar(idauto,idart,tipo,kar_cost,cant,ttip,incl,alma,codv)
VALUES (nid,cc,ct,npr,nct,tmvto,cincl,calma,ccodv);
select last_insert_id() into nidk from fe_kar group by last_insert_id();
return nidk;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaND` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaND` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaND`(dfecha date,ctdoc varchar(2),cserie1 varchar(4),
cndoc varchar(15),nvalor decimal(12,2),notro decimal(12,2),nimpo decimal(12,2),
ctdoc1 varchar(2),cserie varchar(4),naño integer,cndoc1 varchar(15),
nrete decimal(12,2),cmone varchar(3),ndola decimal(6,4),npais integer,
ncodp1 integer,ncodp2 integer,npais1 integer,cvinculo varchar(2),nrentab decimal(12,2),
ncosto decimal(12,2),nrentan decimal(12,2),vrenta decimal(12,2),nreten decimal(12,2),
cconvenio varchar(2),nexon integer,ntrta varchar(2),modo integer,
naplica integer,dfechar date) RETURNS int(11)
begin
declare nid integer default 0;
insert into fe_rcom11(com1_fech,com1_tdoc,com1_ser1,com1_ndoc,com1_valo,com1_otro,
  com1_impo,com1_tdoc1,com1_serie1,com1_año,com1_ndoc1,com1_rete,com1_mone,com1_dola,
  com1_pais,com1_codp,com1_codp1,com1_pais1,com1_vinc,com1_renta,com1_cost,com1_rneta,
  com1_vrenta,com1_irete,com1_conv,com1_exon,com1_trta,com1_modo,com1_aplica,com1_fecr)
values(dfecha,ctdoc,cserie1,cndoc,nvalor,notro,nimpo,ctdoc1,cserie,naño,cndoc1,
  nrete,cmone,ndola,npais,ncodp1,ncodp2,npais1,cvinculo,nrentab,ncosto,nrentan,vrenta,
   nreten,cconvenio,nexon,ntrta,modo,naplica,dfechar);
select last_insert_id() into nid from fe_rcom11 group by last_insert_id();
return nid;
end */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaOtrasCompras` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaOtrasCompras` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaOtrasCompras`(nidprov integer,
ctdoc integer,cform char,cndoc varchar(12),dfecha date,dfechar date,cmon char,ndolar float,nigv1 float,cdetalle varchar(80),
nauto varchar(20),dfevto date,nidalma integer,ctipo char,cusua varchar(45),autorc integer) RETURNS int(11)
BEGIN
declare id integer;
INSERT INTO fe_rcon(idprov,idtdoc,form,ndoc,fech,fecr,mone,dolar,vigv,detalle,auto,fevto,idalma,tipo,usua,fusua,idauto)
values(nidprov,ctdoc,cform,cndoc,dfecha,dfechar,cmon,ndolar,nigv1,cdetalle,nauto,dfevto,nidalma,ctipo,cusua,localtime,autorc);
select last_insert_id() into id from fe_rcon group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaOtrasCompras1` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaOtrasCompras1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaOtrasCompras1`(nidprov integer,
ctdoc integer,cform char,cndoc varchar(12),dfecha date,dfechar date,cmon char,ndolar float,nigv1 float,cdetalle varchar(80),
nauto varchar(20),dfevto date,nidalma integer,ctipo char,cusua varchar(45),autorc integer,nidactivo integer) RETURNS int(11)
BEGIN
declare id integer;
INSERT INTO fe_rcon(idprov,idtdoc,form,ndoc,fech,fecr,mone,dolar,vigv,detalle,auto,fevto,idalma,tipo,usua,fusua,idauto,rcom_idac)
values(nidprov,ctdoc,cform,cndoc,dfecha,dfechar,cmon,ndolar,nigv1,cdetalle,nauto,dfevto,nidalma,ctipo,cusua,localtime,autorc,nidactivo);
select last_insert_id() into id from fe_rcon group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaPagosCreditos` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosCreditos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosCreditos`(nidclie integer,cndoc varchar(12),
cdocp varchar(12),nacta float,cesta char,cmone char,cb1 varchar(80),
dfech date,dfevto date,ctipo char,ndola float,cbco varchar(40),csitua varchar(2),
nimpc float,nctrl integer,nidven integer,nu integer,cnrou varchar(60),
nauto integer,nidaval integer,cfo CHAR,ndscto float,cpc varchar(45),nidtda integer,nidch integer,nidch1 integer) RETURNS int(11)
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

/* Function  structure for function  `FunIngresaPagosCreditosx` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosCreditosx` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosCreditosx`(nidclie integer,cndoc varchar(12),
cdocp varchar(12),nacta float,cesta char,cmone char,cb1 varchar(80),
dfech date,dfevto date,ctipo char,ndola float,cbco varchar(40),csitua varchar(2),
nimpc float,nctrl integer,nidven integer,nu integer,cnrou varchar(60),
nauto integer,nidaval integer,cfo CHAR,ndscto float,cpc varchar(45),nidtda integer,nidch integer,nidch1 integer,nidrc integer) RETURNS int(11)
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_cred(idclie,ndoc,docd,acta,estd,mone,banc,fech,fevto,tipo,dola,banco,situa,impc,ncontrol,idven,
idusua,nrou,idauto,idaval,form,dscto,codt,cre_idpc,cre_fope,cre_idrc,cre_idch,cred_idrc)values
(nidclie,cndoc,cdocp,nacta,cesta,cmone,cb1,dfech,dfevto,ctipo,ndola,
cbco,csitua,nimpc,nctrl,nidven,nu,cnrou,nauto,nidaval,cfo,ndscto,nidtda,cpc,curdate(),nidch,nidch1,nidrc);
select last_insert_id() into nid from fe_cred group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaPagosDeudas` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosDeudas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosDeudas`(dfech datetime,
dfevto datetime,nacta float,cndoc varchar(12),cesta char,cmone char,cb1 varchar(100),ctipo char,
nidrc integer,idusua integer,nctrl integer,cnrou varchar(25),cpc varchar(45),ndolar float) RETURNS int(11)
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
nctrl integer,cnrou varchar(25)) RETURNS int(11)
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_deu(fech,fevto,acta,ndoc,estd,banc,tipo,ncontrol,nrou,mone)
values(dfech,dfevto,nacta,cndoc,cesta,cb1,ctipo,nctrl,cnrou,cmone);
select last_insert_id() into nid from fe_deu group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaRcreditos` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaRcreditos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaRcreditos`(nauto INTEGER,nid INTEGER,dfecha DATE,nidven INTEGER,nimpoo DECIMAL(12,2),
nidus INTEGER,nidtda INTEGER,ninic DECIMAL(12,2),cpc VARCHAR(45)) RETURNS int(11)
BEGIN
DECLARE id1 INTEGER DEFAULT 0;
INSERT INTO fe_rcred(rcre_idcl,rcre_fech,rcre_idau,rcre_impc,rcre_idus,rcre_codt,rcre_idpc,rcre_inic,rcre_codv)
VALUES(nid,dfecha,nauto,nimpoo,nidus,nidtda,cpc,ninic,nidven);
SELECT LAST_INSERT_ID() INTO id1 FROM fe_rcred GROUP BY LAST_INSERT_ID();
RETURN id1;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaRRetencion` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaRRetencion` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaRRetencion`(dfecha date,nidpr integer,importe decimal(12,2),ndoc varchar(12),moneda char(1),
dolar decimal(6,4),nidus integer) RETURNS int(11)
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
nidclie integer,ntdoc integer,cform char,cndoc varchar(12),
dfecha date,dfecha1 date,dfevto date,cm char,ndolar float,ni float,nus integer,
nt1 float,nt2 float,nt3 float,nidcta1 integer,nidcta2 integer,nidcta3 integer,nt4 decimal(12,2),nidcta4 integer) RETURNS int(11)
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
INSERT INTO fe_rven(auto,idclie,idtdoc,form,ndoc,fech,fecr,fevto,mone,dolar,vigv,idauto,idusua,fusua,dolao,pimpo)
values(cauto,nidclie,ntdoc,cform,cndoc,dfecha,dfecha1,dfevto,cm,ndd,ni,0,nus,curdate(),nddd,nt4);
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
cmon char,dfecha date,nimpoo float,nidus integer,nidtda integer,cpc varchar(45)) RETURNS int(11)
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
cmon char,dfecha date,nimpoo float,nidus integer,nidtda integer,cpc varchar(45),nidcta integer) RETURNS int(11)
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

/*!50003 CREATE FUNCTION `FunRRcheques`(nidclie integer,nidtda integer) RETURNS int(11)
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

/*!50003 CREATE FUNCTION `FunTraspasoDatosLcajaE`(dfecha datetime,cndoc varchar(10),cdeta varchar(100),idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),cmone char,ndolar decimal(5,3),nidus integer,nidcp integer) RETURNS int(11)
begin
declare id integer;
insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,lcaj_idus,lcaj_clpr,lcaj_tran)values
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,'T');
select last_insert_id() into id from fe_lcaja group by last_insert_id();
return id;
end */$$
DELIMITER ;

/* Function  structure for function  `FunValidaCajaTda` */

/*!50003 DROP FUNCTION IF EXISTS `FunValidaCajaTda` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunValidaCajaTda`(dfecha date,nidalma integer) RETURNS int(11)
begin
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
if year(dfecha)<2016 then
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

/*!50003 CREATE FUNCTION `FunValidaDctos`(cmvto char,cdcto varchar(12),ctdoc varchar(2)) RETURNS int(11)
BEGIN
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
SELECT idauto into vdvto FROM fe_rcom WHERE ndoc=cdcto and tdoc=ctdoc and tipom=cmvto AND acti<>'I';
return vdvto;
END */$$
DELIMITER ;

/* Function  structure for function  `FUNVALIDADCTOS1` */

/*!50003 DROP FUNCTION IF EXISTS `FUNVALIDADCTOS1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FUNVALIDADCTOS1`(cdcto varchar(12),ctdoc varchar(2),id1 integer) RETURNS int(11)
BEGIN
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
SELECT idauto into vdvto FROM fe_rcom WHERE ndoc=cdcto and tdoc=ctdoc AND acti<>'I' and idauto<>id1 and idcliente>0 group by idauto;
return vdvto;
END */$$
DELIMITER ;

/* Function  structure for function  `FunVerificabancos` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificabancos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificabancos`(nid integer) RETURNS int(11)
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

/*!50003 CREATE FUNCTION `FUnVerificaBloqueo`(dfecha date) RETURNS int(11)
begin
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
if year(dfecha)<2015 then
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

/*!50003 CREATE FUNCTION `FUnVerificaBloqueo1`(dfecha date) RETURNS int(11)
begin
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
if year(dfecha)<2015 then
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

/*!50003 CREATE FUNCTION `FUnVerificaBloqueoBcos`(dfecha date,nid integer) RETURNS int(11)
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

/*!50003 CREATE FUNCTION `FUnVerificaBloqueoCajaEfectivo`(dfecha date) RETURNS int(11)
begin
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
if year(dfecha)<2015 then
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

/*!50003 CREATE FUNCTION `FUnVerificaBloqueoComprasM`(dfecha date) RETURNS int(11)
begin
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
if year(dfecha)<2015 then
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

/*!50003 CREATE FUNCTION `FUnVerificaBloqueoCreditos`(dfecha date) RETURNS int(11)
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

/*!50003 CREATE FUNCTION `FUnVerificaBloqueoVentasM`(dfecha date) RETURNS int(11)
begin
declare vdvto,nmes,na integer default 0;
declare df Date;
dECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
select month(fech) into nmes from fe_gene  where idgene=1;
select year(fech) into na from fe_gene where idgene=1;
select cast(concat(year(fech),"-",month(fech),"-01") as date) into df from fe_gene where idgene=1;
if year(dfecha)<2016 then
  return 0;
 else
   if month(dfecha)=nmes or datediff(dfecha,df)<=15 then
        return 1;
     else
        return 0;
   end if;
end if;
end */$$
DELIMITER ;

/* Function  structure for function  `FUNVERIFICACAJA` */

/*!50003 DROP FUNCTION IF EXISTS `FUNVERIFICACAJA` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FUNVERIFICACAJA`(df datetime) RETURNS int(11)
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

/*!50003 CREATE FUNCTION `FunVerificaEstadoDeuda`(nidauto integer) RETURNS int(11)
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

/*!50003 CREATE FUNCTION `FunVerificaPagos`(nid integer) RETURNS int(11)
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

/*!50003 CREATE FUNCTION `FunVerificaRetencion`(cndoc varchar(12)) RETURNS int(11)
begin
declare idr integer default 0;
select rete_idre into idr from fe_rret where rete_ndoc=cndoc and rete_Acti='A' group by rete_idre;
return idr;
end */$$
DELIMITER ;

/* Function  structure for function  `FunVerificaSiestaCajaB` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaSiestaCajaB` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaSiestaCajaB`(nid integer) RETURNS int(11)
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

/*!50003 CREATE FUNCTION `FunVerificaSiestaCanjeadoD`(nidc integer) RETURNS int(11)
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

/*!50003 CREATE FUNCTION `FunVerificaSiestaPagadod`(nidc integer) RETURNS int(11)
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

/*!50003 CREATE FUNCTION `FunVerificaSiPagoestaenRetenciones`(nid integer) RETURNS int(11)
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
ct1 char,ct2 char,ct3 char,ct4 char,ct5 char,ct6 char, ct7 char) RETURNS int(11)
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
nv2 float,nv3 float,nid1 integer,nid2 integer,nid3 integer) RETURNS int(11)
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

/*!50003 CREATE PROCEDURE `ActualizaCuentasv`(in nv1 float,
in nv2 float,in nv3 float,in nid1 integer,in nid2 integer,nid3 integer,in idv1 integer,
in idv2 integer, in idv3 integer,ct1 char,ct2 char,ct3 char,nv4 decimal(12,2),nid4 integer,idv4 integer,ct4 char)
BEGIN
update fe_ectas set impo=nv1,idcta=nid1,tipo=ct1 where idectas=idv1;
update fe_ectas set impo=nv2,idcta=nid2,tipo=ct2 where idectas=idv2;
update fe_ectas set impo=nv3,idcta=nid3,tipo=ct3  where idectas=idv3;
update fe_ectas set impo=nv4,idcta=nid4,tipo=ct4  where idectas=idv4;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ActualizaND` */

/*!50003 DROP PROCEDURE IF EXISTS  `ActualizaND` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ActualizaND`(dfecha date,ctdoc varchar(2),cserie1 varchar(4),
cndoc varchar(15),nvalor decimal(12,2),notro decimal(12,2),nimpo decimal(12,2),
ctdoc1 varchar(2),cserie varchar(4),naño integer,cndoc1 varchar(15),
nrete decimal(12,2),cmone varchar(3),ndola decimal(6,4),npais integer,
ncodp1 integer,ncodp2 integer,npais1 integer,cvinculo varchar(2),nrentab decimal(12,2),
ncosto decimal(12,2),nrentan decimal(12,2),vrenta decimal(12,2),nreten decimal(12,2),
cconvenio varchar(2),nexon integer,ntrta varchar(2),modo integer,
naplica integer,dfechar date,nidauto integer,opt integer)
begin
if opt=0 then
   update fe_rcom11 set com1_acti='I' where com1_idau=nidauto;
else
  update fe_rcom11 set com1_fech=dfecha,com1_tdoc=ctdoc,com1_ser1=cserie1,com1_ndoc=cndoc,com1_valo=nvalor,com1_otro=notro,
  com1_impo=nimpo,com1_tdoc1=ctdoc1,com1_serie1=cserie,com1_año=naño,com1_ndoc1=cndoc1,com1_rete=nrete,com1_mone=cmone,com1_dola=ndola,
  com1_pais=npais,com1_codp=ncodp1,com1_codp1=ncodp2,com1_pais1=npais1,com1_vinc=cvinculo,com1_renta=nrentab,com1_cost=ncosto,com1_rneta=nrentan,
  com1_vrenta=vrenta,com1_irete=nreten,com1_conv=cconvenio,com1_exon=nexon,com1_trta=ntrta,com1_modo=modo,com1_aplica=naplica,com1_fecr=dfechar
  where com1_idau=nidauto;
end if;
end */$$
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

/*!50003 CREATE PROCEDURE `astock`(coda INTEGER,nalma INTEGER(3),ccant FLOAT,ctipo VARCHAR(1))
BEGIN
CASE ctipo
WHEN 'C' THEN
     IF nalma=1 THEN
          UPDATE fe_art SET uno=uno+ccant WHERE idart=coda AND tipro<>'S';
     END IF;
     IF nalma=2 THEN
          UPDATE fe_art SET dos=dos+ccant WHERE idart=coda AND tipro<>'S';
     END IF;
     IF nalma=3 THEN
          UPDATE fe_art SET tre=tre+ccant WHERE idart=coda AND tipro<>'S';
     END IF;
     IF nalma=4 THEN
          UPDATE fe_art SET cua=cua+ccant WHERE idart=coda AND tipro<>'S';
     END IF;
     IF nalma=7 THEN
          UPDATE fe_art SET sie=sie+ccant WHERE idart=coda AND tipro<>'S';
     END IF;
     IF nalma=8 THEN
          UPDATE fe_art SET sei=sei+ccant WHERE idart=coda AND tipro<>'S';
     END IF;
     IF  nalma=9 THEN
          UPDATE fe_art SET cin=cin+ccant WHERE idart=coda AND tipro<>'S';
    END IF;
    IF  nalma=10 THEN
          UPDATE fe_art SET die=die+ccant WHERE idart=coda AND tipro<>'S';
    END IF;
    IF  nalma=11 THEN
          UPDATE fe_art SET onc=onc+ccant WHERE idart=coda AND tipro<>'S';
    END IF;
    IF  nalma=12 THEN
          UPDATE fe_art SET doce=doce+ccant WHERE idart=coda AND tipro<>'S';
    END IF;
    IF  nalma=13 THEN
          UPDATE fe_art SET trece=trece+ccant WHERE idart=coda AND tipro<>'S';
    END IF;
   IF  nalma=14 THEN
          UPDATE fe_art SET catorce=catorce+ccant WHERE idart=coda AND tipro<>'S';
    END IF; 
     IF  nalma=15 THEN
          UPDATE fe_art SET quince=quince+ccant WHERE idart=coda AND tipro<>'S';
    END IF; 
when 'V' THEN
    IF nalma=1 THEN
          UPDATE fe_art SET uno=uno-ccant WHERE idart=coda AND tipro<>'S';
    END IF;
    IF nalma=2 THEN
          UPDATE fe_art SET dos=dos-ccant WHERE idart=coda AND tipro<>'S';
    END IF;
    IF  nalma=3 THEN
          UPDATE fe_art SET tre=tre-ccant WHERE idart=coda AND tipro<>'S';
    END IF;
    IF  nalma=4 THEN
          UPDATE fe_art SET cua=cua-ccant WHERE idart=coda AND tipro<>'S';
    END IF;
    IF nalma=7 THEN
          UPDATE fe_art SET sie=sie-ccant WHERE idart=coda AND tipro<>'S';
    END IF;
    IF nalma=8 THEN
          UPDATE fe_art SET sei=sei-ccant WHERE idart=coda AND tipro<>'S';
    END IF;
   IF nalma=9 THEN
          UPDATE fe_art SET cin=cin-ccant WHERE idart=coda AND tipro<>'S';
   END IF;
   IF nalma=10 THEN
          UPDATE fe_art SET die=die-ccant WHERE idart=coda AND tipro<>'S';
   END IF;
   IF nalma=11 THEN
          UPDATE fe_art SET onc=onc-ccant WHERE idart=coda AND tipro<>'S';
   END IF;
   IF nalma=12 THEN
          UPDATE fe_art SET doce=doce-ccant WHERE idart=coda AND tipro<>'S';
   END IF;
   IF nalma=13 THEN
          UPDATE fe_art SET trece=trece-ccant WHERE idart=coda AND tipro<>'S';
   END IF;
   IF nalma=14 THEN
          UPDATE fe_art SET catorce=catorce-ccant WHERE idart=coda AND tipro<>'S';
   END IF; 
    IF nalma=15 THEN
          UPDATE fe_art SET quince=quince-ccant WHERE idart=coda AND tipro<>'S';
   END IF; 
when "I" THEN
     IF nalma=1 THEN
          UPDATE fe_art SET uno=ccant WHERE idart=coda AND tipro<>'S';
     END IF;
     IF  nalma=2 THEN
          UPDATE fe_art SET dos=ccant WHERE idart=coda AND tipro<>'S';
     END IF;
     IF nalma=3 THEN
          UPDATE fe_art SET tre=ccant WHERE idart=coda AND tipro<>'S';
     END IF;
     IF nalma=4 THEN
          UPDATE fe_art SET cua=ccant WHERE idart=coda AND tipro<>'S';
     END IF;
     IF nalma=7 THEN
          UPDATE fe_art SET sie=ccant WHERE idart=coda AND tipro<>'S';
     END IF;
     IF nalma=8 THEN
          UPDATE fe_art SET sei=ccant WHERE idart=coda AND tipro<>'S';
     END IF;
     IF  nalma=9 THEN
          UPDATE fe_art SET cin=ccant WHERE idart=coda AND tipro<>'S';
     END IF;
     IF  nalma=10 THEN
          UPDATE fe_art SET die=ccant WHERE idart=coda AND tipro<>'S';
     END IF;
     IF  nalma=11 THEN
          UPDATE fe_art SET onc=ccant WHERE idart=coda AND tipro<>'S';
     END IF;
     IF nalma=12 THEN
          UPDATE fe_art SET doce=ccant WHERE idart=coda AND tipro<>'S';
     END IF;
     IF nalma=13 THEN
          UPDATE fe_art SET trece=ccant WHERE idart=coda AND tipro<>'S';
     END IF;
     IF nalma=14 THEN
          UPDATE fe_art SET catorce=ccant WHERE idart=coda AND tipro<>'S';
     END IF;
       IF nalma=15 THEN
          UPDATE fe_art SET quince=ccant WHERE idart=coda AND tipro<>'S';
     END IF;
END case ;
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
sum(if(b.tipo='V',b.cant,0)) as tventas,b.alma from fe_kar as b  where b.acti<>'I'   group by  idart,alma) as a;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
open cursor1;
start transaction;
UPDATE fe_art SET uno=0,dos=0,tre=0,cua=0,cin=0,sei=0,die=0,sie=0,onc=0,doce=0,trece=0,catorce=0,quince=0;
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
in nimpo float,in nimpo1 float,in cdeta varchar(180),in cusua varchar(45),in cmon varchar(1),
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

/*!50003 CREATE PROCEDURE `ingresa_anulada`(in dfecha Datetime,in cndoc varchar(12),in ctdoc varchar(2),in cu varchar(40),in nidcon integer)
begin
 select @nc:=idclie from fe_clie where nruc='***********';
 insert into fe_rcom(idcliente,fech,fecr,ndoc,tdoc,tipom,ncta,deta,ndo2,tcom,form,mone,exon,fusua,usua)
 values(@nc,dfecha,dfecha,cndoc,ctdoc,'V','','','','K','','S','N',now(),cu);
 SELECT @na:=LAST_INSERT_ID() FROM fe_rcom;
 INSERT INTO fe_caja(idauto,fech,impo,tipo,forma,tmon,ndoc,idcon,usua,fechao,deta,origen)
 VALUES (@na,dfecha,0,"I","E","S",cndoc,nidcon,cu,now(),"*** ANULADA ***","CK");
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaActivos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaActivos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaActivos`(cdesc varchar(150),nvalor decimal(12,2),cdeta varchar(150),nid integer,opt integer)
BEGIN
if opt=0 then
  update fe_activos set acti_acti='I' where acti_idac=nid;
else
  update fe_activos set acti_desc=cdesc,acti_valor=nvalor,acti_deta=cdeta where acti_idac=nid;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProactualizaaResumenBoletas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProactualizaaResumenBoletas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProactualizaaResumenBoletas`(cticket varchar(20),cmensaje varchar(80))
BEGIN
update fe_resboletas set resu_mens=cmensaje,resu_feen=curdate() where resu_tick=cticket;
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

/*!50003 CREATE PROCEDURE `ProActualizaClienteCD`(nid INTEGER,cruc VARCHAR(11),crazo VARCHAR(100),
cdire VARCHAR(100),cciud VARCHAR(100),cfono VARCHAR(15),cfax VARCHAR(15),cdni VARCHAR (11),
ctipo CHAR,cemail VARCHAR(100),nidven INTEGER,nidus INTEGER,ccelu VARCHAR(15),crefe VARCHAR(255),linea FLOAT,
crpm VARCHAR(10),nidz INTEGER,nidpto INTEGER,cdist VARCHAR(100),cdire1 VARCHAR (100),cciud1 VARCHAR(100))
BEGIN
UPDATE fe_clie SET
nruc=cruc,razo=crazo,dire=cdire,ciud=cciud,fono=cfono,fax=cfax,ndni=cdni,clie_tipo=ctipo,clie_corr=cemail,
clie_codv=nidven,clie_actu=nidus,clie_feac=LOCALTIME,celu=ccelu,refe=crefe,
clie_lcre=linea,clie_rpm=crpm,clie_idzo=nidz,
clie_idpt=nidpto,clie_dist=cdist,clie_dir1=cdire1,clie_ciu1=cciud1 WHERE idclie=nid;
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

/*!50003 CREATE PROCEDURE `ProActualizaCtasBancos`(cta varchar(100),idb integer,cmone char,cdeta varchar(100),nidcta integer,opt integer,nidctap integer)
BEGIN
if opt=1 then
   update fe_ctasb set ctas_acti='I' where ctas_idct=nidcta;
  else
   update fe_ctasb set ctas_ctas=cta,ctas_idba=idb,ctas_mone=cmone,ctas_deta=cdeta,ctas_ncta=nidctap where ctas_idct=nidcta;
end if;
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

/* Procedure structure for procedure `ProActualizaDActivosI` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaDActivosI` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaDActivosI`(dfecha date,ct13 char,codi varchar(30),ct18 char,nidcta integer,
ct19 char,cdescri varchar(30),cmarca varchar(40),cmodelo varchar(30),cplaca varchar(10),ninic decimal(12,2),
nadqa decimal(12,2),nmejoras decimal(12,2),nretiros decimal(12,2),najustes decimal(12,2),nreva decimal(12,2),
nreso decimal(12,2),noreva decimal(12,2),najustei decimal(12,2),dfadq date,dfi date,ct20 char,cdcto varchar(12),
npode decimal(5,2),ndacu decimal(12,2),nvade decimal(12,2),nvare decimal(12,2),ndore decimal(12,2),
ndavo decimal(12,2),ndsoc decimal(12,2),ndoref decimal(12,2),ndein decimal(12,2),nidus integer,nidau integer,nid integer)
begin
update  fe_dactivos set
acti_fech=dfecha,acti_ta13=ct13,acti_codi=codi,acti_ta18=ct18,acti_idct=nidcta,acti_ta19=ct19,acti_desc=cdescri,acti_marc=cmarca,
acti_mode=cmodelo,acti_plac=cplaca,acti_inic=ninic,acti_adqa=nadqa,acti_mejo=nmejoras,acti_reti=nretiros,acti_ajus=najustes,
acti_reva=nreva,acti_reso=nreso,acti_orev=noreva,acti_vain=najustei,acti_fadq=dfadq,acti_fius=dfi,acti_ta20=ct20,
acti_dcto=cdcto,acti_pode=npode,acti_dacu=ndacu,acti_vade=nvade,acti_vare=nvare,acti_dore=ndore,
acti_davo=ndavo,acti_dsoc=ndsoc,acti_doref=ndoref,acti_dein=ndein,acti_idua=nidus,acti_fope1=localtime,acti_idau=nidau
where acti_idac=nid;
End */$$
DELIMITER ;

/* Procedure structure for procedure `PROACTUALIZADATOSDIARIO` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROACTUALIZADATOSDIARIO` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROACTUALIZADATOSDIARIO`(dfech datetime,ndebe decimal(12,2)
,nhaber decimal(12,2),cglosa varchar(200),ct char(1),cnume varchar(14),nidcta integer,idd integer,opt integer,ccond char,
nit integer,ncomp varchar(15),nidcl integer,nidpr integer,cmone char,ctran char)
BEGIN
if opt=0 then
   update fe_ldiario set ldia_acti='I' where ldia_idld=idd;
 else
   update fe_ldiario set ldia_fech=dfech,ldia_debe=ndebe,ldia_haber=nhaber,ldia_glosa=cglosa,ldia_tipo=ct,ldia_nume=cnume,
   ldia_idcta=nidcta,ldia_cond=ccond,ldia_item=nit,ldia_comp=ncomp,
   ldia_idcv=nidcl,ldia_idcc=nidpr,ldia_mone=cmone,ldia_tran=ctran where ldia_idld=idd;
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

/* Procedure structure for procedure `ProActualizaDatosLcajaE` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaDatosLcajaE` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaDatosLcajaE`(dfecha datetime,cndoc varchar(10),cdeta varchar(100),idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),nid integer,opt integer,cmone char,ndolar decimal(5,3))
begin
if opt=0 then
   update fe_lcaja  set lcaj_acti='I' where lcaj_idca=nid;
  else
    update fe_lcaja  set lcaj_fech=dfecha,lcaj_ndoc=cndoc,lcaj_deta=cdeta,lcaj_idct=idcta,
    lcaj_deud=sdeudor,lcaj_acre=sacreedor,lcaj_mone=cmone,lcaj_dola=ndolar where lcaj_idca=nid;
end if;
end */$$
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

/* Procedure structure for procedure `ProActualizaDetalleGuiasCons` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaDetalleGuiasCons` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaDetalleGuiasCons`(nidart INTEGER,ncant DECIMAL(12,2),nid INTEGER,nidkar INTEGER,nidguia INTEGER,opt INTEGER,cunid VARCHAR(30))
BEGIN
IF opt=0 THEN
     UPDATE fe_ent SET entr_acti='I' WHERE entr_iden=nid;
   ELSE
     UPDATE fe_ent SET entr_idar=nidart,entr_cant=ncant,entr_idkar=nidkar,entr_idgu=nidguia WHERE entr_iden=nid;
END IF;
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

/* Procedure structure for procedure `ProActualizaGuiasvtas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaGuiasvtas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaGuiasvtas`(dfecha DATE,cptop VARCHAR(150),cptoll VARCHAR(150),nidauto INTEGER,
dfechat DATE,nidus INTEGER,cdeta VARCHAR(150),nidtr INTEGER,cndoc VARCHAR(12),nidg INTEGER,nidtda INTEGER,nidcl INTEGER,cubigeo VARCHAR(8))
BEGIN
UPDATE fe_guias SET guia_fech=dfecha,guia_ptop=cptop,guia_ptoll=cptoll,guia_fect=dfechat,guia_deta=cdeta,guia_idtr=nidtr,
guia_ndoc=cndoc,guia_codt=nidtda,guia_ubig=cubigeo WHERE guia_idgui=nidg;
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

/* Procedure structure for procedure `ProActualizaOtrasCompras1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaOtrasCompras1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaOtrasCompras1`(nidprov integer,
ctdoc integer,cform char,cndoc varchar(12),dfecha date,dfechar date,cmon char,ndolar float,nigv1 float,cdetalle varchar(80),
nauto varchar(20),dfevto date,nidalma integer,ctipo char,cusua varchar(45),nidrc integer,nidactivo integer)
BEGIN
UPDATE fe_rcon SET idprov=nidprov,idtdoc=ctdoc,form=cform,ndoc=cndoc,
fech=dfecha,fecr=dfechar,mone=cmon,dolar=ndolar,vigv=nigv1,detalle=cdetalle,auto=nauto,fevto=dfevto,
idalma=nidalma,tipo=ctipo,usua=cusua,fusua=localtime,rcom_idac=nidactivo where idrcon=nidrc;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaPlanCuentas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaPlanCuentas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaPlanCuentas`(cn varchar(8),cdes varchar(60),
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
cc INTEGER,dfe DATE,npr DECIMAL(12,6),cnd VARCHAR(12),idp INTEGER,cmda CHAR,ni DECIMAL(6,4),nidusua INTEGER)
BEGIN
SELECT CONVERT('00/00/0000',CHAR) INTO @ufc FROM fe_art WHERE idart=cc;
IF @ufc<=dfe THEN
   UPDATE fe_art SET cost=npr,uldc=cnd,ulpc=idp,tmon=cmda,ulfc=dfe,prod_uact=nidusua WHERE idart=cc;
END IF;
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

/* Procedure structure for procedure `ProactualizaRBajas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProactualizaRBajas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProactualizaRBajas`(cticket VARCHAR(30),cmensaje VARCHAR(80),cdrxml longblob)
BEGIN
UPDATE fe_bajas SET baja_mens=cmensaje,baja_cdr=cdrxml  WHERE baja_tick=cticket;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProactualizaResumenBoletas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProactualizaResumenBoletas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProactualizaResumenBoletas`(cticket VARCHAR(30),cmensaje VARCHAR(80),cdrxml longblob)
BEGIN
UPDATE fe_resboletas SET resu_mens=cmensaje,resu_feen=CURDATE(),resu_cdr=cdrxml WHERE resu_tick=cticket;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaSoloVendedorVtas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaSoloVendedorVtas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaSoloVendedorVtas`(nidauto integer,nidv integer,nidus integer)
BEGIN
update fe_kar set codv=nidv where idauto=nidauto;
update fe_cred set idven=nidv where idauto=nidauto;
update fe_rcom set idusua1=nidus where idauto=nidauto;
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

/* Procedure structure for procedure `ProActualizaTransportista1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaTransportista1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaTransportista1`(cplaca VARCHAR(10),crazo VARCHAR(50),
cdire VARCHAR(50),cruc VARCHAR(11),cchofer VARCHAR(50),cbreve varchar(25),cmarca varchar(50),ccons varchar(30),
nid integer,cplaca1 varchar(11),nprop integer)
BEGIN
UPDATE fe_tra SET ructr=cruc,razon=crazo,nombr=cchofer,marca=cmarca,placa=cplaca,dirtr=cdire,
breve=cbreve,cons=ccons,placa1=cplaca1,tran_prop=nprop where idtra=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaVentas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaVentas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaVentas`(nidauto integer,nidus integer)
BEGIN
update fe_cred set acti='I' where idauto=nidauto;
update fe_caja set acti='I' where idauto=nidauto;
update fe_rcom set idusua1=nidus where idauto=nidauto;

END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaBalanceComprobacion` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaBalanceComprobacion` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaBalanceComprobacion`(df date)
BEGIN
update fe_balcomp set dcta_acti='I'  where year(dcta_fech)=year(df);
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

/* Procedure structure for procedure `ProAnulaDatosLibroDiarioPLe5` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaDatosLibroDiarioPLe5` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaDatosLibroDiarioPLe5`(ctipo varchar(3),nmes integer,na integer)
BEGIN
case
   when ctipo='COM' then
        update fe_ldiario set ldia_acti='I' where month(ldia_fech)=nmes and year(ldia_fech)=na and left(ldia_comp,3)='COM';
   when ctipo='VEN' then
        update fe_ldiario set ldia_acti='I' where month(ldia_fech)=nmes and year(ldia_fech)=na and left(ldia_comp,3)='VEN';
   when ctipo='CAJ' then
        update fe_ldiario set ldia_acti='I' where month(ldia_fech)=nmes and year(ldia_fech)=na and left(ldia_comp,3)='CAJ';
   when ctipo='BAN' then
       update fe_ldiario set ldia_acti='I' where month(ldia_fech)=nmes and year(ldia_fech)=na and left(ldia_comp,3)='BAN';
end case;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaDcta12` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaDcta12` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaDcta12`(df date)
BEGIN
delete from fe_cta12 ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaDcta19` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaDcta19` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaDcta19`(df date)
BEGIN
delete from fe_cta19 ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaDcta34` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaDcta34` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaDcta34`(df date)
BEGIN
update fe_cta34 set dcta_acti='I'  where dcta_fech=df;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaDcta37` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaDcta37` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaDcta37`(df date)
BEGIN
update fe_cta37 set dcta_acti='I'  where dcta_fech=df;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaDcta41` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaDcta41` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaDcta41`(df date)
BEGIN
update fe_cta41 set dcta_acti='I'  where dcta_fech=df;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaDcta42` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaDcta42` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaDcta42`(df date)
BEGIN
delete from fe_cta42 ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaDcta46` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaDcta46` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaDcta46`(df date)
BEGIN
delete from fe_cta46 ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaDcta50` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaDcta50` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaDcta50`(df date)
BEGIN
update fe_cta50 set dcta_acti='I'  where dcta_fech=df;
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

/*!50003 CREATE PROCEDURE `ProAnulaTransacciones`(OUT estado varchar(500),ctdoc varchar(2),cndoc varchar(12),
 ctipo char,nidauto integer,nu integer, w char,dfecha date,uauto integer)
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
   SELECT idcon into nidconcepto FROM fe_con WHERE tdoc=cconcepto and tipo='I' group by idcon limit 1;
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
declare cndoc,cdocp varchar(12);
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

/* Procedure structure for procedure `ProEditaNFecha` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProEditaNFecha` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProEditaNFecha`(dfecha date,crefe varchar(150),nidcred integer,nid integer,opt integer)
Begin
if opt=1 then
 update fe_rprg set rprg_fech=dfecha,rprg_deta=crefe,rprg_idcr=idcred where rprg_idrp=nid;
else
 update fe_rprg set rprg_acti='I'  where rprg_idrp=nid;
end if;
End */$$
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

/* Procedure structure for procedure `ProGrabatabla34PlanCuentas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProGrabatabla34PlanCuentas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProGrabatabla34PlanCuentas`(nid integer,ccodigo varchar(20))
BEGIN
update fe_plan set plan_idta=ccodigo where idcta=nid;
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
in nidart integer,in ncant float,in nprec float,in nid integer,in cndoc varchar(12),in ctdoc varchar(2))
BEGIN
insert into fe_akardex(usuario1,detalle,hora,usuario2,idart,cant,prec,idauto,ndoc,
tdoc,fech)values(cu,cd,localtime(),cu,nidart,ncant,nprec,nid,cndoc,ctdoc,curdate());
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaBalanceComprobacion` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaBalanceComprobacion` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaBalanceComprobacion`(ccta varchar(12),nombre varchar(150),
naadeu decimal(12,2),naacre decimal(12,2),ndebe decimal(12,2),nhaber decimal(12,2),ndeudor decimal(12,2),nacreedor decimal(12,2),
ndebet decimal(12,2),nhabert decimal(12,2),nactivo decimal(12,2),npasivo decimal(12,2),nppn decimal(12,2),
ngpn decimal(12,2),nppf decimal(12,2),npgf decimal(12,2),cpcta varchar(2),dfecha date,nidus integer)
BEGIN
insert into fe_balcomp(dcta_ncta,dcta_nomb,dcta_adeu,dcta_aacr,dcta_debe,dcta_haber,dcta_deudor,dcta_acreedor,
dcta_debet,dcta_habert,dcta_activo,dcta_pasivo,dcta_rpnp,dcta_rpng,dcta_rpfp,dcta_rpfg,dcta_pcta,dcta_fech,dcta_fope,dcta_idus)
values(ccta,nombre,naadeu,naacre,ndebe,nhaber,ndeudor,nacreedor,ndebet,nhabert,nactivo,npasivo,nppn,
ngpn,nppf,npgf,cpcta,dfecha,localtime,nidus);
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROingresacaja` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROingresacaja` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROingresacaja`(nauto integer,cdcto varchar(12),dfecha date,
nimpo float,nimpo1 float,cdeta varchar(180),cusua varchar(45),cmon varchar(1),
idcreditos integer,cf varchar(1),nimporte1 float,cmon1 varchar(1),ndola1 float,nidcodt integer,nidu integer)
BEGIN
declare nidcon integer;
if cf="E" then
    select idcon from fe_con where tdoc="PCE" into nidcon;
  else
    select idcon from fe_con where tdoc="XTC" into nidcon;
end if;
if nimpo>0 then
    INSERT INTO fe_caja(forma,tipo,idauto,ndoc,fech,impo,deta,usua,tmon,idcred,idcon,origen,fechao,mone,dola,nimpo,codt,idusua)
    values(cf,"I",nauto,cdcto,dfecha,nimpo,cdeta,cusua,cmon,idcreditos,nidcon,"CA",localtime,cmon1,ndola1,nimporte1,nidcodt,nidu);
end if;
if nimpo1>0 then
     INSERT INTO fe_caja(forma,tipo,idauto,ndoc,fech,impo,deta,usua,tmon,idcred,idcon,origen,fechao,mone,dola,nimpo,codt,idusua)
     values(cf,"I",nauto,cdcto,dfecha,nimpo1,cdeta,cusua,cmon,idcreditos,nidcon,"CA",localtime,cmon1,ndola1,nimporte1,nidcodt,nidu);
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

/*!50003 CREATE PROCEDURE `ProIngresaCuentasv`(nv1 decimal(12,2),
nv2 decimal(12,2),nv3 decimal(12,2),nid1 integer,nid2 integer,nid3 integer,nid integer,tper decimal(12,2),ctaper integer)
BEGIN
insert into fe_ectas(idrven,impo,idcta,nitem,tipo)
values(nid,nv1,nid1,1,"H");
insert into fe_ectas(idrven,impo,idcta,nitem,tipo)
values(nid,nv2,nid2,2,"H");
insert into fe_ectas(idrven,impo,idcta,nitem,tipo,ecta_total)
values(nid,nv3,nid3,3,"D",tper);
insert into fe_ectas(idrven,impo,idcta,nitem,tipo)
values(nid,tper,ctaper,4,"H");
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaCuentasvGratuitas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaCuentasvGratuitas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaCuentasvGratuitas`(nv1 decimal(12,2),
nv2 decimal(12,2),nv3 decimal(12,2),nid1 integer,nid2 integer,nid3 integer,nid integer,tper decimal(12,2),ctaper integer)
BEGIN
insert into fe_ectas(idrven,ecta_tgrat,idcta,nitem,tipo)
values(nid,nv1,nid1,0,"D");
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDatosLcajaE1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDatosLcajaE1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDatosLcajaE1`(dfecha date,cndoc varchar(12),cdeta varchar(100),idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),cmone char,ndolar decimal(5,3),nidus integer,nidcp integer,nidauto integer)
begin
insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,
lcaj_idus,lcaj_clpr,lcaj_idau)values
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,nidauto);
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDatosLibroDiarioPle5` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDatosLibroDiarioPle5` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDatosLibroDiarioPle5`(dfech datetime,ndebe decimal(12,2),
nhaber decimal(12,2),cglosa varchar(120),ct char(1),cnume varchar(12),nidcta integer,ccond char,nit integer,ncomp varchar(15),
nidcl integer,nidpr integer,cmone char,ctran char,nimtd decimal (12,2),nimth decimal(12,2),ctdoc varchar(2))
BEGIN
insert into fe_ldiario(ldia_fech,ldia_debe,ldia_haber,ldia_glosa,ldia_tipo,
ldia_nume,ldia_idcta,ldia_cond,ldia_item,ldia_comp,ldia_idcv,ldia_idcc,ldia_mone,ldia_tran,ldia_itrd,ldia_itrh,ldia_tdoc)
values(dfech,ndebe,nhaber,cglosa,ct,cnume,nidcta,ccond,nit,ncomp,nidcl,nidpr,cmone,ctran,nimtd,nimth,ctdoc);

END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDcta12` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDcta12` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDcta12`(df date,nidclie integer,ncodi integer,cnume varchar(15),cndcto varchar(12),
nimpo decimal(12,2),nidauto integer,nidus integer,tipodcto char,cdctoi varchar(11))
BEGIN
insert into fe_cta12(dcta_fech,dcta_idcl,dcta_codi,dcta_nume,dcta_ndoc,
dcta_impo,dcta_idau,dcta_idus,dcta_fope,dcta_tdoc,dcta_iden)
values(df,nidclie,ncodi,cnume,cndcto,nimpo,nidauto,nidus,localtime,tipodcto,cdctoi);
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDcta19` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDcta19` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDcta19`(df date,nidclie integer,ncodi integer,cnume varchar(15),cndcto varchar(12),
nimpo decimal(12,2),nidauto integer,nidus integer,tipodcto char,cdctoi varchar(11),tdoc1 varchar(2))
BEGIN
insert into fe_cta19(dcta_fech,dcta_idcl,dcta_codi,dcta_nume,dcta_ndoc,
dcta_impo,dcta_idau,dcta_idus,dcta_fope,dcta_tdoc,dcta_iden,dcta_tdc1)
values(df,nidclie,ncodi,cnume,cndcto,nimpo,nidauto,nidus,localtime,tipodcto,cdctoi,tdoc1);
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDcta34` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDcta34` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDcta34`(df date,idcta integer,cdeta varchar(150),nvalor decimal(12,2),namor decimal(12,2),nidus integer)
BEGIN
insert into fe_cta34(dcta_fech,dcta_icta,dcta_deta,dcta_valor,dcta_amor,dcta_fope,dcta_idus)
values(df,idcta,cdeta,nvalor,namor,localtime,nidus);
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDcta37` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDcta37` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDcta37`(ctdoc varchar(2),cserie varchar(4),cndoc varchar(8),nidcta integer,cdeta varchar(150),
nsaldo decimal(12,2),nadicional decimal(12,2),ndeduccion decimal(12,2),df date,nidus integer)
BEGIN
insert into fe_cta37(dcta_tdoc,dcta_seri,dcta_ndoc,dcta_saldo,dcta_adic,dcta_dedu,dcta_fech,dcta_ncta,dcta_deta,dcta_fope,dcta_idus)
values(ctdoc,cserie,cndoc,nsaldo,nadicional,ndeduccion,df,nidcta,cdeta,localtime,nidus);
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDcta41` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDcta41` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDcta41`(nidem integer,nsaldo decimal(12,2),ccta varchar(10),nidus integer,dfecha date)
BEGIN
insert into fe_cta41(dcta_idem,dcta_saldo,dcta_ncta,dcta_fech,dcta_fope,dcta_idus)
values(nidem,nsaldo,ccta,dfecha,localtime,nidus);
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDcta42` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDcta42` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDcta42`(df date,nidclie integer,ncodi integer,cnume varchar(15),cndcto varchar(12),
nimpo decimal(12,2),nidauto integer,nidus integer,tipodcto char,cdctoi varchar(11))
BEGIN
insert into fe_cta42(dcta_fech,dcta_idpr,dcta_codi,dcta_nume,dcta_ndoc,
dcta_impo,dcta_idau,dcta_idus,dcta_fope,dcta_tdoc,dcta_iden)
values(df,nidclie,ncodi,cnume,cndcto,nimpo,nidauto,nidus,localtime,tipodcto,cdctoi);
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDcta46` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDcta46` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDcta46`(df date,nidclie integer,ncodi integer,cnume varchar(15),cndcto varchar(12),
nimpo decimal(12,2),nidauto integer,nidus integer,tipodcto char,cdctoi varchar(11))
BEGIN
insert into fe_cta46(dcta_fech,dcta_idpr,dcta_codi,dcta_nume,dcta_ndoc,
dcta_impo,dcta_idau,dcta_idus,dcta_fope,dcta_tdoc,dcta_iden)
values(df,nidclie,ncodi,cnume,cndcto,nimpo,nidauto,nidus,localtime,tipodcto,cdctoi);
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDcta50` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDcta50` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDcta50`(nimpo decimal(12,2),nvalor decimal(12,2),naccs decimal(12,2),
naccp decimal(12,2),df date,nidus integer)
BEGIN
insert into fe_cta50(dcta_impo,dcta_valor,dcta_accs,dcta_accp,dcta_fope,dcta_idus,dcta_fech)
values(nimpo,nvalor,naccs,naccp,localtime,nidus,df);
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDetalleVta` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDetalleVta` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDetalleVta`(cdesc VARCHAR(80),nitem INTEGER,nitem1 INTEGER,nitem2 INTEGER,nidauto INTEGER,
nprecio DECIMAL(12,5),ncant DECIMAL(12,4),cunid VARCHAR(15))
BEGIN
   INSERT INTO fe_detallevta(detv_desc,detv_item,detv_ite1,detv_ite2,detv_idau,detv_prec,detv_cant,detv_unid)
   VALUES(cdesc,nitem,nitem1,nitem2,nidauto,nprecio,ncant,cunid);
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaInventarioInicial` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaInventarioInicial` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaInventarioInicial`(nidart integer,ncant decimal(12,2),ncosto decimal(12,2),dfecha date)
BEGIN
insert into fe_inicial(invi_idar,invi_cant,invi_prec,invi_fech)values(nidart,ncant,ncosto,dfecha);
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaRBajas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaRBajas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaRBajas`(dfecha DATE,ctdoc VARCHAR(2),cserie VARCHAR(4),cnumero VARCHAR(8),
cmotivo VARCHAR(50),cxml LONGBLOB ,cticket VARCHAR(30),carchivo VARCHAR(70),chash VARCHAR(30),nidauto INTEGER)
BEGIN
INSERT INTO fe_bajas(baja_fech,baja_tdoc,baja_serie,baja_nume,baja_arch,baja_tick,baja_moti,baja_xml,baja_hash,baja_idau)
VALUES (dfecha,ctdoc,cserie,cnumero,carchivo,cticket,cmotivo,cxml,chash,nidauto);
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
      Call ProIngresaDatosLcajaE1(dfecha,"",concat("Compra No Dcto ",cndoc),idce,0,nt,cm,ndolar,nus,nidprov,nid1);
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaResumenBoletas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaResumenBoletas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaResumenBoletas`(dfecha DATE,ctdoc VARCHAR(2),cserie VARCHAR(4),
cdesde VARCHAR(12),chasta VARCHAR(12),nimpo DECIMAL(12,2),nvalor DECIMAL(12,2),nexon DECIMAL(12,2),ninafecta DECIMAL(12,2),
nigv DECIMAL(12,2),ngrati DECIMAL(12,2),cxml LONGBLOB,chash VARCHAR(30),carchivo VARCHAR(70),cticket VARCHAR(30))
BEGIN
INSERT INTO fe_resboletas(resu_fech,resu_tdoc,resu_serie,resu_desd,resu_hast,resu_impo,resu_valo,resu_exon,resu_inaf,
resu_igv,resu_grat,resu_xml,resu_hash,resu_arch,resu_tick)
VALUES (dfecha,ctdoc,cserie,cdesde,chasta,nimpo,nvalor,nexon,ninafecta,nigv,ngrati,cxml,chash,carchivo,cticket);
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaRVentas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaRVentas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaRVentas`(
nidclie integer,ntdoc integer,cform char,cndoc varchar(12),
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
if tper>=0 then
  call ProIngresaCuentasV(nt1,nt2,nt3,nidcta1,nidcta2,nidcta3,nid1,tper,nidctaper);
else
   call ProIngresaCuentasVGratuitas(nt1,nt2,nt3,nidcta1,nidcta2,nidcta3,nid1,tper,nidctaper);
end if;
if idve>0 and cform='E'and (btdoc<>'07' or btdoc<>'08') then
      Call ProIngresaDatosLcajaE1(dfecha,"",concat("Vta.N° ",cndoc),idve,nt3+tper,0,cm,nddd,nus,nidclie,nid1);
end if;
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
 case
 when substr(cndoc,2,3)="001" or substr(cndoc,2,3)="N01" or substr(cndoc,2,3)="D01" then
    set nidtda=1;
 when substr(cndoc,2,3)="004" or substr(cndoc,2,3)="N04" or substr(cndoc,2,3)="D04" then
    set nidtda=2;
 when substr(cndoc,2,3)="003" or substr(cndoc,2,3)="N03" or substr(cndoc,2,3)="D03" then
    set nidtda=3;
 when substr(cndoc,2,3)="006" or substr(cndoc,2,3)="N06" or substr(cndoc,2,3)="D06" then
    set nidtda=4;
 WHEN SUBSTR(cndoc,2,3)="007" OR SUBSTR(cndoc,2,3)="N07" OR SUBSTR(cndoc,2,3)="D07" THEN
    SET nidtda=7;   
 when substr(cndoc,2,3)="011" or substr(cndoc,2,3)="N11" or substr(cndoc,2,3)="D11" then
    set nidtda=9;
 when substr(cndoc,2,3)="014" or substr(cndoc,2,3)="N14" or substr(cndoc,2,3)="D14" then
    set nidtda=7;
 when substr(cndoc,2,3)="012" or substr(cndoc,2,3)="N12" or substr(cndoc,2,3)="D12" then
    set nidtda=10;
 when substr(cndoc,2,3)="015" or substr(cndoc,2,3)="N15" or substr(cndoc,2,3)="D15" then
    set nidtda=11;
 when substr(cndoc,2,3)="016" or substr(cndoc,2,3)="N16" or substr(cndoc,2,3)="D16" then
    set nidtda=13;
when substr(cndoc,2,3)="017" or substr(cndoc,2,3)="N17" or substr(cndoc,2,3)="D17" then
    set nidtda=12;
WHEN SUBSTR(cndoc,2,3)="018" OR SUBSTR(cndoc,2,3)="N18" OR SUBSTR(cndoc,2,3)="D18" THEN
    SET nidtda=14;    
 end case;
 select @nc:=idclie from fe_clie where nruc='***********';
 insert into fe_rcom(idcliente,fech,fecr,ndoc,tdoc,tipom,ncta,deta,ndo2,tcom,form,mone,exon,fusua,idusua,codt)
 values(@nc,dfecha,dfecha,cndoc,ctdoc,'V','','','','K','','S','N',now(),nu,nidtda);
 SELECT @na:=LAST_INSERT_ID() FROM fe_rcom group by last_insert_id();
 INSERT INTO fe_caja(idauto,fech,impo,tipo,forma,tmon,ndoc,idcon,idusua,fechao,deta,origen,codt)
 VALUES (@na,dfecha,0,"I","E","S",cndoc,nidcon,nu,now(),"*** ANULADA ***","CK",nidtda);
 select @ntdoc:=idtdoc from fe_tdoc where tdoc=ctdoc;
 SELECT dcorrelativo(month(dfecha),'V') into cauto;
 INSERT INTO fe_rven(auto,idclie,idtdoc,form,ndoc,fech,fecr,fevto,mone,dolar,vigv,idauto,idusua,fusua,dolao,idalma)
 values(cauto,@nc,@ntdoc,'',cndoc,dfecha,dfecha,dfecha,'S',2.85,1.18,@na,nu,curdate(),2.85,nidtda);
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

/* Procedure structure for procedure `ProMuestraActivos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraActivos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraActivos`()
BEGIN
select acti_desc,acti_valor,acti_deta,acti_idac,acti_acti from fe_Activos where acti_acti='A' order by acti_desc;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraAlmacenes` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraAlmacenes` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraAlmacenes`()
BEGIN
SELECT nomb,idalma,dire,ciud,sucuidserie,ubigeo FROM fe_sucu order by nomb;
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
   select idclie,nruc,razo,ndni,dire,ciud,fono,fax,celu,refe,clie_dir1,clie_ciu1,clie_corr
   from fe_clie where razo like cbuscar and clie_acti<>'I' order by razo;
 when opt=1 then
   select idclie,nruc,razo,ndni,dire,ciud,fono,fax,celu,refe,clie_dir1,clie_ciu1,clie_corr
   from fe_clie where nruc like cbuscar  and clie_acti<>'I' order by nruc;
 when opt=2 then
   select idclie,nruc,razo,ndni,dire,ciud,fono,fax,celu,refe,clie_dir1,clie_ciu1,clie_corr
   from fe_clie where ndni like cbuscar and clie_acti<>'I'  order by ndni;
 when opt=3 then
   select idclie,nruc,razo,ndni,dire,ciud,fono,fax,celu,refe,clie_dir1,clie_ciu1,clie_corr
   from fe_clie where idclie =nid and clie_acti<>'I' order by idclie;
 when opt=4 then
   select idclie,nruc,razo,ndni,dire,ciud,fono,fax,celu,refe,clie_dir1,clie_ciu1,clie_corr
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
   clie_idpt,ifnull(dpto_nomb,'') as dpto,clie_dist as distrito,clie_dir1,clie_ciu1,clie_rpm,clie_corr
   from fe_clie  a left join fe_dpto b on b.dpto_idpt=a.clie_idpt
   where razo like cbuscar and clie_acti<>'I' order by razo;
 when opt=1 then
   select idclie,nruc,razo,ndni,dire,ciud,fono,fax,celu,refe,
   clie_idpt,ifnull(dpto_nomb,'') as dpto,clie_dist as distrito,clie_dir1,clie_ciu1,clie_rpm,clie_corr
   from fe_clie a left join fe_dpto b on b.dpto_idpt=a.clie_idpt
   where nruc like cbuscar  and clie_acti<>'I' order by nruc;
 when opt=2 then
   select idclie,nruc,razo,ndni,dire,ciud,fono,fax,celu,refe,
   clie_idpt,ifnull(dpto_nomb,'') as dpto,clie_dist as distrito,clie_dir1,clie_ciu1,clie_rpm,clie_corr
   from fe_clie a left join fe_dpto b on b.dpto_idpt=a.clie_idpt
   where ndni like cbuscar and clie_acti<>'I'  order by ndni;
 when opt=3 then
   select idclie,nruc,razo,ndni,dire,ciud,fono,fax,celu,refe,
   clie_idpt,ifnull(dpto_nomb,'') as dpto,clie_dist as distrito,clie_dir1,clie_ciu1,clie_rpm,clie_corr
   from fe_clie a left join fe_dpto b on b.dpto_idpt=a.clie_idpt
   where idclie =nid and clie_acti<>'I' order by idclie;
 when opt=4 then
   select idclie,nruc,razo,ndni,dire,ciud,fono,fax,celu,refe,
   clie_idpt,ifnull(dpto_nomb,'') as dpto,clie_dist as distrito,clie_dir1,clie_ciu1,clie_rpm,clie_corr
   from fe_clie a left join fe_dpto b on b.dpto_idpt=a.clie_idpt
   where ciud like cbuscar and clie_acti<>'I' order by idclie;
end case;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraCostosParaVenta` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraCostosParaVenta` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraCostosParaVenta`(lw VARCHAR(60))
BEGIN
DECLARE cb VARCHAR(60);
SET cb=CONCAT("%",TRIM(lw),"%");
SELECT prod_ccai,descri,uno,dos,tre,cua,cin,sei,die,sie,onc,doce,trece,catorce,quince,cost*v.igv AS costo,
IF(tmon="S","Soles","Dólares") AS tmon,round(cost*v.igv*prod_uti1,2) as pre1,
CAST(0 AS DECIMAL(12,2)) AS costop,unid,
pre2,pre3,peso,prod_perc,tipro,prod_grat,idart FROM fe_art  AS a,fe_gene AS v  WHERE descri LIKE cb AND prod_acti<>'I'   ORDER BY descri;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraCostosParaVentaWeb` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraCostosParaVentaWeb` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraCostosParaVentaWeb`(lw varchar(60))
BEGIN
declare vigv decimal(8,5);
declare cb varchar(60);
set cb=concat("%",trim(lw),"%");
select igv into vigv from fe_gene where idgene=1;
SELECT idart,descri,uno,dos,tre,cua,cin,sei,die,sie,cost*vigv as costo,if(tmon="S","Soles","Dólares") as tmon,
pre1,pre2,pre3,peso,prod_perc,tipro FROM fe_art  as a  WHERE descri LIKE cb and prod_acti<>'I'   ORDER BY descri;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraCtasBancos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraCtasBancos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraCtasBancos`()
BEGIN
select a.ctas_ctas,b.banc_nomb,a.ctas_mone,a.ctas_deta,a.ctas_idct,a.ctas_idba,a.ctas_ncta,b.banc_idco from fe_ctasb as a
inner join fe_bancos as b on b.banc_idba=a.ctas_idba where a.ctas_acti='A' order by a.ctas_ctas;
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

/*!50003 CREATE PROCEDURE `ProMuestraCuentasx`(cb varchar(50),opt integer)
BEGIN
declare cb1 varchar(50);
set cb1=concat('%',trim(cb),'%');
if opt=1 then
   select ncta,nomb,idcta,cdestinod,cdestinoh,tipocta,plan_oper,ifnull(esta_desc,'') as esta_desc,plan_idta from fe_plan as p
   left join fe_tabla34  as t on t.esta_coda=p.plan_idta where plan_acti='A'  and ncta like cb1 order by ncta;
  else
   select ncta,nomb,idcta,cdestinod,cdestinoh,tipocta,plan_oper,ifnull(esta_desc,'') as esta_desc,plan_idta from fe_plan as p
   left join fe_tabla34  as t on t.esta_coda=p.plan_idta where nomb like cb1  and plan_acti='A' order by ncta;
end if;
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

/*!50003 CREATE PROCEDURE `PROMUESTRADIARIO`(cndoc varchar(14))
BEGIN
select b.ncta,b.nomb,a.ldia_glosa as glosa,ldia_debe as debe,ldia_haber as haber,ldia_tipo as tipo,a.ldia_idcta as idcta,
a.ldia_idld as nreg,ldia_fech as fecha,ldia_cond as cond,a.ldia_comp as Comp,ifnull(p.razo,'') as Cliente,ifnull(q.razo,'') as Proveedor,
ifnull(a.ldia_idcv,0) as idcliente,ifnull(a.ldia_idcc,0) as idproveedor  from fe_ldiario as a inner join fe_plan as b on b.idcta=a.ldia_idcta
left join fe_ctasctesv as m on m.ctcv_idct=a.ldia_idcv left join fe_clie as p on p.idclie=m.ctcv_idcl left join fe_ctasctesc as n on n.ctcc_idct=a.ldia_idcc
left join fe_prov as q on q.idprov=n.ctcc_idpr where ldia_nume=cndoc and ldia_acti<>'I';
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

/* Procedure structure for procedure `ProMuestraEmpleados` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraEmpleados` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraEmpleados`(cb varchar(50))
BEGIN
declare cbusca varchar(80);
set cbusca=concat('%',trim(cb),+'%');
SELECT empl_idem,empl_nomb,empl_fono,empl_suel,empl_idus,empl_refe,empl_idpc,empl_ndni,empl_tipo
FROM fe_empl WHERE empl_nomb LIKE cbusca and empl_acti<>'I' ORDER BY empl_nomb;
END */$$
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

/* Procedure structure for procedure `ProMuestraIdCuentas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraIdCuentas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraIdCuentas`(nid integer)
BEGIN
select ncta,nomb,idcta,cdestinod,cdestinoh,tipocta,plan_oper from fe_plan where plan_acti='A'  and idcta=nid;
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

/*!50003 CREATE PROCEDURE `ProMuestraLcajaE`(cndoc varchar(10))
begin
select a.lcaj_idca,a.lcaj_fech,a.lcaj_ndoc,a.lcaj_deta,a.lcaj_deud,a.lcaj_acre,a.lcaj_idct,b.ncta,b.nomb,lcaj_mone,lcaj_dola,lcaj_idus,lcaj_clpr,lcaj_tran
from fe_lcaja as a inner join fe_plan as b on b.idcta=a.lcaj_idct where a.lcaj_acti='A' AND trim(a.lcaj_ndoc)=trim(cndoc) and lcaj_tran='N' ;
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

/*!50003 CREATE PROCEDURE `ProMuestraPlanCuentas`(cb varchar(50),NID INTEGER)
BEGIN
declare cb1 varchar(50);
set cb1=concat('%',trim(cb),'%');
SELECT ncta,idcta,nomb,cdestinod,cdestinoh,tipocta,plan_oper FROM fe_plan where ncta like cb1  ORDER BY ncta;
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
pre2,pre3,peso,prec,tipro,idmar,idcat,cost,tmon,idflete,prod_perc,prod_mode,prod_ccai,prod_grat
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

/* Procedure structure for procedure `ProMuestraSeries` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraSeries` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraSeries`()
BEGIN
SELECT idserie,tdoc,serie,nume,codt FROM fe_serie ORDER BY idserie;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestratabla34` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestratabla34` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestratabla34`(cb varchar(50),opt integer)
BEGIN
declare cb1 varchar(50);
set cb1=concat('%',trim(cb),'%');
if opt=1 then
   select esta_desc,esta_coda,esta_ides from fe_tabla34 where esta_coda like cb1 order by esta_desc;
  else
   select esta_desc,esta_coda,esta_ides from fe_tabla34 where esta_desc like cb1   order by esta_desc;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraTabla35` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraTabla35` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraTabla35`()
BEGIN
select ta35_codt,ta35_nomb from fe_tabla35 order by ta35_nomb;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraTabla4` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraTabla4` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraTabla4`()
BEGIN
select tab4_codt,tab4_nomb,tab4_pais from fe_tabla4 order by tab4_nomb;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraTransportista` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraTransportista` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraTransportista`(cb VARCHAR(20),opt INTEGER)
BEGIN
DECLARE cb1 VARCHAR(20);
SET cb1=CONCAT('%',TRIM(cb),'%');
IF opt=1 THEN
  SELECT placa,razon,ructr,cons,nombr,breve,cons,marca,placa1,dirtr,idtra,tran_tipo,tran_cons1,tran_prop FROM fe_tra WHERE razon LIKE cb1 AND tran_acti='A';
 ELSE
  SELECT placa,razon,ructr,cons,nombr,breve,cons,marca,placa1,dirtr,idtra,tran_tipo,tran_cons1,tran_prop FROM fe_tra WHERE placa LIKE cb1 AND tran_acti='A';
END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraVendedores` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraVendedores` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraVendedores`(in cbusca varchar(20))
BEGIN
declare cbuscar varchar(80);
set cbuscar=concat('%',trim(cbusca),+'%');
select * from fe_vend where nomv like cbuscar and vend_acti<>'I' order by nomv;
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

/* Procedure structure for procedure `ProRegistraNFecha` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProRegistraNFecha` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProRegistraNFecha`(dfecha date,crefe varchar(150),nidcred integer)
Begin
 insert  into fe_rprg(rprg_fech,rprg_deta,rprg_idcr)values(dfecha,crefe,nidcred);
End */$$
DELIMITER ;

/* Procedure structure for procedure `ProReiIstraDActivosI` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProReiIstraDActivosI` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProReiIstraDActivosI`(dfecha date,ct13 char,codi varchar(30),ct18 char,nidcta integer,
ct19 char,cdescri varchar(40),cmarca varchar(30),cmodelo varchar(30),cplaca varchar(10),ninic decimal(12,2),
nadqa decimal(12,2),nmejoras decimal(12,2),nretiros decimal(12,2),najustes decimal(12,2),nreva decimal(12,2),
nreso decimal(12,2),noreva decimal(12,2),najustei decimal(12,2),dfadq date,dfi date,ct20 char,cdcto varchar(12),
npode decimal(5,2),ndacu decimal(12,2),nvade decimal(12,2),nvare decimal(12,2),ndore decimal(12,2),
ndavo decimal(12,2),ndsoc decimal(12,2),ndoref decimal(12,2),ndein decimal(12,2),nidus integer,nidau integer)
begin
insert into fe_dactivos(
acti_fech,acti_ta13,acti_codi,acti_ta18,acti_idct,acti_ta19,acti_desc,acti_marc,
acti_mode,acti_plac,acti_inic,acti_adqa,acti_mejo,acti_reti,acti_ajus,acti_reva,
acti_reso,acti_orev,acti_vain,acti_fadq,acti_fius,acti_ta20,acti_dcto,acti_pode,
acti_dacu,acti_vade,acti_vare,acti_dore,acti_davo,acti_dsoc,acti_doref,acti_dein,
acti_idus,acti_fope,acti_idau)
values(dfecha,ct13,codi,ct18,nidcta,ct19,cdescri,cmarca,cmodelo,cplaca,
ninic,nadqa,nmejoras,nretiros,najustes,nreva,nreso,noreva,najustei,dfadq,
dfi,ct20,cdcto,npode,ndacu,nvade,nvare,ndore,ndavo,ndsoc,
ndoref,ndein,nidus,localtime,nidau);
End */$$
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

/* Procedure structure for procedure `ProTraspasoRecibido` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProTraspasoRecibido` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProTraspasoRecibido`(nidauto INTEGER)
BEGIN
  UPDATE fe_rcom SET rcom_reci='E' WHERE idauto=nidauto;
END */$$
DELIMITER ;

/*Table structure for table `vcostoproducto` */

DROP TABLE IF EXISTS `vcostoproducto`;

/*!50001 DROP VIEW IF EXISTS `vcostoproducto` */;
/*!50001 DROP TABLE IF EXISTS `vcostoproducto` */;

/*!50001 CREATE TABLE  `vcostoproducto`(
 `idart` int(11) ,
 `prec` double ,
 `mone` varchar(1) ,
 `fech` date 
)*/;

/*Table structure for table `vguiasdevolucion` */

DROP TABLE IF EXISTS `vguiasdevolucion`;

/*!50001 DROP VIEW IF EXISTS `vguiasdevolucion` */;
/*!50001 DROP TABLE IF EXISTS `vguiasdevolucion` */;

/*!50001 CREATE TABLE  `vguiasdevolucion`(
 `idguia` int(10) unsigned ,
 `coda` int(11) ,
 `descri` varchar(60) ,
 `unid` varchar(5) ,
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
 `idprov` int(11) ,
 `refe` varchar(12) ,
 `tdoc` varchar(2) ,
 `guia_mens` varchar(120) ,
 `guia_arch` varchar(120) ,
 `email` varchar(45) ,
 `guia_hash` varchar(100) ,
 `guia_feen` datetime ,
 `guia_codt` int(10) unsigned ,
 `guia_tick` varchar(40) 
)*/;

/*Table structure for table `vguiasrcompras` */

DROP TABLE IF EXISTS `vguiasrcompras`;

/*!50001 DROP VIEW IF EXISTS `vguiasrcompras` */;
/*!50001 DROP TABLE IF EXISTS `vguiasrcompras` */;

/*!50001 CREATE TABLE  `vguiasrcompras`(
 `idguia` int(10) unsigned ,
 `coda` int(11) ,
 `descri` varchar(60) ,
 `unid` varchar(5) ,
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

/*Table structure for table `vguiasventas` */

DROP TABLE IF EXISTS `vguiasventas`;

/*!50001 DROP VIEW IF EXISTS `vguiasventas` */;
/*!50001 DROP TABLE IF EXISTS `vguiasventas` */;

/*!50001 CREATE TABLE  `vguiasventas`(
 `idguia` int(10) unsigned ,
 `coda` int(11) ,
 `descri` varchar(60) ,
 `unid` varchar(5) ,
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
 `refe` varchar(12) ,
 `tdoc` varchar(2) ,
 `guia_mens` varchar(120) ,
 `guia_arch` varchar(120) ,
 `clie_corr` varchar(100) ,
 `guia_hash` varchar(100) ,
 `guia_feen` datetime ,
 `guia_codt` int(10) unsigned ,
 `guia_tick` varchar(40) 
)*/;

/*Table structure for table `vib` */

DROP TABLE IF EXISTS `vib`;

/*!50001 DROP VIEW IF EXISTS `vib` */;
/*!50001 DROP TABLE IF EXISTS `vib` */;

/*!50001 CREATE TABLE  `vib`(
 `cta` varchar(2) ,
 `plan_idta` varchar(15) ,
 `tipocta` varchar(12) ,
 `esta_desc` varchar(150) 
)*/;

/*Table structure for table `vlcajacl` */

DROP TABLE IF EXISTS `vlcajacl`;

/*!50001 DROP VIEW IF EXISTS `vlcajacl` */;
/*!50001 DROP TABLE IF EXISTS `vlcajacl` */;

/*!50001 CREATE TABLE  `vlcajacl`(
 `lcaj_idca` int(11) ,
 `razo` varchar(100) 
)*/;

/*Table structure for table `vlcajapr` */

DROP TABLE IF EXISTS `vlcajapr`;

/*!50001 DROP VIEW IF EXISTS `vlcajapr` */;
/*!50001 DROP TABLE IF EXISTS `vlcajapr` */;

/*!50001 CREATE TABLE  `vlcajapr`(
 `lcaj_idca` int(11) ,
 `razo` varchar(100) ,
 `lcaj_clpr` int(10) unsigned ,
 `ncta` varchar(8) 
)*/;

/*Table structure for table `vmuestracompras` */

DROP TABLE IF EXISTS `vmuestracompras`;

/*!50001 DROP VIEW IF EXISTS `vmuestracompras` */;
/*!50001 DROP TABLE IF EXISTS `vmuestracompras` */;

/*!50001 CREATE TABLE  `vmuestracompras`(
 `idauto` int(11) ,
 `alma` int(11) ,
 `idkar` int(11) ,
 `descri` varchar(60) ,
 `peso` float ,
 `unid` varchar(5) ,
 `tipro` varchar(1) ,
 `idart` int(11) ,
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
 `idprov` int(11) ,
 `tipo` varchar(1) ,
 `tdoc` varchar(2) ,
 `dolar` float ,
 `mone` varchar(1) ,
 `razo` varchar(100) ,
 `dire` varchar(100) ,
 `ciud` varchar(100) ,
 `nruc` varchar(11) ,
 `Idcaja` bigint(11) ,
 `codt` int(10) unsigned ,
 `dsnc` int(11) ,
 `dsnd` int(11) ,
 `gast` int(11) ,
 `fusua` datetime ,
 `Usuario` varchar(45) 
)*/;

/*Table structure for table `vmuestracotizaciones` */

DROP TABLE IF EXISTS `vmuestracotizaciones`;

/*!50001 DROP VIEW IF EXISTS `vmuestracotizaciones` */;
/*!50001 DROP TABLE IF EXISTS `vmuestracotizaciones` */;

/*!50001 CREATE TABLE  `vmuestracotizaciones`(
 `idart` int(10) unsigned ,
 `descri` varchar(60) ,
 `unid` varchar(5) ,
 `cant` float ,
 `prec` float ,
 `premay` float ,
 `premen` float ,
 `fech` date ,
 `idautop` int(10) unsigned ,
 `impo` float ,
 `ndoc` varchar(10) ,
 `aten` varchar(80) ,
 `forma` varchar(80) ,
 `plazo` varchar(80) ,
 `validez` varchar(80) ,
 `entrega` varchar(80) ,
 `detalle` varchar(150) ,
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
 `Debe` double(23,2) ,
 `Haber` double(23,2) ,
 `idcta` int(10) unsigned ,
 `fech` date ,
 `nomb` varchar(60) ,
 `tipo` char(1) ,
 `idrcon` int(11) ,
 `mone` varchar(1) ,
 `idprov` int(11) 
)*/;

/*Table structure for table `vmuestractasdiario` */

DROP TABLE IF EXISTS `vmuestractasdiario`;

/*!50001 DROP VIEW IF EXISTS `vmuestractasdiario` */;
/*!50001 DROP TABLE IF EXISTS `vmuestractasdiario` */;

/*!50001 CREATE TABLE  `vmuestractasdiario`(
 `Fecha` datetime ,
 `ncta` varchar(8) ,
 `Glosa` varchar(200) ,
 `Debe` decimal(12,2) ,
 `Haber` decimal(12,2) ,
 `Idcta` int(10) unsigned 
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
 `Debe` decimal(16,2) ,
 `Haber` decimal(16,2) ,
 `tipo` char(1) ,
 `idcta` int(10) unsigned ,
 `nomb` varchar(60) ,
 `idrven` int(10) unsigned ,
 `mone` varchar(1) ,
 `idclie` int(11) 
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
 `idauto` int(11) ,
 `tdoc1` varchar(2) ,
 `dolar` float 
)*/;

/*Table structure for table `vpagosbancos` */

DROP TABLE IF EXISTS `vpagosbancos`;

/*!50001 DROP VIEW IF EXISTS `vpagosbancos` */;
/*!50001 DROP TABLE IF EXISTS `vpagosbancos` */;

/*!50001 CREATE TABLE  `vpagosbancos`(
 `ctasb` varchar(110) ,
 `cban_clpr` int(10) unsigned 
)*/;

/*Table structure for table `vpdtespago` */

DROP TABLE IF EXISTS `vpdtespago`;

/*!50001 DROP VIEW IF EXISTS `vpdtespago` */;
/*!50001 DROP TABLE IF EXISTS `vpdtespago` */;

/*!50001 CREATE TABLE  `vpdtespago`(
 `ndoc` varchar(12) ,
 `fevto` date ,
 `dola` float ,
 `nrou` varchar(25) ,
 `banc` varchar(80) ,
 `iddeu` int(11) ,
 `fech` date ,
 `saldo` double(23,2) ,
 `Idpr` int(11) ,
 `ImporteC` decimal(12,2) ,
 `situa` varchar(1) ,
 `Idauto` int(10) unsigned ,
 `ncontrol` int(11) ,
 `tipo` varchar(1) ,
 `banco` varchar(45) ,
 `docd` varchar(12) ,
 `tdoc` varchar(3) ,
 `Moneda` char(1) ,
 `Codt` int(10) unsigned ,
 `Idrd` int(10) unsigned 
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
 `idauto` int(11) ,
 `deta` varchar(220) ,
 `tcom` varchar(1) ,
 `vigv` float ,
 `idprov` int(11) ,
 `tdoc` varchar(2) ,
 `dolar` float ,
 `mone` varchar(1) ,
 `razo` varchar(100) ,
 `dire` varchar(100) ,
 `ciud` varchar(100) ,
 `nruc` varchar(11) ,
 `Idcaja` bigint(11) ,
 `codt` int(10) unsigned ,
 `fusua` datetime ,
 `Usuario` varchar(45) 
)*/;

/*Table structure for table `vsaldosctaspagar` */

DROP TABLE IF EXISTS `vsaldosctaspagar`;

/*!50001 DROP VIEW IF EXISTS `vsaldosctaspagar` */;
/*!50001 DROP TABLE IF EXISTS `vsaldosctaspagar` */;

/*!50001 CREATE TABLE  `vsaldosctaspagar`(
 `rdeu_idrd` int(10) unsigned ,
 `Saldo` double ,
 `ncontrol` int(11) 
)*/;

/*View structure for view vcostoproducto */

/*!50001 DROP TABLE IF EXISTS `vcostoproducto` */;
/*!50001 DROP VIEW IF EXISTS `vcostoproducto` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vcostoproducto` AS select `a`.`idart` AS `idart`,if((`b`.`mone` = 'S'),((`a`.`prec` / `v`.`dola`) * `b`.`vigv`),(`a`.`prec` * `b`.`vigv`)) AS `prec`,`b`.`mone` AS `mone`,`b`.`fech` AS `fech` from ((`fe_kar` `a` join `fe_rcom` `b` on((`b`.`idauto` = `a`.`idauto`))) join `fe_gene` `v`) where ((`a`.`acti` = 'A') and (`b`.`acti` = 'A') and (`a`.`idprov` > 0)) order by `a`.`idart`,`b`.`fech` desc */;

/*View structure for view vguiasdevolucion */

/*!50001 DROP TABLE IF EXISTS `vguiasdevolucion` */;
/*!50001 DROP VIEW IF EXISTS `vguiasdevolucion` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vguiasdevolucion` AS select `b`.`guia_idgui` AS `idguia`,`a`.`idart` AS `coda`,`a`.`descri` AS `descri`,`a`.`unid` AS `unid`,`b`.`guia_ndoc` AS `ndoc`,`b`.`guia_fech` AS `fech`,`b`.`guia_fect` AS `fect`,`b`.`guia_ptoll` AS `ptoll`,`b`.`guia_deta` AS `detalle`,`x`.`entr_cant` AS `cant`,`y`.`placa` AS `placa`,ifnull(`y`.`razon`,'') AS `Transportista`,`y`.`ructr` AS `ructr`,`y`.`nombr` AS `Chofer`,`y`.`breve` AS `Brevete`,`y`.`cons` AS `Constancia`,`y`.`marca` AS `marca`,`y`.`dirtr` AS `Direccion`,`p`.`nomb` AS `usuario`,`d`.`razo` AS `cliente`,`d`.`idprov` AS `idprov`,`c`.`ndoc` AS `refe`,`c`.`tdoc` AS `tdoc`,`b`.`guia_mens` AS `guia_mens`,`b`.`guia_arch` AS `guia_arch`,`d`.`email` AS `email`,`b`.`guia_hash` AS `guia_hash`,`b`.`guia_feen` AS `guia_feen`,`b`.`guia_codt` AS `guia_codt`,`b`.`guia_tick` AS `guia_tick` from (((((((`fe_guias` `b` join `fe_ent` `x` on((`x`.`entr_idgu` = `b`.`guia_idgui`))) join `fe_tra` `y` on((`y`.`idtra` = `b`.`guia_idtr`))) join `fe_kar` `s` on((`s`.`idkar` = `x`.`entr_idkar`))) join `fe_art` `a` on((`a`.`idart` = `s`.`idart`))) join `fe_usua` `p` on((`p`.`idusua` = `b`.`guia_idus`))) join `fe_rcom` `c` on((`c`.`idauto` = `b`.`guia_idau`))) join `fe_prov` `d` on((`d`.`idprov` = `c`.`idprov`))) where ((`b`.`guia_acti` <> 'I') and (`b`.`guia_moti` = 'D') and (`x`.`entr_acti` = 'A')) */;

/*View structure for view vguiasrcompras */

/*!50001 DROP TABLE IF EXISTS `vguiasrcompras` */;
/*!50001 DROP VIEW IF EXISTS `vguiasrcompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vguiasrcompras` AS select `b`.`guia_idgui` AS `idguia`,`a`.`idart` AS `coda`,`a`.`descri` AS `descri`,`a`.`unid` AS `unid`,`b`.`guia_ndoc` AS `ndoc`,`b`.`guia_fech` AS `fech`,`b`.`guia_fect` AS `fect`,`b`.`guia_ptoll` AS `ptoll`,`b`.`guia_deta` AS `detalle`,`x`.`entr_cant` AS `cant`,`y`.`placa` AS `placa`,ifnull(`y`.`razon`,'') AS `Transportista`,`y`.`ructr` AS `ructr`,`y`.`nombr` AS `Chofer`,`y`.`breve` AS `Brevete`,`y`.`cons` AS `Constancia`,`y`.`marca` AS `marca`,`y`.`dirtr` AS `Direccion`,`p`.`nomb` AS `usuario`,`pp`.`razo` AS `cliente`,`b`.`guia_idpr` AS `idprov`,`b`.`guia_ndoc` AS `refe`,'09' AS `tdoc`,`b`.`guia_mens` AS `guia_mens`,`b`.`guia_arch` AS `guia_arch`,`d`.`correo` AS `email`,`b`.`guia_hash` AS `guia_hash`,`b`.`guia_feen` AS `guia_feen`,`b`.`guia_codt` AS `guia_codt`,`b`.`guia_tick` AS `guia_tick` from ((((((`fe_guias` `b` join `fe_ent` `x` on((`x`.`entr_idgu` = `b`.`guia_idgui`))) join `fe_tra` `y` on((`y`.`idtra` = `b`.`guia_idtr`))) join `fe_art` `a` on((`a`.`idart` = `x`.`entr_idar`))) join `fe_usua` `p` on((`p`.`idusua` = `b`.`guia_idus`))) join `fe_prov` `pp` on((`pp`.`idprov` = `b`.`guia_idpr`))) join `fe_gene` `d`) where ((`b`.`guia_acti` <> 'I') and (`b`.`guia_moti` = 'C') and (`x`.`entr_acti` = 'A')) */;

/*View structure for view vguiasventas */

/*!50001 DROP TABLE IF EXISTS `vguiasventas` */;
/*!50001 DROP VIEW IF EXISTS `vguiasventas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vguiasventas` AS select `b`.`guia_idgui` AS `idguia`,`a`.`idart` AS `coda`,`a`.`descri` AS `descri`,`a`.`unid` AS `unid`,`b`.`guia_ndoc` AS `ndoc`,`b`.`guia_fech` AS `fech`,`b`.`guia_fect` AS `fect`,`b`.`guia_ptoll` AS `ptoll`,`b`.`guia_deta` AS `detalle`,`x`.`entr_cant` AS `cant`,`y`.`placa` AS `placa`,ifnull(`y`.`razon`,'') AS `Transportista`,`y`.`ructr` AS `ructr`,`y`.`nombr` AS `Chofer`,`y`.`breve` AS `Brevete`,`y`.`cons` AS `Constancia`,`y`.`marca` AS `marca`,`y`.`dirtr` AS `Direccion`,`p`.`nomb` AS `usuario`,`d`.`razo` AS `cliente`,`d`.`idclie` AS `idcliente`,`c`.`ndoc` AS `refe`,`c`.`tdoc` AS `tdoc`,`b`.`guia_mens` AS `guia_mens`,`b`.`guia_arch` AS `guia_arch`,`d`.`clie_corr` AS `clie_corr`,`b`.`guia_hash` AS `guia_hash`,`b`.`guia_feen` AS `guia_feen`,`b`.`guia_codt` AS `guia_codt`,`b`.`guia_tick` AS `guia_tick` from (((((((`fe_guias` `b` join `fe_ent` `x` on((`x`.`entr_idgu` = `b`.`guia_idgui`))) left join `fe_tra` `y` on((`y`.`idtra` = `b`.`guia_idtr`))) join `fe_kar` `s` on((`s`.`idkar` = `x`.`entr_idkar`))) join `fe_art` `a` on((`a`.`idart` = `s`.`idart`))) join `fe_usua` `p` on((`p`.`idusua` = `b`.`guia_idus`))) join `fe_rcom` `c` on((`c`.`idauto` = `b`.`guia_idau`))) join `fe_clie` `d` on((`d`.`idclie` = `c`.`idcliente`))) where ((`b`.`guia_acti` <> 'I') and (`x`.`entr_acti` = 'A')) */;

/*View structure for view vib */

/*!50001 DROP TABLE IF EXISTS `vib` */;
/*!50001 DROP VIEW IF EXISTS `vib` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vib` AS select left(`p`.`ncta`,2) AS `cta`,`p`.`plan_idta` AS `plan_idta`,`p`.`tipocta` AS `tipocta`,`t`.`esta_desc` AS `esta_desc` from (`fe_plan` `p` join `fe_tabla34` `t` on((`t`.`esta_coda` = `p`.`plan_idta`))) where ((length(trim(`p`.`plan_idta`)) > 0) and (`p`.`plan_Acti` = 'A')) group by left(`p`.`ncta`,2) order by left(`p`.`ncta`,2),`p`.`plan_idta` */;

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

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestracompras` AS select `a`.`idauto` AS `idauto`,`a`.`alma` AS `alma`,`a`.`idkar` AS `idkar`,`b`.`descri` AS `descri`,`b`.`peso` AS `peso`,`b`.`unid` AS `unid`,`b`.`tipro` AS `tipro`,`a`.`idart` AS `idart`,`a`.`incl` AS `incl`,`c`.`ndoc` AS `ndoc`,`c`.`valor` AS `valor`,`c`.`igv` AS `igv`,`c`.`impo` AS `impo`,`c`.`pimpo` AS `pimpo`,`a`.`cant` AS `cant`,`a`.`prec` AS `prec`,`c`.`fech` AS `fech`,`c`.`fecr` AS `fecr`,`c`.`form` AS `form`,`c`.`exon` AS `exon`,`c`.`ndo2` AS `ndo2`,`c`.`vigv` AS `vigv`,`c`.`idprov` AS `idprov`,`a`.`tipo` AS `tipo`,`c`.`tdoc` AS `tdoc`,`c`.`dolar` AS `dolar`,`c`.`mone` AS `mone`,`p`.`razo` AS `razo`,`p`.`dire` AS `dire`,`p`.`ciud` AS `ciud`,`p`.`nruc` AS `nruc`,ifnull(`x`.`idcaja`,0) AS `Idcaja`,`c`.`codt` AS `codt`,`a`.`dsnc` AS `dsnc`,`a`.`dsnd` AS `dsnd`,`a`.`gast` AS `gast`,`c`.`fusua` AS `fusua`,`w`.`nomb` AS `Usuario` from (((((`fe_rcom` `c` left join `fe_kar` `a` on((`c`.`idauto` = `a`.`idauto`))) left join `fe_art` `b` on((`b`.`idart` = `a`.`idart`))) join `fe_prov` `p` on((`p`.`idprov` = `c`.`idprov`))) left join `fe_caja` `x` on((`x`.`idauto` = `c`.`idauto`))) join `fe_usua` `w` on((`w`.`idusua` = `c`.`idusua`))) where ((`c`.`acti` <> 'I') and (`a`.`acti` <> 'I')) */;

/*View structure for view vmuestracotizaciones */

/*!50001 DROP TABLE IF EXISTS `vmuestracotizaciones` */;
/*!50001 DROP VIEW IF EXISTS `vmuestracotizaciones` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestracotizaciones` AS select `a`.`idart` AS `idart`,`b`.`descri` AS `descri`,`b`.`unid` AS `unid`,`a`.`cant` AS `cant`,`a`.`prec` AS `prec`,`b`.`pre1` AS `premay`,`b`.`pre2` AS `premen`,`c`.`fech` AS `fech`,`c`.`idautop` AS `idautop`,`c`.`impo` AS `impo`,`c`.`ndoc` AS `ndoc`,`c`.`aten` AS `aten`,`c`.`forma` AS `forma`,`c`.`plazo` AS `plazo`,`c`.`validez` AS `validez`,`c`.`entrega` AS `entrega`,`c`.`detalle` AS `detalle`,`d`.`idclie` AS `idclie`,`d`.`razo` AS `razo`,`d`.`nruc` AS `nruc`,`d`.`dire` AS `dire`,`c`.`rped_mone` AS `rped_mone`,`d`.`ciud` AS `ciud`,`d`.`fono` AS `fono`,`d`.`fax` AS `fax`,`a`.`idped` AS `nreg` from (((`fe_ped` `a` join `fe_rped` `c` on((`a`.`idautop` = `c`.`idautop`))) join `fe_art` `b` on((`b`.`idart` = `a`.`idart`))) left join `fe_clie` `d` on((`d`.`idclie` = `c`.`idclie`))) where ((`a`.`acti` <> 'I') and (`c`.`acti` <> 'I')) */;

/*View structure for view vmuestractascompras */

/*!50001 DROP TABLE IF EXISTS `vmuestractascompras` */;
/*!50001 DROP VIEW IF EXISTS `vmuestractascompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestractascompras` AS select left(`p`.`nomb`,3) AS `tdoc`,`b`.`ndoc` AS `ndoc`,`b`.`fecr` AS `fecr`,`a`.`ncta` AS `ncta`,`c`.`razo` AS `razo`,(case `x`.`ecta_tipo` when 'D' then if((`b`.`mone` = 'S'),`x`.`impo`,round((`x`.`impo` * `b`.`dolar`),2)) else 0 end) AS `Debe`,(case `x`.`ecta_tipo` when 'H' then if((`b`.`mone` = 'S'),`x`.`impo`,round((`x`.`impo` * `b`.`dolar`),2)) else 0 end) AS `Haber`,`a`.`idcta` AS `idcta`,`b`.`fech` AS `fech`,`a`.`nomb` AS `nomb`,`x`.`ecta_tipo` AS `tipo`,`b`.`idrcon` AS `idrcon`,`b`.`mone` AS `mone`,`c`.`idprov` AS `idprov` from ((((`fe_ectasc` `x` join `fe_plan` `a` on((`a`.`idcta` = `x`.`idcta`))) join `fe_rcon` `b` on((`b`.`idrcon` = `x`.`idrcon`))) join `fe_prov` `c` on((`c`.`idprov` = `b`.`idprov`))) join `fe_tdoc` `p` on((`p`.`idtdoc` = `b`.`idtdoc`))) where ((`x`.`impo` <> 0) and (`b`.`rcon_acti` = 'A')) */;

/*View structure for view vmuestractasdiario */

/*!50001 DROP TABLE IF EXISTS `vmuestractasdiario` */;
/*!50001 DROP VIEW IF EXISTS `vmuestractasdiario` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestractasdiario` AS select `a`.`ldia_fech` AS `Fecha`,`b`.`ncta` AS `ncta`,`a`.`ldia_glosa` AS `Glosa`,`a`.`ldia_debe` AS `Debe`,`a`.`ldia_haber` AS `Haber`,`a`.`ldia_idcta` AS `Idcta` from (`fe_ldiario` `a` join `fe_plan` `b` on((`b`.`idcta` = `a`.`ldia_idcta`))) where (`a`.`ldia_acti` = 'A') */;

/*View structure for view vmuestractasventas */

/*!50001 DROP TABLE IF EXISTS `vmuestractasventas` */;
/*!50001 DROP VIEW IF EXISTS `vmuestractasventas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestractasventas` AS select left(`p`.`nomb`,3) AS `tdoc`,`b`.`ndoc` AS `ndoc`,`b`.`fech` AS `fech`,`a`.`ncta` AS `ncta`,`c`.`razo` AS `razo`,(case `x`.`tipo` when 'D' then if((`b`.`mone` = 'S'),(`x`.`impo` + `x`.`ecta_total`),round(((`x`.`impo` + `x`.`ecta_total`) * `b`.`dolar`),2)) else 0 end) AS `Debe`,(case `x`.`tipo` when 'H' then if((`b`.`mone` = 'S'),(`x`.`impo` + `x`.`ecta_total`),round(((`x`.`impo` + `x`.`ecta_total`) * `b`.`dolar`),2)) else 0 end) AS `Haber`,`x`.`tipo` AS `tipo`,`a`.`idcta` AS `idcta`,`a`.`nomb` AS `nomb`,`b`.`idrven` AS `idrven`,`b`.`mone` AS `mone`,`c`.`idclie` AS `idclie` from ((((`fe_ectas` `x` join `fe_plan` `a` on((`a`.`idcta` = `x`.`idcta`))) join `fe_rven` `b` on((`b`.`idrven` = `x`.`idrven`))) join `fe_clie` `c` on((`c`.`idclie` = `b`.`idclie`))) join `fe_tdoc` `p` on((`p`.`idtdoc` = `b`.`idtdoc`))) where ((`x`.`impo` <> 0) and (`b`.`acti` <> 'I')) */;

/*View structure for view vmuestrarcompras */

/*!50001 DROP TABLE IF EXISTS `vmuestrarcompras` */;
/*!50001 DROP VIEW IF EXISTS `vmuestrarcompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestrarcompras` AS select `a`.`ndoc` AS `ndoc`,`a`.`fech` AS `fech`,`a`.`mone` AS `mone`,sum((case `b`.`nitem` when 8 then `b`.`impo` else 0 end)) AS `impo`,`a`.`idrcon` AS `idauto`,`d`.`tdoc` AS `tdoc1`,`a`.`dolar` AS `dolar` from ((`fe_rcon` `a` join `fe_ectasc` `b` on((`b`.`idrcon` = `a`.`idrcon`))) join `fe_tdoc` `d` on((`d`.`idtdoc` = `a`.`idtdoc`))) where (`d`.`tdoc` = '01') group by `a`.`idrcon` order by `a`.`idrcon` */;

/*View structure for view vpagosbancos */

/*!50001 DROP TABLE IF EXISTS `vpagosbancos` */;
/*!50001 DROP VIEW IF EXISTS `vpagosbancos` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpagosbancos` AS select concat(`w`.`ncta`,'  ',`v`.`ctas_ctas`) AS `ctasb`,`f`.`cban_clpr` AS `cban_clpr` from ((`fe_cbancos` `f` join `fe_ctasb` `v` on((`v`.`ctas_idct` = `f`.`cban_idba`))) join `fe_plan` `w` on((`w`.`idcta` = `v`.`ctas_ncta`))) where ((`f`.`cban_clpr` > 0) and (`f`.`cban_acti` = 'A')) order by `f`.`cban_clpr` */;

/*View structure for view vpdtespago */

/*!50001 DROP TABLE IF EXISTS `vpdtespago` */;
/*!50001 DROP VIEW IF EXISTS `vpdtespago` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpdtespago` AS select `a`.`ndoc` AS `ndoc`,max(`a`.`fevto`) AS `fevto`,`a`.`dola` AS `dola`,`a`.`nrou` AS `nrou`,`a`.`banc` AS `banc`,`a`.`iddeu` AS `iddeu`,`a`.`fech` AS `fech`,round(sum((`a`.`impo` - `a`.`acta`)),2) AS `saldo`,`b`.`rdeu_idpr` AS `Idpr`,`b`.`rdeu_impc` AS `ImporteC`,'C' AS `situa`,`b`.`rdeu_idau` AS `Idauto`,`a`.`ncontrol` AS `ncontrol`,`a`.`tipo` AS `tipo`,`a`.`banco` AS `banco`,ifnull(`c`.`ndoc`,'0') AS `docd`,ifnull(`c`.`tdoc`,'0') AS `tdoc`,`b`.`rdeu_mone` AS `Moneda`,`b`.`rdeu_codt` AS `Codt`,`b`.`rdeu_idrd` AS `Idrd` from ((`fe_deu` `a` join `fe_rdeu` `b` on((`b`.`rdeu_idrd` = `a`.`deud_idrd`))) left join `fe_rcom` `c` on((`c`.`idauto` = `b`.`rdeu_idau`))) where ((`b`.`rdeu_Acti` <> 'I') and (`a`.`acti` <> 'I')) group by `a`.`ncontrol` having (round(sum((`a`.`impo` - `a`.`acta`)),2) <> 0) order by max(`a`.`fevto`) */;

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
