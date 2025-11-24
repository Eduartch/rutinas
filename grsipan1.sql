/*
SQLyog Ultimate v12.09 (64 bit)
MySQL - 8.0.41 : Database - sysven_bdgrsipan
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/* Trigger structure for table `fe_art` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AProductos` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AProductos` AFTER UPDATE ON `fe_art` FOR EACH ROW begin
declare cdeta varchar(100) default '';
case
when old.premay<>new.premay then
    set cdeta=concat("Cambio Precio ",cast(old.premay as char), " Nuevo Precio ",cast(new.premay as char));
    insert into fe_aproductos(prod_idar,prod_idus,prod_fope,prod_deta)values(old.idart,new.prod_uact,localtime,cdeta);
when old.prod_uti1<>new.prod_uti1 then
    set cdeta=concat("Cambio Utilidad 1 ",cast(old.prod_uti1 as char), " Nuevo Utilidad 1 ",cast(new.prod_uti1 as char));
    insert into fe_aproductos(prod_idar,prod_idus,prod_fope,prod_deta)values(old.idart,new.prod_uact,localtime,cdeta);
when old.prod_uti2<>new.prod_uti2 then
    set cdeta=concat("Cambio Utilidad 2 ",cast(old.prod_uti2 as char), " Nuevo Utilidad 2 ",cast(new.prod_uti2 as char));
    insert into fe_aproductos(prod_idar,prod_idus,prod_fope,prod_deta)values(old.idart,new.prod_uact,localtime,cdeta);
when old.prod_uti3<>new.prod_uti3 then
    set cdeta=concat("Cambio Utilidad 3 ",cast(old.prod_uti3 as char), " Nuevo Utilidad 3 ",cast(new.prod_uti3 as char));
    insert into fe_aproductos(prod_idar,prod_idus,prod_fope,prod_deta)values(old.idart,new.prod_uact,localtime,cdeta);
when old.tmon<>new.tmon then
    set cdeta=concat("Cambio Moneda ",old.tmon, " Otra Moneda ",new.tmon);
    insert into fe_aproductos(prod_idar,prod_idus,prod_fope,prod_deta)values(old.idart,new.prod_uact,localtime,cdeta);
else
     set cdeta="";
end case;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_caja` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaCaja` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaCaja` AFTER UPDATE ON `fe_caja` FOR EACH ROW begin
   if new.acti='I' then
      insert into fe_acaja(acaj_caja,acaj_fech)values(old.idcaja,localtime);
   end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_cbancos` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaPagosCB` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaPagosCB` AFTER UPDATE ON `fe_cbancos` FOR EACH ROW begin
if new.cban_acti='I' then
   if old.cban_debe>0 then
       update fe_cred set acti='I' where cred_idcb=old.cban_idco;
   else
      update fe_deu set acti='I' where deud_idcb=old.cban_idco;
   end if;
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_cred` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaDcreditos` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaDcreditos` BEFORE UPDATE ON `fe_cred` FOR EACH ROW begin
if new.acti='I' then
   update fe_caja set acti='I' where idcred=old.idcred;
   insert into fe_aldcreditos(ldcr_iddc,ldcr_idus,ldcre_fech)
   values(old.cred_idrc,new.cred_idu1,localtime);
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_deu` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaCajaPagos` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaCajaPagos` BEFORE UPDATE ON `fe_deu` FOR EACH ROW begin
  if new.acti='I' and old.acta<> 0 then
     update fe_caja set acti='I' where caja_idde=old.iddeu;
  end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_ent` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `ActualizaEntregas` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `ActualizaEntregas` AFTER UPDATE ON `fe_ent` FOR EACH ROW begin
  if new.entr_acti='I' then
     insert into fe_aentregas(entr_ide1,entr_cant,entr_fope)values(old.entr_iden,old.entr_cant,localtime);
  end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_guias` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `ActualizaSalidaEntregaVentas` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `ActualizaSalidaEntregaVentas` AFTER UPDATE ON `fe_guias` FOR EACH ROW begin
if new.guia_acti='I' then
   insert into fe_aguias(ent1_idg1,ent1_idus,ent1_fope)values(old.guia_idgui,new.guia_idu1,localtime);
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_kar` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `Akardex` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `Akardex` AFTER UPDATE ON `fe_kar` FOR EACH ROW begin
if new.acti='I' then
      IF old.kar_idco>0 then
       update venta set estado=1 where idjournal=old.kar_idco;
    end if;
    call astock(old.idart,old.alma,old.cant,if(old.tipo="C","V","C"));
    insert into fe_akardex(logk_deta,logk_idar,logk_cant,logk_prec,
    logk_ida1,logk_idk1,logk_fech,logk_idco)values('Se Anulo ',old.idart,old.cant,old.prec,old.idauto,
    old.idkar,localtime,old.kar_idco);
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_lcaja` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaPagosCE` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaPagosCE` AFTER UPDATE ON `fe_lcaja` FOR EACH ROW begin
if new.lcaj_acti='I' then
   if old.lcaj_deud>0 then
       update fe_cred set acti='I' where cred_idce=old.lcaj_idca;
   else
      update fe_deu set acti='I' where deud_idce=old.lcaj_idca;
   end if;
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_ldiario` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaPagosdesdeDiarioC` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaPagosdesdeDiarioC` AFTER UPDATE ON `fe_ldiario` FOR EACH ROW begin
if new.ldia_acti='I' then
   update fe_cred set acti='I' where cred_iddi=old.ldia_idld;
   update fe_deu set acti='I' where deud_iddi=old.ldia_idld;
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_nccom` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaNotasCreditoCompras` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaNotasCreditoCompras` AFTER UPDATE ON `fe_nccom` FOR EACH ROW begin
   if old.ncre_ideu>0 and new.ncre_acti='I'  then
      update fe_deu set acti='I' where deud_idno=old.ncre_idan;
   end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_ncven` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaPagosNotasV` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaPagosNotasV` AFTER UPDATE ON `fe_ncven` FOR EACH ROW begin
   if old.ncre_idpa>0 and new.ncre_acti='I'  then
      update fe_cred set acti='I' where idcred=old.ncre_idpa;
   end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_rcom` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaMvtos` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaMvtos` AFTER UPDATE ON `fe_rcom` FOR EACH ROW begin
if new.acti='I' then
   update fe_caja set acti='I' where idauto=old.idauto;
   update fe_kar set acti='I' where idauto=old.idauto;
   update fe_costos set cost_acti='I' where cost_idau=old.idauto;
   update fe_lcaja set lcaj_acti='I' where lcaj_idau=old.idauto;
   if old.idprov>0 then
        update fe_rdeu set rdeu_acti='I' where rdeu_idau=old.idauto;
        update fe_nccom set ncre_acti='I' where ncre_idau=old.idauto;
        update fe_ectasc set ecta_acti='I' where idrcon=old.idauto;
     else
       update fe_rcred set rcre_acti='I',rcre_idus1=new.idusua1 where rcre_idau=old.idauto;
       update fe_rvendedor set vend_acti='I' where vend_idau=old.idauto;
       update fe_ncven set ncre_acti='I' where ncre_idau=old.idauto;
       update fe_ectas set acti='I' where idrven=old.idauto;
   end if;
   insert into fe_aresumen(lres_fech,lres_idau,lres_idus)values(localtime,old.idauto,new.idusua1);
 else
   insert into fe_aresumen(lres_fech,lres_idau,lres_idus,lres_tipo)values(localtime,old.idauto,new.idusua1,'A');
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_rcred` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaRcreditos` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaRcreditos` BEFORE UPDATE ON `fe_rcred` FOR EACH ROW begin
if new.rcre_acti='I' then
   update fe_cred set acti='I',cred_idu1=new.rcre_idus1 where cred_idrc=old.rcre_idrc;
   insert into fe_acreditos(lcre_fech,lcre_idus,lcre_rcre)values(localtime,new.rcre_idus1,old.rcre_idrc);
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_rdeu` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaDeudas` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaDeudas` AFTER UPDATE ON `fe_rdeu` FOR EACH ROW begin
if new.rdeu_acti='I' then
   update fe_deu set acti='I',deud_idu1=new.rdeu_idus1 where deud_idrd=old.rdeu_idrd;
   insert into fe_adeudas(ldeu_fech,ldeu_idus,ldeu_rdeu)values(localtime,old.rdeu_idus1,old.rdeu_idrd);
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_rped` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `anulapedido` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `anulapedido` BEFORE DELETE ON `fe_rped` FOR EACH ROW BEGIN
   DELETE FROM fe_ped WHERE idautop=old.idautop;
  END */$$


DELIMITER ;

/* Function  structure for function  `FunBuscaNombre` */

/*!50003 DROP FUNCTION IF EXISTS `FunBuscaNombre` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunBuscaNombre`(ct VARCHAR(50),cb VARCHAR(100),nid INTEGER) RETURNS int
BEGIN
DECLARE vdvto INTEGER DEFAULT 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
CASE
WHEN TRIM(ct)="Clientes" THEN
     IF nid=0 THEN
         SELECT idclie INTO vdvto FROM fe_clie WHERE TRIM(razo)=cb AND clie_acti<>'I';
     ELSE
   	    SELECT idclie INTO vdvto FROM fe_clie WHERE TRIM(razo)=cb AND idclie<>nid AND clie_acti<>'I';
     END IF;
WHEN TRIM(ct)="Proveedores" THEN
     IF nid=0 THEN
         SELECT idprov INTO vdvto FROM fe_prov WHERE TRIM(razo)=cb AND prov_acti<>'I';
     ELSE
   	    SELECT idprov INTO vdvto FROM fe_prov WHERE TRIM(razo)=cb AND idprov<>nid AND prov_acti<>'I';
     END IF;
WHEN TRIM(ct)="Productos" THEN
     IF nid=0 THEN
         SELECT idart INTO vdvto FROM fe_art WHERE TRIM(descri)=cb AND prod_acti<>'I';
     ELSE
   	    SELECT idart INTO vdvto FROM fe_art WHERE TRIM(descri)=cb AND idart<>nid AND prod_acti<>'I';
     END IF;
WHEN TRIM(ct)="Marcas" THEN
     IF nid=0 THEN
         SELECT idmar INTO vdvto FROM fe_mar WHERE TRIM(dmar)=cb AND marc_acti<>'I';
     ELSE
   	    SELECT idmar INTO vdvto FROM fe_mar WHERE TRIM(dmar)=cb AND idmar<>nid AND marc_acti<>'I';
     END IF;
WHEN TRIM(ct)="Lineas" THEN
     IF nid=0 THEN
         SELECT idcat INTO vdvto FROM fe_cat WHERE TRIM(dcat)=cb AND line_acti<>'I';
     ELSE
   	    SELECT idcat INTO vdvto FROM fe_cat WHERE TRIM(dcat)=cb AND idcat<>nid AND line_acti<>'I';
     END IF;
WHEN TRIM(ct)="Grupos" THEN
     IF nid=0 THEN
         SELECT idgrupo INTO vdvto FROM fe_grupo WHERE TRIM(desgrupo)=cb AND grup_acti<>'I';
     ELSE
   	    SELECT idgrupo INTO vdvto FROM fe_grupo WHERE TRIM(desgrupo)=cb AND idgrupo<>nid AND grup_acti<>'I';
     END IF;
WHEN TRIM(ct)="ProductosCod" THEN
     IF nid=0 THEN
         SELECT idart INTO vdvto FROM fe_art WHERE TRIM(coda1)=cb AND prod_acti<>'I';
     ELSE
   	    SELECT idart INTO vdvto FROM fe_art WHERE TRIM(coda1)=cb AND idart<>nid AND prod_acti<>'I';
     END IF;
WHEN TRIM(ct)="Presentaciones" THEN
     IF nid=0 THEN
         SELECT pres_idpr INTO vdvto FROM fe_presentaciones WHERE TRIM(pres_desc)=cb AND pres_acti<>'I';
     ELSE
   	    SELECT pres_idpr INTO vdvto FROM fe_presentaciones WHERE TRIM(pres_desc)=cb AND pres_idpr<>nid AND pres_acti<>'I';
     END IF;
WHEN TRIM(ct)="Usuarios" THEN
     IF nid=0 THEN
         SELECT idusua INTO vdvto FROM fe_usua WHERE TRIM(nomb)=cb AND activo<>'N';
     ELSE
   	    SELECT idusua INTO vdvto FROM fe_usua WHERE TRIM(nomb)=cb AND idusua<>nid AND activo<>'N';
     END IF;
WHEN TRIM(ct)="Fletes" THEN
     IF nid=0 THEN
         SELECT idflete INTO vdvto FROM fe_fletes WHERE TRIM(desflete)=cb AND flet_acti<>'I';
     ELSE
   	    SELECT idflete INTO vdvto FROM fe_fletes WHERE TRIM(desflete)=cb AND idflete<>nid AND flet_acti<>'I';
     END IF;
END CASE;
IF vdvto>0 THEN
   RETURN 0;
ELSE
   RETURN 1;
END IF;
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

/* Function  structure for function  `FunCreaAlmacen` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaAlmacen` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaAlmacen`(cnomb varchar(50),cdire varchar(50),cciud varchar(50),nser integer,nidus integer) RETURNS int
begin
declare nid integer default 0;
INSERT INTO fe_sucu(nomb,dire,ciud,sucuidserie,sucu_idus)VALUES (cnomb,cdire,cciud,nser,nidus);
select last_insert_id() into nid from fe_sucu group by last_insert_id();
return nid;
end */$$
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

