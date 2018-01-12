with Ada.Text_IO; use Ada.Text_IO;
package body Logger is

   ---------
   -- log --
   ---------

   procedure log (Log_Level: Level; Message: String) is
   begin
      Put_Line(Log_Level'Image & ": " & Message);
   end log;

end Logger;
