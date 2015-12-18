DECLARE
		fase				CHAR(2);
		nomeFase			VARCHAR2(20);
		numPartida 			NUMBER;
		numGrupoSelecoes 	NUMBER;
		Selecao1			VARCHAR2(100);
		Selecao2			VARCHAR2(100);
		numGolsSelecao1		NUMBER;
		numGolsSelecao2		NUMBER;
		nomeEstadio			VARCHAR2(100);
		dataJogo			DATE;
		
		nomeJogador			VARCHAR2(100);
		selecaoJogador		VARCHAR2(100);
		nomeJogador1		VARCHAR2(100);
		selecaoJogador1		VARCHAR2(100);
		tipoLance			NUMBER;
		nomeLance			VARCHAR(30);
		
		numGols				NUMBER;
		numCartAm			NUMBER;
		numCartVerm			NUMBER;
		jogadorLance		VARCHAR2(100);
		timeJogador			VARCHAR2(100);
    
		numPatrocinadores 	NUMBER;
		patId            	NUMBER;
		nomePatrocinador	VARCHAR2(100);
		nomesPatrocinadores VARCHAR2(300);
		
		numArbitros			NUMBER;
		nomeJuiz			VARCHAR2(100);
		nomeBandeirinha1 	VARCHAR(100);
		nomeBandeirinha2 	VARCHAR(100);
    
		CURSOR c_informacao IS SELECT id
							   FROM Jogo;
		CURSOR c_lance IS SELECT L.idJogo, idJogador 
						  FROM Lance L
						  JOIN PartDe Par ON Par.idJogo = L.idJogo AND Par.tempo = L.tempo;
		CURSOR c_jogadorGols IS SELECT idPessoa 
								FROM Jogador J
								JOIN PartDe Par ON Par.idJogador = J.idPessoa
								JOIN Lance L ON L.idJogo = Par.idJogo AND L.tempo = Par.tempo
								WHERE L.idTipo = 1;
		CURSOR c_jogadorCartAm IS SELECT idPessoa
								  FROM Jogador J
								  JOIN PartDe Par ON Par.idJogador = J.idPessoa
								  JOIN Lance L ON L.idJogo = Par.idJogo AND L.tempo = Par.tempo
								  WHERE L.idTipo = 3;
		CURSOR c_jogadorCartVerm IS SELECT idPessoa
									FROM Jogador J
									JOIN PartDe Par ON Par.idJogador = J.idPessoa
									JOIN Lance L ON L.idJogo = Par.idJogo AND L.tempo = Par.tempo
									WHERE L.idTipo = 4;
		CURSOR c_patrocinador IS SELECT DISTINCT id
								 FROM Patrocinador P
								 JOIN DivEm D ON D.idPatrocinador = P.id;
		CURSOR c_juiz IS SELECT id
						 FROM Pessoa
						 WHERE subclasse = 'A';
