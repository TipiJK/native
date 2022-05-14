package control;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import model.Asiakas;
import model.dao.Dao;

@WebServlet("/asiakkaat/*")
public class Asiakkaat extends HttpServlet {
	private static final long serialVersionUID = 1L;
           
    public Asiakkaat() {
        super();
        System.out.println("Asiakkaat.Asiakkaat()");
    }
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doGet()");
		String pathInfo = request.getPathInfo();	//haetaan kutsun polkutiedot, esim. /aalto			
		System.out.println("polku: "+pathInfo);				//tulostaa tietoa konsoliin
		
		Dao dao = new Dao();
		ArrayList<Asiakas> asiakkaat;
		String strJSON="";
		if(pathInfo==null) {			// vaihtoehto 1: ei hakusanaa, listataan kaikki
			asiakkaat = dao.listaaKaikki();
			strJSON = new JSONObject().put("asiakkaat", asiakkaat).toString();	
		}else if(pathInfo.indexOf("haeyksi")!=-1) {		//vaihtoehto 2: polussa on sana "haeyksi", eli haetaan yhden asiakkaan tiedot id:n perusteella
			int asiakas_id = Integer.parseInt(pathInfo.replace("/haeyksi/", "")); //poistetaan polusta "/haeyksi/", j‰ljelle j‰‰ asiakasnro	
			Asiakas asiakas = dao.etsiAsiakas(asiakas_id);
			if(asiakas==null) {
				strJSON = "{}"; //korjaa virheen, jossa etsitt‰v‰‰ objektia ei ole olemassa, palauttaa tyhj‰n objektin
			}else {
			JSONObject JSON = new JSONObject();
			JSON.put("asiakas_id", asiakas.getAsiakas_id());	
			JSON.put("etunimi", asiakas.getEtunimi());
			JSON.put("sukunimi", asiakas.getSukunimi());
			JSON.put("puhelin", asiakas.getPuhelin());
			JSON.put("sposti", asiakas.getSposti());	
			strJSON = JSON.toString();   //muutetaan stringiksi
			System.out.println("yksi asiakas haettu");
			}
		}else{ //vaihtoehto 3: Haetaan kaikki hakusanan sis‰lt‰v‰t asiakkaat
			String hakusana = pathInfo.replace("/", "");
			asiakkaat = dao.listaaKaikki(hakusana);
			strJSON = new JSONObject().put("asiakkaat", asiakkaat).toString();	//muutetaan stringiksi
		}	
		response.setContentType("application/json");		// m‰‰ritell‰‰n tyyppi
		PrintWriter out = response.getWriter();
		out.println(strJSON);	//kirjoitetaan stringi ulos
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doPost()");
		JSONObject jsonObj = new JsonStrToObj().convert(request); //Muutetaan kutsun mukana tuleva json-string objektiksi	(sijaitsee control/JsonStrToObj.java)
		Asiakas asiakas = new Asiakas();
		asiakas.setEtunimi(jsonObj.getString("etunimi"));		//nimien t‰ytyy olla samat kuin syˆtt‰v‰ss‰ lomakkeessa
		asiakas.setSukunimi(jsonObj.getString("sukunimi"));
		asiakas.setPuhelin(jsonObj.getString("puhelin"));
		asiakas.setSposti(jsonObj.getString("sposti"));
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();			
		if(dao.lisaaAsiakas(asiakas)){ //palauttaa true/false
			out.println("{\"response\":1}");  //lis‰‰minen onnistui palauttaa selaimelle {"response":1}
		}else{
			out.println("{\"response\":0}");  //lis‰‰minen ep‰onnistui {"response":0}
		}		
	}
	
	protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doPut()");
		JSONObject jsonObj = new JsonStrToObj().convert(request); //Muutetaan kutsun mukana tuleva json-string json-objektiksi			
		Asiakas asiakas = new Asiakas();
		asiakas.setAsiakas_id(jsonObj.getInt("asiakas_id"));
		asiakas.setEtunimi(jsonObj.getString("etunimi"));
		asiakas.setSukunimi(jsonObj.getString("sukunimi"));
		asiakas.setPuhelin(jsonObj.getString("puhelin"));
		asiakas.setSposti(jsonObj.getString("sposti"));
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();			
		if(dao.muutaAsiakas(asiakas)){ //metodi palauttaa true/false
			out.println("{\"response\":1}");  //muuttaminen onnistui {"response":1}
		}else{
			out.println("{\"response\":0}");  //muuttaminen ep‰onnistui {"response":0}
		}
	}
	
	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doDelete()");
		String pathInfo = request.getPathInfo();	//haetaan kutsun polkutiedot	
		System.out.println("polku: "+pathInfo);
		pathInfo = pathInfo.replace("/", "");
		int poistettavaAsiakas_id = Integer.parseInt(pathInfo);	
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();			
		if(dao.poistaAsiakas(poistettavaAsiakas_id)){ //metodi palauttaa true/false
			out.println("{\"response\":1}");  //poistaminen onnistui {"response":1}
			System.out.println("poisto1");
		}else{
			out.println("{\"response\":0}");  //poistaminen ep‰onnistui {"response":0}
			System.out.println("poisto0");
		}	
	}

}
