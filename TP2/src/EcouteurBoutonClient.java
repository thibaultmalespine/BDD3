
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.sql.*;
import javax.swing.JTextField;

public class EcouteurBoutonClient implements MouseListener{
	
	private JTextField jtNom, jtPrenom, jtEmail;
	private FenetreClient f;
	private static String URL = "jdbc:postgresql://localhost:5432/tp1_user";// tp1_user est le nom de la base
	private static String login = "postgres"; // mettre votre login
	private static String password = "postgres"; // mettre votre mot de passe
	private Connection conn;
	
	public EcouteurBoutonClient(JTextField jtNom, JTextField jtPrenom, JTextField jtEmail, FenetreClient f){
		
		this.jtNom = jtNom;
		this.jtPrenom = jtPrenom;
		this.jtEmail = jtEmail;
		this.f = f;
		
	}

    @Override
	public void mouseClicked(MouseEvent e){
		// TODO Auto-generated method stub
		try {
		  
			Class.forName("org.postgresql.Driver");
			conn = DriverManager.getConnection(URL, login, password);
			
			// requetePreparee est une requête précompilée : cela permet d'éviter les injections sql...
			PreparedStatement requetePreparee = conn.prepareStatement("INSERT INTO client(\"nomClient\",\"prenomClient\",\"emailClient\") VALUES (?,?,?)");
			
            // on vérifie si l'email n'est pas nulle
            String emailClient = (jtEmail.getText().trim().length() != 0) ? jtEmail.getText().trim() : null;

			requetePreparee.setString(1,jtNom.getText());
			requetePreparee.setString(2,jtPrenom.getText().trim());
			requetePreparee.setString(3,emailClient);
			
			requetePreparee.executeUpdate();
			
	      	conn.close();
	      	f.setVisible(false);
		  
	    }
		catch(SQLException erreurSQL) {
			System.out.println("code erreur : "+erreurSQL.getSQLState());
			String messageErreur = "<html>";
			switch (erreurSQL.getSQLState()) {
				case "23502":
					messageErreur += "<p>L'email doit être renseigné</p>";
					break;
                case "23505":
					messageErreur += "<p>Cet email est déjà connu dans la base de donnée</p>";
                    break;
				default:
                    messageErreur += erreurSQL.getMessage();
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