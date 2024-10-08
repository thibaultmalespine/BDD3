
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
	private String nomEditeur;
	private String adresseEditeur;
	
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
			
			// on vérifie si le nom de l'auteur est nul 
			nomEditeur = (jt1.getText().trim().length() != 0) ? jt1.getText().trim() : null;
			// on vérifie si l'adresse de l'auteur est nulle 
			adresseEditeur = (jt2.getText().trim().length() != 0) ? jt2.getText().trim() : null;
			
			requetePreparee.setString(1,nomEditeur);
			requetePreparee.setString(2,adresseEditeur);
			
			requetePreparee.executeUpdate();
			
	      	conn.close();
	      	f.setVisible(false);
		  
	    }
		catch(SQLException erreurSQL) {
			System.out.println("code erreur : "+erreurSQL.getSQLState());
			String messageErreur = "<html>";
			switch (erreurSQL.getSQLState()) {
				case "23502":
					messageErreur += (nomEditeur == null) ? "<p>Le nom de l'éditeur doit être renseigné</p>" : "";
					messageErreur += (adresseEditeur == null) ? "<p>L'adresse de l'éditeur doit être renseignée<p>" : "";
					break;
				case "23505":
					messageErreur += "<p>Cette éditeur est déjà connu dans la base</p>";
					break;
				default:
					break;
			}
			messageErreur += "</html>";
			new FenetreErreur(messageErreur);
		}
	    catch(Exception exc){ 
	      System.out.println(exc);
	    }
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