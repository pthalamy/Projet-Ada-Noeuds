with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
with Ada.Numerics.Elementary_Functions;

use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
use Ada.Numerics.Elementary_Functions;

with Objets, Liste;
use Objets, Liste;

package body Traitement is
   
   -- Calcule et stocke les coordonnées des points de contrôles 
   --  pour tous les sommets de T
   procedure Stocker_Points_De_Controle (T : in out Tab_Sommets)
   is
      
      -- Calcule les coordonnées des points de contrôle pour une arrete A
      procedure Calculer_Croix (SCour, SOpp: in Point;
			       A : in out Arrete) is
	 
         Base : constant Float := 360.0; -- Nous utilisons des degrés
         M : Point := A.Milieu;

	 --  La procedure permet le calcul des coordonnees d'un point ayant subit une rotation d'angle Rot et de centre M suivit d'une homothétie de rapport Fact
	 function PDC (Rot, Fact : Float) return Point is 
	    Ret : Point;
	 begin
	    Ret.X := M.X + Fact * (Cos (Rot, Base) * (Sopp.X - M.X) 
				     - Sin (Rot, Base) * (Sopp.Y - M.Y));
	    Ret.Y := M.Y + Fact * (Sin (Rot, Base) * (Sopp.X - M.X)
				     + Cos (Rot,Base) * (Sopp.Y - M.Y));
	    return Ret;
	 end PDC;
	 
      begin
	    A.OppPDC.Inv := PDC (45.0, (1.0 )); 
	    A.MyPDC.Inv := PDC (225.0, (1.0 )); 
	    A.MyPDC.Trig := PDC (45.0 + 90.0, (1.0 ));
	    A.OppPDC.Trig := PDC (225.0 + 90.0, (1.0 ));
      end Calculer_Croix;
      
      -- Calcule la longueur de l'arrete SCour--Opp et détermine son milieu
      -- Stocke le resultat en attribut de A
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
            Calculer_Croix (T(I).Pos, T(Cour.Ind).Pos, Cour.A.all);
            Cour := Cour.Suiv;
         end loop;
      end loop;
   end Stocker_Points_De_Controle;
   
   -- Calcul l'angle entre les arretes Scour---SOpp et SCour---SCand
   -- Dans le sens trigo si Trig = True, sens inverse sinon
   function Calcul_Angle (SCour, SOpp, SCand : Point;
			  Trig : Boolean) return Float
   is
      
      Angle : Float;
      LScour_Sopp :Float; --  Longueur de l'arrete courante
      LSOpp_Scand:Float; --  Distance entre le sommet opposé
			 -- de l'arrete courante et le sommet candidat
      LScand_Scour:Float; --  Longueur de l'arrete candidate
      Base : constant Float := 360.0;
      Interm : Float; -- Calcul intermediaire de l'arg du arccos
      Determinant:Float; --  Determinant des vecteurs 
			 -- (Scour_Sopp,Scour_Scand)
      
      -- Renvoie 1.0 si Exp positif, -1.0 sinon
      function Signe (Exp : Float) return Float is
      begin
	 if Exp > 0.0 then
	    return 1.0;
	 else
	    return -1.0;
	 end if;
      end Signe;
      
   begin
      
      LScour_Sopp := sqrt((Sopp.X-Scour.X)**2 + (Sopp.Y-Scour.Y)**2);
      
      LSopp_Scand := sqrt((SOpp.X-SCand.X)**2 + (SOpp.Y-SCand.Y)**2);
      
      LScand_Scour := sqrt((Scand.X-SCour.X)**2 + (Scand.Y-Scour.Y)**2);	
      
      Determinant := ((Sopp.X-Scour.X)*(Scand.Y-Scour.Y) - 
			(Sopp.Y-Scour.Y)*(Scand.X-Scour.X));
      
      Interm := ((Sopp.X-Scour.X)*(SCand.X-Scour.X) +
		   (Sopp.Y-Scour.Y)*(SCand.Y-Scour.Y)) /
	(LScour_Sopp*LScand_Scour);	    	    	    
      
      
      Angle := Arccos (Interm , Base) * Signe (Determinant);
      
      if Angle < 0.0 then
	 Angle := 360.0 + Angle;
      end if;
      
      if Trig then
	 return Angle;
      else 
	 return 360.0 - Angle;
      end if;
   end Calcul_Angle;
   
   -- Trouve l'arrete cible (SCour..SCible) à partir de 
   --  l'arrete courante (SCour..SOpp) pour le tracé des noeuds   
   procedure Trouve_Cible (T : in out Tab_Sommets;
			   SCour, SCand, SOpp, SCible : in out Indice;
			   AngleCour, AngleExt : in out Float;
			   VCour : in out Pointeur;
			   ArreteCible : out Arrete;
			   Trig, Min : in Boolean) is
      
      -- Recupere l'arrete SCible..SCour dans la liste de voisins de SCible
      procedure Recupere_ArreteCible is
	 Local_Cour : Pointeur := T(SCible).Voisins.Tete;
      begin
	 while Local_Cour /= null loop
	    if Local_Cour.Ind = SCour then
	       ArreteCible := Local_Cour.A.all;
	       return; 
	    end if;
	    Local_Cour := Local_Cour.Suiv;
	 end loop;
      end Recupere_ArreteCible;
      
      Arrete_Unique : exception; -- Le sommet courant n'a qu'un voisin
   begin 
      if VCour.Suiv = null then
	 raise Arrete_Unique; 
      end if;		
      
      while VCour /= null loop
	 SCand := VCour.Ind;
	 
	 if SCand /= SOpp then
	    
	    AngleCour := Calcul_Angle (T(SCour).Pos, 
				       T(SOpp).Pos, 
				       T(SCand).Pos,
				       Trig);
	    
	    if Min then
	       if AngleCour < AngleExt then
		  AngleExt := AngleCour;
		  SCible := SCand;
	       end if;
	    else
	       if AngleCour > AngleExt then
		  AngleExt := AngleCour;
		  SCible := SCand;
	       end if;	       
	    end if;
	 end if;
	 
	 VCour := VCour.Suiv;
      end loop;

      Recupere_ArreteCible; 
      
   exception
      when Arrete_Unique =>
	 SCible := VCour.Ind;

	 Recupere_ArreteCible;
   end Trouve_Cible;

   
end Traitement;
