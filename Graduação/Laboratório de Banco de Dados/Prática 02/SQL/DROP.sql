/* Deleta tuplas e tabelas criadas.
   Executado após qualquer um dos outros scripts, dependendo do que se quer deletar.
   Alguns comandos podem ser executados depois de [01]CREATE_TABLE (marcados com [01] no início da sua declaração)
   Outros devem ser executados após [03]INSERT (marcados com [03] no início da sua declaração)
*/

/* [01] */
DROP TABLE JOGADORES_ENV;
DROP TABLE LANCE;
DROP TABLE ANUNCIO;
DROP TABLE PAISES_ALVO;
DROP TABLE PATROCINADOR;
/*
DROP TABLE RESERVA;
DROP TABLE ESCALACAO;
*/
DROP TABLE SAJ;
DROP TABLE JOGOSPART;
DROP TABLE ARBITRO;
DROP TABLE ATLETA;
DROP TABLE PESSOA;
DROP TABLE JOGO;
DROP TABLE ESTADIO;
DROP TABLE SELECAO;

/* [02] */
DROP SEQUENCE SEQ_IDESTADIO;
DROP SEQUENCE SEQ_IDJOGO;
DROP SEQUENCE SEQ_IDLANCE;
DROP SEQUENCE SEQ_IDPATROC;
DROP SEQUENCE SEQ_IDPESSOA;