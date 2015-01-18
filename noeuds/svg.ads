with Objets;
use Objets;

package Svg is

   type GrilleSVG is record
      Largeur : Float;
      Hauteur : Float;
   end record;

   Image : GrilleSVG;

   procedure Sauvegarde (Nom_Fichier_Svg : in String;
                         T : in out Tab_Sommets;
                         L : in out Liste_Arretes);
end Svg;
