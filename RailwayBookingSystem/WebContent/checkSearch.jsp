<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*, java.util.*, java.sql.*, javax.servlet.*"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%
String originStationString = request.getParameter("originStation");
String destinationStationString = request.getParameter("destinationStation");
String dateOfTravelString = request.getParameter("dateOfTravel");

//if all string inputs are empty then return
if (originStationString == "" && destinationStationString == ""){
	out.print("Input an origin station and/or a destination station before searching. Please try again.");
	out.print("<br><form action=\"success.jsp\"><input type=\"submit\" value=\"Back to home\"></form></br>");
}

//Date dateOfTravel = new Date();

ApplicationDB db = new ApplicationDB();
Connection connection = db.getConnection();

Statement statement = connection.createStatement();
String stmt = "";
			
//if they only put the origin station- list all trains that start at that station
if (originStationString != "" && destinationStationString == ""){
	/*stmt = "SELECT originStation FROM stations " +
		"WHERE originStation LIKE '" + originStationString + "' AND dateOfTravel LIKE '" + dateOfTravelString + "'";*/
}

//if they only put a destination station- list all trains that end at that station
else if (originStationString == "" && destinationStationString != ""){
	/*stmt = "SELECT destinationStation FROM stations " +
	"WHERE destinationStation LIKE '" + destinationStationString" + "' AND dateOfTravel LIKE '" + dateOfTravelString + "'";*/
}

//user inputted both an origin and destination station
else{
	/*stmt = "SELECT origin station, destinationStation FROM stations " +
	"WHERE originStation LIKE '" + originStationString + "' AND destinationStation LIKE '" + destinationStationString" + "' AND dateOfTravel LIKE '" + dateOfTravelString + "'";*/
}

ResultSet rs = statement.executeQuery(stmt);
System.out.println(rs.getMetaData().getColumnCount());
if(rs.next()){
	out.print("<meta http-equiv=\"Refresh\" content=\"0; url='search.jsp'\" />");
}else{
	out.print("Error. Please try again.");
	out.print("<br><form action=\"success.jsp\"><input type=\"submit\" value=\"Back to home\"></form></br>");
}

connection.close();
%>