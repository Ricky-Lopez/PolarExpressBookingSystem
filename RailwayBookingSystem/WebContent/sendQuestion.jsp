<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
String question = request.getParameter("questionText");
String username = session.getAttribute("userID").toString();  //username of logged-in user

try{
	ApplicationDB db = new ApplicationDB();	
	Connection connection = db.getConnection();
	
	Statement statement = connection.createStatement();
	String insert = "INSERT INTO questions(questions, username) VALUES (?, ?)";
	PreparedStatement pStatement = connection.prepareStatement(insert);
	pStatement.setString(1, question);
	pStatement.setString(2, username);
	
	pStatement.executeUpdate();
	
	connection.close();
	out.print("Question was sent to our customer representatives.");
	out.print("<br><form action=\"success.jsp\"><input type=\"submit\" value=\"Back to home\"></form></br>");
	
} catch(Exception ex){
	out.print("Question text: " + question);
	out.print("\n");
	out.print("username: " + username);
	out.print("\n");
	out.print("why does this give an error when its a copy of registerUser");
}

/*
CREATE TABLE questions (
    questions varchar(100),
    username varchar(40),
    PRIMARY KEY (questions),
    FOREIGN KEY (username) REFERENCES passengers (username)
)
*/
%>