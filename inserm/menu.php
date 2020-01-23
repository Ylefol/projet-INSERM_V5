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

<p align="center">Main menu</p>

<?php
	session_start();
	if(!empty($_SESSION['User']) && $_SESSION['User']=="Cellomet")
	{	
?>

</br>

<form style="text-align: center">
	<table style="margin: auto">
		<tr>
			<td><button class="add" style="width: 250px" type="button" onclick=self.location="./addgene.php"><span>Add gene</span></button></td>
			<td><button class="suppr" style="width: 250px" type="button" onclick=self.location="./ncan.php"><span>Delete non-canonical</span></button></td>
			<td><button class="modif" style="width: 250px" type="button" onclick=self.location="./modifGene.php"><span>Modify gene</span></button></td>
		</tr>
		<tr>
			<td><button class="add" style="width: 250px" type="button" onclick=self.location="./ref.php"><span>Add reference</span></button></td>
			<td><button class="suppr" style="width: 250px" type="button" onclick=self.location="./supprRef.php"><span>Delete reference</span></button></td>
		</tr>
	</table>

	<button class="ref" style="width: 522px" type="button" onclick=self.location="./stats.php"><span>View stats</span></button>
</form>

</br></br></br>

<form style="text-align: center">
	<button class="deco" type="button" onclick=self.location="./logout.php"><span>Disconnect</span></button>
</form>
<?php
	}
	else
	{
		echo "<p style='text-align:center'><a href=modif.php> You are not connected, please come back to login page ! </a></p>";
	}
?>

</body>

</html>