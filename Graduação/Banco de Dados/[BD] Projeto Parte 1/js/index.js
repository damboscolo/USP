$(function(){
	$.ajaxSetup({cache:true, timeout:7000, type:'GET', dataType:'json'});
	$.ajax({url:'/projeto_bd/api/TableCountRows.json', success:getAllTables});
})

function getAllTables(data){
	if(data.Estado == 'OK'){
		for(i in data.resultado){
			$('#menuTabelas').append('<li id="menu'+i+'"><a href="#" data-table="'+i+'">'+i+'<span class="badge pull-right" id="countRows'+i+'">'+data.resultado[i]+'</span></a></li>');
		}
		$('#menuTabelas li').delegate('a', 'click', function(){menuAction($(this).data('table'));});
	}
}

function menuAction(menu){
	$('.nav-pills li').removeClass('active');
	$('#menu'+menu).addClass('active');
	if(menu != 'Geral'){
		$('#conteudo .principal').html('<ul class="nav nav-tabs" id="menuTab"><li class="active"><a href="#sqlTableVisualize" data-toggle="tab"><span class="glyphicon glyphicon-list-alt"></span> Visualizar</a></li><li><a href="#sqlSelectForm" data-toggle="tab"><span class="glyphicon glyphicon-search"></span> Pesquisar</a></li><li><a href="#sqlInsertForm" data-toggle="tab"><span class="glyphicon glyphicon-import"></span> Inserir / <span class="glyphicon glyphicon-edit"></span> Editar</a></li></ul><div class="tab-content" id="conteudo_tab"><div class="tab-pane active" id="sqlTableVisualize"><table id="mainTable" data-menu="'+menu+'" class="table"><thead></thead><tbody></tbody></table></div><div class="tab-pane" id="sqlSelectForm"></div><div class="tab-pane" id="sqlInsertForm"></div></div>');
		$.ajax({url:'/projeto_bd/api/TableVisualize.json', data:{table:menu}, success:menuVisualize});
		$.ajax({url:'/projeto_bd/api/TableSearch.json', data:{table:menu}, success:menuSearch});
		$.ajax({url:'/projeto_bd/api/TableInsert.json', data:{table:menu}, success:menuInsert});
	}
}

function menuVisualize(data){
	console.log(data);
	var i, j;
	for(i in data.resultado.aaData){
		data.resultado.aaData[i]['action'] = window.atob(data.resultado.aaData[i]['action']);
	}
	var table = $('#mainTable').dataTable({
		"bProcessing" : true,
		"aaData" : data.resultado.aaData,
		"aoColumns" : data.resultado.aoColumns,
		"oLanguage" : { "sUrl" : '/projeto_bd/js/dataTables.portugues.txt'},
		"bPaginate": false,
		"bLengthChange": false,
		"bFilter": true,
		"bSort": false,
		"bInfo": false,
		"bAutoWidth": false,
		"fnInitComplete": function(oSettings, json) {
			console.log(0);
			$('#mainTable .sorting_disabled').bind('click', function(){console.log(1);sortTable(table, getColTable($(this).attr('class')), getDirTable($(this).attr('class')))});
			$('#mainTable .sorting_disabled.desc').each(function(i){
				$(this).append('&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-up"></span>');
			});
			$('#mainTable .sorting_disabled.asc').each(function(i){
				$(this).append('&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-down"></span>');
			});
			$('#mainTable tr').click(function(){
				$(this).toggleClass('rowSelected');
			});
			$('#mainTable .editarTupla').click(function(){
				var row = $(this).data('row'), pk, pkvalues;
				pk = $('#mainTable #row_pks_'+row).data('pk');
				pkvalues = $('#mainTable #row_pks_'+row).data('pkvalues');
				$('#formType').val('Update');
				$('#sqlInsertEditForm input[type=submit]').val('Atualizar');
				$('#updatePks').val(pk);
				$('#updatePksValue').val(pkvalues);
				$('#sqlInsertEditForm input[type=text]').each(function(i){
					var id = $(this).attr('id');
					$(this).val($('#mainTable tbody tr:eq('+(row-1)+') td.'+id).html());
				});
				$('#cancelarUpdate').removeClass('hide');
				$('#cancelarUpdate').click(function(){
					$('#formType').val('Insert');
					$('#updatePks').val('');
					$('#updatePksValue').val('');
					$('#sqlInsertEditForm input[type=text]').each(function(i){
						$(this).val('');
					});
					$(this).addClass('hide');
					$('#sqlInsertEditForm input[type=submit]').val('Inserir');
					$('#menuTab a:first').tab('show');
				})
				$('#menuTab a:last').tab('show');
				$(this).closest('tr').toggleClass('rowSelected');
			});
			$('#mainTable .removerTupla').click(function(){
				var row = $(this).data('row'), pk, pkvalues;
				pk = $('#mainTable #row_pks_'+row).data('pk');
				pkvalues = $('#mainTable #row_pks_'+row).data('pkvalues');
				$(this).closest('tr').toggleClass('rowSelected');
				$.ajax({url:'/projeto_bd/api/Delete.json', type:'POST', data:{table:$('#mainTable').data('menu'), pks:pk, pkvalues:pkvalues}, success:deleteResult});
			});
    	}
	});
}

