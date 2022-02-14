--4. Prix moyen du mètre carré d’une maison en Île-de-France.
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

--- Ok avec arrondi 
SELECT 
round( (AVG((valeurfonciere/cadastresurfacereellebati))),0) as Prix_m²_Bati_Maison_IDF
FROM "P03VASQL".dvf_view
where regioncode=11 and typelocalcode=1
;


--- Verif  cohérance des données  Problme sur le 75  avec données aberrantes

SELECT 
regionnom,
round( (AVG((valeurfonciere/cadastresurfacereellebati))),0) as Prix_m²_Bati
FROM "P03VASQL".dvf_view
where regioncode<=1100 and typelocalcode<=2
group by regionnom
order by Prix_m²_Bati DESC;



SELECT 
deptcode,
round( (AVG((valeurfonciere/cadastresurfacereellebati))),0) as Prix_m²_Bati
FROM "P03VASQL".dvf_view
where regioncode<=1100 and typelocalcode<=2
group by deptcode
order by Prix_m²_Bati DESC;




---- Ok sans arrondi 
SELECT 
AVG((valeurfonciere/cadastresurfacereellebati)) as Prix_m²_Bati
FROM "P03VASQL".dvf_view
where regioncode=11 and typelocalcode=1
;


-- ==> Etape 1 :  Liste des maisons en Idf et prix ua m²
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
where regioncode=11 and typelocalcode=1
order by deptcodetrinum ,Prix_m²_Bati desc 
;
