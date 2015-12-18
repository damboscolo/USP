
--2.
--a)
CREATE VIEW View_Jogador AS
  SELECT P.nome "Jogador", J.nomeSelecao "Selecao", count(DISTINCT L.idJogo) "Jogos c/ Cartoes Amarelos"
  FROM Jogador J
          JOIN Pessoa P     ON P.id            = J.idPessoa
          JOIN Informacao I ON I.nomeSelecao1  = J.nomeSelecao OR I.nomeSelecao2 = J.nomeSelecao
          JOIN Jogo         ON Jogo.id         = I.idJogo
          JOIN Lance L      ON L.idJogo        = Jogo.id
          JOIN PartDe Par   ON Par.idJogador = J.idPessoa AND Par.idJogo = Jogo.id AND Par.tempo = L.tempo
  WHERE L.idTipo = 3
  GROUP BY P.nome, J.nomeSelecao
  HAVING count(P.nome) > 1;

--b)

CREATE VIEW View_Patrocinador AS
SELECT nome "Patrocinador", 
       I.nomeSelecao "Seleção de Interesse",
       count(case when (I.nomeSelecao = Inf.nomeSelecao1 OR I.nomeSelecao = Inf.nomeSelecao2) then 1 end) "Jogos c/ Interesse"
FROM Patrocinador P
JOIN DivEm D ON D.idPatrocinador = P.id
JOIN Inter I ON I.idPatrocinador = P.id
JOIN Jogo J ON J.id = D.idJogo
JOIN Informacao Inf ON Inf.idJogo = J.id
GROUP BY nome, I.nomeSelecao;

--c)