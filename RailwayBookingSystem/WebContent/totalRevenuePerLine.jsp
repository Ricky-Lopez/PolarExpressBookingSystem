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
		<title>Total Revenue per Transit Line</title>
	</head>
	<body>
		<jsp:include page="navBarAdmin.jsp"/>	
		<h1>Total Revenue per Transit Line</h1>
		
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
				String query = "SELECT lineName as linename, SUM(totalFare) AS revenue FROM books GROUP BY linename";
				//String query = "SELECT YEAR(creationDate) as year, MONTH(creationDate) AS month FROM books GROUP BY YEAR(creationDate), MONTH(creationDate)";  //works without revenue sum
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
				out.print("Total Revenue");
				out.print("</td>");
				out.print("</tr>");

				//parse out the results
				while (rs.next()) {
					//make a row
					out.print("<tr>");
					//make a column
					out.print("<td>");

					String transitLineName = rs.getString("linename");
					//System.out.println(transitLineName);
					out.print(transitLineName);
					out.print("</td>");
					
					out.print("<td>");
					String revenue = rs.getString("revenue");
					//System.out.println(revenue);
					//System.out.println();
					out.print(revenue);
					out.print("</td>");
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