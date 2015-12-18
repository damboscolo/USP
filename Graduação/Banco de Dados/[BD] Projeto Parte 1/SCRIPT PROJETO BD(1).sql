CREATE TABLE Pessoa
(
	codPessoa int NOT NULL,
	nomePessoa varchar (100),
	cpfPessoa varchar (14),
	enderecoPessoa varchar (200),
	dataNascPessoa date,
	emailPessoa varchar (50),
	telefonePessoa varchar (12),

	CONSTRAINT pkPessoa PRIMARY KEY (codPessoa)
);

CREATE TABLE Evento
(
	codEvento int NOT NULL,
	tituloEvento varchar (100),
	descricaoEvento varchar (300),
	siteEvento varchar (50),

	CONSTRAINT pkEvento PRIMARY KEY (codEvento)
);

CREATE TABLE Edicao
(
	codEvento int NOT NULL,
	nroEdicao int NOT NULL,
	dataIniEdicao date,
	dataFimEdicao date,
	nroInscritosEdicao int,

	CONSTRAINT pkEdicao PRIMARY KEY (codEvento, nroEdicao),
	CONSTRAINT fkEventoEdicao FOREIGN KEY (codEvento) REFERENCES Evento (codEvento)
       ON DELETE CASCADE
       ON UPDATE CASCADE
);

CREATE TABLE Participante
(
	nroInscricao int NOT NULL,
	codPessoa int NOT NULL,
	codEvento int NOT NULL,
	nroEdicao int NOT NULL,
	tipoOuvinte int,
	tipoApresentador int,
	tipoOrganizador int,

	CONSTRAINT pkParticipante PRIMARY KEY (nroInscricao),
	CONSTRAINT ukPessoaEventoEdicao UNIQUE (codPessoa, codEvento, nroEdicao),
	CONSTRAINT fkPessoaParticipante FOREIGN KEY (codPessoa) REFERENCES Pessoa (codPessoa)
       ON DELETE CASCADE
       ON UPDATE CASCADE,
	CONSTRAINT fkEdicaoParticipante FOREIGN KEY (codEvento, nroEdicao) REFERENCES  Edicao (codEvento, nroEdicao)
       ON DELETE CASCADE
       ON UPDATE CASCADE
);

CREATE TABLE Patrocinador
(
	cnpjPatrocinador varchar (14) NOT NULL,
	razaoSocialPatrocinador varchar (100),
	nomeFantasiaPatrocinador varchar (100),
	enderecoPatrocinador varchar (200),

	CONSTRAINT pkPatrocinador PRIMARY KEY  (cnpjPatrocinador)
);

CREATE TABLE Despesa
(
	codEvento int NOT NULL,
	nroEdicao int NOT NULL,
	codDespesa int NOT NULL,
	cnpjPatrocinador varchar (14) NOT NULL,
	codEventoPatrocinio int NOT NULL,
	nroEdicaoPatrocinio int NOT NULL,
	dataDespesa date,
	valorDespesa decimal (13,2),
	descricaoDespesa varchar (200),
	tipoDespesa int,

	CONSTRAINT pkDespesa PRIMARY KEY (codEvento, nroEdicao, codDespesa),
	CONSTRAINT fkEdicaoDesp FOREIGN KEY (codEvento, nroEdicao) REFERENCES Edicao (codEvento, nroEdicao)
       ON DELETE CASCADE
       ON UPDATE CASCADE
);

CREATE TABLE DespesaApresentador
(
	codEvento int NOT NULL,
	nroEdicao int NOT NULL,
	codDespesa int NOT NULL,
	nroInscricao int NOT NULL,

	CONSTRAINT pkDespApre PRIMARY KEY (codEvento, nroEdicao, codDespesa),
	CONSTRAINT fkDespesaDespApre FOREIGN KEY (codEvento, nroEdicao, codDespesa) REFERENCES Despesa (codEvento, nroEdicao, codDespesa)
       ON DELETE CASCADE
       ON UPDATE CASCADE,
	CONSTRAINT fkParticipanteDespApre FOREIGN KEY (nroInscricao) REFERENCES Participante (nroInscricao)
       ON DELETE CASCADE
       ON UPDATE CASCADE
);

CREATE TABLE Patrocinio
(
	cnpjPatrocinador varchar (14) NOT NULL,
	codEvento int NOT NULL,
	nroEdicao int NOT NULL,
	valorPatrocinio decimal (12,2),
	saldoPatrocinio decimal (12,2),

	CONSTRAINT pkPatrocinio PRIMARY KEY (cnpjPatrocinador, codEvento, nroEdicao),
	CONSTRAINT fkPatrocinadorPatrocinio FOREIGN KEY (cnpjPatrocinador) REFERENCES Patrocinador (cnpjPatrocinador)
       ON DELETE CASCADE
       ON UPDATE CASCADE,
	CONSTRAINT fkEdicaoPatrocinio FOREIGN KEY (codEvento, nroEdicao) REFERENCES Edicao (codEvento, nroEdicao)
       ON DELETE CASCADE
       ON UPDATE CASCADE
);
	
ALTER TABLE Despesa
ADD	CONSTRAINT fkPatrocinioDesp FOREIGN KEY (cnpjPatrocinador, codEventoPatrocinio, nroEdicaoPatrocinio)
REFERENCES Patrocinio (cnpjPatrocinador, codEvento, nroEdicao)
       ON DELETE CASCADE
       ON UPDATE CASCADE;