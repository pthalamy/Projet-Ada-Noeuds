with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

package Objets is
   
   type Point is record 
      X : Float;
      Y : Float;
   end record;
   
   type Indice is new Natural;
   
   type Cellule;
   type Pile_Sommets is access Cellule;
   
   type Cellule is record
      Val : Indice;
      Suiv : Pile_Sommets;
   end record;
   
   type Sommet is record
      Pos : Point; -- Position du sommet
      Voisins : Pile_Sommets; -- Pointeur vers tableau d'indices des sommets adj
   end record;      
   
   type Tab_Sommets is array(Indice range <>) of Sommet;
   
   X_Offset : constant Float := 50.0;
   Y_Offset : constant Float := 50.0;
      
   procedure Put (S : Sommet);
   procedure Put (T : Tab_Sommets);
   
end Objets;
