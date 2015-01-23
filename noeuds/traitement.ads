with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
with Ada.Numerics.Elementary_Functions;

use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
use Ada.Numerics.Elementary_Functions;

with Objets;
use Objets;

package Traitement is
   
   -- Calcule et stocke les coordonnées des points de contrôles 
   --  pour tous les sommets de T
   procedure Stocker_Points_De_Controle (T : in out Tab_Sommets);
      
   -- Trouve l'arrete cible (SCour..SCible) à partir de 
   --  l'arrete courante (SCour..SOpp) pour le tracé des noeuds
   procedure Trouve_Cible (T : in out Tab_Sommets;
			   SCour, SCand, SOpp, SCible : in out Indice;
			   AngleCour, AngleExt : in out Float;
			   VCour : in out Pointeur;
			   AreteCible : out Arete;
			   Trig, Min : in Boolean);
   
end Traitement;
