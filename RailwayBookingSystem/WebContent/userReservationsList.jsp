<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Reservations</title>
	</head>
	<body>
		<jsp:include page="navBar.jsp"/>	
		Reservations
		
		<%
		String username = session.getAttribute("userID").toString();  //username of logged-in user
		//figure out how to get the email
		String email = "";
		
		List<String> list = new ArrayList<String>();

		try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			
			//Create a SQL statement
			Statement stmt = con.createStatement();
			
			/*//Get the combobox from the index.jsp
			String entity = request.getParameter("price");*/
			
			String str = "SELECT * FROM books WHERE email == " + email;  //change username to email
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);

			//Make an HTML table to show the results in:
			out.print("<table>");

			//make a row
			out.print("<tr>");
			//make a column
			out.print("<td>");
			//print out column header
			out.print("Reservation Number");
			out.print("</td>");
			//make a column
			out.print("<td>");
			out.print("View Reservation");
			out.print("</td>");
			out.print("</tr>");

			//parse out the results
			while (result.next()) {
				//make a row
				out.print("<tr>");
				//make a column
				out.print("<td>");
				//Print out the reservation NO
				out.print(result.getString("reservationNO"));
				String reservationNO = result.getString("reservationNO");
				out.print("</td>");
				out.print("<td>");
				//View reservation button
				out.print("<form action=\"viewReservation.jsp?reservationNO=reservationNO\"><input type=\"submit\" value=\"View\"></form>");
				out.print("</td>");
				out.print("<td>");
			}
			out.print("</table>");

			//close the connection.
			con.close();

		} catch (Exception e) {
			out.print("out");
		}
	%>
	</body>
</html>