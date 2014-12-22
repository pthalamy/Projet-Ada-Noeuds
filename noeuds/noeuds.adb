with Ada.Text_IO, Ada.Command_Line;
use Ada.Text_IO, Ada.Command_Line;

with Objects, Svg, Liste, Parseur;
use Objects, Liste;

-- Idée: Remplacer la liste par un tableau contenant les sommets rangés par indice
-- +> Accés plus simple aux coordonnées.
-- Remplacer tab_ptr par liste / tableau contenant Indice vosin + bool "tracé" ? 

procedure Noeuds is
   Nb_Sommets : Natural;
begin

   if Argument_Count /= 1 then
      Put_Line(Standard_Error, "utilisation : noeuds data.kn");
      return;
   end if;

   declare
      Sommets : Liste_Sommets := Liste_Sommets'(null, null);
   begin
      Parseur.Lecture(Argument(1), Sommets, Nb_Sommets);
      Put_Line ("Nombre de sommets: " & Integer'Image(Nb_Sommets));
      Put (Sommets);
      
      --  Packing.Next_Fit_Decreasing_Height(Objets, Largeur_Ruban, Hauteur_Ruban);
      --  Svg.Sauvegarde(Argument(2), Objets, Largeur_Ruban, Hauteur_Ruban);
   end;

end Noeuds;
