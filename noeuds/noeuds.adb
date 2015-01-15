with Ada.Text_IO, Ada.Command_Line;
use Ada.Text_IO, Ada.Command_Line;

with Objets, Svg, Liste, Parseur, Traitement;
use Objets, Liste;

procedure Noeuds is
   Nb_Sommets : Indice;
begin

   if Argument_Count /= 2 then
      Put_Line(Standard_Error, "utilisation : noeuds data.kn out.svg");
      return;
   end if;

   Parseur.Lecture_Nombre_Sommets (Argument(1), Nb_Sommets);
   
   Put_Line ("Nombre de sommets: " & Integer'Image(Integer (Nb_Sommets)));

   declare
      Sommets : Tab_Sommets (1..Nb_Sommets);
      Arretes : Liste_Arretes := (null, null);
   begin
      Parseur.Lecture (Argument(1), Sommets);
      Put (Sommets);

      -- Traitement ?
      Traitement.Generer_Arretes (Sommets, Arretes);
      Put (Arretes);

      --  Svg.Sauvegarde(Argument(2), Sommets);
   end;

end Noeuds;
