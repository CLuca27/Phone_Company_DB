-- Crearea tabelei P_LOCALITATE (tabelul localităților)
CREATE TABLE P_LOCALITATE(
    ID_LOCALITATE NUMBER(6) NOT NULL,   -- ID unic pentru localitate
    NUME VARCHAR2(20) NOT NULL,          -- Numele localității
    JUDET VARCHAR2(20) NOT NULL,         -- Județul localității
    REGIUNE VARCHAR2(20) NOT NULL,       -- Regiunea localității
    ACOPERIRE NUMBER(1)                 -- Acoperire (valoare 0 sau 1)
);

-- Adăugarea constrângerilor de integritate pentru tabelul P_LOCALITATE
ALTER TABLE P_LOCALITATE
ADD (
    CONSTRAINT Chk_val_acoperire_is_bool CHECK(ACOPERIRE IN (0, 1)),  -- Verifică dacă ACOPERIRE este 0 sau 1
    CONSTRAINT Chk_judet CHECK(JUDET IN ('Alba', 'Arad', 'Argeș', 'Bacău', 'Bihor', 'Bistrița-Năsăud', 'Botoșani', 'Brașov', 'Brăila', 'București', 'Buzău', 'Caraș-Severin', 'Călărași', 'Cluj', 'Constanța', 'Covasna', 'Dâmbovița', 'Dolj', 'Galați', 'Giurgiu', 'Gorj', 'Harghita', 'Hunedoara', 'Ialomița', 'Iași', 'Ilfov', 'Maramureș', 'Mehedinți', 'Mureș', 'Neamț', 'Olt', 'Prahova', 'Sălaj', 'Satu Mare', 'Sibiu', 'Suceava', 'Teleorman', 'Timiș', 'Tulcea', 'Vâlcea', 'Vaslui', 'Vrancea')), -- Verifică dacă JUDETul este din lista permisă
    CONSTRAINT Chk_regiune CHECK(REGIUNE IN ('Banat', 'București-Ilfov', 'Crișana', 'Dobrogea', 'Maramureș', 'Moldova', 'Muntenia', 'Oltenia', 'Transilvania')), -- Verifică dacă REGIUNE este din lista permisă
    PRIMARY KEY (ID_LOCALITATE)  -- Setează ID_LOCALITATE ca cheie primară
);

-- Crearea tabelei P_MAGAZIN (tabelul magazinelor)
CREATE TABLE P_MAGAZIN(
    ID_MAGAZIN NUMBER(4) NOT NULL,     -- ID unic pentru magazin
    ID_LOCALITATE_MAGAZIN NUMBER(6)    -- ID-ul localității unde este situat magazinul
);

-- Adăugarea constrângerilor de integritate pentru tabelul P_MAGAZIN
ALTER TABLE P_MAGAZIN
ADD (
    PRIMARY KEY (ID_MAGAZIN),  -- Setează ID_MAGAZIN ca cheie primară
    CONSTRAINT FK_LocalitateMagazin FOREIGN KEY (ID_LOCALITATE_MAGAZIN) REFERENCES
    P_LOCALITATE(ID_LOCALITATE) ON DELETE CASCADE  -- Creează o relație de cheie străină cu P_LOCALITATE
);

-- Crearea tabelei P_ANTENA (tabelul antenelor)
CREATE TABLE P_ANTENA(
    ID_ANTENA NUMBER(4) NOT NULL,  -- ID unic pentru antenă
    LOCATIE_GPS_ANTENA VARCHAR2(30) NOT NULL,  -- Locația GPS a antenei
    ARIE_DESERVITA NUMBER(5,2) NOT NULL,       -- Aria deservită de antenă
    ID_LOCALITATE_APROPIATA NUMBER(6)         -- ID-ul localității apropiate
);

-- Adăugarea constrângerilor de integritate pentru tabelul P_ANTENA
ALTER TABLE P_ANTENA
ADD (
    PRIMARY KEY (ID_ANTENA),  -- Setează ID_ANTENA ca cheie primară
    CONSTRAINT FK_LocalitateAntena FOREIGN KEY (ID_LOCALITATE_APROPIATA) REFERENCES
    P_LOCALITATE(ID_LOCALITATE) ON DELETE CASCADE  -- Creează o relație de cheie străină cu P_LOCALITATE
);

-- Crearea tabelei P_CLIENTI (tabelul clienților)
CREATE TABLE P_CLIENTI(
    ID_CLIENT NUMBER(6) NOT NULL,        -- ID unic pentru client
    NUME VARCHAR2(30) NOT NULL,          -- Numele clientului
    ID_LOCALITATE_CLIENT NUMBER(6),      -- ID-ul localității clientului
    CNP NUMBER(13) NOT NULL,             -- CNP-ul clientului
    EMAIL VARCHAR2(50),                  -- Emailul clientului
    TELEFON_FIX NUMBER(1) NOT NULL,      -- Telefon fix (0 sau 1)
    ID_ABONAMENT_CLIENT NUMBER(4),  -- ID-ul abonamentului clientului
    DATA_NASTERII DATE,                  -- Data nașterii clientului
    DATA_INREGISTRARII DATE             -- Data înregistrării clientului
);

-- Crearea tabelei P_ABONAMENTE (tabelul abonamentelor)
CREATE TABLE P_ABONAMENTE(
    ID_ABONAMENT NUMBER(4) NOT NULL,     -- ID-ul abonamentului
    DEN_ABONAMENT VARCHAR2(30) NOT NULL, -- Denumirea abonamentului
    PRET_ABONAMENT NUMBER(4) NOT NULL,   -- Prețul abonamentului
    DURATA NUMBER(4) NOT NULL            -- Durata abonamentului (în luni)
);

-- Adăugarea cheii primare pentru tabelul P_ABONAMENTE
ALTER TABLE P_ABONAMENTE
ADD PRIMARY KEY(ID_ABONAMENT);

-- Adăugarea constrângerilor de integritate pentru tabelul P_CLIENTI
ALTER TABLE P_CLIENTI
ADD (
    CONSTRAINT Chk_val_TF_is_bool CHECK (TELEFON_FIX IN (0,1)),  -- Verifică dacă TELEFON_FIX este 0 sau 1
    PRIMARY KEY (ID_CLIENT),  -- Setează ID_CLIENT ca cheie primară
    CONSTRAINT FK_LocalitateClient FOREIGN KEY (ID_LOCALITATE_CLIENT) REFERENCES
    P_LOCALITATE(ID_LOCALITATE) ON DELETE CASCADE,  -- Creează o relație de cheie străină cu P_LOCALITATE
    CONSTRAINT FK_AbonamentClient FOREIGN KEY (ID_ABONAMENT_CLIENT) REFERENCES
    P_ABONAMENTE(ID_ABONAMENT)  -- Creează o relație de cheie străină cu P_ABONAMENTE
);

