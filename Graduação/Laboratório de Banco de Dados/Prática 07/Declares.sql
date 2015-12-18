1)
BEGIN
  comandoSQL('select', 'estadio', '5', null, null);
END;
--- SAIDAS ---
bloco an�nimo conclu�do
ID    NOME
5    damiEl


BEGIN
  comandoSQL('update', 'estadio', '5', 'nome', 'Est�dio Eldorado');
END;
--- SAIDAS ---
bloco an�nimo conclu�do
Comando update executado com sucesso.

BEGIN
  comandoSQL('delete', 'nacao', 'Taiti', null, null);
END;
--- SAIDAS ---
bloco an�nimo conclu�do
Comando delete executado com sucesso.

2b)
SET SERVEROUTPUT ON;
DECLARE 
  v_mediaSelecao1 NUMBER;
  v_mediaSelecao2 NUMBER;
  v_varianciaSelecao1 NUMBER;
  v_varianciaSelecao2 NUMBER;
BEGIN
  v_mediaSelecao1:= MEDIAGOLS('Holanda');
  v_varianciaSelecao1:= VARIANCIAGOLS('Holanda');
  v_mediaSelecao2:= MEDIAGOLS('Alemanha');
  v_varianciaSelecao2:= VARIANCIAGOLS('Alemanha');
  
  dbms_output.put_line('HOLANDA');
  dbms_output.put_line('    Media: ' || v_mediaSelecao1);
  dbms_output.put_line('    Variancia: ' || v_varianciaSelecao1);
  
  dbms_output.put_line('ALEMANHA');
  dbms_output.put_line('    Media: ' || v_mediaSelecao2);
  dbms_output.put_line('    Variancia: ' || v_varianciaSelecao2);
END;

--- SAIDAS ---
FUNCTION -- compilado
bloco an�nimo conclu�do
HOLANDA
    Media: 1
    Variancia: ,6666666666666666666666666666666666666667
ALEMANHA
    Media: ,5
    Variancia: ,3333333333333333333333333333333333333333
	
2c)
SET SERVEROUTPUT ON;
DECLARE 
  v_covariancia NUMBER;
BEGIN
  v_covariancia:= COVARIANCIA('Holanda','Alemanha');
  dbms_output.put_line('Covariancia entre Holanda e Alemanha: ' || v_covariancia);
  
  IF(v_covariancia < 0) THEN
    dbms_output.put_line('Covariancia negativa, as sele��es tem um desempenho oposto.');
  ELSE
    dbms_output.put_line('Covariancia positiva, as sele��es tem um desempenho parecido.');
  END IF;
END;

--- SAIDAS ---
FUNCTION -- compilado
bloco an�nimo conclu�do
Covariancia entre Holanda e Alemanha: -,1428571428571428571428571428571428571429
Covariancia negativa, as sele��es tem um desempenho oposto.

2d)
DECLARE 
  v_correlacao NUMBER;
BEGIN
  v_correlacao := CORRELACAO('Holanda','Alemanha');
  dbms_output.put_line('Correlacao entre Holanda e Alemanha: ' || v_correlacao);
  
  IF(v_correlacao = 1) THEN
    dbms_output.put_line('Correlacao positiva, as sele��es tem um desempenho quase id�ntico.');
  ELSIF(v_correlacao = 0) THEN
    dbms_output.put_line('Correlacao igual a zero, os desempenhos n�o est�o relacionados.');
  ELSIF(v_correlacao < 0) THEN
    dbms_output.put_line('Correlacao negativa, as sele��es tem um desempenho oposto.');
  ELSE
    dbms_output.put_line('Correlacao positiva, as sele��es tem um desempenho parecido.');
  END IF;
END;

--- SAIDAS ---
FUNCTION -- compilado
bloco an�nimo conclu�do
Correlacao entre Holanda e Alemanha: 0
Correlacao igual a zero, os desempenhos n�o est�o relacionados.
