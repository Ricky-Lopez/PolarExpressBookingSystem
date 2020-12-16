<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String currTransitLine = request.getParameter("currTransitLine");
	String newTransitLine = request.getParameter("newTransitLine");
	try{
		ApplicationDB db = new ApplicationDB();	
		Connection connection = db.getConnection();
		Statement statement = connection.createStatement();
		String query = "UPDATE transitLine SET lineName = \"" + newTransitLine + "\" WHERE lineName = \"" + currTransitLine + "\"";
		System.out.println(query);
		int done = statement.executeUpdate(query);
		out.print("<meta http-equiv=\"Refresh\" content=\"0; url='editAndDeleteTrainSchedules.jsp'\" />");

	}catch(Exception e){
		e.printStackTrace();
	}
%>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

</body>
</html>