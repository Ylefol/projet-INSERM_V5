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
		if(isset($_POST['suppr']) && $_POST['suppr'] == 'suppr')
		{
			require_once("connexion.php");

  			try 
  			{
  				$maConnexion = new PDO($dns, $user, $mdp);

 				$reponse = $maConnexion->query('DELETE FROM questionnaire');
  			}
  			catch (PDOException $e) 
			{
	 			print "Erreur de connexion à la base de donnée : " .$e->getMessage();
	 			die();
			}

			$maConnexion = null; 
		}



		?>
		<p align="center">Statistics</p>	
		</br></br>
		<table class="res" id="stats">
		<tr style="background-color: #DE8125">
    		<th>Email</th>
    		<th>Type of study</th>
    		<th>Comments</th>
    		<th><SUB></SUB>Submission date</th>
		</tr>

		<?php
		require_once("connexion.php");

  		try 
  		{
 			$maConnexion = new PDO($dns, $user, $mdp);

 			$reponse = $maConnexion->query('SELECT * FROM questionnaire ORDER BY submit_date');

 			while ($donnees = $reponse->fetch())
			{
				echo '<tr>';
				echo '<td>'; echo $donnees['Email']; echo '</td>';
				echo '<td>'; echo $donnees['Type_of_Study']; echo '</td>';
				echo '<td>'; echo $donnees['Comments']; echo '</td>';
				echo '<td>'; echo $donnees['submit_date']; echo '</td>';
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

<table style='margin: auto'>
	<tr>
		<td><form><button class="ref" style="width: 200px" id="export" type="button" onclick="tableToExcel('stats', 'Tableau Excel')"><span>Download</span></button></form></td>
		<td>
			<form action=stats.php method=post>
				<input type="hidden" id="suppr" name="suppr" value="suppr"></input>
				<button class="suppr" style="width: 200px"><span>Delete history</span></button>
			</form>
		</td>
	</tr>
</table>

<?php
	}
	else
	{
		echo "<p style='text-align:center'><a href=modif.php> You are not connected, please come back to login page ! </a></p>";
	}
?>

<script type="text/javascript">
        var tableToExcel = (function () {
            var uri = 'data:application/vnd.ms-excel;base64,'
                , template = '<html xmlns:o="urn:schemas-microsoft-com:office:office"xmlns:x="urn:schemas-microsoft-com:office:excel"xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><!--[endif]--></head><body><table>{table}</table></body></html>'
                , base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) }
                , format = function (s, c) { return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; }) }
                return function (table, name) {
                if (!table.nodeType) table = document.getElementById(table)
                var ctx = { worksheet: name || 'Worksheet', table: table.innerHTML }
                window.location.href = uri + base64(format(template, ctx))
            }
        })()
    </script> 

</body>
</html>