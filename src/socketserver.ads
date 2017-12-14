with GNAT.Sockets;

package SocketServer is
   -------------------------------------------------------------------------------
   -- Setup the socket receiver, initialize the task stack, and then loop,
   -- blocking on Accept_Socket, using Pop_Stack for the next free task from the
   -- stack, waiting if necessary.
   task type MultithreadedSocketServer (my_Port : GNAT.Sockets.Port_Type) is
      entry Listen;
   end MultithreadedSocketServer;

end SocketServer;
