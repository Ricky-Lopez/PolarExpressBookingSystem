<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.time.LocalTime"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
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
		<style>
			input[type=submit] {
				  text-align: center;
				  font-size: 16px;
				  display: block;
   				  margin: 0 auto;
			}
		</style>
		<style>
			input[type=date] {
				  text-align: center;
				  font-size: 16px;
				  display: block;
   				  margin: 0 auto;
			}
		</style>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
			<title>Make Reservation</title>
	</head>
	<body>
	<jsp:include page="navBar.jsp"/>	
	
<%
	System.out.println("IN MAKE RESERVATION");
	String lineName = request.getParameter("lineName");
	String travelDate = request.getParameter("travelDate");
	String origin = request.getParameter("originStation");
	String originState = request.getParameter("originState");
	String dest = request.getParameter("destStation");
	String destState = request.getParameter("destState");
	String departure = request.getParameter("departureTime");
	String arrival = request.getParameter("arrivalTime");
	Float fare = Float.parseFloat(request.getParameter("fare"));
	String resIdString = request.getParameter("resId");
	int reservationId = -1;
	int originId = -1;
	int destId = -1;
	String origLineName = "";
	String origDeparture = "";
	String origOriginStation = "";
	String origDestStation = "";
	String origArrival = "";
	String origTravelDate = "";
	Float origFare = 0f;
	int origTrainNo = 0;
	
	
	//formatter to format date for DBMS
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String creationDate = formatter.format(new Date());
	
	session = request.getSession();
	String passenger = (String) session.getAttribute("userID");
	


	try{
		ApplicationDB db = new ApplicationDB();
		Connection connection = db.getConnection();
		String query = "SELECT age, isDisabled FROM passengers WHERE username = ?";
		PreparedStatement pStatement = connection.prepareStatement(query);
		pStatement.setString(1, passenger);
		System.out.println(query);
		ResultSet rs = pStatement.executeQuery();
		int age = 0;
		boolean isDisabled = false;
		if(rs.isBeforeFirst()) {
			rs.next();
			age = rs.getInt(1);
			if(rs.getInt(2) == 1){
				isDisabled = true;
			}
		}
		
		pStatement.close();
		
		//determine if any discounts apply
		if(isDisabled){
			fare -= (fare*0.5f);
		}
		else if(age < 12){ //child discount
			fare -= (fare*0.25f);
		}
		else if(age >= 65){ //senior discount
			fare -= (fare*0.35f);
		}
		
		System.out.println("Fare after discounts: " + fare);
		
		//Get Id's of origin & destination station
		query = "SELECT stationID FROM trainStation WHERE name = ? AND state = ?";
		pStatement = connection.prepareStatement(query);
		pStatement.setString(1, origin);
		pStatement.setString(2, originState);
		rs = pStatement.executeQuery();
		rs.next();
		originId = rs.getInt(1);
		pStatement.close();
		
		query = "SELECT stationID FROM trainStation WHERE name = ? AND state = ?";
		pStatement = connection.prepareStatement(query);
		pStatement.setString(1, dest);
		pStatement.setString(2, destState);
		rs = pStatement.executeQuery();
		rs.next();
		destId = rs.getInt(1);
		pStatement.close();
		
		//add reservation to DB
			//non-return trip insertion]
		if (resIdString == null){			
			query = "INSERT INTO books(username, lineName, creationDate, departureDate, arrivalDate, totalFare, destination, origin, travel_date) "
					+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
			pStatement = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
			pStatement.setString(1, passenger);
			pStatement.setString(2, lineName);
			pStatement.setString(3, creationDate);
			pStatement.setString(4, departure);
			pStatement.setString(5, arrival);
			pStatement.setFloat(6, fare);
			pStatement.setInt(7, destId);
			pStatement.setInt(8, originId);
			pStatement.setString(9, travelDate);
			
			pStatement.executeUpdate();
			
			ResultSet id = pStatement.getGeneratedKeys();
			id.next();
			reservationId = id.getInt(1);
			pStatement.close();
		}
		
		else{
			//get fare of original reservation since round-trip price should be fare * 2
			query = "SELECT totalFare FROM books WHERE reservationNo = ?";
			pStatement = connection.prepareStatement(query);
			pStatement.setInt(1, Integer.parseInt(resIdString));
			rs = pStatement.executeQuery();
			rs.next();
			fare = rs.getFloat(1);
			pStatement.close();
			
			query = "INSERT INTO books(username, lineName, creationDate, departureDate, arrivalDate, totalFare, destination, origin, travel_date, round_trip) "
					+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			pStatement = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
			pStatement.setString(1, passenger);
			pStatement.setString(2, lineName);
			pStatement.setString(3, creationDate);
			pStatement.setString(4, departure);
			pStatement.setString(5, arrival);
			pStatement.setFloat(6, fare);
			pStatement.setInt(7, destId);
			pStatement.setInt(8, originId);
			pStatement.setString(9, travelDate);
			pStatement.setInt(10, Integer.parseInt(resIdString));
			
			pStatement.executeUpdate();
			
			ResultSet id = pStatement.getGeneratedKeys();
			id.next();
			int returnResId = id.getInt(1);
			pStatement.close();
			 
			//Update first reservation with this reservation's ID, "linking" them so we know they are a part of a round-trip reservation
			query = "UPDATE books SET round_trip = ? WHERE reservationNo = ?";
			pStatement = connection.prepareStatement(query);
			pStatement.setInt(1, returnResId);
			pStatement.setInt(2, Integer.parseInt(resIdString));
			pStatement.executeUpdate();
			pStatement.close();
			
		}
		%>
		
		<h1> Your Reservation Has Been Confirmed! </h1>
		<h2> Reservation Details: </h2>
		<table>
			<tr>
				<td> Passenger Name </td>
				<td> Reservation Creation Date </td>
				<td> Travel Date </td>
				<td> Transit Line Name </td>
				<td> Train Number </td>
				<td> Origin Station </td>
				<td> Departure Time </td>
				<td> Destination Station </td>
				<td> Arrival Time </td>
				<td> Fare </td>	
			</tr>
			
			<%
				if(resIdString != null){ //if we just reserved a return trip, get corresponding reservation from database
					query = "SELECT lineName, departureDate, arrivalDate, totalFare, destination, origin, travel_date FROM books WHERE reservationNo = ?";
					pStatement = connection.prepareStatement(query);
					pStatement.setInt(1, Integer.parseInt(resIdString));
					rs = pStatement.executeQuery();
					rs.next();
					origLineName = rs.getString(1);
					origDeparture = rs.getString(2);
					origArrival = rs.getString(3);
					origFare = rs.getFloat(4);
					int origDestId = rs.getInt(5);
					int origOriginId = rs.getInt(6);
					origTravelDate = rs.getString(7);
					
					//get names, states of origin & destination stations
					query = "SELECT name, state FROM trainStation WHERE stationID = ?";
					pStatement = connection.prepareStatement(query);
					pStatement.setInt(1, origOriginId);
					rs = pStatement.executeQuery();
					rs.next();
					origOriginStation = rs.getString(1) + " (" + rs.getString(2) + ")";
					
					pStatement = connection.prepareStatement(query);
					pStatement.setInt(1, origDestId);
					rs = pStatement.executeQuery();
					rs.next();
					origDestStation = rs.getString(1) + " (" + rs.getString(2) + ")";
					
					//get train no of original line
					query = "SELECT trainID FROM services WHERE lineName = ?";
					pStatement = connection.prepareStatement(query);
					pStatement.setString(1, origLineName);
					rs = pStatement.executeQuery();
					rs.next();
					origTrainNo = rs.getInt(1);
					pStatement.close();
						
				}
			
				//get train number from DB for displaying reservation info back to user
				query = "SELECT trainID FROM services WHERE lineName = ?";
				pStatement = connection.prepareStatement(query);
				pStatement.setString(1, lineName);
				rs = pStatement.executeQuery();
				rs.next();
				int trainNo = rs.getInt(1);
				pStatement.close();
				
				//get passenger name from DB for displaying reservation info back to user
				query = "SELECT first_name, last_name FROM passengers WHERE username = ?";
				pStatement = connection.prepareStatement(query);
				pStatement.setString(1, passenger);
				rs = pStatement.executeQuery();
				rs.next();
				String name = rs.getString(1) + " " + rs.getString(2);	
				pStatement.close();
				
				if(resIdString != null){ %>
					<tr>
						<td> <%= name %> </td>
						<td> <%= creationDate %> </td>
						<td> <%= origTravelDate %> </td>
						<td> <%= origLineName %> </td>
						<td> <%= origTrainNo%> </td>
						<td> <%= origOriginStation %> </td>
						<td> <%= origDeparture.substring(origDeparture.indexOf(" ")+1)%> </td>
						<td> <%= origDestStation %> </td>
						<td> <%= origArrival.substring(origArrival.indexOf(" ")+1) %> </td>
						<td rowspan = 2> <%= origFare*2 %></td>
					</tr>
					
				<%}
			
			%>
			<tr>
				<td> <%= name %> </td>
				<td> <%= creationDate %> </td>
				<td> <%= travelDate %> </td>
				<td> <%= lineName %> </td>
				<td> <%= trainNo %> </td>
				<td> <%= origin + " (" + originState + ")" %> </td>
				<td> <%= departure.substring(departure.indexOf(" ")) %> </td>
				<td> <%= dest + " (" + destState + ")" %> </td>
				<td> <%= arrival.substring(arrival.indexOf(" ")+1) %> </td>
				<% if (resIdString == null) { %>
				<td> <%= "$" + fare %> </td>
					<% } %>
			</tr>
		</table>
		<br>
		<%
		//increment travel date by one day

		System.out.println(travelDate);

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	    Calendar c = Calendar.getInstance();
	    c.setTime(df.parse(travelDate));
	    c.add(Calendar.DATE, 1);
	    travelDate = df.format(c.getTime());
		
	    if(resIdString == null){
		%>
		<form method="get" action="refinedSearch.jsp">
			<input type="date" name="date" min="<%= travelDate%>" required>
			<input type="hidden" name="originStation" value= "<%= dest + " (" + destState + ")"  %>">
			<input type="hidden" name="destStation" value= "<%= origin + " (" + originState + ")"  %>">
			<input type="hidden" name="sort" value= "Arrival">
			<input type="hidden" name="resId" value= "<%= reservationId%>">
			<input type="hidden" name="arrTime" value= "<%= arrival%>">
			<input type="submit" value="Reserve A Return Trip">
		</form>

<%	}connection.close();
	}catch(Exception ex){
		System.out.println(ex.getMessage());
		ex.printStackTrace();
	}

	


%>

	
	
	
	</body>
</html>