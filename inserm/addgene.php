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
			<button title="Only for database administration" class="buttonBack" type="button" onclick=self.location="./menu.php"><span>Back</span></button>
		</form>		
		</tr>
	</table>
</div>

<?php
	session_start();
	if(!empty($_SESSION['User']) && $_SESSION['User']=="Cellomet")
	{
?>

<p align="center">Add a gene</p>

<?php
 	require_once("connexion.php");

  	try 
  	{
 		$maConnexion = new PDO($dns, $user, $mdp);

 		$reponse = $maConnexion->query("SELECT 'Select a gene' as Gene_Symbol, 1 as rank UNION (SELECT DISTINCT Gene_Symbol, 2 as rank FROM canonic) ORDER BY rank,Gene_Symbol");

?>

<form action=ref.php method=post>
	<table align="center" style="text-align: left">
		<tr>
			<td id="gs"><label for="login" >Gene Symbol : </label></td>
			<td id="gss">
				<select class="select-css" name="slcGs">
					<?php
						while ($donnees = $reponse->fetch())
							{
								echo '<option value="' . $donnees['Gene_Symbol'] . '">' . $donnees['Gene_Symbol'] . '</option>';
							}
					}
					catch (PDOException $e) 
					{
						print "Erreur de connexion à la base de donnée : " .$e->getMessage();
						die();
					}
					?>
				</select>
			</td>
			<td><label for="autre">New gene</label><input type="checkbox" onclick="cacher(this)" id="autre" name="autre"/></td>		
		</tr>

		<tr id="gsc" style="visibility: collapse;">		
			<td><label for="GeneSymbolCanonic">Gene Symbol : </label></td>
			<td><input type="text" id="GeneSymbolCanonic" name="GeneSymbolCanonic" placeholder="Gene Symbol" /></td>
		</tr>

		<tr id="gn" style="visibility: collapse;">		
			<td><label for="geneName">Gene Name : </label></td>
			<td><input type="text" id="geneName" name="geneName" placeholder="Gene Name" /></td>
		</tr>

		<tr id="dc" style="visibility: collapse;">		
			<td><label for="geneDescri">Canonical Description : </label></td>
			<td><textarea style="width:90%" id="geneDescri" name="geneDescri" rows="6" cols="45" placeholder="Write the description of the canonical pathway here..." ></textarea></td>
		</tr>

		<tr id="pw" style="visibility: collapse;">
			<td><label for="cpw">Canonical Pathway : </label></td>
			<td><input type="text" id="cpw" name="cpw" placeholder="Pathway" /></td>
		</tr>

		<tr id="lc" style="visibility: collapse;">		
			<td><label for="geneLoc">Canonical Location : </label></td>
			<td><input type="text" id="geneLoc" name="geneLoc" placeholder="Gene location (canonical)" /></td>
		</tr>

		<tr>
			<td><label for="NonGeneDescri">Non-Canonical Description : </label></td>
			<td><textarea style="width:90%" id="NonGeneDescri" name="NonGeneDescri" rows="6" cols="45" placeholder="Write the description of the non-canonical pathway here..." required></textarea></td>
		</tr>

		<tr>		
			<td><label for="NonGeneLoc">Non Canonical Location : </label></td>
			<td><input type="text" id="NonGeneLoc" name="NonGeneLoc" placeholder="Gene location (non canonical)" required/></td>
		</tr>

		<tr>
			<td></td>
			<td>
				<button class="add" type="submit"><span>Submit</span></button>
			</td>
		</tr>
	</table>
	

</form>

<?php
	}
	else
	{
		echo "<p style='text-align:center'><a href=modif.php> You are not connected, please come back to login page ! </a></p>";
		$maConnexion = null;
	}
?>


<script type="text/javascript">

function cacher(ckCache){
	if(ckCache.checked)
	{
		document.getElementById("gn").style.visibility='initial';
		document.getElementById("dc").style.visibility='initial';
		document.getElementById("lc").style.visibility='initial';
		document.getElementById("gsc").style.visibility='initial';
		document.getElementById("pw").style.visibility='initial';
		document.getElementById("gs").style.visibility='collapse';
		document.getElementById("gss").style.visibility='collapse';
  	}
 	else
 	{
 		document.getElementById("gn").style.visibility='collapse';
 		document.getElementById("dc").style.visibility='collapse';
 		document.getElementById("lc").style.visibility='collapse';
 		document.getElementById("gsc").style.visibility='collapse';
 		document.getElementById("pw").style.visibility='collapse';
 		document.getElementById("gs").style.visibility='initial';
 		document.getElementById("gss").style.visibility='initial';

 		document.getElementById("geneName").value = '';
 		document.getElementById("geneDescri").value = '';
 		document.getElementById("geneLoc").value = '';
 		document.getElementById("GeneSymbolCanonic").value = '';
 		document.getElementById("cpw").value = '';
  	}

  	document.getElementById("autre").addEventListener('change', function(){
    document.getElementById("geneName").required = this.checked ;
    document.getElementById("geneDescri").required = this.checked ;
    document.getElementById("geneLoc").required = this.checked ;
    document.getElementById("GeneSymbolCanonic").required = this.checked ;
    document.getElementById("cpw").required = this.checked ;
})
}

</script>

</body>
</html>