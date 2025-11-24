/*
SQLyog Ultimate v12.09 (64 bit)
MySQL - 8.0.39 : Database - syscom_bdinnova
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

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `Productos` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `Productos` AFTER UPDATE ON `fe_art` FOR EACH ROW begin
  if old.descri<>new.descri  or old.unid<>new.unid or old.prod_unid1<>new.prod_unid1 or  old.prod_equi1<>new.prod_equi1
      or old.prod_equi2<>new.prod_equi2   then
      insert into fe_aproductos(hart_idar,hart_fech,hart_idua,hart_refe)values(old.idart,localtime,old.prod_uact,"Descripición-Equivalencias ");
  end if;
  if old.prec<>new.prec or old.tmon<>new.tmon  or old.prod_alma<> new.prod_alma then
      insert into fe_aproductos(hart_idar,hart_fech,hart_idua,hart_refe)values(old.idart,localtime,old.prod_uact,"Costosy Precios");
  end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_caja` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `Anulacaja` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `Anulacaja` AFTER UPDATE ON `fe_caja` FOR EACH ROW begin
declare nida,nide integer default 0;
select gene_idua into nida from fe_gene where idgene=1;
select gene_idue into nide from fe_gene where idgene=1;
if new.acti='I' then
   insert into fe_acaja(acaj_caja,acaj_fech,acaj_idus,acaj_idua)
   values(old.idcaja,localtime,nide,nida);
   update fe_gene set gene_idua=0,gene_idue=0 where idgene=1;
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_canjesp` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaCanjesP` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaCanjesP` AFTER UPDATE ON `fe_canjesp` FOR EACH ROW begin
if new.canp_acti='I' then
  update fe_rped set facturado='N' where idautop=old.canp_idap;
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

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaDcreditos` AFTER UPDATE ON `fe_cred` FOR EACH ROW begin
if new.acti='I' then
   update fe_lcaja set lcaj_acti='I' where lcaj_idcr=old.idcred;
   insert into fe_aldcreditos(ldcr_iddc,ldcr_idus,ldcre_fech)
   values(old.cred_idrc,new.cred_idu1,localtime);
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_deu` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaDdeudas` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaDdeudas` AFTER UPDATE ON `fe_deu` FOR EACH ROW begin
  if new.acti='I' and old.acta<> 0 then
     update fe_lcaja set lcaj_acti='I' where lcaj_idde=old.iddeu;
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

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaItemGuias` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaItemGuias` AFTER UPDATE ON `fe_guias` FOR EACH ROW begin
if new.guia_acti='I' then
    update fe_ent set entr_cant=0,entr_acti='I' where entr_idgu=old.guia_idgui;
    update fe_entregas set entr_acti='I' where entr_idgu=old.guia_idgui;
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_kar` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaKardex` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaKardex` AFTER UPDATE ON `fe_kar` FOR EACH ROW begin
if new.acti='I' then
    call astock(old.idart,old.alma,old.cant,if(old.tipo="C","V","C"),old.kar_equi);
    insert into fe_akardex(logk_deta,logk_idar,logk_cant,logk_prec,
    logk_ida1,logk_idk1,logk_fech,logk_idco)values('Se Anulo ',old.idart,old.cant,old.prec,old.idauto,
    old.idkar,localtime,old.kar_idco);
end if;
end */$$


DELIMITER ;

/* Trigger structure for table `fe_lcaja` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaCaja1` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaCaja1` AFTER UPDATE ON `fe_lcaja` FOR EACH ROW begin
if new.lcaj_acti='I' then
   insert into fe_acaja(acaj_fech,acaj_caja,acaj_idus,acaj_idua)values(localtime,old.lcaj_idca,old.lcaj_idus,old.lcaj_idus);
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

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `anula_pagosconnotas` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `anula_pagosconnotas` AFTER UPDATE ON `fe_nccom` FOR EACH ROW begin
   if old.ncre_ideu>0 and new.ncre_acti='I'  then
      update fe_deu set acti='I' where iddeu=old.ncre_ideu;
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

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaResumen` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaResumen` AFTER UPDATE ON `fe_rcom` FOR EACH ROW begin
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

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaPedido` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaPedido` AFTER UPDATE ON `fe_rped` FOR EACH ROW begin
if new.acti='I' then
  update fe_ped set acti='I' where idautop=old.idautop;
  update fe_rcred set rcre_acti='I' where rcre_idau=old.idautop;
end if;
end */$$


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
WHEN TRIM(ct)="ClientesCodigo" THEN
     IF nid=0 THEN
         SELECT idclie INTO vdvto FROM fe_clie WHERE TRIM(codigo1)=cb AND clie_acti<>'I';
     ELSE
   	    SELECT idclie INTO vdvto FROM fe_clie WHERE TRIM(codigo1)=cb AND idclie<>nid AND clie_acti<>'I';
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
WHEN TRIM(ct)="ProductosCod" THEN
     IF nid=0 THEN
         SELECT idart INTO vdvto FROM fe_art WHERE TRIM(prod_cod2)=cb AND prod_acti<>'I';
     ELSE
   	    SELECT idart INTO vdvto FROM fe_art WHERE TRIM(prod_cod2)=cb AND idart<>nid AND prod_acti<>'I';
     END IF;
WHEN TRIM(ct)="ProductosCod2" THEN
     IF nid=0 THEN
         SELECT idart INTO vdvto FROM fe_art WHERE TRIM(prod_cod2)=cb AND prod_acti<>'I';
     ELSE
   	    SELECT idart INTO vdvto FROM fe_art WHERE TRIM(prod_cod2)=cb AND idart<>nid AND prod_acti<>'I';
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
END CASE;
IF vdvto>0 THEN
   RETURN 0;
ELSE
   RETURN 1;
END IF;
END */$$
DELIMITER ;

/* Function  structure for function  `FunBuscaPedidoYaIngresado` */

/*!50003 DROP FUNCTION IF EXISTS `FunBuscaPedidoYaIngresado` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunBuscaPedidoYaIngresado`(cndoc varchar(10),nreg integer) RETURNS int
begin
declare nid integer default 0;
if nreg=0 then
   select idautop into nid  from fe_rped where ndoc=cndoc and acti='A' group by idautop;
  else
   select idautop into nid  from fe_rped where ndoc=cndoc and acti='A' and idautop<>nreg group by idautop;
end if;
if nid>0 then
   return 0;
else
   return 1;
end if;
end */$$
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

/* Function  structure for function  `FunCreaCLiente` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaCLiente` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaCLiente`(cruc varchar(11),crazo varchar(120),
cdire varchar(120),cciud varchar(120),cfono varchar(25),ccodigo1 varchar(6),cdni varchar (11),
ctipo char,cemail varchar(100),nidven integer,nidus integer,cpc varchar(45),ccelu varchar(15),
crefe varchar(255),linea float,crpm varchar(10),nidz integer) RETURNS int
BEGIN
declare nid integer default 0;
INSERT INTO fe_clie(nruc,razo,dire,ciud,fono,codigo1,ndni,clie_tipo,clie_corr,clie_codv,clie_idus,idpcclie,
fechclie,celu,refe,clie_lcre,clie_rpm,clie_idzo)
VALUES (cruc,crazo,cdire,cciud,cfono,ccodigo1,cdni,ctipo,cemail,nidven,nidus,cpc,localtime,ccelu,crefe,linea,crpm,nidz);
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

/* Function  structure for function  `FunCreaDetallePromocion` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaDetallePromocion` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaDetallePromocion`(nidpr integer,nidart integer,ncant decimal(12,2),
cunid varchar(50),nequi decimal(6,4),idepta integer) RETURNS int
begin
declare nid integer default 0;
insert into fe_detpro(deta_idpr,deta_idar,deta_cant,deta_unid,deta_equi,deta_epta)values(nidpr,nidart,ncant,cunid,nequi,idepta);
select last_insert_id() into nid from fe_detpro group by last_insert_id();
return nid;
end */$$
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

/* Function  structure for function  `FunCreaEpta` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaEpta` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaEpta`(niart integer,idp integer,nprec decimal(12,8),ncant decimal(8,2),
ncosto decimal(10,2),nmargen decimal(8,4),cmoneda char(1),cestilo char(1),ncomi decimal(6,3),lista integer,pcor decimal(12,5),mcor decimal(8,4)) RETURNS int
BEGIN
declare idep integer default 0;
insert into fe_epta(epta_idar,epta_pres,epta_prec,epta_cant,epta_cost,epta_marg,epta_mone,epta_esti,epta_comi,epta_list,epta_pcor,epta_mcor)
values(niart,idp,nprec,ncant,ncosto,nmargen,cmoneda,cestilo,ncomi,lista,pcor,mcor);
select last_insert_id() into idep from fe_epta group by last_insert_id();
return idep;
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

/*!50003 CREATE FUNCTION `FunCreaLinea`(cdescri varchar(45),nidus integer,cidpc varchar(45),
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

/*!50003 CREATE FUNCTION `FunCreaMarcas`(cdescri varchar(45),
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

/* Function  structure for function  `FunCreaPresentaciones` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaPresentaciones` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaPresentaciones`(cdesc varchar(60),ncant decimal(12,2)) RETURNS int
BEGIN
declare nidp integer default 0;
insert into fe_presentaciones(pres_desc,pres_cant)values(cdesc,ncant);
select last_insert_id() into nidp from fe_presentaciones group by last_insert_id();
return nidp;
END */$$
DELIMITER ;

/* Function  structure for function  `FuncreaProductos` */

/*!50003 DROP FUNCTION IF EXISTS `FuncreaProductos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FuncreaProductos`(cdesc varchar(120),cunid varchar(15),nprec float,ncosto float,
npeso float,ccat integer,cmar integer,ctipro char,nflete decimal(10,6),cm char,cidpc varchar(45),
ncome float,ncomc float,nidusua integer,nsmin float,nsmax float,nidcosto integer,ndolar decimal(6,4),cuni1 varchar(15),
equi1 float,equi2 float,nigv decimal(6,4),nalma integer,ccodigo varchar(30),ccodigo2 varchar(15)) RETURNS int
BEGIN
declare nid integer default 0;
INSERT INTO fe_art(descri,unid,prec,cost,peso,idcat,idmar,tipro,idflete,tmon,fechc,idpc,prod_come,
prod_comc,prod_idus,prod_smin,prod_smax,prod_idco,prod_dola,prod_unid1,prod_equi1,prod_equi2,prod_tigv,prod_alma,prod_cod1,
prod_flet,prod_cod2)
VALUES (cdesc,cunid,nprec,ncosto,npeso,ccat,cmar,ctipro,1,cm,localtime,
cidpc,ncome,ncomc,nidusua,nsmin,nsmax,nidcosto,ndolar,cuni1,equi1,equi2,nigv,nalma,ccodigo,nflete,ccodigo2);
select last_insert_id() into nid from fe_art group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FuncreaProductos1` */

/*!50003 DROP FUNCTION IF EXISTS `FuncreaProductos1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FuncreaProductos1`(cdesc varchar(100),cunid varchar(15),nprec float,ncosto float,
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

/* Function  structure for function  `FunCreaPromociones` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaPromociones` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaPromociones`(dfechai date,dfechaf date,nidart integer,nidcat integer,ncant decimal(12,2),
nimpo decimal(12,2),cunid varchar(50),nequi decimal(6,2),ncosto decimal(6,2),ctipo char,cnomb varchar(100)) RETURNS int
begin
declare nid integer default 0;
insert into fe_rpro(rpro_feci,rpro_fecf,rpro_idar,rpro_idca,rpro_cant,rpro_impo,rpro_unid,rpro_equi,rpro_cost,rpro_tipo,rpro_nomb)
Values(dfechai,dfechaf,nidart,nidcat,ncant,nimpo,cunid,nequi,ncosto,ctipo,cnomb);
select last_insert_id() into nid from fe_rpro group by last_insert_id();
return nid;
end */$$
DELIMITER ;

/* Function  structure for function  `FunCreaProveedor` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaProveedor` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaProveedor`(cruc varchar(11),crazo varchar(60),cdire varchar(60),cciud varchar(60),
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

/* Function  structure for function  `FunCreaVendedor` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaVendedor` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaVendedor`(cvendedor varchar(100),nidusua integer,
pc varchar(60),ccorreo varchar(100),cfono varchar(100),cdni varchar(100)) RETURNS int
BEGIN
declare nid integer default 0;
INSERT INTO fe_vend(nomv,fechvend,vend_idus,idpcvend,vend_corr,vend_fono,vend_ndni)
    VALUES (cvendedor,localtime,nidusua,pc,ccorreo,cfono,cdni);
select last_insert_id() into nid from fe_vend group by last_insert_id();
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

/* Function  structure for function  `FunDetalleGuiasCons1` */

/*!50003 DROP FUNCTION IF EXISTS `FunDetalleGuiasCons1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunDetalleGuiasCons1`(nidart integer,ncant decimal(12,2),nidg integer,nidkar integer,cunid varchar(50)) RETURNS int
BEGIN
declare idg integer default 0;
insert into fe_ent(entr_idar,entr_cant,entr_idgu,entr_idkar,entr_unid)values(nidart,ncant,nidg,nidkar,cunid);
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
   select idauto into sw from fe_rcom where ndoc=cdcto and tdoc=ctdoc and idprov=idp and tipom='C' and acti<>'I'  group by idauto;
  else
   select idauto into sw from fe_rcom where ndoc=cdcto and tdoc=ctdoc and idprov=idp and tipom='C' and idauto<>nidauto and acti<>'I' group by idauto;
end if;
return sw;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCabeceraCotizacion` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCabeceraCotizacion` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCabeceraCotizacion`(dfech datetime,nidclie integer,
cndoc varchar(10),ctdoc varchar(2),nimpo decimal(12,2),cform char,cusua integer,cidpcped varchar(45),nidven integer,nidtienda integer,ctp char,
caten varchar(120),cforma varchar(120),cplazo varchar(120),cvalidez varchar(120),centrega varchar(120),cdetalle varchar(180),cmone char,vigv decimal(6,4),cgara varchar(100)) RETURNS int
BEGIN
declare nid integer default 0;
INSERT INTO fe_rped(fech,idclie,ndoc,tdoc,impo,form,rped_idus,idpcped,fecho,idven,idtienda,
tipopedido,aten,forma,plazo,validez,entrega,detalle,rped_mone,rped_vigv,rped_gara)
VALUES(dfech,nidclie,cndoc,ctdoc,nimpo,cform,cusua,cidpcped,
localtime,nidven,nidtienda,ctp,caten,cforma,cplazo,cvalidez,centrega,cdetalle,cmone,vigv,cgara);
select last_insert_id() into nid from fe_rped group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCabeceraCotizacion1` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCabeceraCotizacion1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCabeceraCotizacion1`(dfech datetime,nidclie integer,
cndoc varchar(10),ctdoc varchar(2),nimpo float,cform char,cusua integer,cidpcped varchar(45),nidven integer,nidtienda integer,ctp char,
caten varchar(80),cforma varchar(80),cplazo varchar(80),cvalidez varchar(80),centrega varchar(80),cdetalle varchar(150),cmone char,cauto char) RETURNS int
BEGIN
declare nid integer default 0;
INSERT INTO fe_rped(fech,idclie,ndoc,tdoc,impo,form,rped_idus,idpcped,fecho,idven,idtienda,tipopedido,aten,forma,plazo,validez,entrega,detalle,rped_mone,rped_auto)
VALUES(dfech,nidclie,cndoc,ctdoc,nimpo,cform,cusua,cidpcped,localtime,nidven,nidtienda,ctp,caten,cforma,cplazo,cvalidez,centrega,cdetalle,cmone,cauto);
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
n1 integer,n2 integer,n3 integer,nitem integer,npvta decimal(12,2)) RETURNS int
BEGIN
declare nid,ntdoc,nidctaper integer;
declare ctipo char;
set nid=0;
if opt=0 then
   INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,dolar,vigv,tcom,idprov,tipom,fusua,idusua,codt,rcom_nitem,pimpo)
   VALUES (ctdoc,cform,cndoc,dfecha,dfechar,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,ctg,ccodp,cmvto,localtime,nus,nidcodt,nitem,npvta);
   select last_insert_id() into nid from fe_rcom group by last_insert_id();
    if n1>0 and n2>0 and n3>0 then
      call IngresaCuentas(nv,0,0,0,nigv,0,0,nt,n1,0,0,0,n2,0,0,n3,"D","","","","D","","","H",nid);
   end if;
  else
   select gene_ctpe into nidctaper  from fe_gene where idgene=1;
   INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,dolar,vigv,tcom,idcliente,tipom,fusua,idusua,codt,rcom_nitem,pimpo)
   VALUES (ctdoc,cform,cndoc,dfecha,dfecha,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,ctg,ccodp,cmvto,localtime,nus,nidcodt,nitem,npvta);
   select last_insert_id() into nid from fe_rcom group by last_insert_id();
   if n1>0 and n2>0 and n3>0 then
      call IngresaCuentasV(nv,nigv,nt,n1,n2,n3,"H","H","D",nid,npvta,nidctaper);
   end if;
end if;
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCabeceraCVtas` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCabeceraCVtas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCabeceraCVtas`(
ctdoc VARCHAR(2),cform CHAR,cndoc VARCHAR(12),dfecha DATE,dfechar DATE,cdetalle VARCHAR(120),
nv FLOAT,nigv FLOAT,nt FLOAT,cndo2 VARCHAR(10),cm CHAR,
ndolar FLOAT,ni FLOAT,ctg CHAR,ccodp INTEGER,cmvto CHAR,nus INTEGER,opt INTEGER,nidcodt INTEGER,
n1 INTEGER,n2 INTEGER,n3 INTEGER,nretencion DECIMAL(8,2),npvta DECIMAL(12,2),nvendedor INTEGER) RETURNS int
BEGIN
DECLARE nid,idve,nidctaper INTEGER;
SET nid=0;
   INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,dolar,vigv,tcom,idcliente,tipom,fusua,idusua,codt,rcom_mret,pimpo,rcom_vend)
   VALUES (ctdoc,cform,cndoc,dfecha,dfecha,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,ctg,ccodp,cmvto,LOCALTIME,nus,nidcodt,nretencion,0,nvendedor);
   SELECT LAST_INSERT_ID() INTO nid FROM fe_rcom GROUP BY LAST_INSERT_ID();
   IF n1>0 AND n2>0 AND n3>0 THEN
      CALL IngresaCuentasV(nv,nigv,nt,n1,n2,n3,"H","H","D",nid,npvta,nidctaper);
   END IF;
RETURN nid;
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

/* Function  structure for function  `FunIngresaCaja` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCaja` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCaja`(
na integer,dfecha date,nt1 float,cmvtoc char,cform char,cm1 char,cndoc varchar(10),nidcon integer,
cu integer,cdetalle varchar(120),cor varchar(2),nimp1 float,cm2 char,tcvta float,nidcodt integer,cajas char,nidcredito int,ide integer) RETURNS int
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

/* Function  structure for function  `FunIngresaCostos` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCostos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCostos`(ncosto float,
nidauto integer,nidart integer,nflete float,nprec float,cmone char,ndola float) RETURNS int
BEGIN
declare nid integer;
insert into fe_costos(cost_cost,cost_idau,cost_idart,cost_flet,cost_prec,cost_mone,cost_dola)
values(ncosto,nidauto,nidart,nflete,nprec,cmone,ndola);
select last_insert_id() into nid from fe_costos group by last_insert_id();
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

/*!50003 CREATE FUNCTION `FunIngresaDatosLcajaE`(dfecha datetime,cndoc varchar(10),cdeta varchar(180),idcta integer,sdeudor decimal(12,2),
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

/*!50003 CREATE FUNCTION `FunIngresaDatosLcajaE1`(dfecha date,cndoc varchar(10),cdeta varchar(180),idcta integer,sdeudor decimal(12,2),
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

/* Function  structure for function  `FunIngresaDatosLcajaECreditos` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDatosLcajaECreditos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDatosLcajaECreditos`(dfecha date,cndoc varchar(12),cdeta varchar(180),idcta integer,sdeudor decimal(12,2),
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

/*!50003 CREATE FUNCTION `FunIngresaDatosLcajaEDeudas`(dfecha date,cndoc varchar(12),cdeta varchar(180),idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),cmone char,ndolar decimal(5,3),nidus integer,nidcp integer,nidauto integer,cform char,cdcto char(15)) RETURNS int
begin
declare nid integer;
insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,
lcaj_idus,lcaj_idde,lcaj_idau,lcaj_form,lcaj_fope,lcaj_dcto)values
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,nidauto,cform,localtime,cdcto);
select last_insert_id() into nid from fe_lcaja group by last_insert_id();
return nid;
end */$$
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

/* Function  structure for function  `FunIngresaDPedidos` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaDPedidos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaDPedidos`(ncoda integer,ncant float,nprec float,nidauto integer,
cunid varchar(20),nequi decimal(8,2),npos integer,idepta integer,comi decimal(6,3),ncosto decimal(12,6)) RETURNS int
BEGIN
declare id integer default 0;
INSERT INTO fe_ped(idart,cant,prec,idautop,dped_unid,dped_equi,dped_posi,dped_idep,dped_comi,dped_cost)
VALUES(ncoda,ncant,nprec,nidauto,cunid,nequi,npos,idepta,comi,ncosto);
select last_insert_id() into id from fe_ped group by last_insert_id();
return id;
END */$$
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
dfechat date,nidus integer,cdeta varchar(150),nidtr integer,cndoc varchar(10),cmoti char,nidcl integer,ntotal decimal(12,2)) RETURNS int
BEGIN
declare id integer;
insert into fe_guias(guia_fech,guia_ptop,guia_ptoll,guia_idau,guia_fect,guia_idus,guia_fope,
guia_deta,guia_idtr,guia_ndoc,guia_moti,guia_idcl,guia_impo)
values(dfecha,cptop,cptoll,nidauto,dfechat,nidus,localtime,cdeta,nidtr,cndoc,cmoti,nidcl,ntotal);
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
dfechat DATETIME,nidus INTEGER,cdeta VARCHAR(150),nidtr INTEGER,cndoc VARCHAR(12),nidtda INTEGER,cdcto VARCHAR(20),df DATE,nidpr INTEGER,cubigeo VARCHAR(8)) RETURNS int
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
dfechat DATE,nidus INTEGER,cdeta VARCHAR(150),nidtr INTEGER,cndoc VARCHAR(12),nidtda INTEGER,cubigeo VARCHAR(8)) RETURNS int
BEGIN
DECLARE id INTEGER;
INSERT INTO fe_guias(guia_fech,guia_ptop,guia_ptoll,guia_idau,guia_fect,guia_idus,guia_fope,guia_deta,guia_idtr,guia_ndoc,guia_moti,guia_codt,guia_ubig)
VALUES(dfecha,cptop,cptoll,nidauto,dfechat,nidus,LOCALTIME,cdeta,nidtr,cndoc,'D',nidtda,cubigeo);
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
nct float,cincl char,tmvto char,ccodv integer,calma integer,nidcosto1 integer,vcom float,nequi decimal(12,8),
cuni varchar(30),epta integer,npos integer,ncosto decimal(12,4),nigv decimal(6,4)) RETURNS int
BEGIN
declare nidk integer default 0;
if ct='C' then
  INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,ttip,incl,alma,kar_idco,codv,kar_alma1,kar_equi,kar_unid,kar_epta,kar_posi)
  VALUES (nid,cc,ct,npr,nct,tmvto,cincl,calma,nidcosto1,ccodv,calma,nequi,cuni,epta,npos);
 else
  INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,ttip,incl,alma,kar_idco,codv,kar_alma1,kar_comi,
  kar_equi,kar_unid,kar_epta,kar_posi,kar_tigv,kar_cost)
  VALUES (nid,cc,ct,npr,nct,tmvto,cincl,calma,nidcosto1,ccodv,0,vcom,nequi,cuni,epta,npos,nigv,ncosto);
end if;
select last_insert_id() into nidk from fe_kar group by last_insert_id();
return nidk;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaKardex2` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaKardex2` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaKardex2`(nid integer,cc integer,ct char,npr float,
nct float,cincl char,tmvto char,ccodv integer,calma integer,nidcosto1 integer,vcom float,nequi decimal(12,8),
cuni varchar(30),epta integer,npos integer,ncosto decimal(12,4),nigv decimal(6,4),nidk1 integer) RETURNS int
BEGIN
declare nidk integer default 0;
if ct='C' then
  INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,ttip,incl,alma,kar_idco,codv,kar_alma1,kar_equi,kar_unid,kar_epta,kar_posi,kar_idk1)
  VALUES (nid,cc,ct,npr,nct,tmvto,cincl,calma,nidcosto1,0,ccodv,nequi,cuni,epta,npos,nidk1);
 else
  INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,ttip,incl,alma,kar_idco,codv,kar_alma1,kar_comi,
  kar_equi,kar_unid,kar_epta,kar_posi,kar_tigv,kar_cost,kar_idk1)
  VALUES (nid,cc,ct,npr,nct,tmvto,cincl,calma,nidcosto1,0,ccodv,vcom,nequi,cuni,epta,npos,nigv,ncosto,nidk1);
end if;
select last_insert_id() into nidk from fe_kar group by last_insert_id();
return nidk;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaKardex3` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaKardex3` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaKardex3`(nid integer,cc integer,ct char,npr float,
nct float,cincl char,tmvto char,ccodv integer,calma integer,nidcosto1 integer,vcom float,nequi decimal(12,8),
cuni varchar(60),epta integer,npos integer,ncosto decimal(12,4),nigv decimal(6,4),fvto date,nflete decimal(10,6)) RETURNS int
BEGIN
declare nidk integer default 0;
if ct='C' then
  INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,ttip,incl,alma,kar_idco,codv,kar_alma1,kar_equi,kar_unid,kar_epta,kar_posi,kar_flet)
  VALUES (nid,cc,ct,npr,nct,tmvto,cincl,calma,nidcosto1,ccodv,calma,nequi,cuni,epta,npos,nflete);
 else
  INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,ttip,incl,alma,kar_idco,codv,kar_alma1,kar_comi,
  kar_equi,kar_unid,kar_epta,kar_posi,kar_tigv,kar_cost)
  VALUES (nid,cc,ct,npr,nct,tmvto,cincl,calma,nidcosto1,ccodv,0,vcom,nequi,cuni,epta,npos,nigv,ncosto);
