

-- [ Script ]
-- postgres sql kód, CMD
-- Adatbázis kezdeti lépések , létrehozás 


docker pull postgres:latest


docker run --name pg4 -p 5490:5432 -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=konyvesbolt_beadando_1 -d postgres:latest

docker run --name pg5 -p 5492:5432 -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=konyvesbolt_beadando_2 -d postgres:latest


docker stop pg4

docker stop pg5


docker start pg4

docker start pg5


docker exec -it pg4 psql -U postgres

exit




-- pg5 konténeren belül adatbázis belépés


docker exec -it pg5 psql -U postgres


SELECT current_database();


\c konyvesbolt_beadando_2


\dt




-- teljesítmény analízishez kód 
-- indexelés előtt


explain analyze SELECT 
    v.varos,
    AVG(s.teljes_osszeg) AS atlagos_rendelesi_ertek
FROM Vasarlok v
JOIN Rendelesek r ON v.vasarlo_id = r.vasarlo_id AND v.varos = r.varos
JOIN Szamlak s ON r.rendeles_id = s.rendeles_id
GROUP BY v.varos;




-- teljesítmény analízishez kód 
-- indexelés után


CREATE INDEX varos_idx ON Vasarlok(varos);

explain analyze SELECT 
    v.varos,
    AVG(s.teljes_osszeg) AS atlagos_rendelesi_ertek
FROM Vasarlok v
JOIN Rendelesek r ON v.vasarlo_id = r.vasarlo_id AND v.varos = r.varos
JOIN Szamlak s ON r.rendeles_id = s.rendeles_id
GROUP BY v.varos;




