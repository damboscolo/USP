--Exercício 2

CREATE OR REPLACE PACKAGE sqlOperations AS
	TYPE t_atributos IS VARRAY(10) OF VARCHAR2(100);
	
	--Procedure que insere dados numa tabela.
	PROCEDURE insertOnTable(p_nomeTabela VARCHAR2,
							p_atributos t_atributos,
							p_valorAtributos t_atributos);
	
	--Procedure que deleta dados de uma tabela.
	PROCEDURE deleteFromTable(p_nomeTabela VARCHAR2,
							  p_atributos t_atributos,
							  p_valorAtributos t_atributos);
							  
	--Procedure que atualiza dados de uma tabela.
	PROCEDURE updateTable(p_nomeTabela VARCHAR2,
						  p_atributos t_atributos,
						  p_valorAtributos t_atributos,
						  p_atributoWhere VARCHAR2,
						  p_valorAtributoWhere VARCHAR2);
							
	--Procedure que seleciona dados de uma tabela.
	PROCEDURE selectFromTable(p_nomeTabela VARCHAR2,
							  p_atributos t_atributos,
							  p_resultado OUT SYS_REFCURSOR);
END sqlOperations;
/
CREATE OR REPLACE PACKAGE BODY sqlOperations AS
	PROCEDURE insertOnTable(p_nomeTabela VARCHAR2,
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
			v_sql := v_sql || '''' || p_valorAtributos(v_aux) || '''';
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
			
		--EXCEPTION
	END;

	PROCEDURE deleteFromTable(p_nomeTabela VARCHAR2,
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
		
		--EXCEPTION
	END;

	PROCEDURE updateTable(p_nomeTabela VARCHAR2,
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
			v_sql := v_sql || '' || p_atributos(v_aux) || ' = ''' || p_valorAtributos(v_aux) || '''';
			EXIT WHEN v_aux = p_atributos.COUNT;
			v_sql := v_sql || ',';
			v_aux := v_aux + 1;
		END LOOP;
		v_sql := v_sql || ' WHERE ' || p_atributoWhere || ' = ''' || p_valorAtributoWhere || '''';
		dbms_output.put_line(v_sql);
		EXECUTE IMMEDIATE v_sql;
		IF(SQL%FOUND) THEN
			dbms_output.put_line('Comando UPDATE bem-sucedido.');
		ELSE
			raise exc_commandNotExec;
		END IF;
		
		--EXCEPTION
	END;

	PROCEDURE selectFromTable(p_nomeTabela VARCHAR2,
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
	END;
END sqlOperations;
/