end if;
select last_insert_id() into nidk from fe_kar group by last_insert_id();
return nidk;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaKardex4` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaKardex4` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaKardex4`(nid integer,cc integer,ct char,npr float,
nct float,cincl char,tmvto char,ccodv integer,calma integer,nidcosto1 integer,vcom float,nequi decimal(12,8),
cuni varchar(60),epta integer,npos integer,ncosto decimal(12,4),nigv decimal(6,4),fvto date,nlote varchar(15),idkardex integer) RETURNS int
BEGIN
declare nidk integer default 0;
if ct='C' then
  INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,ttip,incl,alma,kar_idco,codv,kar_alma1,kar_equi,kar_unid,kar_epta,
  kar_posi,kar_fvto,kar_lote,kar_idkar)
  VALUES (nid,cc,ct,npr,nct,tmvto,cincl,calma,nidcosto1,ccodv,calma,nequi,cuni,epta,npos,fvto,nlote,idkardex);
 else
  INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,ttip,incl,alma,kar_idco,codv,kar_alma1,kar_comi,
  kar_equi,kar_unid,kar_epta,kar_posi,kar_tigv,kar_cost,kar_fvto,kar_lote,kar_idkar)
  VALUES (nid,cc,ct,npr,nct,tmvto,cincl,calma,nidcosto1,ccodv,0,vcom,nequi,cuni,epta,npos,nigv,ncosto,fvto,nlote,idkardex);
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

/* Function  structure for function  `FunIngresaKardexTraspaso` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaKardexTraspaso` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaKardexTraspaso`(nid integer,cc integer,ct char,npr decimal(8,2),
nct decimal(12,2),cincl char,ct1 char,ccodv integer,nidtda integer,nequi decimal(6,2),cunid varchar(50),nidepta integer,
npos integer,nigv decimal(6,3),nidtda1 integer,cdeta varchar(40)) RETURNS int
BEGIN
declare nidk integer default 0;
INSERT INTO fe_kar(idauto,idart,tipo,prec,cant,incl,codv,ttip,alma,kar_alma1,kar_equi,kar_unid,kar_epta,kar_posi,kar_tigv)
VALUES (nid,cc,ct,npr,nct,cincl,ccodv,ct1,nidtda,nidtda1,nequi,cunid,nidepta,npos,nigv);
select last_insert_id() into nidk from fe_kar group by last_insert_id();
insert into fe_traspaso(tras_idka,tras_idau,tras_refe,tras_codt,tras_codt1,tras_idau1)values(nidk,nid,cdeta,nidtda,nidtda1,0);
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

/* Function  structure for function  `FunIngresaPagosCreditosCefectivo` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosCreditosCefectivo` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosCreditosCefectivo`(
cndoc varchar(12),nacta float,cesta char,cmone char,cb1 varchar(100),dfech date,
dfevto date,ctipo char,nctrl integer,cnrou varchar(40),nidrc float,cpc varchar(45),
idusua integer,idcaja integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_cred(fech,fevto,acta,ndoc,estd,mone,banc,tipo,cred_idrc,cred_idus,cred_fope,ncontrol,nrou,cred_idpc,cred_idce)
values(dfech,dfevto,nacta,cndoc,cesta,cmone,cb1,ctipo,nidrc,idusua,localtime,nctrl,cnrou,cpc,idcaja);
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

/* Function  structure for function  `FunIngresaPagosCreditosretencion` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosCreditosretencion` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosCreditosretencion`(
cndoc varchar(12),nacta float,cesta char,cmone char,cb1 varchar(100),dfech date,
dfevto date,ctipo char,nctrl integer,cnrou varchar(40),nidrc float,cpc varchar(45),
idusua integer,nidauto integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_cred(
fech,fevto,acta,ndoc,estd,mone,banc,tipo,cred_idrc,cred_idus,cred_fope,ncontrol,
nrou,cred_idpc,cred_idrt)
values(dfech,dfevto,nacta,cndoc,cesta,cmone,cb1,ctipo,nidrc,idusua,localtime,
nctrl,cnrou,cpc,nidauto);
select last_insert_id() into nid from fe_cred group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaPagosDeudas` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosDeudas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosDeudas`(dfech datetime,
dfevto datetime,nacta float,cndoc varchar(10),cesta char,cmone char,cb1 varchar(100),ctipo char,
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

/* Function  structure for function  `FunIngresaPagosDeudasCb` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaPagosDeudasCb` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaPagosDeudasCb`(dfech datetime,
dfevto datetime,nacta float,cndoc varchar(10),cesta char,cmone char,cb1 varchar(100),ctipo char,
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

/* Function  structure for function  `FunIngresaRCompras` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaRCompras` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaRCompras`(
ctdoc varchar(2),cform char,cndoc varchar(12),dfecha date,dfechar date,cdetalle varchar(120),
nv decimal(12,2),nigv decimal(12,2),nt decimal(12,2),cndo2 varchar(10),cm char,
ndolar float,ni float,ctg char,ccodp integer,cmvto char,nus integer,opt integer,nidcodt integer,
n1 integer,n2 integer,n3 integer,nitem integer,npvta float,nexon decimal(12,2),notros decimal(12,2)) RETURNS int
BEGIN
declare nid integer;
set nid=0;
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

/* Function  structure for function  `FunIngresaRetencion` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaRetencion` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaRetencion`(
ctdoc varchar(2),cform char,cndoc varchar(12),dfecha date,dfechar date,cdetalle varchar(120),
nv float,nigv float,nt float,cndo2 varchar(10),cm char,
ndolar float,ni float,ctg char,ccodp integer,cmvto char,nus integer,opt integer,nidcodt integer,
n1 integer,n2 integer,n3 integer,nitem integer,npvta float) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,
dolar,vigv,tcom,idcliente,tipom,fusua,idusua,codt,rcom_rete,rcom_idrt)
VALUES (ctdoc,cform,cndoc,dfecha,dfechar,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,
ni,ctg,ccodp,cmvto,localtime,nus,nidcodt,npvta,nitem);
select last_insert_id() into nid from fe_rcom group by last_insert_id();
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
values(dfecha,dfevto,nimpo,cndoc,cest,cmon,crefe,ctipo,id1,nidus,localtime);
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

/*!50003 CREATE FUNCTION `FunRegistraDeudasCCtas`(nauto INTEGER,nid INTEGER,
cmon CHAR,dfecha DATE,nimpoo FLOAT,nidus INTEGER,nidtda INTEGER,cpc VARCHAR(45),nidcta INTEGER) RETURNS int
BEGIN
DECLARE id INTEGER DEFAULT 0;
INSERT INTO fe_rdeu(rdeu_idpr,rdeu_fech,rdeu_idau,rdeu_impc,rdeu_idus,rdeu_codt,rdeu_idpc,rdeu_mone,rdeu_idct)
VALUES(nid,dfecha,nauto,nimpoo,nidus,nidtda,cpc,cmon,nidcta);
SELECT LAST_INSERT_ID() INTO id FROM fe_rdeu GROUP BY LAST_INSERT_ID();
RETURN id;
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
if sw1=0 and sw2=0 and sw3=0 then
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
SELECT idauto into vdvto FROM fe_rcom WHERE ndoc=cdcto
and tdoc=ctdoc AND acti<>'I' and idauto<>id1  and idcliente>0 group by idauto;
return vdvto;
END */$$
DELIMITER ;

/* Function  structure for function  `FunValidaDctosCompras` */

/*!50003 DROP FUNCTION IF EXISTS `FunValidaDctosCompras` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunValidaDctosCompras`(nid integer) RETURNS int
BEGIN
declare vdvto,vdvto1,nid1,xi integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0,vdvto1=0,nid1=0;
select rdeu_idau into xi from fe_rdeu  where rdeu_acti<>'I' and rdeu_idau=nid group by rdeu_idau;
SELECT sum(acta) into vdvto from fe_deu where deud_idrd=xi AND acti<>'I';
SELECT cost_idco into nid1 from fe_costos where cost_idau=nid AND cost_acti<>'I' group by cost_idau;
if nid1> 0 then
   SELECT kar_idco into vdvto1 FROM fe_kar WHERE kar_idco=nid1 and tipo='V' and acti<>'I' group by kar_idco;
end if;
if vdvto=0 and vdvto1=0 then
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
select codv into sw1 from fe_kar where codv=nid and acti='A' group by codv;
select rcre_codv into sw2 from fe_rcred where rcre_codv=nid and rcre_Acti='A'  group by rcre_codv;
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
  if ndif<=380 then
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
declare ndias,vdvto integer;
declare saldo decimal(12,2) default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET ndias=0,saldo=0;
set vdvto=0;
SELECT sum(a.impo-a.acta) into saldo FROM fe_cred as a inner join fe_rcred as b ON(b.rcre_idrc=a.cred_idrc)
wHERE a.acti<>'I' and b.rcre_idcl=nidcliente  and b.rcre_acti='A' group by b.rcre_idcl;

SELECT datediff(curdate(),max(a.fevto)) into ndias FROM
fe_cred as a inner join fe_rcred as b ON(b.rcre_idrc=a.cred_idrc)
wHERE a.acti<>'I' and b.rcre_idcl=nidcliente group by ncontrol having ROUND(SUM(a.impo-a.acta),2)>0
ORDER BY datediff(curdate(),max(a.fevto)) limit 0,1;
if (nmonto+saldo)>nlineac then
   set vdvto=0;
 else
   if ndias>1 then
      set vdvto=0;
    else
      set vdvto=1;
  end if;
end if;
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

/* Function  structure for function  `FunVerificaRetencion` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaRetencion` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaRetencion`(cdcto varchar(12),idp integer) RETURNS int
BEGIN
declare sw integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET sw=0;
select idauto into sw from fe_rcom where ndoc=cdcto and tdoc='20' and idcliente=idp and tipom='C' and  acti<>'I' group by idauto;
return sw;
END */$$
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

/* Function  structure for function  `FunVerificaSiTieneVentas` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaSiTieneVentas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaSiTieneVentas`(nid integer) RETURNS int
BEGIN
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
select kar_idkar into vdvto from fe_kar where kar_idkar=nid and tipo='V' and acti='A' group by kar_idkar;
if vdvto>0 then
   return 0;
  else
   return 1;
end if;
END */$$
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

/*!50003 CREATE PROCEDURE `astock`(in coda integer,in nalma integer,in ccant float,in ctipo char(1),equi float)
BEGIN
   if ctipo="C" then
      if nalma=1 then
          UPDATE fe_art SET uno=uno+(ccant*equi) WHERE idart=coda;
      end if;
      if nalma=2 then
          UPDATE fe_art SET dos=dos+(ccant*equi) WHERE idart=coda;
      end if;
      if nalma=3 then
          UPDATE fe_art SET tre=tre+(ccant*equi) WHERE idart=coda;
      end if;
      if nalma=4 then
          UPDATE fe_art SET cua=cua+(ccant*equi) WHERE idart=coda;
     end if;
   end if;
   if ctipo="V" then
      if nalma=1 then
          UPDATE fe_art SET uno=uno-(ccant*equi) WHERE idart=coda;
      end if;
      if nalma=2 then
          UPDATE fe_art SET dos=dos-(ccant*equi) WHERE idart=coda;
      end if;
      if nalma=3 then
          UPDATE fe_art SET tre=tre-(ccant*equi) WHERE idart=coda;
      end if;
      if nalma=4 then
          UPDATE fe_art SET cua=cua-(ccant*equi) WHERE idart=coda;
     end if;
  end if;
   if ctipo="I" then
      if nalma=1 then
          UPDATE fe_art SET uno=ccant,
          prod_uniM=IF(ccant>0,if(Mod(ccant,equi)=0,ccant/equi,ccant div equi),0),
          prod_unin=IF(ccant>0,if(Mod(ccant,equi)=0,0,Mod(ccant,equi)),ccant) WHERE idart=coda;
      end if;
      if nalma=2 then
          UPDATE fe_art SET dos=ccant,
          prod_duniM=IF(ccant>0,if(Mod(ccant,equi)=0,ccant/equi,ccant div equi),0),
          prod_dunin=IF(ccant>0,if(Mod(ccant,equi)=0,0,Mod(ccant,equi)),ccant) WHERE idart=coda;
      end if;
      if nalma=3 then
          UPDATE fe_art SET tre=ccant,
          prod_tuniM=IF(ccant>0,if(Mod(ccant,equi)=0,ccant/equi,ccant div equi),0),
          prod_tunin=IF(ccant>0,if(Mod(ccant,equi)=0,0,Mod(ccant,equi)),ccant) WHERE idart=coda;
      end if;
      if nalma=4 then
          UPDATE fe_art SET cua=ccant,
          prod_cuniM=IF(ccant>0,if(Mod(ccant,equi)=0,ccant/equi,ccant div equi),0),
          prod_cunin=IF(ccant>0,if(Mod(ccant,equi)=0,0,Mod(ccant,equi)),ccant) WHERE idart=coda;
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
declare equi float;
declare cursor1 cursor for
select a.idart,a.tcompras,a.tventas,a.alma,a.equi1
from (select b.idart,sum(if(b.tipo='C',b.cant*b.kar_equi,0)) as tcompras,
sum(if(b.tipo='V',b.cant*b.kar_equi,0)) as tventas,b.alma,if(z.prod_equi1>0,prod_equi1,1) as equi1 from fe_kar as b
inner join fe_rcom as y on y.idauto=b.idauto
inner join fe_art as z on z.idart=b.idart where b.acti<>'I' and y.acti='A' group by  idart,alma) as a;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
open cursor1;
start transaction;
UPDATE fe_art SET uno=0,dos=0,tre=0,cua=0,prod_unim=0,prod_unin=0,
prod_dunim=0,prod_dunin=0,prod_tunim=0,prod_tunin=0,prod_cunim=0,prod_cunin=0;
repeat
    fetch cursor1 into ccoda,tcompras,tventas,calma,equi;
    call astock(ccoda,calma,tcompras-tventas,ct,equi);
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

/* Procedure structure for procedure `Crosstab` */

/*!50003 DROP PROCEDURE IF EXISTS  `Crosstab` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `Crosstab`(dfi date,dff date,nidc integer)
BEGIN
DROP temporary TABLE IF EXISTS `vvtas`;
if nidc=0 then
  CREATE TEMPORARY TABLE vvtas AS
  select idart,dcat,cast(sum(impo) as decimal(12,2)) as importe,nomv,codv from (
  select a.prod_cod1 as idart,a.descri AS dcat,cast(sum(cant*k.prec) as decimal(12,2)) as impo,v.nomv,k.codv,0 as idcliente,a.idcat from
  fe_kar as k inner join fe_rcom as r on r.idauto=k.idauto
  inner join fe_art a on a.idart=k.idart
  inner join fe_vend as v on v.idven=k.codv
  where k.acti='A' and r.acti='A' and idcliente>0 and fech between dfi and dff
  group by rcom_vend,a.idart
  union all
  select -1 as idart,'zzz.COBERTURA CLIENTES' as dcat,count(*) as impo,v.nomv,codv,0 as idciente,0 as idcat
  from
  (select rcom_vend as codv from fe_rcom as r inner join fe_kar as a on a.idauto=r.idauto
  inner join fe_art as q on q.idart=a.idart
  where rcom_vend>0 and fech between dfi and dff
  and r.acti='A' and idcliente>0 and a.acti='A' group by idcliente,rcom_vend)
  as r inner join fe_vend as v on v.idven=r.codv  group by codv
  union all
  select 0 as idart,'zz.TOTALES'  AS dcat,sum(cant*k.prec) as impo,v.nomv,k.codv,0 as idcliente,0 as idcat
  from fe_kar as k inner join fe_rcom as r on r.idauto=k.idauto
  inner join fe_art a on a.idart=k.idart
  inner join fe_vend as v on v.idven=k.codv
  where k.acti='A' and r.acti='A' and idcliente>0 and fech between dfi and dff group by k.codv) as x
  group by x.codv,x.idart order by codv,dcat;
else
  CREATE TEMPORARY TABLE vvtas AS
  select idart,dcat,cast(sum(impo) as decimal(12,2)) as importe,nomv,codv from (
  select a.prod_cod1 as idart,a.descri AS dcat,cast(sum(cant*k.prec) as decimal(12,2)) as impo,v.nomv,k.codv,0 as idcliente,a.idcat from
  fe_kar as k inner join fe_rcom as r on r.idauto=k.idauto
  inner join fe_art a on a.idart=k.idart
  inner join fe_vend as v on v.idven=k.codv
  where k.acti='A' and r.acti='A' and idcliente>0 and fech between dfi and dff and a.idcat=nidc
  group by rcom_vend,a.idart
  union all
  select -1 as idart,'zzz.COBERTURA CLIENTES' as dcat,count(*) as impo,v.nomv,codv,0 as idciente,0 as idcat
  from
  (select rcom_vend as codv from fe_rcom as r inner join fe_kar as a on a.idauto=r.idauto
  inner join fe_art as q on q.idart=a.idart
  where rcom_vend>0 and fech between dfi and dff
  and r.acti='A' and idcliente>0 and a.acti='A' and q.idcat=nidc group by idcliente,rcom_vend)
  as r inner join fe_vend as v on v.idven=r.codv  group by codv
  union all
  select 0 as idart,'zz.TOTALES'  AS dcat,sum(cant*k.prec) as impo,v.nomv,k.codv,0 as idcliente,0 as idcat
  from fe_kar as k inner join fe_rcom as r on r.idauto=k.idauto
  inner join fe_art a on a.idart=k.idart
  inner join fe_vend as v on v.idven=k.codv
  where k.acti='A' and r.acti='A' and idcliente>0 and fech between dfi and dff and a.idcat=nidc group by k.codv) as x
  group by x.codv,x.idart order by codv,dcat;
end if;
SET @sql = NULL;

SELECT
  GROUP_CONCAT(DISTINCT
    CONCAT('sum(if(trim(vv.nomv)=''',trim(nomv),''',vv.importe,0)) AS ',trim(nomv)))
    INTO @sql
    FROM vvtas;
SET @sql = CONCAT('select idart,dcat as producto, ', @sql, '
                   FROM vvtas as vv group by vv.idart order by vv.dcat');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
END */$$
DELIMITER ;

/* Procedure structure for procedure `FunBuscaNombre` */

/*!50003 DROP PROCEDURE IF EXISTS  `FunBuscaNombre` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `FunBuscaNombre`(ct varchar(50),cb varchar(100),nid integer)
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION,SQLWARNING,NOT FOUND
case
when trim(ct)="Clientes" then
     if nid=0 then
         Select idclie From fe_clie Where Trim(razo)=cb And clie_acti<>'I';
     else
   	    Select idclie From fe_clie Where Trim(razo)=cb And idclie<>nid And clie_acti<>'I';
     end if;
when trim(ct)="Proveedores" then
 if nid=0 then
         Select idclie From fe_clie Where Trim(razo)=cb And clie_acti<>'I';
     else
   	    Select idclie From fe_clie Where Trim(razo)=cb And idclie<>nid And clie_acti<>'I';
     end if;
when trim(ct)="Productos" then
 if nid=0 then
         Select idclie From fe_clie Where Trim(razo)=cb And clie_acti<>'I';
     else
   	    Select idclie From fe_clie Where Trim(razo)=cb And idclie<>nid And clie_acti<>'I';
     end if;
when trim(ct)="Marcas" then
 if nid=0 then
         Select idclie From fe_clie Where Trim(razo)=cb And clie_acti<>'I';
     else
   	    Select idclie From fe_clie Where Trim(razo)=cb And idclie<>nid And clie_acti<>'I';
     end if;
when trim(ct)="Lineas" then
 if nid=0 then
         Select idclie From fe_clie Where Trim(razo)=cb And clie_acti<>'I';
     else
   	    Select idclie From fe_clie Where Trim(razo)=cb And idclie<>nid And clie_acti<>'I';
     end if;
end case;
commit;

END */$$
DELIMITER ;

/* Procedure structure for procedure `ingresacaja` */

