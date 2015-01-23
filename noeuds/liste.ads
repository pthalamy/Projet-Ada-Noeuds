
with Objets;
use Objets;

package Liste is

   Liste_Vide, Memoire_Pleine : exception;
   
   -- Garantit: Pointeur sur cellule avec attributs Ind et A chaînée en queue de L.
   procedure Enqueue (L : in out Liste_Voisins;
                      Ind : in Indice;
                      A : in PtrArrete);
   
   -- Affiche le contenu d'une liste
   procedure Put (L : in Liste_Voisins);

end Liste;
