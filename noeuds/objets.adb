with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;

with Liste;
use Liste;

package body Objets is

   function Point2Str (P : Point) return String is
   begin
      return "(" & Float'Image (P.X) & ", " & Float'Image (P.Y) & " )";
   end Point2Str;
   
   procedure Put (P : Point) is
   begin
      Put_Line (Point2Str (P));
   end Put;
   
   procedure Put (S : Sommet) is
   begin
      Put_Line ("Position: " & Point2Str (S.Pos));

      Put_Line ("Aretes adjacents: ");
      -- Affichage du contenu de la liste
      Put (S.Voisins);
   end Put;

   procedure Put (T : Tab_Sommets) is
   begin
      for S in T'Range loop
         Put_Line ("---- Sommet" & Integer'Image(Integer (S)) & " ----");
         Put (T(S));
      end loop;
   end Put;

   procedure Put (A : Arete) is
   begin
      Put_Line ("  Segment : [" & 
		  Integer'Image (Natural (A.MonId)) & ", " & 
		  Integer'Image (Natural (A.OppId)) & " ]");
      Put_Line ("  Longueur: " & Float'Image (A.Longueur));
      Put_Line ("  Milieu: " & Point2Str(A.Milieu));
      Put_Line ("Mes Points de controle: ");
      Put_Line ("  Sens Trigonométrique: ");
      Put_Line (Point2Str (A.MyPDC.Trig));
      Put_Line ("  Sens Inverse: ");
      Put_Line (Point2Str (A.MyPDC.Inv));      
      Put_Line ("Points de controle d'en face: ");
      Put_Line ("  Sens Trigonométrique: ");
      Put_Line (Point2Str (A.OppPDC.Trig));
      Put_Line ("  Sens Inverse: ");
      Put_Line (Point2Str (A.OppPDC.Inv));      

   end Put;

end Objets;
