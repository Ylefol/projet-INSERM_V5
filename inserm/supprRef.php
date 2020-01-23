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
	require_once("connexion.php");
	
	if(isset($_POST['idSuppr'])) {

		try 
	  	{
			$maSuppression = new PDO($dns, $user, $mdp);

	 		$stmt = $maSuppression->prepare('DELETE FROM refs WHERE id_ref = :idRef');
	 		$stmt->bindParam(':idRef',$idRef);

	 		$idRef = $_POST['idSuppr'];

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

<p align="center">Delete a reference</p>

<?php
	require_once("connexion.php");
	session_start();
	if(!empty($_SESSION['User']) && $_SESSION['User']=="Cellomet")
	{	
 		require_once("connexion.php");

	  	try 
	  	{
	 		$maConnexion = new PDO($dns, $user, $mdp);

	 		$reponse = $maConnexion->query("SELECT 'Select a gene' as Gene_Symbol, 1 as rank UNION (SELECT DISTINCT Gene_Symbol, 2 as rank FROM canonic) ORDER BY rank,Gene_Symbol");

?>

<form action=supprRef.php method=post>
	<table align="center" style="text-align: left">
		<tr>
			<td id="gs"><label for="login">Gene Symbol</label></td>
					<td id="gss">
						<select class="select-css" name="slcGs" style="width: 200px">
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
			<td><button class="add" type="submit"><span>Search</span></button></td>
		</tr>
	</table>
</form>


<?php
	if(!empty($_POST['slcGs']))
	{ ?>

	<table class="res">
		<tr style="background-color: #DE8125">
			<th>Gene Symbol</th>
    		<th>Reference</th>
    		<th>Suppression</th>
		</tr>

	<?php
		require_once("connexion.php");

	  	try 
	  	{
	 		$maConnexion = new PDO($dns, $user, $mdp);

	 		$stmt = $maConnexion->prepare('SELECT * FROM refs WHERE Gene_Symbol=:gs');
	 		$stmt->execute(array(
	 			'gs' => $_POST['slcGs']
	 		));

	 		while ($donnees = $stmt->fetch())
				{	
					echo "<tr>";
					echo "<td>" . $donnees['Gene_Symbol'] . "</td>";
					echo "<td>" . $donnees['ref'] . "</td>";
					$id = $donnees['id_ref'];
					echo '<form action=supprRef.php method=post><input type="hidden" name="idSuppr" value="' . $id . '"><td>'; 
					echo '<button class="suppr" type="submit" style="width:300px"
					><span>Delete</span></button>'; echo '</td></form>';
					echo "</tr>";
				}

			$maConnexion = null;
		}
	 	catch (PDOException $e)
		{
			print "Erreur de connexion à la base de donnée : " . $e->getMessage();
			die();
		}
		?></table><?php
	}
?>



<?php
	}
	else
	{
		echo "<p style='text-align:center'><a href=modif.php> You are not connected, please come back to login page ! </a></p>";
	}
?>

</body>
</html>