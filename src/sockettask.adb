with System.Multiprocessors.Dispatching_Domains; use System.Multiprocessors.Dispatching_Domains;
with Ada.Text_IO;
with Ada.IO_Exceptions;
with Ada.Exceptions; use Ada.Exceptions;
package body SocketTask is

   ----------
   -- Info --
   ----------

   protected body Info is
      procedure Push_Stack (Return_Task_Index : in Index) is
      begin -- Performed by tasks that were popped, so won't overflow.
         Stack_Pointer := Stack_Pointer + 1;
         Task_Stack(Stack_Pointer) := Return_Task_Index;
      end;

      entry Pop_Stack (Get_Task_Index : out Index) when Stack_Pointer /= 0 is
      begin -- guarded against underflow.
         Get_Task_Index := Task_Stack(Stack_Pointer);
         Stack_Pointer := Stack_Pointer -  1;
      end;

      procedure Initialize_Stack is
      begin
         for I in Task_Stack'range loop
            Push_Stack (I);
         end loop;
      end;
   end Info;

   ----------------
   -- SocketTask --
   ----------------

   task body AsyncSocketTask is
      my_Connection : GNAT.Sockets.Socket_Type;
      my_Client     : GNAT.Sockets.Sock_Addr_Type;
      my_Channel    : GNAT.Sockets.Stream_Access;
      my_Index      : Index;
   begin
      loop -- Infinitely reusable
         accept Setup (Connection : GNAT.Sockets.Socket_Type;
                       Client  : GNAT.Sockets.Sock_Addr_Type;
                       Channel : GNAT.Sockets.Stream_Access;
                       Task_Index   : Index) do
            -- Store parameters and mark task busy.
            my_Connection := Connection;
            my_Client     := Client;
            my_Channel    := Channel;
            my_Index      := Task_Index;
            Set_CPU(CPU_Range(Task_Index));
         end;

         accept ProcessRequest;
         begin
            null;
            --read byte from input stream
            -- my_Packet_Type := Byte'Input(my_Channel);
            --write byte to stream
            -- Byte'Write (my_Channel, 2#00100000#);
         exception
            when Ada.IO_Exceptions.End_Error =>
               Ada.Text_IO.Put_Line ("Echo " & integer'image(my_Index) & " end");
            when Error: others =>
               Ada.Text_IO.Put_Line ("Echo " & integer'image(my_Index) & " err " & Exception_Information(Error));
         end;
         GNAT.Sockets.Close_Socket (my_Connection);
         Task_Info.Push_Stack (my_Index); -- Return to stack of unused tasks.
      end loop;
   end AsyncSocketTask;

end SocketTask;
