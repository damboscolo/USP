DECLARE
		fase				CHAR(2);		-- Guarda a fase em que o jogo está ocorrendo
		nomeFase			VARCHAR2(20);	-- Transforma o char da fase no nome por extenso da fase
		numPartida 			NUMBER;			-- O número da partida, ou seja, seu id
		numGrupoSelecoes 	NUMBER;			-- O grupo ao qual as seleções que jogaram um jogo pertencem na fase de grupos
		Selecao1			VARCHAR2(100);	-- O nome da primeira seleção a jogar num jogo
		Selecao2			VARCHAR2(100);	-- O nome da segunda seleção a jogar num jogo
		numGolsSelecao1		NUMBER;			-- O número de gols da primeira seleção
		numGolsSelecao2		NUMBER;			-- O número de gols da segunda seleção
		nomeEstadio			VARCHAR2(100);	-- O nome do estádio onde ocorreu o jogo
		dataJogo			DATE;			-- A data do jogo

		nomeJogadorLance	VARCHAR2(100);	-- O nome do jogador que participou de um lance
		timeJogador			VARCHAR2(100);	-- O nome do time do jogador que participou de um lance
		numGols				NUMBER;			-- O número de gols de um certo jogador
		numCartAm			NUMBER;			-- O número de cartões amarelos de um certo jogador
		numCartVerm			NUMBER;			-- O número de cartões vermelhos de um certo jogador
		idJogoLance 		NUMBER;			-- O id do jogo em que um lance aconteceu
    
		numPatrocinadores 	NUMBER;			-- O número de patrocinadores de um certo jogo
		nomePatrocinador 	VARCHAR2(100);	-- O nome do patrocinador
		idPatrocinadorJogo  NUMBER;			-- O id do jogo em que o patrocinador apareceu
    
		numArbitros			NUMBER;			-- O número de árbitros do jogo
		nomeJuiz			VARCHAR2(100);	-- O nome do juiz (principal) do jogo
		nomeBandeirinha1 	VARCHAR2(100);	-- O nome do primeiro bandeirinha
		nomeBandeirinha2 	VARCHAR2(100);	-- O nome do segundo bandeirinha
    
		CURSOR c_jogos IS SELECT id
						  FROM Jogo;
						  
		CURSOR c_jogadorGols IS SELECT L.idJogo, nome, nomeSelecao
								FROM Jogador J
								JOIN PartDe Par ON Par.idJogador = J.idPessoa
								JOIN Lance L ON L.idJogo = Par.idJogo AND L.tempo = Par.tempo
								JOIN Pessoa P ON P.id = J.idPessoa
								WHERE L.idTipo = 1;
		CURSOR c_jogadorCartAm IS SELECT L.idJogo, nome, nomeSelecao
								  FROM Jogador J
								  JOIN PartDe Par ON Par.idJogador = J.idPessoa
								  JOIN Lance L ON L.idJogo = Par.idJogo AND L.tempo = Par.tempo
								  JOIN Pessoa P ON P.id = J.idPessoa
								  WHERE L.idTipo = 3;
		CURSOR c_jogadorCartVerm IS SELECT L.idJogo, nome, nomeSelecao
								    FROM Jogador J
								    JOIN PartDe Par ON Par.idJogador = J.idPessoa
								    JOIN Lance L ON L.idJogo = Par.idJogo AND L.tempo = Par.tempo
								    JOIN Pessoa P ON P.id = J.idPessoa
									WHERE L.idTipo = 4;
									
		CURSOR c_patrocinador IS SELECT DISTINCT P.nome, D.idJogo
								 FROM Patrocinador P
								 JOIN DivEm D ON D.idPatrocinador = P.id;
								 
		CURSOR c_juiz IS SELECT id
						 FROM Pessoa
						 WHERE subclasse = 'A';
