with GNAT.Sockets;
with System.Multiprocessors; use System.Multiprocessors;

package SocketTask is

   type Byte     is mod 2**8;
   Tasks_To_Create : constant Integer := Integer(System.Multiprocessors.Number_Of_CPUs); -- simultaneous socket connections.

   -------------------------------------------------------------------------------
   -- Use stack to pop the next free task index. When a task finishes its
   -- asynchronous (no rendezvous) phase, it pushes the index back on the stack.
   type Integer_List is array (1..Tasks_To_Create) of integer;
   subtype Counter is integer range 0 .. Tasks_To_Create;
   subtype Index is integer range 1 .. Tasks_To_Create;
   
   
   protected type Info is
      procedure Push_Stack (Return_Task_Index : in Index);
      procedure Initialize_Stack;
      entry Pop_Stack (Get_Task_Index : out Index);
   private
      Task_Stack   : Integer_List; -- Stack of free-to-use tasks.
      Stack_Pointer: Counter := 0;
   end Info; 
   
   Task_Info : Info;
   -------------------------------------------------------------------------------
   task type AsyncSocketTask is
      -- Rendezvous the setup, which sets the parameters for entry Echo.
      entry Setup (Connection : GNAT.Sockets.Socket_Type;
                   Client     : GNAT.Sockets.Sock_Addr_Type;
                   Channel    : GNAT.Sockets.Stream_Access;
                   Task_Index : Index);
      -- accepts the asynchronous phase, i.e. no rendezvous. When the
      -- communication is over, push the task number back on the stack.
      entry Echo;
   end AsyncSocketTask;

end SocketTask;
