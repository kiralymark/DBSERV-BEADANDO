// 2 .  
I. rész
Beadandó Feladat: Online Könyvesbolt Adatbázis Rendszer Kialakítása,
Manuális adatbeszúrás
Bevezetés és feladatleírás
A feladat célja egy online könyvesbolt adatbázis rendszer kialakítása volt. 
A feladat az adatbázis megtervezésével indul.
Adatbázis Tervezés, Normálforma, Partícionálás, Adatbázis táblák szerkezete
Az adatbázis táblák szerkezete
Az online könyvesbolt adatbázis a következő adatokat kezeli a táblák 
segítségével.
Vásárlók: A Vasarlok tábla a vásárlók adatait tárolja, város szerint partícionált.
A tábla oszlopai:
vasarlo_id: Egyedi azonosító (automatikusan generált).
teljes_nev: A vásárló teljes neve (kötelező).
email: A vásárló email címe (kötelező).
varos: A vásárló lakhelyének városa.
Elsődleges összetett kulcs: vasarlo_id és varos.
A tábla partíciói:
Vasarlok_Budapest: Azokat a vásárlókat tartalmazza, akik Budapesten 
élnek.
Vasarlok_Miskolc: Miskolci vásárlók.
Vasarlok_Szikszo: Szikszói vásárlók.
Vasarlok_Siofok: Siófoki vásárlók.
Vasarlok_Egyeb: Más városban lakó vásárlók (ez az alapértelmezett).


3  
Rendelések: A rendelések adatait tartalmazza.
A tábla oszlopai:
rendeles_id: Egyedi azonosító (elsődleges kulcs, automatikusan 
generált).
vasarlo_id: A vásárló azonosítója (külső kulcs a Vasarlok táblára).
varos: A vásárló városa (külső kulcs a Vasarlok táblára).
rendeles_datum: A rendelés dátuma (kötelező).
rendeles_allapot: A rendelés állapota (rendeles_allapot_enum típus, 
alapértelmezett értéke: “Folyamatban”).
Kapcsolat: Minden rendelés egy vásárlóhoz tartozik. 
Összetett külső kulcs van (vasarlo_id, varos).
Könyvek: Információkat tartalmaz a könyvekről, mint cím, szerző, ár, készlet.
A tábla oszlopai:
konyv_id: Egyedi azonosító (elsődleges kulcs, automatikusan generált).
cim: A könyv címe (kötelező).
szerzo: A szerző neve (kötelező).
ar: A könyv ára (maximum 8 számjegy, 2 tizedesjeggyel).
darab: A raktárban elérhető mennyiség (kötelező).
van_keszleten: Készlet állapot (alapértelmezett értéke: ‘false’).
kiadas_datuma: A könyv kiadási dátuma.
Számlák: A vásárlásokat tartalmazó számlákat tárolja..
A tábla oszlopai:
szamla_id: Egyedi azonosító (kulcs, automatikusan generált).
rendeles_id: A számla rendeléshez kapcsolódik (külső kulcs a 
Rendelesek táblára).
teljes_osszeg: A rendelés teljes összege (kötelező).
teljesites_datuma: A számla teljesítésének dátuma.
Kapcsolat:
Összetett kulcs van (szamla_id, rendeles_id).

4  
Tételek: A rendeléshez tartozó könyvtételek táblája.
A tábla oszlopai:
rendeles_id: A rendelés azonosítója (külső kulcs a Rendelesek táblára).
konyv_id: A könyv azonosítója (külső kulcs a Konyvek táblára).
mennyiseg: A rendelésben szereplő könyv mennyisége (kötelező).
Elsődleges összetett kulcs: rendeles_id, konyv_id.
Kapcsolatok:
A Vasarlok és a Rendelesek tábla kapcsolatban áll a vásárlók 
azonosítója (vasarlo_id) és városa (varos) alapján.
A Rendelesek tábla és a Szamlak tábla között kapcsolat van a rendelés 
azonosító (rendeles_id) alapján.
A Rendelesek és a Tetelek tábla között kapcsolat van a rendelés 
azonosító (rendeles_id) alapján.
A Tetelek tábla kapcsolatban áll a Konyvek táblával a könyv azonosító 
(konyv_id) alapján.
A táblák létrehozása előtt létre lesz hozva egy ‘ENUM’ típus ami ‘string’ adatok 
tárolását teszi lehetővé.
Ez az ‘ENUM’ a Rendelések táblában kerül felhasználásra.
A “rendelés állapot” lehet “Folyamatban”, “Teljesitett” vagy “Torolt”.
Optimális az adatbázis terv, több érv is mellette szól.
Vásárlók tábla partícionálva van: A városok szerinti partíciók hatékonyabb 
lekérdezést tesznek lehetővé.
Van rendelés állapot: Az ’ENUM’ típus használata megakadályozza az állapot 
érvénytelen értékre állítását.
Van készletkezelés: A ”van_keszleten” oszlop mutatja, hogy egy könyv 
elérhető-e a készleten.
Van számlázás: A Szamlak tábla minden rendeléshez egyedi számlát kapcsol.