/* Function  structure for function  `FunCreaCLiente` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaCLiente` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaCLiente`(cruc varchar(11),crazo varchar(100),
cdire varchar(100),cciud varchar(100),cfono varchar(15),cfax varchar(15),cdni varchar (11),
ctipo char,cemail varchar(120),nidven integer,nidus integer,cpc varchar(45),ccelu varchar(15),
crefe varchar(255),linea float,crpm varchar(10),nidz integer) RETURNS int
BEGIN
declare nid integer default 0;
INSERT INTO fe_clie(nruc,razo,dire,ciud,fono,fax,ndni,clie_tipo,clie_corr,clie_codv,clie_idus,idpcclie,
fechclie,celu,refe,clie_lcre,clie_rpm,clie_idzo)
VALUES (cruc,crazo,cdire,cciud,cfono,cfax,cdni,ctipo,cemail,nidven,nidus,cpc,localtime,ccelu,crefe,linea,crpm,nidz);
select last_insert_id() into nid from fe_clie group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaCliPro` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaCliPro` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaCliPro`(cruc varchar(11),crazo varchar(60),cdire varchar(60),cciud varchar(60),
cfono varchar(10),cfax varchar(10),opt integer,cdni varchar(10)) RETURNS int
BEGIN
declare nid integer;
set nid=0;
if opt=0 then
   INSERT INTO fe_prov(nruc,razo,dire,ciud,fono,fax)
   VALUES (cruc,crazo,cdire,cciud,cfono,cfax);
   select last_insert_id() into nid from fe_prov group by last_insert_id();
 else
   INSERT INTO fe_clie(nruc,razo,dire,ciud,fono,fax,ndni)
   VALUES (cruc,crazo,cdire,cciud,cfono,cfax,cdni);
   select last_insert_id() into nid from fe_clie group by last_insert_id();
end if;
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FuncreaConceptosCaja` */

/*!50003 DROP FUNCTION IF EXISTS `FuncreaConceptosCaja` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FuncreaConceptosCaja`(cdescri varchar(50),ctipo char,ctdoc varchar(3),cusua VARCHAR(45),cidpc VARCHAR(50),
norden integer,idcon1 integer) RETURNS int
begin
declare vdvto integer;
  INSERT INTO fe_con(nomb,tipo,tdoc,fechconc,usuaconc,idpcconc,orden,conc_iddc)
  VALUES (cdescri,ctipo,ctdoc,localtime,cusua,cidpc,norden,idcon1);
  select last_insert_id() into vdvto from fe_con group by last_insert_id();
  return vdvto;
end */$$
DELIMITER ;

/* Function  structure for function  `FunCreaCtasBancos` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaCtasBancos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaCtasBancos`(cta varchar(100),idb1 integer,cmone char,cdeta varchar(100),nidctap integer) RETURNS int
BEGIN
declare idb integer;
insert into fe_ctasb(ctas_ctas,ctas_idba,ctas_mone,ctas_deta,ctas_ncta)
values(cta,idb1,cmone,cdeta,nidctap);
select last_insert_id() into idb from fe_ctasb group by last_insert_id();
return idb;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaDctos` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaDctos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaDctos`(cdes varchar(45),ctdoc varchar(2)) RETURNS int
BEGIN
declare id integer default 0;
insert into fe_tdoc(tdoc,noMb)values(CTDOC,cdes);
select last_insert_id() into id from fe_tdoc group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaEmpleado` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaEmpleado` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaEmpleado`(crazo varchar(80),
cfono varchar(20),nsueldo float,nidus integer,cidpc varchar(45),crefe varchar(80)) RETURNS int
BEGIN
declare nid integer;
INSERT INTO fe_empl(empl_nomb,empl_fono,empl_suel,empl_idus,empl_fech,empl_idpc,empl_refe)
VALUES (crazo,cfono,nsueldo,nidus,current_date(),cidpc,crefe);
select last_insert_id() into nid from fe_empl group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaFletes` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaFletes` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaFletes`(cdescri varchar(45),
nprecio float,nidus integer,cidpc varchar(45)) RETURNS int
BEGIN
declare nid integer default 0;
INSERT INTO fe_fletes(desflete,prec,flet_idus,idpcflete,fechflete)
VALUES (cdescri,nprecio,nidus,cidpc,localtime());
select last_insert_id() into nid from fe_fletes group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaGrupo` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaGrupo` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaGrupo`(cdescri varchar(60),nidus integer,cidpc varchar(45)) RETURNS int
BEGIN
declare id integer default 0;
INSERT INTO fe_grupo(desgrupo,fechgrupo,grup_idus,idpcgrupo)VALUES (cdescri,localtime,nidus,cidpc);
select last_insert_id() into id from fe_grupo group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaLinea` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaLinea` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaLinea`(cdescri varchar(100),nidus integer,cidpc varchar(45),
nutil1 float,nutil2 float,nidgrupo integer) RETURNS int
BEGIN
declare nid integer default 0;
INSERT INTO fe_cat(dcat,line_idus,idpccat,util1,util2,idgrupo,fechcat)
VALUES (cdescri,nidus,cidpc,nutil1,nutil2,nidgrupo,localtime());
select last_insert_id() into nid from fe_cat group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaMarcas` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaMarcas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaMarcas`(cdescri varchar(100),
nidus integer,cidpc varchar(45)) RETURNS int
BEGIN
declare nid integer default 0;
INSERT INTO fe_mar(dmar,fechcm,marc_idus,idpcm)VALUES (cdescri,localtime(),nidus,cidpc);
select last_insert_id() into nid from fe_mar group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaPlanCuentas` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaPlanCuentas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaPlanCuentas`(cn varchar(8),cdes varchar(60),
cdd varchar(8),cdh varchar(8),cuenta varchar(12),cope char) RETURNS int
BEGIN
declare nid integer;
INSERT INTO fe_plan(ncta,nomb,cdestinod,cdestinoh,tipocta,plan_oper)values(cn,cdes,cdd,cdh,cuenta,cope);
select last_insert_id() into nid from fe_plan group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FuncreaProductos` */

/*!50003 DROP FUNCTION IF EXISTS `FuncreaProductos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FuncreaProductos`(cdesc VARCHAR(100),cunid VARCHAR(10),nprec FLOAT,ncosto FLOAT,
np1 FLOAT,np2 FLOAT,np3 FLOAT,npeso FLOAT,ccat INTEGER,cmar INTEGER,ctipro CHAR,nflete INTEGER,cm CHAR,cidpc VARCHAR(45),
ncome FLOAT,ncomc FLOAT,nutil1 FLOAT,nutil2 FLOAT,nutil3 FLOAT,nidusua INTEGER,nsmin FLOAT,nsmax FLOAT,ccodigo1 VARCHAR(20),ndolar FLOAT) RETURNS int
BEGIN
DECLARE nid INTEGER DEFAULT 0;
INSERT INTO fe_art(descri,unid,prec,cost,premay,premen,pre3,peso,idcat,idmar,tipro,idflete,tmon,fechc,idpc,prod_come,
prod_comc,prod_uti1,prod_uti2,prod_uti3,prod_idus,prod_smin,prod_smax,coda1,prod_dola)
VALUES (cdesc,cunid,nprec,ncosto,np1,np2,np3,npeso,ccat,cmar,ctipro,nflete,cm,LOCALTIME,
cidpc,ncome,ncomc,nutil1,nutil2,nutil3,nidusua,nsmin,nsmax,ccodigo1,ndolar);
SELECT LAST_INSERT_ID() INTO nid FROM fe_art GROUP BY LAST_INSERT_ID();
RETURN nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FuncreaProductos1` */

/*!50003 DROP FUNCTION IF EXISTS `FuncreaProductos1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FuncreaProductos1`(cdesc varchar(100),cunid varchar(10),nprec float,ncosto float,
np1 float,np2 float,np3 float,npeso float,ccat integer,cmar integer,ctipro char,nflete integer,cm char,cidpc varchar(45),
nidgrupo integer,ncome float,ncomc float,nutil1 float,nutil2 float,nutil3 float,nidusua integer,nsmin float,nsmax float,
ccoda1 varchar(6),ndolar float) RETURNS int
BEGIN
declare nid integer default 0;
INSERT INTO fe_art(descri,unid,prec,cost,premay,premen,pre3,peso,idcat,idmar,tipro,idflete,tmon,fechc,idpc,prod_come,
prod_comc,prod_uti1,prod_uti2,prod_uti3,prod_idus,prod_smin,prod_smax,coda1,prod_dola)
VALUES (cdesc,cunid,nprec,ncosto,np1,np2,np3,npeso,ccat,cmar,ctipro,nflete,cm,current_date(),
cidpc,ncome,ncomc,nutil1,nutil2,nutil3,nidusua,nsmin,nsmax,ccoda1,ndolar);
select last_insert_id() into nid from fe_art group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaProveedor` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaProveedor` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaProveedor`(cruc varchar(11),crazo varchar(100),cdire varchar(100),cciud varchar(100),
cfono varchar(10),cfax varchar(10),crpm varchar(10),correo varchar(45),crefe varchar(200),ccelu varchar(10),
nidus integer,cpc varchar(45)) RETURNS int
BEGIN
declare nid integer default 0;
INSERT INTO fe_prov(nruc,razo,dire,ciud,fono,fax,prov_rpm,email,refe,celu,prov_idus,idpcprov,fechprov)
VALUES (cruc,crazo,cdire,cciud,cfono,cfax,crpm,correo,crefe,ccelu,nidus,cpc,localtime);
select last_insert_id() into nid from fe_prov group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaSeriesDctos` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaSeriesDctos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaSeriesDctos`(cserie integer,cnume integer,ctdoc varchar(2),nitems integer,ntda integer) RETURNS int
BEGIN
declare ids integer default 0;
insert into fe_serie(tdoc,serie,nume,codt,items,seri_idal)
values(ctdoc,cserie,cnume,ntda,nitems,ntda);
select last_insert_id() into ids from fe_serie group by last_insert_id();
return ids;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaTransportista` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaTransportista` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaTransportista`(cplaca VARCHAR(10),crazo VARCHAR(100),
cdir VARCHAR(100),nruc VARCHAR(11),chofe VARCHAR(100),cbreve VARCHAR(15),
cmarca VARCHAR(20),ccons VARCHAR(30),nidus INTEGER,cplaca1 VARCHAR(10),ctipot VARCHAR(2),const1 VARCHAR(30)) RETURNS int
BEGIN
DECLARE nid INTEGER DEFAULT 0;
INSERT  INTO fe_tra(placa,razon,dirtr,ructr,nombr,breve,marca,cons,tran_idus,placa1,tran_tipo,tran_cons1)
VALUES(cplaca,crazo,cdir,nruc,chofe,cbreve,cmarca,ccons,nidus,cplaca1,ctipot,const1);
SELECT LAST_INSERT_ID() INTO nid FROM fe_tra GROUP BY LAST_INSERT_ID();
RETURN nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaTurno` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaTurno` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaTurno`(df date,cturno varchar(5),dinic datetime,dfinal datetime,crefe varchar(100),nidus integer,nalma integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_turnos(turn_fech,turn_inic,turn_fina,turn_refe,turn_idus,turn_alma,turn_fope,turn_turn)
VALUES (df,dinic,dfinal,crefe,nidus,nalma,localtime,cturno);
select last_insert_id() into nid from fe_turnos group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaZona` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaZona` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaZona`(cnom varchar(50),cpc varchar(50),nidus integer,nidzona integer) RETURNS int
BEGIN
declare id integer default 0;
insert into fe_zona(zona_nomb,zona_idus,zona_idpc,zona_fech,zona_idzz)values(cnom,nidus,cpc,localtime,nidzona);
select last_insert_id() into id from fe_zona group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunCreaZonaP` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaZonaP` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaZonaP`(cnom varchar(50),cpc varchar(50),nidus integer) RETURNS int
BEGIN
declare id integer default 0;
insert into fe_zonap(zona_nomb,zona_idus,zona_idpc,zona_fech)values(cnom,nidus,cpc,localtime);
select last_insert_id() into id from fe_zonap group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunDetalleGuiasCons` */

