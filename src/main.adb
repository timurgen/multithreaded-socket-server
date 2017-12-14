with SocketTask; use SocketTask;
with SocketServer; use SocketServer;

procedure Main is
   Echo_Server : MultithreadedSocketServer(my_Port => 1883);
begin
   Echo_Server.Listen;
end Main;
