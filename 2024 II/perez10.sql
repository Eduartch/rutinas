/*
SQLyog Ultimate v12.09 (64 bit)
MySQL - 8.0.37 : Database - syscom_bdfperez
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
   update fe_ent set entr_acti='I' where entr_idgu=old.guia_idgui;
   insert into fe_aguias(ent1_idg1,ent1_idus,ent1_fope)values(old.guia_idgui,new.guia_idu1,localtime);
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_ipdtes` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `ActualizaIngresosPdtesEntregaVentas` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `ActualizaIngresosPdtesEntregaVentas` AFTER UPDATE ON `fe_ipdtes` FOR EACH ROW begin
if new.pdte_acti='I' then
   insert into fe_aipdtes(aipt_ipd1,aipt_cant,aipt_fope)values(old.pdte_idin,old.pdte_cant,localtime);
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_kar` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `Akardex` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `Akardex` AFTER UPDATE ON `fe_kar` FOR EACH ROW begin
if new.acti='I' then
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

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaNotasCredito` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaNotasCredito` AFTER UPDATE ON `fe_nccom` FOR EACH ROW begin
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

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaResumenDctos` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaResumenDctos` AFTER UPDATE ON `fe_rcom` FOR EACH ROW begin
if new.acti='I' then
   update fe_caja set acti='I' where idauto=old.idauto;
   update fe_kar set acti='I' where idauto=old.idauto;
   update fe_costos set cost_acti='I' where cost_idau=old.idauto;
   update fe_lcaja set lcaj_acti='I' where lcaj_idau=old.idauto;
   if old.idprov then
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

/*!50003 CREATE FUNCTION `FunBuscaNombre`(ct varchar(50),cb varchar(100),nid integer) RETURNS int
BEGIN
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
case
when trim(ct)="Clientes" then
     if nid=0 then
         Select idclie into vdvto From fe_clie Where Trim(razo)=cb And clie_acti<>'I' group by razo;
     else
   	    Select idclie into vdvto From fe_clie Where Trim(razo)=cb And idclie<>nid And clie_acti<>'I' group by razo;
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
when trim(ct)="ProductosCod" then
     if nid=0 then
         Select idart into vdvto From fe_art Where Trim(prod_cod1)=cb And prod_acti<>'I';
     else
   	    Select idart into vdvto From fe_art Where Trim(prod_cod1)=cb And idart<>nid And prod_acti<>'I';
     end if;
when trim(ct)="Fletes" then
     if nid=0 then
         Select idflete into vdvto From fe_fletes Where Trim(desflete)=cb And flet_acti<>'I';
     else
   	    Select idflete into vdvto From fe_fletes Where Trim(desflete)=cb And idflete>nid And flet_acti<>'I';
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
ctipo char,cemail varchar(45),nidven integer,nidus integer,cpc varchar(45),ccelu varchar(15),
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

/*!50003 CREATE FUNCTION `FuncreaProductos`(cdesc varchar(180),cunid varchar(4),nprec decimal(12,7),ncosto decimal(12,7),
np1 float,np2 float,np3 float,npeso float,ccat integer,cmar integer,ctipro char,nflete integer,cm char,cidpc varchar(45),
ncome float,ncomc float,nutil1 float,nutil2 float,nutil3 float,nidusua integer,nsmin float,nsmax float,ccodigo1 varchar(20),ndolar float) RETURNS int
BEGIN
declare nid integer default 0;
INSERT INTO fe_art(descri,unid,prec,cost,premay,premen,pre3,peso,idcat,idmar,tipro,idflete,tmon,fechc,idpc,prod_come,
prod_comc,prod_uti1,prod_uti2,prod_uti3,prod_idus,prod_smin,prod_smax,prod_cod1,prod_dola)
VALUES (cdesc,cunid,nprec,ncosto,np1,np2,np3,npeso,ccat,cmar,ctipro,nflete,cm,localtime,
cidpc,ncome,ncomc,nutil1,nutil2,nutil3,nidusua,nsmin,nsmax,ccodigo1,ndolar);
select last_insert_id() into nid from fe_art group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FuncreaProductos1` */

/*!50003 DROP FUNCTION IF EXISTS `FuncreaProductos1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FuncreaProductos1`(cdesc varchar(180),cunid varchar(4),nprec float,ncosto float,
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
   select idauto into sw from fe_rcom where ndoc=cdcto and tdoc=ctdoc and idprov=idp  and acti<>'I'  group by idauto;
  else
   select idauto into sw from fe_rcom where ndoc=cdcto and tdoc=ctdoc and idprov=idp  and idauto<>nidauto and acti<>'I' group by idauto;
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
ctdoc VARCHAR(2),cform CHAR,cndoc VARCHAR(12),dfecha DATE,dfechar DATE,cdetalle VARCHAR(120),
nv FLOAT,nigv FLOAT,nt FLOAT,cndo2 VARCHAR(10),cm CHAR,
ndolar FLOAT,ni FLOAT,ctg CHAR,ccodp INTEGER,cmvto CHAR,nus INTEGER,opt INTEGER,nidcodt INTEGER,
n1 INTEGER,n2 INTEGER,n3 INTEGER,nidautop INTEGER,npvta DECIMAL(12,2)) RETURNS int
BEGIN
DECLARE nid,idce,idve,nidctaper INTEGER;
DECLARE ctipo CHAR;
SET nid=0;
INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,dolar,vigv,tcom,idcliente,tipom,fusua,idusua,codt,idautop,pimpo,rcom_entr)
VALUES (ctdoc,cform,cndoc,dfecha,dfecha,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,ctg,ccodp,cmvto,LOCALTIME,nus,nidcodt,nidautop,npvta,'C');
SELECT LAST_INSERT_ID() INTO nid FROM fe_rcom GROUP BY LAST_INSERT_ID();
IF n1>0 AND n2>0 AND n3>0 THEN
   CALL IngresaCuentasV(nv,nigv,nt,n1,n2,n3,"H","H","D",nid);
END IF;
RETURN nid;
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
nv float,nigv float,nt float,cndo2 varchar(10),cm char,
ndolar float,ni float,ctg char,ccodp integer,cmvto char,nus integer,opt integer,nidcodt integer,
n1 integer,n2 integer,n3 integer,nitem integer,npvta float) RETURNS int
BEGIN
declare nid,ntdoc,idce,idve integer;
declare ctipo char;
set ntdoc=0;
set nid=0;
if opt=0 then
    if ctdoc='01' or ctdoc='09' or ctdoc='II' or ctdoc='07' or ctdoc='08' then
      set ctipo='C';
     else
      set ctipo='I';
   end if;
   INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,
   dolar,vigv,tcom,idprov,tipom,fusua,idusua,codt,rcom_nitem,rcom_tipo,pimpo,rcom_fech)
   VALUES (ctdoc,cform,cndoc,dfecha,dfechar,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,
   ni,ctg,ccodp,cmvto,localtime,nus,nidcodt,nitem,ctipo,npvta,dfecha);
   select last_insert_id() into nid from fe_rcom group by last_insert_id();
   if n1>0 and n2>0 and n3>0 then
      call IngresaCuentas(nv,0,0,0,nigv,0,0,nt,n1,0,0,0,n2,0,0,n3,"D","","","","D","","","H",nid);
   end if;
  else
   if ctdoc='20' then
      set ctipo='I';
    else
      set ctipo='C';
   end if;
   INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,
   dolar,vigv,tcom,idcliente,tipom,fusua,idusua,codt,rcom_nitem,rcom_tipo,pimpo,rcom_fech)
   VALUES (ctdoc,cform,cndoc,dfecha,dfecha,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,
   ctg,ccodp,cmvto,localtime,nus,nidcodt,nitem,ctipo,npvta,dfecha);
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
ctdoc VARCHAR(2),cform CHAR,cndoc VARCHAR(12),dfecha DATE,dfechar DATE,cdetalle VARCHAR(120),
nv DECIMAL(12,2),nigv DECIMAL(12,2),nt DECIMAL(12,2),cndo2 VARCHAR(10),cm CHAR,
ndolar FLOAT,ni FLOAT,ctg CHAR,ccodp INTEGER,cmvto CHAR,nus INTEGER,opt INTEGER,nidcodt INTEGER,
n1 INTEGER,n2 INTEGER,n3 INTEGER,nexonerada DECIMAL(12,2),ndetraccion DECIMAL(10,2),coddetra VARCHAR(3)) RETURNS int
BEGIN
DECLARE nid INTEGER;
SET nid=0;
   INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,dolar,vigv,tcom,idcliente,tipom,
   fusua,idusua,codt,rcom_exon,rcom_mdet,rcom_detr)
   VALUES (ctdoc,cform,cndoc,dfecha,dfecha,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,ctg,ccodp,cmvto,LOCALTIME,nus,nidcodt,nexonerada,ndetraccion,coddetra);
   SELECT LAST_INSERT_ID() INTO nid FROM fe_rcom GROUP BY LAST_INSERT_ID();
   IF n1>0 AND n2>0 AND n3>0 THEN
      IF nexonerada>0 THEN
          CALL IngresaCuentasV(nexonerada,nigv,nt,n1,n2,n3,"H","H","D",nid);
         ELSE
          CALL IngresaCuentasV(nv,nigv,nt,n1,n2,n3,"H","H","D",nid);
        END IF;
    END IF;
RETURN nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCabeceraVtasicbper` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCabeceraVtasicbper` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCabeceraVtasicbper`(
ctdoc VARCHAR(2),cform CHAR,cndoc VARCHAR(12),dfecha DATE,cdetalle VARCHAR(120),
nv FLOAT,nigv FLOAT,nt FLOAT,cndo2 VARCHAR(10),cm CHAR,
ndolar FLOAT,ni FLOAT,ctg CHAR,ccodp INTEGER,cmvto CHAR,nus INTEGER,nidcodt INTEGER,
n1 INTEGER,n2 INTEGER,n3 INTEGER,nitem DECIMAL(12,2),npvta FLOAT,nicbper DECIMAL(6,2)) RETURNS int
BEGIN
DECLARE nid INTEGER DEFAULT 0;
DECLARE ctipo CHAR;
SET nid=0;
INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,
dolar,vigv,tcom,idcliente,tipom,fusua,idusua,codt,rcom_tipo,pimpo,rcom_fech,rcom_icbper)
VALUES (ctdoc,cform,cndoc,dfecha,dfecha,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,
ctg,ccodp,cmvto,LOCALTIME,nus,nidcodt,ctipo,npvta,dfecha,nicbper);
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

/* Function  structure for function  `FunIngresaCajaBancos2` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCajaBancos2` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCajaBancos2`(idb integer,dfecha date,nop varchar(20),idmp integer,
cdeta varchar(200),idpr integer,idcl integer,cndoc varchar(20),idcta integer,debe decimal(12,2),
haber decimal(12,2),norden integer,nidclpr integer,ndola decimal(5,3)) RETURNS int
BEGIN
declare id integer;
insert into fe_cbancos(cban_idba,cban_nume,cban_fech,cban_idmp,cban_deta,cban_idpr,cban_idcl,cban_ndoc,cban_idct,
cban_debe,cban_haber,cban_orde,cban_clpr,cban_dola)values(idb,nop,dfecha,idmp,cdeta,idpr,idcl,cndoc,idcta,
debe,haber,norden,nidclpr,ndola);
select last_insert_id() into id from fe_cbancos group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCajaBancosInteres` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCajaBancosInteres` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCajaBancosInteres`(idb integer,dfecha date,nop varchar(20),idmp integer,
cdeta varchar(200),idpr integer,idcl integer,cndoc varchar(20),idcta integer,debe decimal(12,2),
haber decimal(12,2),norden integer,nidclpr integer,ndola decimal(5,3),nid0 integer) RETURNS int
BEGIN
declare id integer;
insert into fe_cbancos(cban_idba,cban_nume,cban_fech,cban_idmp,cban_deta,cban_idpr,cban_idcl,cban_ndoc,cban_idct,
cban_debe,cban_haber,cban_orde,cban_clpr,cban_dola,cban_idco1)values(idb,nop,dfecha,idmp,cdeta,idpr,idcl,cndoc,idcta,
debe,haber,norden,nidclpr,ndola,nid0);
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

/* Function  structure for function  `FunIngresaCajaBancosTran1` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCajaBancosTran1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCajaBancosTran1`(idb integer,dfecha date,nop varchar(20),idmp integer,
cdeta varchar(200),idpr integer,idcl integer,cndoc varchar(20),idcta integer,debe decimal(12,2),
haber decimal(12,2),norden integer,nidclpr integer,ndola decimal(5,2)) RETURNS int
BEGIN
declare id integer;
insert into fe_cbancos(cban_idba,cban_nume,cban_fech,cban_idmp,cban_deta,cban_idpr,cban_idcl,cban_ndoc,cban_idct,
cban_debe,cban_haber,cban_orde,cban_clpr,cban_tran,cban_ttra,cban_dola)values
(idb,nop,dfecha,idmp,cdeta,idpr,idcl,cndoc,idcta,debe,haber,norden,nidclpr,'T','T',ndola);
select last_insert_id() into id from fe_cbancos group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCajaBancosTx` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCajaBancosTx` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCajaBancosTx`(idb integer,dfecha date,nop varchar(20),idmp integer,
cdeta varchar(200),idpr integer,idcl integer,cndoc varchar(20),idcta integer,debe decimal(12,2),
haber decimal(12,2),norden integer,nidclpr integer,ndola decimal(5,3)) RETURNS int
BEGIN
declare id integer;
insert into fe_cbancos(cban_idba,cban_nume,cban_fech,cban_idmp,cban_deta,cban_idpr,cban_idcl,cban_ndoc,cban_idct,
cban_debe,cban_haber,cban_orde,cban_idca,cban_dola)values(idb,nop,dfecha,idmp,cdeta,idpr,idcl,cndoc,idcta,debe,
haber,norden,nidclpr,ndola);
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
insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,
lcaj_idus,lcaj_clpr,lcaj_fope)values
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,localtime);
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
lcaj_idus,lcaj_clpr,lcaj_idau,lcaj_fope)values
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,nidauto,localtime);
select last_insert_id() into id from fe_lcaja group by last_insert_id();
return id;
end */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaDatosLcajaE12` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDatosLcajaE12` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDatosLcajaE12`(dfecha datetime,cndoc varchar(10),cdeta varchar(100),idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),cmone char,ndolar decimal(5,3),nidus integer,nidtda integer) RETURNS int
begin
declare id integer;
insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,
lcaj_idus,lcaj_codt,lcaj_fope)values
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidtda,localtime);
select last_insert_id() into id from fe_lcaja group by last_insert_id();
return id;
end */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaDatosLcajaECreditos` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDatosLcajaECreditos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDatosLcajaECreditos`(dfecha date,cndoc varchar(10),cdeta varchar(100),idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),cmone char,ndolar decimal(5,3),nidus integer,nidcp integer,nidauto integer,cform char,cdcto char(15)) RETURNS int
begin
declare nid integer;
insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,
lcaj_idus,lcaj_idcr,lcaj_idau,lcaj_form,lcaj_fope,lcaj_dcto)values
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,nidauto,cform,localtime,cdcto);
select last_insert_id() into nid from fe_lcaja group by last_insert_id();
return nid;
end */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaDatosLcajaEDeudas` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDatosLcajaEDeudas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDatosLcajaEDeudas`(dfecha date,cndoc varchar(12),cdeta varchar(100),idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),cmone char,ndolar decimal(5,3),nidus integer,nidcp integer,nidauto integer,cform char,cdcto char(15),nidt integer) RETURNS int
begin
declare nid integer;
insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,
lcaj_idus,lcaj_idde,lcaj_idau,lcaj_form,lcaj_fope,lcaj_dcto,lcaj_codt)values
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,nidauto,cform,localtime,cdcto,nidt);
select last_insert_id() into nid from fe_lcaja group by last_insert_id();
return nid;
end */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaDatosLcajaEDeudasInteres` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDatosLcajaEDeudasInteres` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDatosLcajaEDeudasInteres`(dfecha date,cndoc varchar(12),cdeta varchar(100),idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),cmone char,ndolar decimal(5,3),
nidus integer,nidcp integer,nidauto integer,cform char,cdcto char(15),nidcaja integer,nidt integer) RETURNS int
begin
declare nid integer;
insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,
lcaj_idus,lcaj_idde,lcaj_idau,lcaj_form,lcaj_fope,lcaj_dcto,lcaj_idca1,lcaj_codt)values
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,nidauto,cform,localtime,cdcto,nidcaja,nidt);
select last_insert_id() into nid from fe_lcaja group by last_insert_id();
return nid;
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
   insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,lcaj_idus,lcaj_idcr,lcaj_fope)values
   (dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,localtime);
else
   insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,lcaj_idus,lcaj_idde,lcaj_fope)values
   (dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,localtime);
