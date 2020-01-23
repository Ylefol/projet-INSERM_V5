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



<p align="center">Please, connect to access to the database administration !</p>
</br></br>

<?php

	if(!empty($_POST['login']) && !empty($_POST['pw']))
	{
		require_once("connexion.php");

	  	try 
	  	{
	 		$maConnexion = new PDO($dns, $user, $mdp);
	 		$query=$maConnexion->prepare('SELECT 1
											FROM user
											WHERE login = :login
  											AND password = MD5(:mdp)');
	 		$query->BindValue(':login',$_POST['login'],PDO::PARAM_STR);
	 		$query->BindValue(':mdp',$_POST['pw'],PDO::PARAM_STR);
			$query->execute();

			$res=$query->fetch();

			if($res[1] == 1)
			{
				session_start();
				$_SESSION['User']='Cellomet';

				header ('location: menu.php');
			}
			else
			{
				echo "<p align='center'>Fail to connect, please try again !</p>";
			}

			$maConnexion = null; 
		}
		catch (PDOException $e)
		{
			print "Erreur de connexion à la base de donnée : " . $e->getMessage();
			die();
		}


	}


?>

</br></br></br>	

<form style="float : center" form action=modif.php method=post>
	<table align="center" style="text-align: right; width: 400px;">
		<tr>
			<td><label for="login">Login</label></td>
			<td><input type="text" id="login" name="login" placeholder="Login" required></td>		
		</tr>
		<tr>
			<td><label for="pw">Password</label></td>
			<td><input type="password" id="pw" name="pw" placeholder="Password" required></td>			
		</tr>
	</table>
	</br></br>	
	<button class="buttonConnexion" type="submit" ><span>Log in</span></button>
</form>

</body>

</html>