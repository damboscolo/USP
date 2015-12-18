DECLARE
	v_aux NUMBER;
	v_rand NUMBER;
	v_sql VARCHAR2(1000);
	
	v_nome VARCHAR2(100);
	v_passaporte VARCHAR2(50);
	v_idPessoa NUMBER;
	v_nomeSelecao VARCHAR2(100);
	v_numSelecao NUMBER;
	
	v_cur SYS_REFCURSOR;
BEGIN
	SELECT DISTINCT COUNT(*) INTO v_numSelecao
	FROM Selecao;
	
	v_aux := 1;
	
	v_sql := 'SELECT nomeNacao FROM Selecao';
	OPEN v_cur FOR v_sql;
	LOOP
		FETCH v_cur INTO v_nomeSelecao;
		EXIT WHEN v_cur%NOTFOUND;
		FOR v_aux IN 1..2 LOOP
			SELECT CAST(dbms_random.value(1, 20) AS INTEGER) INTO v_rand
			FROM DUAL;
			
			CASE v_rand
				WHEN 1 THEN v_nome := 'João';
				WHEN 2 THEN v_nome := 'José';
				WHEN 3 THEN v_nome := 'Bruno';
				WHEN 4 THEN v_nome := 'Lineu';
				WHEN 5 THEN v_nome := 'Shotaro';
				WHEN 6 THEN v_nome := 'Mike';
				WHEN 7 THEN v_nome := 'Albert';
				WHEN 8 THEN v_nome := 'Fernando';
				WHEN 9 THEN v_nome := 'Upalan';
				WHEN 10 THEN v_nome := 'Ken';
				WHEN 11 THEN v_nome := 'Leonar';
				WHEN 12 THEN v_nome := 'Linus';
				WHEN 13 THEN v_nome := 'Cromagnum';
				WHEN 14 THEN v_nome := 'Yonsei';
				WHEN 15 THEN v_nome := 'Matheus';
				WHEN 16 THEN v_nome := 'Coppenhagen';
				WHEN 17 THEN v_nome := 'Hikari';
				WHEN 18 THEN v_nome := 'Joseph';
				WHEN 19 THEN v_nome := 'Mário';
				WHEN 20 THEN v_nome := 'Peter';
			END CASE;
			
			SELECT CAST(dbms_random.value(1, 20) AS INTEGER) INTO v_rand
			FROM DUAL;
			
			CASE v_rand
				WHEN 1 THEN v_nome := v_nome || ' Carvalho';
				WHEN 2 THEN v_nome := v_nome || ' Yoachim';
				WHEN 3 THEN v_nome := v_nome || ' Silva';
				WHEN 4 THEN v_nome := v_nome || ' Well';
				WHEN 5 THEN v_nome := v_nome || ' Yuuki';
				WHEN 6 THEN v_nome := v_nome || ' Vizir';
				WHEN 7 THEN v_nome := v_nome || ' Fundraiser';
				WHEN 8 THEN v_nome := v_nome || ' Agosto';
				WHEN 9 THEN v_nome := v_nome || ' Cabalan';
				WHEN 10 THEN v_nome := v_nome || ' Masters';
				WHEN 11 THEN v_nome := v_nome || ' Henriq III';
				WHEN 12 THEN v_nome := v_nome || ' Pauling';
				WHEN 13 THEN v_nome := v_nome || ' Devaing';
				WHEN 14 THEN v_nome := v_nome || ' Pologn';
				WHEN 15 THEN v_nome := v_nome || ' Eran';
				WHEN 16 THEN v_nome := v_nome || ' Solomon';
				WHEN 17 THEN v_nome := v_nome || ' Peridot';
				WHEN 18 THEN v_nome := v_nome || ' Castellini';
				WHEN 19 THEN v_nome := v_nome || ' Corleone';
				WHEN 20 THEN v_nome := v_nome || ' Dartagnan';
			END CASE;
			
			SELECT CAST(CAST(dbms_random.value(1000000, 9999999) AS INTEGER) AS VARCHAR2(50)) INTO v_passaporte
			FROM DUAL;
  
      v_sql := 'INSERT INTO Pessoa(subClasse, nome, passaporte) VALUES(''A'', ''' ||  v_nome || ''', ''' || v_passaporte || ''')';
      dbms_output.put_line(v_sql);
      EXECUTE IMMEDIATE v_sql;
      
			SELECT id INTO v_idPessoa
			FROM Pessoa
			WHERE passaporte = v_passaporte;
      
			v_sql := 'INSERT INTO PertenceA(idPessoa, nomeNacao) VALUES(' || v_idPessoa || ', ''' || v_nomeSelecao || ''')';
      dbms_output.put_line(v_sql);
      EXECUTE IMMEDIATE v_sql;
      
			v_sql := 'INSERT INTO Arbitro(idPessoa) VALUES(' || v_idPessoa || ')';
      dbms_output.put_line(v_sql);
      EXECUTE IMMEDIATE v_sql;
      
		END LOOP;
	END LOOP;
END;