end if;
select last_insert_id() into id from fe_lcaja group by last_insert_id();
return id;
end */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaDatosLibroDiario` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDatosLibroDiario` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDatosLibroDiario`(dfech datetime,ndebe decimal(12,2),nhaber decimal(12,2),cglosa varchar(120),ct char(1),cnume varchar(10),nidcta integer,ccond char,nit integer,ncomp varchar(15),nidcl integer,
nidpr integer,cmone char,ctran char,nimtd decimal (12,2),nimth decimal(12,2),nidtda integer) RETURNS int
BEGIN
declare iddiario integer default 0;
insert into fe_ldiario(ldia_fech,ldia_debe,ldia_haber,ldia_glosa,ldia_tipo,
ldia_nume,ldia_idcta,ldia_cond,ldia_item,ldia_comp,ldia_idcv,ldia_idcc,ldia_mone,ldia_tran,ldia_itrd,ldia_itrh,ldia_codt)
values(dfech,ndebe,nhaber,cglosa,ct,cnume,nidcta,ccond,nit,ncomp,nidcl,nidpr,cmone,ctran,nimtd,nimth,nidtda);
select last_insert_id() into iddiario from fe_ldiario group by last_insert_id();
return iddiario;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaDatosLibroDiarioinicial` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDatosLibroDiarioinicial` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDatosLibroDiarioinicial`(dfech datetime,ndebe decimal(12,2),nhaber decimal(12,2),cglosa varchar(120),ct char(1),cnume varchar(10),nidcta integer,ccond char,nit integer,ncomp varchar(15),nidcl integer,
nidpr integer,cmone char,ctran char,nimtd decimal (12,2),nimth decimal(12,2),nidtda integer) RETURNS int
BEGIN
declare iddiario integer default 0;
insert into fe_ldiario(ldia_fech,ldia_debe,ldia_haber,ldia_glosa,ldia_tipo,
ldia_nume,ldia_idcta,ldia_cond,ldia_item,ldia_comp,ldia_idcv,ldia_idcc,ldia_mone,ldia_tran,ldia_itrd,ldia_itrh,ldia_inic,ldia_codt)
values(dfech,ndebe,nhaber,cglosa,ct,cnume,nidcta,ccond,nit,ncomp,nidcl,nidpr,cmone,ctran,nimtd,nimth,'I',nidtda);
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

/* Function  structure for function  `FunIngresaDatosLibroDiarioPle55` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDatosLibroDiarioPle55` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDatosLibroDiarioPle55`(dfech datetime,ndebe decimal(12,2),
nhaber decimal(12,2),cglosa varchar(120),ct char(1),cnume varchar(12),nidcta integer,ccond char,nit integer,ncomp varchar(15),
nidcl integer,nidpr integer,cmone char,ctran char,nimtd decimal (12,2),nimth decimal(12,2),ctdoc varchar(2),nidauto integer,nidtda integer) RETURNS int
BEGIN
declare iddiario integer default 0;
insert into fe_ldiario(ldia_fech,ldia_debe,ldia_haber,ldia_glosa,ldia_tipo,
ldia_nume,ldia_idcta,ldia_cond,ldia_item,ldia_comp,ldia_idcv,ldia_idcc,ldia_mone,ldia_tran,ldia_itrd,ldia_itrh,ldia_tdoc,ldia_idau,ldia_codt)
values(dfech,ndebe,nhaber,cglosa,ct,cnume,nidcta,ccond,nit,ncomp,nidcl,nidpr,cmone,ctran,nimtd,nimth,ctdoc,nidauto,nidtda);
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

/*!50003 CREATE FUNCTION `FunIngresaDCreditos`(dfecha datetime,dfevto datetime,nimpo float,cndoc varchar(10),
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
cdeta varchar(180),csitua varchar(2)) RETURNS int
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
ndolar DECIMAL(6,4),ni DECIMAL(6,4),ctg CHAR,ccodp INTEGER,cmvto CHAR,nus INTEGER,nidcodt INTEGER,
n1 INTEGER,n2 INTEGER,n3 INTEGER,nitem INTEGER,idtr DECIMAL(10,2),nexon DECIMAL(12,2),ndscto DECIMAL(12,2)) RETURNS int
BEGIN
DECLARE nid INTEGER;
SET nid=0;
   INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,dolar,vigv,tcom,idcliente,
   tipom,fusua,idusua,codt,pimpo,rcom_exon,rcom_dsct)
   VALUES (ctdoc,cform,cndoc,dfecha,dfecha,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,ctg,ccodp,cmvto,LOCALTIME,nus,nidcodt,
   idtr,nexon,ndscto);
   SELECT LAST_INSERT_ID() INTO nid FROM fe_rcom GROUP BY LAST_INSERT_ID();
 IF n1>0 AND n2>0 AND n3>0 THEN
    IF n1>0 AND n2>0 AND n3>0 THEN
      CALL IngresaCuentasV(nv,nigv,nt,n1,n2,n3,"H","H","D",nid);
   END IF;
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

/*!50003 CREATE FUNCTION `FunIngresaGuiasxComprasRemitente`(dfecha datetime,cptop varchar(100),cptoll varchar(150),nidauto integer,
dfechat datetime,nidus integer,cdeta varchar(150),nidtr integer,cndoc varchar(12),nidtda integer,cdcto varchar(12),df date) RETURNS int
BEGIN
declare id integer;
insert into fe_guias(guia_fech,guia_ptop,guia_ptoll,guia_idau,guia_fect,guia_idus,guia_fope,guia_deta,guia_idtr,guia_ndoc,guia_moti,guia_codt,guia_dcto,guia_fecd)
values(dfecha,cptop,cptoll,nidauto,dfechat,nidus,localtime,cdeta,nidtr,cndoc,'C',nidtda,cdcto,df);
select last_insert_id() into id from  fe_guias group by last_insert_id();
return id;
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

/*!50003 CREATE FUNCTION `FunIngresaKardex1`(nid integer,cc integer,ct char,npr float,
nct float,cincl char,tmvto char,ccodv integer,calma integer,nidcosto1 integer,vcom float) RETURNS int
BEGIN
declare nidk integer default 0;
if ct='C' then
  INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,ttip,incl,alma,kar_idco,codv,kar_alma1)
  VALUES (nid,cc,ct,npr,nct,tmvto,cincl,calma,nidcosto1,ccodv,calma);
 else
  INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,ttip,incl,alma,kar_idco,codv,kar_alma1,kar_comi)
  VALUES (nid,cc,ct,npr,nct,tmvto,cincl,calma,nidcosto1,ccodv,0,vcom);
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

/* Function  structure for function  `FunIngresaKardexdetraccion` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaKardexdetraccion` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaKardexdetraccion`(nid INTEGER,cc INTEGER,nicbper decimal(6,2),npr FLOAT,
nct FLOAT,cincl CHAR,tmvto CHAR,ccodv INTEGER,calma INTEGER,nidcosto1 decimal(10,5),vcom FLOAT,ndetraccion decimal(5,2)) RETURNS int
BEGIN
DECLARE nidk INTEGER DEFAULT 0;
INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,ttip,incl,alma,kar_cost,codv,kar_alma1,kar_comi,kar_icbper,kar_detr)
VALUES (nid,cc,'V',npr,nct,tmvto,cincl,calma,nidcosto1,ccodv,0,vcom,nicbper,ndetraccion);
SELECT LAST_INSERT_ID() INTO nidk FROM fe_kar GROUP BY LAST_INSERT_ID();
RETURN nidk;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaKardexIcbper` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaKardexIcbper` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaKardexIcbper`(nid INTEGER,cc INTEGER,nicbper decimal(6,2),npr FLOAT,
nct FLOAT,cincl CHAR,tmvto CHAR,ccodv INTEGER,calma INTEGER,nidcosto1 decimal(10,5),vcom FLOAT) RETURNS int
BEGIN
DECLARE nidk INTEGER DEFAULT 0;
INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,ttip,incl,alma,kar_cost,codv,kar_alma1,kar_comi,kar_icbper)
VALUES (nid,cc,'V',npr,nct,tmvto,cincl,calma,nidcosto1,ccodv,0,vcom,nicbper);
SELECT LAST_INSERT_ID() INTO nidk FROM fe_kar GROUP BY LAST_INSERT_ID();
RETURN nidk;
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

/*!50003 CREATE FUNCTION `FUNINGRESANOTASCREDITOventas1`(nid0 INTEGER,nid1 INTEGER,nidpagos INTEGER,nimpo DECIMAL(8,2)) RETURNS int
BEGIN
DECLARE id INTEGER DEFAULT 0;
INSERT INTO fe_ncven(ncre_idan,ncre_idau,ncre_idpa,ncre_impo)VALUES(nid0,nid1,nidpagos,nimpo);
SELECT LAST_INSERT_ID() INTO id FROM fe_ncven GROUP BY LAST_INSERT_ID();
RETURN id;
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
cndoc varchar(12),nacta float,cesta char,cmone char,cb1 varchar(100),dfech date,
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
cndoc varchar(12),nacta float,cesta char,cmone char,cb1 varchar(100),dfech date,
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
cndoc varchar(12),nacta float,cesta char,cmone char,cb1 varchar(100),dfech date,
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
dfevto datetime,nacta float,cndoc varchar(12),cesta char,cmone char,cb1 varchar(100),ctipo char,
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
sacreedor decimal(12,2),cmone char,ndolar decimal(5,3),nidus integer,nidt integer) RETURNS int
begin
declare id integer;
insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,lcaj_idus,lcaj_codt,lcaj_tran)values
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidt,'T');
select last_insert_id() into id from fe_lcaja group by last_insert_id();
return id;
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
if vdvto>0 then
   return 1;
 else
   return 0;
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
select count(*)  into sw1 from fe_art where idcat=nid group by idcat;
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
select count(*) into sw from fe_art where idmar=nid group by idmar;
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
select codv into sw1 from fe_kar where codv=nid group by codv;
select rcre_codv into sw2 from fe_rcred where rcre_codv=nid group by rcre_codv;
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
declare vdvto,nmes,na,ndif integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
select month(fech) into nmes from fe_gene  where idgene=1;
select year(fech) into na from fe_gene where idgene=1;
if year(dfecha)<>na then
 select datediff(v.fech,dfecha) into ndif from fe_gene v where idgene=1;
  if ndif<=720 then
     return 1;
   else
      return 0;
   end if;
 else
     if month(dfecha)=nmes then
        return 1;
     else
        select mes_idme into vdvto from fe_meses where mes_idme=month(dfecha) and mes_compra='A';
        if vdvto>0 then
          return 1;
         else
          return 0;
        end if;
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
set nid1=(select pdte_idin from fe_ipdtes where pdte_idau=nid group by pdte_idau);
if nid1>0 then
   set nid2=(select count(*) from fe_entregas where entr_idin=nid1);
   if nid2>0 then
       set sw=0;
      else
       set sw=1;
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

/* Procedure structure for procedure `AbrirCaja` */

/*!50003 DROP PROCEDURE IF EXISTS  `AbrirCaja` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `AbrirCaja`(in dfecha date)
BEGIN
update fe_caja set estado=' ' where fech=dfecha;
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
sum(if(b.tipo='V',b.cant,0)) as tventas,b.alma from fe_kar as b
inner join fe_rcom as a on a.idauto=b.idauto
where b.acti<>'I' and a.acti='A' group by  idart,alma) as a where (a.tcompras-a.tventas)<>0 order by idart,alma;
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

/* Procedure structure for procedure `CalcularStock1` */

/*!50003 DROP PROCEDURE IF EXISTS  `CalcularStock1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `CalcularStock1`()
BEGIN
DECLARE done INT DEFAULT 0;
declare tsaldo float;
declare ccoda integer;
declare cursor1 cursor for
select a.idart,a.tcompras-a.tventas as saldo
from (select b.idart,sum(if(b.tipo='C',b.cant,0)) as tcompras,
sum(if(b.tipo='V',b.cant,0)) as tventas from fe_kar as b inner join fe_rcom as a
on a.idauto=b.idauto where b.acti='A' and a.acti='A' and a.rcom_tipo='C' and a.rcom_fech>="2014-01-01" group by  idart) as a;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
open cursor1;
start transaction;
UPDATE fe_art SET prod_stoc=0;
repeat
    fetch cursor1 into ccoda,tsaldo;
    update fe_art set prod_stoc=tsaldo where idart=ccoda;
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

/* Procedure structure for procedure `IngresaCuentasv` */