/*!50003 DROP FUNCTION IF EXISTS `FunDetalleGuiasCons` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunDetalleGuiasCons`(nidart integer,ncant decimal(12,2),nidg integer,nidkar integer) RETURNS int
BEGIN
declare idg integer default 0;
insert into fe_ent(entr_idar,entr_cant,entr_idgu,entr_idkar)values(nidart,ncant,nidg,nidkar);
select last_insert_id() into idg from fe_ent group by last_insert_id();
return idg;
END */$$
DELIMITER ;

/* Function  structure for function  `FunDetalleGuiaVentas` */

/*!50003 DROP FUNCTION IF EXISTS `FunDetalleGuiaVentas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunDetalleGuiaVentas`(nidk integer,ncant float,nidg integer) RETURNS int
BEGIN
declare idg integer default 0;
insert into fe_ent(entr_idkar,entr_cant,entr_idgu)values(nidk,ncant,nidg);
select last_insert_id() into idg from fe_ent group by last_insert_id();
return idg;
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

/*!50003 CREATE FUNCTION `FunHayCompra`(cdcto varchar(12),ctdoc varchar(2),idp integer,nidauto integer) RETURNS int
BEGIN
declare sw integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET sw=0;
if nidauto=0 then
   select idauto into sw from fe_rcom where ndoc=cdcto and tdoc=ctdoc and idprov=idp and acti<>'I'  group by idauto;
  else
   select idauto into sw from fe_rcom where ndoc=cdcto and tdoc=ctdoc and idprov=idp and idauto<>nidauto and acti<>'I' group by idauto;
end if;
return sw;
END */$$
DELIMITER ;

/* Function  structure for function  `FunHayTraspaso` */

