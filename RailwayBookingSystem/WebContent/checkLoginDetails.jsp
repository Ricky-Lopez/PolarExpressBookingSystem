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

//if (isPassenger == true){
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
//}

/*
else if (isRepresentative == true){
	String stmt = "SELECT username, password FROM employees " +
		"WHERE username LIKE '" + username + "' AND password LIKE '" + password + "'";
	
	ResultSet rs = statement.executeQuery(stmt);
	System.out.println(rs.getMetaData().getColumnCount());
	if(rs.next()){
		session.setAttribute("userID", username);
		out.print("<meta http-equiv=\"Refresh\" content=\"0; url='representativeHome.jsp'\" />");
	}else{
		out.print("Invalid username or password. Please try again.");
		out.print("<br><form action=\"login.jsp\"><input type=\"submit\" value=\"Back to login\"></form></br>");
	}
}

else if (isAdmin == true){
	String stmt = "SELECT username, password FROM employees " +
		"WHERE username LIKE '" + username + "' AND password LIKE '" + password + "'";

	ResultSet rs = statement.executeQuery(stmt);
	System.out.println(rs.getMetaData().getColumnCount());
	if(rs.next()){
		session.setAttribute("userID", username);
		out.print("<meta http-equiv=\"Refresh\" content=\"0; url='adminHome.jsp'\" />");
	}else{
		out.print("Invalid username or password. Please try again.");
		out.print("<br><form action=\"login.jsp\"><input type=\"submit\" value=\"Back to login\"></form></br>");
	}
}

else {
	out.print("Something went very wrong");
	out.print("<br><form action=\"login.jsp\"><input type=\"submit\" value=\"Back to login\"></form></br>");
}
*/

connection.close();
%>