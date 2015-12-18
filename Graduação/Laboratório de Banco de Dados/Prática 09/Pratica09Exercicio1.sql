--Exercício 1
ALTER TABLE Jogador
ADD (experiencia VARCHAR2(100),
	salario	NUMBER);

ALTER TABLE Jogador
ADD CONSTRAINT JogadorCheckExperiencia
		CHECK (experiencia IN ('Senior', 'Profissional', 'Iniciante', 'Amador'));

UPDATE Jogador
SET experiencia = 'Senior'
WHERE idPessoa = 13;

UPDATE Jogador
SET experiencia = 'Profissional'
WHERE idPessoa = 14;

UPDATE Jogador
SET experiencia = 'Iniciante'
WHERE idPessoa = 15;

UPDATE Jogador
SET experiencia = 'Amador'
WHERE idPessoa = 16;

UPDATE Jogador
SET experiencia = 'Senior'
WHERE idPessoa = 17;

UPDATE Jogador
SET experiencia = 'Amador'
WHERE idPessoa = 18;

UPDATE Jogador
SET experiencia = 'Profissional'
WHERE idPessoa = 19;

UPDATE Jogador
SET experiencia = 'Iniciante'
WHERE idPessoa = 20;

CREATE OR REPLACE PACKAGE PacoteCalculo AS
	
	exc_atributoInvalido EXCEPTION;
	
	TYPE Calculo IS RECORD
	(
		porcentagem NUMBER(2),
		referencia VARCHAR2(100)
	);

	TYPE t_calculo IS TABLE OF Calculo INDEX BY Jogador.experiencia%TYPE;
	
	FUNCTION calculoSalario(p_experiencia Jogador.experiencia%TYPE) RETURN NUMBER;
	
END PacoteCalculo;
/

CREATE OR REPLACE PACKAGE BODY PacoteCalculo AS
	
	v_calculo t_calculo;

	FUNCTION calculoSalario(p_experiencia Jogador.experiencia%TYPE) RETURN NUMBER AS
		BEGIN
			IF(p_experiencia NOT IN ('Senior', 'Profissional', 'Iniciante', 'Amador')) THEN
				raise exc_atributoInvalido;
			ELSIF(p_experiencia = 'Senior') THEN
				RETURN 150000;
			ELSE
				RETURN (calculoSalario(v_calculo(p_experiencia).referencia) * (v_calculo(p_experiencia).porcentagem/100));
			END IF;
			
			EXCEPTION
				WHEN exc_atributoInvalido THEN
					raise_application_error(-20001, 'Não é um atributo válido, tente Senior, Profissional, Iniciante ou Amador.');
		END;

BEGIN

	v_calculo('Profissional').porcentagem := 80;
	v_calculo('Profissional').referencia := 'Senior';
	
	v_calculo('Iniciante').porcentagem := 75;
	v_calculo('Iniciante').referencia := 'Profissional';
	
	v_calculo('Amador').porcentagem := 70;
	v_calculo('Amador').referencia := 'Iniciante';
	
END PacoteCalculo;
/

CREATE OR REPLACE TRIGGER triggerAtualizaSalario
BEFORE UPDATE ON Jogador
FOR EACH ROW
DECLARE

BEGIN
	:new.salario := PacoteCalculo.calculoSalario(:new.experiencia);
END;
/