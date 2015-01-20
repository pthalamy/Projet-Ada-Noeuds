with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
with Ada.Numerics.Elementary_Functions;

use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
use Ada.Numerics.Elementary_Functions;

with Objets, Liste;
use Objets, Liste;

package body Traitement is

   procedure Calculer_Points_De_Controle (T : in out Tab_Sommets)
   is

      procedure Generer_Croix (SCour, SOpp: in Point;
			       A : in out Arrete) is
	 
         Base : constant Float := 360.0; -- Nous utilisons des degrés
         M : Point := A.Milieu;

	 --  La procedure permet le calcul des coordonnees d'un point ayant subit une rotation d'angle Rot et de centre M suivit d'une homothétie de rapport Fact
	 function Calcul_PDC (Rot, Fact : Float) return Point is 
	    Ret : Point;
	 begin
	    Ret.X := M.X + Fact * (Cos (Rot, Base) * (Sopp.X - M.X) 
				     - Sin (Rot, Base) * (Sopp.Y - M.Y));
	    Ret.Y := M.Y + Fact * (Sin (Rot, Base) * (Sopp.X - M.X)
				     + Cos (Rot,Base) * (Sopp.Y - M.Y));
	    return Ret;
	 end Calcul_PDC;
	 
      begin
	    A.OppPDC.Inv := Calcul_PDC (45.0, (1.0 )); 
	    A.MyPDC.Inv := Calcul_PDC (225.0, (1.0 )); 
	    A.MyPDC.Trig := Calcul_PDC (45.0 + 90.0, (1.0 ));
	    A.OppPDC.Trig := Calcul_PDC (225.0 + 90.0, (1.0 ));
      end Generer_Croix;

      procedure Calculer_Longueur (SCour, SOpp: in Point;
				     A : in out Arrete) 
      is

         function Hypotenuse (A, B : Float) return Float is
         begin
            return sqrt(A**2 + B**2);
         end Hypotenuse;

         DX, DY : Float; -- Différentiels en X et Y
      begin
         DX := abs (SCour.X - SOpp.X);
         DY := abs (SCour.Y - SOpp.Y);

         A.Longueur := Hypotenuse (DX, DY);
         A.Milieu.X := SOpp.X + ((SCour.X - (SOpp.X)) / 2.0);
         A.Milieu.Y := SOpp.Y + ((SCour.Y - (SOpp.Y)) / 2.0);
      end Calculer_Longueur;

      Cour : Pointeur;
   begin
      for I in T'Range loop
         Cour := T(I).Voisins.Tete;
         while Cour /= null loop
            Calculer_Longueur (T(I).Pos, T(Cour.Ind).Pos, Cour.A.all);
            Generer_Croix (T(I).Pos, T(Cour.Ind).Pos, Cour.A.all);
            Cour := Cour.Suiv;
         end loop;
      end loop;
   end Calculer_Points_De_Controle;

end Traitement;
