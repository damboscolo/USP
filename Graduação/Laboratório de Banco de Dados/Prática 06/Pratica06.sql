--Exercicio 1
ALTER TABLE Estadio
ADD (numSelecoes NUMBER,
	 numJogadDist NUMBER,
	 numGols NUMBER,
	 numCartVerm NUMBER,
	 numCartAm NUMBER);
	
SET SERVEROUTPUT ON;
DECLARE
       Selec NUMBER;
       JogadDist NUMBER;
       Gols NUMBER;
       CartVerm NUMBER;
       CartAm NUMBER;
	   
       CURSOR c_estadio IS SELECT id 
						   FROM Estadio;

BEGIN     
     FOR aux IN c_estadio LOOP
             SELECT count(*) INTO Selec
             FROM Estadio E
             JOIN Jogo Jg ON Jg.idEstadio = E.id
             JOIN Informacao Inf ON Inf.idJogo = Jg.id
             JOIN Selecao S ON S.nomeNacao = Inf.nomeSelecao1 OR S.nomeNacao = Inf.nomeSelecao2
             WHERE E.id = aux.id;
             
             UPDATE Estadio
             SET numSelecoes = Selec
             WHERE Estadio.id = aux.id;
	  END LOOP;
	  
	  FOR aux IN c_estadio LOOP
			SELECT count(DISTINCT P.nome) INTO JogadDist
			FROM Pessoa P
			JOIN Jogador J ON J.idPessoa = P.id
			JOIN Selecao S ON S.nomeNacao = J.nomeSelecao
			JOIN Informacao Inf ON Inf.nomeSelecao1 = S.nomeNacao OR Inf.nomeSelecao2 = S.nomeNacao
			JOIN Jogo Jg ON Jg.id = Inf.idJogo
			JOIN Estadio E ON E.id = Jg.idEstadio
			JOIN Lance L ON L.idJogo = Jg.id
			JOIN PartDe Par ON Par.idJogador = J.idPessoa AND Par.idJogo = L.idJogo AND Par.tempo = L.tempo
			WHERE E.id = aux.id;
			
			UPDATE Estadio
			SET numJogadDist = JogadDist
			WHERE Estadio.id = aux.id;
	  END LOOP;
	  
	  FOR aux IN c_estadio LOOP
			SELECT DISTINCT count(E.nome) INTO Gols
			FROM Estadio E
			JOIN Jogo Jg ON Jg.idEstadio = E.id
			JOIN Informacao Inf ON Inf.idJogo = Jg.id
			JOIN Selecao S ON S.nomeNacao = Inf.nomeSelecao1 OR S.nomeNacao = Inf.nomeSelecao2
			JOIN Jogador J ON J.nomeSelecao = S.nomeNacao
			JOIN Lance L ON L.idJogo = Jg.id
			JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo AND Par.idJogador = J.idPessoa
			WHERE E.id = aux.id AND L.idTipo = 1;
			
			UPDATE Estadio
			SET numGols = Gols
			WHERE Estadio.id = aux.id;
	  END LOOP;
	  
	  FOR aux IN c_estadio LOOP
			SELECT DISTINCT count(E.nome) INTO CartVerm
			FROM Estadio E
			JOIN Jogo Jg ON Jg.idEstadio = E.id
			JOIN Informacao Inf ON Inf.idJogo = Jg.id
			JOIN Selecao S ON S.nomeNacao = Inf.nomeSelecao1 OR S.nomeNacao = Inf.nomeSelecao2
			JOIN Jogador J ON J.nomeSelecao = S.nomeNacao
			JOIN Lance L ON L.idJogo = Jg.id
			JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo AND Par.idJogador = J.idPessoa
			WHERE E.id = aux.id AND L.idTipo = 4;
	        
			UPDATE Estadio
			SET numCartVerm = CartVerm
			WHERE Estadio.id = aux.id;
	  END LOOP;
	  
	  FOR aux IN c_estadio LOOP
			SELECT DISTINCT count(E.nome) INTO CartAm
			FROM Estadio E
			JOIN Jogo Jg ON Jg.idEstadio = E.id
			JOIN Informacao Inf ON Inf.idJogo = Jg.id
			JOIN Selecao S ON S.nomeNacao = Inf.nomeSelecao1 OR S.nomeNacao = Inf.nomeSelecao2
			JOIN Jogador J ON J.nomeSelecao = S.nomeNacao
			JOIN Lance L ON L.idJogo = Jg.id
			JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo AND Par.idJogador = J.idPessoa
			WHERE E.id = aux.id AND L.idTipo = 3;
			
			UPDATE Estadio
			SET numCartAm = CartAm
			WHERE Estadio.id = aux.id;
      END LOOP;
