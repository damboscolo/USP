CREATE OR REPLACE PACKAGE faseGrupos AS
	PROCEDURE criarFaseGrupos;
END faseGrupos;
/
CREATE OR REPLACE PACKAGE BODY faseGrupos AS	
	PROCEDURE criarJogo(p_idJogo OUT NUMBER) AS
		v_rand NUMBER;
		v_sql VARCHAR(1000);

		v_idEstadio NUMBER;
		v_hora CHAR(5);
		v_data DATE;
		v_fase CHAR(2);
		v_renda NUMBER;
		v_publico NUMBER;
	BEGIN	
			SELECT CAST(dbms_random.value(1, 10) AS INTEGER) INTO v_idEstadio
			FROM DUAL;
			
			SELECT CAST(dbms_random.value(1, 4) AS INTEGER) INTO v_rand
			FROM DUAL;
			
			CASE v_rand
				WHEN 1 THEN v_hora := '13:00';
				WHEN 2 THEN v_hora := '16:00';
				WHEN 3 THEN v_hora := '17:00';
				WHEN 4 THEN v_hora := '19:00';
			END CASE;
			
			SELECT to_date(trunc(dbms_random.value(to_char(date '2010-06-01','J'), to_char(date '2010-06-15','J'))), 'J') INTO v_data
			FROM DUAL;
			
			SELECT CAST(dbms_random.value(1, 3) AS INTEGER) INTO v_rand
			FROM DUAL;
			
			CASE v_rand
				WHEN 1 THEN v_fase := 'G1';
				WHEN 2 THEN v_fase := 'G2';
				WHEN 3 THEN v_fase := 'G3';
			END CASE;
			
			SELECT CAST(dbms_random.value(100000, 1000000) AS INTEGER) INTO v_renda
			FROM DUAL;
			
			SELECT CAST(dbms_random.value(100000, 999999) AS INTEGER) INTO v_publico
			FROM DUAL;
			
			v_sql := 'INSERT INTO Jogo(idEstadio, hr, dt, fase, renda, publicoPresente) VALUES(' || v_idEstadio || ', ''' || v_hora || ''', to_date( ''' ||  v_data || ''', ''dd/mm/yy''), ''' || v_fase || ''', ' || v_renda || ', ' || v_publico || ')';
			EXECUTE IMMEDIATE v_sql;
			
			SELECT id INTO p_idJogo
			FROM Jogo Jg
			WHERE idEstadio = v_idEstadio AND renda = v_renda AND publicoPresente = v_publico;
		
	END criarJogo;
	
	PROCEDURE criarLances(p_idJogo NUMBER, p_nomeSelecao VARCHAR2) AS
		v_rand NUMBER;
		v_aux NUMBER;
		v_sql VARCHAR2(1000);
		
		v_nomeJogador VARCHAR2(100);
		v_idJogador NUMBER;
		v_idTipo NUMBER;
		v_hora CHAR(2);
		v_min CHAR(2);
		v_tempo CHAR(5);
		v_descricao VARCHAR2(100);
		
		v_cur SYS_REFCURSOR;
	BEGIN
		v_sql := 'SELECT idPessoa FROM Jogador J WHERE J.nomeSelecao = ''' || p_nomeSelecao || '''';
		OPEN v_cur FOR v_sql;
		
		LOOP
			v_aux := 0;
			FETCH v_cur INTO v_idJogador;
			EXIT WHEN v_cur%NOTFOUND;
			
			SELECT nome INTO v_nomeJogador
			FROM Pessoa P
			WHERE P.id = v_idJogador;
			
			SELECT CAST(dbms_random.value(00, 89) AS INTEGER) INTO v_hora
			FROM DUAL;
			
			SELECT CAST(dbms_random.value(00, 59) AS INTEGER) INTO v_min
			FROM DUAL;

			v_tempo := v_hora || ':' || v_min;
			
			SELECT CAST(dbms_random.value(1, 3) AS INTEGER) INTO v_rand
			FROM DUAL;
			
			CASE v_rand
				WHEN 1 THEN v_idTipo := 1;
				WHEN 2 THEN v_idTipo := 3;
				WHEN 3 THEN v_idTipo := 4;
			END CASE;
      
			CASE v_idTipo
				WHEN 1 THEN  v_descricao := 'Gol feito aos ' || v_tempo || ' por ' || v_nomeJogador || ' da ' || p_nomeSelecao || '.';
				WHEN 3 THEN  v_descricao := 'Cartão amarelo para ' || v_nomeJogador || '(' || p_nomeSelecao || ') aos ' || v_tempo || '.';
				WHEN 4 THEN  v_descricao := 'Cartão vermelho para ' || v_nomeJogador || '(' || p_nomeSelecao || ') aos ' || v_tempo || '.';
			END CASE;
			
			v_sql := 'INSERT INTO JogouEm(idJogo, idJogador, titular) VALUES(' || p_idJogo || ', ''' || v_idJogador || ''', ''S'')';
			EXECUTE IMMEDIATE v_sql;
			
			v_sql := 'INSERT INTO Lance(idJogo, tempo, idTipo, descricao) VALUES(' || p_idJogo || ', ''' || v_tempo || ''', ' || v_idTipo || ', ''' || v_descricao || ''')';
			EXECUTE IMMEDIATE v_sql;
			
			v_sql := 'INSERT INTO PartDe(idJogo, tempo, idJogador) VALUES(' || p_idJogo || ', ''' || v_tempo || ''', ' || v_idJogador || ')';
			EXECUTE IMMEDIATE v_sql;
			
		END LOOP;
		
		CLOSE v_cur;
	END criarLances;
	
	PROCEDURE criarJuizes(p_idJogo NUMBER) AS
		v_sql VARCHAR2(1000);
		v_juiz1 NUMBER;
		v_juiz2 NUMBER;
		v_juiz3 NUMBER;
		
		v_cur SYS_REFCURSOR;
	BEGIN
		LOOP
			SELECT * INTO v_juiz1
			FROM (SELECT idPessoa
				  FROM Arbitro
				  ORDER BY dbms_random.value)
			WHERE rownum = 1;
			
			SELECT * INTO v_juiz2
			FROM (SELECT idPessoa
				  FROM Arbitro
				  ORDER BY dbms_random.value)
			WHERE rownum = 1;
			
			SELECT * INTO v_juiz3
			FROM (SELECT idPessoa
				  FROM Arbitro
				  ORDER BY dbms_random.value)
			WHERE rownum = 1;
			
			EXIT WHEN (v_juiz1 <> v_juiz2 AND v_juiz1 <> v_juiz3 AND v_juiz2 <> v_juiz3);
		END LOOP;
		
		v_sql := 'INSERT INTO Apita(idArbitro, idJogo, funcao) VALUES(' || v_juiz1 || ', ' || p_idJogo || ', ''Principal'')';
		EXECUTE IMMEDIATE v_sql;
		
		v_sql := 'INSERT INTO Apita(idArbitro, idJogo, funcao) VALUES(' || v_juiz2 || ', ' || p_idJogo || ', ''Bandeirinha'')';
		EXECUTE IMMEDIATE v_sql;
		
		v_sql := 'INSERT INTO Apita(idArbitro, idJogo, funcao) VALUES(' || v_juiz3 || ', ' || p_idJogo || ', ''Bandeirinha'')';
		EXECUTE IMMEDIATE v_sql;
		
	END criarJuizes;
	
	PROCEDURE criarFaseGrupos AS
		v_nomeNacao VARCHAR2(100);
		
		v_sql VARCHAR2(1000);
		v_loop NUMBER;
		v_aux NUMBER;
		v_aux1 NUMBER;
		
		v_idJogo NUMBER;
		
		TYPE v_grupos IS VARRAY(4) OF VARCHAR2(100);
		v_vetorNacao v_grupos := v_grupos();
		
		v_cur SYS_REFCURSOR;
	BEGIN
		v_vetorNacao.extend;
		v_vetorNacao.extend;
		v_vetorNacao.extend;
		v_vetorNacao.extend;
		FOR v_loop IN 1..8 LOOP
			v_sql := 'SELECT nomeNacao FROM Selecao S WHERE S.idGrupo = ' || v_loop;
			OPEN v_cur FOR v_sql;
			
			v_aux := 1;
			LOOP
				FETCH v_cur INTO v_nomeNacao;
				EXIT WHEN v_cur%NOTFOUND;
				v_vetorNacao(v_aux) := v_nomeNacao;
				v_aux := v_aux + 1;
			END LOOP;
			
			CLOSE v_cur;
			
			v_aux := 1;
			v_aux1 := 1;
			FOR v_aux IN 1..3 LOOP 
				FOR v_aux1 IN v_aux+1..4 LOOP
					IF(v_vetorNacao(v_aux) <> v_vetorNacao(v_aux1)) THEN
						faseGrupos.criarJogo(v_idJogo);
						INSERT INTO Informacao VALUES(v_idJogo, v_vetorNacao(v_aux), v_vetorNacao(v_aux1));
						faseGrupos.criarJuizes(v_idJogo);
						faseGrupos.criarLances(v_idJogo, v_vetorNacao(v_aux));
						faseGrupos.criarLances(v_idJogo, v_vetorNacao(v_aux1));
					END IF;
				END LOOP;
			END LOOP;
			
		END LOOP;
	END criarFaseGrupos;
	
END faseGrupos;