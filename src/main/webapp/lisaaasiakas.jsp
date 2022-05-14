<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Lisää asiakas</title>
</head>
<body onkeydown="tutkiKey(event)">
<form id="tiedot" accept-charset="utf-8">
	<table>
		<thead>	
			<tr>
				<th colspan="5" class="oikealle"><a id="takaisin" href="listaaasiakkaat.jsp">Takaisin listaukseen</a></th>
			</tr>		
			<tr>
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>Sposti</th>			
				<th id="ilmo"></th>	
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><input type="text" name="etunimi" id="etunimi"></td>
				<td><input type="text" name="sukunimi" id="sukunimi"></td>
				<td><input type="text" name="puhelin" id="puhelin"></td>
				<td><input type="text" name="sposti" id="sposti"></td> 
				<td><input type="submit" id="tallenna" value="Lisää" onclick="lisaaTiedot()"></td>
			</tr>
		</tbody>
	</table>
</form>
</body>
<script>
function tutkiKey(event){
	if(event.keyCode==13){//Enter
		lisaaTiedot();
	}
	
}

document.getElementById("etunimi").focus();//viedään kursori rekno-kenttään sivun latauksen yhteydessä

//funktio tietojen lisäämistä varten. Kutsutaan backin POST-metodia ja välitetään kutsun mukana uudet tiedot json-stringinä.
//POST /autot/
function lisaaTiedot(){	
	var ilmo="";

	if(document.getElementById("etunimi").value.length<2){
		ilmo="Etunimi liian lyhyt!";		
	}else if(document.getElementById("sukunimi").value.length<2){
		ilmo="Sukunimi liian lyhyt!";		
	}else if(document.getElementById("puhelin").value.length<7){
		ilmo="Puhelinnumero liian lyhyt!";
	}else if(document.getElementById("puhelin").value.length>15){
		ilmo="Puhelinnumero liian pitkä!";	
	}else if(document.getElementById("sposti").value.length<8){
		ilmo="Sähköposti liian lyhyt!";		
	}else if(document.getElementById("sposti").value.length>50){
		ilmo="Sähköposti liian pitkä!";	
	}
	if(ilmo!=""){
		document.getElementById("ilmo").innerHTML=ilmo;
		setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 3000);
		return;
	}
	document.getElementById("etunimi").value=siivoa(document.getElementById("etunimi").value);	//siivous-funktio on main.js-tiedostossa
	document.getElementById("sukunimi").value=siivoa(document.getElementById("sukunimi").value); //siivous estää injektiohyökkäykset
	document.getElementById("puhelin").value=siivoa(document.getElementById("puhelin").value);
	document.getElementById("sposti").value=siivoa(document.getElementById("sposti").value);	
		
	var formJsonStr=formDataToJSON(document.getElementById("tiedot")); //muutetaan lomakkeen tiedot json-stringiksi
	//Lähetään uudet tiedot backendiin
	fetch("asiakkaat",{//Lähetetään kutsu backendiin
	      method: 'POST',
	      body:formJsonStr
	    })
	.then( function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi		
		return response.json()
	})
	.then( function (responseJson) {//Otetaan vastaan objekti responseJson-parametrissä	
		var vastaus = responseJson.response;		
		if(vastaus==0){
			document.getElementById("ilmo").innerHTML= "lisääminen epäonnistui";
      	}else if(vastaus==1){	        	
      		document.getElementById("ilmo").innerHTML= "lisääminen onnistui";			      	
		}
		setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 5000);
	});	
	document.getElementById("tiedot").reset(); //tyhjennetään tiedot -lomake
}
</script>
</html>