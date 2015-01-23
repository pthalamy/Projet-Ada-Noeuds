with Ada.Text_IO, Ada.Command_Line;
use Ada.Text_IO, Ada.Command_Line;

with Objets, Svg, Liste, Parseur, Traitement;
use Objets, Liste;

with Ada.Numerics.Elementary_Functions, Ada.Float_Text_IO;
use Ada.Numerics.Elementary_Functions, Ada.Float_Text_IO;

procedure Noeuds is
   Args_Invalides : exception;
   Nb_Sommets : Indice;
   Min : Boolean;
begin

   if Argument_Count /= 3 then
      raise Args_Invalides;
   end if;  
   
   if Argument(3) = "min" then 
      Min := True;
   elsif Argument(3) = "max" then
      Min := False;
   else 
      raise Args_Invalides;
   end if;

   Parseur.Lecture_Nombre_Sommets (Argument(1), Nb_Sommets);

   declare
      Sommets : Tab_Sommets (1..Nb_Sommets);
   begin
      Parseur.Lecture (Argument(1), Sommets);

      Traitement.Stocker_Points_De_Controle (Sommets);
      
      Svg.Sauvegarde (Argument(2), Sommets, Min);
   end;
   
   Put_Line ("Fini: Ouvrez le fichier " & Argument (2) & 
	       " pour afficher le résultat.");   
exception
   when Parseur.Kn_Mal_Formate =>
      Put_Line (Standard_Error,
		"erreur: Fichier Kn erroné.");
   when Args_Invalides =>
      Put_Line (Standard_Error, "utilisation : noeuds data.kn out.svg [max/min]");
end Noeuds;
