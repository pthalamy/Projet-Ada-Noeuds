with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;

with Liste;
use Liste;

package body Objets is

   function Point2Str (P : Point) return String is
   begin
      return "(" & Float'Image (P.X) & ", " & Float'Image (P.Y) & " )";
   end Point2Str;

   procedure Put (S : Sommet) is
   begin
      Put_Line (Point2Str (Point (S)));
   end Put;

   procedure Put (T : Tab_Sommets) is
   begin
      for S in T'Range loop
         Put_Line ("---- Sommet" & Integer'Image(Integer (S)) & " ----");
         Put (T(S));
      end loop;
   end Put;

   procedure Put (A : Arrete) is
   begin
      New_Line;
      Put_Line ("Arrete : [S" & Integer'Image (Natural (A.S1)) & ", S"
                  & Integer'Image (Natural (A.S2)) & "]");
      Put_Line ("Longueur: " & Float'Image (A.Longueur));
      Put_Line ("Points de controle: "
                  & Point2Str(A.PDC.C1) & ", "
                  & Point2Str(A.PDC.C2) & ", "
                  & Point2Str(A.PDC.C3) & ", "
                  & Point2Str(A.PDC.C4) );
   end Put;



end Objets;