function sortTable(table, col, dir){
	console.log(col);
	console.log(dir);
	table.fnDestroy();
	$('.sortCustomColumn').removeClass('asc').removeClass('desc');
	$('#mainTable .sortCustomColumn').unbind('bind');
	$.ajax({url:'/projeto_bd/api/TableVisualize.json', data:{table:$('#mainTable').data('menu'), sort:col, dir:dir}, success:menuVisualize});
}

function getColTable(cl){
	var col = cl.split(' ');
	for(i in col){
		if(col[i] != 'sortCustomColumn' && col[i] != 'sorting_disabled' && col[i] != 'desc' && col[i] != 'asc')
			return col[i];
	}
}

function getDirTable(cl){
	var dir = cl.split(' ');
	for(i in dir){
		if(dir[i] == 'desc' || dir[i] == 'asc')
			return dir[i];
	}
}

function menuSearch(data){
	var conteudo;
	if(data.Estado == 'OK'){
		conteudo = window.atob(data.resultado);
	}else{
		conteudo = data.Erro;
	}
	$('#sqlSelectForm').html(conteudo);
	$('#sqlSearchForm').submit(function(e){
		var attributes = [], values = [], compares = [];
		var attributte, value, compare, table;
		$('#sqlSearchForm input[type=text]').each(function(i){
			var val = $(this).val();
			attributes.push($(this).attr('id'));
			values.push(val);
		});
		$('#sqlSearchForm option:selected').each(function(i){
			compares.push($(this).val());
		});
		attribute = attributes.join(',');
		value = values.join(',');
		compare = compares.join(',');
		table = $('#mainTable').data('menu');
		$.ajax({url: '/projeto_bd/api/Select.json', type:'POST', data:{table:table, attributes:attribute, compares:compare, values:value}, success:selectResult});
		e.preventDefault();
	});
}

function menuInsert(data){
	var conteudo;
	if(data.Estado == 'OK'){
		conteudo = window.atob(data.resultado);
	}else{
		conteudo = data.Erro;
	}
	$('#sqlInsertForm').html(conteudo);
	$('#sqlInsertEditForm').submit(function(e){
		var attributes = [], values = [];
		var attributte, value, table, type;
		$('#sqlInsertEditForm input[type=text]').each(function(i){
			var val = $(this).val();
			attributes.push($(this).attr('id'));
			values.push(val);
		});
		attribute = attributes.join(',');
		value = values.join(',');
		table = $('#mainTable').data('menu');
		type = $('#formType').val();
		if(type == 'Insert')
			$.ajax({url: '/projeto_bd/api/Insert.json', type:'POST', data:{table:table, attributes:attribute, values:value}, success:insertResult});
		else{
			var pks = $('#updatePks').val();
			var pkValues = $('#updatePksValue').val();
			$.ajax({url: '/projeto_bd/api/Update.json', type:'POST', data:{table:table, attributes:attribute, values:value, pks:pks, pkValues:pkValues}, success:updateResult});
		}
		e.preventDefault();
	});
}

