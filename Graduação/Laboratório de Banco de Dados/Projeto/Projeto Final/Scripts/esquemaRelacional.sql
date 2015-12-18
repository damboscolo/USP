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