5  
Az adatbázis szerkezet rugalmasan kezeli a vásárlókat, rendeléseket, 
könyveket és számlákat, továbbá a város szerinti partícionálás gyorsítja az 
adatok elérését.
Az adatbázis szerkezeti terve megfelel a Harmadik Normál Forma 
követelményeinek. A Harmadik Normál Forma alapján az adatok ismétlődés 
mentesek és a szerkezeti integritás erős. Fontos még továbbá, hogy egyik 
nem kulcs attribútum sem függ
más nem kulcs attribútumtól.
Az adatbázis Vásárlók táblája partícionálást használ. Ez lehetővé teszi az 
adatok hatékonyabb kezelését. A nagy adatmennyiségeket kisebb, 
kezelhetőbb darabokra osztjuk általa. 
A Vásárlók tábla város mezője kisebb darabokra van osztva:
Budapest, Miskolc, Siófok, Szikszó, Egyéb (ez az alapértelmezett érték).
A lekérdezések idejének meggyorsításában segít például a partícionálás.
Adatbázis technológiák és adatbázis kezdeti beállítások elvégzése
A feladat megoldásához felhasznált technológiák:
SQL,
Postgres SQL,
PL/pgSQL,
DBeaver,
Docker Desktop.
{FÁJL: Script-03.sql}
Először az adatbázis kezdeti beállításait kell elvégezni.
A parancssorban (CMD) a 
docker pull
paranccsal a postgres sql legfrissebb verzióját
letöltjük a számítógépre.

6  
A parancssorban a 
docker run
parancssal kettő konténert hozunk létre 
a Dockerben.
Az első konténert a feladatok többségének 
megoldásához hoztam létre.
A második konténert az adatbázis 
teljesítmény analízis elvégzéséhez 
hoztam létre.
A második konténerhez kerültek be 
az automatikusan létrehozott (10000 sornyi) adatok.
A konténerek nevei:
pg4 és
pg5.
Az első konténer az 5490 -es porton fut.
A második konténer az 5492 -es porton fut.
Mindkét konténer esetében
a felhasználó: postgres
a jelszó: postgres
A pg4 -hez tartozik a konyvesbolt_beadando_1
adatbázis.
A pg5 -höz tartozik a konyvesbolt_beadando_2
adatbázis.
Mindkét konténer “detached” módban a háttérben
fut postgres sql -el.

7  
A parancssorban a 
docker stop
parancsokkal leállítom mindkét
konténer futását (de a konténerek
tartalma nem törlődik).
A parancssorban a 
docker start
parancsokkal elindítom mindkét
konténer futását.
A parancssorban a 
docker exec
parancssal
hozzáférek az adott konténerhez
(belépek a konténerbe).
Az 
exit
paranccsal kilépek az adott
konténerből.
Most jönnek a PostgreSQL -hez
tartozó utasítások.
A parancssorban a 
SELECT current_database();
parancs visszaadja az aktuálisan
csatlakoztatott adatbázis nevét.


8  
A parancssorban a 
\c konyvesbolt_beadando_2
parancs a 
konyvesbolt_beadando_2 adatbázist 
csatlakoztatja.
A parancssorban a 
\dt
parancs kilistázza az aktuálisan
csatlakoztatott adatbázis tábláit.
A parancssorban “psql” segítségével
csatlakoztam a 
kettő Docker konténerhez.
Ezután tudtam kiadni további 
utasításokat az adott konténerhez
csatlakoztatott adatbázissal kapcsolatban.
A parancssorban kiadott 
utasítások után megnyitom a 
DBeaver -t.
(A kettő konténer esetében külön-külön
elvégzem a következő lépéseket.)
Bal felül rákattintok a 
“Create a new connection” menü 
opcióra.
Kiválasztom a PostgreSQL -t.
Ezután rányomok a 
“Next” feliratú gombra.

