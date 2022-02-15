-- 6. Taux d’évolution du nombre de ventes entre le premier et le second trimestre de 2020.
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

-- OK code optimisé ---> mais problem arrondi ! 
with 
Q1 as (select count(*) as VQ1 FROM "P03VASQL".dvf_view where mutationyear=2020 and mutationquarter=1),
Q2 as (select count(*) as VQ2 FROM "P03VASQL".dvf_view where mutationyear=2020 and mutationquarter=2)
select VQ1,VQ2,round( (((VQ2-VQ1)/VQ1)*100),2),VQ2-VQ1 as delta, round(((VQ2-VQ1)/16776.00),2)
from Q1,Q2 ;






---> Plus ou moins OK probleme Arrondi 

select round( 
(((select count(*) FROM "P03VASQL".dvf_view as VentesQ2 where mutationyear=2020 and mutationquarter=2 ) - (select count(*) FROM "P03VASQL".dvf_view as VentesQ1 where mutationyear=2020 and mutationquarter=1 ))/(select count(*) FROM "P03VASQL".dvf_view as VentesQ1 where mutationyear=2020 and mutationquarter=1 ))*100
,2)
FROM "P03VASQL".dvf_view
limit 1 ;

select round( 
((select count(*) FROM "P03VASQL".dvf_view as VentesQ2 where mutationyear=2020 and mutationquarter=2 ) - (select count(*) FROM "P03VASQL".dvf_view as VentesQ1 where mutationyear=2020 and mutationquarter=1 ))/(1)
,2)
FROM "P03VASQL".dvf_view
limit 1 ;

--- test pour voir si pbr arrondi 
select 
((select count(*) FROM "P03VASQL".dvf_view as VentesQ2 where mutationyear=2020 and mutationquarter=2 ) - (select count(*) FROM "P03VASQL".dvf_view as VentesQ1 where mutationyear=2020 and mutationquarter=1 ))/(1)
FROM "P03VASQL".dvf_view
limit 1
;


--ventes Q1 & Q2 2020 => OK verifié 
select count(*) FROM "P03VASQL".dvf_view as VentesQ2 where mutationyear=2020 and mutationquarter=2  ; --==>17393
select count(*) FROM "P03VASQL".dvf_view as VentesQ2 where mutationyear=2020 and mutationquarter=1  ; --==>16776
																								      -- D2-Q1 = + 617 soit + 3.6677%

--ventes Q1 2020 detail
select  mutationyear, mutationquarter,typelocal, count(typelocalcode) as nbr
FROM "P03VASQL".dvf_view
where mutationyear = 2020 and mutationquarter =1 and typelocalcode <=2
group by mutationyear, mutationquarter,typelocal
