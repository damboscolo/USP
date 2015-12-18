Listagem de Consumo na Televisão do Hóspede
consumo_televisao
num_diarias				FLOAT	3	Soma de todas as diárias do hóspede até a data atual									   DER
valor_diarias			FLOAT   10	Soma dos valores das diárias até a data atual											   DER
valor_consumo			FLOAT	10	Soma dos valores dos consumos do hóspede até a data atual								   DER
valor_desconto			FLOAT	7	Valor do desconto concedido ao hóspede													   DER
total_pagar				FLOAT	10	Soma do total a pagar até a data atual													   DER
total_item_consumo		FLOAT	10	Soma do total a pagar por cada item consumido											   DER
5 DER

Histórico das Estadias
historico_estadias
num_estadia				INTEGER 3	Número criado para representar qual a estadia a que a linha se referencia							DER
1 DER

Ocupação das Acomodações
ocupacao_das_acomodacoes
acomodacoes_ocupadas	INTEGER	4	Derivado do número de acomodações existentes menos o número de acomodações existentes.				DER
acomodacoes_reservadas	INTEGER	4	Derivado do número de acomodações existentes menos o número de acomodações reservadas. 				DER
acomodacoes_disponiveis INTEGER	4	Derivado do número de acomodações existentes menos o número de acomodações reservadas ou ocupadas. 	DER
3 DER

Faturamento do Hotel
faturamento_do_hotel
periodo					VARCHAR	10	"Semanal" ou "Quinzenal".																	DER
dia						VARCHAR	10	Dias da semana ou dias no formato "dd/mm".													DER
total_diarias			FLOAT	10	Derivado da soma de todas as diárias recebidas em um certo dia.								DER
total_frigobar			FLOAT	10	Derivado da soma de todas as rendas com produtos dentro do frigobar.						DER
total_restaurante		FLOAT	10	Derivado da soma de todas as rendas com o restaurante.										DER
total_lavandeira		FLOAT	10	Derivado da soma de todas as rendas com a lavanderia.										DER
total_telefonemas		FLOAT	10	Derivado da soma de todas as rendas com telefonemas realizados por clientes.				DER
total_descontos			FLOAT	10	Derivado da soma de todos os descontos que foram feitos no dia.								DER
total_semquin			FLOAT	10	Derivado da soma de todos os totais calculados anteriormente.								DER
7 DER

Fatura Impressa
fatura_impressa
periodo_de_estadia		VARCHAR	20	A data de entrada e a data de saída no formato "dd/mm/yy à dd/mm/yy".						DER
total_demais_gastos		FLOAT	10	Derivado da soma de todos os gastos com frigobar, restaurante e lavanderia de um cliente.	DER
2 DER

Faturas em Atraso
faturas_em_atraso
periodo					VARCHAR 10	"Semanal" ou "Quinzenal".																	DER
dia						VARCHAR 10  Dias da semana ou dias no formato "dd/mm".													DER
2 DER

B1-10_11 GastoHospedes
gasto_hospedes
subtotal_frigobar		FLOAT	10	Derivado da soma dos gastos do cliente com itens do frigobar								DER
subtotal_restaurante	FLOAT	10	Derivado da soma dos gastos do cliente com o restaurante									DER
subtotal_lavanderia		FLOAT	10	Derivado da soma dos gastos do cliente com a lavanderia										DER
total_pagar				FLOAT	10	Derivado da soma dos gastos totais do cliente, incluindo as diárias							DER
4 DER