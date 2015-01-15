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
				 PDC => (others => (others => 0.0)) );
	    Enqueue (L, ArreteCour);
            -- Elimination de la redondance dans la pile du voisin
            Pop (T(V).Voisins, V); -- V sert de "poubelle"
         end loop;
      end loop;
      
   end Generer_Arretes;
   
end Traitement;
