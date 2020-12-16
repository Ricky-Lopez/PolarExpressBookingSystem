<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
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
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>List of Reservations for Inputed Customer</title>
	</head>
	<body>
		<jsp:include page="navBarAdmin.jsp"/>	
		
		<% String username = request.getParameter("customer").toString(); %>
		<h1>List of Reservations for <%out.print(username);%></h1>
		<hr>
		<br>
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
			String query = "SELECT * FROM books WHERE username = ?";
			PreparedStatement pStatement = connection.prepareStatement(query);
			pStatement.setString(1, (String)username);
			ResultSet rs = pStatement.executeQuery();
			
				while(rs.next()){
					Calendar reservationDate = Calendar.getInstance();
					reservationDate.setTime(df.parse(rs.getString(10)));

					
						//if reservation is part of round-trip, and we do not already have it's "linked" trip in the list -> add id
						if(rs.getObject(11) != null && !pastReservationIds.contains(rs.getInt(11))) {
							System.out.println("Adding an id of round trip");
							pastReservationIds.add(rs.getInt(1));
						}
						else if(rs.getObject(11) == null){ //is not part of rount-trip -> add id
							pastReservationIds.add(rs.getInt(1));
						}
					
				}

			if(pastReservationIds.size() == 0){
				%> <h3> No Current Reservations Found </h3> <%
				return;
			}
			
			//format "list" string for sql IN clause
			String placeholderString = "";
			for(int i = 0; i < pastReservationIds.size(); i++){
				placeholderString += "?";
				if(i != pastReservationIds.size()-1){
					placeholderString += ", ";

				}
			}
			
			//get Passenger name
			query = "SELECT first_name, last_name FROM passengers WHERE username = ?";
			pStatement = connection.prepareStatement(query);
			pStatement.setString(1, (String)username);
			rs = pStatement.executeQuery();
			rs.next();
			String name = rs.getString(1) + " " + rs.getString(2);
			
			
			%>
		
			
			<%
			//Retrive info from books for past reservation Ids
			query = "SELECT * FROM books WHERE reservationNo IN (" + placeholderString + ")";
			pStatement = connection.prepareStatement(query);
			for(int i = 1; i <= pastReservationIds.size(); i++){
				pStatement.setInt(i, pastReservationIds.get(i-1));
			}
			rs = pStatement.executeQuery();
			while(rs.next()){
				//if is part of round-trip -> output reservations together
				if(rs.getObject(11) != null){
					//get corresponding reservation from DB
					query = "SELECT * FROM books WHERE reservationNo = ?";
					PreparedStatement statement = connection.prepareStatement(query);
					statement.setInt(1, rs.getInt(11));
					ResultSet r = statement.executeQuery();
					r.next();
					
					Calendar res1Date = Calendar.getInstance();
					Calendar res2Date = Calendar.getInstance();
					res1Date.setTime(df.parse(rs.getString(10)));
					res2Date.setTime(df.parse(r.getString(10)));
					
					//get train Number for res1
					query = "SELECT trainID FROM services WHERE lineName = ?";
					PreparedStatement stmt = connection.prepareStatement(query);
					stmt.setString(1, rs.getString(3));
					ResultSet train = stmt.executeQuery();
					train.next();
					int res1TrainNo = train.getInt(1);
					
					//get train Number for res2
					query = "SELECT trainID FROM services WHERE lineName = ?";
					stmt = connection.prepareStatement(query);
					stmt.setString(1, r.getString(3));
					train = stmt.executeQuery();
					train.next();
					int res2TrainNo = train.getInt(1);
					
					//get names for origin & dest id's for res1 
					query = "SELECT name, state FROM trainStation WHERE stationID = ?";
					stmt = connection.prepareStatement(query);
					stmt.setInt(1, rs.getInt(8));
					ResultSet rs1 = stmt.executeQuery();
					rs1.next();
					String res1DestStation = rs1.getString(1);
					String res1DestState = rs1.getString(2);
					
					stmt = connection.prepareStatement(query);
					stmt.setInt(1, rs.getInt(9));
					rs1 = stmt.executeQuery();
					rs1.next();
					String res1OriginStation = rs1.getString(1);
					String res1OriginState = rs1.getString(2);
					
					//get names for origin & dest id's for res2 
					stmt = connection.prepareStatement(query);
					stmt.setInt(1, r.getInt(8));
					ResultSet rs2 = stmt.executeQuery();
					rs2.next();
					String res2DestStation = rs2.getString(1);
					String res2DestState = rs2.getString(2);
					
					stmt = connection.prepareStatement(query);
					stmt.setInt(1, r.getInt(9));
					rs2 = stmt.executeQuery();
					rs2.next();
					String res2OriginStation = rs2.getString(1);
					String res2OriginState = rs2.getString(2);
					
					
					
					if(res1Date.compareTo(res2Date) < 0){ //res1 is origin trip -> output res1 first
					%> 
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
							<tr>
								<td> <%=name%> </td>
								<td> <%=rs.getString(4)%> </td>
								<td> <%=rs.getString(10)%> </td>
								<td> <%=rs.getString(3)%> </td>
								<td> <%=res1TrainNo%> </td>
								<td> <%=res1OriginStation + "(" + res1OriginState + ")"%></td>
								<td> <%=rs.getString(5).substring(rs.getString(5).indexOf(" ")+1) %>
								<td> <%=res1DestStation + "(" + res1DestState + ")"%></td>
								<td> <%=rs.getString(6).substring(rs.getString(6).indexOf(" ")+1) %>
								<td rowspan = 2> <%=rs.getFloat(7)*2%> </td>
							</tr>
							<tr>
								<td> <%=name%> </td>
								<td> <%=r.getString(4)%> </td>
								<td> <%=r.getString(10)%> </td>
								<td> <%=r.getString(3)%> </td>
								<td> <%=res2TrainNo%> </td>
								<td> <%=res2OriginStation + "(" + res2OriginState + ")"%></td>
								<td> <%=r.getString(5).substring(r.getString(5).indexOf(" ")+1) %>
								<td> <%=res2DestStation + "(" + res2DestState + ")"%></td>
								<td> <%=r.getString(6).substring(r.getString(6).indexOf(" ")+1) %>
							</tr>
						
						</table>
						<br>
					<% }
					else{ //ouput res2 first %>
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
							<tr>
								<td> <%=name%> </td>
								<td> <%=r.getString(4)%> </td>
								<td> <%=r.getString(10)%> </td>
								<td> <%=r.getString(3)%> </td>
								<td> <%=res2TrainNo%> </td>
								<td> <%=res2OriginStation + "(" + res2OriginState + ")"%></td>
								<td> <%=r.getString(5).substring(r.getString(5).indexOf(" ")+1) %>
								<td> <%=res2DestStation + "(" + res2DestState + ")"%></td>
								<td> <%=r.getString(6).substring(r.getString(6).indexOf(" ")+1) %>
								<td rowspan = 2> <%=r.getFloat(7)*2%> </td>
							</tr>
							<tr>
								<td> <%=name%> </td>
								<td> <%=rs.getString(4)%> </td>
								<td> <%=rs.getString(10)%> </td>
								<td> <%=rs.getString(3)%> </td>
								<td> <%=res1TrainNo%></td>
								<td> <%=res1OriginStation + "(" + res1OriginState + ")"%></td>
								<td> <%=rs.getString(5).substring(rs.getString(5).indexOf(" ")+1) %>
								<td> <%=res1DestStation + "(" + res1DestState + ")"%></td>
								<td> <%=rs.getString(6).substring(rs.getString(6).indexOf(" ")+1) %>
							</tr>
						
						</table>
						<br>
					
					
					<%}
					
				}
				//otherwise, just output
				else{ 
					//get train Number
					query = "SELECT trainID FROM services WHERE lineName = ?";
					PreparedStatement stmt = connection.prepareStatement(query);
					stmt.setString(1, rs.getString(3));
					ResultSet train = stmt.executeQuery();
					train.next();
					int trainNo = train.getInt(1);
					
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
					
				
				%>
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
							<tr>
								<td> <%=name%> </td>
								<td> <%=rs.getString(4)%> </td>
								<td> <%=rs.getString(10)%> </td>
								<td> <%=rs.getString(3)%> </td>
								<td> <%= trainNo %> </td>
								<td> <%=res1OriginStation + "(" + res1OriginState + ")"%></td>
								<td> <%=rs.getString(5).substring(rs.getString(5).indexOf(" ")+1) %>
								<td> <%=res1DestStation + "(" + res1DestState + ")"%></td>
								<td> <%=rs.getString(6).substring(rs.getString(6).indexOf(" ")+1) %>
								<td> <%=rs.getFloat(7)%> </td>
							</tr>
						</table>
						<br>
					
				<% }
			}
			
			
			
			
	    connection.close();
	    }catch(Exception ex){
	    	System.out.println(ex.getMessage());
	    	ex.printStackTrace();
	    }
	    
	
	
	%>
	</body>
</html>