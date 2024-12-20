

-- [ konyvesbolt_beadando_1 Script ]
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




-- Táblákba adatok beszúrása manuálisan


INSERT INTO Konyvek (cim, szerzo, ar, darab, van_keszleten, kiadas_datuma) VALUES
('A Gyűrűk Ura', 'J.R.R. Tolkien', 5999, 20, 'true', '1954-07-29'),
('Harry Potter és a Bölcsek Köve', 'J.K. Rowling', 2999, 50, 'true', '1997-06-26'),
('A Mester és Margarita', 'Mihail Bulgakov', 4499, 25, 'true', '1967-11-01'),
('1984', 'George Orwell', 3999, 30, 'true', '1949-06-08'),
('A kis herceg', 'Antoine de Saint-Exupéry', 1999, 25, 'true', '1943-04-06'),
('Száz év magány', 'Gabriel García Márquez', 4999, 20, 'true', '1967-05-30'),
('Az alkimista', 'Paulo Coelho', 3499, 40, 'true', '1988-01-01'),
('Éhezők Viadala', 'Suzanne Collins', 2999, 20, 'true', '2008-09-14'),
('Tüskevár', 'Fekete István', 2499, 22, 'true', '1957-01-01'),
('Pál utcai fiúk', 'Molnár Ferenc', 1999, 0, 'false', '1907-01-01');


INSERT INTO Vasarlok_Budapest (teljes_nev, email, varos) VALUES
('Kovács Péter', 'kovacs.peter@example.com', 'Budapest'),
('Nagy Anna', 'nagy.anna@example.com', 'Budapest'),
('Szabó Tamás', 'szabo.tamas@example.com', 'Budapest'),
('Tóth Mária', 'toth.maria@example.com', 'Budapest'),
('Farkas Éva', 'farkas.eva@example.com', 'Budapest'),
('Horváth Béla', 'horvath.bela@example.com', 'Budapest');

INSERT INTO Vasarlok_Miskolc (teljes_nev, email, varos) VALUES
('Kovács Zoltán', 'kovacs.zoltan@example.com', 'Miskolc'),
('Tóth Krisztina', 'toth.krisztina@example.com', 'Miskolc'),
('Nagy László', 'nagy.laszlo@example.com', 'Miskolc'),
('Szabó Eszter', 'szabo.eszter@example.com', 'Miskolc'),
('Varga Gábor', 'varga.gabor@example.com', 'Miskolc'),
('Papp Ádám', 'papp.adam@example.com', 'Miskolc');

INSERT INTO Vasarlok_Szikszo (teljes_nev, email, varos) VALUES
('Lakatos Károly', 'lakatos.karoly@example.com', 'Szikszó'),
('Varga Edit', 'varga.edit@example.com', 'Szikszó'),
('Papp János', 'papp.janos@example.com', 'Szikszó'),
('Kiss Júlia', 'kiss.julia@example.com', 'Szikszó');

INSERT INTO Vasarlok_Siofok (teljes_nev, email, varos) VALUES
('Farkas Gergely', 'farkas.gergely@example.com', 'Siófok'),
('Kiss Patrik', 'kiss.patrik@example.com', 'Siófok'),
('Horváth Tamás', 'horvath.tamas@example.com', 'Siófok'),
('Lakatos Barbara', 'lakatos.barbara@example.com', 'Siófok');


INSERT INTO Rendelesek (vasarlo_id, varos, rendeles_datum, rendeles_allapot) VALUES
(1, 'Budapest', '2023-12-01', 'Teljesitett'),
(2, 'Budapest', '2023-12-02', 'Folyamatban'),
(3, 'Budapest', '2023-12-03', 'Teljesitett'),
(4, 'Budapest', '2023-12-04', 'Folyamatban'),
(5, 'Budapest', '2023-12-05', 'Teljesitett'),
(11, 'Miskolc', '2023-12-06', 'Torolt'),
(12, 'Miskolc', '2023-12-07', 'Teljesitett'),
(13, 'Szikszó', '2023-12-08', 'Folyamatban'),
(14, 'Szikszó', '2023-12-09', 'Teljesitett'),
(15, 'Szikszó', '2023-12-10', 'Folyamatban');


INSERT INTO Tetelek (rendeles_id, konyv_id, mennyiseg) VALUES
(11, 1, 2),
(11, 3, 1),
(12, 4, 2),
(13, 2, 1),
(13, 5, 1),
(14, 6, 3),
(15, 7, 1),
(11, 8, 2),
(12, 9, 1),
(13, 9, 3);




-- Lekérdezések megírása


--Könyvek elérhetőségei
select k.cim, k.szerzo, k.ar, k.darab, 
	CASE 
		WHEN k.van_keszleten = 'true' THEN 'Elérhető'
		ELSE 'Nem elérhető' 
	END AS elerhetoseg_statusza
from Konyvek k;

-- Rendelések státusza
SELECT R.rendeles_id, V.teljes_nev, V.email, R.rendeles_allapot
FROM Rendelesek R
JOIN Vasarlok V ON R.vasarlo_id = V.vasarlo_id AND R.varos = V.varos
ORDER BY R.rendeles_datum DESC;

