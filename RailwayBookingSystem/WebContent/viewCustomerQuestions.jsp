<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
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
		<title>Customer Questions</title>
	</head>
	<body>
	<h1>Questions & Answers</h1>
	<form method="post" action="viewCustomerQuestionsByKey.jsp">
		<input type="submit" value="Sort by Keyword:"> <input type="text" name="keyword" maxlength=100 required>
		
	</form>
	<br>
	<form method="get" action="response.jsp">
		<table>
		<tr>
		<td> Questions List </td>
		</tr>
		<tr>
			<td>
				<%
				try{
					ApplicationDB db = new ApplicationDB();	
					Connection connection = db.getConnection();
					Statement statement = connection.createStatement();
					String query = "SELECT * FROM questions";
					ResultSet rs = statement.executeQuery(query);
					while(rs.next()){
						String val = "\"" + rs.getString(1) + "\" - " + rs.getString(3) + "&nbsp &nbsp";
						out.write(val);
						if(rs.getString(2) != null){
							out.write("<br> <br>");
							out.write("&nbsp &nbsp &nbsp &nbsp Representative Response: " + rs.getString(2));
						}
						out.write("<br> <br>");
					}
					
					connection.close();
				}catch(Exception ex){
					
				}
				%>
			</td>
			</tr>
		<tr>
		</tr>
		</table>
	</form>
	<br>
		<jsp:include page="navBar.jsp"/>	
	</body>
</html>