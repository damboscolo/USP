-- EXERCICIO 1)
--ToDo:
-- -Descobrir outra maneira de conseguir os nomes dos atributos 1 e 2 de uma tabela!
-- -Descobrir um jeito de salvar os resultados dos SELECT e imprimí-los.
-- -Testar e ver se os comandos realmente serão executados...
SET SERVEROUTPUT ON;
create or replace PROCEDURE comandoSQL(p_identificador VARCHAR2,
									   p_nomeTabela VARCHAR2, 
									   p_valorAtributoChave VARCHAR2,
									   p_nomeAtributo VARCHAR2, 
									   p_novoValorAtributo VARCHAR2) AS
	
	v_result VARCHAR(100);
	v_result1 VARCHAR(100);	
	v_numAtributoChave NUMBER;	
	v_nomeAtributoChave VARCHAR(100);
	v_tipo VARCHAR(100);
	v_tipo2 VARCHAR(100);	
	v_numAtributos NUMBER;
	v_atributo1	VARCHAR2(100);
	v_atributo2 VARCHAR2(100);	
	comando VARCHAR2(1500);
	
	exc_notAIdentifier 	   EXCEPTION;
	exc_notASingleKeyTable EXCEPTION;
	exc_commandError	   EXCEPTION;
	
  CURSOR c_columns IS SELECT column_name
						FROM user_tab_columns uc
						WHERE uc.table_name = upper(p_nomeTabela);
