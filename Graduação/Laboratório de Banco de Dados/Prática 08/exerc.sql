1)
CREATE OR REPLACE TRIGGER triggerCartoes
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
			SET CartAm = CartAm + 1
			WHERE JogouEm.idJogador = :new.idJogador;
		ELSIF(v_tipoLance = 3 AND numCartAm > 1) THEN
			UPDATE JogouEm
			SET CartAm = CartAm + 1,
				CartVer = CartVer + 1
			WHERE JogouEm.idJogador = :new.idJogador;
		ELSIF(v_tipoLance = 4) THEN
			UPDATE JogouEm
			SET CartVer = CartVer + 1
			WHERE JogouEm.idJogador = :new.idJogador;
		END IF;
	END IF;
	
	IF(DELETING) THEN
		SELECT idTipo INTO v_tipoLance
		FROM Lance L
		WHERE L.idJogo = :old.idJogo AND L.tempo = :old.tempo;
		
		IF(v_tipoLance = 3) THEN
			UPDATE JogouEm
			SET CartAm = CartAm - 1
			WHERE JogouEm.idJogador = :old.idJogador;
		ELSIF(v_tipoLance = 4) THEN
			UPDATE JogouEm
			SET CartVer = CartVer - 1
			WHERE JogouEm.idJogador = :old.idJogador;
	END IF;
  END IF;
END;

2)
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
		Saldo = v_numGols - v_numGolsSofr,
		Pontos = v_totalPontos
	WHERE Selecao.nomeNacao = p_nomeSelecao;
	
END;
-- Trigger
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
			ELSIF(v_nomeSelecJog NOT IN (v_nomeSelecao1)) THEN
				UPDATE Selecao
				SET GolsSofridos = GolsSofridos + 1
				WHERE Selecao.nomeNacao = v_nomeSelecao1;
			ELSIF(v_nomeSelecJog NOT IN (v_nomeSelecao2)) THEN
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
			ELSIF(v_nomeSelecJog NOT IN (v_nomeSelecao1)) THEN
				UPDATE Selecao
				SET GolsSofridos = GolsSofridos - 1
				WHERE Selecao.nomeNacao = v_nomeSelecao1;
			ELSIF(v_nomeSelecJog NOT IN (v_nomeSelecao2)) THEN
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
END;



3)
a)
CREATE OR REPLACE TRIGGER trigger_selec3jogos
BEFORE INSERT OR UPDATE ON Informacao
FOR EACH ROW
DECLARE
    v_numPartFaseGrupos NUMBER;
    exc_numJogosExcedido EXCEPTION;
BEGIN
	SELECT DISTINCT count(CASE WHEN Inf.nomeSelecao1 = :new.nomeSelecao1 OR Inf.nomeSelecao2 = :new.nomeSelecao1 
		OR Inf.nomeSelecao1 = :new.nomeSelecao2 OR Inf.nomeSelecao2 = :new.nomeSelecao2 THEN 1 END) INTO v_numPartFaseGrupos
	FROM Informacao Inf
	JOIN Jogo Jg ON Jg.id = Inf.idJogo
	JOIN Selecao S ON S.nomeNacao = Inf.nomeSelecao1 OR S.nomeNacao = Inf.nomeSelecao2
	WHERE Jg.fase = 'G1' OR Jg.fase = 'G2' OR Jg.fase = 'G3';
	
    IF v_numPartFaseGrupos > 4 THEN
      RAISE exc_numJogosExcedido;
    END IF;
EXCEPTION
	WHEN exc_numJogosExcedido THEN
		raise_application_error(-20004, 'Erro: Uma das seleções já participou de 3 jogos durante a fase de grupos.');
	WHEN OTHERS THEN
		raise_application_error(-20003, SQLERRM);    
END; 


b)
CREATE OR REPLACE TRIGGER triggerArbitroNacionDist
BEFORE INSERT OR UPDATE ON Apita
FOR EACH ROW
DECLARE
    v_idJogo NUMBER;
    exc_invalid EXCEPTION;
