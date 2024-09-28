import java.awt.BorderLayout;
import java.awt.GridLayout;

import javax.swing.*;

public class FenetreClient extends JFrame{
	
	private JLabel nomClient, prenomClient, emailClient;
	private JTextField jtNom, jtPrenom, jtEmail;
	private JButton b;
	
	public FenetreClient(){
		super("création d'un client");
		this.setLayout(new BorderLayout());
		JPanel p1 = new JPanel(new GridLayout(3,1));
		JPanel p2 = new JPanel(new GridLayout(3,1));
		this.nomClient = new JLabel("nom du client : ");
		this.prenomClient = new JLabel("adresse du client : ");
		this.emailClient = new JLabel("email du client : ");
		this.jtNom = new JTextField();
		this.jtPrenom = new JTextField();
		this.jtEmail = new JTextField();
		this.b = new JButton("envoyer");
		p1.add(nomClient);
		p1.add(prenomClient);
		p1.add(emailClient);
		p2.add(jtNom);
		p2.add(jtPrenom);
		p2.add(jtEmail);
		this.add(p1,BorderLayout.WEST);
		this.add(p2,BorderLayout.CENTER);
		this.add(b,BorderLayout.SOUTH);
		b.addMouseListener(new EcouteurBoutonClient(jtNom,jtPrenom,jtEmail,this));
		this.setSize(400,250);
		this.setVisible(true);
	}
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		new FenetreClient();
	}

}
