with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

package Objets is
   
   type Indice_Tab is array(Positive range <>) of Natural;   
   type Tab_Ptr is access Indice_Tab;
   
   type Point is record 
      X : Float;
      Y : Float;
   end record;
   
   type Indice is Natural;
   
   type Sommet is record
      Pos : Point; -- Position du sommet
      Nb_Arretes : Natural; -- Nombre de sommets adjacents
      Voisins : Tab_Ptr; -- Pointeur vers tableau d'indices des sommets adj
   end record;      
   
   procedure Put (S : Sommet);
   
end Objets;
