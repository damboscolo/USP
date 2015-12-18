/* Cria todas as tabelas necessárias.
   Total: 13 Tabelas
*/

/* TODO:
   - Decidir se as tabelas Escalacao e Reserva vão ficar ou se voltarão a ser o atributo escReserva (linha 122).
*/

/* 2b. */

CREATE TABLE Selecao
(
	nome 		VARCHAR2(50) NOT NULL,
	letraHino 	VARCHAR2(3000),
	continente 	VARCHAR2(15),
	bandeira 	BLOB,
	grupo 		CHAR DEFAULT 'A',
	
	CONSTRAINT PK_SELECAO PRIMARY KEY (nome),
	CONSTRAINT N_GRUPO CHECK (grupo BETWEEN 'A' AND 'H')
);

CREATE TABLE Estadio
(
	idEstadio 	NUMBER NOT NULL,
	nome 		VARCHAR2(40),
	rua			VARCHAR2(50),
	num			NUMBER,
	bairro		VARCHAR2(40),
	capac		NUMBER,
	cidade		VARCHAR2(50),
	
	CONSTRAINT PK_ESTADIO PRIMARY KEY (idEstadio),
	CONSTRAINT UN_NOME UNIQUE (nome)
);

CREATE TABLE Jogo 
(
	idJogo 		NUMBER NOT NULL,
	idEstadio 	NUMBER NOT NULL,
	selecao1	VARCHAR2(50) NOT NULL,
	selecao2	VARCHAR2(50) NOT NULL,
    horaJogo	DATE DEFAULT LOCALTIMESTAMP,
	dataJogo	DATE DEFAULT SYSDATE,
	fase 		VARCHAR2(15),
	publico 	NUMBER,
	renda 		FLOAT ,
	
	CONSTRAINT PK_JOGO PRIMARY KEY (idJogo),
	CONSTRAINT FK_IDESTADIO_JOGO FOREIGN KEY (idEstadio)
			   REFERENCES Estadio (idEstadio)
			   ON DELETE CASCADE,
	CONSTRAINT FK_SELECAO1_JOGO FOREIGN KEY (selecao1)
			   REFERENCES Selecao (nome)
			   ON DELETE CASCADE,
	CONSTRAINT FK_SELECAO2_JOGO FOREIGN KEY (selecao2)
			   REFERENCES Selecao (nome)
			   ON DELETE CASCADE,
	CONSTRAINT N_SELECAO CHECK (selecao1 <> selecao2),
	CONSTRAINT N_PUBLICO CHECK (publico >= 0),
	CONSTRAINT N_RENDA CHECK (renda >= 0)
);

CREATE TABLE Pessoa
(
	idPessoa	NUMBER NOT NULL,
	nome		VARCHAR2(100),
	dataNasc	DATE,
	passaporte	VARCHAR2(15),
	nacion		VARCHAR2(30),
	tipoPessoa	NUMBER NOT NULL,
	
	CONSTRAINT PK_PESSOA PRIMARY KEY (idPessoa),
	CONSTRAINT UN_PASSAPORTE UNIQUE (passaporte)
);

CREATE TABLE Atleta
(
	idPessoa 	NUMBER NOT NULL,
	altura 		FLOAT,
	peso 		FLOAT,
	nomeSelecao VARCHAR2(30),
	
	CONSTRAINT PK_ATLETA PRIMARY KEY (idPessoa),
	CONSTRAINT FK_IDPESSOA_ATLETA FOREIGN KEY (idPessoa)
			   REFERENCES Pessoa (idPessoa)
			   ON DELETE CASCADE,
	CONSTRAINT CHECK_ALTURA CHECK (altura > 0),
	CONSTRAINT CHECK_PESO CHECK (peso > 0)
);

CREATE TABLE Arbitro
(
	idPessoa 	NUMBER NOT NULL,
	tipoArbit	VARCHAR2(50),
	
	CONSTRAINT PK_ARBITRO PRIMARY KEY (idPessoa),
	CONSTRAINT FK_IDPESSOA_ARBITRO FOREIGN KEY (idPessoa)
			   REFERENCES Pessoa (idPessoa)
			   ON DELETE CASCADE
);

CREATE TABLE JogosPart 
(
	idPessoa	NUMBER NOT NULL,
	idJogo  	NUMBER NOT NULL,
	
	CONSTRAINT PK_JOGOSPART PRIMARY KEY (idPessoa),
	CONSTRAINT FK_IDPESSOA_JOGOSPART FOREIGN KEY (idPessoa)
			   REFERENCES Arbitro (idPessoa)
			   ON DELETE CASCADE,
	CONSTRAINT FK_IDJOGO_JOGOSPART FOREIGN KEY (idJogo)
			   REFERENCES Jogo (idJogo)
			   ON DELETE CASCADE
);

