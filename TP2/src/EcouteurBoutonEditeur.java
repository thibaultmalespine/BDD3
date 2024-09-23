
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.sql.*;
import javax.swing.JTextField;

public class EcouteurBoutonEditeur implements MouseListener{
	
	private JTextField jt1, jt2;
	private FenetreEditeur f;
	private static String URL = "jdbc:postgresql://localhost:5432/tp1_user";// tp1_user est le nom de la base
	private static String login = "postgres"; // mettre votre login
	private static String password = "postgres"; // mettre votre mot de passe
	private Connection conn;
	
	public EcouteurBoutonEditeur(JTextField jt1, JTextField jt2, FenetreEditeur f){
		
		this.jt1 = jt1;
		this.jt2 = jt2;
		this.f = f;
		
	}

	@Override
	public void mouseClicked(MouseEvent e){
		// TODO Auto-generated method stub
		try {
		  
			Class.forName("org.postgresql.Driver");
			conn = DriverManager.getConnection(URL, login, password);
			
			// requetePreparee est une requête précompilée : cela permet d'éviter les injections sql...
			PreparedStatement requetePreparee = conn.prepareStatement("INSERT INTO editeur(\"nomEditeur\",adresse) VALUES (?,?)");
			// on check si le nom de l'auteur est null
			String nomAuteur = "";
			if (jt1.getText().trim().length() == 0) {
				nomAuteur = null;
			}
			else {
				nomAuteur = jt1.getText().trim();
			}
			requetePreparee.setString(1,nomAuteur);
			requetePreparee.setString(2,jt2.getText());
			
			requetePreparee.executeUpdate();
			
	      	conn.close();
	      	f.setVisible(false);
		  
	    }
		catch(SQLException erreurSQL) {
			//System.out.println(erreurSQL);
			System.out.println(" code de l'erreur : "+erreurSQL.getErrorCode());
			//System.out.println(" message de l'erreur : "+erreurSQL.getMessage());
			String messageErreur = "";
			// TODO : trouver un meilleur moyen de vérifier quel est le type de l'erreur, 
			// 		  car getErrorCode renvoie toujours 0 pour un pb de clé primaire
			//		  mais ne fais pas la différence entre un nom null et un nom déjà existant 
			if (erreurSQL.getErrorCode() == 0) {
				messageErreur = "Cette éditeur est déjà connu dans la base";
			}
			FenetreErreur fe = new FenetreErreur(messageErreur);
		}
	    catch(Exception exc){ 
	      System.out.println(exc);
	    }
		//f.setVisible(false);
	}

	@Override
	public void mousePressed(MouseEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void mouseReleased(MouseEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void mouseEntered(MouseEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void mouseExited(MouseEvent e) {
		// TODO Auto-generated method stub
		
	}

}