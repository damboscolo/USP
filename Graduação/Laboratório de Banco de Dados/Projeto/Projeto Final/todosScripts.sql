DROP SEQUENCE SeqGrupoId;
DROP SEQUENCE SeqPessoaId;
DROP SEQUENCE SeqEstadioId;
DROP SEQUENCE SeqJogoId;
DROP SEQUENCE SeqTipoId;
DROP SEQUENCE SeqPatrocinadorId;

DROP SYNONYM DivEm;
DROP SYNONYM Inter;
DROP SYNONYM Pat;
DROP SYNONYM Apt;
DROP SYNONYM PartDe;
DROP SYNONYM Lan;
DROP SYNONYM JgEm;
DROP SYNONYM Arb;
DROP SYNONYM Tp;
DROP SYNONYM Info;
DROP SYNONYM Enf;
DROP SYNONYM Jog;
DROP SYNONYM Est;
DROP SYNONYM Jogd;
DROP SYNONYM PertA;
DROP SYNONYM Pes;
DROP SYNONYM Sel;
DROP SYNONYM Nac;
DROP SYNONYM Gru;

DROP TABLE DivulgadoEm;
DROP TABLE Interesse;
DROP TABLE Patrocinador;
DROP TABLE Apita;
DROP TABLE ParticipaDe;
DROP TABLE Lance;
DROP TABLE JogouEm;
DROP TABLE Arbitro;
DROP TABLE Tipo;
DROP TABLE Informacao;
DROP TABLE Enfrenta;
DROP TABLE Jogo;
DROP TABLE Estadio;
DROP TABLE Jogador;
DROP TABLE PertenceA;
DROP TABLE Pessoa;
DROP TABLE Selecao;
DROP TABLE Nacao;
DROP TABLE Grupo;

CREATE TABLE Grupo (
  id NUMBER(10) NOT NULL,
  par NUMBER(10) NOT NULL,
  CONSTRAINT GrupoPK PRIMARY KEY(id),
  CONSTRAINT GrupoAK UNIQUE(par),
  CONSTRAINT GrupoFKGrupo FOREIGN KEY (par) REFERENCES Grupo(id)
);

CREATE TABLE Nacao (
  nome VARCHAR2(100) NOT NULL,
  bandeira BLOB,
  CONSTRAINT NacaoPK PRIMARY KEY(nome)
);

CREATE TABLE Selecao (
  nomeNacao VARCHAR2(100) NOT NULL,
  idGrupo NUMBER(10) NOT NULL,
  hino CLOB,
  continente VARCHAR2(100),
  pontos NUMBER(3) DEFAULT 0,
  golsMarcados NUMBER(3) DEFAULT 0,
  golsSofridos NUMBER(3) DEFAULT 0,
  saldo NUMBER(3) DEFAULT 0,
  cartAm NUMBER(3) DEFAULT 0,
  cartVer NUMBER(3) DEFAULT 0,
  CONSTRAINT SelecaoPK PRIMARY KEY(nomeNacao),
  CONSTRAINT SelecaoFKNacao FOREIGN KEY (nomeNacao) REFERENCES Nacao(nome),
  CONSTRAINT SelecaoFKGrupo FOREIGN KEY (idGrupo) REFERENCES Grupo(id),
  CONSTRAINT SelecaoCheckPontos CHECK (pontos >= 0),
  CONSTRAINT SelecaoCheckGolsMarcados CHECK (golsMarcados >= 0),
  CONSTRAINT SelecaoCheckGolsSofridos CHECK (golsSofridos >= 0),
  CONSTRAINT SelecaoCheckSaldo CHECK (saldo = golsMarcados-golsSofridos),
  CONSTRAINT SelecaoCheckCartAm CHECK (cartAm >= 0),
  CONSTRAINT SelecaoCheckCartVer CHECK (cartVer >= 0)
);

CREATE TABLE Pessoa (
  id NUMBER(10) NOT NULL,
  subClasse CHAR(1) NOT NULL,
  nome VARCHAR2(100) NOT NULL,
  passaporte VARCHAR2(50) NOT NULL,
  nascimento DATE,
  CONSTRAINT PessoaPK PRIMARY KEY(id),
  CONSTRAINT PessoaAK UNIQUE(passaporte),
  CONSTRAINT PessoaCheckClasse CHECK (subClasse IN ('A', 'J'))
);

CREATE TABLE PertenceA (
  idPessoa NUMBER(10) NOT NULL,
  nomeNacao VARCHAR2(100) NOT NULL,
  CONSTRAINT PertenceAPK PRIMARY KEY(idPessoa,nomeNacao),
  CONSTRAINT PertenceAFKPessoa FOREIGN KEY (idPessoa) REFERENCES Pessoa(id),
  CONSTRAINT PertenceAFKNacao FOREIGN KEY (nomeNacao) REFERENCES Nacao(nome)
);

CREATE TABLE Jogador (
  idPessoa NUMBER(10) NOT NULL,
  nomeSelecao VARCHAR2(100) NOT NULL,
  peso NUMBER(5,2),
  altura NUMBER(5,2),
  CONSTRAINT JogadorPK PRIMARY KEY (idPessoa),
  CONSTRAINT JogadorFKPessoa FOREIGN KEY (idPessoa) REFERENCES Pessoa(id),
  CONSTRAINT JogadorFKSelecao FOREIGN KEY (nomeSelecao) REFERENCES Selecao(nomeNacao)
);

CREATE TABLE Estadio (
  id NUMBER(10) NOT NULL,
  nome VARCHAR2(100) NOT NULL,
  cidade VARCHAR2(100),
  capacidade NUMBER(6),
  rua VARCHAR2(100),
  bairro VARCHAR2(100),
  nro NUMBER(5),
  CONSTRAINT EstadioPK PRIMARY KEY(id)
);
	
CREATE TABLE Jogo (
  id NUMBER(10) NOT NULL,
  idEstadio NUMBER(10) NOT NULL,
  hr CHAR(5),
  dt DATE,
  fase CHAR(2),
  renda NUMBER(10,3),
  publicoPresente NUMBER(6),
  CONSTRAINT JogoPK PRIMARY KEY (id),
  CONSTRAINT JogoFKEstadio FOREIGN KEY (idEstadio) REFERENCES Estadio(id),
  CONSTRAINT JogoCheckFase CHECK (fase IN ('G1', 'G2', 'G3', 'O', 'Q', 'S', 'F', 'T'))
);

CREATE TABLE Enfrenta (
  fasePosterior NUMBER(10) NOT NULL,
  faseAnteriorJ1 NUMBER(10) NOT NULL,
  faseAnteriorJ2 NUMBER(10) NOT NULL,
  vencedor CHAR(1) NOT NULL,
  CONSTRAINT EnfrentaPK PRIMARY KEY(fasePosterior),
  CONSTRAINT EnfrentaFKJogoP FOREIGN KEY (fasePosterior) REFERENCES Jogo(id),
  CONSTRAINT EnfrentaFKJogoAJ1 FOREIGN KEY (faseAnteriorJ1) REFERENCES Jogo(id),
  CONSTRAINT EnfrentaFKJogoAJ2 FOREIGN KEY (faseAnteriorJ2) REFERENCES Jogo(id),
  CONSTRAINT EnfrentaCheckVencedor CHECK (vencedor IN ('V', 'F'))
);

CREATE TABLE Informacao (
  idJogo NUMBER(10) NOT NULL,
  nomeSelecao1 VARCHAR2(100) NOT NULL,
  nomeSelecao2 VARCHAR2(100) NOT NULL,
  CONSTRAINT InformacaoPK PRIMARY KEY(idJogo),
  CONSTRAINT InformacaoFKJogo FOREIGN KEY (idJogo) REFERENCES Jogo(id),
  CONSTRAINT InformacaoFKSelecao1 FOREIGN KEY (nomeSelecao1) REFERENCES Selecao(nomeNacao),
  CONSTRAINT InformacaoFKSelecao2 FOREIGN KEY (nomeSelecao2) REFERENCES Selecao(nomeNacao)
);

CREATE TABLE Tipo (
  id NUMBER(10) NOT NULL,
  descritor VARCHAR2(100) NOT NULL,
  CONSTRAINT TipoPK PRIMARY KEY(id)
);

CREATE TABLE Arbitro (
  idPessoa NUMBER(10) NOT NULL,
  CONSTRAINT ArbitroPK PRIMARY KEY(idPessoa),
  CONSTRAINT ArbitroFKPessoa FOREIGN KEY (idPessoa) REFERENCES Pessoa(id)
);

CREATE TABLE JogouEm (
  idJogo NUMBER(10) NOT NULL,
  idJogador NUMBER(10) NOT NULL,
  titular CHAR(1) NOT NULL,
  cartVer NUMBER(1) DEFAULT 0,
  cartAm NUMBER(1) DEFAULT 0,
  CONSTRAINT JogouEmPK PRIMARY KEY(idJogo, idJogador),
  CONSTRAINT JogouEmFKInformacao FOREIGN KEY(idJogo) REFERENCES Informacao(idJogo),
  CONSTRAINT JogouEmFKJogador FOREIGN KEY (idJogador) REFERENCES Jogador(idPessoa),
  CONSTRAINT JogouEmCheckTitular CHECK (titular IN ('S', 'N')),
  CONSTRAINT JogouEmCheckCartVer CHECK (cartVer BETWEEN 0 and 1),
  CONSTRAINT JogouEmCheckCartAm CHECK (cartAm BETWEEN 0 and 2)
); 

CREATE TABLE Lance (
  idJogo NUMBER(10) NOT NULL,
  tempo CHAR(5) NOT NULL,
  idTipo NUMBER(10),
  descricao VARCHAR2(100) NOT NULL,
  CONSTRAINT LancePK PRIMARY KEY(idJogo,tempo),
  CONSTRAINT LanceFKJogo FOREIGN KEY (idJogo) REFERENCES Jogo(id),
  CONSTRAINT LanceFKTipo FOREIGN KEY (idTipo) REFERENCES Tipo(id) ON DELETE SET NULL
); 

CREATE TABLE ParticipaDe (
  idJogo NUMBER(10) NOT NULL,
  tempo CHAR(5) NOT NULL,
  idJogador NUMBER(10) NOT NULL,
  CONSTRAINT ParticipaDePK PRIMARY KEY(idJogo, tempo, idJogador),
  CONSTRAINT ParticipaDeFKLance FOREIGN KEY (idJogo, tempo) REFERENCES Lance(idJogo, tempo),
  CONSTRAINT ParticipaDeFKJogador FOREIGN KEY (idJogador) REFERENCES Jogador(idPessoa)
); 

CREATE TABLE Apita (
  idArbitro NUMBER(10) NOT NULL,
  idJogo NUMBER(10) NOT NULL,
  funcao VARCHAR2(20) NOT NULL,
  CONSTRAINT ApitaPK PRIMARY KEY(idArbitro,idJogo),
  CONSTRAINT ApitaFKArbitro FOREIGN KEY (idArbitro) REFERENCES Arbitro(idPessoa) ON DELETE CASCADE,
  CONSTRAINT ApitaFKJogo FOREIGN KEY (idJogo) REFERENCES Jogo(id),
  CONSTRAINT ApitaCheckFuncao CHECK (funcao IN ('Principal', 'Bandeirinha', 'Reserva'))
);

CREATE TABLE Patrocinador (
  id NUMBER(10) NOT NULL,
  nome VARCHAR2(100) NOT NULL,
  CONSTRAINT PatrocinadorPK PRIMARY KEY(id)
);

CREATE TABLE Interesse (
  idPatrocinador NUMBER(10) NOT NULL,
  nomeSelecao VARCHAR2(100) NOT NULL,
  CONSTRAINT InteressePK PRIMARY KEY(idPatrocinador, nomeSelecao),
  CONSTRAINT InteresseFKPatrocinador FOREIGN KEY (idPatrocinador) REFERENCES Patrocinador(id) ON DELETE CASCADE,
  CONSTRAINT InteresseFKSelecao FOREIGN KEY (nomeSelecao) REFERENCES Selecao(nomeNacao)
);

CREATE TABLE DivulgadoEm (
  idPatrocinador NUMBER(10) NOT NULL,
  idJogo NUMBER(10) NOT NULL,
  CONSTRAINT DivulgadoEmPK PRIMARY KEY(idPatrocinador, idJogo),
  CONSTRAINT DivulgadoEmFKPatrocinador FOREIGN KEY (idPatrocinador) REFERENCES Patrocinador(id) ON DELETE CASCADE,
  CONSTRAINT DivulgadoEmFKJogo FOREIGN KEY (idJogo) REFERENCES Jogo(id)
);

CREATE SYNONYM DivEm FOR DivulgadoEm;
CREATE SYNONYM Inter FOR Interesse;
CREATE SYNONYM Pat FOR Patrocinador;
CREATE SYNONYM Apt FOR Apita;
CREATE SYNONYM PartDe FOR ParticipaDe;
CREATE SYNONYM Lan FOR Lance;
CREATE SYNONYM JgEm FOR JogouEm;
CREATE SYNONYM Arb FOR Arbitro;
CREATE SYNONYM Tp FOR Tipo;
CREATE SYNONYM Info FOR Informacao;
CREATE SYNONYM Enf FOR Enfrenta;
CREATE SYNONYM Jog FOR Jogo;
CREATE SYNONYM Est FOR Estadio;
CREATE SYNONYM Jogd FOR Jogador;
CREATE SYNONYM PertA FOR PertenceA;
CREATE SYNONYM Pes FOR Pessoa;
CREATE SYNONYM Sel FOR Selecao;
CREATE SYNONYM Nac FOR Nacao;
CREATE SYNONYM Gru FOR Grupo;

CREATE SEQUENCE SeqGrupoId NOCYCLE NOCACHE;
CREATE SEQUENCE SeqPessoaId NOCYCLE NOCACHE;
CREATE SEQUENCE SeqEstadioId NOCYCLE NOCACHE;
CREATE SEQUENCE SeqJogoId NOCYCLE NOCACHE;
CREATE SEQUENCE SeqTipoId NOCYCLE NOCACHE;
CREATE SEQUENCE SeqPatrocinadorId NOCYCLE NOCACHE;

CREATE OR REPLACE TRIGGER triggerCartoes
BEFORE INSERT OR UPDATE OR DELETE ON ParticipaDe
FOR EACH ROW
DECLARE
	v_tipoLance NUMBER;
	numCartAm NUMBER;
	
BEGIN
	IF(INSERTING OR UPDATING) THEN
		SELECT idTipo INTO v_tipoLance
		FROM Lance L
		WHERE L.idJogo = :new.idJogo AND L.tempo = :new.tempo;
	
		SELECT count(*) INTO numCartAm
		FROM Lance L
		JOIN ParticipaDe PartDe ON PartDe.idJogo = L.idJogo AND PartDe.tempo = L.tempo
		WHERE L.idTipo = 3 AND PartDe.idJogador = :new.idJogador;
		
		IF(v_tipoLance = 3) THEN
			UPDATE JogouEm 
			SET CartAm = CartAm + 1
			WHERE JogouEm.idJogador = :new.idJogador AND JogouEm.idJogo = :new.idJogo;
		ELSIF(v_tipoLance = 3 AND (MOD(numCartAm, 2) <> 0)) THEN
			UPDATE JogouEm
			SET CartAm = CartAm + 1,
				CartVer = CartVer + 1
			WHERE JogouEm.idJogador = :new.idJogador AND JogouEm.idJogo = :new.idJogo;
		ELSIF(v_tipoLance = 4) THEN
			UPDATE JogouEm
			SET CartVer = CartVer + 1
			WHERE JogouEm.idJogador = :new.idJogador AND JogouEm.idJogo = :new.idJogo;
		END IF;
	END IF;
	
	IF(DELETING) THEN
		SELECT idTipo INTO v_tipoLance
		FROM Lance L
		WHERE L.idJogo = :old.idJogo AND L.tempo = :old.tempo;
		
		IF(v_tipoLance = 3) THEN
			UPDATE JogouEm
			SET CartAm = CartAm - 1
			WHERE JogouEm.idJogador = :old.idJogador AND JogouEm.idJogo = :old.idJogo;
		ELSIF(v_tipoLance = 4) THEN
			UPDATE JogouEm
			SET CartVer = CartVer - 1
			WHERE JogouEm.idJogador = :old.idJogador AND JogouEm.idJogo = :old.idJogo;
    END IF;
  END IF;
END trigger_cartoes;
/

CREATE OR REPLACE TRIGGER triggerValoresSelecPartDe
BEFORE INSERT OR UPDATE OR DELETE ON ParticipaDe
FOR EACH ROW
DECLARE
	v_tipoLance NUMBER;
	v_nomeSelecJog VARCHAR(100);
	v_nomeSelecao1 VARCHAR(100);
	v_nomeSelecao2 VARCHAR(100);
	v_numCartAm	NUMBER;
	
