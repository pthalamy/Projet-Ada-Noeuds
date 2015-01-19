with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
with Ada.Numerics.Elementary_Functions;

use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
use Ada.Numerics.Elementary_Functions;

with Objets, Liste;
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
   
   procedure Trace_Intermediaire (T : in out Tab_Sommets) is
      -- Dessine une ligne A -- B
      procedure Svg_Line (A, B : Point;
			  C : Color)
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

         Put (Fichier_Svg, Code_Couleur (C));

         Put_Line (Fichier_Svg, ";stroke-width:0.1""/>");
      end Svg_Line;

      -- TODO : Tracer croix
      procedure Trace_Croix (A : Arrete) is
	 --  procedure Svg_Dot (P : Point; C : Color) is
	 --     Pp : Point;
	 --  begin
	 --     Pp.X := P.X + 0.01;
	 --     Pp.Y := P.Y + 0.01;
	 --     Svg_Line (P, Pp, C);
	 --  end Svg_Dot;
      begin
	 --  Svg_Dot (A.MyPDC.Trig, Rouge);
	 --  Svg_Dot (A.MyPDC.Inv, Vert);
	 --  Svg_Dot (A.OppPDC.Trig, Jaune);
	 --  Svg_Dot (A.OppPDC.Inv, Bleu);
         Svg_Line (A.MyPDC.Trig, A.OppPDC.Trig, Noir);
	 --  Svg_Line (A.MyPDC.Trig, A.MyPDC.Inv, Bleu);
         Svg_Line (A.MyPDC.Inv, A.OppPDC.Inv, Noir);
      end Trace_Croix;      
      
      Cour : Pointeur;      
   begin
      for I in T'Range loop
         Cour := T(I).Voisins.Tete;
         while Cour /= null loop
	    Svg_Line (T(I).Pos, T(Cour.Ind).Pos, Noir); -- Trace l'arrete
            Trace_Croix (Cour.A.all);
            Cour := Cour.Suiv;
         end loop;
      end loop;      
   end Trace_Intermediaire;
   
   procedure Trace_Noeuds (T : in out Tab_Sommets) is 
      
      procedure Svg_Curve (D, A, C1, C2 : Point) is
	 
	 function Pt2Svg (P : Point) return String is
	 begin
	    return Float'Image (P.X) & Float'Image (P.Y);
	 end Pt2Svg;
	 
      begin
	 Put_Line (Fichier_Svg, "<path d=""M" & Pt2Svg (D)
		     & "C" & Pt2Svg (C1) & Pt2Svg (C2)
		     & Pt2Svg (A));
	 Put (Fichier_Svg, """ style=""stroke:");
         Put (Fichier_Svg, Code_Couleur (Rouge));
         Put_Line (Fichier_Svg, ";stroke-width:0.1; fill: none""/>");
      end Svg_Curve;
      
      Depart : Indice; -- Sommet de depart du tracé
      SCour, SOpp, SCand, SCible : Indice;
      ArreteCour, ArreteCible : Arrete;
      AngleMax, AngleCour : Float;
      Trig : Boolean;
      Cour : Pointeur;
      Count : Natural := 0;
      
      procedure Trouve_Cible is
	 
	 procedure Recupere_ArreteCible is
	    Local_Cour : Pointeur := T(SCible).Voisins.Tete;
	 begin
	    while Local_Cour /= null loop
	       if Local_Cour.Ind = SCour then
		  ArreteCible := Local_Cour.A.all;
		  return;
	       end if;
	       Local_Cour := Local_Cour.Suiv;
	    end loop;
	 end Recupere_ArreteCible;
	 
	 function Calcul_Angle (SCour, SOpp, SCand : Point;
				Trig : Boolean) return Float 
	 is	    
	    Angle : Float;
	    LScour_Sopp :Float;
	    LSOpp_Scand:Float;
	    LScand_Scour:Float;
	    Base : constant Float := 360.0;
	    Interm : Float;
	 begin
	    Put (Scour); 
	    Put (SOpp); 
	    Put (SCand);
	    
	    LScour_Sopp := sqrt((SCour.X-SOpp.X)**2 + (SCour.Y-SOpp.Y)**2);
	    
	    LSopp_Scand := sqrt((SOpp.X-SCand.X)**2 + (SOpp.Y-SCand.Y)**2);
	    
	    LScand_Scour := sqrt((Scour.X-SCand.X)**2 + (Scour.Y-Scand.Y)**2);	    
	    
	    Interm := ((SOpp.X-SCour.X)*(SCand.X-SCour.X) +
	    		 (SOpp.Y-SCour.Y)*(SCand.Y-SCour.Y)) /
	      (LScour_Sopp*LSopp_Scand);	    	    	    
	    
	    --  Interm := ((LScour_Sopp)**2 + (LScand_Scour)**2 - (LSopp_Scand)**2)
	    --    / (2.0 * LScour_Sopp * LSopp_Scand);
	    
	    Angle := Arccos (Interm , Base);
	    
	    if Trig then
	       return Angle;
	    else 
	       return 360.0 - Angle;
	    end if;
	 end Calcul_Angle;
	 
	 Arrete_Unique : exception;	 
      begin 
	 if Cour.Suiv = null then
	    raise Arrete_Unique; 
	 end if;		
	 
	 while Cour /= null loop
	    SCand := Cour.Ind;
	    
	    if SCand /= SOpp then
	       Put_Line ("SCour="&Integer'Image(Integer(SCour))
			   &"  SOpp="&Integer'Image(Integer(SOpp))
			   &"  SCand="&Integer'Image(Integer(SCand)));
	       
	       AngleCour := Calcul_Angle (T(SCour).Pos, 
	       				  T(SOpp).Pos, 
	       				  T(SCand).Pos,
					  Trig);
	       
	       Put ("AngleCour: " & Float'Image (AngleCour));
	       if not Cour.A.Traitee and then AngleCour > AngleMax then
		  Put (" > AngleMax: " & Float'Image (AngleMax));
		  AngleMax := AngleCour;
		  SCible := SCand;
	       end if;
	       New_Line;
	    end if;
	    
	    Cour := Cour.Suiv;
	 end loop;
	 
	 Put_Line ("SCible="&Integer'Image(Integer(SCible)));
	 Recupere_ArreteCible; 
	 
	 --  Put_Line ("ArreteCour: ");
	 --  Put (ArreteCour);
	 --  Put_Line ("ArreteCible: ");
	 --  Put (ArreteCible);
	 
      exception
	 when Arrete_Unique => 
	    SCible := Cour.Ind;
	    Recupere_ArreteCible; 
      end Trouve_Cible;
      
      procedure Trace_Bezier is	 
      begin
	 if Trig then
	    Svg_Curve (ArreteCour.Milieu, ArreteCible.Milieu, 
		       ArreteCour.MyPDC.Trig, ArreteCible.OppPDC.Inv);
	    Put_Line ("Tracé Nº" & Integer'Image (Count) & ":");
	    Put ("D: " & Integer'Image (Integer(SCour)) & ",T <"
		   & Integer'Image (Integer(SOpp)) & " > - ");
	    Put_Line ("A: " & Integer'Image (Integer(ArreteCible.OppID)) 
			& ",I <" & Integer'Image (Integer(SCible)) & " >");
	    Trig := False;
	 else
	    Svg_Curve (ArreteCour.Milieu, ArreteCible.Milieu, 
		       ArreteCour.MyPDC.Inv, ArreteCible.OppPDC.Trig);	 
	    Put_Line ("Tracé Nº" & Integer'Image (Count) & ":");
	    Put ("D: " & Integer'Image (Integer(SCour)) & ",I <" 
		   & Integer'Image (Integer(SOpp)) & " > - ");
	    Put_Line ("A: " & Integer'Image (Integer(ArreteCible.OppID)) 
			& ",T <" & Integer'Image (Integer(SCible)) & " >");
	    Trig := True;
	 end if;
	 
	 ArreteCible.Traitee := True;
      end Trace_Bezier;
      
   begin    
      -- Initialisation
      Depart := T'First; -- On part toujours du premier element
      Put_Line ("Départ: " & Integer'Image (Integer(Depart)));
      SCour := Depart;      
      ArreteCour := T(SCour).Voisins.Tete.A.all;
      
      Trig := True; -- On part dans le sens Trigo
      
      loop 	 
	 AngleMax := 0.0;
	 SOpp := ArreteCour.OppID;
	 Cour := T(SCour).Voisins.Tete;
	 
	 Trouve_Cible;
	 Trace_Bezier;	 
	 
	 SCour := SCible;
	 ArreteCour := ArreteCible;
	 
	 Count := Count + 1;
	 -- Si on retombe sur le point de départ, le tracé est terminé      
	 --  exit when SCour = Depart;
	 exit when Count = 2; New_Line;
      end loop;
      
   end Trace_Noeuds;
   
   procedure Sauvegarde (Nom_Fichier_Svg : in String;
                         T : in out Tab_Sommets)
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
      Trace_Noeuds (T);
      
      Svg_Footer;

      Close (Fichier_Svg);
   end Sauvegarde;

end Svg;
