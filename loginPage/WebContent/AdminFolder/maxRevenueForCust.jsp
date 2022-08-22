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
				
	
				ResultSet result = stmt.executeQuery("select c.username CustomerUsername, sum(t.totalFare) + sum(b.bookingFee) TotalRevenueWithoutCancelFee from tickets t, buys b, customer_logins c where c.username = b.username and t.ticketID = b.ticketID  and isCancelled = 'n' group by c.username order by TotalRevenueWithoutCancelFee DESC Limit 1;");
				
		
				
				%>
				Customer With Maximum Revenue Depending on Fares And Booking Fees
				<table border ='1'>
					<tr>
						<td>Username</td>
						<td>Maximum Total Revenue Without Cancel Fees</td>
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
				
				ResultSet result = stmt.executeQuery("select c.username CustomerUsername, sum(t.cancelFee) TotalCancelFee from tickets t, buys b, customer_logins c where c.username = b.username and t.ticketID = b.ticketID and isCancelled = 'y' group by c.username order by TotalCancelFee DESC Limit 1;");				
		
				
				%>
				Customer With Maximum Revenue Depending on Cancel Fees
				<br>
				<small>If empty, no customers cancelled tickets</small>
				<table border ='1'>
					<tr>
						<td>Username</td>
						<td>Maximum Total Revenue Based On Cancel Fees</td>
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
					
				