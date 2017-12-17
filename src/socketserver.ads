with GNAT.Sockets;

package SocketServer is
   type Callback is access procedure (Conn: GNAT.Sockets.Socket_Type; Stream: GNAT.Sockets.Stream_Access);
   -------------------------------------------------------------------------------
   -- Setup the socket receiver, initialize the task stack, and then loop,
   -- blocking on Accept_Socket, using Pop_Stack for the next free task from the
   -- stack, waiting if necessary.
   task type MultithreadedSocketServer (my_Port : GNAT.Sockets.Port_Type; Handler: Callback) is
      entry Listen;
   end MultithreadedSocketServer;

end SocketServer;
