<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
		//note that if one reservation of round trip is cancelled, entire trip will be cancelled due to FK constraints and on delete cascade option
		
		int resIdToCancel = Integer.parseInt(request.getParameter("resId"));
		try{
			ApplicationDB db = new ApplicationDB();
			Connection connection = db.getConnection();
			String query = "DELETE FROM books WHERE reservationNo = ?;";
			PreparedStatement pStatement = connection.prepareStatement(query);
			pStatement.setInt(1, resIdToCancel);
			pStatement.executeUpdate();
			
		}catch (Exception ex){
			ex.printStackTrace();
		}

	%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<title>Cancel Reservation</title>
	<meta http-equiv="Refresh" content="0; url= viewCurrentReservations.jsp" />
	</head>
	<body>
	</body>
	</html>