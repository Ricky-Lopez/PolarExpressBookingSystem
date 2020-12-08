<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Show Transit Lines</title>
	</head>
	<body>
<%
try{
	ApplicationDB db = new ApplicationDB();	
	Connection connection = db.getConnection();
	Statement statement = connection.createStatement();
	
	String query = "SELECT LineName, t.trainID, x.origin_station, x.origin_state, y.destination_station, y.destination_state, z.dept_date_and_time, "
			+ "w.arrival_date_and_time, totalTravelTime, totalFare FROM transitLine "
			+ "join (SELECT * FROM services) t using (lineName) "
			+ "join (SELECT L.lineName, S.name AS origin_station, S.state AS origin_state FROM transitLine L, trainStation S WHERE L.originStation = S.stationID)x using (lineName)"
			+ "join (SELECT L.lineName, S.name AS destination_station, S.state AS destination_state FROM transitLine L, trainStation S WHERE L.destinationStation = S.stationID)y using (lineName)"
			+ "join (SELECT L.lineName, S.departureTime AS dept_date_and_time FROM transitLine L, stopsAt S WHERE L.originStation = S.stationID AND S.lineName = L.lineName)z using (lineName)"
			+ "join (SELECT L.lineName, S.ArrivalTime AS arrival_date_and_time FROM transitLine L, stopsAt S WHERE L.destinationStation = S.stationID AND S.lineName = L.lineName)w using (lineName);";
	
	System.out.println(query);
	ResultSet rs = statement.executeQuery(query); 
	%>
	<table> 
	<tr>
		<td> Line Name </td>
		<td> Train Number </td>
		<td> Origin Station </td>
		<td> Origin Station State </td>
		<td> Destination Station </td>
		<td> Destination Station State </td>
		<td> Departure Date and Time </td>
		<td> Arrival Date and Time </td>
		<td> Total Travel Time </td>
		<td> Total Fare </td>
	</tr>
	<%  
		while(rs.next()){ 
			System.out.println("in while loop");%>
			<tr>
				<td> <%= rs.getString(1) %> </td> 
				<td> <%= rs.getInt(2) %> </td>
				<td> <%= rs.getString(3) %> </td>
				<td> <%= rs.getString(4) %> </td>
				<td> <%= rs.getString(5) %> </td>
				<td> <%= rs.getString(6) %> </td>
				<td> <%= rs.getString(7) %> </td>
				<td> <%= rs.getString(8) %> </td>
				<td> <%= rs.getInt(9) %> </td>
				<td> <%= rs.getInt(10) %> </td>
			</tr>
	<%} %>
	</table>
	</body>

<%
}catch(Exception e){
	System.out.println(e.toString());
}
%>