/*!50003 DROP PROCEDURE IF EXISTS  `IngresaCuentasv` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `IngresaCuentasv`(nv1 decimal(12,2),
nv2 decimal(12,2),nv3 decimal(12,2),nid1 integer,nid2 integer,nid3 integer,ct1 char,ct2 char,ct3 char,nid integer)
BEGIN
insert into fe_ectas(idrven,impo,idcta,nitem,tipo)
values(nid,nv1,nid1,1,ct1);
insert into fe_ectas(idrven,impo,idcta,nitem,tipo)
values(nid,nv2,nid2,2,ct2);
insert into fe_ectas(idrven,impo,idcta,nitem,tipo)
values(nid,nv3,nid3,3,ct3);
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

/* Procedure structure for procedure `ProActualizaCabeceraCV` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCabeceraCV` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCabeceraCV`(
ctdoc varchar(2),cform char,cndoc varchar(12),dfecha date,dfechar date,cdetalle varchar(120),
nv decimal(12,2),nigv decimal(12,2),nt decimal(12,2),cndo2 varchar(10),cm char,
ndolar float,ni float,ctg char,ccodp integer,cmvto char,nus integer,opt integer,nidcodt integer,
n1 integer,n2 integer,n3 integer,nitems integer,npvta float,nidauto integer)
BEGIN
declare idce,idve,nidctaper integer;
if opt=0 then
   select gene_idce into idce from fe_gene where idgene=1;
   update fe_rcom set tdoc=ctdoc,form=cform,ndoc=cndoc,fech=dfecha,fecr=dfechar,deta=cdetalle,valor=nv,igv=nigv,impo=nt,ndo2=cndo2,
   mone=cm,dolar=ndolar,vigv=ni,tcom=ctg,idprov=ccodp,tipom=cmvto,idusua1=nus,codt=nidcodt,rcom_nitem=nitems where idauto=nidauto;
 call ProDesactivaLcajaE(nidauto);
  if n1>0 and n2>0 and n3>0 then
      select @id1:=sum(x.nid1),@id5:=sum(x.nid2),@id6:=sum(x.nid3),@id8:=sum(x.nid4)
      from (select case nitem when 1 then idectas else 0 end as nid1,
      case nitem when 5 then idectas else 0 end as nid2,
      case nitem when 6 then idectas else 0 end as nid3,
      case nitem when 8 then idectas else 0 end as nid4,idrcon
      from fe_ectasc where idrcon=nidauto) as x group by idrcon;
      if @id1>0 then
        call ProActualizaCuentasc(nv,0,0,0,nigv,0,0,nt,n1,0,0,0,n2,0,0,n3,@id1,@id5,@id6,@id8,"D","D","","H");
      else
           call IngresaCuentas(nv,0,0,0,nigv,0,0,nt,n1,0,0,0,n2,0,0,n3,"D","","","","D","","","H",nidauto);
      end if;
    end if;
  else
   select gene_idve into idve from fe_gene where idgene=1;
   update fe_rcom set tdoc=ctdoc,form=cform,ndoc=cndoc,fech=dfecha,fecr=dfechar,deta=cdetalle,valor=nv,igv=nigv,impo=nt,ndo2=cndo2,
   mone=cm,dolar=ndolar,vigv=ni,tcom=ctg,idcliente=ccodp,tipom=cmvto,idusua1=nus,codt=nidcodt,rcom_nitem=nitems where idauto=nidauto;
   call ProDesactivaLcajaE(nidauto);
   if n1>0 and n2>0 and n3>0 then
      select @i1:=sum(xx.nid1),@i2:=sum(xx.nid2),@i3:=sum(xx.nid3)
      from (select case a.nitem when 1 then idectas else 0 end as nid1,
      case a.nitem when 2 then idectas else 0 end as nid2,
      case a.nitem when 3 then idectas else 0 end as nid3,idrven
      from fe_ectas  as a where idrven=nidauto) as xx group by idrven;
      if @i1>0 then
         call ProActualizaCuentasV(nv,nigv,nt,n1,n2,n3,@i1,@i2,@i3,"H","H","D");
      else
        if ctdoc<>'20' then  
           call IngresaCuentasV(nv,nigv,nt,n1,n2,n3,"H","H","D",nidauto);
       end if;
      end if;
     end if;
 end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCabeceracVTas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCabeceracVTas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCabeceracVTas`(
ctdoc VARCHAR(2),cform CHAR,cndoc VARCHAR(12),dfecha DATE,cdetalle VARCHAR(120),
nv DECIMAL(12,2),nigv DECIMAL(12,2),nt DECIMAL(12,2),cndo2 VARCHAR(12),cm CHAR,
ndolar FLOAT,ni FLOAT,ctg CHAR,ccodp INTEGER,cmvto CHAR,nus INTEGER,nporcentaje DECIMAL(5,2),nidcodt INTEGER,
n1 INTEGER,n2 INTEGER,n3 INTEGER,nexon DECIMAL(12,2),ncargo DECIMAL(12,2),nidauto INTEGER,nidven INTEGER)
BEGIN
DECLARE idve,nidctaper INTEGER;
    UPDATE fe_rcom SET tdoc=ctdoc,form=cform,ndoc=cndoc,fech=dfecha,fecr=dfecha,deta=cdetalle,valor=nv,igv=nigv,impo=nt,ndo2=cndo2,
   mone=cm,dolar=ndolar,vigv=ni,tcom=ctg,idcliente=ccodp,tipom=cmvto,idusua1=nus,codt=nidcodt,
   rcom_arch="",rcom_dsct=nporcentaje,rcom_exon=nexon WHERE idauto=nidauto;
 CALL ProDesactivaLcajaE(nidauto);
   IF n1>0 AND n2>0 AND n3>0 THEN
      SELECT @i1:=SUM(xxnid1),@i2:=SUM(xx.nid2),@i3:=SUM(xx.nid3),@i4:=SUM(xx.nid4)
      FROM (SELECT CASE a.nitem WHEN 1 THEN idectas ELSE 0 END AS nid1,
      CASE a.nitem WHEN 2 THEN idectas ELSE 0 END AS nid2,
      CASE a.nitem WHEN 3 THEN idectas ELSE 0 END AS nid3,
      CASE a.nitem WHEN 4 THEN idectas ELSE 0 END AS nid4,idrven
      FROM fe_ectas  AS a WHERE idrven=nidauto) AS xx GROUP BY idrven;
      CALL ProActualizaCuentasV(nv,nigv,nt,n1,n2,n3,@i1,@i2,@i3,"H","H","D");
END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCabeceraCVtasicbper` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCabeceraCVtasicbper` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCabeceraCVtasicbper`(
ctdoc VARCHAR(2),cform CHAR,cndoc VARCHAR(12),dfecha DATE,cdetalle VARCHAR(120),
nv DECIMAL(12,2),nigv DECIMAL(12,2),nt DECIMAL(12,2),cndo2 VARCHAR(10),cm CHAR,
ndolar FLOAT,ni FLOAT,ctg CHAR,ccodp INTEGER,cmvto CHAR,
nus INTEGER,nicbper DECIMAL(8,2),nidcodt INTEGER,n1 INTEGER,n2 INTEGER,
n3 INTEGER,nitems INTEGER,npvta FLOAT,nidauto INTEGER)
BEGIN
UPDATE fe_rcom SET tdoc=ctdoc,form=cform,ndoc=cndoc,fech=dfecha,fecr=dfecha,deta=cdetalle,valor=nv,igv=nigv,impo=nt,ndo2=cndo2,
mone=cm,dolar=ndolar,vigv=ni,tcom=ctg,idcliente=ccodp,tipom=cmvto,idusua1=nus,codt=nidcodt,rcom_icbper=nicbper WHERE idauto=nidauto;
CALL ProDesactivaLcajaE(nidauto);
IF n1>0 AND n2>0 AND n3>0 THEN
     SELECT @i1:=SUM(xx.nid1),@i2:=SUM(xx.nid2),@i3:=SUM(xx.nid3),@i4:=SUM(xx.nid4)
     FROM (SELECT CASE a.nitem WHEN 1 THEN idectas ELSE 0 END AS nid1,
     CASE a.nitem WHEN 2 THEN idectas ELSE 0 END AS nid2,
     CASE a.nitem WHEN 3 THEN idectas ELSE 0 END AS nid3,
     CASE a.nitem WHEN 4 THEN idectas ELSE 0 END AS nid4,idrven
     FROM fe_ectas  AS a WHERE idrven=nidauto) AS xx GROUP BY idrven;
      IF @i1>0 THEN
         CALL ProActualizaCuentasV(nv,nigv,nt,n1,n2,n3,@i1,@i2,@i3,"H","H","D");
      ELSE
        IF ctdoc<>'20' THEN
           CALL IngresaCuentasV(nv,nigv,nt,n1,n2,n3,"H","H","D",nidauto);
       END IF;
      END IF;
END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCabeceraPedido` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCabeceraPedido` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCabeceraPedido`(dfech date,nidclie integer,cndoc varchar(10),ctdoc varchar(2),
nimpo float,cform char,nidven integer,nidauto integer)
BEGIN
UPDATE fe_rped SET fech=dfech,idclie=nidclie,ndoc=cndoc,tdoc=ctdoc,impo=nimpo,form=cform,idven=nidven,facturado='N',
tipopedido='p' WHERE idautop=nidauto;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCabeceraporTraspasos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCabeceraporTraspasos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCabeceraporTraspasos`(nid integer,nit integer,opt integer,nu integer,nu1 integer)
BEGIN
if opt=0 then
   update fe_rcom set rcom_idtr=nit where idauto=nid;
 else
   update fe_rcom set rcom_idtr=0 where idauto=nid;
   update fe_traspaso set tras_acti='I' where tras_idau=nit;
   Call ProAnulaTransacciones(@estado,'','','C',nit,nu,'N',localtime,nu1);
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCabeceraTraspasoN` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCabeceraTraspasoN` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCabeceraTraspasoN`(
ctdoc varchar(2),cform char,cndoc varchar(10),dfecha date,dfechar date,cdetalle varchar(120),
nv float,nigv float,nt float,cndo2 varchar(10),cm char,
ndolar float,ni float,ctg char,ccodp integer,cmvto char,nus integer,opt integer,nidcodt integer,
n1 integer,n2 integer,n3 integer,nitem integer,npvta float,copt char,nauto integer)
BEGIN
Update fe_rcom set tdoc=ctdoc,form=cform,ndoc=cndoc,fech=dfecha,fecr=dfechar,deta=cdetalle,valor=nv,
igv=nigv,impo=nt,ndo2=cndo2,mone=cm,dolar=ndolar,vigv=ni,tcom=ctg,tipom=cmvto,codt=nidcodt,rcom_nitem=nitem,rcom_reci='P' where idauto=nauto;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCabeceraVentascdetraccion` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCabeceraVentascdetraccion` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCabeceraVentascdetraccion`(
ctdoc VARCHAR(2),cform CHAR,cndoc VARCHAR(12),dfecha DATE,dfechar DATE,cdetalle VARCHAR(120),
nv DECIMAL(12,2),nigv DECIMAL(12,2),nt DECIMAL(12,2),cndo2 VARCHAR(10),cm CHAR,
ndolar FLOAT,ni FLOAT,ctg CHAR,ccodp INTEGER,cmvto CHAR,nus INTEGER,opt INTEGER,nidcodt INTEGER,
n1 INTEGER,n2 INTEGER,n3 INTEGER,nexonerado DECIMAL(12,2),npvta FLOAT,ndetraccion DECIMAL(10,2),nidauto INTEGER,coddetra VARCHAR(3))
BEGIN
  UPDATE fe_rcom SET tdoc=ctdoc,form=cform,ndoc=cndoc,fech=dfecha,fecr=dfechar,deta=cdetalle,valor=nv,igv=nigv,impo=nt,ndo2=cndo2,
   mone=cm,dolar=ndolar,vigv=ni,tcom=ctg,idcliente=ccodp,tipom=cmvto,idusua1=nus,codt=nidcodt,rcom_exon=nexonerado,rcom_mdet=ndetraccion,
   rcom_detr=coddetra WHERE idauto=nidauto;
   IF n1>0 AND n2>0 AND n3>0 THEN
      SELECT @i1:=SUM(xx.nid1),@i2:=SUM(xx.nid2),@i3:=SUM(xx.nid3)
      FROM (SELECT CASE a.nitem WHEN 1 THEN idectas ELSE 0 END AS nid1,
      CASE a.nitem WHEN 2 THEN idectas ELSE 0 END AS nid2,
      CASE a.nitem WHEN 3 THEN idectas ELSE 0 END AS nid3,idrven
      FROM fe_ectas  AS a WHERE idrven=nidauto) AS xx GROUP BY idrven;
      CALL ProActualizaCuentasV(nv,nigv,nt,n1,n2,n3,@i1,@i2,@i3,"H","H","D");
   END IF;
   CALL ProDesactivaLcajaE(nidauto);
 END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCaja` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCaja` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCaja`(na integer,dfecha date,nt1 float,cmvtoc char,cform char,cm1 char,cndoc varchar(12),nidcon integer,
cu integer,cdetalle varchar(120),cor varchar(2),nimp1 float,cm2 char,tcvta float,nidcodt integer,nidcaja integer)
BEGIN
Update fe_caja set fech=dfecha,impo=nt1,tipo=cmvtoc,forma=cform,tmon=cm1,ndoc=cndoc,idcon=nidcon,idusua=cu,deta=cdetalle,origen=cor,
nimpo=nimp1,mone=cm2,dola=tcvta,codt=nidcodt where idcaja=nidcaja;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCajaBancos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCajaBancos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCajaBancos`(idb integer,dfecha date,nope varchar(20),idmp integer,
cdeta varchar(120),idpr integer,idcl integer,cndoc varchar(20),idcta integer,debe float,haber float,norden integer,id integer,opt integer)
BEGIN
declare nidclpr integer default 0;
if opt=0 then
   update fe_cbancos set cban_acti='I' where cban_idco=id;
  else
   if idcl>0 then
      set nidclpr=idcl;
     else
       set nidclpr=idpr;
   end if;
   update fe_cbancos set cban_nume=nope,cban_idba=idb,cban_fech=dfecha,cban_idmp=idmp,
   cban_deta=cdeta,cban_idpr=idpr,cban_idcl=idcl,cban_ndoc=cndoc,cban_idct=idcta,
   cban_debe=debe,cban_haber=haber,cban_orde=norden,cban_clpr=nidclpr  where cban_idco=id;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCajaBancos1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCajaBancos1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCajaBancos1`(idb integer,dfecha date,nope varchar(20),idmp integer,
cdeta varchar(120),idpr integer,idcl integer,cndoc varchar(20),idcta integer,debe float,haber float,norden integer,id integer,
opt integer,nd decimal(5,3))
BEGIN
declare nidclpr integer default 0;
if opt=0 then
   update fe_cbancos set cban_acti='I' where cban_idco=id;
  else
   if idcl>0 then
      set nidclpr=idcl;
     else
       set nidclpr=idpr;
   end if;
   update fe_cbancos set cban_nume=nope,cban_idba=idb,cban_fech=dfecha,cban_idmp=idmp,
   cban_deta=cdeta,cban_idpr=idpr,cban_idcl=idcl,cban_ndoc=cndoc,cban_idct=idcta,
   cban_debe=debe,cban_haber=haber,cban_orde=norden,cban_clpr=nidclpr,cban_dola=nd  where cban_idco=id;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizacanjesC` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizacanjesC` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizacanjesC`(anidc integer,anidcc integer,opt integer)
begin
if opt=1 then
   update fe_ccanjes set canj_idca=anidc where canj_idca=anidcc;
  else
   update fe_ccanjes set canj_acti='I' where canj_idca=anidcc;
   update fe_rcred set rcre_acti='I' where rcre_idrc=anidcc;
end if;
end */$$
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

/* Procedure structure for procedure `ProActualizaCargos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCargos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCargos`(nid integer,opt integer)
begin
  if opt=0 then
     update fe_cargos set carg_acti='I' where carg_idca=nid;
  else
     update fe_cargos set carg_cond='C' where carg_idca=nid;
  end if;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCliente` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCliente` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCliente`(nid integer,cruc varchar(11),crazo varchar(100),
cdire varchar(100),cciud varchar(100),cfono varchar(15),cfax varchar(15),cdni varchar (11),
ctipo char,cemail varchar(45),nidven integer,nidus integer,ccelu varchar(15),crefe varchar(255),linea float,crpm varchar(10),nidz integer)
BEGIN
update fe_clie set
nruc=cruc,razo=crazo,dire=cdire,ciud=cciud,fono=cfono,fax=cfax,ndni=cdni,clie_tipo=ctipo,clie_corr=cemail,
clie_codv=nidven,clie_actu=nidus,clie_feac=localtime,celu=ccelu,refe=crefe,clie_lcre=linea,clie_rpm=crpm,clie_idzo=nidz
where idclie=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaComisiones` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaComisiones` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaComisiones`(ncome decimal(9,3),ncomc decimal(9,3),nidart integer)
begin
update fe_art set prod_come=ncome,prod_comc=ncomc where idart=nidart;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCostoproducto` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCostoproducto` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCostoproducto`(np decimal(6,3),nidart integer)
begin
update fe_art  as s set prec=s.prec*np where idart=nidart;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCostos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCostos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCostos`(nidcosto integer,ncosto float,nflete float,nprecio float,
cmoneda char,ndolar float)
BEGIN
update fe_costos set cost_cost=ncosto,cost_flet=nflete,cost_prec=nprecio,cost_mone=cmoneda,cost_dola=ndolar
where cost_idco=nidcosto;
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

/* Procedure structure for procedure `ProActualizaCotizacion1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCotizacion1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCotizacion1`(dfech datetime,nidclie integer,
cndoc varchar(10),ctdoc varchar(2),nimpo float,cform char,cusua integer,nidven integer,nidtienda integer,ctp char,
caten varchar(80),cforma varchar(80),cplazo varchar(80),cvalidez varchar(80),centrega varchar(80),cdetalle varchar(150),ctvta char,nidauto integer)
BEGIN
UPDATE fe_rped SET fech=dfech,idclie=nidclie,ndoc=cndoc,impo=nimpo,form=cform,idven=nidven,facturado='N',tdoc=ctdoc,
tipopedido='P',aten=caten,forma=cforma,plazo=cplazo,validez=cvalidez,entrega=centrega,detalle=cdetalle,rped_tipo=ctvta WHERE idautop=nidauto;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCreditos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCreditos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCreditos`(nauto integer,nu integer)
BEGIN
update fe_rcred set rcre_acti='I',rcre_idus1=nu where rcre_idau=nauto;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCtasBancos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCtasBancos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCtasBancos`(cta varchar(100),idb integer,cmone char,cdeta varchar(100),nidcta integer,opt integer,nidctap integer)
BEGIN
if opt=0 then
   update fe_ctasb set ctas_acti='I' where ctas_idct=nidcta;
  else
   update fe_ctasb set ctas_ctas=cta,ctas_idba=idb,ctas_mone=cmone,ctas_deta=cdeta,ctas_ncta=nidctap where ctas_idct=nidcta;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCtasc` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCtasc` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCtasc`(in nv1 decimal(12,2),
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

/* Procedure structure for procedure `ProActualizaCuentasc` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCuentasc` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCuentasc`(in nv1 decimal(12,2),
in nv2 decimal(12,2),in nv3 decimal(12,2),in nv4 decimal(12,2),in nv5 decimal(12,2),in nv6 decimal(12,2),
in nv7 decimal(12,2),in nv8 decimal(12,2),in nid1 integer,in nid2 integer,nid3 integer,
in nid4 integer,in nid5 integer,nid6 integer,in nid7 integer,in nid8 integer,
in idv1 integer,in idv2 integer, in idv3 integer,
in idv4 integer,in ct1 char,in ct2 char,in ct3 char,in ct4 char)
BEGIN
update fe_ectasc set impo=nv1,idcta=nid1,ecta_tipo=ct1 where idectas=idv1;
update fe_ectasc set impo=nv5,idcta=nid5,ecta_tipo=ct2 where idectas=idv2;
update fe_ectasc set impo=nv6,idcta=nid6,ecta_tipo=ct3 where idectas=idv3;
update fe_ectasc set impo=nv8,idcta=nid8,ecta_tipo=ct4 where idectas=idv4;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCuentasv` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCuentasv` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCuentasv`(in nv1 decimal(12,2),
in nv2 decimal(12,2),in nv3 decimal(12,2),in nid1 integer,in nid2 integer,nid3 integer,in idv1 integer,
in idv2 integer, in idv3 integer,ct1 char,ct2 char,ct3 char)
BEGIN
update fe_ectas set impo=nv1,idcta=nid1,tipo=ct1 where idectas=idv1;
update fe_ectas set impo=nv2,idcta=nid2,tipo=ct2 where idectas=idv2;
update fe_ectas set impo=nv3,idcta=nid3,tipo=ct3  where idectas=idv3;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROACTUALIZADATOSDIARIO` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROACTUALIZADATOSDIARIO` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROACTUALIZADATOSDIARIO`(dfech datetime,ndebe decimal(12,2)
,nhaber decimal(12,2),cglosa varchar(120),ct char(1),cnume varchar(10),nidcta integer,idd integer,
opt integer,ccond char,nit integer,ncomp varchar(15),nidcl integer,nidpr integer,cmone char,ctran char,nidtda integer)
BEGIN
if opt=0 then
   update fe_ldiario set ldia_acti='I' where ldia_idld=idd;
 else
   update fe_ldiario set ldia_fech=dfech,ldia_debe=ndebe,ldia_haber=nhaber,ldia_glosa=cglosa,ldia_tipo=ct,ldia_nume=cnume,
   ldia_idcta=nidcta,ldia_cond=ccond,ldia_tran=ctran,
   ldia_item=nit,ldia_comp=ncomp,ldia_idcv=nidcl,ldia_idcc=nidpr,ldia_mone=cmone,ldia_codt=nidtda where ldia_idld=idd;
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

/*!50003 CREATE PROCEDURE `ProActualizaDatosLcajaE1`(dfecha datetime,cndoc varchar(10),cdeta varchar(100),idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),nidauto integer,cmone char,ndolar decimal(5,3),idcl integer)
begin
update fe_lcaja  set lcaj_fech=dfecha,lcaj_ndoc=cndoc,lcaj_deta=cdeta,lcaj_idct=idcta,
lcaj_deud=sdeudor,lcaj_acre=sacreedor,lcaj_mone=cmone,lcaj_dola=ndolar,lcaj_clpr=idcl where lcaj_idau=nidauto and lcaj_acti='A';
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

/* Procedure structure for procedure `ProActualizaDctosVendedor` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaDctosVendedor` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaDctosVendedor`(nidauto integer,nidv integer,dfecha date)
BEGIN
update fe_rcom set rcom_codv=nidv,rcom_feen=dfecha where idauto=nidauto;
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
     UPDATE fe_ped SET acti='I' WHERE idped=nr;
   else
    UPDATE fe_ped SET idart=ncoda,cant=ncant,prec=nprec WHERE idped=nr;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaDetalleVta` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaDetalleVta` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaDetalleVta`(nidauto integer)
begin
   update fe_detallevta set detv_acti='I' where detv_idau=nidauto;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaDeudas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaDeudas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaDeudas`(nauto integer,nu integer)
BEGIN
update fe_rdeu set rdeu_acti='I',rdeu_idus1=nu where rdeu_idau=nauto;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROActualizaDsctoProductos` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROActualizaDsctoProductos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROActualizaDsctoProductos`(ncoda integer,ndscto decimal(12,2))
begin
update fe_art  as a set prec=a.prec*((100-ndscto)/100) where idart=ncoda;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaEstadoGuiaCons` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaEstadoGuiaCons` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaEstadoGuiaCons`(nid integer,cestado char)
BEGIN
update fe_guias set guia_esta=cestado where guia_idgui=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROACTUALIZAGUIASCOMPRAS` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROACTUALIZAGUIASCOMPRAS` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROACTUALIZAGUIASCOMPRAS`(nid0 integer,nid1 integer)
BEGIN
update fe_guiac set guic_idac=nid1,guic_tipo='E' where guic_idau=nid0;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaGuiasCons` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaGuiasCons` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaGuiasCons`(dfecha date,cptop varchar(100),cptoll varchar(100),nidauto integer,
dfechat date,nidus integer,cdeta varchar(150),nidtr integer,cndoc varchar(10),nidg integer)
Begin
update fe_guias set guia_fech=dfecha,guia_ptop=cptop,guia_ptoll=cptoll,guia_fect=dfechat,guia_deta=cdeta,guia_idtr=nidtr,
guia_ndoc=cndoc where guia_idgui=nidg;
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

/* Procedure structure for procedure `ProActualizaIdautoGuiaCons` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaIdautoGuiaCons` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaIdautoGuiaCons`(nidg integer,nidauto integer)
BEGIN
update fe_guias set guia_idau=nidauto where guia_idgui=nidg;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaIdkarGuiasCons` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaIdkarGuiasCons` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaIdkarGuiasCons`(nidk integer,nidk1 integer)
BEGIN
update fe_ent set entr_idkar=nidk1 where entr_iden=nidk;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaKardex1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaKardex1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaKardex1`(nid integer,cc integer,ct char,npr float,
nct float,cincl char,tmvto char,ccodv integer,calma integer,nidcosto1 integer,nidkar integer,op integer,xcom float)
BEGIN
if op=0 then
  Update fe_kar set Acti='I'  where idkar=nidkar;
 else
  Update fe_kar set
  idauto=nid,idart=cc,tipo=ct,prec=npr,cant=nct,ttip=tmvto,incl=cincl,
  alma=calma,kar_idco=nidcosto1,codv=ccodv,kar_comi=xcom where idkar=nidkar;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaKardexdetraccion` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaKardexdetraccion` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaKardexdetraccion`(nid INTEGER,cc INTEGER,nicbper DECIMAL(6,2),npr FLOAT,
nct FLOAT,cincl CHAR,tmvto CHAR,ccodv INTEGER,calma INTEGER,nidcosto1 INTEGER,nidkar INTEGER,op INTEGER,xcom FLOAT,ndetraccion DECIMAL(5,2))
BEGIN
IF op=0 THEN
  UPDATE fe_kar SET Acti='I'  WHERE idkar=nidkar;
 ELSE
  UPDATE fe_kar SET
  idauto=nid,idart=cc,kar_icbper=nicbper,prec=npr,cant=nct,ttip=tmvto,incl=cincl,
  alma=calma,kar_idco=nidcosto1,codv=ccodv,kar_comi=xcom,kar_detr=ndetraccion WHERE idkar=nidkar;
END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaKardexICBPER` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaKardexICBPER` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaKardexICBPER`(nid INTEGER,cc INTEGER,nicbper DECIMAL(6,2),npr FLOAT,
nct FLOAT,cincl CHAR,tmvto CHAR,ccodv INTEGER,calma INTEGER,nidcosto1 INTEGER,nidkar INTEGER,op INTEGER,xcom FLOAT)
BEGIN
IF op=0 THEN
  UPDATE fe_kar SET Acti='I'  WHERE idkar=nidkar;
 ELSE
  UPDATE fe_kar SET
  idauto=nid,idart=cc,kar_icbper=nicbper,prec=npr,cant=nct,ttip=tmvto,incl=cincl,
  alma=calma,kar_idco=nidcosto1,codv=ccodv,kar_comi=xcom WHERE idkar=nidkar;
END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROACTUALIZALINEACREDITO` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROACTUALIZALINEACREDITO` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROACTUALIZALINEACREDITO`(NID INTeger,nmonto float)
BEGIN
update fe_clie set clie_lcre=nmonto where idclie=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaMargenesVta` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaMargenesVta` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaMargenesVta`(nu1 decimal(9,6),nu2 decimal(9,6),nu3 decimal(9,6),nidart integer)
begin
update fe_art set prod_uti1=nu1,prod_uti2=nu2,prod_uti3=nu3 where idart=nidart;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaOCompra` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaOCompra` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaOCompra`(nid integer,opt char,nidart integer,ncant float,nprec float)
BEGIN
if opt='E' then
  update fe_docom set doco_acti='I' where doco_iddo=nid;
 else
  update fe_docom set doco_coda=nidart,doco_cant=ncant,doco_prec=nprec where doco_iddo=nid;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaOrdenCompra` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaOrdenCompra` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaOrdenCompra`(
dfecha date,nidpr integer,cmone char,
cndoc varchar(10),ctigv char,cobse varchar(200),caten varchar(80),cdeta varchar(200),
nidus integer,nid integer,cdespacho varchar(60),cforma varchar(60),nv float,nigv float,nimpo float)
BEGIN
update fe_rocom set ocom_fech=dfecha,ocom_idpr=nidpr,ocom_mone=cmone,ocom_ndoc=cndoc,
ocom_tigv=ctigv,ocom_obse=cobse,ocom_aten=caten,ocom_deta=cdeta,ocom_idac=nidus,ocom_fact=current_date(),
ocom_desp=cdespacho,ocom_form=cforma,ocom_valor=nv,ocom_igv=nigv,ocom_impo=nimpo where ocom_idroc=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaPagosVendedores1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaPagosVendedores1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaPagosVendedores1`(nid integer)
begin
update fe_rpvendedor set rpve_acti='I' where rpve_idrp=nid;
update fe_rvendedor set vend_chek=0 where vend_idrp=nid;
end */$$
DELIMITER ;

