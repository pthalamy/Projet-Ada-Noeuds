with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;

with Objets, Liste, Svg;
use Objets, Liste;

package body Parseur is

   procedure Lecture_Nombre_Sommets (Nom_Fichier : in String;
                                     Nb_Sommets : out Indice)
   is

      procedure InitialisationSVG is
         -- Variables de comparaison
         X_Cour : Float := 0.0;
         Y_Cour : Float := 0.0;
      begin
         X_Max := X_Cour;
         Y_Max := Y_Cour;

         -- Recuperation des coordonnees max
         while not End_Of_File (Fichier_Kn) loop
            Get (Fichier_Kn, X_Cour);
            X_Cour := abs X_Cour;
            if X_Cour > X_Max then
               X_Max := X_Cour;
            end if;

            Get (Fichier_Kn, Y_Cour);
            Y_Cour := abs Y_Cour;
            if Y_Cour > Y_Max then
               Y_Max := Y_Cour;
            end if;

            Skip_Line (Fichier_Kn);
            Skip_Line (Fichier_Kn); -- Nombre de sommets voisins
            Skip_Line (Fichier_Kn); -- Voisins
         end loop;

         -- Initialisation de la grille svg avec
         -- Les valeurs max + une marge
         Svg.Image := (X_Max + (X_Max / 10.0), Y_Max + (Y_Max / 10.0));
         X_Offset := X_Max / 2.0;
         Y_Offset := Y_Max / 2.0;

      end InitialisationSVG;

   begin
      Open (File => Fichier_Kn,
            Mode => In_File,
            Name => Nom_Fichier);

      Get (Fichier_Kn, Natural (Nb_Sommets));

      if Nb_Sommets = 0 then
         raise Nombre_Sommets_Nul;
      end if;

      InitialisationSVG;

      Close (Fichier_Kn);
   exception
      when End_Error | Name_Error | Data_Error | Layout_Error
        | Constraint_Error =>
         Put_Line (Standard_Error,
                   "Erreur: Erreur de lecture !");
         raise Erreur_Lecture;
   end Lecture_Nombre_Sommets;

   procedure Lecture (T : in out Tab_Sommets)
   is
   begin

      -- Parser les valeurs des attributs de chaque sommet
      -- et les stockers dans T à la case I.
      for I in T'Range loop
         Init_Sommet (I);
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
