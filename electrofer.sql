/*
SQLyog Ultimate v12.09 (64 bit)
MySQL - 8.0.37 : Database - sysven_bdelectrofer
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

/* Trigger structure for table `fe_clie` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `CreditosAutorizados` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `CreditosAutorizados` AFTER UPDATE ON `fe_clie` FOR EACH ROW begin
if new.clie_auto=1 then
   insert into fe_acrecli(logc_idcl,logc_idus,logc_fope)values(old.idclie,new.clie_ucre,localtime());
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

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `AnulaPagosCreditos` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `AnulaPagosCreditos` AFTER UPDATE ON `fe_ncven` FOR EACH ROW begin
   if old.ncre_idcr>0 and new.ncre_acti='I'  then
      update fe_cred set acti='I' where idcred=old.ncre_idcr;
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
   if old.idprov>0 then
        update fe_rdeu set rdeu_acti='I' where rdeu_idau=old.idauto;
     else
       update fe_rcred set rcre_acti='I',rcre_idus1=new.idusua1 where rcre_idau=old.idauto;
       update fe_rvendedor set vend_acti='I' where vend_idau=old.idauto;
   end if;
   insert into fe_aresumen(lres_fech,lres_idau,lres_idus)values(localtime,old.idauto,new.idusua1);
 else
    if new.idusua1>0 then   
   insert into fe_aresumen(lres_fech,lres_idau,lres_idus,lres_tipo)values(localtime,old.idauto,new.idusua1,'A');
   end if ;
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

/* Function  structure for function  `FunCreaCLiente` */

/*!50003 DROP FUNCTION IF EXISTS `FunCreaCLiente` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunCreaCLiente`(cruc varchar(11),crazo varchar(100),
cdire varchar(100),cciud varchar(100),cfono varchar(15),cfax varchar(15),cdni varchar (11),
ctipo char,cemail varchar(100),nidven integer,nidus integer,cpc varchar(45),ccelu varchar(15),
crefe varchar(255),linea decimal(12,2),crpm varchar(10),nidz integer,ndias integer,cconta varchar(150),cdire1 varchar(150),nids integer) RETURNS int
BEGIN
declare nid integer default 0;
INSERT INTO fe_clie(nruc,razo,dire,ciud,fono,fax,ndni,clie_tipo,clie_corr,clie_codv,clie_idus,idpcclie,
fechclie,celu,refe,clie_lcre,clie_rpm,clie_idzo,clie_dias,clie_conta,clie_dire1,clie_idse)
VALUES (cruc,crazo,cdire,cciud,cfono,cfax,cdni,ctipo,cemail,nidven,nidus,cpc,localtime,ccelu,crefe,linea,crpm,nidz,
ndias,cconta,cdire1,nids);
select last_insert_id() into nid from fe_clie group by last_insert_id();
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

/* Function  structure for function  `FuncreaProductos` */

/*!50003 DROP FUNCTION IF EXISTS `FuncreaProductos` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FuncreaProductos`(cdesc varchar(150),cunid varchar(4),nprec float,ncosto float,
np1 float,np2 float,np3 float,npeso float,ccat integer,cmar integer,ctipro char,nflete integer,cm char,cidpc varchar(45),
ncome float,ncomc float,nutil1 float,nutil2 float,nutil3 float,nidusua integer,nsmin float,nsmax float,nidcosto integer,
ndolar float,nuti0 decimal(8,5)) RETURNS int
BEGIN
declare nid integer default 0;
INSERT INTO fe_art(descri,unid,prec,cost,premay,premen,pre3,peso,idcat,idmar,tipro,idflete,tmon,fechc,idpc,prod_come,
prod_comc,prod_uti1,prod_uti2,prod_uti3,prod_idus,prod_smin,prod_smax,prod_idco,prod_dola,prod_uti0)
VALUES (cdesc,cunid,nprec,ncosto,np1,np2,np3,npeso,ccat,cmar,ctipro,156,cm,localtime,
cidpc,ncome,ncomc,nutil1,nutil2,nutil3,nidusua,nsmin,nsmax,nidcosto,ndolar,nuti0);
select last_insert_id() into nid from fe_art group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FuncreaProductos1` */

/*!50003 DROP FUNCTION IF EXISTS `FuncreaProductos1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FuncreaProductos1`(cdesc varchar(150),cunid varchar(4),nprec float,ncosto float,
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

/*!50003 CREATE FUNCTION `FunHayTraspaso`(cdcto varchar(10),ctdoc varchar(2)) RETURNS int
BEGIN
declare sw integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET sw=0;
select idauto into sw from fe_rcom where ndoc=cdcto and tdoc=ctdoc and tcom='T' and acti<>'I';
return sw;
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
ctdoc varchar(2),cform char,cndoc varchar(12),dfecha date,dfechar date,cdetalle varchar(120),
nv decimal(12,2),nigv decimal(12,2),nt decimal(12,2),cndo2 varchar(10),cm char,
ndolar decimal(6,4),ni decimal(6,4),ctg char,ccodp integer,cmvto char,nus integer,opt integer,nidcodt integer,
n1 integer,n2 integer,n3 integer,cdetalle1 varchar(120),npvta decimal(12,2)) RETURNS int
BEGIN
declare nid,ntdoc integer;
set ntdoc=0;
set nid=0;
if opt=0 then
   INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,dolar,vigv,tcom,idprov,tipom,fusua,idusua,codt,exon,pimpo)
   VALUES (ctdoc,cform,cndoc,dfecha,dfechar,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,ctg,ccodp,cmvto,localtime,nus,nidcodt,0,npvta);
   select last_insert_id() into nid from fe_rcom group by last_insert_id();
  else
   INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,dolar,vigv,tcom,idcliente,tipom,fusua,idusua,codt,rcom_nitem)
   VALUES (ctdoc,cform,cndoc,dfecha,dfecha,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,ctg,ccodp,cmvto,localtime,nus,nidcodt,0);
   select last_insert_id() into nid from fe_rcom group by last_insert_id();
end if;
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCabeceraPedido` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCabeceraPedido` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCabeceraPedido`(dfech date,nidclie integer,
cndoc varchar(10),ctdoc varchar(2),nimpo float,cform char,cusua integer,cidpcped varchar(45),nidven integer,nidtienda integer,
ctp char,
ccontacto varchar(120),cdire1 varchar(120),cfono varchar(50),ndias integer,centrega varchar(120),
ctransportista varchar(120),cmone char) RETURNS int
BEGIN
declare nid integer default 0;
INSERT INTO fe_rped(fech,idclie,ndoc,tdoc,impo,form,rped_idus,idpcped,fecho,idven,idtienda,
tipopedido,rped_cont,rped_dire,rped_fono,rped_dias,entrega,rped_trans,rped_mone)
VALUES(dfech,nidclie,cndoc,ctdoc,nimpo,cform,cusua,cidpcped,localtime,nidven,nidtienda,
ctp,ccontacto,cdire1,cfono,ndias,centrega,ctransportista,cmone);
select last_insert_id() into nid from fe_rped group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCabeceraTraspaso` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCabeceraTraspaso` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCabeceraTraspaso`(
ctdoc varchar(2),cform char,cndoc varchar(10),dfecha date,dfechar date,cdetalle varchar(120),
nv decimal(12,2),nigv decimal(12,2),nt decimal(12,2),cndo2 varchar(10),cm char,
ndolar decimal(6,4),ni decimal(6,4),ctg char,ccodp integer,cmvto char,nus integer,opt integer,nidcodt integer,
n1 integer,n2 integer,n3 integer,nitem integer,npvta decimal(12,2),cestado char) RETURNS int
BEGIN
declare nid,ntdoc integer;
set ntdoc=0;
set nid=0;
INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,dolar,vigv,tcom,idcliente,tipom,fusua,idusua,codt,rcom_nitem,rcom_reci)
VALUES (ctdoc,cform,cndoc,dfecha,dfecha,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,ctg,ccodp,cmvto,localtime,nus,nidcodt,nitem,cestado);
select last_insert_id() into nid from fe_rcom group by last_insert_id();
return nid;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaCaja` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaCaja` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaCaja`(
na integer,dfecha date,nt1 float,cmvtoc char,cform char,cm1 char,cndoc varchar(12),nidcon integer,
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
na integer,dfecha date,nt1 float,cmvtoc char,cform char,cm1 char,cndoc varchar(12),nidcon integer,
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
ctdoc VARCHAR(2),cform CHAR,cndoc VARCHAR(12),dfecha DATE,cdetalle VARCHAR(120),
nv DECIMAL(12,2),nigv DECIMAL(12,2),nt DECIMAL(12,2),cndo2 VARCHAR(10),cm CHAR,
ndolar DECIMAL(6,4),ni DECIMAL(6,4),ctg CHAR,ccodp INTEGER,cmvto CHAR,nus INTEGER,nidcodt INTEGER,
n1 INTEGER,n2 INTEGER,n3 INTEGER,nitem INTEGER,idtr DECIMAL(10,2),
nexon DECIMAL(12,2),ndscto DECIMAL(12,2),nretencion DECIMAL(8,2)
) RETURNS int
BEGIN
DECLARE nid INTEGER;
SET nid=0;
   INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,dolar,vigv,tcom,idcliente,
   tipom,fusua,idusua,codt,pimpo,rcom_exon,rcom_dsct,rcom_mret)
   VALUES (ctdoc,cform,cndoc,dfecha,dfecha,cdetalle,nv,nigv,nt,cndo2,cm,ndolar,ni,ctg,ccodp,cmvto,LOCALTIME,nus,nidcodt,
   idtr,nexon,ndscto,nretencion);
   SELECT LAST_INSERT_ID() INTO nid FROM fe_rcom GROUP BY LAST_INSERT_ID();
   IF n1>0 AND n2>0 AND n3>0 AND nv<>0 AND nigv<>0 AND nt<>0  THEN
    CALL IngresaCuentasV(nv,nigv,nt,n1,n2,n3,"H","H","D",nid,0,0);
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

/*!50003 CREATE FUNCTION `FUNINGRESANOTASCREDITOventas1`(nid0 integer,nid1 integer,nidcr integer) RETURNS int
BEGIN
declare id integer default 0;
insert into fe_ncven(ncre_idan,ncre_idau,ncre_idcr)values(nid0,nid1,nidcr);
select last_insert_id() into id from fe_ncven group by last_insert_id();
return id;
END */$$
DELIMITER ;

/* Function  structure for function  `FunIngresaOrdenCompra` */

/*!50003 DROP FUNCTION IF EXISTS `FunIngresaOrdenCompra` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunIngresaOrdenCompra`(dfecha date,nidpr integer,cmone char,
cndoc varchar(10),ctigv char,cobse varchar(220),caten varchar(150),cdeta varchar(220),
cidpc varchar(45),nidus integer,cdespacho varchar(150),cforma varchar(150),nv float,nigv float,nimpo float) RETURNS int
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
values(dfech,dfevto,nacta,cndoc,cesta,cmone,cb1,ctipo,nidrc,idusua,localtime,nctrl,cnrou,cpc);
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
cndoc varchar(12),nacta float,cesta char,cmone char,cb1 varchar(100),dfech date,
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
cndoc varchar(12),nacta float,cesta char,cmone char,cb1 varchar(100),dfech date,
dfevto date,ctipo char,nctrl integer,cnrou varchar(40),nidrc float,cpc varchar(45),
idusua integer) RETURNS int
BEGIN
declare nid integer;
set nid=0;
INSERT INTO fe_cred(fech,fevto,cred_acta,ndoc,estd,mone,banc,tipo,cred_idrc,cred_idus,cred_fope,ncontrol,nrou,cred_idpc)
values(dfech,dfevto,nacta,cndoc,cesta,cmone,cb1,ctipo,nidrc,idusua,localtime,nctrl,cnrou,cpc);
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

/* Function  structure for function  `FunRegistraCreditosformaPago` */

/*!50003 DROP FUNCTION IF EXISTS `FunRegistraCreditosformaPago` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunRegistraCreditosformaPago`(nauto integer,nid integer,cndoc varchar(12),
cest char,cmon char,crefe varchar(60),dfecha date,dfevto date,
ctipo char,cdocp varchar(12),nimpo float,ninic float,
idven integer,nimpoo float,nidus integer,nidtda integer,cpc varchar(45),cform char) RETURNS int
BEGIN
declare id integer default 0;
declare id1 integer default 0;
insert into fe_rcred(rcre_idcl,rcre_fech,rcre_idau,rcre_impc,rcre_idus,rcre_codt,rcre_idpc,rcre_inic,rcre_codv,rcre_form)
values(nid,dfecha,nauto,nimpoo,nidus,nidtda,cpc,ninic,idven,cform);
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

/* Function  structure for function  `FunRegistraDeudascctas` */