/*!50003 DROP PROCEDURE IF EXISTS  `ingresacaja` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ingresacaja`(in nauto integer,in cdcto varchar(10),in dfecha date,
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
nv2 decimal(12,2),nv3 decimal(12,2),nid1 integer,nid2 integer,nid3 integer,ct1 char,ct2 char,ct3 char,nid integer,tper decimal(12,2),nidctaper integer)
BEGIN
insert into fe_ectas(idrven,impo,idcta,nitem,tipo)
values(nid,nv1,nid1,1,ct1);
insert into fe_ectas(idrven,impo,idcta,nitem,tipo)
values(nid,nv2,nid2,2,ct2);
insert into fe_ectas(idrven,impo,idcta,nitem,tipo,ecta_total)
values(nid,nv3,nid3,3,ct3,tper);
insert into fe_ectas(idrven,impo,idcta,nitem,tipo)
values(nid,tper,nidctaper,4,'H');
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCabeceraCV` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCabeceraCV` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCabeceraCV`(
ctdoc varchar(2),cform char,cndoc varchar(12),dfecha date,dfechar date,cdetalle varchar(120),
nv decimal(12,2),nigv decimal(12,2),nt decimal(12,2),cndo2 varchar(10),cm char,
ndolar decimal(6,4),ni decimal(6,4),ctg char,ccodp integer,cmvto char,nus integer,opt integer,nidcodt integer,
n1 integer,n2 integer,n3 integer,cdetalle1 varchar(120),npvta decimal(10,2),nidauto integer)
BEGIN
if opt=0 then
   update fe_rcom set tdoc=ctdoc,form=cform,ndoc=cndoc,fech=dfecha,fecr=dfechar,deta=cdetalle,valor=nv,igv=nigv,impo=nt,ndo2=cndo2,
   mone=cm,dolar=ndolar,vigv=ni,tcom=ctg,idprov=ccodp,tipom=cmvto,idusua1=nus,codt=nidcodt,pimpo=npvta where idauto=nidauto;
   call ProDesactivaLcajaE(nidauto);
   if n1>0 and n2>0 and n3>0 then
      select @i1:=sum(x.nid1),@i5:=sum(x.nid2),@i6:=sum(x.nid3),@i8:=sum(x.nid4)
      from (select
      case a.nitem when 1 then idectas else 0 end as nid1,
      case a.nitem when 5 then idectas else 0 end as nid2,
      case a.nitem when 6 then idectas else 0 end as nid3,
      case a.nitem when 8 then idectas else 0 end as nid4,idrcon
      from fe_ectasc  as a where a.idrcon=nidauto and a.ecta_Acti='A') as x group by idrcon;
      call ProActualizaCuentasc(nv,0,0,0,nigv,0,0,nt,n1,0,0,0,n2,0,0,n3,@i1,@i5,@i6,@i8,"D","D","","H");
    end if;
  else
   update fe_rcom set tdoc=ctdoc,form=cform,ndoc=cndoc,fech=dfecha,fecr=dfechar,deta=cdetalle,valor=nv,igv=nigv,impo=nt,ndo2=cndo2,
   mone=cm,dolar=ndolar,vigv=ni,tcom=ctg,idcliente=ccodp,tipom=cmvto,idusua1=nus,codt=nidcodt where idauto=nidauto;
   call ProDesactivaLcajaE(nidauto);
   if n1>0 and n2>0 and n3>0 then
      select @i1:=sum(x.nid1),@i2:=sum(x.nid2),@i3:=sum(x.nid3),@i4:=sum(x.nid4)
      from (select case a.nitem when 1 then idectas else 0 end as nid1,
      case a.nitem when 2 then idectas else 0 end as nid2,
      case a.nitem when 3 then idectas else 0 end as nid3,
      case a.nitem when 4 then idectas else 0 end as nid4,idrven
      from fe_ectas  as a where idrven=nidauto and acti='A') as x group by idrven;
      call ProActualizaCuentasV(nv,nigv,nt,n1,n2,n3,@i1,@i2,@i3,"H","H","D",nt,0,@i4);
   end if;
end if;
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

/* Procedure structure for procedure `ProActualizaCabeceraVTas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCabeceraVTas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCabeceraVTas`(
ctdoc VARCHAR(2),cform CHAR,cndoc VARCHAR(12),dfecha DATE,dfechar DATE,cdetalle VARCHAR(120),
nv DECIMAL(12,2),nigv DECIMAL(12,2),nt DECIMAL(12,2),cndo2 VARCHAR(12),cm CHAR,
ndolar FLOAT,ni FLOAT,ctg CHAR,ccodp INTEGER,cmvto CHAR,nus INTEGER,opt INTEGER,nidcodt INTEGER,
n1 INTEGER,n2 INTEGER,n3 INTEGER,nitems INTEGER,npvta FLOAT,nidauto INTEGER,nidven INTEGER)
BEGIN
DECLARE idve,nidctaper INTEGER;
    UPDATE fe_rcom SET tdoc=ctdoc,form=cform,ndoc=cndoc,fech=dfecha,fecr=dfechar,deta=cdetalle,valor=nv,igv=nigv,impo=nt,ndo2=cndo2,
   mone=cm,dolar=ndolar,vigv=ni,tcom=ctg,idcliente=ccodp,tipom=cmvto,idusua1=nus,codt=nidcodt,
   rcom_vend=nidven WHERE idauto=nidauto;
 CALL ProDesactivaLcajaE(nidauto);
   IF n1>0 AND n2>0 AND n3>0 THEN
      SELECT @i1:=SUM(xx.nid1),@i2:=SUM(xx.nid2),@i3:=SUM(xx.nid3),@i4:=SUM(xx.nid4)
      FROM (SELECT CASE a.nitem WHEN 1 THEN idectas ELSE 0 END AS nid1,
      CASE a.nitem WHEN 2 THEN idectas ELSE 0 END AS nid2,
      CASE a.nitem WHEN 3 THEN idectas ELSE 0 END AS nid3,
      CASE a.nitem WHEN 4 THEN idectas ELSE 0 END AS nid4,idrven
      FROM fe_ectas  AS a WHERE idrven=nidauto) AS xx GROUP BY idrven;
      CALL ProActualizaCuentasV(nv,nigv,nt,n1,n2,n3,@i1,@i2,@i3,"H","H","D",npvta,nidctaper,@i4);
END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCaja` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCaja` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCaja`(na integer,dfecha date,nt1 float,cmvtoc char,cform char,cm1 char,cndoc varchar(10),nidcon integer,
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
if opt=0 then
   update fe_cbancos set cban_acti='I' where cban_idco=id;
  else
   update fe_cbancos set cban_nume=nope,cban_idba=idb,cban_fech=dfecha,cban_idmp=idmp,
   cban_deta=cdeta,cban_idpr=idpr,cban_idcl=idcl,cban_ndoc=cndoc,cban_idct=idcta,
   cban_debe=debe,cban_haber=haber,cban_orde=norden  where cban_idco=id;
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

/* Procedure structure for procedure `ProActualizaCliente` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCliente` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCliente`(nid integer,cruc varchar(11),crazo varchar(120),
cdire varchar(120),cciud varchar(120),cfono varchar(20),ccodigo1 varchar(6),cdni varchar (11),
ctipo char,cemail varchar(100),nidven integer,nidus integer,ccelu varchar(15),crefe varchar(255),linea float,crpm varchar(10),nidz integer)
BEGIN
update fe_clie set
nruc=cruc,razo=crazo,dire=cdire,ciud=cciud,fono=cfono,codigo1=ccodigo1,ndni=cdni,clie_tipo=ctipo,clie_corr=cemail,
clie_codv=nidven,clie_actu=nidus,clie_feac=localtime,celu=ccelu,refe=crefe,clie_lcre=linea,clie_rpm=crpm,clie_idzo=nidz
where idclie=nid;
END */$$
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
caten varchar(120),cforma varchar(120),cplazo varchar(120),cvalidez varchar(120),centrega varchar(120),cdetalle varchar(180),
cmone char,nidauto integer,vigv decimal(6,4),cgara varchar(100))
BEGIN
UPDATE fe_rped SET fech=dfech,idclie=nidclie,ndoc=cndoc,impo=nimpo,form=cform,idven=nidven,facturado='N',tdoc=ctdoc,
tipopedido='P',aten=caten,forma=cforma,plazo=cplazo,validez=cvalidez,entrega=centrega,detalle=cdetalle,rped_vigv=vigv,rped_gara=cgara WHERE idautop=nidauto;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCotizacion1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCotizacion1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCotizacion1`(dfech datetime,nidclie integer,
cndoc varchar(10),ctdoc varchar(2),nimpo float,cform char,cusua integer,nidven integer,nidtienda integer,ctp char,
caten varchar(80),cforma varchar(80),cplazo varchar(80),cvalidez varchar(80),centrega varchar(80),cdetalle varchar(150),cmone char,cauto char,nidauto integer)
BEGIN
UPDATE fe_rped SET fech=dfech,idclie=nidclie,ndoc=cndoc,impo=nimpo,form=cform,idven=nidven,facturado='N',tdoc=ctdoc,rped_auto=cauto,
tipopedido='P',aten=caten,forma=cforma,plazo=cplazo,validez=cvalidez,entrega=centrega,detalle=cdetalle WHERE idautop=nidauto;
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
if opt=1 then
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
in idv2 integer, in idv3 integer,ct1 char,ct2 char,ct3 char,tper decimal(12,2),nidctaper integer,idv4 integer)
BEGIN
update fe_ectas set impo=nv1,idcta=nid1,tipo=ct1 where idectas=idv1;
update fe_ectas set impo=nv2,idcta=nid2,tipo=ct2 where idectas=idv2;
update fe_ectas set impo=nv3,idcta=nid3,tipo=ct3,ecta_total=tper  where idectas=idv3;
update fe_ectas set impo=tper,idcta=nidctaper,tipo='H' where idectas=idv4;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROACTUALIZADATOSDIARIO` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROACTUALIZADATOSDIARIO` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROACTUALIZADATOSDIARIO`(dfech datetime,ndebe decimal(12,2)
,nhaber decimal(12,2),cglosa varchar(120),ct char(1),cnume varchar(10),nidcta integer,idd integer,opt integer,ccond char,nit integer,ncomp varchar(15),nidcl integer,nidpr integer,cmone char,ctran char)
BEGIN
if opt=0 then
   update fe_ldiario set ldia_acti='I' where ldia_idld=idd;
 else
   update fe_ldiario set ldia_fech=dfech,ldia_debe=ndebe,ldia_haber=nhaber,ldia_glosa=cglosa,ldia_tipo=ct,ldia_nume=cnume,
   ldia_idcta=nidcta,ldia_cond=ccond,ldia_tran=ctran,
   ldia_item=nit,ldia_comp=ncomp,ldia_idcv=nidcl,ldia_idcc=nidpr,ldia_mone=cmone where ldia_idld=idd;
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

/* Procedure structure for procedure `ProActualizaDetalleGuiasCons1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaDetalleGuiasCons1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaDetalleGuiasCons1`(nidart integer,ncant decimal(12,2),nidg integer,
nidkar integer,opt integer,cunid varchar(50))
BEGIN
if opt=0 then
     update fe_ent set entr_acti='I' where entr_iden=nidkar;
   else
     update fe_ent set entr_idar=nidart,entr_cant=ncant,entr_unid=cunid where entr_iden=nidkar;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaDetallePedidos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaDetallePedidos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaDetallePedidos`(ncoda integer,ncant float,nprec float,
nr integer,idepta integer,equi decimal(8,4),ctipoa char,npos integer,ncosto decimal(12,5))
BEGIN
if ctipoa='A' then
     UPDATE fe_ped SET acti='I' WHERE idped=nr;
   else
     UPDATE fe_ped SET idart=ncoda,cant=ncant,prec=nprec,
     dped_equi=equi,dped_idep=idepta,dped_posi=npos,dped_cost=ncosto WHERE idped=nr;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaDetallePedidosc` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaDetallePedidosc` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaDetallePedidosc`(ncoda integer,ncant float,nprec float,
nr integer,idepta integer,equi decimal(8,4),ctipoa char,npos integer,ncosto decimal(12,4))
BEGIN
if ctipoa='A' then
     UPDATE fe_ped SET acti='I' WHERE idped=nr;
   else
     UPDATE fe_ped SET idart=ncoda,cant=ncant,prec=nprec,
     dped_equi=equi,dped_idep=idepta,dped_posi=npos,dped_cost=ncosto WHERE idped=nr;
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

/* Procedure structure for procedure `ProActualizaEpta` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaEpta` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaEpta`(niart integer,idp integer,nprec decimal(12,2),
ncant decimal(10,2),idepta integer,opt integer,ncosto decimal(10,2),nmargen decimal(8,4),cmoneda char(1),
cestilo char(1),ncomi decimal(6,3),lista integer,pcor decimal(12,5),mcor decimal(8,4))
BEGIN
if opt=0 then
   update fe_epta set epta_acti='I' where epta_idep=idepta;
  else
   update fe_epta set epta_idar=niart,epta_pres=idp,epta_prec=nprec,epta_cant=ncant,epta_cost=ncosto,
   epta_marg=nmargen,epta_mone=cmoneda,epta_esti=cestilo,epta_comi=ncomi,epta_list=lista,epta_pcor=pcor,epta_mcor=mcor where epta_idep=idepta;
end if;
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
dfechat date,nidus integer,cdeta varchar(150),nidtr integer,cndoc varchar(10),nidg integer,nidcl integer)
Begin
update fe_guias set guia_fech=dfecha,guia_ptop=cptop,guia_ptoll=cptoll,guia_fect=dfechat,guia_deta=cdeta,guia_idtr=nidtr,
guia_ndoc=cndoc,guia_idcl=nidcl where guia_idgui=nidg;
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

/* Procedure structure for procedure `ProActualizaIdpromocion` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaIdpromocion` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaIdpromocion`(nidart integer,nidpro integer,opt integer)
begin
if opt=1 then
   update fe_art set prod_idpc=nidpro where idart=nidart;
else
   update fe_art set prod_idpm=nidpro where idart=nidart;
end if;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaKardex1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaKardex1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaKardex1`(nid integer,cc integer,ct char,npr float,
nct float,cincl char,tmvto char,ccodv integer,calma integer,nidcosto1 integer,
nidkar integer,op integer,nequi float,cunid varchar(15),nidepta integer,xcom float,npos integer,ncosto decimal(12,4),nigv decimal(6,4))
BEGIN
if op=0 then
  Update fe_kar set Acti='I' where idkar=nidkar;
 else
  Update fe_kar set
  idauto=nid,idart=cc,tipo=ct,prec=npr,cant=nct,ttip=tmvto,incl=cincl,
  alma=calma,kar_idco=nidcosto1,codv=ccodv,kar_comi=xcom,
  kar_equi=nequi,kar_unid=cunid,kar_epta=nidepta,kar_posi=npos,kar_cost=ncosto,kar_tigv=nigv where idkar=nidkar;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaKardex2` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaKardex2` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaKardex2`(nid integer,cc integer,ct char,npr float,
nct float,cincl char,tmvto char,nidt integer,calma integer,nidcosto1 integer,
nidkar integer,op integer,nequi float,cunid varchar(15),nidepta integer,xcom float,npos integer,ncosto decimal(12,4),nigv decimal(6,4))
BEGIN
if op=0 then
  Update fe_kar set Acti='I' where idkar=nidkar;
 else
  Update fe_kar set
  idauto=nid,idart=cc,tipo=ct,prec=npr,cant=nct,ttip=tmvto,incl=cincl,
  alma=calma,kar_idco=nidcosto1,kar_alma1=nidt,kar_comi=xcom,
  kar_equi=nequi,kar_unid=cunid,kar_epta=nidepta,kar_posi=npos,kar_cost=ncosto,kar_tigv=nigv where idkar=nidkar;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaKardexF` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaKardexF` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaKardexF`(nid integer,cc integer,ct char,npr float,
nct float,cincl char,tmvto char,ccodv integer,calma integer,nidcosto1 integer,
nidkar integer,op integer,nequi float,cunid varchar(15),nidepta integer,xcom float,npos integer,ncosto decimal(12,4),
nigv decimal(6,4),fvto date,nflete decimal(10,5))
BEGIN
if op=0 then
  Update fe_kar set Acti='I' where idkar=nidkar;
 else
  Update fe_kar set
  idauto=nid,idart=cc,tipo=ct,prec=npr,cant=nct,ttip=tmvto,incl=cincl,
  alma=calma,kar_idco=nidcosto1,codv=ccodv,kar_comi=xcom,
  kar_equi=nequi,kar_unid=cunid,kar_epta=nidepta,kar_posi=npos,kar_cost=ncosto,kar_tigv=nigv,kar_flet=nflete where idkar=nidkar;
end if;
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

/* Procedure structure for procedure `PROActualizaPedidoFacturado` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROActualizaPedidoFacturado` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROActualizaPedidoFacturado`(nautop integer)
begin
UPDATE fe_rped SET facturado="S" WHERE idautop=nautop;
end */$$
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

/*!50003 CREATE PROCEDURE `PROACTUALIZAPRECIOGUIAS`(nidk integer,nprec decimal(12,6),nid integer)
BEGIN
update fe_kar set prec=nprec,idauto=nid,acti='A' where idkar=nidk;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaPreciosEptaUsuario` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaPreciosEptaUsuario` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaPreciosEptaUsuario`(nid integer,nidart integer,nidusua integer,cmone char,nprecio decimal(12,5))
BEGIN
update fe_art set prod_alma=nid,prod_uact=nidusua,prod_fact=localtime where idart=nidart;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaPreciosProducto` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaPreciosProducto` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaPreciosProducto`(
cc integer,dfe date,npr decimal(12,4),cnd integer,idp integer,cmda char,ni decimal(5,3),ndolar float,nidusua integer,nflete decimal(10,6))
BEGIN
declare costor decimal(12,4);
set costor=round((npr*ni*if(cmda='S',1,ndolar))+nflete,4);
UPDATE fe_art SET prec=npr,cost=npr*ni,prod_idau=cnd,ulpc=idp,tmon=cmda,ulfc=dfe,
prod_uact=nidusua,prod_dola=ndolar,prod_tigv=ni,prod_flet=nflete WHERE idart=cc;
update fe_epta as e set epta_cost=e.epta_cant*costor,epta_mone=cmda where epta_idar=cc and epta_acti='A';
update fe_epta as q set epta_prec=(q.epta_cost*(1+(epta_marg/100))) where epta_idar=cc and epta_acti='A';
update fe_epta as q set epta_pcor=(q.epta_cost*(1+(epta_mcor/100))) where epta_idar=cc and epta_acti='A';
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaPreciosVta` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaPreciosVta` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaPreciosVta`(prec1 decimal(10,2),prec2 decimal(10,2),nidus integer,ncoda integer)
begin
UPDATE fe_art SET premay=prec1,premen=prec2,prod_uact=nidus WHERE idart=ncoda;
End */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaPresentaciones` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaPresentaciones` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaPresentaciones`(cdesc varchar(60),ncant float,idp integer,opt integer)
BEGIN
if opt=0 then
   update fe_presentaciones set pres_acti='I' where pres_idpr=idp;
  else
   update fe_presentaciones set pres_desc=cdesc,pres_cant=ncant where pres_idpr=idp;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaProductos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaProductos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaProductos`(cdesc varchar(120),cunid varchar(15),nprec float,ncosto float,
npeso float,ccat integer,cmar integer,ctipro char,nflete decimal(10,6),cm char,cidpc varchar(45),
ncome float,ncomc float,nidusua integer,nsmin float,nsmax float,nidcosto integer,ndolar decimal(6,4),cuni1 varchar(15),
equi1 decimal(12,2),equi2 decimal(12,2),nigv decimal(6,4),ncoda integer,cesta char,nalma integer,ccodigo varchar(30),ccodigo2 varchar(15))
BEGIN
UPDATE fe_art SET descri=cdesc,unid=cunid,cost=ncosto,peso=npeso,idcat=ccat,idmar=cmar,tipro=ctipro,idflete=1,tmon=cm,
prec=nprec,prod_come=ncome,prod_comc=ncomc,prod_uact=nidusua,prod_fact=localtime,prod_smax=nsmax,
prod_smin=nsmin,prod_idco=nidcosto,prod_dola=ndolar,prod_unid1=cuni1,prod_equi1=equi1,prod_equi2=equi2,
prod_tigv=nigv,prod_acti=cesta,prod_alma=nalma,prod_cod1=ccodigo,prod_flet=nflete,prod_cod2=ccodigo2 WHERE idart=ncoda;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaPromciones` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaPromciones` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaPromciones`(nid integer)
begin
update fe_rpro set rpro_Acti='I',rpro_cond=0 where rpro_idrp=nid;
update fe_detpro set deta_acti='I' where deta_idpr=nid;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaPromociones` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaPromociones` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaPromociones`(nid integer)
begin
update fe_rpro set rpro_Acti='I',rpro_cond=0 where rpro_idrp=nid;
update fe_detpro set deta_acti='I' where deta_idpr=nid;
update fe_art set prod_idpc=0 where prod_idpc=nid;
update fe_art set prod_idpm=0 where prod_idpm=nid;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaProveedor` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaProveedor` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaProveedor`(nid integer,cruc varchar(11),crazo varchar(60),
cdire varchar(60),cciud varchar(50),cfono varchar(15),cfax varchar(15),
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

/*!50003 CREATE PROCEDURE `ProactualizaRBajas`(cticket VARCHAR(20),cmensaje VARCHAR(80),cdrxml longblob)
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

/*!50003 CREATE PROCEDURE `ProactualizaResumenBoletas`(cticket VARCHAR(20),cmensaje VARCHAR(80),cdrxml longblob)
BEGIN
UPDATE fe_resboletas SET resu_mens=cmensaje,resu_feen=CURDATE(),resu_cdr=cdrxml WHERE resu_tick=cticket;
END */$$
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

/*!50003 CREATE PROCEDURE `ProActualizaStock`(in coda integer,in nalma integer,in ccant float,in ctipo char(1),nequi float,ncaant float)
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
          UPDATE fe_art SET uno=((uno+ncaant)-(ccant*nequi)) WHERE idart=coda;
      end if;
      if nalma=2 then
          UPDATE fe_art SET dos=((dos+ncaant)-(ccant*nequi)) WHERE idart=coda;
      end if;
      if nalma=3 then
          UPDATE fe_art SET tre=((tre+ncaant)-(ccant*nequi)) WHERE idart=coda;
      end if;
      if nalma=4 then
          UPDATE fe_art SET cua=((cua+ncaant)-(ccant*nequi)) WHERE idart=coda;
     end if;
  end if;
END */$$
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

/* Procedure structure for procedure `ProActualizaUsuarios` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaUsuarios` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaUsuarios`(idc integer,idz integer)
BEGIN
update fe_gene set gene_idua=idc,gene_idue=idz where idgene=1;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaVendedorCliente` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaVendedorCliente` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaVendedorCliente`(nidcl integer,nidv integer)
BEGIN
update fe_clie set clie_codv=nidv where idclie=nidcl;
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

/* Procedure structure for procedure `ProActualizaZonas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaZonas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaZonas`(idc integer,idz integer)
BEGIN
update fe_clie set cliE_idzo=idz where idclie=idc;
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

/* Procedure structure for procedure `ProAnulaEntregaFisica` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaEntregaFisica` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaEntregaFisica`(na integer)
BEGIN
update fe_guias set guia_acti='I' where guia_idgui=na;
update fe_canjespg set capg_acti='I' where capg_idgu=na;
update fe_rcom set rcom_idgu=0 where rcom_idgu=na;
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

/* Procedure structure for procedure `ProAnulaPagosEmpleados1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaPagosEmpleados1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaPagosEmpleados1`(nid integer)
BEGIN
select igv from fe_gene where idgene=1;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaPdtesEntrega` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaPdtesEntrega` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaPdtesEntrega`(nid integer)
BEGIN
update fe_pdtes set pdte_acti='I' where pdte_idfau=nid;
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

/*!50003 CREATE PROCEDURE `ProAnulaTransacciones`(OUT estado varchar(500),in ctdoc varchar(2),in cndoc varchar(12),
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
   select @idclave:=idauto,@nidcodt:=codt from fe_rcom where tdoc=ctdoc and ndoc=cndoc and tipom =ctipo;
   set nid=@idclave;
  else
   set nid=nidauto;
   select @ct:=tdoc,@cn1:=ndoc,@df:=fech,@nidcodt:=codt from fe_rcom where idauto=nid;
end if;
if nid>0 then
    update fe_rcom set acti='I',idusua1=nu,rcom_idus=nu1 where idauto=nid;
    if ctipo='V' then
      update fe_ncven set ncre_acti='I' where ncre_idan=nid;
      update fe_rvendedor set vend_acti='I' where vend_idau=nid;
      update fe_guias set guia_acti='I' where guia_idau=nid;
      UPDATE fe_cred SET acti='I' WHERE cred_idrt=nid;
      update fe_canjesp set canp_acti='I' where canp_idau=nid;
   else
       update fe_nccom set ncre_acti='I' where ncre_idan=nid;
       update fe_guiac set guic_acti='I' where guic_idac=nid;
       update fe_guiac set guic_acti='I'  where guic_idau=nid;
       update fe_kar set gast=0 where kar_idk1=nid;
    end if;
end if;
if sw='S' and ctipo='V'  then
   if @ct='07' or @ct='08' then
       set cconcepto:=concat('01','E');
      else
       set cconcepto:=concat(trim(@ct),'E');
  end if;
  SELECT @nidconcepto:=idcon FROM fe_con WHERE tdoc=cconcepto AND tipo='I' AND conc_acti<>'I' GROUP BY idcon;
  call PROingresa_anulada(@df,@cn1,@ct,nu,@nidcodt);
end if;
set estado=null;
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

/* Procedure structure for procedure `ProAutorizaCreditoCliente` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAutorizaCreditoCliente` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAutorizaCreditoCliente`(nidcl integer,
nidus integer,opt integer)
BEGIN
if opt=1 then
   update fe_clie set clie_auto=1,clie_ucre=nidus where idclie=nidcl;
  else
   update fe_clie set clie_auto=0 where idclie=nidcl;
end if;
END */$$
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
    call Proastock1(ccoda,calma,tcompras-tventas,ct);
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
   update fe_rped set idclie=idclie1 where idclie=idclie0;
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
if trim(ct)="Marcas" then
   update fe_art set idmar=idclie1 where idmar=idclie0;
   update fe_mar set marc_acti='I' where idmar=idclie0;
   insert into fe_cambios(camb_fech,camb_idan,camb_idac,camb_tipo,camb_idus)
   values(localtime,idclie0,idclie1,"Marcas",nu);
end if;
if trim(ct)="Lineas" then
   update fe_art set idcat=idclie1 where idcat=idclie0;
   update fe_cat set line_acti='I' where idcat=idclie0;
   insert into fe_cambios(camb_fech,camb_idan,camb_idac,camb_tipo,camb_idus)
   values(localtime,idclie0,idclie1,"Lineas",nu);
end if;
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

/*!50003 CREATE PROCEDURE `PROCANCELADCTOSVENDEDOR`(idv integer,opt integer)
BEGIN
if opt=1 then
   update fe_rvendedor set vend_chek=1 where vend_idrv=idv;
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

/* Procedure structure for procedure `ProDesactivaCaja` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaCaja` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaCaja`(in nid integer)
BEGIN
update fe_caja set acti='I' where idcaja=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProDesactivaCajaPedidos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProDesactivaCajaPedidos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProDesactivaCajaPedidos`(nid integer)
BEGIN
update fe_caja set acti='I' where idauto=nid;
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
update fe_rcred set rcre_acti='A' where rcre_idrc=nid;
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

/*!50003 CREATE PROCEDURE `PRODSTOCKS`(nidart integer,nalma integer)
BEGIN
case
   when nalma=1 then
      select uno from fe_art where idart=nidart;
   when nalma=2 then
      select dos from fe_art where idart=nidart;
   when nalma=1 then
      select tre from fe_art where idart=nidart;
   else
      select cua from fe_art where idart=nidart;
end case;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PRODSTOCKSFab` */

/*!50003 DROP PROCEDURE IF EXISTS  `PRODSTOCKSFab` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PRODSTOCKSFab`(nidart integer,nalma integer)
BEGIN
case
   when nalma=1 then
      select uno from fe_art where idart=nidart;
   when nalma=2 then
      select dos from fe_art where idart=nidart;
   when nalma=1 then
      select tre from fe_art where idart=nidart;
   else
      select cua from fe_art where idart=nidart;
end case;
END */$$
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

/* Procedure structure for procedure `ProEditaFechas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProEditaFechas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProEditaFechas`(dfecha date,clote varchar(15),nid integer)
begin
update fe_fechas set fech_fvto=dfecha,fech_lote=clote where fech_idka=nid;
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

/* Procedure structure for procedure `ProGrabaGuiaenVentas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProGrabaGuiaenVentas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProGrabaGuiaenVentas`(nidauto integer,nidguia integer)
begin
update fe_rcom set rcom_idgu=nidguia where idauto=nidauto;
end */$$
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

