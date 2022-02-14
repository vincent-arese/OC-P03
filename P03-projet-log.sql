---_____________________________________________________________________________________________________________________________________________ 
-- | Historique P03 SQL  																														|
---|____________________________________________________________________________________________________________________________________________|


--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
-- 0 import du fichier CSV et génération du create table via interface graphique Dbeaver 
-- raw => fichier P03 OC convertis au format Csv + Fichier Region et Departement XLSà partir de date INSEE modifé et converti au format CSV



--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
-- 1 Creation d'un RowID pour Normaliser la table raw

ALTER TABLE "P03VASQL".raw ADD column1 serial NOT NULL;


--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
--2 Creation des tables normalises à partir du fichier raw


-- Modif manuelle de la table raw
ALTER TABLE "P03VASQL".raw RENAME COLUMN "cadastreLot1SurfaceCarrez" TO cadastreLot1SurfaceCarrez;


-- 2.1 Creation table Type Local 
create table typeLocal as
SELECT distinct 
typelocalcode, typelocal
FROM "P03VASQL".raw;

--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
--2.2 Table Commune
--- Recherche clef primaire table ! 
SELECT cadastrecommunecodeid, codepostal,commune, cadastrecodedept FROM "P03VASQL".raw  ; 
SELECT  count(distinct cadastrecommunecodeid) FROM "P03VASQL".raw  -- ==> 3125
SELECT  count(distinct commune) FROM "P03VASQL".raw  -- ==> 3110 
--- => cadastrecommunecodeid n'est pas une clef primaire ! 


--- Select  pour tester et requette  créer la table Commune
Select distinct commune,cadastrecodedept, CONCAT((substring(codepostal from 1 for 2)),'-', commune ) AS CommuneID FROM "P03VASQL".raw where commune like '%' and cadastrecodedept='75' order by cadastrecodedept, commune ;

create table Commune as 
Select distinct commune,cadastrecodedept, CONCAT((substring(codepostal from 1 for 2)),'-', commune ) AS CommuneID FROM "P03VASQL".raw order by cadastrecodedept, commune ;


--- Select * Table commune verif clef primaire 
SELECT COUNT(*) FROM commune; 
--/égal/ 
select distinct  COUNT(commune) FROM commune;  -- ==> 3132 Donc PK OK 

--Set PK  ² FK de la table Commune: 
 ALTER TABLE "P03VASQL".commune ADD CONSTRAINT commune_pk PRIMARY KEY (communeid);   
 ALTER TABLE "P03VASQL".commune ADD CONSTRAINT commune_fk FOREIGN KEY (cadastrecodedept) REFERENCES "P03VASQL"."departementFR"(deptcode);


-- Gestion probleme arrondissements Paris Marseille Lyon 
SELECT * FROM commune
where commune like 'PARIS%';

SELECT * FROM commune
where commune like 'LYON%';

SELECT * FROM commune
where commune like 'MARSEILLE%';


--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
-- 2.3  Table Cadastre
 
-- Select pour tester table
SELECT rawid,CONCAT((date_part('year', mutationdate)),'-',	date_part('quarter', mutationdate),'-',rawid) as mutationIDFK,mutationdate, CONCAT(cadastrecommunecodeid, '-',cadastrecodedept, '-', cadastrecodecommune, '-', cadastreprefixesection, '-', cadastresection, '-', cadastreplannum, '-', cadastrevolumenum, '-', cadastrelot1) as cadastreID, cadastrelot1surfacecarrez, cadastrenombrepiecesprincipales, cadastresurfacereellebati, cadastrenombrelots, typelocalcode as typelocalcodeFK, CONCAT((substring(codepostal from 1 for 2)),'-', commune ) AS CommuneIDFK, (substring(codepostal from 1 for 2)) as DeptNumFK, rawid as mutationIDFK FROM "P03VASQL".raw order by DeptNumFK,cadastreID,cadastresection  ;

