with Objets, Pile;
use Objets, Pile;

package Parseur is
   
   Erreur_Lecture, Nombre_Sommets_Nul : exception;
   
     -- requiert : Nom_Fichier nom de fichier existant et bien formatté
     -- garantit : Nombre de sommets lus dans le fichier
   procedure Lecture_Nombre_Sommets (Nom_Fichier : in String;
				     Nb_Sommets : out Natural) 
   
   -- requiert : Tab Sommets tableau de taille non vide et = Nb_Sommets
   -- garantit : Tableau de sommets remplis des données lues dans le fichier
   procedure Lecture (T : in out Tab_Sommets);
   
private
   Fichier_Kn : File_Type;
   
end Parseur;
