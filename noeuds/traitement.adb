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
      
      --  procedure Generer_Croix is
      --  	 A, B, C, D : Point; -- extrémités des segments de croix
      --  	 Alpha : Float; -- Angle ^LR
      --  	 Base : constant Float := 360.0; -- Nous utilisons des degrés
      --  begin
      
      --  	 if R.X > L.X then 
      --  	    Alpha := Arcsin (DY / LR, Base);
      --  	 else 
      --  	    Alpha := 360.0 - Arcsin (DY / LR, Base);
      --  	 end if;
      
      --  	 A := Point'( Milieu.X + (Cos (Alpha + 45.0, Base))*(LR / 4.0), 
      --  		      Milieu.Y + (Sin (Alpha + 45.0, Base))*(LR / 4.0) );
      --  	 B := Point'( Milieu.X + (Cos (Alpha + 225.0, Base))*(LR / 4.0), 
      --  		      Milieu.Y + (Sin (Alpha + 225.0, Base))*(LR / 4.0) );

      --  	 C := Point'( Milieu.X + (Cos (Alpha + 135.0, Base))*(LR / 4.0), 
      --  		      Milieu.Y + (Sin (Alpha + 135.0, Base))*(LR / 4.0) );
      --  	 D := Point'( Milieu.X + (Cos (Alpha + 315.0, Base))*(LR / 4.0),
      --  		      Milieu.Y + (Sin (Alpha + 315.0, Base))*(LR / 4.0) );

      --  end Generer_Croix;

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
	 Cour := Cour.Suiv;
      end loop;
   end Calculer_Points_De_Controle;
   
end Traitement;
