<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	//get tomorrow's date so that user cannot select a date who's trains may have already left
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    Calendar c = Calendar.getInstance();
    c.add(Calendar.DATE, 1);
    String minDate = df.format(c.getTime());
	


%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Representatives Home</title>
	</head>
	<body>
		<jsp:include page="navBarRepresentative.jsp"/>	
		<h1> Representative Home </h1>
		<h2> Welcome, <%=session.getAttribute("userID")%>!</h2>
		
		<%  /*Customer Representatives should be thought of as reservation agents and should be able to:
			Edit and Delete information for train schedules
			Reply to customer questions
			Produce a list of all customers who have reservations on a given transit line and date
			Produce a list of all schedules for a given station (both as origin and as destination)
			(e.g. list of train schedules that have New Brunswick as origin, or list of train
			schedules that have NB as destination) */%>
			
		<form method="post" action="searchRepresentative.jsp">
			<input type="submit" value="Search Train Schedules">
		</form>
		<hr>	
		
		<form action="viewCustomerQuestionsRep.jsp">
			<input type="submit" value="View customer questions">
		</form>
		<hr>
		
		<form method="get" action="viewCustomersRepresentative.jsp">
			<table>
			<tr>    
				<td>Transit Line</td><td><input type="text" name="transitLine" maxlength=30 required></td>
			</tr>
			<tr>
				<td>Date of travel</td><td><input type="date" name="date" min="<%= minDate %>"required></td>
			</tr>
			</table>
			<input type="submit" value="View customers with reservations for given transit line and date">
		</form>
		<hr>
		
		<form method="get" action="viewStationScheduleRepresentative.jsp">
			<table>
			<tr>    
				<td>Station</td><td><input type="text" name="station" maxlength=30 required></td>
			</tr>
			</table>
			<input type="submit" value="View schedules for a given station">
		</form>
		<hr>
	</body>
</html>