import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseListener;
import java.util.ArrayList;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JTable;

import org.w3c.dom.events.MouseEvent;

public class Tp3Etape4 extends JFrame implements ActionListener {
	private JTable tableau;
	private MonModeleDeTable modele;

	public Tp3Etape4() {
		super();

		setTitle("JTable avec tous les sports");
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		modele = new MonModeleDeTable(this);
		tableau = new JTable(modele);

		JButton btnAjouter = new JButton("Ajouter");
		JButton btnSupprimer = new JButton("Supprimer");

		btnAjouter.addActionListener(this);
		btnSupprimer.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				// à compléter
				System.out.println("supprimer");
			}
			
		});
		// ajouter un grid en position south
		getContentPane().add(btnAjouter, BorderLayout.SOUTH);
		//getContentPane().add(btnSupprimer, BorderLayout.SOUTH);

		getContentPane().add(tableau.getTableHeader(), BorderLayout.NORTH);
		getContentPane().add(tableau, BorderLayout.CENTER);

		tableau.addMouseListener(new MouseAdapter() {

			@Override
			public void mouseClicked(java.awt.event.MouseEvent e) {
				System.out.println(tableau.getSelectedRow());
			}
			
		});

		pack();
	}

	@Override
	public void actionPerformed(ActionEvent arg0) {
		System.out.println("Ajouter ligne ");
		String sport = JOptionPane.showInputDialog("Entrer le nom du sport");
		ArrayList<String> sports = modele.getSports();
		
		if (! sport.trim().equals("") && !sports.contains(sport.toUpperCase())) {
			// ajouter un sport du modèle de table et de la bdd
			sport = sport.substring(0,1).toUpperCase() + sport.substring(1).toLowerCase(); 
			modele.addRow(sport);
		}
		else{
			System.out.println("insertion impossible : nom du sport vide ou déjà présent");
		}
		

	}

}
