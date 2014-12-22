with Ada.Text_IO, Ada.Command_Line;
use Ada.Text_IO, Ada.Command_Line;

with Objets, Svg, Liste, Parseur;
use Objets, Liste;

-- Idée: Remplacer la liste par un tableau contenant les sommets rangés par indice
-- +> Accés plus simple aux coordonnées.
-- Remplacer tab_ptr par liste / tableau contenant Indice voisin + bool "tracé" ? 

procedure Noeuds is
   Nb_Sommets : Natural;
   
begin

   if Argument_Count /= 2 then
      Put_Line(Standard_Error, "utilisation : noeuds data.kn out.svg");
      return;
   end if;

   declare
      Sommets : Liste_Sommets := Liste_Sommets'(null, null);
   begin
      Parseur.Lecture(Argument(1), Sommets, Nb_Sommets);
      Put_Line ("Nombre de sommets: " & Integer'Image(Nb_Sommets));
      Put (Sommets);
      
      -- Traitement ?
      
      Svg.Sauvegarde(Argument(2), Sommets);
   end;

end Noeuds;
