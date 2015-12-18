--INSERT
DECLARE
       v_atributos sqlOperations.t_atributos := sqlOperations.t_atributos();
       v_valorAtributos sqlOperations.t_atributos := sqlOperations.t_atributos();
BEGIN
       v_atributos.extend;
       v_atributos(1) := 'NomeNacao';
       v_atributos.extend;
       v_atributos(2) := 'idGrupo';
       v_valorAtributos.extend;
       v_valorAtributos(1) := 'Daniele';
       v_valorAtributos.extend;
       v_valorAtributos(2) := '8';
       sqlOperations.insertOnTable('Selecao', 
                                   v_atributos,
                                   v_valorAtributos);
END;

--Saída
anonymous block completed
INSERT INTO Selecao (NomeNacao, idGrupo) VALUES ('Daniele','8')
Comando INSERT bem-sucedido.

--DELETE
DECLARE
       v_atributos sqlOperations.t_atributos := sqlOperations.t_atributos();
       v_valorAtributos sqlOperations.t_atributos := sqlOperations.t_atributos();
BEGIN
       v_atributos.extend;
       v_atributos(1) := 'Nome';
       v_valorAtributos.extend;
       v_valorAtributos(1) := 'Estádio da Dani';
       sqlOperations.operationSQL('Estadio', 
                                  v_atributos,
                                  v_valorAtributos) 
END;

--Saída
anonymous block completed
DELETE FROM Estadio WHERE Nome = 'Estádio da Dani'
Comando DELETE bem-sucedido.

--UPDATE
DECLARE
       v_atributos sqlOperations.t_atributos := sqlOperations.t_atributos(); 
       v_valorAtributos sqlOperations.t_atributos := sqlOperations.t_atributos();
BEGIN
       v_atributos.extend;
       v_atributos(1) := 'nomeSelecao';
       v_valorAtributos.extend;
       v_valorAtributos(1) := 'Alemanha';
       sqlOperations.updateTable('Jogador', 
                                 v_atributos,
                                 v_valorAtributos, 
                                 'idPessoa', 
                                 '14');
END;

--Saída
anonymous block completed
UPDATE Jogador SET nomeSelecao = 'Alemanha' WHERE idPessoa = '14'
Comando UPDATE bem-sucedido.

--SELECT
DECLARE
       v_atributos sqlOperations.t_atributos := sqlOperations.t_atributos();
       v_valorAtributos sqlOperations.t_atributos := sqlOperations.t_atributos();
	   v_resultado SYS_REFCURSOR;
BEGIN
       v_atributos.extend;
       v_atributos(1) := 'idJogo';
       v_atributos.extend;
       v_atributos(2) := 'titular';
       sqlOperations.selectFromTable('JogouEm', 
									 v_atributos,
							    	 v_resultado);            
END;

--Saída
anonymous block completed
SELECT idJogo, titular FROM JogouEm