with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;

with Objets;
use Objets;

package body Svg is
   
   type Color is (Violet, Indigo, Bleu, Vert, Jaune, Orange, Rouge, Noir, Blanc);  

   function Code_Couleur (C : Color) return String is
   begin
      case C is
         when Violet  => return "rgb(255,0,255)";
         when Indigo  => return "rgb(111,0,255)";
         when Bleu  => return "rgb(0,0,255)";
         when Vert  => return "rgb(0,255,0)";
         When Jaune => return "rgb(0,255,255)";
         When Orange => return "rgb(255,165,0)";
         when Rouge => return "rgb(255,0,0)";
         when Noir  => return "rgb(0,0,0)";
         when Blanc => return "rgb(255,255,255)";
      end case;
   end Code_Couleur;
   
   procedure Sauvegarde (Nom_Fichier_Svg : in String;
                         L : in Liste_Sommets)
   is
      Fichier_Svg : File_Type;
      
      -- ! A appeler avant toute ecriture dans le fichier svg !
      -- garantit : Insere le header svg dans le fichiersvg.
      procedure Svg_Header is
      begin
	 Put (Fichier_Svg, "<svg width=""");
	 Put (Fichier_Svg, Affichage.Largeur);
	 Put (Fichier_Svg, """ height=""");
	 Put (Fichier_Svg, Affichage.Hauteur);
	 Put_Line (Fichier_Svg, """>");
      end Svg_Header;

      -- ! A appeler pour clore le fichier svg !
      -- garantit : Insere le footer svg dans le fichier svg.
      procedure Svg_Footer is
      begin
	 Put_Line (Fichier_Svg, "</svg>");
      end Svg_Footer;
      
      -- Dessine une ligne A -- B
      procedure Svg_Line (A, B : Point)
      is
      begin
	 Put (Fichier_Svg, "<line x1=""");
	 Put (Fichier_Svg, A.X);
	 Put (Fichier_Svg, """ y1=""");
	 Put (Fichier_Svg, A.Y);
	 Put (Fichier_Svg, """ x2=""");
	 Put (Fichier_Svg, B.X);
	 Put (Fichier_Svg, """ y2=""");
	 Put (Fichier_Svg, B.Y);
	 Put (Fichier_Svg, """ style=""stroke:");

	 Put (Fichier_Svg, Code_Couleur (Noir));

	 Put_Line (Fichier_Svg, ";stroke-width:1""/>");
      end Svg_Line;
      
   begin
      Create (File => Fichier_Svg,
	    Mode => Out_File,
	    Name => Nom_Fichier_Svg);
      
      Svg_Header;      
      
      Svg_Footer;      
      
      Close (Fichier_Svg);            
   end Sauvegarde;
   
end Svg;
