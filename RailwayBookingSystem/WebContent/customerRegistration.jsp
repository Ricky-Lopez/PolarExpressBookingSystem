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
			<form method="post" action="registerUser.jsp">
			<table>
			<tr>    
			<td>Username</td><td><input type="text" name="username" maxlength="20" required></td>
			</tr>
			<tr>
			<td>Email Address</td><td><input type="email"  name="email" maxlength="40" required></td>
			</tr>
			<tr>
			<td>First Name</td><td><input type="text" name="firstName" maxlength="20" required></td>
			</tr>
			<tr>
			<td>Last Name</td><td><input type="text" name="lastName" maxlength="20" required></td>
			</tr>
			<tr>
			<td>Password</td><td><input type="password" name="password" pattern=".{4,}" title="password must be at least 4 characters" maxlength="20" required></td>
			</tr>
			<tr>
			<td>Age</td><td><input type="text" name="age" maxlength="3" required></td>
			</tr>
			<tr>
			<td>Passenger is Disabled</td><td><input type="checkbox" id="disabled" name="isDisabled" value="true"></td>
			</tr>
			</table>
			<br>
			<input type="hidden" name="userType" value="passenger">
			<input type="submit" value="Create account">
			</form>
		<br>
	</body>
</html>