ASP dotenv
==========

This is a ASP version of the original [PHP Dotenv](https://github.com/vlucas/phpdotenv).

When using PHP dotenv, it loads environment variables from `.env` to `getenv()`, `$_ENV` and
`$_SERVER` automagically.

In asp, we will try to do same same, but using always a function wrapper for `.env`, and result of `Request.ServerVariables` and `WScript.Shell.Environment("PROCESS")` ([more info here](https://stackoverflow.com/questions/6360036/getting-environment-variables-in-classic-asp?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa)).

Here is an example of usage:

```asp
<!--
file: example.asp
-->

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
```

Why .env?
---------
**You should never store sensitive credentials in your code**. Storing
[configuration in the environment](http://www.12factor.net/config) is one of
the tenets of a [twelve-factor app](http://www.12factor.net/). Anything that is
likely to change between deployment environments – such as database credentials
or credentials for 3rd party services – should be extracted from the
code into environment variables.

Basically, a `.env` file is an easy way to load custom configuration
variables that your application needs without having to modify server configuration.
This means you won't have to edit
any files outside the project, and all the environment variables are
always set no matter how you run your project.
It's WAY easier than all the other
ways you know of to set environment variables, and you're going to love
it.

* NO editing server configuration
* EASY portability and sharing of required ENV values

Usage
-----
The `.env` file is generally kept out of version control since it can contain
sensitive API keys and passwords. A separate `.env.example` file is created
with all the required environment variables defined except for the sensitive
ones, which are either user-supplied for their own development environments or
are communicated elsewhere to project collaborators. The project collaborators
then independently copy the `.env.example` file to a local `.env` and ensure
all the settings are correct for their local environment, filling in the secret
keys or providing their own values when necessary. In this usage, the `.env`
file should be added to the project's `.gitignore` file so that it will never
be committed by collaborators.  This usage ensures that no sensitive passwords
or API keys will ever be in the version control history so there is less risk
of a security breach, and production values will never have to be shared with
all project collaborators.

Add your application configuration to a `.env` file in the root of your
project. **Make sure the `.env` file is added to your `.gitignore` so it is not
checked-in the code**

```shell
S3_BUCKET="dotenv"
SECRET_KEY="souper_seekret_key"
```

Now create a file named `.env.example` and check this into the project. This
should have the ENV variables you need to have set, but the values should
either be blank or filled with dummy data. The idea is to let people know what
variables are required, but not give them the sensitive production values.

```shell
S3_BUCKET="devbucket"
SECRET_KEY="abc123"
```

Usage Notes
-----------

When a new developer clones your codebase, they will have an additional
**one-time step** to manually copy the `.env.example` file to `.env` and fill-in
their own values (or get any sensitive values from a project co-worker).

Environment variables order
---------------------------

We try to use [PHP EGPCS (Environment, Get, Post, Cookie, and Server)](http://us.php.net/manual/en/ini.core.php#ini.variables-order).

So, remember it when your application is trying to load a variable that was set in more than one place.

Top is used:

* `.env` file
* SO environment variable
* Request.ServerVariables

### Example 1 (`.env` file and SO Environment Variable)

* `.env`

 ```shell
TEMP=my_name
```

* SO Environment Variable

```shell
TEMP=another_name
```

* Result in asp
```
<%
Response.Write("TEMP: " & env.getenv("TEMP") & "<br>" & vbCrLf)

' TEMP: my_name
%>
```

### Example 2 (SO Environment Variable and Request.ServerVariables)

* SO Environment Variable

 ```shell
REMOTE_USER=my_name
```

* Request.ServerVariables

```shell
REMOTE_USER=another_name
```

* Result in asp
```
<%
Response.Write("REMOTE_USER: " & env.getenv("REMOTE_USER") & "<br>" & vbCrLf)

' REMOTE_USER: my_name
%>
```
