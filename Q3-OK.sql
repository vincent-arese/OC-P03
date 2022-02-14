--3. Liste des 10 départements où le prix du mètre carré est le plus élevé.
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

-- Valider la bonne requette 


-- Requette sur les 10 dept ou prix moyen du département au mètre carré est le plus élevé.
SELECT 
deptcode, 
round((AVG(valeurfonciere/cadastresurfacereellebati)),0) as Prix_m²_Moy_Dept
FROM "P03VASQL".dvf_view
where (valeurfonciere/cadastresurfacereellebati)>0 
group by deptcode
order by Prix_m²_Moy_Dept desc 
limit 10;



-- Requette sur les 10 dept ou le prix/m² d'un bien est le plus élevé.
SELECT 
deptcode, 
MAX(ROUND((valeurfonciere/cadastresurfacereellebati),0)) as Prix_m²_MAX_Dept
FROM "P03VASQL".dvf_view
where (valeurfonciere/cadastresurfacereellebati) is not NULL
group by deptcode
order by Prix_m²_MAX_Dept desc 
limit 10;



