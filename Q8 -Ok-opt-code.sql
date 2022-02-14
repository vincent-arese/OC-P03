--8. Différence en pourcentage du prix au mètre carré entre un appartement de 2 pièces et un appartement de 3 pièces.
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

--OK code optimiséV1 
with 
P2P as (SELECT  ROUND(AVG(valeurfonciere/cadastrelot1surfacecarrez),2) as PM2P FROM "P03VASQL".dvf_view where typelocalcode=2 and cadastrenombrepiecesprincipales=2 and  ROUND((valeurfonciere/cadastrelot1surfacecarrez),2)>0),
P3P as (SELECT  ROUND(AVG(valeurfonciere/cadastrelot1surfacecarrez),2) as PM3P FROM "P03VASQL".dvf_view where typelocalcode=2 and cadastrenombrepiecesprincipales=3 and  ROUND((valeurfonciere/cadastrelot1surfacecarrez),2)>0)
select PM2P as Prix_m²_Carrez_2P,PM3P as Prix_m²_Carrez_3P, round( (((PM3P-PM2P)/PM2P)*100),2) as "Delta_3P_vs_2P_%"
from P2P,P3P;


--opt V2 
-with
pp as (SELECT  ROUND(AVG(valeurfonciere/cadastrelot1surfacecarrez),2) pm FROM "P03VASQL".dvf_view where typelocalcode=2 and valeurfonciere >0 GROUP BY  cadastrenombrepiecesprincipales, 
P2P as (select pm from pp where cadastrenombrepiecesprincipales=2),
P3P as (select pm from pp where cadastrenombrepiecesprincipales=3)
select P2P as Prix_m²_Carrez_2P,P3P as Prix_m²_Carrez_3P, round( (((P3P-P2P)/P2P)*100),2) as "Delta_3P_vs_2P_%"
from P2P,P3P;


pp AS  (SELECT  ROUND(AVG(valeurfonciere/cadastrelot1surfacecarrez),2) pm,  cadastrenombrepiecesprincipales as np FROM "P03VASQL".dvf_view and typelocalcode=2 and valeurfonciere >0 GROUP BY  cadastrenombrepiecesprincipales)

Pour demain, je trouve pas le lien sur le site [OC]  

WITH
var1 as ( select ...... from ..... where .... group  by  ..... order by ....)
var2 as ( TEXTE-CODE-SQL)
Var3 as ( select var2 from ....  where ....order by var4)
AttributTableTropLong as var4
select * from Var1, Var3 



------- code compliqué non arrondi Problemme performance car utilisation limit 1 (donc nombreux calculs inutiles ! )
select 
(SELECT (SELECT ROUND(AVG(valeurfonciere/cadastrelot1surfacecarrez),2))as Prix_m²_Carrez2P FROM "P03VASQL".dvf_view where typelocalcode=2 and cadastrenombrepiecesprincipales=2 and (SELECT ROUND((valeurfonciere/cadastrelot1surfacecarrez),2))>0 ) as P2P,
(SELECT (SELECT ROUND(AVG(valeurfonciere/cadastrelot1surfacecarrez),2))as Prix_m²_Carrez3P FROM "P03VASQL".dvf_view where typelocalcode=2 and cadastrenombrepiecesprincipales=3 and (SELECT ROUND((valeurfonciere/cadastrelot1surfacecarrez),2))>0 ) as P3P,
((SELECT (SELECT ROUND(AVG(valeurfonciere/cadastrelot1surfacecarrez),2))as Prix_m²_Carrez2P FROM "P03VASQL".dvf_view where typelocalcode=2 and cadastrenombrepiecesprincipales=2 and (SELECT ROUND((valeurfonciere/cadastrelot1surfacecarrez),2))>0 )-
(SELECT (SELECT ROUND(AVG(valeurfonciere/cadastrelot1surfacecarrez),2))as Prix_m²_Carrez3P FROM "P03VASQL".dvf_view where typelocalcode=2 and cadastrenombrepiecesprincipales=3 and (SELECT ROUND((valeurfonciere/cadastrelot1surfacecarrez),2))>0 )) as calculdelta,
round( (((((SELECT (SELECT ROUND(AVG(valeurfonciere/cadastrelot1surfacecarrez),2))as Prix_m²_Carrez2P FROM "P03VASQL".dvf_view where typelocalcode=2 and cadastrenombrepiecesprincipales=2 and (SELECT ROUND((valeurfonciere/cadastrelot1surfacecarrez),2))>0 )-
(SELECT (SELECT ROUND(AVG(valeurfonciere/cadastrelot1surfacecarrez),2))as Prix_m²_Carrez3P FROM "P03VASQL".dvf_view where typelocalcode=2 and cadastrenombrepiecesprincipales=3 and (SELECT ROUND((valeurfonciere/cadastrelot1surfacecarrez),2))>0 ))
)/(SELECT (SELECT ROUND(AVG(valeurfonciere/cadastrelot1surfacecarrez),2))as Prix_m²_Carrez2P FROM "P03VASQL".dvf_view where typelocalcode=2 and cadastrenombrepiecesprincipales=2 and (SELECT ROUND((valeurfonciere/cadastrelot1surfacecarrez),2))>0 )
)*100 ),2)as calculfinal
FROM "P03VASQL".dvf_view
limit 1;



-- Prix moyen d'un appartement 2 Pieces 1 cellule 

SELECT  ROUND(AVG(valeurfonciere/cadastrelot1surfacecarrez),2) as Prix_m²_Carrez3P
FROM "P03VASQL".dvf_view
where typelocalcode=2 and cadastrenombrepiecesprincipales=2 and  ROUND((valeurfonciere/cadastrelot1surfacecarrez),2)>0
;




-- Prix moyen d'un appartement 2 Pieces 
SELECT 
cadastrenombrepiecesprincipales,
(SELECT ROUND(AVG(valeurfonciere/cadastrelot1surfacecarrez),2))as Prix_m²_Carrez2P
FROM "P03VASQL".dvf_view
where typelocalcode=2 and cadastrenombrepiecesprincipales=2 and (SELECT ROUND((valeurfonciere/cadastrelot1surfacecarrez),2))>0
group by dvf_view.cadastrenombrepiecesprincipales
order by Prix_m²_Carrez2P desc 
;



-- Prix moyen d'un appartement 3 Pieces 1 Cellulle
SELECT (SELECT ROUND(AVG(valeurfonciere/cadastrelot1surfacecarrez),2))as Prix_m²_Carrez3P
FROM "P03VASQL".dvf_view
where typelocalcode=2 and cadastrenombrepiecesprincipales=3 and (SELECT ROUND((valeurfonciere/cadastrelot1surfacecarrez),2))>0
;


-- Prix moyen d'un appartement 3 Pieces 
SELECT 
cadastrenombrepiecesprincipales,
(SELECT ROUND(AVG(valeurfonciere/cadastrelot1surfacecarrez),2))as Prix_m²_Carrez3P
FROM "P03VASQL".dvf_view
where typelocalcode=2 and cadastrenombrepiecesprincipales=3 and (SELECT ROUND((valeurfonciere/cadastrelot1surfacecarrez),2))>0
group by dvf_view.cadastrenombrepiecesprincipales
order by Prix_m²_Carrez3P desc 
;






create OR REPLACE VIEW  Prix2P_view as 
SELECT 
cadastrenombrepiecesprincipales,
(SELECT ROUND((valeurfonciere/cadastrelot1surfacecarrez),2))as Prix_m²_Carrez2P
FROM "P03VASQL".dvf_view
where typelocalcode=2 and cadastrenombrepiecesprincipales=2 and (SELECT ROUND((valeurfonciere/cadastrelot1surfacecarrez),2))>0
order by Prix_m²_Carrez2P desc 
;

create OR REPLACE VIEW  Prix3P_view as
SELECT 
cadastrenombrepiecesprincipales,
(SELECT ROUND((valeurfonciere/cadastrelot1surfacecarrez),2))as Prix_m²_Carrez3P
FROM "P03VASQL".dvf_view
where typelocalcode=2 and cadastrenombrepiecesprincipales=3 and (SELECT ROUND((valeurfonciere/cadastrelot1surfacecarrez),2))>0
order by Prix_m²_Carrez3P desc 
;






-- ==> Etape 1 :  Liste prix au  m² appart 2 pièces 
SELECT 
cadastrenombrepiecesprincipales,
cadastrelot1surfacecarrez,  cadastresurfacereellebati, 
cadastrenombrelots, 
 typelocalcode, typelocal, 
communeid, commune, 
deptcode, deptnom, deptcodetrinum ,
regionnom, regioncode,
(SELECT ROUND((valeurfonciere/cadastresurfacereellebati),2)) as Prix_m²_Bati,
(SELECT ROUND((valeurfonciere/cadastrelot1surfacecarrez),2))as Prix_m²_Carrez,
mutationidnun,
mutationdate, mutationquarter, mutationyear, 
valeurfonciere, 
cadastreid
FROM "P03VASQL".dvf_view
where typelocalcode=2 and cadastrenombrepiecesprincipales=2
order by deptcodetrinum ,Prix_m²_Bati desc 
;



--https://www.pichet.fr/guide-immobilier/loi-immobilier/t1-t2-t3-t4-type-logement
