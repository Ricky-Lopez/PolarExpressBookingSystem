<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Registration</title>
	</head>
	<body>
		<form action="login.jsp"><input type="submit" value="Back to login"></form>
		<h1>Create an account</h1>
			<form method="post" action="checkUserType.jsp">
			<table>
			<tr>
				<td>
				<input type="radio" name="command" value="passenger"/> I am a regular user</td>
				</tr>
				<tr>
				<td><input type="radio" name="command" value="representative"/> I am a customer representative</td>
				</tr>
				<tr>
				<td><input type="radio" name="command" value="admin"/> I am an admin</td>
				</tr>
			</table>
			<br>
			<input type="submit" value="Create account">
			</form>
	</body>
</html>