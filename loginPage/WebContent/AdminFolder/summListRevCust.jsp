<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="stylesheet.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Total Revenue For Each Customer</title>
	</head>
	<body>
		<%
			try {
				//Get the database connection
				ApplicationDB db = new ApplicationDB();
				Connection con = db.getConnection();
		
				//Create a SQL statement
				Statement stmt = con.createStatement();
				
				//ResultSet result = stmt.executeQuery("select c.username Username, sum(t.totalFare) TotalFares from customer_logins c, buys b, tickets t where c.username = b.username and b.ticketID = t.ticketID group by c.username;");
				
				
				//ResultSet result = stmt.executeQuery("select c.username Username, sum(t.totalFare) + sum(b.bookingFee) + sum(c.cancelFeeTotal) TotalRevenueForCustomer from customer_logins c, buys b, tickets t, flights f, includes i where f.flightNum = i.flightNum and i.ticketID = t.ticketID and c.username = b.username and t.ticketID = b.ticketID group by Username;");
				
				ResultSet result = stmt.executeQuery("select c.username CustomerUsername, sum(t.totalFare) + sum(b.bookingFee) TotalRevenueWithoutCancelFee from tickets t, buys b, customer_logins c where c.username = b.username and t.ticketID = b.ticketID  and isCancelled = 'n' group by c.username;	");
				
		
		//		ResultSet result = stmt.executeQuery("select f.airlineID AirlineID, sum(t.totalFare) TotalFares from flights f, includes i, tickets t where f.flightNum = i.flightNum and i.ticketID = t.ticketID group by f.airlineID;");

			//	ResultSet result = stmt.executeQuery("select t.ticketID TicketID, t.totalFare TotalFare from tickets t, buys b where b.ticketID = t.ticketID AND EXTRACT(month FROM b.purchaseDate) = " + month + " group by t.ticketID;");

				//stmt.executeUpdate("INSERT INTO credentials(username, password) VALUES('" + username + "', '" + password + "');");
				//ResultSet result = stmt.executeQuery("SELECT password FROM credentials WHERE username = '" + username + "'");
				
				//out.println("Success");
				
		/* 	} catch (Exception e) {
				out.print(e);
			} */
				
				%>
				
				Total Revenue For Each Customer With Fares and Booking Fees
				
				<table border ='1'>
					<tr>
						<td>Username</td>
						<td>Total Revenue For Each Customer</td>
					</tr>
					
					<%
					while(result.next()) { %>
						<tr>
							<td><%= result.getString("CustomerUsername") %></td>
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
				
				//ResultSet result = stmt.executeQuery("select c.username Username, sum(t.totalFare) TotalFares from customer_logins c, buys b, tickets t where c.username = b.username and b.ticketID = t.ticketID group by c.username;");
				
				
				//ResultSet result = stmt.executeQuery("select c.username Username, sum(t.totalFare) + sum(b.bookingFee) + sum(c.cancelFeeTotal) TotalRevenueForCustomer from customer_logins c, buys b, tickets t, flights f, includes i where f.flightNum = i.flightNum and i.ticketID = t.ticketID and c.username = b.username and t.ticketID = b.ticketID group by Username;");
				
		//		ResultSet result = stmt.executeQuery("select c.username CustomerUsername, sum(t.totalFare) + sum(b.bookingFee) TotalRevenueWithoutCancelFee from tickets t, buys b, customer_logins c where c.username = b.username and t.ticketID = b.ticketID  and isCancelled = 'n' group by c.username;	");
				
		ResultSet result = stmt.executeQuery("select c.username CustomerUsername, sum(t.cancelFee) TotalCancelFee from tickets t, buys b, customer_logins c where c.username = b.username and t.ticketID = b.ticketID  and isCancelled = 'y' group by c.username;");
		
				
				%>
				
				Total Revenue Of Cancel Fees For Each Customer
				<br>
				<small>If empty, no tickets were cancelled</small>
				
				
				<table border ='1'>
					<tr>
						<td>Username</td>
						<td>Total Revenue Of Cancel Fees For Each Customer</td>
					</tr>
					
					<%
					while(result.next()) { %>
						<tr>
							<td><%= result.getString("CustomerUsername") %></td>
							<td><%= result.getString("TotalCancelFee") %></td>
						
						
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
					
				