BEGIN
	v_atributo2 := ' ';

	--Se o identificador não for SELECT, DELETE ou UPDATE cai na exceção exc_notAIdentifier
	IF(upper(p_identificador) NOT IN ('SELECT', 'DELETE', 'UPDATE')) THEN
		RAISE exc_notAIdentifier;
	END IF;
	
	--Conta o número de Primary Keys da Tabela
	SELECT count(*) INTO v_numAtributoChave
	FROM user_constraints uc
	JOIN user_cons_columns uco ON uco.constraint_name = uc.constraint_name AND uco.owner = uc.owner
	WHERE uco.table_name = upper(p_nomeTabela)
	AND uc.constraint_type = 'P';

	--Se a tabela possuir mais de uma Primary Key, entra na exceção exc_notASingleKeyTable
	IF(v_numAtributoChave > 1) THEN
		RAISE exc_notASingleKeyTable;
	END IF;
	
	SELECT column_name INTO v_nomeAtributoChave
	FROM user_constraints uc
	JOIN user_cons_columns uco ON uco.constraint_name = uc.constraint_name AND uco.owner = uc.owner
	WHERE uco.table_name = upper(p_nomeTabela)
	AND uc.constraint_type = 'P';
	
	OPEN c_columns;
	v_numAtributos := c_columns%ROWCOUNT;
	
	FETCH c_columns INTO v_atributo1;
	
	IF(c_columns%FOUND) THEN
		FETCH c_columns INTO v_atributo2;
	END IF;
	
	CLOSE c_columns;
  
	CASE upper(p_identificador)
		--SELECT
		WHEN 'SELECT' THEN
			IF(v_atributo2 <> ' ') THEN
				comando := 'SELECT ' ||  upper(v_atributo1) || ', ' || upper(v_atributo2) || ' FROM ' ||  upper(p_nomeTabela) || ' WHERE ' || upper(p_nomeTabela) || '.' || upper(v_nomeAtributoChave) || ' = ' || p_valorAtributoChave;
        
				EXECUTE IMMEDIATE comando INTO v_result, v_result1;
				
				dbms_output.put_line(v_atributo1 || '    ' || v_atributo2);
				
				dbms_output.put_line(v_result || '    ' || v_result1);
			ELSIF(v_atributo2 = ' ') THEN
				comando := 'SELECT ' ||  upper(v_atributo1) || ' FROM ' || upper(p_nomeTabela) || ' WHERE ' || upper(p_nomeTabela) || '.' || upper(v_nomeAtributoChave) || ' = ' || p_valorAtributoChave;
        
				EXECUTE IMMEDIATE comando INTO v_result;
				
				dbms_output.put_line(v_atributo1);
				
				dbms_output.put_line(v_result);
			ELSE
				RAISE exc_commandError;
			END IF;
		--UPDATE
		WHEN 'UPDATE' THEN
			comando := 'UPDATE ' || UPPER(p_nomeTabela) ||' SET '|| UPPER(p_nomeAtributo) ||' = '''|| p_novoValorAtributo ||''' WHERE '|| UPPER(v_nomeAtributoChave) || ' = '|| UPPER(p_valorAtributoChave);
			
			EXECUTE IMMEDIATE comando;
      
			IF(SQL%FOUND) THEN
				dbms_output.put_line('Comando ' || p_identificador || ' executado com sucesso.');
			ELSE
				RAISE exc_commandError;
			END IF;
		--DELETE
		WHEN 'DELETE' THEN
			comando := 'DELETE FROM ' || upper(p_nomeTabela) || ' WHERE ' || upper(p_nomeTabela) || '.' || upper(v_nomeAtributoChave) || ' = ' || p_valorAtributoChave;
			
			EXECUTE IMMEDIATE comando;
			IF(SQL%FOUND) THEN
				dbms_output.put_line('Comando ' || p_identificador || ' executado com sucesso.');
			ELSE
				RAISE exc_commandError;
			END IF;
    ELSE
      RAISE exc_commandError;
	END CASE;

EXCEPTION
WHEN exc_notAIdentifier THEN
	raise_application_error(-20000, upper(p_identificador) || ' não é um identificador válido para um das operações. Use ''SELECT'', ''UPDATE'' ou ''DELETE''.');
WHEN exc_notASingleKeyTable THEN
	raise_application_error(-20001, p_nomeTabela || ' não é uma tabela de chave única.');
WHEN exc_commandError THEN
	raise_application_error(-20002, upper(p_identificador) || ' não foi executado corretamente.');
WHEN OTHERS THEN
	dbms_output.put_line(SQLErrm);
END;

-- EXERCICIO 2a)
CREATE OR REPLACE
FUNCTION porcAproveitamento(p_selecao Selecao.nomeNacao%TYPE) RETURN NUMBER AS
	v_gols1 NUMBER;
	v_gols2 NUMBER;
	v_vitoria NUMBER;
	v_empate  NUMBER;
	v_numJogos NUMBER;
	v_totalPontos NUMBER;
	v_maxPontos NUMBER;
	v_porcAprov NUMBER;
	
	v_idJogo Informacao.idJogo%TYPE;
	v_selecao1 Informacao.nomeSelecao1%TYPE;
	v_selecao2 Informacao.nomeSelecao2%TYPE;
	
	CURSOR c_jogos IS SELECT idJogo, nomeSelecao1, nomeSelecao2 
					  FROM Informacao Inf
					  JOIN Jogo Jg ON Jg.id = Inf.idJogo
					  WHERE (Inf.nomeSelecao1 = p_selecao OR Inf.nomeSelecao2 = p_selecao) AND (Jg.fase = 'G1' OR Jg.fase = 'G2' OR Jg.fase = 'G3');
BEGIN
	v_vitoria := 0;
	v_empate := 0;
	OPEN c_jogos;
	LOOP
		FETCH c_jogos INTO v_idJogo, v_selecao1, v_selecao2;
			v_numJogos := c_jogos%ROWCOUNT;
			
			-- count gols da selecao 1
			SELECT count(*) INTO v_gols1
			FROM Lance L
			JOIN PartDe P ON P.idJogo = L.idJogo AND P.tempo = L.tempo
			JOIN Jogador J ON J.idPessoa = P.idJogador
			WHERE L.idJogo = v_idJogo AND J.nomeSelecao = v_selecao1;
			
			-- count gols da selecao 2
			SELECT count(*) INTO v_gols2
			FROM Lance L
			JOIN PartDe P ON P.idJogo = L.idJogo AND P.tempo = L.tempo
			JOIN Jogador J ON J.idPessoa = P.idJogador
			WHERE L.idJogo = v_idJogo AND J.nomeSelecao = v_selecao2;
			
			IF(v_gols1 > v_gols2 AND v_selecao1 = p_selecao) THEN
				v_vitoria := v_vitoria + 1;
			ELSIF(v_gols1 < v_gols2 AND v_selecao2 = p_selecao) THEN
				v_vitoria := v_vitoria + 1;
			ELSIF(v_gols1 = v_gols2) THEN
				v_empate := v_empate + 1;
			END IF;
		EXIT WHEN c_jogos%NOTFOUND;
	END LOOP;
	-- pontos totais
	v_totalPontos := (v_vitoria * 3) + v_empate;
	v_maxPontos := v_numJogos * 3;
	
	IF(v_maxPontos <> 0) THEN
		v_porcAprov := (v_totalPontos / v_maxPontos) * 100;
	ELSE
		v_porcAprov := 0;
	END IF;	
	
	CLOSE c_jogos;
	RETURN v_porcAprov;
	
  EXCEPTION 
	WHEN OTHERS THEN
		dbms_output.put_line(SQLErrm);
END;

--TESTES
set serveroutput on;
DECLARE
  porc NUMBER;
BEGIN 
  porc := PORCAPROVEITAMENTO('Holanda');
  DBMS_OUTPUT.PUT_line(porc);
END;

-- EXERCICIO 2b)
-- Pesquise o conceito de variância e analise a variância para 2 seleções.
-- Média de Gols
CREATE OR REPLACE
FUNCTION mediaGols(p_selecao Selecao.nomeNacao%TYPE) RETURN NUMBER AS
	v_idJogo NUMBER;	
	v_numGols NUMBER;
	v_numPartidas NUMBER;
	v_mediaGols	NUMBER;
BEGIN 
    SELECT count(*) INTO v_numPartidas
    FROM Informacao Inf
    JOIN Jogo Jg ON Jg.id = Inf.idJogo
    WHERE Inf.nomeSelecao1 = p_selecao OR Inf.nomeSelecao2 = p_selecao;
    
	SELECT count(*) INTO v_numGols
	FROM Lance L
	JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
	JOIN Jogador J ON J.idPessoa = Par.idJogador
	WHERE L.idTipo = 1 AND J.nomeSelecao = p_selecao;
	
	v_mediaGols := v_numGols / v_numPartidas;	
	dbms_output.put_line('A média de gols da seleção ' || p_selecao || ' é de ' || v_mediaGols || '. '|| v_numGols ||' gols em ' || v_numPartidas || ' partidas.');
	RETURN v_mediaGols;
END;

--Variância de Gols
CREATE OR REPLACE
FUNCTION varianciaGols(p_selecao Selecao.nomeNacao%TYPE) RETURN NUMBER AS
	v_idJogo NUMBER;  
	n NUMBER; -- número de partidas
	v_mediaGols	NUMBER;
	v_numGols NUMBER;
	v_somatoria NUMBER;
	v_total NUMBER;
	
	CURSOR c_jogos IS SELECT idJogo 
                      FROM Informacao Inf 
                      JOIN Jogo Jg ON Jg.id = Inf.idJogo 
                      WHERE Inf.nomeSelecao1 = p_selecao OR Inf.nomeSelecao2 = p_selecao;
BEGIN
    v_somatoria := 0;
    v_mediaGols := MEDIAGOLS(p_selecao);

    OPEN c_jogos;
    LOOP
        FETCH c_jogos INTO v_idJogo;
        EXIT WHEN c_jogos%NOTFOUND; 
        n := c_jogos%ROWCOUNT;
        
        SELECT count(*) INTO v_numGols 
        FROM Lance L 
        JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo 
        JOIN Jogador J ON J.idPessoa = Par.idJogador 
        WHERE L.idTipo = 1 AND L.idJogo = v_idJogo AND J.nomeSelecao = p_selecao;  
        
        dbms_output.put_line('ELEVADO = ' || POWER(v_numGols - v_mediaGols, 2) || ' - idJogo = ' || v_idJogo);
        v_somatoria := v_somatoria + (POWER(v_numGols - v_mediaGols, 2));
    END LOOP; 
    CLOSE c_jogos;
    
    v_total := v_somatoria / (n - 1);
	dbms_output.put_line('Variância = ' || v_total);
    RETURN v_total;
END;

-- EXERCICIO 2c)
-- Pesquise o conceito de co-variância e analise o sinal (positivo ou negativo) da variância para 2 pares de seleções. Se necessário, insira dados.
CREATE OR REPLACE FUNCTION covariancia(p_selecao Selecao.nomeNacao%TYPE,
									   p_selecao1 Selecao.nomeNacao%TYPE) RETURN NUMBER AS
					   
	v_idJogo NUMBER;  
	v_idJogo1 NUMBER;
	
	n NUMBER; -- número de partidas Seleção 1
	n1 NUMBER; -- número de partidas Seleção 2
	
	v_mediaGols	NUMBER;
	v_numGols NUMBER;
	
	v_mediaGols1 NUMBER;
	v_numGols1 NUMBER;
	
	v_somatoria NUMBER;
	v_total NUMBER;
	
	CURSOR c_jogos IS SELECT idJogo 
                      FROM Informacao Inf 
                      JOIN Jogo Jg ON Jg.id = Inf.idJogo 
                      WHERE Inf.nomeSelecao1 = p_selecao OR Inf.nomeSelecao2 = p_selecao;
	
	CURSOR c_jogos1 IS SELECT idJogo
					   FROM Informacao Inf
					   JOIN Jogo Jg ON Jg.id = Inf.idJogo
					   WHERE Inf.nomeSelecao1 = p_selecao1 OR Inf.nomeSelecao2 = p_selecao1;
BEGIN
    v_somatoria := 0;
    v_mediaGols := mediaGols(p_selecao);
	v_mediaGols1 := mediaGols(p_selecao1);
    
    
    OPEN c_jogos;
    OPEN c_jogos1;
    LOOP
        FETCH c_jogos INTO v_idJogo;
		
        FETCH c_jogos1 INTO v_idJogo1;
		
        EXIT WHEN c_jogos%NOTFOUND AND c_jogos1%NOTFOUND; 
        
        n := c_jogos%ROWCOUNT;
        n1 := c_jogos1%ROWCOUNT;
                
        SELECT count(*) INTO v_numGols 
        FROM Lance L 
        JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo 
        JOIN Jogador J ON J.idPessoa = Par.idJogador 
        WHERE L.idTipo = 1 AND L.idJogo = v_idJogo AND J.nomeSelecao = p_selecao;  
		
        SELECT count(*) INTO v_numGols1
        FROM Lance L
        JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
        JOIN Jogador J ON J.idPessoa = Par.idJogador
        WHERE L.idTipo = 1 AND L.idJogo = v_idJogo1 AND J.nomeSelecao = p_selecao1;
        
        IF(v_numGols - v_mediaGols <> 0 AND v_numGols1 - v_mediaGols1 <> 0) THEN
          v_somatoria := v_somatoria + ((v_numGols - v_mediaGols) * (v_numGols1 - v_mediaGols1));
        ELSIF(v_numGols - v_mediaGols = 0) THEN
          v_somatoria := v_somatoria + ((v_numGols1 - v_mediaGols1));
        ELSE
          v_somatoria := v_somatoria + ((v_numGols - v_mediaGols));
        END IF;
        
    END LOOP; 
    CLOSE c_jogos;
	CLOSE c_jogos1;
    
    v_total := v_somatoria / ((n + n1) - 1);
    RETURN v_total;
END;

-- EXERCICIO 2d)
-- Pesquise o conceito de correlação (“Interpretação do coeficiente de correlação”) e analise o sinal (positivo ou negativo) e a magnitude da correlação para 2 pares de seleções. Se necessário, insira dados.
CREATE OR REPLACE
FUNCTION correlacao(p_selecao Selecao.nomeNacao%TYPE,
					p_selecao1 Selecao.nomeNacao%TYPE) RETURN NUMBER AS
					   
	v_idJogo NUMBER;  
	v_idJogo1 NUMBER;
	
	n NUMBER; -- número de partidas Seleção 1
	n1 NUMBER; -- número de partidas Seleção 2
	
	v_mediaGols	NUMBER;
	v_numGols NUMBER;
	v_variancia NUMBER;
	
	v_mediaGols1 NUMBER;
	v_numGols1 NUMBER;
	v_variancia1 NUMBER;
	
	v_somatoria NUMBER;
	v_total NUMBER;
	
	CURSOR c_jogos IS SELECT idJogo 
                      FROM Informacao Inf 
                      JOIN Jogo Jg ON Jg.id = Inf.idJogo 
                      WHERE Inf.nomeSelecao1 = p_selecao OR Inf.nomeSelecao2 = p_selecao;
	
	CURSOR c_jogos1 IS SELECT idJogo
					   FROM Informacao Inf
					   JOIN Jogo Jg ON Jg.id = Inf.idJogo
					   WHERE Inf.nomeSelecao1 = p_selecao1 OR Inf.nomeSelecao2 = p_selecao1;
BEGIN
    v_somatoria := 0;
    v_mediaGols := mediaGols(p_selecao);
	v_mediaGols1 := mediaGols(p_selecao1);
	v_variancia := varianciaGols(p_selecao);
	v_variancia1 := varianciaGols(p_selecao1);
	
    OPEN c_jogos;
	OPEN c_jogos1;
    LOOP
        FETCH c_jogos INTO v_idJogo;
		
		FETCH c_jogos1 INTO v_idJogo1;
		
        EXIT WHEN c_jogos%NOTFOUND AND c_jogos1%NOTFOUND; 
		
        n := c_jogos%ROWCOUNT;
		n1 := c_jogos1%ROWCOUNT;
        
        SELECT count(*) INTO v_numGols 
        FROM Lance L 
        JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo 
        JOIN Jogador J ON J.idPessoa = Par.idJogador 
        WHERE L.idTipo = 1 AND L.idJogo = v_idJogo AND J.nomeSelecao = p_selecao;  
		
		SELECT count(*) INTO v_numGols1
		FROM Lance L
		JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
		JOIN Jogador J ON J.idPessoa = Par.idJogador
		WHERE L.idTipo = 1 AND L.idJogo = v_idJogo1 AND J.nomeSelecao = p_selecao1;
		
        IF(v_numGols - v_mediaGols <> 0 AND v_numGols1 - v_mediaGols1 <> 0) THEN
          v_somatoria := v_somatoria + ((v_numGols - v_mediaGols) * (v_numGols1 - v_mediaGols1));
        ELSIF(v_numGols - v_mediaGols = 0) THEN
          v_somatoria := v_somatoria + ((v_numGols1 - v_mediaGols1));
        ELSE
          v_somatoria := v_somatoria + ((v_numGols - v_mediaGols));
        END IF;
		
    END LOOP; 
    CLOSE c_jogos;
	CLOSE c_jogos1;
    
    v_total := v_somatoria / (sqrt(v_variancia) * sqrt(v_variancia1));
    RETURN v_total;
END;

-- EXERCICIO 3)