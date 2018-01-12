package Logger is

   type Level is (INFO, WARNING, ERROR, FATAL);
   
   procedure log(Log_Level: Level; Message: String);

end Logger;