--create table Cadastre as 
create table "P03VASQL".cadastre as 
SELECT distinct 
CONCAT(cadastrecommunecodeid, '-',cadastrecodedept, '-', cadastrecodecommune, '-', cadastreprefixesection, '-', cadastresection, '-', cadastreplannum, '-', cadastrevolumenum, '-', cadastrelot1) as cadastreID,
cadastrelot1surfacecarrez, cadastrenombrepiecesprincipales, cadastresurfacereellebati, cadastrenombrelots, 
typelocalcode as typelocalcodeFK,
CONCAT((substring(codepostal from 1 for 2)),'-', commune ) AS CommuneIDFK,
(substring(codepostal from 1 for 2)) as DeptNumUK,
CONCAT((date_part('year', mutationdate)),'-',	date_part('quarter', mutationdate),'-',rawid) as mutationIDUK, mutationdate as mutationdateUK, 
rawid as MutationIDNumUK
FROM "P03VASQL".raw
;


---- Test table Cadastre Recherche doublon ?
SELECT cadastreid, cadastrelot1surfacecarrez, cadastrenombrepiecesprincipales, cadastresurfacereellebati, cadastrenombrelots, typelocalcodefk, communeidfk, deptnumuk, mutationiduk, mutationdateuk, mutationidnumuk FROM "P03VASQL".cadastre;
--select COUNT(  cadastreid)  FROM "P03VASQL".cadastre   ==>34169  //  select COUNT( distinct cadastreid)  FROM "P03VASQL".cadastre 34160 !! 

-- Recherche doublon sur CadastreID:  

SELECT count (*), cadastreid FROM "P03VASQL".cadastre group by cadastreid having count (*)>1;


-- visualiser les doublons :
--create table CadastredoublonTEST as
select *  FROM "P03VASQL".cadastre
where cadastreid='1906-69-382--AW-39--18' 
or cadastreid='142-6-88--MO-189--44' 
or cadastreid='301-11-202--DV-77--171' 
or cadastreid='3150-95-427--AB-1--144' 
or cadastreid='3200-75-105--AC-3--13' 
or cadastreid='2281-77-390--AD-4--129' 
or cadastreid='3203-75-111--BX-125--14' 
or cadastreid='3214-75-102--AO-77--17' 
or cadastreid='3070-95-572--BI-149--22' 
--order by cadastreid;









--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
--2.4 Table mutation 

--create table mutation as 
create table mutation4 as 
SELECT 
rawid as MutationIDNum4,
CONCAT((date_part('year', mutationdate)),'-',	date_part('quarter', mutationdate),'-',rawid) as mutationID4,
mutationdate, 
date_part('quarter', mutationdate) as mutationQuarter4,
(date_part('year', mutationdate))as mutationYear4,
valeurfonciere, 
CONCAT(cadastrecommunecodeid, '-',cadastrecodedept, '-', cadastrecodecommune, '-', cadastreprefixesection, '-', cadastresection, '-', cadastreplannum, '-', cadastrevolumenum, '-', cadastrelot1) as cadastreIDFK4,
typelocalcode as typelocalcodeFK4,
CONCAT((substring(codepostal from 1 for 2)),'-', commune ) AS CommuneIDFKTEST4,
(substring(codepostal from 1 for 2)) as DeptNumFKTEST4
FROM "P03VASQL".raw
order by  mutationdate;

-- verif mutation ID pour PK  table mutation
SELECT count(distinct mutationid) FROM "P03VASQL".mutation;-- ==>34169 //
SELECT count( mutationid) FROM "P03VASQL".mutation; --==>34169








--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
-- 3 jointure & view 

-----------------------------------------------------------
--3.1 View adresse_view Jointure COMMUNE - DEPT - Region

--- Tabbles à joindre
SELECT regionnom, regioncode FROM "P03VASQL"."regionFR";
SELECT deptnom, deptcode, deptcodetrinum, regioncodefk FROM "P03VASQL"."departementFR";
SELECT commune, cadastrecodedept, communeid FROM "P03VASQL".commune;


-- Filtre de tri  test jointure : 
select * from "P03VASQL"."departementFR","P03VASQL"."regionFR","P03VASQL".commune
where "P03VASQL"."departementFR".regioncodefk = "P03VASQL"."regionFR".regioncode and "P03VASQL"."departementFR".deptcode = "P03VASQL".commune.cadastrecodedept 
and  deptcodetrinum<999 ;