9  
A “Connection Settings” 
ablakában
megadom a szükséges 
adatokat. Beállítom a portot
és a jelszót is.
A “Test Connection” gombbal
tudom letesztelni, hogy van 
csatlakozás vagy nincs.
Ezután a “Finish” gombra 
kattintok.
Bal felül rákattintok az SQL Editor
menüpontra és 
itt futtatom a megírt SQL kódokat.
Például itt futtatom az SQL tábla létrehozásokat 
és az SQL beszúrásokat is.
A manuális SQL adatbeszúrások megírása
{FÁJL: Script-01.sql}
Az SQL tábla létrehozások kódjának 
lefuttatása után 
az SQL adatbeszúrások kódját is 
lefuttatom.
A táblákba adatokat 
szúrok be manuálisan.
Az ’INSERT INTO …’
sql parancsokkal 
szúrok be adatokat 
a megfelelő 
táblákba.


10  
A Könyvek tábla esetén, ha a 
darab nagyobb mint 0 
akkor a ”van_keszleten”
értéke “true” kell hogy legyen.
A Vásárlók táblába
partícionálva kerülnek 
beszúrásra a sorok.
A Rendelések táblába
az összetett kulcsok 
értékeit figyelembe veszem
a sorok beszúrásakor.
A Rendelések táblába
az ‘ENUM’ 
értékeit figyelembe veszem
a sorok beszúrásakor.
A Tételek táblába
az összetett kulcsok
értékeit figyelembe veszem
a sorok beszúrásakor.
A Tételek táblába
az “mennyiseg”
értékeit figyelembe veszem
a sorok beszúrásakor.
A Számlák táblába később 
lesz beszúrva sor tárolt 
eljárások segítségével.


11  
Lekérdezések megírása
A következő feladat, hogy a lekérdezések
meg legyenek írva.
Megírom a lekérdezéseket
(Könyvek elérhetőségei, Rendelések státusza, Vásárlók vásárlási 
előzményei), utána lefuttatom és 
leellenőrizem
hogy jó-e.
Könyvek elérhetőségei lekérdezés.
Itt kilistázásra kerül az összes 
könyv.
Ha a készleten van akkor “Elérhető” a könyv,
különben 
“Nem elérhető”.
Rendelések státusza lekérdezés.
Itt kilistázásra kerül az összes 
rendelés a rendelés dátuma
szerint rendezve.
Kiiratásra kerül a rendelés 
azonosító, a név, az email, 
a rendelés állapota.
Vásárlók vásárlási előzményei lekérdezés.
Itt kilistázásra kerül az, hogy
ki, mikor, miből, mennyit
vett. A rendelés dátuma 
szerint lesz rendezve.

12  
Trigger megírása
A könyv készletének (van_keszleten) automatikus frissítéséhez triggert 
használtam.
A triggerek olyan eseményvezérelt műveletek, amelyek automatikusan 
végrehajtódnak egy adott tábla műveletei (INSERT, UPDATE, DELETE) 
során.
A triggerek meghívásáról az adatbázis gondoskodik, nem manuálisan kell ezt 
elvégezni. A trigger egy konkrét eseményhez és 
egy konkrét táblához kötődik.
A trigger egy trigger függvényt hív meg amelyben végrehajtásra 
kerül a kívánt művelet.
A “trg_frissit_konyvek” nevű trigger azt figyeli, hogyha egy
INSERT esemény bekövetkezik a 
Tételek táblán. 
A “trg_frissit_konyvek” nevű trigger meghívja a 
“konyv_elerhetoseg_frissites” nevű függvényt.
A “konyv_elerhetoseg_frissites” nevű függvény
frissíti a könyvek elérhetőségét, ha 
“Teljesitett” a rendelés állapota.
Ha a darab egyenlő 0, akkor 
nincs készleten az adott könyv.
Ha “Teljesitett” a rendelés állapota, akkor
frissítésre kerül a darab értéke.
A darab értékéből kivonásra kerül a 
mennyiseg (csak akkor, ha a kivonás 
után a darab értéke nagyobb vagy 
egyenlő a nullánál).


