with Objets;
use Objets;

package Liste is
   
   Liste_Vide : exception;
   
   type Element;
   type Pointeur is access Element;
   
   type Element is record
      Val : Sommet;
      Suiv : Pointeur;
   end record;
      
   type Liste_Sommets is record
      Tete, Queue : Pointeur;      
   end record;
   
   procedure Enqueue (L : in out Liste_Sommets; S : in Sommet);
   
   procedure Put (L : in Liste_Sommets); 
   
end Liste;