/*!50003 DROP FUNCTION IF EXISTS `FunHayTraspaso` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunHayTraspaso`(cdcto varchar(10),ctdoc varchar(2),nidauto integer) RETURNS int
BEGIN
declare sw integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET sw=0;
select idauto into sw from fe_rcom where ndoc=cdcto and tdoc=ctdoc and tcom='T' and acti<>'I' and idauto<>nidauto;
return sw;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCabeceraCanjeado` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCabeceraCanjeado` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCabeceraCanjeado`(
ctdoc varchar(2),cform char,cndoc varchar(12),dfecha date,dfechar date,cdetalle varchar(120),
nv float,nigv float,nt float,cndo2 varchar(10),cm char,
ndolar float,ni float,ctg char,ccodp integer,cmvto char,nus integer,opt integer,nidcodt integer,
n1 integer,n2 integer,n3 integer,nitem integer,npvta float) RETURNS int
BEGIN
declare nid,ntdoc,idce,idve integer;
declare ctipo char;
set ntdoc=0;
set nid=0;
  select gene_idve into idve from fe_gene where idgene=1;
   if ctdoc='20' then
      set ctipo='I';
    else
      set ctipo='C';
   end if;
   INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,
   dolar,vigv,tcom,idcliente,tipom,fusua,idusua,codt,rcom_nitem,rcom_tipo,rcom_fech,rcom_canj)
   VALUES (ctdoc,cform,cndoc,dfecha,dfecha,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,
   ctg,ccodp,cmvto,localtime,nus,nidcodt,nitem,ctipo,dfecha,npvta);
   select last_insert_id() into nid from fe_rcom group by last_insert_id();
   if n1>0 and n2>0 and n3>0 then
      call IngresaCuentasV(nv,nigv,nt,n1,n2,n3,"H","H","D",nid);
      if idve>0 and cform='E' and ctdoc<>'20' then
        Call ProIngresaDatosLcajaE1(dfecha,"",concat("Venta al Contado No Dcto ",cndoc),idve,nt,0,cm,ndolar,nus,ccodp,nid);
       end if;
   end if;
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCabeceraCotizacion` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCabeceraCotizacion` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCabeceraCotizacion`(dfech datetime,nidclie integer,
cndoc varchar(10),ctdoc varchar(2),nimpo float,cform char,cusua integer,cidpcped varchar(45),nidven integer,nidtienda integer,ctp char,
caten varchar(150),cforma varchar(150),cplazo varchar(150),cvalidez varchar(150),centrega varchar(150),cdetalle varchar(200),cmone char) RETURNS int
BEGIN
declare nid integer default 0;
INSERT INTO fe_rped(fech,idclie,ndoc,tdoc,impo,form,rped_idus,idpcped,fecho,idven,idtienda,tipopedido,aten,forma,plazo,validez,entrega,detalle,rped_mone)
VALUES(dfech,nidclie,cndoc,ctdoc,nimpo,cform,cusua,cidpcped,localtime,nidven,nidtienda,ctp,caten,cforma,cplazo,cvalidez,centrega,cdetalle,cmone);
select last_insert_id() into nid from fe_rped group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCabeceraCotizacion1` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCabeceraCotizacion1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCabeceraCotizacion1`(dfech datetime,nidclie integer,
cndoc varchar(10),ctdoc varchar(2),nimpo float,cform char,cusua integer,cidpcped varchar(45),nidven integer,nidtienda integer,ctp char,
caten varchar(80),cforma varchar(80),cplazo varchar(80),cvalidez varchar(80),centrega varchar(80),cdetalle varchar(150),ctvta char) RETURNS int
BEGIN
declare nid integer default 0;
INSERT INTO fe_rped(fech,idclie,ndoc,tdoc,impo,form,rped_idus,idpcped,fecho,idven,idtienda,tipopedido,aten,forma,plazo,validez,entrega,detalle,rped_tipo)
VALUES(dfech,nidclie,cndoc,ctdoc,nimpo,cform,cusua,cidpcped,localtime,nidven,nidtienda,ctp,caten,cforma,cplazo,cvalidez,centrega,cdetalle,ctvta);
select last_insert_id() into nid from fe_rped group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCabeceraCV` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCabeceraCV` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCabeceraCV`(
ctdoc varchar(2),cform char,cndoc varchar(12),dfecha date,dfechar date,cdetalle varchar(120),
nv decimAL(12,2),nigv decimal(12,2),nt decimal(12,2),cndo2 varchar(10),cm char,
ndolar float,ni float,ctg char,ccodp integer,cmvto char,nus integer,opt integer,nidcodt integer,
n1 integer,n2 integer,n3 integer,nisla integer,npvta float) RETURNS int
BEGIN
declare nid integer;
declare ctipo char;
set nid=0;
 if ctdoc='01' or ctdoc='09' or ctdoc='II' or ctdoc='07' or ctdoc='08'or ctdoc='03' then
      set ctipo='C';
     else
      set ctipo='I';
 end if;
if opt=0 then
   INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,
   dolar,vigv,tcom,idprov,tipom,fusua,idusua,codt,rcom_tipo,pimpo)
   VALUES (ctdoc,cform,cndoc,dfecha,dfechar,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,
   ni,ctg,ccodp,cmvto,localtime,nus,nidcodt,ctipo,npvta);
   select last_insert_id() into nid from fe_rcom group by last_insert_id();
    if n1>0 and n2>0 and n3>0 then
      call IngresaCuentas(nv,0,0,0,nigv,0,0,nt,n1,0,0,0,n2,0,0,n3,"D","","","","D","","","H",nid);
      end if;
  else
   INSERT INTO fe_correvtas(auto_corr)VALUES(CONCAT(ctdoc,cndoc));   
   INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,
   dolar,vigv,tcom,idcliente,tipom,fusua,idusua,codt,rcom_tipo,pimpo,rcom_idis)
   VALUES (ctdoc,cform,cndoc,dfecha,dfecha,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,
   ctg,ccodp,cmvto,localtime,nus,nidcodt,ctipo,npvta,nisla);
   select last_insert_id() into nid from fe_rcom group by last_insert_id();
   if n1>0 and n2>0 and n3>0 then
      call IngresaCuentasV(nv,nigv,nt,n1,n2,n3,"H","H","D",nid);
   end if;
end if;
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCabeceraPedido` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCabeceraPedido` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCabeceraPedido`(dfech date,nidclie integer,cndoc varchar(10),
ctdoc varchar(2),nimpo float,cform char,nidus integer,cidpcped varchar(45),nidven integer,nidtienda integer,ctipop char) RETURNS int
BEGIN
declare nid integer default 0;
INSERT INTO fe_rped(fech,idclie,ndoc,tdoc,impo,form,rped_idus,idpcped,fecho,idven,idtienda,tipopedido)
VALUES(dfech,nidclie,cndoc,ctdoc,nimpo,cform,nidus,cidpcped,localtime,nidven,nidtienda,ctipop);
select last_insert_id() into nid from fe_rped group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCabeceraTraspasoN` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCabeceraTraspasoN` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCabeceraTraspasoN`(
ctdoc varchar(2),cform char,cndoc varchar(10),dfecha date,dfechar date,cdetalle varchar(120),
nv float,nigv float,nt float,cndo2 varchar(10),cm char,
ndolar float,ni float,ctg char,ccodp integer,cmvto char,nus integer,opt integer,nidcodt integer,
n1 integer,n2 integer,n3 integer,nitem integer,npvta float,copt char) RETURNS int
BEGIN
declare nid integer;
INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,dolar,vigv,tcom,tipom,
fusua,idusua,codt,rcom_nitem,rcom_reci)
VALUES (ctdoc,cform,cndoc,dfecha,dfecha,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,ctg,cmvto,
localtime,nus,nidcodt,nitem,copt);
select last_insert_id() into nid from fe_rcom group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCabeceraVtascdetraccion` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCabeceraVtascdetraccion` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCabeceraVtascdetraccion`(
ctdoc VARCHAR(2),cform CHAR,cndoc VARCHAR(12),dfecha DATE,cdetalle VARCHAR(120),
nv DECIMAL(12,2),nigv DECIMAL(12,2),nt DECIMAL(12,2),cndo2 VARCHAR(10),cm CHAR,
ndolar FLOAT,ni FLOAT,ctg CHAR,ccodp INTEGER,cmvto CHAR,nus INTEGER,opt INTEGER,nidcodt INTEGER,
n1 INTEGER,n2 INTEGER,n3 INTEGER,nexonerada DECIMAL(12,2),ndetraccion DECIMAL(10,2),cdetra VARCHAR(10),niddire INTEGER) RETURNS int
BEGIN
DECLARE nid INTEGER;
SET nid=0;
   INSERT INTO fe_correvtas(auto_corr)VALUES(CONCAT(ctdoc,cndoc));
   INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,dolar,vigv,tcom,idcliente,tipom,
   fusua,idusua,codt,rcom_exon,rcom_mdet,rcom_detr,alma)
   VALUES (ctdoc,cform,cndoc,dfecha,dfecha,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,ctg,ccodp,cmvto,LOCALTIME,nus,nidcodt,nexonerada,ndetraccion,cdetra,niddire);
   SELECT LAST_INSERT_ID() INTO nid FROM fe_rcom GROUP BY LAST_INSERT_ID();
   IF n1>0 AND n2>0 AND n3>0 THEN
      CALL IngresaCuentasV(nv,nigv,nt,n1,n2,n3,"H","H","D",nid);
   END IF;
RETURN nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCaja` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCaja` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCaja`(
na integer,dfecha date,nt1 float,cmvtoc char,cform char,cm1 char,cndoc varchar(12),nidcon integer,
cu integer,cdetalle varchar(180),cor varchar(2),nimp1 float,cm2 char,tcvta float,nidcodt integer,cajas char,nidcredito int,ide integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
if cajas='A' then
   INSERT INTO fe_caja(idauto,fech,caja_nimp,tipo,forma,tmon,ndoc,idcon,idusua,fechao,deta,origen,nimpo,mone,dola,codt,idcred,caja_idem)
   VALUES (na,dfecha,nt1,cmvtoc,cform,cm1,cndoc,nidcon,cu,localtime,cdetalle,cor,nimp1,cm2,tcvta,nidcodt,nidcredito,ide);
 else
   INSERT INTO fe_caja(idauto,fech,impo,tipo,forma,tmon,ndoc,idcon,idusua,fechao,deta,origen,nimpo,mone,dola,codt,idcred,caja_idem)
   VALUES (na,dfecha,nt1,cmvtoc,cform,cm1,cndoc,nidcon,cu,localtime,cdetalle,cor,nimp1,cm2,tcvta,nidcodt,nidcredito,ide);
end if;
select last_insert_id() into nid from fe_caja group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCaja1` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCaja1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCaja1`(
na integer,dfecha date,nt1 float,cmvtoc char,cform char,cm1 char,cndoc varchar(12),nidcon integer,
cu integer,cdetalle varchar(120),cor varchar(2),nimp1 float,cm2 char,tcvta float,
nidcodt integer,cajas char,nidcredito int,ide integer,si char) RETURNS int
BEGIN
declare nid integer;
set nid=0;
update fe_caja set acti='I' where idusua=cu and caja_sald='S' and fech=dfecha;
INSERT INTO fe_caja(idauto,fech,impo,tipo,forma,tmon,ndoc,idcon,idusua,fechao,deta,origen,nimpo,mone,dola,codt,idcred,caja_idem,caja_sald)
VALUES (na,dfecha,nt1,cmvtoc,cform,cm1,cndoc,nidcon,cu,localtime,cdetalle,cor,nimp1,cm2,tcvta,nidcodt,nidcredito,ide,'S');
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

/* Function  structure for function  `FunIngresaCajaBancos1` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCajaBancos1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCajaBancos1`(idb integer,dfecha date,nop varchar(20),idmp integer,
cdeta varchar(120),idpr integer,idcl integer,cndoc varchar(20),idcta integer,debe decimal(12,2),
haber decimal(12,2),norden integer,nidclpr integer,ctipo char) RETURNS int
BEGIN
declare id integer;
insert into fe_cbancos(cban_idba,cban_nume,cban_fech,cban_idmp,cban_deta,cban_idpr,cban_idcl,cban_ndoc,cban_idct,
cban_debe,cban_haber,cban_orde,cban_clpr,cban_tipo)values(idb,nop,dfecha,idmp,cdeta,idpr,idcl,cndoc,idcta,debe,haber,norden,nidclpr,ctipo);
select last_insert_id() into id from fe_cbancos group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCajaBancosT` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCajaBancosT` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCajaBancosT`(idb integer,dfecha date,nop varchar(20),idmp integer,
cdeta varchar(180),idpr integer,idcl integer,cndoc varchar(20),idcta integer,debe decimal(12,2),
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

/* Function  structure for function  `FunIngresaCajaE` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCajaE` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCajaE`(
na integer,dfecha date,nt1 float,cmvtoc char,cform char,cm1 char,cndoc varchar(12),nidcon integer,
cu integer,cdetalle varchar(120),cor varchar(2),nimp1 float,cm2 char,tcvta float,nidcodt integer,cajas char,nidcredito int,ide integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_caja(idauto,fech,impo,tipo,forma,tmon,ndoc,idcon,idusua,fechao,deta,origen,nimpo,mone,dola,codt,caja_idde,caja_idem)
VALUES (na,dfecha,nt1,cmvtoc,cform,cm1,cndoc,nidcon,cu,localtime,cdetalle,cor,nimp1,cm2,tcvta,nidcodt,nidcredito,ide);
select last_insert_id() into nid from fe_caja group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCajaVendedor` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCajaVendedor` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCajaVendedor`(
na integer,dfecha date,nt1 float,cmvtoc char,cform char,cm1 char,cndoc varchar(10),nidcon integer,
cu integer,cdetalle varchar(120),cor varchar(2),nimp1 float,cm2 char,tcvta float,nidcodt integer,cajas char,nidcredito integer,
ide integer,nidv integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_caja(idauto,fech,impo,tipo,forma,tmon,ndoc,idcon,idusua,fechao,deta,origen,nimpo,mone,dola,codt,idcred,caja_idem,caja_idc1)
VALUES (na,dfecha,nt1,cmvtoc,cform,cm1,cndoc,nidcon,cu,localtime,cdetalle,cor,nimp1,cm2,tcvta,nidcodt,nidcredito,ide,nidv);
select last_insert_id() into nid from fe_caja group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCajaVendedortmp` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCajaVendedortmp` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCajaVendedortmp`(
na integer,dfecha date,nt1 float,cmvtoc char,cform char,cm1 char,cndoc varchar(15),nidcon integer,
cu integer,cdetalle varchar(120),cor varchar(2),nimp1 float,cm2 char,tcvta float,nidcodt integer,cajas char,nidcredito integer,
ide integer,nidv integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_caja(idauto,fech,caja_impo,tipo,forma,tmon,ndoc,idcon,idusua,fechao,deta,origen,nimpo,mone,dola,codt,idcred,caja_idem,caja_idc1)
VALUES (na,dfecha,nt1,cmvtoc,cform,cm1,cndoc,nidcon,cu,localtime,cdetalle,cor,nimp1,cm2,tcvta,nidcodt,nidcredito,ide,nidv);
select last_insert_id() into nid from fe_caja group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCajaVtas` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCajaVtas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCajaVtas`(
na integer,dfecha date,nt1 float,cmvtoc char,cform char,cm1 char,cndoc varchar(12),nidcon integer,
cu integer,cdetalle varchar(120),cor varchar(2),nimp1 float,cm2 char,tcvta float,nidcodt integer,cajas char,nidcredito int,ide integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_caja(idauto,fech,impo,tipo,forma,tmon,ndoc,idcon,idusua,fechao,deta,origen,nimpo,mone,dola,codt,idcred,idusuavtas)
VALUES (na,dfecha,nt1,cmvtoc,cform,cm1,cndoc,nidcon,cu,localtime,cdetalle,cor,nimp1,cm2,tcvta,nidcodt,nidcredito,ide);
select last_insert_id() into nid from fe_caja group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCambiosVtas` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCambiosVtas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCambiosVtas`(nida integer,nidac integer,nidart integer,ncant float,nprec float,nidus integer,cpc varchar(50)) RETURNS int
BEGIN
declare id integer default 0;
insert into fe_cambiosvtas(camb_idaa,camb_idac,camb_idart,camb_cant,camb_prec,camb_idus,camb_fope,camb_idpc)
values(nida,nidac,nidart,ncant,nprec,nidus,localtime,cpc);
select last_insert_id() into id from fe_cambiosvtas group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCanjePedidosF` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCanjePedidosF` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCanjePedidosF`(dfecha date,nidus integer) RETURNS int
begin
declare nid integer default 0;
insert into fe_canjesn(canj_fech,canj_idus)values(dfecha,nidus);
select last_insert_id() into nid from fe_canjesn group by last_insert_id();
return nid;
end */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCheques` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCheques` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCheques`(nidb integer,cnumero varchar(45),dfechag date,
dfechac date,cmone char,nimpo float,nidch integer,nidus integer) RETURNS int
BEGIN
declare nid integer;
insert into fe_cheques(cheq_idba,cheq_nume,cheq_fecg,cheq_fecc,cheq_mone,cheq_impo,cheq_idrc,cheq_fech,cheq_idus)
values(nidb,cnumero,dfechag,dfechac,cmone,nimpo,nidch,localtime(),nidus);
select last_insert_id() into nid from fe_cheques group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCostos` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCostos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCostos`(ncosto float,
nidauto integer,nidart integer,nflete float,nprec float,cmone char,ndola float,dfecha date) RETURNS int
BEGIN
declare nid integer;
insert into fe_costos(cost_cost,cost_idau,cost_idart,cost_flet,cost_prec,cost_mone,cost_dola,cost_fech)
values(ncosto,nidauto,nidart,nflete,nprec,cmone,ndola,dfecha);
select last_insert_id() into nid from fe_costos group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCreditos` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCreditos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCreditos`(
nauto integer,nidcl integer,cndoc varchar(12),cest char,cmon char,crefe varchar(120),
dfecha date,dfevto date,ctipo char,cdocp varchar(10),ndolar float,csitua varchar(2),
nimpo float,ni float,idven integer,nimpoo float,cusua integer,nidaval integer,ndscto float,
cpc varchar(50),nidcodt integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_cred(idauto,idclie,ndoc,estd,mone,banc,fech,fevto,tipo,docd,dola,situa,impo,
inic,idven,impc,idusua,idaval,dscto,cre_idpc,cre_fope,codt)values(nauto,nidcl,cndoc,cest,cmon,crefe,dfecha,dfevto,
ctipo,cdocp,ndolar,csitua,nimpo,ni,idven,nimpoo,cusua,nidaval,ndscto,cpc,curdate(),nidcodt);
select last_insert_id() into nid from fe_cred group by last_insert_id();
UPDATE fe_cred SET ncontrol=nid,inic=ni WHERE idcred=nid;
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaDatosLcajaE` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDatosLcajaE` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDatosLcajaE`(dfecha datetime,cndoc varchar(10),cdeta varchar(100),idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),cmone char,ndolar decimal(5,3),nidus integer,nidcp integer) RETURNS int
begin
declare id integer;
insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,lcaj_idus,lcaj_clpr)values
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp);
select last_insert_id() into id from fe_lcaja group by last_insert_id();
return id;
end */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaDatosLcajaE1` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDatosLcajaE1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDatosLcajaE1`(dfecha date,cndoc varchar(10),cdeta varchar(100),idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),cmone char,ndolar decimal(5,3),nidus integer,nidcp integer,nidauto integer) RETURNS int
begin
declare id integer;
insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,
lcaj_idus,lcaj_clpr,lcaj_idau)values
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,nidauto);
select last_insert_id() into id from fe_lcaja group by last_insert_id();
return id;
end */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaDatosLcajaEe` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDatosLcajaEe` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDatosLcajaEe`(dfecha datetime,cndoc varchar(10),cdeta varchar(100),idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),cmone char,ndolar decimal(5,3),nidus integer,nidcp integer) RETURNS int
begin
declare id integer;
if sdeudor>0 then
   insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,lcaj_idus,lcaj_idcr)values
   (dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp);
else
   insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,lcaj_idus,lcaj_idde)values
   (dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp);
end if;
select last_insert_id() into id from fe_lcaja group by last_insert_id();
return id;
end */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaDatosLcajaEfectivoCturnos20Transferencia` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDatosLcajaEfectivoCturnos20Transferencia` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDatosLcajaEfectivoCturnos20Transferencia`(dfecha DATE,cndoc VARCHAR(12),
cdeta VARCHAR(100),idcta INTEGER,sdeudor DECIMAL(12,2),
sacreedor DECIMAL(12,2),cmone CHAR,ndolar DECIMAL(5,3),nidus INTEGER,nidcp INTEGER,nidauto INTEGER,
cform CHAR,cdcto VARCHAR(12),ctdoc VARCHAR(2),ncodt INTEGER,nturno INTEGER,ndscto DECIMAL(12,2),nidtran INTEGER) RETURNS int
BEGIN
DECLARE nid INTEGER DEFAULT 0;
INSERT INTO fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,
lcaj_idus,lcaj_clpr,lcaj_idau,lcaj_form,lcaj_dcto,lcaj_tdoc,lcaj_codt,lcaj_idtu,lcaj_dsct,lcaj_idtra,lcaj_fope)VALUES
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,nidauto,cform,cdcto,ctdoc,ncodt,nturno,ndscto,nidtran,localtime);
SELECT LAST_INSERT_ID() INTO nid FROM fe_lcaja GROUP BY LAST_INSERT_ID();
RETURN nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaDatosLibroDiario` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDatosLibroDiario` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDatosLibroDiario`(dfech datetime,ndebe decimal(12,2),nhaber decimal(12,2),cglosa varchar(120),ct char(1),cnume varchar(10),nidcta integer,ccond char,nit integer,ncomp varchar(15),nidcl integer,
nidpr integer,cmone char,ctran char,nimtd decimal (12,2),nimth decimal(12,2)) RETURNS int
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
nidcl integer,nidpr integer,cmone char,ctran char,nimtd decimal (12,2),nimth decimal(12,2),ctdoc varchar(2)) RETURNS int
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

/*!50003 CREATE FUNCTION `FuningresaDCotizacion`(ncoda integer,ncant float,nprec float,nidauto integer) RETURNS int
BEGIN
declare id integer default 0;
INSERT INTO fe_ped(idart,cant,prec,idautop)VALUES(ncoda,ncant,nprec,nidauto);
select last_insert_id() into id from fe_ped group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaDCreditos` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDCreditos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDCreditos`(dfecha datetime,dfevto datetime,nimpo float,cndoc varchar(12),
cest char,cmon char,crefe varchar(120),ctipo char,id1 integer,nidus integer) RETURNS int
BEGIN
declare id integer default 0;
INSERT INTO fe_cred(fech,fevto,impo,ndoc,estd,mone,banc,tipo,cred_idrc,cred_idus,cred_fope)
values(dfecha,dfevto,nimpo,cndoc,cest,cmon,crefe,ctipo,id1,nidus,localtime);
select last_insert_id() into id from fe_cred group by last_insert_id();
UPDATE fe_cred SET ncontrol=id WHERE idcred=id;
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

/* Function  structure for function  `FunIngresaDkardex` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDkardex` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDkardex`(nid integer,cc integer,ct char,npr float,
nct float,cincl char,ccodv integer,ct1 char,nidtda integer) RETURNS int
BEGIN
declare nidk integer default 0;
INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,incl,codv,ttip,alma)
VALUES (nid,cc,ct,npr,nct,cincl,ccodv,ct1,nidtda);
select last_insert_id() into nidk from fe_kar group by last_insert_id();
return nidk;
END */$$
DELIMITER ;

/* Function  structure for function  `FuningresaDocumentoElectronico` */

/*!50003 DROP FUNCTION IF EXISTS `FuningresaDocumentoElectronico` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FuningresaDocumentoElectronico`(
ctdoc VARCHAR(2),cform CHAR,cndoc VARCHAR(12),dfecha DATE,cdetalle VARCHAR(220),
nv DECIMAL(12,2),nigv DECIMAL(12,2),nt DECIMAL(12,2),cndo2 VARCHAR(10),cm CHAR,
ndolar DECIMAL(6,4),ni DECIMAL(6,4),ctg CHAR,ccodp INTEGER,nidturno INTEGER,nus INTEGER,nidcodt INTEGER,
n1 INTEGER,n2 INTEGER,n3 INTEGER,ngratuita DECIMAL(8,2),nidlectura INTEGER,nexon DECIMAL(12,2),ndscto DECIMAL(12,2)) RETURNS int
BEGIN
DECLARE nid INTEGER;
SET nid=0;
INSERT INTO fe_correvtas(auto_corr)VALUES(CONCAT(ctdoc,cndoc));      
INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,dolar,vigv,tcom,idcliente,
tipom,fusua,idusua,codt,rcom_exon,rcom_dsct,rcom_idtr,rcom_idis)
VALUES (ctdoc,cform,cndoc,dfecha,dfecha,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,ctg,ccodp,'V',LOCALTIME,nus,nidcodt,
nexon,ndscto,nidturno,nidlectura);
SELECT LAST_INSERT_ID() INTO nid FROM fe_rcom GROUP BY LAST_INSERT_ID();
IF n1>0 AND n2>0 AND n3>0 THEN
   CALL IngresaCuentasV(nv,nigv,nt,n1,n2,n3,"H","H","D",nid);
