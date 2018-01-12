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
      Offset : Ada.Streams.Stream_Element_Count;
      Data   : Ada.Streams.Stream_Element_Array (1 .. 1024);
   begin
      loop
         Ada.Streams.Read (Stream.All, Data, Offset);
         exit when Offset = 0;
         for I in 1 .. Offset loop
            Ada.Text_IO.Put (Character'Val (Data (I)));
         end loop;
      end loop;
      String'Write (Stream, "HTTP/1.1 200 OK");
      GNAT.Sockets.Close_Socket(Socket => Conn);
   end Req_Handler;
end My_Handler;
