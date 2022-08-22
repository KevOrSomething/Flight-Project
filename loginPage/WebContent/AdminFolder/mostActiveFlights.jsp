<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="stylesheet.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>List of Most Active Flights</title>
	</head>
	<body>
		<%
			try {
				//Get the database connection
				ApplicationDB db = new ApplicationDB();
				Connection con = db.getConnection();
		
				//Create a SQL statement
				Statement stmt = con.createStatement();
				//String username = request.getParameter("loginUsername");
			

				ResultSet result = stmt.executeQuery("select t1.FlightNumber FlightNumber, t1.airlineID airlineID, count(*) NumbOfTickets from ( select f.flightNum FlightNumber, f.airlineID airlineID, t.ticketID TicketID from flights f, includes i, tickets t where f.flightNum = i.flightNum and i.ticketID = t.ticketID) t1 group by FlightNumber, airlineID Order by count(*) desc;");
				
			
				%>
				
				<table border ='1'>
					<tr>
						<td>Flight Number</td>
						<td>Airline ID</td>
						<td>Number of Tickets</td>
					</tr>
					
					<%
					while(result.next()) { %>
						<tr>
							<td><%= result.getString("FlightNumber") %></td>
						  	<td><%= result.getString("airlineID") %></td>
							<td><%= result.getString("NumbOfTickets") %></td>
						
						
						</tr>
					
					<% }
						db.closeConnection(con);
					%>
					
					
				</table>
				<br>
				
				<%} catch (Exception e) {
					out.print(e);
				}%>
		
				<form action="../adminhome.jsp">
				<input type="submit" value="Return to Dashboard">
				</form>
					
					</body>
		</html>
				