-- Crearea tabelei P_ANGAJATI (tabelul angajaților)
CREATE TABLE P_ANGAJATI(
    ID_ANGAJAT NUMBER(5) NOT NULL,      -- ID unic pentru angajat
    ID_MAGAZIN_ANGAJAT NUMBER(4),       -- ID-ul magazinului în care lucrează angajatul
    NUME VARCHAR2(30) NOT NULL,         -- Numele angajatului
    DEN_FCT VARCHAR2(30) NOT NULL,      -- Denumirea funcției angajatului
    EMAIL VARCHAR2(40) NOT NULL,        -- Emailul angajatului
    TELEFON VARCHAR2(30) NOT NULL,      -- Telefonul angajatului
    ID_MANAGER NUMBER(5)                -- ID-ul managerului
);

-- Adăugarea constrângerilor de integritate pentru tabelul P_ANGAJATI
ALTER TABLE P_ANGAJATI
ADD (
    PRIMARY KEY(ID_ANGAJAT),  -- Setează ID_ANGAJAT ca cheie primară
    CONSTRAINT FK_MagazinAngajat FOREIGN KEY (ID_MAGAZIN_ANGAJAT) REFERENCES
    P_MAGAZIN (ID_MAGAZIN)  -- Creează o relație de cheie străină cu P_MAGAZIN
);

-- Crearea tabelei P_PRODUSE (tabelul produselor)
CREATE TABLE P_PRODUSE(
    ID_PRODUS NUMBER(10) NOT NULL,      -- ID unic pentru produs
    NUME_PRODUS VARCHAR2(40) NOT NULL,  -- Numele produsului
    PRET NUMBER(10) NOT NULL ,          -- Prețul produsului
    CANTITATE_ACHIZITIONATA NUMBER(5)   -- Cantitatea achiziționată de produs
);

-- Adăugarea cheii primare pentru tabelul P_PRODUSE
ALTER TABLE P_PRODUSE
ADD PRIMARY KEY(ID_PRODUS);

-- Crearea tabelei P_STOC (tabelul stocurilor)
CREATE TABLE P_STOC(
    ID_MAGAZIN NUMBER(4),               -- ID-ul magazinului
    ID_PRODUS NUMBER(4),                -- ID-ul produsului
    CANTITATE_MAGAZIN NUMBER(4)         -- Cantitatea de produs disponibilă în magazin
);

-- Adăugarea constrângerilor de integritate pentru tabelul P_STOC
ALTER TABLE P_STOC
ADD (
    CONSTRAINT FK_MagazinStoc FOREIGN KEY (ID_MAGAZIN) REFERENCES
    P_MAGAZIN(ID_MAGAZIN) ON DELETE CASCADE,  -- Creează o relație de cheie străină cu P_MAGAZIN
    CONSTRAINT FK_ProdusStoc FOREIGN KEY (ID_PRODUS) REFERENCES
    P_PRODUSE(ID_PRODUS) ON DELETE CASCADE  -- Creează o relație de cheie străină cu P_PRODUSE
);

-- Crearea tabelei P_TELEFON_FIX (tabelul telefoanelor fixe)
CREATE TABLE P_TELEFON_FIX(
    IP_TELEFON VARCHAR2(16) NOT NULL,      -- IP-ul telefonului fix
    NUMAR_FIX VARCHAR2(11) NOT NULL,       -- Numărul telefonului fix
    ID_CLIENT_TF NUMBER(6) NOT NULL        -- ID-ul clientului asociat
);

-- Adăugarea constrângerilor de integritate pentru tabelul P_TELEFON_FIX
ALTER TABLE P_TELEFON_FIX
ADD(
    PRIMARY KEY(IP_TELEFON),  -- Setează IP_TELEFON ca cheie primară
    CONSTRAINT FK_id_client_TF FOREIGN KEY (ID_CLIENT_TF) REFERENCES
    P_CLIENTI(ID_CLIENT) ON DELETE CASCADE  -- Creează o relație de cheie străină cu P_CLIENTI
);

-- Crearea tabelei P_NUMAR (tabelul numerelor de telefon)
CREATE TABLE P_NUMAR(
    NUMAR_TELEFON VARCHAR2(11),    -- Numărul de telefon
    ID_CLIENT_ASOCIAT NUMBER(6)    -- ID-ul clientului asociat
);

-- Adăugarea constrângerilor de integritate pentru tabelul P_NUMAR
ALTER TABLE P_NUMAR
ADD(
    PRIMARY KEY (NUMAR_TELEFON),  -- Setează NUMAR_TELEFON ca cheie primară
    CONSTRAINT FK_NumarClient FOREIGN KEY (ID_CLIENT_ASOCIAT) REFERENCES
    P_CLIENTI(ID_CLIENT) ON DELETE CASCADE  -- Creează o relație de cheie străină cu P_CLIENTI 
); 
-- Crearea tabelei P_ISTORIC_APELURI_CLIENTI (tabelul istoricului apelurilor clienților)
CREATE TABLE P_ISTORIC_APELURI_CLIENTI(
    ID_APEL NUMBER(6) NOT NULL,                -- ID unic pentru apel
    DURATA_APEL NUMBER(3),                     -- Durata apelului (în secunde)
    NUMAR_TELEFON_APELANT VARCHAR2(11),        -- Numărul de telefon al apelantului
    NUMAR_TELEFON_DESTINATIE VARCHAR2(11),     -- Numărul de telefon al destinatarului
    DATA_APEL DATE                              -- Data apelului
);

-- Adăugarea constrângerilor de integritate pentru tabelul P_ISTORIC_APELURI_CLIENTI
ALTER TABLE P_ISTORIC_APELURI_CLIENTI
ADD(
    PRIMARY KEY (ID_APEL),  -- Setează ID_APEL ca cheie primară
    CONSTRAINT FK_NumarApelant FOREIGN KEY (NUMAR_TELEFON_APELANT) REFERENCES
    P_NUMAR(NUMAR_TELEFON),  -- Creează o relație de cheie străină cu P_NUMAR pentru apelant
    CONSTRAINT FK_NumarDestinatie FOREIGN KEY (NUMAR_TELEFON_DESTINATIE) REFERENCES
    P_NUMAR(NUMAR_TELEFON)  -- Creează o relație de cheie străină cu P_NUMAR pentru destinatar
);

-- Crearea tabelei P_CARTELA (tabelul cartelor SIM)
CREATE TABLE P_CARTELA(
    ICCID NUMBER(10),                        -- ID unic al cartelei (ICCID)
    NUMAR_TELEFON_CARTELA VARCHAR2(11) UNIQUE -- Numărul de telefon al cartelei
);

