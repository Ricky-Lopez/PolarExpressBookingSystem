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
	===============================================================================================================
	<br>
	Train Schedules
	<br>
			<%
		List<String> list = new ArrayList<String>();

		try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			
			//Create a SQL statement
			Statement stmt = con.createStatement();

			//String entity = request.getParameter("price");
			
			//FIX THIS
			String str = "SELECT * FROM stopsAt WHERE price <= " + "FIX THIS";
			
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);

			//Make an HTML table to show the results in:
			out.print("<table>");

			//make a row
			out.print("<tr>");
			//make a column
			out.print("<td>");
			//print out column header
			out.print("Train Number");
			out.print("</td>");
			//make a column
			out.print("<td>");
			out.print("Origin Station");
			out.print("</td>");
			//make a column
			out.print("<td>");
			out.print("Destination Station");
			out.print("</td>");
			//make a column
			out.print("<td>");
			out.print("Departure Time");
			out.print("</td>");
			out.print("</tr>");

			//parse out the results   FIX THIS
			while (result.next()) {
				/*//make a row
				out.print("<tr>");
				//make a column
				out.print("<td>");
				//Print out current bar name:
				out.print(result.getString("bar"));
				out.print("</td>");
				out.print("<td>");
				//Print out current beer name:
				out.print(result.getString("beer"));
				out.print("</td>");
				out.print("<td>");
				//Print out current price
				out.print(result.getString("price"));
				out.print("</td>");
				out.print("</tr>");
				*/

			}
			out.print("</table>");

			//close the connection.
			con.close();

		} catch (Exception e) {
			out.print("error");
		}
	%>
	<br>
	</body>
</html>