/* Procedure structure for procedure `PROActualizaPedidoFacturado` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROActualizaPedidoFacturado` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROActualizaPedidoFacturado`(nautop integer)
begin
UPDATE fe_rped SET facturado="S" WHERE idautop=nautop;
end */$$
DELIMITER ;

/* Procedure structure for procedure `PROActualizaPedidoVtasFacturado` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROActualizaPedidoVtasFacturado` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROActualizaPedidoVtasFacturado`(nautop INTEGER)
BEGIN
UPDATE fe_rcom SET rcom_entr="C" WHERE idauto=nautop;
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

/* Procedure structure for procedure `PROACTUALIZAPRECIOGUIAS` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROACTUALIZAPRECIOGUIAS` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROACTUALIZAPRECIOGUIAS`(nidk integer,nprec decimal(12,6),nid integer,cincl char)
BEGIN
update fe_kar set prec=nprec,idauto=nid,acti='A',incl=cincl where idkar=nidk;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaPreciosProducto` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaPreciosProducto` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaPreciosProducto`(
cc integer,dfe date,npr decimal(12,7),cnd integer,idp integer,cmda char,ni float,ndolar float,nidcosto integer)
BEGIN
declare costor float;
declare vigv float;
select igv into vigv from fe_gene where idgene=1;
SELECT convert('00/00/0000',char) into @ufc FROM fe_art WHERE idart=cc;
IF @ufc<=dfe then
   select prod_uti1,prod_uti2,prod_uti3,idflete into @nutil1,@nutil2,@nutil2,@nidflete
   from fe_art where idart=cc;
   select prec into @ncostof from fe_fletes where idflete=@nidflete;
   set costor=round((npr*vigv)+@ncostof,2);
   UPDATE fe_art SET prec=npr,cost=npr*vigv,prod_idau=cnd,ulpc=idp,tmon=cmda,ulfc=dfe,
   premay=round(costor*@nutil1,2),premen=round(costor*@nutil2,2),pre3=if(@nutil3<>0,round(costor*@nutil3,2),0),
   prod_idco=nidcosto,prod_dola=ndolar WHERE idart=cc;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaPreciosProductoCdscto` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaPreciosProductoCdscto` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaPreciosProductoCdscto`(
cc integer,dfe date,npr decimal(12,7),idp integer,cmda char)
BEGIN
declare costor float;
declare vigv float;
select igv into vigv from fe_gene where idgene=1;
   select prod_uti1,prod_uti2,prod_uti3,idflete into @nutil1,@nutil2,@nutil2,@nidflete
   from fe_art where idart=cc;
   select prec into @ncostof from fe_fletes where idflete=@nidflete;
   set costor=round((npr*vigv)+@ncostof,2);
   UPDATE fe_art SET prec=npr,cost=npr*vigv,ulpc=idp,
   premay=round(costor*@nutil1,2),premen=round(costor*@nutil2,2),pre3=round(costor*@nutil3,2)
   WHERE idart=cc;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaProductos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaProductos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaProductos`(cdesc varchar(100),cunid varchar(20),ncosto decimal(12,7),np1 float,np2 float,
np3 float,npeso float,ccat integer,cmar integer,ctipro char,nflete integer,cm char,nprecio decimal(12,7),
nidgrupo integer,nutil1 float,nutil2 float,nutil3 float,ncome float,
ncomc float,nidus integer,ncoda integer,nsmin float,nsmax float,ccodigo1 varchar(20),ndolar float,ce char)
BEGIN
UPDATE fe_art SET descri=cdesc,unid=cunid,cost=ncosto,premay=np1,premen=np2,pre3=np3,peso=npeso,idcat=ccat,idmar=cmar,tipro=ctipro,idflete=nflete,tmon=cm,
prec=nprecio,prod_uti1=nutil1,prod_uti2=nutil2,prod_uti3=nutil3,
prod_come=ncome,prod_comc=ncomc,prod_uact=nidus,prod_fact=localtime,prod_smax=nsmax,
prod_smin=nsmin,prod_cod1=ccodigo1,prod_dola=ndolar,prod_acti=ce  WHERE idart=ncoda;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaProveedor` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaProveedor` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaProveedor`(nid integer,cruc varchar(11),crazo varchar(100),
cdire varchar(100),cciud varchar(100),cfono varchar(15),cfax varchar(15),
cemail varchar(45),nidus integer,ccelu varchar(15),crefe varchar(2005),crpm varchar(10))
BEGIN
update fe_prov set
nruc=cruc,razo=crazo,dire=cdire,ciud=cciud,fono=cfono,fax=cfax,email=cemail,
prov_actu=nidus,prov_feac=current_date(),celu=ccelu,refe=crefe,prov_rpm=crpm
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

/* Procedure structure for procedure `ProActualizaRCompras` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaRCompras` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaRCompras`(
ctdoc varchar(2),cform char,cndoc varchar(12),dfecha date,dfechar date,cdetalle varchar(120),
nv decimal(12,2),nigv decimal(12,2),nt decimal(12,2),cndo2 varchar(10),cm char,
ndolar float,ni float,ctg char,ccodp integer,cmvto char,nus integer,opt integer,nidcodt integer,
n1 integer,n2 integer,n3 integer,nitems integer,npvta float,nidauto integer,nexon decimal(12,2),notros decimal(12,2))
BEGIN
declare idce integer;
select gene_idce into idce from fe_gene where idgene=1;
   update fe_rcom set tdoc=ctdoc,form=cform,ndoc=cndoc,fech=dfecha,fecr=dfechar,deta=cdetalle,valor=nv,igv=nigv,impo=nt,ndo2=cndo2,
   mone=cm,dolar=ndolar,vigv=ni,tcom=ctg,idprov=ccodp,tipom=cmvto,idusua1=nus,codt=nidcodt,
   rcom_nitem=nitems,rcom_exon=nexon,rcom_otro=notros where idauto=nidauto;
   call ProDesactivaLcajaE(nidauto);
 END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaRCompras1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaRCompras1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaRCompras1`(
ctdoc varchar(2),cform char,cndoc varchar(12),dfecha date,dfechar date,cdetalle varchar(120),
nv decimal(12,2),nigv decimal(12,2),nt decimal(12,2),cndo2 varchar(10),cm char,
ndolar float,ni float,ctg char,ccodp integer,cmvto char,nus integer,opt integer,nidcodt integer,
n1 integer,n2 integer,n3 integer,nitems integer,npvta float,nidauto integer,nexon decimal(12,2),notros decimal(12,2))
BEGIN
   update fe_rcom set tdoc=ctdoc,ndoc=cndoc,fech=dfecha,fecr=dfechar,deta=cdetalle,
   ndo2=cndo2,
   mone=cm,dolar=ndolar,vigv=ni,tcom=ctg,idprov=ccodp,tipom=cmvto,idusua1=nus,
   codt=nidcodt,
   rcom_nitem=nitems,rcom_exon=nexon,rcom_otro=notros where idauto=nidauto;
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

/* Procedure structure for procedure `ProActualizaResumenEntregas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaResumenEntregas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaResumenEntregas`(nid integer)
begin
update fe_pentregas set pent_acti='I' where pent_idpr=nid;
update fe_rpentregas set rpen_acti='I' where rpen_idpr=nid;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaRvendedores` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaRvendedores` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaRvendedores`(nauto integer,nidrc integer,
nidcl integer,cform char,codv integer,nidr integer)
BEGIN
Update fe_rvendedor set vend_idau=nauto,vend_idrc=nidrc,vend_idcl=nidcl,vend_form=cform,vend_codv=codv where vend_idrv=nidr;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaStock` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaStock` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaStock`(in coda integer,in nalma integer,in ccant float,in ctipo char(1),ncaant float)
BEGIN
   if ctipo="C" then
      if nalma=1 then
          UPDATE fe_art SET uno=(uno-ncaant)+ccant WHERE idart=coda;
      end if;
      if nalma=2 then
          UPDATE fe_art SET dos=(dos-ncaant)+ccant WHERE idart=coda;
      end if;
      if nalma=3 then
          UPDATE fe_art SET tre=(tre-ncaant)+ccant WHERE idart=coda;
      end if;
      if nalma=4 then
          UPDATE fe_art SET cua=(cua-ncaant)+ccant WHERE idart=coda;
     end if;
   end if;
   if ctipo="V" then
      if nalma=1 then
          UPDATE fe_art SET uno=(uno+ncaant)-ccant WHERE idart=coda;
      end if;
      if nalma=2 then
          UPDATE fe_art SET dos=(dos+ncaant)-ccant WHERE idart=coda;
      end if;
      if nalma=3 then
          UPDATE fe_art SET tre=(tre+ncaant)-ccant WHERE idart=coda;
      end if;
      if nalma=4 then
          UPDATE fe_art SET cua=(cua+ncaant)-ccant WHERE idart=coda;
     end if;
  end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaStockf` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaStockf` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaStockf`(in coda integer,in nalma integer,in ccant float,in ctipo char(1),ncaant float)
BEGIN
if ctipo="C" then
      if nalma=1 then
          UPDATE fe_art SET prod_ent1=(prod_ent1-ncaant)+ccant WHERE idart=coda;
      end if;
      if nalma=2 then
          UPDATE fe_art SET prod_ent2=(prod_ent2-ncaant)+ccant WHERE idart=coda;
      end if;
end if;
if ctipo="V" then
      if nalma=1 then
          UPDATE fe_art SET prod_ent1=(prod_ent1+ncaant)-ccant WHERE idart=coda;
      end if;
      if nalma=2 then
          UPDATE fe_art SET prod_ent2=(prod_ent2+ncaant)-ccant WHERE idart=coda;
      end if;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaTcproducto` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaTcproducto` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaTcproducto`(ndolar decimal(6,3),nidart integer)
begin
update fe_art set prod_dola=ndolar where idart=nidart;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaTipoCambio` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaTipoCambio` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaTipoCambio`(nmes integer,na integer,ctipo char(1))
BEGIN
DECLARE done INT DEFAULT 0;
declare tcom float default 0;
declare tven float default 0;
declare dfecha date;
declare cursor1 cursor for
select a.fech,a.valor,a.venta from fe_mon as a where month(fech)=nmes and year(fech)=na;
declare cursor2 cursor for
select a.fech,a.venta from fe_mon as a where month(fech)=nmes and year(fech)=na;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
if ctipo='C' or ctipo='V' then
  open cursor1;
  start transaction;
  repeat
      fetch cursor1 into dfecha,tcom,tven;
      if ctipo='C' then
         update fe_rcom set dolar=tven where fech=dfecha;
       else
         update fe_rcom set dolar=tcom where fech=dfecha;
      end if;
  until done end repeat;
  commit;
end if;
if ctipo='D'then
  open cursor2;
  start transaction;
  repeat
      fetch cursor2 into dfecha,tven;
      update fe_deu set dola=tven where fech=dfecha;
  until done end repeat;
  commit;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaTransportista` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaTransportista` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaTransportista`(cplaca VARCHAR(10),crazo VARCHAR(100),
cdire VARCHAR(100),cruc VARCHAR(11),cchofer VARCHAR(100),cbreve VARCHAR(25),cmarca VARCHAR(50),ccons VARCHAR(30),
nid INTEGER,cplaca1 VARCHAR(11),ctipot VARCHAR(2),const1 VARCHAR(30))
BEGIN
UPDATE fe_tra SET ructr=cruc,razon=crazo,nombr=cchofer,marca=cmarca,placa=cplaca,dirtr=cdire,
breve=cbreve,cons=ccons,placa1=cplaca1,tran_tipo=ctipot,tran_cons1=const1 WHERE idtra=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaZona` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaZona` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaZona`(cnom varchar(50),id integer,opt integer,idz integer)
BEGIN
if opt=0 then
   update fe_zona set zona_acti='I' where zona_idzo=id;
  else
   update fe_zona set zona_nomb=cnom,zona_idzz=idz where zona_idzo=id;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaZonap` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaZonap` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaZonap`(cnom varchar(50),id integer,opt integer)
BEGIN
if opt=0 then
   update fe_zonap set zona_acti='I' where zona_idzon=id;
  else
   update fe_zonap set zona_nomb=cnom where zona_idzon=id;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROActualizaZonas` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROActualizaZonas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROActualizaZonas`(nidclie integer,nidzona integer)
BEGIN
update fe_clie set clie_idzo=nidzona where idclie=nidclie;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActulizaSeriesDctos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActulizaSeriesDctos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActulizaSeriesDctos`(cserie integer,cnume integer,ctdoc varchar(2),nitems integer,ntda integer,nidserie integer)
BEGIN
update fe_serie set tdoc=ctdoc,nume=cnume,items=nitems,codt=ntda,seri_idal=ntda where idserie=nidserie;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAcutalizaResumenCreditosVendedoresKardex` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAcutalizaResumenCreditosVendedoresKardex` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAcutalizaResumenCreditosVendedoresKardex`(nidauto integer,nidv integer)
begin
Update fe_kar set codv=nidv where idauto=nidauto;
Update fe_rcred set rcre_codv=nidv where rcre_idau=nidauto;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaCanjesGuiasCons` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaCanjesGuiasCons` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaCanjesGuiasCons`(nidg integer,nidguia integer)
BEGIN
update fe_cguias set cgui_acti='I' where cgui_idgu=nidg;
update fe_guias set guia_esta='E' where guia_idgui=nidguia;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaCanjesNotas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaCanjesNotas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaCanjesNotas`(nid integer,ctipo char)
begin
if ctipo='C' then
   update fe_nccom set ncre_acti='I' where ncre_idnc=nid;
else
   update fe_ncven set ncre_acti='I' where ncre_idnc=nid;
end if;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaDatosLibroDiarioPLe5` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaDatosLibroDiarioPLe5` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaDatosLibroDiarioPLe5`(ctipo varchar(3),dfi date,dff date)
BEGIN
case
   when ctipo='COM' then
        delete from fe_ldiario where ldia_fech between dfi and dff and left(ldia_comp,3)='COM';
   when ctipo='VEN' then
        delete from fe_ldiario where ldia_fech between dfi and dff and left(ldia_comp,3)='VEN';
   when ctipo='CAJ' then
        delete from fe_ldiario where ldia_fech between dfi and dff and left(ldia_comp,3)='CAJ';
   when ctipo='BAN' then
        delete from fe_ldiario where ldia_fech between dfi and dff and left(ldia_comp,3)='BAN';
end case;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaEntregaFisica` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaEntregaFisica` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaEntregaFisica`(na integer,nu integer)
BEGIN
update fe_guias set guia_acti='I',guia_idu1=nu where guia_idgui=na;
update fe_ent set entr_cant=0,entr_acti='I' where entr_idgu=na;
update fe_entregas set entr_acti='I' where entr_idgu=na;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaItemCopia` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaItemCopia` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaItemCopia`(nidped integer)
begin
delete from fe_copia where copi_idpe=nidped;
end */$$
DELIMITER ;

