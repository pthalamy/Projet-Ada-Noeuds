with Ada.Text_IO, Ada.Unchecked_Deallocation;
use Ada.Text_IO;

with Objets;
use Objets;

package body Pile is
   
   procedure Push (Tete : in out Pile; I : in Indice) is
   begin                 
      Tete := new Pile'(I, Tete);
      
      if Tete = null then
	 raise Memoire_Pleine;	 
      end if;
      
   end Push;
   
   --  procedure Push_Back (Tete : in out Pile; I : in Indice) is
   --     Cour : Pile := Tete;
   --  begin                 
   --     while Cour /= null loop
   --  	 Cour := Cour.Suiv;
   --     end loop;        
      
   --     Push (Cour, I)            
   --  end Push;
   
   procedure Pop (Tete : in out Pile) is
      procedure Free is new Ada.Unchecked_Deallocation(Cellule, Pile);
      Temp : Tete;
   begin
      if Temp = null then
	 raise Pile_Vide;
      end if;
      
      Tete := Tete.Suiv;
      Free (Temp);
      
   exception
      when => Pile_Vide
	 Put_Line ("Pile_Vide: Impossible de dépiler, la pile est vide.");
   end Pop;
   
   procedure Put (Tete : in Pile) is 
      Cour : Pile;
   begin
      if Tete = null then
	 raise Pile_Vide;
      end if;
      
      Cour := Tete;
      
      while Cour /= null loop
	 New_Line;
	 Put (Cour.Val);
	 Cour := Cour.Suiv;
	 New_Line;
      end loop;
      
   exception
      when Pile_Vide =>
	 Put_Line ("Pile_Vide: Affichage impossible, la pile est vide.");	 
   end Put;    
   
end Pile;
