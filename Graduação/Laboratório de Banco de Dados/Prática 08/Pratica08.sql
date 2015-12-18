--Exercício 1
CREATE OR REPLACE TRIGGER trigger_Cartoes
AFTER INSERT OR UPDATE OR DELETE ON ParticipaDe
FOR EACH ROW
DECLARE
	v_tipoLance NUMBER;
	numCartAm NUMBER;
	
BEGIN
	IF(INSERTING OR UPDATING) THEN
		SELECT idTipo INTO v_tipoLance
		FROM Lance L
		WHERE L.idJogo = :new.idJogo AND L.tempo = :new.tempo;
	
		SELECT count(*) INTO numCartAm
		FROM Lance L
		JOIN ParticipaDe PartDe ON PartDe.idJogo = L.idJogo AND PartDe.tempo = L.tempo
		WHERE L.idTipo = 3 AND PartDe.idJogador = :new.idJogador;
		
		IF(v_tipoLance = 3) THEN
			UPDATE JogouEm
			SET CartAm = CartAm + 1;
			WHERE JogouEm.idJogador = :new.idJogador;
		ELSIF(v_tipoLance = 3 AND (MOD(numCartAm, 2) <> 0)) THEN
			UPDATE JogouEm
			SET CartAm = CartAm + 1,
				CartVerm = CartVerm + 1;
			WHERE JogouEm.idJogador = :new.idJogador;
		ELSIF(v_tipoLance = 4) THEN
			UPDATE JogouEm
			SET CartVerm = CartVerm + 1;
			WHERE JogouEm.idJogador = :new.idJogador;
		END IF;
	END IF;
	
	IF(DELETING) THEN
		SELECT idTipo INTO v_tipoLance
		FROM Lance L
		WHERE L.idJogo = :old.idJogo AND L.tempo = :old.tempo;
		
		IF(v_tipoLance = 3) THEN
			UPDATE JogouEm
			SET CartAm = CartAm - 1;
			WHERE JogouEm.idJogador = :old.idJogador;
		ELSIF(v_tipoLance = 4) THEN
			UPDATE JogouEm
			SET CartVerm = CartVerm - 1;
			WHERE JogouEm.idJogador = :old.idJogador;
	END IF;
	
END trigger_Cartoes;

--Exercício 2
CREATE OR REPLACE PROCEDURE atualizaValores(p_nomeSelecao Selecao.nomeNacao%TYPE) AS
	v_numGols NUMBER;
	v_numGolsSofr NUMBER;
	v_numCartAm NUMBER;
	v_numCartVerm NUMBER;
	v_totalPontos  NUMBER;
	
	v_idJogo NUMBER;
	v_selecao1 VARCHAR(100);
	v_selecao2 VARCHAR(100);
	v_gols1 NUMBER;
	v_gols2 NUMBER;
	v_vitoria NUMBER;
	v_empate NUMBER;
	
	CURSOR c_jogos IS SELECT idJogo, nomeSelecao1, nomeSelecao2 
					  FROM Informacao Inf
					  JOIN Jogo Jg ON Jg.id = Inf.idJogo
					  WHERE (Inf.nomeSelecao1 = p_nomeSelecao OR Inf.nomeSelecao2 = p_nomeSelecao);
	
BEGIN
	v_vitoria := 0;
	v_empate := 0;
	v_totalPontos := 0;
	
	SELECT count(*) INTO v_numGols
	FROM Lance L
	JOIN ParticipaDe PartDe ON PartDe.idJogo = L.idJogo AND PartDe.tempo = L.tempo
	JOIN Jogador J ON J.idPessoa = PartDe.idJogador
	WHERE L.idTipo = 1 AND J.nomeSelecao = p_nomeSelecao;
	
	SELECT count(*) INTO v_numGolsSofr
	FROM Lance L
	JOIN Informacao Inf ON Inf.idJogo = L.idJogo
	JOIN ParticipaDe PartDe ON PartDe.idJogo = L.idJogo AND PartDe.tempo = L.tempo
	JOIN Jogador J ON J.idPessoa = PartDe.idJogador
	WHERE L.idTipo = 1 AND J.nomeSelecao NOT IN (p_nomeSelecao) AND (Inf.nomeSelecao1 = p_nomeSelecao OR Inf.nomeSelecao2 = p_nomeSelecao);
	
	SELECT count(*) INTO v_numCartAm
	FROM Lance L
	JOIN ParticipaDe PartDe ON PartDe.idJogo = L.idJogo AND PartDe.tempo = L.tempo
	JOIN Jogador J ON J.idPessoa = PartDe.idJogador
	WHERE L.idTipo = 3 AND J.nomeSelecao = p_nomeSelecao;
	 
	SELECT count(*) INTO v_numCartVerm
	FROM Lance L
	JOIN ParticipaDe PartDe ON PartDe.idJogo = L.idJogo AND PartDe.tempo = L.tempo
	JOIN Jogador J ON J.idPessoa = PartDe.idJogador
	WHERE L.idTipo = 4 AND J.nomeSelecao = p_nomeSelecao;
	
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
			
			IF(v_gols1 > v_gols2 AND v_selecao1 = p_nomeSelecao) THEN
				v_vitoria := v_vitoria + 1;
			ELSIF(v_gols1 < v_gols2 AND v_selecao2 = p_nomeSelecao) THEN
				v_vitoria := v_vitoria + 1;
			ELSIF(v_gols1 = v_gols2) THEN
				v_empate := v_empate + 1;
			END IF;
		EXIT WHEN c_jogos%NOTFOUND;
	END LOOP;
	v_totalPontos := (v_vitoria * 3) + v_empate;
	CLOSE c_jogos;
	
	UPDATE Selecao
	SET CartVer = v_numCartVerm,
		CartAm = v_numCartAm,
		GolsMarcados = v_numGols,
		GolsSofridos = v_numGolsSofr,
		Pontos = v_totalPontos
	WHERE Selecao.nomeNacao = p_nomeSelecao;
	
