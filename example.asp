<!--Firstly, reference Dotenv.asp class file-->
<!--#include file="Dotenv.asp"-->
<%
' After that, create an variable...
Dim env
' ... and instanciate the object...
Set env = new Dotenv
' Finally, load environment file
call env.IniFileLoad("virtual=.env")


' Now, in any part of your code that see "env" object instantiation...
' You just need to call env.getenv("VARIABLE_NAME")

' Variables present in .env
Response.Write("DB_HOST: " & env.getenv("DB_HOST") & "<br>" & vbCrLf)
Response.Write("DB_DATABASE: " & env.getenv("DB_DATABASE") & "<br>" & vbCrLf)
Response.Write("DB_USERNAME: " & env.getenv("DB_USERNAME") & "<br>" & vbCrLf)

' Variables present in SO Environment Variables
Response.Write("PATH: " & env.getenv("PATH") & "<br>" & vbCrLf)
Response.Write("windir: " & env.getenv("windir") & "<br>" & vbCrLf)
Response.Write("TEMP: " & env.getenv("TEMP") & "<br>" & vbCrLf)

' Variables present in Request.ServerVariables
Response.Write("REMOTE_USER: " & env.getenv("REMOTE_USER") & "<br>" & vbCrLf)
Response.Write("SCRIPT_NAME: " & env.getenv("SCRIPT_NAME") & "<br>" & vbCrLf)
Response.Write("REQUEST_METHOD: " & env.getenv("REQUEST_METHOD") & "<br>" & vbCrLf)

%>