/*!50003 DROP FUNCTION IF EXISTS `FunRegistraDeudascctas` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunRegistraDeudascctas`(nauto integer,nid integer,
cmon char,dfecha date,nimpoo float,nidus integer,nidtda integer,cpc varchar(45),nidcta integer) RETURNS int
BEGIN
declare id integer default 0;
insert into fe_rdeu(rdeu_idpr,rdeu_fech,rdeu_idau,rdeu_impc,rdeu_idus,
rdeu_codt,rdeu_idpc,rdeu_mone,rdeu_idct)
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
SELECT idauto into vdvto FROM fe_rcom WHERE ndoc=cdcto and tdoc=ctdoc AND acti<>'I' and idauto<>id1 group by idauto;
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
declare vdvto,nmes,na,ndias integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
select month(fech) into nmes from fe_gene  where idgene=1;
select year(fech) into na from fe_gene where idgene=1;
if year(dfecha)<>na then
   select datediff(v.fech,dfecha) into ndias from fe_gene as v where idgene=1;
   if ndias<=15 then
      return 1;
    else
       return 1;
   end if;
 else
     if month(dfecha)=nmes then
        return 1;
     else
        select mes_idme into vdvto from fe_meses where mes_idme=month(dfecha) and mes_compra='A';
        if vdvto>0 then
          return 1;
         else
          return 1;
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
declare dfechaservidor date;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET sw=0;
select fech into dfechaservidor from fe_gene where idgene=1;
if df=dfechaservidor then
    set sw=0;
 else
    set sw=0;
end if;
return sw;
END */$$
DELIMITER ;

/* Function  structure for function  `FunVerificaCaja1` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaCaja1` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaCaja1`(df date,nidus integer) RETURNS int
BEGIN
declare sw,ndias integer;
declare dfechaservidor date;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET sw=0;
if nidus=7 or nidus=8 or nidus=20 then
   select datediff(v.fech,df) into ndias from fe_gene as v where idgene=1;
   if ndias<=30 or ndias=2 or ndias=0 or ndias=1 then
      set sw=0;
    else
      set sw=1;
   end if;
  else
   select fech into dfechaservidor from fe_gene where idgene=1;
   if dfechaservidor<>df then
      set sw=1;
    else
      set sw=0;
    end if;
end if;
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

/* Function  structure for function  `FunVerificaPedidosEntregados` */

/*!50003 DROP FUNCTION IF EXISTS `FunVerificaPedidosEntregados` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `FunVerificaPedidosEntregados`(nidped integer) RETURNS int
BEGIN
declare vdvto integer default 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdvto=0;
SELECT idped into vdvto FROM vpentregas where idped=nidped group by idped;
return vdvto;
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

/*!50003 CREATE PROCEDURE `AbrirCaja`(dfecha date,nidu integer)
BEGIN
update fe_caja set estado=' ' where fech=dfecha and idusua=nidu;
END */$$
DELIMITER ;

/* Procedure structure for procedure `astock` */

/*!50003 DROP PROCEDURE IF EXISTS  `astock` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `astock`(in coda integer,in nalma integer,in ccant float,in ctipo char(1))
BEGIN
case
   when ctipo="C" then
      case
      when nalma=1 then
          UPDATE fe_art SET uno=uno+ccant WHERE idart=coda and tipro<>'S';
      when nalma=2 then
          UPDATE fe_art SET dos=dos+ccant WHERE idart=coda and tipro<>'S';
      when nalma=3 then
          UPDATE fe_art SET tre=tre+ccant WHERE idart=coda and tipro<>'S';
      when nalma=4 then
          UPDATE fe_art SET cua=cua+ccant WHERE idart=coda and tipro<>'S';
      when nalma=5 then
          UPDATE fe_art SET cin=cin+ccant WHERE idart=coda and tipro<>'S';
      else
          UPDATE fe_art SET sei=sei+ccant WHERE idart=coda and tipro<>'S';
      end case;
   when ctipo="V" then
      case
      when  nalma=1 then
          UPDATE fe_art SET uno=uno-ccant WHERE idart=coda and tipro<>'S';
      when nalma=2 then
          UPDATE fe_art SET dos=dos-ccant WHERE idart=coda and tipro<>'S';
      when nalma=3 then
          UPDATE fe_art SET tre=tre-ccant WHERE idart=coda and tipro<>'S';
      when  nalma=4 then
          UPDATE fe_art SET cua=cua-ccant WHERE idart=coda and tipro<>'S';
      when nalma=5 then
          UPDATE fe_art SET cin=cin-ccant WHERE idart=coda and tipro<>'S';
      else
          UPDATE fe_art SET sei=sei-ccant WHERE idart=coda and tipro<>'S';
     end case;
  else
      case
      when nalma=1 then
          UPDATE fe_art SET uno=ccant WHERE idart=coda and tipro<>'S';
      when nalma=2 then
          UPDATE fe_art SET dos=ccant WHERE idart=coda and tipro<>'S';
      when nalma=3 then
          UPDATE fe_art SET tre=ccant WHERE idart=coda and tipro<>'S';
      when nalma=4 then
          UPDATE fe_art SET cua=ccant WHERE idart=coda and tipro<>'S';
      when nalma=5 then
          UPDATE fe_art SET cin=ccant WHERE idart=coda and tipro<>'S';
      else
          UPDATE fe_art SET sei=ccant WHERE idart=coda and tipro<>'S';
     end case;
  end case;
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
where b.acti<>'I' group by  idart,alma) as a;
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

/*!50003 CREATE PROCEDURE `CierraCaja`(dfecha date, nidu integer)
BEGIN
update fe_caja set estado='C' where fech=dfecha and idusua=nidu;
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

/* Procedure structure for procedure `ProActualizaCabeceraCV` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCabeceraCV` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCabeceraCV`(
ctdoc varchar(2),cform char,cndoc varchar(12),dfecha date,dfechar date,cdetalle varchar(120),
nv decimal(12,2),nigv decimal(12,2),nt decimal(12,2),cndo2 varchar(10),cm char,
ndolar decimal(6,4),ni decimal(6,4),ctg char,ccodp integer,cmvto char,nus integer,opt integer,nidcodt integer,
n1 integer,n2 integer,n3 integer,cdetalle1 varchar(120),npvta float,nidauto integer)
BEGIN
if opt=0 then
   update fe_rcom set tdoc=ctdoc,form=cform,ndoc=cndoc,fech=dfecha,fecr=dfechar,deta=cdetalle,valor=nv,igv=nigv,impo=nt,ndo2=cndo2,
   mone=cm,dolar=ndolar,vigv=ni,tcom=ctg,idprov=ccodp,tipom=cmvto,idusua1=nus,codt=nidcodt,exon=0,pimpo=npvta where idauto=nidauto;
  else
   update fe_rcom set tdoc=ctdoc,form=cform,ndoc=cndoc,fech=dfecha,fecr=dfechar,deta=cdetalle,valor=nv,igv=nigv,impo=nt,ndo2=cndo2,
   mone=cm,dolar=ndolar,vigv=ni,tcom=ctg,idcliente=ccodp,tipom=cmvto,idusua1=nus,codt=nidcodt,rcom_nitem=0 where idauto=nidauto;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaCabeceraCV1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCabeceraCV1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCabeceraCV1`(
ctdoc varchar(2),cform char,cndoc varchar(12),dfecha date,dfechar date,cdetalle varchar(120),
nv decimal(12,2),nigv decimal(12,2),nt decimal(12,2),cndo2 varchar(10),cm char,
ndolar decimal(6,4),ni decimal(6,4),ctg char,ccodp integer,cmvto char,nus integer,opt integer,nidcodt integer,
n1 integer,n2 integer,n3 integer,cdetalle1 varchar(120),npvta decimal(10,2),nidauto integer)
BEGIN
if opt=0 then
   update fe_rcom set tdoc=ctdoc,form=cform,ndoc=cndoc,fech=dfecha,fecr=dfechar,deta=cdetalle,valor=nv,igv=nigv,impo=nt,ndo2=cndo2,
   mone=cm,dolar=ndolar,vigv=ni,tcom=ctg,idprov=ccodp,tipom=cmvto,idusua1=nus,codt=nidcodt,pimpo=npvta where idauto=nidauto;
  else
   update fe_rcom set tdoc=ctdoc,form=cform,ndoc=cndoc,fech=dfecha,fecr=dfechar,
   deta=cdetalle,ndo2=cndo2,
   dolar=ndolar,vigv=ni,tcom=ctg,idcliente=ccodp,tipom=cmvto,idusua1=nus,codt=nidcodt where idauto=nidauto;
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

/*!50003 CREATE PROCEDURE `ProActualizaCliente`(nid INTEGER,cruc VARCHAR(11),crazo VARCHAR(100),
cdire VARCHAR(100),cciud VARCHAR(100),cfono VARCHAR(15),cfax VARCHAR(15),cdni VARCHAR (11),
ctipo CHAR,cemail VARCHAR(100),nidven INTEGER,nidus INTEGER,ccelu VARCHAR(15),
crefe VARCHAR(255),linea DECIMAL(12,2),crpm VARCHAR(10),nidz INTEGER,ndias INTEGER,cconta VARCHAR(150),cdire1 VARCHAR(150),nidsegmento INTEGER)
BEGIN
UPDATE fe_clie SET
nruc=cruc,razo=crazo,dire=cdire,ciud=cciud,fono=cfono,fax=cfax,ndni=cdni,clie_tipo=ctipo,clie_corr=cemail,
clie_codv=nidven,clie_actu=nidus,clie_feac=LOCALTIME,celu=ccelu,refe=crefe,clie_lcre=linea,clie_rpm=crpm,clie_idzo=nidz,
clie_dias=ndias,clie_conta=cconta,clie_dire1=cdire1,clie_idse=nidsegmento WHERE idclie=nid;
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

/* Procedure structure for procedure `ProActualizaCreditos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaCreditos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaCreditos`(nauto integer,nu integer)
BEGIN
update fe_rcred set rcre_acti='I',rcre_idus1=nu where rcre_idau=nauto;
END */$$
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

/* Procedure structure for procedure `ProActualizaDeudas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaDeudas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaDeudas`(nauto integer,nu integer)
BEGIN
update fe_rdeu set rdeu_acti='I',rdeu_idus1=nu where rdeu_idau=nauto;
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

/* Procedure structure for procedure `ProActualizaLdctos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaLdctos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaLdctos`(df date,nid integer,opt integer)
begin
if opt=0 then
  update fe_ldctos set dctos_acti='I',dctos_chek=0 where dctos_idoc=nid;
else
 if opt=1 then
  update fe_ldctos set dctos_chek=1,dctos_fecr=df where dctos_idoc=nid;
 else
  update fe_ldctos set dctos_chek=0 where dctos_idoc=nid;
  end if;
end if;
end */$$
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
cndoc varchar(10),ctigv char,cobse varchar(220),caten varchar(150),cdeta varchar(220),
nidus integer,nid integer,cdespacho varchar(150),cforma varchar(150),nv float,nigv float,nimpo float)
BEGIN
update fe_rocom set ocom_fech=dfecha,ocom_idpr=nidpr,ocom_mone=cmone,ocom_ndoc=cndoc,
ocom_tigv=ctigv,ocom_obse=cobse,ocom_aten=caten,ocom_deta=cdeta,ocom_idac=nidus,ocom_fact=current_date(),
ocom_desp=cdespacho,ocom_form=cforma,ocom_valor=nv,ocom_igv=nigv,ocom_impo=nimpo where ocom_idroc=nid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaPedido1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaPedido1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaPedido1`(dfech datetime,nidclie integer,
cndoc varchar(10),ctdoc varchar(2),nimpo float,cform char,cusua integer,nidven integer,nidtienda integer,ctp char,
ccontacto varchar(120),cdire1 varchar(120),cfono varchar(50),ndias integer,centrega varchar(120),
ctransportista varchar(120),cmone char,nidauto integer)
BEGIN
UPDATE fe_rped SET fech=dfech,idclie=nidclie,ndoc=cndoc,impo=nimpo,form=cform,idven=nidven,facturado='N',tdoc=ctdoc,
tipopedido='P',rped_cont=ccontacto,rped_dire=cdire1,rped_fono=cfono,rped_dias=ndias,entrega=centrega,rped_trans=ctransportista WHERE idautop=nidauto;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROACTUALIZAPRECIOGUIAS` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROACTUALIZAPRECIOGUIAS` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROACTUALIZAPRECIOGUIAS`(nidk integer,nprec float )
BEGIN
update fe_kar set prec=nprec where idkar=nidk;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaPreciosProducto` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaPreciosProducto` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaPreciosProducto`(
cc integer,dfe date,npr float,cnd integer,idp integer,cmda char,ni float,ndolar float,nidcosto integer)
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

/* Procedure structure for procedure `ProActualizaProductos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaProductos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaProductos`(cdesc varchar(150),cunid varchar(4),ncosto float,np1 float,np2 float,
np3 float,npeso float,ccat integer,cmar integer,ctipro char,nflete integer,cm char,nprecio float,
nidgrupo integer,nutil1 float,nutil2 float,nutil3 float,ncome float,
ncomc float,nidus integer,ncoda integer,nsmin float,nsmax float,nidcosto integer,ndolar float,cestado char,
nutil0 DECIMAL(8,4))
BEGIN
UPDATE fe_art SET descri=cdesc,unid=cunid,cost=ncosto,premay=np1,premen=np2,pre3=np3,peso=npeso,idcat=ccat,idmar=cmar,tipro=ctipro,idflete=nflete,tmon=cm,
prec=nprecio,prod_uti1=nutil1,prod_uti2=nutil2,prod_uti3=nutil3,
prod_come=ncome,prod_comc=ncomc,prod_uact=nidus,prod_fact=localtime,prod_smax=nsmax,
prod_smin=nsmin,prod_idco=nidcosto,prod_dola=ndolar,prod_acti=cestado,prod_uti0=nutil0
  WHERE idart=ncoda;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaProveedor` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaProveedor` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaProveedor`(nid integer,cruc varchar(11),crazo varchar(60),
cdire varchar(60),cciud varchar(50),cfono varchar(15),cfax varchar(15),
cemail varchar(45),nidus integer,ccelu varchar(15),crefe varchar(200),crpm varchar(10))
BEGIN
update fe_prov set
nruc=cruc,razo=crazo,dire=cdire,ciud=cciud,fono=cfono,fax=cfax,email=cemail,
prov_actu=nidus,prov_feac=current_date(),celu=ccelu,refe=crefe,prov_rpm=crpm
where idprov=nid;
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