BEGIN
	IF(INSERTING OR UPDATING) THEN
		SELECT idTipo INTO v_tipoLance
		FROM Lance L
		WHERE L.idJogo = :new.idJogo AND L.tempo = :new.tempo;
		
		SELECT nomeSelecao INTO v_nomeSelecJog
		FROM Jogador J
		WHERE J.idPessoa = :new.idJogador;
		
		IF(v_tipoLance = 1) THEN
			SELECT nomeSelecao1 INTO v_nomeSelecao1
			FROM Informacao Inf
			WHERE Inf.idJogo = :new.idJogo;
			
			SELECT nomeSelecao2 INTO v_nomeSelecao2
			FROM Informacao Inf
			WHERE Inf.idJogo = :new.idJogo;
		
			IF(v_nomeSelecJog = v_nomeSelecao1) THEN
				UPDATE Selecao
				SET Saldo = Saldo + 1,
					GolsMarcados = GolsMarcados + 1
				WHERE Selecao.nomeNacao = v_nomeSelecao1;
				
				UPDATE Selecao
				SET Saldo = Saldo - 1,
					GolsSofridos = GolsSofridos + 1
				WHERE Selecao.nomeNacao = v_nomeSelecao2;
        
			ELSIF(v_nomeSelecJog = v_nomeSelecao2) THEN
				UPDATE Selecao
				SET Saldo = Saldo + 1,
					GolsMarcados = GolsMarcados + 1
				WHERE Selecao.nomeNacao = v_nomeSelecao2;
				
				UPDATE Selecao
				SET Saldo = Saldo - 1,
					GolsSofridos = GolsSofridos + 1
				WHERE Selecao.nomeNacao = v_nomeSelecao1;
			END IF;
		ELSIF(v_tipoLance = 3) THEN
			
			SELECT cartAm INTO v_numCartAm
			FROM Selecao S
			WHERE S.nomeNacao = v_nomeSelecJog;
			
			IF((MOD(v_numCartAm, 2) <> 0)) THEN
				UPDATE Selecao
				SET CartAm = CartAm + 1,
					CartVer = CartVer + 1
				WHERE Selecao.nomeNacao = v_nomeSelecJog;
			ELSE
				UPDATE Selecao
				SET CartAm = CartAm + 1
				WHERE Selecao.nomeNacao = v_nomeSelecJog;
			END IF;
		ELSIF(v_tipoLance = 4) THEN
			UPDATE Selecao
			SET CartVer = CartVer + 1
			WHERE Selecao.nomeNacao = v_nomeSelecJog;
		END IF;
	END IF;
	
	IF(DELETING) THEN
		SELECT idTipo INTO v_tipoLance
		FROM Lance L
		WHERE L.idJogo = :old.idJogo AND L.tempo = :old.tempo;
		
		SELECT nomeSelecao INTO v_nomeSelecJog
		FROM Jogador J
		WHERE J.idPessoa = :old.idJogador;
		
		IF(v_tipoLance = 1) THEN
			SELECT nomeSelecao1 INTO v_nomeSelecao1
			FROM Informacao Inf
			WHERE Inf.idJogo = :old.idJogo;
			
			SELECT nomeSelecao2 INTO v_nomeSelecao2
			FROM Informacao Inf
			WHERE Inf.idJogo = :old.idJogo;
		
			IF(v_nomeSelecJog = v_nomeSelecao1) THEN
				UPDATE Selecao
				SET Saldo = Saldo - 1,
					GolsMarcados = GolsMarcados - 1
				WHERE Selecao.nomeNacao = v_nomeSelecao1;
				
				UPDATE Selecao
				SET Saldo = Saldo + 1,
					GolsSofridos = GolsSofridos - 1
				WHERE Selecao.nomeNacao = v_nomeSelecao2;
			ELSIF(v_nomeSelecJog = v_nomeSelecao2) THEN
				UPDATE Selecao
				SET Saldo = Saldo - 1,
					GolsMarcados = GolsMarcados - 1
				WHERE Selecao.nomeNacao = v_nomeSelecao2;
				
				UPDATE Selecao
				SET Saldo = Saldo + 1,
					GolsSofridos = GolsSofridos - 1
				WHERE Selecao.nomeNacao = v_nomeSelecao1;
			END IF;
			UPDATE Selecao
			SET Saldo = GolsMarcados - GolsSofridos
			WHERE Selecao.nomeNacao = v_nomeSelecao2;
				
			UPDATE Selecao
			SET Saldo = GolsMarcados - GolsSofridos
			WHERE Selecao.nomeNacao = v_nomeSelecao1;
		ELSIF(v_tipoLance = 3) THEN
			UPDATE Selecao
			SET CartAm = CartAm - 1
			WHERE Selecao.nomeNacao = v_nomeSelecJog;
		ELSIF(v_tipoLance = 4) THEN
			UPDATE Selecao
			SET CartVer = CartVer - 1
			WHERE Selecao.nomeNacao = v_nomeSelecJog;
		END IF;
	END IF;
END triggerValoresSelecPartDe;
/

CREATE OR REPLACE TRIGGER triggerGrupoId
	BEFORE INSERT ON Grupo
	FOR EACH ROW 
BEGIN 
    IF( :new.id IS NULL ) THEN 
		SELECT SEQGRUPOID.NEXTVAL 
		INTO   :new.id 
		FROM   dual; 
    END IF; 
END;
/

CREATE OR REPLACE TRIGGER triggerPessoaId
	BEFORE INSERT ON Pessoa
	FOR EACH ROW
BEGIN
	IF(:new.id is NULL) THEN
		SELECT SeqPessoaId.NEXTVAL
		INTO :new.id
		FROM dual;
	END IF;
END;
/

CREATE OR REPLACE TRIGGER triggerEstadioId
	BEFORE INSERT ON Estadio
	FOR EACH ROW
BEGIN
	IF(:new.id is NULL) THEN
		SELECT SeqEstadioId.NEXTVAL
		INTO :new.id
		FROM dual;
	END IF;
END;
/

CREATE OR REPLACE TRIGGER triggerJogoId
	BEFORE INSERT ON Jogo
	FOR EACH ROW
BEGIN
	IF(:new.id is NULL) THEN
		SELECT SeqJogoId.NEXTVAL
		INTO :new.id
		FROM dual;
	END IF;
END;
/

CREATE OR REPLACE TRIGGER triggerTipoId
	BEFORE INSERT ON Tipo
	FOR EACH ROW
BEGIN
	IF(:new.id is NULL) THEN
		SELECT SeqTipoId.NEXTVAL
		INTO :new.id
		FROM dual;
	END IF;
END;
/

CREATE OR REPLACE TRIGGER triggerPatrocinadorId
	BEFORE INSERT ON Patrocinador
	FOR EACH ROW
BEGIN
	IF(:new.id is NULL) THEN
		SELECT SeqPatrocinadorId.NEXTVAL
		INTO :new.id
		FROM dual;
	END IF;
END;
/

--Grupo
ALTER TABLE Grupo
			DROP CONSTRAINT GrupoFKGrupo;	--Necessário para a inserção dos dados, já que a tabela referencia a si mesma.

INSERT INTO Gru(par) -- Grupo A
			VALUES (2);
INSERT INTO Gru(par) -- Grupo B
			VALUES (1);
INSERT INTO Gru(par) -- Grupo C
			VALUES (4);
INSERT INTO Gru(par) -- Grupo D
			VALUES (3);
INSERT INTO Gru(par) -- Grupo E
			VALUES (6);
INSERT INTO Gru(par) -- Grupo F
			VALUES (5);
INSERT INTO Gru(par) -- Grupo G
			VALUES (8);
INSERT INTO Gru(par) -- Grupo H
			VALUES (7);

ALTER TABLE Grupo
			ADD CONSTRAINT GrupoFKGrupo FOREIGN KEY (par) REFERENCES Grupo(id); -- Recolocação da CONSTRAINT GrupoFKGrupo no atributo par.

