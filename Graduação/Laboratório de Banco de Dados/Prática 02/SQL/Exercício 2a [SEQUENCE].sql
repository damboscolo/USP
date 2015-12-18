/* Cria as sequências necessárias para os atributos das tabelas
   Deve ser executado antes das inserções, pois as sequências são usadas nas inserções
*/

/* TODO:
   - Nothing.
*/ 

/* 2a. */

CREATE SEQUENCE seq_idPessoa
	MINVALUE 0
	NOMAXVALUE
	START WITH 0
	INCREMENT BY 1
	NOCYCLE
	NOCACHE;

CREATE SEQUENCE seq_idJogo
	MINVALUE 0
	MAXVALUE 70
	START WITH 0
	INCREMENT BY 1
	NOCYCLE
	NOCACHE;

CREATE SEQUENCE seq_idEstadio
	MINVALUE 0
	MAXVALUE 15
	START WITH 0
	INCREMENT BY 1
	NOCYCLE
	NOCACHE;

CREATE SEQUENCE seq_idPatroc
	MINVALUE 0
	NOMAXVALUE
	START WITH 0
	INCREMENT BY 1
	NOCYCLE
	NOCACHE;

CREATE SEQUENCE seq_idLance
	MINVALUE 0
	NOMAXVALUE
	START WITH 0
	INCREMENT BY 1
	NOCYCLE
	NOCACHE;