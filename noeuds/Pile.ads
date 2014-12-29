with Objets;
use Objets;

package Pile is
      
   Pile_Vide, Memoire_Pleine : exception;   
   
   procedure Push (Tete : in out Pile_Sommets; I : in Indice);
   
   -- Ne devrait pas avoir à être utilisé, mais si le fichier
   -- kn est mal formaté (indices sommets voisins non triés),
   -- permet d'ajouter un element en fin de pile.
   -- MAIS: Important coût en temps potentiel, responsabilité 
   -- de l'utilisateur que  de bien formatter son fichier de donnée.
   --  procedure Push_Back (Tete : in out Pile_Sommets; I : in Indice)
   
   procedure Pop (Tete : in out Pile_Sommets; I : out Indice);
   
   function Vide (Tete : in Pile_Sommets) return Boolean;
   
   procedure Put (Tete : in Pile_Sommets);
   
end Pile;
