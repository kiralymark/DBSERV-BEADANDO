

-- [ konyvesbolt_beadando_2 Script ]
-- Táblák létrehozása


CREATE TYPE rendeles_allapot_enum AS ENUM ('Folyamatban', 'Teljesitett', 'Torolt');


CREATE TABLE Vasarlok (
    vasarlo_id SERIAL,
    teljes_nev VARCHAR(32) NOT NULL,
    email VARCHAR(32) NOT NULL,
    varos VARCHAR(64),
	PRIMARY KEY (vasarlo_id, varos)
)partition by list(varos);

CREATE TABLE Vasarlok_Budapest PARTITION OF Vasarlok
    FOR VALUES IN ('Budapest');

CREATE TABLE Vasarlok_Miskolc PARTITION OF Vasarlok
    FOR VALUES IN ('Miskolc');
	
CREATE TABLE Vasarlok_Szikszo PARTITION OF Vasarlok
    FOR VALUES IN ('Szikszó');
   
CREATE TABLE Vasarlok_Siofok PARTITION OF Vasarlok
    FOR VALUES IN ('Siófok');

CREATE TABLE Vasarlok_Egyeb PARTITION OF Vasarlok
    DEFAULT;


CREATE TABLE Rendelesek (
    rendeles_id SERIAL PRIMARY KEY,
    vasarlo_id INT,
	varos VARCHAR(32),
    rendeles_datum DATE NOT NULL,
    rendeles_allapot rendeles_allapot_enum DEFAULT 'Folyamatban',
	FOREIGN KEY (vasarlo_id, varos) REFERENCES Vasarlok(vasarlo_id, varos)
);


CREATE TABLE Konyvek (
    konyv_id SERIAL PRIMARY KEY,
    cim VARCHAR(128) NOT NULL,
    szerzo VARCHAR(64) NOT NULL,
    ar DECIMAL(8, 2),
    darab INT NOT NULL,
    van_keszleten BOOLEAN DEFAULT 'false',
    kiadas_datuma DATE
);


CREATE TABLE Szamlak (
    szamla_id SERIAL PRIMARY KEY,
    rendeles_id INT REFERENCES Rendelesek(rendeles_id),
    teljes_osszeg DECIMAL(16, 2) NOT NULL,
    teljesites_datuma DATE 
);


CREATE TABLE Tetelek (
    rendeles_id INT REFERENCES Rendelesek(rendeles_id),
    konyv_id INT REFERENCES Konyvek(konyv_id),
    mennyiseg INT NOT NULL,
    PRIMARY KEY (rendeles_id, konyv_id)
);




-- Táblákba adatok (10 000) beszúrása


INSERT INTO Vasarlok (teljes_nev, email, varos)
SELECT 
    'Vásárló_' || i AS teljes_nev,
    'email_' || i || '@example.com' AS email,
    CASE WHEN (i % 4) = 0 THEN 'Budapest' 
         WHEN (i % 4) = 1 THEN 'Miskolc'
		 WHEN (i % 4) = 2 THEN 'Szikszó'
         ELSE 'Siófok' END AS varos
FROM generate_series(1, 10000) AS i;


INSERT INTO Rendelesek (vasarlo_id, varos, rendeles_datum, rendeles_allapot)
SELECT 
    v.vasarlo_id,
    v.varos,
    CURRENT_DATE - (i % 365) AS rendeles_datum,
    CASE 
        WHEN (i % 4) = 0 OR (i % 5) = 1 THEN 'Teljesitett'::rendeles_allapot_enum
        WHEN (i % 4) = 2 THEN 'Folyamatban'::rendeles_allapot_enum
        ELSE 'Torolt'::rendeles_allapot_enum
    END AS rendeles_allapot
FROM generate_series(0, 9999) AS i
JOIN Vasarlok v ON v.vasarlo_id = ((i % (SELECT COUNT(*) FROM Vasarlok)) + 1);


INSERT INTO Konyvek (cim, szerzo, ar, darab, van_keszleten, kiadas_datuma)
SELECT 
    'Könyv_' || i AS cim,
    'Szerző_' || i AS szerzo,
    (100 + (i % 500))::DECIMAL(6, 2) AS ar, 
    (10 + (i % 50)) AS darab,       
    CASE WHEN (10 + (i % 50)) > 0 THEN true ELSE false END AS van_keszleten, 
    CURRENT_DATE - (i % 365) AS kiadas_datuma 
FROM generate_series(1, 10000) AS i;


INSERT INTO Tetelek (rendeles_id, konyv_id, mennyiseg)
SELECT 
    (i % 10000) + 1 AS rendeles_id,
    (i % 500) + 1 AS konyv_id, 
    LEAST((random() * 10 + 1)::INT, k.darab) AS darabszam 
FROM generate_series(1, 10000) AS i
JOIN Konyvek k ON k.konyv_id = (i % 500) + 1
WHERE LEAST((random() * 10 + 1)::INT, k.darab) <= k.darab;




-- Tárolt Eljárások
-- számla generálása


CREATE OR REPLACE PROCEDURE szamla_generalas(input_rendeles_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    teljes_osszeg DECIMAL(9, 2);
    van_szamla BOOLEAN;
BEGIN
	IF EXISTS (SELECT 1 FROM Rendelesek WHERE rendeles_id = input_rendeles_id AND rendeles_allapot = 'Teljesitett') THEN
	
		SELECT EXISTS (
			SELECT 1 FROM Szamlak WHERE rendeles_id = input_rendeles_id
		) INTO van_szamla;

		IF van_szamla THEN
			RAISE NOTICE 'Ehhez a rendeléshez (%), már létezik számla.', input_rendeles_id;
			RETURN;
		END IF;

		SELECT SUM(k.ar * t.mennyiseg)
		INTO teljes_osszeg
		FROM Tetelek t
		JOIN Konyvek k ON t.konyv_id = k.konyv_id
		WHERE t.rendeles_id = input_rendeles_id;

		IF teljes_osszeg IS NULL THEN
			RAISE EXCEPTION 'A megadott rendelés (%), nem tartalmaz tételeket.', input_rendeles_id;
		END IF;

		INSERT INTO Szamlak (rendeles_id, teljes_osszeg, teljesites_datuma)
		VALUES (input_rendeles_id, teljes_osszeg, CURRENT_DATE);

		RAISE NOTICE 'Számla generálva rendeléshez: %, összeg: %', input_rendeles_id, teljes_osszeg;
	END IF;
END;
$$;




-- Táblába adatok (10 000) beszúrásához
-- Számlákra generálás


DO $$
DECLARE
    i INT;
BEGIN
    FOR i IN 1..10000 LOOP
        CALL szamla_generalas(i);
    END LOOP;
END;
$$;




-- Lekérdezés megírása a teljesítmény analízishez
--  Mennyi volt az átlagos rendelési érték városonként?
--  Ez a lekérdezés a Rendelesek, Szamlak, és Vasarlok táblák összekapcsolásával készül.


SELECT 
    v.varos,
    AVG(s.teljes_osszeg) AS atlagos_rendelesi_ertek
FROM Vasarlok v
JOIN Rendelesek r ON v.vasarlo_id = r.vasarlo_id AND v.varos = r.varos
JOIN Szamlak s ON r.rendeles_id = s.rendeles_id
GROUP BY v.varos;




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




