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
			</tr>
			</table>
			
			<table>
			<tr><td><input type="radio" id="sortFare" name="sort" value="Fare">
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