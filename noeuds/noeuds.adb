with Ada.Text_IO, Ada.Command_Line;
use Ada.Text_IO, Ada.Command_Line;

with Objets, Svg, Liste, Parseur, Traitement;
use Objets, Liste;

with Ada.Numerics.Elementary_Functions, Ada.Float_Text_IO;
use Ada.Numerics.Elementary_Functions, Ada.Float_Text_IO;

procedure Noeuds is
   Nb_Args_Invalide : exception;
   Nb_Sommets : Indice;
   
   function Calcul_Angle (SCour, SOpp, SCand : Point;
			  Trig : Boolean) return Float 
   is
      
      Angle : Float;
      LScour_Sopp :Float;
      LSOpp_Scand:Float;
      LScand_Scour:Float;
      Base : constant Float := 360.0;
      Interm : Float;
   begin
            
      LScour_Sopp := sqrt((SCour.X-SOpp.X)**2 + (SCour.Y-SOpp.Y)**2);
      
      LSopp_Scand := sqrt((SOpp.X-SCand.X)**2 + (SOpp.Y-SCand.Y)**2);
      
      LScand_Scour := sqrt((Scour.X-SCand.X)**2 + (Scour.Y-Scand.Y)**2);	    
      
      --  Interm := ((SCour.X-SOpp.X)*(SCand.X-SOpp.X) +
      --  		 (Scour.Y-SOpp.Y)*(SCand.Y-SOpp.Y)) /
      --    (LScour_Sopp*LSopp_Scand);	    	    	    
      
      Interm := ((LScour_Sopp)**2 + (LScand_Scour)**2 - (LSopp_Scand)**2)
	/ (2.0 * LScour_Sopp * LSopp_Scand);
      
      Angle := Arccos (Interm , Base);
      
      if Trig then
	 return Angle;
      else 
	 return 360.0 - Angle;
      end if;
   end Calcul_Angle;
   
begin

   if Argument_Count /= 2 then
      raise Nb_Args_Invalide;
   end if;

   Parseur.Lecture_Nombre_Sommets (Argument(1), Nb_Sommets);

   Put_Line ("Nombre de sommets: " & Integer'Image(Integer (Nb_Sommets)));

   declare
      Sommets : Tab_Sommets (1..Nb_Sommets);
   begin
      Parseur.Lecture (Argument(1), Sommets);

      Traitement.Calculer_Points_De_Controle (Sommets);
      
      Svg.Sauvegarde(Argument(2), Sommets);
      
      Put (Calcul_Angle ((0.0,0.0), (1.0,0.0), (0.0,1.0), True));
   end;
      
exception
   when Parseur.Kn_Mal_Formate =>
      Put_Line (Standard_Error,
		"erreur: Fichier Kn erroné.");
   when Nb_Args_Invalide =>
      Put_Line(Standard_Error, "utilisation : noeuds data.kn out.svg");
end Noeuds;
