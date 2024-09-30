import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.JComboBox;

public class FenetreAuteur extends JFrame{
	
	private JLabel nomAuteur, prenomAuteur, emailAuteur, contratAuteurEditeur;
	private JTextField jtNom, jtPrenom, jtEmail;
    private JComboBox<String> jcEditeurs;
	private JButton b;
	
	public FenetreAuteur(){
		super("création d'un auteur");
		this.setLayout(new BorderLayout());
		JPanel p1 = new JPanel(new GridLayout(4,1));
		JPanel p2 = new JPanel(new GridLayout(4,1));
		this.nomAuteur = new JLabel("nom de l'auteur : ");
		this.prenomAuteur = new JLabel("prenom de l'auteur : ");
		this.emailAuteur = new JLabel("email de l'auteur : ");
        this.contratAuteurEditeur = new JLabel("contrat avec : ");
		this.jtNom = new JTextField();
		this.jtPrenom = new JTextField();
		this.jtEmail = new JTextField();
        this.jcEditeurs = new JComboBox<>(this.getEditeurs());
		this.b = new JButton("envoyer");
		p1.add(nomAuteur);
		p1.add(prenomAuteur);
		p1.add(emailAuteur);
        p1.add(contratAuteurEditeur);
		p2.add(jtNom);
		p2.add(jtPrenom);
		p2.add(jtEmail);
        p2.add(jcEditeurs);
		this.add(p1,BorderLayout.WEST);
		this.add(p2,BorderLayout.CENTER);
		this.add(b,BorderLayout.SOUTH);
		b.addMouseListener(new EcouteurBoutonAuteur(jtNom,jtPrenom,jtEmail,jcEditeurs,this));
		this.setSize(400,250);
		this.setVisible(true);
	}
	
    private Vector<String> getEditeurs(){
        Vector<String> editeurs = new Vector<>();

        String URL = "jdbc:postgresql://localhost:5432/tp1_user";// tp1_user est le nom de la base
	    String login = "postgres"; // mettre votre login
	    String password = "postgres"; // mettre votre mot de passe

        try {
		  
			Class.forName("org.postgresql.Driver");
			Connection conn = DriverManager.getConnection(URL, login, password);
			
			// requetePreparee est une requête précompilée : cela permet d'éviter les injections sql...
			Statement requete = conn.createStatement();
            ResultSet result = requete.executeQuery("SELECT \"nomEditeur\" FROM editeur");
            while (result.next()) {
                editeurs.add(result.getString(1));
            }

        }catch(SQLException sqlException){
            System.out.println("sqlException : "+sqlException.getMessage());
        }catch(Exception e){
            System.out.println("Exception : "+e.getMessage());
        }

        
        return editeurs;
    }

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		FenetreAuteur f = new FenetreAuteur();
        f.getEditeurs();
	}

}
