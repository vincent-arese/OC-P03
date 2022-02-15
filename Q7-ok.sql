--7. Liste des communes où le nombre de ventes a augmenté d'au moins 20% entre le premier et le second trimestre de 2020
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 



--- OK mais voir sir possible optimiser le code avec alias ????
select TotalVentesComQ1_view.commune , totalventescomq1 ,totalventescomq2, totalventescomq2-totalventescomq1 as delta, (((totalventescomq2-totalventescomq1)/totalventescomq1)*100) as Calcul_variation
from TotalVentesComQ2_view,TotalVentesComQ1_view 
where TotalVentesComQ2_view.commune=TotalVentesComQ1_view.commune and ((((totalventescomq2-totalventescomq1)/totalventescomq1)*100))>20
order by Calcul_variation Asc




-- Liste commune avec evolution ventes Q1vsQ2 Manque le filtre sur le calcul

select TotalVentesComQ1_view.commune , totalventescomq1 ,totalventescomq2, totalventescomq2-totalventescomq1 as delta, (((totalventescomq2-totalventescomq1)/totalventescomq1)*100) as Calcul_var
from TotalVentesComQ2_view,TotalVentesComQ1_view 
where TotalVentesComQ2_view.commune=TotalVentesComQ1_view.commune --and TotalVentesComQ1_view.commune like 'PARIS%'
order by Calcul_var desc

--ventes Q2 2020 detail 
create OR REPLACE VIEW  TotalVentesComQ2_view as 
 select   commune,  count(communeid) as TotalVentesComQ2
FROM "P03VASQL".dvf_view  as VentesQ2
where mutationyear = 2020 and mutationquarter=2 and typelocalcode <=2
group by  commune
order by commune ASC;

create OR REPLACE VIEW TotalVentesComQ1_view as 
 select commune,  count(communeid) as TotalVentesComQ1
FROM "P03VASQL".dvf_view as VentesQ1
where mutationyear = 2020 and mutationquarter=1 and typelocalcode <=2
group by commune
order by commune asc ;


select count(*)
from raw 
where commune like 'PAU%' and date_part('quarter', mutationdate)=2;
