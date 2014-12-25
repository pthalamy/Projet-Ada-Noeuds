with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;

with Objets, Liste, Svg;
use Objets, Liste;

package body Parseur is
   
   procedure Lecture_Nombre_Sommets (Nom_Fichier : in String;
				     Nb_Sommets : out Natural) 
   is      
   begin
      Open (File => Fichier_Kn,
	    Mode => In_File,
	    Name => Nom_Fichier);
      
      Get (Fichier_Kn, Nb_Sommets);
      
      if Nb_Sommets = 0 then 
      	 raise Nombre_Sommets_Nul; 
      end if;
      
   exception
      when End_Error | Name_Error | Data_Error | Layout_Error
	| Constraint_Error =>
	 Put_Line (Standard_Error, 
		   "Erreur: Erreur de lecture !");
	 raise Erreur_Lecture;         
   end Lecture_Nombre_Sommets;
   
   procedure Lecture (T : in out Tab_Sommets) 
   is      
      X_Max : Float := 0.0; -- Abcisse maximale des sommets
      Y_Max : Float := 0.0; -- Ordonnée maximale des sommets
      
      procedure Init_Sommet (I: Natural) is 
	 S : Sommet;
	 Nb_Arretes : Natural;	 
	 Indice_Courant : Indice;
      begin 
	 S.Voisins := null;
	 
	 -- Parsing des attributs du sommet	 
	 ---- Position X
     	 Get (Fichier_Kn, S.Pos.X);
	 if S.Pos.X > X_Max then
	    X_Max := S.Pos.X;
	 end if;
	 ---- Position Y	 
	 Get (Fichier_Kn, S.Pos.Y);	 
	 if S.Pos.Y > Y_Max then
	    Y_Max := S.Pos.Y;
	 end if;
	 ---- Nombre d'arrètes voisines	 
	 Get (Fichier_Kn, Nb_Arretes);	 	 
	 ---- Récuperation des indices des sommets voisins et stockage
	 ---- dans une pile/liste.
	 for V in Nb_Arretes loop
	    Get(Fichier_Kn, Indice_Courant);
	    Push (S.Voisins, Indice_Courant)
	 end loop;
      end Get;
      
   begin
      
      -- Parser les valeurs des attributs de chaque sommet
      -- et les stockers dans T à la case I.
      for I in 1..Nb_Sommets loop
	 Init_Sommet (L, I);
      end loop;
      
      Close (Fichier_Kn);            
            
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
