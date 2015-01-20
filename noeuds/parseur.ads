with Objets, Ada.Text_IO;
use Objets, Ada.Text_IO;

package Parseur is
   
   Erreur_Lecture, Nombre_Sommets_Nul, 
     Nombre_Voisins_Nul, Kn_Mal_Formate : exception;
   
   -- requiert : Nom_Fichier nom de fichier existant et bien formatté
   -- garantit : Nombre de sommets lus dans le fichier
   procedure Lecture_Nombre_Sommets (Nom_Fichier : in String;
				     Nb_Sommets : out Indice);
   
   -- requiert : Tab Sommets tableau de taille non vide et = Nb_Sommets
   -- garantit : Tableau de sommets remplis des données lues dans le fichier
   procedure Lecture (Nom_Fichier : in String; 
		      T : in out Tab_Sommets);
   
end Parseur;
