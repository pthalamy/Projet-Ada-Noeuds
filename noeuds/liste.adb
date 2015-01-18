with Ada.Text_IO;
use Ada.Text_IO;

with Objets;
use Objets;

package body Liste is

   procedure Enqueue (L : in out Liste_Voisins;
                      I : in Indice;
                      A : in Arrete)
   is
   begin
      if L.Tete = null then
         raise Liste_Vide;
      end if;

      L.Queue.Suiv := new Cellule'(I, A, null);
      L.Queue := L.Queue.Suiv;

   exception
      when Liste_Vide =>
         L.Tete := new Cellule'(I, A, null);
         L.Queue := L.Tete;
   end Enqueue;

   procedure Put (L : in Liste_Voisins) is
      Cour : Pointeur;
   begin
      if L.Tete = null then
         raise Liste_Vide;
      end if;

      Cour := L.Tete;

      while Cour /= null loop

         Put_Line ("  Indice: " & Integer'Image (Integer (Cour.I)));
         Put (Cour.A);
         New_Line;
         Cour := Cour.Suiv;
      end loop;

   exception
      when Liste_Vide =>
         Put_Line ("La liste est vide.");
   end Put;

end Liste;