function selectResult(data){
	var i, j;
	for(i in data.resultado.aaData){
		data.resultado.aaData[i]['action'] = window.atob(data.resultado.aaData[i]['action']);
	}
	var tableSelect = $('#searchTable').dataTable({
		"bProcessing" : true,
		"aaData" : data.resultado.aaData,
		"aoColumns" : data.resultado.aoColumns,
		"oLanguage" : { "sUrl" : '/projeto_bd/js/dataTables.portugues.txt'},
		"bPaginate": false,
		"bLengthChange": false,
		"bFilter": true,
		"bInfo": false,
		"bAutoWidth": false,
		"fnInitComplete": function(oSettings, json) {
			$('#searchTable .editarTupla').click(function(){
				var row = $(this).data('row'), pk, pkvalues;
				pk = $('#searchTable #row_pks_'+row).data('pk');
				pkvalues = $('#searchTable #row_pks_'+row).data('pkvalues');
				$('#formType').val('Update');
				$('#sqlInsertEditForm input[type=submit]').val('Atualizar');
				$('#updatePks').val(pk);
				$('#updatePksValue').val(pkvalues);
				$('#sqlInsertEditForm input[type=text]').each(function(i){
					var id = $(this).attr('id');
					$(this).val($('#mainTable tbody tr:eq('+(row-1)+') td.'+id).html());
				});
				$('#cancelarUpdate').removeClass('hide');
				$('#cancelarUpdate').click(function(){
					$('#formType').val('Insert');
					$('#updatePks').val('');
					$('#updatePksValue').val('');
					$('#sqlInsertEditForm input[type=text]').each(function(i){
						$(this).val('');
					});
					$(this).addClass('hide');
					$('#sqlInsertEditForm input[type=submit]').val('Inserir');
					$('#menuTab a:first').tab('show');
				})
				$('#menuTab a:last').tab('show');
				$(this).closest('tr').toggleClass('rowSelected');
			});
			$('#searchTable .removerTupla').click(function(){
				var row = $(this).data('row'), pk, pkvalues;
				pk = $('#searchTable #row_pks_'+row).data('pk');
				pkvalues = $('#searchTable #row_pks_'+row).data('pkvalues');
				$(this).closest('tr').toggleClass('rowSelected');
				$.ajax({url:'/projeto_bd/api/Delete.json', type:'POST', data:{table:$('#mainTable').data('menu'), pks:pk, pkvalues:pkvalues}, success:deleteResult});
			});
    	}
	});
}

function insertResult(data){
	if(data.Estado == 'OK'){
		$('#conteudo .alertas').append('<div class="alert alert-success alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>Tupla inserida com sucesso.</div>');
	}else{
		$('#conteudo .alertas').append('<div class="alert alert-danger alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><strong>Erro:</strong>Tupla nao pode ser inserida.<br>'+data.Erro+'</div>');
	}
	menuAction($('#mainTable').data('menu'));
}

function updateResult(data){
	if(data.Estado == 'OK'){
		$('#conteudo .alertas').append('<div class="alert alert-success alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>Tupla atualizada com sucesso.</div>');
	}else{
		$('#conteudo .alertas').append('<div class="alert alert-danger alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><strong>Erro:</strong>Tupla nao pode ser atualizada.<br>'+data.Erro+'</div>');
	}
	menuAction($('#mainTable').data('menu'));
}

function deleteResult(data){
	if(data.Estado == 'OK'){
		$('#conteudo .alertas').append('<div class="alert alert-success alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>Tupla deletada com sucesso.</div>');		
	}else{
		$('#conteudo .alertas').append('<div class="alert alert-danger alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><strong>Erro:</strong>Tupla nao pode ser deletado.<br>'+data.Erro+'</div>');		
	}
	menuAction($('#mainTable').data('menu'));
}