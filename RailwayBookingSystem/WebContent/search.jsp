<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Search</title>
	</head>
	
	<body>
	<jsp:include page="navBar.jsp"/>	
	
	<%
		//get tomorrow's date so that user cannot select a date who's trains may have already left
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	    Calendar c = Calendar.getInstance();
	    c.add(Calendar.DATE, 1);
	    String minDate = df.format(c.getTime());
		
	
	
	%>
	<form method="get" action="refinedSearch.jsp">
		<table>
			<tr>
				<td> Date of Travel </td>
				<td> Origin Station </td>
				<td> Destination Station </td>
			</tr>
			<tr>
				<td><input type="date" name="date" min="<%= minDate %>"required></td>
				<td>
					<select name="originStation" id="originStation" required>
					<%
					try{
						ApplicationDB db = new ApplicationDB();	
						Connection connection = db.getConnection();
						Statement statement = connection.createStatement();
						String query = "SELECT name, state FROM trainStation";
						ResultSet rs = statement.executeQuery(query);
						while(rs.next()){
							String val = rs.getString(1) + " (" + rs.getString(2) + ")";
							out.write("<option value=\"" + val + "\">" + val + "</option>");
						}
					}catch(Exception ex){
						
					}
					%>
					</select>
				</td>
				<td>
					<select name="destStation" required>
					<%
					try{
						System.out.println("in second try");
						ApplicationDB db = new ApplicationDB();	
						Connection connection = db.getConnection();
						Statement statement = connection.createStatement();
						String query = "SELECT name, state FROM trainStation";
						ResultSet rs = statement.executeQuery(query);
						while(rs.next()){
							System.out.println("in second while");
							String val = rs.getString(1) + " (" + rs.getString(2) + ")";
							out.write("<option value=\"" + val + "\">" + val + "</option>");
						}
						
						connection.close();
					}catch(Exception ex){
						
					}
					%>
					</select>
				</td>	
			</tr>
			</table>
			
			<table>
			<tr><td><input type="radio" id="sortFare" name="sort" value="Fare" required>
				<label for="sortFare">Sort By Fare (lowest-highest)</label><br></td>
			</tr>
			<tr>
				<td><input type="radio" id="sortArrival" name="sort" value="Arrival">
				<label for="sortArrival">Sort By Arrival Time (earliest-latest)</label><br></td>
			</tr>
			<tr>
				<td><input type="radio" id="sortDeparture" name="sort" value="Departure">
				<label for="sortDeparture">Sort By Departure Time (earliest-latest)</label><br></td>
			</tr>
			</table>

		<input type="submit" value="Search">
	</form>
	</body>
</html>