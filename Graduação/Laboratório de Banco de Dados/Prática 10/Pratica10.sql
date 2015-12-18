—- SCC 541 - Laboratório de Bases de dados - Material de apoio à prática 10
—- Material criado por Prof. Dr. José Fernando Rodrigues Júnior

create or replace
PROCEDURE INSERT_INTO(vNameOfTable IN CHAR, nOfRows IN NUMBER) AS
 iUmId NUMBER; 
 iUmValor NUMBER;
 iUmOutroValor NUMBER;
 iTemp NUMBER;
 i NUMBER;
 vTemp CHAR(300); 
BEGIN
 i := 1;
 WHILE i <= nOfRows LOOP
    vTemp := 'SELECT trunc(dbms_random.value(1,'|| nOfRows*100 ||')) FROM DUAL';
    EXECUTE IMMEDIATE vTemp INTO iUmId;
    vTemp := 'SELECT COUNT(*) FROM ' || vNameOfTable || ' WHERE ID =' || iUmId;
    EXECUTE IMMEDIATE vTemp INTO iTemp;
    IF iTemp = 0 THEN
       vTemp := 'SELECT trunc(dbms_random.value(1,'|| nOfRows*100 ||')) FROM DUAL';
       EXECUTE IMMEDIATE vTemp INTO iUmValor;
	   
       vTemp := 'SELECT trunc(dbms_random.value(1,50)) FROM DUAL';
       EXECUTE IMMEDIATE vTemp INTO iUmOutroValor;
	   
  	   vTemp := 'INSERT INTO ' || vNameOfTable || ' VALUES(' || iUmId ||','''|| iUmValor ||''','''|| iUmOutroValor ||''')';
      EXECUTE IMMEDIATE vTemp;
    END IF;
    i := i + 1;
 END LOOP;
 dbms_output.put_line('Number of inserted rows: '|| i);
END;
/
create or replace
PROCEDURE GETTIME(sqlQuery IN CHAR) AS
 iTime NUMBER;
 j NUMBER;
BEGIN
 iTime := dbms_utility.get_time;
 EXECUTE IMMEDIATE sqlQuery;
 iTime:=round((dbms_utility.get_time-iTime)/100,2);
 dbms_output.put_line(iTime || ' Sec');
end;
/
create or replace
PROCEDURE SELECT_FROM_BTREE(vNameOfTable IN CHAR, nOfSelects IN NUMBER) AS
 iMin NUMBER;
 iMax NUMBER;
 iUmId NUMBER;
 i NUMBER;
 vTemp CHAR(300); 
BEGIN
 vTemp := 'SELECT MIN(nome1) FROM ' || vNameOfTable;
 EXECUTE IMMEDIATE vTemp INTO iMin;
 vTemp := 'SELECT MAX(nome1) FROM ' || vNameOfTable;
 EXECUTE IMMEDIATE vTemp INTO iMax;

 i := 1;
 WHILE i <= nOfSelects LOOP
    vTemp := 'SELECT trunc(dbms_random.value('|| iMin || ','|| iMax ||')) FROM DUAL';
    EXECUTE IMMEDIATE vTemp INTO iUmId;

    vTemp := 'SELECT * FROM ' || vNameOfTable ||' WHERE nome1 = '''|| IUmId || '''';
    EXECUTE IMMEDIATE vTemp;

    i := i + 1;
 END LOOP;
 dbms_output.put_line('Number of selects: '|| i);
END;
/
create or replace
PROCEDURE SELECT_FROM_BITMAP(vNameOfTable IN CHAR, nOfSelects IN NUMBER) AS
 iMin NUMBER;
 iMax NUMBER;
 iUmValor NUMBER;
 i NUMBER;
 vTemp CHAR(300); 
BEGIN
 vTemp := 'SELECT MIN(nome2) FROM ' || vNameOfTable;
 EXECUTE IMMEDIATE vTemp INTO iMin;
 vTemp := 'SELECT MAX(nome2) FROM ' || vNameOfTable;
 EXECUTE IMMEDIATE vTemp INTO iMax;

 i := 1;
 WHILE i <= nOfSelects LOOP
    vTemp := 'SELECT trunc(dbms_random.value('|| iMin || ','|| iMax ||')) FROM DUAL';
    EXECUTE IMMEDIATE vTemp INTO iUmValor;

    vTemp := 'SELECT * FROM ' || vNameOfTable ||' WHERE nome2 = '''|| iUmValor || '''';
    EXECUTE IMMEDIATE vTemp;

    i := i + 1;
 END LOOP;
 dbms_output.put_line('Number of selects: '|| i);
END;
/