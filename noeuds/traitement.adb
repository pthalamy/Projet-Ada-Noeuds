with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
with Ada.Numerics.Elementary_Functions;

use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
use Ada.Numerics.Elementary_Functions;

with Objets, Liste, Pile;
use Objets, Liste, Pile;

package body Traitement is

   procedure Generer_Arretes (T : in out Tab_Sommets;
                              L : in out Liste_Arretes)
   is
      ArreteCour : Arrete;
      V : Indice;
   begin
      -- Création d'un pour chaque couple d'indice de sommet
      -- De l'arrête correspondante
      for I in reverse T'Range loop
         while not Vide (T(I).Voisins) loop
            -- Recuperation de l'indice du voisin
            Pop (T(I).Voisins, V);
            -- Création de l'arrête et ajout à la liste
            ArreteCour := Arrete'(S1 => I,
                                  S2 => V,
                                  Longueur => 0.0,
                                  Milieu => (others => 0.0),
                                  PDC => (others =>
                                            (others => (others => 0.0))) );
            Enqueue (L, ArreteCour);
            -- Elimination de la redondance dans la pile du voisin
            Pop (T(V).Voisins, V); -- V sert de "poubelle"
         end loop;
      end loop;

   end Generer_Arretes;

   procedure Calculer_Points_De_Controle (T : in out Tab_Sommets;
                                          L : in out Liste_Arretes)
   is

      procedure Generer_Croix (A : in out Arrete) is
         Alpha : Float; -- Angle ^LR
         Base : constant Float := 360.0; -- Nous utilisons des degrés

         R : Point := T(A.S1).Pos;
         L : Point := T(A.S2).Pos;
         M : Point := A.Milieu;
         DY : Float;
	 
	 function Calcul_PDC (Rot, Fact : Float) return Point is 
	    Ret : Point;
	 begin
	    Ret.X := M.X + Fact * (Cos (Rot, Base) * (L.X - M.X) 
				     - Sin (Rot, Base) * (L.Y - M.Y));
	    Ret.Y := M.Y + Fact * (Sin (Rot, Base) * (L.X - M.X)
				     + Cos (Rot,Base) * (L.Y - M.Y));
	    return Ret;
	 end Calcul_PDC;
	 
      begin

         DY := abs (R.Y - L.Y);

         if R.X > L.X then
            Alpha := Arcsin (DY / A.Longueur, Base);
         else
            Alpha := 360.0 - Arcsin (DY / A.Longueur, Base);
         end if;

         A.PDC.Trig(1) := Calcul_PDC (45.0, (1.0 / 2.0));
         A.PDC.Trig(2) := Calcul_PDC (225.0, (1.0 / 2.0));
         A.PDC.Inv(1) := Calcul_PDC (45.0 + 90.0, (1.0 / 2.0));
         A.PDC.Inv(2) := Calcul_PDC (225.0 + 90.0, (1.0 / 2.0));
	 
      end Generer_Croix;

      procedure Calculer_Longueur (A : in out Arrete) is

         function Hypotenuse (A, B : Float) return Float is
         begin
            return sqrt(A**2 + B**2);
         end Hypotenuse;

         DX, DY : Float; -- Différentiels en X et Y
         R : Point := T(A.S1).Pos;
         L : Point := T(A.S2).Pos;
      begin
         DX := abs (R.X - L.X);
         DY := abs (R.Y - L.Y);

         A.Longueur := Hypotenuse (DX, DY);
         A.Milieu.X := L.X + ((R.X - (L.X)) / 2.0);
         A.Milieu.Y := L.Y + ((R.Y - (L.Y)) / 2.0);
      end Calculer_Longueur;

      Cour : PointeurA := L.Tete;
   begin
      while Cour /= null loop
         Calculer_Longueur (Cour.Val);
         Generer_Croix (Cour.Val);
         Cour := Cour.Suiv;
      end loop;
   end Calculer_Points_De_Controle;

end Traitement;
