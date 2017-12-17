with SocketServer; use SocketServer;
with GNAT.Sockets;
with My_Handler; use My_Handler;

procedure Main is
   My_Callback : Callback := Req_Handler'Access;
   Echo_Server : MultithreadedSocketServer(my_Port => 1883, Handler => My_Callback);
begin
   Echo_Server.Listen;
end Main;
