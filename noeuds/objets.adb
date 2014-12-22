with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;

package body Objets is
   
   procedure Put (S : Sommet) is 
      
      function Point2Str (P : Point) return String is 
      begin
	 return "(" & Float'Image (P.X) & ", " & Float'Image (P.Y) & " )";
      end Point2Str;
      
   begin 
      
      Put_Line ("---- Sommet" & Integer'Image(S.Indice) & " ----");
      Put_Line ("Position: " & Point2Str (S.Pos));
      Put_Line ("Nombre d'arrètes adjacentes: " 
		  & Integer'Image(S.Nb_Arretes) );
      Put_Line ("Sommets adjacents: ");
      
      for I in S.Voisins.all'Range loop
	 Put (S.Voisins.all(I));	
      end loop;    
   end Put;
   
end Objets;
