with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;

with Objets, Liste, Svg, Pile;
use Objets, Liste, Pile;

package body Parseur is

   procedure Lecture_Nombre_Sommets (Nom_Fichier : in String;
                                     Nb_Sommets : out Indice)
   is
      Fichier_Kn : File_Type;

      procedure InitialisationSVG is
         -- Variables de comparaison
         X_Cour : Float := 0.0;
         Y_Cour : Float := 0.0;
      begin
         -- Initialisation
         X_Max := X_Cour;
         X_Min := X_Cour;
         Y_Max := Y_Cour;
         Y_Min := Y_Cour;

         -- Recuperation des coordonnees max
         while not End_Of_File (Fichier_Kn) loop
            Get (Fichier_Kn, X_Cour);
            if X_Cour > X_Max then
               X_Max := X_Cour;
            elsif X_Cour < X_Min then
               X_Min := X_Cour;
            end if;

            Get (Fichier_Kn, Y_Cour);
            if Y_Cour > Y_Max then
               Y_Max := Y_Cour;
            elsif Y_Cour < Y_Min then
               Y_Min := Y_Cour;
            end if;

            Skip_Line (Fichier_Kn);
            Skip_Line (Fichier_Kn); -- Nombre de sommets voisins
            Skip_Line (Fichier_Kn); -- Voisins
         end loop;

         -- Initialisation de la grille svg
         Svg.Image := ((X_Max - X_Min) * Coeff_Marge, (Y_Max - Y_Min) * Coeff_Marge);
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

   procedure Lecture (Nom_Fichier : in String;
                      T : in out Tab_Sommets)
   is
      Fichier_Kn : File_Type;

      procedure Init_Sommet (I: Indice) is
         Nb_Arretes : Natural;
         Indice_Courant : Indice;
      begin
         T(I).Voisins := null;

         -- Parsing des attributs du sommet
         ---- Position X
         Get (Fichier_Kn, T(I).Pos.X);
         ------ Calcul de valeur corrigée de X
         T(I).Pos.X := T(I).Pos.X + (X_Max - X_Min) * Coeff_Marge / 2.0;

         ---- Position Y
         Get (Fichier_Kn, T(I).Pos.Y);
         ------ Calcul de valeur corrigée de Y
         T(I).Pos.Y := T(I).Pos.Y + (Y_Max - Y_Min) * Coeff_Marge / 2.0;

         ---- Nombre d'arrètes voisines
         Get (Fichier_Kn, Nb_Arretes);
         ---- Récuperation des indices des sommets voisins et stockage
         ---- dans une pile/liste.
         for V in 1..Nb_Arretes loop
            Get (Fichier_Kn, Natural (Indice_Courant));
            Push (T(I).Voisins, Indice_Courant);
         end loop;
      end Init_Sommet;

   begin
      Open (File => Fichier_Kn,
            Mode => In_File,
            Name => Nom_Fichier);

      Skip_Line (Fichier_Kn);

      -- Parser les valeurs des attributs de chaque sommet
      -- et les stockers dans T à la case I.
      for I in T'Range loop
         Init_Sommet (I);
      end loop;

      Close (Fichier_Kn);

   exception
      when End_Error | Name_Error | Data_Error | Layout_Error
        | Constraint_Error =>
         Put_Line (Standard_Error,
                   "Erreur: Erreur de lecture !");
         raise Erreur_Lecture;
   end Lecture;

end Parseur;
