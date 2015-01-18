
with Objets;
use Objets;

package Liste is

   Liste_Vide, Memoire_Pleine : exception;

   procedure Enqueue (L : in out Liste_Voisins;
                      Ind : in Indice;
                      A : in PtrArrete);

   procedure Put (L : in Liste_Voisins);

end Liste;
