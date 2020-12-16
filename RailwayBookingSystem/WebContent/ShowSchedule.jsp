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
	</head>
	<body>
<%
try{
	ApplicationDB db = new ApplicationDB();	
	Connection connection = db.getConnection();
	Statement statement = connection.createStatement();
	Statement statement2 = connection.createStatement();
	
	String query = "SELECT LineName, t.trainID, x.origin_station, x.origin_state, y.destination_station, y.destination_state, z.dept_date_and_time, "
			+ "w.arrival_date_and_time, totalTravelTime, totalFare FROM transitLine "
			+ "join (SELECT * FROM services) t using (lineName) "
			+ "join (SELECT L.lineName, S.name AS origin_station, S.state AS origin_state FROM transitLine L, trainStation S WHERE L.originStation = S.stationID)x using (lineName)"
			+ "join (SELECT L.lineName, S.name AS destination_station, S.state AS destination_state FROM transitLine L, trainStation S WHERE L.destinationStation = S.stationID)y using (lineName)"
			+ "join (SELECT L.lineName, S.departureTime AS dept_date_and_time FROM transitLine L, stopsAt S WHERE L.originStation = S.stationID AND S.lineName = L.lineName)z using (lineName)"
			+ "join (SELECT L.lineName, S.ArrivalTime AS arrival_date_and_time FROM transitLine L, stopsAt S WHERE L.destinationStation = S.stationID AND S.lineName = L.lineName)w using (lineName);";
	
	ResultSet rs = statement.executeQuery(query); 
	
	%>
	<%  
		while(rs.next()){ %>
			<h4> <%= rs.getString(1) + " " + rs.getString(7) %> </h4>
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
				<td> Fare </td>
				<td> Round-Trip Fare </td>
			</tr>
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
				<td> <%= rs.getInt(10)*2 %> </td>
				
			</tr>
			</table>
				<% 
				String transitLine = rs.getString(1);
				query = "SELECT L.lineName, T.name, T.state, stops.arrivalTime, stops.departureTime FROM transitLine L, stopsAt stops, trainStation T WHERE stops.lineName = L.lineName AND stops.stationID = T.stationID AND L.lineName = " + "\"" + transitLine + "\"";
				ResultSet rs2 = statement2.executeQuery(query);
				if (rs2.isBeforeFirst()) { %>
				<h4> Stops </h4>
				<table>
					<tr>
						<td> Line Name </td>
						<td> Station Name </td>
						<td> State </td>
						<td> Arrival Date and Time </td>
						<td> Departure Date and Time </td>
					</tr>
					<% while (rs2.next()){ %>
					<tr>
						<td> <%= rs2.getString(1) %> </td>
						<td> <%= rs2.getString(2) %> </td>
						<td> <%= rs2.getString(3) %> </td>
						<td> <%= rs2.getString(4) %> </td>
						<td> <%= rs2.getString(5) %> </td>
					</tr>
					<%}%>
					</table>
				<%}%> 

	<%} connection.close(); %>
	</body>

<%
}catch(Exception e){
	System.out.println(e.toString());
}
%>
