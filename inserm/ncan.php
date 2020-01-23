<!DOCTYPE html >
<html lang="fr">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="css/style_fac.css" />
</head>

<body>
<?php
	require_once("connexion.php");
	
	if(isset($_POST['idSuppr'])) {

		try 
	  	{
			$maSuppression = new PDO($dns, $user, $mdp);

	 		$stmt = $maSuppression->prepare('DELETE FROM ncanonic WHERE num_ncan = :idDel');
	 		$stmt->bindParam(':idDel',$idDel);

	 		$idDel = $_POST['idSuppr'];

	 		$stmt->execute();
	 	}
	 	catch (PDOException $e)
		{
			print "Erreur de connexion à la base de donnée : " . $e->getMessage();
			die();
		}

		$maSuppression = null;
	}
?>

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

<p align="center">Suppression of non-canonical pathways</p>

<?php
 	require_once("connexion.php");

  	try 
  	{
 		$maConnexion = new PDO($dns, $user, $mdp);

 		$reponse = $maConnexion->query('SELECT * FROM ncanonic ORDER BY Gene_Symbol');

?>

</br></br></br>

<table class="res">
<tr style="background-color: #DE8125">
    <th>Gene Symbol</th>
    <th>Pathway</th>
    <th>Location</th>
    <th>Suppression</th>
</tr>
	<?php
	 		while ($donnees = $reponse->fetch())
			{
				echo '<tr>';
				echo '<td>'; echo $donnees['Gene_Symbol']; echo '</td>';
				echo '<td>'; echo $donnees['NC_Pathway']; echo '</td>';
				echo '<td>'; echo $donnees['NC_Loc']; echo '</td>';
				$id = $donnees['num_ncan'];
				echo '<form action=ncan.php method=post><input type="hidden" name="idSuppr" value="' . $id . '"><td>'; 
				echo '<button class="suppr" type="submit"
				><span>Delete</span></button>'; echo '</td></form>';
				echo '</tr>';
			}

	 		
		}
		catch (PDOException $e) 
		{
	 		print "Erreur de connexion à la base de donnée : " .$e->getMessage();
	 	die();
		}

		$maConnexion = null; 
	?>
</table>

<?php
	}
	else
	{
		echo "<p style='text-align:center'><a href=modif.php> You are not connected, please come back to login page ! </a></p>";
	}
?>

</body>
</html>