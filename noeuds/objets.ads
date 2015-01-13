with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

package Objets is

   type Point is record
      X : Float;
      Y : Float;
   end record;

   type PtsDeCtrl is record
      C1, C2, C3, C4 : Point;
   end record;

   type Indice is new Natural;

   type Cellule;
   type Pointeur is access Cellule;

   type Liste_Arretes is record
      Tete, Queue : Pointeur;
   end record;

   type Arrete is record
      S1, S2 : Indice;
      Longueur : Float;
      PDC : PtsDeCtrl;
   end record;

   type Cellule is record
      Val : Arrete;
      Suiv : Pointeur;
   end record;

   type Sommet is new Point;

   type Tab_Sommets is array(Indice range <>) of Sommet;

   X_Offset : constant Float := 50.0;
   Y_Offset : constant Float := 50.0;

   procedure Put (S : Sommet);
   procedure Put (T : Tab_Sommets);
   procedure Put (A : Arrete);

end Objets;
