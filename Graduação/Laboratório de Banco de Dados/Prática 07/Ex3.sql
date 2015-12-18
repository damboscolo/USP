CREATE TABLE Table_Log
(
	Comando VARCHAR(1000),
	Usuario VARCHAR(200),
	Dt DATE
);

CREATE OR REPLACE PROCEDURE escreverLog(comando VARCHAR2) IS
	PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	INSERT INTO Table_Log (Comando, Usuario, Dt)
				VALUES(comando, USER, systimestamp);
	COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
		raise_application_error(-20005, 'SQLErrm');
END;

CREATE OR REPLACE PROCEDURE executarDML(comando VARCHAR2) AS
BEGIN
	escreverLog(comando);
	EXECUTE IMMEDIATE comando;
	dbms_output.put_line('Comando executado com sucesso');

	EXCEPTION
	WHEN OTHERS THEN
		dbms_output.put_line(SQLErrm);
END;

DECLARE 
    v_stmt VARCHAR2(300); 
BEGIN 
    v_stmt := 'SELECT * FROM Nacao'; 
    executarDML(v_stmt); 
    COMMIT; 
EXCEPTION 
    WHEN OTHERS THEN 
    dbms_output.Put_line('Erro: ' || SQLERRM); 
    ROLLBACK; 
END; 

--saida--
PROCEDURE EXECUTARDML compilado
bloco anônimo concluído
Comando executado com sucesso