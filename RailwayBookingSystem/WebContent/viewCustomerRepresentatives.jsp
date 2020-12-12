<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>List of Customer Representatives</title>
	</head>
	<body>
		<jsp:include page="navBarAdmin.jsp"/>	
		
		<h1>Customer Representative Accounts</h1>
		<br>
		
		<%
		
		ArrayList<String> customerRepresentativeUsernames = new ArrayList<String>();

		try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			
			String query = "SELECT username FROM employees WHERE isAdmin = false";
			
			Statement statement = con.createStatement();
			//PreparedStatement pStatement = connection.prepareStatement(query);
			
			//System.out.println(query);
			
			//Run the query against the database
			ResultSet result = statement.executeQuery(query);
			//System.out.println(result);
			
			//Make an HTML table to show the results in:
			out.print("<table>");

			//make a row
			out.print("<tr>");
			//make a column
			out.print("<td>");
			//print out column header
			out.print("Username");
			out.print("</td>");
			//make a column
			out.print("<td>");
			out.print("| Edit Account Information");
			out.print("</td>");
			out.print("</tr>");

			//parse out the results
			while (result.next()) {
				//make a row
				out.print("<tr>");
				//make a column
				out.print("<td>");
				//Print out the reservation NO
				String userNA = result.getString("username");
				out.print(userNA);
				out.print("</td>");
				out.print("<td>");
				//View reservation button
				%>
					<form method = "post" action="editCRAccount.jsp">
						<input type="submit" value="Edit">
						<input type="hidden" name="CRusername" value="<%=userNA%>"/>
					</form> 
				<%
				//out.print("<form action=\"editCRAccount.jsp\"><input type=\"submit\" value=\"Edit\"></form>");
				//<input type=\"hidden\" name=\"CRusername\" value=\"\"/>
				out.print("</td>");
				out.print("<td>");
			}
			out.print("</table>");

			//close the connection.
			con.close();

		} catch (Exception e) {
			out.print("out");
		}
	%>
	
	</body>
</html>