<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String date = request.getParameter("date");
	String transitLine = request.getParameter("transitLine");
	ArrayList<String> users = new ArrayList<String>();
	Boolean isDuplicate = false;
	Boolean notEmptySet = false;
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Transit Line Reservations</title>
		<style>
			table, th, td {
	  			border: 1px solid black;
	  			padding: 2px;
	  			width: 180px;
	  			border-collapse: collapse;
			}
			tr:nth-child(even) {
			  background-color: #f2f2f2;
			}
		</style>
	</head>
	<table>
	<tr>
	<td>
		Passenger List
	</td>
	</tr>
	
	<%
	try{
		ApplicationDB db = new ApplicationDB();	
		Connection connection = db.getConnection();
		Statement statement = connection.createStatement();
		String query = "SELECT username, departureDate FROM books WHERE lineName LIKE \"" + transitLine + "\"";
		System.out.println(query);
		ResultSet rs = statement.executeQuery(query);
		while(rs.next()){
			if(rs.getString(2).contains(date)){ //Current tuple contains a departureDate equivalent with the one specified by user.
				notEmptySet = true;
				for(int i = 0; i < users.size(); i++){
					if(users.get(i).equals(rs.getString(1))){
						isDuplicate = true;
						break;
						
					}
				}
				if(!isDuplicate){
					users.add(rs.getString(1));
					out.print("<tr><td>");
					out.print(rs.getString(1));
					out.print("</td></tr>");
				}
				isDuplicate = false;
			}
		}
		if(!notEmptySet){
			out.print("<tr><td>Empty.</td></tr>");
		}
		
		connection.close();
	}catch(Exception ex){
		
	}
	%>
	<body>
		<jsp:include page="navBarRepresentative.jsp"/>
		<hr>
		<h1> List of Passengers </h1>
		Based on Criteria: Date = <%out.print(date);%> , Transit Line = <%out.print(transitLine);%>

		<br>
		<br>
	</body>
</html>