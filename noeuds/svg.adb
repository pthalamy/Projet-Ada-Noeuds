with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
with Ada.Numerics.Elementary_Functions;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
use Ada.Numerics.Elementary_Functions;
with Objets, Liste;
use Objets, Liste;
package body Svg is
   
   function Point2Str (P : Point) return String is
   begin
      return "(" & Float'Image (P.X) & ", " & Float'Image (P.Y) & " )";
   end Point2Str;
   
   
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

      procedure Trace_Croix (A : Arrete) is
      begin
         Svg_Line (A.MyPDC.Trig, A.OppPDC.Trig, Bleu);
         Svg_Line (A.MyPDC.Inv, A.OppPDC.Inv, Bleu);
      end Trace_Croix;      
      
      Cour : Pointeur;      
   begin
      for I in T'Range loop
         Cour := T(I).Voisins.Tete;
         while Cour /= null loop
	    Svg_Line (T(I).Pos, T(Cour.Ind).Pos,Noir); -- Trace l'arrete
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
		     & " C" & Pt2Svg (C1) & Pt2Svg (C2)
		     & Pt2Svg (A) & """ />");
      end Svg_Curve;
      
      Depart : Indice; -- Sommet de depart du tracé
      SCour, SOpp, SCand, SCible : Indice;
      ArreteCour, ArreteCible : Arrete;
      AngleMin, AngleCour : Float;
      Trig : Boolean;
      Cour : Pointeur;
      Path:Boolean:=False;
      
      procedure Trouve_Cible is
	 
	 procedure Recupere_ArreteCible is
	    Local_Cour : Pointeur := T(SCible).Voisins.Tete;
	 begin
	    while Local_Cour /= null loop
	       if Local_Cour.Ind = SCour then
		  ArreteCible := Local_Cour.A.all;
		  --  Put_Line("indice" & Integer'Image( Integer (Local_Cour.Ind)));
		  Put (ArreteCible);
		  return; 
	       end if;
	       Local_Cour := Local_Cour.Suiv;
	    end loop;
	 end Recupere_ArreteCible;
	 
	 function Calcul_Angle (SCour, SOpp, SCand : Point;
				Trig : Boolean) return Float
	 is
	    
	    Angle : Float;
	    LScour_Sopp :Float; 	--  Longueur de l'arrete courante
	    LSOpp_Scand:Float;         	--  Distance entre le sommet opposé de l'arrete courante et le sommet candidat
	    LScand_Scour:Float;		--  Longueur de l'arrete candidate
	    Base : constant Float := 360.0;
	    Interm : Float;
	    Determinant:Float;		--  Determinant des vecteurs (Scour_Sopp,Scour_Scand)
	    
	    function Signe (Expression : Float) return Float is
	    begin
	       if Expression > 0.0 then
		  return 1.0;
	       else
		  return -1.0;
	       end if;
	    end Signe;
	    
	 begin
	    
	    --  Put (Scour); 
	    --  Put (SOpp); 
	    --  Put (SCand);
	    
	    LScour_Sopp := sqrt((Sopp.X-Scour.X)**2 + (Sopp.Y-Scour.Y)**2);
	    
	    LSopp_Scand := sqrt((SOpp.X-SCand.X)**2 + (SOpp.Y-SCand.Y)**2);
	    
	    LScand_Scour := sqrt((Scand.X-SCour.X)**2 + (Scand.Y-Scour.Y)**2);	
	    
	    Determinant := ((Sopp.X-Scour.X)*(Scand.Y-Scour.Y) - 
			      (Sopp.Y-Scour.Y)*(Scand.X-Scour.X));
	    
	    Interm := ((Sopp.X-Scour.X)*(SCand.X-Scour.X) +
	 		 (Sopp.Y-Scour.Y)*(SCand.Y-Scour.Y)) /
	      (LScour_Sopp*LScand_Scour);	    	    	    
	    
	    
	    Angle := Arccos(Interm , Base)*Signe(Determinant);
	    
	    if Angle < 0.0 then
	       Angle:=360.0 + Angle;
	    end if;
	    
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
	       --  Put_Line ("SCour="&Integer'Image(Integer(SCour))
	       --  		   &"  SOpp="&Integer'Image(Integer(SOpp))
	       --  		   &"  SCand="&Integer'Image(Integer(SCand)));
	       
	       AngleCour := Calcul_Angle (T(SCour).Pos, 
	       				  T(SOpp).Pos, 
	       				  T(SCand).Pos,
					  Trig);
	       	       	       
	       if AngleCour < AngleMin then
		  --  Put_Line ("AngleCour: " & Float'Image (AngleCour)
		  --  	      & " < AngleMin: " & Float'Image (AngleMin));
		  AngleMin := AngleCour;
		  SCible := SCand;
	       --  else
		  --  Put_Line ("AngleCour: " & Float'Image (AngleCour) & " > AngleMin: " & Float'Image (AngleMin));
	       end if;
	    end if;
	    
	    Cour := Cour.Suiv;
	 end loop;
	 	 --  Put_Line ("SCible="&Integer'Image(Integer(SCible)));
	 Recupere_ArreteCible; 
	 
      exception
	 when Arrete_Unique =>
	    SCible := Cour.Ind;

	    Recupere_ArreteCible;
      end Trouve_Cible;
      
      procedure Trace_Bezier is	 
      begin
	 if Path=False then
	    Put (Fichier_Svg, "<g");
	    Put(Fichier_Svg, " id=");
	    Put(Fichier_Svg, """noeud");
	    Put(Fichier_Svg,""" style=""");
	    Put(Fichier_Svg, "stroke:");
	    Put(Fichier_Svg,"rgb(255,0,0) ; fill: none ");
	    Put_Line(Fichier_Svg,"; stroke-width: 0.1"">");
	    Path:=True;
	 end if;
	 if Trig then
	    --  Put_Line("Milieu Départ :" & "(" & Float'Image(ArreteCour.Milieu.X) & " ' " & Float'Image(ArreteCour.Milieu.Y) & ")");
	    --  Put_Line("Milieu Arrivé :" & "(" & Float'Image(ArreteCible.Milieu.X) & " ' " & Float'Image(ArreteCible.Milieu.Y) & ")");
	    --  Put_Line("Points de Controles :" & "(Trig Cour)" & Point2Str (ArreteCour.MyPDC.Trig) & "(Inv Cible)" & Point2Str (ArreteCible.OppPDC.Inv));
	    Svg_Curve (ArreteCour.Milieu, ArreteCible.Milieu, 
		       ArreteCour.MyPDC.Trig, ArreteCible.OppPDC.Inv);
	    Trig := False;
	 else
	    --  Put_Line("Milieu Départ :" & "(" & Float'Image(ArreteCour.Milieu.X) & " ' " & Float'Image(ArreteCour.Milieu.Y) & ")");
	    --  Put_Line("Milieu Arrivé :" & "(" & Float'Image(ArreteCible.Milieu.X) & " ' " & Float'Image(ArreteCible.Milieu.Y) & ")");
	    --  Put_Line("Points de Controles :" & "(Inv Cour)" & Point2Str (ArreteCour.MyPDC.Inv) & "(Trig Cible)" & Point2Str (ArreteCible.OppPDC.Trig));
	    Svg_Curve (ArreteCour.Milieu, ArreteCible.Milieu, 
		       ArreteCour.MyPDC.Inv, ArreteCible.OppPDC.Trig);	 
	    Trig := True;
	 end if;
	 
      end Trace_Bezier;
      
      Count : Indice := 0;
   begin    
      -- Initialisation
      Depart := T'First; -- On part toujours du premier element
      --  Put_Line ("Départ: " & Integer'Image (Integer(Depart)));
      Put (T(Depart));
      SCour := Depart;      
      ArreteCour := T(SCour).Voisins.Tete.A.all;
      
      Trig := True; -- On part dans le sens Trigo
      
      loop 	 
	 AngleMin := 360.0;
	 SOpp := ArreteCour.OppID;
	 Cour := T(SCour).Voisins.Tete;
	 
	 Trouve_Cible;
	 Trace_Bezier;
	 
	 --  Put_Line ("SCible: " & Integer'Image (Integer(SCible)));
	 
	 SCour := SCible;
	 ArreteCour := ArreteCible;
	 
	 Count := Count + 1;
	 exit when Count = 2 * (T'Last - 1); New_Line;
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
      
      Put_Line(Fichier_Svg,"</g>");
      Svg_Footer;
      Close (Fichier_Svg);
   end Sauvegarde;
end Svg;
