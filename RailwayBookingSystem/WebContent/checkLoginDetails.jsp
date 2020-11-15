<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
String username = request.getParameter("username");
String password = request.getParameter("password");

ApplicationDB db = new ApplicationDB();
Connection connection = db.getConnection();

Statement statement = connection.createStatement();
String stmt = "SELECT username, password FROM passengers " +
	"WHERE username LIKE '" + username + "' AND password LIKE '" + password + "'";

ResultSet rs = statement.executeQuery(stmt);
System.out.println(rs.getMetaData().getColumnCount());
if(rs.next()){
	session.setAttribute("userID", username);
	out.print("<meta http-equiv=\"Refresh\" content=\"0; url='success.jsp'\" />");
}else{
	out.print("Invalid username or password. Please try again.");
	out.print("<br><form action=\"login.jsp\"><input type=\"submit\" value=\"Back to login\"></form></br>");
}

connection.close();
%>