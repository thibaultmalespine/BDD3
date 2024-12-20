import java.io.FilterInputStream;
import java.sql.*;
import java.util.ArrayList;
import java.util.Scanner;
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author ngarric
 */
public class Tp3Etape2 {

	private static String URL = "jdbc:mysql://localhost:10002/jo";
	private static String login = "root";
	private static String password = "licinfo2020";
	private Connection connexion;
	private Statement stmt;
	private int nbDeChoix = 6;

	public Tp3Etape2() {
		try {
			// Etablisement de la connexion avec la base
			connexion = DriverManager.getConnection(URL, login, password);
			stmt = connexion.createStatement();
	
		} catch (SQLException c) {
			System.out.println("Connexion echouee ou base de donnees inconnue : " + c);
		} catch (Exception d) {
			System.out.println("Problème sur connexion");
		}

	}

	public void menu() {

		int res = -1;
		while (res != 0) {
			// on propose à l'utilisateur de choisir entre plusieurs options
			Scanner scan = new Scanner(System.in);
			do {
				System.out.println("Menu\n0=Fin\n1=Lister tous les sports\n2=Ajout d'un sport\n3=Récupérer la liste des sportifs d'un sport"+
									"\n4=Lister les sportifs qui ont gagnés une médaille d'or individuel\n5=Liste des équipes présentes et leurs membres"+
									"\n6=Supprimer un sportif à partir de son nom");
				res = scan.nextInt();
				if (res<0 || res > nbDeChoix) {
					System.out.println("mauvais choix! Recommencez.");
				}
			} while (res<0 || res > nbDeChoix);
		
			switch (res) {

			// affichage de tous les nomsde sports
			case 1:
				try {
					// on lance la requête
					String requete = "SELECT INTITULE FROM SPORT";
					ResultSet resultat = stmt.executeQuery(requete);

					System.out.println("Voici tous les noms de sports :");

					// on parcourt le résultat
					while (resultat.next()) {

						System.out.println(resultat.getString(1));
					}
					System.out.println();
				} catch (SQLException c) {
					System.out.println("Connexion echouee ou base de donnees inconnue : " + c);
				}
				break;
				
			// ajout d'un sport
			case 2:
				try {
					// saisie du nom du sport
					System.out.print("Entrer le nom du sport à ajouter : ");
					String nom = scan.next();
					
					
					PreparedStatement requetePreparee = connexion.prepareStatement("INSERT INTO SPORT(INTITULE) VALUES (?)"); 
					requetePreparee.setString(1,nom); 
					

					// on lance la requête
					requetePreparee.executeUpdate();
					System.out.println("Ajout réussi" );

				} catch (SQLException c) {
					System.out.println("Problème lors de l'ajout d'un sport: " + c);
				}
				break;
				
			// récupérer la liste des sportifs d'un sport
			case 3:
				try {
					// récupère le nom du sport
					System.out.print("Entrer le nom du sport : ");
					String nom = scan.next();
					
					// requete
					PreparedStatement requetePreparee = connexion.prepareStatement("SELECT nom, prenom FROM SPORTIF, SPORT WHERE SPORT.INTITULE = ? AND SPORT.CODE_SPORT = SPORTIF.CODE_SPORT");
					requetePreparee.setString(1, nom);

					ResultSet result = requetePreparee.executeQuery();
					System.out.println("Voici tous les noms des sportifs :");
					
					while(result.next()){
						System.out.println(result.getString(1)+" "+ result.getString(2));
					}
					System.out.println();
					

				} catch (Exception e) {
					System.out.println(e.getMessage());
				}
				break;
				
			// afficher le nom des sportifs qui ont une médaille d'or en individuel et dans quelle discipline
			case 4:
				try {
					ResultSet result = stmt.executeQuery("SELECT nom, prenom, INTITULE FROM SPORTIF, GAGNER_INDIVIDUEL, DISCIPLINE WHERE GAGNER_INDIVIDUEL.NUM_LICENCE = SPORTIF.NUM_LICENCE "+
														"AND GAGNER_INDIVIDUEL.MEDAILLE = 'Or' AND DISCIPLINE.CODE_SPORT = SPORTIF.CODE_SPORT AND GAGNER_INDIVIDUEL.CODE_DISCIPLINE = DISCIPLINE.CODE_DISCIPLINE");
					System.out.println("Voici tous les noms des sportifs qui ont gagnés une médaille d'or individuel:");
					while(result.next()){
						System.out.println(result.getString(1)+" "+ result.getString(2)+" : "+result.getString(3));
					}
					System.out.println();
				} catch (Exception e) {
					System.out.println(e.getMessage());
				}
				break;

			// Afficher la liste des équipes présentes et pour chacune le nom des joueurs qui la composent
			case 5:
				try {
					ArrayList<String> equipes = new ArrayList<>();

					PreparedStatement statement = connexion.prepareStatement("SELECT denomination FROM EQUIPE");
					ResultSet resultSet = statement.executeQuery();

					while (resultSet.next()) {
						equipes.add(resultSet.getString(1));
					}

					for (String equipe : equipes) {
						statement = connexion.prepareStatement("SELECT prenom, nom FROM SPORTIF, APPARTENIR_EQUIPE, EQUIPE "
															+ "WHERE denomination = ? AND EQUIPE.num_equipe = APPARTENIR_EQUIPE.num_equipe AND SPORTIF.num_licence = APPARTENIR_EQUIPE.num_licence");
						statement.setString(1, equipe);
						resultSet = statement.executeQuery();	

						System.out.print(equipe+", ");
						System.out.println("joueurs qui composent l'équipe : ");
						while (resultSet.next()) {
							System.out.print("	"+resultSet.getString(1)+" ");
							System.out.println(resultSet.getString(2));
						}
						System.out.println("");
					}
				} catch (Exception e) {
					System.out.println(e.getMessage());
				}
				break;

			// Permet de supprimer un sportif donné par son nom
			case 6:
				try {
			
			
					Scanner s = new Scanner(System.in);
					
					System.out.println("Entrer le nom du sportif à supprimer");
					String nom = s.nextLine();

					PreparedStatement statement = connexion.prepareStatement("DELETE FROM SPORTIF WHERE nom = ?");
					statement.setString(1, nom);
					if (statement.executeUpdate() == 0){
						System.out.println("le sportif n'a pas été trouvé dans la BDD");
					}
					else { System.out.println("le sportif a bien été supprimé");}

				
				} catch (Exception e) {
					System.out.println(e.getMessage());
				}
				break;
			}
				
		}
		// fermeture de la connexion
		try {
			connexion.close();
			System.out.println("Programme terminé");
		} catch (SQLException c) {
			System.out.println("Problème de fermeture de connexion: " + c);
		}

	}

	public static void main(String[] args) {
		Tp3Etape2 tp3Etape2 = new Tp3Etape2();
		tp3Etape2.menu();
	}
}