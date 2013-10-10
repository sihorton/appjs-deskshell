<!DOCTYPE html>
<html>
	<head>
		<title>PHP demo</title>
	</head>
	
	<body>
		<center><h2>Desktop app with PHP - Deskshell makes it possible!</h2></center>
		<p>
			URI: <?=$_SERVER['SCRIPT_URL']?><br/>
			Details:
			<?php $details = array(
				"PHP Version"=>phpversion(),
			); ?>
			<ul>
			<?php foreach($details as $dk => $dv) { ?>
			<li><b><?=$dk?>:</b> <?=$dv?></li>
			<?php } ?>
			</ul>

			_SERVER:
			<ul>
			<?php foreach($_SERVER as $dk => $dv) { ?>
			<li><b><?=$dk?>:</b> <?=$dv?></li>
			<?php } ?>
			</ul>

			<script>
				console.log("Meep o.o");
			</script>
			<input type="button" value="Reload Page (and watch terminal if open)" onClick="window.location.reload()">
		</p>
	</body>
</html>