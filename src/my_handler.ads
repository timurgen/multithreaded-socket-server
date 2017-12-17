with GNAT.Sockets;
-- simple echo handler
package My_Handler is
   procedure Req_Handler(Conn: GNAT.Sockets.Socket_Type; Stream: GNAT.Sockets.Stream_Access );
end My_Handler;