END;

CREATE OR REPLACE TRIGGER trigger_valoresSelecPartDe
AFTER INSERT OR UPDATE OR DELETE ON ParticipaDe
FOR EACH ROW
DECLARE
	v_tipoLance NUMBER;
	v_nomeSelecJog VARCHAR(100);
	v_nomeSelecao1 VARCHAR(100);
	v_nomeSelecao2 VARCHAR(100);
	v_numCartAm	NUMBER;
	
BEGIN
	IF(INSERTING OR UPDATING) THEN
		SELECT idTipo INTO v_tipoLance
		FROM Lance L
		WHERE L.idJogo = :new.idJogo AND L.tempo = :new.tempo;
		
		SELECT nomeSelecao INTO v_nomeSelecJog
		FROM Jogador J
		WHERE J.idPessoa = :new.idJogador;
		
		IF(v_tipoLance = 1) THEN
			SELECT nomeSelecao1 INTO v_nomeSelecao1
			FROM Informacao Inf
			WHERE Inf.idJogo = :new.idJogo;
			
			SELECT nomeSelecao2 INTO v_nomeSelecao2
			FROM Informacao Inf
			WHERE Inf.idJogo = :new.idJogo;
		
			IF(v_nomeSelecJog = v_nomeSelecao1) THEN
				UPDATE Selecao
				SET GolsMarcados = GolsMarcados + 1
				WHERE Selecao.nomeNacao = v_nomeSelecao1;
			ELSIF(v_nomeSelecJog = v_nomeSelecao2) THEN
				UPDATE Selecao
				SET GolsMarcados = GolsMarcados + 1
				WHERE Selecao.nomeNacao = v_nomeSelecao2;
			ELSIF(v_nomeSelecJog NOT v_nomeSelecao1) THEN
				UPDATE Selecao
				SET GolsSofridos = GolsSofridos + 1
				WHERE Selecao.nomeNacao = v_nomeSelecao1;
			ELSIF(v_nomeSelecJog NOT v_nomeSelecao2) THEN
				UPDATE Selecao
				SET GolsSofridos = GolsSofridos + 1
				WHERE Selecao.nomeNacao = v_nomeSelecao2;
			END IF;
		ELSIF(v_tipoLance = 3) THEN
			
			SELECT cartAm INTO v_numCartAm
			FROM Selecao S
			WHERE S.nomeNacao = v_nomeSelecJog;
			
			IF((MOD(v_numCartAm, 2) <> 0)) THEN
				UPDATE Selecao
				SET CartAm = CartAm + 1,
					CartVer = CartVer + 1
				WHERE Selecao.nomeNacao = v_nomeSelecJog;
			ELSE
				UPDATE Selecao
				SET CartAm = CartAm + 1
				WHERE Selecao.nomeNacao = v_nomeSelecJog;
			END IF;
		ELSIF(v_tipoLance = 4) THEN
		
			UPDATE Selecao
			SET CartVer = CartVer + 1
			WHERE Selecao.nomeNacao = v_nomeSelecJog;
			
		END IF;
	END IF;
	
	IF(DELETING) THEN
		SELECT idTipo INTO v_tipoLance
		FROM Lance L
		WHERE L.idJogo = :old.idJogo AND L.tempo = :old.tempo;
		
		SELECT nomeSelecao INTO v_nomeSelecJog
		FROM Jogador J
		WHERE J.idPessoa = :old.idJogador;
		
		IF(v_tipoLance = 1) THEN
			SELECT nomeSelecao1 INTO v_nomeSelecao1
			FROM Informacao Inf
			WHERE Inf.idJogo = :old.idJogo;
			
			SELECT nomeSelecao2 INTO v_nomeSelecao2
			FROM Informacao Inf
			WHERE Inf.idJogo = :old.idJogo;
		
			IF(v_nomeSelecJog = v_nomeSelecao1) THEN
				UPDATE Selecao
				SET GolsMarcados = GolsMarcados - 1
				WHERE Selecao.nomeNacao = v_nomeSelecao1;
			ELSIF(v_nomeSelecJog = v_nomeSelecao2) THEN
				UPDATE Selecao
				SET GolsMarcados = GolsMarcados - 1
				WHERE Selecao.nomeNacao = v_nomeSelecao2;
			ELSIF(v_nomeSelecJog NOT v_nomeSelecao1) THEN
				UPDATE Selecao
				SET GolsSofridos = GolsSofridos - 1
				WHERE Selecao.nomeNacao = v_nomeSelecao1;
			ELSIF(v_nomeSelecJog NOT v_nomeSelecao2) THEN
				UPDATE Selecao
				SET GolsSofridos = GolsSofridos - 1
				WHERE Selecao.nomeNacao = v_nomeSelecao2;
			END IF;
		ELSIF(v_tipoLance = 3) THEN
		
			UPDATE Selecao
			SET CartAm = CartAm - 1
			WHERE Selecao.nomeNacao = v_nomeSelecJog;
			
		ELSIF(v_tipoLance = 4) THEN
		
			UPDATE Selecao
			SET CartVer = CartVer - 1
			WHERE Selecao.nomeNacao = v_nomeSelecJog;
			
		END IF;
	END IF;
