<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%

String userType = request.getParameter("userType");
try{
	ApplicationDB db = new ApplicationDB();	
	Connection connection = db.getConnection();
	
	Statement statement = connection.createStatement();
	
	//if userType is passenger
	if (userType.equals("passenger")){
		int disabled = 0;
		if(request.getParameter("isDisabled") != null && request.getParameter("isDisabled").equals("true")){
			disabled = 1;
		}
		String insert = "INSERT INTO passengers(email, username, password, " 
				+ "first_name, last_name, age, isDisabled) VALUES (?, ?, ?, ?, ?, ?, ?)";
		PreparedStatement pStatement = connection.prepareStatement(insert);
		pStatement.setString(1, request.getParameter("email"));
		pStatement.setString(2, request.getParameter("username"));
		pStatement.setString(3, request.getParameter("password"));
		pStatement.setString(4, request.getParameter("firstName"));
		pStatement.setString(5, request.getParameter("lastName"));
		pStatement.setInt(6, Integer.parseInt(request.getParameter("age")));
		pStatement.setInt(7, disabled);
		
		pStatement.executeUpdate();
	}
	
	//else if userType is representative
	else if (userType.equals("representative")){
		String insert = "INSERT INTO employees(SSN, username, password, " 
				+ "first_name, last_name, isAdmin) VALUES (?, ?, ?, ?, ?, ?)";
		PreparedStatement pStatement = connection.prepareStatement(insert);
		pStatement.setString(1, request.getParameter("SSN"));
		pStatement.setString(2, request.getParameter("username"));
		pStatement.setString(3, request.getParameter("password"));
		pStatement.setString(4, request.getParameter("firstName"));
		pStatement.setString(5, request.getParameter("lastName"));
		pStatement.setBoolean(6, false);
		
		pStatement.executeUpdate();
	}
	
	//else userType is admin
	else{
		String insert = "INSERT INTO employees(SSN, username, password, " 
				+ "first_name, last_name, isAdmin) VALUES (?, ?, ?, ?, ?, ?)";
		PreparedStatement pStatement = connection.prepareStatement(insert);
		pStatement.setString(1, request.getParameter("SSN"));
		pStatement.setString(2, request.getParameter("username"));
		pStatement.setString(3, request.getParameter("password"));
		pStatement.setString(4, request.getParameter("firstName"));
		pStatement.setString(5, request.getParameter("lastName"));
		pStatement.setBoolean(6, true);
		
		pStatement.executeUpdate();
	}
	
	connection.close();
	out.print("Registration Success!");
	out.print("<br><form action=\"login.jsp\"><input type=\"submit\" value=\"Continue to login\"></form></br>");
	
} catch(Exception ex){
	System.out.println(ex.toString());
	if (ex.toString().contains("passengers.PRIMARY")){
		out.print("This email address is already associated with an account.");
		out.print("<br><form action=\"login.jsp\"><input type=\"submit\" value=\"Continue to login\"></form></br>");
	}
	else if(ex.toString().contains("employees.PRIMARY")){
		out.print("These credentials are already associated with an account.");
		out.print("<br><form action=\"login.jsp\"><input type=\"submit\" value=\"Continue to login\"></form></br>");
	}
	else{
		out.print("This username is used by another account. Please try again with a different username.");
		out.print(userType);
		out.print("<br><form action=\"registration.jsp\"><input type=\"submit\" value=\"Continue to registration\"></form></br>");
	}
}
%>
