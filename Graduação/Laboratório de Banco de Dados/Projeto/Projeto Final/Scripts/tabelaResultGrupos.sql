CREATE OR REPLACE PACKAGE tabelaResultadoGrupos AS
	PROCEDURE getVitoriasDerrotasEmpates(p_selecao VARCHAR2,
 	    							     p_vitorias OUT NUMBER,
	    							     p_derrotas OUT NUMBER,
	    							     p_empates OUT NUMBER,
	    							     p_numJogos OUT NUMBER);
	PROCEDURE dadosTabelaGrupo(p_resultado OUT SYS_REFCURSOR, 
	     				       p_vitorias OUT t_dados,
							   p_derrotas OUT t_dados,
	 						   p_empates OUT t_dados,
	 						   p_numJogos OUT t_dados,
	 						   p_porcAprov OUT t_dados,
	 						   p_mediaGols OUT t_dados,
	 						   p_varianciaGols OUT t_dados,
                               p_numeroGrupo NUMBER);
END tabelaResultadoGrupos;	
/

CREATE OR REPLACE PACKAGE BODY tabelaResultadoGrupos AS

	PROCEDURE getVitoriasDerrotasEmpates(p_selecao VARCHAR2,
										 p_vitorias OUT NUMBER,
										 p_derrotas OUT NUMBER,
										 p_empates OUT NUMBER,
										 p_numJogos OUT NUMBER) AS
		v_gols1 NUMBER;
		v_gols2 NUMBER;
		v_vitoria NUMBER;
		v_empate  NUMBER;
		v_derrota NUMBER;
		v_numJogos NUMBER;
		
		v_idJogo NUMBER;
		v_selecao1 VARCHAR2(100);
		v_selecao2 VARCHAR2(100);
		
		CURSOR c_jogos IS SELECT idJogo, nomeSelecao1, nomeSelecao2 
						  FROM Informacao Inf
						  JOIN Jogo Jg ON Jg.id = Inf.idJogo
						  WHERE (Inf.nomeSelecao1 = p_selecao OR Inf.nomeSelecao2 = p_selecao) AND (Jg.fase = 'G1' OR Jg.fase = 'G2' OR Jg.fase = 'G3');
		BEGIN
		
			v_vitoria := 0;
			v_empate := 0;
			v_derrota := 0;
			v_numJogos := 0;
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
					ELSIF(v_gols1 > v_gols2 AND v_selecao2 = p_selecao) THEN
						v_derrota := v_derrota + 1;
					ELSIF(v_gols1 < v_gols2 AND v_selecao1 = p_selecao) THEN
						v_derrota := v_derrota + 1;
					ELSIF(v_gols1 = v_gols2 AND v_selecao1 <> v_selecao2) THEN
						v_empate := v_empate + 1;
					END IF;
				EXIT WHEN c_jogos%NOTFOUND;
			END LOOP;

			CLOSE c_jogos;
			
			p_numJogos := v_numJogos;
			p_vitorias := v_vitoria;
			p_derrotas := v_derrota;
			p_empates := v_empate;
			
		  EXCEPTION 
			WHEN OTHERS THEN
				dbms_output.put_line(SQLErrm);
	END;

	PROCEDURE dadosTabelaGrupo(p_resultado OUT SYS_REFCURSOR, 
	     				       p_vitorias OUT t_dados,
							   p_derrotas OUT t_dados,
	 						   p_empates OUT t_dados,
	 						   p_numJogos OUT t_dados,
	 						   p_porcAprov OUT t_dados,
	 						   p_mediaGols OUT t_dados,
	 						   p_varianciaGols OUT t_dados,
                               p_numeroGrupo NUMBER) AS
		v_sql VARCHAR2(1000);
		v_nomeNacao VARCHAR(100);
		v_pontos NUMBER;
		v_saldo NUMBER;
		v_vitoria NUMBER;
		v_derrota NUMBER;
		v_empate NUMBER;
		v_numJogos NUMBER;
		v_porcAprov NUMBER;
		v_mediaGols NUMBER;
		v_varianciaGols NUMBER;
		
		i NUMBER;
		
		v_vitoriasVetor t_dados := t_dados();
		v_derrotasVetor t_dados := t_dados();
		v_empatesVetor t_dados := t_dados();
		v_numJogosVetor t_dados := t_dados();
		v_porcAprovVetor t_dados := t_dados();
		v_mediaGolsVetor t_dados := t_dados();
		v_varianciaGolsVetor t_dados := t_dados();
		
		c1 SYS_REFCURSOR;
		BEGIN
			v_sql := 'SELECT nomeNacao, pontos, saldo FROM Selecao S WHERE S.idGrupo = ' || p_numeroGrupo || ' ORDER BY pontos, saldo';
			i := 0;
			OPEN c1 FOR v_sql;
			LOOP
				FETCH c1 INTO v_nomeNacao, v_pontos, v_saldo;
				EXIT WHEN c1%NOTFOUND;
				i := i + 1;
				tabelaResultadoGrupos.getVitoriasDerrotasEmpates(v_nomeNacao, v_vitoria, v_derrota, v_empate, v_numJogos);
				v_vitoriasVetor.extend;
				v_vitoriasVetor(i) := v_vitoria;
				v_derrotasVetor.extend;
				v_derrotasVetor(i) := v_derrota;
				v_empatesVetor.extend;
				v_empatesVetor(i) := v_empate;
				v_numJogosVetor.extend;
				v_numJogosVetor(i) := v_numJogos;
				
				v_porcAprov := calculosEstatisticos.porcAproveitamento(v_nomeNacao);
				v_mediaGols := calculosEstatisticos.mediaGols(v_nomeNacao);
				v_varianciaGols := calculosEstatisticos.varianciaGols(v_nomeNacao);
				v_porcAprovVetor.extend;
				v_porcAprovVetor(i) := v_porcAprov;
				v_mediaGolsVetor.extend;
				v_mediaGolsVetor(i) := v_mediaGols;
				v_varianciaGolsVetor.extend;
				v_varianciaGolsVetor(i) := v_varianciaGols;
			END LOOP;
			CLOSE c1;
			
			v_sql := 'SELECT nomeNacao, pontos, golsMarcados, golsSofridos, saldo FROM Selecao S WHERE S.idGrupo = ' || p_numeroGrupo || ' ORDER BY pontos, saldo';
			OPEN p_resultado FOR v_sql;
			p_vitorias := v_vitoriasVetor;
			p_derrotas := v_derrotasVetor;
			p_empates := v_empatesVetor;
			p_numJogos := v_numJogosVetor;
			p_porcAprov := v_porcAprovVetor;
			p_mediaGols := v_mediaGolsVetor;
			p_varianciaGols := v_varianciaGolsVetor;
			END dadosTabelaGrupo;
	