/* Procedure structure for procedure `ProActualizaSoloVendedorVtas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaSoloVendedorVtas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaSoloVendedorVtas`(nidauto integer,nidv integer)
BEGIN
update fe_kar set codv=nidv where idauto=nidauto;
update fe_rcred set rcre_codv=nidv where rcre_idau=nidauto;
update fe_rvendedor set vend_codv=nidv where vend_idau=nidauto;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProActualizaStock` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProActualizaStock` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProActualizaStock`(coda integer,nalma integer,ccant float,ctipo char(1),ncaant float)
BEGIN
  case
  when ctipo="C" then
      case
      when nalma=1 then
          UPDATE fe_art SET uno=(uno-ncaant)+ccant WHERE idart=coda and tipro<>'S';
      when nalma=2 then
          UPDATE fe_art SET dos=(dos-ncaant)+ccant WHERE idart=coda and tipro<>'S';
      when nalma=3 then
          UPDATE fe_art SET tre=(tre-ncaant)+ccant WHERE idart=coda and tipro<>'S';
      when nalma=4 then
          UPDATE fe_art SET cua=(cua-ncaant)+ccant WHERE idart=coda and tipro<>'S';
      else
          UPDATE fe_art SET cin=(cin-ncaant)+ccant WHERE idart=coda and tipro<>'S';
     end case;
   when ctipo="V" then
      case
       when nalma=1 then
          UPDATE fe_art SET uno=(uno+ncaant)-ccant WHERE idart=coda and tipro<>'S';
      when nalma=2 then
          UPDATE fe_art SET dos=(dos+ncaant)-ccant WHERE idart=coda and tipro<>'S';
      when nalma=3 then
          UPDATE fe_art SET tre=(tre+ncaant)-ccant WHERE idart=coda and tipro<>'S';
      when nalma=4 then
          UPDATE fe_art SET cua=(cua+ncaant)-ccant WHERE idart=coda and tipro<>'S';
      else
          UPDATE fe_art SET cin=(cin+ncaant)-ccant WHERE idart=coda and tipro<>'S';
     end case;
  end case;
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

/* Procedure structure for procedure `ProAnulaCanjesNotas` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaCanjesNotas` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaCanjesNotas`(nid integer,ctipo char)
begin
if ctipo='C' then
   update fe_nccom set ncre_acti='A' where ncre_idnc=nid;
else
   update fe_ncven set ncre_acti='A' where ncre_idnc=nid;
end if;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaEntregaFisica` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaEntregaFisica` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaEntregaFisica`(na integer,nu integer)
BEGIN
update fe_guias set guia_acti='I' where guia_idgui=na;
update fe_ent set entr_cant=0,entr_acti='I' where entr_idgu=na;
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
call ProActualizaResumenEntregas(nid);
commit;
set estado:="Ok";
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProAnulaTransacciones` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProAnulaTransacciones` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProAnulaTransacciones`(OUT estado varchar(500), ctdoc varchar(2), cndoc varchar(12),
 ctipo char, nidauto integer, nu integer,  sw char,dfecha date, nu1 integer)
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
      update fe_canjesp set canp_acti='I' where canp_idau=nid;
      if @nguia>0 then
         CALL ProAnulaEntregaFisica(@nguia,nu1);
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

/* Procedure structure for procedure `ProCreaVinculoCliente` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProCreaVinculoCliente` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProCreaVinculoCliente`(nidc integer,nidp integer)
BEGIN
insert into fe_vclientes(ecli_idcl,ecli_idin)values(nidc,nidp);
update fe_clie set clie_idvi=nidp where idclie=nidc;
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

/* Procedure structure for procedure `PRODSTOCKS` */

/*!50003 DROP PROCEDURE IF EXISTS  `PRODSTOCKS` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PRODSTOCKS`(nidart integer)
BEGIN
select uno,dos,tre,cua,cin,sei from fe_art where idart=nidart;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProEditaAlmacen` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProEditaAlmacen` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProEditaAlmacen`(cnomb varchar(50),cdire varchar(50),cciud varchar(50),nser integer,nidus integer,nid integer)
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

/* Procedure structure for procedure `ProEditaVinculoCliente` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProEditaVinculoCliente` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProEditaVinculoCliente`(nidc integer)
BEGIN
update fe_vclientes set ecli_acti='I' where ecli_idcl=nidc and ecli_acti='A';
update fe_clie set clie_idvi=0 where idclie=nidc;
END */$$
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

/* Procedure structure for procedure `ProIngresaLdctos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProIngresaLdctos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProIngresaLdctos`(df date,nidauto integer,nidguia integer,cres varchar(120),cndoc varchar(20),codv integer)
begin
insert into fe_ldctos(dctos_fech,dctos_idau,dctos_idgu,dctos_resp,dctos_ndoc,dctos_vend)
values(df,nidauto,nidguia,cres,cndoc,codv);
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

/*!50003 CREATE PROCEDURE `Proingresa_anulada`(in dfecha Datetime,in cndoc varchar(12),in ctdoc varchar(2),in nidus integer,in nidcon integer)
begin
 select @nc:=idclie from fe_clie where nruc='***********';
 insert into fe_rcom(idcliente,fech,fecr,ndoc,tdoc,tipom,deta,ndo2,tcom,form,mone,exon,fusua,idusua)
 values(@nc,dfecha,dfecha,cndoc,ctdoc,'V','','','K','E','S',0,localtime,nidus);
 SELECT @na:=LAST_INSERT_ID() FROM fe_rcom group by LAST_INSERT_ID();
 INSERT INTO fe_caja(idauto,fech,impo,tipo,forma,tmon,ndoc,idcon,idusua,fechao,deta,origen)
 VALUES (@na,dfecha,0,"I","E","S",cndoc,nidcon,nidus,localtime,"*** ANULADA ***","CK");
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
SELECT nomb,idalma,dire,ciud,sucuidserie,sucu_idus,ubigeo  FROM fe_sucu order by idalma;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraAlmacenes1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraAlmacenes1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraAlmacenes1`()
BEGIN
select fisi_nomb,fisi_iden from fe_almfisico order by fisi_iden;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PromuestraBancos` */

/*!50003 DROP PROCEDURE IF EXISTS  `PromuestraBancos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PromuestraBancos`(cb varchar(20))
BEGIN
declare cb1 varchar(20);
set cb1=concat('%',trim(cb),'%');
select banc_nomb,banc_idba from fe_bancos where banc_nomb like cb1 and banc_acti='A' order by banc_nomb;
END */$$
DELIMITER ;

/* Procedure structure for procedure `PROMuestraClientes` */

