-- Crearea tabelei P_LOCALITATE
CREATE TABLE P_LOCALITATE(
    ID_LOCALITATE NUMBER(6) NOT NULL,   
    NUME VARCHAR2(20) NOT NULL,          
    JUDET VARCHAR2(20) NOT NULL,         
    REGIUNE VARCHAR2(20) NOT NULL,       
    ACOPERIRE NUMBER(1)                 
);

-- Adăugarea constrângerilor de integritate pentru tabelul P_LOCALITATE
ALTER TABLE P_LOCALITATE
ADD (
    CONSTRAINT Chk_val_acoperire_is_bool CHECK(ACOPERIRE IN (0, 1)),  
    CONSTRAINT Chk_judet CHECK(JUDET IN ('Alba', 'Arad', 'Argeș', 'Bacău', 'Bihor', 'Bistrița-Năsăud', 'Botoșani', 'Brașov', 'Brăila', 'București', 'Buzău', 'Caraș-Severin', 'Călărași', 'Cluj', 'Constanța', 'Covasna', 'Dâmbovița', 'Dolj', 'Galați', 'Giurgiu', 'Gorj', 'Harghita', 'Hunedoara', 'Ialomița', 'Iași', 'Ilfov', 'Maramureș', 'Mehedinți', 'Mureș', 'Neamț', 'Olt', 'Prahova', 'Sălaj', 'Satu Mare', 'Sibiu', 'Suceava', 'Teleorman', 'Timiș', 'Tulcea', 'Vâlcea', 'Vaslui', 'Vrancea')),
    CONSTRAINT Chk_regiune CHECK(REGIUNE IN ('Banat', 'București-Ilfov', 'Crișana', 'Dobrogea', 'Maramureș', 'Moldova', 'Muntenia', 'Oltenia', 'Transilvania')), 
    PRIMARY KEY (ID_LOCALITATE)  
);

-- Crearea tabelei P_MAGAZIN
CREATE TABLE P_MAGAZIN(
    ID_MAGAZIN NUMBER(4) NOT NULL,     
    ID_LOCALITATE_MAGAZIN NUMBER(6)    
);

-- Adăugarea constrângerilor de integritate pentru tabelul P_MAGAZIN
ALTER TABLE P_MAGAZIN
ADD (
    PRIMARY KEY (ID_MAGAZIN),  
    CONSTRAINT FK_LocalitateMagazin FOREIGN KEY (ID_LOCALITATE_MAGAZIN) REFERENCES
    P_LOCALITATE(ID_LOCALITATE) ON DELETE CASCADE  
);

-- Crearea tabelei P_ANTENA
CREATE TABLE P_ANTENA(
    ID_ANTENA NUMBER(4) NOT NULL,  
    LOCATIE_GPS_ANTENA VARCHAR2(30) NOT NULL,  
    ARIE_DESERVITA NUMBER(5,2) NOT NULL,       
    ID_LOCALITATE_APROPIATA NUMBER(6)         
);

-- Adăugarea constrângerilor de integritate pentru tabelul P_ANTENA
ALTER TABLE P_ANTENA
ADD (
    PRIMARY KEY (ID_ANTENA),  
    CONSTRAINT FK_LocalitateAntena FOREIGN KEY (ID_LOCALITATE_APROPIATA) REFERENCES
    P_LOCALITATE(ID_LOCALITATE) ON DELETE CASCADE  
);

-- Crearea tabelei P_CLIENTI
CREATE TABLE P_CLIENTI(
    ID_CLIENT NUMBER(6) NOT NULL,        
    NUME VARCHAR2(30) NOT NULL,          
    ID_LOCALITATE_CLIENT NUMBER(6),      
    CNP NUMBER(13) NOT NULL,             
    EMAIL VARCHAR2(50),                  
    TELEFON_FIX NUMBER(1) NOT NULL,      
    ID_ABONAMENT_CLIENT NUMBER(4),   
    DATA_NASTERII DATE,                  
    DATA_INREGISTRARII DATE             
);
