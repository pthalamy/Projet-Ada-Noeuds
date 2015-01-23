with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
with Ada.Numerics.Elementary_Functions;

use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
use Ada.Numerics.Elementary_Functions;

with Objets, Liste, Traitement;
use Objets, Liste;

package body Svg is
         
   Fichier_Svg : File_Type;
   
   type Color is (Violet, Indigo, Bleu, Vert, Jaune, Orange, Rouge, Noir, Blanc);
   function Code_Couleur (C : Color) return String is
   begin
      case C is
         when Violet  => return "rgb(255,0,255)";
         when Indigo  => return "rgb(111,0,255)";
         when Bleu  => return "rgb(0,0,255)";
         when Vert  => return "rgb(0,255,0)";
         When Jaune => return "rgb(0,255,255)";
         When Orange => return "rgb(255,165,0)";
         when Rouge => return "rgb(255,0,0)";
         when Noir  => return "rgb(0,0,0)";
         when Blanc => return "rgb(255,255,255)";
      end case;
   end Code_Couleur;
   
   -- Effectue le tracé intermédiaire :
   -- Trace les arretes et les croix
   -- Rmq: Toutes les arretes sont tracées deux fois pour simplifier le code
   procedure Trace_Intermediaire (T : in out Tab_Sommets) is
      -- Dessine une ligne A -- B
      procedure Svg_Line (A, B : Point; C: Color)
      is
      begin
         Put (Fichier_Svg, "<line x1=""");
         Put (Fichier_Svg, A.X);
         Put (Fichier_Svg, """ y1=""");
         Put (Fichier_Svg, A.Y);
         Put (Fichier_Svg, """ x2=""");
         Put (Fichier_Svg, B.X);
         Put (Fichier_Svg, """ y2=""");
         Put (Fichier_Svg, B.Y);
         Put (Fichier_Svg, """ style=""stroke:");
         Put (Fichier_Svg, Code_Couleur(C));
         Put_Line (Fichier_Svg, ";stroke-width:0.1""/>");
      end Svg_Line;

      procedure Trace_Croix (A : Arete) is
      begin
         Svg_Line (A.MyPDC.Trig, A.OppPDC.Trig, Bleu);
         Svg_Line (A.MyPDC.Inv, A.OppPDC.Inv, Bleu);
      end Trace_Croix;      
      
      -- Tableau de marquage des arretes deja tracées, afin d'éviter de 
      --  tracer chaque segment deux fois
      Marque_Traces : array (T'Range, T'Range) of Boolean 
	:= (others => (others => False));
      Cour : Pointeur;      
   begin
      for I in T'Range loop
         Cour := T(I).Voisins.Tete;
         while Cour /= null loop
	    if not Marque_Traces (I, Cour.Ind) 
	      and not Marque_Traces (Cour.Ind, I) then
	       Svg_Line (T(I).Pos, T(Cour.Ind).Pos,Noir); -- Trace l'arrete
	       Trace_Croix (Cour.A.all);
	       
	       -- Marquage anti-redondance
	       Marque_Traces (I, Cour.Ind) := True;
	       Marque_Traces (Cour.Ind, I) := True;
	    end if;
	    Cour := Cour.Suiv;
         end loop;
      end loop;      
   end Trace_Intermediaire;
   
   -- Effectue le tracé des noeuds
   procedure Trace_Noeuds (T : in out Tab_Sommets; Min : in Boolean) is 
      
      procedure Svg_Curve (D, A, C1, C2 : Point) is
	 
	 function Pt2Svg (P : Point) return String is
	 begin
	    return Float'Image (P.X) & Float'Image (P.Y);
	 end Pt2Svg;
	 
      begin
	 Put_Line (Fichier_Svg, "<path d=""M" & Pt2Svg (D)
		     & " C" & Pt2Svg (C1) & Pt2Svg (C2)
		     & Pt2Svg (A) & """ />");
      end Svg_Curve;
                  
      procedure Trace_Bezier (AreteCour, AreteCible : in Arete;
			      Trig : in out Boolean;
			      PathStyleSet : in out Boolean) is
      begin
	 if not PathStyleSet then
	    Put (Fichier_Svg, "<g");
	    Put(Fichier_Svg, " id=");
	    Put(Fichier_Svg, """noeud");
	    Put(Fichier_Svg,""" style=""");
	    Put(Fichier_Svg, "stroke:");
	    Put(Fichier_Svg,"rgb(255,0,0) ; fill: none ");
	    Put_Line(Fichier_Svg,"; stroke-width: 0.1"">");
	    PathStyleSet := True;
	 end if;
	 if Trig then
	    Svg_Curve (AreteCour.Milieu, AreteCible.Milieu, 
		       AreteCour.MyPDC.Trig, AreteCible.OppPDC.Inv);
	    Trig := False;
	 else
	    Svg_Curve (AreteCour.Milieu, AreteCible.Milieu, 
		       AreteCour.MyPDC.Inv, AreteCible.OppPDC.Trig);	 
	    Trig := True;
	 end if;
	 
	 Trig := not Trig;
	 
      end Trace_Bezier;
      
      Depart : Indice; -- Sommet de depart du tracé
      SCour, SOpp, SCand, SCible : Indice;
      AreteCour, AreteCible : Arete;
      AngleExt : Float; -- Angle Extremum (min ou max)
      AngleCour : Float;
      Trig : Boolean; -- Indique le sens de rotation à utiliser pour les calculs
      VCour : Pointeur; -- Pointeur sur le voisin courant dans la liste 
		       --  de voisins du sommet courant
      PathStyleSet : Boolean := False; -- Indique si le style svg des noeuds
				       --  a déjà été écrit dans le fichier
      
      Count : Indice := 0;
   begin    
      -- Initialisation
      Depart := T'First; -- On part toujours du premier element     

      SCour := Depart;

      SCand := 0; 
      SCible := 0; 
      AngleCour := 0.0;
      
      AreteCour := T(SCour).Voisins.Tete.A.all;
      
      Trig := True; -- On part dans le sens Trigo
      
      loop 	 
	 if Min then
	    AngleExt := 360.0;
	 else 
	    AngleExt := 0.0;
	 end if;
	 
	 SOpp := AreteCour.OppID;
	 VCour := T(SCour).Voisins.Tete;
	 
	 Traitement.Trouve_Cible (T, SCour, SCand, SOpp, SCible, 
				  AngleCour, AngleExt, 
				  VCour, AreteCible, Trig, Min);
	 
	 Trace_Bezier (AreteCour, AreteCible, Trig, PathStyleSet);
	 
	 SCour := SCible;
	 AreteCour := AreteCible;
	 
	 Count := Count + 1;
	 exit when Count = 2 * (T'Last - 1); 
      end loop;
      
   end Trace_Noeuds;
      
   -- Procedure unique permettant de generer le tracé 
   --  de tous les elements de l'image
   procedure Sauvegarde (Nom_Fichier_Svg : in String;
                         T : in out Tab_Sommets;
			 Min : in Boolean)
   is
      procedure Svg_Header is
      begin
         Put (Fichier_Svg, "<svg width=""");
         Put (Fichier_Svg, Image.Largeur);
         Put (Fichier_Svg, """ height=""");
         Put (Fichier_Svg, Image.Hauteur);
         Put_Line (Fichier_Svg, """>");
      end Svg_Header;
      
      procedure Svg_Footer is
      begin
         Put_Line (Fichier_Svg, "</svg>");
      end Svg_Footer;
      
   begin
      Create (File => Fichier_Svg,
              Mode => Out_File,
              Name => Nom_Fichier_Svg);
      Svg_Header;
      
      Trace_Intermediaire (T);
      Trace_Noeuds (T, Min);
      
      Put_Line(Fichier_Svg,"</g>");
      Svg_Footer;
      Close (Fichier_Svg);
   end Sauvegarde;
end Svg;
