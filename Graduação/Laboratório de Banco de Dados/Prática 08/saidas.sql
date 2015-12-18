1)
TRIGGER TRIGGERCARTOES compilado
--teste
UPDATE PARTICIPADE SET IDJOGADOR = 14 WHERE IDJOGADOR = 13 AND IDJOGO = 11 AND TEMPO = '00:03';

2)
a)
PROCEDURE ATUALIZAVALORES compilad

-- Teste
BEGIN
  atualizaValores('Brasil');
END;
bloco anônimo concluído

TRIGGER TRIGGER_VALORESSELECPARTDE compilado


3)
a)
Ocorreu um erro ao salvar alterações na tabela "7986625"."INFORMACAO":
Linha 17: ORA-20002: Uma das seleções já participou de 3 jogos durante a fase de grupos.
ORA-06512: em "7986625.TRIGGER_SELEC3JOGOS", line 17
ORA-04088: erro durante a execução do gatilho '7986625.TRIGGER_SELEC3JOGOS'
ORA-06512: em line 1

b)
Erro a partir da linha : 24 no comando -
INSERT INTO Apt(idArbitro, idJogo, funcao)  
            VALUES (9, 11, 'Principal')
Relatório de erros -
Erro de SQL: ORA-20004: Erro: arbitro nao apita jogos de sua propria nacao
ORA-06512: em "7986625.TRIGGERARBITRONACIONDIST", line 15
ORA-04088: erro durante a execução do gatilho '7986625.TRIGGERARBITRONACIONDIST'

4)
TRIGGER TRIGGERINSERTUPDATEJOGOUEM compilado

--Teste
Erro a partir da linha : 4 no comando -
INSERT INTO JgEm(idJogo, idJogador, titular)
			VALUES (15, 16, 'S')
Relatório de erros -
Erro de SQL: ORA-20000: Erro: jogador não pertence a uma das seleções da partida correspondente.
ORA-06512: em "7986625.TRIGGERINSERTUPDATEJOGOUEM", line 24
ORA-04088: erro durante a execução do gatilho '7986625.TRIGGERINSERTUPDATEJOGOUEM'
20000. 00000 -  "%s"
*Cause:    The stored procedure 'raise_application_error'
           was called which causes this error to be generated.
*Action:   Correct the problem as described in the error message or contact
           the application administrator or DBA for more information.

		   
5)
TRIGGER TRIGGERUPDATEFKPATROCIN compilado

6)
a)
table TABLELOG criado.

b)
TRIGGER TRIGGERTABLELOG compilado

--Teste
CREATE TABLE TableTest ( 
  id NUMBER(10) NOT NULL 
);

TABLELOG:
usuario	  data     operacao 	tipoObj   	nomeObj
-------	 ------	   --------    --------    ----------
7986625	 07/05/14	CREATE		TABLE		TABLETEST


7)
TRIGGER TRIGGERPESSOAIDADE compilado

UPDATE Pessoa SET nascimento = '26/04/94' where id = 2;
UPDATE Pessoa SET nascimento = '26/04/96', idade = 10 where id = 4;
INSERT INTO Pes(id,subclasse, nome, passaporte, nascimento) 
 	 VALUES (100,'A', 'Hi', '41', '17/04/72');