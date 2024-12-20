# Adatbázis szerverek  
  
**Összefoglaló**  
  
**Beadandó feladat:**
- adatbázis tervezés (indexek stb)
- SQL insertek megírása
- lekérdezések megírása
- triggerek megírása
- tárolt eljárások megírása
- adatbázis teljesítmény analízis
  


  
## Beadandó feladat első rész  
  
**Beadandó Feladat: Online Könyvesbolt Adatbázis Rendszer Kialakítása**  
  
**Cél:**  
Egy online könyvesbolt adatbázis rendszerének kialakítása, megvalósítása és elemzése. Az adatbázisnak képesnek  
kell lennie kezelni a könyvek, vásárlók, rendelések és számlák adatait, valamint automatizálnia kell bizonyos  
műveleteket tárolt eljárások segítségével, mint például a rendelés teljesítése és számlázás.  
  
**Feladatok:**  
Adatbázis Tervezés:  
Tervezd meg az online könyvesbolt adatbázist, vedd figyelembe a szükséges táblákat.  
Tervezd meg az indexeket a hatékony lekérdezés érdekében.  
  
**Adatok Beszúrása:**  
Készíts SQL INSERT utasításokat az adatok táblákba történő beszúrásához.
  

**Lekérdezések Megírása:**  
Készíts lekérdezéseket, amelyek információt nyújtanak az egyes könyvek elérhetőségéről, a vásárlók vásárlási  
előzményeiről és a rendelések státuszáról.  
  
## Beadandó feladat második rész  
  
**Triggerek Megírása:**  
- Hozz létre egy triggert, ami automatikusan frissíti a könyv készletét (elérhető/nem elérhető), amikor egy rendelés teljesül.
  
**Tárolt Eljárások Megírása:**  
- Írj egy tárolt eljárást a számla generálására a vásárlás alapján.
- Készíts tárolt eljárásokat, amelyek különféle statisztikákat és riportokat generálnak, például a legjobban fogyó könyvek és a legaktívabb vásárlók
alapján.
  
**Vásárlók Tábla Particionálása:**  
- Particionáld a vásárlók adatait tartalmazó táblát régió (pl. város) alapján.
  
**Adatbázis Teljesítmény Analízis:**  
- Töltsd fel a táblákat legalább 10 000 rekorddal (használhatsz generált adatokat, hogy szimuláld a valós adatbázis terhelést)
- Írj egy összetett SQL lekérdezést, amely több táblából olvas adatokat (pl. Vásárlók legutóbbi rendelései és a rendelésükhöz tartozó könyvek).
- Elemezd, hogyan teljesít az adatbázis a lekérdezések és műveletek során, és tegyél javaslatokat a teljesítmény optimalizálására (indexek stb.).
  
**Beadandók:**  
- Az adatbázis tervezését bemutató dokumentáció.
- SQL scriptek (táblák létrehozása, adatok beszúrása, lekérdezések, triggerek, tárolt eljárások).
- Teljesítményanalízis jelentés.
  






**Értékelési Szempontok:**  
- A tervezés logikai felépítése és megvalósíthatósága.
- Az SQL scriptek helyessége és hatékonysága.
- A teljesítményanalízis alapossága és a benne foglalt javaslatok relevanciája.

