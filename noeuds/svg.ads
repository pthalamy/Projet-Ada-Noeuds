with Objets;
use Objets;

package Svg is
   
   type Image is record
      Largeur : Float;
      Hauteur : Float;
   end record;
   
   Affichage : Image;
   Marge_Affichage : constant Float := 10.0;
   
   procedure Sauvegarde (Nom_Fichier_Svg : in String;
                         T : in out Tab_Sommets);
end Svg;
