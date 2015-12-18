Acompanhantes
data_chegada			DATE		8		RLR
hospede					LONG		12		RLR
nome					VARCHAR		45		RLR
idade					INTEGER		3		DER
RLR 3 | DER 1 | Simples

Hospede
docID					LONG		12		RLR
nome					VARCHAR		45		DER
telefone				INTEGER		12		DER	
email					VARCHAR		45		DER
data_nasc				DATE		8		DER
pai_ou_mae				VARCHAR		45		DER
endereco				LONG		12		DER --1
RLR 1 | DER 6 | Simples

Endereco
ID						LONG		12		RLR --1
rua						VARCHAR		45		DER
num						INT			5		DER
cidade					VARCHAR		45		DER
estado					VARCHAR		2		DER
pais					VARCHAR		45		DER
bairro					VARCHAR		45		DER
RLR 1 | DER 6 | Simples

Saida_hospede
num_acomodacao			INT			5		RLR --4
data_saida				DATE		8		RLR
hora_saida				TIME		8		DER
num_diarias				INTEGER		3		DER
valor_diaria			DOUBLE		10		DER
valor_telefonemas		DOUBLE		10		DER
desconto				DOUBLE		7		DER
tipo_pagamento			VARCHAR		25		DER --3
fatura					LONG		36		DER --2
RLR 2 | DER 7 | Simples

Reserva_acomodacao
data_chegada			DATE		8		RLR
hospede					LONG		12		RLR
hora_chegada			TIME		8		DER
data_saida				DATE		8		DER
hora_saida				TIME		8		DER
tipo_acomodacao			INTEGER		2		DER --5
valor_diaria			DOUBLE		10		DER
taxa_multa				DOUBLE		10		DER
dados_cartao			LONG		19		DER
desconto				DOUBLE		7		DER
RLR 2 | DER 8 | Simples

Fatura
numero					LONG		36		RLR --2
vencimento				DATE		8		DER
pagamento				DATE		8		DER
valor_pago				DOUBLE		10		DER
juros					DOUBLE		5		DER
multa					DOUBLE		10		DER
RLR 1 | DER 5 | Simples

Pagamento_estadia
opcoes					VARCHAR		25		RLR --3
RLR 1 | Simples

Funcionarios
docID					LONG		12		RLR
nome					VARCHAR		45		DER	
telefone				VARCHAR		45		DER
data_nasc				DATE		8		DER
endereco				LONG		12		DER --1 ENDERECO
RLR 1 | DER 4 | Simples

Acomodacao
numero					INTEGER		5		RLR
andar					INTEGER		2		DER
codigo_tipo_acomodacao	INTEGER		2		DER
RLR 1 | DER 2 | Simples

Consumo_hospede
data_consumo			DATE		8		RLR
num_acomodacao			INTEGER		5		RLR --4
funcionario_resp		LONG		12		DER
cod_item_consumo		LONG		8		DER
quantidade				INTEGER		4		DER
valor_unitario			DOUBLE		6		DER
RLR 2 | DER 4 | Simples

Item_consumo
codigo 					LONG		20		RLR
descricao				VARCHAR		45		DER
categoria				VARCHAR		45		DER
preco					DOUBLE		6		DER
RLR 1 | DER 3 | Simples

Categorias
descricao				VARCHAR		45		RLR
RLR 1 | Simples

Tipo_acomodacao
codigo					INT			2		RLR --5
descricao				VARCHAR		45		DER
quant_unid				INTEGER		3		DER
preco_diaria			DOUBLE		10		DER
num_adultos				INTEGER		2		DER
num_criancas			VARCHAR 	45		DER
RLR 1 | DER 5 | Simples

Entrada_hospede
data_chegada			DATE		8		RLR
hospede					LONG		12		RLR
hora_chegada			TIME		8		DER
data_saida_prevista		DATE		8		DER
hora_saida_prevista		TIME		8		DER
num_acomodacao			INT			5		DER --4
valor_diaria			DOUBLE		10		DER
funcionario_receb		LONG		12		DER
desconto				DOUBLE		7		DER
RLR 2 | DER 7 | Simples