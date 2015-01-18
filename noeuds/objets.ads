with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

package Objets is

   -- Types personnalisés
   type Indice is new Natural;

   -- Entités géométriques
   type Point is record
      X : Float;
      Y : Float;
   end record;

   type CelluleS;
   type Pile_Sommets is access CelluleS;

   type Sommet is record
      Pos : Point; -- Position du sommet
      Voisins : Pile_Sommets; -- Pointeur vers tableau d'indices
                              -- des sommets adjacents
   end record;

   type Tab_Points is array (1..2) of Point;
   type PtsDeCtrl is record
      Trig, Inv : Tab_Points;
   end record;

   type Arrete is record
      S1, S2 : Indice;
      Longueur : Float;
      Milieu : Point;
      PDC : PtsDeCtrl;
   end record;

   -- Types tabulaires
   type Tab_Sommets is array(Indice range <>) of Sommet;

   -- Types de gestion de liste
   type CelluleA;
   type PointeurA is access CelluleA;

   type Liste_Arretes is record
      Tete, Queue : PointeurA;
   end record;

   type CelluleA is record
      Val : Arrete;
      Suiv : PointeurA;
   end record;

   -- Types de gestion de pile
   type CelluleS is record
      Val : Indice;
      Suiv : Pile_Sommets;
   end record;

   -- Types de gestion SVG
   X_Max, Y_Max : Float;
   X_Min, Y_Min : Float;
   Coeff_Marge: Float := 1.5;

   procedure Put (S : Sommet);
   procedure Put (T : Tab_Sommets);
   procedure Put (A : Arrete);

end Objets;