/* Procedure structure for procedure `ProIngresaCanjePedidosG` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaCanjePedidosG` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaCanjePedidosG`(nidautog integer,nidautop integer)
begin
insert into fe_canjespg(capg_idgu,capg_idap)values(nidautog,nidautop);
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

/* Procedure structure for procedure `ProIngresaDatosLcajaE1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDatosLcajaE1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDatosLcajaE1`(dfecha date,cndoc varchar(10),cdeta varchar(180),idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),cmone char,ndolar decimal(5,3),nidus integer,nidcp integer,nidauto integer)
begin
insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,
lcaj_idus,lcaj_clpr,lcaj_idau)values
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,nidauto);
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDatosLcajaEefectivo` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDatosLcajaEefectivo` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDatosLcajaEefectivo`(dfecha date,cndoc varchar(12),cdeta varchar(180),
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

/*!50003 CREATE PROCEDURE `ProIngresaDatosLcajaEefectivo11`(dfecha date,cndoc varchar(10),cdeta varchar(180),idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),cmone char,ndolar decimal(5,3),nidus integer,nidcp integer,nidauto integer,cform char,
cdcto varchar(12),ctdoc varchar(2),nidtda integer)
begin
insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,
lcaj_idus,lcaj_clpr,lcaj_idau,lcaj_form,lcaj_dcto,lcaj_tdoc,lcaj_codt,lcaj_fope)values
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,nidauto,cform,cdcto,ctdoc,nidtda,localtime);
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDatosLcajaEefectivoAnulada` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDatosLcajaEefectivoAnulada` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDatosLcajaEefectivoAnulada`(dfecha date,cndoc varchar(12),cdeta varchar(120),
idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),cmone char,ndolar decimal(5,3),nidus integer,nidcp integer,nidauto integer,
cform char,cdcto char(15),ctdoc varchar(2),nidtda integer)
begin
insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,
lcaj_idus,lcaj_clpr,lcaj_idau,lcaj_form,lcaj_fope,lcaj_dcto,lcaj_tdoc,lcaj_codt)values
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,nidauto,cform,localtime,cdcto,ctdoc,nidtda);
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDatosLcajaEfectivo11` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDatosLcajaEfectivo11` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDatosLcajaEfectivo11`(dfecha date,cndoc varchar(10),cdeta varchar(180),idcta integer,sdeudor decimal(12,2),
sacreedor decimal(12,2),cmone char,ndolar decimal(5,3),nidus integer,nidcp integer,nidauto integer,cform char,
cdcto varchar(12),ctdoc varchar(2),nidtda integer)
begin
insert into fe_lcaja(lcaj_fech,lcaj_ndoc,lcaj_deta,lcaj_idct,lcaj_deud,lcaj_acre,lcaj_mone,lcaj_dola,
lcaj_idus,lcaj_clpr,lcaj_idau,lcaj_form,lcaj_dcto,lcaj_tdoc,lcaj_codt)values
(dfecha,cndoc,cdeta,idcta,sdeudor,sacreedor,cmone,ndolar,nidus,nidcp,nidauto,cform,cdcto,ctdoc,nidtda);
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaDetalleCompra` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaDetalleCompra` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaDetalleCompra`(nidkar integer,cfracm varchar(15),
cfracn varchar(15),nequi1 float,nequi2 float,nd1 float,nd2 float,nd3 float,nprec float)
BEGIN
insert into fe_detallec(detc_idkar,detc_fracm,detc_fracn,detc_equi1,detc_equi2,detc_dcto1,
detc_dcto2,detc_dcto3,detc_prec)values(nidkar,cfracm,cfracn,nequi1,nequi2,nd1,nd2,nd3,nprec);
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

/* Procedure structure for procedure `ProIngresaEntregaFisica` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaEntregaFisica` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaEntregaFisica`(nidk integer,nalma integer,ncant float,nidg integer)
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

/*!50003 CREATE PROCEDURE `ProIngresaEntregas`(ncant float,nidin integer,nidguia integer)
BEGIN
insert into fe_entregas(entr_cant,entr_idin,entr_idgu)values(ncant,nidin,nidguia);
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaFechas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaFechas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaFechas`(dfechav date,clote varchar(15),nidk integer)
begin
insert into fe_fechas(fech_fvto,fech_lote,fech_idka)values(dfechav,clote,nidk);
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaFleteAlCosto` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaFleteAlCosto` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaFleteAlCosto`(nidkar integer,ngasto decimal(8,2),nidauto integer)
begin
  update fe_kar set gast=ngasto,kar_idk1=nidauto where idkar=nidkar;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaGuiasCompras` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaGuiasCompras` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaGuiasCompras`(idp integer,nid integer,cndoc varchar(10),dfecha date,nidus integer)
begin
insert into fe_rgcompra(rgco_codp,rgco_fech,rgco_idus,rgco_idau,rgco_ndoc,rgco_fope)values(idp,dfecha,nidus,nid,cndoc,localtime());
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProINGRESAGUIASGC1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProINGRESAGUIASGC1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProINGRESAGUIASGC1`(nidau integer,nidkar integer,nidac integer)
BEGIN
declare id integer default 0;
insert into fe_guiac(guic_idau,guic_idka,guic_idac)
values(nidau,nidkar,nidac);
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProIngresaIDKardex` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaIDKardex` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaIDKardex`(nid integer)
begin
update fe_kar set kar_idkar=nid where idkar=nid;
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
cmotivo VARCHAR(50),cxml LONGBLOB ,cticket VARCHAR(15),carchivo VARCHAR(70),chash VARCHAR(30),nidauto INTEGER)
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
nigv DECIMAL(12,2),ngrati DECIMAL(12,2),cxml LONGBLOB,chash VARCHAR(30),carchivo VARCHAR(70),cticket VARCHAR(25))
BEGIN
DECLARE cnruc VARCHAR(11);
DECLARE ncodt INTEGER;
SET cnruc=SUBSTR(carchivo,19,11);
CASE
WHEN cnruc="20480781172" THEN
     SET ncodt=1;
WHEN cnruc="20602908667" THEN
     SET ncodt=2;
WHEN cnruc="20602908781" THEN
     SET ncodt=3;
WHEN cnruc="20602879560" THEN
     SET ncodt=4;
ELSE
     SET ncodt=1;
END CASE;
INSERT INTO fe_resboletas(resu_fech,resu_tdoc,resu_serie,resu_desd,resu_hast,resu_impo,resu_valo,resu_exon,resu_inaf,
resu_igv,resu_grat,resu_xml,resu_hash,resu_arch,resu_tick,resu_codt)
VALUES (dfecha,ctdoc,cserie,cdesde,chasta,nimpo,nvalor,nexon,ninafecta,nigv,ngrati,cxml,chash,carchivo,cticket,ncodt);
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

/*!50003 CREATE PROCEDURE `Proingresa_anulada`(dfecha Date,cndoc varchar(12),ctdoc varchar(2),nidus integer,nidcodt integer)
begin

 select @nc:=idclie from fe_clie where nruc='***********';

 insert into fe_rcom(idcliente,fech,fecr,ndoc,tdoc,tipom,deta,ndo2,tcom,form,mone,exon,fusua,idusua,codt)
 values(@nc,dfecha,dfecha,cndoc,ctdoc,'V','','','K','E','S',0,localtime,nidus,nidcodt);
 SELECT @na:=LAST_INSERT_ID() FROM fe_rcom group by LAST_INSERT_ID();
 Call ProIngresaDatosLcajaEefectivoAnulada(dfecha,"","*** ANULADA ***",0,0,0,'S',1,nidus,@nc,@na,'E',cndoc,ctdoc,nidcodt);
 
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
select dcon_deta, dcon_tipo, dcon_clav from sysvenl.fe_dconceptos;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
open cursor1;
repeat
    fetch cursor1 into m1,m2,m3;
    insert into sysvenl1.fe_dconceptos(dcon_deta, dcon_tipo, dcon_clav)values(m1,m2,m3);
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
select menu_text, menu_clav, menu_enla, menu_tipo from sysvenl.fe_menus;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
open cursor1;
repeat
    fetch cursor1 into m1,m2,m3,m4;
    insert into sysvenl1.fe_menus(menu_text, menu_clav, menu_enla, menu_tipo)values(m1,m2,m3,m4);
until done end repeat;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMostarMenu1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMostarMenu1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMostarMenu1`(nid varchar(5),ct char,nidus integer)
BEGIN
SELECT a.Menu_idme as iKey,a.Menu_text as Texto,a.menu_enla as Parent,a.menu_clav as clave from fe_menus a
inner join fe_opt b on b.opti_idme=a.menu_idme where menu_tipo='A' and b.opti_idus=nidus and b.opti_acti=1;
END */$$
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
SELECT * FROM fe_sucu where idalma=1 order by idalma;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PromuestraBancos` */

/*!50003 DROP PROCEDURE IF EXISTS  `PromuestraBancos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PromuestraBancos`(cb varchar(20))
BEGIN
declare cb1 varchar(20);
set cb1=concat('%',trim(cb),'%');
select banc_nomb,banc_idba from fe_bancos where banc_nomb like cb1 order by banc_nomb;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROMuestraClientes` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROMuestraClientes` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROMuestraClientes`(cbusca varchar(80),opt integer,nid integer)
BEGIN
declare cbuscar varchar(80);
set cbuscar=concat('%',trim(cbusca),+'%');
case
when opt=0 then
   select idclie,nruc,razo,ifnull(ndni,'')as ndni,dire,ciud,ifnull(fono,'0') as fono,ifnull(fax,'0') as fax,
   ifnull(celu,'0') as celu,refe,clie_tipo,clie_codv,clie_lcre,clie_corr,clie_rpm,clie_idus,clie_actu,
   fechclie,clie_feac,ifnull(c.zona_nomb,'') as Zona,ifnull(a.clie_idzo,0) as clie_idzo,codigo1,ifnull(v.nomv,'') as vendedor,
   clie_auto,clie_rete
   from fe_clie as a 
   left join fe_zona as c on c.zona_idzo=a.clie_idzo
   left join fe_vend as v on v.idven=a.clie_codv
   where  clie_acti<>'I' and razo like cbuscar order by codigo1,razo;
when opt=1 then
   select idclie,nruc,razo,ifnull(ndni,'') as ndni,dire,ciud,ifnull(fono,'0') as fono,ifnull(fax,'0') as fax,
   ifnull(celu,'0') as celu,refe,clie_tipo,clie_codv,clie_lcre,clie_corr,clie_rpm,clie_idus,clie_actu,
   fechclie,clie_feac,ifnull(c.zona_nomb,'') as Zona,ifnull(a.clie_idzo,0) as clie_idzo,codigo1,ifnull(v.nomv,'') as vendedor,
   clie_auto,clie_rete
   from fe_clie as a 
   left join fe_zona as c on c.zona_idzo=a.clie_idzo
   left join fe_vend as v on v.idven=a.clie_codv 
   where  clie_acti<>'I' and nruc like cbuscar order by codigo1,razo;
when opt=2 then
   select idclie,nruc,razo,ifnull(ndni,'') as ndni,dire,ciud,ifnull(fono,'0') as fono,ifnull(fax,'0') as fax,
   ifnull(celu,'0') as celu,refe,clie_tipo,clie_codv,clie_lcre,clie_corr,clie_rpm,clie_idus,clie_actu,
   fechclie,clie_feac,ifnull(c.zona_nomb,'') as Zona,ifnull(a.clie_idzo,0) as clie_idzo,codigo1,ifnull(v.nomv,'') as vendedor,
   clie_auto,clie_rete
   from fe_clie as a 
   left join fe_zona as c on c.zona_idzo=a.clie_idzo
   left join fe_vend as v on v.idven=a.clie_codv 
   where  clie_acti<>'I' and  ndni like cbuscar order by codigo1,razo;
when opt=3 then
   select idclie,nruc,razo,ifnull(ndni,'') as ndni,dire,ciud,ifnull(fono,'0') as fono,ifnull(fax,'0') as fax,
   ifnull(celu,'0') as celu,refe,clie_tipo,clie_codv,clie_lcre,clie_corr,clie_rpm,clie_idus,clie_actu,
   fechclie,clie_feac,ifnull(c.zona_nomb,'') as Zona,ifnull(a.clie_idzo,0) as clie_idzo,codigo1,ifnull(v.nomv,'') as vendedor,
   clie_auto,clie_rete
   from fe_clie as a 
   left join fe_zona as c on c.zona_idzo=a.clie_idzo
   left join fe_vend as v on v.idven=a.clie_codv 
   where  clie_acti<>'I' and idclie =nid order by codigo1,razo;
when opt=4 then
   select idclie,nruc,razo,ifnull(ndni,'') as ndni,dire,ciud,ifnull(fono,'0') as fono,ifnull(fax,'0') as fax,
   ifnull(celu,'0') as celu,refe,clie_tipo,clie_codv,clie_lcre,clie_corr,clie_rpm,clie_idus,clie_actu,
   fechclie,clie_feac,ifnull(c.zona_nomb,'') as Zona,ifnull(a.clie_idzo,0) as clie_idzo,codigo1,ifnull(v.nomv,'') as vendedor,
   clie_auto,clie_rete
   from fe_clie as a 
   left join fe_zona as c on c.zona_idzo=a.clie_idzo
   left join fe_vend as v on v.idven=a.clie_codv
   where  clie_acti<>'I' and ciud like cbuscar order by codigo1,razo;
when opt=5 then
   select idclie,nruc,razo,ifnull(ndni,'') as ndni,dire,ciud,ifnull(fono,'0') as fono,ifnull(fax,'0') as fax,
   ifnull(celu,'0') as celu,refe,clie_tipo,clie_codv,clie_lcre,clie_corr,clie_rpm,clie_idus,clie_actu,
   fechclie,clie_feac,ifnull(c.zona_nomb,'') as Zona,ifnull(a.clie_idzo,0) as clie_idzo,codigo1,ifnull(v.nomv,'') as vendedor,
   clie_auto,clie_rete
   from fe_clie as a 
   left join fe_zona as c on c.zona_idzo=a.clie_idzo 
   LEFT JOIN fe_vend AS v ON v.idven=a.clie_codv
   where  clie_acti<>'I' and ndni like cbuscar order by codigo1,razo;
when opt=6 then
   select idclie,nruc,razo,ifnull(ndni,'') as ndni,dire,ciud,ifnull(fono,'0') as fono,ifnull(fax,'0') as fax,
   ifnull(celu,'0') as celu,refe,clie_tipo,clie_codv,clie_lcre,clie_corr,clie_rpm,clie_idus,clie_actu,
   fechclie,clie_feac,ifnull(c.zona_nomb,'') as Zona,ifnull(a.clie_idzo,0) as clie_idzo,codigo1,ifnull(v.nomv,'') as vendedor,
   clie_auto,clie_rete
   from fe_clie as a 
   left join fe_zona as c on c.zona_idzo=a.clie_idzo
   left join fe_vend as v on v.idven=a.clie_codv 
   where  clie_acti<>'I' and codigo1 like cbuscar order by codigo1,razo;
when opt=7 then
   select idclie,nruc,razo,ifnull(ndni,'') as ndni,dire,ciud,ifnull(fono,'0') as fono,ifnull(fax,'0') as fax,
   ifnull(celu,'0') as celu,refe,clie_tipo,clie_codv,clie_lcre,clie_corr,clie_rpm,clie_idus,clie_actu,
   fechclie,clie_feac,ifnull(c.zona_nomb,'') as Zona,ifnull(a.clie_idzo,0) as clie_idzo,codigo1,ifnull(v.nomv,'') as vendedor,
   clie_auto,clie_rete
   from fe_clie as a 
   left join fe_zona as c on c.zona_idzo=a.clie_idzo
   left join fe_vend as v on v.idven=a.clie_codv 
   where  clie_acti<>'I' and c.zona_nomb like cbuscar order by codigo1,razo;
when opt=8 then
   select idclie,nruc,razo,ifnull(ndni,'') as ndni,dire,ciud,ifnull(fono,'0') as fono,ifnull(fax,'0') as fax,
   ifnull(celu,'0') as celu,refe,clie_tipo,clie_codv,clie_lcre,clie_corr,clie_rpm,clie_idus,clie_actu,
   fechclie,clie_feac,ifnull(c.zona_nomb,'') as Zona,ifnull(a.clie_idzo,0) as clie_idzo,codigo1,ifnull(v.nomv,'') as vendedor,
   clie_auto,clie_rete
   from fe_clie as a 
   left join fe_zona as c on c.zona_idzo=a.clie_idzo
   left join fe_vend as v on v.idven=a.clie_codv 
   where  clie_acti<>'I' and v.nomv like cbuscar order by codigo1,razo;
end case;
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
select a.ctas_ctas,b.banc_nomb,a.ctas_mone,a.ctas_deta,a.ctas_idct,a.ctas_idba,a.ctas_ncta from fe_ctasb as a
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
   select ncta,nomb,idcta,cdestinod,cdestinoh,tipocta,plan_oper from fe_plan where plan_acti='A'  and ncta like cb1 order by ncta;
  else
   select ncta,nomb,idcta,cdestinod,cdestinoh,tipocta,plan_oper from fe_plan where nomb like cb1  and plan_acti='A' order by ncta;
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
SELECT idflete,desflete,prec FROM fe_fletes WHERE desflete LIKE cbusca and flet_acti<>'I'  ORDER BY desflete;
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
   SELECT a.idcat,a.dcat,a.util1,a.util2,ifnull(count(b.idart),0) as Total_Productos,a.idgrupo
   FROM fe_cat as a left join fe_art as b on b.idcat=a.idcat
   WHERE dcat LIKE cbusca and line_acti<>'I'  group by a.idcat ORDER BY dcat;
  else
   SELECT a.idcat,a.dcat,a.util1,a.util2,ifnull(count(b.idart),0) as Total_Productos,a.idgrupo
   FROM fe_cat as a left join fe_art as b on b.idcat=a.idcat
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
fe_mar as a left join fe_art as b on b.idmar=a.idmar
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

