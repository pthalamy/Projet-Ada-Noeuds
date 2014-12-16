with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

with Objet_Packing;
use Objet_Packing;

package body Svg is

   type Color is (Violet, Indigo, Bleu, Vert, Jaune, Orange, Rouge, Noir, Blanc);

   Display_Width, Display_Height : Natural;
   Fichier_Svg : File_Type;

   function Code_Couleur (C : Color) return String is
   begin
      case C is
         when Violet  => return "rgb(255,0,255)";
         when Indigo  => return "rgb(111,0,255)";
         when Bleu  => return "rgb(0,0,255)";
         when Vert  => return "rgb(0,255,0)";
         When Jaune => return "rgb(0,255,255)";
         When Jaune => return "rgb(255,165,0)";
         when Rouge => return "rgb(255,0,0)";
         when Noir  => return "rgb(0,0,0)";
         when Blanc => return "rgb(255,255,255)";
      end case;
   end Code_Couleur;

   -- ! A appeler avant toute ecriture dans le fichier svg !
   -- garantit : Insere le header svg dans Fichier_Svg.
   procedure Svg_Header (Largeur, Hauteur : Natural) is
   begin
      Put (Fichier_Svg, "<svg width=""");
      Put (Fichier_Svg, Largeur);
      Put (Fichier_Svg, """ height=""");
      Put (Fichier_Svg, Hauteur);
      Put_Line (Fichier_Svg, """>");

      Display_Width := Largeur;
      Display_Height := Hauteur;
   end Svg_Header;


   -- ! A appeler pour clore le fichier svg !
   -- garantit : Insere le footer svg dans Fichier_Svg.
   procedure Svg_Footer is
   begin
      Put_Line (Fichier_Svg, "</svg>");
   end Svg_Footer;

   -- Dessing une ligne A -- B
   procedure Svg_Line (A, B : Point;
                       C : Color)
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

      Put (Fichier_Svg, Code_Couleur (C));

      Put_Line (Fichier_Svg, ";stroke-width:1""/>");
   end Svg_Line;


   -- Dessine un rectangle de la forme:
   --              A/O ---- B
   --               |      |
   --               D ---- C
   -- et de couleur C.
   procedure Svg_Rectangle (O : Point;
                            Largeur, Hauteur : Natural;
                            C : Color)
   is
   begin
      Put (Fichier_Svg, "<rect ");
      Put (Fichier_Svg, "x=""" & Integer'Image(O.X) & """ ");
      Put (Fichier_Svg, "y=""" & Integer'Image(O.Y) & """ ");
      Put (Fichier_Svg, "width=""" & Integer'Image(Largeur) & """ ");
      Put (Fichier_Svg, "height=""" & Integer'Image(Hauteur) & """ ");
      Put (Fichier_Svg, "style=""fill:" & Code_Couleur (C) & ";"
             & "stroke-width:0;"
             & "stroke:" & Code_Couleur (Noir));
      Put_Line (Fichier_Svg, """/>");
   end Svg_Rectangle;

   procedure Sauvegarde (Nom_Fichier_Svg : String;
                         Objets : Tableau_Objets;
                         Largeur_Ruban : Natural;
                         Hauteur_Ruban : Natural) is
   begin
      -- Ouverture du fichier
      Open (File => Fichier_Svg,
            Mode => Out_File,
            Name => Nom_Fichier_Svg);

      Svg_Header (Largeur_Ruban, Hauteur_Ruban);

      Svg_Rectangle ((10, 10), 150, 75, Rouge);

      Svg_Footer;
   end Sauvegarde;

end Svg;
