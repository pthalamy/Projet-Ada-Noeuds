with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;

with Pile;
use Pile;

package body Objets is
   
   procedure Put (S : Sommet) is       
      
      function Point2Str (P : Point) return String is 
      begin
	 return "(" & Float'Image (P.X) & ", " & Float'Image (P.Y) & " )";
      end Point2Str;      
      
   begin       
      Put_Line ("Position: " & Point2Str (S.Pos));
      Put_Line ("Sommets adjacents: ");
      -- Affichage du contenu de la pile
      Put (S.Voisins);
   end Put;
   
   procedure Put (T : Tab_Sommets) is            
   begin       
      for I in T'Range loop
	 Put_Line ("---- Sommet" & Integer'Image(Integer (I)) & " ----");
	 Put (T(I));
      end loop;
   end Put;
   
end Objets;
