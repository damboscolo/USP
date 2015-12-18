<!DOCTYPE html>
	<head>

		<title>Projeto Banco De Dados Parte 3 - Implementaçao</title>

		<meta charset="UTF-8">
		<meta name="description" content="Interface gráfica para o projeto de banco de dados">
		<meta name="keywords" content="usp, banco de dados, bd, projeto, trabalho, projeto banco de dados">
		<meta name="Robots" content="INDEX,FOLLOW">
		<meta name="googlebot" content="FOLLOW,INDEX">
		<meta name="author" content="Eduardo Ciciliato, Daniele Boscolo, Hiero Martinelli, Matheus Pusinhol">
		<meta name="langague" content="pt-BR">
		<meta name="distribution" content="global">
		<meta name="rating" content="general">

		<!-- Latest compiled and minified Bootstrap CSS -->
		<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.2/css/bootstrap.min.css">

		<!-- Optional Bootstrap theme -->
		<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.2/css/bootstrap-theme.min.css">

		<!-- DataTables Integration with Bootstrap -->
		<link rel="stylesheet" href="css/dataTables.bootstrap.css">

		<!-- Main CSS -->
		<link rel="stylesheet" href="css/index.css">
		
		<!-- Lateste compiled Jquery Javascript -->
		<script src="//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>

		<!-- Latest compiled and minified JavaScript Bootstrap -->
		<script src="//netdna.bootstrapcdn.com/bootstrap/3.0.2/js/bootstrap.min.js"></script>
		 
		<!-- DataTables -->
		<script type="text/javascript" charset="utf8" src="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.4/jquery.dataTables.min.js"></script>

		<!-- DataTables Integration with Bootstrap Script -->
		<script type="text/javascript" src="js/dataTables.bootstrap.js"></script>

		<!-- Main Script -->
		<script type="text/javascript" src="js/index.js"></script>

	</head>
	<body>
		<header>
			<h2>Projeto Banco de Dados</h2>
		</header>
		<section>
			<div class="row main">
				<div class="col-md-3 menu-tabelas">
					<ul class="nav nav-pills nav-stacked" id="menuTabelas">
						<li id="menuGeral" class="active"><a href="#" data-table="Geral">Visão Geral</a></li>
					</ul>
				</div>
				<div class="col-md-9" id="conteudo">
					<div class="alertas"></div>
					<div class="principal"></div>
				</div>
			</div>
		</section>
	</body>
</html>