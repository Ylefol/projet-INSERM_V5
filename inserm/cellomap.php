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
			<button title="Only for database administration" class="buttonModif" type="button" onclick=self.location="./modif.php"><span>Connexion</span></button>
		</form>		
		</tr>
	</table>
</div>

</br>


	<fieldset id="fs01">
	 	<p id="p03" align="center">Multiple options are available on our app !</p>


  <section id="portfolio">

    <div class="project">
      <img class="project__image" id="f1" src="images/folio1.png" style="width: 100%"/>
     	 <div id="myModal1" class="modal">

	  		<span class="close">&times;</span>
	  		<img style="margin: auto" class="modal-content" id="folio1">
	  		<div id="caption"></div>

		</div>
    </div>
    
    <div class="project">
      	<img class="project__image" id="f2" src="images/folio2.png" style="width: 100%"/>
      	<div id="myModal2" class="modal">

	  		<span class="close">&times;</span>
	  		<img class="modal-content" id="folio2">
	  		<div id="caption"></div>

		</div>

    </div>
    
    <div class="project">
      <img class="project__image" id="f3" src="images/folio3.png" style="width: 100%"/>
      <div id="myModal3" class="modal">

	  		<span class="close">&times;</span>
	  		<img class="modal-content" id="folio3">
	  		<div id="caption"></div>

		</div>

    </div>
    
    <div class="project">
      	<img class="project__image" id="f4" src="images/folio4.png" style="width: 100%"/>
  		<div id="myModal4" class="modal">

	  		<span class="close">&times;</span>
	  		<img class="modal-content" id="folio4">
	  		<div id="caption"></div>

		</div>

    </div>
    <div class="project">
      <img class="project__image" id="f5" src="images/folio5.png" style="width: 100%"/>
      <div id="myModal5" class="modal">

	  		<span class="close">&times;</span>
	  		<img class="modal-content" id="folio5">
	  		<div id="caption"></div>

		</div>

    </div>
    
    <div class="project">
      <img class="project__image" src="" />
 

    </div>
    
    <div class="project">
      <img class="project__image" src="" />
  

    </div>
    
    <div class="project">
      <img class="project__image" src="" />
  

    </div>
  </section>

</br></br>

<table align="center" cellpadding=20>	
	<tr>
		<td>
			<form action="res/CelloApp.zip" >
				<button class="button" type="submit">
			<table>
				<tr>
					<td>
						<img style="height: 20px" src="images/windows.svg">
					</td>
					<td>
						<span>Download</span>
					</td>
				</tr>
						</table>
						</button>
						</form>
					</td>
					<td>
						<button class="button" type="button" >
							<table>
								<tr>
									<td>
										<img style="height: 20px" src="images/apple.svg">
									</td>
									<td>
										<span>Download</span>
									</td>
								</tr>
							</table>
							</button>
					</td>
				</tr>
		</table>	
	</p>
</fieldset>


<!-- <form action="res/CelloApp.zip" >
	<button class="button" type="submit">TEST</button>
</form> -->

<script type="text/javascript">
// Get the modal
var modal1 = document.getElementById("myModal1");
var modal2 = document.getElementById("myModal2");
var modal3 = document.getElementById("myModal3");
var modal4 = document.getElementById("myModal4");
var modal5 = document.getElementById("myModal5");
var modal6 = document.getElementById("myModal6");
var modal7 = document.getElementById("myModal7");
var modal8 = document.getElementById("myModal8");

// Get the image and insert it inside the modal - use its "alt" text as a caption
var img1 = document.getElementById("f1");
var modalImg1 = document.getElementById("folio1");

var img2 = document.getElementById("f2");
var modalImg2 = document.getElementById("folio2");

var img3 = document.getElementById("f3");
var modalImg3 = document.getElementById("folio3");

var img4 = document.getElementById("f4");
var modalImg4 = document.getElementById("folio4");

var img5 = document.getElementById("f5");
var modalImg5 = document.getElementById("folio5");

var img6 = document.getElementById("f6");
var modalImg6 = document.getElementById("folio6");

var img7 = document.getElementById("f7");
var modalImg7 = document.getElementById("folio7");

var img8 = document.getElementById("f8");
var modalImg8 = document.getElementById("folio8");

var captionText = document.getElementById("caption");
img1.onclick = function(){
  modal1.style.display = "block";
  modalImg1.src = this.src;
  captionText.innerHTML = this.alt;
}

img2.onclick = function(){
  modal2.style.display = "block";
  modalImg2.src = this.src;
  captionText.innerHTML = this.alt;
}

img3.onclick = function(){
  modal3.style.display = "block";
  modalImg3.src = this.src;
  captionText.innerHTML = this.alt;
}

img4.onclick = function(){
  modal4.style.display = "block";
  modalImg4.src = this.src;
  captionText.innerHTML = this.alt;
}

img5.onclick = function(){
  modal5.style.display = "block";
  modalImg5.src = this.src;
  captionText.innerHTML = this.alt;
}

/*img6.onclick = function(){
  modal6.style.display = "block";
  modalImg6.src = this.src;
  captionText.innerHTML = this.alt;
}

img7.onclick = function(){
  modal7.style.display = "block";
  modalImg7.src = this.src;
  captionText.innerHTML = this.alt;
}

img8.onclick = function(){
  modal8.style.display = "block";
  modalImg8.src = this.src;
  captionText.innerHTML = this.alt;
}*/

// Get the <span> element that closes the modal
var span1 = document.getElementsByClassName("close")[0];
var span2 = document.getElementsByClassName("close")[1];
var span3 = document.getElementsByClassName("close")[2];
var span4 = document.getElementsByClassName("close")[3];
var span5 = document.getElementsByClassName("close")[4];
/*var span6 = document.getElementsByClassName("close")[5];
var span7 = document.getElementsByClassName("close")[6];
var span8 = document.getElementsByClassName("close")[7];*/


// When the user clicks on <span> (x), close the modal
span1.onclick = function() {
  modal1.style.display = "none";
}

span2.onclick = function() {
  modal2.style.display = "none";
}

span3.onclick = function() {
  modal3.style.display = "none";
}

span4.onclick = function() {
  modal4.style.display = "none";
}

span5.onclick = function() {
  modal5.style.display = "none";
}

/*span6.onclick = function() {
  modal6.style.display = "none";
}

span7.onclick = function() {
  modal7.style.display = "none";
}

span8.onclick = function() {
  modal8.style.display = "none";
}*/

</script>

</body>

</html>