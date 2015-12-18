/* Alteração de tabelas e tuplas
   Alguns comandos podem ser executados depois de [01]CREATE_TABLE (marcados com [01] no início da sua declaração)
   Outros devem ser executados após [03]INSERT (marcados com [03] no início da sua declaração)
*/

/* 3b. */
/* 
Faça as seguintes alterações: 
Escolha uma tabela e faça uma alteração nos valores de 2 ou mais atributos de um conjunto de tuplas. 
Use uma condição de localização (um predicado) para encontrar as tuplas a serem modificadas;
Escolha uma tabela e remova uma ou mais tuplas.  
Use uma condição de localização (um predicado) para encontrar as tuplas a serem removidas.
*/

SELECT * FROM ATLETA
	WHERE PESO = 85;
	
ALTER TABLE ATLETA 
	MODIFY (altura NUMBER,
			peso NUMBER);

DELETE FROM SELECAO
	WHERE nome = 'Brasil';
	
DELETE FROM ESTADIO
	WHERE cidade = 'São Paulo';
	
/* 4a. */
/* 
Explique o comportamento do SGBD com relação ao conteúdo da tabela:
como ficam os valores deste novo atributo nas tuplas previamente existentes? 
Faça testes 
*/

ALTER TABLE Jogo 
	ADD prorrogacao NUMBER DEFAULT 0
	CONSTRAINT chk_prorrogacao CHECK (prorrogacao >= 0);
/*
Resposta: Os valores deste novo atributo nas tuplas se torna o valor DEFAULT que foi estipulado na declaração do ALTER TABLE.
Caso não haja valor DEFAULT, os dados no atributo novo serão NULL. É possível deletar o atributo e as tuplas sem nenhum problema.
*/

/* 4b. */

ALTER TABLE Pessoa ADD CONSTRAINT UN_NOME_PESSOA UNIQUE (nome);

/* 4c.
/*
Escolha uma tabela com chave primária (PK) definida por apenas um atributo, 
e que seja referenciada por uma chave estrangeira (FK) de outra tabela. 
Tente remover a PK. Teste o comando com e sem CASCADE. Explique o que acontece.
No caso do CASCADE, explique o que acontece na tabela em que havia a PK e na 
tabela em que havia a FK (pesquise e use o comando DESCRIBE).
*/

ALTER TABLE Pessoa DROP (idPessoa);

ALTER TABLE Pessoa DROP (idPessoa) CASCADE CONSTRAINTS;

DESCRIBE TABLE Pessoa;
DESCRIBE TABLE Atleta;

/*
Resposta: Sem CASCADE a operação não é realizada e um erro é exibido dizendo que não é possível excluir uma chave pai enquanto
ela estiver sendo usada por outra tabela. (ORA-12992)
Se for utilizado o comando com CASCADE, a tabela que possuía a PK perde esse campo, porém as tabelas que se relacionavam com ela mantém
o campo com os mesmos valores.

Antes do comando:
DESCRIBE TABLE Pessoa
Name       Null     Type          
---------- -------- ------------- 
IDPESSOA   NOT NULL NUMBER
NOME                VARCHAR2(100) 
DATANASC            DATE          
PASSAPORTE          VARCHAR2(15)  
NACION              VARCHAR2(30)  
TIPOPESSOA NOT NULL NUMBER  

DESCRIBE TABLE Atleta
Name        Null     Type         
----------- -------- ------------ 
IDPESSOA    NOT NULL NUMBER       
ALTURA               FLOAT(126)   
PESO                 FLOAT(126)   
NOMESELECAO          VARCHAR2(30) 

Após o comando:
DESCRIBE TABLE Pessoa
Name       Null     Type          
---------- -------- ------------- 
NOME                VARCHAR2(100) 
DATANASC            DATE          
PASSAPORTE          VARCHAR2(15)  
NACION              VARCHAR2(30)  
TIPOPESSOA NOT NULL NUMBER  

DESCRIBE TABLE Atleta
Name        Null     Type         
----------- -------- ------------ 
IDPESSOA    NOT NULL NUMBER       
ALTURA               FLOAT(126)   
PESO                 FLOAT(126)   
NOMESELECAO          VARCHAR2(30) 
*/

/* 4d. */
ALTER TABLE SELECAO DROP CONSTRAINT N_GRUPO;

INSERT INTO SELECAO (nome, letraHino, continente, bandeira, grupo)
            VALUES ('Colombia', NULL, 'América do Sul', EMPTY_BLOB(), 'K');
            
ALTER TABLE SELECAO
            ADD CONSTRAINT N_GRUPO CHECK (grupo BETWEEN 'A' AND 'H');
			
/*
Resposta: Uma mensagem de erro é exibida quando se tenta colocar uma constraint que é violada por algum valor já existente na tabela. (ORA-02293).
