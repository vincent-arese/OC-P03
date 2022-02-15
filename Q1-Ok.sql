--Q1. Nombre total d’appartements vendus au 1er semestre 2020.
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
select  typelocal, count(typelocalcode) as nbr_appt
FROM "P03VASQL".dvf_view
where mutationyear = 2020 and mutationquarter <=2 and typelocalcode =2
group by typelocal
;
