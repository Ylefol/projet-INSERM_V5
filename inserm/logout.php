<!DOCTYPE html >
<html lang="fr">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="css/style_fac.css" />
</head>

<body>

<div class="header">
	<table align="center">
		<tr>
			<td><a href="http://www.cellomet.com"> <img style="width: 233px" src="images/logo_app.svg"></a></td>
			<td><label id="p02">Non-Canonic </label></td> <td><label id="p01"> Identification</label> </td>
		<form>
			<button title="Only for database administration" class="buttonBack" type="button" onclick=self.location="./cellomap.php"><span>Back</span></button>
		</form>		
		</tr>
	</table>
</div>

<?php
	session_start();
	session_destroy();
?>

<p align="center">You have been disconnected !</p>

<form style="text-align: center">
	<button class="suppr" type="button" onclick=self.location="./cellomap.php"><span>Back</span></button>
</form>	

</br></br>