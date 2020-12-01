<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
String reservationNO = request.getParameter("reservationNO"); 
String username = session.getAttribute("userID").toString();  //username of logged-in user
String email = ""; //figure out how to get email

try{
	ApplicationDB db = new ApplicationDB();	
	Connection connection = db.getConnection();
	
	Statement statement = connection.createStatement();
	/*String insert = "INSERT INTO questions(questions, username) VALUES (?, ?)";
	PreparedStatement pStatement = connection.prepareStatement(insert);
	pStatement.setString(1, question);
	pStatement.setString(2, username);
	
	pStatement.executeUpdate();*/
	
	connection.close();
	out.print("Reservation cancelled.");
	out.print("<meta http-equiv=\"Refresh\" content=\"0; url='viewReservation.jsp?reservationNO=reservationNO'\" />");  //Reservation updated to cancelled -> Page refreshed
	
} catch(Exception ex){
	out.print("ReservationNO: " + reservationNO);
	out.print("\n");
	out.print("username: " + username);
	out.print("\n");
	out.print("Error");
}
%>