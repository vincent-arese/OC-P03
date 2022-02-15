--9 Les moyennes de valeurs foncières pour le top 3 des communes des départements 6, 13, 33, 59 et 69
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

--- TOP 3 Communes de l'ensemble des departements listés ! 
SELECT 
deptnom,commune,round(( AVG(valeurfonciere)),0) as Prix_Immo_Moy
FROM "P03VASQL".dvf_view
where deptcodetrinum in (6,13,33,59,69) and valeurfonciere IS NOT null
group by commune,deptnom
order by Prix_Immo_Moy DESC
limit 3
; 

--- TOP 3 communes de chaque departements de la liste 
--Version With  .... AS  & Union 
with
Top06 as (SELECT deptnom,commune,round(( AVG(valeurfonciere)),0) as Prix_Immo_Moy FROM "P03VASQL".dvf_view where deptcodetrinum in (6) and valeurfonciere IS NOT null group by commune,deptnom order by deptnom,Prix_Immo_Moy desc limit 3),
Top13 as (select deptnom,commune,round(( AVG(valeurfonciere)),0) as Prix_Immo_Moy FROM "P03VASQL".dvf_view where deptcodetrinum in (13) and valeurfonciere IS NOT null group by commune,deptnom order by deptnom,Prix_Immo_Moy desc limit 3),
Top33 as (SELECT deptnom,commune,round(( AVG(valeurfonciere)),0) as Prix_Immo_Moy FROM "P03VASQL".dvf_view where deptcodetrinum in (33) and valeurfonciere IS NOT null group by commune,deptnom order by deptnom,Prix_Immo_Moy desc limit 3),
Top59 as (SELECT deptnom,commune,round(( AVG(valeurfonciere)),0) as Prix_Immo_Moy FROM "P03VASQL".dvf_view where deptcodetrinum in (59) and valeurfonciere IS NOT null group by commune,deptnom order by deptnom,Prix_Immo_Moy desc limit 3),
Top69 as (SELECT deptnom,commune,round(( AVG(valeurfonciere)),0) as Prix_Immo_Moy FROM "P03VASQL".dvf_view where deptcodetrinum in (69) and valeurfonciere IS NOT null group by commune,deptnom order by deptnom,Prix_Immo_Moy desc limit 3)
select *from Top06
union
select *from Top13
union 
select *from Top33
union 
select *from Top59
union 
select *from Top69
order by deptnom,Prix_Immo_Moy desc;


--- Script avec des view 
create view Top06_view as (
SELECT 
deptnom,commune,round(( AVG(valeurfonciere)),0) as Prix_Immo_Moy
FROM "P03VASQL".dvf_view
where deptcodetrinum in (6) and valeurfonciere IS NOT null
group by commune,deptnom
order by deptnom,Prix_Immo_Moy DESC
limit 3);

create view Top13_view as (
SELECT 
deptnom,commune,round(( AVG(valeurfonciere)),0) as Prix_Immo_Moy
FROM "P03VASQL".dvf_view
where deptcodetrinum in (13) and valeurfonciere IS NOT null
group by commune,deptnom
order by deptnom,Prix_Immo_Moy DESC
limit 3) ;

select *from Top06_view
union
select *from Top13_view
order by deptnom;






-- version view  & Union 

-- Top 3 d'un département 
deptnom,commune,round(( AVG(valeurfonciere)),0) as Prix_Immo_Moy
FROM "P03VASQL".dvf_view
where deptcodetrinum in (6) and valeurfonciere IS NOT null
group by commune,deptnom
order by deptnom,Prix_Immo_Moy DESC
limit 3;
