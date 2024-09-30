
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.sql.*;

import javax.swing.JComboBox;
import javax.swing.JTextField;

public class EcouteurBoutonAuteur implements MouseListener{
	
	private JTextField jtNom, jtPrenom, jtEmail;
    private JComboBox<String> jcEditeurs;
	private FenetreAuteur f;
	private static String URL = "jdbc:postgresql://localhost:5432/tp1_user";// tp1_user est le nom de la base
	private static String login = "postgres"; // mettre votre login
	private static String password = "postgres"; // mettre votre mot de passe
	private Connection conn;
    private String emailAuteur;
	
	public EcouteurBoutonAuteur(JTextField jtNom, JTextField jtPrenom, JTextField jtEmail, JComboBox<String> jcEditeurs,FenetreAuteur f){
		
		this.jtNom = jtNom;
		this.jtPrenom = jtPrenom;
		this.jtEmail = jtEmail;
		this.jcEditeurs = jcEditeurs;
        this.f = f;
		
	}
    /**
     * Créer une connexion avec la BDD
     */
    public void startConnexion() {
        try {
            Class.forName("org.postgresql.Driver");
			conn = DriverManager.getConnection(URL, login, password);
        } catch (Exception e) {
            System.out.println("startConnexion : "+e.getMessage());
        }
    }    

    /**
     * Mets fin à la connexion avec la BDD
     */
    public void endConnexion() {
        try {
            conn.close();
        } catch (Exception e) {
            System.out.println("endConnexion : "+e.getMessage());
        }
    }

    /**
     * Ajoute un auteur à la BDD
     */
    private void addAuteur() throws Exception{
        // on vérifie que l'email ne soit pas nulle
        emailAuteur = (jtEmail.getText().trim().length() != 0) ? jtEmail.getText().trim() : null;
        
        // insertIntoAuteur est une requête précompilée : cela permet d'éviter les injections sql...
        PreparedStatement insertIntoAuteur = conn.prepareStatement("INSERT INTO auteur(\"nomAuteur\",\"prenomAuteur\",\"emailAuteur\") VALUES (?,?,?)");
          
        insertIntoAuteur.setString(1,jtNom.getText());
        insertIntoAuteur.setString(2,jtPrenom.getText().trim());
        insertIntoAuteur.setString(3,emailAuteur);

        // on exécute la requête
        insertIntoAuteur.executeUpdate();
    }

    /**
     * Ajoute un contrat à la BDD
     */
    private void addContrat() throws Exception{
        // on récupère le numéro de l'auteur associé à l'email 
        PreparedStatement getnoAuteur = conn.prepareStatement("SELECT \"noAuteur\" FROM auteur WHERE \"emailAuteur\" = ?");
        getnoAuteur.setString(1, emailAuteur);
        ResultSet result = getnoAuteur.executeQuery();
        result.next();
        int noAuteur = result.getInt(1);
        // on créer la requête
        PreparedStatement insertIntoContrat = conn.prepareStatement("INSERT INTO contrat(\"unEditeur\",\"unAuteur\") VALUES(?,?)");
        insertIntoContrat.setString(1, (String) jcEditeurs.getSelectedItem());
        insertIntoContrat.setInt(2, noAuteur);
        
        // on exécute la requête
        insertIntoContrat.executeUpdate();
        
    }

    /**
     * Permet de définir une erreur personnalisé en fonction du code d'erreur
     * @param erreurSQL
     * @return
     */
    private String gestionnaireMessageErreur(SQLException erreurSQL){
        System.out.println("code erreur : "+erreurSQL.getSQLState());
			String messageErreur = "<html>";
			switch (erreurSQL.getSQLState()) {
				case "23502":
					messageErreur +=  "<p>L'email doit être renseigné</p>";
					break;
                case "23505":
					messageErreur += "<p>Cet email est déjà connu dans la base de donnée</p>";
                    break;
                case "P0001":
                    String messageTrigger = erreurSQL.getMessage().split("Where")[0];
                    messageTrigger = messageTrigger.split("ERROR:")[1];
                    messageErreur += "<p>"+messageTrigger+"</p>";
                    break;
				default:
                    messageErreur += erreurSQL.getMessage();
					break;
			}
			messageErreur += "</html>";
        return messageErreur;
    }

    @Override
	public void mouseClicked(MouseEvent e){
		try {	
			startConnexion();
			addAuteur();
            addContrat();
            endConnexion();
	      	f.setVisible(false);
	    }
		catch(SQLException erreurSQL) {
			new FenetreErreur(gestionnaireMessageErreur(erreurSQL));
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