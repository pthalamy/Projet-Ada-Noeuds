with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
with Ada.Numerics.Elementary_Functions;

use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
use Ada.Numerics.Elementary_Functions;

with Objets;
use Objets;

package Traitement is
   
   procedure Generer_Arretes (T : in out Tab_Sommets;
			      L : in out Liste_Arretes);
   
end Traitement;