/*!50003 DROP PROCEDURE IF EXISTS  `PROMuestraClientes` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `PROMuestraClientes`(cbusca VARCHAR(80),opt INTEGER,nid INTEGER)
BEGIN
DECLARE cbuscar VARCHAR(80);
SET cbuscar=CONCAT('%',TRIM(cbusca),+'%');
CASE
WHEN opt=0 THEN
   SELECT idclie,nruc,razo,ndni,dire,ciud,IFNULL(fono,'0') AS fono,IFNULL(fax,'0') AS fax,
   IFNULL(celu,'0') AS celu,refe,clie_tipo,clie_codv,clie_lcre,clie_corr,
   clie_rpm,clie_idus,clie_actu,fechclie,clie_feac,IFNULL(c.zona_nomb,'') AS Zona,IFNULL(a.clie_idzo,0) AS clie_idzo,
   clie_dias,clie_conta,clie_dire1,clie_idvi,clie_auto,clie_idse,segm_segm AS segmento,u.nomb AS usuacreo,
   uu.nomb AS usuamodifico,clie_rete
   FROM fe_clie AS a 
   INNER JOIN fe_segmento  AS s ON s.segm_idse=a.clie_idse
   LEFT JOIN fe_zona AS c ON c.zona_idzo=a.clie_idzo
   LEFT JOIN fe_usua AS u  ON u.idusua=a.clie_idus
   LEFT JOIN fe_usua AS uu ON uu.idusua=a.clie_actu  WHERE  clie_acti<>'I' AND razo LIKE cbuscar ORDER BY razo;
WHEN opt=1 THEN
   SELECT idclie,nruc,razo,ndni,dire,ciud,IFNULL(fono,'0') AS fono,IFNULL(fax,'0') AS fax,
   IFNULL(celu,'0') AS celu,refe,clie_tipo,clie_codv,clie_lcre,clie_corr,
   clie_rpm,clie_idus,clie_actu,fechclie,clie_feac,IFNULL(c.zona_nomb,'') AS Zona,IFNULL(a.clie_idzo,0) AS clie_idzo,
   clie_dias,clie_conta,clie_dire1,clie_idvi,clie_auto,clie_idse,segm_segm AS segmento,
   u.nomb AS usuacreo,uu.nomb AS usuamodifico,clie_rete
   FROM fe_clie AS a 
   INNER JOIN fe_segmento  AS s ON s.segm_idse=a.clie_idse
   LEFT JOIN fe_zona AS c ON c.zona_idzo=a.clie_idzo
   LEFT JOIN fe_usua AS u  ON u.idusua=a.clie_idus
   LEFT JOIN fe_usua AS uu ON uu.idusua=a.clie_actu 
   WHERE  clie_acti<>'I' AND nruc LIKE cbuscar ORDER BY razo;
WHEN opt=2 THEN
   SELECT idclie,nruc,razo,ndni,dire,ciud,IFNULL(fono,'0') AS fono,IFNULL(fax,'0') AS fax,
   IFNULL(celu,'0') AS celu,refe,clie_tipo,clie_codv,clie_lcre,clie_corr,
   clie_rpm,clie_idus,clie_actu,fechclie,clie_feac,IFNULL(c.zona_nomb,'') AS Zona,IFNULL(a.clie_idzo,0) AS clie_idzo,
   clie_dias,clie_conta,clie_dire1,clie_idvi,clie_auto,clie_idse,segm_segm AS segmento,
   u.nomb AS usuacreo,uu.nomb AS usuamodifico,clie_rete
   FROM fe_clie AS a 
   INNER JOIN fe_segmento  AS s ON s.segm_idse=a.clie_idse
   LEFT JOIN fe_zona AS c ON c.zona_idzo=a.clie_idzo
   LEFT JOIN fe_usua AS u  ON u.idusua=a.clie_idus
   LEFT JOIN fe_usua AS uu ON uu.idusua=a.clie_actu  WHERE  clie_acti<>'I' AND  ndni LIKE cbuscar ORDER BY razo;
WHEN opt=3 THEN
   SELECT idclie,nruc,razo,ndni,dire,ciud,IFNULL(fono,'0') AS fono,IFNULL(fax,'0') AS fax,
   IFNULL(celu,'0') AS celu,refe,clie_tipo,clie_codv,clie_lcre,clie_corr,
   clie_rpm,clie_idus,clie_actu,fechclie,clie_feac,IFNULL(c.zona_nomb,'') AS Zona,IFNULL(a.clie_idzo,0) AS clie_idzo,
   clie_dias,clie_conta,clie_dire1,clie_idvi,clie_auto,clie_idse,segm_segm AS segmento,
   u.nomb AS usuacreo,uu.nomb AS usuamodifico,clie_rete
   FROM fe_clie AS a 
   INNER JOIN fe_segmento  AS s ON s.segm_idse=a.clie_idse
   LEFT JOIN fe_zona AS c ON c.zona_idzo=a.clie_idzo
   LEFT JOIN fe_usua AS u  ON u.idusua=a.clie_idus
   LEFT JOIN fe_usua AS uu ON uu.idusua=a.clie_actu 
   WHERE  clie_acti<>'I' AND idclie =nid ORDER BY razo;
WHEN opt=4 THEN
   SELECT idclie,nruc,razo,ndni,dire,ciud,IFNULL(fono,'0') AS fono,IFNULL(fax,'0') AS fax,
   IFNULL(celu,'0') AS celu,refe,clie_tipo,clie_codv,clie_lcre,clie_corr,
   clie_rpm,clie_idus,clie_actu,fechclie,clie_feac,IFNULL(c.zona_nomb,'') AS Zona,IFNULL(a.clie_idzo,0) AS clie_idzo,
   clie_dias,clie_conta,clie_dire1,clie_idvi,clie_auto,clie_idse,segm_segm AS segmento,
   u.nomb AS usuacreo,uu.nomb AS usuamodifico,clie_rete
   FROM fe_clie AS a 
   INNER JOIN fe_segmento  AS s ON s.segm_idse=a.clie_idse
   LEFT JOIN fe_zona AS c ON c.zona_idzo=a.clie_idzo
   LEFT JOIN fe_usua AS u  ON u.idusua=a.clie_idus
   LEFT JOIN fe_usua AS uu ON uu.idusua=a.clie_actu 
   WHERE  clie_acti<>'I' AND ciud LIKE cbuscar ORDER BY razo;
 WHEN opt=5 THEN
   SELECT idclie,nruc,razo,ndni,dire,ciud,IFNULL(fono,'0') AS fono,IFNULL(fax,'0') AS fax,
   IFNULL(celu,'0') AS celu,refe,clie_tipo,clie_codv,clie_lcre,clie_corr,
   clie_rpm,clie_idus,clie_actu,fechclie,clie_feac,IFNULL(c.zona_nomb,'') AS Zona,IFNULL(a.clie_idzo,0) AS clie_idzo,
   clie_dias,clie_conta,clie_dire1,clie_idvi,clie_auto,clie_idse,segm_segm AS segmento,
   u.nomb AS usuacreo,uu.nomb AS usuamodifico
   FROM fe_clie AS a 
   INNER JOIN fe_segmento  AS s ON s.segm_idse=a.clie_idse
   LEFT JOIN fe_usua AS u  ON u.idusua=a.clie_idus
   LEFT JOIN fe_usua AS uu ON uu.idusua=a.clie_actu 
   LEFT JOIN fe_zona AS c ON c.zona_idzo=a.clie_idzo WHERE  clie_acti<>'I' AND c.zona_nomb LIKE cbuscar ORDER BY razo;  
WHEN opt=6 THEN
   SELECT idclie,nruc,razo,ndni,dire,ciud,IFNULL(fono,'0') AS fono,IFNULL(fax,'0') AS fax,
   IFNULL(celu,'0') AS celu,refe,clie_tipo,clie_codv,clie_lcre,clie_corr,
   clie_rpm,clie_idus,clie_actu,fechclie,clie_feac,IFNULL(c.zona_nomb,'') AS Zona,IFNULL(a.clie_idzo,0) AS clie_idzo,
   clie_dias,clie_conta,clie_dire1,clie_idvi,clie_auto,clie_idse,segm_segm AS segmento,IFNULL(v.nomv,'') AS vendedor,
   u.nomb AS usuacreo,uu.nomb AS usuamodifico,clie_rete
   FROM fe_clie AS a 
   INNER JOIN fe_segmento  AS s ON s.segm_idse=a.clie_idse
   LEFT JOIN fe_zona AS c ON c.zona_idzo=a.clie_idzo 
   LEFT JOIN fe_vend AS v ON v.idven=a.clie_codv
   LEFT JOIN fe_usua AS u  ON u.idusua=a.clie_idus
   LEFT JOIN fe_usua AS uu ON uu.idusua=a.clie_actu 
   WHERE  clie_acti<>'I' AND v.nomv LIKE cbuscar ORDER BY razo;  
WHEN opt=7 THEN
   SELECT idclie,nruc,razo,ndni,dire,ciud,IFNULL(fono,'0') AS fono,IFNULL(fax,'0') AS fax,
   IFNULL(celu,'0') AS celu,refe,clie_tipo,clie_codv,clie_lcre,clie_corr,
   clie_rpm,clie_idus,clie_actu,fechclie,clie_feac,IFNULL(c.zona_nomb,'') AS Zona,IFNULL(a.clie_idzo,0) AS clie_idzo,
   clie_dias,clie_conta,clie_dire1,clie_idvi,clie_auto,clie_idse,segm_segm AS segmento,
   u.nomb AS usuacreo,uu.nomb AS usuamodifico,clie_rete
   FROM fe_clie AS a 
   INNER JOIN fe_segmento  AS s ON s.segm_idse=a.clie_idse
   LEFT JOIN fe_zona AS c ON c.zona_idzo=a.clie_idzo 
   LEFT JOIN fe_usua AS u  ON u.idusua=a.clie_idus
   LEFT JOIN fe_usua AS uu ON uu.idusua=a.clie_actu   
   WHERE  clie_acti<>'I' AND  s.segm_segm  LIKE cbuscar ORDER BY razo;      
END CASE;
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

/* Procedure structure for procedure `ProMuestraProductos` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraProductos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraProductos`(abuscar varchar(80),nd float)
BEGIN
declare cbuscar varchar(80);
declare vigv decimal(6,4);
select igv into vigv from fe_gene where idgene=1;
set cbuscar=concat('%',trim(abuscar),+'%');
SELECT idart,descri,unid,uno,dos,tre,cua,cin,sei,
ifnull(round(if(tmon='S',((a.prec*vigv)+b.prec)*prod_uti1,((a.prec*vigv*if(prod_dola>nd,prod_dola,nd))+b.prec)*prod_uti1),2),0) as pre1,
ifnull(round(if(tmon='S',((a.prec*vigv)+b.prec)*prod_uti2,((a.prec*vigv*if(prod_dola>nd,prod_dola,nd))+b.prec)*prod_uti2),2),0) as pre2,
ifnull(round(if(tmon='S',((a.prec*vigv)+b.prec)*prod_uti3,((a.prec*vigv*if(prod_dola>nd,prod_dola,nd))+b.prec)*prod_uti3),2),0) as pre3,
round(if(tmon='S',(a.prec*vigv)+b.prec,(a.prec*vigv*nd)+b.prec),2) as costo,c.idgrupo,c.dcat,prod_dola,
round(if(tmon='S',(a.prec*vigv),(a.prec*vigv*nd)),2) as costosf,b.prec as flete,
ifnull(d.cost_cost,0) as costor,ifnull(d.cost_prec,0) as precr,ifnull(d.cost_mone,'')  as moner,
cast(ifnull(d.cost_idco,0) as unsigned) as cost_idco,ifnull(d.cost_flet,0)  as fleter,ifnull(d.cost_dola,0) as dolar,
peso,a.prec,tipro,a.idmar,a.idcat,cost,tmon,a.idflete,prod_uti1,prod_uti2,prod_uti3,prod_idus,
prod_come,prod_comc,ulpc,prod_idus,prod_uact,prod_fact,fechc,prod_smax,prod_smin,ifnull(o.razo,'') as proveedor,
ifnull(y.ndoc,'') as ndoc,ifnull(y.fech,'') as fech,ulfc,s.dmar
FROM fe_art  as a inner join fe_fletes as b on(b.idflete=a.idflete)
inner join fe_cat as c on(c.idcat=a.idcat)
inner join fe_mar as s ON s.idmar=a.idmar left join fe_costos as d on(d.cost_idco=a.prod_idco)
left join fe_rcom as y on (y.idauto=a.prod_idau) left join fe_prov as o on (o.idprov=y.idprov)
WHERE descri LIKE cbuscar and prod_acti<>'I' ORDER BY s.dmar,a.DESCRI;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraProductos1` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraProductos1` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraProductos1`(abuscar VARCHAR(80), nd FLOAT,opt INTEGER,nid INTEGER)
BEGIN
DECLARE cbuscar VARCHAR(80);
case
when opt=1 THEN
   SET cbuscar=CONCAT('%',TRIM(abuscar),+'%');
   SELECT idart,descri,unid,uno,dos,tre,cua,cin,sei,
   IFNULL(ROUND(IF(tmon='S',((a.prec*v.igv)+b.prec)*prod_uti1,((a.prec*v.igv*IF(prod_dola>nd,prod_dola,nd))+b.prec)*prod_uti1),2),0) AS pre1,
   IFNULL(ROUND(IF(tmon='S',((a.prec*v.igv)+b.prec)*prod_uti2,((a.prec*v.igv*IF(prod_dola>nd,prod_dola,nd))+b.prec)*prod_uti2),2),0) AS pre2,
   IFNULL(ROUND(IF(tmon='S',((a.prec*v.igv)+b.prec)*prod_uti3,((a.prec*v.igv*IF(prod_dola>nd,prod_dola,nd))+b.prec)*prod_uti3),2),0) AS pre3,
   IFNULL(ROUND(IF(tmon='S',((a.prec*v.igv)+b.prec)*prod_uti0,((a.prec*v.igv*IF(prod_dola>nd,prod_dola,nd))+b.prec)*prod_uti0),2),0) AS pre0,   
   ROUND(IF(tmon='S',(a.prec*v.igv)+b.prec,(a.prec*v.igv*nd)+b.prec),2) AS costo,c.idgrupo,c.dcat,prod_dola,
   ROUND(IF(tmon='S',(a.prec*v.igv),(a.prec*v.igv*nd)),2) AS costosf,b.prec AS flete,
   IFNULL(d.cost_cost,0) AS costor,IFNULL(d.cost_prec,0) AS precr,IFNULL(d.cost_mone,'')  AS moner,
   CAST(IFNULL(d.cost_idco,0) AS UNSIGNED) AS cost_idco,IFNULL(d.cost_flet,0)  AS fleter,IFNULL(d.cost_dola,0) AS dolar,
   peso,a.prec,tipro,a.idmar,a.idcat,cost,tmon,a.idflete,prod_uti1,prod_uti2,prod_uti3,prod_uti0,prod_idus,
   prod_come,prod_comc,ulpc,prod_idus,prod_uact,prod_fact,fechc,prod_smax,prod_smin,IFNULL(o.razo,'') AS proveedor,
   IFNULL(yy.ndoc,'') AS ndoc,IFNULL(yy.fech,'') AS fech,ulfc,s.dmar,prod_acti,prod_perm,prod_perx,
   u.nomb AS usuacreo,us.nomb AS usuamodifico,g.desgrupo AS grupo,b.desflete,prod_ocan,prod_ocom,prod_cod1
   FROM fe_art  AS a 
   INNER JOIN fe_fletes AS b ON(b.idflete=a.idflete)
   INNER JOIN fe_cat AS c ON(c.idcat=a.idcat)
   INNER JOIN fe_grupo AS g ON g.idgrupo=c.idgrupo
   INNER JOIN fe_mar AS s ON s.idmar=a.idmar 
   LEFT JOIN fe_costos AS d ON(d.cost_idco=a.prod_idco)
   LEFT JOIN fe_rcom AS yy ON (yy.idauto=a.prod_idau) 
   LEFT JOIN fe_prov AS o ON (o.idprov=yy.idprov)
   LEFT JOIN fe_usua AS u ON u.idusua=a.prod_idus
   LEFT JOIN fe_usua AS us ON us.idusua=a.prod_uact,fe_gene AS v
   WHERE descri LIKE cbuscar AND prod_acti<>'I' ORDER BY s.dmar,a.DESCRI;
when opt=0 then
   SET cbuscar=TRIM(CAST(nid AS CHAR));
   SELECT idart,descri,unid,uno,dos,tre,cua,cin,sei,
   IFNULL(ROUND(IF(tmon='S',((a.prec*v.igv)+b.prec)*prod_uti1,((a.prec*v.igv*IF(prod_dola>nd,prod_dola,nd))+b.prec)*prod_uti1),2),0) AS pre1,
   IFNULL(ROUND(IF(tmon='S',((a.prec*v.igv)+b.prec)*prod_uti2,((a.prec*v.igv*IF(prod_dola>nd,prod_dola,nd))+b.prec)*prod_uti2),2),0) AS pre2,
   IFNULL(ROUND(IF(tmon='S',((a.prec*v.igv)+b.prec)*prod_uti3,((a.prec*v.igv*IF(prod_dola>nd,prod_dola,nd))+b.prec)*prod_uti3),2),0) AS pre3,
   IFNULL(ROUND(IF(tmon='S',((a.prec*v.igv)+b.prec)*prod_uti0,((a.prec*v.igv*IF(prod_dola>nd,prod_dola,nd))+b.prec)*prod_uti0),2),0) AS pre0,
   ROUND(IF(tmon='S',(a.prec*v.igv)+b.prec,(a.prec*v.igv*nd)+b.prec),2) AS costo,c.idgrupo,c.dcat,prod_dola,
   ROUND(IF(tmon='S',(a.prec*v.igv),(a.prec*v.igv*nd)),2) AS costosf,b.prec AS flete,
   IFNULL(d.cost_cost,0) AS costor,IFNULL(d.cost_prec,0) AS precr,IFNULL(d.cost_mone,'')  AS moner,
   CAST(IFNULL(d.cost_idco,0) AS UNSIGNED) AS cost_idco,IFNULL(d.cost_flet,0)  AS fleter,IFNULL(d.cost_dola,0) AS dolar,
   peso,a.prec,tipro,a.idmar,a.idcat,cost,tmon,a.idflete,prod_uti1,prod_uti2,prod_uti3,prod_uti0,prod_idus,
   prod_come,prod_comc,ulpc,prod_idus,prod_uact,prod_fact,fechc,prod_smax,prod_smin,IFNULL(o.razo,'') AS proveedor,
   IFNULL(yy.ndoc,'') AS ndoc,IFNULL(yy.fech,'') AS fech,ulfc,s.dmar,prod_acti,prod_perm,prod_perx,
   u.nomb AS usuacreo,us.nomb AS usuamodifico,g.desgrupo AS grupo,b.desflete,prod_ocan,prod_ocom,prod_cod1
   FROM fe_art  AS a 
   INNER JOIN fe_fletes AS b ON(b.idflete=a.idflete)
   INNER JOIN fe_cat AS c ON(c.idcat=a.idcat)
   INNER JOIN fe_grupo AS g ON g.idgrupo=c.idgrupo
   INNER JOIN fe_mar AS s ON s.idmar=a.idmar 
   LEFT JOIN fe_costos AS d ON(d.cost_idco=a.prod_idco)
   LEFT JOIN fe_rcom AS yy ON (yy.idauto=a.prod_idau) 
   LEFT JOIN fe_prov AS o ON (o.idprov=yy.idprov)
   LEFT JOIN fe_usua AS u ON u.idusua=a.prod_idus
   LEFT JOIN fe_usua AS us ON us.idusua=a.prod_uact,fe_gene AS v
   WHERE CAST(idart AS CHAR) = cbuscar AND prod_acti<>'I' ORDER BY s.dmar,a.DESCRI;
WHEN opt=2 THEN
   SET cbuscar=CONCAT('%',TRIM(abuscar),+'%');
   SELECT idart,descri,unid,uno,dos,tre,cua,cin,sei,
   IFNULL(ROUND(IF(tmon='S',((a.prec*v.igv)+b.prec)*prod_uti1,((a.prec*v.igv*IF(prod_dola>nd,prod_dola,nd))+b.prec)*prod_uti1),2),0) AS pre1,
   IFNULL(ROUND(IF(tmon='S',((a.prec*v.igv)+b.prec)*prod_uti2,((a.prec*v.igv*IF(prod_dola>nd,prod_dola,nd))+b.prec)*prod_uti2),2),0) AS pre2,
   IFNULL(ROUND(IF(tmon='S',((a.prec*v.igv)+b.prec)*prod_uti3,((a.prec*v.igv*IF(prod_dola>nd,prod_dola,nd))+b.prec)*prod_uti3),2),0) AS pre3,
   IFNULL(ROUND(IF(tmon='S',((a.prec*v.igv)+b.prec)*prod_uti0,((a.prec*v.igv*IF(prod_dola>nd,prod_dola,nd))+b.prec)*prod_uti0),2),0) AS pre0,
   ROUND(IF(tmon='S',(a.prec*v.igv)+b.prec,(a.prec*v.igv*nd)+b.prec),2) AS costo,c.idgrupo,c.dcat,prod_dola,
   ROUND(IF(tmon='S',(a.prec*v.igv),(a.prec*v.igv*nd)),2) AS costosf,b.prec AS flete,
   IFNULL(d.cost_cost,0) AS costor,IFNULL(d.cost_prec,0) AS precr,IFNULL(d.cost_mone,'')  AS moner,
   CAST(IFNULL(d.cost_idco,0) AS UNSIGNED) AS cost_idco,IFNULL(d.cost_flet,0)  AS fleter,IFNULL(d.cost_dola,0) AS dolar,
   peso,a.prec,tipro,a.idmar,a.idcat,cost,tmon,a.idflete,prod_uti1,prod_uti2,prod_uti3,prod_uti0,prod_idus,
   prod_come,prod_comc,ulpc,prod_idus,prod_uact,prod_fact,fechc,prod_smax,prod_smin,IFNULL(o.razo,'') AS proveedor,
   IFNULL(yy.ndoc,'') AS ndoc,IFNULL(yy.fech,'') AS fech,ulfc,s.dmar,prod_acti,prod_perm,prod_perx,
   u.nomb AS usuacreo,us.nomb AS usuamodifico,g.desgrupo AS grupo,b.desflete,prod_ocan,prod_ocom,prod_cod1
   FROM fe_art  AS a 
   INNER JOIN fe_fletes AS b ON(b.idflete=a.idflete)
   INNER JOIN fe_cat AS c ON(c.idcat=a.idcat)
   INNER JOIN fe_grupo AS g ON g.idgrupo=c.idgrupo
   INNER JOIN fe_mar AS s ON s.idmar=a.idmar 
   LEFT JOIN fe_costos AS d ON(d.cost_idco=a.prod_idco)
   LEFT JOIN fe_rcom AS yy ON (yy.idauto=a.prod_idau) 
   LEFT JOIN fe_prov AS o ON (o.idprov=yy.idprov)
   LEFT JOIN fe_usua AS u ON u.idusua=a.prod_idus
   LEFT JOIN fe_usua AS us ON us.idusua=a.prod_uact,fe_gene AS v
   WHERE prod_cod1 LIKE cbuscar AND prod_acti<>'I' ORDER BY s.dmar,a.DESCRI;   
END case ;
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
declare vigv decimal(6,4);
select igv into vigv from fe_gene where idgene=1;
set cbuscar=concat('%',trim(abuscar),+'%');
SELECT idart,descri,unid,uno,dos,tre,cua,
ifnull(round(if(tmon='S',((a.prec*vigv)+b.prec)*prod_uti1,((a.prec*vigv*if(prod_dola>nd,prod_dola,nd))+b.prec)*prod_uti1),2),0) as pre1,
ifnull(round(if(tmon='S',((a.prec*vigv)+b.prec)*prod_uti2,((a.prec*vigv*if(prod_dola>nd,prod_dola,nd))+b.prec)*prod_uti2),2),0) as pre2,
ifnull(round(if(tmon='S',((a.prec*vigv)+b.prec)*prod_uti3,((a.prec*vigv*if(prod_dola>nd,prod_dola,nd))+b.prec)*prod_uti3),2),0) as pre3,
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

/* Procedure structure for procedure `ProMuestratVendedores` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestratVendedores` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestratVendedores`(cbusca varchar(20))
BEGIN
declare cbuscar varchar(80);
set cbuscar=concat('%',trim(cbusca),+'%');
select nomv,idven from fe_vend where nomv like cbuscar order by nomv;
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
   select nomb,tipo,activo,idusua,0 as Uno,1 as uno,2 as dos,3 as tres,clave,idalma,usua_tran,usua_scre from fe_usua where nomb like cbuscar  and activo='S' order by nomb;
end if;
if opt=1 then
   select nomb,tipo,activo,idusua,0 as Uno,1 as uno,2 as dos,3 as tres,clave,idalma,usua_tran,usua_scre  from fe_usua where idusua=nid and activo='S' order by nomb;
end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `ProMuestraVendedores` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProMuestraVendedores` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProMuestraVendedores`(cbusca varchar(20))
BEGIN
declare cbuscar varchar(80);
set cbuscar=concat('%',trim(cbusca),+'%');
select nomv,idven,cuota,'N' as modi from fe_vend where nomv like cbuscar and vend_acti<>'I' order by nomv;
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

/* Procedure structure for procedure `ProPermiteVentasProducto` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProPermiteVentasProducto` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProPermiteVentasProducto`(nid integer,opt integer)
BEGIN
if opt=1 then
    update fe_art set prod_perm=1 where idart=nid;
else
     update fe_art set prod_perm=0 where idart=nid;
end if;
END */$$
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
declare vigv float;
declare cursor1 cursor for
SELECT idart as coda,round(if(tmon='S',(a.prec*vigv),(a.prec*vigv*2.85)),2) as costo,
b.prec as flete,round(a.prec*vigv,2) as precio,tmon FROM fe_art  as a inner join fe_fletes as b on(b.idflete=a.idflete)
WHERE prod_acti<>'I' ORDER BY idart;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
select igv into vigv from fe_gene where idgene=1;
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