BEGIN
	SELECT DISTINCT count(*) INTO v_idJogo
         FROM Informacao Inf
	JOIN PertenceA PerA ON (PerA.NOMENACAO = Inf.nomeSelecao1 OR PerA.NOMENACAO = Inf.nomeSelecao2)
  WHERE :new.idArbitro = PerA.idPessoa AND :new.idJogo = Inf.idJogo;
  
  IF v_idJogo <> 0 THEN
      RAISE exc_invalid;
  END IF;
EXCEPTION
WHEN exc_invalid THEN
    raise_application_error(-20004, 'Erro: arbitro nao apita jogos de sua propria nacao');
WHEN OTHERS THEN
     raise_application_error(-20003, SQLErrm);   
END; 


4)
CREATE OR REPLACE TRIGGER triggerInsertUpdateJogouEm
BEFORE INSERT OR UPDATE ON JogouEm
FOR EACH ROW
DECLARE
	v_selecao1 VARCHAR2(100);
	v_selecao2 VARCHAR2(100);
	v_jogadorSelecao VARCHAR(100);

	exc_invalid EXCEPTION;
BEGIN
    -- selecoes que o jogador jogou
	SELECT Jogd.nomeSelecao INTO v_jogadorSelecao
	FROM Jogd 
	WHERE Jogd.idPessoa = :new.IDJOGADOR;
   
	-- selecoes que participam do jogo
	SELECT Info.nomeSelecao1, 
		Info.nomeSelecao2 INTO v_selecao1,  v_selecao2
		FROM Info WHERE Info.idJogo = :new.idJogo; 

	IF (v_jogadorSelecao != v_selecao1 AND v_jogadorSelecao != v_selecao2) THEN
		RAISE exc_invalid;
	END IF;

	EXCEPTION 
	WHEN exc_invalid THEN
		raise_application_error(-20000, 'Erro: jogador não pertence a uma das seleções da partida correspondente.'); 
	WHEN OTHERS THEN
		raise_application_error(-20001,SQLErrm); 
END;

5)
CREATE OR REPLACE TRIGGER triggerUpdateFKPatrocin
AFTER UPDATE ON Patrocinador
FOR EACH ROW
BEGIN
  -- Altera na tabela DivulgadoEm
  UPDATE DivEm 
    SET idPatrocinador = :new.ID 
  WHERE DivEm.idPatrocinador = :old.ID;
  
   -- Altera na tabela Interesse 
  UPDATE Inter
    SET idPatrocinador = :new.ID 
  WHERE Inter.idPatrocinador = :old.ID;
END;

6)
a)
CREATE TABLE TableLog
( 
     usuario      VARCHAR2(100), 
     data         DATE, 
     operacao     VARCHAR2(100),
     tipoObj	  VARCHAR2(100),
     nomeObj	  VARCHAR2(100),
     PRIMARY KEY (usuario, data) 
); 
 
b)
CREATE OR REPLACE TRIGGER triggerTableLog
AFTER DDL ON SCHEMA
DECLARE 
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO TableLog VALUES (USER, SYSDATE, ora_sysevent, ora_dict_obj_type, ora_dict_obj_name);
  COMMIT;
END;


7)
ALTER TABLE Pessoa ADD idade number(3);

CREATE OR REPLACE TRIGGER triggerPessoaIdade
BEFORE INSERT OR UPDATE ON Pessoa
FOR EACH ROW
DECLARE
	v_idade NUMBER(3);
BEGIN
   -- se houver apenas data de nascimento
   IF :new.nascimento IS NOT NULL AND :new.idade IS NULL THEN
      :new.idade := trunc(months_between(sysdate, :new.nascimento))/12; 
   END IF;
   
   -- se houver data de nascimento e idade
   IF :new.nascimento IS NOT NULL AND :new.idade IS NOT NULL THEN
      v_idade := trunc(months_between(SYSDATE, :new.nascimento))/12; 
      -- se idade for diferente, entao atualiza
      IF v_idade <> :new.idade THEN
        :new.idade := v_idade;
      END IF;
   END IF;
END; 