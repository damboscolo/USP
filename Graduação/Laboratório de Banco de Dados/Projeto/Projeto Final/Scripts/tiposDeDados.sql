--Tipo utilizado para a passagem de atributos no arquivo operacoesSQL
CREATE OR REPLACE TYPE t_atributos IS VARRAY(10) OF VARCHAR2(100);
/
--Tipo utilizado para armazenar os resultados no arquivo tabelaResultGrupos
CREATE OR REPLACE TYPE t_dados IS VARRAY(4) OF NUMBER;
/