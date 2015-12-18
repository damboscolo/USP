CREATE OR REPLACE PROCEDURE getResumoJogo(p_idJogo NUMBER,
										  p_resumo OUT VARCHAR) AS
	v_resumo VARCHAR(3000);
	v_aux NUMBER;
	
	v_sql VARCHAR(1000);
	v_totalCartAm NUMBER;
	v_totalCartVerm NUMBER;
	
	v_fase CHAR(2);
	v_nomeFase VARCHAR2(100);
	v_selecao1 VARCHAR2(100);
	v_selecao2 VARCHAR2(100);
	v_grupo NUMBER;
	v_golsSelecao1 NUMBER;
	v_golsSelecao2 NUMBER;
	v_nomeJogador VARCHAR2(100);
	v_estadio VARCHAR2(100);
	v_data DATE;
	v_numCartAmSelecao1 NUMBER;
	v_numCartAmSelecao2 NUMBER;
	v_numCartVermSelecao1 NUMBER;
	v_numCartVermSelecao2 NUMBER;
	v_numPatr NUMBER;
	v_nomeJuiz VARCHAR2(100);
	v_numBandeirinhas NUMBER;
	v_nomePatr VARCHAR2(100);

	v_cur SYS_REFCURSOR;

BEGIN
	SELECT Jg.fase, E.nome INTO v_fase, v_estadio
	FROM Jogo Jg
	JOIN Estadio E ON E.id = Jg.idEstadio
	WHERE Jg.id = p_idJogo;
	
	SELECT nomeSelecao1, nomeSelecao2 INTO v_selecao1, v_selecao2
	FROM Informacao Inf
	WHERE Inf.idJogo = p_idJogo;
	
	SELECT idGrupo INTO v_grupo
	FROM Selecao S
	WHERE S.nomeNacao = v_selecao1;
	
	SELECT DISTINCT COUNT(*) INTO v_golsSelecao1
	FROM Lance L
	JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
	JOIN Jogador J ON J.idPessoa = Par.idJogador
	WHERE L.idJogo = p_idJogo AND L.idTipo = 1 AND J.nomeSelecao = v_selecao1;
	
	SELECT DISTINCT COUNT(*) INTO v_golsSelecao2
	FROM Lance L
	JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
	JOIN Jogador J ON J.idPessoa = Par.idJogador
	WHERE L.idJogo = p_idJogo AND L.idTipo = 1 AND J.nomeSelecao = v_selecao2;
	
	SELECT dt INTO v_data
	FROM Jogo Jg
	WHERE Jg.id = p_idJogo;
	
	IF(v_fase = 'O') THEN
		v_nomeFase := 'oitavas-de-final';
	ELSIF(v_fase = 'Q') THEN
		v_nomeFase := 'quartas-de-final';
	ELSIF(v_fase = 'S') THEN
		v_nomeFase := 'semi-final';
	ELSIF(v_fase = 'F') THEN
		v_nomeFase := 'final';
	END IF;
	
	IF(v_fase = 'G1' OR v_fase = 'G2' OR v_fase = 'G3') THEN
		v_resumo := 'Partida ' || p_idJogo || ' realizada na fase de grupos pelo Grupo ' || v_grupo || ', terminou com o resultado ' || v_selecao1 || ' ' || v_golsSelecao1 || ' x ' || v_golsSelecao2 || ' ' || v_selecao2 || ', no estádio ' || v_estadio || ' no dia ' || to_char(v_data, 'dd/mm/yy') || '. ';
	ELSE
		v_resumo := 'Partida ' || p_idJogo || ' realizada na fase ' || v_nomeFase || ', terminou com o resultado ' || v_selecao1 || ' ' || v_golsSelecao1 || ' x ' || v_golsSelecao2 || ' ' || v_selecao2 || ', no estádio ' || v_estadio || ' no dia ' || to_char(v_data, 'dd/mm/yy') || '. ';
	END IF;
	
	IF(v_golsSelecao1 > 0) THEN
		v_sql := 'SELECT P.nome FROM Pessoa P JOIN Jogador J ON J.idPessoa = P.id JOIN PartDe Par ON Par.idJogador = J.idPessoa JOIN Lance L ON L.idJogo = Par.idJogo AND L.tempo = Par.tempo WHERE J.nomeSelecao = ''' || v_selecao1 || ''' AND L.idJogo = ' || p_idJogo || ' AND L.idTipo = 1';
		v_aux := v_golsSelecao1;
		OPEN v_cur FOR v_sql;
		LOOP
			v_aux := v_aux - 1;
			FETCH v_cur INTO v_nomeJogador;
			EXIT WHEN v_cur%NOTFOUND;
			v_resumo := v_resumo || v_nomeJogador || ' marcou para ' || v_selecao1;
			EXIT WHEN v_aux = 0;
			v_resumo := v_resumo || ', ';
		END LOOP;
		
		CLOSE v_cur;
	END IF;
	
	IF(v_golsSelecao2 > 0) THEN
		IF(v_golsSelecao1 > 0) THEN
			v_resumo := v_resumo || ', ';
		END IF;
		v_sql := 'SELECT P.nome FROM Pessoa P JOIN Jogador J ON J.idPessoa = P.id JOIN PartDe Par ON Par.idJogador = J.idPessoa JOIN Lance L ON L.idJogo = Par.idJogo AND L.tempo = Par.tempo WHERE J.nomeSelecao = ''' || v_selecao2 || ''' AND L.idJogo = ' || p_idJogo || ' AND L.idTipo = 1';
		v_aux := v_golsSelecao2;
		OPEN v_cur FOR v_sql;
		
		LOOP
			v_aux := v_aux - 1;
			FETCH v_cur INTO v_nomeJogador;
			EXIT WHEN v_cur%NOTFOUND;
			v_resumo := v_resumo || v_nomeJogador || ' marcou para ' || v_selecao2;
			EXIT WHEN v_aux = 0;
			v_resumo := v_resumo || ', ';
		END LOOP;
		
		CLOSE v_cur;
	END IF;
	
	IF((v_golsSelecao1 <> 0) OR (v_golsSelecao2 <> 0)) THEN
		v_resumo := v_resumo || '. ';
	END IF;
	
	SELECT DISTINCT COUNT(*) INTO v_totalCartAm
	FROM Lance L
	JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
	JOIN Jogador J ON J.idPessoa = Par.idJogador
	WHERE L.idJogo = p_idJogo AND L.idTipo = 3;
	
	IF(v_totalCartAm > 0) THEN
		v_resumo := v_resumo || 'Receberam cartões amarelos ';
	END IF;
	
	SELECT DISTINCT COUNT(*) INTO v_numCartAmSelecao1
	FROM Lance L
	JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
	JOIN Jogador J ON J.idPessoa = Par.idJogador
	WHERE L.idJogo = p_idJogo AND L.idTipo = 3 AND J.nomeSelecao = v_selecao1;
	
	IF(v_numCartAmSelecao1 > 0) THEN
		v_sql := 'SELECT P.nome FROM Pessoa P JOIN Jogador J ON J.idPessoa = P.id JOIN PartDe Par ON Par.idJogador = J.idPessoa JOIN Lance L ON L.idJogo = Par.idJogo AND L.tempo = Par.tempo WHERE J.nomeSelecao = ''' || v_selecao1 || ''' AND L.idJogo = ' || p_idJogo || ' AND L.idTipo = 3';
		v_aux := v_numCartAmSelecao1;
		OPEN v_cur FOR v_sql;
		
		LOOP
			v_aux := v_aux - 1;
			FETCH v_cur INTO v_nomeJogador;
			EXIT WHEN v_cur%NOTFOUND;
			v_resumo := v_resumo || v_nomeJogador || ' (' || v_selecao1 || ')';
			EXIT WHEN v_aux = 0;
			v_resumo := v_resumo || ', ';
		END LOOP;
		
		CLOSE v_cur;
	END IF;
	
	SELECT DISTINCT COUNT(*) INTO v_numCartAmSelecao2
	FROM Lance L
	JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
	JOIN Jogador J ON J.idPessoa = Par.idJogador
	WHERE L.idJogo = p_idJogo AND L.idTipo = 3 AND J.nomeSelecao = v_selecao2;
	
	IF(v_numCartAmSelecao2 > 0) THEN
		IF(v_numCartAmSelecao1 > 0) THEN
			v_resumo := v_resumo || ', ';
		END IF;
		v_sql := 'SELECT P.nome FROM Pessoa P JOIN Jogador J ON J.idPessoa = P.id JOIN PartDe Par ON Par.idJogador = J.idPessoa JOIN Lance L ON L.idJogo = Par.idJogo AND L.tempo = Par.tempo WHERE J.nomeSelecao = ''' || v_selecao2 || ''' AND L.idJogo = ' || p_idJogo || ' AND L.idTipo = 3';
		v_aux := v_numCartAmSelecao2;
		OPEN v_cur FOR v_sql;
		
		LOOP
			v_aux := v_aux - 1;
			FETCH v_cur INTO v_nomeJogador;
			EXIT WHEN v_cur%NOTFOUND;
			v_resumo := v_resumo || v_nomeJogador || ' (' || v_selecao2 || ')';
			EXIT WHEN v_aux = 0;
			v_resumo := v_resumo || ', ';
		END LOOP;
		
		CLOSE v_cur;
	END IF;
	
	IF(v_totalCartAm <> 0) THEN
		v_resumo := v_resumo || '. ';
	END IF;
	
	SELECT DISTINCT COUNT(*) INTO v_totalCartVerm
	FROM Lance L
	JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
	JOIN Jogador J ON J.idPessoa = Par.idJogador
	WHERE L.idJogo = p_idJogo AND L.idTipo = 4 AND J.nomeSelecao = v_selecao1;
	
	IF(v_totalCartVerm > 0) THEN
		v_resumo := v_resumo || 'Receberam cartões vermelhos ';
 	END IF;
	
	IF(v_numCartVermSelecao1 > 0) THEN
		v_sql := 'SELECT P.nome FROM Pessoa P JOIN Jogador J ON J.idPessoa = P.id JOIN PartDe Par ON Par.idJogador = J.idPessoa JOIN Lance L ON L.idJogo = Par.idJogo AND L.tempo = Par.tempo WHERE J.nomeSelecao = ''' || v_selecao1 || ''' AND L.idJogo = ' || p_idJogo || ' AND L.idTipo = 4';
		v_aux := v_numCartVermSelecao1;
		OPEN v_cur FOR v_sql;
		
		LOOP
			v_aux := v_aux - 1;
			FETCH v_cur INTO v_nomeJogador;
			EXIT WHEN v_cur%NOTFOUND;
			v_resumo := v_resumo || v_nomeJogador || ' (' || v_selecao2 || ')';
			EXIT WHEN v_aux = 0;
			v_resumo := v_resumo || ', ';
		END LOOP;
		
		CLOSE v_cur;
	END IF;
	
	SELECT DISTINCT COUNT(*) INTO v_numCartVermSelecao2
	FROM Lance L
	JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
	JOIN Jogador J ON J.idPessoa = Par.idJogador
	WHERE L.idJogo = p_idJogo AND L.idTipo = 4 AND J.nomeSelecao = v_selecao2;
	
	IF(v_numCartVermSelecao2 > 0) THEN
		IF(v_numCartVermSelecao1 > 0) THEN
			v_resumo := v_resumo || ', ';
		END IF;
		v_sql := 'SELECT P.nome FROM Pessoa P JOIN Jogador J ON J.idPessoa = P.id JOIN PartDe Par ON Par.idJogador = J.idPessoa JOIN Lance L ON L.idJogo = Par.idJogo AND L.tempo = Par.tempo WHERE J.nomeSelecao = ''' || v_selecao2 || ''' AND L.idJogo = ' || p_idJogo || ' AND L.idTipo = 4';
		v_aux := v_numCartVermSelecao2;
		OPEN v_cur FOR v_sql;
		
		LOOP
			v_aux := v_aux - 1;
			FETCH v_cur INTO v_nomeJogador;
			EXIT WHEN v_cur%NOTFOUND;
			v_resumo := v_resumo || v_nomeJogador || ' (' || v_selecao2 || ')';
			EXIT WHEN v_aux = 0;
			v_resumo := v_resumo || ', ';
		END LOOP;
		
		CLOSE v_cur;
	END IF;
	
	IF(v_totalCartVerm <> 0) THEN
		v_resumo := v_resumo || '.';
	END IF;
	
	SELECT DISTINCT COUNT(*) INTO v_numPatr
	FROM DivEm D
	WHERE D.idJogo = p_idJogo;

	IF(v_numPatr > 0) THEN
		v_resumo := v_resumo || ' Patrocinaram a partida ';
		v_sql := 'SELECT nome FROM Patrocinador P JOIN DivEm D ON D.idPatrocinador = P.id WHERE D.idJogo = ' || p_idJogo;
		v_aux := v_numPatr;
		OPEN v_cur FOR v_sql;
		
		LOOP
			v_aux := v_aux - 1;
			FETCH v_cur INTO v_nomePatr;
			EXIT WHEN v_cur%NOTFOUND;
			v_resumo := v_resumo || v_nomePatr;
			EXIT WHEN v_aux = 0;
			v_resumo := v_resumo || ', ';
		END LOOP;
		v_resumo := v_resumo || '.';
	END IF;
	
	SELECT nome INTO v_nomeJuiz
	FROM Pessoa P
	JOIN Arbitro Ar ON Ar.idPessoa = P.id
	JOIN Apita Ap ON Ap.idArbitro = Ar.idPessoa
	WHERE Ap.idJogo = p_idJogo AND Ap.funcao = 'Principal';
	
	v_resumo := v_resumo || ' Apitaram o jogo ' || v_nomeJuiz || ' (principal)';

	SELECT DISTINCT COUNT(*) INTO v_numBandeirinhas
	FROM Pessoa P
	JOIN Arbitro Ar ON Ar.idPessoa = P.id
	JOIN Apita Ap ON Ap.idArbitro = Ar.idPessoa
	WHERE Ap.idJogo = p_idJogo AND Ap.funcao = 'Bandeirinha';
	
	IF(v_numBandeirinhas > 0) THEN
		v_resumo := v_resumo || ' auxiliado por ';
		v_sql := 'SELECT nome FROM Pessoa P JOIN Arbitro Ar ON Ar.idPessoa = P.id JOIN Apita Ap ON Ap.idArbitro = Ar.idPessoa WHERE Ap.idJogo = ' || p_idJogo || ' AND Ap.funcao = ''Bandeirinha''';
		v_aux := v_numBandeirinhas;
		OPEN v_cur FOR v_sql;
		
		LOOP
			v_aux := v_aux - 1;
			FETCH v_cur INTO v_nomeJuiz;
			EXIT WHEN v_cur%NOTFOUND;
			v_resumo := v_resumo || v_nomeJuiz;
			EXIT WHEN v_aux = 0;
			v_resumo := v_resumo || ', ';
		END LOOP;
		v_resumo := v_resumo || '.';
		CLOSE v_cur;
	ELSE
		v_resumo := v_resumo || '.';
	END IF;
  
  p_resumo := v_resumo;
END;