END;

--Exercicio 2
SET SERVEROUTPUT ON;
DECLARE
		--DECLARE VariaveisChecagemNumGrupos
		numGrupos NUMBER;
		--END DECLARE
		
		--DECLARE VariaveisChecagemNumSelecPorGrupos
		selecPorGrupos NUMBER;
		lastRowId ROWID;
		--END DECLARE
		
		--DECLARE VariaveisChecagemSelecoes3Partidas
		numPartFaseGrupos NUMBER;
		--END DECLARE
		
		--DECLARE VariaveisChecagemSuspensoes
		nomeJogador VARCHAR(100);
		numCartoesAmarelos NUMBER;
		--END DECLARE
		
		--DECLARE VariaveisChecagemArbitrosSelecoes
		nomeArbitro VARCHAR(100); --usada também em ChecagemArbitros
		
		TYPE idJogosArb IS TABLE OF Apita.idJogo%TYPE;
		TYPE idArb IS TABLE OF Arbitro.idPessoa%TYPE;
		jogosArbPart idJogosArb;
		jogosIdArb idArb;
		
		TYPE idJogosSel IS TABLE OF Informacao.idJogo%TYPE;
		TYPE nomeSel IS TABLE OF Selecao.nomeNacao%TYPE;
		jogosSelPart idJogosSel;
		jogosNomeSelec nomeSel;
		
		numJogosPart NUMBER;
		dataJogo1 DATE;
		dataJogo2 DATE;
		--END DECLARE
		
		--DECLARE VariaveisChecagemArbitros
		nomeNacaoArbitro VARCHAR(100);
		--END DECLARE
		
		--DECLARE Cursors
		CURSOR c_grupo IS SELECT id 
						  FROM Grupo;
						  
		CURSOR c_selecao IS SELECT nomeNacao 
							FROM Selecao;
							
		CURSOR c_jogador IS SELECT idPessoa, L.idJogo
							FROM Jogador J
							JOIN PartDe Par ON Par.idJogador = J.idPessoa
							JOIN Lance L ON L.idJogo = Par.idJogo
							WHERE L.idTipo = 3
							ORDER BY L.idJogo;
		CURSOR c_jogosCartAm IS SELECT DISTINCT id, JgEm.idJogador
								FROM Jogo Jg
								JOIN JogouEm JgEm ON JgEm.idJogo = Jg.id
								JOIN Lance L ON L.idJogo = Jg.id
								WHERE L.idTipo = 3;
		CURSOR c_jogosJogador IS SELECT idJogo, idJogador
								 FROM JogouEm;
		
		CURSOR c_arbitroJogos IS SELECT DISTINCT idJogo, idPessoa
								 FROM Arbitro A
								 JOIN Apita Ap ON Ap.idArbitro = A.idPessoa
								 WHERE Ap.funcao NOT IN ('Reserva')
								 ORDER BY idJogo;
		CURSOR c_selecaoJogos IS SELECT DISTINCT idJogo, nomeNacao
								 FROM Selecao S
								 JOIN Informacao Inf ON Inf.nomeSelecao1 = S.nomeNacao OR Inf.nomeSelecao1 = S.nomeNacao
								 ORDER BY idJogo;
		
		CURSOR c_arbitro IS SELECT idPessoa
							FROM Arbitro;
		CURSOR c_nomeSelecao IS SELECT idArbitro, nomeSelecao1, nomeSelecao2
								FROM Informacao Inf
								JOIN Apita Ap ON Ap.idJogo = Inf.idJogo;
		--END DECLARE
