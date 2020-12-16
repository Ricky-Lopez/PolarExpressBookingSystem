<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Edit Customer Representative Account Information</title>
	</head>
	<body>
		<jsp:include page="navBarAdmin.jsp"/>	
		<h1>Add/Edit/Delete Customer Representative Account Information</h1>
		<% String username = request.getParameter("CRusername").toString();%>
		<h2><% out.print("Account: " + username); %></h2>

		<%
			ApplicationDB db = new ApplicationDB();
			Connection connection = db.getConnection();
			
			//get user information
			String query = "SELECT * FROM employees WHERE username = ?";
			PreparedStatement pStatement = connection.prepareStatement(query);
			pStatement.setString(1, (String)username);
			ResultSet rs = pStatement.executeQuery();
			rs.next();
			
			System.out.println(rs.getString(1));
			System.out.println(rs.getString(2));
			System.out.println(rs.getString(3));
			System.out.println(rs.getString(4));
			System.out.println(rs.getString(5));
			System.out.println(rs.getString(6));
			System.out.println();
			
			String SSN = rs.getString(1);
			String firstName = rs.getString(4);
			String lastName = rs.getString(5);
			String password = rs.getString(3);
			
			connection.close();
		%>
			 
			<form method="post" action="updateRepresentativeAccount.jsp">
			<table>
			<tr>    
			<td>SSN</td><td><input type="text" name="SSN" maxlength="20" value="<%=SSN%>" required></td>
			</tr>
			<tr>
			<td>Username</td><td><%=username%></td>
			</tr>
			<tr>
			<td>First Name</td><td><input type="text" name="firstName" maxlength="20" value="<%=firstName%>" required></td>
			</tr>
			<tr>
			<td>Last Name</td><td><input type="text" name="lastName" maxlength="20" value="<%=lastName%>" required></td>
			</tr>
			<tr>
			<td>Password</td><td><%=password%></td>
			</tr>
			</table>
			<br>
			
			<input type="hidden" name="username" value="<%=username%>"/>
			<input type="hidden" name="userType" value="representative">
			<input type="submit" value="Submit">
			</form>
		<br>
		
		
	</body>
</html>