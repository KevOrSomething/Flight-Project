<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="stylesheet.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Total Revenue For A Particular Flight</title>
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
				
				String flightNum = request.getParameter("flightNumForSum");
			
				String airlineID = request.getParameter("airlineIDForSum");
				
			//	ResultSet result = stmt.executeQuery("select f.flightNum FlightNum, sum(t.totalFare) + sum(b.bookingFee) + sum(c.cancelFeeTotal)  TotalRevenueForThisFlight  from flights f, includes i, tickets t , buys b, customer_logins c where f.flightNum = i.flightNum and i.ticketID = t.ticketID and b.username = c.username and b.ticketID = t.ticketID and  f.flightNum = " + flightNum + " group by f.flightNum;");
			
			
			
			
	
		
				ResultSet result = stmt.executeQuery("select f.flightNum FlightNum, f.airlineID AirlineID, sum(t.totalFare) + sum(b.bookingFee) TotalRevenueWithoutCancelFee from flights f, includes i, tickets t, buys b where f.flightNum = i.flightNum and t.ticketID = b.ticketID and i.ticketID = t.ticketID and isCancelled = 'n' and f.flightNum = " + flightNum + " and f.airlineID = '" + airlineID + "' group by f.flightNum, f.airlineID;");
			


			//	ResultSet result = stmt.executeQuery("select t.ticketID TicketID, t.totalFare TotalFare from tickets t, buys b where b.ticketID = t.ticketID AND EXTRACT(month FROM b.purchaseDate) = " + month + " group by t.ticketID;");

				//stmt.executeUpdate("INSERT INTO credentials(username, password) VALUES('" + username + "', '" + password + "');");
				//ResultSet result = stmt.executeQuery("SELECT password FROM credentials WHERE username = '" + username + "'");
				
				//out.println("Success");
				
		/* 	} catch (Exception e) {
				out.print(e);
			} */
				
				%>
				
				Total Revenue For This Particular Flight Based On Fares and Booking Fees
				<table border ='1'>
					<tr>
						<td>Flight Number</td>
						<td>Airline ID</td>
						<td>Total Revenue For This Flight Without Cancel Fees</td>
					</tr>
					
					<%
					while(result.next()) { %>
						<tr>
							<td><%= result.getString("FlightNum") %></td>
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
				
				String flightNum = request.getParameter("flightNumForSum");
			
				String airlineID = request.getParameter("airlineIDForSum");
				
			//	ResultSet result = stmt.executeQuery("select f.flightNum FlightNum, sum(t.totalFare) + sum(b.bookingFee) + sum(c.cancelFeeTotal)  TotalRevenueForThisFlight  from flights f, includes i, tickets t , buys b, customer_logins c where f.flightNum = i.flightNum and i.ticketID = t.ticketID and b.username = c.username and b.ticketID = t.ticketID and  f.flightNum = " + flightNum + " group by f.flightNum;");
			
			
			//ResultSet result = stmt.executeQuery("select f.flightNum FlightNum, f.airlineID AirlineID, sum(t.totalFare) + sum(b.bookingFee) TotalRevenueWithoutCancelFee from flights f, includes i, tickets t, buys b where f.flightNum = i.flightNum and t.ticketID = b.ticketID and i.ticketID = t.ticketID and isCancelled = 'n' and f.flightNum = " + flightNum + " group by f.flightNum, f.airlineID;");
				
				ResultSet result = stmt.executeQuery("select f.flightNum FlightNum, f.airlineID AirlineID, sum(t.cancelFee) TotalRevenueOfCancelFees from flights f, includes i, tickets t, buys b where f.flightNum = i.flightNum and t.ticketID = b.ticketID and i.ticketID = t.ticketID and isCancelled = 'y' and f.flightNum = " + flightNum + " and f.airlineID = '" + airlineID + "' group by f.flightNum, f.airlineID;");
	
				%>
				
				Total Revenue For This Particular Flight Based On Cancel Fees
				<br>
				<small>If empty, there were no cancellations for the entered flight</small>
				<table border ='1'>
					<tr>
						<td>Flight Number</td>
						<td>Airline ID</td>
						<td>Total Revenue For This Flight For Cancel Fees</td>
					</tr>
					
					<%
					while(result.next()) { %>
						<tr>
							<td><%= result.getString("FlightNum") %></td>
							<td><%= result.getString("AirlineID") %></td>
							<td><%= result.getString("TotalRevenueOfCancelFees") %></td>
						
						
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
					
				