BEGIN
	FOR aux in c_jogos LOOP
		--Fase.
		SELECT Jg.fase INTO fase
		FROM Jogo Jg
		WHERE Jg.id = aux.id;
		
		--Nome da fase.
		IF(fase = 'O') THEN
			nomeFase := 'Oitavas-de-final';
		ELSIF(fase = 'Q') then
			nomeFase := 'Quartas-de-final';
		ELSIF(fase = 'S') THEN
			nomeFase := 'Semi-final';
		ELSIF(fase = 'F') THEN
			nomeFase := 'Final';
		END IF;
		
		--Número da Partida.
		numPartida := aux.id;
		
		--Nome da Seleção 1.
		SELECT Inf.nomeSelecao1 INTO Selecao1
		FROM Informacao Inf
		WHERE Inf.idJogo = aux.id;
		
		--Nome da Seleção 2.
		SELECT Inf.nomeSelecao2 INTO Selecao2
		FROM Informacao Inf
		WHERE Inf.idJogo = aux.id;
		
		--Número de Gols da Seleção 1.
		SELECT DISTINCT count(*) INTO numGolsSelecao1
		FROM Lance L
		JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
		JOIN Jogador J ON J.idPessoa = Par.idJogador
		JOIN Informacao Inf ON Inf.idJogo = L.idJogo
		WHERE L.idTipo = 1 AND L.idJogo = aux.id AND Inf.nomeSelecao1 = Selecao1 AND J.nomeSelecao = Selecao1;
		
		--Número de Gols da Seleção 2.
		SELECT DISTINCT count(*) INTO numGolsSelecao2
		FROM Lance L
		JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo
		JOIN Jogador J ON J.idPessoa = Par.idJogador
		JOIN Informacao Inf ON Inf.idJogo = L.idJogo
		WHERE L.idTipo = 1 AND L.idJogo = aux.id AND Inf.nomeSelecao2 = Selecao2 AND J.nomeSelecao = Selecao2;
		
		--Grupo.
		SELECT S.idGrupo INTO numGrupoSelecoes
		FROM Selecao S
		JOIN Informacao Inf ON Inf.nomeSelecao1 = S.nomeNacao
		WHERE Inf.idJogo = aux.id AND Inf.nomeSelecao1 = Selecao1;
		
		--Nome do Estádio.
		SELECT E.nome INTO nomeEstadio
		FROM Estadio E
		JOIN Jogo Jg ON Jg.idEstadio = E.id
		JOIN Informacao Inf ON Inf.idJogo = Jg.id
		WHERE Inf.idJogo = aux.id;
		
		--Data do Jogo
		SELECT Jg.dt INTO dataJogo
		FROM Jogo Jg
		WHERE Jg.id = aux.id;
		
		--Imprime o relatório dos jogos de Grupo.
		IF(fase = 'G1' OR fase = 'G2' OR fase = 'G3') THEN
			dbms_output.put('Partida ' || numPartida || ', realizada na fase de grupos pelo Grupo ' || numGrupoSelecoes || ', terminou com o resultado ' || Selecao1 || ' ' || numGolsSelecao1 || ' x ' || numGolsSelecao2 || ' ' || Selecao2 || ', no estádio ' || nomeEstadio || ' no dia ' || to_char(dataJogo, 'dd/mm/yy') || ', ');
		--Imprime o relatório dos jogos das Oitavas, Quartas, Semi e Finais
		ELSE
			dbms_output.put('Partida ' || numPartida || ', realizada na fase ' || nomeFase || ', terminou com o resultado ' || Selecao1 || ' ' || numGolsSelecao1 || ' x ' || numGolsSelecao2 || ' ' || Selecao2 || ', no estádio ' || nomeEstadio || ' no dia ' || to_char(dataJogo, 'dd/mm/yy') || ', ');
		END IF;
		
		--Loop para os Lances ocorridos em um jogo.
		--Loop para os gols
		SELECT count(*) INTO numGols
		FROM Lance L
		WHERE L.idJogo = aux.id AND L.idTipo = 1;
		
		IF(numGols > 0) THEN --Checa se existem gols no jogo.
		  OPEN c_jogadorGols;
		  LOOP    
			  FETCH c_jogadorGols INTO idJogoLance, nomeJogadorLance, timeJogador;
				  IF(idJogoLance = aux.id) THEN
					dbms_output.put(nomeJogadorLance || ' marcou para ' || timeJogador || ', ');
				  END IF;
			  EXIT WHEN c_jogadorGols%NOTFOUND;
		   END LOOP;
		   CLOSE c_jogadorGols;
		END IF;  
  
		
		--Loop para os cartões amarelos
		SELECT count(*) INTO numCartAm
		FROM Lance L
		WHERE L.idJogo = aux.id AND L.idTipo = 3;
		
		IF(numCartAm > 0) THEN --Checa se existem cartões amarelos no jogo.
			OPEN c_jogadorCartAm;
			dbms_output.put_line('receberam cartões amarelos ');
			LOOP    
				FETCH c_jogadorCartAm INTO idJogoLance, nomeJogadorLance, timeJogador;
				IF(idJogoLance = aux.id) THEN
					dbms_output.put(nomeJogadorLance || ' (' || timeJogador || '), ');
				END IF;
				EXIT WHEN c_jogadorCartAm%NOTFOUND;
			END LOOP;
			CLOSE c_jogadorCartAm;
		END IF;
		
		--Loop para os cartões vermelhos
		SELECT count(*) INTO numCartVerm
		FROM Lance L
		WHERE L.idJogo = aux.id AND L.idTipo = 4;
		
		IF(numCartVerm > 0) THEN --Checa se existem cartões vermelhos no jogo.
			dbms_output.put_line('receberam cartões vermelhos ');
			OPEN c_jogadorCartVerm;
			LOOP    
			  FETCH c_jogadorCartVerm INTO idJogoLance, nomeJogadorLance, timeJogador;
				  IF(idJogoLance = aux.id) THEN
					dbms_output.put(nomeJogadorLance || ' (' || timeJogador || '), ');
				  END IF;
			  EXIT WHEN c_jogadorCartVerm%NOTFOUND;
			END LOOP;
			CLOSE c_jogadorCartVerm;
		END IF;
		
		--Loop para os patrocinadores.
		SELECT count(*) INTO numPatrocinadores
		FROM DivEm D
		WHERE D.idJogo = aux.id;
		
		IF(numPatrocinadores > 0) THEN --Checa se existem patrocinadores para esse jogo.
		  dbms_output.put('patrocinaram a partida ');
		 OPEN c_patrocinador;
			 LOOP    
          FETCH c_patrocinador INTO nomePatrocinador, idPatrocinadorJogo;
              IF(idPatrocinadorJogo = aux.id) THEN
                dbms_output.put(nomePatrocinador || ', ');
              END IF;
          EXIT WHEN c_patrocinador%NOTFOUND;
       END LOOP;
       CLOSE c_patrocinador;
		END IF;
    
		--Juiz do Jogo.
		SELECT count(*) INTO numArbitros
		FROM Apita Ap
		WHERE Ap.idJogo = aux.id AND Ap.funcao NOT IN ('Reserva');
		
		IF(numArbitros > 0)	THEN --Checa se existem árbitros cadastrados para esse jogo.
      dbms_output.put('apitaram o jogo ');
			SELECT count(*) INTO numArbitros
			FROM Apita Ap
			WHERE Ap.idJogo = aux.id AND Ap.funcao = 'Principal';
			
			IF(numArbitros > 0) THEN --Checa se existem juízes cadastrados para esse jogo.
				SELECT P.nome INTO nomeJuiz
				FROM Pessoa P
				JOIN Arbitro A ON A.idPessoa = P.id
				JOIN Apita Ap ON Ap.idArbitro = A.idPessoa
				WHERE P.subClasse = 'A' AND Ap.idJogo = aux.id AND Ap.funcao = 'Principal';
				
				dbms_output.put(nomeJuiz || '(principal)');
			END IF;
			
			SELECT count(*) INTO numArbitros
			FROM Apita Ap
			WHERE Ap.idJogo = aux.id AND Ap.funcao = 'Bandeirinha';
			
			IF(numArbitros > 1) THEN --Checa se existem bandeirinhas suficientes cadastrados para esse jogo.
				dbms_output.put(' auxiliado por ');
				--Bandeirinha 1.
				SELECT P.nome INTO nomeBandeirinha1
				FROM Pessoa P
				JOIN Arbitro A ON A.idPessoa = P.id
				JOIN Apita Ap ON Ap.idArbitro = A.idPessoa
				WHERE P.subClasse = 'A' AND Ap.idJogo = aux.id AND Ap.funcao = 'Bandeirinha';
				
				dbms_output.put(nomeBandeirinha1);
				
				--Bandeirinha 2.
				SELECT P.nome INTO nomeBandeirinha2
				FROM Pessoa P
				JOIN Arbitro A ON A.idPessoa = P.id
				JOIN Apita Ap ON Ap.idArbitro = A.idPessoa
				WHERE P.subClasse = 'A' AND Ap.idJogo = aux.id AND Ap.funcao = 'Bandeirinha' AND P.nome <> nomeBandeirinha1;
				
				dbms_output.put(' e ' || nomeBandeirinha2);
				
			END IF;
		END IF;
		dbms_output.put_line(' ');
    
		dbms_output.put_line(' ');
	END LOOP;
	
	EXCEPTION
	WHEN OTHERS THEN
	dbms_output.put_line('Ocorreu um erro.');
END;