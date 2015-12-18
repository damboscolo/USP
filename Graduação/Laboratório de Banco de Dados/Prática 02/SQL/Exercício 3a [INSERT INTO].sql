/* Insere tuplas nas tabelas já criadas no passo [01]
   Deve ser executado após [01]CREATE_TABLE e [02]SEQUENCE
*/

/* TODO:
	- Decidir se linhas 180-194 serão necessárias. (Ver CREATE_TABLE, linha 122).
*/

/* 3a. */

/* Tabela Selecao */
INSERT INTO Selecao (nome, letraHino, continente, bandeira, grupo)
			VALUES ('Brasil', 'Ouviram do Ipiranga as margens plácidas 
De um povo heróico o brado retumbante, 
E o sol da liberdade, em raios fúlgidos, 
Brilhou no céu da pátria nesse instante. 
 
Se o penhor dessa igualdade 
Conseguimos conquistar com braço forte, 
Em teu seio, ó liberdade, 
Desafia o nosso peito a própria morte! 
 
Ó pátria amada, 
Idolatrada, 
Salve! Salve! 
 
Brasil, um sonho intenso, um raio vívido 
De amor e de esperança à terra desce, 
Se em teu formoso céu, risonho e límpido, 
A imagem do cruzeiro resplandece. 
 
Gigante pela própria natureza, 
És belo, és forte, impávido colosso, 
E o teu futuro espelha essa grandeza. 
 
Terra adorada, 
Entre outras mil, 
És tu, Brasil, 
Ó pátria amada! 
Dos filhos deste solo és mãe gentil, 
Pátria amada, 
Brasil! 
 
Dos filhos deste solo és mãe gentil, 
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
Brasil!', 'América do Sul', EMPTY_BLOB(), 'A');



INSERT INTO Selecao (nome, letraHino, continente, bandeira, grupo)
			VALUES ('Inglaterra', '1.
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
The wide world o''er.', 'Europa', EMPTY_BLOB(), null);

/* Tabela Estadio */
INSERT INTO Estadio (idEstadio, nome, rua, num, bairro, capac, cidade)
			VALUES(seq_idEstadio.nextval, 'Morumbi', 'Rua 7 de Setembro', '190', 'Jardim Pinheiros', 60000, 'São Paulo');

INSERT INTO Estadio (idEstadio, nome, rua, num, bairro, capac, cidade)
			VALUES(seq_idEstadio.nextval, 'Pacaembu', 'Avenida Paulista', '1340', 'Vila da Sé', 80000, 'São Paulo');


/* Tabela Jogo */
INSERT INTO Jogo (idJogo, idEstadio, selecao1, selecao2, horaJogo, dataJogo, fase, publico, renda)
			VALUES(seq_idJogo.nextval, 1, 'Brasil', 'Inglaterra', to_date('20:00','hh24:mi'), to_date('20/05/2014','dd/mm/yyyy'), 'Semifinais', 45000, 20000);

INSERT INTO Jogo (idJogo, idEstadio, selecao1, selecao2, fase, publico, renda)
			VALUES(seq_idJogo.nextval, 2, 'Brasil', 'Inglaterra', 'Finais', 120300, 23401);

/* Tabela Pessoa */
INSERT INTO Pessoa (idPessoa, nome, dataNasc, passaporte, nacion, tipoPessoa)
			VALUES (seq_idPessoa.nextval, 'Neymar Júnior', to_date('23/10/1992','dd/mm/yyyy'), 'AC332542', 'Brasileiro', 1);

INSERT INTO Pessoa (idPessoa, nome, dataNasc, passaporte, nacion, tipoPessoa)
			VALUES (seq_idPessoa.nextval, 'Júlio César Soares de Espíndola', to_date('03/09/1979','dd/mm/yyyy'), 'AB932512', 'Brasileiro', 1);
			
INSERT INTO Pessoa (idPessoa, nome, dataNasc, passaporte, nacion, tipoPessoa)
			VALUES (seq_idPessoa.nextval, 'Ravshan Irmatov', to_date('09/08/1977','dd/mm/yyyy'), 'CK1923523', 'Uzbeque', 2);

INSERT INTO Pessoa (idPessoa, nome, dataNasc, passaporte, nacion, tipoPessoa)
			VALUES (seq_idPessoa.nextval, 'Yuri Nagawaka', to_date('26/04/1973','dd/mm/yyyy'), 'DO5543523', 'Japão', 2);

/* Tabela Atleta */
INSERT INTO Atleta (idPessoa, altura, peso, nomeSelecao)
			VALUES (1, '1.75', 70, 'Brasil');

INSERT INTO Atleta (idPessoa, altura, peso, nomeSelecao)
			VALUES (2, '1.87', 85, 'Brasil');

/* Tabela Arbitro */
INSERT INTO Arbitro (idPessoa, tipoArbit)
			VALUES (3, 'Juiz');
			
INSERT INTO Arbitro (idPessoa, tipoArbit)
			VALUES (4, 'Juiz');

/* Tabela JogosPart */
INSERT INTO JogosPart (idPessoa, idJogo)
			VALUES (3, 1);

INSERT INTO JogosPart (idPessoa, idJogo)
			VALUES (4, 1);

/* Tabela SAJ */
INSERT INTO SAJ(nomeSelecao, idPessoa, idJogo, escReserv)
			VALUES('Brasil', 1, 1, 0);

INSERT INTO SAJ(nomeSelecao, idPessoa, idJogo, escReserv)
			VALUES('Inglaterra', 2, 2, 1);

/* Tabela Patrocinador */
INSERT INTO Patrocinador (idPatroc, nomePatroc)
			VALUES(seq_idPatroc.nextval, 'Coca-Cola');

INSERT INTO PATROCINADOR(idPatroc, nomePatroc)
			VALUES(seq_idPatroc.nextval, 'Havaianas');


/* Tabela Paises_alvo */
INSERT INTO Paises_alvo (idPatroc, nomeSelec)
			VALUES(1, 'Brasil');

INSERT INTO Paises_alvo (idPatroc, nomeSelec)
			VALUES(2, 'Inglaterra');

/* Tabela Anuncio */
INSERT INTO Anuncio (idPatroc, idJogo)
			VALUES(1, 1);

INSERT INTO Anuncio (idPatroc, idJogo)
			VALUES(2, 2);

/* Tabela Lance */
INSERT INTO Lance (idLance, idJogo, tipoLance, tempLance, minLance, segLance)
			VALUES(seq_idLance.nextval, 2, 'Falta', 2, 45, 00);

INSERT INTO Lance (idLance, idJogo)
			VALUES(seq_idLance.nextval, 2);

/* Tabela Jogadores_env */
INSERT INTO Jogadores_env(idLance, idJogo, idPessoa)
			VALUES(1, 2, 1);

INSERT INTO Jogadores_env(idLance, idJogo, idPessoa)
			VALUES(2, 2, 2);
