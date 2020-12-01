<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
String reservationNO = request.getParameter("reservationNO");
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Reservation #<%out.print("reservationNO");%></title>
	</head>
	<body>
		<jsp:include page="navBar.jsp"/>	
		<br>
		Reservation #<%out.print("reservationNO");%>
		<br>
		<%
		List<String> list = new ArrayList<String>();

		try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			
			//Create a SQL statement
			Statement stmt = con.createStatement();
			
			/*//Get the combobox from the index.jsp
			String entity = request.getParameter("price");*/
			
			String str = "SELECT * FROM books WHERE reservationNO == " + reservationNO;  //change username to email
			
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);

			out.print("Cancelled?: " + result.getBoolean("cancelled"));
			out.print("<br>");
			out.print("Date Created: " + result.getDate("creationDate"));
			out.print("<br>");
			out.print("Transit line: " + result.getString("lineName"));
			out.print("<br>");
			out.print("Total Fare: " + result.getFloat("totalFare"));
			out.print("<br>");
			out.print("Origin: " + result.getInt("origin"));
			out.print("<br>");
			out.print("Destination: " + result.getInt("destination"));
			out.print("<br>");
			
			out.print("<form action=\"cancelReservation.jsp?reservationNO=reservationNO\"><input type=\"submit\" value=\"Cancel\"></form>");
			
			//close the connection.
			con.close();

		} catch (Exception e) {
			out.print("error");
		}
		%>
	</body>
</html>