13  
A trigger működésének leellenőrzéséhez odatettem
néhány teszt adatot (Rendelések tábla adatbeszúrás 
és Tételek tábla adatbeszúrás).
Tárolt Eljárások megírása
legjobban_fogyo_konyvek_procedure tárolt eljárás.
Ehhez a feladathoz tárolt eljárásokat használtam.
A tárolt eljárások olyan előre definiált és az adatbázisban tárolt SQL vagy 
PL/pgSQL kódok, amelyeket paraméterekkel hívhatunk meg. Ezeket akkor 
használjuk, ha az üzleti logikát közvetlenül az adatbázisban szeretnénk 
megvalósítani, nem pedig az alkalmazás kódjában.
Összetett műveleteket végeznek el, például adatmanipulációt, számításokat, 
vagy más SQL műveletek végrehajtását.
Általuk például több lekérdezés és módosítás összefűzhető egyetlen 
egységben.
A tárolt eljárások paraméterezhetők. Elfogadnak bemeneti (IN), 
kimeneti (OUT), vagy mindkettő (INOUT) paramétereket.
A tárolt eljárások támogatják az elágazások (IF/CASE) és ciklusok 
(LOOP/FOR) használatát.
A tárolt eljárások meghívása
a ‘CALL’ utasítással történik.

14  
A “ legjobban_fogyo_konyvek_procedure” nevű tárolt eljárás
a ‘CALL’ utasítással történik és a létrehozott 
temp table -ből (“legjobban_fogyo_konyvek_temp”) lehetséges az adatok 
megtekintése.
A tárolt eljárás segítségével a legjobban fogyó könyvekről 
készíthetők statisztikák. A tárolt eljárás ideiglenes táblát hoz létre, amely 
tartalmazza a legjobban fogyó könyveket az eladott példányszám alapján.
A tárolt eljárás bemeneti paraméterének megadható egy olyan érték, amivel 
a visszaadott könyvek maximális számát lehet limitálni. A “top x eladott könyv”
megadható ezzel.
Az eljárás a következő feladatokat hajtja végre:
Ideiglenes tábla létrehozása:
Ha létezik már az ideiglenes tábla (legjobban_fogyo_konyvek_temp), 
az eljárás törli azt, hogy biztosítsa az új adatok frissességét.
Adatok összegyűjtése és betöltése:
Az ‘INSERT INTO ... SELECT’ utasítás segítségével feltölti az 
ideiglenes táblát a könyvek adataival.
A lekérdezés:
Összesíti az eladott példányszámokat a “Tetelek” táblában.
Rendezi az adatokat az eladások összesített száma szerint csökkenő 
sorrendben.
Csak a “limit_szam” által meghatározott számú könyvet adja vissza.
Visszajelzés:
Az eljárás végrehajtása után egy üzenetet küld (RAISE NOTICE), 
amely jelzi, hogy az ideiglenes tábla készen áll.


15  
Az ideiglenes táblában a következő adatok lesznek 
amik aztán egy lekérdezéssel kiírattathatók:
konyv_id (INT): A könyv egyedi azonosítója.
cim (TEXT): A könyv címe.
osszes_eladott (INT): Az adott könyvből eladott összes példányszám.
Fontos, hogy az ideiglenes tábla csak az aktuális adatbázis-kapcsolat 
élettartamáig marad meg.
Hibakezelés:
Az eljárás figyeli, hogy létezik-e a “legjobban_fogyo_konyvek_temp” tábla. Ha 
nem létezik, a ‘DROP TABLE’ parancs figyelmen kívül hagyja a hibát, és az 
eljárás folytatódik.
legaktivabb_vasarlok_procedure tárolt eljárás.
Ez az eljárás a legaktívabb vásárlókat tárolja el egy ideiglenes táblában az 
általuk leadott rendelések száma alapján.
A tárolt eljárás bemeneti paraméterének megadható egy olyan érték, amivel 
a visszaadott legaktívabb vásárlók maximális számát lehet limitálni. 
Működés:
Ideiglenes tábla törlése:
Ha létezik a “legaktivabb_vasarlok_temp” tábla, az eljárás törli azt, hogy 
helyet biztosítson az új adatoknak.

16  
Ideiglenes tábla létrehozása:
Az ideiglenes tábla a vásárlók azonosítóját (vasarlo_id), nevét 
(teljes_nev), és az általuk leadott rendelések számát (osszes_eladott) 
tartalmazza.
Adatok beillesztése:
Összekapcsolja a Rendelesek és Vasarlok táblát.
Összesíti, hogy az egyes vásárlók hány rendelést adtak le.
Rendezi az adatokat csökkenő sorrendben a rendelések száma szerint.
Csak a megadott limit_szam értéknek megfelelő számú vásárlót helyezi 
az ideiglenes táblába.
Visszajelzés:
Egy üzenetet küld (RAISE NOTICE), amely jelzi, hogy az ideiglenes 
tábla készen áll.
Az ideiglenes tábla oszlopai:
vasarlo_id: (INT) A vásárló azonosítója
teljes_nev: (TEXT) A vásárló teljes neve
osszes_eladott: (INT) A vásárló által leadott rendelések száma
Az eljárás figyelembe veszi azokat a rendeléseket, amelyek a Rendelesek 
táblában szerepelnek.
szamla_generalas tárolt eljárás.
A Számla tábla sorainak beszúrásához tárolt eljárásokat használtam.
A tárolt eljárás a vásárlás alapján hoz létre 
számlákat. Egy rendelés alapján számlát generál, ha a rendelés teljesített 
állapotban van, és még nem készült hozzá számla.