/* Procedure structure for procedure `ProTraspasoRecibido` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProTraspasoRecibido` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProTraspasoRecibido`(nidauto integer)
begin
  update fe_rcom set rcom_reci='E' where idauto=nidauto;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ProUltimoPrecioVenta` */

/*!50003 DROP PROCEDURE IF EXISTS  `ProUltimoPrecioVenta` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `ProUltimoPrecioVenta`(nidcl integer,nidart integer)
BEGIN
select a.fech,ifnull(b.prec,0) as precio from
 fe_kar as b inner join fe_rcom as a on a.idauto=b.idauto where a.idcliente=nidcl
and b.idart=nidart and b.acti='A'  order by fech desc limit 1;
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

/*Table structure for table `vcaja` */

DROP TABLE IF EXISTS `vcaja`;

/*!50001 DROP VIEW IF EXISTS `vcaja` */;
/*!50001 DROP TABLE IF EXISTS `vcaja` */;

/*!50001 CREATE TABLE  `vcaja`(
 `idcaja` int ,
 `idauto` int 
)*/;

/*Table structure for table `vcambio` */

DROP TABLE IF EXISTS `vcambio`;

/*!50001 DROP VIEW IF EXISTS `vcambio` */;
/*!50001 DROP TABLE IF EXISTS `vcambio` */;

/*!50001 CREATE TABLE  `vcambio`(
 `nomb` varchar(45) ,
 `fusua` datetime ,
 `descri` varchar(150) ,
 `unid` varchar(5) ,
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
 `razo` varchar(100) ,
 `impo` decimal(12,2) ,
 `nomb` varchar(45) ,
 `fusua` datetime ,
 `descri` varchar(150) ,
 `unid` varchar(5) ,
 `cant` float ,
 `prec` float ,
 `importe` double ,
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
 `razo` varchar(100) ,
 `impo` decimal(12,2) ,
 `nomb` varchar(45) ,
 `fusua` datetime ,
 `descri` varchar(150) ,
 `unid` varchar(5) ,
 `cant` float ,
 `prec` float ,
 `importe` double ,
 `camb_idaa` int ,
 `camb_fope` datetime ,
 `idauto` int ,
 `acti` char(1) 
)*/;

/*Table structure for table `vcred` */

DROP TABLE IF EXISTS `vcred`;

/*!50001 DROP VIEW IF EXISTS `vcred` */;
/*!50001 DROP TABLE IF EXISTS `vcred` */;

/*!50001 CREATE TABLE  `vcred`(
 `idrc` int unsigned ,
 `impo` decimal(14,2) 
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

/*Table structure for table `vguiasventas` */

DROP TABLE IF EXISTS `vguiasventas`;

/*!50001 DROP VIEW IF EXISTS `vguiasventas` */;
/*!50001 DROP TABLE IF EXISTS `vguiasventas` */;

/*!50001 CREATE TABLE  `vguiasventas`(
 `idguia` int unsigned ,
 `coda` int ,
 `descri` varchar(150) ,
 `unid` varchar(5) ,
 `ndoc` varchar(12) ,
 `fech` datetime ,
 `fect` datetime ,
 `ptoll` varchar(100) ,
 `detalle` varchar(150) ,
 `cant` int ,
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
 `idcliente` int ,
 `refe` varchar(12) ,
 `tdoc` varchar(2) 
)*/;

/*Table structure for table `vmuestracompras` */

DROP TABLE IF EXISTS `vmuestracompras`;

/*!50001 DROP VIEW IF EXISTS `vmuestracompras` */;
/*!50001 DROP TABLE IF EXISTS `vmuestracompras` */;

/*!50001 CREATE TABLE  `vmuestracompras`(
 `idauto` int ,
 `alma` int ,
 `idkar` int ,
 `descri` varchar(150) ,
 `peso` float ,
 `prod_idco` int unsigned ,
 `unid` varchar(5) ,
 `tipro` varchar(1) ,
 `idart` int ,
 `incl` char(1) ,
 `ndoc` varchar(12) ,
 `valor` decimal(12,2) ,
 `igv` decimal(12,2) ,
 `impo` decimal(12,2) ,
 `pimpo` float ,
 `cant` float ,
 `prec` float ,
 `fech` date ,
 `fecr` date ,
 `form` varchar(1) ,
 `exon` decimal(12,2) ,
 `ndo2` varchar(10) ,
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
 `codt` int ,
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
 `descri` varchar(150) ,
 `unid` varchar(5) ,
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
 `aten` varchar(45) ,
 `forma` varchar(45) ,
 `plazo` varchar(45) ,
 `validez` varchar(45) ,
 `entrega` varchar(45) ,
 `detalle` varchar(80) ,
 `idclie` bigint ,
 `razo` varchar(100) ,
 `nruc` varchar(11) ,
 `dire` varchar(100) ,
 `rped_mone` char(1) ,
 `ciud` varchar(100) ,
 `fono` varchar(15) ,
 `fax` varchar(15) ,
 `nreg` int unsigned 
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
 `unid` varchar(5) ,
 `prod_smax` float ,
 `ocom_valor` float ,
 `ocom_igv` float ,
 `ocom_impo` float ,
 `ocom_idroc` int unsigned ,
 `ocom_fech` date ,
 `ocom_idpr` int ,
 `ocom_desp` varchar(150) ,
 `ocom_form` varchar(150) ,
 `ocom_mone` char(1) ,
 `ocom_ndoc` varchar(10) ,
 `ocom_tigv` char(1) ,
 `ocom_obse` varchar(220) ,
 `ocom_aten` varchar(150) ,
 `ocom_deta` varchar(220) ,
 `ocom_idus` int unsigned ,
 `ocom_fope` datetime ,
 `ocom_idpc` varchar(45) ,
 `ocom_idac` int unsigned ,
 `ocom_fact` datetime ,
 `razo` varchar(100) ,
 `nomb` varchar(45) 
)*/;

/*Table structure for table `vmuestrapedidos` */

DROP TABLE IF EXISTS `vmuestrapedidos`;

/*!50001 DROP VIEW IF EXISTS `vmuestrapedidos` */;
/*!50001 DROP TABLE IF EXISTS `vmuestrapedidos` */;

/*!50001 CREATE TABLE  `vmuestrapedidos`(
 `idart` int unsigned ,
 `descri` varchar(150) ,
 `unid` varchar(5) ,
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
 `aten` varchar(45) ,
 `forma` varchar(45) ,
 `plazo` varchar(45) ,
 `validez` varchar(45) ,
 `entrega` varchar(45) ,
 `detalle` varchar(80) ,
 `idclie` bigint ,
 `razo` varchar(100) ,
 `nruc` varchar(11) ,
 `dire` varchar(100) ,
 `rped_cont` varchar(120) ,
 `rped_dias` int unsigned ,
 `rped_fono` varchar(50) ,
 `rped_trans` varchar(120) ,
 `rped_dire` varchar(120) ,
 `rped_mone` char(1) ,
 `ciud` varchar(100) ,
 `fono` varchar(15) ,
 `fax` varchar(15) ,
 `nreg` int unsigned ,
 `form` varchar(1) 
)*/;

