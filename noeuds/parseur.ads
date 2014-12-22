with Objects, Liste;
use Objects, Liste;

package Parseur is
   
   Erreur_Lecture, Nombre_Sommets_Nul : exception;
   
   -- requiert : Nom_Fichier nom de fichier existant et bien formatté
   -- garantit : Objets rempli d'objets de dimension et indice
   --            lus dans le fichier.
   procedure Lecture (Nom_Fichier : in String; 
		      L : in out Liste_Sommets;
		      Nb_Sommets : out Natural);

end Parseur;
