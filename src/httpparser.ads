with Ada.Containers.Hashed_Maps;  use Ada.Containers;
with Ada.Strings.Unbounded;
with Ada.Calendar;
package HttpParser is

   type HTTP_Method is (GET, POST, HEAD, OPTIONS, PUT, DELETE, TRACE, CONNECT);
   type HTTP_Version is new String(1..16);
   
   -- headers
   type Req_Header_Key is new String(1..256);
   type Req_Header_Value_Access is access constant String;
   function Get_Req_Header_Hash(Key: Req_Header_Key) return Hash_Type;
   package Req_Headers_Map 
   is new Ada.Containers.Hashed_Maps(Key_Type => Req_Header_Key,
                                     Element_Type    => Req_Header_Value_Access,
                                     Hash            => Get_Req_Header_Hash,
                                     Equivalent_Keys => "=");
   --params 
   type Req_Param_Key is new String(1..256);
   type Req_Param_Value_Access is access constant String;
   function Get_Req_Param_Hash(Key: Req_Param_Key)return Hash_Type;
   package Req_Parameters_Map 
   is new Ada.Containers.Hashed_Maps(Key_Type        => Req_Param_Key,
                                     Element_Type    => Req_Param_Value_Access,
                                     Hash            => Get_Req_Param_Hash,
                                     Equivalent_Keys => "=");
   
   type Req_Body is new Ada.Strings.Unbounded.Unbounded_String;
   type Req_Body_Access is access all Req_Body;
   
   -- request record
   type HTTP_Request is record
      Timestamp: Ada.Calendar.Time := Ada.Calendar.Clock;
      Version: HTTP_Version;
      Method: Http_Method;
      Headers: Req_Headers_Map.Map;
      Parameters: Req_Parameters_Map.Map;
      Message_Body: Req_Body_Access;
   end record;
   

end HttpParser;