------  Create View : 
--create view  adresse_view as 
select communeid,commune,deptcode, deptnom, regionnom ,regioncode, deptcodetrinum 
from "P03VASQL"."departementFR","P03VASQL"."regionFR","P03VASQL".commune 
where "P03VASQL"."departementFR".regioncodefk = "P03VASQL"."regionFR".regioncode and "P03VASQL"."departementFR".deptcode = "P03VASQL".commune.cadastrecodedept order by deptcodetrinum ,commune;


--select adresse_view : 
SELECT communeid, commune, deptcode, deptnom, regionnom, regioncode, deptcodetrinum FROM "P03VASQL".adresse_view;




-----------------------------------------------------------
--3.2 View adresse_view Jointure DVF

--Tables à joindre
SELECT cadastreid, cadastrelot1surfacecarrez, cadastrenombrepiecesprincipales, cadastresurfacereellebati, cadastrenombrelots, typelocalcodefk, communeidfk, deptnumuk, mutationiduk, mutationdateuk, mutationidnumuk FROM "P03VASQL".cadastre;
SELECT mutationidnun, mutationid, mutationdate, mutationquarter, mutationyear, valeurfonciere, cadastreidfk, "typelocalcode-FKtest", "communeid-fktest", "deptnum-fktest" FROM "P03VASQL".mutation;
SELECT typelocalcode, typelocal FROM "P03VASQL".typelocal;
SELECT communeid, commune, deptcode, deptnom, regionnom, regioncode, deptcodetrinum FROM "P03VASQL".adresse_view;


--jointure
create view DVF_view as
select
mutationidnun,
mutationdate, mutationquarter, mutationyear,
valeurfonciere, 
cadastreid, 
cadastrelot1surfacecarrez, cadastrenombrepiecesprincipales, cadastresurfacereellebati, cadastrenombrelots, 
deptnumuk, typelocalcode, typelocal, 
communeid,commune, deptcode, deptnom, regionnom, regioncode, deptcodetrinum
from "P03VASQL".mutation,"P03VASQL".cadastre,"P03VASQL".typelocal,"P03VASQL".adresse_view
where mutation.cadastreidfk = cadastre.cadastreid and cadastre.typelocalcodefk =typelocal.typelocalcode and cadastre.communeidfk =adresse_view.communeid 

-- verif jointure : 
SELECT count (*), cadastreid FROM "P03VASQL".dvf_view group by cadastreid having count (*)>1; -- OK Un cadastre peut être lié à plusieurs mutations (vente)
SELECT count (*), mutationidnun FROM "P03VASQL".dvf_view group by mutationidnun having count (*)>1; -- Ok mutationidnun est bien un clef primaire ! 






-- Select Table dvf_view 
SELECT 
mutationidnun,
mutationdate, mutationquarter, mutationyear, 
valeurfonciere, 
cadastreid,
cadastrelot1surfacecarrez, cadastrenombrepiecesprincipales, cadastresurfacereellebati, 
cadastrenombrelots, 
 typelocalcode, typelocal, 
communeid, commune, 
deptcode, deptnom, deptcodetrinum ,
regionnom, regioncode
FROM "P03VASQL".dvf_view;


-- select avec prix au m2
SELECT 
mutationidnun,
mutationdate, mutationquarter, mutationyear, 
valeurfonciere, 
cadastreid,
cadastrelot1surfacecarrez, cadastrenombrepiecesprincipales, cadastresurfacereellebati, 
cadastrenombrelots, 
 typelocalcode, typelocal, 
communeid, commune, 
deptcode, deptnom, deptcodetrinum ,
regionnom, regioncode,
(SELECT ROUND((valeurfonciere/cadastresurfacereellebati),2)) as Prix_m²_Bati,
(SELECT ROUND((valeurfonciere/cadastrelot1surfacecarrez),2))as Prix_m²_Carrez
FROM "P03VASQL".dvf_view
order by Prix_m²_Bati desc 
;









