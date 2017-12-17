with GNAT.Sockets;
with Ada.Text_IO;
with Ada.Strings.Unbounded;
with SocketTask; use SocketTask;
with Ada.IO_Exceptions;
with Ada.Streams; use type Ada.Streams.Stream_Element_Count;
with Ada.Task_Identification;
package body My_Handler is
   type Byte is mod 2**8;
   -----------------
   -- Req_Handler --
   -----------------
   procedure Req_Handler(Conn: GNAT.Sockets.Socket_Type; Stream: GNAT.Sockets.Stream_Access ) is
      use ASCII;
      Current_Byte: Byte;
      T_ID : Ada.Task_Identification.Task_Id := Ada.Task_Identification.Current_Task;
   begin
      loop
         Current_Byte := Byte'Input(Stream);
         exit when Current_Byte = 255;
         Ada.Text_IO.Put_Line(Ada.Task_Identification.Image(T_ID) & " " & Character'Val(Current_Byte));
      end loop;
   end Req_Handler;
end My_Handler;