END IF;
RETURN nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FuningresaDocumentoElectronicoy` */

/*!50003 DROP FUNCTION IF EXISTS `FuningresaDocumentoElectronicoy` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FuningresaDocumentoElectronicoy`(
ctdoc VARCHAR(2),cform CHAR,cndoc VARCHAR(12),dfecha DATE,cdetalle VARCHAR(220),
nv DECIMAL(12,2),nigv DECIMAL(12,2),nt DECIMAL(12,2),cndo2 VARCHAR(10),cm CHAR,
ndolar DECIMAL(6,4),ni DECIMAL(6,4),ctg CHAR,ccodp INTEGER,nidturno INTEGER,nus INTEGER,nidcodt INTEGER,
n1 INTEGER,n2 INTEGER,n3 INTEGER,ngratuita DECIMAL(8,2),nidlectura INTEGER,nexon DECIMAL(12,2),ndscto DECIMAL(12,2),dfope datetime) RETURNS int
BEGIN
DECLARE nid INTEGER;
SET nid=0;
INSERT INTO fe_correvtas(auto_corr)VALUES(CONCAT(ctdoc,cndoc));      
INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,dolar,vigv,tcom,idcliente,
tipom,fusua,idusua,codt,rcom_exon,rcom_dsct,rcom_idtr,rcom_idis)
VALUES (ctdoc,cform,cndoc,dfecha,dfecha,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,ctg,ccodp,'V',dfope,nus,nidcodt,
nexon,ndscto,nidturno,nidlectura);
SELECT LAST_INSERT_ID() INTO nid FROM fe_rcom GROUP BY LAST_INSERT_ID();
IF n1>0 AND n2>0 AND n3>0 THEN
   CALL IngresaCuentasV(nv,nigv,nt,n1,n2,n3,"H","H","D",nid);
END IF;
RETURN nid;
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

/* Function  structure for function  `FunIngresaEntregaPedidos` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaEntregaPedidos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaEntregaPedidos`(nidin integer,ncant decimal(12,2),ncanr decimal(12,2),nidp integer) RETURNS int
begin
declare nid integer default 0;
insert into fe_pentregas(pent_idin,pent_cant,pent_canr,pent_idpr)values(nidin,ncant,ncanr,nidp);
select last_insert_id() into nid from fe_pentregas group by last_insert_id();
return nid;
end */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaGuias` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaGuias` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaGuias`(dfecha DATETIME,cptop VARCHAR(100),cptoll VARCHAR(150),nidauto INTEGER,
dfechat DATETIME,nidus INTEGER,cdeta VARCHAR(150),nidtr INTEGER,cndoc VARCHAR(12),nidtda INTEGER,cubigeo VARCHAR(8)) RETURNS int
BEGIN
DECLARE id INTEGER;
INSERT INTO fe_guias(guia_fech,guia_ptop,guia_ptoll,guia_idau,guia_fect,guia_idus,guia_fope,guia_deta,guia_idtr,guia_ndoc,guia_moti,guia_codt,guia_ubig)
VALUES(dfecha,cptop,cptoll,nidauto,dfechat,nidus,LOCALTIME,cdeta,nidtr,cndoc,'V',nidtda,cubigeo);
SELECT LAST_INSERT_ID() INTO id FROM  fe_guias GROUP BY LAST_INSERT_ID();
RETURN id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaGuiasCompras` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaGuiasCompras` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaGuiasCompras`(nidau integer,nidkar integer) RETURNS int
BEGIN
declare id integer default 0;
insert into fe_guiac(guic_idau,guic_idka)
values(nidau,nidkar);
select last_insert_id() into id from fe_guiac group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaGuiasCons` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaGuiasCons` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaGuiasCons`(dfecha date,cptop varchar(100),cptoll varchar(100),nidauto integer,
dfechat date,nidus integer,cdeta varchar(150),nidtr integer,cndoc varchar(10),cmoti char) RETURNS int
BEGIN
declare id integer;
insert into fe_guias(guia_fech,guia_ptop,guia_ptoll,guia_idau,guia_fect,guia_idus,guia_fope,guia_deta,guia_idtr,guia_ndoc,guia_moti)
values(dfecha,cptop,cptoll,nidauto,dfechat,nidus,localtime,cdeta,nidtr,cndoc,cmoti);
select last_insert_id() into id from  fe_guias group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaGuiasT` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaGuiasT` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaGuiasT`(`dfecha` DATETIME, `cptop` VARCHAR(100), `cptoll` VARCHAR(150), `nidauto` INTEGER, `dfechat` DATETIME, `nidus` INTEGER, `cdeta` VARCHAR(150), `nidtr` INTEGER, `cndoc` VARCHAR(12), `nidt` INTEGER,
cubiego VARCHAR(8)) RETURNS int
BEGIN
DECLARE id INTEGER;
INSERT INTO fe_guias(guia_fech,guia_ptop,guia_ptoll,guia_idau,guia_fect,guia_idus,guia_fope,guia_deta,
guia_idtr,guia_ndoc,guia_moti,guia_codt,guia_ubig)
VALUES(dfecha,cptop,cptoll,nidauto,dfechat,nidus,LOCALTIME,cdeta,nidtr,cndoc,'T',nidt,cubiego);
SELECT LAST_INSERT_ID() INTO id FROM  fe_guias GROUP BY LAST_INSERT_ID();
RETURN id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaGuiasxComprasRemitente` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaGuiasxComprasRemitente` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaGuiasxComprasRemitente`(dfecha DATETIME,cptop VARCHAR(100),cptoll VARCHAR(150),nidauto INTEGER,
dfechat DATETIME,nidus INTEGER,cdeta VARCHAR(150),nidtr INTEGER,cndoc VARCHAR(12),nidtda INTEGER,cdcto VARCHAR(12),df DATE,nidpr INTEGER,cubigeo VARCHAR(8)) RETURNS int
BEGIN
DECLARE id INTEGER;
INSERT INTO fe_guias(guia_fech,guia_ptop,guia_ptoll,guia_idau,guia_fect,guia_idus,guia_fope,guia_deta,guia_idtr,guia_ndoc,guia_moti,
guia_codt,guia_dcto,guia_fecd,guia_idpr,guia_ubig)
VALUES(dfecha,cptop,cptoll,nidauto,dfechat,nidus,LOCALTIME,cdeta,nidtr,cndoc,'C',nidtda,cdcto,df,nidpr,cubigeo);
SELECT LAST_INSERT_ID() INTO id FROM  fe_guias GROUP BY LAST_INSERT_ID();
RETURN id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaGuiasXdCompras` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaGuiasXdCompras` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaGuiasXdCompras`(dfecha DATE,cptop VARCHAR(100),cptoll VARCHAR(150),nidauto INTEGER,
dfechat DATE,nidus INTEGER,cdeta VARCHAR(150),nidtr INTEGER,cndoc VARCHAR(12),nidtda INTEGER,nidpr INTEGER,cubigeo VARCHAR(8)) RETURNS int
BEGIN
DECLARE id INTEGER;
INSERT INTO fe_guias(guia_fech,guia_ptop,guia_ptoll,guia_idau,guia_fect,guia_idus,guia_fope,guia_deta,guia_idtr,guia_ndoc,guia_moti,
guia_codt,guia_ubig,guia_idpr)
VALUES(dfecha,cptop,cptoll,nidauto,dfechat,nidus,LOCALTIME,cdeta,nidtr,cndoc,'D',nidtda,cubigeo,nidpr);
SELECT LAST_INSERT_ID() INTO id FROM  fe_guias GROUP BY LAST_INSERT_ID();
RETURN id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaGuiasxOtros` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaGuiasxOtros` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaGuiasxOtros`(dfecha DATETIME,cptop VARCHAR(100),cptoll VARCHAR(150),nidauto INTEGER,
dfechat DATETIME,nidus INTEGER,cdeta VARCHAR(150),nidtr INTEGER,cndoc VARCHAR(12),nidtda INTEGER,cubigeo VARCHAR(8),nidcl INTEGER) RETURNS int
BEGIN
DECLARE id INTEGER;
INSERT INTO fe_guias(guia_fech,guia_ptop,guia_ptoll,guia_idau,guia_fect,guia_idus,guia_fope,guia_deta,guia_idtr,guia_ndoc,guia_moti,guia_codt,guia_ubig,
guia_idcl)
VALUES(dfecha,cptop,cptoll,nidauto,dfechat,nidus,LOCALTIME,cdeta,nidtr,cndoc,'O',nidtda,cubigeo,nidcl);
SELECT LAST_INSERT_ID() INTO id FROM  fe_guias GROUP BY LAST_INSERT_ID();
RETURN id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaKardex` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaKardex` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaKardex`(nid integer,cc integer,ct char,npr float,
nct float,cincl char,ccodv integer,ct1 char,cdeta varchar(50),nidtda integer,nidtda1 integer,na1 integer) RETURNS int
BEGIN
declare nidk integer default 0;
INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,incl,codv,ttip,alma,kar_alma1)
VALUES (nid,cc,ct,npr,nct,cincl,ccodv,ct1,nidtda,nidtda);
select last_insert_id() into nidk from fe_kar group by last_insert_id();
insert into fe_traspaso(tras_idka,tras_idau,tras_refe,tras_codt,tras_codt1,tras_idau1)values(nidk,nid,cdeta,nidtda,nidtda1,na1);
return nidk;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaKardex1` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaKardex1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaKardex1`(nid integer,cc integer,ct char,npr decimal(12,5),
nct decimal(12,4),cincl char,tmvto char,ccodv integer,calma integer,nidcont integer,nalma1 integer,
npreciol decimal(12,5)) RETURNS int
BEGIN
declare nidk integer default 0;
if ct='C' then
  INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,ttip,incl,alma,kar_idco,kar_alm1,kar_prel)
  VALUES (nid,cc,ct,npr,nct,tmvto,cincl,calma,0,calma,npreciol);
 else
  INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,ttip,incl,alma,kar_idco,codv,kar_alm1,kar_prel)
  VALUES (nid,cc,ct,npr,nct,tmvto,cincl,calma,nidcont,ccodv,nalma1,npreciol);
