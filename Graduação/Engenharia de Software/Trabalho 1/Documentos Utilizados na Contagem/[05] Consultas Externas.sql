Contagem de todas as interfaces pedidas pelo cliente, que necessitam de algum tipo de consulta que devolve dados para o cliente. 
(EXEMPLO: Na interface EntradaHospedes existe a possibilidade de se pedir que os dados sejam preenchidos automaticamente através dos dados das reservas, através do nome em que foi feito a reserva. 
	Por isso a entrada vai ser "Nome Reserva Prévia". 
	Para a consulta acontecer o botão "Recuperar Dados da Reserva" deve ser apertado. 
	Os arquivos utilizados são com base nos dados que deverão ser preenchidos automaticamente pela consulta.
	Desconsiderei os dados dos Acompanhantes e do Funcionário Responsável pela entrada do hóspede já que esses vão ser preenchidos no momento da entrada do hóspede.
	As mensagens que vão aparecer nessa tela devem ser consideradas como saídas.
	O DER a ser considerado é sempre o maior entre os DER de Entrada e de Saída.
	LEIAM: Página 26 EXEMPLO. http://www.icmc.usp.br/CMS/Arquivos/arquivos_enviados/BIBLIOTECA_113_RT_105.pdf 
	
	As tabelas que mostram todos os dados de um certo tipo (B1-01/02/03/04/05 Visualização) são consideradas consultas, porém não são consultas externas. Uma consulta externa deve possuir uma entrada pelo menos, ou seja, deve ser originada do usuário.
	
	2 Simples / 3 Média / 3 Complexa)

B1-07 - EntradaHospedes
	Arquivos:
		-Acompanhantes										ALR
		-Reserva_acomodacao									ALR
	Entrada: [2 DER]
		-Nome Reserva Prévia								DER
		-Botão "Recuperar Dados da Reserva"					DER
	Saída: 	 [10 DER]
		Arquivo "Reserva_acomodacao" [ALI]:
		data_chegada										DER
		hora_chegada										DER
		data_saida											DER
		hora_saida											DER
		tipo_acomodacao										DER
		valor_diaria										DER
		taxa_multa											DER
		dados_cartao										DER
		desconto											DER
		Mensagens:
		Mensagem "Não foi possível encontrar a reserva"		DER
3 ALR | 10 DER | Complexa

B1-10_11 - GastosHospedes
	Arquivos:
		-Acomodacao											ALR
		-Consumo_hospede									ALR
	Entrada: [2 DER]
		-Número do Quarto									DER
		-Botão "Resgatar Gastos"							DER
	Saída:	 [8 DER]
		Arquivo "Consumo_hospede" [ALI]:
		-cod_item											DER
		-quantidade											DER
		-valor_unitario										DER
		Arquivo "Gasto_hospedes" [ALE]:
		-subtotal_frigobar									DER
		-subtotal_restaurante								DER
		-subtotal_lavanderia								DER
		-total_pagar										DER
		Mensagens:
		Mensagem "Não foi possível encontrar o quarto."     DER
2 ALR | 8 DER | Média

B2-16 - Listagem de Consumo na Televisão do Hóspede
	Arquivos:
		-Acomodacao											ALR
		-Tipo_acomodacao									ALR
		-Consumo_hospede									ALR
		-Consumo_televisao									ALR
	Entrada: [1 DER]
		-Número do Quarto									DER
	Saída:	 [18 DER]
		Arquivo "Tipo_acomodacao" [ALI]:
		-descricao											DER
		-preco_diaria										DER
		-num_adultos										DER
		-num_criancas										DER
		Arquivo "Consumo_hospede" [ALI]:
		-data_consumo										DER
		-quantidade											DER
		Arquivo "Item_consumo" [ALI]:
		-descricao											DER
		-preco												DER
		Arquivo "Consumo_televisao" [ALE]:
		-num_diarias										DER
		-valor_diarias										DER
		-valor_consumo										DER
		-valor_desconto										DER
		-total_pagar										DER
		-total_item_consumo									DER
		Mensagens:
		-Mensagem "Não existem gastos na categoria Frigobar"	DER
		-Mensagem "Não existem gastos na categoria Restaurante"	DER
		-Mensagem "Não existem gastos na categoria Lavanderia"	DER
		-Mensagem "Não foi possível encontrar o quarto."		DER