/* Procedure structure for procedure `PROANULALCAJA` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROANULALCAJA` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROANULALCAJA`(idcaja integer)
begin
update fe_cbancos set cban_acti='I' where cban_idco=idcaja;
update fe_cbancos set cban_acti='I' where cban_idco1=idcaja and cban_idco1>0;
end */$$
DELIMITER ;

/* Procedure structure for procedure `PROANULAPAGOSEMPLEADOS` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROANULAPAGOSEMPLEADOS` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROANULAPAGOSEMPLEADOS`(nidp integer)
BEGIN
update fe_pagos set pago_acti='I' where pago_idpa=nidp;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROANULAPAGOSEMPLEADOS1` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROANULAPAGOSEMPLEADOS1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROANULAPAGOSEMPLEADOS1`(nidca integer)
BEGIN
if nidca>0 then
  update fe_pagos set pago_acti='I' where pago_idca=nidca;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaPdtesEntrega` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaPdtesEntrega` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaPdtesEntrega`(nid integer,nu integer)
BEGIN
update fe_ipdtes set pdte_acti='I',pdte_idu1=nu where pdte_idau=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaPedidos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaPedidos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaPedidos`(out estado varchar(500),in nid integer)
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION,SQLWARNING,NOT FOUND
begin
  rollback;
  set estado:="No Se ejecuto Correctamente la Transacción";
end;
set estado:=null;
start transaction;
update fe_rped set acti='I' where idautop=nid;
update fe_ped set acti='I' where idautop=nid;
commit;
set estado:="Ok";
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROANULASIENTODIARIO` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROANULASIENTODIARIO` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROANULASIENTODIARIO`(nid varchar(10))
BEGIN
update fe_ldiario set ldia_acti='I' where ldia_nume=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaTransacciones` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaTransacciones` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaTransacciones`(OUT estado varchar(500),in ctdoc varchar(2),in cndoc varchar(10),
in ctipo char,IN nidauto integer,in nu integer, in sw char,dfecha date,in nu1 integer)
BEGIN
declare nid integer;
declare cconcepto varchar(3);
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
   select @idclave:=idauto from fe_rcom where tdoc=ctdoc and ndoc=cndoc and tipom =ctipo;
   set nid=@idclave;
  else
   set nid=nidauto;
   select @ct:=tdoc,@cn1:=ndoc,@df:=fech from fe_rcom where idauto=nid;
end if;
if nid>0 then
   update fe_rcom set acti='I',idusua1=nu,rcom_idus=nu1 where idauto=nid;
   select @ntraspaso:=tras_idau from fe_traspaso where tras_idau1=nid and tras_acti<>'I' group by tras_idau;
   update fe_traspaso set tras_acti='I' where tras_idau1=nid;
   if @ntraspaso>0 then
      update fe_rcom set acti='I' where idauto=@ntraspaso;
   end if;
   if ctipo='V' then
      update fe_ncven set ncre_acti='I' where ncre_idan=nid;
      update fe_rvendedor set vend_acti='I' where vend_idau=nid;
      select @nguia:=guia_idgui from fe_guias where guia_idau=nid;
      if @nguia>0 then
         CALL ProAnulaEntregaFisica(@nguia);
        
      end if;
    else
       update fe_nccom set ncre_acti='I' where ncre_idau=nid;
       update fe_guiac set guic_tipo='P',guic_idac=0 where guic_idac=nid;
       update fe_guiac set guic_acti='I'  where guic_idau=nid;
   end if;
end if;
if sw='S' and ctipo='V' then
   if @ct='07' or @ct='08' then
       set cconcepto:=concat('01','E');
      else
       set cconcepto:=concat(trim(@ct),'E');
   end if;
   SELECT @nidconcepto:=idcon FROM fe_con WHERE tdoc=cconcepto AND tipo='I' AND conc_acti<>'I' GROUP BY idcon;
   call PROingresa_anulada(@df,@cn1,@ct,nu,@nidconcepto);
end if;
set estado=null;
commit;
set estado:="Ok";
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaTransacciones1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaTransacciones1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaTransacciones1`(OUT estado varchar(500),ctdoc varchar(2),cndoc varchar(12),
ctipo char,nidauto integer,nu integer,sw char,dfecha date,nu1 integer,nimporte integer)
BEGIN
declare nid,nidcajero integer;
declare cconcepto varchar(3);
DECLARE EXIT HANDLER FOR SQLEXCEPTION,SQLWARNING,NOT FOUND
begin
   rollback;
   set estado:="No se ejecuto Correctamente las Transacciones";
end;
start transaction;
set nid=0;
if nidauto=0 then
   set @ct:=ctdoc;
   set @cndoc:=cndoc;
   set @df:=dfecha;
   select @idclave:=idauto,@nimp:=impo,@ncodt=codt from fe_rcom where tdoc=ctdoc and ndoc=cndoc and tipom =ctipo and acti='A';
   set nid=@idclave;
  else
   set nid=nidauto;
   select @ct:=tdoc,@cndoc:=ndoc,@df:=fech,@nimp:=impo,@ncodt:=codt from fe_rcom where idauto=nid;
end if;
if nid>0 then
   update fe_rcom set acti='I',idusua1=nu,rcom_idus=nu1 where idauto=nid;
   if ctipo='V' then
      update fe_ncven set ncre_acti='I' where ncre_idan=nid;
      update fe_rvendedor set vend_acti='I' where vend_idau=nid;
      update fe_ipdtes set pdte_acti='I',pdte_idu1=nu where pdte_idau=nid;
      select @nguia:=guia_idgui from fe_guias where guia_idau=nid;
      if @nguia>0 then
         CALL ProAnulaEntregaFisica(@nguia,nu);
      end if;
      if sw='S' then
         select sucu_idus into nidcajero from fe_sucu where idalma=@ncodt;
         if nidcajero<=0 then
            set nidcajero=nu;
         end if;
         call PROingresa_anulada1(@df,@cndoc,@ct,nidcajero,0,0);
      end if;
    else
       update fe_nccom set ncre_acti='I' where ncre_idan=nid;
       update fe_guiac set guic_tipo='P',guic_idac=0 where guic_idac=nid;
       update fe_guiac set guic_acti='I'  where guic_idau=nid;
   end if;
 else
      
          set nidcajero=nu;
      
      if sw='S' then
          call PROingresa_anulada1(@df,@cndoc,@ct,nidcajero,0,0);
      end if;
end if;
set estado=null;
commit;
set estado:="Ok";
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaVtaCanjeda` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaVtaCanjeda` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaVtaCanjeda`(nid integer,nu integer)
BEGIN
update fe_ncven set ncre_acti='I' where ncre_idan=nid;
update fe_dper set dper_acti='I' where dper_idrp=nid;
update fe_rcom set acti='I',idusua1=nu where idauto=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAplicaTCBancos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAplicaTCBancos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAplicaTCBancos`(nid integer,ntc decimal(6,4))
begin
update fe_cbancos set cban_dola=ntc where cban_idco=nid and cban_dola=0;
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
update fe_rcom set dolar=tc where idauto=nidauto;
end */$$
DELIMITER ;

/* Procedure structure for procedure `PROAplicaTcDeudas` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROAplicaTcDeudas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROAplicaTcDeudas`(nidd integer,tc decimal(8,4))
begin
update fe_deu set dola=tc where iddeu=nidd;
end */$$
DELIMITER ;

/* Procedure structure for procedure `PROAplicaTcVentas` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROAplicaTcVentas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROAplicaTcVentas`(nidrv integer,nidauto integer,tc decimal(8,4))
begin
update fe_rcom set dolar=tc where idauto=nidauto;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProAsignaOpciones` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAsignaOpciones` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAsignaOpciones`(nidmenu integer,nidus integer,dfi date,dff date)
begin
insert into fe_opt(opti_idus,opti_idme,opti_acti,opti_feci,opti_fecf)values(nidus,nidmenu,1,dfi,dff);
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProAstock1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAstock1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAstock1`(in coda integer,in nalma integer,in ccant float,in ctipo char(1))
BEGIN
 if ctipo="C" then
      if nalma=1 then
          UPDATE fe_art SET prod_ent1=prod_ent1+ccant WHERE idart=coda;
      end if;
      if nalma=2 then
          UPDATE fe_art SET prod_ent2=prod_ent2+ccant WHERE idart=coda;
      end if;
   end if;
   if ctipo="V" then
      if nalma=1 then
          UPDATE fe_art SET prod_ent1=prod_ent1-ccant WHERE idart=coda;
      end if;
      if nalma=2 then
          UPDATE fe_art SET prod_ent2=prod_ent2-ccant WHERE idart=coda;
      end if;
  end if;
   if ctipo="I" then
      if nalma=1 then
          UPDATE fe_art SET prod_ent1=ccant WHERE idart=coda;
      end if;
      if nalma=2 then
          UPDATE fe_art SET prod_ent2=ccant WHERE idart=coda;
      end if;
  end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProBloqueaD` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProBloqueaD` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProBloqueaD`(nmes integer,na integer,opt integer)
begin
if opt=0 then
   update fe_meses set mes_compra='C' where mes_idme=nmes;
 else
   update fe_meses set mes_compra='A' where mes_idme=nmes;
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

/* Procedure structure for procedure `ProCalcularSaldos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProCalcularSaldos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProCalcularSaldos`(nid integer)
BEGIN
select z.rcre_cont,z.saldo,z.cvta,z.nomv,ifnull(w.ava_nomb,'')as Aval,z.rcre_idrc,z.rcre_idea from
(select b.rcre_cont,sum(a.cred_impo-a.cred_acta) as saldo,b.rcre_idrc,b.rcre_idea,
b.rcre_cvta as cvta,c.nomv from fe_cred as a inner join fe_rcred as b on(a.cred_idrc=b.rcre_idrc)
inner join fe_vend as c on(c.idven=b.rcre_idve) where b.rcre_idcl=nid
and a.cred_acti<>'I' group by a.cred_idrc) as z left join fe_eaval as y on(y.eava_idea=z.rcre_idea)
left join fe_aval as w on(w.ava_idav=y.eava_idav) where z.saldo>0;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProCalcularSaldosCliente` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProCalcularSaldosCliente` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProCalcularSaldosCliente`(nidclie integer)
BEGIN
if nidclie>0 then
   SELECT IF(acta>0,-acta,impo) as impsoles,000000.00 as impdolares FROM fe_cred  as a
   inner join fe_rcred as b on(b.rcre_idrc=a.cred_idrc) WHERE b.rcre_idcl=nidclie
   and a.acti<>'I' AND a.mone="S" and b.rcre_acti<>"I"  UNION ALL SELECT 0000000.00 as impsoles,IF(acta>0,-acta,impo) as impdolares FROM fe_cred as a
   inner join fe_rcred as b on(b.rcre_idrc=a.cred_idrc) WHERE b.rcre_idcl=nidclie AND a.mone="D" and a.acti<>'I'and b.rcre_Acti<>"I";
 else
   SELECT IF(acta>0,-acta,impo) as impsoles,000000.00 as impdolares FROM fe_cred  as a
   inner join fe_rcred as b on(b.rcre_idrc=a.cred_idrc) WHERE a.acti<>'I' AND a.mone="S" and b.rcre_acti<>"I"
   UNION ALL SELECT 0000000.00 as impsoles,IF(acta>0,-acta,impo) as impdolares FROM fe_cred as a
   inner join fe_rcred as b on(b.rcre_idrc=a.cred_idrc) WHERE a.mone="D" and a.acti<>"I" and b.rcre_acti<>"I";
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProCalcularStock1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProCalcularStock1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProCalcularStock1`()
BEGIN
DECLARE done INT DEFAULT 0;
declare ct varchar(1) default 'I';
declare saldo float;
declare ccoda integer;
declare calma integer;
declare tcompras float;
declare tventas float;
declare cursor1 cursor for
select z.idart,cast(sum(z.tcompras) as decimal(10,2))as tcompras,cast(sum(z.tventas) as decimal(10,2)) as tventas,z.alma from(
select b.idkar,b.idart,b.cant as tcompras,0 as Tventas,b.alma
from fe_kar as b where b.acti<>'I' and tipo='C' union all
select b.idkar,b.idart,0 as tcompras,x.entr_cant as tventas,b.alma
from fe_kar as b  inner join fe_ent as x on x.entr_idkar=b.idkar where x.entr_Acti<>'I' and b.tipo='V' and x.entr_cant<>0 and b.acti<>'I') as z
group by z.idart,z.alma;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
open cursor1;
start transaction;
UPDATE fe_art SET prod_ent1=0,prod_ent2=0;
repeat
    fetch cursor1 into ccoda,tcompras,tventas,calma;
   
until done end repeat;
commit;
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

/* Procedure structure for procedure `PROCambiaCostos` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROCambiaCostos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROCambiaCostos`(idcosto1 integer,idcosto2 integer)
BEGIN
update fe_kar set kar_idco=idcosto2 where kar_idco=idcosto1;
update fe_costos set cost_acti='I' where cost_idco=idcosto1;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProCambiaEstadoGuiaCompra` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProCambiaEstadoGuiaCompra` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProCambiaEstadoGuiaCompra`(nid integer)
begin
update fe_rcom set acti='I' where idauto=nid;
end */$$
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
   update fe_rcred set rcre_idcl=idclie1 where rcre_idcl=idclie0;
   update fe_rcom set idcliente=idclie1 where idcliente=idclie0;
   update fe_rped set idclie=idclie1 where idcliente=idclie0;
   update fe_clie set clie_acti='I' where idclie=idclie0;
   insert into fe_cambios(camb_fech,camb_idan,camb_idac,camb_tipo,camb_idus)
   values(localtime,idclie0,idclie1,"Clientes",nu);
end if;
if trim(ct)="Proveedores" then
   update fe_rdeu set rdeu_idpr=idclie1 where rdeu_idpr=idclie0;
   update fe_rcom set idprov=idclie1 where idprov=idclie0;
   update fe_rocom set ocom_idpr=idclie1 where ocom_idpr=idclie0;
   update fe_prov set prov_acti='I' where idprov=idclie0;
   insert into fe_cambios(camb_fech,camb_idan,camb_idac,camb_tipo,camb_idus)
   values(localtime,idclie0,idclie1,"Proveedores",nu);
end if;
if trim(ct)="Productos" then
   update fe_kar set idart=idclie1 where idart=idclie0;
   update fe_ped set idart=idclie1 where idart=idclie0;
   update fe_docom set doco_coda=idclie1 where doco_coda=idclie0;
   update fe_art set prod_acti='I' where idart=idclie0;
   insert into fe_cambios(camb_fech,camb_idan,camb_idac,camb_tipo,camb_idus)
   values(localtime,idclie0,idclie1,"Productos",nu);
end if;
commit;
set estado:="Ok";
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProCambiosCtas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProCambiosCtas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProCambiosCtas`(out estado varchar(500),nvo integer,nid integer)
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION,SQLWARNING,NOT FOUND
begin
   rollback;
   set estado:="No se ejecuto Correctamente las Transacciones";
end;
   UPDATE fe_ldiario SET ldia_idcta=nvo WHERE ldia_idcta=nid;
   UPDATE fe_lcaja SET lcaj_idct=nvo WHERE lcaj_idct=nid;
   UPDATE fe_cbancos SET cban_idct=nvo WHERE cban_idct=nid;
   UPDATE fe_plan SET plan_acti='I' WHERE idcta=nid;
   update fe_ectasc set idcta=nvo where idcta=nid;
   update fe_ectas set idcta=nvo where idcta=nid;
commit;
set estado:="Ok";
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProCancelaDctosComprasPorCaja` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProCancelaDctosComprasPorCaja` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProCancelaDctosComprasPorCaja`(nidauto integer,opt integer)
BEGIN
if opt=1 then
   update fe_rcom set rcom_ccaj='C' where idauto=nidauto;
 else
   update fe_rcom set rcom_ccaj='P' where idauto=nidauto;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROCANCELADCTOSVENDEDOR` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROCANCELADCTOSVENDEDOR` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROCANCELADCTOSVENDEDOR`(idv integer,opt integer,idr integer)
BEGIN
if opt=1 then
   update fe_rvendedor set vend_chek=1,vend_idrp=idr where vend_idrv=idv;
  else
   update fe_rvendedor set vend_chek=0 where vend_idrv=idv;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PRODcosto` */

