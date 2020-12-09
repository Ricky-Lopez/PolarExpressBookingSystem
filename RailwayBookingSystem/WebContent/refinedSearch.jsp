<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Search Results</title>
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
ArrayList<String> transitLines = new ArrayList<String>();
ArrayList<String> transitLineResults = new ArrayList<String>();

String originSelection = request.getParameter("originStation");
String originStationName = originSelection.substring(0, originSelection.indexOf("(")).trim();
String originState = originSelection.substring(originSelection.indexOf("(")+1, originSelection.indexOf(")"));

String destSelection = request.getParameter("destStation");
String destStationName = destSelection.substring(0, destSelection.indexOf("(")).trim();
String destState = destSelection.substring(destSelection.indexOf("(")+1, destSelection.indexOf(")"));
String travelDate = request.getParameter("date");

String fareSort = "SELECT lineName FROM transitLine ORDER BY totalFare ASC;";
String arrivalSort = "SELECT LineName FROM transitLine join (SELECT L.lineName, S.departureTime AS dept_date_and_time FROM transitLine L, stopsAt S "
		+ "WHERE L.originStation = S.stationID AND S.lineName = L.lineName)z using (lineName) join (SELECT L.lineName, S.ArrivalTime AS "
		+ "arrival_date_and_time FROM transitLine L, stopsAt S WHERE L.destinationStation = S.stationID AND S.lineName = L.lineName)w using (lineName) ORDER BY w.arrival_date_and_time ASC;";

String departureSort = "SELECT LineName, z.dept_date_and_time, w.arrival_date_and_time FROM transitLine join "
	+ "(SELECT L.lineName, S.departureTime AS dept_date_and_time FROM transitLine L, stopsAt S WHERE L.originStation = S.stationID AND S.lineName = L.lineName)z using (lineName) "
	+ "join (SELECT L.lineName, S.ArrivalTime AS arrival_date_and_time FROM transitLine L, stopsAt S WHERE L.destinationStation = S.stationID AND S.lineName = L.lineName)w using (lineName) ORDER BY z.dept_date_and_time ASC;";




try{
	ApplicationDB db = new ApplicationDB();	
	Connection connection = db.getConnection();
	Statement statement = connection.createStatement();
	String query;
	if(request.getParameter("sort").equals("Arrival")){
		query = arrivalSort;
	}
	else if(request.getParameter("sort").equals("Departure")){
		query = departureSort;
	}
	else{
		query = fareSort;
	}
	ResultSet rs = statement.executeQuery(query);
	
	while(rs.next()){
		transitLines.add(rs.getString(1));
	}
	
	for(int i = 0; i < transitLines.size(); i++){
		boolean originFound = false;
		boolean destFound = false;
		String transitLine = transitLines.get(i);
		query = "SELECT L.lineName, T.name, T.state, stops.arrivalTime, stops.departureTime FROM transitLine L, stopsAt stops, trainStation T WHERE stops.lineName = L.lineName AND stops.stationID = T.stationID AND L.lineName = " + "\"" + transitLine + "\"";
		rs = statement.executeQuery(query);
		while(rs.next()){
			if(rs.getString(2).equals(originStationName) && rs.getString(3).equals(originState) && rs.getString(4).contains(travelDate)){
				originFound = true;
			}
			if(rs.getString(2).equals(destStationName) && rs.getString(3).equals(destState) && rs.getString(4).contains(travelDate) && originFound == true){
				transitLineResults.add(rs.getString(1));
			}
		}
	}
	if(transitLineResults.size() == 0){ %>
	<h4> No results found for given information </h4>	
	<%}
	else{
		System.out.println("in else");
		for(int i = 0; i < transitLineResults.size(); i++){
			String lineName = transitLineResults.get(i);
			System.out.println("Gathering info for: " + lineName);
			query = "SELECT LineName, t.trainID, x.origin_station, x.origin_state, y.destination_station, y.destination_state, z.dept_date_and_time, "
					+ "w.arrival_date_and_time, totalTravelTime, totalFare FROM transitLine "
					+ "join (SELECT * FROM services) t using (lineName) "
					+ "join (SELECT L.lineName, S.name AS origin_station, S.state AS origin_state FROM transitLine L, trainStation S WHERE L.originStation = S.stationID)x using (lineName) "
					+ "join (SELECT L.lineName, S.name AS destination_station, S.state AS destination_state FROM transitLine L, trainStation S WHERE L.destinationStation = S.stationID)y using (lineName) "
					+ "join (SELECT L.lineName, S.departureTime AS dept_date_and_time FROM transitLine L, stopsAt S WHERE L.originStation = S.stationID AND S.lineName = L.lineName)z using (lineName) "
					+ "join (SELECT L.lineName, S.ArrivalTime AS arrival_date_and_time FROM transitLine L, stopsAt S WHERE L.destinationStation = S.stationID AND S.lineName = L.lineName)w using (lineName) "
					+ "WHERE LineName = \"" + lineName + "\"";
			System.out.println(query);
			rs = statement.executeQuery(query); 
			rs.next();%>
			
			<h2> <%= rs.getString(1) + " " + rs.getString(7) %> </h2>
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
				<td> <%= rs.getInt(9) + " minutes" %> </td>
				<td> <%= "$" + rs.getInt(10) %> </td>
				<td> <%= "$" + rs.getInt(10)*2 %> </td>
			</tr>
			</table>
			<%  query = "SELECT L.lineName, T.name, T.state, stops.arrivalTime, stops.departureTime FROM transitLine L, stopsAt stops, trainStation T WHERE stops.lineName = L.lineName AND stops.stationID = T.stationID AND L.lineName = " + "\"" + lineName + "\"";
				System.out.println("down below");
				rs = statement.executeQuery(query);
				if (rs.isBeforeFirst()) { %>
				<h4> Stops </h4>
				<table>
					<tr>
						<td> Line Name </td>
						<td> Station Name </td>
						<td> State </td>
						<td> Arrival Date and Time </td>
						<td> Departure Date and Time </td>
					</tr>
					<% while (rs.next()){ %>
					<tr>
						<td> <%= rs.getString(1) %> </td>
						<td> <%= rs.getString(2) %> </td>
						<td> <%= rs.getString(3) %> </td>
						<td> <%= rs.getString(4) %> </td>
						<td> <%= rs.getString(5) %> </td>
					</tr>
					<%}}%>
					</table>
			
			
<%
		}
	}
	
		
	
	
	
}catch (Exception ex){
	
}
%>
</body>
</html>