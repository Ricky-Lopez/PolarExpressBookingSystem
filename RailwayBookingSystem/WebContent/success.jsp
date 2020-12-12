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
		<form method="post" action="search.jsp">
			<input type="submit" value="Search Train Schedules">
		</form>
	<br>
	<hr>
	<form method="post" action="viewCurrentReservations.jsp">
		<input type="submit" value="View Current Reservations">
	</form>
	
	<form method="post" action="viewPastReservations.jsp">
		<input type="submit" value="View Past Reservations">
	</form>
	
	<form method="post" action="sendQuestion.jsp">
		<table>
		<tr>
			<td>Have a question? Send it to our customer representatives! (max 100 characters)</td>
		</tr>
		<tr>
			<td><input type="text" name="questionText" maxlength=100 required></td>
		</tr>
		<tr>
			<td><input type="submit" value="Send"></td>
		</tr>
		</table>
	</form>
	</body>
</html>