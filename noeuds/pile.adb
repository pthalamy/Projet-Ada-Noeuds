with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Unchecked_Deallocation;
use Ada.Text_IO, Ada.Integer_Text_IO;

with Objets;
use Objets;

package body Pile is
   
   procedure Push (Tete : in out Pile_Sommets; I : in Indice) is
   begin                 
      Tete := new Cellule'(I, Tete);
      
      if Tete = null then
	 raise Memoire_Pleine;	 
      end if;
      
   end Push;
   
   --  procedure Push_Back (Tete : in out Pile_Sommets; I : in Indice) is
   --     Cour : Pile_Sommets := Tete;
   --  begin                 
   --     while Cour /= null loop
   --  	 Cour := Cour.Suiv;
   --     end loop;        
      
   --     Push (Cour, I)            
   --  end Push;
   
   procedure Pop (Tete : in out Pile_Sommets; I : out Indice) is
      procedure Free is new Ada.Unchecked_Deallocation(Cellule, Pile_Sommets);
      Temp : Pile_Sommets := Tete;
   begin
      if Temp = null then
	 raise Pile_Vide;
      end if;
      
      I := Tete.Val;
      Tete := Tete.Suiv;
      Free (Temp);
      
   exception
      when Pile_Vide =>
	 Put_Line ("Pile_Vide: Impossible de dépiler, la pile est vide.");
   end Pop;
   
   procedure Put (Tete : in Pile_Sommets) is 
      Cour : Pile_Sommets;
   begin
      if Tete = null then
	 raise Pile_Vide;
      end if;
      
      Cour := Tete;
      
      while Cour /= null loop
	 New_Line;
	 Put (Natural (Cour.Val));
	 Cour := Cour.Suiv;
	 New_Line;
      end loop;
      
   exception
      when Pile_Vide =>
	 Put_Line ("Pile_Vide: Affichage impossible, la pile est vide.");	 
   end Put;    
    
   function Vide (Tete : in Pile_Sommets) return Boolean is 
   begin 
      if Tete = null then
	 return True;
      else 
	 return False;
      end if;
   end Vide;
   
end Pile;
