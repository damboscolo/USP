SET SERVEROUTPUT ON;
DECLARE
	v_gols1 NUMBER;
	v_gols2 NUMBER;
	v_vitoria NUMBER;
	v_empate  NUMBER;
  v_numJogos NUMBER;
  v_totalPontos NUMBER;
  v_maxPontos NUMBER;
  v_porcAprov NUMBER;
  
	p_selecao VARCHAR(100);
  
	v_idJogo Informacao.idJogo%TYPE;
	v_selecao1 Informacao.nomeSelecao1%TYPE;
	v_selecao2 Informacao.nomeSelecao2%TYPE;
	
	CURSOR c_jogos IS SELECT idJogo, nomeSelecao1, nomeSelecao2 
					  FROM Informacao Inf
					  WHERE Inf.nomeSelecao1 = 'Holanda' OR Inf.nomeSelecao2 = 'Holanda';
BEGIN
  p_selecao := 'Holanda';  
  v_vitoria := 0;
  v_empate := 0;
  
	--v_numJogos := c_jogos%LENGTH;
  
  OPEN c_jogos;

	LOOP
		FETCH c_jogos INTO v_idJogo, v_selecao1, v_selecao2;
      -- numero de jogos
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
  v_porcAprov := (v_totalPontos / v_maxPontos) * 100;
  DBMS_OUTPUT.PUT_LINE('vitoria: ' || v_vitoria || ' | empate: ' || v_empate || ' - ' || v_numJogos|| ' - '|| v_totalPontos || ' - '||  v_maxPontos || ' - Porcentagem: ' || v_porcAprov || '%');
  CLOSE c_jogos;
    EXCEPTION 
  WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE(SQLCode || ' ' || SQLErrm);
END;
	