17  
A tárolt eljárás bemeneti paraméterének megadható egy olyan érték, ami 
az adott rendelésnek az azonosítója. Ehhez fog a tárolt eljárás számlát 
generálni.
Feltételek:
A rendelésnek "Teljesített" állapotúnak kell lennie.
A rendeléshez még nem létezhet számla.
A rendelésnek tartalmaznia kell tételeket.
Működés:
Rendelés ellenőrzése:
Az eljárás megnézi, hogy a megadott rendelés
“Teljesitett” állapotú-e és 
létezik-e már hozzá számla. Ha már van számla, 
az eljárás üzenetet küld és kilép.
Teljes összeg számítása:
Az eljárás kiszámítja a rendelés teljes értékét a Tetelek és Konyvek 
táblák alapján.
A tételek mennyiségét megszorozza az adott könyv árával.
Ha nincsenek tételek, hibát jelez.
Számla létrehozása:
Az eljárás bejegyzést készít a Szamlak táblába a következő adatokkal:
rendeles_id: (INT) A rendelés azonosítója.
teljes_osszeg: (DECIMAL) A rendeléshez tartozó tételek 
összértéke.
teljesites_datuma: (DATE) A számla létrehozásának dátuma.


18  
Visszajelzés:
Az eljárás üzenetet küld (RAISE NOTICE), amely tartalmazza a 
rendelés azonosítóját és a generált számla összegét.
Hibák kezelése:
Ha már létezik számla a rendeléshez, az eljárás értesíti a felhasználót.
Ha a rendelés nem tartalmaz tételeket, hibaüzenet jelenik meg.




19  
II. rész
Beadandó Feladat: Online Könyvesbolt Adatbázis Rendszer Kialakítása,
Automatikus adatbeszúrás,
Teljesítmény analízis
{FÁJL: Script-02.sql}
Bevezetés és feladatleírás
Az adatbázist a 
teljesítmény analízis elvégzéséhez 
hoztam létre.
A második adatbázishoz kerültek be 
az automatikusan létrehozott (10000 sornyi) adatok.
A feladat célja egy online könyvesbolt adatbázis rendszer kialakítása volt. 
A feladat az adatbázis megtervezésével indul.
Adatbázis Tervezés, Adatbázis táblák szerkezete
Az adatbázis táblák szerkezete
Az online könyvesbolt adatbázis a következő adatokat kezeli a táblák 
segítségével.
Az adatbázis szerkezet, az adattípusok megegyeznek az első adatbáziséval.


20  
Adatbázis táblák:
Vásárlók, 
Rendelések, 
Könyvek, 
Számlák,
Tételek
Adatbázis Teljesítmény Analízis, Adatok beszúrása 10000 rekorddal, 
Összetett SQL lekérdezés írása
Adatok beszúrása automatikusan (10000 sor)
Itt több táblába tömegesen generálunk, szúrunk be adatokat, mesterséges 
tesztadatok előállításához. Az összes tábla feltöltésre kerül adatokkal. 
Több tábla 10000 rekorddal kerül feltöltésre.
Vásárlók tábla feltöltése
Működés:
Generált adatok:
teljes_nev: Számozott vásárlói nevek, pl. "Vásárló_1", "Vásárló_2".
email: Egyedi e-mail címek azonosítóval, pl. "email_1@example.com".
varos: Négy város közül választ, körforgással: Budapest, Miskolc, 
Szikszó, Siófok.



