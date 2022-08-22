<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Customer Representative Homepage</title>
	</head>
	<body>
			
		<%
		try {
			if (session.getAttribute("user") == null || !session.getAttribute("userType").equals("rep")) {
				response.sendRedirect("login.jsp");
			}
			
			out.println(session.getAttribute("welcomeMessage"));
			
			//PUT YOUR REDIRECT BUTTONS TO YOUR PAGES HERE
			//...
			
			%><table>	
			<tr><td>Customer Representative Tools:</td></tr>
			<tr><td><a href="./repFolder/userFlightActions.jsp">Make and Edit Flight Reservations</a></td></tr>
			<tr><td><a href="./repFolder/editAircraftInformation.jsp">Edit Aircraft Information</a></td></tr>
			<tr><td><a href="./repFolder/editAirportInformation.jsp">Edit Airport Information</a></td></tr>
			<tr><td><a href="./repFolder/editFlightInformation.jsp">Edit Flight Information</a></td></tr>
			<tr><td><a href="./repFolder/waitlistHome.jsp">Search for wait-listed passengers of flights</a></td></tr>
			<tr><td><a href="./repFolder/airportFlights.jsp">Find all flights for an airport</a></td></tr>
			<tr><td><a href="./repFolder/userQuestions.jsp">Reply to user questions</a></td></tr>
			</table>
		<% 	
			
			
		} catch (Exception e) {
			out.println(e);
		} finally {
			out.println("<a href=\"loggedout.jsp\">Log out</a>");
		}
		
		%>
	</body>
</html>