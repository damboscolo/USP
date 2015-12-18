CREATE OR REPLACE PACKAGE calculosEstatisticos AS
	FUNCTION porcAproveitamento(p_selecao VARCHAR2) RETURN NUMBER;
	FUNCTION mediaGols(p_selecao VARCHAR2) RETURN NUMBER;
	FUNCTION varianciaGols(p_selecao VARCHAR2) RETURN NUMBER;
	FUNCTION covariancia(p_selecao VARCHAR2,
						 p_selecao1 VARCHAR2) RETURN NUMBER;
	FUNCTION correlacao(p_selecao VARCHAR2,
						p_selecao1 VARCHAR2) RETURN NUMBER;

END calculosEstatisticos;
/
CREATE OR REPLACE PACKAGE BODY calculosEstatisticos AS

	FUNCTION porcAproveitamento(p_selecao VARCHAR2) RETURN NUMBER AS
		v_gols1 NUMBER;
		v_gols2 NUMBER;
		v_vitoria NUMBER;
		v_empate  NUMBER;
		v_numJogos NUMBER;
		v_totalPontos NUMBER;
		v_maxPontos NUMBER;
		v_porcAprov NUMBER;
		
		v_idJogo VARCHAR2(100);
		v_selecao1 VARCHAR2(100);
		v_selecao2 VARCHAR2(100);
		
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

	FUNCTION mediaGols(p_selecao VARCHAR2) RETURN NUMBER AS
		v_idJogo NUMBER;	
		v_numGols NUMBER;
		v_numPartidas NUMBER;
		v_mediaGols	NUMBER;
	BEGIN 
		SELECT count(*) INTO v_numPartidas
		FROM Informacao Inf
		JOIN Jogo Jg ON Jg.id = Inf.idJogo
		WHERE (Inf.nomeSelecao1 = p_selecao OR Inf.nomeSelecao2 = p_selecao) AND (Jg.fase = 'G1' OR Jg.fase = 'G2' OR Jg.fase = 'G3');
		
		SELECT count(*) INTO v_numGols
		FROM Lance L
		JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
		JOIN Jogador J ON J.idPessoa = Par.idJogador
		JOIN Jogo Jg ON Jg.id = L.idJogo
		WHERE L.idTipo = 1 AND J.nomeSelecao = p_selecao AND (Jg.fase = 'G1' OR Jg.fase = 'G2' OR Jg.fase = 'G3');
		
		IF(v_numPartidas = 0) THEN
			RETURN 0;
		END IF;
		
		v_mediaGols := v_numGols / v_numPartidas;
		RETURN v_mediaGols;
	END;

	FUNCTION varianciaGols(p_selecao VARCHAR2) RETURN NUMBER AS
		v_idJogo NUMBER;  
		n NUMBER; -- número de partidas
		v_mediaGols	NUMBER;
		v_numGols NUMBER;
		v_somatoria NUMBER;
		v_total NUMBER;
		
		CURSOR c_jogos IS SELECT idJogo 
						  FROM Informacao Inf 
						  JOIN Jogo Jg ON Jg.id = Inf.idJogo 
						  WHERE (Inf.nomeSelecao1 = p_selecao OR Inf.nomeSelecao2 = p_selecao) AND (Jg.fase = 'G1' OR Jg.fase = 'G2' OR Jg.fase = 'G3');
	BEGIN
		v_somatoria := 0;
		v_mediaGols := MEDIAGOLS(p_selecao);
		v_total := 0;
		n := 0;
		
		OPEN c_jogos;
		LOOP
			FETCH c_jogos INTO v_idJogo;
			EXIT WHEN c_jogos%NOTFOUND; 
			n := c_jogos%ROWCOUNT;
			
			SELECT count(*) INTO v_numGols 
			FROM Lance L 
			JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo 
			JOIN Jogador J ON J.idPessoa = Par.idJogador
			JOIN Jogo Jg ON Jg.id = L.idJogo
			WHERE L.idTipo = 1 AND L.idJogo = v_idJogo AND J.nomeSelecao = p_selecao AND (Jg.fase = 'G1' OR Jg.fase = 'G2' OR Jg.fase = 'G3');
			
			v_somatoria := v_somatoria + (POWER(v_numGols - v_mediaGols, 2));
		END LOOP; 
		CLOSE c_jogos;
		
		IF(n = 1) THEN
			RETURN 0;
		END IF;
		
		v_total := v_somatoria / (n - 1);
		RETURN v_total;
	END;
	
	FUNCTION covariancia(p_selecao VARCHAR2,
						 p_selecao1 VARCHAR2) RETURN NUMBER AS
						   
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
		
		IF((n + n1) = 1) THEN
			RETURN 0;
		END IF;
		
		v_total := v_somatoria / ((n + n1) - 1);
		RETURN v_total;
	END;

	FUNCTION correlacao(p_selecao VARCHAR2,
						p_selecao1 VARCHAR2) RETURN NUMBER AS
						   
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
		
			IF(c_jogos%FOUND AND c_jogos1%FOUND) THEN
				v_somatoria := v_somatoria + ((v_numGols - v_mediaGols) * (v_numGols1 - v_mediaGols1));
			ELSIF(c_jogos1%FOUND) THEN
			  v_somatoria := v_somatoria + ((v_numGols1 - v_mediaGols1));
			ELSIF(c_jogos%FOUND) THEN
			  v_somatoria := v_somatoria + ((v_numGols - v_mediaGols));
			 END IF;
		END LOOP; 
		CLOSE c_jogos;
		CLOSE c_jogos1;
		
		IF((v_variancia = 0) OR (v_variancia1 = 0)) THEN
			RETURN 0;
		END IF;
		
		v_total := v_somatoria / (sqrt(v_variancia) * sqrt(v_variancia1));
		RETURN v_total;
	END;
	
END calculosEstatisticos;