with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

package Objets is

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

   type PtsDeCtrl is record
      Inv, Trig : Point;
   end record;

   type Sommet is record
      Pos : Point; -- Position du sommet
      Voisins : Liste_Voisins; -- Pointeur vers tableau d'indices
                               -- des sommets adjacents
   end record;

   type Arete is record
      MonId, OppID : Indice; 
      MyPDC, OppPDC : PtsDeCtrl;
      Longueur : Float;
      Milieu : Point;
   end record;
   type PtrArete is access Arete;

   type Cellule is record
      Ind : Indice;
      A : PtrArete;
      Suiv : Pointeur;
   end record;

   -- Types tabulaires
   type Tab_Sommets is array(Indice range <>) of Sommet;

   -- Types de gestion SVG
   X_Max, Y_Max : Float;
   X_Min, Y_Min : Float;
   Coeff_Marge: Float := 1.5;
   
   -- Procedure de tracé des objets
   procedure Put (P : Point);
   procedure Put (S : Sommet);
   procedure Put (T : Tab_Sommets);
   procedure Put (A : Arete);

end Objets;
