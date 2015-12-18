CREATE OR REPLACE PACKAGE nacaoBandeiras AS
	
	PROCEDURE insertNacao(p_dados BLOB, p_nomeNacao IN VARCHAR2);
	PROCEDURE setBandeira(p_dados BLOB, p_nomeNacao IN VARCHAR2);
	PROCEDURE getBandeira(p_dados OUT BLOB, p_nomeNacao IN VARCHAR2);
	
END nacaoBandeiras;
/
CREATE OR REPLACE PACKAGE BODY nacaoBandeiras AS
	
	PROCEDURE insertNacao(p_dados BLOB, p_nomeNacao VARCHAR2) AS
    exc_comandoNaoExecutado EXCEPTION;
    BEGIN
    
      INSERT INTO Nacao(nome, bandeira) VALUES(p_nomeNacao, p_dados);
      
      IF(SQL%NOTFOUND) THEN
        RAISE exc_comandoNaoExecutado;
      END IF;
    
    EXCEPTION
      WHEN exc_comandoNaoExecutado THEN
        dbms_output.put_line('Comando não executado.');
      WHEN OTHERS THEN
        raise_application_error(-20101, SQLErrm);
	END insertNacao;
	
	PROCEDURE setBandeira(p_dados BLOB, p_nomeNacao VARCHAR2) AS
		v_sql VARCHAR2(1000);
		exc_comandoNaoExecutado EXCEPTION;
	BEGIN
	  
		  UPDATE Nacao
		  SET Nacao.bandeira = p_dados
		  WHERE Nacao.nome = p_nomeNacao;
		  
		  IF(SQL%NOTFOUND) THEN
			RAISE exc_comandoNaoExecutado;
		  END IF;
	  
		EXCEPTION
		  WHEN exc_comandoNaoExecutado THEN
			dbms_output.put_line('Comando não executado.');
		  WHEN OTHERS THEN
			raise_application_error(-20101, SQLErrm);
	END setBandeira;
  
	PROCEDURE getBandeira(p_dados OUT BLOB, p_nomeNacao VARCHAR2) AS
		v_sql VARCHAR2(1000);
	BEGIN
			SELECT bandeira INTO p_dados
			FROM Nacao N
			WHERE N.nome = p_nomeNacao;
		EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20101, SQLErrm);
	END getBandeira;
	
END nacaoBandeiras;


--Teste
SET SERVEROUTPUT ON;
DECLARE
  b1 BLOB;
BEGIN
  nacaoBandeiras.setBandeira(EMPTY_BLOB(), 'Brasil');
  nacaoBandeiras.getBandeira(b1, 'Brasil');
  dbms_output.put_line(utl_raw.cast_to_varchar2(b1));
END;