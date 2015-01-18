with Ada.Text_IO, Ada.Command_Line;
use Ada.Text_IO, Ada.Command_Line;

with Objets, Svg, Liste, Parseur, Traitement;
use Objets, Liste;

procedure Noeuds is
   Nb_Args_Invalide : exception;
   Nb_Sommets : Indice;
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
   end;
   
exception
   when Parseur.Kn_Mal_Formate =>
      Put_Line (Standard_Error,
		"erreur: Fichier Kn erroné.");
   when Nb_Args_Invalide =>
      Put_Line(Standard_Error, "utilisation : noeuds data.kn out.svg");
end Noeuds;
