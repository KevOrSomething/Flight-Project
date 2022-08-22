<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="stylesheet.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Total Revenue For A Particular Airline</title>
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
				//String enteredPassword = request.getParameter("loginPassword");
				//String correctPassword = null;
				//String loginType = request.getParameter("loginType");
				
				String airlineID = request.getParameter("airlineIDforSum");
				
				//ResultSet result = stmt.executeQuery("select f.airlineID AirlineID, sum(t.totalFare) + sum(b.bookingFee) + sum(c.cancelFeeTotal) TotalRevenueForThisAirline  from flights f, includes i, tickets t, buys b, customer_logins c where f.flightNum = i.flightNum and i.ticketID = t.ticketID and b.username = c.username and b.ticketID = t.ticketID and f.airlineID = '" + airlineID + "' group by f.airlineID;");

				ResultSet result = stmt.executeQuery("select f.airlineID AirlineID, sum(t.totalFare) + sum(b.bookingFee) TotalRevenueWithoutCancelFee from flights f, includes i, tickets t, buys b where f.flightNum = i.flightNum and t.ticketID = b.ticketID and i.ticketID = t.ticketID and isCancelled = 'n' and f.airlineID = '" + airlineID + "' group by f.airlineID;");
				
				
				%>
			
				Total Revenue For This Particular Airline Based On Fares and Booking Fees
				
				<table border ='1'>
					<tr>
						<td>Airline ID</td>
						<td>Total Revenue For This Airline Without Cancel Fees</td>
					</tr>
					
					<%
					while(result.next()) { %>
						<tr>
							<td><%= result.getString("AirlineID") %></td>
							<td><%= result.getString("TotalRevenueWithoutCancelFee") %></td>
						
						
						</tr>
					
					<% }
						db.closeConnection(con);
					%>
					
					
				</table>
				
				<br>

				
				<%} catch (Exception e) {
					out.print(e);
				}%>
				
	
	
	
		<%
			try {
				//Get the database connection
				ApplicationDB db = new ApplicationDB();
				Connection con = db.getConnection();
		
				//Create a SQL statement
				Statement stmt = con.createStatement();
				//String username = request.getParameter("loginUsername");
				//String enteredPassword = request.getParameter("loginPassword");
				//String correctPassword = null;
				//String loginType = request.getParameter("loginType");
				
				String airlineID = request.getParameter("airlineIDforSum");
				
				//ResultSet result = stmt.executeQuery("select f.airlineID AirlineID, sum(t.totalFare) + sum(b.bookingFee) + sum(c.cancelFeeTotal) TotalRevenueForThisAirline  from flights f, includes i, tickets t, buys b, customer_logins c where f.flightNum = i.flightNum and i.ticketID = t.ticketID and b.username = c.username and b.ticketID = t.ticketID and f.airlineID = '" + airlineID + "' group by f.airlineID;");

				//ResultSet result = stmt.executeQuery("select f.airlineID AirlineID, sum(t.totalFare) + sum(b.bookingFee) TotalRevenueWithoutCancelFee from flights f, includes i, tickets t, buys b where f.flightNum = i.flightNum and t.ticketID = b.ticketID and i.ticketID = t.ticketID and isCancelled = 'n' and f.airlineID = '" + airlineID + "' group by f.airlineID;");
				
				ResultSet result = stmt.executeQuery("select f.airlineID AirlineID, sum(t.cancelFee) cancelFeeTotal from flights f, includes i, tickets t, buys b where f.flightNum = i.flightNum and t.ticketID = b.ticketID and i.ticketID = t.ticketID and isCancelled = 'y' and f.airlineID = '" + airlineID + "' group by f.airlineID;");
				
				%>
			
				Total Revenue For This Particular Airline Based On Cancel Fees
				<br>
				<small>If empty, no tickets for the entered airline were cancelled</small>
				<table border ='1'>
					<tr>
						<td>Airline ID</td>
						<td>Total Revenue For This Airline For CancelFees</td>
					</tr>
					
					<%
					while(result.next()) { %>
						<tr>
							<td><%= result.getString("AirlineID") %></td>
							<td><%= result.getString("cancelFeeTotal") %></td>
						
						
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
					
				