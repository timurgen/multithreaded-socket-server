with SocketTask; use SocketTask;
package body SocketServer is

   ------------------
   -- SocketServer --
   ------------------

   task body MultithreadedSocketServer is
      Receiver   : GNAT.Sockets.Socket_Type;
      Connection : GNAT.Sockets.Socket_Type;
      Client     : GNAT.Sockets.Sock_Addr_Type;
      Channel    : GNAT.Sockets.Stream_Access;
      Worker     : array (1..Tasks_To_Create) of AsyncSocketTask;
      Use_Task   : Index;

   begin
      accept Listen;
      GNAT.Sockets.Create_Socket (Socket => Receiver);
      GNAT.Sockets.Set_Socket_Option
        (Socket => Receiver,
         Option => (Name    => GNAT.Sockets.Reuse_Address, Enabled => True));
      GNAT.Sockets.Bind_Socket
        (Socket  => Receiver,
         Address => (Family => GNAT.Sockets.Family_Inet,
                     Addr   => GNAT.Sockets.Inet_Addr ("0.0.0.0"),
                     Port   => my_Port));
      GNAT.Sockets.Listen_Socket (Socket => Receiver);
      Task_Info.Initialize_Stack;
      Find: loop -- Block for connection and take next free task.
         GNAT.Sockets.Accept_Socket
           (Server  => Receiver,
            Socket  => Connection,
            Address => Client);
         Channel := GNAT.Sockets.Stream (Connection);
         Task_Info.Pop_Stack(Use_Task); -- Protected guard waits if full house.
         -- Setup the socket in this task in rendezvous.
         Worker(Use_Task).Setup(Connection,Client, Channel,Use_Task);
         -- Run the asynchronous task for the socket communications.
         Worker(Use_Task).Echo; -- Start echo loop.
      end loop Find;
   end MultithreadedSocketServer;

end SocketServer;
