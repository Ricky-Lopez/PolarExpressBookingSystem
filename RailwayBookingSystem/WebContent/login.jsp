<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Log-in</title>
	</head>
	<body>
		Log-in
		<br>
			<form method="post" action="checkLoginDetails.jsp">
			<table>
			<tr>    
			<td>Username</td><td><input type="text" name="username" maxlength=20 required></td>
			</tr>
			<tr>
			<td>Password</td><td><input type="text" name="password" pattern=".{4,}" title="password must be at least 4 characters" maxlength=20 required></td>
			</tr>
			</table>
			<input type="submit" value="Log-in">
			</form>
		<br>
		
		<form action="registration.jsp">
			<input type="submit" value="Create an account">
		</form>
	</body>
</html>