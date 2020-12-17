<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.time.LocalTime"%>
<%@ page import="java.text.DecimalFormat"%>
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
	<jsp:include page="navBarAdmin.jsp"/>	

<%!
	public float getFare(String transitLine, String origin, String oState, String destination, String dState, ApplicationDB db){
		try{
			Connection connection = db.getConnection();
			String query = "SELECT L.lineName, T.name, T.state, stops.arrivalTime, stops.departureTime FROM transitLine L, stopsAt stops, trainStation T WHERE stops.lineName = L.lineName AND stops.stationID = T.stationID AND L.lineName = ? ORDER BY stops.arrivalTime";
			PreparedStatement statement = connection.prepareStatement(query);
			statement.setString(1, transitLine);
			ResultSet rs = statement.executeQuery();
			int numStopsTraveled = 1;
			int totalStops = 0;
			float totalFare = 0f;
			boolean originFound = false;
			while(rs.next()){
				if(originFound == true){
					numStopsTraveled++;
				}
				if(rs.getString(2).equals(origin) && rs.getString(3).equals(oState)){
					originFound = true;
				}
				if(rs.getString(2).equals(destination) && rs.getString(3).equals(dState) && originFound == true){
					break;
				}
			}
			
			query = "SELECT count(*), totalFare FROM stopsAt S, transitLine L WHERE S.lineName = ? AND L.lineName = ?;";
			statement = connection.prepareStatement(query);
			statement.setString(1, transitLine);
			statement.setString(2, transitLine);
			rs = statement.executeQuery(query);
			if(rs.next()){
				totalStops = rs.getInt(1);
				totalFare = rs.getFloat(2);
			}
			return (totalFare/totalStops)*numStopsTraveled;
		}catch(Exception ex){
			return 0f;
		}
	}

%>

<% 
ArrayList<String> transitLines = new ArrayList<String>();
HashMap <String, LocalTime> validLines = new HashMap<String, LocalTime>();
HashMap <String, Float> validLinesFare = new HashMap<String, Float>();
ArrayList<String> transitLineResults = new ArrayList<String>();

String originSelection = request.getParameter("originStation");
String originStationName = originSelection.substring(0, originSelection.indexOf("(")).trim();
String originState = originSelection.substring(originSelection.indexOf("(")+1, originSelection.indexOf(")"));

String destSelection = request.getParameter("destStation");
String destStationName = destSelection.substring(0, destSelection.indexOf("(")).trim();
String destState = destSelection.substring(destSelection.indexOf("(")+1, destSelection.indexOf(")"));
String travelDate = request.getParameter("date");
String resId = request.getParameter("resId");
String[] results;
String departure;