--Vásárlók vásárlási előzményei
SELECT v.teljes_nev, v.email, r.rendeles_datum, k.cim AS konyv_cim, t.mennyiseg 
FROM Vasarlok v
JOIN Rendelesek r ON v.vasarlo_id = r.vasarlo_id
JOIN Tetelek t ON r.rendeles_id = t.rendeles_id
JOIN Konyvek k ON t.konyv_id = k.konyv_id
ORDER BY r.rendeles_datum DESC;



 
-- Trigger megírása


CREATE OR REPLACE FUNCTION konyv_elerhetoseg_frissites() RETURNS TRIGGER AS $$
BEGIN
	IF (SELECT darab FROM Konyvek WHERE konyv_id = NEW.konyv_id) < NEW.mennyiseg THEN
        RAISE EXCEPTION 'Nincsen elegendo mennyiseg a konyv_id %', NEW.konyv_id;
    END IF;
    IF EXISTS (SELECT 1 FROM Rendelesek WHERE rendeles_id = NEW.rendeles_id AND rendeles_allapot = 'Teljesitett') THEN
 
        UPDATE Konyvek
        SET darab = darab - NEW.mennyiseg
        WHERE konyv_id = NEW.konyv_id;


        UPDATE Konyvek
        SET van_keszleten = 'false'
        WHERE konyv_id = NEW.konyv_id AND darab <= 0;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_frissit_konyvek
AFTER INSERT ON Tetelek
FOR EACH ROW
EXECUTE FUNCTION konyv_elerhetoseg_frissites();


-- teszt Rendelés adatok
INSERT INTO Rendelesek (vasarlo_id, varos, rendeles_datum, rendeles_allapot) VALUES
(1, 'Budapest', '2024-01-15', 'Folyamatban'),
(2, 'Budapest', '2024-01-16', 'Teljesitett'),
(3, 'Budapest', '2024-01-17', 'Torolt'),
(4, 'Budapest', '2024-01-18', 'Folyamatban'),
(5, 'Budapest', '2024-01-19', 'Teljesitett');


-- teszt Tételek adatok
INSERT INTO Tetelek (rendeles_id, konyv_id, mennyiseg) VALUES
(26, 5, 1);


INSERT INTO Tetelek (rendeles_id, konyv_id, mennyiseg) VALUES
(27, 4, 6);


INSERT INTO Tetelek (rendeles_id, konyv_id, mennyiseg) VALUES
(28, 2, 4);


INSERT INTO Tetelek (rendeles_id, konyv_id, mennyiseg) VALUES
(29, 3, 2);


INSERT INTO Tetelek (rendeles_id, konyv_id, mennyiseg) VALUES
(30, 3, 6);




-- Tárolt Eljárások megírása


-- legjobban_fogyo_konyvek_procedure tárolt eljárás

CREATE OR REPLACE PROCEDURE legjobban_fogyo_konyvek_procedure(limit_szam INT DEFAULT 5)
LANGUAGE plpgsql AS $$
BEGIN
    BEGIN
        DROP TABLE IF EXISTS legjobban_fogyo_konyvek_temp;
    EXCEPTION WHEN undefined_table THEN

        NULL;
    END;

    CREATE TEMP TABLE legjobban_fogyo_konyvek_temp (
        konyv_id INT,
        cim TEXT,
        osszes_eladott INT
    ) ON COMMIT PRESERVE ROWS;

    INSERT INTO legjobban_fogyo_konyvek_temp (konyv_id, cim, osszes_eladott)
    SELECT 
        k.konyv_id,
        k.cim,
        SUM(t.mennyiseg)::INT AS osszes_eladott
    FROM Tetelek t
    JOIN Konyvek k ON t.konyv_id = k.konyv_id
    GROUP BY k.konyv_id, k.cim
    ORDER BY osszes_eladott DESC
    LIMIT limit_szam;

    RAISE NOTICE 'Statisztika készen áll az ideiglenes táblában.';
END;
$$;


CALL legjobban_fogyo_konyvek_procedure(3);


SELECT * FROM legjobban_fogyo_konyvek_temp;


-- legaktivabb_vasarlok_procedure tárolt eljárás

CREATE OR REPLACE PROCEDURE legaktivabb_vasarlok_procedure(limit_szam INT DEFAULT 5)
LANGUAGE plpgsql AS $$
BEGIN
    BEGIN
        DROP TABLE IF EXISTS legaktivabb_vasarlok_temp;
    EXCEPTION WHEN undefined_table THEN

        NULL;
    END;

    CREATE TEMP TABLE legaktivabb_vasarlok_temp (
        vasarlo_id INT,
        teljes_nev TEXT,
        osszes_eladott INT
    ) ON COMMIT PRESERVE ROWS;

    INSERT INTO legaktivabb_vasarlok_temp (vasarlo_id, teljes_nev, osszes_eladott)
    SELECT 
        v.vasarlo_id,
        v.teljes_nev,
        COUNT(r.rendeles_id)::INT AS osszes_eladott
    FROM Rendelesek r
    JOIN Vasarlok v ON r.vasarlo_id = v.vasarlo_id
    GROUP BY v.vasarlo_id, v.teljes_nev
    ORDER BY osszes_eladott DESC
    LIMIT limit_szam;

    RAISE NOTICE 'Statisztika készen áll az ideiglenes táblában.';
END;
$$;


CALL legaktivabb_vasarlok_procedure(3);

SELECT * FROM legaktivabb_vasarlok_temp;


-- számla generálása (Tárolt Eljárás)

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


call szamla_generalas(11);


call szamla_generalas(13);



