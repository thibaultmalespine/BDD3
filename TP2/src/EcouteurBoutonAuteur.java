
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.sql.*;

import javax.swing.JComboBox;
import javax.swing.JTextField;

public class EcouteurBoutonAuteur implements MouseListener{
	
	private JTextField jtNom, jtPrenom, jtEmail;
    private JComboBox<String> jcEditeurs1, jcEditeurs2;
	private FenetreAuteur f;
	private static String URL = "jdbc:postgresql://localhost:5433/lib2";// tp1_user est le nom de la base
	private static String login = "userpostgres"; // mettre votre login
	private static String password = "userpostgres"; // mettre votre mot de passe
	private Connection conn;
    private String emailauteur;
    private int noauteur;
	
	public EcouteurBoutonAuteur(JTextField jtNom, JTextField jtPrenom, JTextField jtEmail, JComboBox<String> jcEditeurs1, JComboBox<String> jcEditeurs2,FenetreAuteur f){	
		this.jtNom = jtNom;
		this.jtPrenom = jtPrenom;
		this.jtEmail = jtEmail;
		this.jcEditeurs1 = jcEditeurs1;
		this.jcEditeurs2 = jcEditeurs2;
        this.f = f;	
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
     * Ajoute l'auteur à la BDD
     */
    private void addAuteur() throws SQLException{
                
        // insertIntoAuteur est une requête précompilée : cela permet d'éviter les injections sql...
        PreparedStatement insertIntoAuteur = conn.prepareStatement("INSERT INTO auteur VALUES (NEXTVAL('cleAuteur'),?,?,?)");
          
        insertIntoAuteur.setString(1,jtNom.getText());
        insertIntoAuteur.setString(2,jtPrenom.getText().trim());
        insertIntoAuteur.setString(3,emailauteur);

        // on exécute la requête
        insertIntoAuteur.executeUpdate();
    }

    /**
     * Supprime l'auteur de la BDD et les contrats associés
     */
    private void removeAuteurAndContrat(){
        try {
            // récupérer les contrats avec les editeurs de l'auteur
            PreparedStatement getContratEditeur = conn.prepareStatement("SELECT unediteur FROM contrat WHERE unauteur = ?");
            getContratEditeur.setInt(1, noauteur);
            // supprimer tous les contrats
            ResultSet contratsEditeurs = getContratEditeur.executeQuery();
            while (contratsEditeurs.next()) {
                String nomEditeur = contratsEditeurs.getString(1);
                PreparedStatement removeContrat = conn.prepareStatement("DELETE FROM contrat WHERE unediteur = ? AND unauteur = ?" );
                removeContrat.setString(1, nomEditeur);
                removeContrat.setInt(2, noauteur);
                removeContrat.executeUpdate();
            }   

            // supprimer l'auteur
            PreparedStatement removeAuteur = conn.prepareStatement("DELETE FROM auteur WHERE noauteur = ? ");            
            removeAuteur.setInt(1,noauteur);
    
            // on exécute la requête
            removeAuteur.executeUpdate();
            
        } catch (Exception e) {
            System.out.println("Erreur lors de la suppression de l'auteur : "+e.getMessage());
        }
    }

    /**
     * Ajoute un contrat à la BDD
     */
    private void addContrat() throws SQLException{
        
        String[] editeursSelectionnés = {(String) jcEditeurs1.getSelectedItem(), (String) jcEditeurs2.getSelectedItem()};  

        for (String editeur : editeursSelectionnés) {   
    
            // on créer la requête
            PreparedStatement insertIntoContrat = conn.prepareStatement("INSERT INTO contrat(unediteur,unauteur) VALUES(?,?)");
            insertIntoContrat.setString(1, editeur);
            insertIntoContrat.setInt(2, noauteur);
            
            // on exécute la requête
            insertIntoContrat.executeUpdate();
           
        }  
    }

    /**
     * Réupère le numéro de l'auteur dans la BDD à partir de son email
     * @param emailauteur
     * @return
     */
    private int getNoAuteur(String emailauteur) throws SQLException{
        // on récupère le numéro de l'auteur associé à l'email 
        PreparedStatement getNoAuteur = conn.prepareStatement("SELECT noauteur FROM auteur WHERE emailauteur = ?");
        getNoAuteur.setString(1, emailauteur);
        ResultSet result = getNoAuteur.executeQuery();
        result.next();
        int noAuteur = result.getInt(1);

        return noAuteur;
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
                    removeAuteurAndContrat();
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
            emailauteur = (jtEmail.getText().trim().length() != 0) ? jtEmail.getText().trim() : null;
			addAuteur();
            noauteur = getNoAuteur(emailauteur);
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