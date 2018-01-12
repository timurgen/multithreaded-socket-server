with SocketServer; use SocketServer;
with GNAT.Sockets;
with My_Handler; use My_Handler;
with Logger; use Logger;
with HttpParser;
procedure Main is
   My_Callback : Callback := Req_Handler'Access;
   Echo_Server : MultithreadedSocketServer(my_Port => 12008, Handler => My_Callback);
begin
   log(Logger.INFO, "Starting server on port 1885");
   Echo_Server.Listen;
end Main;