-- Adăugarea constrângerilor de integritate pentru tabelul P_CARTELA
ALTER TABLE P_CARTELA
ADD(
    PRIMARY KEY (ICCID),  -- Setează ICCID ca cheie primară
    CONSTRAINT FK_NumarTelefonCartela FOREIGN KEY (NUMAR_TELEFON_CARTELA) REFERENCES
    P_NUMAR(NUMAR_TELEFON)  -- Creează o relație de cheie străină cu P_NUMAR
);

-- Crearea tabelei P_TELEFOANE_CONECTATE (tabelul telefoanelor conectate)
CREATE TABLE P_TELEFOANE_CONECTATE(
    IMEI NUMBER(15) NOT NULL,              -- IMEI-ul telefonului
    NUME_DISPOZITIV VARCHAR2(20) NOT NULL,  -- Numele dispozitivului (telefon)
    MODEL VARCHAR2(20) NOT NULL,            -- Modelul dispozitivului
    BLACKLIST NUMBER(1) NOT NULL            -- Indică dacă telefonul este pe lista neagră (0 = nu, 1 = da)
);

-- Adăugarea constrângerilor de integritate pentru tabelul P_TELEFOANE_CONECTATE
ALTER TABLE P_TELEFOANE_CONECTATE
ADD(
    PRIMARY KEY(IMEI),  -- Setează IMEI ca cheie primară
    CONSTRAINT Chk_val_blacklist_is_bool CHECK(BLACKLIST IN (0, 1))  -- Verifică dacă BLACKLIST este 0 sau 1
);

-- Crearea tabelei P_CARTELE_CONECTATE (tabelul cartelor conectate)
CREATE TABLE P_CARTELE_CONECTATE(
    ID_CONEXIUNE NUMBER(6) NOT NULL,           -- ID unic pentru conexiune
    IMEI_TELEFON_ASOCIAT NUMBER(15),           -- IMEI-ul telefonului asociat
    ICCID_CARTELA_CONECTATA NUMBER(10)         -- ICCID-ul cartelei conectate
);

-- Adăugarea constrângerilor de integritate pentru tabelul P_CARTELE_CONECTATE
ALTER TABLE P_CARTELE_CONECTATE
ADD (
    PRIMARY KEY(ID_CONEXIUNE),  -- Setează ID_CONEXIUNE ca cheie primară
    CONSTRAINT FK_IMEI_asociat FOREIGN KEY (IMEI_TELEFON_ASOCIAT) REFERENCES
    P_TELEFOANE_CONECTATE(IMEI),  -- Creează o relație de cheie străină cu P_TELEFOANE_CONECTATE
    CONSTRAINT FK_ICCID_asociat FOREIGN KEY (ICCID_CARTELA_CONECTATA) REFERENCES
    P_CARTELA(ICCID)  -- Creează o relație de cheie străină cu P_CARTELA
);

-- P_LOCALITATE
INSERT INTO P_LOCALITATE VALUES (100001, 'Cluj-Napoca', 'Cluj', 'Transilvania', 1);
INSERT INTO P_LOCALITATE VALUES (100002, 'Bucuresti', 'București', 'București-Ilfov', 1);
INSERT INTO P_LOCALITATE VALUES (100003, 'Iasi', 'Iași', 'Moldova', 1);
INSERT INTO P_LOCALITATE VALUES (100004, 'Constanta', 'Constanța', 'Dobrogea', 1);
INSERT INTO P_LOCALITATE VALUES (100005, 'Timisoara', 'Timiș', 'Banat', 1);
INSERT INTO P_LOCALITATE VALUES (100006, 'Oradea', 'Bihor', 'Crișana', 1);
INSERT INTO P_LOCALITATE VALUES (100007, 'Brasov', 'Brașov', 'Transilvania', 1);
INSERT INTO P_LOCALITATE VALUES (100008, 'Craiova', 'Dolj', 'Oltenia', 1);
INSERT INTO P_LOCALITATE VALUES (100009, 'Suceava', 'Suceava', 'Moldova', 0);
INSERT INTO P_LOCALITATE VALUES (100010, 'Sibiu', 'Sibiu', 'Transilvania', 1);

 
-- P_MAGAZIN
INSERT INTO P_MAGAZIN VALUES (2001, 100001);
INSERT INTO P_MAGAZIN VALUES (2002, 100002);
INSERT INTO P_MAGAZIN VALUES (2003, 100003);
INSERT INTO P_MAGAZIN VALUES (2004, 100004);
INSERT INTO P_MAGAZIN VALUES (2005, 100005);
INSERT INTO P_MAGAZIN VALUES (2006, 100006);
INSERT INTO P_MAGAZIN VALUES (2007, 100007);
INSERT INTO P_MAGAZIN VALUES (2008, 100008);
INSERT INTO P_MAGAZIN VALUES (2009, 100009);
INSERT INTO P_MAGAZIN VALUES (2010, 100010); 
INSERT INTO P_MAGAZIN VALUES (2011, 100010);
INSERT INTO P_MAGAZIN VALUES (2012, 100010);
 
-- P_ANTENA
INSERT INTO P_ANTENA VALUES (3001, '47.05,23.57', 120.50, 100001);
INSERT INTO P_ANTENA VALUES (3002, '44.43,26.10', 150.00, 100002);
INSERT INTO P_ANTENA VALUES (3003, '47.16,27.57', 110.20, 100003);
INSERT INTO P_ANTENA VALUES (3004, '44.17,28.63', 95.40, 100004);
INSERT INTO P_ANTENA VALUES (3005, '45.75,21.23', 80.10, 100005);
INSERT INTO P_ANTENA VALUES (3006, '46.77,23.61', 140.25, 100006);
INSERT INTO P_ANTENA VALUES (3007, '45.66,25.61', 170.00, 100007);
INSERT INTO P_ANTENA VALUES (3008, '44.33,23.80', 120.35, 100008);
INSERT INTO P_ANTENA VALUES (3009, '47.64,26.25', 110.10, 100009);
INSERT INTO P_ANTENA VALUES (3010, '45.80,24.15', 125.75, 100010);
 -- P_ABONAMENTE
