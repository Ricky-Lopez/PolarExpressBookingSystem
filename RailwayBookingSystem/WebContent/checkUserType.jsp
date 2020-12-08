<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%

String userType = request.getParameter("command");
if(userType.equals("admin")){
	out.print("<meta http-equiv=\"Refresh\" content=\"0; url='adminRegistration.jsp'\" />");
}
else if(userType.equals("representative")){
	out.print("<meta http-equiv=\"Refresh\" content=\"0; url='representativeRegistration.jsp'\" />");
}
else{
	out.print("<meta http-equiv=\"Refresh\" content=\"0; url='customerRegistration.jsp'\" />");
}

%>