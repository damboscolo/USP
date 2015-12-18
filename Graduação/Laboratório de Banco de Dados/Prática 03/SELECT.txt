--2)

--a)Liste o nome dos patrocinadores já divulgados em algum jogo, incluindo também a contagem de divulgações em jogos de seleções de interesse do patrocinador e a contagem de divulgações em demais jogos;

SELECT nome "Patrocinador", 
       count(case when (I.nomeSelecao = Inf.nomeSelecao1 OR I.nomeSelecao = Inf.nomeSelecao2) then 1 end) "Jogos c/ Interesse", 
       count(case when (I.nomeSelecao != Inf.nomeSelecao1 AND I.nomeSelecao != Inf.nomeSelecao2) then 1 end) "Jogos s/ Interesse"
FROM Patrocinador P
JOIN DivEm D ON D.idPatrocinador = P.id
JOIN Inter I ON I.idPatrocinador = P.id
JOIN Jogo J ON J.id = D.idJogo
JOIN Informacao Inf ON Inf.idJogo = J.id
GROUP BY P.nome;

--b)Para uma dada seleção, liste os nomes dos jogadores que foram titulares em pelo menos um jogo disputado;

SELECT DISTINCT P.nome "Jogador"
FROM Selecao
JOIN Jogd J ON J.nomeSelecao = Selecao.nomeNacao 	--junta jogador com selecao
JOIN Pes P ON J.idPessoa = P.id 					--junta jogador com pessoa
JOIN JgEm JE ON JE.idJogador = P.id 				--junta jogouEm com pessoa
WHERE JE.titular = 'S' 
	  AND Selecao.nomeNacao = 'Alemanha';

--c)Liste o nome de todos os árbitros (função “Principal”) que já deram cartão vermelho em mais do que um jogo;

SELECT nome "Árbitro"
FROM Pes P
JOIN Arb ON P.id = Arb.idPessoa 		--junta arbitro com pessoa
JOIN Apt ON P.id = Apt.idArbitro		--junta apitou
JOIN Jogo J ON J.id = Apt.idJogo    	
JOIN Lance L ON L.idJogo = Apt.idJogo	
WHERE Apt.funcao = 'Principal' 
	AND L.idTipo = 4
GROUP BY P.NOME
        HAVING count(P.nome) > 1;
			
--d)Escreva uma consulta que retorna a lista de artilheiros em ordem decrescente de número de gols e também o correspondente rank do jogador; além disso, inclua o número de gols marcados, o número de partidas em que marcou gols ou em que recebeu cartões, a média de gols por partida e o número de cartões amarelos, e vermelhos;

SELECT DISTINCT
       RANK() OVER (ORDER BY count(P.nome)) "Rank", 
       nome "Jogador",
       count(case when L.idTipo = 1 then 1 end) "Gols",
       count(case when (L.idTipo = 1 AND L.idJogo = Par.idJogo) then 1 end) "Nº de Partidas c/ Gol",
       count(case when (L.idTipo = 3 OR L.idTipo = 4) then 1 end) "Número de Cartões",
       round(count(case when L.idTipo = 1 then 1 end)/count(L.idJogo), 2) "Média de Gols",
       count(case when L.idTipo = 3 then 1 end) "Cartões Amarelos",
       count(case when L.idTipo = 4 then 1 end) "Cartões Vermelhos"
FROM Pessoa P
JOIN Jogd J ON J.idPessoa = P.id
JOIN Selecao S ON S.nomeNacao = J.nomeSelecao
JOIN Informacao Inf ON Inf.NomeSelecao1 = S.nomeNacao OR Inf.NomeSelecao2 = S.nomeNacao
JOIN Jogo Jg ON Jg.id = Inf.idJogo
JOIN Lance L ON L.idJogo = Jg.id
JOIN PartDe Par ON Par.idJogador = J.idPessoa AND Par.idJogo = L.idJogo AND Par.tempo = L.tempo
GROUP BY P.nome, nome
ORDER BY "Gols" DESC;

--e)Para uma dada seleção, escreva uma consulta que retorna as vitórias da seleção considerando todos os jogos já jogados na fase de grupos; faça o mesmo para os empates, e para as derrotas. Em seguida, use a união para unir as 3 consultas. Finalmente, escreva uma superconsulta que conte e retorne o número de vitórias, empates, e derrotas, e também retorne o número de pontos obtidos.
--Dica: rotule as tuplas de cada consulta inicial com ‘V’, ‘E’, ou ‘D’.

