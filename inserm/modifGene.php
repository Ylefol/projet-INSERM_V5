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
		if(!empty($_POST['gs']) && !empty($_POST['gn']) && !empty($_POST['cp']) && !empty($_POST['cl']) && !empty($_POST['cc']))
		{

			require_once("connexion.php");

  			try 
  			{
				$maConnexion = new PDO($dns, $user, $mdp);

		 		$stmt = $maConnexion->prepare('
		 			UPDATE canonic 
		 			SET Gene_Symbol = :gs,
		 				Gene_Name = :gn,
		 				C_Pathway = :cp,
		 				C_Loc = :cl,
		 				C_category = :cc
		 			WHERE num_can = :id');
		 		$stmt->execute(array(
		 			'gs' => $_POST['gs'],
		 			'gn' => $_POST['gn'],
		 			'cp' => $_POST['cp'],
		 			'cl' => $_POST['cl'],
		 			'cc' => $_POST['cc'],
		 			'id' => $_POST['lineModif']
		 		));
		 	}
		 	catch (PDOException $e) 
			{
	 			print "Erreur de connexion à la base de donnée : " . $e->getMessage();
	 			die();
			}

			$maConnexion = null;

			echo "<p align='center'>Gene modified successfully !</p>";
		}
		?>
			<p align="center">Modify a gene</p>	
			</br></br>
			<table class="res" id="stats">
				<tr style="background-color: #DE8125">
		    		<th>Gene Symbol</th>
		    		<th>Gene Name</th>
		    		<th>Canonical Pathway</th>
		    		<th>Canonical Location</th>
		    		<th>Canonical Category</th>
		    		<th>Modify</th>
				</tr>

			<?php
			require_once("connexion.php");

  			try 
  			{
  				$maConnexion = new PDO($dns, $user, $mdp);

 				$reponse = $maConnexion->query('SELECT * FROM canonic');

 				while ($donnees = $reponse->fetch())
			{
				echo '<tr>';
				echo '<td>'; echo $donnees['Gene_Symbol']; echo '</td>';
				echo '<td>'; echo $donnees['Gene_Name']; echo '</td>';
				echo '<td>'; echo $donnees['C_Pathway']; echo '</td>';
				echo '<td>'; echo $donnees['C_Loc']; echo '</td>';
				echo '<td>'; echo $donnees['C_category']; echo '</td>';
				$id = $donnees['num_can'];
				echo '<form action=modifGeneForm.php method=post><input type="hidden" name="idModif" value="' . $id . '"><td>'; 
				echo '<button class="modif" type="submit"
				><span>Modify</span></button>'; echo '</td></form>';
				echo '</tr>';
			}

 				$reponse = null;
  			}
  			catch (PDOException $e) 
			{
	 			print "Erreur de connexion à la base de donnée : " .$e->getMessage();
	 			die();
			}

			$maConnexion = null; 
		}
	else
	{
		echo "<p style='text-align:center'><a href=modif.php> You are not connected, please come back to login page ! </a></p>";
	}
?>


</body>
</html>