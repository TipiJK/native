<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Asiakkaiden listaus</title>
</head>
<body onkeydown="tutkiKey(event)">
	<table id="listaus">
		<thead>
		<tr>
			<th colspan="3" id="ilmo"></th>
			<th colspan="2" class="oikealle"><a id="uusiAsiakas" href="lisaaasiakas.jsp">Lisää asiakas</a></th>
		</tr>
			<tr>
				<th colspan="3" class="oikealle">Hakusana:</th>
				<th><input type="text" id="hakusana"></th>
				<th><input type="button" id="hae" value="Hae" onclick="haeTiedot()"></th>
			</tr>		
			<tr>
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>Sposti</th>
				<th>&nbsp;</th>		<!-- välilyönti -->
			</tr>
		</thead>
		<tbody id="tbody">
		</tbody>
	</table>
<script>
haeTiedot();	
document.getElementById("hakusana").focus();
function tutkiKey(event){
	if(event.keyCode==13){//Enter
		haeTiedot();
	}		
}

function haeTiedot(){	
	document.getElementById("tbody").innerHTML = ""; //tyhjentää tbody:n elementit ja tekstin
	fetch("asiakkaat/" + document.getElementById("hakusana").value,{//Lähetetään kutsuu autot backin GET-metodia, välittää hakusanan
	      method: 'GET'
	    })
	.then(function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
			return response.json()	
		})
	.then(function (responseJson) {//Otetaan vastaan objekti responseJson-parametrissä
	
		var asiakkaat = responseJson.asiakkaat;	
		var htmlStr="";
		for(var i=0;i<asiakkaat.length;i++){			
        	htmlStr+="<tr>";
        	//htmlStr+="<td>"+asiakkaat[i].asiakas_id+"</td>";
        	htmlStr+="<td>"+asiakkaat[i].etunimi+"</td>";
        	htmlStr+="<td>"+asiakkaat[i].sukunimi+"</td>";
        	htmlStr+="<td>"+asiakkaat[i].puhelin+"</td>";
        	htmlStr+="<td>"+asiakkaat[i].sposti+"</td>";        	
        	htmlStr+="<td><a href='muutaasiakas.jsp?asiakas_id="+asiakkaat[i].asiakas_id+"'>Muuta</a>&nbsp;";
        	htmlStr+="<span class='poista' onclick=poista('"+asiakkaat[i].asiakas_id+"')>Poista</span></td>";
        	htmlStr+="</tr>";        	
		}
		document.getElementById("tbody").innerHTML = htmlStr;
	})	
}

function poista(asiakas_id){
	if(confirm("Poista asiakas?")){	
		fetch("asiakkaat/"+ asiakas_id,{//Lähetetään kutsu backendiin
		      method: 'DELETE'		      	      
		    })
		.then(function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
			return response.json()
		})
		.then(function (responseJson) {//Otetaan vastaan objekti responseJson-parametrissä		
			var vastaus = responseJson.response;		
			if(vastaus==0){
				document.getElementById("ilmo").innerHTML= "Asiakkaan poisto epäonnistui.";
	        }else if(vastaus==1){	        	
	        	document.getElementById("ilmo").innerHTML="Asiakkaan poisto onnistui.";
				haeTiedot();        	
			}	
			setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 5000);
		})		
	}	
}
</script>
</body>
</html>