try{
	ApplicationDB db = new ApplicationDB();	
	Connection connection = db.getConnection();
	String query = "SELECT lineName FROM transitLine";
	PreparedStatement statement = connection.prepareStatement(query);
	ResultSet rs = statement.executeQuery();
	
	while(rs.next()){
		transitLines.add(rs.getString(1));
	}
	
	System.out.println("origin station: " + originStationName);
	System.out.println("dest station: " + destStationName);
	
	for(int i = 0; i < transitLines.size(); i++){ //for each transit line
		boolean originFound = false;
		boolean destFound = false;
		String transitLine = transitLines.get(i);
		query = "SELECT L.lineName, T.name, T.state, stops.arrivalTime, stops.departureTime FROM transitLine L, stopsAt stops, trainStation T WHERE stops.lineName = L.lineName AND stops.stationID = T.stationID AND L.lineName = ? ORDER BY stops.arrivalTime";
		statement = connection.prepareStatement(query);
		statement.setString(1, transitLine);
		rs = statement.executeQuery();
		int numStopsTraveled = 0;
		
		//get the stops for that transit line. Determine if there is a route on this transit line between origin and dest station.
		while(rs.next()){
			System.out.println(rs.getString(1) + rs.getString(2) + rs.getString(3));
			System.out.println("originFound:" + originFound);
			System.out.println(rs.getString(2).equals(originStationName));
			if(originFound == true){
				numStopsTraveled++;
			}
			if(rs.getString(2).equals(originStationName) && rs.getString(3).equals(originState)){
				System.out.println("IN ORIGIN FOUND IF STATEMENT FOR TRANSIT LINE " + transitLine);
				originFound = true;	
			}
			if(rs.getString(2).equals(destStationName) && rs.getString(3).equals(destState) && originFound == true){
				System.out.println("IN DEST FOUND IF STATEMENT FOR TRANSIT LINE " + transitLine);
				//depending on chosen sorting option, add lineName and value of sorting metric to appropriate hashmap
				if(request.getParameter("sort").equals("Arrival")){
					System.out.println("Sorting by arrival");
					String arrivalDateTime = rs.getString(4);
					String arrivalTime = arrivalDateTime.substring(arrivalDateTime.indexOf(" ")+1);
					String[] timeSplit = arrivalTime.split(":");
					validLines.put(rs.getString(1), LocalTime.of(Integer.parseInt(timeSplit[0]), Integer.parseInt(timeSplit[1]), Integer.parseInt(timeSplit[2])));
					transitLineResults.add(rs.getString(1));
				}
				else if(request.getParameter("sort").equals("Departure")){
					String departureDateTime = rs.getString(5);
					String departureTime = departureDateTime.substring(departureDateTime.indexOf(" ")+1);
					String[] timeSplit = departureTime.split(":");
					validLines.put(rs.getString(1), LocalTime.of(Integer.parseInt(timeSplit[0]), Integer.parseInt(timeSplit[1]), Integer.parseInt(timeSplit[2])));
					transitLineResults.add(rs.getString(1));
				}
				else{
					String nameAndTotalFareQuery = "SELECT count(*), totalFare FROM stopsAt S, transitLine L WHERE S.lineName = ? AND L.lineName = ?;";
					PreparedStatement statement2 = connection.prepareStatement(nameAndTotalFareQuery);
					statement2.setString(1, transitLine);
					statement2.setString(2, transitLine);
					System.out.println(nameAndTotalFareQuery);
					ResultSet rsNameAndTotalFare = statement2.executeQuery();
					rsNameAndTotalFare.next();
					int numStops = rsNameAndTotalFare.getInt(1);
					Float totalFare = rsNameAndTotalFare.getFloat(2);

					Float calculatedFare = (totalFare/numStops)*numStopsTraveled;
					System.out.println("CALCULATED FARE: " + calculatedFare);
					validLinesFare.put(rs.getString(1), calculatedFare);
					transitLineResults.add(rs.getString(1));
				}
			}
		}
	} //end for loop
		if(request.getParameter("sort").equals("Fare")){
			results = new String[transitLineResults.size()];
			results = transitLineResults.toArray(results);
			//Sort transit line names by chosen sorting metric -- an absolutely awful take on selection sort
			for (int k = 0; k < results.length-1; k++) 
	        { 
	            // Find the minimum element in unsorted array 
	            int minIndex = k; 
	            for (int j =k+1; j < results.length; j++) {
	                if (validLinesFare.get(results[j]).compareTo(validLinesFare.get(results[minIndex])) < 0) 
	                    minIndex = j; 
	            }
	            // Swap the found minimum element with the first 
	            // element 
	            String temp = results[minIndex]; 
	            results[minIndex] = results[k]; 
	            results[k] = temp; 
	        } 
			
		}
		else {
			System.out.println("IN ELSE FOR AWFUL SELECTION SORT");
			results = new String[transitLineResults.size()];
			results = transitLineResults.toArray(results);
			//Sort transit line names by chosen sorting metric -- an absolutely awful take on selection sort
			for (int k = 0; k < results.length-1; k++) 
	        { 
	            // Find the minimum element in unsorted array 
	            int minIndex = k; 
	            for (int j =k+1; j < results.length; j++) {
	                if (validLines.get(results[j]).compareTo(validLines.get(results[minIndex])) < 0) 
	                    minIndex = j; 
	            }
	            // Swap the found minimum element with the first 
	            // element 
	            String temp = results[minIndex]; 
	            results[minIndex] = results[k]; 
	            results[k] = temp; 
	        } 
		}
	
	System.out.println("IS SORTING WORKING? " + results.length);
	if(results.length == 0){ %>
	<h4> No results found for given information </h4>	
	<%}
	else{
		System.out.println("in else");
		for(int i = 0; i < results.length; i++){
			String lineName = results[i];
			System.out.println("Gathering info for: " + lineName);
			query = "SELECT LineName, t.trainID, x.origin_station, x.origin_state, y.destination_station, y.destination_state, z.dept_date_and_time, "
					+ "w.arrival_date_and_time, totalTravelTime, totalFare FROM transitLine "
					+ "join (SELECT * FROM services) t using (lineName) "
					+ "join (SELECT L.lineName, S.name AS origin_station, S.state AS origin_state FROM transitLine L, trainStation S WHERE L.originStation = S.stationID)x using (lineName) "
					+ "join (SELECT L.lineName, S.name AS destination_station, S.state AS destination_state FROM transitLine L, trainStation S WHERE L.destinationStation = S.stationID)y using (lineName) "
					+ "join (SELECT L.lineName, S.departureTime AS dept_date_and_time FROM transitLine L, stopsAt S WHERE L.originStation = S.stationID AND S.lineName = L.lineName)z using (lineName) "
					+ "join (SELECT L.lineName, S.ArrivalTime AS arrival_date_and_time FROM transitLine L, stopsAt S WHERE L.destinationStation = S.stationID AND S.lineName = L.lineName)w using (lineName) "
					+ "WHERE LineName = ?";
			PreparedStatement pstatement = connection.prepareStatement(query);
			pstatement.setString(1, lineName);
			rs = pstatement.executeQuery(); 
			rs.next();%>
			
			<h2> <%= rs.getString(1) + " " + travelDate %> </h2>
			<table> 
			<tr>
				<td> Line Name </td>
				<td> Train Number </td>
				<td> Origin Station </td>
				<td> Origin Station State </td>
				<td> Destination Station </td>
				<td> Destination Station State </td>
				<td> Departure Time </td>
				<td> Arrival Time </td>
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
				<td> <%= rs.getString(7).substring(rs.getString(7).indexOf(" ")+1) %> </td>
				<td> <%= rs.getString(8).substring(rs.getString(8).indexOf(" ")+1) %> </td>
				<td> <%= rs.getInt(9) + " minutes" %> </td>
				<% if (request.getParameter("returnTrip") == null) { //don't display fares if is return trip since price is original fare * 2 instead%> 
				<td> <%= "$" + rs.getInt(10) %> </td>
				<td> <%= "$" + rs.getInt(10)*2 %> </td>
				<%} %>
			</tr>
			</table>
			<%  query = "SELECT L.lineName, T.name, T.state, stops.arrivalTime, stops.departureTime FROM transitLine L, stopsAt stops, trainStation T WHERE stops.lineName = L.lineName AND stops.stationID = T.stationID AND L.lineName = ? ORDER BY stops.arrivalTime";
				statement = connection.prepareStatement(query);
				statement.setString(1, lineName);
				rs = statement.executeQuery();
				if (rs.isBeforeFirst()) { %>
				<h4> Stops </h4>
				<table>
					<tr>
						<td> Line Name </td>
						<td> Station Name </td>
						<td> State </td>
						<td> Arrival Time </td>
						<td> Departure Time </td>
					</tr>
					<% while (rs.next()){ %>
					<tr>
						<td> <%= rs.getString(1) %> </td>
						<td> <%= rs.getString(2) %> </td>
						<td> <%= rs.getString(3) %> </td>
						<td> <%= rs.getString(4).substring(rs.getString(4).indexOf(" ")+1) %> </td>
						<td> <%= rs.getString(5).substring(rs.getString(4).indexOf(" ")+1) %> </td>
					</tr>
					
					<%}
					
					//put new stuff here	
				
				}%>
				</table>
				<h3>Trip Details:</h3>
				<%
					String arrival= "";
					String depart = "";
					query = "SELECT stops.departureTime FROM transitLine L, stopsAt stops, trainStation T WHERE stops.lineName = L.lineName "
							+ "AND stops.stationID = T.stationID AND L.lineName = ? AND T.name = ? AND T.state = ?;";
					statement = connection.prepareStatement(query);
					statement.setString(1, lineName);
					statement.setString(2, originStationName);
					statement.setString(3, originState);
					rs = statement.executeQuery();
					if(rs.next()){
						depart = rs.getString(1);
					}
					
					query = "SELECT stops.arrivalTime FROM transitLine L, stopsAt stops, trainStation T WHERE stops.lineName = L.lineName "
							+ "AND stops.stationID = T.stationID AND L.lineName = ? AND T.name = ? AND T.state = ?;";
					statement = connection.prepareStatement(query);
					statement.setString(1, lineName);
					statement.setString(2, destStationName);
					statement.setString(3, destState);		
					rs = statement.executeQuery();
					if(rs.next()){
						arrival = rs.getString(1);
					}
					
					DecimalFormat df = new DecimalFormat();
					df.setMaximumFractionDigits(2);
							
				%>
				<table>
					<tr>
						<td> Date of Travel </td>
						<td> Origin Station </td>
						<td> Destination Station </td>
						<td> Departure Time </td>
						<td> Arrival Time </td>
						<td> Fare </td>
						<td rowspan="2">
					</tr>
					<tr>
						<td><%= travelDate %></td>
						<td><%= request.getParameter("originStation") %></td>
						<td><%= request.getParameter("destStation") %></td>
						<td><%= depart.substring(depart.indexOf(" ")+1) %></td>
						<td><%= arrival.substring(arrival.indexOf(" ")+1) %></td>
						<td><%= "$" + df.format(getFare(lineName, originStationName, originState, destStationName, destState, db)) %></td>
					</tr>
					<tr>
						<td colspan = 7> **Applicable Discounts Applied Upon Reservation** </td>
					</tr>
				</table>
				
				
					
			
			
<%
		}
	}
	
		
	
	
connection.close();
}catch (Exception ex){
	
}
%>
</body>
</html>