CREATE TABLE SAJ /* Essa tabela cuida da relação entre os jogadores de uma determinada seleção que jogam em um jogo */
(
	nomeSelecao	VARCHAR2(20) NOT NULL,
	idPessoa	NUMBER NOT NULL,
	idJogo		NUMBER NOT NULL,
	escReserv	NUMBER NOT NULL,		-- 0 para Escalacao do Jogo, 1 para Reserva
	
	CONSTRAINT PK_SAJ PRIMARY KEY (nomeSelecao, idPessoa, idJogo),
	CONSTRAINT FK_NOMESELECAO_SAJ FOREIGN KEY (nomeSelecao)
			   REFERENCES Selecao(nome)
			   ON DELETE CASCADE,
	CONSTRAINT FK_IDPESSOA_SAJ FOREIGN KEY (idPessoa)
			   REFERENCES Pessoa (idPessoa)
			   ON DELETE CASCADE,
	CONSTRAINT FK_IDJOGO_SAJ FOREIGN KEY (idJogo)
			   REFERENCES Jogo (idJogo)
			   ON DELETE CASCADE,
	CONSTRAINT N_ESCRESERV CHECK (escReserv = 0 OR escReserv = 1)
);

CREATE TABLE Patrocinador 
(
	idPatroc	NUMBER NOT NULL,
	nomePatroc	VARCHAR2(50) NOT NULL,
	
	CONSTRAINT PK_PATROCINADOR PRIMARY KEY (idPatroc)
);

CREATE TABLE Paises_alvo 
(
	idPatroc	NUMBER NOT NULL,
	nomeSelec	VARCHAR2(50) NOT NULL,
	
	CONSTRAINT PK_PAISES_ALVO PRIMARY KEY (idPatroc),
	CONSTRAINT FK_IDPATROC_PAISES_ALVO FOREIGN KEY (idPatroc)
			   REFERENCES Patrocinador (idPatroc)
			   ON DELETE CASCADE,
	CONSTRAINT FK_NOMESELEC_PAISES_ALVO FOREIGN KEY (nomeSelec)
			   REFERENCES Selecao (nome)
			   ON DELETE CASCADE
);

CREATE TABLE Anuncio 
(
	idPatroc	NUMBER NOT NULL,
	idJogo		NUMBER NOT NULL,
	
	CONSTRAINT PK_ANUNCIO PRIMARY KEY (idPatroc, idJogo),
	CONSTRAINT FK_IDPATROC_ANUNCIO FOREIGN KEY (idPatroc)
			   REFERENCES Patrocinador (idPatroc)
			   ON DELETE CASCADE,
	CONSTRAINT FK_IDJOGO_ANUNCIO FOREIGN KEY (idJogo)
			   REFERENCES Jogo(idJogo)
			   ON DELETE CASCADE
);

CREATE TABLE Lance 
(
	idLance		NUMBER NOT NULL,
	idJogo		NUMBER NOT NULL,
	tipoLance	VARCHAR2(20) DEFAULT 'Gol' NOT NULL,
	tempLance	NUMBER DEFAULT 1,
	minLance	NUMBER DEFAULT 0,
	segLance	NUMBER DEFAULT 0,
	
	CONSTRAINT PK_LANCE PRIMARY KEY (idLance, idJogo),
	CONSTRAINT FK_IDJOGO_LANCE FOREIGN KEY (idJogo)
			   REFERENCES JOGO(idJogo)
			   ON DELETE CASCADE,
	CONSTRAINT N_TEMP_LANCE CHECK (tempLance BETWEEN 1 AND 5), /* Tempo do Lance: 1º (1) ou 2º (2) Tempo, 1ª (3) ou 2ª (4) Prorrogação e Pênalti (5) */
	CONSTRAINT N_MIN_LANCE CHECK (minLance BETWEEN 0 AND 55),  /* Até 55 minutos de jogo, levando em conta tempos de acréscimos. */
	CONSTRAINT N_SEG_LANCE CHECK (segLance BETWEEN 0 AND 59)
);

CREATE TABLE Jogadores_env
(
	idLance		NUMBER NOT NULL,
	idJogo		NUMBER NOT NULL,
	idPessoa	NUMBER NOT NULL,
	
	CONSTRAINT PK_Jogadores_env PRIMARY KEY (idLance, idJogo, idPessoa),
	CONSTRAINT FK_idLance_Jogadores_env FOREIGN KEY (idLance, idJogo)
			   REFERENCES Lance(idLance, idJogo)
			   ON DELETE CASCADE,
	CONSTRAINT FK_idPessoa FOREIGN KEY (idPessoa)
			   REFERENCES Pessoa(idPessoa)
			   ON DELETE CASCADE
);