/*Table structure for table `vmuestraventas` */

DROP TABLE IF EXISTS `vmuestraventas`;

/*!50001 DROP VIEW IF EXISTS `vmuestraventas` */;
/*!50001 DROP TABLE IF EXISTS `vmuestraventas` */;

/*!50001 CREATE TABLE  `vmuestraventas`(
 `idusua` int unsigned ,
 `kar_comi` float ,
 `codv` int ,
 `idauto` int ,
 `alma` int ,
 `idcosto` int ,
 `idkar` int ,
 `Coda` int ,
 `cant` float ,
 `prec` float ,
 `valor` decimal(12,2) ,
 `igv` decimal(12,2) ,
 `impo` decimal(12,2) ,
 `fech` date ,
 `fecr` date ,
 `form` varchar(1) ,
 `deta` varchar(150) ,
 `exon` decimal(12,2) ,
 `ndo2` varchar(10) ,
 `rcom_entr` char(1) ,
 `idclie` int ,
 `razo` varchar(100) ,
 `nruc` varchar(11) ,
 `dire` varchar(100) ,
 `ciud` varchar(100) ,
 `ndni` varchar(11) ,
 `tipo` varchar(1) ,
 `tdoc` varchar(2) ,
 `ndoc` varchar(12) ,
 `dolar` float ,
 `mone` varchar(1) ,
 `descri` varchar(150) ,
 `idcaja` bigint ,
 `unid` varchar(5) ,
 `pre1` float ,
 `tipro` varchar(1) ,
 `peso` float ,
 `pre2` float ,
 `nidrv` bigint ,
 `vigv` float ,
 `dsnc` int ,
 `dsnd` int ,
 `gast` int ,
 `idcliente` int ,
 `codt` int ,
 `pre3` float ,
 `costo` float ,
 `uno` float ,
 `dos` float ,
 `TAlma` double ,
 `fusua` datetime ,
 `Vendedor` varchar(45) ,
 `Usuario` varchar(45) ,
 `incl` char(1) ,
 `kar_cost` decimal(12,5) 
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
 `cant` float ,
 `prec` float ,
 `valor` decimal(12,2) ,
 `igv` decimal(12,2) ,
 `impo` decimal(12,2) ,
 `fech` date ,
 `fecr` date ,
 `form` varchar(1) ,
 `deta` varchar(150) ,
 `exon` decimal(12,2) ,
 `ndo2` varchar(10) ,
 `idclie` int ,
 `razo` varchar(100) ,
 `nruc` varchar(11) ,
 `dire` varchar(100) ,
 `ciud` varchar(100) ,
 `ndni` varchar(11) ,
 `tipo` varchar(1) ,
 `tdoc` varchar(2) ,
 `ndoc` varchar(12) ,
 `dolar` float ,
 `mone` varchar(1) ,
 `vigv` float ,
 `dsnc` int ,
 `dsnd` int ,
 `gast` int ,
 `idcliente` int ,
 `codt` int ,
 `fusua` datetime ,
 `descri` varchar(150) ,
 `unid` varchar(5) ,
 `usuario` varchar(45) 
)*/;

/*Table structure for table `vpdtesentrega` */

DROP TABLE IF EXISTS `vpdtesentrega`;

/*!50001 DROP VIEW IF EXISTS `vpdtesentrega` */;
/*!50001 DROP TABLE IF EXISTS `vpdtesentrega` */;

/*!50001 CREATE TABLE  `vpdtesentrega`(
 `Producto` varchar(150) ,
 `Unidad` varchar(5) ,
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
 `Cliente` varchar(100) ,
 `dire` varchar(100) ,
 `ciud` varchar(100) ,
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
 `saldo` decimal(12,2) ,
 `Idpr` int ,
 `ImporteC` float ,
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

/*Table structure for table `vpdtespagoc` */

DROP TABLE IF EXISTS `vpdtespagoc`;

/*!50001 DROP VIEW IF EXISTS `vpdtespagoc` */;
/*!50001 DROP TABLE IF EXISTS `vpdtespagoc` */;

/*!50001 CREATE TABLE  `vpdtespagoc`(
 `idclie` int ,
 `ndoc` varchar(12) ,
 `importe` decimal(37,2) ,
 `mone` varchar(1) ,
 `banc` varchar(120) ,
 `fech` date ,
 `razo` varchar(100) ,
 `fono` varchar(15) ,
 `dire` varchar(100) ,
 `ciud` varchar(100) ,
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
 `rcre_idrc` int unsigned ,
 `estd` varchar(1) ,
 `rcre_codv` int unsigned ,
 `tdoc` varchar(2) 
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

/*Table structure for table `vpdtesvtas` */

DROP TABLE IF EXISTS `vpdtesvtas`;

/*!50001 DROP VIEW IF EXISTS `vpdtesvtas` */;
/*!50001 DROP TABLE IF EXISTS `vpdtesvtas` */;

/*!50001 CREATE TABLE  `vpdtesvtas`(
 `idkar` int ,
 `Pedido` float ,
 `Entregado` bigint unsigned 
)*/;

/*Table structure for table `vpentregas` */

DROP TABLE IF EXISTS `vpentregas`;

/*!50001 DROP VIEW IF EXISTS `vpentregas` */;
/*!50001 DROP TABLE IF EXISTS `vpentregas` */;

/*!50001 CREATE TABLE  `vpentregas`(
 `idped` int unsigned ,
 `entregado` decimal(13,2) ,
 `pent_idpr` int unsigned ,
 `pent_idpe` int unsigned 
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
 `exon` decimal(12,2) ,
 `ndo2` varchar(10) ,
 `idauto` int ,
 `deta` varchar(150) ,
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
 `ndo2` varchar(10) ,
 `mone` varchar(1) ,
 `valor` decimal(12,2) ,
 `igv` decimal(12,2) ,
 `impo` decimal(12,2) ,
 `codt` int ,
 `dola` float ,
 `form` varchar(1) ,
 `idauto` int ,
 `usuario` varchar(45) ,
 `fusua` datetime ,
 `razo` varchar(100) ,
 `nruc` varchar(11) ,
 `dire` varchar(100) ,
 `ciud` varchar(100) ,
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

/*Table structure for table `vsaldosctasporcobrar` */

DROP TABLE IF EXISTS `vsaldosctasporcobrar`;

/*!50001 DROP VIEW IF EXISTS `vsaldosctasporcobrar` */;
/*!50001 DROP TABLE IF EXISTS `vsaldosctasporcobrar` */;

/*!50001 CREATE TABLE  `vsaldosctasporcobrar`(
 `rcre_idcl` int ,
 `fevto` date ,
 `saldo` decimal(37,2) ,
 `ncontrol` int ,
 `mone` varchar(1) 
)*/;

/*Table structure for table `vutilidad` */

DROP TABLE IF EXISTS `vutilidad`;

/*!50001 DROP VIEW IF EXISTS `vutilidad` */;
/*!50001 DROP TABLE IF EXISTS `vutilidad` */;

/*!50001 CREATE TABLE  `vutilidad`(
 `fecha` date ,
 `Documento` varchar(12) ,
 `Cliente` varchar(100) ,
 `costo` double ,
 `precio` double ,
 `Vendedor` varchar(45) ,
 `usuario` varchar(45) ,
 `FechaHora` datetime ,
 `x` varchar(2) ,
 `idauto` int ,
 `codv` int 
)*/;

/*View structure for view rvendedores */

/*!50001 DROP TABLE IF EXISTS `rvendedores` */;
/*!50001 DROP VIEW IF EXISTS `rvendedores` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `rvendedores` AS select `fe_kar`.`idauto` AS `idauto`,`fe_kar`.`codv` AS `codv` from `fe_kar` where (`fe_kar`.`acti` = 'A') group by `fe_kar`.`idauto` */;

/*View structure for view vcaja */

/*!50001 DROP TABLE IF EXISTS `vcaja` */;
/*!50001 DROP VIEW IF EXISTS `vcaja` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vcaja` AS select `fe_caja`.`idcaja` AS `idcaja`,`fe_caja`.`idauto` AS `idauto` from `fe_caja` where (`fe_caja`.`acti` = 'A') */;

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

/*View structure for view vcred */

/*!50001 DROP TABLE IF EXISTS `vcred` */;
/*!50001 DROP VIEW IF EXISTS `vcred` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vcred` AS select `w`.`cred_idrc` AS `idrc`,`w`.`impo` AS `impo` from (`fe_cred` `w` join `fe_rcred` `s` on((`s`.`rcre_idrc` = `w`.`cred_idrc`))) where ((`w`.`acti` = 'A') and (`s`.`rcre_Acti` = 'A') and (`w`.`impo` > 0)) */;

/*View structure for view vguiascompras */

/*!50001 DROP TABLE IF EXISTS `vguiascompras` */;
/*!50001 DROP VIEW IF EXISTS `vguiascompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vguiascompras` AS select `fe_guiac`.`guic_idau` AS `guic_idau`,`fe_guiac`.`guic_tipo` AS `guic_tipo`,cast(ifnull(`fe_guiac`.`guic_idac`,0) as signed) AS `guic_idac` from `fe_guiac` where (`fe_guiac`.`guic_acti` = 'A') group by `fe_guiac`.`guic_idau` */;

/*View structure for view vguiasventas */

/*!50001 DROP TABLE IF EXISTS `vguiasventas` */;
/*!50001 DROP VIEW IF EXISTS `vguiasventas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vguiasventas` AS select `b`.`guia_idgui` AS `idguia`,`a`.`idart` AS `coda`,`a`.`descri` AS `descri`,`a`.`unid` AS `unid`,`b`.`guia_ndoc` AS `ndoc`,`b`.`guia_fech` AS `fech`,`b`.`guia_fect` AS `fect`,`b`.`guia_ptoll` AS `ptoll`,`b`.`guia_deta` AS `detalle`,`x`.`entr_cant` AS `cant`,`y`.`placa` AS `placa`,`y`.`razon` AS `Transportista`,`y`.`ructr` AS `ructr`,`y`.`nombr` AS `Chofer`,`y`.`breve` AS `Brevete`,`y`.`cons` AS `Constancia`,`y`.`marca` AS `marca`,`y`.`dirtr` AS `Direccion`,`p`.`nomb` AS `usuario`,`d`.`razo` AS `cliente`,`d`.`idclie` AS `idcliente`,`c`.`ndoc` AS `refe`,`c`.`tdoc` AS `tdoc` from (((((((`fe_guias` `b` join `fe_ent` `x` on((`x`.`entr_idgu` = `b`.`guia_idgui`))) left join `fe_tra` `y` on((`y`.`idtra` = `b`.`guia_idtr`))) join `fe_kar` `s` on((`s`.`idkar` = `x`.`entr_idkar`))) join `fe_art` `a` on((`a`.`idart` = `s`.`idart`))) join `fe_usua` `p` on((`p`.`idusua` = `b`.`guia_idus`))) join `fe_rcom` `c` on((`c`.`idauto` = `b`.`guia_idau`))) join `fe_clie` `d` on((`d`.`idclie` = `c`.`idcliente`))) where (`b`.`guia_acti` <> 'I') */;

/*View structure for view vmuestracompras */

/*!50001 DROP TABLE IF EXISTS `vmuestracompras` */;
/*!50001 DROP VIEW IF EXISTS `vmuestracompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestracompras` AS select `a`.`idauto` AS `idauto`,`a`.`alma` AS `alma`,`a`.`idkar` AS `idkar`,`b`.`descri` AS `descri`,`b`.`peso` AS `peso`,`b`.`prod_idco` AS `prod_idco`,`b`.`unid` AS `unid`,`b`.`tipro` AS `tipro`,`a`.`idart` AS `idart`,`a`.`incl` AS `incl`,`c`.`ndoc` AS `ndoc`,`c`.`valor` AS `valor`,`c`.`igv` AS `igv`,`c`.`impo` AS `impo`,`c`.`pimpo` AS `pimpo`,`a`.`cant` AS `cant`,`a`.`prec` AS `prec`,`c`.`fech` AS `fech`,`c`.`fecr` AS `fecr`,`c`.`form` AS `form`,`c`.`exon` AS `exon`,`c`.`ndo2` AS `ndo2`,`c`.`vigv` AS `vigv`,`c`.`idprov` AS `idprov`,`a`.`tipo` AS `tipo`,`c`.`tdoc` AS `tdoc`,`c`.`dolar` AS `dolar`,`c`.`mone` AS `mone`,`p`.`razo` AS `razo`,`p`.`dire` AS `dire`,`p`.`ciud` AS `ciud`,`p`.`nruc` AS `nruc`,ifnull(`x`.`idcaja`,0) AS `Idcaja`,`c`.`codt` AS `codt`,`a`.`dsnc` AS `dsnc`,`a`.`dsnd` AS `dsnd`,`a`.`gast` AS `gast`,`c`.`fusua` AS `fusua`,`w`.`nomb` AS `Usuario` from (((((`fe_rcom` `c` left join `fe_kar` `a` on((`c`.`idauto` = `a`.`idauto`))) left join `fe_art` `b` on((`b`.`idart` = `a`.`idart`))) join `fe_prov` `p` on((`p`.`idprov` = `c`.`idprov`))) left join `vcaja` `x` on((`x`.`idauto` = `c`.`idauto`))) join `fe_usua` `w` on((`w`.`idusua` = `c`.`idusua`))) where ((`c`.`acti` <> 'I') and (`a`.`acti` <> 'I')) */;

