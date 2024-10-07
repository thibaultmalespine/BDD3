import java.awt.event.MouseEvent;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.awt.event.MouseAdapter;

import javax.swing.JComboBox;
import javax.swing.JFormattedTextField;
import javax.swing.JTextField;

public class EcouteurBoutonLivre extends MouseAdapter{
    String titre;
    int prix;
    JTextField jtTitre;
    JFormattedTextField jfPrix;
    JComboBox<String> jcType, jcAuteurs1, jcAuteurs2;
    FenetreLivre f;
    Connection conn;

    String URL = "jdbc:postgresql://localhost:5433/lib2";// tp1_user est le nom de la base
    String login = "userpostgres"; // mettre votre login
    String password = "userpostgres"; // mettre votre mot de passe
    
    public EcouteurBoutonLivre(JTextField jtTitre, JFormattedTextField jfPrix, JComboBox<String> jcType, JComboBox<String> jcAuteurs1, JComboBox<String> jcAuteurs2,FenetreLivre f){	
		this.jtTitre = jtTitre;
		this.jfPrix = jfPrix;
		this.jcType = jcType;
		this.jcAuteurs1 = jcAuteurs1;
		this.jcAuteurs2 = jcAuteurs2;
        this.f = f;	
	}
    @Override
    public void mouseClicked(MouseEvent e) {
        try {	
			startConnexion();
            titre = jtTitre.getText().trim();
        }
	
	    catch(Exception exc){ 
	      System.out.println(exc);
	    }
    }



    /**
     * Créer une connexion avec la BDD
     */
    private void startConnexion() {
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
    private void endConnexion() {
        try {
            conn.close();
        } catch (Exception e) {
            System.out.println("endConnexion : "+e.getMessage());
        }
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
                    String messageTrigger = erreurSQL.getMessage().split("Où")[0];
                    messageTrigger = messageTrigger.split("ERROR:")[1];
                    messageErreur += "<p>"+messageTrigger+"</p>";
                    //removeAuteurAndContrat();
                    break;
				default:
                    messageErreur += erreurSQL.getMessage();
					break;
			}
			messageErreur += "</html>";
        return messageErreur;
    }
}