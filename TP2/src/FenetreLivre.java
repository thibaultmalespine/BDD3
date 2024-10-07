import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.NumberFormat;
import java.util.Arrays;
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.JComboBox;
import javax.swing.JFormattedTextField;

public class FenetreLivre extends JFrame{
	
	private JLabel titre, prix, type, auteur1, auteur2;
	private JTextField jtTitre;
    private JFormattedTextField jfPrix;
    private JComboBox<String> jcType, jcAuteur1, jcAuteur2;
	private JButton b;
	
	public FenetreLivre(){
		super("création d'un livre");
		this.setLayout(new BorderLayout());
		JPanel p1 = new JPanel(new GridLayout(5,1));
		JPanel p2 = new JPanel(new GridLayout(5,1));
		this.titre = new JLabel("titre du livre : ");
		this.prix = new JLabel("prix du livre : ");
        this.type = new JLabel("type du livre : ");
        this.auteur1 = new JLabel("auteur du livre : ");
        this.auteur2 = new JLabel("auteur du livre : ");
		this.jtTitre = new JTextField();
		this.jfPrix = new JFormattedTextField(NumberFormat.getIntegerInstance());
        this.jcType = new JComboBox<>(new Vector<>(Arrays.asList("POCHE", "BD")));  
		this.jcAuteur1 = new JComboBox<>(this.getAuteurs());
		this.jcAuteur2 = new JComboBox<>(this.getAuteurs());
		this.b = new JButton("envoyer");
		p1.add(titre);
		p1.add(prix);
		p1.add(type);
        p1.add(auteur1);
        p1.add(auteur2);
		p2.add(jtTitre);
		p2.add(jfPrix);
		p2.add(jcType);
        p2.add(jcAuteur1);
        p2.add(jcAuteur2);
		this.add(p1,BorderLayout.WEST);
		this.add(p2,BorderLayout.CENTER);
		this.add(b,BorderLayout.SOUTH);
		b.addMouseListener(new EcouteurBoutonLivre(jtTitre,jfPrix,jcType,jcAuteur1,jcAuteur2,this));
		this.setSize(400,250);
		this.setVisible(true);
	}

    /**
	 * retourne un vector de chaine de caractère contenant l'ensemble des noms des éditeurs
	 * @return
	 */
    private Vector<String> getAuteurs(){
        Vector<String> auteurs = new Vector<>();

        String URL = "jdbc:postgresql://localhost:5433/lib2";// tp1_user est le nom de la base
	    String login = "userpostgres"; // mettre votre login
	    String password = "userpostgres"; // mettre votre mot de passe

        try {
		  
			Class.forName("org.postgresql.Driver");
			Connection conn = DriverManager.getConnection(URL, login, password);
			
			// requetePreparee est une requête précompilée : cela permet d'éviter les injections sql...
			Statement requete = conn.createStatement();
            ResultSet result = requete.executeQuery("SELECT prenomauteur, nomauteur FROM auteur");
            while (result.next()) {
                auteurs.add(result.getString(1)+" "+result.getString(2));
            }

        }catch(SQLException sqlException){
            System.out.println("sqlException : "+sqlException.getMessage());
        }catch(Exception e){
            System.out.println("Exception : "+e.getMessage());
        }

        
        return auteurs;
    }
	

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		FenetreLivre f = new FenetreLivre();
	}

}