END trigger_valoresSelecPartDe;

CREATE OR REPLACE TRIGGER trigger_valoresSelecLance
BEFORE INSERT OR UPDATE OR DELETE ON Lance
DECLARE

BEGIN
	IF(INSERTING OR UPDATING) THEN
		
	END IF;
	
	IF(DELETING) THEN
		
	END IF;
END trigger_valoresSelecLance;

--Exercício 3
CREATE OR REPLACE TRIGGER trigger_Selec3Jogos
BEFORE INSERT OR UPDATE ON Informacao
FOR EACH ROW
DECLARE
   numPartFaseGrupos NUMBER
   exc_numJogosExcedido EXCEPTION
   
BEGIN

	SELECT DISTINCT count(CASE WHEN Inf.nomeSelecao1 = aux.nomeNacao OR Inf.nomeSelecao2 = aux.nomeNacao THEN 1 END) INTO numPartFaseGrupos
	FROM Informacao Inf
	JOIN Jogo Jg ON Jg.id = Inf.idJogo
	JOIN Selecao S ON S.nomeNacao = Inf.nomeSelecao1 OR S.nomeNacao = Inf.nomeSelecao2
	WHERE (Jg.fase = 'G1' OR Jg.fase = 'G2' OR Jg.fase = 'G3') 
		AND (Inf.nomeSelecao1 = :new.nomeSelecao1 OR Inf.nomeSelecao2 = :new.nomeSelecao2);
	
	IF(numPartFaseGrupos >= 3)
		raise exc_numJogosExcedido
	END IF;
	
EXCEPTION
	WHEN exc_numJogosExcedido THEN
		raise_application_error(-20002, 'Uma das seleções já participou de 3 jogos durante a fase de grupos.')
	WHEN OTHERS THEN
		raise_application_error(-20001, SQLERRM);   
END attSelecaoFase; 

CREATE OR REPLACE TRIGGER trigger_ArbitrosSelecDist
BEFORE INSERT OR UPDATE ON Apita
FOR EACH ROW
DECLARE
	v_nomeNacaoArbitro VARCHAR(100);
	v_nomeSelecao1 VARCHAR(100);
	v_nomeSelecao2 VARCHAR(100);
	
BEGIN

	SELECT nomeNacao INTO v_nomeNacaoArbitro
	FROM PertenceA PerA
	WHERE PerA.idPessoa = :new.idArbitro;
	
	SELECT nomeSelecao1 INTO v_nomeSelecao1
	FROM Informacao Inf
	WHERE Inf.idJogo = :new.idJogo;
	
	SELECT nomeSelecao2 INTO v_nomeSelecao2
	FROM Informacao Inf
	WHERE Inf.idJogo = :new.idJogo;
	
	IF(v_nomeNacaoArbitro = v_nomeSelecao1 AND v_nomeNacaoArbitro = v_nomeSelecao2) THEN
		raise exc_mesmaNacion;
	END IF;
	
EXCEPTION
	WHEN exc_mesmaNacion THEN
		raise_application_error(-20002, 'O árbitro está apitando um jogo da mesma seleção do seu país de origem.');
	WHEN OTHERS THEN
		raise_application_error(-20001, SQLErrm);
END trigger_ArbitrosSelecDist;