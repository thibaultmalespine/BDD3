import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.util.ArrayList;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTable;

public class Tp3Etape4 extends JFrame implements ActionListener {
	private JTable tableau;
	private MonModeleDeTable modele;
	private String codeSport;

	public Tp3Etape4() {
		super();

		setTitle("JTable avec tous les sports");
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setLayout(new BorderLayout());

		modele = new MonModeleDeTable(this);
		tableau = new JTable(modele);

		JButton btnAjouter = new JButton("Ajouter");
		JButton btnSupprimer = new JButton("Supprimer");

		btnAjouter.addActionListener(this);
		btnSupprimer.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				// à compléter
				if (codeSport != null) {
					modele.removeRow(codeSport);
					codeSport = null;
				} else {
					JOptionPane.showMessageDialog(null, "Selectionnez d'abord un sport !");
				}

			}
			
		});
		// Gestionnaire de placement en grille pour les boutons
		GridLayout gridLayout = new GridLayout(1,2);
		// JPanel qui contient le GridLayout
		JPanel gridPanel = new JPanel(gridLayout);
		gridPanel.add(btnAjouter);
		gridPanel.add(btnSupprimer);
		// ajout des boutons en position sud via le JPanel
		getContentPane().add(gridPanel, BorderLayout.SOUTH);

		getContentPane().add(tableau.getTableHeader(), BorderLayout.NORTH);
		getContentPane().add(tableau, BorderLayout.CENTER);

		tableau.addMouseListener(new MouseAdapter() {

			@Override
			public void mouseClicked(java.awt.event.MouseEvent e) {
				codeSport = (String) tableau.getModel().getValueAt(tableau.getSelectedRows()[0], 0);
				if (e.getClickCount() == 2) {
					String listeSportif = ""; 
					for(String[] sportif : modele.getSportifs(codeSport)){
						listeSportif += sportif[0] +" "+ sportif[1] + "\n";
					};
					if (listeSportif.equals("")) {
						JOptionPane.showMessageDialog(null,"Aucun sportif dans ce sport"); 
					} else {
						JOptionPane.showMessageDialog(null,listeSportif); 
					}
					
				}
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
