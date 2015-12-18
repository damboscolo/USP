-- EXERCICIO 1)
--ToDo:
-- -Descobrir um jeito de salvar os resultados dos SELECT e imprimí-los.
-- -Testar e ver se os comandos realmente serão executados...
-- -EXCEPTIONS!
SET SERVEROUTPUT ON;
CREATE OR REPLACE
PROCEDURE comandoSQL(p_identificador IN VARCHAR2,
					 p_nomeTabela IN VARCHAR2, 
					 p_nomeAtributoChave IN VARCHAR2, 
					 p_valorAtributoChave IN VARCHAR2,
					 p_nomeAtributo IN VARCHAR2, 
					 p_novoValorAtributo IN VARCHAR2) AS
					 
	v_numAtributoChave NUMBER;

	v_tipo VARCHAR(100);
	v_tipo2 VARCHAR(100);
	
	v_numAtributos NUMBER;
	v_atributo1	VARCHAR2(100);
	v_atributo2 VARCHAR2(100);
	
	exc_notAIdentifier 	   EXCEPTION;
	exc_notASingleKeyTable EXCEPTION;
	exc_commandError	   EXCEPTION;
	
	CURSOR c_columns IS SELECT column_name
						FROM user_tab_columns uc
						WHERE uc.table_name = upper(p_nomeTable);
BEGIN
	--Se o identificador não for SELECT, DELETE ou UPDATE cai na exceção exc_notAIdentifier
	IF(p_identificador NOT IN ('SELECT', 'DELETE', 'UPDATE')) THEN
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
	
	--Determina o tipo do atributo-chave
	SELECT data_type INTO v_tipo
	FROM user_tab_columns
	WHERE table_name = upper(p_nomeTabela) AND column_name = upper(p_nomeAtributoChave);
	
	--Determina o tipo do novo atributo, se esse existir
	IF(p_novoValorAtributo <> NULL) THEN
		SELECT data_type INTO v_tipo2
		FROM user_tab_columns
		WHERE table_name = upper(p_nomeTabela) AND column_name = upper(p_novoValorAtributo);
	END IF;
	
	OPEN c_columns;
	v_numAtributos = c_columns%LENGHT;
	
	FETCH c_columns INTO v_atributo1;
	
	IF(v_numAtributos > 1) THEN
		FETCH c_columns INTO v_atributo2;
	END IF;
	
	CLOSE c_columns;
	
	CASE p_identificador
		--SELECT
		WHEN 'SELECT' THEN
			IF(v_numAtributos > 1) THEN
				SELECT v_atributo1, v_atributo2
				FROM p_nomeTabela
				WHERE p_nomeTabela.p_nomeAtributoChave = CAST(p_valorAtributoChave AS v_tipo);
				--dmbs_output.put_line();
			ELSE
				SELECT v_atributo1
				FROM p_nomeTabela
				WHERE p_nomeTabela.p_nomeAtributoChave = CAST(p_valorAtributoChave AS v_tipo);
				--dmbs_output.put_line();
			END IF;
		--UPDATE
		WHEN 'UPDATE' THEN
			UPDATE p_nomeTabela SET p_nomeAtributo = CAST(p_novoValorAtributo AS v_tipo2)
			WHERE p_nomeTabela.p_nomeAtributoChave = CAST(p_valorAtributoChave AS v_tipo);
			IF(SQL%FOUND) THEN
				dbms_output.put_line('Comando ' || p_identificador || ' executado com sucesso.');
			ELSE
				RAISE exc_CommandError;
			END IF;
		--DELETE
		WHEN 'DELETE' THEN
			DELETE
			FROM p_nomeTabela
			WHERE p_nomeTabela.p_nomeAtributoChave = CAST(p_valorAtributoChave AS v_tipo);
			IF(SQL%FOUND) THEN
				dbms_output.put_line('Comando ' || p_identificador || ' executado com sucesso.');
			ELSE
				RAISE exc_commandError;
			END IF;
	END;
	
	EXCEPTION
	WHEN exc_notAIdentifier THEN
		--RETURN
	WHEN exc_notASingleKeyTable THEN
		--RETURN
	WHEN exc_commandError THEN
		--RETURN
	WHEN OTHERS THEN
		--RETURN
END;

-- EXERCICIO 2a)
SET SERVEROUTPUT ON;
-- vitoria - 3 pontos | empate - 1 ponto | derrota - 0 ponto
CREATE OR REPLACE
PROCEDURE porcAproveitamento(p_selecao Selecao.nomeNacao%TYPE) AS
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
	v_numJogos := c_jogos%LENGHT;
	OPEN c_jogos;
	LOOP
		FETCH c_jogos INTO v_idJogo, v_selecao1, v_selecao2;
			
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
	v_porcAprov := (v_totalPontos / v_maxPontos) * 100;
	--DBMS_OUTPUT.PUT_LINE('vitoria: ' || v_vitoria || ' | empate: ' || v_empate || ' - ' || v_numJogos|| ' - '|| v_totalPontos || ' - '||  v_maxPontos || ' - Porcentagem: ' || v_porcAprov || '%');
  	CLOSE c_jogos;
	RETURN v_porcAprov;
	
	EXCEPTION 
	WHEN OTHERS THEN
	--RETURN error
END;

-- EXERCICIO 2b)
-- Média de Gols
SET SERVEROUTPUT ON;
CREATE OR REPLACE
PROCEDURE mediaGols(p_selecao Selecao.nomeNacao%TYPE) AS
	v_idJogo NUMBER;
	v_nomeSelecao1 VARCHAR(100);
	v_nomeSelecao2 VARCHAR(100);
	
	v_numGols NUMBER;
	v_numPartidas NUMBER;
	v_mediaGols	NUMBER;

	CURSOR c_jogos IS SELECT idJogo
					  FROM Informacao Inf
					  JOIN Jogo Jg ON Jg.id = Inf.idJogo
					  WHERE Inf.nomeSelecao1 = p_selecao OR Inf.nomeSelecao2 = p_selecao
BEGIN
	v_numPartidas = c_jogos%LENGHT;
	OPEN c_jogos;
	LOOP
		FETCH c_jogos INTO v_idJogo
	
		SELECT count(*) INTO v_numGols
		FROM Lance L
		JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
		JOIN Jogador J ON J.idPessoa = Par.idPessoa
		WHERE L.idTipo = 1 AND L.idJogo = v_idJogo AND J.nomeSelecao = p_selecao;
		
		v_mediaGols = v_numGols / v_numPartidas;
		
		dbms_output.put_line('A média de gols na partida ' || v_idJogo || ' da seleção ' || p_selecao || ' é de ' || v_mediaGols || '.');
		
		EXIT WHEN c_jogos%NOTFOUND;
	END LOOP;
	CLOSE c_jogos;
END;

--Variância de Gols

-- EXERCICIO 2c)

-- EXERCICIO 2d)

-- EXERCICIO 3)