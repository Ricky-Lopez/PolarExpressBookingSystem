<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<style>
			table, th, td {
	  			border: 1px solid black;
	  			padding: 2px;
	  			border-collapse: collapse;
			}
			tr:nth-child(even) {
			  background-color: #f2f2f2;
			}
		</style>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Customer Questions</title>
	</head>
	<body>
		<h1>Your response has been recorded.</h1>
		<%
		String responseText = request.getParameter("responseText");
		String question = request.getParameter("questionText");
		try{
			ApplicationDB db = new ApplicationDB();	
			Connection connection = db.getConnection();
			Statement statement = connection.createStatement();
			String query = "UPDATE questions SET answer = \"" + responseText + "\" WHERE question = \"" + question + "\"";
			statement.executeUpdate(query);
			System.out.println(query);
			
			connection.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		
		
		%>
		
	<jsp:include page="navBarRepresentative.jsp"/>	
	</body>
</html>