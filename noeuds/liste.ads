
with Objets;
use Objets;

package Liste is

   Liste_Vide, Memoire_Pleine : exception;

   procedure Enqueue (L : in out Liste_Arretes; A : in Arrete);

   procedure Put (L : in Liste_Arretes);

end Liste;
