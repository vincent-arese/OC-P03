-- 2. Proportion des ventes d’appartements par le nombre de pièces.
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

-- Partiel Ok probleme arrondi 

-- ==> Etape 2 : Requette finale   !!!!!  Fonctionne mais probleme arrondi - je n'arrive pas a utiliser correctement les alias pour simplifier le code  !!!!
select typelocal ,cadastrenombrepiecesprincipales, count(cadastrenombrepiecesprincipales) as nbr ,
count(cadastrenombrepiecesprincipales)/(31378/100) as "%totalApptManuel",
count(cadastrenombrepiecesprincipales)/((select count(typelocalcode) as totalappt  FROM "P03VASQL".dvf_view as totalAppt where mutationyear = 2020 and mutationquarter <=2 and typelocalcode =2)/10000) as "Pour 10 000 totalApptSQL",
(SELECT ROUND((count(cadastrenombrepiecesprincipales)/(31378/100)),4)) as "%totalApptManuel Arrondi2"
FROM "P03VASQL".dvf_view
where mutationyear = 2020 and mutationquarter<=2 and typelocalcode=2
group by cadastrenombrepiecesprincipales, typelocal
order by cadastrenombrepiecesprincipales;



--> Etape 1 : test requette intermédiaire 

-- total par type local Appt ou maison : 
select  typelocal, count(typelocalcode) as nbr_appt FROM "P03VASQL".dvf_view as totalAppt where mutationyear = 2020 and mutationquarter <=2 and typelocalcode <=2 group by typelocal; 

--Total Appt 
select count(typelocalcode) as totalappt  FROM "P03VASQL".dvf_view as totalAppt where mutationyear = 2020 and mutationquarter <=2 and typelocalcode =2;
(select count(typelocalcode) as totalappt  FROM "P03VASQL".dvf_view as totalAppt where mutationyear = 2020 and mutationquarter <=2 and typelocalcode =2);


