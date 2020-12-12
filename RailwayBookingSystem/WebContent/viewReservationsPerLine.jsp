<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>List of Reservations for Inputed Transit Line</title>
	</head>
	<body>
		<jsp:include page="navBarAdmin.jsp"/>	
		<br>
		
		<% String lineName = request.getParameter("transitLine"); %>
		<h1>List of Reservations for <%out.print(lineName);%></h1>
		<hr>
		<%	
		ArrayList<Integer> pastReservationIds = new ArrayList<Integer>();
	
		//Get Today's Date As String
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	    Calendar today = Calendar.getInstance();
	   // String todayDate = df.format(today);
	    
	    try{
	    	ApplicationDB db = new ApplicationDB();
			Connection connection = db.getConnection();
			//get all of this user's reservations
			String query = "SELECT * FROM books WHERE lineName = ?";
			PreparedStatement pStatement = connection.prepareStatement(query);
			pStatement.setString(1, (String)lineName);
			ResultSet rs = pStatement.executeQuery();
			
				while(rs.next()){
					Calendar reservationDate = Calendar.getInstance();
					reservationDate.setTime(df.parse(rs.getString(10)));

					
						//if reservation is part of round-trip, and we do not already have it's "linked" trip in the list -> add id
						if(rs.getObject(11) != null && !pastReservationIds.contains(rs.getInt(11))) {
							System.out.println("Adding an id of round trip");
							pastReservationIds.add(rs.getInt(1));
							
							//get names for origin & dest id's 
							query = "SELECT name, state FROM trainStation WHERE stationID = ?";
							PreparedStatement stmt2 = connection.prepareStatement(query);
							stmt2.setInt(1, rs.getInt(8));
							ResultSet res1 = stmt2.executeQuery();
							res1.next();
							String res1DestStation = res1.getString(1);
							String res1DestState = res1.getString(2);
							
							stmt2 = connection.prepareStatement(query);
							stmt2.setInt(1, rs.getInt(9));
							res1 = stmt2.executeQuery();
							res1.next();
							String res1OriginStation = res1.getString(1);
							String res1OriginState = res1.getString(2);
							
							out.println("Reservation NO: " + rs.getString(1)); %> <br> <%
							out.println("Passenger Username: " + rs.getString(2)); %> <br> <%
							out.println("Transit Line Name: " + rs.getString(3)); %> <br> <%
							out.println("Creation Date: " + rs.getString(4)); %> <br> <%
							out.println("Departure Date: " + rs.getString(5)); %> <br> <%
							out.println("Arrival Date: " + rs.getString(6)); %> <br> <%
							out.println("Total Fare: " + rs.getString(7)); %> <br> <%
							out.println("Destination Station: " + res1DestStation + "(" + res1DestState + ")"); %> <br> <%
							out.println("Origin Station: " + res1OriginStation + "(" + res1OriginState + ")"); %> <br> <%
							out.println("Travel Date: " + rs.getString(10)); %> <br> <%
							if (rs.getString(11) == null){
								out.println("Round Trip?: NO"); %> <br> <%
							}
							else{
								out.println("Round Trip?: YES"); %> <br> <%
							}
							%> 
							<hr>
							<%
						}
						else if(rs.getObject(11) == null){ //is not part of rount-trip -> add id
							pastReservationIds.add(rs.getInt(1));
						
							out.println("Reservation NO: " + rs.getString(1)); %> <br> <%
							out.println("Passenger Username: " + rs.getString(2)); %> <br> <%
							out.println("Transit Line Name: " + rs.getString(3)); %> <br> <%
							out.println("Creation Date: " + rs.getString(4)); %> <br> <%
							out.println("Departure Date: " + rs.getString(5)); %> <br> <%
							out.println("Arrival Date: " + rs.getString(6)); %> <br> <%
							out.println("Total Fare: " + rs.getString(7)); %> <br> <%
							out.println("Destination Station: " + rs.getString(8)); %> <br> <%
							out.println("Origin Station: " + rs.getString(9)); %> <br> <%
							out.println("Travel Date: " + rs.getString(10)); %> <br> <%
							if (rs.getString(11) == null){
								out.println("Round Trip?: NO"); %> <br> <%
							}
							else{
								out.println("Round Trip?: YES"); %> <br> <%
							}
							%> 
							<hr>
							<%
						}
						
						/*System.out.println(rs.getString(1));
						System.out.println(rs.getString(2));
						System.out.println(rs.getString(3));
						System.out.println(rs.getString(4));
						System.out.println(rs.getString(5));
						System.out.println(rs.getString(6));
						System.out.println(rs.getString(7));
						System.out.println();*/
					
				}

			if(pastReservationIds.size() == 0){
				%> <h3> No Current Reservations Found </h3> <%
				return;
			}
	    }catch(Exception ex){
	    	System.out.println(ex.getMessage());
	    	ex.printStackTrace();
	    }
	%>
	</body>
</html>