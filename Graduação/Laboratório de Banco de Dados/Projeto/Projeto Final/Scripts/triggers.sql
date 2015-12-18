CREATE OR REPLACE TRIGGER triggerCartoes
BEFORE INSERT OR UPDATE OR DELETE ON ParticipaDe
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
			WHERE JogouEm.idJogador = :new.idJogador AND JogouEm.idJogo = :new.idJogo;
		ELSIF(v_tipoLance = 3 AND (MOD(numCartAm, 2) <> 0)) THEN
			UPDATE JogouEm
			SET CartAm = CartAm + 1,
				CartVer = CartVer + 1
			WHERE JogouEm.idJogador = :new.idJogador AND JogouEm.idJogo = :new.idJogo;
		ELSIF(v_tipoLance = 4) THEN
			UPDATE JogouEm
			SET CartVer = CartVer + 1
			WHERE JogouEm.idJogador = :new.idJogador AND JogouEm.idJogo = :new.idJogo;
		END IF;
	END IF;
	
	IF(DELETING) THEN
		SELECT idTipo INTO v_tipoLance
		FROM Lance L
		WHERE L.idJogo = :old.idJogo AND L.tempo = :old.tempo;
		
		IF(v_tipoLance = 3) THEN
			UPDATE JogouEm
			SET CartAm = CartAm - 1
			WHERE JogouEm.idJogador = :old.idJogador AND JogouEm.idJogo = :old.idJogo;
		ELSIF(v_tipoLance = 4) THEN
			UPDATE JogouEm
			SET CartVer = CartVer - 1
			WHERE JogouEm.idJogador = :old.idJogador AND JogouEm.idJogo = :old.idJogo;
    END IF;
  END IF;
END trigger_cartoes;
/

CREATE OR REPLACE TRIGGER triggerValoresSelecPartDe
BEFORE INSERT OR UPDATE OR DELETE ON ParticipaDe
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
				SET Saldo = Saldo + 1,
					GolsMarcados = GolsMarcados + 1
				WHERE Selecao.nomeNacao = v_nomeSelecao1;
				
				UPDATE Selecao
				SET Saldo = Saldo - 1,
					GolsSofridos = GolsSofridos + 1
				WHERE Selecao.nomeNacao = v_nomeSelecao2;
        
			ELSIF(v_nomeSelecJog = v_nomeSelecao2) THEN
				UPDATE Selecao
				SET Saldo = Saldo + 1,
					GolsMarcados = GolsMarcados + 1
				WHERE Selecao.nomeNacao = v_nomeSelecao2;
				
				UPDATE Selecao
				SET Saldo = Saldo - 1,
					GolsSofridos = GolsSofridos + 1
				WHERE Selecao.nomeNacao = v_nomeSelecao1;
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
				SET Saldo = Saldo - 1,
					GolsMarcados = GolsMarcados - 1
				WHERE Selecao.nomeNacao = v_nomeSelecao1;
				
				UPDATE Selecao
				SET Saldo = Saldo + 1,
					GolsSofridos = GolsSofridos - 1
				WHERE Selecao.nomeNacao = v_nomeSelecao2;
			ELSIF(v_nomeSelecJog = v_nomeSelecao2) THEN
				UPDATE Selecao
				SET Saldo = Saldo - 1,
					GolsMarcados = GolsMarcados - 1
				WHERE Selecao.nomeNacao = v_nomeSelecao2;
				
				UPDATE Selecao
				SET Saldo = Saldo + 1,
					GolsSofridos = GolsSofridos - 1
				WHERE Selecao.nomeNacao = v_nomeSelecao1;
			END IF;
			UPDATE Selecao
			SET Saldo = GolsMarcados - GolsSofridos
			WHERE Selecao.nomeNacao = v_nomeSelecao2;
				
			UPDATE Selecao
			SET Saldo = GolsMarcados - GolsSofridos
			WHERE Selecao.nomeNacao = v_nomeSelecao1;
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
END triggerValoresSelecPartDe;
/

CREATE OR REPLACE TRIGGER triggerGrupoId
	BEFORE INSERT ON Grupo
	FOR EACH ROW 
BEGIN 
    IF( :new.id IS NULL ) THEN 
		SELECT SEQGRUPOID.NEXTVAL 
		INTO   :new.id 
		FROM   dual; 
    END IF; 
END;
/

CREATE OR REPLACE TRIGGER triggerPessoaId
	BEFORE INSERT ON Pessoa
	FOR EACH ROW
BEGIN
	IF(:new.id is NULL) THEN
		SELECT SeqPessoaId.NEXTVAL
		INTO :new.id
		FROM dual;
	END IF;
END;
/

CREATE OR REPLACE TRIGGER triggerEstadioId
	BEFORE INSERT ON Estadio
	FOR EACH ROW
BEGIN
	IF(:new.id is NULL) THEN
		SELECT SeqEstadioId.NEXTVAL
		INTO :new.id
		FROM dual;
	END IF;
END;
/

CREATE OR REPLACE TRIGGER triggerJogoId
	BEFORE INSERT ON Jogo
	FOR EACH ROW
BEGIN
	IF(:new.id is NULL) THEN
		SELECT SeqJogoId.NEXTVAL
		INTO :new.id
		FROM dual;
	END IF;
END;
/

CREATE OR REPLACE TRIGGER triggerTipoId
	BEFORE INSERT ON Tipo
	FOR EACH ROW
BEGIN
	IF(:new.id is NULL) THEN
		SELECT SeqTipoId.NEXTVAL
		INTO :new.id
		FROM dual;
	END IF;
END;
/

CREATE OR REPLACE TRIGGER triggerPatrocinadorId
	BEFORE INSERT ON Patrocinador
	FOR EACH ROW
BEGIN
	IF(:new.id is NULL) THEN
		SELECT SeqPatrocinadorId.NEXTVAL
		INTO :new.id
		FROM dual;
	END IF;
END;
/

