--5. Liste des 10 appartements les plus chers avec le département et le nombre de mètres carrés.
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
SELECT 
typelocal,
valeurfonciere,
cadastrelot1surfacecarrez,
cadastresurfacereellebati, 
deptnom,
(SELECT ROUND((valeurfonciere/cadastresurfacereellebati),2)) as Prix_m²_Bati,
(SELECT ROUND((valeurfonciere/cadastrelot1surfacecarrez),2))as Prix_m²_Carrez,
commune
FROM "P03VASQL".dvf_view
where  typelocalcode=2 and valeurfonciere>0
order by valeurfonciere desc ,deptcodetrinum
limit 10
;
--oK ! 

-- requette Q5 ok .... mais valeurs abérantes dans le raw ! 
SELECT 
typelocal,
mutationdate, 
cadastreid,
valeurfonciere,
cadastrelot1surfacecarrez,
cadastresurfacereellebati, 
cadastrenombrepiecesprincipales,
deptnom,
(SELECT ROUND((valeurfonciere/cadastresurfacereellebati),2)) as Prix_m²_Bati,
(SELECT ROUND((valeurfonciere/cadastrelot1surfacecarrez),2))as Prix_m²_Carrez,
commune,
communeid,
cadastrenombrelots,
mutationidnun
FROM "P03VASQL".dvf_view
where  typelocalcode=2 and valeurfonciere>0
order by valeurfonciere desc ,deptcodetrinum
limit 10
;

-- oK mais nombreuses valeurs incoherentes presente sur le raw ! 
SELECT *, (SELECT ROUND((valeurfonciere/cadastresurfacereellebati),2)) as Prix_m²_Bati,(SELECT ROUND((valeurfonciere/cadastrelot1surfacecarrez),2))as Prix_m²_Carrez
from raw
where rawid in (32275, 29799, 32433, 31973, 32135, 29513)

