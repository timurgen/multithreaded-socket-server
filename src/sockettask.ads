with SocketServer; use SocketServer;
with GNAT.Sockets;
with System.Multiprocessors; use System.Multiprocessors;

package SocketTask is

   -- simultaneous socket connections.
   Tasks_To_Create : constant Integer := Integer(Number_Of_CPUs); 

   -------------------------------------------------------------------------------
   -- Use stack to pop the next free task index. When a task finishes its
   -- asynchronous (no rendezvous) phase, it pushes the index back on the stack.
   type Integer_List is array (1..Tasks_To_Create) of integer;
   
   subtype Counter is integer range 0 .. Tasks_To_Create;
   
   subtype Index is integer range 1 .. Tasks_To_Create;
   
   -- stack info type
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
      -- Rendezvous the setup, which sets the parameters for entry ProcessRequest.
      entry Setup (Connection : GNAT.Sockets.Socket_Type;
                   Client     : GNAT.Sockets.Sock_Addr_Type;
                   Channel    : GNAT.Sockets.Stream_Access;
                   Task_Index : Index;
                   Handler    : Callback);
      -- accepts the asynchronous phase, i.e. no rendezvous. When the
      -- communication is over, push the task number back on the stack.
      entry ProcessRequest;
   end AsyncSocketTask;

end SocketTask;
