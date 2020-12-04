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
Integer age = Integer.parseInt(request.getParameter("age"));
String userType = request.getParameter("command");

try{
	ApplicationDB db = new ApplicationDB();	
	Connection connection = db.getConnection();
	
	Statement statement = connection.createStatement();
	
	//if userType is passenger
	if (userType.equals("passenger")){
		String insert = "INSERT INTO passengers(email, username, password, " 
				+ "first_name, last_name, age) VALUES (?, ?, ?, ?, ?, ?)";
		PreparedStatement pStatement = connection.prepareStatement(insert);
		pStatement.setString(1, email);
		pStatement.setString(2, username);
		pStatement.setString(3, password);
		pStatement.setString(4, firstName);
		pStatement.setString(5, lastName);
		pStatement.setInt(6, age);
		
		pStatement.executeUpdate();
	}
	
	//else if userType is representative
	else if (userType.equals("representative")){
		String insert = "INSERT INTO employees(email, username, password, " 
				+ "first_name, last_name, isAdmin) VALUES (?, ?, ?, ?, ?, ?)";
		PreparedStatement pStatement = connection.prepareStatement(insert);
		pStatement.setString(1, email);
		pStatement.setString(2, username);
		pStatement.setString(3, password);
		pStatement.setString(4, firstName);
		pStatement.setString(5, lastName);
		pStatement.setBoolean(6, false);
		
		pStatement.executeUpdate();
	}
	
	//else userType is admin
	else{
		String insert = "INSERT INTO employees(email, username, password, " 
				+ "first_name, last_name, isAdmin) VALUES (?, ?, ?, ?, ?, ?)";
		PreparedStatement pStatement = connection.prepareStatement(insert);
		pStatement.setString(1, email);
		pStatement.setString(2, username);
		pStatement.setString(3, password);
		pStatement.setString(4, firstName);
		pStatement.setString(5, lastName);
		pStatement.setBoolean(6, true);
		
		pStatement.executeUpdate();
	}
	
	connection.close();
	out.print("Registration Success!");
	out.print("<br><form action=\"login.jsp\"><input type=\"submit\" value=\"Continue to login\"></form></br>");
	
} catch(Exception ex){
	if (ex.toString().contains("passengers.PRIMARY") || ex.toString().contains("employees.PRIMARY")){
		out.print("This email address is already associated with an account.");
		out.print("<br><form action=\"login.jsp\"><input type=\"submit\" value=\"Continue to login\"></form></br>");
	}
	else{
		out.print("This username is used by another account. Please try again with a different username.");
		out.print(userType);
		out.print("<br><form action=\"registration.jsp\"><input type=\"submit\" value=\"Continue to registration\"></form></br>");
	}
}
%>