/*View structure for view vmuestracotizaciones */

/*!50001 DROP TABLE IF EXISTS `vmuestracotizaciones` */;
/*!50001 DROP VIEW IF EXISTS `vmuestracotizaciones` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestracotizaciones` AS select `a`.`idart` AS `idart`,`b`.`descri` AS `descri`,`b`.`unid` AS `unid`,`a`.`cant` AS `cant`,ifnull(`m`.`idven`,0) AS `idven`,ifnull(`m`.`nomv`,'') AS `Vendedor`,`a`.`prec` AS `prec`,`b`.`premay` AS `premay`,`b`.`premen` AS `premen`,`c`.`fech` AS `fech`,`c`.`idautop` AS `idautop`,`c`.`impo` AS `impo`,`c`.`ndoc` AS `ndoc`,`c`.`aten` AS `aten`,`c`.`forma` AS `forma`,`c`.`plazo` AS `plazo`,`c`.`validez` AS `validez`,`c`.`entrega` AS `entrega`,`c`.`detalle` AS `detalle`,ifnull(`d`.`idclie`,0) AS `idclie`,ifnull(`d`.`razo`,'') AS `razo`,ifnull(`d`.`nruc`,'') AS `nruc`,ifnull(`d`.`dire`,'') AS `dire`,`c`.`rped_mone` AS `rped_mone`,ifnull(`d`.`ciud`,'') AS `ciud`,`d`.`fono` AS `fono`,`d`.`fax` AS `fax`,`a`.`idped` AS `nreg` from ((((`fe_ped` `a` join `fe_rped` `c` on((`a`.`idautop` = `c`.`idautop`))) join `fe_art` `b` on((`b`.`idart` = `a`.`idart`))) left join `fe_clie` `d` on((`d`.`idclie` = `c`.`idclie`))) left join `fe_vend` `m` on((`m`.`idven` = `c`.`idven`))) where ((`a`.`acti` <> 'I') and (`c`.`acti` <> 'I')) */;

/*View structure for view vmuestraordencompra */

/*!50001 DROP TABLE IF EXISTS `vmuestraordencompra` */;
/*!50001 DROP VIEW IF EXISTS `vmuestraordencompra` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestraordencompra` AS select `b`.`doco_iddo` AS `doco_iddo`,`b`.`doco_coda` AS `doco_coda`,`b`.`doco_cant` AS `doco_cant`,`b`.`doco_prec` AS `doco_prec`,`c`.`descri` AS `descri`,`c`.`prod_smin` AS `prod_smin`,`c`.`unid` AS `unid`,`c`.`prod_smax` AS `prod_smax`,`a`.`ocom_valor` AS `ocom_valor`,`a`.`ocom_igv` AS `ocom_igv`,`a`.`ocom_impo` AS `ocom_impo`,`a`.`ocom_idroc` AS `ocom_idroc`,`a`.`ocom_fech` AS `ocom_fech`,`a`.`ocom_idpr` AS `ocom_idpr`,`a`.`ocom_desp` AS `ocom_desp`,`a`.`ocom_form` AS `ocom_form`,`a`.`ocom_mone` AS `ocom_mone`,`a`.`ocom_ndoc` AS `ocom_ndoc`,`a`.`ocom_tigv` AS `ocom_tigv`,`a`.`ocom_obse` AS `ocom_obse`,`a`.`ocom_aten` AS `ocom_aten`,`a`.`ocom_deta` AS `ocom_deta`,`a`.`ocom_idus` AS `ocom_idus`,`a`.`ocom_fope` AS `ocom_fope`,`a`.`ocom_idpc` AS `ocom_idpc`,`a`.`ocom_idac` AS `ocom_idac`,`a`.`ocom_fact` AS `ocom_fact`,`d`.`razo` AS `razo`,`e`.`nomb` AS `nomb` from ((((`fe_rocom` `a` join `fe_docom` `b` on((`b`.`doco_idro` = `a`.`ocom_idroc`))) join `fe_art` `c` on((`b`.`doco_coda` = `c`.`idart`))) join `fe_prov` `d` on((`d`.`idprov` = `a`.`ocom_idpr`))) join `fe_usua` `e` on((`e`.`idusua` = `a`.`ocom_idus`))) where ((`a`.`ocom_acti` <> 'I') and (`b`.`doco_acti` <> 'I')) */;

/*View structure for view vmuestrapedidos */

/*!50001 DROP TABLE IF EXISTS `vmuestrapedidos` */;
/*!50001 DROP VIEW IF EXISTS `vmuestrapedidos` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestrapedidos` AS select `a`.`idart` AS `idart`,`b`.`descri` AS `descri`,`b`.`unid` AS `unid`,`a`.`cant` AS `cant`,ifnull(`m`.`idven`,0) AS `idven`,ifnull(`m`.`nomv`,'') AS `Vendedor`,`a`.`prec` AS `prec`,`b`.`premay` AS `premay`,`b`.`premen` AS `premen`,`c`.`fech` AS `fech`,`c`.`idautop` AS `idautop`,`c`.`impo` AS `impo`,`c`.`ndoc` AS `ndoc`,`c`.`aten` AS `aten`,`c`.`forma` AS `forma`,`c`.`plazo` AS `plazo`,`c`.`validez` AS `validez`,`c`.`entrega` AS `entrega`,`c`.`detalle` AS `detalle`,ifnull(`d`.`idclie`,0) AS `idclie`,ifnull(`d`.`razo`,'') AS `razo`,ifnull(`d`.`nruc`,'') AS `nruc`,ifnull(`d`.`dire`,'') AS `dire`,`c`.`rped_cont` AS `rped_cont`,`c`.`rped_dias` AS `rped_dias`,`c`.`rped_fono` AS `rped_fono`,`c`.`rped_trans` AS `rped_trans`,`c`.`rped_dire` AS `rped_dire`,`c`.`rped_mone` AS `rped_mone`,ifnull(`d`.`ciud`,'') AS `ciud`,`d`.`fono` AS `fono`,`d`.`fax` AS `fax`,`a`.`idped` AS `nreg`,`c`.`form` AS `form` from ((((`fe_ped` `a` join `fe_rped` `c` on((`a`.`idautop` = `c`.`idautop`))) join `fe_art` `b` on((`b`.`idart` = `a`.`idart`))) left join `fe_clie` `d` on((`d`.`idclie` = `c`.`idclie`))) left join `fe_vend` `m` on((`m`.`idven` = `c`.`idven`))) where ((`a`.`acti` <> 'I') and (`c`.`acti` <> 'I')) */;

/*View structure for view vmuestraventas */

/*!50001 DROP TABLE IF EXISTS `vmuestraventas` */;
/*!50001 DROP VIEW IF EXISTS `vmuestraventas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestraventas` AS select `c`.`idusua` AS `idusua`,`a`.`kar_comi` AS `kar_comi`,`a`.`codv` AS `codv`,`a`.`idauto` AS `idauto`,`c`.`codt` AS `alma`,`a`.`kar_idco` AS `idcosto`,`a`.`idkar` AS `idkar`,`a`.`idart` AS `Coda`,`a`.`cant` AS `cant`,`a`.`prec` AS `prec`,`c`.`valor` AS `valor`,`c`.`igv` AS `igv`,`c`.`impo` AS `impo`,`c`.`fech` AS `fech`,`c`.`fecr` AS `fecr`,`c`.`form` AS `form`,`c`.`deta` AS `deta`,`c`.`exon` AS `exon`,`c`.`ndo2` AS `ndo2`,`c`.`rcom_entr` AS `rcom_entr`,`c`.`idcliente` AS `idclie`,`d`.`razo` AS `razo`,`d`.`nruc` AS `nruc`,`d`.`dire` AS `dire`,`d`.`ciud` AS `ciud`,`d`.`ndni` AS `ndni`,`a`.`tipo` AS `tipo`,`c`.`tdoc` AS `tdoc`,`c`.`ndoc` AS `ndoc`,`c`.`dolar` AS `dolar`,`c`.`mone` AS `mone`,`b`.`descri` AS `descri`,ifnull(`x`.`idcaja`,0) AS `idcaja`,`b`.`unid` AS `unid`,`b`.`premay` AS `pre1`,`b`.`tipro` AS `tipro`,`b`.`peso` AS `peso`,`b`.`premen` AS `pre2`,ifnull(`z`.`vend_idrv`,0) AS `nidrv`,`c`.`vigv` AS `vigv`,`a`.`dsnc` AS `dsnc`,`a`.`dsnd` AS `dsnd`,`a`.`gast` AS `gast`,`c`.`idcliente` AS `idcliente`,`c`.`codt` AS `codt`,`b`.`pre3` AS `pre3`,`b`.`cost` AS `costo`,`b`.`uno` AS `uno`,`b`.`dos` AS `dos`,(`b`.`uno` + `b`.`dos`) AS `TAlma`,`c`.`fusua` AS `fusua`,`p`.`nomv` AS `Vendedor`,`q`.`nomb` AS `Usuario`,`a`.`incl` AS `incl`,`a`.`kar_cost` AS `kar_cost` from (((((((`fe_art` `b` join `fe_kar` `a` on((`a`.`idart` = `b`.`idart`))) join `fe_rcom` `c` on((`a`.`idauto` = `c`.`idauto`))) left join `fe_caja` `x` on((`x`.`idauto` = `c`.`idauto`))) join `fe_clie` `d` on((`c`.`idcliente` = `d`.`idclie`))) join `fe_vend` `p` on((`p`.`idven` = `a`.`codv`))) join `fe_usua` `q` on((`q`.`idusua` = `c`.`idusua`))) left join `fe_rvendedor` `z` on((`z`.`vend_idau` = `c`.`idauto`))) where ((`c`.`tipom` = 'V') and (`c`.`acti` <> 'I') and (`a`.`acti` <> 'I')) */;

/*View structure for view vmuestravtas */

/*!50001 DROP TABLE IF EXISTS `vmuestravtas` */;
/*!50001 DROP VIEW IF EXISTS `vmuestravtas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vmuestravtas` AS select `c`.`idusua` AS `idusua`,`a`.`kar_comi` AS `kar_comi`,`a`.`codv` AS `codv`,`a`.`idauto` AS `idauto`,`c`.`codt` AS `alma`,`a`.`kar_idco` AS `idcosto`,`a`.`idkar` AS `idkar`,`a`.`idart` AS `Coda`,`a`.`cant` AS `cant`,`a`.`prec` AS `prec`,`c`.`valor` AS `valor`,`c`.`igv` AS `igv`,`c`.`impo` AS `impo`,`c`.`fech` AS `fech`,`c`.`fecr` AS `fecr`,`c`.`form` AS `form`,`c`.`deta` AS `deta`,`c`.`exon` AS `exon`,`c`.`ndo2` AS `ndo2`,`c`.`idcliente` AS `idclie`,`d`.`razo` AS `razo`,`d`.`nruc` AS `nruc`,`d`.`dire` AS `dire`,`d`.`ciud` AS `ciud`,`d`.`ndni` AS `ndni`,`a`.`tipo` AS `tipo`,`c`.`tdoc` AS `tdoc`,`c`.`ndoc` AS `ndoc`,`c`.`dolar` AS `dolar`,`c`.`mone` AS `mone`,`c`.`vigv` AS `vigv`,`a`.`dsnc` AS `dsnc`,`a`.`dsnd` AS `dsnd`,`a`.`gast` AS `gast`,`c`.`idcliente` AS `idcliente`,`c`.`codt` AS `codt`,`c`.`fusua` AS `fusua`,`b`.`descri` AS `descri`,`b`.`unid` AS `unid`,`g`.`nomb` AS `usuario` from ((((`fe_kar` `a` left join `fe_rcom` `c` on((`c`.`idauto` = `a`.`idauto`))) join `fe_clie` `d` on((`c`.`idcliente` = `d`.`idclie`))) join `fe_art` `b` on((`b`.`idart` = `a`.`idart`))) join `fe_usua` `g` on((`g`.`idusua` = `c`.`idusua`))) where ((`c`.`tipom` = 'V') and (`c`.`acti` <> 'I') and (`a`.`acti` <> 'I')) */;

/*View structure for view vpdtesentrega */

/*!50001 DROP TABLE IF EXISTS `vpdtesentrega` */;
/*!50001 DROP VIEW IF EXISTS `vpdtesentrega` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpdtesentrega` AS select `a`.`descri` AS `Producto`,`a`.`unid` AS `Unidad`,`a`.`peso` AS `peso`,`a`.`uno` AS `uno`,`a`.`dos` AS `dos`,`a`.`idart` AS `idart`,sum(`p`.`Pedido`) AS `Pedido`,sum(`p`.`Entregado`) AS `Entregado`,(sum(`p`.`Pedido`) - sum(`p`.`Entregado`)) AS `Saldo`,`p`.`idin` AS `idin`,`d`.`tdoc` AS `tdoc`,`d`.`ndoc` AS `ndoc`,`d`.`idauto` AS `idauto`,`e`.`razo` AS `Cliente`,`e`.`dire` AS `dire`,`e`.`ciud` AS `ciud`,`e`.`nruc` AS `nruc`,`d`.`fech` AS `fech`,`e`.`ndni` AS `ndni`,`e`.`idclie` AS `idclie`,`f`.`nomb` AS `Usuario` from ((((`vsaldos` `p` join `fe_art` `a` on((`a`.`idart` = `p`.`pdte_idar`))) join `fe_rcom` `d` on((`d`.`idauto` = `p`.`pdte_idau`))) join `fe_clie` `e` on((`e`.`idclie` = `d`.`idcliente`))) join `fe_usua` `f` on((`f`.`idusua` = `p`.`pdte_idus`))) group by `p`.`idin`,`p`.`pdte_idar` having (sum((`p`.`Pedido` - `p`.`Entregado`)) > 0) */;

