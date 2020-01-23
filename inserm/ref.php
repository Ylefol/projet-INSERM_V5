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
	session_start();
	if(!empty($_SESSION['User']) && $_SESSION['User']=="Cellomet")
	{	?> 

	<p style="text-align: center">Add references</p>


<?php
	if(!empty($_POST['refDirect']))
	{
		try 
	  	{
			$monAjout = new PDO($dns, $user, $mdp);

	 		$stmt = $monAjout->prepare('INSERT INTO refs(Gene_Symbol,ref) VALUES(:gene,:refDirect) ');
	 		$stmt->execute(array(
	 			'gene' => $_POST['slcGsRef'],
	 			'refDirect' => $_POST['refDirect']
	 		));

	 		$monAjout = null;
	 	}
	 	catch (PDOException $e)
		{
			print "Erreur de connexion à la base de donnée : " . $e->getMessage();
			die();
		}

		
	}
	elseif(!empty($_POST['refSlt']))
	{
		try 
	  	{
			$monAjout = new PDO($dns, $user, $mdp);

	 		$stmt = $monAjout->prepare('INSERT INTO refs(Gene_Symbol,ref) VALUES(:gene,:refSlt) ');
	 		$stmt->execute(array(
	 			'gene' => $_POST['gs'],
	 			'refSlt' => $_POST['refSlt']
	 		));

	 		$stmtBis = $monAjout->prepare('INSERT INTO ncanonic(Gene_Symbol,NC_Pathway,NC_Loc) VALUES(:gs,:ncpw,:ncloc)');
			$stmtBis->execute(array(
	 			'gs' => $_POST['gs'],
	 			'ncpw' => $_POST['ncpw'],
	 			'ncloc' => $_POST['ncloc']
	 		));

	 		$monAjout = null;
	 	}
	 	catch (PDOException $e)
		{
			print "Erreur de connexion à la base de donnée : " . $e->getMessage();
			die();
		}
	}
	elseif(!empty($_POST['refInput']))
	{
		try 
	  	{
			$monAjout = new PDO($dns, $user, $mdp);

	 		$stmt = $monAjout->prepare('INSERT INTO refs(Gene_Symbol,ref) VALUES(:gene,:refInput) ');
	 		$stmt->execute(array(
	 			'gene' => $_POST['gs'],
	 			'refInput' => $_POST['refInput']
	 		));

	 		$stmtBis = $monAjout->prepare('INSERT INTO ncanonic(Gene_Symbol,NC_Pathway,NC_Loc) VALUES(:gs,:ncpw,:ncloc)');
			$stmtBis->execute(array(
	 			'gs' => $_POST['gs'],
	 			'ncpw' => $_POST['ncpw'],
	 			'ncloc' => $_POST['ncloc']
	 		));

	 		$stmtTer = $monAjout->prepare('INSERT INTO canonic(Gene_Symbol,Gene_Name,C_Pathway,C_Loc,C_category) VALUES(:gs,:gn,:cdescri,:cloc,:canopw)');
	 		$stmtTer->execute(array(
	 			'gs' => $_POST['gs'],
	 			'gn' => $_POST['gn'],
	 			'cdescri' => $_POST['cdescri'],
	 			'cloc' => $_POST['cloc'],
	 			'canopw' => $_POST['canopw']
	 		));

	 		$monAjout = null;
	 	}
	 	catch (PDOException $e)
		{
			print "Erreur de connexion à la base de donnée : " . $e->getMessage();
			die();
		}

		$monAjout = null;
	}
?>

<?php
 	require_once("connexion.php");

  	try 
  	{
 		$maConnexion = new PDO($dns, $user, $mdp);

 		$reponse = $maConnexion->query("SELECT 'Select a gene' as Gene_Symbol, 1 as rank UNION (SELECT DISTINCT Gene_Symbol, 2 as rank FROM canonic) ORDER BY rank,Gene_Symbol");

?>

<?php
	if(empty($_POST['slcGs']) && empty($_POST['GeneSymbolCanonic']) && empty($_POST['geneName']) && empty($_POST['geneDescri']) && empty($_POST['geneLoc']) && empty($_POST['NonGeneDescri']) && empty($_POST['NonGeneLoc']))
	{
		?>

		<form action=ref.php method=post>
			<table align="center" style="text-align: left">
				<tr>
					<td id="gsRef"><label>Gene : </label></td>
					<td id="gssRef">
						<select class="select-css" name="slcGsRef" style="width: 200px">
							<?php
								while ($donnees = $reponse->fetch())
									{
										echo '<option value="' . $donnees['Gene_Symbol'] . '">' . $donnees['Gene_Symbol'] . '</option>';
									}

									$reponse->closeCursor();
							?>
						</select>
					</td>
				</tr>

				<tr>		
					<td><label id="lblRefDirect" for="refDirect">Reference : </label></td>
					<td><textarea style="width:90%" id="refDirect" name="refDirect" rows="6" cols="45" placeholder="Write one reference here..." required></textarea></td>
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
		/*echo "On arrive depuis la page d'ajout de gene </br></br>";

		echo "Gene Symbol (Selected) : " . $_POST['slcGs'] . "</br>";
		echo "Gene Symbol (input) : " . $_POST['GeneSymbolCanonic'] . "</br>";
		echo "Gene Name (input) : " . $_POST['geneName'] . "</br>";
		echo "Gene Descri (input) : " . $_POST['geneDescri'] . "</br>";
		echo "Gene Pathway (input) : " . $_POST['cpw'] . "</br>";
		echo "Gene Location (input) : " . $_POST['geneLoc'] . "</br>";
		echo "Gene Description Non-Canonic (input) : " . $_POST['NonGeneDescri'] . "</br>";
		echo "Gene Lacation Non-Canonic (input) : " . $_POST['NonGeneLoc'] . "</br>";*/

		if(empty($_POST['GeneSymbolCanonic']))
		{
			/*echo "On passe par le select";*/
			?>

			<form action=ref.php method=post>
				<table align="center" >
					<tr>
						<td id="geneRef"><label style="float: left">Adding reference for : </label></td>
						<td><label> <?php echo $_POST['slcGs']; ?></label></td>
					</tr>

					<tr>		
						<td><label for="refSlt">Reference : </label></td>
						<td><textarea style="width:90%" id="refSlt" name="refSlt" rows="6" cols="45" placeholder="Write one reference here..." required></textarea></td>
					</tr>

					<input type="hidden" name="gs" value="<?php echo "" . $_POST['slcGs'] . "" ?>"></input>

					<input type="hidden" name="ncpw" value="<?php echo "" . $_POST['NonGeneDescri'] . "" ?>"></input>
					<input type="hidden" name="ncloc" value="<?php echo "" . $_POST['NonGeneLoc'] . "" ?>"></input>

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
			/*echo "On ne passe pas par le select";*/

			?>

			<form action=ref.php method=post>
				<table align="center" style="text-align: left">
					<tr>
						<td id="geneRef"><label style="float: left">Adding reference for : </label></td>
						<td><label> <?php echo $_POST['GeneSymbolCanonic']; ?></label></td>
					</tr>

					<tr>		
						<td><label for="refInput">Reference :</label></td>
						<td><textarea style="width:90%" id="refInput" name="refInput" rows="6" cols="45" placeholder="Write one reference here..." required></textarea></td>
					</tr>

					<input type="hidden" name="gs" value="<?php echo "" . $_POST['GeneSymbolCanonic'] . "" ?>"></input>

					<input type="hidden" name="ncpw" value="<?php echo "" . $_POST['NonGeneDescri'] . "" ?>"></input>
					<input type="hidden" name="ncloc" value="<?php echo "" . $_POST['NonGeneLoc'] . "" ?>"></input>
					<input type="hidden" name="gn" value="<?php echo "" . $_POST['geneName'] . "" ?>"></input>
					<input type="hidden" name="cdescri" value="<?php echo "" . $_POST['geneDescri'] . "" ?>"></input>
					<input type="hidden" name="canopw" value="<?php echo "" . $_POST['cpw'] . "" ?>"></input>
					<input type="hidden" name="cloc" value="<?php echo "" . $_POST['geneLoc'] . "" ?>"></input>

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
	}





		}
		catch (PDOException $e) 
		{
			print "Erreur de connexion à la base de donnée : " .$e->getMessage();
			die();
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