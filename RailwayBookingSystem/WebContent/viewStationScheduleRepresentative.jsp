<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String trainStation = request.getParameter("station");
	String originStationID;
	String destinationStationID;
	String query2;
	String query3;

%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Station Schedule</title>
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
		<jsp:include page="navBarRepresentative.jsp"/>	
		<h1> Train Schedule List for <%out.print(trainStation);%></h1>
		<table>
			<tr>
			<td>Line Name</td>
			<td> Arrival Time </td>
			<td> Departure Time </td>
			<td> Train ID </td>
			<td> Origin Station </td>
			<td> Destination Station </td>
			<td> Total Travel Time </td>
			<td> Total Fare </td>
			
			</tr>
			<%
			try{
				ApplicationDB db = new ApplicationDB();	
				Connection connection = db.getConnection();
				Statement statement = connection.createStatement();
				Statement statement1 = connection.createStatement();
				String query = "SELECT stationID FROM trainStation WHERE name LIKE \"" + trainStation + "\"";
				System.out.println(query);
				ResultSet rs = statement.executeQuery(query);
				rs.next();
				String stationID = rs.getString(1);
				
				String query1 = "SELECT stopsAt.lineName, arrivalTime, departureTime, trainID, originStation.originStation, destinationStation.destinationStation, totalTravelTime, totalFare "
						+ "FROM stopsAt INNER JOIN services ON stopsAt.lineName = services.lineName "
						+ "INNER JOIN transitLine ON stopsAt.lineName = transitLine.lineName "
					    + "INNER JOIN (SELECT stationID, name originStation FROM trainStation) as originStation ON "
						+ "originStation.stationID = transitLine.originStation "
						+ "INNER JOIN (SELECT stationID, name destinationStation FROM trainStation) as destinationStation ON "
						+ "destinationStation.stationID = transitLine.destinationStation "
						+ "WHERE stopsAt.stationID = "+ stationID;
				System.out.println(query1);
				ResultSet rs1 = statement1.executeQuery(query1);
				
				while(rs1.next()){ //produces dataset for a "train schedule".
					out.print("<tr><td>");
					out.print(rs1.getString(1));
					out.print("</td><td>");
					out.print(rs1.getString(2));
					out.print("</td><td>");
					out.print(rs1.getString(3));
					out.print("</td><td>");
					out.print(rs1.getString(4));
					out.print("</td><td>");
					out.print(rs1.getString(5));
					out.print("</td><td>");
					out.print(rs1.getString(6));
					out.print("</td><td>");
					out.print(rs1.getString(7)+" minutes");
					out.print("</td><td>");
					out.print("$"+rs1.getString(8));
					out.print("</td></tr>");
					
				}
			
				connection.close();
			}catch(Exception ex){
				ex.printStackTrace();
			}
			%>
		</table>
	</body>
</html>