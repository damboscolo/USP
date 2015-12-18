<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
class SQLManager{

	private $table;
	private $queryType;
	private $tables;
	private $attributes;
	private $conditions;
	private $orders;
	private $limit;
	private $join;
	private $distinct;
	private $union;
	private $intersect;
	private $db;
	private $sql;
	private $json;
	private $ok;
	private $erro;
	private $erroList = array(
		'BD' => 'Erro ao tentar conectar ao banco de dados', 
		'SELECT' => 'Erro ao tentar selecionar no banco de dados', 
		'UPDATE' => 'Erro ao tentar atualizar valores do banco de dados', 
		'INSERT' => 'Erro ao tentar inserir dados no banco de dados', 
		'DELETE' => 'Erro ao tentar deletar tupla do banco de dados', 
		'RI' => 'Requisiçao Inválida',
		'ET' => 'Erro ao tentar recuperar tuplas do banco de dados'
	);
	private $compareList = array(
		'int' => array('equal', 'diff', 'gt', 'gte', 'lt', 'lte'),
		'date' => array('equal', 'diff', 'gt', 'gte', 'lt', 'lte'),
		'varchar' => array('equal', 'diff', 'like'),
		'decimal' => array('equal', 'diff', 'gt', 'gte', 'lt', 'lte')
	);
	private $compareValue = array('equal' => '=', 'diff' => '!= / <>', 'gt' => '>', 'gte' => '>=', 'lt' => '<', 'lte' => '<=', 'like' => 'LIKE');
	private $compareLabel = array('equal' => 'igual', 'diff' => 'diferente', 'gt' => 'maior que', 'gte' => 'maior ou igual a', 'lt' => 'menor que', 'lte' => 'menor ou igual a', 'like' => 'parecido com');
	private $columnTypeList = array('int' => 'Número Inteiro', 'varchar' => 'Texto', 'date' => 'Data (aaaa-mm-dd)', 'decimal' => 'Número Real');
	private $columnTypeData = array('int' => 'digitos', 'varchar' => 'caracteres', 'date' => '', 'decimal' => ' digitos');
	private $columnList = array(
		'codEvento' => 'Código Evento',
		'nroEdicao' => '#Edição',
		'codDespesa' => 'Código Despesa',
		'codEventoPatrocinio' => 'Código Evento Patrocinio',
		'nroEdicaoPatrocinio' => '#Ediçao do Patrocinio',
		'tipoDespesa' => 'Tipo de Despesa',
		'nroInscricao'  => '#Inscrição',
		'nroInscritosEdicao' => '#Inscritos na Edição',
		'codPessoa' => 'Código Pessoa',
		'tipoOuvinte' => 'Pessoa Tipo Ouvinte',
		'tipoApresentador' => 'Pessoa Tipo Apresentador',
		'tipoOrganizador' => 'Pessoa Tipo Organizador',
		'dataDespesa' => 'Data da Despesa',
		'dataIniEdicao' => 'Data de Inicio da Edição',
		'dataFimEdicao' => 'Data de Fim da Edição',
		'dataNascPessoa' => 'Data de Nascimento',
		'cnpjPatrocinador' => 'CNPJ',
		'descricaoDespesa' => 'Descrição',
		'tituloEvento' => 'Titulo',
		'descricaoEvento' => 'Descrição',
		'siteEvento' => 'Site',
		'razaoSocialPatrocinador' => 'Razão Social',
		'nomeFantasiaPatrocinador' => 'Nome Fantasia',
		'enderecoPatrocinador' => 'Endereço',
		'nomePessoa' => 'Nome',
		'cpfPessoa' => 'CPF',
		'enderecoPessoa' => 'Endereço',
		'emailPessoa' => 'Email',
		'telefonePessoa' => 'Telefone',
		'valorDespesa' => 'Valor da Despesa',
		'valorPatrocinio' => 'Valor do Patrocinio',
		'saldoPatrocinio' => 'Saldo do Patrocinio'
	);
	private $sqlErrorList = array(
		1062 => 'Tupla já existe com essa combinaçao de cháve primária',
		1452 => 'A tupla referenciada por uma das chaves primarias não existe'
	);

