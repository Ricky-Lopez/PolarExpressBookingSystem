<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Home</title>
	</head>
	<body>
	<jsp:include page="navBar.jsp"/>	
	
	Welcome, <%=session.getAttribute("userID")%>!
	<br>
	<br>
	Search train schedules
	<br>
		<form method="post" action="checkSearch.jsp">
		<table>
		<tr>    
		<td>Origin Station</td><td><input type="text" name="originStation" maxlength=10></td>
		</tr>
		<tr>
		<td>Destination Station</td><td><input type="text" name="destinationStation" maxlength=10></td>
		</tr>
		<tr>
		<td>Date of travel</td><td><input type="text" name="dateOfTravel" maxlength=20 required></td>
		</tr>
		</table>
		<input type="submit" value="Search">
		</form>
	<br>
	</body>
</html>