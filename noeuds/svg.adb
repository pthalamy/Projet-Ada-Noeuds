with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
with Ada.Numerics.Elementary_Functions;

use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
use Ada.Numerics.Elementary_Functions;

with Objets, Pile;
use Objets, Pile;

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
   
   function Hypotenuse (A, B : Float) return Float is
   begin
      return sqrt(A**2 + B**2);
   end Hypotenuse;
   
   procedure Sauvegarde (Nom_Fichier_Svg : in String;
                         T : in out Tab_Sommets)
   is
      Fichier_Svg : File_Type;
      
      -- ! A appeler avant toute ecriture dans le fichier svg !
      -- garantit : Insere le header svg dans le fichiersvg.
      procedure Svg_Header is
      begin
	 Put (Fichier_Svg, "<svg width=""");
	 --  Put (Fichier_Svg, Affichage.Largeur);
	 Put (Fichier_Svg, "100");
	 Put (Fichier_Svg, """ height=""");
	 --  Put (Fichier_Svg, Affichage.Hauteur);
	 Put (Fichier_Svg, "100");
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

	 Put_Line (Fichier_Svg, ";stroke-width:0.02""/>");
      end Svg_Line;
            
      -- TODO : Tracer croix
      procedure Trace_Croix (L, R : Point)is
      	 LR : Float; -- Longueur du segment L-R
      	 DX, DY : Float; -- Différentiels en X et Y
      	 Milieu : Point; -- Milieu du segment
	 A, B, C, D : Point; -- extrémités des segments de croix
	 Alpha : Float; -- Angle ^LR
	 Base : constant Float := 360.0; -- Nous utilisons des degrés
      begin
      	 DX := abs (R.X - L.X);
      	 DY := abs (R.Y - L.Y);
      	 LR := Hypotenuse (DX, DY);
	 
	 if R.X > L.X then 
	    Alpha := Arcsin (DY / LR, Base);
	 else 
	    Alpha := 360.0 - Arcsin (DY / LR, Base);
	 end if;

	 New_Line; 
	 Put (LR); New_Line; 
	 Put (Alpha); New_Line;
	 
	 Put_Line ("L.X=" & Float'Image(L.X)
		     & " L.Y=" & Float'Image(L.Y));
	 
	 Put_Line ("R.X=" & Float'Image(R.X)
		     & " R.Y=" & Float'Image(R.Y));
	 
      	 Milieu.X := L.X + ((R.X - (L.X)) / 2.0);
      	 Milieu.Y := L.Y + ((R.Y - (L.Y)) / 2.0);
	 
	 Put_Line ("Milieu.X=" & Float'Image(Milieu.X)
		  & " Milieu.Y=" & Float'Image(Milieu.Y));
	 
	 A := Point'( Milieu.X + (Cos (Alpha + 45.0, Base))*(LR / 4.0), 
		      Milieu.Y + (Sin (Alpha + 45.0, Base))*(LR / 4.0) );
	 B := Point'( Milieu.X + (Cos (Alpha + 225.0, Base))*(LR / 4.0), 
		      Milieu.Y + (Sin (Alpha + 225.0, Base))*(LR / 4.0) );
	 Svg_Line (A, B);
	 C := Point'( Milieu.X + (Cos (Alpha + 135.0, Base))*(LR / 4.0), 
		      Milieu.Y + (Sin (Alpha + 135.0, Base))*(LR / 4.0) );
	 D := Point'( Milieu.X + (Cos (Alpha + 315.0, Base))*(LR / 4.0),
		      Milieu.Y + (Sin (Alpha + 315.0, Base))*(LR / 4.0) );
	 Svg_Line (C, D);	
      end Trace_Croix;
		    
      V : Indice;
   begin
      Create (File => Fichier_Svg,
	    Mode => Out_File,
	    Name => Nom_Fichier_Svg);
      
      Svg_Header;      
      
      
      -- Tracé pour chaque couple d'indice
      for I in reverse T'Range loop
	 -- Tant que la pile du sommet courant n'est pas vide, 
	 -- tracé est mis a jour des piles
	 while not Vide (T(I).Voisins) loop
	    -- Recuperation de l'indice du voisin
	    Pop (T(I).Voisins, V);
	    -- Tracé du segment
	    Svg_Line (T(I).Pos, T(V).Pos);
	    -- TODO: Puis de la croix
	    Trace_Croix (T(I).Pos, T(V).Pos);
	    -- Elimination de la redondance dans la pile du voisin
	    Pop (T(V).Voisins, V); -- V sert de "poubelle"
	 end loop;
      end loop;
      
      Svg_Footer;      
      
      Close (Fichier_Svg);            
   end Sauvegarde;
   
end Svg;