--f)Liste os nomes dos árbitros (função “Principal”) que deram o maior número de cartões (amarelo + vermelho), inclua o rank em ordem crescente;

SELECT RANK() OVER (ORDER BY count(P.id)) "Rank", 
       nome "Árbitro", 
       count(P.id) "Cartões Dados"
FROM Pes P
JOIN Arb A ON P.id = A.idPessoa
JOIN Apt ON P.id = Apt.idArbitro
JOIN Jogo J ON J.id = Apt.idJogo
JOIN Lance L ON L.idJogo = Apt.idJogo
WHERE Apt.funcao = 'Principal' 
	  AND (L.idTipo = 3 OR L.idTipo = 4)
GROUP BY P.nome
ORDER BY "Rank";

--3)Considere a seguinte tarefa: selecionar todos os dados das seleções que alguma vez já disputaram partidas em estádios com capacidade maior do que 50.000 pessoas.
--Implemente 3 versões para esta consulta:

--a)Versão 1: apenas usando junção;

SELECT DISTINCT 
       nomeNacao "Seleção", 
       idGrupo "Grupo", 
       to_char(hino) "Hino", 
       continente "Continente", 
       pontos "Ponto", 
       golsMarcados "Gols Marcados", 
       golsSofridos "Gols Sofridos", 
       saldo "Saldo de Gols", 
       cartAm "Cartões Amarelos", 
       cartVer "Cartões Vermelhos"
FROM Selecao S
JOIN Informacao Inf ON (Inf.nomeSelecao1 = S.nomeNacao OR Inf.nomeSelecao2 = S.nomeNacao)
JOIN Jogo J ON J.id = Inf.idJogo
JOIN Estadio E ON E.id = J.idEstadio
WHERE E.capacidade >= 50000
ORDER BY S.idGrupo;

--b)Versão 2: com consultas aninhadas correlacionadas (EXISTS);
----Ainda não está certa!

SELECT DISTINCT 
       nomeNacao "Seleção", 
       idGrupo "Grupo", 
       to_char(hino) "Hino", 
       continente "Continente", 
       pontos "Ponto", 
       golsMarcados "Gols Marcados", 
       golsSofridos "Gols Sofridos", 
       saldo "Saldo de Gols", 
       cartAm "Cartões Amarelos", 
       cartVer "Cartões Vermelhos"
FROM Selecao S
WHERE EXISTS(SELECT *
             FROM Jogo J
             WHERE EXISTS(SELECT *
                              FROM Informacao Inf
                              WHERE (Inf.nomeSelecao1 = S.nomeNacao OR Inf.nomeSelecao2 = S.nomeNacao)
                   AND EXISTS(SELECT *
                          FROM Estadio E
                          WHERE (J.idEstadio = E.id AND E.capacidade >= 50000))))
ORDER BY S.idGrupo;

--c)Versão 3: com consultas aninhadas não correlacionadas (IN);

SELECT DISTINCT 
       nomeNacao "Seleção", 
       idGrupo "Grupo", 
       to_char(hino) "Hino", 
       continente "Continente", 
       pontos "Ponto", 
       golsMarcados "Gols Marcados", 
       golsSofridos "Gols Sofridos", 
       saldo "Saldo de Gols", 
       cartAm "Cartões Amarelos", 
       cartVer "Cartões Vermelhos"
FROM Selecao S
WHERE S.nomeNacao IN (SELECT nomeSelecao1
                      FROM Informacao Inf
                      WHERE Inf.idJogo IN (SELECT id
                                           FROM Jogo J
                                           WHERE J.idEstadio IN (SELECT id
                                                                 FROM Estadio E
                                                                 WHERE E.capacidade >= 50000)))
UNION
SELECT DISTINCT 
       nomeNacao "Seleção", 
       idGrupo "Grupo", 
       to_char(hino) "Hino", 
       continente "Continente", 
       pontos "Ponto", 
       golsMarcados "Gols Marcados", 
       golsSofridos "Gols Sofridos", 
       saldo "Saldo de Gols", 
       cartAm "Cartões Amarelos", 
       cartVer "Cartões Vermelhos"
FROM Selecao S
WHERE S.nomeNacao IN (SELECT nomeSelecao2
                      FROM Informacao Inf
                      WHERE Inf.idJogo IN (SELECT id
                                           FROM Jogo J
                                           WHERE J.idEstadio IN (SELECT id
                                                                 FROM Estadio E
                                                                 WHERE E.capacidade >= 50000)));
