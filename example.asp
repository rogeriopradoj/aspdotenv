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
Response.Write("DB_HOST: " & env.getenv("DB_HOST") & "<br>" & vbCrLf)
Response.Write("DB_DATABASE: " & env.getenv("DB_DATABASE") & "<br>" & vbCrLf)
Response.Write("DB_USERNAME: " & env.getenv("DB_USERNAME") & "<br>" & vbCrLf)

%>