21  
Rendelések tábla feltöltése
Működés:
Generált adatok:
vasarlo_id: Véletlenszerűen rendel vásárlókat a rendelésekhez.
varos: A vásárló lakóhelye.
rendeles_datum: A mai naphoz képest az elmúlt 365 nap egyikére 
állítja a rendelés dátumát.
rendeles_allapot: Három állapot közül választ: Teljesitett, Folyamatban, 
Torolt.
Könyvek tábla feltöltése
Működés:
Generált adatok:
cim: Számozott könyvcímek, pl. "Könyv_1", "Könyv_2".
szerzo: Számozott szerzői nevek.
ar: Véletlenszerű ár 100 és 599 között.
darab: Véletlenszerű készlet (10–59 között).
van_keszleten: Ha a készlet nagyobb mint 0, akkor igaz; különben 
hamis.
kiadas_datuma: Az elmúlt 365 nap egyikére állítja a kiadás dátumát.



22  
Tételek tábla feltöltése
Működés:
Generált adatok:
rendeles_id: Véletlenszerűen kapcsolja a rendeléseket a tételekhez.
konyv_id: Véletlenszerű könyvet kapcsol a tételhez.
mennyiseg: Véletlenszerű mennyiség (1–10 között), amely nem haladja 
meg a könyv készletét.
Számlák tábla feltöltése
Ehhez tárolt eljárást használtam.
Ugyanazt a tárolt eljárást használom, ugyanazzal a működéssel 
mint az első adatbázisban.
A Számlák tábla feltöltéséhez meghívom
Rendelések táblában 
található “rendeles_id” kulcsra
1 -től 10000 -ig a
tárolt eljárást.


23  
Adatbázis Teljesítmény Analízis, Összetett SQL lekérdezés írása,
Index használat előtt
Index használat előtt  
1 . ábra  
A teljesítmény analízis 
végezhető
a parancssorban (CMD) 
például.
Indexelési technikák alkalmazásával az adatbázis teljesítményének 
javítása lenne optimális.
A cél az, hogy megvizsgáljuk, hogyan hat az indexelés a lekérdezések 
végrehajtási idejére.


24  
Az összetett lekérdezés ami meg lett írva azt csinálja, hogy kiszámolja az 
átlagos rendelési értéket városonként.
Működés:
Feladat:
Az átlagos rendelési érték (számlák alapján) kiszámítása városonként.
Kapcsolatok:
Vasarlok és Rendelesek: Vásárlók azonosítója (vasarlo_id) és városa 
(varos).
Rendelesek és Szamlak: Rendelések azonosítója (rendeles_id).
Aggregálás:
Az egyes városokra csoportosított átlagos 
rendelési összeg (AVG(s.teljes_osszeg)).
Az Explain Analyze használata
Ezt az utasítást a lekérdezés végrehajtási tervének elemzésére 
használjuk.
Információt ad a sorok számáról, szűrési feltételekről, és a végrehajtási 
időről.
Indexelés nélkül:
Az elemzés célja az lenne, hogy 
megmérjük a lekérdezés végrehajtási idejét indexelés alkalmazása 
nélkül.


25  
Index használat után  
2 . ábra  
Az adatbázis teljesítményének javítása érdekében létrehozunk indexeket a 
gyakran használt oszlopokra.
Ezáltal a lekérdezés lefutási ideje rövidebb lesz.
Indexelés után a
működés:
Cél: Az index gyorsítja az ”ON v.varos = r.varos” feltétellel kapcsolódó 
keresést.
Hatás:
Csökkenti a lekérdezések futási idejét, különösen nagy adatállományok 
esetén.
Az indexelés lehetővé teszi az adatbázis számára, hogy 
hatékonyabban szűrje és rendezze az adatokat.


26  
EXPLAIN ANALYZE ismételt futtatása után a
működés:
Az elemzés célja, hogy összehasonlítsa a futási időt az indexelés 
előttivel.
Várható eredmény:
A lekérdezés végrehajtási ideje rövidebb lesz, különösen sok adatsor 
esetén.
Indexelés után tehát gyorsul az ’ON’ és ’WHERE’ feltételek végrehajtása.
A futási idő is jelentősen csökken.
Teljesítmény Analízis és Javaslatok
Az adatbázis teljesítményének elemzése során figyelembe kell venni:
Indexek: Az indexek növelik a keresések gyorsaságát, de lassítják az 
adatmódosító műveleteket (INSERT/UPDATE/DELETE). Érdemes 
olyan mezőkre indexet létrehozni, amelyekre gyakran keresünk.
Partícionálás: A vásárlók tábla partícionálása javítja a lekérdezések 
teljesítményét város alapú lekérdezéseknél.
Triggerek és tárolt eljárások: Automatikus műveletek segítik a rendszer 
hatékonyságát, de figyelni kell arra, hogy ne terheljék túl a rendszert.


// 27 .

