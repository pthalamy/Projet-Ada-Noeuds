with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;

with Objets, Liste, Svg;
use Objets, Liste;

package body Parseur is
   
   -- requiert : Nom_Fichier nom de fichier existant et bien formatté
   -- garantit : Objets rempli d'objets de dimension et indice
   --            lus dans le fichier.
   procedure Lecture (Nom_Fichier : in String; 
		      L : in out Liste_Sommets;
		      Nb_Sommets : out Natural) 
   is      
      Fichier : File_Type;
      X_Max : Float := 0.0; -- Abcisse maximale des sommets
      Y_Max : Float := 0.0; -- Ordonnée maximale des sommets
      
      procedure Get (F: in File_Type; L: out Liste_Sommets; I: Natural) is 
	 S : Sommet;
      begin 
	 S.Indice := I;
	 
	 -- Parsing des attributs du sommet	 
     	 Get (F, S.Pos.X);
	 if S.Pos.X > X_Max then
	    X_Max := S.Pos.X;
	 end if;
	 
	 Get (F, S.Pos.Y);	 
	 if S.Pos.Y > Y_Max then
	    Y_Max := S.Pos.Y;
	 end if;
	 
	 Get (F, S.Nb_Arretes);
	 
	 S.Voisins := new Indice_Tab(1..S.Nb_Arretes);
	 
	 for V in S.Voisins'Range loop
	    Get (F, S.Voisins.all(V));
	 end loop;	   
	 
	 -- Stockage du sommet dans la liste
	 Enqueue (L, S);	 
      end Get;
      
   begin
      Open (File => Fichier,
	    Mode => In_File,
	    Name => Nom_Fichier);

      Get (Fichier, Nb_Sommets);
      
      for S in 1..Nb_Sommets loop
	 Get (Fichier, L, S);
      end loop;
      
      Close (Fichier);            
      
      if Nb_Sommets = 0 then 
      	 raise Nombre_Sommets_Nul; 
      end if;
      
      -- Stockage de la taille de l'image SVG en sortie
      Svg.Affichage.Largeur := X_Max + Svg.Marge_Affichage;
      Svg.Affichage.Hauteur := Y_Max + Svg.Marge_Affichage;
      
   exception
      when End_Error | Name_Error | Data_Error | Layout_Error
	| Constraint_Error =>
	 Put_Line (Standard_Error, 
		   "Erreur: Erreur de lecture !");
	 raise Erreur_Lecture;      
   end Lecture;

end Parseur;