	public function __construct(){
		$this->ok = true;
		$this->erro = false;
		$this->db = new PDO('mysql:host=127.0.0.1;dbname=projeto_bd', 'projeto_db', 'projetodbpass');
	}

	public function setTableParams($table){
		$this->table = $table;
	}

	public function setGeneratorParams($queryType, $tables, $attributes = false, $conditions = false, $orders = false, $limit = false, $join = false, $distinct = false, $union = false, $intersect = false){
		$this->queryType = $queryType;
		$this->tables = $tables;
		$this->attributes = $attributes;
		$this->conditions = $conditions;
		$this->orders = $orders;
		$this->limit = $limit;
		$this->distinct = $distinct;
		$this->join = $join;
		$this->union = $union;
		$this->intersect = $intersect;
	}

	public function generateSQL(){
		if($this->queryType == 'Mixed'){
			call_user_func(array($this, 'generateSelect'));
			if($this->union)
				$sql .= ' UNION ';
			else if($this->intersect)
				$sql .= ' INTERSECT ';
			call_user_func(array($this, 'generateSelect'));
		}else
			call_user_func(array($this, 'generate'.$this->queryType));
		return $this->sql;
	}

	public function generateSelect(){
		$sql = array();
		array_push($sql, 'SELECT '.join(', ', $this->attributes));
		if($this->distinct){
			array_push($sql, 'DISTINCT');
		}
		array_push($sql, 'FROM '.join(', ', $this->tables));
		if($this->join){
			foreach($this->join as $k=>$v){
				array_push($sql, 'JOIN '.$v['table'].' AS '.$v['as'].' ON '.$v['as'].'.'.$v['att'].' = '.$v['other'].'.'.$v['att']);
			}
		}
		if($this->conditions){
		array_push($sql, 'WHERE');
			foreach ($this->conditions as $k => $v){
				array_push($sql, $v['att'].' '.$v['compare'].' '.$v['value'].' '.$v['continue']);
			}
		}
		if($this->orders){
			array_push($sql, 'ORDER BY');
			foreach ($this->orders as $k => $v){
				array_push($sql, $v['att'].' '.$v['order'].',');
			}
		}
		$this->sql = join(' ', $sql);
	}

	public function generateUpdate(){
		$sql = array();
		array_push($sql, 'UPDATE '.join(', ', $this->tables).' SET ');
		$i = 0;
		foreach ($this->attributes['att_names'] as $k => $v) {
			if($i > 0)
				array_push($sql, ',');
			array_push($sql, $v.' = :_'.$v);
			$i++;
		}
		if($this->conditions){
			array_push($sql, 'WHERE');
			foreach ($this->conditions as $k => $v){
				array_push($sql, $v['att'].' '.$v['compare'].' '.$v['value'].' '.$v['continue']);
			}		
		}
		$this->sql = implode(' ', $sql);
	}

	public function generateDelete(){
		$this->sql = 'DELETE FROM '.join(', ', $this->tables).' WHERE ';
		if($this->conditions){
			foreach ($this->conditions as $k => $v){
				$this->sql .= $v['att'].' '.$v['compare'].' '.$v['value'].' '.$v['continue'];
			}
		}
	}

	public function generateInsert(){
		$this->sql = 'INSERT INTO '.join(', ', $this->tables).'('.join(', ', $this->attributes['att_names']).') VALUES (:_'.join(', :_', $this->attributes['att_names']).')';
	}

