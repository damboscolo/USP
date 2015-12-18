1)
BEGIN
  comandoSQL('select', 'estadio', '5', null, null);
END;
--- SAIDAS ---
bloco anônimo concluído
ID    NOME
5    damiEl


BEGIN
  comandoSQL('update', 'estadio', '5', 'nome', 'Estádio Eldorado');
END;
--- SAIDAS ---
bloco anônimo concluído
Comando update executado com sucesso.

BEGIN
  comandoSQL('delete', 'nacao', 'Taiti', null, null);
END;
--- SAIDAS ---
bloco anônimo concluído
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
bloco anônimo concluído
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
    dbms_output.put_line('Covariancia negativa, as seleções tem um desempenho oposto.');
  ELSE
    dbms_output.put_line('Covariancia positiva, as seleções tem um desempenho parecido.');
  END IF;
END;

--- SAIDAS ---
FUNCTION -- compilado
bloco anônimo concluído
Covariancia entre Holanda e Alemanha: -,1428571428571428571428571428571428571429
Covariancia negativa, as seleções tem um desempenho oposto.

2d)
DECLARE 
  v_correlacao NUMBER;
BEGIN
  v_correlacao := CORRELACAO('Holanda','Alemanha');
  dbms_output.put_line('Correlacao entre Holanda e Alemanha: ' || v_correlacao);
  
  IF(v_correlacao = 1) THEN
    dbms_output.put_line('Correlacao positiva, as seleções tem um desempenho quase idêntico.');
  ELSIF(v_correlacao = 0) THEN
    dbms_output.put_line('Correlacao igual a zero, os desempenhos não estão relacionados.');
  ELSIF(v_correlacao < 0) THEN
    dbms_output.put_line('Correlacao negativa, as seleções tem um desempenho oposto.');
  ELSE
    dbms_output.put_line('Correlacao positiva, as seleções tem um desempenho parecido.');
  END IF;
END;

--- SAIDAS ---
FUNCTION -- compilado
bloco anônimo concluído
Correlacao entre Holanda e Alemanha: 0
Correlacao igual a zero, os desempenhos não estão relacionados.