4 ALR | 18 DER | Complexa

B2-17 - Histórico das Estadias
	Arquivos:
		-Saida_hospede											ALR
		-Fatura													ALR
		-Historico_estadias										ALR
	Entrada: [3 DER]
		-Número de Identificação do Hóspede						DER
		-Senha do Hóspede										DER
		Mensagens:
		-Mensagem "Nome de usuário ou senha incorretos."		DER
	Saída:	 [5 DER]
		Arquivo "Saida_hospede" [ALI]:
		-data_chegada											DER
		-data_saida												DER
		Arquivo "Fatura" [ALI]:
		-valor_pago												DER
		Arquivo "Historico_estadias" [ALE]:
		-num_estadia											DER
		Mensagens:
		-Mensagem "Não foi possível encontrar estadias anteriores."	DER
3 ALR | 5 DER | Média

B2-18 - Ocupação das Acomodações
	Arquivos:
		-Tipo_acomodacao											   ALR
		-Ocupacao_acomodacoes										   ALR
	Entrada: [2 DER]
		-Data a ser consultada										   DER
		Mensagens:
		-Mensagem "Data entrada incorretamente. Use o modelo DD/MM/AA" DER
	Saída:	 [4 DER]
		Arquivo "Tipo_acomodacao" [ALI]:
		-quant_unid													   DER
		-descricao													   DER
		Arquivo "Ocupacao_acomodacoes" [ALE]:
		-acomodacoes_ocupadas										   DER
		-acomodacoes_reservadas										   DER
		-acomodacoes_disponiveis									   DER
2 ALR | 5 DER | Simples

B2-19 - Faturamento do Hotel
	Arquivos:
		-Faturamento_do_hotel										   ALR
	Entrada: [2 DER]
		-Período a ser exibido										   DER
		Mensagens:
		-Mensagem "Não existem dados para o período selecionado."	   DER
	Saída:	 [9 DER]
		Arquivo "Faturamento_do_hotel" [ALE]:
		-periodo													   DER
		-dia														   DER
		-total_diarias												   DER
		-total_frigobar												   DER
		-total_restaurante											   DER
		-total_lavanderia											   DER
		-total_telefonemas											   DER
		-total_descontos											   DER
		-total_semquin												   DER
1 ALR | 9 DER | Simples

B2-20 - Fatura Impressa
	Arquivos:
		-Hospede														ALR
		-Endereco														ALR
		-Fatura_impressa												ALR
	Entrada: [2 DER]
		-Nome do Hóspede											  	DER
		Mensagens:
		-Mensagem "Nome do hóspede não encontrado."					  	DER
	Saída:	 [8 DER]
		Arquivo "Hospede" [ALI]:
		-nome
		Arquivo "Endereco" [ALI]:
		-rua															DER --Rua, num e bairro são contados como apenas um DER, pois são atributos usados para apenas um intuito: o endereço.
		-num															
		-bairro															
		-cidade															DER
		-pais															DER
		Arquivo "Saida_hospede" [ALI]:
		valor_diaria													DER
		desconto														DER
		Arquivo "Fatura" [ALI]:
		-vencimento														DER
		-valor_pago														DER
		Arquivo "Fatura_impressa" [ALE]:
		-periodo_de_estadia												DER
		-total_demais_gastos											DER
3 ALR | 8 DER | Complexa

B2-21 - Fatura em Atraso
	Arquivos:
		-Hospede																ALR
		-Fatura																	ALR
		-Fatura_em_atraso														ALR
	Entrada: [3 DER]
		-Período para ver as faturas em atraso									DER
		-Nome do Hóspede														DER
		Mensagens:
		-Mensagem "Nome do hóspede não encontrado."								DER
	Saída:	 [5 DER]
		Arquivo "Hospede" [ALI]:
		-nome																	DER
		Arquivo "Fatura" [ALI]:
		-valor_pago																DER
		-vencimento																DER
		Arquivo "Fatura_em_atraso" [ALE]:
		-dia																	DER
		Mensagens:
		-Mensagem "Não existem faturas atrasadas para o período selecionado."	DER
3 ALR | 5 DER | Média