with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

package Objets is

   -- Types personnalisés
   type Indice is new Natural;

   -- Types de gestion de liste
   type Cellule;
   type Pointeur is access Cellule;

   type Liste_Voisins is record
      Tete, Queue : Pointeur;
   end record;

   -- Entités géométriques
   type Point is record
      X : Float;
      Y : Float;
   end record;

   type Tab_Points is array('T'..'I') of Point;
   type PtsDeCtrl is record
      SPt1, SPt2 : Tab_Points;
   end record;

   type Sommet is record
      Pos : Point; -- Position du sommet
      Voisins : Liste_Voisins; -- Pointeur vers tableau d'indices
                               -- des sommets adjacents
   end record;

   type Arrete is record
      S1, S2 : Indice;
      PDC : PtsDeCtrl;
      Longueur : Float;
      Milieu : Point;
   end record;
   type PtrArrete is access Arrete;

   type Cellule is record
      I : Indice;
      A : PtrArrete;
      Suiv : Pointeur;
   end record;

   -- Types tabulaires
   type Tab_Sommets is array(Indice range <>) of Sommet;

   -- Types de gestion SVG
   X_Max, Y_Max : Float;
   X_Min, Y_Min : Float;
   Coeff_Marge: Float := 1.5;

   procedure Put (S : Sommet);
   procedure Put (T : Tab_Sommets);
   procedure Put (A : Arrete);

end Objets;