/*!50003 CREATE PROCEDURE `ProMuestraPlanCuentas`(cb varchar(50),nid integer)
BEGIN
declare cb1 varchar(50);
set cb1=concat('%',trim(cb),'%');
SELECT ncta,idcta,nomb,cdestinod,cdestinoh,tipocta,plan_oper FROM fe_plan where ncta like cb1 and plan_acti='A'  ORDER BY ncta;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraPresentaciones` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraPresentaciones` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraPresentaciones`(cb varchar(60),idpr integer,opt integer)
BEGIN
declare cbuscar varchar(60);
if opt=1 then
  set cbuscar=concat('%',trim(cb),'%');
  select pres_desc,pres_cant,pres_idpr,pres_unid from fe_presentaciones where pres_desc like cbuscar and pres_acti='A' order by pres_desc;
 else
  select pres_desc,pres_cant,pres_idpr,pres_unid from fe_presentaciones where pres_idpr=idpr and pres_acti='A' order by pres_desc;
end if ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraPresentacionesP` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraPresentacionesP` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraPresentacionesP`(nd decimal(6,4))
BEGIN
SELECT a.pres_desc,b.epta_cost,b.epta_marg,b.epta_prec as epta_prec,epta_mcor,epta_pcor,
round(epta_comi*100,3) as epta_comi,epta_list,
if(b.epta_mone='S',round(b.epta_cost/((100-g.pmvtas)/100),2),round((b.epta_cost*nd)/((100-g.pmvtas)/100),2)) as precio1,
if(b.epta_mone='S',b.epta_cost,round(b.epta_cost*nd,2)) as costo,
b.epta_cant,b.epta_pres,b.epta_idar,b.epta_idep,b.epta_mone,b.epta_esti,b.epta_comi
FROM fe_epta as b  
inner JOIN fe_presentaciones as a  ON b.epta_pres=a.pres_idpr,fe_gene as g 
where b.epta_acti='A' and a.pres_acti='A' order by b.epta_cant;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraPresentacionesP1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraPresentacionesP1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraPresentacionesP1`(nidart INTEGER)
BEGIN
SELECT a.pres_desc,CAST(IF(p.tmon='S',(p.prec*g.igv*epta_cant),(p.prec*g.igv*g.dola*epta_cant))+p.prod_flet AS DECIMAL(10,4)) AS costo,b.epta_marg,
CAST(CEILING((IF(p.tmon='S',(p.prec*g.igv*epta_cant),(p.prec*g.igv*g.dola*epta_cant))+p.prod_flet)*(1+(epta_marg/100))*10)/10 AS DECIMAL(10,2)) AS epta_prec,
CAST(CEILING((IF(p.tmon='S',(p.prec*g.igv*epta_cant),(p.prec*g.igv*g.dola*epta_cant))+p.prod_flet)*(1+(epta_mcor/100))*10)/10 AS DECIMAL(10,2)) AS epta_pcor,
ROUND(epta_comi*100,3) AS epta_comi,epta_list,epta_mcor,
IF(b.epta_mone='S',ROUND(b.epta_cost/((100-g.pmvtas)/100),2),ROUND((b.epta_cost*g.dola)/((100-g.pmvtas)/100),2)) AS precio1,
IF(b.epta_mone='S',b.epta_cost,ROUND(b.epta_cost*g.dola,2)) AS costo,
b.epta_cant,b.epta_pres,b.epta_idar,b.epta_idep,b.epta_mone,b.epta_esti,b.epta_comi
FROM fe_epta AS b  
INNER JOIN fe_presentaciones AS a  ON b.epta_pres=a.pres_idpr
INNER JOIN (SELECT idart,prec,tmon,prod_flet FROM fe_art WHERE idart=nidart LIMIT 1) AS p ON p.idart=b.epta_idar,fe_gene AS g 
WHERE b.epta_acti='A' AND a.pres_acti='A' AND epta_idar=nidart ORDER BY b.epta_cant;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraPresentacionesXProducto` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraPresentacionesXProducto` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraPresentacionesXProducto`(nidart INTEGER,nd DECIMAL(6,4))
BEGIN
SELECT a.pres_desc,
CAST(IF(a.tmon='S',(((a.prec*yy.igv)+prod_flet)*epta_cant),(((a.prec*yy.igv*yy.dola)+prod_flet)*epta_cant)) AS DECIMAL(10,4)) AS costo,b.epta_marg,
CAST(CEILING((IF(a.tmon='S',(((a.prec*yy.igv)+prod_flet)*epta_cant),(((a.prec*yy.igv*yy.dola)+prod_flet)*epta_cant)))*(1+(epta_marg/100))*10)/10 AS DECIMAL(10,2)) AS epta_prec,
CAST(CEILING((IF(a.tmon='S',(((a.prec*yy.igv)+prod_flet)*epta_cant),(((a.prec*yy.igv*yy.dola)+prod_flet)*epta_cant)))*(1+(epta_mcor/100))*10)/10 AS DECIMAL(10,2)) AS epta_pcor,
ROUND(epta_prec*((yy.gene_cred/100)+1),2) AS preciocredito,
ROUND(epta_comi*100,3) AS epta_comi,epta_list,epta_mcor,
IF(b.epta_mone='S',ROUND(b.epta_cost/((100-yy.pmvtas)/100),2),ROUND((b.epta_cost*nd)/((100-yy.pmvtas)/100),2)) AS precio1,
IF(b.epta_mone='S',b.epta_cost,ROUND(b.epta_cost*nd,2)) AS cost,
b.epta_cant,b.epta_pres,b.epta_idar,b.epta_idep,b.epta_mone,b.epta_esti
FROM fe_epta  AS b 
INNER JOIN fe_presentaciones AS a ON a.pres_idpr=b.epta_pres
INNER JOIN (SELECT idart,prec,tmon,prod_flet FROM fe_art WHERE idart=nidart LIMIT 1) AS a ON a.idart=b.epta_idar,
fe_gene AS yy 
WHERE b.epta_acti='A' AND b.epta_idar=nidart ORDER BY b.epta_cant;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraProductos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraProductos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraProductos`(in abuscar varchar(80),in nd float)
BEGIN
declare cbuscar varchar(80);
declare vigv decimal(5,3);
set cbuscar=concat('%',trim(abuscar),+'%');
select igv into vigv from fe_gene group by idgene;
SELECT idart,descri,unid,prod_unid1,
cast(IF(uno>0,IF(MOD(uno,prod_equi1)=0,uno/prod_equi1,
if(mod(uno,prod_equi1)=0,uno div prod_equi1,truncate(uno/prod_equi1,0))),0.00) as decimal(12,2)) as prod_unim,
cast(IF(uno>0,IF(MOD(uno,prod_equi1)=0,0.00,MOD(uno,prod_equi1)),uno) as decimal(12,2)) as prod_unin,
cast(IF(dos>0,IF(MOD(dos,prod_equi1)=0,dos/prod_equi1,
if(mod(dos,prod_equi1)=0,dos div prod_equi1,truncate(dos/prod_equi1,0))),0.00) as decimal(12,2)) as prod_dunim,
cast(IF(dos>0,IF(MOD(dos,prod_equi1)=0,0.00,MOD(dos,prod_equi1)),dos) as decimal(12,2)) as prod_dunin,
cast(IF(tre>0,IF(MOD(tre,prod_equi1)=0,tre/prod_equi1,
if(mod(tre,prod_equi1)=0,tre div prod_equi1,truncate(tre/prod_equi1,0))),0.00) as decimal(12,2)) as prod_tunim,
cast(IF(tre>0,IF(MOD(tre,prod_equi1)=0,0.00,MOD(tre,prod_equi1)),tre) as decimal(12,2)) as prod_tunin,
cast(IF(cua>0,IF(MOD(cua,prod_equi1)=0,cua/prod_equi1,
if(mod(cua,prod_equi1)=0,cua div prod_equi1,truncate(cua/prod_equi1,0))),0.00) as decimal(12,2)) as prod_cunim,
cast(IF(cua>0,IF(MOD(cua,prod_equi1)=0,0.00,MOD(cua,prod_equi1)),cua) as decimal(12,2)) as prod_cunin,
round(if(tmon='S',(a.prec*prod_tigv)+b.prec,(a.prec*prod_tigv*nd)+b.prec),2) as costo,c.idgrupo,c.dcat,
ifnull(round(if(tmon='S',premay,((a.prec*prod_tigv*nd)+b.prec)*prod_uti3),2),0) as pre1,
ifnull(round(if(tmon='S',premen,((a.prec*prod_tigv*nd)+b.prec)*prod_uti2),2),0) as pre2,
ifnull(round(if(tmon='S',pre3,((a.prec*prod_tigv*nd)+b.prec)*prod_uti1),2),0) as pre3,prod_tigv,prod_alma,
round(if(tmon='S',(a.prec*prod_tigv),(a.prec*prod_tigv*nd)),2) as costosf,b.prec as flete,ulfc,uno,dos,tre,cua,
ifnull(d.cost_cost,0) as costor,ifnull(d.cost_prec,0) as precr,ifnull(d.cost_mone,'')  as moner,
cast(ifnull(d.cost_idco,0) as unsigned) as cost_idco,ifnull(d.cost_flet,0)  as fleter,ifnull(d.cost_dola,0) as dolar,
peso,a.prec,tipro,idmar,a.idcat,cost,tmon,a.idflete,prod_uti1,prod_uti2,prod_uti3,prod_idus,prod_equi1,prod_equi2,
prod_come,prod_comc,ulpc,prod_idus,prod_uact,prod_fact,fechc,prod_smax,prod_smin,ifnull(o.razo,'') as proveedor,
ifnull(y.ndoc,'') as ndoc,ifnull(y.fech,'') as fech
FROM fe_art  as a inner join fe_fletes as b on(b.idflete=a.idflete)
inner join fe_cat as c on(c.idcat=a.idcat) left join fe_costos as d on(d.cost_idco=a.prod_idco)
left join fe_rcom as y on (y.idauto=a.prod_idau) left join fe_prov as o on (o.idprov=y.idprov)
WHERE descri LIKE cbuscar and prod_acti<>'I' ORDER BY DESCRI;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraProductosJx` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraProductosJx` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraProductosJx`(abuscar varchar(80),nd decimal(5,2),opt integer,nid float)
BEGIN
declare cbuscar varchar(80);
declare cbuscar1 varchar(80);
declare vigv decimal(5,3);
select igv into vigv from fe_gene group by idgene;
case
when opt=1 then
  set cbuscar=concat('%',trim(abuscar),+'%');
  SELECT idart,descri,unid,prod_unid1,
  cast(IF(uno>0,IF(MOD(uno,prod_equi2)=0,uno/prod_equi2,
  if(mod(uno,prod_equi2)=0,uno div prod_equi2,truncate(uno/prod_equi2,0))),0.00) as decimal(12,2)) as prod_unim,
  cast(IF(uno>0,IF(MOD(uno,prod_equi2)=0,0.00,MOD(uno,prod_equi2)),uno) as decimal(12,2)) as prod_unin,
  cast(IF(dos>0,IF(MOD(dos,prod_equi1)=0,dos/prod_equi1,
  if(mod(dos,prod_equi1)=0,dos div prod_equi1,truncate(dos/prod_equi1,0))),0.00) as decimal(12,2)) as prod_dunim,
  cast(IF(dos>0,IF(MOD(dos,prod_equi1)=0,0.00,MOD(dos,prod_equi1)),dos) as decimal(12,2)) as prod_dunin,
  cast(IF(tre>0,IF(MOD(tre,prod_equi1)=0,tre/prod_equi1,
  if(mod(tre,prod_equi1)=0,tre div prod_equi1,truncate(tre/prod_equi1,0))),0.00) as decimal(12,2)) as prod_tunim,
  cast(IF(tre>0,IF(MOD(tre,prod_equi1)=0,0.00,MOD(tre,prod_equi1)),tre) as decimal(12,2)) as prod_tunin,
  cast(IF(cua>0,IF(MOD(cua,prod_equi1)=0,cua/prod_equi1,
  if(mod(cua,prod_equi1)=0,cua div prod_equi1,truncate(cua/prod_equi1,0))),0.00) as decimal(12,2)) as prod_cunim,
  cast(IF(cua>0,IF(MOD(cua,prod_equi1)=0,0.00,MOD(cua,prod_equi1)),cua) as decimal(12,2)) as prod_cunin,
  round(if(tmon='S',(a.prec*prod_tigv)+prod_flet,(a.prec*prod_tigv*nd)+prod_flet),4) as costo,c.idgrupo,c.dcat,
  ifnull(round(if(tmon='S',premay,((a.prec*prod_tigv*nd)+b.prec)*prod_uti3),2),0) as pre1,
  ifnull(round(if(tmon='S',premen,((a.prec*prod_tigv*nd)+b.prec)*prod_uti2),2),0) as pre2,
  ifnull(round(if(tmon='S',pre3,((a.prec*prod_tigv*nd)+b.prec)*prod_uti1),2),0) as pre3,prod_tigv,
  round(if(tmon='S',(a.prec*prod_tigv),(a.prec*prod_tigv*nd)),2) as costosf,prod_flet as flete,ulfc,uno,dos,tre,cua,
  ifnull(d.cost_cost,0) as costor,ifnull(d.cost_prec,0) as precr,ifnull(d.cost_mone,'')  as moner,
  cast(ifnull(d.cost_idco,0) as unsigned) as cost_idco,ifnull(d.cost_flet,0)  as fleter,ifnull(d.cost_dola,0) as dolar,
  peso,a.prec,tipro,idmar,a.idcat,cost,tmon,a.idflete,prod_uti1,prod_uti2,prod_uti3,prod_idus,prod_equi1,prod_equi2,
  prod_come,prod_comc,ulpc,prod_idus,prod_uact,prod_fact,fechc,prod_smax,prod_smin,ifnull(o.razo,'') as proveedor,
  ifnull(y.ndoc,'') as ndoc,ifnull(y.fech,'') as fech,prod_idpc,prod_idpm,prod_cod1,prod_acti,prod_alma,prod_cod2
  FROM fe_art  as a inner join fe_fletes as b on(b.idflete=a.idflete)
  inner join fe_cat as c on(c.idcat=a.idcat) left join fe_costos as d on(d.cost_idco=a.prod_idco)
  left join fe_rcom as y on (y.idauto=a.prod_idau) left join fe_prov as o on (o.idprov=y.idprov)
  WHERE descri LIKE cbuscar and prod_acti<>'I' ORDER BY DESCRI;
when opt=0 then
  set cbuscar=concat('%',trim(cast(nid as char)),'%');
  set cbuscar1=concat('%',trim(abuscar),+'%');
  SELECT idart,descri,unid,prod_unid1,
  cast(IF(uno>0,IF(MOD(uno,prod_equi2)=0,uno/prod_equi2,
  if(mod(uno,prod_equi2)=0,uno div prod_equi2,truncate(uno/prod_equi2,0))),0.00) as decimal(12,2)) as prod_unim,
  cast(IF(uno>0,IF(MOD(uno,prod_equi2)=0,0.00,MOD(uno,prod_equi2)),uno) as decimal(12,2)) as prod_unin,
  cast(IF(dos>0,IF(MOD(dos,prod_equi1)=0,dos/prod_equi1,
  if(mod(dos,prod_equi1)=0,dos div prod_equi1,truncate(dos/prod_equi1,0))),0.00) as decimal(12,2)) as prod_dunim,
  cast(IF(dos>0,IF(MOD(dos,prod_equi1)=0,0.00,MOD(dos,prod_equi1)),dos) as decimal(12,2)) as prod_dunin,
  cast(IF(tre>0,IF(MOD(tre,prod_equi1)=0,tre/prod_equi1,
  if(mod(tre,prod_equi1)=0,tre div prod_equi1,truncate(tre/prod_equi1,0))),0.00) as decimal(12,2)) as prod_tunim,
  cast(IF(tre>0,IF(MOD(tre,prod_equi1)=0,0.00,MOD(tre,prod_equi1)),tre) as decimal(12,2)) as prod_tunin,
  cast(IF(cua>0,IF(MOD(cua,prod_equi1)=0,cua/prod_equi1,
  if(mod(cua,prod_equi1)=0,cua div prod_equi1,truncate(cua/prod_equi1,0))),0.00) as decimal(12,2)) as prod_cunim,
  cast(IF(cua>0,IF(MOD(cua,prod_equi1)=0,0.00,MOD(cua,prod_equi1)),cua) as decimal(12,2)) as prod_cunin,
  round(if(tmon='S',(a.prec*prod_tigv)+prod_flet,(a.prec*prod_tigv*nd)+prod_flet),4) as costo,c.idgrupo,c.dcat,
  ifnull(round(if(tmon='S',premay,((a.prec*prod_tigv*nd)+b.prec)*prod_uti3),2),0) as pre1,
  ifnull(round(if(tmon='S',premen,((a.prec*prod_tigv*nd)+b.prec)*prod_uti2),2),0) as pre2,
  ifnull(round(if(tmon='S',pre3,((a.prec*prod_tigv*nd)+b.prec)*prod_uti1),2),0) as pre3,prod_tigv,
  round(if(tmon='S',(a.prec*prod_tigv),(a.prec*prod_tigv*nd)),2) as costosf,prod_flet as flete,ulfc,uno,dos,tre,cua,
  ifnull(d.cost_cost,0) as costor,ifnull(d.cost_prec,0) as precr,ifnull(d.cost_mone,'')  as moner,
  cast(ifnull(d.cost_idco,0) as unsigned) as cost_idco,ifnull(d.cost_flet,0)  as fleter,ifnull(d.cost_dola,0) as dolar,
  peso,a.prec,tipro,idmar,a.idcat,cost,tmon,a.idflete,prod_uti1,prod_uti2,prod_uti3,prod_idus,prod_equi1,prod_equi2,
  prod_come,prod_comc,ulpc,prod_idus,prod_uact,prod_fact,fechc,prod_smax,prod_smin,ifnull(o.razo,'') as proveedor,
  ifnull(y.ndoc,'') as ndoc,ifnull(y.fech,'') as fech,prod_idpc,prod_idpm,prod_cod1,prod_acti,prod_alma,prod_cod2
  FROM fe_art  as a inner join fe_fletes as b on(b.idflete=a.idflete)
  inner join fe_cat as c on(c.idcat=a.idcat) left join fe_costos as d on(d.cost_idco=a.prod_idco)
  left join fe_rcom as y on (y.idauto=a.prod_idau) left join fe_prov as o on (o.idprov=y.idprov)
  WHERE prod_cod1  like cbuscar1  and prod_acti<>'I' ORDER BY DESCRI;
when opt=2 then
  set cbuscar=concat('%',trim(cast(nid as char)),'%');
  set cbuscar1=concat('%',trim(abuscar),+'%');
  SELECT idart,descri,unid,prod_unid1,
  cast(IF(uno>0,IF(MOD(uno,prod_equi2)=0,uno/prod_equi2,
  if(mod(uno,prod_equi2)=0,uno div prod_equi2,truncate(uno/prod_equi2,0))),0.00) as decimal(12,2)) as prod_unim,
  cast(IF(uno>0,IF(MOD(uno,prod_equi2)=0,0.00,MOD(uno,prod_equi2)),uno) as decimal(12,2)) as prod_unin,
  cast(IF(dos>0,IF(MOD(dos,prod_equi1)=0,dos/prod_equi1,
  if(mod(dos,prod_equi1)=0,dos div prod_equi1,truncate(dos/prod_equi1,0))),0.00) as decimal(12,2)) as prod_dunim,
  cast(IF(dos>0,IF(MOD(dos,prod_equi1)=0,0.00,MOD(dos,prod_equi1)),dos) as decimal(12,2)) as prod_dunin,
  cast(IF(tre>0,IF(MOD(tre,prod_equi1)=0,tre/prod_equi1,
  if(mod(tre,prod_equi1)=0,tre div prod_equi1,truncate(tre/prod_equi1,0))),0.00) as decimal(12,2)) as prod_tunim,
  cast(IF(tre>0,IF(MOD(tre,prod_equi1)=0,0.00,MOD(tre,prod_equi1)),tre) as decimal(12,2)) as prod_tunin,
  cast(IF(cua>0,IF(MOD(cua,prod_equi1)=0,cua/prod_equi1,
  if(mod(cua,prod_equi1)=0,cua div prod_equi1,truncate(cua/prod_equi1,0))),0.00) as decimal(12,2)) as prod_cunim,
  cast(IF(cua>0,IF(MOD(cua,prod_equi1)=0,0.00,MOD(cua,prod_equi1)),cua) as decimal(12,2)) as prod_cunin,
  round(if(tmon='S',(a.prec*prod_tigv)+prod_flet,(a.prec*prod_tigv*nd)+prod_flet),4) as costo,c.idgrupo,c.dcat,
  ifnull(round(if(tmon='S',premay,((a.prec*prod_tigv*nd)+b.prec)*prod_uti3),2),0) as pre1,
  ifnull(round(if(tmon='S',premen,((a.prec*prod_tigv*nd)+b.prec)*prod_uti2),2),0) as pre2,
  ifnull(round(if(tmon='S',pre3,((a.prec*prod_tigv*nd)+b.prec)*prod_uti1),2),0) as pre3,prod_tigv,
  round(if(tmon='S',(a.prec*prod_tigv),(a.prec*prod_tigv*nd)),2) as costosf,prod_flet as flete,ulfc,uno,dos,tre,cua,
  ifnull(d.cost_cost,0) as costor,ifnull(d.cost_prec,0) as precr,ifnull(d.cost_mone,'')  as moner,
  cast(ifnull(d.cost_idco,0) as unsigned) as cost_idco,ifnull(d.cost_flet,0)  as fleter,ifnull(d.cost_dola,0) as dolar,
  peso,a.prec,tipro,idmar,a.idcat,cost,tmon,a.idflete,prod_uti1,prod_uti2,prod_uti3,prod_idus,prod_equi1,prod_equi2,
  prod_come,prod_comc,ulpc,prod_idus,prod_uact,prod_fact,fechc,prod_smax,prod_smin,ifnull(o.razo,'') as proveedor,
  ifnull(y.ndoc,'') as ndoc,ifnull(y.fech,'') as fech,prod_idpc,prod_idpm,prod_cod1,prod_acti,prod_alma,prod_cod2
  FROM fe_art  as a inner join fe_fletes as b on(b.idflete=a.idflete)
  inner join fe_cat as c on(c.idcat=a.idcat) left join fe_costos as d on(d.cost_idco=a.prod_idco)
  left join fe_rcom as y on (y.idauto=a.prod_idau) left join fe_prov as o on (o.idprov=y.idprov)
  WHERE prod_cod2  like cbuscar1  and prod_acti<>'I' ORDER BY DESCRI;
end case ;
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

/* Procedure structure for procedure `ProMuestraTodosLosProductos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraTodosLosProductos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraTodosLosProductos`(in abuscar varchar(80),in nd float)
BEGIN
declare cbuscar varchar(80);
set cbuscar=concat('%',trim(abuscar),+'%');
SELECT idart,descri,unid,uno,dos,tre,cua,
ifnull(round(if(tmon='S',((a.prec*prod_tigv)+b.prec)*prod_uti1,((a.prec*prod_tigv*if(prod_dola>0,prod_dola,nd))+b.prec)*prod_uti1),2),0) as pre1,
ifnull(round(if(tmon='S',((a.prec*prod_tigv)+b.prec)*prod_uti2,((a.prec*prod_tigv*if(prod_dola>0,prod_dola,nd))+b.prec)*prod_uti2),2),0) as pre2,
ifnull(round(if(tmon='S',((a.prec*prod_tigv)+b.prec)*prod_uti3,((a.prec*prod_tigv*if(prod_dola>0,prod_dola,nd))+b.prec)*prod_uti3),2),0) as pre3,
round(if(tmon='S',(a.prec*prod_tigv)+b.prec,(a.prec*prod_tigv*nd)+b.prec),2) as costo,c.idgrupo,c.dcat,prod_dola,
round(if(tmon='S',(a.prec*prod_tigv),(a.prec*prod_tigv*nd)),2) as costosf,b.prec as flete,a.prod_acti,prod_tigv,
ifnull(d.cost_cost,0) as costor,ifnull(d.cost_prec,0) as precr,ifnull(d.cost_mone,'')  as moner,
cast(ifnull(d.cost_idco,0) as unsigned) as cost_idco,ifnull(d.cost_flet,0)  as fleter,ifnull(d.cost_dola,0) as dolar,
peso,a.prec,tipro,idmar,a.idcat,cost,tmon,a.idflete,prod_uti1,prod_uti2,prod_uti3,prod_idus,
prod_come,prod_comc,ulpc,prod_idus,prod_uact,prod_fact,fechc,prod_smax,prod_smin,ifnull(o.razo,'') as proveedor,
ifnull(y.ndoc,'') as ndoc,ifnull(y.fech,'') as fech,ulfc
FROM fe_art  as a inner join fe_fletes as b on(b.idflete=a.idflete)
inner join fe_cat as c on(c.idcat=a.idcat) left join fe_costos as d on(d.cost_idco=a.prod_idco)
left join fe_rcom as y on (y.idauto=a.prod_idau) left join fe_prov as o on (o.idprov=y.idprov)
WHERE descri LIKE cbuscar ORDER BY DESCRI;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraTProductos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraTProductos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraTProductos`(in abuscar varchar(80),in nd float)
BEGIN
declare cbuscar varchar(80);
declare vigv decimal(5,3);
set cbuscar=concat('%',trim(abuscar),+'%');
select igv into vigv from fe_gene group by idgene;
SELECT idart,descri,unid,prod_unid1,
cast(IF(uno>0,IF(MOD(uno,prod_equi1)=0,uno/prod_equi1,
if(mod(uno,prod_equi1)=0,uno div prod_equi1,truncate(uno/prod_equi1,0))),0.00) as decimal(12,2)) as prod_unim,
cast(IF(uno>0,IF(MOD(uno,prod_equi1)=0,0.00,MOD(uno,prod_equi1)),uno) as decimal(12,2)) as prod_unin,
cast(IF(dos>0,IF(MOD(dos,prod_equi1)=0,dos/prod_equi1,
if(mod(dos,prod_equi1)=0,dos div prod_equi1,truncate(dos/prod_equi1,0))),0.00) as decimal(12,2)) as prod_dunim,
cast(IF(dos>0,IF(MOD(dos,prod_equi1)=0,0.00,MOD(dos,prod_equi1)),dos) as decimal(12,2)) as prod_dunin,
cast(IF(tre>0,IF(MOD(tre,prod_equi1)=0,tre/prod_equi1,
if(mod(tre,prod_equi1)=0,tre div prod_equi1,truncate(tre/prod_equi1,0))),0.00) as decimal(12,2)) as prod_tunim,
cast(IF(tre>0,IF(MOD(tre,prod_equi1)=0,0.00,MOD(tre,prod_equi1)),tre) as decimal(12,2)) as prod_tunin,
cast(IF(cua>0,IF(MOD(cua,prod_equi1)=0,cua/prod_equi1,
if(mod(cua,prod_equi1)=0,cua div prod_equi1,truncate(cua/prod_equi1,0))),0.00) as decimal(12,2)) as prod_cunim,
cast(IF(cua>0,IF(MOD(cua,prod_equi1)=0,0.00,MOD(cua,prod_equi1)),cua) as decimal(12,2)) as prod_cunin,
round(if(tmon='S',(a.prec*prod_tigv)+b.prec,(a.prec*prod_tigv*nd)+b.prec),2) as costo,c.idgrupo,c.dcat,
ifnull(round(if(tmon='S',premay,((a.prec*prod_tigv*nd)+b.prec)*prod_uti3),2),0) as pre1,
ifnull(round(if(tmon='S',premen,((a.prec*prod_tigv*nd)+b.prec)*prod_uti2),2),0) as pre2,
ifnull(round(if(tmon='S',pre3,((a.prec*prod_tigv*nd)+b.prec)*prod_uti1),2),0) as pre3,prod_tigv,prod_acti,
round(if(tmon='S',(a.prec*prod_tigv),(a.prec*prod_tigv*nd)),2) as costosf,b.prec as flete,ulfc,uno,dos,tre,cua,
ifnull(d.cost_cost,0) as costor,ifnull(d.cost_prec,0) as precr,ifnull(d.cost_mone,'')  as moner,prod_alma,
cast(ifnull(d.cost_idco,0) as unsigned) as cost_idco,ifnull(d.cost_flet,0)  as fleter,ifnull(d.cost_dola,0) as dolar,
peso,a.prec,tipro,idmar,a.idcat,cost,tmon,a.idflete,prod_uti1,prod_uti2,prod_uti3,prod_idus,prod_equi1,prod_equi2,
prod_come,prod_comc,ulpc,prod_idus,prod_uact,prod_fact,fechc,prod_smax,prod_smin,ifnull(o.razo,'') as proveedor,
ifnull(y.ndoc,'') as ndoc,ifnull(y.fech,'') as fech,prod_cod1
FROM fe_art  as a inner join fe_fletes as b on(b.idflete=a.idflete)
inner join fe_cat as c on(c.idcat=a.idcat) left join fe_costos as d on(d.cost_idco=a.prod_idco)
left join fe_rcom as y on (y.idauto=a.prod_idau) left join fe_prov as o on (o.idprov=y.idprov)
WHERE descri LIKE cbuscar and prod_Acti='A' ORDER BY DESCRI;
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
   select nomb,tipo,activo,idusua,0 as Uno,1 as uno,2 as dos,3 as tres,clave,idalma from fe_usua where nomb like cbuscar;
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
select nomv,idven from fe_vend where nomv like cbuscar and vend_acti<>'I' order by nomv;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraVendedoresTodos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraVendedoresTodos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraVendedoresTodos`(cbusca varchar(20))
BEGIN
declare cbuscar varchar(80);
set cbuscar=concat('%',trim(cbusca),+'%');
select nomv,idven from(select ' Todos' as nomv,cast(-1 as unsigned) as idven
union all
select nomv,idven from fe_vend where vend_acti<>'I') as x  where x.nomv like cbuscar order by nomv;
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

/*!50003 CREATE PROCEDURE `ProOtorgaOpciones`(nidop integer,nidacti integer)
begin
update fe_opt set opti_acti=nidacti where opti_idop=nidop;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProRegistraPeridoRetencion` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProRegistraPeridoRetencion` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProRegistraPeridoRetencion`(nidauto integer,cperiodo varchar(20))
begin
  update fe_rcom set rcom_pert=cperiodo where idauto=nidauto;
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
alter table fe_docom Auto_increment=1 ;
delete from fe_rocom;
alter table fe_rocom Auto_increment=1 ;
delete from fe_rvendedor;
alter table fe_rvendedor Auto_increment=1 ;
delete from fe_kar;
alter table fe_kar Auto_increment=1 ;
delete from fe_rcom;
alter table fe_rcom Auto_increment=1 ;
delete from fe_cred;
alter table fe_cred Auto_increment=1 ;
delete from fe_rcred;
alter table fe_rcred Auto_increment=1 ;
delete from fe_ent;
alter table fe_ent Auto_increment=1 ;
delete from fe_caja;
alter table fe_caja Auto_increment=1 ;
delete from fe_deu;
alter table fe_deu Auto_increment=1;
delete from fe_rdeu;
alter table fe_rdeu Auto_increment=1;
delete from fe_guiac;
alter table fe_guiac Auto_increment=1 ;
delete from fe_nccom;
alter table fe_nccom Auto_increment=1;
delete from fe_ncven;
alter table fe_ncven Auto_increment=1 ;
delete from fe_cambiosvtas;
alter table fe_cambiosvtas Auto_increment=1;
delete from fe_ped;
alter table fe_ped Auto_increment=1 ;
delete from fe_rped;
alter table fe_rped Auto_increment=1 ;
delete from fe_costos;
alter table fe_costos Auto_increment=1 ;
delete from fe_art;
alter table fe_art Auto_increment=1 ;
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
delete from fe_usua;
alter table fe_usua Auto_increment=1 ;
delete from fe_serie;
alter table fe_serie Auto_increment=1 ;
delete from fe_sucu;
alter table fe_sucu Auto_increment=1 ;
delete from fe_vend;
alter table fe_vend Auto_increment=1 ;
delete from fe_con;
alter table fe_con Auto_increment=1 ;
delete from fe_tra;
alter table fe_tra Auto_increment=1 ;
delete from fe_tdoc;
alter table fe_tdoc Auto_increment=1 ;
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

/* Procedure structure for procedure `ProUltimoPrecioVenta` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProUltimoPrecioVenta` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProUltimoPrecioVenta`(nidcl integer,nidart integer)
BEGIN
select max(a.fech),ifnull(b.prec,0) as precio from fe_kar as b inner join fe_rcom as a on a.idauto=b.idauto where a.idcliente=nidcl
and b.idart=nidart;
END */$$
DELIMITER ;

/*Table structure for table `rvendedores` */

DROP TABLE IF EXISTS `rvendedores`;

/*!50001 DROP VIEW IF EXISTS `rvendedores` */;
/*!50001 DROP TABLE IF EXISTS `rvendedores` */;

/*!50001 CREATE TABLE  `rvendedores`(
 `idauto` int ,
 `codv` int 
)*/;

/*Table structure for table `vcambio` */

DROP TABLE IF EXISTS `vcambio`;

/*!50001 DROP VIEW IF EXISTS `vcambio` */;
/*!50001 DROP TABLE IF EXISTS `vcambio` */;