INSERT INTO P_ABONAMENTE VALUES (5001, 'Standard', 50, 12);
INSERT INTO P_ABONAMENTE VALUES (5002, 'Premium', 100, 12);
INSERT INTO P_ABONAMENTE VALUES (5003, 'Family', 75, 24);
INSERT INTO P_ABONAMENTE VALUES (5004, 'Business', 120, 12);
INSERT INTO P_ABONAMENTE VALUES (5005, 'Student', 30, 12);
INSERT INTO P_ABONAMENTE VALUES (5006, 'Unlimited', 200, 24);
INSERT INTO P_ABONAMENTE VALUES (5007, 'Prepaid', 0, 1);
INSERT INTO P_ABONAMENTE VALUES (5008, 'Economy', 40, 12);
INSERT INTO P_ABONAMENTE VALUES (5009, 'Pro', 150, 24);
INSERT INTO P_ABONAMENTE VALUES (5010, 'Lite', 20, 6); 


 
-- P_CLIENTI
INSERT INTO P_CLIENTI VALUES (400001, 'Ion Popescu', 100001, 291020212345, 'ion.popescu@gmail.com', 1, 5001, TO_DATE('1990-01-01', 'YYYY-MM-DD'), TO_DATE('2023-01-01', 'YYYY-MM-DD'));
INSERT INTO P_CLIENTI VALUES (400002, 'Maria Ionescu', 100002, 2910202123456, 'maria.ionescu@gmail.com', 0, 5002, TO_DATE('1995-06-15', 'YYYY-MM-DD'), TO_DATE('2023-06-01', 'YYYY-MM-DD'));
INSERT INTO P_CLIENTI VALUES (400003, 'Andrei Georgescu', 100003, 1800505123456, 'andrei.georgescu@gmail.com', 1, 5003, TO_DATE('1980-05-05', 'YYYY-MM-DD'), TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO P_CLIENTI VALUES (400004, 'Ana Popa', 100004, 2750308123456, 'ana.popa@gmail.com', 0, 5004, TO_DATE('1975-03-08', 'YYYY-MM-DD'), TO_DATE('2025-01-01', 'YYYY-MM-DD'));
INSERT INTO P_CLIENTI VALUES (400005, 'Mihai Dumitru', 100005, 1800105123456, 'mihai.dumitru@gmail.com', 1, 5005, TO_DATE('1980-01-05', 'YYYY-MM-DD'), TO_DATE('2022-01-01', 'YYYY-MM-DD'));
INSERT INTO P_CLIENTI VALUES (400006, 'Elena Radu', 100006, 1850722123456, 'elena.radu@gmail.com', 0, 5006, TO_DATE('1985-07-22', 'YYYY-MM-DD'), TO_DATE('2023-03-01', 'YYYY-MM-DD'));
INSERT INTO P_CLIENTI VALUES (400007, 'Vasile Dobre', 100007, 1951223123456, 'vasile.dobre@gmail.com', 1, 5007, TO_DATE('1995-12-23', 'YYYY-MM-DD'), TO_DATE('2024-05-01', 'YYYY-MM-DD'));
INSERT INTO P_CLIENTI VALUES (400008, 'Gabriela Tudor', 100008, 1880901123456, 'gabriela.tudor@gmail.com', 0, 5008, TO_DATE('1988-09-01', 'YYYY-MM-DD'), TO_DATE('2023-12-01', 'YYYY-MM-DD'));
INSERT INTO P_CLIENTI VALUES (400009, 'Radu Stanciu', 100009, 1980315123456, 'radu.stanciu@gmail.com', 1, 5009, TO_DATE('1998-03-15', 'YYYY-MM-DD'), TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO P_CLIENTI VALUES (400010, 'Ioana Marinescu', 100010, 2000222123456, 'ioana.marinescu@gmail.com', 0, 5010, TO_DATE('2000-02-22', 'YYYY-MM-DD'), TO_DATE('2023-01-01', 'YYYY-MM-DD'));
 

-- P_PRODUSE
INSERT INTO P_PRODUSE VALUES (1, 'iPhone 14 Pro Max', 6799, 50);
INSERT INTO P_PRODUSE VALUES (2, 'Samsung Galaxy S23 Ultra', 5999, 40);
INSERT INTO P_PRODUSE VALUES (3, 'Google Pixel 8 Pro', 4999, 30);
INSERT INTO P_PRODUSE VALUES (4, 'OnePlus 11', 3699, 25);
INSERT INTO P_PRODUSE VALUES (5, 'Xiaomi 13 Pro', 3299, 20);
INSERT INTO P_PRODUSE VALUES (6, 'Sony Xperia 1 V', 5499, 15);
INSERT INTO P_PRODUSE VALUES (7, 'Huawei P60 Pro', 4899, 35);
INSERT INTO P_PRODUSE VALUES (8, 'Asus ROG Phone 7', 4599, 10);
INSERT INTO P_PRODUSE VALUES (9, 'Oppo Find X6 Pro', 4199, 28);
INSERT INTO P_PRODUSE VALUES (10, 'Motorola Edge 40 Pro', 3799, 18);
INSERT INTO P_PRODUSE VALUES (11, 'Realme GT 3', 3499, 12);
INSERT INTO P_PRODUSE VALUES (12, 'Vivo X90 Pro', 3999, 22);
INSERT INTO P_PRODUSE VALUES (13, 'Nokia X30', 2299, 40);
INSERT INTO P_PRODUSE VALUES (14, 'Samsung Galaxy Z Fold 5', 8699, 5);
INSERT INTO P_PRODUSE VALUES (15, 'iPhone SE (2022)', 2899, 60);






 
-- P_ANGAJATI
INSERT INTO P_ANGAJATI VALUES (70001, 2001, 'Ion Popescu', 'General Manager', 'ion.popescu@company.com', '0720123456', NULL);
INSERT INTO P_ANGAJATI VALUES (70002, 2002, 'Maria Ionescu', 'Regional Manager', 'maria.ionescu@company.com', '0721123456', 70001);
INSERT INTO P_ANGAJATI VALUES (70003, 2003, 'Vasile Mihai', 'Regional Manager', 'vasile.mihai@company.com', '0722123456', 70001);
INSERT INTO P_ANGAJATI VALUES (70004, 2004, 'Andreea Georgescu', 'Store Manager', 'andreea.georgescu@company.com', '0723123456', 70002);
INSERT INTO P_ANGAJATI VALUES (70005, 2005, 'Cristina Radu', 'Consultant', 'cristina.radu@company.com', '0724123456', 70004);
INSERT INTO P_ANGAJATI VALUES (70006, 2006, 'Darius Neagu', 'Sales', 'darius.neagu@company.com', '0725123456', 70004);

INSERT INTO P_ANGAJATI VALUES (70007, 2007, 'Oana Pavel', 'Store Manager', 'oana.pavel@company.com', '0726123456', 70003);
INSERT INTO P_ANGAJATI VALUES (70008, 2008, 'Bogdan Ilie', 'Consultant', 'bogdan.ilie@company.com', '0727123456', 70007);
INSERT INTO P_ANGAJATI VALUES (70009, 2009, 'Mihai Dumitrescu', 'Sales', 'mihai.dumitrescu@company.com', '0728123456', 70007);
INSERT INTO P_ANGAJATI VALUES (70010, 2010, 'Alexandra Stan', 'Regional Manager', 'alexandra.stan@company.com', '0729123456', 70001);
INSERT INTO P_ANGAJATI VALUES (70011, 2011, 'Daniel Luca', 'Store Manager', 'daniel.luca@company.com', '0729923456', 70010);
INSERT INTO P_ANGAJATI VALUES (70012, 2012, 'Cirimpei Luca', 'Consultant', 'elena.marin@company.com', '0730123456', 70011);

 


-- P_STOC
INSERT INTO P_STOC VALUES (2001, 1, 20);
INSERT INTO P_STOC VALUES (2001, 2, 15);
INSERT INTO P_STOC VALUES (2002, 3, 10);
INSERT INTO P_STOC VALUES (2002, 4, 5);
INSERT INTO P_STOC VALUES (2003, 5, 25);
INSERT INTO P_STOC VALUES (2003, 6, 18);
INSERT INTO P_STOC VALUES (2004, 7, 30);
INSERT INTO P_STOC VALUES (2004, 8, 8);
INSERT INTO P_STOC VALUES (2005, 9, 50);
INSERT INTO P_STOC VALUES (2005, 10, 12);
INSERT INTO P_STOC VALUES (2006, 11, 35);
INSERT INTO P_STOC VALUES (2006, 12, 22);
INSERT INTO P_STOC VALUES (2007, 13, 7);
INSERT INTO P_STOC VALUES (2007, 14, 3);
INSERT INTO P_STOC VALUES (2008, 15, 40); 






 
-- P_TELEFON_FIX
INSERT INTO P_TELEFON_FIX VALUES ('192.168.1.1', '0212345678', 400001);
INSERT INTO P_TELEFON_FIX VALUES ('192.168.1.2', '0212345679', 400002);
INSERT INTO P_TELEFON_FIX VALUES ('192.168.1.3', '0212345680', 400003);
INSERT INTO P_TELEFON_FIX VALUES ('192.168.1.4', '0212345681', 400004);
INSERT INTO P_TELEFON_FIX VALUES ('192.168.1.5', '0212345682', 400005);
INSERT INTO P_TELEFON_FIX VALUES ('192.168.1.6', '0212345683', 400006);
INSERT INTO P_TELEFON_FIX VALUES ('192.168.1.7', '0212345684', 400007);
INSERT INTO P_TELEFON_FIX VALUES ('192.168.1.8', '0212345685', 400008);
INSERT INTO P_TELEFON_FIX VALUES ('192.168.1.9', '0212345686', 400009);
INSERT INTO P_TELEFON_FIX VALUES ('192.168.1.10', '0212345687', 400010); 

 
-- P_NUMAR 
INSERT INTO P_NUMAR VALUES ('0720123456', 400001);
INSERT INTO P_NUMAR VALUES ('0721123457', 400002);
INSERT INTO P_NUMAR VALUES ('0722123458', 400003);
INSERT INTO P_NUMAR VALUES ('0723123459', 400004);
INSERT INTO P_NUMAR VALUES ('0724123460', 400005);
INSERT INTO P_NUMAR VALUES ('0725123461', 400006);
INSERT INTO P_NUMAR VALUES ('0726123462', 400007);
INSERT INTO P_NUMAR VALUES ('0727123463', 400008);
INSERT INTO P_NUMAR VALUES ('0728123464', 400009);
INSERT INTO P_NUMAR VALUES ('0729123465', 400010); 

 
--P_ISTORIC_APELURI_CLIENTI
INSERT INTO P_ISTORIC_APELURI_CLIENTI VALUES (900001, 5, '0720123456', '0721123457', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO P_ISTORIC_APELURI_CLIENTI VALUES (900002, 3, '0721123457', '0722123458', TO_DATE('2024-01-02', 'YYYY-MM-DD'));
INSERT INTO P_ISTORIC_APELURI_CLIENTI VALUES (900003, 10, '0722123458', '0723123459', TO_DATE('2024-01-03', 'YYYY-MM-DD'));
INSERT INTO P_ISTORIC_APELURI_CLIENTI VALUES (900004, 2, '0723123459', '0724123460', TO_DATE('2024-01-04', 'YYYY-MM-DD'));
INSERT INTO P_ISTORIC_APELURI_CLIENTI VALUES (900005, 7, '0724123460', '0725123461', TO_DATE('2024-01-05', 'YYYY-MM-DD'));
INSERT INTO P_ISTORIC_APELURI_CLIENTI VALUES (900006, 4, '0725123461', '0726123462', TO_DATE('2024-01-06', 'YYYY-MM-DD'));
INSERT INTO P_ISTORIC_APELURI_CLIENTI VALUES (900007, 6, '0726123462', '0727123463', TO_DATE('2024-01-07', 'YYYY-MM-DD'));
INSERT INTO P_ISTORIC_APELURI_CLIENTI VALUES (900008, 8, '0727123463', '0728123464', TO_DATE('2024-01-08', 'YYYY-MM-DD'));
INSERT INTO P_ISTORIC_APELURI_CLIENTI VALUES (900009, 12, '0728123464', '0729123465', TO_DATE('2024-01-09', 'YYYY-MM-DD'));
INSERT INTO P_ISTORIC_APELURI_CLIENTI VALUES (900010, 15, '0729123465', '0720123456', TO_DATE('2024-01-10', 'YYYY-MM-DD')); 

 






--P_CARTELA 
INSERT INTO P_CARTELA VALUES (300001, '0720123456');
INSERT INTO P_CARTELA VALUES (300002, '0721123457');
INSERT INTO P_CARTELA VALUES (300003, '0722123458');
INSERT INTO P_CARTELA VALUES (300004, '0723123459');
INSERT INTO P_CARTELA VALUES (300005, '0724123460');
INSERT INTO P_CARTELA VALUES (300006, '0725123461');
INSERT INTO P_CARTELA VALUES (300007, '0726123462');
INSERT INTO P_CARTELA VALUES (300008, '0727123463');
INSERT INTO P_CARTELA VALUES (300009, '0728123464');
INSERT INTO P_CARTELA VALUES (300010, '0729123465'); 

 
--P_TELEFOANE_CONECTATE 
INSERT INTO P_TELEFOANE_CONECTATE VALUES (100000000000001, 'iPhone 14', 'Pro Max', 0);
INSERT INTO P_TELEFOANE_CONECTATE VALUES (100000000000002, 'Samsung Galaxy', 'S23 Ultra', 0);
INSERT INTO P_TELEFOANE_CONECTATE VALUES (100000000000003, 'Google Pixel', '7 Pro', 0);
INSERT INTO P_TELEFOANE_CONECTATE VALUES (100000000000004, 'OnePlus', '11', 0);
INSERT INTO P_TELEFOANE_CONECTATE VALUES (100000000000005, 'Xiaomi', 'Mi 13 Pro', 0);
INSERT INTO P_TELEFOANE_CONECTATE VALUES (100000000000006, 'Huawei', 'P60 Pro', 1);
INSERT INTO P_TELEFOANE_CONECTATE VALUES (100000000000007, 'Sony Xperia', '5 IV', 0);
INSERT INTO P_TELEFOANE_CONECTATE VALUES (100000000000008, 'Nokia', 'G50', 0);
INSERT INTO P_TELEFOANE_CONECTATE VALUES (100000000000009, 'Motorola', 'Edge 30', 0);
INSERT INTO P_TELEFOANE_CONECTATE VALUES (100000000000010, 'Asus ROG', 'Phone 7', 0); 




 
--P_CARTELE_CONECTATE 
INSERT INTO P_CARTELE_CONECTATE VALUES (800001, 100000000000001, 300001);
INSERT INTO P_CARTELE_CONECTATE VALUES (800002, 100000000000002, 300002);
INSERT INTO P_CARTELE_CONECTATE VALUES (800003, 100000000000003, 300003);
INSERT INTO P_CARTELE_CONECTATE VALUES (800004, 100000000000004, 300004);
INSERT INTO P_CARTELE_CONECTATE VALUES (800005, 100000000000005, 300005);
INSERT INTO P_CARTELE_CONECTATE VALUES (800006, 100000000000006, 300006);
INSERT INTO P_CARTELE_CONECTATE VALUES (800007, 100000000000007, 300007);
INSERT INTO P_CARTELE_CONECTATE VALUES (800008, 100000000000008, 300008);
INSERT INTO P_CARTELE_CONECTATE VALUES (800009, 100000000000009, 300009);
INSERT INTO P_CARTELE_CONECTATE VALUES (800010, 100000000000010, 300010); 
 

--Interogarile de mai jos sunt utilizate pentru un set de exercitii 
/*
--Selecteaza numele meu
SELECT *
FROM P_ANGAJATI
WHERE UPPER(NUME) = 'CIRIMPEI LUCA';


-- Actualizează adresa de e-mail a unui client
UPDATE P_CLIENTI 
SET EMAIL = 'ion.pop@gmail.com'
WHERE ID_CLIENT = 400001;

-- Actualizează cantitatea de stoc a unui produs
UPDATE P_PRODUSE 
SET CANTITATE_ACHIZITIONATA = 120 
WHERE ID_PRODUS = 1;

-- Actualizează localitatea asociată unui magazin
UPDATE P_MAGAZIN 
SET ID_LOCALITATE_MAGAZIN = 100003 
WHERE ID_MAGAZIN = 2002; 

-- Șterge stocul magazinului cu id-ul 2001
DELETE FROM P_STOC
WHERE ID_MAGAZIN = 2001;

-- Sterge apelul cu id-ul 900001 din istoricul apelurilor
DELETE FROM p_istoric_apeluri_clienti
WHERE ID_APEL = 900001;

-- Șterge o înregistrare a unei antene
DELETE FROM P_ANTENA 
WHERE ID_ANTENA = 3009;


-- 1. Selectează abonamentele cu preț între 0 și 100 și cu ID_ABONAMENT dintre 5003, 5005, 5007.
SELECT * 
FROM P_ABONAMENTE 
WHERE PRET_ABONAMENT BETWEEN 0 AND 100 
AND ID_ABONAMENT IN (5003, 5005, 5007);

-- 2. Selectează apelurile care au durată mai mare sau egală cu 5 și data apelului nu este 05-01-2024.
SELECT * 
FROM P_ISTORIC_APELURI_CLIENTI 
WHERE DURATA_APEL >= 5 
AND DATA_APEL != TO_DATE('05-01-2024', 'DD-MM-YYYY'); 

 

-- 3. Selectează angajații care nu au un manager (ID_MANAGER este NULL).
SELECT * 
FROM P_ANGAJATI 
WHERE ID_MANAGER IS NULL; 

-- 4. Selectează magazinul și numărul de produse din stoc (care au cantitate >= 5) pentru magazinele cu ID <= 2005.
-- Se grupează pe ID_MAGAZIN și se filtrează magazinele care au exact 2 produse în stoc.
SELECT ID_MAGAZIN, COUNT(ID_PRODUS) 
FROM P_STOC 
WHERE CANTITATE_MAGAZIN >= 5 
AND ID_MAGAZIN <= 2005
GROUP BY ID_MAGAZIN 
HAVING COUNT(ID_PRODUS) = 2; 

 

-- 5. Selectează abonamentele cu preț mai mic decât oricare dintre valorile (50, 70, 80) și durata mai mare decât toate valorile (5, 10, 15).
SELECT * 
FROM P_ABONAMENTE 
WHERE PRET_ABONAMENT < ANY (50, 70, 80) 
AND DURATA > ALL (5, 10, 15); 

-- 6. JOIN între P_ABONAMENTE și P_CLIENTI folosind un RIGHT OUTER JOIN.
-- Se selectează clienții care au abonamente cu prețul 0 sau 100 și telefonul fix este 0 (adică nu au telefon fix).
SELECT C.ID_CLIENT, C.NUME, C.ID_ABONAMENT_CLIENT, A.ID_ABONAMENT
FROM P_ABONAMENTE A RIGHT OUTER JOIN P_CLIENTI C 
ON A.ID_ABONAMENT = C.ID_ABONAMENT_CLIENT
WHERE A.PRET_ABONAMENT IN (0, 100) AND C.TELEFON_FIX = 0; 


 

-- 7. JOIN între P_ABONAMENTE și P_CLIENTI folosind un LEFT OUTER JOIN.
-- Se selectează clienții care au abonamente cu durata între 10 și 24 luni.
SELECT C.ID_CLIENT, C.NUME, C.ID_ABONAMENT_CLIENT, A.ID_ABONAMENT
FROM P_ABONAMENTE A LEFT OUTER JOIN P_CLIENTI C 
ON A.ID_ABONAMENT = C.ID_ABONAMENT_CLIENT 
WHERE A.DURATA BETWEEN 10 AND 24;

 

-- 8. FULL OUTER JOIN între P_ABONAMENTE și P_CLIENTI.
-- Se selectează clienții cu CNP care începe cu 2 și care s-au înregistrat în aceeași lună ca și luna curentă.
SELECT C.ID_CLIENT, C.NUME, C.ID_ABONAMENT_CLIENT, C.DATA_INREGISTRARII, A.ID_ABONAMENT
FROM P_ABONAMENTE A FULL OUTER JOIN P_CLIENTI C 
ON A.ID_ABONAMENT = C.ID_ABONAMENT_CLIENT 
WHERE SUBSTR(TO_CHAR(C.CNP), 1, 1) = '2' 
AND EXTRACT(MONTH FROM SYSDATE) = EXTRACT(MONTH FROM C.DATA_INREGISTRARII);

-- 9. INNER JOIN între P_ABONAMENTE și P_CLIENTI.
-- Se selectează clienții care s-au înregistrat în luna ianuarie.
SELECT C.ID_CLIENT, C.NUME, C.ID_ABONAMENT_CLIENT, TO_CHAR(C.DATA_INREGISTRARII, 'DD MONTH YYYY') AS "DATA INREGISTRARII", A.ID_ABONAMENT
FROM P_ABONAMENTE A INNER JOIN  P_CLIENTI C 
ON A.ID_ABONAMENT = C.ID_ABONAMENT_CLIENT
WHERE EXTRACT(MONTH FROM C.DATA_INREGISTRARII) = 1; 


 


-- 10. SELECT cu un CASE pentru a aplica reduceri de fidelitate în funcție de anul înregistrării clientului.
SELECT ID_CLIENT, NUME, 
CASE 
    WHEN EXTRACT(YEAR FROM DATA_INREGISTRARII) = 2023 THEN 0.2 
    WHEN EXTRACT(YEAR FROM DATA_INREGISTRARII) = 2024 THEN 0.1 
    ELSE NULL 
END AS REDUCERE_FIDELITATE 
FROM P_CLIENTI; 
 





-- 11. DECODE pentru a oferi valoarea SUMA_INVESTITII în funcție de oraș (NUME).
SELECT NUME, 
DECODE(UPPER(NUME), 'CLUJ-NAPOCA', 100000, 
                    'BUCURESTI', 1000000,
                    'TIMISOARA', 10000, 
                    1000) AS SUMA_INVESTITII 
FROM P_LOCALITATE; 

-- 12. UNION între P_CLIENTI și P_ANGAJATI pentru a obține numele și emailurile.
-- Din P_CLIENTI se selectează cei cu numele ce începe cu A și din P_ANGAJATI cei cu numele ce începe cu C.
-- Rezultatul este ordonat după NUME.
SELECT NUME, EMAIL 
FROM P_CLIENTI 
WHERE SUBSTR(NUME, 1, 1) = 'A' 
UNION 
SELECT NUME, EMAIL 
FROM P_ANGAJATI
WHERE SUBSTR(NUME, 1, 1) = 'C' 
ORDER BY NUME; 
 

-- 13. MINUS între P_CLIENTI și P_ANGAJATI pentru a selecta clienții născuți după 1990, dar care nu sunt angajați.
SELECT NUME, EMAIL 
FROM P_CLIENTI 
WHERE EXTRACT(YEAR FROM DATA_NASTERII) >= 1990 
MINUS 
SELECT NUME, EMAIL 
FROM P_ANGAJATI 
ORDER BY NUME; 

-- 14. INTERSECT între P_CLIENTI și P_ANGAJATI pentru a obține numele și emailurile celor care au CNP ce începe cu 1 și telefon fix = 1.
SELECT NUME, EMAIL 
FROM P_CLIENTI 
WHERE SUBSTR(TO_CHAR(CNP), 1, 1) = '1' AND TELEFON_FIX = 1
INTERSECT 
SELECT NUME, EMAIL 
FROM P_ANGAJATI;
 






-- 15. SELECT cu un CASE pentru a verifica dacă un angajat are manager.
-- Folosind NVL, se verifică dacă ID_MANAGER este NULL (adică nu are manager), iar în cazul în care nu este NULL se afișează 'ARE MANAGER'.
SELECT ID_ANGAJAT, NUME, EMAIL,
CASE  
    WHEN NVL(ID_MANAGER, 1) != 1 THEN 'ARE MANAGER' 
    ELSE 'NU ARE MANAGER' 
END AS ARE_MANAGER
FROM P_ANGAJATI; 
 
                          
-- Prima interogare: Selectează antenele unde aria deservită este mai mare decât media tuturor antenelor
SELECT ID_ANTENA, LOCATIE_GPS_ANTENA, ARIE_DESERVITA
FROM P_ANTENA
WHERE ARIE_DESERVITA > 
    (SELECT AVG(ARIE_DESERVITA) FROM P_ANTENA); -- Subinterogare pentru calcularea mediei ariei deservite

-- A doua interogare: Selectează angajații într-o structură ierarhică, începând cu managerul fără manager
SELECT ID_ANGAJAT, NUME, LEVEL
FROM P_ANGAJATI 
START WITH NUME = (SELECT NUME FROM P_ANGAJATI WHERE ID_MANAGER IS NULL) -- Începe de la managerul de top (fără manager)
CONNECT BY PRIOR ID_ANGAJAT = ID_MANAGER  -- Definirea relației ierarhice dintre angajați și managerul lor
ORDER BY LEVEL; -- Ordonează rezultatele în funcție de nivelul ierarhic (rădăcina mai întâi, apoi copii etc.) 






 
-- A treia interogare: Selectează angajații într-o structură ierarhică care au aceeași funcție ca 'Alexandra Stan'
SELECT ID_ANGAJAT, NUME, LEVEL
FROM P_ANGAJATI 
START WITH ID_MANAGER IS NULL -- Începe de la managerul de top (fără manager)
CONNECT BY PRIOR ID_ANGAJAT = ID_MANAGER 
AND DEN_FCT = (SELECT DEN_FCT FROM P_ANGAJATI WHERE UPPER(NUME) = 'ALEXANDRA STAN') -- Filtrează angajații care au aceeași funcție cu 'Alexandra Stan'
ORDER BY LEVEL; -- Ordonează rezultatele în funcție de nivelul ierarhic

                          
-- A patra interogare: Selectează angajații care sunt la nivelul 3 într-o ierarhie,
-- începând de la angajatul care nu are manager (adică managerul superior al organizației).
SELECT ID_ANGAJAT, NUME, LEVEL
FROM P_ANGAJATI
WHERE LEVEL = 3  -- Filtrăm doar angajații cu nivelul 3
START WITH ID_ANGAJAT = (SELECT ID_ANGAJAT FROM P_ANGAJATI WHERE ID_MANAGER IS NULL)  -- Începem căutarea de la angajatul care nu are manager (adica cel mai sus din ierarhie)
CONNECT BY PRIOR ID_ANGAJAT = ID_MANAGER;  -- Parcurgem ierarhia folosind relația între angajat și manager 
 



-- A cincea interogare: Selectează angajații care sunt la nivelul 2 și au funcția de "Store Manager",
-- începând de la un angajat cu numele 'Maria Ionescu' și navigând ierarhia.
SELECT ID_ANGAJAT, NUME, LEVEL
FROM P_ANGAJATI
WHERE LEVEL = 2  -- Filtrăm doar angajații cu nivelul 2
AND UPPER(DEN_FCT) = 'STORE MANAGER'  -- Filtrăm doar angajații care au funcția 'Store Manager' (indiferent de majuscule/minuscule)
START WITH ID_ANGAJAT = (SELECT ID_ANGAJAT FROM P_ANGAJATI WHERE UPPER(NUME) = 'MARIA IONESCU')  -- Începem căutarea de la angajatul cu numele 'Maria Ionescu'
CONNECT BY PRIOR ID_ANGAJAT = ID_MANAGER;  -- Parcurgem ierarhia folosind relația între angajat și manager
*/

-- Crearea unui index pe coloana CNP din tabela P_CLIENTI
-- Acest index îmbunătățește performanța interogărilor care caută în mod frecvent în funcție de valoarea CNP a unui client.
CREATE INDEX IDX_P_CLIENTI_CNP ON P_CLIENTI(CNP);

-- Crearea unui index pe coloana ID_LOCALITATE_CLIENT din tabela P_CLIENTI
-- Acest index va îmbunătăți performanța interogărilor care implică căutarea în funcție de locația clientului, 
-- în special pentru a filtra sau conecta datele din tabela P_LOCALITATE.
CREATE INDEX IDX_P_CLIENTI_LOCALITATE ON P_CLIENTI(ID_LOCALITATE_CLIENT);

-- Crearea unui index pe coloanele IMEI și BLACKLIST din tabela P_TELEFOANE_CONECTATE
-- Indexul pe două coloane (composite index) îmbunătățește performanța interogărilor care caută telefoane 
-- cu un anumit IMEI și starea de blacklist asociată acestora.
CREATE INDEX IDX_P_TELEFOANE_BLACKSLIST ON P_TELEFOANE_CONECTATE(IMEI, BLACKLIST);

-- Crearea unui index pe coloanele NUMAR_TELEFON_APELANT și NUMAR_TELEFON_DESTINATIE din tabela P_ISTORIC_APELURI_CLIENTI
-- Acest index va accelera interogările care implică apeluri între două numere de telefon, 
-- fie pentru a căuta apelurile unui anumit apelant sau ale unui anumit destinatar.
CREATE INDEX IDX_P_ISTORIC_APELURI_DOUA_PERSOANE ON P_ISTORIC_APELURI_CLIENTI(NUMAR_TELEFON_APELANT, NUMAR_TELEFON_DESTINATIE);



 

-- Crează un view cu datele angajaților, combinând tabelele P_CLIENTI și P_LOCALITATE
-- Afișează ID-ul clientului, numele (ca NUME_ANGAJAT), CNP-ul și localitatea asociată.
CREATE VIEW P_DATE_ANGAJATI AS  
SELECT C.ID_CLIENT, C.NUME AS NUME_ANGAJAT, C.CNP, L.NUME, L.JUDET 
FROM P_LOCALITATE L INNER JOIN P_CLIENTI C 
ON L.ID_LOCALITATE = C.ID_LOCALITATE_CLIENT;

-- Crează un view cu date despre antene, combinând tabelele P_ANTENA și P_LOCALITATE
-- Afișează ID-ul antenei, aria deservită, locația GPS și localitatea asociată antenei.
CREATE VIEW P_DATE_ANTENA AS  
SELECT A.ID_ANTENA, A.ARIE_DESERVITA, A.LOCATIE_GPS_ANTENA, L.NUME AS LOCALITATE_ANTENA, L.JUDET
FROM P_LOCALITATE L INNER JOIN P_ANTENA A 
ON L.ID_LOCALITATE = A.ID_LOCALITATE_APROPIATA;

-- Crează un view cu date despre stocuri, combinând tabelele P_PRODUSE și P_STOC
-- Afișează ID-ul magazinului, ID-ul produsului, cantitatea în stoc și prețul per unitate.
CREATE VIEW P_DATE_STOC AS 
SELECT S.ID_MAGAZIN, S.ID_PRODUS, S.CANTITATE_MAGAZIN, P.PRET AS PRET_PER_UNITATE
FROM P_PRODUSE P JOIN P_STOC S 
ON P.ID_PRODUS = S.ID_PRODUS;
 



-- Sinonim pentru tabela P_LOCALITATE
CREATE SYNONYM SY_P_LOCALITATE FOR P_LOCALITATE;

-- Sinonim pentru tabela P_MAGAZIN
CREATE SYNONYM SY_P_MAGAZIN FOR P_MAGAZIN;

-- Sinonim pentru tabela P_ANTENA
CREATE SYNONYM SY_P_ANTENA FOR P_ANTENA;

-- Sinonim pentru tabela P_CLIENTI
CREATE SYNONYM SY_P_CLIENTI FOR P_CLIENTI;

-- Sinonim pentru tabela P_ABONAMENTE
CREATE SYNONYM SY_P_ABONAMENTE FOR P_ABONAMENTE;

-- Sinonim pentru tabela P_ANGAJATI
CREATE SYNONYM SY_P_ANGAJATI FOR P_ANGAJATI;

-- Sinonim pentru tabela P_PRODUSE
CREATE SYNONYM SY_P_PRODUSE FOR P_PRODUSE;

-- Sinonim pentru tabela P_STOC
CREATE SYNONYM SY_P_STOC FOR P_STOC;

-- Sinonim pentru tabela P_TELEFON_FIX
CREATE SYNONYM SY_P_TELEFON_FIX FOR P_TELEFON_FIX;

-- Sinonim pentru tabela P_NUMAR
CREATE SYNONYM SY_P_NUMAR FOR P_NUMAR;

-- Sinonim pentru tabela P_ISTORIC_APELURI_CLIENTI
CREATE SYNONYM SY_P_ISTORIC_APELURI_CLIENTI FOR P_ISTORIC_APELURI_CLIENTI;

-- Sinonim pentru tabela P_CARTELA
CREATE SYNONYM SY_P_CARTELA FOR P_CARTELA;

-- Sinonim pentru tabela P_TELEFOANE_CONECTATE
CREATE SYNONYM SY_P_TELEFOANE_CONECTATE FOR P_TELEFOANE_CONECTATE;

-- Sinonim pentru tabela P_CARTELE_CONECTATE
CREATE SYNONYM SY_P_CARTELE_CONECTATE FOR P_CARTELE_CONECTATE; 
 

CREATE SEQUENCE seq_localitate 
START WITH 100010
INCREMENT BY 1 
NOCYCLE 
CACHE 10; 

CREATE SEQUENCE seq_clienti 
START WITH 400017
INCREMENT BY 1 
NOCYCLE  
CACHE 50; 

CREATE SEQUENCE seq_istoric_apeluri_clienti 
START WITH 900011 
INCREMENT BY 1 
NOCYCLE 
CACHE 100;




 





