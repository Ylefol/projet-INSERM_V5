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
	{	?>

		<p align="center">Modify a gene</p>

<?php
		require_once("connexion.php");

  			try 
  			{
  				$maConnexion = new PDO($dns, $user, $mdp);

 				$stmt = $maConnexion->prepare('SELECT * FROM canonic WHERE num_can=:id'); 
 				$stmt->bindParam(':id',$id);

 				$id = $_POST['idModif'];

	 			$stmt->execute();

	 			$res = $stmt->fetch();
 ?>

				<form action=modifGene.php method=post>
					<input type="hidden" name="lineModif" value="<?php echo $id; ?>">
					<table align="center">
						<tr>
							<td>
								<label for="gs">Gene Symbol : </label>
							</td>
							<td>
								<input type="text" id="gs" name="gs" value="<?php echo $res['Gene_Symbol']; ?>" required/>
							</td>
						</tr>

						<tr>
							<td>
								<label for="gn">Gene Name : </label>
							</td>
							<td>
								<input type="text" id="gn" name="gn" value="<?php echo $res['Gene_Name']; ?>"  required/>
							</td>
						</tr>

						<tr>
							<td>
								<label for="cp">Canonical Pathway : </label>
							</td>
							<td>
								<textarea style="width:90%" id="cp" name="cp" rows="6" cols="45" required><?php echo $res['C_Pathway'];?></textarea>
							</td>
						</tr>

						<tr>
							<td>
								<label for="cl">Canonical Location : </label>
							</td>
							<td>
								<input type="text" id="cl" name="cl" value="<?php echo $res['C_Loc']; ?>" required/>
							</td>
						</tr>

						<tr>
							<td>
								<label for="cc">Canonical Category : </label>
							</td>
							<td>
								<textarea style="width:90%" id="cc" name="cc" rows="6" cols="45" required><?php echo $res['C_category'];?></textarea>
							</td>
						</tr>

						<tr>
							<td></td>
							<td>
								<button class="modif" type="submit"><span>Modify</span></button>
							</td>
						</tr>
					</table>
				</form>


 <?php

 			}
  			catch (PDOException $e) 
			{
	 			print "Erreur de connexion à la base de donnée : " . $e->getMessage();
	 			die();
			}

			$maConnexion = null;
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