/*!50001 CREATE TABLE  `vcambio`(
 `nomb` varchar(45) ,
 `fusua` datetime ,
 `descri` varchar(150) ,
 `unid` varchar(15) ,
 `camb_cant` float ,
 `camb_prec` float ,
 `importe` double ,
 `camb_idac` int ,
 `camb_fope` datetime 
)*/;

/*Table structure for table `vcambioactual` */

DROP TABLE IF EXISTS `vcambioactual`;

/*!50001 DROP VIEW IF EXISTS `vcambioactual` */;
/*!50001 DROP TABLE IF EXISTS `vcambioactual` */;

/*!50001 CREATE TABLE  `vcambioactual`(
 `ndoc` varchar(12) ,
 `tdoc` varchar(2) ,
 `razo` varchar(120) ,
 `impo` decimal(12,2) ,
 `nomb` varchar(45) ,
 `fusua` datetime ,
 `descri` varchar(150) ,
 `unid` varchar(15) ,
 `cant` decimal(14,2) ,
 `prec` decimal(14,8) ,
 `importe` decimal(21,2) ,
 `camb_idac` int ,
 `camb_idaa` int ,
 `camb_fope` datetime ,
 `fech` date ,
 `idauto` int 
)*/;

/*Table structure for table `vcambioanterior` */

DROP TABLE IF EXISTS `vcambioanterior`;

/*!50001 DROP VIEW IF EXISTS `vcambioanterior` */;
/*!50001 DROP TABLE IF EXISTS `vcambioanterior` */;

/*!50001 CREATE TABLE  `vcambioanterior`(
 `ndoc` varchar(12) ,
 `tdoc` varchar(2) ,
 `razo` varchar(120) ,
 `impo` decimal(12,2) ,
 `nomb` varchar(45) ,
 `fusua` datetime ,
 `descri` varchar(150) ,
 `unid` varchar(15) ,
 `cant` decimal(14,2) ,
 `prec` decimal(14,8) ,
 `importe` decimal(21,2) ,
 `camb_idaa` int ,
 `camb_fope` datetime ,
 `idauto` int ,
 `acti` char(1) 
)*/;

/*Table structure for table `vcomisiones` */

DROP TABLE IF EXISTS `vcomisiones`;

/*!50001 DROP VIEW IF EXISTS `vcomisiones` */;
/*!50001 DROP TABLE IF EXISTS `vcomisiones` */;

/*!50001 CREATE TABLE  `vcomisiones`(
 `idauto` int ,
 `ndoc` varchar(12) ,
 `fech` date ,
 `mone` varchar(1) ,
 `impo` decimal(12,2) ,
 `form` varchar(1) ,
 `comision` double 
)*/;

/*Table structure for table `vdvtas` */

DROP TABLE IF EXISTS `vdvtas`;

/*!50001 DROP VIEW IF EXISTS `vdvtas` */;
/*!50001 DROP TABLE IF EXISTS `vdvtas` */;

/*!50001 CREATE TABLE  `vdvtas`(
 `kar_comi` float ,
 `cant` decimal(14,2) ,
 `prec` decimal(14,8) ,
 `idauto` int ,
 `alma` int ,
 `idart` int ,
 `kar_unid` varchar(60) ,
 `descri` varchar(150) ,
 `dcat` varchar(45) ,
 `idcat` int ,
 `idmar` int ,
 `dmar` varchar(45) ,
 `prod_equi1` decimal(8,2) ,
 `prod_equi2` decimal(8,2) ,
 `unid` varchar(15) ,
 `prod_unid1` varchar(15) ,
 `prod_cod1` varchar(30) ,
 `kar_equi` decimal(8,2) 
)*/;

/*Table structure for table `vguiascompras` */

DROP TABLE IF EXISTS `vguiascompras`;

/*!50001 DROP VIEW IF EXISTS `vguiascompras` */;
/*!50001 DROP TABLE IF EXISTS `vguiascompras` */;

/*!50001 CREATE TABLE  `vguiascompras`(
 `guic_idau` int unsigned ,
 `guic_tipo` char(1) ,
 `guic_idac` bigint 
)*/;

/*Table structure for table `vguiasdevolucion` */

DROP TABLE IF EXISTS `vguiasdevolucion`;

/*!50001 DROP VIEW IF EXISTS `vguiasdevolucion` */;
/*!50001 DROP TABLE IF EXISTS `vguiasdevolucion` */;

/*!50001 CREATE TABLE  `vguiasdevolucion`(
 `idguia` int unsigned ,
 `coda` int ,
 `descri` varchar(150) ,
 `unid` varchar(15) ,
 `ndoc` varchar(12) ,
 `fech` date ,
 `fect` date ,
 `ptoll` varchar(180) ,
 `detalle` varchar(150) ,
 `cant` int ,
 `placa` varchar(10) ,
 `Transportista` varchar(100) ,
 `ructr` varchar(11) ,
 `Chofer` varchar(100) ,
 `Brevete` varchar(25) ,
 `Constancia` varchar(40) ,
 `marca` varchar(50) ,
 `Direccion` varchar(100) ,
 `usuario` varchar(45) ,
 `cliente` varchar(80) ,
 `idprov` int ,
 `refe` varchar(12) ,
 `tdoc` varchar(2) ,
 `guia_mens` varchar(120) ,
 `guia_arch` varchar(120) ,
 `email` varchar(45) ,
 `guia_hash` varchar(100) ,
 `guia_feen` datetime ,
 `guia_codt` int unsigned ,
 `guia_tick` varchar(40) 
)*/;

/*Table structure for table `vguiasrcompras` */

DROP TABLE IF EXISTS `vguiasrcompras`;

/*!50001 DROP VIEW IF EXISTS `vguiasrcompras` */;
/*!50001 DROP TABLE IF EXISTS `vguiasrcompras` */;

/*!50001 CREATE TABLE  `vguiasrcompras`(
 `idguia` int unsigned ,
 `coda` int ,
 `descri` varchar(150) ,
 `unid` varchar(15) ,
 `ndoc` varchar(12) ,
 `fech` date ,
 `fect` date ,
 `ptoll` varchar(180) ,
 `detalle` varchar(150) ,
 `cant` int ,
 `placa` varchar(10) ,
 `Transportista` varchar(100) ,
 `ructr` varchar(11) ,
 `Chofer` varchar(100) ,
 `Brevete` varchar(25) ,
 `Constancia` varchar(40) ,
 `marca` varchar(50) ,
 `Direccion` varchar(100) ,
 `usuario` varchar(45) ,
 `cliente` varchar(80) ,
 `idprov` int ,
 `refe` varchar(12) ,
 `tdoc` varchar(2) ,
 `guia_mens` varchar(120) ,
 `guia_arch` varchar(120) ,
 `email` varchar(45) ,
 `guia_hash` varchar(100) ,
 `guia_feen` datetime ,
 `guia_codt` int unsigned ,
 `guia_tick` varchar(40) 
)*/;

/*Table structure for table `vguiasventas` */

DROP TABLE IF EXISTS `vguiasventas`;

/*!50001 DROP VIEW IF EXISTS `vguiasventas` */;
/*!50001 DROP TABLE IF EXISTS `vguiasventas` */;

/*!50001 CREATE TABLE  `vguiasventas`(
 `idguia` int unsigned ,
 `coda` int ,
 `descri` varchar(150) ,
 `unid` varchar(15) ,
 `ndoc` varchar(12) ,
 `fech` date ,
 `fect` date ,
 `ptoll` varchar(180) ,
 `detalle` varchar(150) ,
 `cant` int ,
 `placa` varchar(10) ,
 `Transportista` varchar(100) ,
 `ructr` varchar(11) ,
 `Chofer` varchar(100) ,
 `Brevete` varchar(25) ,
 `Constancia` varchar(40) ,
 `marca` varchar(50) ,
 `Direccion` varchar(100) ,
 `usuario` varchar(45) ,
 `cliente` varchar(120) ,
 `idcliente` int ,
 `refe` varchar(12) ,
 `tdoc` varchar(2) ,
 `guia_mens` varchar(120) ,
 `guia_arch` varchar(120) ,
 `clie_corr` varchar(150) ,
 `guia_hash` varchar(100) ,
 `guia_feen` datetime ,
 `guia_codt` int unsigned ,
 `guia_tick` varchar(40) 
)*/;

/*Table structure for table `vguiasventas1` */

DROP TABLE IF EXISTS `vguiasventas1`;

/*!50001 DROP VIEW IF EXISTS `vguiasventas1` */;
/*!50001 DROP TABLE IF EXISTS `vguiasventas1` */;

/*!50001 CREATE TABLE  `vguiasventas1`(
 `idguia` int unsigned ,
 `coda` int ,
 `descri` varchar(150) ,
 `unid` varchar(50) ,
 `ndoc` varchar(12) ,
 `fech` date ,
 `fect` date ,
 `ptoll` varchar(180) ,
 `detalle` varchar(150) ,
 `cant` int ,
 `placa` varchar(10) ,
 `Transportista` varchar(100) ,
 `ructr` varchar(11) ,
 `Chofer` varchar(100) ,
 `Brevete` varchar(25) ,
 `Constancia` varchar(40) ,
 `marca` varchar(50) ,
 `Direccion` varchar(100) ,
 `usuario` varchar(45) ,
 `cliente` varchar(120) ,
 `idcliente` int ,
 `guia_impo` decimal(12,2) ,
 `refe` varchar(12) ,
 `tdoc` varchar(2) 
)*/;

/*Table structure for table `vingresos` */

DROP TABLE IF EXISTS `vingresos`;

/*!50001 DROP VIEW IF EXISTS `vingresos` */;
/*!50001 DROP TABLE IF EXISTS `vingresos` */;

/*!50001 CREATE TABLE  `vingresos`(
 `idprov` int ,
 `kar_idkar` int unsigned 
)*/;

/*Table structure for table `vmuestracompras` */

DROP TABLE IF EXISTS `vmuestracompras`;

/*!50001 DROP VIEW IF EXISTS `vmuestracompras` */;
/*!50001 DROP TABLE IF EXISTS `vmuestracompras` */;

/*!50001 CREATE TABLE  `vmuestracompras`(
 `idauto` int ,
 `alma` int ,
 `idkar` int ,
 `kar_equi` decimal(8,2) ,
 `kar_fvto` date ,
 `kar_lote` varchar(15) ,
 `descri` varchar(150) ,
 `peso` float ,
 `prod_idco` int unsigned ,
 `unid` varchar(60) ,
 `tipro` varchar(1) ,
 `idart` int ,
 `incl` char(1) ,
 `ndoc` varchar(12) ,
 `valor` decimal(12,2) ,
 `igv` decimal(12,2) ,
 `impo` decimal(12,2) ,
 `pimpo` float ,
 `cant` decimal(14,2) ,
 `prec` decimal(14,8) ,
 `fech` date ,
 `fecr` date ,
 `form` varchar(1) ,
 `exon` varchar(1) ,
 `ndo2` varchar(12) ,
 `vigv` float ,
 `idprov` int ,
 `tipo` varchar(1) ,
 `tdoc` varchar(2) ,
 `dolar` float ,
 `mone` varchar(1) ,
 `razo` varchar(80) ,
 `dire` varchar(60) ,
 `ciud` varchar(50) ,
 `nruc` varchar(11) ,
 `kar_posi` int unsigned ,
 `kar_epta` int unsigned ,
 `Idcaja` bigint ,
 `kar_flet` decimal(10,6) ,
 `codt` int ,
 `fusua` datetime ,
 `Usuario` varchar(45) ,
 `kar_idkar` int unsigned 
)*/;

/*Table structure for table `vmuestracompras1` */

DROP TABLE IF EXISTS `vmuestracompras1`;

/*!50001 DROP VIEW IF EXISTS `vmuestracompras1` */;
/*!50001 DROP TABLE IF EXISTS `vmuestracompras1` */;

/*!50001 CREATE TABLE  `vmuestracompras1`(
 `idauto` int ,
 `alma` int ,
 `idkar` int ,
 `idart` int ,
 `incl` char(1) ,
 `descri` varchar(150) ,
 `unid` varchar(15) ,
 `peso` float ,
 `cant` decimal(14,2) ,
 `prec` decimal(14,8) ,
 `tipo` varchar(1) ,
 `dsnc` int ,
 `dsnd` int ,
 `gast` decimal(6,3) 
)*/;

/*Table structure for table `vmuestracotizaciones` */

DROP TABLE IF EXISTS `vmuestracotizaciones`;

/*!50001 DROP VIEW IF EXISTS `vmuestracotizaciones` */;
/*!50001 DROP TABLE IF EXISTS `vmuestracotizaciones` */;

/*!50001 CREATE TABLE  `vmuestracotizaciones`(
 `rped_gara` varchar(100) ,
 `rped_vigv` decimal(5,2) ,
 `idart` int unsigned ,
 `descri` varchar(150) ,
 `unid` varchar(20) ,
 `cant` float ,
 `idven` bigint ,
 `Vendedor` varchar(45) ,
 `prec` float ,
 `premay` float ,
 `premen` float ,
 `fech` date ,
 `idautop` int unsigned ,
 `impo` float ,
 `ndoc` varchar(10) ,
 `aten` varchar(120) ,
 `forma` varchar(120) ,
 `facturado` varchar(1) ,
 `form` varchar(1) ,
 `plazo` varchar(120) ,
 `validez` varchar(120) ,
 `entrega` varchar(120) ,
 `detalle` varchar(180) ,
 `idclie` bigint ,
 `razo` varchar(120) ,
 `nruc` varchar(11) ,
 `dire` varchar(120) ,
 `clie_lcre` float ,
 `ndni` varchar(11) ,
 `refe` varchar(255) ,
 `tdoc` varchar(2) ,
 `rped_mone` char(1) ,
 `ciud` varchar(120) ,
 `fono` varchar(20) ,
 `fax` varchar(15) ,
 `nreg` int unsigned ,
 `dped_unid` varchar(20) ,
 `dped_equi` decimal(8,2) ,
 `dped_posi` int ,
 `comi` decimal(6,3) ,
 `idepta` int unsigned ,
 `rped_idus` int unsigned 
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
 `razo` varchar(80) ,
 `Debe` double ,
 `Haber` double ,
 `idcta` int unsigned ,
 `fech` date ,
 `nomb` varchar(60) ,
 `tipo` char(1) ,
 `idrcon` int ,
 `mone` varchar(1) ,
 `idprov` int ,
 `idectas` int unsigned 
)*/;

/*Table structure for table `vmuestractasdiario` */

DROP TABLE IF EXISTS `vmuestractasdiario`;

/*!50001 DROP VIEW IF EXISTS `vmuestractasdiario` */;
/*!50001 DROP TABLE IF EXISTS `vmuestractasdiario` */;

/*!50001 CREATE TABLE  `vmuestractasdiario`(
 `Fecha` datetime ,
 `ncta` varchar(8) ,
 `Glosa` varchar(120) ,
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
 `razo` varchar(120) ,
 `Debe` decimal(12,2) ,
 `Haber` decimal(12,2) ,
 `tipo` char(1) ,
 `idcta` int unsigned ,
 `nomb` varchar(60) ,
 `idrven` int ,
 `mone` varchar(1) ,
 `idectas` int unsigned ,
 `idclie` int 
)*/;

/*Table structure for table `vmuestraordencompra` */

DROP TABLE IF EXISTS `vmuestraordencompra`;

/*!50001 DROP VIEW IF EXISTS `vmuestraordencompra` */;
/*!50001 DROP TABLE IF EXISTS `vmuestraordencompra` */;

/*!50001 CREATE TABLE  `vmuestraordencompra`(
 `doco_iddo` int unsigned ,
 `doco_coda` int unsigned ,
 `doco_cant` float ,
 `doco_prec` float ,
 `descri` varchar(150) ,
 `prod_smin` float ,
 `unid` varchar(15) ,
 `prod_smax` float ,
 `ocom_valor` float ,
 `ocom_igv` float ,
 `ocom_impo` float ,
 `ocom_idroc` int unsigned ,
 `ocom_fech` date ,
 `ocom_idpr` int ,
 `ocom_desp` varchar(60) ,
 `ocom_form` varchar(60) ,
 `ocom_mone` char(1) ,
 `ocom_ndoc` varchar(10) ,
 `ocom_tigv` char(1) ,
 `ocom_obse` varchar(120) ,
 `ocom_aten` varchar(80) ,
 `ocom_deta` varchar(120) ,
 `ocom_idus` int unsigned ,
 `ocom_fope` datetime ,
 `ocom_idpc` varchar(45) ,
 `ocom_idac` int unsigned ,
 `ocom_fact` datetime ,
 `razo` varchar(80) ,
 `nomb` varchar(45) 
)*/;

/*Table structure for table `vmuestrastockfvto` */

DROP TABLE IF EXISTS `vmuestrastockfvto`;

/*!50001 DROP VIEW IF EXISTS `vmuestrastockfvto` */;
/*!50001 DROP TABLE IF EXISTS `vmuestrastockfvto` */;

/*!50001 CREATE TABLE  `vmuestrastockfvto`(
 `idart` int ,
 `cant` decimal(44,4) ,
 `kar_fvto` date ,
 `kar_lote` varchar(15) ,
 `fech_idka` int unsigned ,
 `idprov` int ,
 `alma` int 
)*/;

/*Table structure for table `vmuestraventas` */

DROP TABLE IF EXISTS `vmuestraventas`;

/*!50001 DROP VIEW IF EXISTS `vmuestraventas` */;
/*!50001 DROP TABLE IF EXISTS `vmuestraventas` */;

/*!50001 CREATE TABLE  `vmuestraventas`(
 `rcom_idtr` int unsigned ,
 `codv` int ,
 `idauto` int ,
 `kar_cost` decimal(10,2) ,
 `kar_tigv` decimal(6,4) ,
 `kar_posi` int unsigned ,
 `kar_equi` decimal(8,2) ,
 `kar_epta` int unsigned ,
 `kar_comi` float ,
 `alma` int ,
 `idcosto` int ,
 `idkar` int ,
 `Coda` int ,
 `cant` decimal(14,2) ,
 `prec` decimal(14,8) ,
 `valor` decimal(12,2) ,
 `igv` decimal(12,2) ,
 `impo` decimal(12,2) ,
 `fech` date ,
 `fecr` date ,
 `form` varchar(1) ,
 `deta` varchar(150) ,
 `exon` varchar(1) ,
 `ndo2` varchar(12) ,
 `rcom_entr` char(1) ,
 `idclie` int ,
 `razo` varchar(120) ,
 `nruc` varchar(11) ,
 `dire` varchar(120) ,
 `ciud` varchar(120) ,
 `ndni` varchar(11) ,
 `tipo` varchar(1) ,
 `tdoc` varchar(2) ,
 `ndoc` varchar(12) ,
 `dolar` float ,
 `mone` varchar(1) ,
 `descri` varchar(150) ,
 `idcaja` bigint ,
 `unid` varchar(60) ,
 `pre1` float ,
 `peso` float ,
 `pre2` float ,
 `prod_cod1` varchar(30) ,
 `nidrv` bigint ,
 `vigv` float ,
 `idcliente` int ,
 `codt` int ,
 `pre3` decimal(12,2) ,
 `costo` float ,
 `uno` float ,
 `dos` float ,
 `tre` float ,
 `cua` float ,
 `TAlma` double ,
 `fusua` datetime ,
 `Vendedor` varchar(45) ,
 `Usuario` varchar(45) ,
 `tipro` varchar(1) ,
 `rcom_mens` varchar(180) ,
 `idusua` int unsigned 
)*/;

/*Table structure for table `vmuestravtas` */

DROP TABLE IF EXISTS `vmuestravtas`;

/*!50001 DROP VIEW IF EXISTS `vmuestravtas` */;
/*!50001 DROP TABLE IF EXISTS `vmuestravtas` */;

/*!50001 CREATE TABLE  `vmuestravtas`(
 `idusua` int unsigned ,
 `kar_comi` float ,
 `codv` int ,
 `idauto` int ,
 `alma` int ,
 `idcosto` int ,
 `idkar` int ,
 `Coda` int ,
 `cant` decimal(14,2) ,
 `prec` decimal(14,8) ,
 `valor` decimal(12,2) ,
 `igv` decimal(12,2) ,
 `impo` decimal(12,2) ,
 `fech` date ,
 `fecr` date ,
 `form` varchar(1) ,
 `deta` varchar(150) ,
 `exon` varchar(1) ,
 `ndo2` varchar(12) ,
 `idclie` int ,
 `razo` varchar(120) ,
 `nruc` varchar(11) ,
 `dire` varchar(120) ,
 `ciud` varchar(120) ,
 `ndni` varchar(11) ,
 `tipo` varchar(1) ,
 `tdoc` varchar(2) ,
 `ndoc` varchar(12) ,
 `dolar` float ,
 `mone` varchar(1) ,
 `vigv` float ,
 `dsnc` int ,
 `dsnd` int ,
 `gast` decimal(6,3) ,
 `idcliente` int ,
 `codt` int ,
 `fusua` datetime ,
 `descri` varchar(150) ,
 `unid` varchar(15) ,
 `usuario` varchar(45) 
)*/;

/*Table structure for table `vnotascompras` */

DROP TABLE IF EXISTS `vnotascompras`;

/*!50001 DROP VIEW IF EXISTS `vnotascompras` */;
/*!50001 DROP TABLE IF EXISTS `vnotascompras` */;

/*!50001 CREATE TABLE  `vnotascompras`(
 `fecha_Comp_Origen` date ,
 `Tipo_Comprob_Origen` varchar(2) ,
 `Serie_Origen` varchar(3) ,
 `Correlativo_Origen` varchar(7) ,
 `Item_Origen` int ,
 `idauto` int unsigned 
)*/;

/*Table structure for table `vnotasventas` */

DROP TABLE IF EXISTS `vnotasventas`;

/*!50001 DROP VIEW IF EXISTS `vnotasventas` */;
/*!50001 DROP TABLE IF EXISTS `vnotasventas` */;

/*!50001 CREATE TABLE  `vnotasventas`(
 `fecha_Comp_Origen` date ,
 `Tipo_Comprob_Origen` varchar(2) ,
 `Serie_Origen` varchar(3) ,
 `Correlativo_Origen` varchar(7) ,
 `Item_Origen` int ,
 `idauto` int unsigned 
)*/;

/*Table structure for table `vpdtesentrega` */

DROP TABLE IF EXISTS `vpdtesentrega`;

/*!50001 DROP VIEW IF EXISTS `vpdtesentrega` */;
/*!50001 DROP TABLE IF EXISTS `vpdtesentrega` */;

/*!50001 CREATE TABLE  `vpdtesentrega`(
 `Producto` varchar(150) ,
 `Unidad` varchar(15) ,
 `peso` float ,
 `uno` float ,
 `dos` float ,
 `idart` int ,
 `Pedido` decimal(32,2) ,
 `Entregado` decimal(32,2) ,
 `Saldo` decimal(33,2) ,
 `idin` bigint ,
 `tdoc` varchar(2) ,
 `ndoc` varchar(12) ,
 `idauto` int ,
 `Cliente` varchar(120) ,
 `dire` varchar(120) ,
 `ciud` varchar(120) ,
 `nruc` varchar(11) ,
 `fech` date ,
 `ndni` varchar(11) ,
 `idclie` int ,
 `Usuario` varchar(45) 
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
 `saldo` double ,
 `Idpr` int ,
 `ImporteC` float ,
 `situa` varchar(1) ,
 `Idauto` int unsigned ,
 `rdeu_idct` int unsigned ,
 `ncontrol` int ,
 `tipo` varchar(1) ,
 `banco` varchar(45) ,
 `docd` varchar(12) ,
 `tdoc` varchar(2) ,
 `Moneda` char(1) ,
 `Codt` int unsigned ,
 `Idrd` int unsigned 
)*/;

/*Table structure for table `vpdtespagoc` */

DROP TABLE IF EXISTS `vpdtespagoc`;

/*!50001 DROP VIEW IF EXISTS `vpdtespagoc` */;
/*!50001 DROP TABLE IF EXISTS `vpdtespagoc` */;

/*!50001 CREATE TABLE  `vpdtespagoc`(
 `idclie` int ,
 `ndoc` varchar(12) ,
 `importe` decimal(35,2) ,
 `mone` varchar(1) ,
 `banc` varchar(120) ,
 `fech` date ,
 `razo` varchar(120) ,
 `fono` varchar(20) ,
 `dire` varchar(120) ,
 `ciud` varchar(120) ,
 `fevto` date ,
 `tipo` varchar(1) ,
 `dola` float ,
 `docd` varchar(12) ,
 `nrou` varchar(40) ,
 `banco` varchar(120) ,
 `idcred` int ,
 `idauto` int unsigned ,
 `nomv` varchar(45) ,
 `ncontrol` int ,
 `rcre_codv` int unsigned ,
 `estd` varchar(1) ,
 `rcre_codt` int unsigned 
)*/;

/*Table structure for table `vpdtesvtas` */

DROP TABLE IF EXISTS `vpdtesvtas`;

/*!50001 DROP VIEW IF EXISTS `vpdtesvtas` */;
/*!50001 DROP TABLE IF EXISTS `vpdtesvtas` */;

/*!50001 CREATE TABLE  `vpdtesvtas`(
 `idkar` int ,
 `Pedido` decimal(14,2) ,
 `Entregado` bigint unsigned 
)*/;

/*Table structure for table `vpdtesx` */