end if;
select last_insert_id() into nidk from fe_kar group by last_insert_id();
return nidk;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaKardexCambios` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaKardexCambios` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaKardexCambios`(nid integer,cc integer,ct char,npr float,nct float,cin char,
ccodv integer,ctt char,nidtda integer,nidcosto integer) RETURNS int
BEGIN
declare nidk integer default 0;
INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,incl,codv,ttip,alma,kar_idco)
 VALUES (nid,cc,ct,npr,nct,cin,ccodv,ctt,nidtda,nidcosto);
select last_insert_id() into nidk from fe_kar group by last_insert_id();
return nidk;
END */$$
DELIMITER ;

/* Function  structure for function  `FUNINGRESANOTASCREDITOCOMPRAS` */

/*!50003 DROP FUNCTION IF EXISTS `FUNINGRESANOTASCREDITOCOMPRAS` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FUNINGRESANOTASCREDITOCOMPRAS`(nid0 integer,nid1 integer,ideudas integer) RETURNS int
BEGIN
declare id integer default 0;
insert into fe_nccom(ncre_idan,ncre_idau,ncre_ideu)values(nid0,nid1,ideudas);
select last_insert_id() into id from fe_nccom group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FUNINGRESANOTASCREDITOventas` */

/*!50003 DROP FUNCTION IF EXISTS `FUNINGRESANOTASCREDITOventas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FUNINGRESANOTASCREDITOventas`(nid0 integer,nid1 integer) RETURNS int
BEGIN
declare id integer default 0;
insert into fe_ncven(ncre_idan,ncre_idau)values(nid0,nid1);
select last_insert_id() into id from fe_ncven group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FUNINGRESANOTASCREDITOventas1` */

/*!50003 DROP FUNCTION IF EXISTS `FUNINGRESANOTASCREDITOventas1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FUNINGRESANOTASCREDITOventas1`(nid0 integer,nid1 integer,nidpagos integer) RETURNS int
BEGIN
declare id integer default 0;
insert into fe_ncven(ncre_idan,ncre_idau,ncre_idpa)values(nid0,nid1,nidpagos);
select last_insert_id() into id from fe_ncven group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaOrdenCompra` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaOrdenCompra` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaOrdenCompra`(dfecha date,nidpr integer,cmone char,
cndoc varchar(10),ctigv char,cobse varchar(200),caten varchar(80),cdeta varchar(200),
cidpc varchar(45),nidus integer,cdespacho varchar(60),cforma varchar(60),nv float,nigv float,nimpo float) RETURNS int
BEGIN
declare nid integer;
insert into fe_rocom(ocom_fech,ocom_idpr,ocom_mone,ocom_ndoc,ocom_tigv,ocom_obse,ocom_aten,
ocom_deta,ocom_idpc,ocom_idus,ocom_fope,ocom_desp,ocom_form,ocom_valor,ocom_igv,ocom_impo)values(dfecha,nidpr,cmone,cndoc,ctigv,cobse,
caten,cdeta,cidpc,nidus,current_date(),cdespacho,cforma,nv,nigv,nimpo);
select last_insert_id() into nid from fe_rocom group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaPagosCreditos` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosCreditos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosCreditos`(
cndoc varchar(10),nacta float,cesta char,cmone char,cb1 varchar(100),dfech date,
dfevto date,ctipo char,nctrl integer,cnrou varchar(40),nidrc float,cpc varchar(45),
idusua integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_cred(fech,fevto,acta,ndoc,estd,mone,banc,tipo,cred_idrc,cred_idus,cred_fope,ncontrol,nrou,cred_idpc)
values(dfech,dfevto,nacta,cndoc,cesta,cmone,cb1,ctipo,nidrc,idusua,current_date(),nctrl,cnrou,cpc);
select last_insert_id() into nid from fe_cred group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaPagosCreditosCb` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosCreditosCb` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosCreditosCb`(
cndoc varchar(10),nacta float,cesta char,cmone char,cb1 varchar(100),dfech date,
dfevto date,ctipo char,nctrl integer,cnrou varchar(40),nidrc float,cpc varchar(45),
idusua integer,idcb integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_cred(fech,fevto,acta,ndoc,estd,mone,banc,tipo,cred_idrc,cred_idus,cred_fope,ncontrol,nrou,cred_idpc,cred_idcb)
values(dfech,dfevto,nacta,cndoc,cesta,cmone,cb1,ctipo,nidrc,idusua,current_date(),nctrl,cnrou,cpc,idcb);
select last_insert_id() into nid from fe_cred group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaPagosCreditosCe` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosCreditosCe` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosCreditosCe`(
cndoc varchar(10),nacta float,cesta char,cmone char,cb1 varchar(100),dfech date,
dfevto date,ctipo char,nctrl integer,cnrou varchar(40),nidrc float,cpc varchar(45),
idusua integer,idce integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_cred(fech,fevto,acta,ndoc,estd,mone,banc,tipo,cred_idrc,cred_idus,cred_fope,ncontrol,nrou,cred_idpc,cred_idce)
values(dfech,dfevto,nacta,cndoc,cesta,cmone,cb1,ctipo,nidrc,idusua,current_date(),nctrl,cnrou,cpc,idce);
select last_insert_id() into nid from fe_cred group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaPagosCreditosDiario` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosCreditosDiario` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosCreditosDiario`(
cndoc varchar(10),nacta float,cesta char,cmone char,cb1 varchar(100),dfech date,
dfevto date,ctipo char,nctrl integer,cnrou varchar(40),nidrc float,cpc varchar(45),
idusua integer,idiario integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_cred(fech,fevto,acta,ndoc,estd,mone,banc,tipo,cred_idrc,cred_idus,cred_fope,ncontrol,nrou,cred_idpc,cred_iddi)
values(dfech,dfevto,nacta,cndoc,cesta,cmone,cb1,ctipo,nidrc,idusua,current_date(),nctrl,cnrou,cpc,idiario);
select last_insert_id() into nid from fe_cred group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaPagosCreditostmp` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosCreditostmp` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosCreditostmp`(
cndoc varchar(10),nacta float,cesta char,cmone char,cb1 varchar(100),dfech date,
dfevto date,ctipo char,nctrl integer,cnrou varchar(40),nidrc float,cpc varchar(45),
idusua integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_cred(fech,fevto,cred_acta,ndoc,estd,mone,banc,tipo,cred_idrc,cred_idus,cred_fope,ncontrol,nrou,cred_idpc)
values(dfech,dfevto,nacta,cndoc,cesta,cmone,cb1,ctipo,nidrc,idusua,current_date(),nctrl,cnrou,cpc);
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
dfevto datetime,nacta float,cndoc varchar(12),cesta char,cmone char,cb1 varchar(100),ctipo char,
nidrc integer,idusua integer,nctrl integer,cnrou varchar(25),cpc varchar(45),ndolar float,ninteres decimal(10,2)) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_deu(fech,fevto,acta,ndoc,estd,banc,tipo,deud_idrd,deud_idus,deud_fope,ncontrol,nrou,deud_idpc,dola,deud_inte)
values(dfech,dfevto,nacta,cndoc,cesta,cb1,ctipo,nidrc,idusua,localtime,nctrl,cnrou,cpc,ndolar,ninteres);
select last_insert_id() into nid from fe_deu group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaPagosDeudasCb` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosDeudasCb` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosDeudasCb`(dfech datetime,
dfevto datetime,nacta float,cndoc varchar(12),cesta char,cmone char,cb1 varchar(100),ctipo char,
nidrc integer,idusua integer,nctrl integer,cnrou varchar(25),cpc varchar(45),ndolar float,idcb integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_deu(fech,fevto,acta,ndoc,estd,banc,tipo,deud_idrd,deud_idus,deud_fope,ncontrol,nrou,deud_idpc,dola,deud_idcb)
values(dfech,dfevto,nacta,cndoc,cesta,cb1,ctipo,nidrc,idusua,localtime,nctrl,cnrou,cpc,ndolar,idcb);
select last_insert_id() into nid from fe_deu group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaPagosDeudasCE` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosDeudasCE` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosDeudasCE`(dfech datetime,
dfevto datetime,nacta float,cndoc varchar(10),cesta char,cmone char,cb1 varchar(100),ctipo char,
nidrc integer,idusua integer,nctrl integer,cnrou varchar(25),cpc varchar(45),ndolar float,idce integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_deu(fech,fevto,acta,ndoc,estd,banc,tipo,deud_idrd,deud_idus,deud_fope,ncontrol,nrou,deud_idpc,dola,deud_idce)
values(dfech,dfevto,nacta,cndoc,cesta,cb1,ctipo,nidrc,idusua,localtime,nctrl,cnrou,cpc,ndolar,idce);
select last_insert_id() into nid from fe_deu group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaPagosDeudasConNotasCredito` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosDeudasConNotasCredito` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosDeudasConNotasCredito`(dfech datetime,
dfevto datetime,nacta float,cndoc varchar(12),cesta char,cmone char,cb1 varchar(100),ctipo char,
nidrc integer,idusua integer,nctrl integer,cnrou varchar(25),cpc varchar(45),ndolar float,nidn integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_deu(fech,fevto,acta,ndoc,estd,banc,tipo,deud_idrd,deud_idus,
deud_fope,ncontrol,nrou,deud_idpc,dola,deud_idno)
values(dfech,dfevto,nacta,cndoc,cesta,cb1,ctipo,nidrc,idusua,localtime,nctrl,cnrou,cpc,ndolar,nidn);
select last_insert_id() into nid from fe_deu group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaPagosDeudasDiario` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosDeudasDiario` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosDeudasDiario`(dfech datetime,
dfevto datetime,nacta float,cndoc varchar(10),cesta char,cmone char,cb1 varchar(100),ctipo char,
nidrc integer,idusua integer,nctrl integer,cnrou varchar(25),cpc varchar(45),ndolar decimal(6,4),idiario integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_deu(fech,fevto,acta,ndoc,estd,banc,tipo,deud_idrd,deud_idus,deud_fope,ncontrol,nrou,deud_idpc,dola,deud_iddi)
values(dfech,dfevto,nacta,cndoc,cesta,cb1,ctipo,nidrc,idusua,localtime,nctrl,cnrou,cpc,ndolar,idiario);
select last_insert_id() into nid from fe_deu group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaPagosEmpleados` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosEmpleados` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosEmpleados`(nimpo float,nacta float,dfech date,ct char,nidus integer,
nidcaja integer,nidem integer,cdeta varchar(100)) RETURNS int
BEGIN
declare x integer default 0;
if ct='A' then
   insert into fe_pagos(pago_impo,pago_fech,pago_tipo,pago_idus,pago_fope,pago_idem,pago_deta)
   values(nimpo,dfech,'A',nidus,localtime,nidem,cdeta);
  else
    insert into fe_pagos(pago_acta,pago_fech,pago_tipo,pago_idus,pago_fope,pago_idem,pago_idca,pago_deta)
    values(nacta,dfech,'P',nidus,localtime,nidem,nidcaja,cdeta);
end if;
select last_insert_id() into x from fe_pagos group by last_insert_id();
return x;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaPagosvendedores1` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosvendedores1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosvendedores1`(df date,nidus integer,nidv integer,nimpo decimal(12,2),npago decimal(12,2)) RETURNS int
begin
declare id integer default 0;
Insert into fe_rpvendedor(rpve_fech,rpve_idus,rpve_fope,rpve_impo,rpve_pago,rpve_idve)values(df,nidus,localtime,nimpo,npago,nidv);
select last_insert_id() into id from fe_rpvendedor group by last_insert_id();
return id;
end */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaRCompras` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaRCompras` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaRCompras`(
ctdoc varchar(2),cform char,cndoc varchar(12),dfecha date,dfechar date,cdetalle varchar(120),
nv decimal(12,2),nigv decimal(12,2),nt decimal(12,2),cndo2 varchar(10),cm char,
ndolar float,ni float,ctg char,ccodp integer,cmvto char,nus integer,opt integer,nidcodt integer,
n1 integer,n2 integer,n3 integer,nitem integer,npvta float,nexon decimal(12,2),notros decimal(12,2)) RETURNS int
BEGIN
declare nid,idce integer;
set nid=0;
select gene_idce into idce from fe_gene where idgene=1;
   INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,dolar,vigv,tcom,
   idprov,tipom,fusua,idusua,codt,rcom_nitem,rcom_exon,rcom_otro)
   VALUES (ctdoc,cform,cndoc,dfecha,dfechar,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,ctg,ccodp,cmvto,localtime,nus,nidcodt,nitem,nexon,notros);
   select last_insert_id() into nid from fe_rcom group by last_insert_id();
   if n1>0 and n2>0 and n3>0 then
      call IngresaCuentas(nv,0,0,0,nigv,0,0,nt,n1,0,0,0,n2,0,0,n3,"D","","","","D","","","H",nid);
   end if;
 return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaRcreditos` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaRcreditos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaRcreditos`(nauto integer,nid integer,dfecha datetime,nidven integer,nimpoo float,
nidus integer,nidtda integer,ninic float,cpc varchar(45)) RETURNS int
BEGIN
declare id1 integer default 0;
insert into fe_rcred(rcre_idcl,rcre_fech,rcre_idau,rcre_impc,rcre_idus,rcre_codt,rcre_idpc,rcre_inic,rcre_codv)
values(nid,dfecha,nauto,nimpoo,nidus,nidtda,cpc,ninic,nidven);
select last_insert_id() into id1 from fe_rcred group by last_insert_id();
CALL PROingresarvendedores(nauto,id1,nid,'C',nidven);
return id1;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaRPUsados` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaRPUsados` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaRPUsados`(dfecha date,cndoc varchar(10),
ctipo char,nimpo decimal(12,2),nidalma integer) RETURNS int
begin
declare nid integer default 0;
insert into fe_rcomu(rcom_fech,rcom_ndoc,rcom_fope,rcom_tipo,rcom_impo,rcom_codt)
values(dfecha,cndoc,localtime,ctipo,nimpo,nidalma);
select last_insert_id() into nid from fe_rcomu group by last_insert_id();
return nid;
end */$$
DELIMITER ;

