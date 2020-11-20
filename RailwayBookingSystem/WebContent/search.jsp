<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Search</title>
	</head>
	
	<body>
	<jsp:include page="navBar.jsp"/>	
	
	Sort
	<form method="get" action="refinedSearch.jsp">
		<table>
		<tr>    
		<td>Departure Time</td><td><input type="text" name="departureTime" maxlength=5></td>
		</tr>
		<tr>
		<td>Arrival Time</td><td><input type="text" name="arrivalTime" maxlength=5></td>
		</tr>
		<tr>
		<td>Fare</td><td><input type="text" name="fare" maxlength=20></td>
		</tr>
		</table>
		<input type="submit" value="Search">
	</form>
	<br>
	<br>
	Train Schedules
	<br>
		Search results go here! :D
	<br>
	</body>
</html>