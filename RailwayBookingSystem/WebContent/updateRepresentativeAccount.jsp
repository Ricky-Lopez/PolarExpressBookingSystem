<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%

String userType = request.getParameter("userType");
try{
	ApplicationDB db = new ApplicationDB();	
	Connection connection = db.getConnection();
	
	Statement statement = connection.createStatement();
	
	//if userType is passenger
	if (userType.equals("representative")){
		String query = "UPDATE employees SET SSN=?, first_name=?, last_name=? WHERE username=?";
		
		String CRusername = (String)request.getParameter("username");
		System.out.println(CRusername);
		
		PreparedStatement pStatement = connection.prepareStatement(query);
		pStatement.setString(4, CRusername);
		pStatement.setString(1, (String)request.getParameter("SSN"));
		pStatement.setString(2, (String)request.getParameter("firstName"));
		pStatement.setString(3, (String)request.getParameter("lastName"));
		
		int i = pStatement.executeUpdate();
		
		if (i > 0){
			System.out.println("update success");
		}
		else{
			System.out.println("update not a success");
		}
		System.out.println();
	}
	
	
	connection.close();
	out.print("Information Updated!");
	out.print("<br><form action=\"adminHome.jsp\"><input type=\"submit\" value=\"Back to Home\"></form></br>");
	
} catch(Exception ex){
	System.out.println(ex.toString());
	out.print("Error");
	out.print("<br><form action=\"adminHome.jsp\"><input type=\"submit\" value=\"Back to Home\"></form></br>");
}
%>