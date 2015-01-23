with Objets;
use Objets;

package Svg is
   
   -- Objet représentant les dimensions d'une grille svg
   type GrilleSVG is record
      Largeur : Float;
      Hauteur : Float;
   end record;

   Image : GrilleSVG;
   
   -- Procedure unique permettant de generer le tracé 
   --  de tous les elements de l'image
   procedure Sauvegarde (Nom_Fichier_Svg : in String;
                         T : in out Tab_Sommets;
			 Min : in Boolean);
end Svg;
