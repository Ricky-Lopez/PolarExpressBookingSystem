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

boolean isPassenger = false;
boolean isRepresentatitve = false;
boolean isAdmin = false;

/*
  Check if username is a passenger, admin, or representative
  -> Go through passengers table and see if they are in there
  -> If not, go through employees table and see if they are in there
  set one of the 3 booleans above to true
  once you finish this, uncomment my comments below V V V 
*/

String query = "SELECT username, password FROM passengers WHERE username = " + "\"" + username + "\"";
System.out.println(query);
ResultSet rs = statement.executeQuery(query);
if(rs.isBeforeFirst()){ //login is for passenger
	System.out.println("user is passenger");
	rs.next();
	if(rs.getString(2).equals(password)){
		session.setAttribute("userID", username);
		session.setAttribute("userType", "passenger");
		out.print("<meta http-equiv=\"Refresh\" content=\"0; url='success.jsp'\" />");
		return;
	}
	else{
		out.print("Invalid username or password. Please try again.");
		out.print("<br><form action=\"login.jsp\"><input type=\"submit\" value=\"Back to login\"></form></br>");
		return;
	}
}

query = "SELECT username, password, isAdmin FROM employees WHERE username = "+ "\"" + username + "\"";
System.out.println(query);
rs = statement.executeQuery(query);
if(rs.isBeforeFirst()){ //login is for rep or admin
	rs.next();
	if(rs.getString(2).equals(password)){
		session.setAttribute("userID", username);
		session.setAttribute("userType", rs.getBoolean(3) == true ? "admin" : "representative");
		out.print("<meta http-equiv=\"Refresh\" content=\"0; url='adminHome.jsp'\" />");
		return;
	}
	else{
		out.print("Invalid username or password. Please try again.");
		out.print("<br><form action=\"login.jsp\"><input type=\"submit\" value=\"Back to login\"></form></br>");
		return;
	}
}
else{
	out.print("Invalid username or password. Please try again.");
	out.print("<br><form action=\"login.jsp\"><input type=\"submit\" value=\"Back to login\"></form></br>");
}
connection.close();
%>