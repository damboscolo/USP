<?php
require_once("SQLManager.php");

$sqlm = new SQLManager();

foreach($_GET as $key=>$val){
	$$key = $val;
}

foreach ($_POST as $k => $v) {
	$$k = $v;
}

$params_start = strpos($_SERVER['REQUEST_URI'], '?') + 1;
if($params_start > 1){
	$requestURI = substr($_SERVER['REQUEST_URI'], $params_start);
	$params = explode('&', $requestURI);
	foreach ($params as $k => $v) {
		$params[$k] = explode('=', $v);
		$$params[$k][0] = $params[$k][1];
	}
}

$type = substr($queryType, 0, 5);
if($type == 'Table' && isset($table))
	$sqlm->setTableParams($table);

switch($queryType){
	case 'TableCountRows':
		$sqlm->setJSON($sqlm->getCountRowsAllTables());
		break;
	case 'TableVisualize':
		$sort = isset($sort)?$sort:false;
		$dir = isset($dir)?$dir:false;
		$r = $sqlm->getAllFromTable($table, $sort, $dir);
		if(!$r){
			$sqml->setErro('ET');
			break;
		}
		$i = 0;
		foreach ($r as $k => $v) {
			$i++;
			$r[$k]['action'] = base64_encode("<input type='hidden' name='select_row_{$i}' id='row_pks_{$i}' data-pk='".join(',', $sqlm->getPrimaryKeys($table))."' data-pkvalues='".join(',', $sqlm->getPrimaryKeyValues($table, $v))."' class='tupla_select'><span class='glyphicon glyphicon-edit editarTupla' id='editar_{$table}_{$r[$k][0]}' data-row='{$i}' data-id='{$r[$k][0]}'></span><span class='glyphicon glyphicon-remove removerTupla' id='deletar_{$table}_{$r[$k][0]}' data-row='{$i}' data-id='{$r[$k][0]}'></span>");
		}
		$columns = array(array('mData' => 'action', 'sTitle' => 'Ação', 'sClass' => 'actionColumn'));
		foreach ($sqlm->getColumns($table) as $k => $v){
			if($v['Field'] == $sort){
				if($dir)
					$dirclass = $dir=='asc'?'desc':'asc';
				else
					$dirclass = 'desc';
			}else
				$dirclass = 'desc';
			array_push($columns, array('mData' => $v['Field'], 'sTitle' => $sqlm->renameColumns($v['Field']), 'sClass' => 'sortCustomColumn '.$v['Field'].' '.$dirclass));
		}
		$sqlm->setJSON(array('aoColumns' => $columns, 'aaData' => $r));
		break;
	case 'TableSearch':
		$columns = $sqlm->getColumns($table);
		$html = '<div class="sqlSearchForm"><h3>Pesquisar em '.$table.'</h3><form id="sqlSearchForm">';
		foreach($columns as $k => $v){
			$compares = $sqlm->getComparesFields($sqlm->getCompares($sqlm->getColumnType($v['Type'])));
			$html .= '<div class="form-input form-group"><label for="'.$v['Field'].'Value" class="col-sm-3 control-label">'.$sqlm->renameColumns($v['Field']).'</label><div class="col-sm-2"><select name="'.$v['Field'].'Compare" class="form-control" id="'.$v['Field'].'Compare"><option value="0">Selecione</option>';
			foreach ($compares as $key => $val)
				$html .= '<option value="'.$val.'">'.$key.'</option>';
			$html .= '</select></div><div class="col-sm-7"><input type="text" name="'.$v['Field'].'" class="form-control" id="'.$v['Field'].'"></div></div>';
		}
		$html .= '<div class="form-submit form-group pull-right"><input type="submit" name="envir" value="Pesquisar" class="btn btn-primary"></div></form></div><div class="sqlSearchResult"><table id="searchTable" class="table"><thead></thead><tbody></tbody></table></div>';
		$sqlm->setJSON(base64_encode(utf8_decode($html)));
		break;
	case 'TableInsert':
		$columns = $sqlm->getColumns($table);
		$html = '<div class="sqlInsertForm"><h3>Inserir/Editar em '.$table.'</h3><form id="sqlInsertEditForm"><div class="baseForm">';
		foreach ($columns as $k => $v) {
			$type = $sqlm->getColumnTypeRenamed($v['Type']);
			$limit = $sqlm->getColumnTypeLimit($v['Type']);
			$maxlength = $sqlm->getColumnLength($v['Type']);
			$maxlength = is_array($maxlength)?$maxlength[0]+$maxlength[1]+1:$maxlength;
			$html .= '<div class="form-input form-group"><label for="'.$v['Field'].'Value" class="col-sm-3 control-label">'.$sqlm->renameColumns($v['Field']).'</label><div class="col-sm-3">'.$type.', '.$limit.'</div><div class="col-sm-6"><input name="'.$v['Field'].'Value" class="form-control" data-pk="'.($v['Key']=='PRI'?1:0).'" maxlength="'.$maxlength.'" id="'.$v['Field'].'" type="text"></div></div>';
		}
		$html .= '<input type="hidden" id="formType" value="Insert"><input type="hidden" id="updatePks" value=""><input type="hidden" id="updatePksValue" value=""><div class="form-submit form-group pull-right"><input type="button" value="Cancelar" id="cancelarUpdate" class="btn btn-primary hide"><input type="submit" value="Inserir" class="btn btn-primary"></div></div></form></div>';
		$sqlm->setJSON(base64_encode(utf8_decode($html)));
		break;
	case 'Select':
		$distinct = isset($distinct)?$distinct:false;
		$conditions = array();
		$attributeList = explode(',', $attributes);
		$attributeCompare = explode(',', $compares);
		$attributeCompareValue = explode(',', $values);
		$length = 0;
		foreach ($attributeCompare as $k => $v) {
			if($v != '0')
				$length++;
		}
		foreach ($attributeList as $k => $v) {
			$continue = ($k < $length-1)?'AND ':'';
			if($attributeCompare[$k]!='0')
				array_push($conditions, array('att' => $v, 'compare' => $attributeCompare[$k], 'value' => '"'.$attributeCompareValue[$k].'"', 'continue' => $continue));
		}
		$sqlm->setGeneratorParams($queryType, array($table), $attributeList, $conditions, false, false, false, $distinct);
		$sql = $sqlm->generateSql();
		$r = $sqlm->executeSql();
		$i = 0;
		foreach ($r as $k => $v) {
			$i++;
			$r[$k]['action'] = base64_encode("<input type='hidden' name='select_row_{$i}' id='row_pks_{$i}' data-pk='".join(',', $sqlm->getPrimaryKeys($table))."' data-pkvalues='".join(',', $sqlm->getPrimaryKeyValues($table, $v))."' class='tupla_select'><span class='glyphicon glyphicon-edit editarTupla' id='editar_{$table}_{$r[$k][0]}' data-row='{$i}' data-id='{$r[$k][0]}'></span><span class='glyphicon glyphicon-remove removerTupla' id='deletar_{$table}_{$r[$k][0]}' data-row='{$i}' data-id='{$r[$k][0]}'></span>");
		}
		$columns = array(array('mData' => 'action', 'sTitle' => 'Ação', 'sClass' => 'actionColumn'));
		foreach ($sqlm->getColumns($table) as $k => $v){
			array_push($columns, array('mData' => $v['Field'], 'sTitle' => $sqlm->renameColumns($v['Field']), 'sClass' => 'sortCustomColumn '.$v['Field']));
		}
		$sqlm->setJSON(array('aoColumns' => $columns, 'aaData' => $r));
		break;
	case 'Insert':
		$attributeList = explode(',', $attributes);
		$attributeValues = explode(',', $values);
		$attributeSql = array('att_names' => $attributeList, 'att_values' => $attributeValues);
		$sqlm->setGeneratorParams($queryType, array($table), $attributeSql);
		$sql = $sqlm->generateSql();
		$r = $sqlm->executeSql();
		$sqlm->setJSON(array('result' => $r, 'sql' => $sql));
		break;
	case 'Update':
		$attributeList = explode(',', $attributes);
		$attributeValues = explode(',', $values);
		$attributeSql = array('att_names' => $attributeList, 'att_values' => $attributeValues);
		if(!strpos($pks, ',')){
			$conditions = array(array('att' => $pks, 'compare' => '=', 'value' => $pkValues, 'continue' => ''));			
		}else{
			$pkArray = explode(',', $pks);
			$pkValues = explode(',', $pkvalues);
			$conditions = array();
			$length = count($pkArray);
			foreach ($pkArray as $k => $v) {	
				$continue = ($k < ($length-1))?'AND ':'';
				array_push($conditions, array('att' => $v, 'compare' => '=', 'value' => $pkValues[$k], 'continue' => $continue));
			}				
		}
		$sqlm->setGeneratorParams($queryType, array($table), $attributeSql, $conditions);
		$sql = $sqlm->generateSql();
		$sqlm->executeSql();
		$sqlm->setJSON($sql);
		break;
	case 'Delete':
		$deletes = array();
		if(!strpos($pks, ';')){
			if(!strpos($pks, ',')){
				$conditions = array(array('att' => $pks, 'compare' => '=', 'value' => $pkvalues, 'continue' => ''));
			}else{
				$pkAtributtes = explode(',', $pks);
				$pkValues = explode(',', $pkvalues);
				$conditions = array();
				$length = count($pkAtributtes);
				foreach ($pkAtributtes as $k => $v) {
					$continue = ($k < ($length-1))?'AND ':'';
					array_push($conditions, array('att' => $v, 'compare' => '=', 'value' => $pkValues[$k], 'continue' => $continue));
				}
			}
			$sqlm->setGeneratorParams($queryType, array($table), false, $conditions);
			$sql = $sqlm->generateSql();
			$sqlm->executeSql();
			array_push($deletes, $sql);
		}else{
			$pkArray = explode(';', $pks);
			$pkVArray = explode(';', $pkvalues);
			foreach ($pkArray as $key => $val) {
				if(!strpos($val, ',')){
					$conditions = array(array('att' => $val, 'compare' => '=', 'value' => $pkVArray[$k], 'continue' => ''));
				}else{
					$pkAtributtes = explode(',', $val);
					$pkValues = explode(',', $pkVArray[$key]);
					$conditions = array();
					$length = count($pkAtributtes);
					foreach ($pkAtributtes as $k => $v) {
						$continue = ($k < ($length-1))?'AND ':'';
						array_push($conditions, array('att' => $v, 'compare' => '=', 'value' => $pkValues[$k], 'continue' => $continue));
					}
				}
				$sqlm->setGeneratorParams($queryType, array($table), false, $conditions);
				$sql = $sqlm->generateSql();
				$sqlm->executeSql();
				array_push($deletes, $sql);
			}
		}
		$sqlm->setJSON($deletes);
		break;
	default:
		$sqlm->setErro('RI');
		break;
}

$sqlm->printJSON();