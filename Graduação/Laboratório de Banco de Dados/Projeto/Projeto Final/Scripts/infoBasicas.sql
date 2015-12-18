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

--Usando os resultados em Java:
--Public void teste(){
--	CallableStatement pesquisa =
--   conection.prepareCall("{ call UsaCursor( (?, ?) }");
--	
--	pesquisa.registerOutParameter(1, OracleTypes.CURSOR);
--	  pesquisa.setString(2, 5);
--	pesquisa.execute();
--	ResultSet cursor = (ResultSet)pesquisa.getObject(1) ;
--	while (cursor.next()){
--		...
--	}
-- http://www.oracle-base.com/articles/misc/using-ref-cursors-to-return-recordsets.php

SET SERVEROUTPUT ON;
DECLARE
	v1 VARCHAR2(100);
	v2 VARCHAR2(100);
	v3 VARCHAR2(100);
	v4 VARCHAR2(100);
	v5 VARCHAR2(100);
	cur SYS_REFCURSOR;
BEGIN
	infoBasicas.getNomeTabela(cur);
	FETCH cur INTO v1;
	dbms_output.put_line(v1);	
  
  infoBasicas.getNomesColunas(cur, 'APITA');
  FETCH cur INTO v1, v2, v3, v4, v5;
	dbms_output.put_line(v1 || ' ' || v2 || ' ' || v3 || ' ' || v4 || ' ' || v5);
  
  infoBasicas.getPrimaryKey(cur, 'APITA');
  FETCH cur INTO v1;
	dbms_output.put_line(v1);
  
  infoBasicas.getForeignKey(cur, 'APITA');
  FETCH cur INTO v1, v2, v3;
	dbms_output.put_line(v1 || ' ' || v2 || ' ' || v3);
END;