/* Function  structure for function  `FunIngresatregaPedidos` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresatregaPedidos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresatregaPedidos`(nidin integer,ncant decimal(12,2),ncanr decimal(12,2),nidp integer) RETURNS int
begin
declare nid integer default 0;
insert into fe_pentregas(pent_idin,pent_cant,pent_canr,pent_idpr)values(nidin,ncant,ncanr,nidp);
select last_insert_id() into nid from fe_pentregas group by last_insert_id();
return nid;
end */$$
DELIMITER ;

/* Function  structure for function  `FunObtieneValoresContometro` */

/*!50003 DROP FUNCTION IF EXISTS `FunObtieneValoresContometro` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunObtieneValoresContometro`(nidart integer) RETURNS int
BEGIN
declare nid integer default 0;
set nid=1;
select cont_idcon into nid from fe_contometro as c where  cont_esta='A' and cont_acti='A' and cont_idar=nidart group by cont_idcon;
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FUNPERMITEANULARGUIASCOMPRAS` */

/*!50003 DROP FUNCTION IF EXISTS `FUNPERMITEANULARGUIASCOMPRAS` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FUNPERMITEANULARGUIASCOMPRAS`(idg integer) RETURNS int
BEGIN
declare nidg integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET nidg=0;
SELECT guic_idau into nidg  from fe_guiac where guic_idau=idg and guic_acti<>'I' and guic_tipo='E' group by guic_idau;
return nidg;
END */$$
DELIMITER ;

/* Function  structure for function  `FUNPERMITEANULARTRASPASO` */

/*!50003 DROP FUNCTION IF EXISTS `FUNPERMITEANULARTRASPASO` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FUNPERMITEANULARTRASPASO`(nato integer) RETURNS int
BEGIN
declare nidt integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET nidt=0;
SELECT tras_idau1 into nidt  from fe_traspaso where tras_idau=nato and tras_acti<>'I' group by tras_idau;
return nidt;
END */$$
DELIMITER ;

/* Function  structure for function  `FunRegistraCreditos` */

/*!50003 DROP FUNCTION IF EXISTS `FunRegistraCreditos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunRegistraCreditos`(nauto integer,nid integer,cndoc varchar(12),
cest char,cmon char,crefe varchar(60),dfecha date,dfevto date,
ctipo char,cdocp varchar(12),nimpo float,ninic float,
idven integer,nimpoo float,nidus integer,nidtda integer,cpc varchar(45)) RETURNS int
BEGIN
declare id integer default 0;
declare id1 integer default 0;
insert into fe_rcred(rcre_idcl,rcre_fech,rcre_idau,rcre_impc,rcre_idus,rcre_codt,rcre_idpc,rcre_inic,rcre_codv)
values(nid,dfecha,nauto,nimpoo,nidus,nidtda,cpc,ninic,idven);
select last_insert_id() into id1 from fe_rcred group by last_insert_id();
INSERT INTO fe_cred(fech,fevto,impo,ndoc,estd,mone,banc,tipo,cred_idrc,cred_idus,cred_fope)
values(dfecha,dfevto,nimpo,cndoc,cest,cmon,crefe,ctipo,id1,nidus,current_date());
select last_insert_id() into id from fe_cred group by last_insert_id();
UPDATE fe_cred SET ncontrol=id WHERE idcred=id;
CALL PROingresarvendedores(nauto,id1,nid,'C',idven);
return id;
END */$$
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

/* Function  structure for function  `FunResumenEntregaPedidos` */

/*!50003 DROP FUNCTION IF EXISTS `FunResumenEntregaPedidos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunResumenEntregaPedidos`(dfecha date) RETURNS int
begin
declare nid integer default 0;
insert into fe_rpentregas(rpen_fech)values(dfecha);
select last_insert_id() into nid from fe_rpentregas group by last_insert_id();
return nid;
end */$$
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

/* Function  structure for function  `FunSiestaRegistradoDctoPago` */

/*!50003 DROP FUNCTION IF EXISTS `FunSiestaRegistradoDctoPago` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunSiestaRegistradoDctoPago`(cdcto varchar(10)) RETURNS int
begin
declare vdvto integer default 0;
select idcred into vdvto from fe_cred where trim(ndoc)=trim(cdcto) and estd='P' and acti='A' group by idcred;
if vdvto>0 then
   return 0;
 else
   return 1;
end if;
end */$$
DELIMITER ;

/* Function  structure for function  `FunTraspasoDatosLcajaE` */

/*!50003 DROP FUNCTION IF EXISTS `FunTraspasoDatosLcajaE` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunTraspasoDatosLcajaE`(dfecha datetime,cndoc varchar(10),cdeta varchar(100),idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),cmone char,ndolar decimal(5,3),nidus integer,nidcp integer) RETURNS int
begin
declare id integer;
insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,lcaj_idus,lcaj_clpr,lcaj_tran)values
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,'T');
select last_insert_id() into id from fe_lcaja group by last_insert_id();
return id;
end */$$
DELIMITER ;

/* Function  structure for function  `FunUltimoPrecio` */

/*!50003 DROP FUNCTION IF EXISTS `FunUltimoPrecio` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunUltimoPrecio`(nidart integer) RETURNS decimal(10,2)
begin
declare nid decimal(12,2) default 0;
select karu_prec into nid from fe_karu as a inner join fe_rcomu as b
on b.rcom_idau=a.karu_idau where karu_idar=nidart  and a.karu_Acti='A' and b.rcom_acti='A'
group by karu_idar order by rcom_fech desc;
return nid;
end */$$
DELIMITER ;

/* Function  structure for function  `FunValidaClientes` */

/*!50003 DROP FUNCTION IF EXISTS `FunValidaClientes` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunValidaClientes`(nid integer) RETURNS int
BEGIN
declare sw1,sw2,sw3 integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET sw1=0,sw2=0,sw3=0;
select rcre_idcl into sw1 from fe_rcred where rcre_idcl=nid group by rcre_idcl;
select idcliente into sw2 from fe_rcom where idclieNTE=nid group by idcliente;
select idclie into sw3 from fe_rped where idclie=nid group by idclie;
if sw1>0 and sw2>0 and sw3>0 then
   return 0;
 else
    return 1;
end if;
END */$$
DELIMITER ;

/* Function  structure for function  `FunValidaDctos` */

/*!50003 DROP FUNCTION IF EXISTS `FunValidaDctos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunValidaDctos`(cmvto char,cdcto varchar(12),ctdoc varchar(2),id1 integer) RETURNS int
BEGIN
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
if id1=0 then
  if ctdoc<>'TT' then
     SELECT idauto into vdvto FROM fe_rcom WHERE ndoc=cdcto and tdoc=ctdoc and tipom=cmvto AND acti<>'I' group by idauto;
   else
     SELECT idauto into vdvto FROM fe_rcom WHERE ndoc=cdcto and tdoc=ctdoc AND acti<>'I' group by idauto;
   end if;
end if;
return vdvto;
END */$$
DELIMITER ;

/* Function  structure for function  `FUNVALIDADCTOS1` */

/*!50003 DROP FUNCTION IF EXISTS `FUNVALIDADCTOS1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FUNVALIDADCTOS1`(cdcto varchar(12),ctdoc varchar(2),id1 integer) RETURNS int
BEGIN
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
SELECT idauto into vdvto FROM fe_rcom WHERE ndoc=cdcto and tdoc=ctdoc AND acti<>'I' and idauto<>id1 and idcliente>0 group by idauto;
return vdvto;
END */$$
DELIMITER ;

/* Function  structure for function  `FunValidaDctosCompras` */

/*!50003 DROP FUNCTION IF EXISTS `FunValidaDctosCompras` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunValidaDctosCompras`(nid integer) RETURNS int
BEGIN
declare vdvto,vdvto1,nid1,xi integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0,vdvto1=0,nid1=0,xi=0;
select rdeu_idau into xi from fe_rdeu  where rdeu_acti<>'I' and rdeu_idau=nid group by rdeu_idau;
SELECT sum(acta) into vdvto from fe_deu where deud_idrd=xi AND acti<>'I';
SELECT cost_idco into nid1 from fe_costos where cost_idau=nid AND cost_acti<>'I' group by cost_idau;
if nid1> 0 then
   SELECT kar_idco into vdvto1 FROM fe_kar WHERE kar_idco=nid1 and tipo='V' and acti<>'I' group by kar_idco;
end if;
if vdvto=0 then
   return 0;
 else
   return 1;
end if;
END */$$
DELIMITER ;

/* Function  structure for function  `FunValidaDesactivaConceptos` */

/*!50003 DROP FUNCTION IF EXISTS `FunValidaDesactivaConceptos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunValidaDesactivaConceptos`(nid integer) RETURNS int
BEGIN
declare sw integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET sw=0;
select idcon into sw from fe_con where idcon=nid;
if nid=0 then
   update fe_con set conc_acti='I' where idcon=nid;
   return 0;
 else
   return 1;
end if;
END */$$
DELIMITER ;

/* Function  structure for function  `FunValidaDesactivaDctos` */

/*!50003 DROP FUNCTION IF EXISTS `FunValidaDesactivaDctos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunValidaDesactivaDctos`(nid integer) RETURNS int
BEGIN
declare sw varchar(2) default '';
declare nidtdoc integer;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET sw='';
select idtdoc  into nidtdoc from fe_tdoc where idtdoc=nid;
select tdoc into sw from fe_rcom where nid=nidtdoc;
if sw='' then
   update fe_tdoc set dcto_acti='I' where idtdoc=nidtdoc;
   return 0;
 else
   return 1;
end if;
END */$$
DELIMITER ;

/* Function  structure for function  `FunValidaFletes` */

/*!50003 DROP FUNCTION IF EXISTS `FunValidaFletes` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunValidaFletes`(nid integer) RETURNS int
BEGIN
declare sw integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET sw=0;
select idflete into sw from fe_art where idflete=nid;
return sw;
END */$$
DELIMITER ;

/* Function  structure for function  `FunValidaGrupos` */

/*!50003 DROP FUNCTION IF EXISTS `FunValidaGrupos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunValidaGrupos`(nid integer) RETURNS int
BEGIN
declare sw1 integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET sw1=0;
select count(*) into sw1 from fe_cat where idgrupo=nid group by idgrupo;
if sw1=0 then
   return 0;
  else
   return 1;
end if;
END */$$
DELIMITER ;

/* Function  structure for function  `FunValidaLineas` */

/*!50003 DROP FUNCTION IF EXISTS `FunValidaLineas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunValidaLineas`(nid integer) RETURNS int
BEGIN
declare sw1 integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET sw1=0;
select count(*)  into sw1 from fe_art where idcat=nid and prod_acti='A' group by idcat;
return sw1;
END */$$
DELIMITER ;

