with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

package Objects is
   
   type Point is record 
      X : Float;
      Y : Float;
   end record;
   
   type Vertex is record
      Pos : Point; -- Vertex's Location
      Edges : Natural;-- Number of adjacent edges
      Neighbors : array(1..Edges) of Natural; -- Index of adjacent vertexes
   end record;
   
   
   
end Objects;
