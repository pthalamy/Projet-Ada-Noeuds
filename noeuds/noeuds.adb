with Ada.Text_IO, Ada.Command_Line;
use Ada.Text_IO, Ada.Command_Line;

with Objets, Svg, Pile, Parseur;
use Objets, Pile;

-- Idée: Remplacer la liste par un tableau contenant les sommets rangés par indice
-- +> Accés plus simple aux coordonnées.

-- NOTE: Pile implémentée. 
-- TODO: Implementation du tableau et supplantation de la liste.
procedure Noeuds is
   Nb_Sommets : Natural;
begin

   if Argument_Count /= 2 then
      Put_Line(Standard_Error, "utilisation : noeuds data.kn out.svg");
      return;
   end if;
   
   Parseur.Lecture_Nombre_Sommets (Argument(1), Nb_Sommets);
   Put_Line ("Nombre de sommets: " & Integer'Image(Nb_Sommets));
   
   declare
      Sommets : Tab_Sommets := Tab_Sommets'(1..Nb_Sommets);
   begin
      Parseur.Lecture(Sommets);
      Put (Sommets);
      
      -- Traitement ?
      
      Svg.Sauvegarde(Argument(2), Sommets);
   end;

end Noeuds;
