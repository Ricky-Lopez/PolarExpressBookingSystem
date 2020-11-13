<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
String username = request.getParameter("username");
String email = request.getParameter("email");
String firstName = request.getParameter("firstName");
String lastName = request.getParameter("lastName");
String password = request.getParameter("password");

try{
	ApplicationDB db = new ApplicationDB();	
	Connection connection = db.getConnection();
	
	Statement statement = connection.createStatement();
	String insert = "INSERT INTO passengers(email, username, password, " 
			+ "first_name, last_name) VALUES (?, ?, ?, ?, ?)";
	PreparedStatement pStatement = connection.prepareStatement(insert);
	pStatement.setString(1, email);
	pStatement.setString(2, username);
	pStatement.setString(3, password);
	pStatement.setString(4, firstName);
	pStatement.setString(5, lastName);
	
	pStatement.executeUpdate();
	
	connection.close();
	out.print("Registration Success!");
	out.print("<br><form action=\"login.jsp\"><input type=\"submit\" value=\"Continue to login\"></form></br>");
	
} catch(Exception ex){
	if (ex.toString().contains("passengers.PRIMARY")){
		out.print("This email address is already associated with an account.");
		out.print("<br><form action=\"login.jsp\"><input type=\"submit\" value=\"Continue to login\"></form></br>");
	}
	else{
		out.print("This username is in user by another account. Please try again with a different username.");
		out.print("<br><form action=\"registration.jsp\"><input type=\"submit\" value=\"Continue to registration\"></form></br>");
	}
}
%>
