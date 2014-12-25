with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

with Pile;
use Pile;

package Objets is
   
   type Point is record 
      X : Float;
      Y : Float;
   end record;
   
   type Indice is Natural;
   
   type Sommet is record
      Pos : Point; -- Position du sommet
      Voisins : Pile; -- Pointeur vers tableau d'indices des sommets adj
   end record;      
   
   type Tab_Sommets is array(Positive range <>) of Sommet;
      
   procedure Put (S : Sommet);
   procedure Put (T : Tab_Sommets);
   
end Objets;