/*!50003 DROP PROCEDURE IF EXISTS  `PRODcosto` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PRODcosto`(idc integer)
BEGIN
select cost_mone,cost_prec as costo from fe_costos where cost_idco=idc;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PRODcostos` */

/*!50003 DROP PROCEDURE IF EXISTS  `PRODcostos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PRODcostos`(idc integer)
BEGIN
select cost_mone,cost_prec as costo from fe_costos where cost_idco=idc;
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

/* Procedure structure for procedure `ProDesactivaCajaEfectivoCr` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaCajaEfectivoCr` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaCajaEfectivoCr`(nidcre integer)
begin
 update fe_lcaja set lcaj_Acti='I' where lcaj_idcr=nidcre;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProDesactivaCajaEfectivoDe` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaCajaEfectivoDe` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaCajaEfectivoDe`(nide integer)
begin
 update fe_lcaja set lcaj_Acti='I' where lcaj_idde=nide;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProdesactivaCDeudas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProdesactivaCDeudas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProdesactivaCDeudas`(id integer)
BEGIN
update fe_rdeu set rdeu_acti='I' where rdeu_idrd=id;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProDesactivaClientes` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaClientes` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaClientes`(nid integer)
BEGIN
update fe_clie set clie_acti='I' where idclie=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProDesactivaCreditos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaCreditos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaCreditos`(in nid integer)
BEGIN
update fe_cred set acti='I' where idcred=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProDesactivaDctos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaDctos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaDctos`(id integer)
BEGIN
update fe_tdoc set dcto_acti='I' where idtdoc=id;
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

/* Procedure structure for procedure `ProDesactivaDtraspaso` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaDtraspaso` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaDtraspaso`(nidauto integer)
begin
Update fe_kar set acti='I' where idauto=nidauto;
Update fe_traspaso set tras_acti='I' where tras_idau=nidauto;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProDesactivaEctasCompras` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaEctasCompras` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaEctasCompras`(nid integer)
begin
 update fe_ectasc set ecta_acti='I' where idectas=nid;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProDesactivaEctasVtas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaEctasVtas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaEctasVtas`(nid integer)
begin
 update fe_ectas set acti='I' where idectas=nid;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProDesactivaEmpleados` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaEmpleados` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaEmpleados`(nide integer,opt integer)
begin
if opt=0 then
   update fe_empl set empl_acti='I' where empl_idem=nide;
  else
   update fe_empl set empl_acti='A' where empl_idem=nide;
end if;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProDesactivaFletes` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaFletes` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaFletes`(nid integer)
BEGIN
update fe_fletes set flet_acti='I' where idflete=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProDesactivaGrupos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaGrupos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaGrupos`(nid integer)
BEGIN
update fe_grupo set grup_acti='I' where idgrupo=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProDesactivaLcajaE` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaLcajaE` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaLcajaE`(nidauto integer)
begin
update fe_lcaja  set lcaj_acti='I' where lcaj_idau=nidauto;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProDesactivaLineas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaLineas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaLineas`(nid integer)
BEGIN
update fe_cat set line_acti='I' where idcat=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProDesactivaMarcas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaMarcas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaMarcas`(nid integer)
BEGIN
update fe_mar set marc_acti='I' where idmar=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PRODesactivaPlanCuentas` */

/*!50003 DROP PROCEDURE IF EXISTS  `PRODesactivaPlanCuentas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PRODesactivaPlanCuentas`(nid integer)
begin
update fe_plan set plan_acti='I' where idcta=nid;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProDesactivaProductos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaProductos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaProductos`(in nid integer)
BEGIN
update fe_art set prod_acti='I' where idart=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProDesactivaProveedores` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaProveedores` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaProveedores`(nid integer)
BEGIN
update fe_prov set prov_acti='I' where idprov=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProdesactivaRcreditos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProdesactivaRcreditos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProdesactivaRcreditos`(nid integer)
begin
update fe_rcred set rcre_acti='I' where rcre_idrc=nid;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProDesactivaVendedores` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaVendedores` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaVendedores`(nid integer)
BEGIN
update fe_vend set vend_acti='I' where idven=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProdNAlmacen` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProdNAlmacen` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProdNAlmacen`(nalma integer)
begin
select nomb from fe_sucu where idalma=nalma;
end */$$
DELIMITER ;

/* Procedure structure for procedure `PRODSTOCKS` */

/*!50003 DROP PROCEDURE IF EXISTS  `PRODSTOCKS` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PRODSTOCKS`(nidart integer)
BEGIN
select uno,dos,tre,cua from fe_art where idart=nidart;
END */$$
DELIMITER ;

/* Procedure structure for procedure `Prodstocks1` */

/*!50003 DROP PROCEDURE IF EXISTS  `Prodstocks1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `Prodstocks1`(nidart integer,nalma integer)
begin
select a.idart,a.tcompras-a.tventas as saldo
from (select b.idart,sum(if(b.tipo='C',b.cant,0)) as tcompras,
sum(if(b.tipo='V',b.cant,0)) as tventas,b.alma from fe_kar as b
where b.acti<>'I'  and idart=nidart and alma=nalma group by  idart,alma) as a;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProEditaAlmacen` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProEditaAlmacen` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProEditaAlmacen`(cnomb varchar(50),cdire varchar(150),cciud varchar(150),nser integer,nidus integer,nid integer)
begin
update fe_sucu set nomb=cnomb,dire=cdire,ciud=cciud,sucuidserie=nser,sucu_idus=nidus where idalma=nid;
end */$$
DELIMITER ;

/* Procedure structure for procedure `Proeditaclipro` */

/*!50003 DROP PROCEDURE IF EXISTS  `Proeditaclipro` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `Proeditaclipro`(in crazo varchar(60),in cdire varchar(60),in cciud varchar(60),
in cfono varchar(10),in cfax varchar(10),in nid integer,in opt integer,in cdni varchar(8))
BEGIN
if opt=0 then
   UPDATE fe_prov SET dire=cdire,ciud=cciud,fono=cfono,fax=cfax WHERE idprov=nid;
  else
   UPDATE fe_clie SET dire=cdire,ciud=cciud,fono=cfono,fax=cfax,ndni=cdni WHERE idclie=nid;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `Proeditaconceptoscaja` */

/*!50003 DROP PROCEDURE IF EXISTS  `Proeditaconceptoscaja` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `Proeditaconceptoscaja`(cdescri varchar(50),ctdoc varchar(3),norden integer,nid1 integer,nidcon integer)
begin
UPDATE fe_con SET nomb=cdescri,tdoc=ctdoc,orden=norden,conc_iddc=nid1 WHERE idcon=nidcon;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProGeneraCorrelativo` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProGeneraCorrelativo` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProGeneraCorrelativo`(nn integer,ns integer)
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

/* Procedure structure for procedure `ProIngresaAcreditos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaAcreditos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaAcreditos`(in cu varchar(50),in cndoc varchar(10),
in cd varchar(80),in nimpo float,in nacta float,in nidclie integer)
BEGIN
insert into fe_acreditos(fech,hora,usuario,ndoc,detalle,impo,acta,idclie)
values(curdate(),localtime(),cu,cndoc,cd,nimpo,nacta,nidlie);
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

/* Procedure structure for procedure `ProIngresaCanjePedidosF` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaCanjePedidosF` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaCanjePedidosF`(nidauto integer,nidautop integer)
begin
insert into fe_canjesp(canp_idap,canp_idau)values(nidautop,nidauto);
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaCanjesC` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaCanjesC` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaCanjesC`(nidc integer,niddc integer,nidcc1 integer,nidrc integer)
begin
if nidc=0 then
   insert into fe_ccanjes(canj_idca,canj_idan,canj_idac,canj_idrc)values(nidc,niddc,nidcc1,nidrc);
  else
   insert into fe_ccanjes(canj_idca,canj_idac)values(nidc,niddc);
end if;
end */$$
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

/* Procedure structure for procedure `ProIngresaCanjesGuiasCons` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaCanjesGuiasCons` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaCanjesGuiasCons`(nidg1 integer,nidg2 integer,nidcliente integer,dfecha date,nidus integer)
BEGIN
insert into fe_cguias(cgui_idau,cgui_idga,cgui_idcl,cgui_fech,cgui_idus)values(nidg1,nidg2,nidcliente,dfecha,nidus);
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaCargos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaCargos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaCargos`(dfecha date,cndoc varchar(10),nimpo decimal(12,2),cdeta varchar(100))
begin
  insert into fe_cargos(carg_fech,carg_ndoc,carg_impo,carg_deta)values(dfecha,cndoc,nimpo,cdeta);
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaCopia` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaCopia` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaCopia`(nidart integer,cdes varchar(100),cuni varchar(4),ncant decimal(12,2),
nprec decimal(12,4),cestado char,nidcl integer,ccliente varchar(100),opt integer,nidalma integer,nidped integer)
begin
if opt=0 then
   delete from sysvenl1.fe_copia where copi_idpe=nidped;
   insert into sysvenl1.fe_copia(copi_idar,copi_desc,copi_unid,copi_cant,copi_prec,copi_esta,copi_idcl,copi_razo,copi_fech,copi_codt,copi_idpe)
   values(nidart,cdes,cuni,ncant,nprec,cestado,nidcl,ccliente,curdate(),nidalma,nidped);
 else
   delete from sysvenl.fe_copia where copi_idpe=nidped;
   insert into sysvenl.fe_copia(copi_idar,copi_desc,copi_unid,copi_cant,copi_prec,copi_esta,copi_idcl,copi_razo,copi_fech,copi_codt,copi_idpe)
   values(nidart,cdes,cuni,ncant,nprec,cestado,nidcl,ccliente,curdate(),nidalma,nidped);
 end if;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDatosLcajaE1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDatosLcajaE1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDatosLcajaE1`(dfecha date,cndoc varchar(10),cdeta varchar(100),idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),cmone char,ndolar decimal(5,3),nidus integer,nidcp integer,nidauto integer)
begin
insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,
lcaj_idus,lcaj_clpr,lcaj_idau,lcaj_fope)values
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,nidauto,localtime);
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDatosLcajaEefectivo` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDatosLcajaEefectivo` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDatosLcajaEefectivo`(dfecha date,cndoc varchar(12),cdeta varchar(120),
idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),cmone char,ndolar decimal(5,3),nidus integer,nidcp integer,nidauto integer,
cform char,cdcto char(15),ctdoc varchar(2))
begin
insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,
lcaj_idus,lcaj_clpr,lcaj_idau,lcaj_form,lcaj_fope,lcaj_dcto,lcaj_tdoc,lcaj_codt)values
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,nidauto,cform,localtime,cdcto,ctdoc,1);
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDatosLcajaEefectivo11` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDatosLcajaEefectivo11` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDatosLcajaEefectivo11`(dfecha date,cndoc varchar(10),cdeta varchar(100),idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),cmone char,ndolar decimal(5,3),nidus integer,nidcp integer,nidauto integer,cform char,
cdcto varchar(12),ctdoc varchar(2),nidtda integer)
begin
insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,
lcaj_idus,lcaj_clpr,lcaj_idau,lcaj_form,lcaj_dcto,lcaj_tdoc,lcaj_codt,lcaj_fope)values
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,nidauto,cform,cdcto,ctdoc,nidtda,localtime);
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDatosLcajaEefectivoTransferencia` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDatosLcajaEefectivoTransferencia` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDatosLcajaEefectivoTransferencia`(dfecha DATE,cndoc VARCHAR(12),cdeta VARCHAR(120),
idcta INTEGER,sdeudor DECIMAL(12,2),
sacreedor DECIMAL(12,2),cmone CHAR,ndolar DECIMAL(5,3),nidus INTEGER,nidcp INTEGER,nidauto INTEGER,
cform CHAR,cdcto CHAR(15),ctdoc VARCHAR(2))
BEGIN
INSERT INTO fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,
lcaj_idus,lcaj_clpr,lcaj_idau,lcaj_form,lcaj_fope,lcaj_dcto,lcaj_tdoc,lcaj_tran)VALUES
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,nidauto,cform,LOCALTIME,cdcto,ctdoc,'T');
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDatosLcajaEfectivo11` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDatosLcajaEfectivo11` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDatosLcajaEfectivo11`(dfecha date,cndoc varchar(12),cdeta varchar(100),idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),cmone char,ndolar decimal(5,3),nidus integer,nidcp integer,nidauto integer,cform char,
cdcto varchar(12),ctdoc varchar(2),nidtda integer)
begin
insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,
lcaj_idus,lcaj_clpr,lcaj_idau,lcaj_form,lcaj_dcto,lcaj_tdoc,lcaj_codt,lcaj_fope)values
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,nidauto,cform,cdcto,ctdoc,nidtda,localtime);
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDetalleGuiaRCompras` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDetalleGuiaRCompras` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDetalleGuiaRCompras`(nidart INTEGER,ncant DECIMAL(12,2),nidg INTEGER,ccodigo varchar(30))
BEGIN
INSERT INTO fe_ent(entr_idar,entr_cant,entr_idgu,entr_codi)VALUES(nidart,ncant,nidg,ccodigo);
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDetalleOCompra` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDetalleOCompra` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDetalleOCompra`(nid integer,nidart integer,ncant float,nprec float)
BEGIN
insert into fe_docom(doco_idro,doco_coda,doco_cant,doco_prec)
values(nid,nidart,ncant,nprec);
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDetalleVta` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDetalleVta` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDetalleVta`(cdesc varchar(80),nitem integer,nitem1 integer,nitem2 integer,nidauto integer,
nprecio decimal(12,2),ncant decimal(10,2),cunid varchar(10))
begin
   insert into fe_detallevta(detv_desc,detv_item,detv_ite1,detv_ite2,detv_idau,detv_prec,detv_cant,detv_unid)
   values(cdesc,nitem,nitem1,nitem2,nidauto,nprecio,ncant,cunid);
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaEntregaFisica` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaEntregaFisica` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaEntregaFisica`(nidk integer,nalma integer,ncant decimal(12,2),nidg integer)
BEGIN
if nalma=1 then
   update fe_kar set kar_alma1=1 where idkar=nidk;
 else
   update fe_kar set kar_alma1=2 where idkar=nidk;
end if;
if nidk>0 then
   insert into fe_ent(entr_idkar,entr_cant,entr_idgu)values(nidk,ncant,nidg);
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaEntregas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaEntregas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaEntregas`(ncant decimal(12,2),nidin integer,nidguia integer)
BEGIN
insert into fe_entregas(entr_cant,entr_idin,entr_idgu)values(ncant,nidin,nidguia);
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaGuiasCompras` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaGuiasCompras` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaGuiasCompras`(idp integer,nid integer,cndoc varchar(10),dfecha date,nidus integer)
begin
insert into fe_rgcompra(rgco_codp,rgco_fech,rgco_idus,rgco_idau,rgco_ndoc,rgco_fope)values(idp,dfecha,nidus,nid,cndoc,localtime());
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaPdtesEntrega` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaPdtesEntrega` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaPdtesEntrega`(nidart integer,ncant float,nidauto integer,nidus integer,cidpc varchar(45))
BEGIN
insert into fe_ipdtes(pdte_idar,pdte_cant,pdte_idau,pdte_idus,pdte_fope,pdte_idpc)values(nidart,ncant,nidauto,nidus,localtime,cidpc);
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

/* Procedure structure for procedure `ProIngresaResumenBoletasconbaja` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaResumenBoletasconbaja` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaResumenBoletasconbaja`(dfecha DATE,ctdoc VARCHAR(2),cserie VARCHAR(4),
cdesde VARCHAR(12),chasta VARCHAR(12),nimpo DECIMAL(12,2),nvalor DECIMAL(12,2),nexon DECIMAL(12,2),ninafecta DECIMAL(12,2),
nigv DECIMAL(12,2),ngrati DECIMAL(12,2),cxml LONGBLOB,chash VARCHAR(30),carchivo VARCHAR(70),cticket VARCHAR(25))
BEGIN
INSERT INTO fe_resboletas(resu_fech,resu_tdoc,resu_serie,resu_desd,resu_hast,resu_impo,resu_valo,resu_exon,resu_inaf,
resu_igv,resu_grat,resu_xml,resu_hash,resu_arch,resu_tick,resu_esta)
VALUES (dfecha,ctdoc,cserie,cdesde,chasta,nimpo,nvalor,nexon,ninafecta,nigv,ngrati,cxml,chash,carchivo,cticket,'3');
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaRvendedores` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaRvendedores` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaRvendedores`(nauto integer,nidrc integer,
nidcl integer,cform char,codv integer)
BEGIN
update fe_rvendedor set vend_acti='I' where vend_idau=nauto;
insert into fe_rvendedor(vend_idau,vend_idrc,vend_idcl,vend_form,vend_codv)values
(nauto,nidrc,nidcl,cform,codv);
END */$$
DELIMITER ;

/* Procedure structure for procedure `Proingresa_anulada` */

