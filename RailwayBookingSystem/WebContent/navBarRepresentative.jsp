<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
	<head>
		<title>NavBar</title>
	</head>

	<body>
			<form action="representativeHome.jsp">
				<input type="submit" value="Home">
			</form>
			<form action="logout.jsp">
				<input type="submit" value="Logout">
			</form>
			<br>
	</body>
</html>