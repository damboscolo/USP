Acompanhantes
Campos:
	data_chegada			DATE		8		DER
	hospede					LONG		12		DER
	nome					VARCHAR		45		DER
	idade					INTEGER		3		DER
DER 4 | Simples

Hospede
Arquivos:
	Acompanhantes								ALR
	Endereco									ALR
Campos:
	docID					LONG		12		DER
	nome					VARCHAR		45		DER
	telefone				INTEGER		12		DER	
	email					VARCHAR		45		DER
	data_nasc				DATE		8		DER
	pai_ou_mae				VARCHAR		45		DER
	endereco				LONG		12		DER
ALR 2 | DER 7 | Média

Endereco
Campos:
	ID						LONG		12		DER
	rua						VARCHAR		45		DER
	num						INT			5		DER
	cidade					VARCHAR		45		DER
	estado					VARCHAR		2		DER
	pais					VARCHAR		45		DER
	bairro					VARCHAR		45		DER
DER 7 | Simples

Saida_hospede
Arquivos:
	Acomodacao									ALR
	Pagamento_estadia							ALR
	Fatura										ALR
	Hospede										ALR
Campos:
	num_acomodacao			INT			5		DER
	data_saida				DATE		8		DER
	hora_saida				TIME		8		DER
	num_diarias				INTEGER		3		DER
	valor_diaria			DOUBLE		10		DER
	valor_telefonemas		DOUBLE		10		DER
	desconto				DOUBLE		7		DER
	fatura					LONG		36		DER
ALR 4 | DER 8 | Complexa

Reserva_acomodacao
Arquivos:
	Tipo_acomodacao								ALR
	Hospede										ALR
Campos:
	data_chegada			DATE		8		DER
	hospede					LONG		12		DER
	hora_chegada			TIME		8		DER
	data_saida				DATE		8		DER
	hora_saida				TIME		8		DER
	tipo_acomodacao			INTEGER		2		DER
	valor_diaria			DOUBLE		10		DER
	taxa_multa				DOUBLE		10		DER
	dados_cartao			LONG		19		DER
	desconto				DOUBLE		7		DER
ALR 2 | DER 10 | Média

Fatura
Campos:
	numero					LONG		36		DER 
	vencimento				DATE		8		DER
	pagamento				DATE		8		DER
	valor_pago				DOUBLE		10		DER
	juros					DOUBLE		5		DER
	multa					DOUBLE		10		DER
DER 6 | Simples

Funcionarios
Arquivos:
	Endereco
Campos:
	docID					LONG		12		DER
	nome					VARCHAR		45		DER	
	telefone				VARCHAR		45		DER
	data_nasc				DATE		8		DER
	endereco				LONG		12		DER
ALR 1 | DER 5 | Simples

Acomodacao
Arquivos:
	Tipo_acomodacao								ALR
Campos:
	numero					INTEGER		5		DER
	andar					INTEGER		2		DER
	codigo_tipo_acomodacao	INTEGER		2		DER
ALR 1 | DER 3 | Simples

Consumo_hospede
Arquivos:
	Funcionarios								ALR
	Item_consumo								ALR
	Acomodacao									ALR
Campos:
	data_consumo			DATE		8		DER
	num_acomodacao			INTEGER		5		DER
	funcionario_resp		LONG		12		DER
	cod_item_consumo		LONG		8		DER
	quantidade				INTEGER		4		DER
	valor_unitario			DOUBLE		6		DER
ALR 3 | DER 6 | Complexa

Item_consumo
Arquivo:
	Categorias									ALR
Campos:
	codigo 					LONG		20		DER
	descricao				VARCHAR		45		DER
	preco					DOUBLE		6		DER
ALR 1 | DER 3 | Simples

Tipo_acomodacao
Campos:
	codigo					INT			2		DER
	descricao				VARCHAR		45		DER
	quant_unid				INTEGER		3		DER
	preco_diaria			DOUBLE		10		DER
	num_adultos				INTEGER		2		DER
	num_criancas			VARCHAR 	45		DER
DER 6 | Simples

Entrada_hospede
Arquivos:
	Acomodacao									ALR
	Hospede										ALR
Campos:
	data_chegada			DATE		8		DER
	hospede					LONG		12		DER
	hora_chegada			TIME		8		DER
	data_saida_prevista		DATE		8		DER
	hora_saida_prevista		TIME		8		DER
	num_acomodacao			INT			5		DER
	valor_diaria			DOUBLE		10		DER
	funcionario_receb		LONG		12		DER
	desconto				DOUBLE		7		DER
ALR 2 | DER 9 | Média