END tabelaResultadoGrupos;

--Teste
DECLARE
  p_resultado SYS_REFCURSOR;
  p_vitorias t_dados;
  p_derrotas t_dados;
  p_empates t_dados;
  p_numJogos t_dados;
  p_porcAprov t_dados;
  p_mediaGols t_dados;
  p_varianciaGols t_dados;
  
  nome VARCHAR2(100);
  pontos NUMBER;
  golsMarcados NUMBER;
  golsSofridos NUMBER;
  saldo NUMBER;
  
  i NUMBER;
BEGIN
  TABELARESULTADOGRUPOS.DADOSTABELAGRUPO(p_resultado, p_vitorias, p_derrotas, p_empates, p_numJogos, p_porcAprov, p_mediaGols, p_varianciaGols, 4);
  i := 0;
  LOOP
    FETCH p_resultado INTO nome, pontos, golsMarcados, golsSofridos, saldo;
    EXIT WHEN p_resultado%NOTFOUND;
    i := i + 1;
    dbms_output.put_line(nome || ', ' || pontos || ', ' || golsMarcados || ', ' || golsSofridos || ', ' || saldo  || ', ' || p_vitorias(i) || ', ' || p_derrotas(i) || ', ' || p_empates(i) || ', ' || p_numJogos(i) || ', ' || p_porcAprov(i) || ', ' || p_mediaGols(i) || ', ' || p_varianciaGols(i));
  END LOOP;
  CLOSE p_resultado;
END;