--Nacao
----Grupo A
INSERT INTO Nac(nome, bandeira)
			VALUES ('Uruguai', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('México', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('África do Sul', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('França', EMPTY_BLOB());

----Grupo B
INSERT INTO Nac(nome, bandeira)
			VALUES ('Argentina', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Coréia do Sul', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Grécia', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Nigéria', EMPTY_BLOB());
			
----Grupo C
INSERT INTO Nac(nome, bandeira)
			VALUES ('Estados Unidos da América', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Inglaterra', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Eslovênia', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Algéria', EMPTY_BLOB());

----Grupo D
INSERT INTO Nac(nome, bandeira)
			VALUES ('Alemanha', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Guana', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Austrália', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Sérvia', EMPTY_BLOB());

----Grupo E
INSERT INTO Nac(nome, bandeira)
			VALUES ('Holanda', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Japão', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Dinamarca', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Camarões', EMPTY_BLOB());

----Grupo F
INSERT INTO Nac(nome, bandeira)
			VALUES ('Paraguai', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Eslováquia', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Nova Zelândia', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Itália', EMPTY_BLOB());

----Grupo G
INSERT INTO Nac(nome, bandeira) 
			VALUES ('Brasil', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Portugal', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Costa do Marfim', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Coréia do Norte', EMPTY_BLOB());

----Grupo H
INSERT INTO Nac(nome, bandeira) 
			VALUES ('Espanha', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Chile', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Suíça', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Honduras', EMPTY_BLOB());

----Países dos Árbitros/Jogadores
INSERT INTO Nac(nome, bandeira)
			VALUES ('El Salvador', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Húngria', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Uzbequistão', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Guatemala', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Bélgica', EMPTY_BLOB());

--Selecao
----Grupo A
INSERT INTO Sel(nomeNacao, idGrupo, hino, continente)
			VALUES ('Uruguai', 1, 'Orientales la Patria o la Tumba!
Libertad o con gloria morir!
Orientales la Patria o la Tumba!
Libertad o con gloria morir!
Es el voto que el alma pronuncia,
Y que heroicos sabremos cumplir!
Es el voto que el alma pronuncia,
Y que heroicos sabremos cumplir!
Que sabremos cumplir!
Es el voto que el alma pronuncia,
Y que heroicos sabremos cumplir!
Que sabremos cumplir!
Sabremos cumplir!
Sabremos cumplir!
Sabremos cumplir!
Libertad, libertad Orientales!
Este grito à la Patria salvó.
Que a sus bravos en fieras batallas
De entusiasmo sublime inflamó.
Libertad, libertad Orientales!
Este grito à la Patria salvó.
Que a sus bravos en fieras batallas
De entusiasmo sublime inflamó.
De este don sacrosanto la gloria
Merecimos: tiranos temblad!
Tiranos temblad!
Tiranos temblad!
Libertad en la lid clamaremos,
Y muriendo, también libertad!
Libertad en la lid clamaremos,
Y muriendo, también libertad!
Y muriendo, también libertad!
También libertad!
También libertad!
Orientales la Patria o la Tumba!
Libertad o con gloria morir!
Orientales la Patria o la Tumba!
Libertad o con gloria morir!
Es el voto que el alma pronuncia,
Y que heroicos sabremos cumplir!
Es el voto que el alma pronuncia,
Y que heroicos sabremos cumplir!
Que sabremos cumplir!
Es el voto que el alma pronuncia,
Y que heroicos sabremos cumplir!
Que sabremos cumplir!
Sabremos cumplir!
Sabremos cumplir!
Sabremos cumplir!', 'América do Sul');
INSERT INTO Sel(nomeNacao, idGrupo, continente) VALUES ('México', 1, 'América do Norte');
INSERT INTO Sel(nomeNacao, idGrupo, continente) VALUES ('África do Sul', 1, 'África');
INSERT INTO Sel(nomeNacao, idGrupo, continente) VALUES ('França', 1, 'Europa');

--Grupo B
INSERT INTO Sel(nomeNacao, idGrupo, hino, continente)
			VALUES ('Argentina', 2, 'Oíd, mortales, el grito sagrado:
"¡Libertad! ¡Libertad! ¡Libertad!"
Oíd el ruido de rotas cadenas
ved en trono a la noble igualdad

Ya su trono dignísimo abrieron
las Provincias Unidas del Sud
y los libres del mundo responden:
"¡Al gran pueblo argentino, salud!"
"¡Al gran pueblo argentino, salud!"
Y los libres del mundo responden:
"¡Al gran pueblo argentino, salud!"
Y los libres del mundo responden:
"¡Al gran pueblo argentino, salud!"

Sean eternos los laureles,
que supimos conseguir,
que supimos conseguir.
Coronados de gloria vivamos...
o juremos con gloria morir!
O juremos con gloria morir!
O juremos con gloria morir!', 'América do Sul');
INSERT INTO Sel(nomeNacao, idGrupo, hino, continente)
			VALUES ('Coréia do Sul', 2, '동해 물과 백두산이 마르고 닳도록
하느님이 보우하사 우리나라 만세
무궁화 삼천리 화려 강산
대한 사람 대한으로 길이 보전하세
남산 위에 저 소나무 철갑을 두른 듯
바람서리 불변함은 우리 기상일세
가을 하늘 공활한데 높고 구름 없이
밝은 달은 우리 가슴 일편단심일세
이 기상과 이 맘으로 충성을 다하여
괴로우나 즐거우나 나라 사랑하세', 'Ásia');
INSERT INTO Sel(nomeNacao, idGrupo, continente) VALUES ('Grécia', 2, 'Europa');
INSERT INTO Sel(nomeNacao, idGrupo, continente) VALUES ('Nigéria', 2, 'África');

--Grupo C
INSERT INTO Sel(nomeNacao, idGrupo, continente) VALUES ('Estados Unidos da América', 3, 'América do Norte');
INSERT INTO Sel(nomeNacao, idGrupo, hino, continente)
			VALUES ('Inglaterra', 3, '1.
God save our gracious Queen,
Live long our noble Queen,
God save the Queen!
Send her victorious,
Happy and glorious,
Long to reign over us,
God save the Queen.
2.
Thy choicest gifts in store
On her be pleased to pour,
Long may she reign;
May she defend our laws,
And ever give us cause
To sing with heart and voice,
God save the Queen!
3.
God bless our native land,
May heaven''s protective hand
Still guard our shore;
May peace her power extend,
Foe be transformed to friend,
And Britain''s power depend
On war no more.
4.
May just and righteous laws
Uphold the public cause,
And bless our isle.
Home of the brave and free,
Fair land and liberty,
We pray that still on thee
Kind heaven may smile.
5.
And not this land alone-
But be thy mercies known
From shore to shore.
Lord, make the nations see
That men should brothers be,
And from one family
The wide world o''er.', 'Europa');
INSERT INTO Sel(nomeNacao, idGrupo, continente) VALUES ('Eslovênia', 3, 'Europa');
INSERT INTO Sel(nomeNacao, idGrupo, continente) VALUES ('Algéria', 3, 'África');

--Grupo D
INSERT INTO Sel(nomeNacao, idGrupo, hino, continente)
			VALUES ('Alemanha', 4, 'Deutschland, Deutschland über alles,
Über alles in der Welt,
Wenn es stets zu Schutz und Trutze
Brüderlich zusammenhält.
Von der Maas bis an die Memel,
Von der Etsch bis an den Belt,
Deutschland, Deutschland über alles,
Über alles in der Welt!
Deutsche Frauen, deutsche Treue,
Deutscher Wein und deutscher Sang
Sollen in der Welt behalten
Ihren alten schönen Klang,
Uns zu edler Tat begeistern
Unser ganzes Leben lang.
Deutsche Frauen, deutsche Treue,
Deutscher Wein und deutscher Sang!
Einigkeit und Recht und Freiheit
Für das deutsche Vaterland!
Danach lasst uns alle streben
Brüderlich mit Herz und Hand!
Einigkeit und Recht und Freiheit
Sind des Glückes Unterpfand;
Blüh'' im Glanze dieses Glückes,
 Blühe, deutsches Vaterland!', 'Europa');
INSERT INTO Sel(nomeNacao, idGrupo, hino, continente)
			VALUES ('Guana', 4, 'God bless our homeland Ghana
And make our nation great and strong,
Bold to defend forever
The cause of Freedom and of Right;
Fill our hearts with true humility,
Make us cherish fearless honesty,
And help us to resist oppressors'' rule

With all our will and might for evermore.
Hail to thy name, O Ghana,
To thee we make our solemn vow:
Steadfast to build together
A nation strong in Unity;
With our gifts of mind and strength of arm,
Whether night or day, in the midst of storm,
In every need, whate''er the call may be,

To serve thee, Ghana, now and evermore.
Raise high the flag of Ghana
and one with Africa advance;
Black star of hope and honour
To all who thirst for liberty;
Where the banner of Ghana freely flies,
May the way to freedom truly lie;
Arise, arise, O sons of Ghana land,

And under God march on for evermore!', 'África');
INSERT INTO Sel(nomeNacao, idGrupo, continente) VALUES ('Austrália', 4, 'Oceania');
INSERT INTO Sel(nomeNacao, idGrupo, continente) VALUES ('Sérvia', 4, 'África');

----Grupo E
INSERT INTO Sel(nomeNacao, idGrupo, hino, continente)
			VALUES ('Holanda', 5, 'Wilhelmus van Nassouwe
ben ik, van Duitsen bloed,
den vaderland getrouwe
blijf ik tot in den dood.
Een Prinse van Oranje
ben ik, vrij, onverveerd,
den Koning van Hispanje
heb ik altijd geëerd.
In Godes vrees te leven
heb ik altijd betracht,
daarom ben ik verdreven,
om land, om luid gebracht.
Maar God zal mij regeren
als een goed instrument,
dat ik zal wederkeren
in mijnen regiment.
Lijdt u, mijn onderzaten
die oprecht zijt van aard,
God zal u niet verlaten,
al zijt gij nu bezwaard.
Die vroom begeert te leven,
bidt God nacht ende dag,
dat Hij mij kracht zal geven,
dat ik u helpen mag.
Lijf en goed al te samen
heb ik u niet verschoond,
mijn broeders hoog van namen
hebben ''t u ook vertoond:
Graaf Adolf is gebleven
in Friesland in de slag,
zijn ziel in ''t eeuwig leven
verwacht de jongste dag.
Edel en hooggeboren,
van keizerlijke stam,
een vorst des rijks verkoren,
als een vroom christenman,
voor Godes woord geprezen,
heb ik, vrij onversaagd,
als een held zonder vreze
mijn edel bloed gewaagd.
Mijn schild ende betrouwen
zijt Gij, o God mijn Heer,
op U zo wil ik bouwen,
Verlaat mij nimmermeer.
Dat ik doch vroom mag blijven,
uw dienaar t''aller stond,
de tirannie verdrijven
die mij mijn hart doorwondt.
Van al die mij bezwaren
en mijn vervolgers zijn,
mijn God, wil doch bewaren
de trouwe dienaar dijn,
dat zij mij niet verrassen
in hunne boze moed,
hun handen niet en wassen
in mijn onschuldig bloed.
Als David moeste vluchten
voor Sauel de tiran,
zo heb ik moeten zuchten
als menig edelman.
Maar God heeft hem verheven,
verlost uit alle nood,
een koninkrijk gegeven
in Israël zeer groot.
Na ''t zuur zal ik ontvangen
van God mijn Heer het zoet,
daarnaar zo doet verlangen
mijn vorstelijk gemoed:
dat is, dat ik mag sterven
met ere in dat veld,
een eeuwig rijk verwerven
als een getrouwe held.
Niets doet mij meer erbarmen
in mijne wederspoed
dan dat men ziet verarmen
des Konings landen goed.
Dat u de Spanjaards krenken,
o edel Neerland zoet,
als ik daaraan gedenke,
mijn edel hart dat bloedt.
Als een prins opgezeten
met mijner heireskracht,
van de tiran vermeten
heb ik de slag verwacht,
die, bij Maastricht begraven,
bevreesden mijn geweld;
mijn ruiters zag men draven
zeer moedig door dat veld.
Zo het de wil des Heren
op die tijd was geweest,
had ik geern willen keren
van u dit zwaar tempeest.
Maar de Heer van hierboven,
die alle ding regeert,
die men altijd moet loven,
Hij heeft het niet begeerd.
Zeer christlijk was gedreven
mijn prinselijk gemoed,
standvastig is gebleven
mijn hart in tegenspoed.
De Heer heb ik gebeden
uit mijnes harten grond,
dat Hij mijn zaak wil redden,
mijn onschuld maken kond.
Oorlof, mijn arme schapen
die zijt in grote nood,
uw herder zal niet slapen,
al zijt gij nu verstrooid.
Tot God wilt u begeven,
zijn heilzaam woord neemt aan,
als vrome christen leven,-
''t zal hier haast zijn gedaan.
Voor God wil ik belijden
en zijne grote macht,
dat ik tot gene tijden
de Koning heb veracht,
dan dat ik God de Here,
de hoogste Majesteit,
heb moeten obediëren
in de gerechtigheid.
WILLEM VAN NAZZOV', 'Europa');
INSERT INTO Sel(nomeNacao, idGrupo, continente) VALUES ('Japão', 5, 'Ásia');
INSERT INTO Sel(nomeNacao, idGrupo, continente) VALUES ('Dinamarca', 5, 'Europa');
INSERT INTO Sel(nomeNacao, idGrupo, continente) VALUES ('Camarões', 5, 'África');

--Grupo F
INSERT INTO Sel(nomeNacao, idGrupo, hino, continente)
			VALUES ('Paraguai', 6, 'Paraguayos, ¡República o Muerte!
nuestro brío nos dio libertad;
ni opresores, ni siervos alientan
donde reinan unión e igualdad.
A los pueblos de América, infausto
tres centurias un cetro oprimió,
mas un día soberbia surgiendo,
"¡Basta!" —dijo, y el cetro rompió.
Nuestros padres, lidiando grandiosos,
ilustraron su gloria marcial;
y trozada la augusta diadema,
enalzaron el gorro triunfal.
Nueva Roma, la Patria ostentará
dos caudillos de nombre y valer,
que rivales —cual Rómulo y Remo—
dividieron gobierno y poder.
Largos años —cual Febo entre nubes—
viose oculta la perla del Sud.
Hoy un héroe grandioso aparece
realzando su gloria y virtud...
Con aplauso la Europa y el Mundo
la saludan, y aclaman también;
de heroísmo: baluarte invencible,
de riquezas: magnífico Edén.
Cuando entorno rugió la Discordia
que otros Pueblos fatal devoró,
paraguayos, el suelo sagrado
con sus alas un ángel cubrió.
¡Oh! cuán pura, de lauro ceñida,
dulce Patria te ostentas así
En tu enseña se ven los colores
del zafiro, diamante y rubí.
En tu escudo que el sol ilumina,
bajo el gorro se mira el león.
Doble imagen de fuertes y libres,
y de glorias, recuerdo y blasón.
De la tumba del vil feudalismo
se alza libre la Patria deidad;
opresores, ¡doblad rodilla!,
compatriotas, ¡el Himno entonad!
Suene el grito: "¡República o muerte!",
nuestros pechos lo exhalen con fe,
y sus ecos repitan los montes
cual gigantes poniéndose en pie.
Libertad y justicia defiende
nuestra Patria; tiranos, ¡oíd!
de sus fueros la carta sagrada
su heroísmo sustenta en la lid.
Contra el mundo, si el mundo se opone,
Si intentare su prenda insultar,
batallando vengar la sabremos
o abrazo con ella expirar.
Alza, oh Pueblo, tu espada esplendente
que fulmina destellos de Dios,
no hay más medio que libre o esclavo
y un abismo divide a los dos.
En las auras el Himno resuene,
repitiendo con eco triunfal:
¡a los libres perínclita gloria!,
¡a la Patria laurel inmortal!', 'América do Sul');
INSERT INTO Sel(nomeNacao, idGrupo, hino, continente)
			VALUES ('Eslováquia', 6, 'Nad Tatrou sa blýska, hromy divo bijú, 
nad Tatrou sa blýska, hromy divo bijú.
Zastavme ich bratia, veď sa ony stratia, Slováci ožijú, 
zastavme ich bratia, veď sa ony stratia, Slováci ožijú.
To Slovensko naše dosiaľ tvrdo spalo, 
to Slovensko naše dosiaľ tvrdo spalo.
Ale blesky hromu vzbudzujú ho k tomu, aby sa prebralo, 
ale blesky hromu vzbudzujú ho k tomu, aby sa prebralo.', 'Europa');
INSERT INTO Sel(nomeNacao, idGrupo, continente) VALUES ('Nova Zelândia', 6, 'Oceania');
INSERT INTO Sel(nomeNacao, idGrupo, continente) VALUES ('Itália', 6, 'Europa');

--Grupo G
INSERT INTO Sel(nomeNacao, idGrupo, hino, continente) 
			VALUES ('Brasil', 7, 'Ouviram do Ipiranga as margens plácidas
De um povo heroico o brado retumbante,
E o sol da Liberdade, em raios fúlgidos,
Brilhou no céu da Pátria nesse instante.

Se o penhor dessa igualdade
Conseguimos conquistar com braço forte,
Em teu seio, ó Liberdade,
Desafia o nosso peito a própria morte!

Ó Pátria amada,
Idolatrada,
Salve! Salve!

Brasil, um sonho intenso, um raio vívido,
De amor e de esperança à terra desce,
Se em teu formoso céu, risonho e límpido,
A imagem do Cruzeiro resplandece.

Gigante pela própria natureza,
És belo, és forte, impávido colosso,
E o teu futuro espelha essa grandeza.

Terra adorada
Entre outras mil
És tu, Brasil,
Ó Pátria amada!

Dos filhos deste solo
És mãe gentil,
Pátria amada,
Brasil!
Deitado eternamente em berço esplêndido,
Ao som do mar e à luz do céu profundo,
Fulguras, ó Brasil, florão da América,
Iluminado ao sol do Novo Mundo!

Do que a terra mais garrida
Teus risonhos, lindos campos têm mais flores,
"Nossos bosques têm mais vida",
"Nossa vida" no teu seio "mais amores".

Ó Pátria amada,
Idolatrada,
Salve! Salve!

Brasil, de amor eterno seja símbolo
O lábaro que ostentas estrelado,
E diga o verde-louro dessa flâmula
- Paz no futuro e glória no passado.

Mas se ergues da justiça a clava forte,
Verás que um filho teu não foge à luta,
Nem teme, quem te adora, a própria morte.

Terra adorada
Entre outras mil
És tu, Brasil,
Ó Pátria amada!

Dos filhos deste solo
És mãe gentil,
Pátria amada,
Brasil!', 'América do Sul');
INSERT INTO Sel(nomeNacao, idGrupo, hino, continente)
			VALUES ('Portugal', 7, 'Heróis do mar, nobre povo,
Nação valente, imortal,
Levantai hoje de novo
O esplendor de Portugal!
Entre as brumas da memória,
Ó Pátria, sente-se a voz
Dos teus egrégios avós,
Que há-de guiar-te à vitória!
Às armas, às armas!
Sobre a terra, sobre o mar,
Às armas, às armas!
Pela Pátria lutar!
Contra os canhões, marchar, marchar!
Desfralda a invicta Bandeira,
À luz viva do teu céu!
Brade a Europa à terra inteira:
Portugal não pereceu
Beija o solo teu jucundo
O Oceano, a rugir d''amor,
E teu braço vencedor
Deu mundos novos ao Mundo!
Saudai o Sol que desponta
Sobre um ridente porvir;
Seja o eco de uma afronta
O sinal do ressurgir.
Raios dessa aurora forte
São como beijos de mãe,
Que nos guardam, nos sustêm,
Contra as injúrias da sorte.', 'Europa');
INSERT INTO Sel(nomeNacao, idGrupo, continente) VALUES ('Costa do Marfim', 7, 'África');
INSERT INTO Sel(nomeNacao, idGrupo, continente) VALUES ('Coréia do Norte', 7, 'Ásia');

--Grupo H
INSERT INTO Sel(nomeNacao, idGrupo, hino, continente) 
			VALUES ('Espanha', 8, '¡Viva España!
Cantemos todos juntos
con distinta voz
y un solo corazón.
¡Viva España!
Desde los verdes valles
al inmenso mar,
un himno de hermandad.
Ama a la Patria
pues sabe abrazar,
bajo su cielo azul,
pueblos en libertad.
Gloria a los hijos
que a la Historia dan
justicia y grandeza
democracia y paz.', 'Europa');
INSERT INTO Sel(nomeNacao, idGrupo, hino, continente)
			VALUES ('Chile', 8, 'Puro, Chile, es tu cielo azulado.
Puras brisas te cruzan también.
Y tu campo de flores bordado
Es la copia feliz del Edén.
Majestuosa es la blanca montaña
Que te dio por baluarte el Señor
Que te dio por baluarte el Señor,
Y ese mar que tranquilo te baña
Te promete un futuro esplendor
Y ese mar que tranquilo te baña
Te promete un futuro esplendor.
Dulce Patria, recibe los votos
Con que Chile en tus aras juró:
Que o la tumba serás de los libres
O el asilo contra la opresión
Que o la tumba serás de los libres
O el asilo contra la opresión
Que o la tumba serás de los libres
O el asilo contra la opresión
O el asilo contra la opresión
O el asilo contra la opresión.', 'América do Sul');
INSERT INTO Sel(nomeNacao, idGrupo, continente) VALUES ('Suíça', 8, 'Europa');
INSERT INTO Sel(nomeNacao, idGrupo, continente) VALUES ('Honduras', 8, 'América Central');

--Pessoa
----Árbitros
INSERT INTO Pes(subclasse, nome, passaporte, nascimento) 		-- 1
			VALUES ('A', 'Yuichi Nishimura', '3332', to_date('17/04/72', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento) 		-- 2
			VALUES ('A', 'Joel Aguilar', '5545', to_date('02/07/75', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento) 		-- 3
			VALUES ('A', 'Benito Archundia', '8787', to_date('21/03/66', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 4
			VALUES ('A', 'Howard Webb', '141524124', to_date('14/07/71', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 5
			VALUES ('A', 'Viktor Kassai', '490112412', to_date('10/09/75', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 6
			VALUES ('A', 'Ravshan Irmatov', '014241241', to_date('09/07/77', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 7
			VALUES ('A', 'Carlos Batres', '1231241', to_date('02/04/68', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 8
			VALUES ('A', 'Olegário Benquerença', '23124141', to_date('18/10/69', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 9
			VALUES ('A', 'Héctor Baldassi', '2315555124', to_date('05/01/66', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 10
			VALUES ('A', 'Frank De Bleeckere', '211516661', to_date('01/07/66', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 11
			VALUES ('A', 'Alberto Undiano Mallenco', '05501241', to_date('08/10/73', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 12
			VALUES ('A', 'Roberto Rosetti', '12412415', to_date('18/09/67', 'dd/mm/yy'));

----Jogadores
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 13
			VALUES ('J', 'Thomas Müller', '321314', to_date('13/09/89', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento) 		-- 14
			VALUES ('J', 'Kaká', '5547', to_date('22/04/82', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 15
			VALUES ('J', 'David Villa', '12151251', to_date('03/12/81', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 16
			VALUES ('J', 'Wesley Sneijder', '124152516', to_date('09/06/84', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 17
			VALUES ('J', 'Diego Fórlan', '15581922', to_date('19/05/79', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 18
			VALUES ('J', 'Manuel Neuer', '241411251', to_date('27/03/86', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 19
			VALUES ('J', 'Eljero Elia', '30912300131', to_date('13/02/87', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 20
			VALUES ('J', 'Luis Suárez', '13134141', to_date('24/01/87', 'dd/mm/yy'));

--PertenceA
----Árbitros
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (1, 'Japão');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (2, 'El Salvador');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (3, 'México');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (4, 'Inglaterra');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (5, 'Húngria');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (6, 'Uzbequistão');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (7, 'Guatemala');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (8, 'Portugal');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (9, 'Argentina');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (10, 'Bélgica');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (11, 'Espanha');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (12, 'Itália');

----Jogadores
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (13, 'Alemanha');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (14, 'Brasil');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (15, 'Espanha');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (16, 'Holanda');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (17, 'Uruguai');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (18, 'Alemanha');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (19, 'Holanda');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (20, 'Uruguai');

--Jogador
INSERT INTO Jogd(idPessoa, nomeSelecao, peso, altura) -- Thomas Müller // Maior número de gols da World Cup 2010: 5
			VALUES (13, 'Alemanha', 74, 1.86);
INSERT INTO Jogd(idPessoa, nomeSelecao, peso, altura) -- Kaká // 
			VALUES (14, 'Brasil', 74, 1.76);
INSERT INTO Jogd(idPessoa, nomeSelecao, peso, altura) -- David Villa // Maior número de gols da World Cup 2010: 5
			VALUES (15, 'Espanha', 69, 1.75);
INSERT INTO Jogd(idPessoa, nomeSelecao, peso, altura) -- Wesley Sneijder // Maior número de gols da World Cup 2010: 5
			VALUES (16, 'Holanda', 67, 1.70);
INSERT INTO Jogd(idPessoa, nomeSelecao, peso, altura) -- Diego Fórlan // Maior número de gols da World Cup 2010: 5
			VALUES (17, 'Uruguai', 75, 1.80);
INSERT INTO Jogd(idPessoa, nomeSelecao, peso, altura) -- Manuel Neuer // Goleiro da Alemanha
			VALUES (18, 'Alemanha', 92, 1.93); 
INSERT INTO Jogd(idPessoa, nomeSelecao, peso, altura) -- Eljero Elia //
			VALUES (19, 'Holanda', 77, 1.76);
INSERT INTO Jogd(idPessoa, nomeSelecao, peso, altura) -- Luis Suárez //
			VALUES (20, 'Uruguai', 81, 1.81);

			
--Estadio
INSERT INTO Est(nome, cidade, capacidade, rua, bairro, nro) 	-- 1
			VALUES ('Nelson Mandela Bay Stadium', 'Port Elizabeth', 48000, 'Prince Alfred Road', 'North End', 6001);
INSERT INTO Est(nome, cidade, capacidade, rua, bairro, nro) 	-- 2
			VALUES ('Loftus Versfeld Stadium', 'Pretoria', 51000, 'Kirkness St.', 'Arcadia', 440);
INSERT INTO Est(nome, cidade, capacidade, rua, bairro, nro) 	-- 3
			VALUES ('Cape Town Stadium', 'Cape Town', 69000, 'Fritz Sonnenberg Rd.', 'Green Point', 8051);
INSERT INTO Est(nome, cidade, capacidade, rua, bairro, nro) 	-- 4
			VALUES ('Moses Mabhida Stadium', 'Durban', 70000, 'Masabalala Yengwa Ave', 'Stamford Hill', 4025);
INSERT INTO Est(nome, cidade, capacidade, rua, bairro, nro) 	-- 5
			VALUES ('Ellis Park Stadium', 'Johannesburg', 59611, 'Doornfontein', '47 North Park Lane', 2028);
INSERT INTO Est(nome, cidade, capacidade, rua, bairro, nro)		-- 6
			VALUES ('Soccer City', 'Johannesburg', 94736, 'Stadium Avenue', 'Nasrec', 0);
INSERT INTO Est(nome, cidade, capacidade, rua, bairro, nro)		-- 7
			VALUES ('Peter Mokaba Stadium', 'Polokwane', 41733, 'Magazin St.', 'Polokwane Central', 0);
INSERT INTO Est(nome, cidade, capacidade, rua, bairro, nro)		-- 8
			VALUES ('Mbombela Stadium', 'Nelspruit', 40929, 'Masafeni Rd.', 'N/A', 0);
INSERT INTO Est(nome, cidade, capacidade, rua, bairro, nro)		-- 9
			VALUES ('Free State Stadium', 'Bloemfontein', 48000, 'Kings Way', 'Westdene', 0);
INSERT INTO Est(nome, cidade, capacidade, rua, bairro, nro)		-- 10
			VALUES ('Royal Bafokeng Stadium', 'Phokeng', 42000, 'Sun City Rd.', 'N/A', 0);

--Jogo
----Oitavas de Final
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 1 Uruguai x Coréia do Sul
			VALUES(1, '11:00', to_date('26/06/10', 'dd/mm/yy'), 'O', 4589550, 30597);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 2 EUA x Guana
			VALUES(10, '15:30', to_date('26/06/10', 'dd/mm/yy'), 'O', 5246400, 34976);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 3 Alemanha x Inglaterra
			VALUES(9, '11:00', to_date('27/06/10', 'dd/mm/yy'), 'O', 6076500, 40510);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 4 Argentina x México
			VALUES(6, '15:30', to_date('27/06/10', 'dd/mm/yy'), 'O', 9265655, 84377);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 5 Holanda x Eslováquia
			VALUES(4, '11:00', to_date('28/06/10', 'dd/mm/yy'), 'O', 9294300, 61962);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 6 Brasil x Chile
			VALUES(5, '15:30', to_date('28/06/10', 'dd/mm/yy'), 'O', 8114400, 54096);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 7 Paraguai x Japão
			VALUES(2, '11:00', to_date('29/06/10', 'dd/mm/yy'), 'O', 5511300, 36742);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 8 Espanha x Portugal
			VALUES(3, '15:30', to_date('29/06/10', 'dd/mm/yy'), 'O', 9443250, 62955);

----Quartas-de-Final
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 9 Holanda x Brasil
			VALUES(1, '11:00', to_date('02/07/10', 'dd/mm/yy'), 'Q', 6027900, 40186);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 10 Uruguai x Guana
			VALUES(6, '15:30', to_date('02/07/10', 'dd/mm/yy'), 'Q', 9260255, 84017);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 11 Argentina x Alemanha
			VALUES(3, '11:00', to_date('03/07/10', 'dd/mm/yy'), 'Q', 9615000, 64100);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 12 Paraguai x Espanha
			VALUES(5, '15:30', to_date('03/07/10', 'dd/mm/yy'), 'Q', 8303850, 55359);
			
----Semi-final
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 13 Uruguai x Holanda
			VALUES(3, '15:30', to_date('06/07/10', 'dd/mm/yy'), 'S', 9371850, 62479);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 14 Alemanha x Espanha
			VALUES(4, '15:30', to_date('07/07/10', 'dd/mm/yy'), 'S', 9144000, 60960);

----Final
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 15 Uruguai x Alemanha
			VALUES(1, '15:30', to_date('10/07/10', 'dd/mm/yy'), 'F', 5438100, 36254);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 16 Holanda x Espanha
			VALUES(6, '15:30', to_date('11/07/10', 'dd/mm/yy'), 'F', 1267350, 84490);

--Enfrenta
INSERT INTO Enf(fasePosterior, faseAnteriorJ1, faseAnteriorJ2, vencedor) -- 4ªs-de-Final 1 [Holanda x Brasil]
			VALUES (9, 5, 6, 'V');
INSERT INTO Enf(fasePosterior, faseAnteriorJ1, faseAnteriorJ2, vencedor) -- 4ªs-de-Final 2 [Uruguai x Guana]
			VALUES (10, 1, 2, 'V');
INSERT INTO Enf(fasePosterior, faseAnteriorJ1, faseAnteriorJ2, vencedor) -- 4ªs-de-Final 3 [Argentina x Alemanha]
			VALUES (11, 3, 4, 'V');
INSERT INTO Enf(fasePosterior, faseAnteriorJ1, faseAnteriorJ2, vencedor) -- 4ªs-de-Final 4 [Paraguai x Espanha]
			VALUES (12, 7, 8, 'V');
INSERT INTO Enf(fasePosterior, faseAnteriorJ1, faseAnteriorJ2, vencedor) -- Semi-Final 1 [Uruguai x Holanda]
			VALUES (13, 9, 10, 'V');
INSERT INTO Enf(fasePosterior, faseAnteriorJ1, faseAnteriorJ2, vencedor) -- Semi-Final 2 [Alemanha x Espanha]
			VALUES (14, 11, 12, 'V');
INSERT INTO Enf(fasePosterior, faseAnteriorJ1, faseAnteriorJ2, vencedor) -- Final 1 [Uruguai x Alemanha]
			VALUES (15 , 13, 14, 'F');
INSERT INTO Enf(fasePosterior, faseAnteriorJ1, faseAnteriorJ2, vencedor) -- Final 2 [Holanda x Espanha]
			VALUES (16 , 13, 14, 'V');

--Informacao
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (1, 'Uruguai', 'Coréia do Sul');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (3, 'Alemanha', 'Inglaterra');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (5, 'Holanda', 'Eslováquia');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (6, 'Brasil', 'Chile');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (8, 'Espanha', 'Portugal');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (9, 'Holanda', 'Brasil');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (10, 'Uruguai', 'Guana');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (11, 'Argentina', 'Alemanha');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (12, 'Paraguai', 'Espanha');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (13, 'Uruguai', 'Holanda');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (14, 'Alemanha', 'Espanha');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (15, 'Uruguai', 'Alemanha');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (16, 'Holanda', 'Espanha');

--Tipo
INSERT INTO Tp(descritor)
			VALUES ('Gol');
INSERT INTO Tp(descritor)
			VALUES ('Lance de Perigo');
INSERT INTO Tp(descritor)
			VALUES ('Cartão Amarelo');
INSERT INTO Tp(descritor)
			VALUES ('Cartão Vermelho');
INSERT INTO Tp(descritor)
			VALUES ('Substituição');

--Árbitro
INSERT INTO Arb(idPessoa)
			VALUES (1);
INSERT INTO Arb(idPessoa)
			VALUES (2);
INSERT INTO Arb(idPessoa)
			VALUES (3);
INSERT INTO Arb(idPessoa)
			VALUES (4);
INSERT INTO Arb(idPessoa)
			VALUES (5);
INSERT INTO Arb(idPessoa)
			VALUES (6);
INSERT INTO Arb(idPessoa)
			VALUES (7);
INSERT INTO Arb(idPessoa)
			VALUES (8);
INSERT INTO Arb(idPessoa)
			VALUES (9);
INSERT INTO Arb(idPessoa)
			VALUES (10);
INSERT INTO Arb(idPessoa)
			VALUES (11);
INSERT INTO Arb(idPessoa)
			VALUES (12);
			
--JogouEm
----Thomas Müller (Alemanha)
INSERT INTO JgEm(idJogo, idJogador, titular) --Uruguai x Alemanha
			VALUES (15, 13, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Argentina x Alemanha
			VALUES (11, 13, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Alemanha x Inglaterra
			VALUES (3, 13, 'S');
----Kaká (Brasil)
INSERT INTO JgEm(idJogo, idJogador, titular) --Brasil x Chile
			VALUES (6, 14, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Holanda x Brasil
			VALUES (9, 14, 'S');
----David Villa (Espanha)
INSERT INTO JgEm(idJogo, idJogador, titular) --Holanda x Espanha
			VALUES (16, 15, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Paraguai x Espanha
			VALUES (12, 15, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Espanha x Portugal
			VALUES (8, 15, 'S');
----Wesley Sneijder (Holanda)
INSERT INTO JgEm(idJogo, idJogador, titular) --Holanda x Espanha
			VALUES (16, 16, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Uruguai x Holanda
			VALUES (13, 16, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Holanda x Brasil
			VALUES (9, 16, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Holanda x Eslováquia
			VALUES (5, 16, 'S');
----Diego Fórlan (Uruguai)
INSERT INTO JgEm(idJogo, idJogador, titular) --Uruguai x Alemanha
			VALUES (15, 17, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Uruguai x Holanda
			VALUES (13, 17, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Uruguai x Guana
			VALUES (10, 17, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Uruguai x Coréia do Sul
			VALUES (1, 17, 'S');
----Manuel Neuer (Alemanha)
INSERT INTO JgEm(idJogo, idJogador, titular) --Alemanha x Espanha
			VALUES (14, 18, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Argentina x Alemanha
			VALUES (11, 18, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Alemanha x Inglaterra
			VALUES (3, 18, 'S');
----Eljero Elia (Holanda)
INSERT INTO JgEm(idJogo, idJogador, titular) --Holanda x Espanha
			VALUES (16, 19, 'N');

			
--Lance
----Müller
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (15, '00:19', 1, 'Gol realizado por Müller da Alemanha aos 19 minutos do primeiro tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (11, '00:03', 1, 'Gol realizado por Müller da Alemanha aos 3 minutos do primeiro tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (11, '00:35', 3, 'Cartão amarelo recebido por Müller da Alemanha aos 35 minutos do primeiro tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (11, '01:24', 5, 'Müller da Alemanha é substituído aos 39 minutos do segundo tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (3, '01:12', 5, 'Müller da Alemanha é substituído aos 27 minutos do segundo tempo.');
----Sneijder
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (13, '01:10', 1, 'Gol realizado por Sneijder da Holanda aos 25 minutos do segundo tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (13, '00:29', 3, 'Cartão amarelo recebido por Sneijder da Holanda aos 29 minutos do primeiro tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (9, '00:53', 1, 'Gol realizado por Sneijder da Holanda aos 8 minutos do segundo tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (9, '01:08', 1, 'Gol realizado por Sneijder da Holanda aos 23 minutos do segundo tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (5, '01:24', 1, 'Gol realizado por Sneijder da Holanda aos 39 minutos do segundo tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (5, '01:32', 5, 'Sneijder da Holanda é substituído aos 2 minutos na prorrogação.');
----Fórlan
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (15, '00:51', 1, 'Gol realizado por Forlán do Uruguai aos 6 minutos do segundo tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (13, '00:41', 1, 'Gol realizado por Fórlan do Uruguai aos 41 minutos do primeiro tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (10, '00:55', 1, 'Gol realizado por Fórlan do Uruguai aos 10 minutos do segundo tempo.');
----Villa
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (16, '01:46', 5, 'Villa da Espanha é substituído a 1 minuto do segundo tempo adicional.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (12, '01:21', 1, 'Gol realizado por Villa da Espanha aos 36 minutos do segundo tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (8, '01:03', 1, 'Gol realizado por Villa da Espanha aos 18 minutos do segundo tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (8, '01:28', 5, 'Villa da Espanha é substituído aos 43 minutos do segundo tempo.');
----Kaká
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (6, '00:30', 3, 'Cartão amarelo recebido por Kaká do Brasil aos 30 minutos do primeiro tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (6, '01:21', 5, 'Kaká do Brasil é substituído aos 36 minutos do segundo tempo.');
			
--ParticipaDe
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (15, '00:19', 13);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (11, '00:03', 13);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (11, '00:35', 13);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (11, '01:24', 13);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (3, '01:12', 13);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (6, '00:30', 14);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (6, '01:21', 14);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (16, '01:46', 15);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (12, '01:21', 15);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (8, '01:03', 15);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (8, '01:28', 15);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (13, '01:10', 16);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (13, '00:29', 16);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (9, '00:53', 16);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (9, '01:08', 16);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (5, '01:24', 16);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (5, '01:32', 16);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (15, '00:51', 17);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (13, '00:41', 17);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (10, '00:55', 17);
			
			
--Apita
INSERT INTO Apt(idArbitro, idJogo, funcao) 
			VALUES (1, 9, 'Principal');		-- Yuichi Nishimura, Holanda x Brasil.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (1, 16, 'Reserva'); 		-- Yuichi Nishimura, Holanda x Espanha.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (2, 1, 'Reserva');		-- Joel Aguillar, Uruguai x Coréia do Sul.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (3, 12, 'Reserva');		-- Benito Archundia, Paraguai x Espanha.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (3, 15, 'Principal');	-- Benito Archundia, Uruguai x Alemanha.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (4, 16, 'Principal');	-- Howard Webb, Holanda x Espanha.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (4, 6, 'Principal');		-- Howard Webb, Brasil x Chile.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (5, 2, 'Principal');		-- Viktor Kassai, EUA x Guana.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (5, 14, 'Principal');	-- Viktor Kassai, Alemanha x Espanha.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (6, 11, 'Principal');	-- Ravshan Irmatov, Argentina x Alemanha.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (6, 13, 'Principal');	-- Ravshan Irmatov, Uruguai x Holanda.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (7, 8, 'Reserva');		-- Carlos Batres, Espanha x Portugal.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (7, 12, 'Principal');	-- Carlos Batres, Paraguai x Espanha.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (8, 10, 'Principal');	-- Olegário Benquerença, Uruguai x Guana.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (9, 8, 'Principal');		-- Héctor Baldassi, Espanha x Portugal.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (10, 7, 'Principal');	-- Frank De Bleeckere, Paraguai x Japão.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (10, 14, 'Reserva');		-- Frank De Bleeckere, Alemanha x Espanha.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (11, 5, 'Principal');	-- Alberto Undiano Mallenco, Holanda x Eslováquia.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (11, 10, 'Reserva');		-- Alberto Undiano Mallenco, Uruguai x Guana.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (12, 4, 'Principal');	-- Roberto Rosetti, Argentina x México.
			
--Patrocinador
INSERT INTO Pat(nome)
			VALUES ('Coca-Cola');
INSERT INTO Pat(nome)
			VALUES ('Adidas');
INSERT INTO Pat(nome)
			VALUES ('VISA');
INSERT INTO Pat(nome)
			VALUES ('SONY');
INSERT INTO Pat(nome)
			VALUES ('McDonald''s');
			
--Interesse
INSERT INTO Inter(idPatrocinador, nomeSelecao)
			VALUES(1, 'Brasil');
INSERT INTO Inter(idPatrocinador, nomeSelecao)
			VALUES(2, 'Holanda');
INSERT INTO Inter(idPatrocinador, nomeSelecao)
			VALUES(3, 'Alemanha');
INSERT INTO Inter(idPatrocinador, nomeSelecao)
			VALUES(4, 'Uruguai');
INSERT INTO Inter(idPatrocinador, nomeSelecao)
			VALUES(5, 'Espanha');
			
--DivulgadoEm
----Coca-Cola, Interesse: Brasil, Tuplas: 2
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(1, 6);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(1, 9);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(1, 12);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(1, 15);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(1, 16);
----Adidas, Interesse: Holanda, Tuplas: 4
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(2, 5);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(2, 9);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(2, 13);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(2, 15);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(2, 16);
----VISA, Interesse: Alemanha, Tuplas: 4
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(3, 3);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(3, 11);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(3, 14);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(3, 15);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(3, 16);
----SONY, Interesse: Uruguai, Tuplas: 4
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(4, 1);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(4, 10);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(4, 13);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(4, 15);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(4, 16);
			
DECLARE
	v_aux NUMBER;
	v_rand NUMBER;
	v_sql VARCHAR2(1000);
	
	v_nome VARCHAR2(100);
	v_passaporte VARCHAR2(50);
	v_idPessoa NUMBER;
	v_nomeSelecao VARCHAR2(100);
	v_numSelecao NUMBER;
	
	v_cur SYS_REFCURSOR;
BEGIN
	SELECT DISTINCT COUNT(*) INTO v_numSelecao
	FROM Selecao;
	
	v_aux := 1;
	
	v_sql := 'SELECT nomeNacao FROM Selecao';
	OPEN v_cur FOR v_sql;
	LOOP
		FETCH v_cur INTO v_nomeSelecao;
		EXIT WHEN v_cur%NOTFOUND;
		FOR v_aux IN 1..2 LOOP
			SELECT CAST(dbms_random.value(1, 20) AS INTEGER) INTO v_rand
			FROM DUAL;
			
			CASE v_rand
				WHEN 1 THEN v_nome := 'João';
				WHEN 2 THEN v_nome := 'José';
				WHEN 3 THEN v_nome := 'Bruno';
				WHEN 4 THEN v_nome := 'Lineu';
				WHEN 5 THEN v_nome := 'Shotaro';
				WHEN 6 THEN v_nome := 'Mike';
				WHEN 7 THEN v_nome := 'Albert';
				WHEN 8 THEN v_nome := 'Fernando';
				WHEN 9 THEN v_nome := 'Upalan';
				WHEN 10 THEN v_nome := 'Ken';
				WHEN 11 THEN v_nome := 'Leonar';
				WHEN 12 THEN v_nome := 'Linus';
				WHEN 13 THEN v_nome := 'Cromagnum';
				WHEN 14 THEN v_nome := 'Yonsei';
				WHEN 15 THEN v_nome := 'Matheus';
				WHEN 16 THEN v_nome := 'Coppenhagen';
				WHEN 17 THEN v_nome := 'Hikari';
				WHEN 18 THEN v_nome := 'Joseph';
				WHEN 19 THEN v_nome := 'Mário';
				WHEN 20 THEN v_nome := 'Peter';
			END CASE;
			
			SELECT CAST(dbms_random.value(1, 20) AS INTEGER) INTO v_rand
			FROM DUAL;
			
			CASE v_rand
				WHEN 1 THEN v_nome := v_nome || ' Carvalho';
				WHEN 2 THEN v_nome := v_nome || ' Yoachim';
				WHEN 3 THEN v_nome := v_nome || ' Silva';
				WHEN 4 THEN v_nome := v_nome || ' Well';
				WHEN 5 THEN v_nome := v_nome || ' Yuuki';
				WHEN 6 THEN v_nome := v_nome || ' Vizir';
				WHEN 7 THEN v_nome := v_nome || ' Fundraiser';
				WHEN 8 THEN v_nome := v_nome || ' Agosto';
				WHEN 9 THEN v_nome := v_nome || ' Cabalan';
				WHEN 10 THEN v_nome := v_nome || ' Masters';
				WHEN 11 THEN v_nome := v_nome || ' Henriq III';
				WHEN 12 THEN v_nome := v_nome || ' Pauling';
				WHEN 13 THEN v_nome := v_nome || ' Devaing';
				WHEN 14 THEN v_nome := v_nome || ' Pologn';
				WHEN 15 THEN v_nome := v_nome || ' Eran';
				WHEN 16 THEN v_nome := v_nome || ' Solomon';
				WHEN 17 THEN v_nome := v_nome || ' Peridot';
				WHEN 18 THEN v_nome := v_nome || ' Castellini';
				WHEN 19 THEN v_nome := v_nome || ' Corleone';
				WHEN 20 THEN v_nome := v_nome || ' Dartagnan';
			END CASE;
			
			SELECT CAST(CAST(dbms_random.value(1000000, 9999999) AS INTEGER) AS VARCHAR2(50)) INTO v_passaporte
			FROM DUAL;
  
      v_sql := 'INSERT INTO Pessoa(subClasse, nome, passaporte) VALUES(''J'', ''' ||  v_nome || ''', ''' || v_passaporte || ''')';
      dbms_output.put_line(v_sql);
      EXECUTE IMMEDIATE v_sql;
      
			SELECT id INTO v_idPessoa
			FROM Pessoa
			WHERE passaporte = v_passaporte;
      
			v_sql := 'INSERT INTO PertenceA(idPessoa, nomeNacao) VALUES(' || v_idPessoa || ', ''' || v_nomeSelecao || ''')';
      dbms_output.put_line(v_sql);
      EXECUTE IMMEDIATE v_sql;
      
			v_sql := 'INSERT INTO Jogador(idPessoa, nomeSelecao) VALUES(' || v_idPessoa || ', ''' ||  v_nomeSelecao || ''')';
      dbms_output.put_line(v_sql);
      EXECUTE IMMEDIATE v_sql;
      
		END LOOP;
	END LOOP;
END;
/

DECLARE
	v_aux NUMBER;
	v_rand NUMBER;
	v_sql VARCHAR2(1000);
	
	v_nome VARCHAR2(100);
	v_passaporte VARCHAR2(50);
	v_idPessoa NUMBER;
	v_nomeSelecao VARCHAR2(100);
	v_numSelecao NUMBER;
	
	v_cur SYS_REFCURSOR;
BEGIN
	SELECT DISTINCT COUNT(*) INTO v_numSelecao
	FROM Selecao;
	
	v_aux := 1;
	
	v_sql := 'SELECT nomeNacao FROM Selecao';
	OPEN v_cur FOR v_sql;
	LOOP
		FETCH v_cur INTO v_nomeSelecao;
		EXIT WHEN v_cur%NOTFOUND;
		FOR v_aux IN 1..2 LOOP
			SELECT CAST(dbms_random.value(1, 20) AS INTEGER) INTO v_rand
			FROM DUAL;
			
			CASE v_rand
				WHEN 1 THEN v_nome := 'João';
				WHEN 2 THEN v_nome := 'José';
				WHEN 3 THEN v_nome := 'Bruno';
				WHEN 4 THEN v_nome := 'Lineu';
				WHEN 5 THEN v_nome := 'Shotaro';
				WHEN 6 THEN v_nome := 'Mike';
				WHEN 7 THEN v_nome := 'Albert';
				WHEN 8 THEN v_nome := 'Fernando';
				WHEN 9 THEN v_nome := 'Upalan';
				WHEN 10 THEN v_nome := 'Ken';
				WHEN 11 THEN v_nome := 'Leonar';
				WHEN 12 THEN v_nome := 'Linus';
				WHEN 13 THEN v_nome := 'Cromagnum';
				WHEN 14 THEN v_nome := 'Yonsei';
				WHEN 15 THEN v_nome := 'Matheus';
				WHEN 16 THEN v_nome := 'Coppenhagen';
				WHEN 17 THEN v_nome := 'Hikari';
				WHEN 18 THEN v_nome := 'Joseph';
				WHEN 19 THEN v_nome := 'Mário';
				WHEN 20 THEN v_nome := 'Peter';
			END CASE;
			
			SELECT CAST(dbms_random.value(1, 20) AS INTEGER) INTO v_rand
			FROM DUAL;
			
			CASE v_rand
				WHEN 1 THEN v_nome := v_nome || ' Carvalho';
				WHEN 2 THEN v_nome := v_nome || ' Yoachim';
				WHEN 3 THEN v_nome := v_nome || ' Silva';
				WHEN 4 THEN v_nome := v_nome || ' Well';
				WHEN 5 THEN v_nome := v_nome || ' Yuuki';
				WHEN 6 THEN v_nome := v_nome || ' Vizir';
				WHEN 7 THEN v_nome := v_nome || ' Fundraiser';
				WHEN 8 THEN v_nome := v_nome || ' Agosto';
				WHEN 9 THEN v_nome := v_nome || ' Cabalan';
				WHEN 10 THEN v_nome := v_nome || ' Masters';
				WHEN 11 THEN v_nome := v_nome || ' Henriq III';
				WHEN 12 THEN v_nome := v_nome || ' Pauling';
				WHEN 13 THEN v_nome := v_nome || ' Devaing';
				WHEN 14 THEN v_nome := v_nome || ' Pologn';
				WHEN 15 THEN v_nome := v_nome || ' Eran';
				WHEN 16 THEN v_nome := v_nome || ' Solomon';
				WHEN 17 THEN v_nome := v_nome || ' Peridot';
				WHEN 18 THEN v_nome := v_nome || ' Castellini';
				WHEN 19 THEN v_nome := v_nome || ' Corleone';
				WHEN 20 THEN v_nome := v_nome || ' Dartagnan';
			END CASE;
			
			SELECT CAST(CAST(dbms_random.value(1000000, 9999999) AS INTEGER) AS VARCHAR2(50)) INTO v_passaporte
			FROM DUAL;
  
      v_sql := 'INSERT INTO Pessoa(subClasse, nome, passaporte) VALUES(''A'', ''' ||  v_nome || ''', ''' || v_passaporte || ''')';
      dbms_output.put_line(v_sql);
      EXECUTE IMMEDIATE v_sql;
      
			SELECT id INTO v_idPessoa
			FROM Pessoa
			WHERE passaporte = v_passaporte;
      
			v_sql := 'INSERT INTO PertenceA(idPessoa, nomeNacao) VALUES(' || v_idPessoa || ', ''' || v_nomeSelecao || ''')';
      dbms_output.put_line(v_sql);
      EXECUTE IMMEDIATE v_sql;
      
			v_sql := 'INSERT INTO Arbitro(idPessoa) VALUES(' || v_idPessoa || ')';
      dbms_output.put_line(v_sql);
      EXECUTE IMMEDIATE v_sql;
      
		END LOOP;
	END LOOP;
END;
/

CREATE OR REPLACE PACKAGE faseGrupos AS
	PROCEDURE criarFaseGrupos;
END faseGrupos;
/
CREATE OR REPLACE PACKAGE BODY faseGrupos AS	
	PROCEDURE criarJogo(p_idJogo OUT NUMBER) AS
		v_rand NUMBER;
		v_sql VARCHAR(1000);

		v_idEstadio NUMBER;
		v_hora CHAR(5);
		v_data DATE;
		v_fase CHAR(2);
		v_renda NUMBER;
		v_publico NUMBER;
	BEGIN	
			SELECT CAST(dbms_random.value(1, 10) AS INTEGER) INTO v_idEstadio
			FROM DUAL;
			
			SELECT CAST(dbms_random.value(1, 4) AS INTEGER) INTO v_rand
			FROM DUAL;
			
			CASE v_rand
				WHEN 1 THEN v_hora := '13:00';
				WHEN 2 THEN v_hora := '16:00';
				WHEN 3 THEN v_hora := '17:00';
				WHEN 4 THEN v_hora := '19:00';
			END CASE;
			
			SELECT to_date(trunc(dbms_random.value(to_char(date '2010-06-01','J'), to_char(date '2010-06-15','J'))), 'J') INTO v_data
			FROM DUAL;
			
			SELECT CAST(dbms_random.value(1, 3) AS INTEGER) INTO v_rand
			FROM DUAL;
			
			CASE v_rand
				WHEN 1 THEN v_fase := 'G1';
				WHEN 2 THEN v_fase := 'G2';
				WHEN 3 THEN v_fase := 'G3';
			END CASE;
			
			SELECT CAST(dbms_random.value(100000, 1000000) AS INTEGER) INTO v_renda
			FROM DUAL;
			
			SELECT CAST(dbms_random.value(100000, 999999) AS INTEGER) INTO v_publico
			FROM DUAL;
			
			v_sql := 'INSERT INTO Jogo(idEstadio, hr, dt, fase, renda, publicoPresente) VALUES(' || v_idEstadio || ', ''' || v_hora || ''', to_date( ''' ||  v_data || ''', ''dd/mm/yy''), ''' || v_fase || ''', ' || v_renda || ', ' || v_publico || ')';
			EXECUTE IMMEDIATE v_sql;
			
			SELECT id INTO p_idJogo
			FROM Jogo Jg
			WHERE idEstadio = v_idEstadio AND renda = v_renda AND publicoPresente = v_publico;
		
	END criarJogo;
	
	PROCEDURE criarLances(p_idJogo NUMBER, p_nomeSelecao VARCHAR2) AS
		v_rand NUMBER;
		v_aux NUMBER;
		v_sql VARCHAR2(1000);
		
		v_nomeJogador VARCHAR2(100);
		v_idJogador NUMBER;
		v_idTipo NUMBER;
		v_hora CHAR(2);
		v_min CHAR(2);
		v_tempo CHAR(5);
		v_descricao VARCHAR2(100);
		
		v_cur SYS_REFCURSOR;
	BEGIN
		v_sql := 'SELECT idPessoa FROM Jogador J WHERE J.nomeSelecao = ''' || p_nomeSelecao || '''';
		OPEN v_cur FOR v_sql;
		
		LOOP
			v_aux := 0;
			FETCH v_cur INTO v_idJogador;
			EXIT WHEN v_cur%NOTFOUND;
			
			SELECT nome INTO v_nomeJogador
			FROM Pessoa P
			WHERE P.id = v_idJogador;
			
			SELECT CAST(dbms_random.value(00, 89) AS INTEGER) INTO v_hora
			FROM DUAL;
			
			SELECT CAST(dbms_random.value(00, 59) AS INTEGER) INTO v_min
			FROM DUAL;

			v_tempo := v_hora || ':' || v_min;
			
			SELECT CAST(dbms_random.value(1, 3) AS INTEGER) INTO v_rand
			FROM DUAL;
			
			CASE v_rand
				WHEN 1 THEN v_idTipo := 1;
				WHEN 2 THEN v_idTipo := 3;
				WHEN 3 THEN v_idTipo := 4;
			END CASE;
      
			CASE v_idTipo
				WHEN 1 THEN  v_descricao := 'Gol feito aos ' || v_tempo || ' por ' || v_nomeJogador || ' da ' || p_nomeSelecao || '.';
				WHEN 3 THEN  v_descricao := 'Cartão amarelo para ' || v_nomeJogador || '(' || p_nomeSelecao || ') aos ' || v_tempo || '.';
				WHEN 4 THEN  v_descricao := 'Cartão vermelho para ' || v_nomeJogador || '(' || p_nomeSelecao || ') aos ' || v_tempo || '.';
			END CASE;
			
			v_sql := 'INSERT INTO JogouEm(idJogo, idJogador, titular) VALUES(' || p_idJogo || ', ''' || v_idJogador || ''', ''S'')';
			EXECUTE IMMEDIATE v_sql;
			
			v_sql := 'INSERT INTO Lance(idJogo, tempo, idTipo, descricao) VALUES(' || p_idJogo || ', ''' || v_tempo || ''', ' || v_idTipo || ', ''' || v_descricao || ''')';
			EXECUTE IMMEDIATE v_sql;
			
			v_sql := 'INSERT INTO PartDe(idJogo, tempo, idJogador) VALUES(' || p_idJogo || ', ''' || v_tempo || ''', ' || v_idJogador || ')';
			EXECUTE IMMEDIATE v_sql;
			
		END LOOP;
		
		CLOSE v_cur;
	END criarLances;
	
	PROCEDURE criarJuizes(p_idJogo NUMBER) AS
		v_sql VARCHAR2(1000);
		v_juiz1 NUMBER;
		v_juiz2 NUMBER;
		v_juiz3 NUMBER;
		
		v_cur SYS_REFCURSOR;
	BEGIN
		LOOP
			SELECT * INTO v_juiz1
			FROM (SELECT idPessoa
				  FROM Arbitro
				  ORDER BY dbms_random.value)
			WHERE rownum = 1;
			
			SELECT * INTO v_juiz2
			FROM (SELECT idPessoa
				  FROM Arbitro
				  ORDER BY dbms_random.value)
			WHERE rownum = 1;
			
			SELECT * INTO v_juiz3
			FROM (SELECT idPessoa
				  FROM Arbitro
				  ORDER BY dbms_random.value)
			WHERE rownum = 1;
			
			EXIT WHEN (v_juiz1 <> v_juiz2 AND v_juiz1 <> v_juiz3 AND v_juiz2 <> v_juiz3);
		END LOOP;
		
		v_sql := 'INSERT INTO Apita(idArbitro, idJogo, funcao) VALUES(' || v_juiz1 || ', ' || p_idJogo || ', ''Principal'')';
		EXECUTE IMMEDIATE v_sql;
		
		v_sql := 'INSERT INTO Apita(idArbitro, idJogo, funcao) VALUES(' || v_juiz2 || ', ' || p_idJogo || ', ''Bandeirinha'')';
		EXECUTE IMMEDIATE v_sql;
		
		v_sql := 'INSERT INTO Apita(idArbitro, idJogo, funcao) VALUES(' || v_juiz3 || ', ' || p_idJogo || ', ''Bandeirinha'')';
		EXECUTE IMMEDIATE v_sql;
		
	END criarJuizes;
	
	PROCEDURE criarFaseGrupos AS
		v_nomeNacao VARCHAR2(100);
		
		v_sql VARCHAR2(1000);
		v_loop NUMBER;
		v_aux NUMBER;
		v_aux1 NUMBER;
		
		v_idJogo NUMBER;
		
		TYPE v_grupos IS VARRAY(4) OF VARCHAR2(100);
		v_vetorNacao v_grupos := v_grupos();
		
		v_cur SYS_REFCURSOR;
	BEGIN
		v_vetorNacao.extend;
		v_vetorNacao.extend;
		v_vetorNacao.extend;
		v_vetorNacao.extend;
		FOR v_loop IN 1..8 LOOP
			v_sql := 'SELECT nomeNacao FROM Selecao S WHERE S.idGrupo = ' || v_loop;
			OPEN v_cur FOR v_sql;
			
			v_aux := 1;
			LOOP
				FETCH v_cur INTO v_nomeNacao;
				EXIT WHEN v_cur%NOTFOUND;
				v_vetorNacao(v_aux) := v_nomeNacao;
				v_aux := v_aux + 1;
			END LOOP;
			
			CLOSE v_cur;
			
			v_aux := 1;
			v_aux1 := 1;
			FOR v_aux IN 1..3 LOOP 
				FOR v_aux1 IN v_aux+1..4 LOOP
					IF(v_vetorNacao(v_aux) <> v_vetorNacao(v_aux1)) THEN
						faseGrupos.criarJogo(v_idJogo);
						INSERT INTO Informacao VALUES(v_idJogo, v_vetorNacao(v_aux), v_vetorNacao(v_aux1));
						faseGrupos.criarJuizes(v_idJogo);
						faseGrupos.criarLances(v_idJogo, v_vetorNacao(v_aux));
						faseGrupos.criarLances(v_idJogo, v_vetorNacao(v_aux1));
					END IF;
				END LOOP;
			END LOOP;
			
		END LOOP;
	END criarFaseGrupos;
	
END faseGrupos;
/

DECLARE

BEGIN
	faseGrupos.criarFaseGrupos;
END;
/

--Tipo utilizado para a passagem de atributos no arquivo operacoesSQL
CREATE OR REPLACE TYPE t_atributos IS VARRAY(10) OF VARCHAR2(100);
/
--Tipo utilizado para armazenar os resultados no arquivo tabelaResultGrupos
CREATE OR REPLACE TYPE t_dados IS VARRAY(4) OF NUMBER;
/

CREATE OR REPLACE PACKAGE infoBasicas AS
	
	PROCEDURE getNomeTabela(p_resultado OUT SYS_REFCURSOR);
	PROCEDURE getDadosTabela(p_resultado OUT SYS_REFCURSOR, p_nomeTabela VARCHAR2);
	PROCEDURE getNomesColunas(p_resultado OUT SYS_REFCURSOR, p_nomeTabela VARCHAR2);
	PROCEDURE getPrimaryKey(p_resultado OUT SYS_REFCURSOR, p_nomeTabela VARCHAR2);
	PROCEDURE getForeignKey(p_resultado OUT SYS_REFCURSOR, p_nomeTabela VARCHAR2);
	PROCEDURE getConstraints(p_resultado OUT SYS_REFCURSOR, p_nomeTabela VARCHAR2);
	PROCEDURE getPossiveisValoresFK(p_resultado OUT SYS_REFCURSOR, p_nomeTabela VARCHAR2, p_atributo VARCHAR2);
END infoBasicas;
/
CREATE OR REPLACE PACKAGE BODY infoBasicas AS
	PROCEDURE getNomeTabela(p_resultado OUT SYS_REFCURSOR) AS
		v_sql VARCHAR2(1000);
		BEGIN
			v_sql := 'SELECT table_name FROM user_tables';
			EXECUTE IMMEDIATE v_sql;
			OPEN p_resultado FOR v_sql;
			
			EXCEPTION
			WHEN OTHERS THEN
				raise_application_error(-20001, SQLErrm);
	END getNomeTabela;
	
	PROCEDURE getDadosTabela(p_resultado OUT SYS_REFCURSOR, 
							 p_nomeTabela VARCHAR2) AS
		v_sql VARCHAR2(1000);
		BEGIN
			v_sql := 'SELECT * FROM ' || p_nomeTabela;
			EXECUTE IMMEDIATE v_sql;
			OPEN p_resultado FOR v_sql;
			
			EXCEPTION
			WHEN OTHERS THEN
				raise_application_error(-20001, SQLErrm);
	END getDadosTabela;
	
	PROCEDURE getNomesColunas(p_resultado OUT SYS_REFCURSOR,
							  p_nomeTabela VARCHAR2) AS
		v_sql VARCHAR2(1000);
		BEGIN
			v_sql := 'SELECT COLUMN_ID, COLUMN_NAME, DATA_TYPE, DATA_LENGTH, NULLABLE FROM USER_TAB_COLUMNS WHERE TABLE_NAME = ''' || p_nomeTabela || '''';
			EXECUTE IMMEDIATE v_sql;
			OPEN p_resultado FOR v_sql;
			
			EXCEPTION
			WHEN OTHERS THEN
				raise_application_error(-20001, SQLErrm);
	END getNomesColunas;

	PROCEDURE getPrimaryKey(p_resultado OUT SYS_REFCURSOR, 
							p_nomeTabela VARCHAR2) AS
		v_sql VARCHAR2(1000);
		BEGIN
			v_sql := 'SELECT USER_CONS_COLUMNS.COLUMN_NAME AS COLUMN_NAME FROM USER_CONSTRAINTS JOIN USER_CONS_COLUMNS ON (USER_CONSTRAINTS.CONSTRAINT_NAME = USER_CONS_COLUMNS.CONSTRAINT_NAME) WHERE CONSTRAINT_TYPE = ''P'' AND USER_CONSTRAINTS.TABLE_NAME = ''' || p_nomeTabela || '''';
			EXECUTE IMMEDIATE v_sql;
			OPEN p_resultado FOR v_sql;
			
			EXCEPTION
			WHEN OTHERS THEN
				raise_application_error(-20001, SQLErrm);
	END getPrimaryKey;
	
	PROCEDURE getForeignKey(p_resultado OUT SYS_REFCURSOR,
							p_nomeTabela VARCHAR2) AS
		v_sql VARCHAR2(1000);
		BEGIN
			v_sql := 'SELECT DISTINCT ucc.COLUMN_NAME AS COLUMN_NAME, ucc2.COLUMN_NAME AS FK_COLUMN_NAME, ucc2.table_name AS FK_TABLE_NAME FROM USER_CONS_COLUMNS ucc JOIN USER_CONSTRAINTS uc ON ucc.OWNER = uc.OWNER AND ucc.CONSTRAINT_NAME = uc.CONSTRAINT_NAME JOIN USER_CONSTRAINTS uc_pk ON uc.R_OWNER = uc_pk.OWNER AND uc.CONSTRAINT_NAME = uc_pk.CONSTRAINT_NAME JOIN USER_CONS_COLUMNS ucc2 ON ucc2.CONSTRAINT_NAME = uc.R_CONSTRAINT_NAME WHERE ucc.TABLE_NAME = ''' || p_nomeTabela || '''';
			EXECUTE IMMEDIATE v_sql;
			OPEN p_resultado FOR v_sql;
			
			EXCEPTION
			WHEN OTHERS THEN
				raise_application_error(-20001, SQLErrm);
	END getForeignKey;
	
	PROCEDURE getConstraints(p_resultado OUT SYS_REFCURSOR,
							 p_nomeTabela VARCHAR2) AS
		v_sql VARCHAR2(1000);
		BEGIN
			v_sql := 'SELECT SEARCH_CONDITION FROM USER_CONSTRAINTS WHERE TABLE_NAME = ''' || p_nomeTabela || ''' AND CONSTRAINT_TYPE = ''C''';
			EXECUTE IMMEDIATE v_sql;
			OPEN p_resultado FOR v_sql;
			
			EXCEPTION
			WHEN OTHERS THEN
				raise_application_error(-20001, SQLErrm);
	END getConstraints;	
	
	PROCEDURE getPossiveisValoresFK(p_resultado OUT SYS_REFCURSOR,
							 p_nomeTabela VARCHAR2, p_atributo VARCHAR2) AS
		v_sql VARCHAR2(1000);
		BEGIN
			v_sql := 'SELECT DISTINCT ' || p_atributo  ||' FROM ' || p_nomeTabela|| ' ORDER BY ' || p_atributo;
			EXECUTE IMMEDIATE v_sql;
			OPEN p_resultado FOR v_sql;
			
			EXCEPTION
			WHEN OTHERS THEN
				raise_application_error(-20001, SQLErrm);
	END getPossiveisValoresFK;
	
END infoBasicas;
/

CREATE OR REPLACE PACKAGE operacoesSQL AS
		
	--Procedure que insere dados numa tabela.
	PROCEDURE insertTabela(p_nomeTabela VARCHAR2,
						   p_atributos t_atributos,
						   p_valorAtributos t_atributos);
	
	--Procedure que deleta dados de uma tabela.
	PROCEDURE deleteTabela(p_nomeTabela VARCHAR2,
						   p_atributos t_atributos,
						   p_valorAtributos t_atributos);
							  
	--Procedure que atualiza dados de uma tabela.
	PROCEDURE updateTabela(p_nomeTabela VARCHAR2,
						   p_atributos t_atributos,
						   p_valorAtributos t_atributos,
						   p_atributoWhere VARCHAR2,
						   p_valorAtributoWhere VARCHAR2);
							
	--Procedure que seleciona dados de uma tabela.
	PROCEDURE selectTabela(p_nomeTabela VARCHAR2,
						   p_atributos t_atributos,
						   p_resultado OUT SYS_REFCURSOR);
END operacoesSQL;
/
CREATE OR REPLACE PACKAGE BODY operacoesSQL AS
	PROCEDURE insertTabela(p_nomeTabela VARCHAR2,
						   p_atributos t_atributos,
						   p_valorAtributos t_atributos) AS
		v_aux NUMBER;
		v_sql VARCHAR(1000);
		
		exc_commandNotExec EXCEPTION;
		
	BEGIN
		v_sql := 'INSERT INTO ' || p_nomeTabela || ' (';
		v_aux := 1;
		LOOP
			v_sql := v_sql || p_atributos(v_aux);
			EXIT WHEN v_aux = p_atributos.COUNT;
			v_sql := v_sql || ', ';
			v_aux := v_aux + 1;
		END LOOP;
		v_sql := v_sql || ') VALUES (';
		v_aux := 1;
		LOOP
			v_sql := v_sql || p_valorAtributos(v_aux);
			EXIT WHEN v_aux = p_valorAtributos.COUNT;
			v_sql := v_sql || ',';
			v_aux := v_aux + 1;
		END LOOP;
		v_sql := v_sql || ')';
		dbms_output.put_line(v_sql);
		EXECUTE IMMEDIATE v_sql;
		IF(SQL%FOUND) THEN
			dbms_output.put_line('Comando INSERT bem-sucedido.');
		ELSE
			raise exc_commandNotExec;
		END IF;
			
		EXCEPTION
		WHEN exc_commandNotExec THEN
			raise_application_error(-20101, 'Comando não executado. Tente novamente.');
		WHEN OTHERS THEN
			raise_application_error(-20103, SQLErrm);
	END;

	PROCEDURE deleteTabela(p_nomeTabela VARCHAR2,
						   p_atributos t_atributos,
						   p_valorAtributos t_atributos) AS
		v_aux NUMBER;
		v_sql VARCHAR(1000);
		
		exc_commandNotExec EXCEPTION;
		exc_notEnoughValues EXCEPTION;

	BEGIN
		IF(p_atributos.COUNT < p_valorAtributos.COUNT) THEN
			raise exc_notEnoughValues;
		END IF;

		v_sql := 'DELETE FROM ' || p_nomeTabela || ' WHERE ';
		v_aux := 1;
		LOOP
			v_sql := v_sql || '' || p_atributos(v_aux) || ' = ' || '''' || p_valorAtributos(v_aux) || '''';
			EXIT WHEN v_aux = p_atributos.COUNT;
			v_sql := v_sql || ',';
			v_aux := v_aux + 1;
		END LOOP;
		dbms_output.put_line(v_sql);
		EXECUTE IMMEDIATE v_sql;
		IF(SQL%FOUND) THEN
			dbms_output.put_line('Comando DELETE bem-sucedido.');
		ELSE
			raise exc_commandNotExec;
		END IF;
		
		EXCEPTION
		WHEN exc_commandNotExec THEN
			raise_application_error(-20101, 'Comando não executado. Tente novamente.');
		WHEN exc_notEnoughValues THEN
			raise_application_error(-20102, 'Existem mais atributos que valores. Tente novamente.');
		WHEN OTHERS THEN
			raise_application_error(-20103, SQLErrm);
	END;

	PROCEDURE updateTabela(p_nomeTabela VARCHAR2,
						   p_atributos t_atributos,
						   p_valorAtributos t_atributos,
						   p_atributoWhere VARCHAR2,
						   p_valorAtributoWhere VARCHAR2) AS
		v_aux NUMBER;
		v_sql VARCHAR(1000);
		
		exc_commandNotExec EXCEPTION;
		exc_notEnoughValues EXCEPTION;
		
	BEGIN
		IF(p_atributos.COUNT < p_valorAtributos.COUNT) THEN
			raise exc_notEnoughValues;
		END IF;
		
		v_sql := 'UPDATE ' || p_nomeTabela || ' SET ';
		v_aux := 1;
		LOOP
			v_sql := v_sql || '' || p_atributos(v_aux) || ' = ' || p_valorAtributos(v_aux);
			EXIT WHEN v_aux = p_atributos.COUNT;
			v_sql := v_sql || ',';
			v_aux := v_aux + 1;
		END LOOP;
		v_sql := v_sql || ' WHERE ' || p_atributoWhere || ' = ' || p_valorAtributoWhere;
		dbms_output.put_line(v_sql);
		EXECUTE IMMEDIATE v_sql;
		IF(SQL%FOUND) THEN
			dbms_output.put_line('Comando UPDATE bem-sucedido.');
		ELSE
			raise exc_commandNotExec;
		END IF;
		
		EXCEPTION
		WHEN exc_commandNotExec THEN
			raise_application_error(-20101, 'Comando não executado. Tente novamente.');
		WHEN exc_notEnoughValues THEN
			raise_application_error(-20102, 'Existem mais atributos que valores. Tente novamente.');
		WHEN OTHERS THEN
			raise_application_error(-20103, SQLErrm);
	END;

	PROCEDURE selectTabela(p_nomeTabela VARCHAR2,
						   p_atributos t_atributos,
						   p_resultado OUT SYS_REFCURSOR) AS
		v_aux NUMBER;
		v_sql VARCHAR(1000);
		
		exc_commandNotExec EXCEPTION;
		
	BEGIN
		v_sql := 'SELECT ';
		v_aux := 1;
		LOOP
			v_sql := v_sql || '' || p_atributos(v_aux) || '';
			EXIT WHEN v_aux = p_atributos.COUNT;
			v_sql := v_sql || ', ';
			v_aux := v_aux + 1;
		END LOOP;
		v_sql := v_sql || ' FROM ' || p_nomeTabela;
		dbms_output.put_line(v_sql);
		EXECUTE IMMEDIATE v_sql;
		OPEN p_resultado FOR v_sql;
		
		EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20103, SQLErrm);
	END;
END operacoesSQL;
/

CREATE OR REPLACE PACKAGE nacaoBandeiras AS
	
	PROCEDURE insertNacao(p_dados BLOB, p_nomeNacao IN VARCHAR2);
	PROCEDURE setBandeira(p_dados BLOB, p_nomeNacao IN VARCHAR2);
	PROCEDURE getBandeira(p_dados OUT BLOB, p_nomeNacao IN VARCHAR2);
	
END nacaoBandeiras;
/
CREATE OR REPLACE PACKAGE BODY nacaoBandeiras AS
	
	PROCEDURE insertNacao(p_dados BLOB, p_nomeNacao VARCHAR2) AS
    exc_comandoNaoExecutado EXCEPTION;
    BEGIN
    
      INSERT INTO Nacao(nome, bandeira) VALUES(p_nomeNacao, p_dados);
      
      IF(SQL%NOTFOUND) THEN
        RAISE exc_comandoNaoExecutado;
      END IF;
    
    EXCEPTION
      WHEN exc_comandoNaoExecutado THEN
        dbms_output.put_line('Comando não executado.');
      WHEN OTHERS THEN
        raise_application_error(-20101, SQLErrm);
	END insertNacao;
	
	PROCEDURE setBandeira(p_dados BLOB, p_nomeNacao VARCHAR2) AS
		v_sql VARCHAR2(1000);
		exc_comandoNaoExecutado EXCEPTION;
	BEGIN
	  
		  UPDATE Nacao
		  SET Nacao.bandeira = p_dados
		  WHERE Nacao.nome = p_nomeNacao;
		  
		  IF(SQL%NOTFOUND) THEN
			RAISE exc_comandoNaoExecutado;
		  END IF;
	  
		EXCEPTION
		  WHEN exc_comandoNaoExecutado THEN
			dbms_output.put_line('Comando não executado.');
		  WHEN OTHERS THEN
			raise_application_error(-20101, SQLErrm);
	END setBandeira;
  
	PROCEDURE getBandeira(p_dados OUT BLOB, p_nomeNacao VARCHAR2) AS
		v_sql VARCHAR2(1000);
	BEGIN
			SELECT bandeira INTO p_dados
			FROM Nacao N
			WHERE N.nome = p_nomeNacao;
		EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20101, SQLErrm);
	END getBandeira;
	
END nacaoBandeiras;
/

CREATE OR REPLACE PACKAGE calculosEstatisticos AS
	FUNCTION porcAproveitamento(p_selecao VARCHAR2) RETURN NUMBER;
	FUNCTION mediaGols(p_selecao VARCHAR2) RETURN NUMBER;
	FUNCTION varianciaGols(p_selecao VARCHAR2) RETURN NUMBER;
	FUNCTION covariancia(p_selecao VARCHAR2,
						 p_selecao1 VARCHAR2) RETURN NUMBER;
	FUNCTION correlacao(p_selecao VARCHAR2,
						p_selecao1 VARCHAR2) RETURN NUMBER;

END calculosEstatisticos;
/
CREATE OR REPLACE PACKAGE BODY calculosEstatisticos AS

	FUNCTION porcAproveitamento(p_selecao VARCHAR2) RETURN NUMBER AS
		v_gols1 NUMBER;
		v_gols2 NUMBER;
		v_vitoria NUMBER;
		v_empate  NUMBER;
		v_numJogos NUMBER;
		v_totalPontos NUMBER;
		v_maxPontos NUMBER;
		v_porcAprov NUMBER;
		
		v_idJogo VARCHAR2(100);
		v_selecao1 VARCHAR2(100);
		v_selecao2 VARCHAR2(100);
		
		CURSOR c_jogos IS SELECT idJogo, nomeSelecao1, nomeSelecao2 
						  FROM Informacao Inf
						  JOIN Jogo Jg ON Jg.id = Inf.idJogo
						  WHERE (Inf.nomeSelecao1 = p_selecao OR Inf.nomeSelecao2 = p_selecao) AND (Jg.fase = 'G1' OR Jg.fase = 'G2' OR Jg.fase = 'G3');
	BEGIN
		v_vitoria := 0;
		v_empate := 0;
		OPEN c_jogos;
		LOOP
			FETCH c_jogos INTO v_idJogo, v_selecao1, v_selecao2;
				v_numJogos := c_jogos%ROWCOUNT;
				
				-- count gols da selecao 1
				SELECT count(*) INTO v_gols1
				FROM Lance L
				JOIN PartDe P ON P.idJogo = L.idJogo AND P.tempo = L.tempo
				JOIN Jogador J ON J.idPessoa = P.idJogador
				WHERE L.idJogo = v_idJogo AND J.nomeSelecao = v_selecao1;
				
				-- count gols da selecao 2
				SELECT count(*) INTO v_gols2
				FROM Lance L
				JOIN PartDe P ON P.idJogo = L.idJogo AND P.tempo = L.tempo
				JOIN Jogador J ON J.idPessoa = P.idJogador
				WHERE L.idJogo = v_idJogo AND J.nomeSelecao = v_selecao2;
				
				IF(v_gols1 > v_gols2 AND v_selecao1 = p_selecao) THEN
					v_vitoria := v_vitoria + 1;
				ELSIF(v_gols1 < v_gols2 AND v_selecao2 = p_selecao) THEN
					v_vitoria := v_vitoria + 1;
				ELSIF(v_gols1 = v_gols2) THEN
					v_empate := v_empate + 1;
				END IF;
			EXIT WHEN c_jogos%NOTFOUND;
		END LOOP;
		-- pontos totais
		v_totalPontos := (v_vitoria * 3) + v_empate;
		v_maxPontos := v_numJogos * 3;
		
		IF(v_maxPontos <> 0) THEN
			v_porcAprov := (v_totalPontos / v_maxPontos) * 100;
		ELSE
			v_porcAprov := 0;
		END IF;	
		
		CLOSE c_jogos;
		RETURN v_porcAprov;
		
	  EXCEPTION 
		WHEN OTHERS THEN
			dbms_output.put_line(SQLErrm);
	END;

	FUNCTION mediaGols(p_selecao VARCHAR2) RETURN NUMBER AS
		v_idJogo NUMBER;	
		v_numGols NUMBER;
		v_numPartidas NUMBER;
		v_mediaGols	NUMBER;
	BEGIN 
		SELECT count(*) INTO v_numPartidas
		FROM Informacao Inf
		JOIN Jogo Jg ON Jg.id = Inf.idJogo
		WHERE (Inf.nomeSelecao1 = p_selecao OR Inf.nomeSelecao2 = p_selecao) AND (Jg.fase = 'G1' OR Jg.fase = 'G2' OR Jg.fase = 'G3');
		
		SELECT count(*) INTO v_numGols
		FROM Lance L
		JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
		JOIN Jogador J ON J.idPessoa = Par.idJogador
		JOIN Jogo Jg ON Jg.id = L.idJogo
		WHERE L.idTipo = 1 AND J.nomeSelecao = p_selecao AND (Jg.fase = 'G1' OR Jg.fase = 'G2' OR Jg.fase = 'G3');
		
		IF(v_numPartidas = 0) THEN
			RETURN 0;
		END IF;
		
		v_mediaGols := v_numGols / v_numPartidas;
		RETURN v_mediaGols;
	END;

	FUNCTION varianciaGols(p_selecao VARCHAR2) RETURN NUMBER AS
		v_idJogo NUMBER;  
		n NUMBER; -- número de partidas
		v_mediaGols	NUMBER;
		v_numGols NUMBER;
		v_somatoria NUMBER;
		v_total NUMBER;
		
		CURSOR c_jogos IS SELECT idJogo 
						  FROM Informacao Inf 
						  JOIN Jogo Jg ON Jg.id = Inf.idJogo 
						  WHERE (Inf.nomeSelecao1 = p_selecao OR Inf.nomeSelecao2 = p_selecao) AND (Jg.fase = 'G1' OR Jg.fase = 'G2' OR Jg.fase = 'G3');
	BEGIN
		v_somatoria := 0;
		v_mediaGols := MEDIAGOLS(p_selecao);
		v_total := 0;
		n := 0;
		
		OPEN c_jogos;
		LOOP
			FETCH c_jogos INTO v_idJogo;
			EXIT WHEN c_jogos%NOTFOUND; 
			n := c_jogos%ROWCOUNT;
			
			SELECT count(*) INTO v_numGols 
			FROM Lance L 
			JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo 
			JOIN Jogador J ON J.idPessoa = Par.idJogador
			JOIN Jogo Jg ON Jg.id = L.idJogo
			WHERE L.idTipo = 1 AND L.idJogo = v_idJogo AND J.nomeSelecao = p_selecao AND (Jg.fase = 'G1' OR Jg.fase = 'G2' OR Jg.fase = 'G3');
			
			v_somatoria := v_somatoria + (POWER(v_numGols - v_mediaGols, 2));
		END LOOP; 
		CLOSE c_jogos;
		
		IF(n = 1) THEN
			RETURN 0;
		END IF;
		
		v_total := v_somatoria / (n - 1);
		RETURN v_total;
	END;
	
	FUNCTION covariancia(p_selecao VARCHAR2,
						 p_selecao1 VARCHAR2) RETURN NUMBER AS
						   
		v_idJogo NUMBER;  
		v_idJogo1 NUMBER;
		
		n NUMBER; -- número de partidas Seleção 1
		n1 NUMBER; -- número de partidas Seleção 2
		
		v_mediaGols	NUMBER;
		v_numGols NUMBER;
		
		v_mediaGols1 NUMBER;
		v_numGols1 NUMBER;
		
		v_somatoria NUMBER;
		v_total NUMBER;
		
		CURSOR c_jogos IS SELECT idJogo 
						  FROM Informacao Inf 
						  JOIN Jogo Jg ON Jg.id = Inf.idJogo 
						  WHERE Inf.nomeSelecao1 = p_selecao OR Inf.nomeSelecao2 = p_selecao;
		
		CURSOR c_jogos1 IS SELECT idJogo
						   FROM Informacao Inf
						   JOIN Jogo Jg ON Jg.id = Inf.idJogo
						   WHERE Inf.nomeSelecao1 = p_selecao1 OR Inf.nomeSelecao2 = p_selecao1;
	BEGIN
		v_somatoria := 0;
		v_mediaGols := mediaGols(p_selecao);
		v_mediaGols1 := mediaGols(p_selecao1);
		
		
		OPEN c_jogos;
		OPEN c_jogos1;
		LOOP
			FETCH c_jogos INTO v_idJogo;
			
			FETCH c_jogos1 INTO v_idJogo1;
			
			EXIT WHEN c_jogos%NOTFOUND AND c_jogos1%NOTFOUND; 
			
			n := c_jogos%ROWCOUNT;
			n1 := c_jogos1%ROWCOUNT;
					
			SELECT count(*) INTO v_numGols 
			FROM Lance L 
			JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo 
			JOIN Jogador J ON J.idPessoa = Par.idJogador 
			WHERE L.idTipo = 1 AND L.idJogo = v_idJogo AND J.nomeSelecao = p_selecao;  
			
			SELECT count(*) INTO v_numGols1
			FROM Lance L
			JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
			JOIN Jogador J ON J.idPessoa = Par.idJogador
			WHERE L.idTipo = 1 AND L.idJogo = v_idJogo1 AND J.nomeSelecao = p_selecao1;
			
			IF(v_numGols - v_mediaGols <> 0 AND v_numGols1 - v_mediaGols1 <> 0) THEN
			  v_somatoria := v_somatoria + ((v_numGols - v_mediaGols) * (v_numGols1 - v_mediaGols1));
			ELSIF(v_numGols - v_mediaGols = 0) THEN
			  v_somatoria := v_somatoria + ((v_numGols1 - v_mediaGols1));
			ELSE
			  v_somatoria := v_somatoria + ((v_numGols - v_mediaGols));
			END IF;
			
		END LOOP; 
		CLOSE c_jogos;
		CLOSE c_jogos1;
		
		IF((n + n1) = 1) THEN
			RETURN 0;
		END IF;
		
		v_total := v_somatoria / ((n + n1) - 1);
		RETURN v_total;
	END;

	FUNCTION correlacao(p_selecao VARCHAR2,
						p_selecao1 VARCHAR2) RETURN NUMBER AS
						   
		v_idJogo NUMBER;  
		v_idJogo1 NUMBER;
		
		n NUMBER; -- número de partidas Seleção 1
		n1 NUMBER; -- número de partidas Seleção 2
		
		v_mediaGols	NUMBER;
		v_numGols NUMBER;
		v_variancia NUMBER;
		
		v_mediaGols1 NUMBER;
		v_numGols1 NUMBER;
		v_variancia1 NUMBER;
		
		v_somatoria NUMBER;
		v_total NUMBER;
		
		CURSOR c_jogos IS SELECT idJogo 
						  FROM Informacao Inf 
						  JOIN Jogo Jg ON Jg.id = Inf.idJogo 
						  WHERE Inf.nomeSelecao1 = p_selecao OR Inf.nomeSelecao2 = p_selecao;
		
		CURSOR c_jogos1 IS SELECT idJogo
						   FROM Informacao Inf
						   JOIN Jogo Jg ON Jg.id = Inf.idJogo
						   WHERE Inf.nomeSelecao1 = p_selecao1 OR Inf.nomeSelecao2 = p_selecao1;
	BEGIN
		v_somatoria := 0;
		v_mediaGols := mediaGols(p_selecao);
		v_mediaGols1 := mediaGols(p_selecao1);
		v_variancia := varianciaGols(p_selecao);
		v_variancia1 := varianciaGols(p_selecao1);
		
		OPEN c_jogos;
		OPEN c_jogos1;
		LOOP
			FETCH c_jogos INTO v_idJogo;
			FETCH c_jogos1 INTO v_idJogo1;	
			
			EXIT WHEN c_jogos%NOTFOUND AND c_jogos1%NOTFOUND; 
			
			n := c_jogos%ROWCOUNT;
			n1 := c_jogos1%ROWCOUNT;
			
			SELECT count(*) INTO v_numGols 
			FROM Lance L 
			JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo 
			JOIN Jogador J ON J.idPessoa = Par.idJogador 
			WHERE L.idTipo = 1 AND L.idJogo = v_idJogo AND J.nomeSelecao = p_selecao;  
			
			SELECT count(*) INTO v_numGols1
			FROM Lance L
			JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
			JOIN Jogador J ON J.idPessoa = Par.idJogador
			WHERE L.idTipo = 1 AND L.idJogo = v_idJogo1 AND J.nomeSelecao = p_selecao1;
		
			IF(c_jogos%FOUND AND c_jogos1%FOUND) THEN
				v_somatoria := v_somatoria + ((v_numGols - v_mediaGols) * (v_numGols1 - v_mediaGols1));
			ELSIF(c_jogos1%FOUND) THEN
			  v_somatoria := v_somatoria + ((v_numGols1 - v_mediaGols1));
			ELSIF(c_jogos%FOUND) THEN
			  v_somatoria := v_somatoria + ((v_numGols - v_mediaGols));
			 END IF;
		END LOOP; 
		CLOSE c_jogos;
		CLOSE c_jogos1;
		
		IF((v_variancia = 0) OR (v_variancia1 = 0)) THEN
			RETURN 0;
		END IF;
		
		v_total := v_somatoria / (sqrt(v_variancia) * sqrt(v_variancia1));
		RETURN v_total;
	END;
	
END calculosEstatisticos;
/

CREATE OR REPLACE PROCEDURE getResumoJogo(p_idJogo NUMBER,
										  p_resumo OUT VARCHAR) AS
	v_resumo VARCHAR(3000);
	v_aux NUMBER;
	
	v_sql VARCHAR(1000);
	v_totalCartAm NUMBER;
	v_totalCartVerm NUMBER;
	
	v_fase CHAR(2);
	v_nomeFase VARCHAR2(100);
	v_selecao1 VARCHAR2(100);
	v_selecao2 VARCHAR2(100);
	v_grupo NUMBER;
	v_golsSelecao1 NUMBER;
	v_golsSelecao2 NUMBER;
	v_nomeJogador VARCHAR2(100);
	v_estadio VARCHAR2(100);
	v_data DATE;
	v_numCartAmSelecao1 NUMBER;
	v_numCartAmSelecao2 NUMBER;
	v_numCartVermSelecao1 NUMBER;
	v_numCartVermSelecao2 NUMBER;
	v_numPatr NUMBER;
	v_nomeJuiz VARCHAR2(100);
	v_numBandeirinhas NUMBER;
	v_nomePatr VARCHAR2(100);

	v_cur SYS_REFCURSOR;

BEGIN
	SELECT Jg.fase, E.nome INTO v_fase, v_estadio
	FROM Jogo Jg
	JOIN Estadio E ON E.id = Jg.idEstadio
	WHERE Jg.id = p_idJogo;
	
	SELECT nomeSelecao1, nomeSelecao2 INTO v_selecao1, v_selecao2
	FROM Informacao Inf
	WHERE Inf.idJogo = p_idJogo;
	
	SELECT idGrupo INTO v_grupo
	FROM Selecao S
	WHERE S.nomeNacao = v_selecao1;
	
	SELECT DISTINCT COUNT(*) INTO v_golsSelecao1
	FROM Lance L
	JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
	JOIN Jogador J ON J.idPessoa = Par.idJogador
	WHERE L.idJogo = p_idJogo AND L.idTipo = 1 AND J.nomeSelecao = v_selecao1;
	
	SELECT DISTINCT COUNT(*) INTO v_golsSelecao2
	FROM Lance L
	JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
	JOIN Jogador J ON J.idPessoa = Par.idJogador
	WHERE L.idJogo = p_idJogo AND L.idTipo = 1 AND J.nomeSelecao = v_selecao2;
	
	SELECT dt INTO v_data
	FROM Jogo Jg
	WHERE Jg.id = p_idJogo;
	
	IF(v_fase = 'O') THEN
		v_nomeFase := 'oitavas-de-final';
	ELSIF(v_fase = 'Q') THEN
		v_nomeFase := 'quartas-de-final';
	ELSIF(v_fase = 'S') THEN
		v_nomeFase := 'semi-final';
	ELSIF(v_fase = 'F') THEN
		v_nomeFase := 'final';
	END IF;
	
	IF(v_fase = 'G1' OR v_fase = 'G2' OR v_fase = 'G3') THEN
		v_resumo := 'Partida ' || p_idJogo || ' realizada na fase de grupos pelo Grupo ' || v_grupo || ', terminou com o resultado ' || v_selecao1 || ' ' || v_golsSelecao1 || ' x ' || v_golsSelecao2 || ' ' || v_selecao2 || ', no estádio ' || v_estadio || ' no dia ' || to_char(v_data, 'dd/mm/yy') || '. ';
	ELSE
		v_resumo := 'Partida ' || p_idJogo || ' realizada na fase ' || v_nomeFase || ', terminou com o resultado ' || v_selecao1 || ' ' || v_golsSelecao1 || ' x ' || v_golsSelecao2 || ' ' || v_selecao2 || ', no estádio ' || v_estadio || ' no dia ' || to_char(v_data, 'dd/mm/yy') || '. ';
	END IF;
	
	IF(v_golsSelecao1 > 0) THEN
		v_sql := 'SELECT P.nome FROM Pessoa P JOIN Jogador J ON J.idPessoa = P.id JOIN PartDe Par ON Par.idJogador = J.idPessoa JOIN Lance L ON L.idJogo = Par.idJogo AND L.tempo = Par.tempo WHERE J.nomeSelecao = ''' || v_selecao1 || ''' AND L.idJogo = ' || p_idJogo || ' AND L.idTipo = 1';
		v_aux := v_golsSelecao1;
		OPEN v_cur FOR v_sql;
		LOOP
			v_aux := v_aux - 1;
			FETCH v_cur INTO v_nomeJogador;
			EXIT WHEN v_cur%NOTFOUND;
			v_resumo := v_resumo || v_nomeJogador || ' marcou para ' || v_selecao1;
			EXIT WHEN v_aux = 0;
			v_resumo := v_resumo || ', ';
		END LOOP;
		
		CLOSE v_cur;
	END IF;
	
	IF(v_golsSelecao2 > 0) THEN
		IF(v_golsSelecao1 > 0) THEN
			v_resumo := v_resumo || ', ';
		END IF;
		v_sql := 'SELECT P.nome FROM Pessoa P JOIN Jogador J ON J.idPessoa = P.id JOIN PartDe Par ON Par.idJogador = J.idPessoa JOIN Lance L ON L.idJogo = Par.idJogo AND L.tempo = Par.tempo WHERE J.nomeSelecao = ''' || v_selecao2 || ''' AND L.idJogo = ' || p_idJogo || ' AND L.idTipo = 1';
		v_aux := v_golsSelecao2;
		OPEN v_cur FOR v_sql;
		
		LOOP
			v_aux := v_aux - 1;
			FETCH v_cur INTO v_nomeJogador;
			EXIT WHEN v_cur%NOTFOUND;
			v_resumo := v_resumo || v_nomeJogador || ' marcou para ' || v_selecao2;
			EXIT WHEN v_aux = 0;
			v_resumo := v_resumo || ', ';
		END LOOP;
		
		CLOSE v_cur;
	END IF;
	
	IF((v_golsSelecao1 <> 0) OR (v_golsSelecao2 <> 0)) THEN
		v_resumo := v_resumo || '. ';
	END IF;
	
	SELECT DISTINCT COUNT(*) INTO v_totalCartAm
	FROM Lance L
	JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
	JOIN Jogador J ON J.idPessoa = Par.idJogador
	WHERE L.idJogo = p_idJogo AND L.idTipo = 3;
	
	IF(v_totalCartAm > 0) THEN
		v_resumo := v_resumo || 'Receberam cartões amarelos ';
	END IF;
	
	SELECT DISTINCT COUNT(*) INTO v_numCartAmSelecao1
	FROM Lance L
	JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
	JOIN Jogador J ON J.idPessoa = Par.idJogador
	WHERE L.idJogo = p_idJogo AND L.idTipo = 3 AND J.nomeSelecao = v_selecao1;
	
	IF(v_numCartAmSelecao1 > 0) THEN
		v_sql := 'SELECT P.nome FROM Pessoa P JOIN Jogador J ON J.idPessoa = P.id JOIN PartDe Par ON Par.idJogador = J.idPessoa JOIN Lance L ON L.idJogo = Par.idJogo AND L.tempo = Par.tempo WHERE J.nomeSelecao = ''' || v_selecao1 || ''' AND L.idJogo = ' || p_idJogo || ' AND L.idTipo = 3';
		v_aux := v_numCartAmSelecao1;
		OPEN v_cur FOR v_sql;
		
		LOOP
			v_aux := v_aux - 1;
			FETCH v_cur INTO v_nomeJogador;
			EXIT WHEN v_cur%NOTFOUND;
			v_resumo := v_resumo || v_nomeJogador || ' (' || v_selecao1 || ')';
			EXIT WHEN v_aux = 0;
			v_resumo := v_resumo || ', ';
		END LOOP;
		
		CLOSE v_cur;
	END IF;
	
	SELECT DISTINCT COUNT(*) INTO v_numCartAmSelecao2
	FROM Lance L
	JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
	JOIN Jogador J ON J.idPessoa = Par.idJogador
	WHERE L.idJogo = p_idJogo AND L.idTipo = 3 AND J.nomeSelecao = v_selecao2;
	
	IF(v_numCartAmSelecao2 > 0) THEN
		IF(v_numCartAmSelecao1 > 0) THEN
			v_resumo := v_resumo || ', ';
		END IF;
		v_sql := 'SELECT P.nome FROM Pessoa P JOIN Jogador J ON J.idPessoa = P.id JOIN PartDe Par ON Par.idJogador = J.idPessoa JOIN Lance L ON L.idJogo = Par.idJogo AND L.tempo = Par.tempo WHERE J.nomeSelecao = ''' || v_selecao2 || ''' AND L.idJogo = ' || p_idJogo || ' AND L.idTipo = 3';
		v_aux := v_numCartAmSelecao2;
		OPEN v_cur FOR v_sql;
		
		LOOP
			v_aux := v_aux - 1;
			FETCH v_cur INTO v_nomeJogador;
			EXIT WHEN v_cur%NOTFOUND;
			v_resumo := v_resumo || v_nomeJogador || ' (' || v_selecao2 || ')';
			EXIT WHEN v_aux = 0;
			v_resumo := v_resumo || ', ';
		END LOOP;
		
		CLOSE v_cur;
	END IF;
	
	IF(v_totalCartAm <> 0) THEN
		v_resumo := v_resumo || '. ';
	END IF;
	
	SELECT DISTINCT COUNT(*) INTO v_totalCartVerm
	FROM Lance L
	JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
	JOIN Jogador J ON J.idPessoa = Par.idJogador
	WHERE L.idJogo = p_idJogo AND L.idTipo = 4 AND J.nomeSelecao = v_selecao1;
	
	IF(v_totalCartVerm > 0) THEN
		v_resumo := v_resumo || 'Receberam cartões vermelhos ';
 	END IF;
	
	IF(v_numCartVermSelecao1 > 0) THEN
		v_sql := 'SELECT P.nome FROM Pessoa P JOIN Jogador J ON J.idPessoa = P.id JOIN PartDe Par ON Par.idJogador = J.idPessoa JOIN Lance L ON L.idJogo = Par.idJogo AND L.tempo = Par.tempo WHERE J.nomeSelecao = ''' || v_selecao1 || ''' AND L.idJogo = ' || p_idJogo || ' AND L.idTipo = 4';
		v_aux := v_numCartVermSelecao1;
		OPEN v_cur FOR v_sql;
		
		LOOP
			v_aux := v_aux - 1;
			FETCH v_cur INTO v_nomeJogador;
			EXIT WHEN v_cur%NOTFOUND;
			v_resumo := v_resumo || v_nomeJogador || ' (' || v_selecao2 || ')';
			EXIT WHEN v_aux = 0;
			v_resumo := v_resumo || ', ';
		END LOOP;
		
		CLOSE v_cur;
	END IF;
	
	SELECT DISTINCT COUNT(*) INTO v_numCartVermSelecao2
	FROM Lance L
	JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
	JOIN Jogador J ON J.idPessoa = Par.idJogador
	WHERE L.idJogo = p_idJogo AND L.idTipo = 4 AND J.nomeSelecao = v_selecao2;
	
	IF(v_numCartVermSelecao2 > 0) THEN
		IF(v_numCartVermSelecao1 > 0) THEN
			v_resumo := v_resumo || ', ';
		END IF;
		v_sql := 'SELECT P.nome FROM Pessoa P JOIN Jogador J ON J.idPessoa = P.id JOIN PartDe Par ON Par.idJogador = J.idPessoa JOIN Lance L ON L.idJogo = Par.idJogo AND L.tempo = Par.tempo WHERE J.nomeSelecao = ''' || v_selecao2 || ''' AND L.idJogo = ' || p_idJogo || ' AND L.idTipo = 4';
		v_aux := v_numCartVermSelecao2;
		OPEN v_cur FOR v_sql;
		
		LOOP
			v_aux := v_aux - 1;
			FETCH v_cur INTO v_nomeJogador;
			EXIT WHEN v_cur%NOTFOUND;
			v_resumo := v_resumo || v_nomeJogador || ' (' || v_selecao2 || ')';
			EXIT WHEN v_aux = 0;
			v_resumo := v_resumo || ', ';
		END LOOP;
		
		CLOSE v_cur;
	END IF;
	
	IF(v_totalCartVerm <> 0) THEN
		v_resumo := v_resumo || '.';
	END IF;
	
	SELECT DISTINCT COUNT(*) INTO v_numPatr
	FROM DivEm D
	WHERE D.idJogo = p_idJogo;

	IF(v_numPatr > 0) THEN
		v_resumo := v_resumo || ' Patrocinaram a partida ';
		v_sql := 'SELECT nome FROM Patrocinador P JOIN DivEm D ON D.idPatrocinador = P.id WHERE D.idJogo = ' || p_idJogo;
		v_aux := v_numPatr;
		OPEN v_cur FOR v_sql;
		
		LOOP
			v_aux := v_aux - 1;
			FETCH v_cur INTO v_nomePatr;
			EXIT WHEN v_cur%NOTFOUND;
			v_resumo := v_resumo || v_nomePatr;
			EXIT WHEN v_aux = 0;
			v_resumo := v_resumo || ', ';
		END LOOP;
		v_resumo := v_resumo || '.';
	END IF;
	
	SELECT nome INTO v_nomeJuiz
	FROM Pessoa P
	JOIN Arbitro Ar ON Ar.idPessoa = P.id
	JOIN Apita Ap ON Ap.idArbitro = Ar.idPessoa
	WHERE Ap.idJogo = p_idJogo AND Ap.funcao = 'Principal';
	
	v_resumo := v_resumo || ' Apitaram o jogo ' || v_nomeJuiz || ' (principal)';

	SELECT DISTINCT COUNT(*) INTO v_numBandeirinhas
	FROM Pessoa P
	JOIN Arbitro Ar ON Ar.idPessoa = P.id
	JOIN Apita Ap ON Ap.idArbitro = Ar.idPessoa
	WHERE Ap.idJogo = p_idJogo AND Ap.funcao = 'Bandeirinha';
	
	IF(v_numBandeirinhas > 0) THEN
		v_resumo := v_resumo || ' auxiliado por ';
		v_sql := 'SELECT nome FROM Pessoa P JOIN Arbitro Ar ON Ar.idPessoa = P.id JOIN Apita Ap ON Ap.idArbitro = Ar.idPessoa WHERE Ap.idJogo = ' || p_idJogo || ' AND Ap.funcao = ''Bandeirinha''';
		v_aux := v_numBandeirinhas;
		OPEN v_cur FOR v_sql;
		
		LOOP
			v_aux := v_aux - 1;
			FETCH v_cur INTO v_nomeJuiz;
			EXIT WHEN v_cur%NOTFOUND;
			v_resumo := v_resumo || v_nomeJuiz;
			EXIT WHEN v_aux = 0;
			v_resumo := v_resumo || ', ';
		END LOOP;
		v_resumo := v_resumo || '.';
		CLOSE v_cur;
	ELSE
		v_resumo := v_resumo || '.';
	END IF;
  
  p_resumo := v_resumo;
END;
/

CREATE OR REPLACE PACKAGE tabelaResultadoGrupos AS
	PROCEDURE getVitoriasDerrotasEmpates(p_selecao VARCHAR2,
 	    							     p_vitorias OUT NUMBER,
	    							     p_derrotas OUT NUMBER,
	    							     p_empates OUT NUMBER,
	    							     p_numJogos OUT NUMBER);
	PROCEDURE dadosTabelaGrupo(p_resultado OUT SYS_REFCURSOR, 
	     				       p_vitorias OUT t_dados,
							   p_derrotas OUT t_dados,
	 						   p_empates OUT t_dados,
	 						   p_numJogos OUT t_dados,
	 						   p_porcAprov OUT t_dados,
	 						   p_mediaGols OUT t_dados,
	 						   p_varianciaGols OUT t_dados,
                               p_numeroGrupo NUMBER);
END tabelaResultadoGrupos;	
/

CREATE OR REPLACE PACKAGE BODY tabelaResultadoGrupos AS

	PROCEDURE getVitoriasDerrotasEmpates(p_selecao VARCHAR2,
										 p_vitorias OUT NUMBER,
										 p_derrotas OUT NUMBER,
										 p_empates OUT NUMBER,
										 p_numJogos OUT NUMBER) AS
		v_gols1 NUMBER;
		v_gols2 NUMBER;
		v_vitoria NUMBER;
		v_empate  NUMBER;
		v_derrota NUMBER;
		v_numJogos NUMBER;
		
		v_idJogo NUMBER;
		v_selecao1 VARCHAR2(100);
		v_selecao2 VARCHAR2(100);
		
		CURSOR c_jogos IS SELECT idJogo, nomeSelecao1, nomeSelecao2 
						  FROM Informacao Inf
						  JOIN Jogo Jg ON Jg.id = Inf.idJogo
						  WHERE (Inf.nomeSelecao1 = p_selecao OR Inf.nomeSelecao2 = p_selecao) AND (Jg.fase = 'G1' OR Jg.fase = 'G2' OR Jg.fase = 'G3');
		BEGIN
		
			v_vitoria := 0;
			v_empate := 0;
			v_derrota := 0;
			v_numJogos := 0;
			OPEN c_jogos;
			LOOP
				FETCH c_jogos INTO v_idJogo, v_selecao1, v_selecao2;
					v_numJogos := c_jogos%ROWCOUNT;
					
					-- count gols da selecao 1
					SELECT count(*) INTO v_gols1
					FROM Lance L
					JOIN PartDe P ON P.idJogo = L.idJogo AND P.tempo = L.tempo
					JOIN Jogador J ON J.idPessoa = P.idJogador
					WHERE L.idJogo = v_idJogo AND J.nomeSelecao = v_selecao1;
					
					-- count gols da selecao 2
					SELECT count(*) INTO v_gols2
					FROM Lance L
					JOIN PartDe P ON P.idJogo = L.idJogo AND P.tempo = L.tempo
					JOIN Jogador J ON J.idPessoa = P.idJogador
					WHERE L.idJogo = v_idJogo AND J.nomeSelecao = v_selecao2;
					
					IF(v_gols1 > v_gols2 AND v_selecao1 = p_selecao) THEN
						v_vitoria := v_vitoria + 1;
					ELSIF(v_gols1 < v_gols2 AND v_selecao2 = p_selecao) THEN
						v_vitoria := v_vitoria + 1;
					ELSIF(v_gols1 > v_gols2 AND v_selecao2 = p_selecao) THEN
						v_derrota := v_derrota + 1;
					ELSIF(v_gols1 < v_gols2 AND v_selecao1 = p_selecao) THEN
						v_derrota := v_derrota + 1;
					ELSIF(v_gols1 = v_gols2 AND v_selecao1 <> v_selecao2) THEN
						v_empate := v_empate + 1;
					END IF;
				EXIT WHEN c_jogos%NOTFOUND;
			END LOOP;

			CLOSE c_jogos;
			
			p_numJogos := v_numJogos;
			p_vitorias := v_vitoria;
			p_derrotas := v_derrota;
			p_empates := v_empate;
			
		  EXCEPTION 
			WHEN OTHERS THEN
				dbms_output.put_line(SQLErrm);
	END;

	PROCEDURE dadosTabelaGrupo(p_resultado OUT SYS_REFCURSOR, 
	     				       p_vitorias OUT t_dados,
							   p_derrotas OUT t_dados,
	 						   p_empates OUT t_dados,
	 						   p_numJogos OUT t_dados,
	 						   p_porcAprov OUT t_dados,
	 						   p_mediaGols OUT t_dados,
	 						   p_varianciaGols OUT t_dados,
                               p_numeroGrupo NUMBER) AS
		v_sql VARCHAR2(1000);
		v_nomeNacao VARCHAR(100);
		v_pontos NUMBER;
		v_saldo NUMBER;
		v_vitoria NUMBER;
		v_derrota NUMBER;
		v_empate NUMBER;
		v_numJogos NUMBER;
		v_porcAprov NUMBER;
		v_mediaGols NUMBER;
		v_varianciaGols NUMBER;
		
		i NUMBER;
		
		v_vitoriasVetor t_dados := t_dados();
		v_derrotasVetor t_dados := t_dados();
		v_empatesVetor t_dados := t_dados();
		v_numJogosVetor t_dados := t_dados();
		v_porcAprovVetor t_dados := t_dados();
		v_mediaGolsVetor t_dados := t_dados();
		v_varianciaGolsVetor t_dados := t_dados();
		
		c1 SYS_REFCURSOR;
		BEGIN
			v_sql := 'SELECT nomeNacao, pontos, saldo FROM Selecao S WHERE S.idGrupo = ' || p_numeroGrupo || ' ORDER BY pontos, saldo';
			i := 0;
			OPEN c1 FOR v_sql;
			LOOP
				FETCH c1 INTO v_nomeNacao, v_pontos, v_saldo;
				EXIT WHEN c1%NOTFOUND;
				i := i + 1;
				tabelaResultadoGrupos.getVitoriasDerrotasEmpates(v_nomeNacao, v_vitoria, v_derrota, v_empate, v_numJogos);
				v_vitoriasVetor.extend;
				v_vitoriasVetor(i) := v_vitoria;
				v_derrotasVetor.extend;
				v_derrotasVetor(i) := v_derrota;
				v_empatesVetor.extend;
				v_empatesVetor(i) := v_empate;
				v_numJogosVetor.extend;
				v_numJogosVetor(i) := v_numJogos;
				
				v_porcAprov := calculosEstatisticos.porcAproveitamento(v_nomeNacao);
				v_mediaGols := calculosEstatisticos.mediaGols(v_nomeNacao);
				v_varianciaGols := calculosEstatisticos.varianciaGols(v_nomeNacao);
				v_porcAprovVetor.extend;
				v_porcAprovVetor(i) := v_porcAprov;
				v_mediaGolsVetor.extend;
				v_mediaGolsVetor(i) := v_mediaGols;
				v_varianciaGolsVetor.extend;
				v_varianciaGolsVetor(i) := v_varianciaGols;
			END LOOP;
			CLOSE c1;
			
			v_sql := 'SELECT nomeNacao, pontos, golsMarcados, golsSofridos, saldo FROM Selecao S WHERE S.idGrupo = ' || p_numeroGrupo || ' ORDER BY pontos, saldo';
			OPEN p_resultado FOR v_sql;
			p_vitorias := v_vitoriasVetor;
			p_derrotas := v_derrotasVetor;
			p_empates := v_empatesVetor;
			p_numJogos := v_numJogosVetor;
			p_porcAprov := v_porcAprovVetor;
			p_mediaGols := v_mediaGolsVetor;
			p_varianciaGols := v_varianciaGolsVetor;
			END dadosTabelaGrupo;
	
END tabelaResultadoGrupos;
/