/*!50003 DROP PROCEDURE IF EXISTS  `Proingresa_anulada` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `Proingresa_anulada`(dfecha Date,cndoc varchar(12),ctdoc varchar(2),nidus integer,nidcon integer)
begin
 select @nc:=idclie from fe_clie where nruc='***********';
 insert into fe_rcom(idcliente,fech,fecr,ndoc,tdoc,tipom,deta,ndo2,tcom,form,mone,exon,fusua,idusua)
 values(@nc,dfecha,dfecha,cndoc,ctdoc,'V','','','K','E','S',0,localtime,nidus);
 SELECT @na:=LAST_INSERT_ID() FROM fe_rcom group by LAST_INSERT_ID();
 Call ProIngresaDatosLcajaEefectivo(dfecha,"","*** ANULADA ***",0,0,0,'S',0,nidus,0,@na,'E',cndoc,ctdoc);
END */$$
DELIMITER ;

/* Procedure structure for procedure `Proingresa_anulada1` */

/*!50003 DROP PROCEDURE IF EXISTS  `Proingresa_anulada1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `Proingresa_anulada1`(dfecha Date,cndoc varchar(12),
ctdoc varchar(2),nidus integer,nidcon integer,nimporte decimal(12,2))
begin
  declare nidt integer default 0;
  if substr(cndoc,4,1)='1' then
     set nidt=1;
    else
    set nidt=2;
end if;
 select @nc:=idclie from fe_clie where nruc='***********' and clie_Acti='A';
 insert into fe_rcom(idcliente,fech,fecr,ndoc,tdoc,tipom,deta,ndo2,tcom,form,mone,exon,fusua,idusua,impo,codt)
 values(@nc,dfecha,dfecha,cndoc,ctdoc,'V','','','K','E','S','N',localtime,nidus,0,nidt);
 SELECT @na:=LAST_INSERT_ID() FROM fe_rcom group by LAST_INSERT_ID();
Call ProIngresaDatosLcajaEefectivo(dfecha,"","*** ANULADA ***",0,0,0,'S',0,nidus,0,@na,'E',cndoc,ctdoc);
END */$$
DELIMITER ;

/* Procedure structure for procedure `Proingresa_Anulada2` */

/*!50003 DROP PROCEDURE IF EXISTS  `Proingresa_Anulada2` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `Proingresa_Anulada2`(out estado varchar(200),
in cauto varchar(20),in dfecha Date,in cndoc varchar(12),in ntdoc integer,in nu integer,in nidrven integer,nidtda integer)
BEGIN
 declare nid1 integer default 0;
 declare nidtda integer default 0;
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

/* Procedure structure for procedure `ProInsertaConceptos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProInsertaConceptos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProInsertaConceptos`()
BEGIN
DECLARE done INT DEFAULT 0;
declare m1 varchar(45);
declare m2 varchar(20);
declare m3 varchar(5);
declare m4 char;
declare cursor1 cursor for
select dcon_deta, dcon_tipo, dcon_clav from sysvenn.fe_dconceptos;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
open cursor1;
repeat
    fetch cursor1 into m1,m2,m3;
    insert into sysvenn1.fe_dconceptos(dcon_deta, dcon_tipo, dcon_clav)values(m1,m2,m3);
until done end repeat;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProInsertaMenus` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProInsertaMenus` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProInsertaMenus`()
BEGIN
DECLARE done INT DEFAULT 0;
declare m1 varchar(45);
declare m2 varchar(20);
declare m3 varchar(5);
declare m4 char;
declare cursor1 cursor for
select menu_text, menu_clav, menu_enla, menu_tipo from sysvenn.fe_menus;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
open cursor1;
repeat
    fetch cursor1 into m1,m2,m3,m4;
    insert into sysvenn1.fe_menus(menu_text, menu_clav, menu_enla, menu_tipo)values(m1,m2,m3,m4);
until done end repeat;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProlimpiaCopias` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProlimpiaCopias` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProlimpiaCopias`(nidt integer)
begin
delete from fe_copia where copi_codt=nidt;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProMostrarMenu1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMostrarMenu1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMostrarMenu1`(nid varchar(5),ct char,nidus integer,df date)
BEGIN
SELECT a.Menu_idme as iKey,a.Menu_text as Texto,a.menu_enla as Parent,a.menu_clav as clave from fe_menus a
inner join fe_opt b on b.opti_idme=a.menu_idme
where menu_tipo=ct and b.opti_idus=nidus and b.opti_acti=1 and df between b.opti_feci and b.opti_fecf
union all
SELECT Menu_idme as iKey,Menu_text as Texto,menu_enla as Parent,menu_clav as clave from fe_menus
 where menu_tipo=ct and  menu_enla='0_' ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraAlmacenes` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraAlmacenes` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraAlmacenes`()
BEGIN
SELECT * FROM fe_sucu  where idalma in(1,2) order by idalma;
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

/* Procedure structure for procedure `PROMuestraClientes` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROMuestraClientes` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROMuestraClientes`(in cbusca varchar(80),in opt integer,in nid integer)
BEGIN
declare cbuscar varchar(80);
set cbuscar=concat('%',trim(cbusca),+'%');
if opt=0 then
   select idclie,nruc,razo,ndni,dire,ciud,ifnull(fono,'0') as fono,ifnull(fax,'0') as fax,
   ifnull(celu,'0') as celu,refe,clie_tipo,clie_codv,clie_lcre,clie_corr,clie_rpm,clie_idus,clie_actu,fechclie,clie_feac,ifnull(c.zona_nomb,'') as Zona,ifnull(a.clie_idzo,0) as clie_idzo
   from fe_clie as a left join fe_zona as c on c.zona_idzo=a.clie_idzo where  clie_acti<>'I' and razo like cbuscar order by razo;
end if;
if opt=1 then
   select idclie,nruc,razo,ndni,dire,ciud,ifnull(fono,'0') as fono,ifnull(fax,'0') as fax,
   ifnull(celu,'0') as celu,refe,clie_tipo,clie_codv,clie_lcre,clie_corr,clie_rpm,clie_idus,clie_actu,fechclie,clie_feac,ifnull(c.zona_nomb,'') as Zona,ifnull(a.clie_idzo,0) as clie_idzo
   from fe_clie as a left join fe_zona as c on c.zona_idzo=a.clie_idzo where  clie_acti<>'I' and nruc like cbuscar order by razo;
end if;
if opt=2 then
   select idclie,nruc,razo,ndni,dire,ciud,ifnull(fono,'0') as fono,ifnull(fax,'0') as fax,
   ifnull(celu,'0') as celu,refe,clie_tipo,clie_codv,clie_lcre,clie_corr,clie_rpm,clie_idus,clie_actu,fechclie,clie_feac,ifnull(c.zona_nomb,'') as Zona,ifnull(a.clie_idzo,0) as clie_idzo
   from fe_clie as a left join fe_zona as c on c.zona_idzo=a.clie_idzo where  clie_acti<>'I' and  ndni like cbuscar order by razo;
end if;
if opt=3 then
   select idclie,nruc,razo,ndni,dire,ciud,ifnull(fono,'0') as fono,ifnull(fax,'0') as fax,
   ifnull(celu,'0') as celu,refe,clie_tipo,clie_codv,clie_lcre,clie_corr,clie_rpm,clie_idus,clie_actu,fechclie,clie_feac,ifnull(c.zona_nomb,'') as Zona,ifnull(a.clie_idzo,0) as clie_idzo
   from fe_clie as a left join fe_zona as c on c.zona_idzo=a.clie_idzo where  clie_acti<>'I' and idclie =nid order by razo;
end if;
if opt=4 then
   select idclie,nruc,razo,ndni,dire,ciud,ifnull(fono,'0') as fono,ifnull(fax,'0') as fax,
   ifnull(celu,'0') as celu,refe,clie_tipo,clie_codv,clie_lcre,clie_corr,clie_rpm,clie_idus,clie_actu,fechclie,clie_feac,ifnull(c.zona_nomb,'') as Zona,ifnull(a.clie_idzo,0) as clie_idzo
   from fe_clie as a left join fe_zona as c on c.zona_idzo=a.clie_idzo where  clie_acti<>'I' and ciud like cbuscar order by razo;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraConceptos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraConceptos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraConceptos`(ctipo varchar(50))
BEGIN
declare cb varchar(50);
set cb=concat('%',trim(ctipo),'%');
SELECT idcon,nomb,tipo,tdoc,conc_iddc,orden FROM fe_con WHERE nomb like cb and conc_acti<>'I';
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraCostos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraCostos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraCostos`(ncoda integer)
BEGIN
SELECT cost_idco,cost_cost,cost_idau,cost_idart,cost_flet,cost_prec,cost_mone,cost_dola FROM fe_costos
where cost_idart=ncoda and cost_acti<>'I' ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraCtasBancos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraCtasBancos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraCtasBancos`()
BEGIN
select a.ctas_ctas,b.banc_nomb,a.ctas_mone,a.ctas_deta,a.ctas_idct,a.ctas_idba,a.ctas_ncta,ctas_seri,ctas_codt from fe_ctasb as a
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
   select ncta,nomb,idcta,cdestinod,cdestinoh,tipocta,plan_oper from fe_plan where plan_acti='A' order by ncta;
  else
   select ncta,nomb,idcta,cdestinod,cdestinoh,tipocta,plan_oper from fe_plan where nomb like cb1  and plan_acti='A' order by ncta;
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
   select ncta,nomb,idcta,cdestinod,cdestinoh,tipocta,ctasunat,ifnull(ctas_desc,'') as ctas_desc,plan_oper from fe_plan p
   left join fe_ctasbalance c on c.ctas_ncta=p.ctasunat where plan_acti='A'  and ncta like cb1 order by ncta;
  else
   select ncta,nomb,idcta,cdestinod,cdestinoh,tipocta,ctasunat,ifnull(ctas_desc,'') as ctas_desc,plan_oper from fe_plan p
   left join fe_ctasbalance c on c.ctas_ncta=p.ctasunat where nomb like cb1  and plan_acti='A' order by ncta;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraDconceptos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraDconceptos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraDconceptos`()
BEGIN
select dcon_idcon,dcon_deta,dcon_tipo,dcon_clav from fe_dconceptos;
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

/*!50003 CREATE PROCEDURE `PROMUESTRADIARIO`(cndoc varchar(10))
BEGIN
select b.ncta,b.nomb,a.ldia_glosa as glosa,ldia_debe as debe,ldia_haber as haber,ldia_tipo as tipo,a.ldia_idcta as idcta,
a.ldia_idld as nreg,ldia_fech as fecha,ldia_cond as cond,a.ldia_comp as Comp,ifnull(p.razo,'') as Cliente,ifnull(q.razo,'') as Proveedor,
ifnull(a.ldia_idcv,0) as idcliente,ifnull(a.ldia_idcc,0) as idproveedor  from fe_ldiario as a inner join fe_plan as b on b.idcta=a.ldia_idcta
left join fe_ctasctesv as m on m.ctcv_idct=a.ldia_idcv left join fe_clie as p on p.idclie=m.ctcv_idcl left join fe_ctasctesc as n on n.ctcc_idct=a.ldia_idcc
left join fe_prov as q on q.idprov=n.ctcc_idpr where ldia_nume=cndoc and ldia_acti<>'I';
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraEmpleados` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraEmpleados` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraEmpleados`(cb varchar(50))
BEGIN
declare cbusca varchar(80);
set cbusca=concat('%',trim(cb),+'%');
SELECT empl_idem,empl_nomb,empl_fono,empl_suel,empl_idus,empl_refe,empl_idpc
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
SELECT a.idflete,desflete,prec,ifnull(count(b.idart),0) as TotalProductos
FROM fe_fletes as a left join (select b.idart,b.idflete from fe_art  as b where prod_acti='A') as b on b.idflete=a.idflete
WHERE desflete LIKE cbusca and flet_acti<>'I'  group by a.idflete ORDER BY desflete;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraGrupos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraGrupos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraGrupos`(abuscar varchar(50))
BEGIN
declare cbuscar varchar(80);
set cbuscar=concat('%',trim(abuscar),+'%');
SELECT a.idgrupo,a.desgrupo,ifnull(count(b.idgrupo),0) as Total_Categorias FROM
fe_grupo as a left join fe_cat as b on b.idgrupo=a.idgrupo
WHERE desgrupo LIKE cbuscar  and grup_acti<>'I' group by a.idgrupo ORDER BY desgrupo;
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
a.cban_ndoc,c.ncta,c.nomb,a.cban_debe,a.cban_haber,a.cban_idct,a.cban_idmp,a.cban_idco,a.cban_idcl,
a.cban_idpr,cban_clpr,a.cban_idca,cban_dola,cban_idco1,cban_orde from fe_cbancos as a 
inner join fe_mpago as b on b.pago_idpa=a.cban_idmp 
left join fe_clie as m on m.idclie=a.cban_idcl 
left join fe_prov as n on n.idprov=a.cban_idpr
inner join fe_plan as c on c.idcta=a.cban_idct 
where a.cban_acti='A' AND trim(a.cban_ndoc)=trim(cndoc);
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

/*!50003 CREATE PROCEDURE `ProMuestraLineas`( abuscar varchar(50),nidgrupo integer)
BEGIN
declare cbusca varchar(20);
set cbusca=concat('%',trim(abuscar),+'%');
if nidgrupo=0 then
   SELECT a.idcat,a.dcat,a.util1,a.util2,ifnull(count(b.idart),0) as Total_Productos,a.idgrupo
   FROM fe_cat as a left join (select b.idart,b.idcat from fe_art as b where prod_acti='A') as b on b.idcat=a.idcat
   WHERE dcat LIKE cbusca and line_acti<>'I'  group by a.idcat ORDER BY dcat;
  else
   SELECT a.idcat,a.dcat,a.util1,a.util2,ifnull(count(b.idart),0) as Total_Productos,a.idgrupo
   FROM fe_cat as a left join (select b.idart,b.idcat from fe_art as b where prod_acti='A') as b on b.idcat=a.idcat
   WHERE dcat LIKE cbusca and line_acti<>'I' and idgrupo=nidgrupo  group by a.idcat ORDER BY dcat;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraMarcas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraMarcas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraMarcas`(in abuscar varchar(20))
BEGIN
declare cbusca varchar(20);
set cbusca=concat('%',trim(abuscar),+'%');
SELECT a.idmar,a.dmar,ifnull(count(b.idart),0) as TotalProductos FROM
fe_mar as a left join (select b.idart,b.idmar from fe_art  as b where prod_acti='A') as b on b.idmar=a.idmar
WHERE dmar LIKE cbusca and marc_acti<>'I' group by a.idmar ORDER BY dmar;
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
SELECT idart,descri,unid,uno,dos,tre,cua,
ifnull(round(if(tmon='S',premay,((a.prec*1.19*nd)+b.prec)*prod_uti1),2),0) as pre1,
ifnull(round(if(tmon='S',premen,((a.prec*1.19*nd)+b.prec)*prod_uti2),2),0) as pre2,
ifnull(round(if(tmon='S',pre3,((a.prec*1.19*nd)+b.prec)*prod_uti3),2),0) as pre3,
round(if(tmon='S',(a.prec*1.19)+b.prec,(a.prec*1.19*nd)+b.prec),2) as costo,c.idgrupo,c.dcat,
round(if(tmon='S',(a.prec*1.19),(a.prec*1.19*nd)),2) as costosf,b.prec as flete,
ifnull(d.cost_cost,0) as costor,ifnull(d.cost_prec,0) as precr,ifnull(d.cost_mone,'')  as moner,
cast(ifnull(d.cost_idco,0) as unsigned) as cost_idco,ifnull(d.cost_flet,0)  as fleter,ifnull(d.cost_dola,0) as dolar,
peso,a.prec,tipro,idmar,a.idcat,cost,tmon,a.idflete,prod_uti1,prod_uti2,prod_uti3,prod_idus,
prod_come,prod_comc,ulpc,prod_idus,prod_uact,prod_fact,fechc,prod_smax,prod_smin
FROM fe_art  as a inner join fe_fletes as b on(b.idflete=a.idflete)
inner join fe_cat as c on(c.idcat=a.idcat) left join fe_costos as d on(d.cost_idco=a.prod_idco)
WHERE idart=ncoda and prod_acti<>'I' ORDER BY DESCRI;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraPlanCuentas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraPlanCuentas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraPlanCuentas`(cb varchar(50),na integer)
BEGIN
declare cb1 varchar(50);
set cb1=concat('%',trim(cb),'%');
SELECT ncta,idcta,nomb,cdestinod,cdestinoh,tipocta,plan_oper FROM fe_plan where ncta like cb1 and plan_acti='A'  ORDER BY ncta;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraProductos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraProductos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraProductos`(in abuscar varchar(80),in nd float)
BEGIN
declare cbuscar varchar(80);
declare vigv decimal(6,4);
select igv into vigv from fe_gene where idgene=1;
set cbuscar=concat('%',trim(abuscar),+'%');
SELECT idart,descri,unid,uno,dos,tre,cua,cero,
ifnull(round(if(tmon='S',((a.prec*vigv)+b.prec)*prod_uti1,((a.prec*vigv*nd)+b.prec)*prod_uti1),2),0) as pre1,
ifnull(round(if(tmon='S',((a.prec*vigv)+b.prec)*prod_uti2,((a.prec*vigv*nd)+b.prec)*prod_uti2),2),0) as pre2,
ifnull(round(if(tmon='S',((a.prec*vigv)+b.prec)*prod_uti3,((a.prec*vigv*nd)+b.prec)*prod_uti3),2),0) as pre3,
round(if(tmon='S',(a.prec*vigv)+b.prec,(a.prec*vigv*nd)+b.prec),2) as costo,c.idgrupo,c.dcat,prod_dola,
round(if(tmon='S',(a.prec*vigv),(a.prec*vigv*nd)),2) as costosf,b.prec as flete,
ifnull(d.cost_cost,0) as costor,ifnull(d.cost_prec,0) as precr,ifnull(d.cost_mone,'')  as moner,
cast(ifnull(d.cost_idco,0) as unsigned) as cost_idco,ifnull(d.cost_flet,0)  as fleter,ifnull(d.cost_dola,0) as dolar,
peso,a.prec,tipro,idmar,a.idcat,cost,tmon,a.idflete,prod_uti1,prod_uti2,prod_uti3,prod_idus,
prod_come,prod_comc,ulpc,prod_idus,prod_uact,prod_fact,fechc,prod_smax,prod_smin,ifnull(o.razo,'') as proveedor,
ifnull(y.ndoc,'') as ndoc,ifnull(y.fech,'') as fech,ulfc
FROM fe_art  as a inner join fe_fletes as b on(b.idflete=a.idflete)
inner join fe_cat as c on(c.idcat=a.idcat) left join fe_costos as d on(d.cost_idco=a.prod_idco)
left join fe_rcom as y on (y.idauto=a.prod_idau) left join fe_prov as o on (o.idprov=y.idprov)
WHERE descri LIKE cbuscar and prod_acti<>'I' ORDER BY DESCRI;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraProductos1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraProductos1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraProductos1`(abuscar varchar(80),nd float,opt integer,nid integer)
BEGIN
declare cbuscar varchar(80);
if opt=1 then
    set cbuscar=concat('%',trim(abuscar),+'%');
    SELECT idart,descri,unid,uno,dos,tre,cua,cero,
    round(prod_uti1*round(if(tmon='S',(a.prec*v.igv)+b.prec,(a.prec*v.igv*if(prod_dola>nd,prod_dola,nd))+b.prec),2),0.5) as pre1,
    round(prod_uti2*round(if(tmon='S',(a.prec*v.igv)+b.prec,(a.prec*v.igv*if(prod_dola>nd,prod_dola,nd))+b.prec),2),0.5) as pre2,
    round(prod_uti3*round(if(tmon='S',(a.prec*v.igv)+b.prec,(a.prec*v.igv*if(prod_dola>nd,prod_dola,nd))+b.prec),2),0.5) as pre3,
    round(if(tmon='S',(a.prec*v.igv)+b.prec,(a.prec*v.igv*if(prod_dola>nd,prod_dola,nd))+b.prec),2) as costo,c.idgrupo,c.dcat,prod_dola,
    round(if(tmon='S',(a.prec*v.igv),(a.prec*v.igv*nd)),2) as costosf,b.prec as flete,m.dmar,
    mid(descri,1,length(trim(descri))-length(trim(m.dmar))) as descri1,prod_cod1,
    ifnull(d.cost_cost,0) as costor,ifnull(d.cost_prec,0) as precr,ifnull(d.cost_mone,'')  as moner,
    cast(ifnull(d.cost_idco,0) as unsigned) as cost_idco,ifnull(d.cost_flet,0)  as fleter,ifnull(d.cost_dola,0) as dolar,
    peso,a.prec,tipro,a.idmar,a.idcat,cost,tmon,a.idflete,prod_uti1,prod_uti2,prod_uti3,
    prod_come,prod_comc,ulpc,prod_idus,prod_uact,prod_fact,fechc,prod_smax,prod_smin,ifnull(o.razo,'') as proveedor,
    ifnull(yy.ndoc,'') as ndoc,ifnull(yy.fech,'') as fech,ulfc,prod_ent1,prod_ent2,prod_icbper,
     g.desgrupo AS grupo,b.desflete,u.nomb AS usuacreo,us.nomb AS usuamodifico,prod_detr,prod_cdtr
    FROM fe_art  as a 
    inner join fe_fletes as b on(b.idflete=a.idflete)
    inner join fe_mar as m on m.idmar=a.idmar
    inner join fe_cat as c on(c.idcat=a.idcat) 
    INNER JOIN fe_grupo AS g ON g.idgrupo=c.idgrupo
    left join fe_costos as d on(d.cost_idco=a.prod_idco)
    left join fe_rcom as yy on (yy.idauto=a.prod_idau) 
    left join fe_prov as o on (o.idprov=yy.idprov)
    LEFT JOIN fe_usua AS u ON u.idusua=a.prod_idus
    LEFT JOIN fe_usua AS us ON us.idusua=a.prod_uact,fe_gene AS v
    WHERE descri LIKE cbuscar and prod_acti<>'I' ORDER BY DESCRI;
  else
    set cbuscar=concat('%',trim(abuscar),+'%');
    SELECT idart,descri,unid,uno,dos,tre,cua,cero,
    round(prod_uti1*round(if(tmon='S',(a.prec*v.igv)+b.prec,(a.prec*v.igv*if(prod_dola>nd,prod_dola,nd))+b.prec),2),0.5) as pre1,
    round(prod_uti2*round(if(tmon='S',(a.prec*v.igv)+b.prec,(a.prec*v.igv*if(prod_dola>nd,prod_dola,nd))+b.prec),2),0.5) as pre2,
    round(prod_uti3*round(if(tmon='S',(a.prec*v.igv)+b.prec,(a.prec*v.igv*if(prod_dola>nd,prod_dola,nd))+b.prec),2),0.5) as pre3,
    round(if(tmon='S',(a.prec*v.igv)+b.prec,(a.prec*v.igv*if(prod_dola>nd,prod_dola,nd))+b.prec),2) as costo,c.idgrupo,c.dcat,prod_dola,
    round(if(tmon='S',(a.prec*v.igv),(a.prec*v.igv*nd)),2) as costosf,b.prec as flete,m.dmar,
    mid(descri,1,length(trim(descri))-length(trim(m.dmar))) as descri1,prod_cod1,
    ifnull(d.cost_cost,0) as costor,ifnull(d.cost_prec,0) as precr,ifnull(d.cost_mone,'')  as moner,
    cast(ifnull(d.cost_idco,0) as unsigned) as cost_idco,ifnull(d.cost_flet,0)  as fleter,ifnull(d.cost_dola,0) as dolar,
    peso,a.prec,tipro,a.idmar,a.idcat,cost,tmon,a.idflete,prod_uti1,prod_uti2,prod_uti3,
    prod_come,prod_comc,ulpc,prod_idus,prod_uact,prod_fact,fechc,prod_smax,prod_smin,ifnull(o.razo,'') as proveedor,
    ifnull(yy.ndoc,'') as ndoc,ifnull(yy.fech,'') as fech,ulfc,prod_ent1,prod_ent2,prod_icbper,
     g.desgrupo AS grupo,b.desflete,u.nomb AS usuacreo,us.nomb AS usuamodifico,prod_detr,prod_cdtr
    FROM fe_art  as a 
    inner join fe_fletes as b on(b.idflete=a.idflete)
    inner join fe_mar as m on m.idmar=a.idmar
    inner join fe_cat as c on(c.idcat=a.idcat) 
    INNER JOIN fe_grupo AS g ON g.idgrupo=c.idgrupo
    left join fe_costos as d on(d.cost_idco=a.prod_idco)
    left join fe_rcom as yy on (yy.idauto=a.prod_idau) 
    left join fe_prov as o on (o.idprov=yy.idprov)
    LEFT JOIN fe_usua AS u ON u.idusua=a.prod_idus
    LEFT JOIN fe_usua AS us ON us.idusua=a.prod_uact,fe_gene AS v
    WHERE prod_cod1 LIKE cbuscar and prod_acti<>'I' ORDER BY DESCRI;
end if;
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
   select idprov,nruc,razo,ndni,dire,ciud,fono,fax,email,celu,refe,prov_rpm,prov_idus,prov_actu,fechprov,prov_feac
   from fe_prov where razo like cbuscar and prov_acti<>'I' order by razo ;
end if;
if opt=1 then
   select idprov,nruc,razo,ndni,dire,ciud,fono,fax,email,celu,refe,prov_rpm,prov_idus,prov_actu,fechprov,prov_feac
   from fe_prov where nruc like cbuscar and prov_acti<>'I' order by nruc;
end if;
if opt=2 then
   select idprov,nruc,razo,ndni,dire,ciud,fono,fax,email,celu,refe,prov_rpm,prov_idus,prov_actu,fechprov,prov_feac
   from fe_prov where idprov=nid and prov_acti<>'I' order by razo;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraSeries` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraSeries` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraSeries`()
BEGIN
SELECT idserie,tdoc,serie,nume,codt,seri_idal FROM fe_serie ORDER BY idserie;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraStockC` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraStockC` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraStockC`(nidart integer)
begin
select a.tcompras-a.tventas as saldo
from (select idart,sum(if(tipo='C',cant,0)) as tcompras,
sum(if(tipo='V',cant,0)) as tventas from Vkardexc  as a where idart=nidart group by  idart) as a;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraTodosLosProductos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraTodosLosProductos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraTodosLosProductos`(in abuscar varchar(80),in nd float)
BEGIN
declare cbuscar varchar(80);
declare vigv decimal(6,4);
select igv into vigv from fe_gene where idgene=1;
set cbuscar=concat('%',trim(abuscar),+'%');
SELECT idart,descri,unid,uno,dos,tre,cua,
ifnull(round(if(tmon='S',((a.prec*vigv)+b.prec)*prod_uti1,((a.prec*vigv*if(prod_dola>nd,prod_dola,nd))+b.prec)*prod_uti1),0.5),0) as pre1,
ifnull(round(if(tmon='S',((a.prec*vigv)+b.prec)*prod_uti2,((a.prec*vigv*if(prod_dola>nd,prod_dola,nd))+b.prec)*prod_uti2),0.5),0) as pre2,
ifnull(round(if(tmon='S',((a.prec*vigv)+b.prec)*prod_uti3,((a.prec*vigv*if(prod_dola>nd,prod_dola,nd))+b.prec)*prod_uti3),0.5),0) as pre3,
round(if(tmon='S',(a.prec*vigv)+b.prec,(a.prec*vigv*nd)+b.prec),2) as costo,c.idgrupo,c.dcat,prod_dola,
round(if(tmon='S',(a.prec*vigv),(a.prec*vigv*nd)),2) as costosf,b.prec as flete,a.prod_acti,
ifnull(d.cost_cost,0) as costor,ifnull(d.cost_prec,0) as precr,ifnull(d.cost_mone,'')  as moner,
cast(ifnull(d.cost_idco,0) as unsigned) as cost_idco,ifnull(d.cost_flet,0)  as fleter,ifnull(d.cost_dola,0) as dolar,
peso,a.prec,tipro,idmar,a.idcat,cost,tmon,a.idflete,prod_uti1,prod_uti2,prod_uti3,prod_idus,
prod_come,prod_comc,ulpc,prod_idus,prod_uact,prod_fact,fechc,prod_smax,prod_smin,ifnull(o.razo,'') as proveedor,
ifnull(y.ndoc,'') as ndoc,ifnull(y.fech,'') as fech,ulfc
FROM fe_art  as a inner join fe_fletes as b on(b.idflete=a.idflete)
inner join fe_cat as c on(c.idcat=a.idcat) left join fe_costos as d on(d.cost_idco=a.prod_idco)
left join fe_rcom as y on (y.idauto=a.prod_idau) left join fe_prov as o on (o.idprov=y.idprov)
WHERE descri LIKE cbuscar  and prod_Acti='A' ORDER BY DESCRI;
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
  SELECT placa,razon,ructr,cons,nombr,breve,cons,marca,placa1,dirtr,idtra,tran_tipo,tran_cons1 FROM fe_tra WHERE razon LIKE cb1 AND tran_acti='A';
 ELSE
  SELECT placa,razon,ructr,cons,nombr,breve,cons,marca,placa1,dirtr,idtra,tran_tipo,tran_cons1 FROM fe_tra WHERE placa LIKE cb1 AND tran_acti='A';
END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PromuestraUsuarioS` */

