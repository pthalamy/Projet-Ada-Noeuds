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
   
   procedure Pop (Tete : in out Pile;
   
   procedure Put (Tete : in Pile);
   
end Pile;