	public function executeSql(){
		$params = array();
		if($this->attributes && ($this->queryType == 'Insert' || $this->queryType == 'Update')){
			foreach($this->attributes['att_names'] as $k => $v){
				$params[':_'.$v] = $this->attributes['att_values'][$k];
			}
		}
		$stm = $this->db->prepare($this->sql);
		$result = false;
		if($stm){
			$r = $stm->execute($params);
			if($r){
				if($this->queryType == 'Select')
					$result = $stm->fetchAll();
				else
					$result = $r;
			}else{
				$erro = $stm->errorInfo();
				$this->setErro($this->sqlErrorList[$erro[1]]);
			}			
		}else{
			$erro = $this->db->errorInfo();
			$this->setErro('Erro: '.$erro[2]);
		}
		return $result;
	}

	public function getSql(){
		return $this->sql;
	}

	public function setSql($sql){
		$this->sql = $sql;
	}

	public function getRows($sql){
		$r = array();
		foreach($this->db->query($sql) as $row){
			array_push($r, $row);
		}
		return $r;
	}

	public function getTables(){
		return $this->getRows("SHOW TABLES");
	}

	public function getCountRowsAllTables(){
		$tables = $this->getTables();
		foreach($tables as $k => $v){
			$count = $this->getRows('SELECT COUNT(*) FROM '.$v[0]);
			$result[$v[0]] = $count[0]['COUNT(*)'];
		}
		return $result;
	}

	public function getColumns($table){
		return $this->getRows("EXPLAIN ".$table);
	}

	public function getColumnType($col){
		return strpos($col, '(')?substr($col, 0, strpos($col, '(')):$col;
	}

	public function getColumnTypeRenamed($col){
		return $this->columnTypeList[$this->getColumnType($col)];
	}

	public function getColumnTypeLimit($col){
		$type = $this->getColumnType($col);
		if($type == 'date')
			return '';
		$length = $this->getColumnLength($col);
		$dataType = $this->columnTypeData[$type];
		$length = is_array($length)?$length[0]+$length[1]+1:$length;
		return 'máximo '.$length.' '.$dataType;
	}

	public function getColumnLength($col){
		$length = substr($col, strpos($col, '(')+1, -1);
		if($this->getColumnType($col) == 'decimal'){
			$len = explode(',', $length);
			return $len;
		}
		return $length;
	}

	public function getPrimaryKeys($table){
		$result = array();
		$cols = $this->getColumns($table);
		foreach($cols as $k => $v){
			if($v['Key'] == 'PRI')
				array_push($result, $v);
		}
		$rpks = array();
		foreach($result as $key => $val){
			array_push($rpks, $val['Field']);
		}
		return $rpks;
	}

	public function getPrimaryKeyValues($table, $tuplas){
		$pks = $this->getPrimaryKeys($table);
		$pkvs = array();
		foreach($tuplas as $k => $v){
			if(in_array($k, $pks, TRUE))
				array_push($pkvs, $v);
		}
		return $pkvs;
	}

	private function renameAttributes(&$atts){
		foreach ($atts as $k => $v) {
			$atts[$k] = $v.' AS '.$this->attributeList[$v];
		}
	}

	public function renameColumns($colName){
		return $this->columnList[$colName];
	}

	public function getAllFromTable($table, $sort = false, $dir = false){
		return $this->getRows('SELECT * FROM '.$table.($sort?' ORDER BY '.$sort.($dir?' '.$dir:' DESC'):''));
	}

	public function getJSON(){
		return $this->json;
	}

	public function setJSON($json){
		$this->json = $json;
	}

	public function printJSON(){
		if($this->ok)
			echo json_encode(array('Estado' => 'OK', 'resultado' => $this->json));
		else
			echo json_encode(array('Estado' => 'erro', 'Erro' => $this->getErrorMessage()));
	}

	public function getErrorMessage(){
		return $this->erro?$this->erro:$this->erroList[$this->erro];
	}

	public function getCompares($type){
		return $this->compareList[$type];
	}

	public function getComparesFields($compares){
		$fields;
		foreach ($compares as $k => $v) {
			$fields[$this->compareLabel[$v]] = $this->compareValue[$v]; 
		}
		return $fields;
	}

	public function setErro($erro){
		$this->ok = false;
		$this->erro = $erro;
	}

}