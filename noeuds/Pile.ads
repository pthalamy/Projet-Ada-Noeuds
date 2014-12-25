with Objets;
use Objets;

package Pile is
   
   type Cellule;
   type Pile is access Cellule;
   
   type Cellule is record
      Val : Indice;
      Suiv : Pile;
   end record;
   
   Pile_Vide, Memoire_Pleine : exception;   
   
   procedure Push (Tete : in out Pile; I : in Indice);
   
   -- Ne devrait pas avoir à être utilisé, mais si le fichier
   -- kn est mal formaté (indices sommets voisins non triés),
   -- permet d'ajouter un element en fin de pile.
   -- MAIS: Important coût en tempspotentiel, responsabilité 
   -- de l'utilisateur que  de bien formatter son fichier de donnée.
   --  procedure Push_Back (Tete : in out Pile; I : in Indice)
   
   procedure Pop (Tete : in out Pile;
   
   procedure Put (Tete : in Pile);
   
end Pile;
