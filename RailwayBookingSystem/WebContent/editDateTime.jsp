<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	System.out.println("HELLO");
	final String defaultDate = "2020-12-26";
	String trainSchedule = request.getParameter("currTransitLine");
	String[] schedulePieces = trainSchedule.split(",");
	System.out.println(trainSchedule);
	String currTransitLine = schedulePieces[0];
	String stationIDString = schedulePieces[1];
	int stationID = Integer.parseInt(stationIDString.substring(stationIDString.indexOf(" ")+11));
	String newArrival = defaultDate + " " + request.getParameter("arrivalDate") + ":00";
	String newDepart = defaultDate + " " + request.getParameter("departureDate") + ":00";
	String query;
	try{
		System.out.println("arr date: " + newArrival);
		ApplicationDB db = new ApplicationDB();	
		Connection connection = db.getConnection();
		query = "UPDATE stopsAt SET departureTime = ?, arrivalTime = ? WHERE lineName = ? AND stationID = ?";
		PreparedStatement statement = connection.prepareStatement(query);
		statement.setString(1, newDepart);
		statement.setString(2, newArrival);
		statement.setString(3, currTransitLine);
		statement.setInt(4, stationID);
		int done = statement.executeUpdate();
		
		//Update any reservations that use this stop as origin to use new time
		query = "UPDATE books SET departureDate = ? WHERE lineName = ? AND origin = ?";
		statement = connection.prepareStatement(query);
		statement.setString(1, newDepart);
		statement.setString(2, currTransitLine);
		statement.setInt(3, stationID);
		statement.executeUpdate();
		
		//Update any reservations that use this stop as destination to use new time
		query = "UPDATE books SET arrivalDate = ? WHERE lineName = ? AND destination = ?";
		statement = connection.prepareStatement(query);
		statement.setString(1, newArrival);
		statement.setString(2, currTransitLine);
		statement.setInt(3, stationID);
		statement.executeUpdate();		
		
		connection.close();
		
		out.print("<meta http-equiv=\"Refresh\" content=\"0; url='editAndDeleteTrainSchedules.jsp'\" />");
		

	}catch(Exception e){
		e.printStackTrace();
	}
%>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Schedule Modification</title>
</head>
<body>
<jsp:include page="navBarRepresentative.jsp"/>	
	<h1> Schedule Edited!</h1>
</body>
</html>