/*View structure for view vpdtespago */

/*!50001 DROP TABLE IF EXISTS `vpdtespago` */;
/*!50001 DROP VIEW IF EXISTS `vpdtespago` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpdtespago` AS select `a`.`ndoc` AS `ndoc`,`a`.`fech` AS `fech`,`a`.`dola` AS `dola`,`a`.`nrou` AS `nrou`,`a`.`banc` AS `banc`,`a`.`iddeu` AS `iddeu`,`s`.`fevto` AS `fevto`,`s`.`saldo` AS `saldo`,`s`.`rdeu_idpr` AS `Idpr`,`b`.`rdeu_impc` AS `ImporteC`,'C' AS `situa`,`b`.`rdeu_idau` AS `Idauto`,`s`.`ncontrol` AS `ncontrol`,`a`.`tipo` AS `tipo`,`a`.`banco` AS `banco`,ifnull(`c`.`ndoc`,'0') AS `docd`,ifnull(`c`.`tdoc`,'0') AS `tdoc`,`b`.`rdeu_mone` AS `Moneda`,`b`.`rdeu_codt` AS `Codt`,`b`.`rdeu_idrd` AS `Idrd`,`b`.`rdeu_idct` AS `rdeu_idct` from ((((`vpdtespagocompras` `s` join `fe_prov` `z` on((`z`.`idprov` = `s`.`rdeu_idpr`))) join `fe_deu` `a` on((`a`.`iddeu` = `s`.`ncontrol`))) join `fe_rdeu` `b` on((`b`.`rdeu_idrd` = `a`.`deud_idrd`))) left join `fe_rcom` `c` on((`c`.`idauto` = `b`.`rdeu_idau`))) order by `s`.`fevto` */;

/*View structure for view vpdtespagoc */

/*!50001 DROP TABLE IF EXISTS `vpdtespagoc` */;
/*!50001 DROP VIEW IF EXISTS `vpdtespagoc` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpdtespagoc` AS select `b`.`rcre_idcl` AS `idclie`,`a`.`ndoc` AS `ndoc`,`s`.`saldo` AS `importe`,`a`.`mone` AS `mone`,`a`.`banc` AS `banc`,`b`.`rcre_fech` AS `fech`,`x`.`razo` AS `razo`,`x`.`fono` AS `fono`,`x`.`dire` AS `dire`,`x`.`ciud` AS `ciud`,`s`.`fevto` AS `fevto`,`a`.`tipo` AS `tipo`,`a`.`dola` AS `dola`,ifnull(`c`.`ndoc`,'') AS `docd`,`a`.`nrou` AS `nrou`,`a`.`banco` AS `banco`,`a`.`idcred` AS `idcred`,`b`.`rcre_idau` AS `idauto`,`d`.`nomv` AS `nomv`,`a`.`ncontrol` AS `ncontrol`,`b`.`rcre_idrc` AS `rcre_idrc`,`a`.`estd` AS `estd`,`b`.`rcre_codv` AS `rcre_codv`,ifnull(`c`.`tdoc`,'') AS `tdoc` from (((((`vsaldosctasporcobrar` `s` join `fe_clie` `x` on((`x`.`idclie` = `s`.`rcre_idcl`))) join `fe_cred` `a` on((`a`.`idcred` = `s`.`ncontrol`))) join `fe_rcred` `b` on((`b`.`rcre_idrc` = `a`.`cred_idrc`))) left join `fe_rcom` `c` on((`c`.`idauto` = `b`.`rcre_idau`))) join `fe_vend` `d` on((`d`.`idven` = `b`.`rcre_codv`))) order by `s`.`fevto`,`c`.`ndoc` */;

/*View structure for view vpdtespagocompras */

/*!50001 DROP TABLE IF EXISTS `vpdtespagocompras` */;
/*!50001 DROP VIEW IF EXISTS `vpdtespagocompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpdtespagocompras` AS select cast(sum((`d`.`impo` - `d`.`acta`)) as decimal(12,2)) AS `saldo`,`d`.`ncontrol` AS `ncontrol`,max(`d`.`fevto`) AS `fevto`,`r`.`rdeu_idpr` AS `rdeu_idpr`,`r`.`rdeu_mone` AS `rdeu_mone` from (`fe_rdeu` `r` join `fe_deu` `d` on((`d`.`deud_idrd` = `r`.`rdeu_idrd`))) where ((`d`.`acti` = 'A') and (`r`.`rdeu_Acti` = 'A')) group by `r`.`rdeu_idpr`,`d`.`ncontrol`,`r`.`rdeu_mone` having (`saldo` <> 0) */;

/*View structure for view vpdtesvtas */

/*!50001 DROP TABLE IF EXISTS `vpdtesvtas` */;
/*!50001 DROP VIEW IF EXISTS `vpdtesvtas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpdtesvtas` AS select `a`.`idkar` AS `idkar`,`a`.`cant` AS `Pedido`,cast(ifnull(sum(`b`.`entr_cant`),0) as unsigned) AS `Entregado` from (`fe_kar` `a` left join `fe_ent` `b` on((`b`.`entr_idkar` = `a`.`idkar`))) where ((`a`.`tipo` = 'V') and (`a`.`acti` <> 'I')) group by `a`.`idart`,`a`.`idkar` */;

/*View structure for view vpentregas */

/*!50001 DROP TABLE IF EXISTS `vpentregas` */;
/*!50001 DROP VIEW IF EXISTS `vpentregas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpentregas` AS select `fe_pentregas`.`pent_idin` AS `idped`,(`fe_pentregas`.`pent_cant` + `fe_pentregas`.`pent_canr`) AS `entregado`,`fe_pentregas`.`pent_idpr` AS `pent_idpr`,`fe_pentregas`.`pent_idpe` AS `pent_idpe` from `fe_pentregas` where (`fe_pentregas`.`pent_acti` = 'A') order by `fe_pentregas`.`pent_idin` */;

/*View structure for view vrcompras */

/*!50001 DROP TABLE IF EXISTS `vrcompras` */;
/*!50001 DROP VIEW IF EXISTS `vrcompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vrcompras` AS select `c`.`ndoc` AS `ndoc`,`c`.`valor` AS `valor`,`c`.`igv` AS `igv`,`c`.`impo` AS `impo`,`c`.`pimpo` AS `pimpo`,`c`.`fech` AS `fech`,`c`.`fecr` AS `fecr`,`c`.`form` AS `form`,`c`.`exon` AS `exon`,`c`.`ndo2` AS `ndo2`,`c`.`idauto` AS `idauto`,`c`.`deta` AS `deta`,`c`.`tcom` AS `tcom`,`c`.`vigv` AS `vigv`,`c`.`idprov` AS `idprov`,`c`.`tdoc` AS `tdoc`,`c`.`dolar` AS `dolar`,`c`.`mone` AS `mone`,`p`.`razo` AS `razo`,`p`.`dire` AS `dire`,`p`.`ciud` AS `ciud`,`p`.`nruc` AS `nruc`,ifnull(`x`.`idcaja`,0) AS `Idcaja`,`c`.`codt` AS `codt`,`c`.`fusua` AS `fusua`,`w`.`nomb` AS `Usuario` from (((`fe_rcom` `c` join `fe_prov` `p` on((`p`.`idprov` = `c`.`idprov`))) left join `fe_caja` `x` on((`x`.`idauto` = `c`.`idauto`))) join `fe_usua` `w` on((`w`.`idusua` = `c`.`idusua`))) where (`c`.`acti` <> 'I') */;

/*View structure for view vregcompras */

/*!50001 DROP TABLE IF EXISTS `vregcompras` */;
/*!50001 DROP VIEW IF EXISTS `vregcompras` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vregcompras` AS select `x`.`fech` AS `fech`,`x`.`fecr` AS `fecr`,`x`.`tdoc` AS `tdoc`,`x`.`ndoc` AS `ndoc`,`x`.`idprov` AS `idprov`,`x`.`ndo2` AS `ndo2`,`x`.`mone` AS `mone`,`x`.`valor` AS `valor`,`x`.`igv` AS `igv`,`x`.`impo` AS `impo`,`x`.`codt` AS `codt`,`x`.`dolar` AS `dola`,`x`.`form` AS `form`,`x`.`idauto` AS `idauto`,`y`.`nomb` AS `usuario`,`x`.`fusua` AS `fusua`,`p`.`razo` AS `razo`,`p`.`nruc` AS `nruc`,`p`.`dire` AS `dire`,`p`.`ciud` AS `ciud`,`p`.`fono` AS `fono` from ((`fe_rcom` `x` join `fe_usua` `y` on((`y`.`idusua` = `x`.`idusua`))) join `fe_prov` `p` on((`p`.`idprov` = `x`.`idprov`))) where (((`x`.`tipom` = 'C') or (`x`.`tipom` = 'G')) and (`x`.`acti` <> 'I')) */;

/*View structure for view vsaldos */

/*!50001 DROP TABLE IF EXISTS `vsaldos` */;
/*!50001 DROP VIEW IF EXISTS `vsaldos` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vsaldos` AS select `a`.`pdte_idar` AS `pdte_idar`,`a`.`pdte_cant` AS `Pedido`,0 AS `Entregado`,`a`.`pdte_idau` AS `pdte_idau`,`a`.`pdte_idus` AS `pdte_idus`,`a`.`pdte_idin` AS `idin` from `fe_ipdtes` `a` where (`a`.`pdte_Acti` <> 'I') union all select `a`.`pdte_idar` AS `pdte_idar`,0 AS `Pedido`,ifnull(`b`.`entr_cant`,0) AS `Entregado`,`a`.`pdte_idau` AS `pdte_idau`,`a`.`pdte_idus` AS `pdte_idus`,`b`.`entr_idin` AS `idin` from (`fe_ipdtes` `a` left join `fe_entregas` `b` on((`b`.`entr_idin` = `a`.`pdte_idin`))) where (`b`.`entr_acti` <> 'I') */;

/*View structure for view vsaldosctaspagar */

/*!50001 DROP TABLE IF EXISTS `vsaldosctaspagar` */;
/*!50001 DROP VIEW IF EXISTS `vsaldosctaspagar` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vsaldosctaspagar` AS select `a`.`rdeu_idrd` AS `rdeu_idrd`,sum((`b`.`impo` - `b`.`acta`)) AS `Saldo`,`b`.`ncontrol` AS `ncontrol` from (`fe_rdeu` `a` join `fe_deu` `b` on((`b`.`deud_idrd` = `a`.`rdeu_idrd`))) where ((`a`.`rdeu_Acti` <> 'I') and (`b`.`acti` <> 'I')) group by `b`.`ncontrol` */;

/*View structure for view vsaldosctasporcobrar */

/*!50001 DROP TABLE IF EXISTS `vsaldosctasporcobrar` */;
/*!50001 DROP VIEW IF EXISTS `vsaldosctasporcobrar` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vsaldosctasporcobrar` AS select `r`.`rcre_idcl` AS `rcre_idcl`,max(`c`.`fevto`) AS `fevto`,sum((`c`.`impo` - `c`.`acta`)) AS `saldo`,`c`.`ncontrol` AS `ncontrol`,`c`.`mone` AS `mone` from (`fe_rcred` `r` join `fe_cred` `c` on((`c`.`cred_idrc` = `r`.`rcre_idrc`))) where ((`r`.`rcre_Acti` = 'A') and (`c`.`acti` = 'A')) group by `r`.`rcre_idcl`,`c`.`ncontrol`,`c`.`mone` having (`saldo` <> 0) */;

/*View structure for view vutilidad */

/*!50001 DROP TABLE IF EXISTS `vutilidad` */;
/*!50001 DROP VIEW IF EXISTS `vutilidad` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vutilidad` AS select `a`.`fech` AS `fecha`,`a`.`ndoc` AS `Documento`,`b`.`razo` AS `Cliente`,sum(((`c`.`cost_cost` + `c`.`cost_flet`) * `d`.`cant`)) AS `costo`,sum((`d`.`prec` * `d`.`cant`)) AS `precio`,`e`.`nomv` AS `Vendedor`,`f`.`nomb` AS `usuario`,`a`.`fusua` AS `FechaHora`,'00' AS `x`,`a`.`idauto` AS `idauto`,`d`.`codv` AS `codv` from (((((`fe_rcom` `a` join `fe_clie` `b` on((`b`.`idclie` = `a`.`idcliente`))) join `fe_kar` `d` on((`d`.`idauto` = `a`.`idauto`))) join `fe_costos` `c` on((`c`.`cost_idco` = `d`.`kar_idco`))) join `fe_vend` `e` on((`e`.`idven` = `d`.`codv`))) join `fe_usua` `f` on((`f`.`idusua` = `a`.`idusua`))) where ((`a`.`acti` <> 'I') and (`d`.`acti` <> 'I') and (`d`.`tipo` = 'V')) group by `a`.`idauto` */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
