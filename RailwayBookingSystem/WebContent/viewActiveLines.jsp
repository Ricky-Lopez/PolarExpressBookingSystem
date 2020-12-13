<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<style>
			table, th, td {
	  			border: 1px solid black;
	  			padding: 2px;
	  			border-collapse: collapse;
			}
			tr:nth-child(even) {
			  background-color: #f2f2f2;
			}
		</style>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Top 5 Active Lines</title>
	</head>
	<body>
		<jsp:include page="navBarAdmin.jsp"/>	
		<h1>Top 5 Most Active Transit Lines by Reservations</h1>
		<h2>(Descending Order)</h2>
		
		<%
			try {
				//Get the database connection
				/*ApplicationDB db = new ApplicationDB();	
				Connection con = db.getConnection();	
					
				String query = "SELECT YEAR(creationDate) as year, MONTH(creationDate) AS month, SUM(PRICE) AS revenue FROM books " 
					+ "GROUP BY YEAR(creationDate), MONTH(creationDate) ORDER BY YEAR(creationDate), MONTH(creationDate)";
		
				Statement statement = con.createStatement();
				//PreparedStatement pStatement = connection.prepareStatement(query);

				//Run the query against the database
				ResultSet result = statement.executeQuery(query);*/
				ApplicationDB db = new ApplicationDB();
				Connection connection = db.getConnection();
				//get all of this user's reservations
				//String query = "SELECT DISTINCT lineName as linename, ((SELECT COUNT(reservationNo) FROM books) / (SELECT distinct COUNT(MONTH(creationDate)) FROM books)) AS numReservations FROM books GROUP BY linename ORDER BY numReservations desc LIMIT 5";
				//String query = "SELECT DISTINCT lineName as linename, SELECT COUNT(reservationNo) AS numReservations, SELECT COUNT(MONTH(creationDate)) as numMonths FROM books GROUP BY linename ORDER BY numReservations desc LIMIT 5";
				String query = "SELECT DISTINCT lineName as linename, COUNT(reservationNo) AS numReservations FROM books GROUP BY linename ORDER BY numReservations desc LIMIT 5";  //num reservations/2
				PreparedStatement pStatement = connection.prepareStatement(query);
				ResultSet rs = pStatement.executeQuery();
				
				//Make an HTML table to show the results in:
				out.print("<table>");

				//make a row
				out.print("<tr>");
				//make a column
				out.print("<td>");
				//print out column header
				out.print("Transit Line");
				out.print("</td>");
				//make a column
				out.print("<td>");
				out.print("# Reservations");
				out.print("</td>");
				/*out.print("<td>");
				out.print("Months");
				out.print("</td>");*/
				out.print("</tr>");

				//parse out the results
				while (rs.next()) {
					//make a row
					out.print("<tr>");
					//make a column
					out.print("<td>");
					String transitLineName = rs.getString("linename");
					out.print(transitLineName);
					out.print("</td>");
					
					out.print("<td>");
					String reservations = rs.getString("numReservations");
					out.print(reservations);
					out.print("</td>");
					
					/*out.print("<td>");
					String months = rs.getString("numMonths");
					out.print(months);
					out.print("</td>");*/
				}
				out.print("</table>");

				//close the connection.
				connection.close();

			} catch (Exception e) {
				out.print("Error");
			}
			
		%>
	</body>
</html>