DROP TABLE IF EXISTS `vpdtesx`;

/*!50001 DROP VIEW IF EXISTS `vpdtesx` */;
/*!50001 DROP TABLE IF EXISTS `vpdtesx` */;

/*!50001 CREATE TABLE  `vpdtesx`(
 `idart` int ,
 `fech` date ,
 `tdoc` varchar(2) ,
 `ndoc` varchar(12) ,
 `pedido` decimal(14,2) ,
 `entregado` decimal(32,0) ,
 `saldo` decimal(35,2) ,
 `guia_ndoc` varchar(12) ,
 `guia_fech` date ,
 `idauto` int ,
 `idcliente` int ,
 `impo` decimal(12,2) ,
 `valor` decimal(12,2) ,
 `igv` decimal(12,2) ,
 `form` varchar(1) ,
 `prec` decimal(14,8) ,
 `idkar` int ,
 `entr_acti` char(1) ,
 `kar_unid` varchar(60) 
)*/;

/*Table structure for table `vrcompras` */

DROP TABLE IF EXISTS `vrcompras`;

/*!50001 DROP VIEW IF EXISTS `vrcompras` */;
/*!50001 DROP TABLE IF EXISTS `vrcompras` */;

/*!50001 CREATE TABLE  `vrcompras`(
 `ndoc` varchar(12) ,
 `valor` decimal(12,2) ,
 `igv` decimal(12,2) ,
 `impo` decimal(12,2) ,
 `pimpo` float ,
 `fech` date ,
 `fecr` date ,
 `form` varchar(1) ,
 `exon` varchar(1) ,
 `ndo2` varchar(12) ,
 `idauto` int ,
 `deta` varchar(150) ,
 `tcom` varchar(1) ,
 `vigv` float ,
 `idprov` int ,
 `tdoc` varchar(2) ,
 `dolar` float ,
 `mone` varchar(1) ,
 `razo` varchar(80) ,
 `dire` varchar(60) ,
 `ciud` varchar(50) ,
 `nruc` varchar(11) ,
 `Idcaja` bigint ,
 `codt` int ,
 `fusua` datetime ,
 `Usuario` varchar(45) 
)*/;

/*Table structure for table `vregcompras` */

DROP TABLE IF EXISTS `vregcompras`;

/*!50001 DROP VIEW IF EXISTS `vregcompras` */;
/*!50001 DROP TABLE IF EXISTS `vregcompras` */;

/*!50001 CREATE TABLE  `vregcompras`(
 `fech` date ,
 `fecr` date ,
 `tdoc` varchar(2) ,
 `ndoc` varchar(12) ,
 `idprov` int ,
 `ndo2` varchar(12) ,
 `mone` varchar(1) ,
 `valor` decimal(12,2) ,
 `igv` decimal(12,2) ,
 `impo` decimal(12,2) ,
 `codt` int ,
 `dola` float ,
 `form` varchar(1) ,
 `vigv` float ,
 `idauto` int ,
 `usuario` varchar(45) ,
 `fusua` datetime ,
 `razo` varchar(80) ,
 `nruc` varchar(11) ,
 `dire` varchar(60) ,
 `ciud` varchar(50) ,
 `fono` varchar(15) 
)*/;

/*Table structure for table `vsaldos` */

DROP TABLE IF EXISTS `vsaldos`;

/*!50001 DROP VIEW IF EXISTS `vsaldos` */;
/*!50001 DROP TABLE IF EXISTS `vsaldos` */;

/*!50001 CREATE TABLE  `vsaldos`(
 `pdte_idar` int ,
 `Pedido` decimal(10,2) ,
 `Entregado` decimal(10,2) ,
 `pdte_idau` int ,
 `pdte_idus` int unsigned ,
 `idin` bigint 
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

/*Table structure for table `vutilidad` */

DROP TABLE IF EXISTS `vutilidad`;

/*!50001 DROP VIEW IF EXISTS `vutilidad` */;
/*!50001 DROP TABLE IF EXISTS `vutilidad` */;

/*!50001 CREATE TABLE  `vutilidad`(
 `fecha` date ,
 `Documento` varchar(12) ,
 `Cliente` varchar(120) ,
 `costo` double ,
 `precio` decimal(50,10) ,
 `Vendedor` varchar(45) ,
 `usuario` varchar(45) ,
 `FechaHora` datetime ,
 `x` varchar(2) ,
 `idauto` int ,
 `codv` int 
)*/;

/*Table structure for table `vvolumenvtas` */

DROP TABLE IF EXISTS `vvolumenvtas`;

/*!50001 DROP VIEW IF EXISTS `vvolumenvtas` */;
/*!50001 DROP TABLE IF EXISTS `vvolumenvtas` */;

/*!50001 CREATE TABLE  `vvolumenvtas`(
 `idart` int ,
 `dcat` varchar(150) ,
 `impo` decimal(12,2) ,
 `nomv` varchar(45) ,
 `fech` date ,
 `codv` int ,
 `idcliente` int ,
 `idcat` int 
)*/;

/*View structure for view rvendedores */

/*!50001 DROP TABLE IF EXISTS `rvendedores` */;
/*!50001 DROP VIEW IF EXISTS `rvendedores` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `rvendedores` AS select `fe_kar`.`idauto` AS `idauto`,`fe_kar`.`codv` AS `codv` from `fe_kar` where (`fe_kar`.`tipo` = 'V') group by `fe_kar`.`idauto` */;

/*View structure for view vcambio */

/*!50001 DROP TABLE IF EXISTS `vcambio` */;
/*!50001 DROP VIEW IF EXISTS `vcambio` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vcambio` AS select `c`.`nomb` AS `nomb`,`a`.`fusua` AS `fusua`,`y`.`descri` AS `descri`,`y`.`unid` AS `unid`,`p`.`camb_cant` AS `camb_cant`,`p`.`camb_prec` AS `camb_prec`,round((`p`.`camb_cant` * `p`.`camb_prec`),2) AS `importe`,`p`.`camb_idac` AS `camb_idac`,`p`.`camb_fope` AS `camb_fope` from ((((`fe_rcom` `a` join `fe_clie` `b` on((`b`.`idclie` = `a`.`idcliente`))) join `fe_usua` `c` on((`a`.`idusua` = `c`.`idusua`))) join `fe_cambiosvtas` `p` on((`p`.`camb_idac` = `a`.`idauto`))) join `fe_art` `y` on((`y`.`idart` = `p`.`camb_idart`))) */;

/*View structure for view vcambioactual */

/*!50001 DROP TABLE IF EXISTS `vcambioactual` */;
/*!50001 DROP VIEW IF EXISTS `vcambioactual` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vcambioactual` AS select `a`.`ndoc` AS `ndoc`,`a`.`tdoc` AS `tdoc`,`b`.`razo` AS `razo`,`a`.`impo` AS `impo`,`c`.`nomb` AS `nomb`,`a`.`fusua` AS `fusua`,`y`.`descri` AS `descri`,`y`.`unid` AS `unid`,`p`.`cant` AS `cant`,`p`.`prec` AS `prec`,round((`p`.`cant` * `p`.`prec`),2) AS `importe`,`z`.`camb_idac` AS `camb_idac`,`z`.`camb_idaa` AS `camb_idaa`,`z`.`camb_fope` AS `camb_fope`,`a`.`fech` AS `fech`,`a`.`idauto` AS `idauto` from (((((`fe_rcom` `a` join `fe_clie` `b` on((`b`.`idclie` = `a`.`idcliente`))) join `fe_usua` `c` on((`a`.`idusua` = `c`.`idusua`))) join `fe_kar` `p` on((`p`.`idauto` = `a`.`idauto`))) join `fe_cambiosvtas` `z` on((`z`.`camb_idac` = `a`.`idauto`))) join `fe_art` `y` on((`y`.`idart` = `z`.`camb_idart`))) where (`a`.`acti` <> 'I') group by `z`.`camb_idca` */;

/*View structure for view vcambioanterior */

/*!50001 DROP TABLE IF EXISTS `vcambioanterior` */;
/*!50001 DROP VIEW IF EXISTS `vcambioanterior` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vcambioanterior` AS select `a`.`ndoc` AS `ndoc`,`a`.`tdoc` AS `tdoc`,`b`.`razo` AS `razo`,`a`.`impo` AS `impo`,`c`.`nomb` AS `nomb`,`a`.`fusua` AS `fusua`,`y`.`descri` AS `descri`,`y`.`unid` AS `unid`,`p`.`cant` AS `cant`,`p`.`prec` AS `prec`,round((`p`.`cant` * `p`.`prec`),2) AS `importe`,`z`.`camb_idaa` AS `camb_idaa`,`z`.`camb_fope` AS `camb_fope`,`a`.`idauto` AS `idauto`,`w`.`acti` AS `acti` from ((((((`fe_rcom` `a` join `fe_clie` `b` on((`b`.`idclie` = `a`.`idcliente`))) join `fe_usua` `c` on((`a`.`idusua` = `c`.`idusua`))) join `fe_kar` `p` on((`p`.`idauto` = `a`.`idauto`))) join `fe_cambiosvtas` `z` on((`z`.`camb_idaa` = `a`.`idauto`))) join `fe_art` `y` on((`y`.`idart` = `z`.`camb_idart`))) join `fe_rcom` `w` on((`w`.`idauto` = `z`.`camb_idac`))) where (`w`.`acti` <> 'I') group by `z`.`camb_idca` */;

/*View structure for view vcomisiones */

/*!50001 DROP TABLE IF EXISTS `vcomisiones` */;
/*!50001 DROP VIEW IF EXISTS `vcomisiones` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vcomisiones` AS select `v`.`idauto` AS `idauto`,`v`.`ndoc` AS `ndoc`,`v`.`fech` AS `fech`,`v`.`mone` AS `mone`,`v`.`impo` AS `impo`,`v`.`form` AS `form`,sum((case `v`.`tdoc` when '07' then if((`a`.`cant` = 0),(`a`.`kar_comi` / `v`.`vigv`),(((`a`.`cant` * `a`.`prec`) / `v`.`vigv`) * `a`.`kar_comi`)) when '08' then (`a`.`kar_comi` / `v`.`vigv`) else (((`a`.`cant` * `a`.`prec`) / `v`.`vigv`) * `a`.`kar_comi`) end)) AS `comision` from (`fe_kar` `a` join `fe_rcom` `v` on((`v`.`idauto` = `a`.`idauto`))) where ((`v`.`acti` = 'A') and (`a`.`acti` = 'A') and (`v`.`idcliente` > 0)) group by `v`.`idauto` */;

/*View structure for view vdvtas */

/*!50001 DROP TABLE IF EXISTS `vdvtas` */;
/*!50001 DROP VIEW IF EXISTS `vdvtas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vdvtas` AS select `a`.`kar_comi` AS `kar_comi`,`a`.`cant` AS `cant`,`a`.`prec` AS `prec`,`a`.`idauto` AS `idauto`,`a`.`alma` AS `alma`,`a`.`idart` AS `idart`,`a`.`kar_unid` AS `kar_unid`,`b`.`descri` AS `descri`,`c`.`dcat` AS `dcat`,`b`.`idcat` AS `idcat`,`b`.`idmar` AS `idmar`,`d`.`dmar` AS `dmar`,`b`.`prod_equi1` AS `prod_equi1`,`b`.`prod_equi2` AS `prod_equi2`,`b`.`unid` AS `unid`,`b`.`prod_unid1` AS `prod_unid1`,`b`.`prod_cod1` AS `prod_cod1`,`a`.`kar_equi` AS `kar_equi` from (((`fe_kar` `a` join `fe_art` `b` on((`b`.`idart` = `a`.`idart`))) join `fe_cat` `c` on((`c`.`idcat` = `b`.`idcat`))) join `fe_mar` `d` on((`d`.`idmar` = `b`.`idmar`))) where ((`a`.`acti` = 'A') and (`a`.`tipo` = 'V')) */;

/*View structure for view vguiascompras */

/*!50001 DROP TABLE IF EXISTS `vguiascompras` */;
/*!50001 DROP VIEW IF EXISTS `vguiascompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vguiascompras` AS select `fe_guiac`.`guic_idau` AS `guic_idau`,`fe_guiac`.`guic_tipo` AS `guic_tipo`,cast(ifnull(`fe_guiac`.`guic_idac`,0) as signed) AS `guic_idac` from `fe_guiac` where (`fe_guiac`.`guic_acti` = 'A') group by `fe_guiac`.`guic_idau` */;

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

/*View structure for view vguiasventas1 */

/*!50001 DROP TABLE IF EXISTS `vguiasventas1` */;
/*!50001 DROP VIEW IF EXISTS `vguiasventas1` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vguiasventas1` AS select `b`.`guia_idgui` AS `idguia`,`a`.`idart` AS `coda`,`a`.`descri` AS `descri`,if((`x`.`entr_unid` = ''),`a`.`unid`,`x`.`entr_unid`) AS `unid`,`b`.`guia_ndoc` AS `ndoc`,`b`.`guia_fech` AS `fech`,`b`.`guia_fect` AS `fect`,`b`.`guia_ptoll` AS `ptoll`,`b`.`guia_deta` AS `detalle`,`x`.`entr_cant` AS `cant`,ifnull(`y`.`placa`,'') AS `placa`,ifnull(`y`.`razon`,'') AS `Transportista`,ifnull(`y`.`ructr`,'') AS `ructr`,ifnull(`y`.`nombr`,'') AS `Chofer`,ifnull(`y`.`breve`,'') AS `Brevete`,ifnull(`y`.`cons`,'') AS `Constancia`,ifnull(`y`.`marca`,'') AS `marca`,ifnull(`y`.`dirtr`,'') AS `Direccion`,`p`.`nomb` AS `usuario`,`d`.`razo` AS `cliente`,`d`.`idclie` AS `idcliente`,`b`.`guia_impo` AS `guia_impo`,`b`.`guia_ndoc` AS `refe`,'09' AS `tdoc` from (((((`fe_guias` `b` join `fe_ent` `x` on((`x`.`entr_idgu` = `b`.`guia_idgui`))) left join `fe_tra` `y` on((`y`.`idtra` = `b`.`guia_idtr`))) join `fe_art` `a` on((`a`.`idart` = `x`.`entr_idar`))) join `fe_usua` `p` on((`p`.`idusua` = `b`.`guia_idus`))) join `fe_clie` `d` on((`d`.`idclie` = `b`.`guia_idcl`))) where (`b`.`guia_acti` <> 'I') */;

/*View structure for view vingresos */

/*!50001 DROP TABLE IF EXISTS `vingresos` */;
/*!50001 DROP VIEW IF EXISTS `vingresos` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vingresos` AS select `b`.`idprov` AS `idprov`,`a`.`kar_idkar` AS `kar_idkar` from ((`fe_kar` `a` join `fe_rcom` `b` on((`b`.`idauto` = `a`.`idauto`))) join `fe_prov` `x` on((`x`.`idprov` = `b`.`idprov`))) where ((`a`.`acti` = 'A') and (`b`.`acti` = 'A')) group by `a`.`kar_idkar` */;

/*View structure for view vmuestracompras */

/*!50001 DROP TABLE IF EXISTS `vmuestracompras` */;
/*!50001 DROP VIEW IF EXISTS `vmuestracompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestracompras` AS select `a`.`idauto` AS `idauto`,`a`.`alma` AS `alma`,`a`.`idkar` AS `idkar`,`a`.`kar_equi` AS `kar_equi`,`a`.`kar_fvto` AS `kar_fvto`,`a`.`kar_lote` AS `kar_lote`,`b`.`descri` AS `descri`,`b`.`peso` AS `peso`,`b`.`prod_idco` AS `prod_idco`,`a`.`kar_unid` AS `unid`,`b`.`tipro` AS `tipro`,`a`.`idart` AS `idart`,`a`.`incl` AS `incl`,`c`.`ndoc` AS `ndoc`,`c`.`valor` AS `valor`,`c`.`igv` AS `igv`,`c`.`impo` AS `impo`,`c`.`pimpo` AS `pimpo`,`a`.`cant` AS `cant`,`a`.`prec` AS `prec`,`c`.`fech` AS `fech`,`c`.`fecr` AS `fecr`,`c`.`form` AS `form`,`c`.`exon` AS `exon`,`c`.`ndo2` AS `ndo2`,`c`.`vigv` AS `vigv`,`c`.`idprov` AS `idprov`,`a`.`tipo` AS `tipo`,`c`.`tdoc` AS `tdoc`,`c`.`dolar` AS `dolar`,`c`.`mone` AS `mone`,`p`.`razo` AS `razo`,`p`.`dire` AS `dire`,`p`.`ciud` AS `ciud`,`p`.`nruc` AS `nruc`,`a`.`kar_posi` AS `kar_posi`,`a`.`kar_epta` AS `kar_epta`,ifnull(`x`.`idcaja`,0) AS `Idcaja`,`a`.`kar_flet` AS `kar_flet`,`c`.`codt` AS `codt`,`c`.`fusua` AS `fusua`,`w`.`nomb` AS `Usuario`,`a`.`kar_idkar` AS `kar_idkar` from (((((`fe_rcom` `c` left join `fe_kar` `a` on((`c`.`idauto` = `a`.`idauto`))) left join `fe_art` `b` on((`b`.`idart` = `a`.`idart`))) join `fe_prov` `p` on((`p`.`idprov` = `c`.`idprov`))) left join `fe_caja` `x` on((`x`.`idauto` = `c`.`idauto`))) join `fe_usua` `w` on((`w`.`idusua` = `c`.`idusua`))) where ((`c`.`acti` <> 'I') and (`a`.`acti` <> 'I')) */;

/*View structure for view vmuestracompras1 */

/*!50001 DROP TABLE IF EXISTS `vmuestracompras1` */;
/*!50001 DROP VIEW IF EXISTS `vmuestracompras1` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestracompras1` AS select `a`.`idauto` AS `idauto`,`a`.`alma` AS `alma`,`a`.`idkar` AS `idkar`,`a`.`idart` AS `idart`,`a`.`incl` AS `incl`,`b`.`descri` AS `descri`,`b`.`unid` AS `unid`,`b`.`peso` AS `peso`,`a`.`cant` AS `cant`,`a`.`prec` AS `prec`,`a`.`tipo` AS `tipo`,`a`.`dsnc` AS `dsnc`,`a`.`dsnd` AS `dsnd`,`a`.`gast` AS `gast` from (`fe_kar` `a` join `fe_art` `b` on((`b`.`idart` = `a`.`idart`))) where (`a`.`acti` = 'A') */;

/*View structure for view vmuestracotizaciones */

/*!50001 DROP TABLE IF EXISTS `vmuestracotizaciones` */;
/*!50001 DROP VIEW IF EXISTS `vmuestracotizaciones` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestracotizaciones` AS select `c`.`rped_gara` AS `rped_gara`,`c`.`rped_vigv` AS `rped_vigv`,`a`.`idart` AS `idart`,`b`.`descri` AS `descri`,`a`.`dped_unid` AS `unid`,`a`.`cant` AS `cant`,ifnull(`m`.`idven`,0) AS `idven`,ifnull(`m`.`nomv`,'') AS `Vendedor`,`a`.`prec` AS `prec`,`b`.`premay` AS `premay`,`b`.`premen` AS `premen`,`c`.`fech` AS `fech`,`c`.`idautop` AS `idautop`,`c`.`impo` AS `impo`,`c`.`ndoc` AS `ndoc`,`c`.`aten` AS `aten`,`c`.`forma` AS `forma`,`c`.`facturado` AS `facturado`,`c`.`form` AS `form`,`c`.`plazo` AS `plazo`,`c`.`validez` AS `validez`,`c`.`entrega` AS `entrega`,`c`.`detalle` AS `detalle`,ifnull(`d`.`idclie`,0) AS `idclie`,ifnull(`d`.`razo`,'') AS `razo`,ifnull(`d`.`nruc`,'') AS `nruc`,ifnull(`d`.`dire`,'') AS `dire`,ifnull(`d`.`clie_lcre`,0) AS `clie_lcre`,ifnull(`d`.`ndni`,'') AS `ndni`,ifnull(`d`.`refe`,'') AS `refe`,`c`.`tdoc` AS `tdoc`,`c`.`rped_mone` AS `rped_mone`,ifnull(`d`.`ciud`,'') AS `ciud`,`d`.`fono` AS `fono`,`d`.`fax` AS `fax`,`a`.`idped` AS `nreg`,`a`.`dped_unid` AS `dped_unid`,`a`.`dped_equi` AS `dped_equi`,`a`.`dped_posi` AS `dped_posi`,`a`.`dped_comi` AS `comi`,`a`.`dped_idep` AS `idepta`,`c`.`rped_idus` AS `rped_idus` from ((((`fe_ped` `a` join `fe_rped` `c` on((`a`.`idautop` = `c`.`idautop`))) join `fe_art` `b` on((`b`.`idart` = `a`.`idart`))) left join `fe_clie` `d` on((`d`.`idclie` = `c`.`idclie`))) left join `fe_vend` `m` on((`m`.`idven` = `c`.`idven`))) where ((`a`.`acti` <> 'I') and (`c`.`acti` <> 'I')) */;

/*View structure for view vmuestractascompras */

/*!50001 DROP TABLE IF EXISTS `vmuestractascompras` */;
/*!50001 DROP VIEW IF EXISTS `vmuestractascompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestractascompras` AS select left(`p`.`nomb`,3) AS `tdoc`,`b`.`ndoc` AS `ndoc`,`b`.`fecr` AS `fecr`,`a`.`ncta` AS `ncta`,`c`.`razo` AS `razo`,(case `x`.`ecta_tipo` when 'D' then if((`b`.`mone` = 'S'),`x`.`impo`,round((`x`.`impo` * `b`.`dolar`),2)) else 0 end) AS `Debe`,(case `x`.`ecta_tipo` when 'H' then if((`b`.`mone` = 'S'),`x`.`impo`,round((`x`.`impo` * `b`.`dolar`),2)) else 0 end) AS `Haber`,`a`.`idcta` AS `idcta`,`b`.`fech` AS `fech`,`a`.`nomb` AS `nomb`,`x`.`ecta_tipo` AS `tipo`,`b`.`idauto` AS `idrcon`,`b`.`mone` AS `mone`,`c`.`idprov` AS `idprov`,`x`.`idectas` AS `idectas` from ((((`fe_ectasc` `x` join `fe_plan` `a` on((`a`.`idcta` = `x`.`idcta`))) join `fe_rcom` `b` on((`b`.`idauto` = `x`.`idrcon`))) join `fe_prov` `c` on((`c`.`idprov` = `b`.`idprov`))) join `fe_tdoc` `p` on((`p`.`tdoc` = `b`.`tdoc`))) where ((`x`.`impo` <> 0) and (`b`.`acti` = 'A') and (`p`.`dcto_acti` = 'A') and (`x`.`ecta_acti` = 'A')) */;

/*View structure for view vmuestractasdiario */

/*!50001 DROP TABLE IF EXISTS `vmuestractasdiario` */;
/*!50001 DROP VIEW IF EXISTS `vmuestractasdiario` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestractasdiario` AS select `a`.`ldia_fech` AS `Fecha`,`b`.`ncta` AS `ncta`,`a`.`ldia_glosa` AS `Glosa`,`a`.`ldia_debe` AS `Debe`,`a`.`ldia_haber` AS `Haber`,`a`.`ldia_idcta` AS `Idcta` from (`fe_ldiario` `a` join `fe_plan` `b` on((`b`.`idcta` = `a`.`ldia_idcta`))) where (`a`.`ldia_acti` = 'A') */;

/*View structure for view vmuestractasventas */

/*!50001 DROP TABLE IF EXISTS `vmuestractasventas` */;
/*!50001 DROP VIEW IF EXISTS `vmuestractasventas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestractasventas` AS select left(`p`.`nomb`,3) AS `tdoc`,`b`.`ndoc` AS `ndoc`,`b`.`fech` AS `fech`,`a`.`ncta` AS `ncta`,`c`.`razo` AS `razo`,(case `x`.`tipo` when 'D' then `x`.`impo` else 0 end) AS `Debe`,(case `x`.`tipo` when 'H' then `x`.`impo` else 0 end) AS `Haber`,`x`.`tipo` AS `tipo`,`a`.`idcta` AS `idcta`,`a`.`nomb` AS `nomb`,`b`.`idauto` AS `idrven`,`b`.`mone` AS `mone`,`x`.`idectas` AS `idectas`,`c`.`idclie` AS `idclie` from ((((`fe_ectas` `x` join `fe_plan` `a` on((`a`.`idcta` = `x`.`idcta`))) join `fe_rcom` `b` on((`b`.`idauto` = `x`.`idrven`))) join `fe_clie` `c` on((`c`.`idclie` = `b`.`idcliente`))) join `fe_tdoc` `p` on((`p`.`tdoc` = `b`.`tdoc`))) where ((`x`.`impo` <> 0) and (`b`.`acti` <> 'I') and (`p`.`dcto_acti` = 'A') and (`x`.`acti` = 'A')) */;

/*View structure for view vmuestraordencompra */

