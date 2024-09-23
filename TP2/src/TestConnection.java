import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
public class TestConnection {

	public static void main(String[] args) {
		// TODO Auto-generated method stub

	    try
	    {
	      //étape 1: charger la classe de driver
	      Class.forName("org.postgresql.Driver");
	      
	      //étape 2: créer l'objet de connexion
	      Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/tp1_user","postgres","postgres");
	      
	      //étape 3: créer l'objet statement 
	      Statement stmt = conn.createStatement();
	      
	      //étape 4: exécuter la requête
	      ResultSet res = stmt.executeQuery("SELECT * FROM editeur");
	      
	      //étape 5: impression du résultat de la requête
	      while(res.next())
	        System.out.println(res.getString(1)+"  "+res.getString(2));
	      
	      //étape 6: fermeture de l'objet de connexion
	      conn.close();
	    }
	    catch(Exception e){ 
	      System.out.println(e);
	    }
	}

}
