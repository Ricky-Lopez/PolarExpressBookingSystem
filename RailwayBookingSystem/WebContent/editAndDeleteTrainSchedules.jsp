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
<title>Train Schedule Maker</title>
</head>
<body>
	<h1>Modify By Train</h1>
	<hr>
	<form method="get" action="editTrainID.jsp">
	<table>
	<tr>
	<td>
	Choose Train:
	</td>
	</tr>
	<tr>
	<td>
		<select name="currTrainID" id="currTrainID" required>
		<%
		try{
			ApplicationDB db = new ApplicationDB();	
			Connection connection = db.getConnection();
			Statement statement = connection.createStatement();
			String query = "SELECT trainId from services";
			ResultSet rs = statement.executeQuery(query);
			while(rs.next()){
				String val = "\"" + rs.getString(1) + "\"";
				out.write("<option value=" + val + ">" + rs.getString(1) + "</option>");

			}
		}catch(Exception ex){
			ex.printStackTrace();
		}
		%>
		</select>
	</td>
	</tr>
	</table>
	<br>
	<input type="submit" value="Edit Train ID To:">
	<input type="text" name="newTrainID" maxlength=4 minlength=4 required>
	</form>
	<br>
	<form method="get" action="deleteTrainID.jsp">
		<input type="submit" value="Delete Train From Records:">
		<input type="text" name="trainID" maxlength=4 minlength=4 required>
	</form>
	<br>
	<form method="get" action="addTrainID.jsp">
		<Table>
		<tr>
		<td>
		Train ID
		</td>
		<td>
		Transit Line
		</td>
		</tr>
		<tr>
		<td>
		<input type="text" name="trainID" maxlength=4 minlength=4 required>
		</td>
		<td>
		<input type="text" name="transitLine" required>
		<td>
		<input type="submit" value="Add Train to Records">
		</td>
		</tr>
		</Table>
	</form>
	<hr>
	<h1> Modify by Transit Line</h1>
	<hr>
		<form method="get" action="editTransitLine.jsp">
	<table>
	<tr>
	<td>
	Choose Transit Line:
	</td>
	</tr>
	<tr>
	<td>
		<select name="currTransitLine" id="currTransitLine" required>
		<%
		try{
			ApplicationDB db = new ApplicationDB();	
			Connection connection = db.getConnection();
			Statement statement = connection.createStatement();
			String query = "SELECT lineName from transitLine";
			ResultSet rs = statement.executeQuery(query);
			while(rs.next()){
				String val = "\"" + rs.getString(1) + "\"";
				out.write("<option value=" + val + ">" + rs.getString(1) + "</option>");

			}
		}catch(Exception ex){
			ex.printStackTrace();
		}
		%>
		</select>
	</td>
	</tr>
	</table>
	<br>
	<input type="submit" value="Edit Transit Line To:">
	<input type="text" name="newTransitLine" required>
	</form>
	<br>
	<form method="get" action="deleteTransitLine.jsp">
		<input type="submit" value="Delete Transit Line From Records:">
		<input type="text" name="transitLine" required>
	</form>
	<hr>
	<h1> Modify by Arrival and Departure Time</h1>
	<hr>
		<form method="get" action="editDateTime.jsp">
	<table>
	<tr>
	<td>
	Choose Train Schedule to Modify:
	</td>
	</tr>
	<tr>
	<td>
		<select name="currTransitLine" id="currTransitLine" required>
		<%
		try{
			ApplicationDB db = new ApplicationDB();	
			Connection connection = db.getConnection();
			Statement statement = connection.createStatement();
			String query = "SELECT lineName, arrivalTime, departureTime from stopsAt";
			ResultSet rs = statement.executeQuery(query);
			while(rs.next()){
				String val = rs.getString(1) + ", Arrival Time: " + rs.getString(2) + ", Departure Time: " + rs.getString(3);
				out.write("<option value=" + val + ">" + val + "</option>");

			}
		}catch(Exception ex){
			ex.printStackTrace();
		}
		%>
		</select>
	</td>
	</tr>
	</table>
	<br>
	<input type="submit" value="Edit Arrival Time To:">
	<input type="datetime-local" name="arrivalDate" required >
	<br>
	<input type="submit" value="Edit Departure Time To:">
	<input type="datetime-local" name="departureDate" required>
	</form>
	<br>
	<br>
</body>
</html>