/*!50003 DROP PROCEDURE IF EXISTS  `PromuestraUsuarioS` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PromuestraUsuarioS`(in cbusca varchar(80),in opt integer,in nid integer)
BEGIN
declare cbuscar varchar(80);
set cbuscar=concat('%',trim(cbusca),+'%');
if opt=0 then
   select nomb,tipo,activo,idusua,0 as Uno,1 as uno,2 as dos,3 as tres,clave,idalma
   from fe_usua where nomb like cbuscar and activo='S' order by nomb;
end if;
if opt=1 then
   select nomb,tipo,activo,idusua,0 as Uno,1 as uno,2 as dos,3 as tres,clave,idalma from fe_usua where idusua=nid;
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
select nomv,idven,vend_comi,vend_tipo from fe_vend where nomv like cbuscar and vend_acti<>'I' order by nomv;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraZonas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraZonas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraZonas`(cv varchar(50))
BEGIN
declare cv1 varchar(50);
set cv1=concat('%',trim(cv),'%');
select a.zona_nomb,c.zona_nomb as Zonap,b.nomb as usuario,a.zona_fech,a.zona_idpc,a.zona_idzo,a.zona_idzz from fe_zona as a
inner join fe_zonap as c on c.zona_idzon=a.zona_idzz inner join fe_usua as b on b.idusua=a.zona_idus where
a.zona_acti<>'I' and a.zona_nomb like cv1 order by a.zona_nomb;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraZonasp` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraZonasp` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraZonasp`(cv varchar(50))
BEGIN
declare cv1 varchar(50);
set cv1=concat('%',trim(cv),'%');
select zona_nomb,zona_idzon,b.nomb as usuario,zona_fech,zona_idpc from fe_zonap as a
inner join fe_usua as b on b.idusua=a.zona_idus where
zona_acti<>'I' and zona_nomb like cv1 order by zona_nomb;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProOtorgaOpciones` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProOtorgaOpciones` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProOtorgaOpciones`(nidop integer,nidacti integer,dfi date,dff date)
begin
update fe_opt set opti_acti=nidacti,opti_feci=dfi,opti_fecf=dff where opti_idop=nidop;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProRegistroCostos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProRegistroCostos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProRegistroCostos`()
BEGIN
DECLARE done INT DEFAULT 0;
declare ncosto float;
declare nflete float;
declare nprec float;
declare nidart integer;
declare cmone char;
declare cursor1 cursor for
SELECT idart as coda,round(if(tmon='S',(a.prec*1.19),(a.prec*1.19*2.85)),2) as costo,
b.prec as flete,round(a.prec*1.19,2) as precio,tmon FROM fe_art  as a inner join fe_fletes as b on(b.idflete=a.idflete)
WHERE prod_acti<>'I' ORDER BY idart;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
open cursor1;
cursor1: LOOP
    fetch cursor1 into nidart,ncosto,nflete,nprec,cmone;
    insert into fe_costos(cost_cost,cost_idau,cost_idart,cost_flet,cost_prec,cost_mone,cost_dola)
    values(ncosto,0,nidart,nflete,nprec,cmone,2.85);
    select @idcosto:=max(cost_idco) from fe_costos;
    update fe_art set prod_idco=@idcosto where idart=nidart;
END LOOP cursor1;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProReiniciaMvtos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProReiniciaMvtos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProReiniciaMvtos`()
BEGIN
delete from fe_docom;
alter table fe_docom Auto_increment=0 ;
delete from fe_rocom;
alter table fe_rocom Auto_increment=0 ;
delete from fe_rvendedor;
alter table fe_rvendedor Auto_increment=0 ;
delete from fe_kar;
alter table fe_kar Auto_increment=0 ;
delete from fe_rcom;
alter table fe_rcom Auto_increment=0 ;
delete from fe_cred;
alter table fe_cred Auto_increment=0 ;
delete from fe_rcred;
alter table fe_rcred Auto_increment=0 ;
delete from fe_ent;
alter table fe_ent Auto_increment=0 ;
delete from fe_caja;
alter table fe_caja Auto_increment=0 ;
delete from fe_deu;
alter table fe_deu Auto_increment=0 ;
delete from fe_rdeu;
alter table fe_rdeu Auto_increment=0 ;
delete from fe_guiac;
alter table fe_guiac Auto_increment=0 ;
delete from fe_nccom;
alter table fe_nccom Auto_increment=0 ;
delete from fe_ncven;
alter table fe_ncven Auto_increment=0 ;
delete from fe_cambiosvtas;
alter table fe_cambiosvtas Auto_increment=0 ;
delete from fe_ped;
alter table fe_ped Auto_increment=1 ;
delete from fe_rped;
alter table fe_rped Auto_increment=1 ;
delete from fe_costos;
alter table fe_costos Auto_increment=0 ;
delete from fe_art;
alter table fe_art Auto_increment=0 ;
delete from fe_cat;
alter table fe_cat Auto_increment=1 ;
delete from fe_mar;
alter table fe_mar Auto_increment=1 ;
delete from fe_fletes;
alter table fe_fletes Auto_increment=1 ;
delete from fe_clie;
alter table fe_clie Auto_increment=1 ;
delete from fe_prov;
alter table fe_prov Auto_increment=1 ;
delete from fe_traspaso;
alter table fe_traspaso Auto_increment=1 ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProSoloCostosProductos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProSoloCostosProductos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProSoloCostosProductos`(nidart integer,nprec float,cmoneda char,idcosto integer,dfecha date,nidusua integer)
BEGIN
update fe_art set prec=nprec,tmon=cmoneda,prod_idco=idcosto,prod_fact=dfecha,prod_uact=nidusua where idart=nidart;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProSoloDatoCuenta` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProSoloDatoCuenta` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProSoloDatoCuenta`(cta varchar(8))
BEGIN
select idcta,nomb,ncta from fe_plan where ncta=cta and plan_acti='A';
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

/*!50003 CREATE PROCEDURE `ProTraspasoRecibido`(nauto integer)
begin
update fe_rcom set rcom_reci='E' where idauto=nauto;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProUltimoPrecioVenta` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProUltimoPrecioVenta` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProUltimoPrecioVenta`(nidcl integer,nidart integer)
BEGIN
select max(a.fech),ifnull(b.prec,0)  as precio from fe_kar as b inner join fe_rcom as a on a.idauto=b.idauto where a.idcliente=nidcl
and b.idart=nidart;
END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