BEGIN
	FOR aux in c_informacao LOOP
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
			dbms_output.put_line('Partida ' || numPartida || ', realizada na fase de grupos pelo Grupo ' || numGrupoSelecoes || ', terminou com o resultado ' || Selecao1 || ' ' || numGolsSelecao1 || ' x ' || numGolsSelecao2 || ' ' || Selecao2 || ', no estádio ' || nomeEstadio || ' no dia ' || to_char(dataJogo, 'dd/mm/yy') || '.');
		--Imprime o relatório dos jogos das Oitavas, Quartas, Semi e Finais
		ELSE
			dbms_output.put_line('Partida ' || numPartida || ', realizada na fase ' || nomeFase || ', terminou com o resultado ' || Selecao1 || ' ' || numGolsSelecao1 || ' x ' || numGolsSelecao2 || ' ' || Selecao2 || ', no estádio ' || nomeEstadio || ' no dia ' || to_char(dataJogo, 'dd/mm/yy') || '.');
		END IF;
		
		--Loop para os Lances ocorridos em um jogo.
		--Loop para os gols
		SELECT count(*) INTO numGols
		FROM Lance L
		WHERE L.idJogo = aux.id AND L.idTipo = 1;
		
		IF(numGols > 0) THEN
			FOR auxJogador IN c_jogadorGols LOOP
				SELECT DISTINCT idJogador INTO jogadorLance
				FROM PartDe Par
        JOIN Lance L ON L.idJogo = Par.idJogo AND L.tempo = Par.tempo
				WHERE Par.idJogo = aux.id AND Par.idJogador = auxJogador.idPessoa;
				
				SELECT nomeNacao INTO timeJogador
				FROM PertenceA PerA
				WHERE PerA.idPessoa = auxJogador.idPessoa;
				
				dbms_output.put_line(jogadorLance || ' marcou para ' || timeJogador || ', ');
			END LOOP;
		END IF;
		
		--Loop para os cartões amarelos
		SELECT count(*) INTO numCartAm
		FROM Lance L
		WHERE L.idJogo = aux.id AND L.idTipo = 3;
		
		IF(numCartAm > 0) THEN
			dbms_output.put_line('receberam cartões amarelos ');
			FOR auxJogador IN c_jogadorCartAm LOOP
				SELECT DISTINCT idJogador INTO jogadorLance
				FROM PartDe Par
        JOIN Lance L ON L.idJogo = Par.idJogo AND L.tempo = Par.tempo
				WHERE Par.idJogo = aux.id AND Par.idJogador = auxJogador.idPessoa;
				
				SELECT nomeNacao INTO timeJogador
				FROM PertenceA PerA
				WHERE PerA.idPessoa = auxJogador.idPessoa;
				
				dbms_output.put_line(nomeJogador || ' (' || timeJogador || '), ');
			END LOOP;
		END IF;
		
		--Loop para os cartões vermelhos
		SELECT count(*) INTO numCartVerm
		FROM Lance L
		WHERE L.idJogo = aux.id AND L.idTipo = 4;
		
		IF(numCartVerm > 0) THEN
			dbms_output.put_line('receberam cartões vermelhos ');
			FOR auxJogador IN c_jogadorCartVerm LOOP
				SELECT DISTINCT idJogador INTO jogadorLance
				FROM PartDe Par
				JOIN Lance L ON L.idJogo = Par.idJogo AND L.tempo = Par.tempo
				WHERE Par.idJogo = aux.id AND Par.idJogador = auxJogador.idPessoa;
        
				SELECT nomeNacao INTO timeJogador
				FROM PertenceA PerA
				WHERE PerA.idPessoa = auxJogador.idPessoa;
				
				dbms_output.put_line(jogadorLance || ' (' || timeJogador || '), ');
			END LOOP;
		END IF;
		
		--Loop para os patrocinadores.
		SELECT count(*) INTO numPatrocinadores
		FROM DivEm D
		WHERE D.idJogo = aux.id;
		
		IF(numPatrocinadores > 0) THEN
		  dbms_output.put_line('Patrocinaram a partida ');
		  
		  FOR i IN 1..numPatrocinadores LOOP
			SELECT D.idPatrocinador INTO patId
			FROM DivEm D
			WHERE D.idJogo = aux.id;
			
			SELECT P.nome INTO nomePatrocinador
			FROM Patrocinador P
			WHERE P.id = patId;
			
			dbms_output.put_line(nomePatrocinador || ', ');
		  END LOOP;
		END IF;
    
		--Juiz do Jogo.
		SELECT count(*) INTO numArbitros
		FROM Apita Ap
		WHERE Ap.idJogo = aux.id;
		
		IF(numArbitros > 0)	THEN --Checa se existem árbitros cadastrados para esse jogo.
			dbms_output.put_line('apitaram o jogo ');
			SELECT count(*) INTO numArbitros
			FROM Apita Ap
			WHERE Ap.idJogo = aux.id AND Ap.funcao = 'Principal';
			
			IF(numArbitros > 0) THEN --Checa se existem juízes cadastrados para esse jogo.
				SELECT P.nome INTO nomeJuiz
				FROM Pessoa P
				JOIN Arbitro A ON A.idPessoa = P.id
				JOIN Apita Ap ON Ap.idArbitro = A.idPessoa
				WHERE P.subClasse = 'A' AND Ap.idJogo = aux.id AND Ap.funcao = 'Principal';
				
				dbms_output.put_line(nomeJuiz || '(principal)');
			END IF;
			
			SELECT count(*) INTO numArbitros
			FROM Apita Ap
			WHERE Ap.idJogo = aux.id AND Ap.funcao = 'Bandeirinha';
			
			IF(numArbitros > 1) THEN --Checa se existem bandeirinhas suficientes cadastrados para esse jogo.
				dbms_output.put_line(' auxiliado por ');
				--Bandeirinha 1.
				SELECT P.nome INTO nomeBandeirinha1
				FROM Pessoa P
				JOIN Arbitro A ON A.idPessoa = P.id
				JOIN Apita Ap ON Ap.idArbitro = A.idPessoa
				WHERE P.subClasse = 'A' AND Ap.idJogo = aux.id AND Ap.funcao = 'Bandeirinha';
				
				dbms_output.put_line(nomeBandeirinha1);
				
				--Bandeirinha 2.
				SELECT P.nome INTO nomeBandeirinha2
				FROM Pessoa P
				JOIN Arbitro A ON A.idPessoa = P.id
				JOIN Apita Ap ON Ap.idArbitro = A.idPessoa
				WHERE P.subClasse = 'A' AND Ap.idJogo = aux.id AND Ap.funcao = 'Bandeirinha' AND P.nome <> nomeBandeirinha1;
				
				dbms_output.put_line(' e ' || nomeBandeirinha2);
				
			END IF;
		END IF;
		dbms_output.put_line('.');
	END LOOP;
	
	EXCEPTION
	WHEN OTHERS THEN
	dbms_output.put_line('Ocorreu um erro.');
END;