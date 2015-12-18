INSERT INTO Evento VALUES (1, "Simpósio de Banco de Dados", "Este Evento visa desenvolver melhorias para os SGBDs mais importantes da atualidade.", "www.sbd.com.br");
INSERT INTO Evento VALUES (2, "III Encontro de Programadores", "Este Evento visa desenvolver melhorias para as linguagens de programação mais importantes da atualidade.", "www.3ep.com.br");
INSERT INTO Evento VALUES (3, "Semana da Tecnologia", "Este Evento visa difundir novas formas de tecnologia que surgiram no último ano.", "www.sematec.com.br");

INSERT INTO Pessoa VALUES (1, "José Silva", "456.789.345-12", "Rua Onze, 100", "1895-05-05", "js@icmc.usp.br", "016998765432");
INSERT INTO Pessoa VALUES (2, "Maria Souza", "234.567.890-10", "Rua Doze, 150", "1989-02-07", "ms@icmc.usp.br", "016987964856");
INSERT INTO Pessoa VALUES (3, "Joana Lamert", "928.456.879-01", "Rua Treze, 200", "1990-12-10", "jl@icmc.usp.br", "016974658877");
 
INSERT INTO Edicao VALUES (1, 2, "2012-11-25", "2012-11-27", "267");
INSERT INTO Edicao VALUES (1, 3, "2013-11-20", "2013-11-22", "300");
INSERT INTO Edicao VALUES (2, 10, "2013-09-12", "2013-09-15", "1000");
INSERT INTO Edicao VALUES (3, 33, "2013-05-02", "2013-05-06", "1500"); 

INSERT INTO Participante VALUES (1, 1, 1, 3, 0, 1, 1);
INSERT INTO Participante VALUES (2, 1, 1, 2, 0, 1, 0);
INSERT INTO Participante VALUES (3, 2, 2, 10, 0, 1, 1);
INSERT INTO Participante VALUES (4, 2, 3, 33, 1, 1, 0);
INSERT INTO Participante VALUES (5, 3, 1, 3, 1, 1, 1);
INSERT INTO Participante VALUES (6, 3, 2, 10, 1, 0, 0);
INSERT INTO Participante VALUES (7, 3, 3, 33, 1, 1, 0);

INSERT INTO Patrocinador VALUES ("413.521.728-10", "Matheus Pusinhol", "MP", "Alvarenga Peixoto, 100");
INSERT INTO Patrocinador VALUES ("123.456.789-10", "Eduardo Siciliato", "ES", "Inconfidentes, 20");
INSERT INTO Patrocinador VALUES ("432.645.556-12", "Daniele Boscolo", "DB", "Av. São Carlos, 1867");
INSERT INTO Patrocinador VALUES ("567.432.455-99", "Hiero Eunãosei", "HE", "Interrogação, 00");

INSERT INTO Patrocinio VALUES ("413.521.728-10", 1, 2, 10000, 10000);
INSERT INTO Patrocinio VALUES ("413.521.728-10", 1, 3, 12000, 12000);
INSERT INTO Patrocinio VALUES ("123.456.789-10", 2, 10, 9000, 9000);
INSERT INTO Patrocinio VALUES ("123.456.789-10", 3, 33, 15000, 15000);

INSERT INTO Despesa VALUES (1, 2, 1, "413.521.728-10", 1, 2, "2012-11-27", 10000, "Despesa gasta para alugar o local e na organização em geral.", 1);
INSERT INTO Despesa VALUES (1, 2, 2, "413.521.728-10", 1, 2, "2012-11-27", 1000, "Despesa gasta com hoteis para os convidados.", 2);
INSERT INTO Despesa VALUES (1, 3, 1, "413.521.728-10", 1, 3, "2013-11-22", 12000, "Despesa gasta para alugar o local e na organização em geral", 1);
INSERT INTO Despesa VALUES (1, 3, 2, "413.521.728-10", 1, 3, "2013-11-22", 1500, "Despesa gasta com hoteis para os convidados.", 2);
INSERT INTO Despesa VALUES (2, 10, 1, "123.456.789-10", 2, 10, "2013-09-15", 30000, "Despesa gasta para alugar o local e na organização em geral.", 1);
INSERT INTO Despesa VALUES (2, 10, 2, "123.456.789-10", 2, 10, "2013-09-15", 3000, "Despesa gasta com hoteis para os convidados.", 2);
INSERT INTO Despesa VALUES (3, 33, 1, "123.456.789-10", 3, 33, "2013-05-06", 45000, "Despesa gasta para alugar o local e na organização em geral", 1);
INSERT INTO Despesa VALUES (3, 33, 2, "123.456.789-10", 3, 33, "2013-05-06", 5200, "Despesa gasta com hoteis para os convidados.", 2);

INSERT INTO DespesaApresentador VALUES (1, 2, 2, 2);
INSERT INTO DespesaApresentador VALUES (1, 3, 2, 1);
INSERT INTO DespesaApresentador VALUES (2, 10, 2, 3);
INSERT INTO DespesaApresentador VALUES (3, 33, 2, 7);