BEGIN
	--BEGIN ChecagemNumGrupos
	--Checagem do número de grupos.
	SELECT count(*) INTO numGrupos
	FROM Grupo;

	IF(numGrupos <> 8) THEN
			dbms_output.put_line('Tabela Grupo, não existem exatamente 8 grupos.');
	END IF;
	--END ChecagemNumGrupos

	--BEGIN ChecagemNumSelecPorGrupo
	--Checagem do número de seleções em cada grupo.
	FOR aux IN c_grupo LOOP
		SELECT count(*) INTO selecPorGrupos
		FROM Grupo G
		JOIN Selecao S ON S.idGrupo = G.id
		WHERE G.id = aux.id;
		
		SELECT rowid INTO lastRowId
		FROM Grupo G
		WHERE G.id = aux.id;

		IF(SelecPorGrupos <> 4) THEN
			dbms_output.put_line('Tabela Grupo, rowid ' || lastRowId || ', o grupo ' || aux.id || ' não possui exatamente 4 seleções');
		END IF;
	END LOOP;
	--END ChecagemNumSelecPorGrupo
	
	--BEGIN ChecagemSelecoes3Partidas
	--Checagem das seleções não realizarem mais de 3 partidas na fase de grupos
	FOR aux IN c_selecao LOOP
		SELECT DISTINCT count(CASE WHEN Inf.nomeSelecao1 = aux.nomeNacao OR Inf.nomeSelecao2 = aux.nomeNacao THEN 1 END) INTO numPartFaseGrupos
		FROM Informacao Inf
		JOIN Jogo Jg ON Jg.id = Inf.idJogo
		JOIN Selecao S ON S.nomeNacao = Inf.nomeSelecao1 OR S.nomeNacao = Inf.nomeSelecao2
		WHERE Jg.fase = 'G1' OR Jg.fase = 'G2' OR Jg.fase = 'G3';
		
		SELECT rowid INTO lastRowId
		FROM Selecao S
		WHERE S.nomeNacao = aux.nomeNacao;
		
		IF(numPartFaseGrupos > 3) THEN
			dbms_output.put_line('Tabela Selecao, rowid ' || lastRowId || ', a seleção ' || aux.nomeNacao || ' realizou mais do que 3 jogos na fase de grupos.');
		END IF;
	END LOOP;
	--END ChecagemSelecoes3Partidas
	
	--BEGIN ChecagemSuspensoes
	--Checagem das suspensões das partidas por jogadores com mais de 2 cartões amarelos.
	FOR aux IN c_jogador LOOP
		SELECT count(DISTINCT L.idJogo) INTO numCartoesAmarelos
		FROM Jogador J
		JOIN Pessoa P ON P.id = J.idPessoa
		JOIN Informacao I ON I.nomeSelecao1  = J.nomeSelecao OR I.nomeSelecao2 = J.nomeSelecao
		JOIN Jogo Jg ON Jg.id = I.idJogo
		JOIN Lance L ON L.idJogo = Jg.id
		JOIN PartDe Par ON Par.idJogador = J.idPessoa AND Par.idJogo = Jg.id AND Par.tempo = L.tempo
		WHERE L.idTipo = 3 AND P.id = aux.idPessoa AND (Jg.fase = 'G1' OR Jg.fase = 'G2' OR Jg.fase = 'G3');
		
		IF(numCartoesAmarelos > 2) THEN
			SELECT id INTO ultimoJogoCartAm
			FROM Jogo Jg
			JOIN JogouEm JgEm ON JgEm.idJogo = Jg.id
			JOIN Lance L ON L.idJogo = Jg.id
			WHERE JgEm.idJogador = aux.idPessoa AND L.idTipo = 3 AND (Jg.fase = 'G1' OR Jg.fase = 'G2' OR Jg.fase = 'G3') AND Jg.dt > (SELECT dt
																																	   FROM Jogo Jg
																																	   WHERE Jg.id = aux.idJogo);
			
			OPEN c_jogosJogador;
			LOOP
				FETCH c_jogosJogador INTO idJogadorAm, idJogoAm;
				IF(idJogadorAm = aux.idPessoa) THEN
					IF(idJogoAm <> ultimoJogoCartAm) THEN
						SELECT dt INTO dataJogo1
						FROM Jogo Jg
						WHERE Jg.id = idJogoAm;
						
						SELECT dt INTO dataJogo2
						FROM Jogo Jg
						WHERE Jg.id = ultimoJogoCartAm;
						
						IF()
					END IF;
				END IF;
			END LOOP;
 		END IF;
 	END LOOP;
	--END ChecagemSuspensoes
	
	--BEGIN ChecagemArbitrosSelecoes
	--Checagem dos árbitros e seleções não participarem em dias consecutivos (60 horas de descanso).
	OPEN c_arbitroJogos;
	
	FETCH c_arbitroJogos BULK COLLECT INTO jogosArbPart, jogosIdArb;
	
	CLOSE c_arbitroJogos;
	
	FOR i IN jogosIdArb.FIRST .. (jogosIdArb.LAST - 1) LOOP
		SELECT count(*) INTO numJogosPart
		FROM Arbitro A
		JOIN Apita Ap ON Ap.idArbitro = A.idPessoa
		WHERE A.idPessoa = jogosIdArb(i);
		
		SELECT nome INTO nomeArbitro
		FROM Pessoa P
		WHERE P.id = jogosIdArb(i);
		
		IF(numJogosPart > 1) THEN
			IF(jogosIdArb(i) = jogosIdArb(i + 1)) THEN
				IF(jogosArbPart(i) <> jogosArbPart(i + 1)) THEN
					SELECT dt INTO dataJogo1
					FROM Jogo Jg
					WHERE Jg.id = jogosArbPart(i);
					
					SELECT dt INTO dataJogo2
					FROM Jogo Jg
					WHERE Jg.id = jogosArbPart(i + 1);
					
					SELECT rowid INTO lastRowId
					FROM Apita Ap
					WHERE Ap.idArbitro = jogosArbPart(i) AND Ap.idJogo = jogosArbPart(i + 1);
					
					IF((dataJogo2 - dataJogo1)*24 < 60) THEN
						dbms_output.put_line('Tabela Apita, rowid ' || lastRowId || ', o árbitro ' ||  nomeArbitro || ' apitou o jogo sem respeitar o intervalo mínimo de descanso.');
					END IF;
				END IF;
			END IF;
		END IF;
	END LOOP;
	
	OPEN c_selecaoJogos;
	
	FETCH c_selecaoJogos BULK COLLECT INTO jogosSelPart, jogosNomeSelec;
	
	CLOSE c_selecaoJogos;
	
	FOR i IN jogosSelPart.FIRST .. (jogosSelPart.LAST - 1) LOOP
		SELECT count(*) INTO numJogosPart
		FROM Selecao S
		JOIN Informacao Inf ON Inf.nomeSelecao1 = S.nomeNacao OR Inf.nomeSelecao2 = S.nomeNacao
		WHERE S.nomeNacao = jogosNomeSelec(i);
		
		IF(numJogosPart > 1) THEN
			IF(jogosNomeSelec(i) = jogosNomeSelec(i + 1)) THEN
				IF(jogosSelPart(i) <> jogosSelPart(i + 1)) THEN
					SELECT dt INTO dataJogo1
					FROM Jogo Jg
					WHERE Jg.id = jogosSelPart(i);
					
					SELECT dt INTO dataJogo2
					FROM Jogo Jg
					WHERE Jg.id = jogosSelPart(i + 1);
					
					SELECT rowid INTO lastRowId
					FROM Informacao Inf
					WHERE Inf.idJogo = jogosSelPart(i + 1) AND (Inf.nomeSelecao1 = jogosNomeSelec(i) OR Inf.nomeSelecao2 = jogosNomeSelec(i));
					
					IF((dataJogo2 - dataJogo1)*24 < 60) THEN
						dbms_output.put_line('Tabela Informacao, rowid ' || lastRowId || ', a seleção ' || jogosNomeSelec(i) || ' jogou sem respeitar o intervalo mínimo de descanso.');
					END IF;
				END IF;
			END IF;
		END IF;
	END LOOP;
	--END ChecagemArbitrosSelecoes
	
	--BEGIN ChecagemArbitros
	--Checagem de que os árbitros não participem de jogos das seleções de seus países
	FOR aux IN c_arbitro LOOP
		SELECT nomeNacao INTO nomeNacaoArbitro
		FROM PertenceA PerA
		WHERE PerA.idPessoa = aux.idPessoa;
		
		SELECT nome INTO nomeArbitro
		FROM Pessoa P
		WHERE P.id = aux.idPessoa;
		
		FOR auxSelec IN c_nomeSelecao LOOP
			IF(aux.idPessoa = auxSelec.idArbitro) THEN
				IF(nomeNacaoArbitro = auxSelec.nomeSelecao1 OR nomeNacaoArbitro = auxSelec.nomeSelecao2) THEN
					SELECT Ap.rowid INTO lastRowId
					FROM Apita Ap
					JOIN Informacao Inf ON Inf.idJogo = Ap.idJogo
					WHERE Ap.idArbitro = aux.idPessoa AND (Inf.nomeSelecao1 = nomeNacaoArbitro OR Inf.nomeSelecao2 = nomeNacaoArbitro);
              
					dbms_output.put_line('Tabela Apita, rowid ' || lastRowId || ' o árbitro ' || nomeArbitro || ' apitou o jogo de uma seleção de sua nacionalidade.');
				END IF;
			END IF;
		END LOOP;
	END LOOP;
	--END ChecagemArbitros
END;