/*!50001 DROP TABLE IF EXISTS `vmuestraordencompra` */;
/*!50001 DROP VIEW IF EXISTS `vmuestraordencompra` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestraordencompra` AS select `b`.`doco_iddo` AS `doco_iddo`,`b`.`doco_coda` AS `doco_coda`,`b`.`doco_cant` AS `doco_cant`,`b`.`doco_prec` AS `doco_prec`,`c`.`descri` AS `descri`,`c`.`prod_smin` AS `prod_smin`,`c`.`unid` AS `unid`,`c`.`prod_smax` AS `prod_smax`,`a`.`ocom_valor` AS `ocom_valor`,`a`.`ocom_igv` AS `ocom_igv`,`a`.`ocom_impo` AS `ocom_impo`,`a`.`ocom_idroc` AS `ocom_idroc`,`a`.`ocom_fech` AS `ocom_fech`,`a`.`ocom_idpr` AS `ocom_idpr`,`a`.`ocom_desp` AS `ocom_desp`,`a`.`ocom_form` AS `ocom_form`,`a`.`ocom_mone` AS `ocom_mone`,`a`.`ocom_ndoc` AS `ocom_ndoc`,`a`.`ocom_tigv` AS `ocom_tigv`,`a`.`ocom_obse` AS `ocom_obse`,`a`.`ocom_aten` AS `ocom_aten`,`a`.`ocom_deta` AS `ocom_deta`,`a`.`ocom_idus` AS `ocom_idus`,`a`.`ocom_fope` AS `ocom_fope`,`a`.`ocom_idpc` AS `ocom_idpc`,`a`.`ocom_idac` AS `ocom_idac`,`a`.`ocom_fact` AS `ocom_fact`,`d`.`razo` AS `razo`,`e`.`nomb` AS `nomb` from ((((`fe_rocom` `a` join `fe_docom` `b` on((`b`.`doco_idro` = `a`.`ocom_idroc`))) join `fe_art` `c` on((`b`.`doco_coda` = `c`.`idart`))) join `fe_prov` `d` on((`d`.`idprov` = `a`.`ocom_idpr`))) join `fe_usua` `e` on((`e`.`idusua` = `a`.`ocom_idus`))) where ((`a`.`ocom_acti` <> 'I') and (`b`.`doco_acti` <> 'I')) */;

/*View structure for view vmuestrastockfvto */

/*!50001 DROP TABLE IF EXISTS `vmuestrastockfvto` */;
/*!50001 DROP VIEW IF EXISTS `vmuestrastockfvto` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestrastockfvto` AS select `a`.`idart` AS `idart`,sum(if((`a`.`tipo` = 'C'),(`a`.`cant` * `a`.`kar_equi`),-((`a`.`cant` * `a`.`kar_equi`)))) AS `cant`,`t`.`fech_fvto` AS `kar_fvto`,`t`.`fech_lote` AS `kar_lote`,`t`.`fech_idka` AS `fech_idka`,`w`.`idprov` AS `idprov`,`a`.`alma` AS `alma` from (((`fe_kar` `a` join `fe_rcom` `b` on((`b`.`idauto` = `a`.`idauto`))) join `fe_fechas` `t` on((`t`.`fech_idka` = `a`.`kar_idkar`))) join `vingresos` `w` on((`w`.`kar_idkar` = `a`.`kar_idkar`))) where ((`a`.`acti` = 'A') and (`b`.`acti` = 'A')) group by `a`.`alma`,`a`.`idart`,`a`.`kar_idkar` having (`cant` > 0) */;

/*View structure for view vmuestraventas */

/*!50001 DROP TABLE IF EXISTS `vmuestraventas` */;
/*!50001 DROP VIEW IF EXISTS `vmuestraventas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestraventas` AS select `c`.`rcom_idtr` AS `rcom_idtr`,`a`.`codv` AS `codv`,`a`.`idauto` AS `idauto`,`a`.`kar_cost` AS `kar_cost`,`a`.`kar_tigv` AS `kar_tigv`,`a`.`kar_posi` AS `kar_posi`,`a`.`kar_equi` AS `kar_equi`,`a`.`kar_epta` AS `kar_epta`,`a`.`kar_comi` AS `kar_comi`,`a`.`alma` AS `alma`,`a`.`kar_idco` AS `idcosto`,`a`.`idkar` AS `idkar`,`a`.`idart` AS `Coda`,`a`.`cant` AS `cant`,`a`.`prec` AS `prec`,`c`.`valor` AS `valor`,`c`.`igv` AS `igv`,`c`.`impo` AS `impo`,`c`.`fech` AS `fech`,`c`.`fecr` AS `fecr`,`c`.`form` AS `form`,`c`.`deta` AS `deta`,`c`.`exon` AS `exon`,`c`.`ndo2` AS `ndo2`,`c`.`rcom_entr` AS `rcom_entr`,`c`.`idcliente` AS `idclie`,`d`.`razo` AS `razo`,`d`.`nruc` AS `nruc`,`d`.`dire` AS `dire`,`d`.`ciud` AS `ciud`,`d`.`ndni` AS `ndni`,`a`.`tipo` AS `tipo`,`c`.`tdoc` AS `tdoc`,`c`.`ndoc` AS `ndoc`,`c`.`dolar` AS `dolar`,`c`.`mone` AS `mone`,`b`.`descri` AS `descri`,ifnull(`x`.`idcaja`,0) AS `idcaja`,`a`.`kar_unid` AS `unid`,`b`.`premay` AS `pre1`,`b`.`peso` AS `peso`,`b`.`premen` AS `pre2`,`b`.`prod_cod1` AS `prod_cod1`,ifnull(`z`.`vend_idrv`,0) AS `nidrv`,`c`.`vigv` AS `vigv`,`c`.`idcliente` AS `idcliente`,`c`.`codt` AS `codt`,`b`.`pre3` AS `pre3`,`b`.`cost` AS `costo`,`b`.`uno` AS `uno`,`b`.`dos` AS `dos`,`b`.`tre` AS `tre`,`b`.`cua` AS `cua`,(`b`.`uno` + `b`.`dos`) AS `TAlma`,`c`.`fusua` AS `fusua`,`p`.`nomv` AS `Vendedor`,`q`.`nomb` AS `Usuario`,`b`.`tipro` AS `tipro`,`c`.`rcom_mens` AS `rcom_mens`,`c`.`idusua` AS `idusua` from (((((((`fe_art` `b` join `fe_kar` `a` on((`b`.`idart` = `a`.`idart`))) join `fe_rcom` `c` on((`a`.`idauto` = `c`.`idauto`))) left join `fe_caja` `x` on((`x`.`idauto` = `c`.`idauto`))) join `fe_clie` `d` on((`c`.`idcliente` = `d`.`idclie`))) join `fe_vend` `p` on((`p`.`idven` = `a`.`codv`))) join `fe_usua` `q` on((`q`.`idusua` = `c`.`idusua`))) left join `fe_rvendedor` `z` on((`z`.`vend_idau` = `c`.`idauto`))) where ((`c`.`tipom` = 'V') and (`c`.`acti` <> 'I') and (`a`.`acti` <> 'I')) */;

/*View structure for view vmuestravtas */

/*!50001 DROP TABLE IF EXISTS `vmuestravtas` */;
/*!50001 DROP VIEW IF EXISTS `vmuestravtas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestravtas` AS select `c`.`idusua` AS `idusua`,`a`.`kar_comi` AS `kar_comi`,`a`.`codv` AS `codv`,`a`.`idauto` AS `idauto`,`c`.`codt` AS `alma`,`a`.`kar_idco` AS `idcosto`,`a`.`idkar` AS `idkar`,`a`.`idart` AS `Coda`,`a`.`cant` AS `cant`,`a`.`prec` AS `prec`,`c`.`valor` AS `valor`,`c`.`igv` AS `igv`,`c`.`impo` AS `impo`,`c`.`fech` AS `fech`,`c`.`fecr` AS `fecr`,`c`.`form` AS `form`,`c`.`deta` AS `deta`,`c`.`exon` AS `exon`,`c`.`ndo2` AS `ndo2`,`c`.`idcliente` AS `idclie`,`d`.`razo` AS `razo`,`d`.`nruc` AS `nruc`,`d`.`dire` AS `dire`,`d`.`ciud` AS `ciud`,`d`.`ndni` AS `ndni`,`a`.`tipo` AS `tipo`,`c`.`tdoc` AS `tdoc`,`c`.`ndoc` AS `ndoc`,`c`.`dolar` AS `dolar`,`c`.`mone` AS `mone`,`c`.`vigv` AS `vigv`,`a`.`dsnc` AS `dsnc`,`a`.`dsnd` AS `dsnd`,`a`.`gast` AS `gast`,`c`.`idcliente` AS `idcliente`,`c`.`codt` AS `codt`,`c`.`fusua` AS `fusua`,`b`.`descri` AS `descri`,`b`.`unid` AS `unid`,`g`.`nomb` AS `usuario` from ((((`fe_kar` `a` left join `fe_rcom` `c` on((`c`.`idauto` = `a`.`idauto`))) join `fe_clie` `d` on((`c`.`idcliente` = `d`.`idclie`))) join `fe_art` `b` on((`b`.`idart` = `a`.`idart`))) join `fe_usua` `g` on((`g`.`idusua` = `c`.`idusua`))) where ((`c`.`tipom` = 'V') and (`c`.`acti` <> 'I') and (`a`.`acti` <> 'I')) */;

/*View structure for view vnotascompras */

/*!50001 DROP TABLE IF EXISTS `vnotascompras` */;
/*!50001 DROP VIEW IF EXISTS `vnotascompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vnotascompras` AS select `a`.`fech` AS `fecha_Comp_Origen`,`a`.`tdoc` AS `Tipo_Comprob_Origen`,left(`a`.`ndoc`,3) AS `Serie_Origen`,substr(`a`.`ndoc`,4,7) AS `Correlativo_Origen`,`e`.`idart` AS `Item_Origen`,`f`.`ncre_idan` AS `idauto` from ((`fe_rcom` `a` join `fe_nccom` `f` on((`f`.`ncre_idau` = `a`.`idauto`))) left join `fe_kar` `e` on((`e`.`idauto` = `f`.`ncre_idan`))) where (`f`.`ncre_acti` = 'A') */;

/*View structure for view vnotasventas */

/*!50001 DROP TABLE IF EXISTS `vnotasventas` */;
/*!50001 DROP VIEW IF EXISTS `vnotasventas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vnotasventas` AS select `a`.`fech` AS `fecha_Comp_Origen`,`a`.`tdoc` AS `Tipo_Comprob_Origen`,left(`a`.`ndoc`,3) AS `Serie_Origen`,substr(`a`.`ndoc`,4,7) AS `Correlativo_Origen`,`e`.`idart` AS `Item_Origen`,`f`.`ncre_idan` AS `idauto` from ((`fe_rcom` `a` join `fe_ncven` `f` on((`f`.`ncre_idau` = `a`.`idauto`))) left join `fe_kar` `e` on((`e`.`idauto` = `f`.`ncre_idan`))) where (`f`.`ncre_acti` = 'A') */;

/*View structure for view vpdtesentrega */

/*!50001 DROP TABLE IF EXISTS `vpdtesentrega` */;
/*!50001 DROP VIEW IF EXISTS `vpdtesentrega` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpdtesentrega` AS select `a`.`descri` AS `Producto`,`a`.`unid` AS `Unidad`,`a`.`peso` AS `peso`,`a`.`uno` AS `uno`,`a`.`dos` AS `dos`,`a`.`idart` AS `idart`,sum(`p`.`Pedido`) AS `Pedido`,sum(`p`.`Entregado`) AS `Entregado`,(sum(`p`.`Pedido`) - sum(`p`.`Entregado`)) AS `Saldo`,`p`.`idin` AS `idin`,`d`.`tdoc` AS `tdoc`,`d`.`ndoc` AS `ndoc`,`d`.`idauto` AS `idauto`,`e`.`razo` AS `Cliente`,`e`.`dire` AS `dire`,`e`.`ciud` AS `ciud`,`e`.`nruc` AS `nruc`,`d`.`fech` AS `fech`,`e`.`ndni` AS `ndni`,`e`.`idclie` AS `idclie`,`f`.`nomb` AS `Usuario` from ((((`vsaldos` `p` join `fe_art` `a` on((`a`.`idart` = `p`.`pdte_idar`))) join `fe_rcom` `d` on((`d`.`idauto` = `p`.`pdte_idau`))) join `fe_clie` `e` on((`e`.`idclie` = `d`.`idcliente`))) join `fe_usua` `f` on((`f`.`idusua` = `p`.`pdte_idus`))) group by `p`.`idin`,`p`.`pdte_idar` having (sum((`p`.`Pedido` - `p`.`Entregado`)) > 0) */;

/*View structure for view vpdtespago */

/*!50001 DROP TABLE IF EXISTS `vpdtespago` */;
/*!50001 DROP VIEW IF EXISTS `vpdtespago` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpdtespago` AS select `a`.`ndoc` AS `ndoc`,`a`.`fech` AS `fech`,`a`.`dola` AS `dola`,`a`.`nrou` AS `nrou`,`a`.`banc` AS `banc`,`a`.`iddeu` AS `iddeu`,max(`a`.`fevto`) AS `fevto`,round(sum((`a`.`impo` - `a`.`acta`)),2) AS `saldo`,`b`.`rdeu_idpr` AS `Idpr`,`b`.`rdeu_impc` AS `ImporteC`,'C' AS `situa`,`b`.`rdeu_idau` AS `Idauto`,`b`.`rdeu_idct` AS `rdeu_idct`,`a`.`ncontrol` AS `ncontrol`,`a`.`tipo` AS `tipo`,`a`.`banco` AS `banco`,ifnull(`c`.`ndoc`,'0') AS `docd`,ifnull(`c`.`tdoc`,'0') AS `tdoc`,`b`.`rdeu_mone` AS `Moneda`,`b`.`rdeu_codt` AS `Codt`,`b`.`rdeu_idrd` AS `Idrd` from ((`fe_deu` `a` join `fe_rdeu` `b` on((`b`.`rdeu_idrd` = `a`.`deud_idrd`))) left join `fe_rcom` `c` on((`c`.`idauto` = `b`.`rdeu_idau`))) where ((`b`.`rdeu_Acti` <> 'I') and (`a`.`acti` <> 'I')) group by `a`.`ncontrol` having (round(sum((`a`.`impo` - `a`.`acta`)),2) > 0) order by max(`a`.`fevto`) */;

/*View structure for view vpdtespagoc */

/*!50001 DROP TABLE IF EXISTS `vpdtespagoc` */;
/*!50001 DROP VIEW IF EXISTS `vpdtespagoc` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpdtespagoc` AS select `b`.`rcre_idcl` AS `idclie`,`a`.`ndoc` AS `ndoc`,round(sum((`a`.`impo` - `a`.`acta`)),2) AS `importe`,`a`.`mone` AS `mone`,`a`.`banc` AS `banc`,`b`.`rcre_fech` AS `fech`,`x`.`razo` AS `razo`,`x`.`fono` AS `fono`,`x`.`dire` AS `dire`,`x`.`ciud` AS `ciud`,max(`a`.`fevto`) AS `fevto`,`a`.`tipo` AS `tipo`,`a`.`dola` AS `dola`,ifnull(`c`.`ndoc`,'') AS `docd`,`a`.`nrou` AS `nrou`,`a`.`banco` AS `banco`,`a`.`idcred` AS `idcred`,`b`.`rcre_idau` AS `idauto`,`d`.`nomv` AS `nomv`,`a`.`ncontrol` AS `ncontrol`,`b`.`rcre_codv` AS `rcre_codv`,`a`.`estd` AS `estd`,`b`.`rcre_codt` AS `rcre_codt` from ((((`fe_cred` `a` join `fe_rcred` `b` on((`b`.`rcre_idrc` = `a`.`cred_idrc`))) left join `fe_rcom` `c` on((`c`.`idauto` = `b`.`rcre_idau`))) join `fe_vend` `d` on((`d`.`idven` = `b`.`rcre_codv`))) join `fe_clie` `x` on((`x`.`idclie` = `b`.`rcre_idcl`))) where ((`a`.`acti` <> 'I') and (`b`.`rcre_Acti` <> 'I')) group by `a`.`ncontrol` having (round(sum((`a`.`impo` - `a`.`acta`)),2) <> 0) order by max(`a`.`fevto`),`c`.`ndoc` */;

/*View structure for view vpdtesvtas */

/*!50001 DROP TABLE IF EXISTS `vpdtesvtas` */;
/*!50001 DROP VIEW IF EXISTS `vpdtesvtas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpdtesvtas` AS select `a`.`idkar` AS `idkar`,`a`.`cant` AS `Pedido`,cast(ifnull(sum(`b`.`entr_cant`),0) as unsigned) AS `Entregado` from (`fe_kar` `a` left join `fe_ent` `b` on((`b`.`entr_idkar` = `a`.`idkar`))) where ((`a`.`tipo` = 'V') and (`a`.`acti` <> 'I')) group by `a`.`idart`,`a`.`idkar` */;

/*View structure for view vpdtesx */

/*!50001 DROP TABLE IF EXISTS `vpdtesx` */;
/*!50001 DROP VIEW IF EXISTS `vpdtesx` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpdtesx` AS select `b`.`idart` AS `idart`,`a`.`fech` AS `fech`,`a`.`tdoc` AS `tdoc`,`a`.`ndoc` AS `ndoc`,`b`.`cant` AS `pedido`,sum(ifnull(`f`.`entr_cant`,0)) AS `entregado`,(`b`.`cant` - sum(ifnull(`f`.`entr_cant`,0))) AS `saldo`,ifnull(`w`.`guia_ndoc`,'') AS `guia_ndoc`,`w`.`guia_fech` AS `guia_fech`,`a`.`idauto` AS `idauto`,`a`.`idcliente` AS `idcliente`,`a`.`impo` AS `impo`,`a`.`valor` AS `valor`,`a`.`igv` AS `igv`,`a`.`form` AS `form`,`b`.`prec` AS `prec`,`b`.`idkar` AS `idkar`,`f`.`entr_acti` AS `entr_acti`,`b`.`kar_unid` AS `kar_unid` from (((`fe_kar` `b` join `fe_rcom` `a` on((`a`.`idauto` = `b`.`idauto`))) left join `fe_ent` `f` on((`f`.`entr_idkar` = `b`.`idkar`))) left join `fe_guias` `w` on((`w`.`guia_idgui` = `f`.`entr_idgu`))) where (((`a`.`acti` = 'A') and (`b`.`acti` = 'A') and (`a`.`idcliente` > 0)) or (`f`.`entr_acti` = 'A') or (`f`.`entr_acti` is null)) group by `b`.`idkar` */;

/*View structure for view vrcompras */

/*!50001 DROP TABLE IF EXISTS `vrcompras` */;
/*!50001 DROP VIEW IF EXISTS `vrcompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vrcompras` AS select `c`.`ndoc` AS `ndoc`,`c`.`valor` AS `valor`,`c`.`igv` AS `igv`,`c`.`impo` AS `impo`,`c`.`pimpo` AS `pimpo`,`c`.`fech` AS `fech`,`c`.`fecr` AS `fecr`,`c`.`form` AS `form`,`c`.`exon` AS `exon`,`c`.`ndo2` AS `ndo2`,`c`.`idauto` AS `idauto`,`c`.`deta` AS `deta`,`c`.`tcom` AS `tcom`,`c`.`vigv` AS `vigv`,`c`.`idprov` AS `idprov`,`c`.`tdoc` AS `tdoc`,`c`.`dolar` AS `dolar`,`c`.`mone` AS `mone`,`p`.`razo` AS `razo`,`p`.`dire` AS `dire`,`p`.`ciud` AS `ciud`,`p`.`nruc` AS `nruc`,ifnull(`x`.`idcaja`,0) AS `Idcaja`,`c`.`codt` AS `codt`,`c`.`fusua` AS `fusua`,`w`.`nomb` AS `Usuario` from (((`fe_rcom` `c` join `fe_prov` `p` on((`p`.`idprov` = `c`.`idprov`))) left join `fe_caja` `x` on((`x`.`idauto` = `c`.`idauto`))) join `fe_usua` `w` on((`w`.`idusua` = `c`.`idusua`))) where (`c`.`acti` <> 'I') */;

/*View structure for view vregcompras */

/*!50001 DROP TABLE IF EXISTS `vregcompras` */;
/*!50001 DROP VIEW IF EXISTS `vregcompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vregcompras` AS select `x`.`fech` AS `fech`,`x`.`fecr` AS `fecr`,`x`.`tdoc` AS `tdoc`,`x`.`ndoc` AS `ndoc`,`x`.`idprov` AS `idprov`,`x`.`ndo2` AS `ndo2`,`x`.`mone` AS `mone`,`x`.`valor` AS `valor`,`x`.`igv` AS `igv`,`x`.`impo` AS `impo`,`x`.`codt` AS `codt`,`x`.`dolar` AS `dola`,`x`.`form` AS `form`,`x`.`vigv` AS `vigv`,`x`.`idauto` AS `idauto`,`y`.`nomb` AS `usuario`,`x`.`fusua` AS `fusua`,`p`.`razo` AS `razo`,`p`.`nruc` AS `nruc`,`p`.`dire` AS `dire`,`p`.`ciud` AS `ciud`,`p`.`fono` AS `fono` from ((`fe_rcom` `x` join `fe_usua` `y` on((`y`.`idusua` = `x`.`idusua`))) join `fe_prov` `p` on((`p`.`idprov` = `x`.`idprov`))) where (`x`.`acti` <> 'I') */;

/*View structure for view vsaldos */

/*!50001 DROP TABLE IF EXISTS `vsaldos` */;
/*!50001 DROP VIEW IF EXISTS `vsaldos` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vsaldos` AS select `a`.`pdte_idar` AS `pdte_idar`,`a`.`pdte_cant` AS `Pedido`,0 AS `Entregado`,`a`.`pdte_idau` AS `pdte_idau`,`a`.`pdte_idus` AS `pdte_idus`,`a`.`pdte_idin` AS `idin` from `fe_ipdtes` `a` where (`a`.`pdte_Acti` <> 'I') union all select `a`.`pdte_idar` AS `pdte_idar`,0 AS `Pedido`,ifnull(`b`.`entr_cant`,0) AS `Entregado`,`a`.`pdte_idau` AS `pdte_idau`,`a`.`pdte_idus` AS `pdte_idus`,`b`.`entr_idin` AS `idin` from (`fe_ipdtes` `a` left join `fe_entregas` `b` on((`b`.`entr_idin` = `a`.`pdte_idin`))) where (`b`.`entr_acti` <> 'I') */;

/*View structure for view vsaldosctaspagar */

/*!50001 DROP TABLE IF EXISTS `vsaldosctaspagar` */;
/*!50001 DROP VIEW IF EXISTS `vsaldosctaspagar` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vsaldosctaspagar` AS select `a`.`rdeu_idrd` AS `rdeu_idrd`,sum((`b`.`impo` - `b`.`acta`)) AS `Saldo`,`b`.`ncontrol` AS `ncontrol` from (`fe_rdeu` `a` join `fe_deu` `b` on((`b`.`deud_idrd` = `a`.`rdeu_idrd`))) where ((`a`.`rdeu_Acti` <> 'I') and (`b`.`acti` <> 'I')) group by `b`.`ncontrol` */;

/*View structure for view vutilidad */

/*!50001 DROP TABLE IF EXISTS `vutilidad` */;
/*!50001 DROP VIEW IF EXISTS `vutilidad` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vutilidad` AS select `a`.`fech` AS `fecha`,`a`.`ndoc` AS `Documento`,`b`.`razo` AS `Cliente`,sum(((`c`.`cost_cost` + `c`.`cost_flet`) * `d`.`cant`)) AS `costo`,sum((`d`.`prec` * `d`.`cant`)) AS `precio`,`e`.`nomv` AS `Vendedor`,`f`.`nomb` AS `usuario`,`a`.`fusua` AS `FechaHora`,'00' AS `x`,`a`.`idauto` AS `idauto`,`d`.`codv` AS `codv` from (((((`fe_rcom` `a` join `fe_clie` `b` on((`b`.`idclie` = `a`.`idcliente`))) join `fe_kar` `d` on((`d`.`idauto` = `a`.`idauto`))) join `fe_costos` `c` on((`c`.`cost_idco` = `d`.`kar_idco`))) join `fe_vend` `e` on((`e`.`idven` = `d`.`codv`))) join `fe_usua` `f` on((`f`.`idusua` = `a`.`idusua`))) where ((`a`.`acti` <> 'I') and (`d`.`acti` <> 'I') and (`d`.`tipo` = 'V')) group by `a`.`idauto` */;

/*View structure for view vvolumenvtas */

/*!50001 DROP TABLE IF EXISTS `vvolumenvtas` */;
/*!50001 DROP VIEW IF EXISTS `vvolumenvtas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vvolumenvtas` AS select `a`.`idart` AS `idart`,`a`.`descri` AS `dcat`,cast(sum((`k`.`cant` * `k`.`prec`)) as decimal(12,2)) AS `impo`,`v`.`nomv` AS `nomv`,`r`.`fech` AS `fech`,`k`.`codv` AS `codv`,0 AS `idcliente`,`a`.`idcat` AS `idcat` from (((`fe_kar` `k` join `fe_rcom` `r` on((`r`.`idauto` = `k`.`idauto`))) join `fe_art` `a` on((`a`.`idart` = `k`.`idart`))) join `fe_vend` `v` on((`v`.`idven` = `k`.`codv`))) where ((`k`.`acti` = 'A') and (`r`.`acti` = 'A') and (`r`.`idcliente` > 0)) group by `k`.`codv`,`a`.`idart` */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