/* Function  structure for function  `FunValidaMarcas` */

/*!50003 DROP FUNCTION IF EXISTS `FunValidaMarcas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunValidaMarcas`(nid integer) RETURNS int
BEGIN
declare sw integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET sw=0;
select count(*) into sw from fe_art where idmar=nid and prod_Acti='A'  group by idmar;
return sw;
END */$$
DELIMITER ;

/* Function  structure for function  `FunValidaProductos` */

/*!50003 DROP FUNCTION IF EXISTS `FunValidaProductos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunValidaProductos`(nid integer) RETURNS int
BEGIN
declare sw integer;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET sw=0;
select idart into sw from fe_kar where idart=nid and acti='A' group by idart;
return sw;
END */$$
DELIMITER ;

/* Function  structure for function  `FunValidaProveedores` */

/*!50003 DROP FUNCTION IF EXISTS `FunValidaProveedores` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunValidaProveedores`(nid integer) RETURNS int
BEGIN
declare sw1,sw2 integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET sw1=0,sw2=0;
select rdeu_idpr into sw1 from fe_rdeu where rdeu_idpr=nid group by rdeu_idpr;
select idprov into sw2 from fe_rcom where idprov=nid group by idprov;
if sw1=0 and sw2=0 then
   return 0;
 else
    return 1;
end if;
END */$$
DELIMITER ;

/* Function  structure for function  `FunValidaVendedores` */

/*!50003 DROP FUNCTION IF EXISTS `FunValidaVendedores` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunValidaVendedores`(nid integer) RETURNS int
BEGIN
declare sw1,sw2 integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET sw1=0,sw2=0;
select idven into sw1 from fe_kar where codv=nid group by idven;
select idven into sw2 from fe_cred where codv=nid group by idven;
if sw1=0 and sw2=0 then
   return 0;
 else
   return 1;
end if;
END */$$
DELIMITER ;

/* Function  structure for function  `FunValidaZonas` */

/*!50003 DROP FUNCTION IF EXISTS `FunValidaZonas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunValidaZonas`(id integer) RETURNS int
BEGIN
declare nid integer default 0;
set nid=(select ifnull(count(idclie),0) as total from fe_clie where clie_idzo=id and clie_acti<>'I' group by idclie);
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunValidaZonasp` */

/*!50003 DROP FUNCTION IF EXISTS `FunValidaZonasp` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunValidaZonasp`(id integer) RETURNS int
BEGIN
declare nid integer default 0;
set nid=(select ifnull(count(*),0) as total from fe_zona where zona_idzz=id and zona_acti<>'I' group by zona_idzz);
return nid;
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
   year(fecr)=year(dfecha) and acti='A' and rcom_bloq='C' group by rcom_bloq;
   if vdvto>0 then
      return 0;
     else
      return 1;
    end if;
end if;
end */$$
DELIMITER ;

/* Function  structure for function  `FunVerificaCaja` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaCaja` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaCaja`(df date) RETURNS int
BEGIN
declare sw integer;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET sw=0;
SELECT COUNT(*) into sw FROM fe_caja WHERE fech=df AND estado="C" AND acti<>'I' group by fech;
return sw;
END */$$
DELIMITER ;

/* Function  structure for function  `FunVerificaCaja1` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaCaja1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaCaja1`(df date,nidus integer) RETURNS int
BEGIN
declare sw integer;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET sw=0;
SELECT COUNT(*) into sw FROM fe_caja WHERE fech=df AND estado="C" AND acti<>'I'  and idusua=nidus group by fech;
return sw;
END */$$
DELIMITER ;

/* Function  structure for function  `FUNVERIFICADPTESENTREGA` */

/*!50003 DROP FUNCTION IF EXISTS `FUNVERIFICADPTESENTREGA` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FUNVERIFICADPTESENTREGA`(nid integer) RETURNS int
BEGIN
declare nid1 integer default 0;
declare nid2 integer default 0;
declare sw integer default 0;
set nid1=(select pdte_idin from fe_ipdtes where pdte_idau=nid and pdte_Acti='A' group by pdte_idau);
if nid1>0 then
   set nid2=(select count(*) from fe_entregas where entr_idin=nid1 and entr_Acti='A');
   if nid2>0 then
       set sw=1;
      else
       set sw=0;
   end if;
 else
   set sw=0;
end if;
return sw;
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

/* Function  structure for function  `FunVerificaIngresoGuiaCompra` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaIngresoGuiaCompra` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaIngresoGuiaCompra`(nid integer) RETURNS int
begin
declare x integer default 0;
set x=(select ifnull(rgco_idau,0) from fe_rgcompra where rgco_idau=nid and rgco_acti='A');
if x>0 then
   return 0;
  else
  return 1;
end if;
end */$$
DELIMITER ;

/* Function  structure for function  `FunVerificaLineaCredito` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaLineaCredito` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaLineaCredito`(nidcliente integer,nmonto float,nlineac float) RETURNS int
BEGIN
declare ndias integer;
declare vdvto integer;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET ndias=0;
set vdvto=0;
SELECT datediff(curdate(),max(a.fevto)) into ndias FROM
fe_cred as a inner join fe_rcred as b ON(b.rcre_idrc=a.cred_idrc) left join fe_rcom as c ON(c.idauto=b.rcre_idau)
WHERE a.acti<>'I' and b.rcre_idcl=nidcliente group by ncontrol having ROUND(SUM(a.impo-a.acta),2)>0 ORDER BY datediff(curdate(),max(a.fevto)) limit 0,1;
if nmonto>nlineac then
   set vdvto=0;
 else
   if ndias>30 then
      set vdvto=0;
    else
      set vdvto=1;
  end if;
end if;
return vdvto;
END */$$
DELIMITER ;

/* Function  structure for function  `FunVerificaNoPedido` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaNoPedido` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaNoPedido`(cd varchar(10)) RETURNS int
BEGIN
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
select a.idautop into vdvto from fe_rped as a inner join fe_ped as b on b.idautop=a.idautop
where trim(a.ndoc)=trim(cd) and a.acti='A' and b.acti='A' group by a.idautop;
if vdvto>0 then
  return 0;
 else
   return 1;
end if;
END */$$
DELIMITER ;

/* Function  structure for function  `FunVerificaPagos` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaPagos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaPagos`(nid integer) RETURNS int
BEGIN
declare sw,sw1 integer;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET sw=0,sw1=0;
set sw:=(SELECT count(rcre_idau) FROM fe_cred as b inner join fe_rcred as a
on(a.rcre_idrc=b.cred_idrc) WHERE b.acta>0 AND a.rcre_idau=nid AND acti<>'I'group by a.rcre_idau);
set sw1:=(SELECT count(rcre_idau)  FROM fe_rcred as b WHERE b.rcre_inic>0 AND b.rcre_idau=nid AND b.rcre_acti<>'I'group by b.rcre_idau);
if sw>0 or sw1>0 then
   return 1;
  else
   return 0;
end if;
END */$$
DELIMITER ;

/* Function  structure for function  `FunVerificaSiEstaAnuladaDespachos` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaSiEstaAnuladaDespachos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaSiEstaAnuladaDespachos`(nidauto integer) RETURNS int
begin
declare id integer default 0;
  select idauto into id from vrdespachos where idauto=nidauto and  not isnull(entr_acti) group by idauto;
  if id>0 then
     return 0;
    else
     return 1;
  end if;
end */$$
DELIMITER ;

/* Function  structure for function  `FunVerificaSiestaCanjeado` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaSiestaCanjeado` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaSiestaCanjeado`(nidc integer) RETURNS int
begin
declare vdvto integer default 0;
select canj_idrc into vdvto from fe_ccanjes where canj_idrc=nidc and canj_acti='A'  group by canj_idrc;
if vdvto>0 then
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

/* Function  structure for function  `FunVerificaSiEstaGC` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaSiEstaGC` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaSiEstaGC`(nid integer) RETURNS int
begin
declare x integer default 0;
set x=(select ifnull(guic_idka,0) from fe_guiac where guic_idka=nid and guic_acti='A');
if x>0 then
   return 0;
  else
  return 1;
end if;
end */$$
DELIMITER ;

/* Function  structure for function  `FunVerificaSiestaPagadoC` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaSiestaPagadoC` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaSiestaPagadoC`(nidc integer) RETURNS int
begin
declare vdvto integer default 0;
select ncontrol into vdvto from fe_cred where ncontrol=nidc and acta>0 and acti='A' group by ncontrol;
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

/* Function  structure for function  `FunVerificaSiGuiaEstaIngresada` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaSiGuiaEstaIngresada` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaSiGuiaEstaIngresada`(nd varchar(10)) RETURNS int
begin
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
SELECT guia_idau into vdvto FROM fe_guias as a WHERE a.guia_ndoc=nd AND a.guia_acti='A' group by guia_idau;
return vdvto;
end */$$
DELIMITER ;

/* Function  structure for function  `FunVerificaTraspasoAutomatico` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaTraspasoAutomatico` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaTraspasoAutomatico`(nid integer) RETURNS int
BEGIN
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
select count(*)  into vdvto from fe_traspaso where tras_idau1=nid and tras_acti<>'I' group by tras_idau;
return vdvto;
END */$$
DELIMITER ;

/* Procedure structure for procedure `astock` */

/*!50003 DROP PROCEDURE IF EXISTS  `astock` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `astock`(in coda integer,in nalma integer,in ccant float,in ctipo char(1))
BEGIN
   if ctipo="C" then
      if nalma=0 then
          UPDATE fe_art SET cero=cero+ccant WHERE idart=coda;
      end if;
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
   end if;
   if ctipo="V" then
      if nalma=0 then
          UPDATE fe_art SET cero=cero-ccant WHERE idart=coda;
      end if;
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
  end if;
   if ctipo="I" then
      if nalma=0 then
          UPDATE fe_art SET cero=ccant WHERE idart=coda;
      end if;
      if nalma=1 then
          UPDATE fe_art SET uno=ccant WHERE idart=coda;
      end if;
      if nalma=2 then
          UPDATE fe_art SET dos=ccant WHERE idart=coda;
      end if;
      if nalma=3 then
          UPDATE fe_art SET tre=ccant WHERE idart=coda;
      end if;
      if nalma=4 then
          UPDATE fe_art SET cua=ccant WHERE idart=coda;
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
sum(if(b.tipo='V',b.cant,0)) as tventas,b.alma from fe_kar as b inner join fe_rcom as a
on a.idauto=b.idauto
where b.acti='A' and a.acti='A' group by  idart,alma) as a;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
open cursor1;
start transaction;
UPDATE fe_art SET uno=0,dos=0,tre=0,cua=0,cero=0;
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

/* Procedure structure for procedure `ingresacaja` */

/*!50003 DROP PROCEDURE IF EXISTS  `ingresacaja` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ingresacaja`(in nauto integer,in cdcto varchar(12),in dfecha date,
in nimpo float,in nimpo1 float,in cdeta varchar(120),in nidus integer,in cmon char,
in idcreditos integer,in cf char,in nimporte1 float,in cmon1 char,in ndola1 float,
in cidpc varchar(50),in nidtda integer)
BEGIN
declare nidcon integer;
if cf="E" then
    select idcon from fe_con where tdoc="PCE" into nidcon;
  else
    select idcon from fe_con where tdoc="XTC" into nidcon;
end if;
if nimpo>0 then
    INSERT INTO fe_caja(forma,tipo,idauto,ndoc,fech,impo,deta,idusua,tmon,idcred,idcon,origen,fechao,mone,dola,nimpo,idpccaja,codt)
    values(cf,"I",nauto,cdcto,dfecha,nimpo,cdeta,nidus,cmon,idcreditos,nidcon,"CA",now(),cmon1,ndola1,nimporte1,cidpc,nidtda);
end if;
if nimpo1>0 then
     INSERT INTO fe_caja(forma,tipo,idauto,ndoc,fech,impo,deta,idusua,tmon,idcred,idcon,origen,fechao,mone,dola,nimpo,idpccaja,codt)
     values(cf,"I",nauto,cdcto,dfecha,nimpo1,cdeta,nidus,cmon,idcreditos,nidcon,"CA",now(),cmon1,ndola1,nimporte1,cidpc,nidtda);
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `IngresaCuentas` */

/*!50003 DROP PROCEDURE IF EXISTS  `IngresaCuentas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `IngresaCuentas`(nv1 decimal(12,2),
nv2 decimal(12,2),nv3 decimal(12,2),nv4 decimal(12,2),nv5 decimal(12,2),nv6 decimal(12,2),nv7 decimal(12,2),nv8 decimal(12,2),
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
