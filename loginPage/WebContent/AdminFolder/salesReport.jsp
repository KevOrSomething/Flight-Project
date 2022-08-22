<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="stylesheet.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Sales Report</title>
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
				
				String month = request.getParameter("MonthForReport");
				
				//Run the query against the database.
				//ResultSet result = stmt.executeQuery("SELECT password FROM " + loginType + "_logins WHERE username = '" + username + "';");
				//ResultSet result = stmt.executeQuery("select EXTRACT(month FROM t.purchaseDate) Month, count(ticketID) NumberOfTickets from tickets t where EXTRACT(month FROM t.purchaseDate) = " + month + " group by EXTRACT(month FROM t.purchaseDate)"); 
				//.ticketID TicketID, t.totalFare TotalFare from tickets t, buys where b.ticketID = t.ticketID AND EXTRACT(month FROM b.purchaseDate) = 12
				//		group by t.ticketID ")
				
				//ResultSet totalRes = stmt.executeQuery("select EXTRACT(month FROM b.purchaseDate) Month, sum(t.totalFare) TotalFareForMonth from tickets t, buys b where t.ticketID = b.ticketID and EXTRACT(month FROM b.purchaseDate) = " + month + " group by Month;");
				
				//ResultSet totalRes = stmt.executeQuery("Select EXTRACT(month FROM b.purchaseDate) Month, sum(t.totalFare) + sum(c.cancelFeeTotal) + sum(b.bookingFee) TotalRevenueForMonth  from tickets t, buys b, customer_logins c where t.ticketID = b.ticketID and c.username = b.username and EXTRACT(month FROM b.purchaseDate) = " + month + " group by Month;");
				
				
				//ResultSet totalRes = stmt.executeQuery("select t1.Month Month, t1.RevenueWithoutCancelFee + t2.CancelFeeRev totalRev from (select EXTRACT(month FROM b.purchaseDate) Month, sum(t.totalFare) + sum(b.bookingFee) RevenueWithoutCancelFee from tickets t, buys b where t.ticketID = b.ticketID and isCancelled = 'n' and  EXTRACT(month FROM b.purchaseDate) = " + month + " group by Month) t1,  ( select EXTRACT(month FROM b.purchaseDate) Month, sum(t.cancelFee) CancelFeeRev from tickets t, buys b where t.ticketID = b.ticketID and isCancelled = 'y' and EXTRACT(month FROM b.purchaseDate) = " + month + " group by Month) t2 where t1.Month = t2.Month;");
				
				
				ResultSet totalRes = stmt.executeQuery("select EXTRACT(month FROM b.purchaseDate) Month, sum(t.totalFare) + sum(b.bookingFee) RevenueWithoutCancelFee from tickets t, buys b where t.ticketID = b.ticketID and isCancelled = 'n' and  EXTRACT(month FROM b.purchaseDate) = " + month + " group by Month;");
						
				

				//ResultSet result = stmt.executeQuery("select t.ticketID TicketID, t.totalFare TotalFare from tickets t, buys b where b.ticketID = t.ticketID AND EXTRACT(month FROM b.purchaseDate) = " + month + " group by t.ticketID;");

				//stmt.executeUpdate("INSERT INTO credentials(username, password) VALUES('" + username + "', '" + password + "');");
				//ResultSet result = stmt.executeQuery("SELECT password FROM credentials WHERE username = '" + username + "'");
				
				//out.println("Success");
				
		/* 	} catch (Exception e) {
				out.print(e);
			} */
				
				%>
				
				
				
				
				Total Revenue Without Cancellation Fee
				<table border ='1'>
					<tr>
						<td>Month</td>
						<td>Total Revenue For The Month Without Cancel Fees</td>
					</tr>
					
					<%
					while(totalRes.next()) { %>
						<tr>
							<td><%= totalRes.getString("Month") %></td>
							<td><%= totalRes.getString("RevenueWithoutCancelFee") %></td>
						
						
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
				
				String month = request.getParameter("MonthForReport");
				
				//Run the query against the database.
				//ResultSet result = stmt.executeQuery("SELECT password FROM " + loginType + "_logins WHERE username = '" + username + "';");
				//ResultSet result = stmt.executeQuery("select EXTRACT(month FROM t.purchaseDate) Month, count(ticketID) NumberOfTickets from tickets t where EXTRACT(month FROM t.purchaseDate) = " + month + " group by EXTRACT(month FROM t.purchaseDate)"); 
				//.ticketID TicketID, t.totalFare TotalFare from tickets t, buys where b.ticketID = t.ticketID AND EXTRACT(month FROM b.purchaseDate) = 12
				//		group by t.ticketID ")
				
				//ResultSet totalRes = stmt.executeQuery("select EXTRACT(month FROM b.purchaseDate) Month, sum(t.totalFare) TotalFareForMonth from tickets t, buys b where t.ticketID = b.ticketID and EXTRACT(month FROM b.purchaseDate) = " + month + " group by Month;");
				
				//ResultSet totalRes = stmt.executeQuery("Select EXTRACT(month FROM b.purchaseDate) Month, sum(t.totalFare) + sum(c.cancelFeeTotal) + sum(b.bookingFee) TotalRevenueForMonth  from tickets t, buys b, customer_logins c where t.ticketID = b.ticketID and c.username = b.username and EXTRACT(month FROM b.purchaseDate) = " + month + " group by Month;");
				
				
				//ResultSet totalRes = stmt.executeQuery("select t1.Month Month, t1.RevenueWithoutCancelFee + t2.CancelFeeRev totalRev from (select EXTRACT(month FROM b.purchaseDate) Month, sum(t.totalFare) + sum(b.bookingFee) RevenueWithoutCancelFee from tickets t, buys b where t.ticketID = b.ticketID and isCancelled = 'n' and  EXTRACT(month FROM b.purchaseDate) = " + month + " group by Month) t1,  ( select EXTRACT(month FROM b.purchaseDate) Month, sum(t.cancelFee) CancelFeeRev from tickets t, buys b where t.ticketID = b.ticketID and isCancelled = 'y' and EXTRACT(month FROM b.purchaseDate) = " + month + " group by Month) t2 where t1.Month = t2.Month;");
				
				
				//ResultSet totalRes = stmt.executeQuery("select EXTRACT(month FROM b.purchaseDate) Month, sum(t.totalFare) + sum(b.bookingFee) RevenueWithoutCancelFee from tickets t, buys b where t.ticketID = b.ticketID and isCancelled = 'n' and  EXTRACT(month FROM b.purchaseDate) = " + month + " group by Month;");
				
				ResultSet result = stmt.executeQuery("select EXTRACT(month FROM b.purchaseDate) Month, sum(t.cancelFee) CancelFeeRev from tickets t, buys b where t.ticketID = b.ticketID and isCancelled = 'y' and EXTRACT(month FROM b.purchaseDate) = " + month + " group by Month;");
				

				//ResultSet result = stmt.executeQuery("select t.ticketID TicketID, t.totalFare TotalFare from tickets t, buys b where b.ticketID = t.ticketID AND EXTRACT(month FROM b.purchaseDate) = " + month + " group by t.ticketID;");

				//stmt.executeUpdate("INSERT INTO credentials(username, password) VALUES('" + username + "', '" + password + "');");
				//ResultSet result = stmt.executeQuery("SELECT password FROM credentials WHERE username = '" + username + "'");
				
				//out.println("Success");
				
		/* 	} catch (Exception e) {
				out.print(e);
			} */
				
				%>
				
				
				
				
				Total Revenue Of Cancellation Fees
				<br>
				<small>If the table is empty, there were no cancelled tickets for this month</small>
				<table border ='1'>
					<tr>
						<td>Month</td>
						<td>Total Revenue For The Month Of Cancel Fees</td>
					</tr>
					
					<%
					while(result.next()) { %>
						<tr>
							<td><%= result.getString("Month") %></td>
							<td><%= result.getString("CancelFeeRev") %></td>
						
						
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
				
				String month = request.getParameter("MonthForReport");
				
				//Run the query against the database.
				//ResultSet result = stmt.executeQuery("SELECT password FROM " + loginType + "_logins WHERE username = '" + username + "';");
				//ResultSet result = stmt.executeQuery("select EXTRACT(month FROM t.purchaseDate) Month, count(ticketID) NumberOfTickets from tickets t where EXTRACT(month FROM t.purchaseDate) = " + month + " group by EXTRACT(month FROM t.purchaseDate)"); 
				//.ticketID TicketID, t.totalFare TotalFare from tickets t, buys where b.ticketID = t.ticketID AND EXTRACT(month FROM b.purchaseDate) = 12
				//		group by t.ticketID ")
				
				//ResultSet totalRes = stmt.executeQuery("select EXTRACT(month FROM b.purchaseDate) Month, sum(t.totalFare) TotalFareForMonth from tickets t, buys b where t.ticketID = b.ticketID and EXTRACT(month FROM b.purchaseDate) = " + month + " group by Month;");
				

				//ResultSet result = stmt.executeQuery("select t.ticketID TicketID, t.totalFare TotalFare from tickets t, buys b where b.ticketID = t.ticketID AND EXTRACT(month FROM b.purchaseDate) = " + month + " group by t.ticketID;");

//				ResultSet result = stmt.executeQuery("select t.ticketID TicketID, t.totalFare + c.cancelFeeTotal + b.bookingFee TotalRevenueForTicket  from tickets t, buys b, customer_logins c where b.ticketID = t.ticketID and c.username = b.username  AND EXTRACT(month FROM b.purchaseDate) = " + month + " group by t.ticketID;");

				ResultSet result = stmt.executeQuery("select t.ticketID TicketID, sum(t.totalFare) + sum(b.bookingFee) TotalRevenueForTicketWithoutCancelFee from tickets t, buys b where b.ticketID = t.ticketID AND isCancelled = 'n'  AND EXTRACT(month FROM b.purchaseDate) = " + month + " group by t.ticketID;");
				
				//stmt.executeUpdate("INSERT INTO credentials(username, password) VALUES('" + username + "', '" + password + "');");
				//ResultSet result = stmt.executeQuery("SELECT password FROM credentials WHERE username = '" + username + "'");
				
				//out.println("Success");
				
		/* 	} catch (Exception e) {
				out.print(e);
			} */
				
				%>
				
				
				
				
				Total Revenue Without Cancellation Fee For Each Ticket
				<table border ='1'>
					<tr>
						<td>Ticket ID</td>
						<td>Total Revenue For Each Ticket Without Cancel Fees</td>
					</tr>
					
					<%
					while(result.next()) { %>
						<tr>
							<td><%= result.getString("TicketID") %></td>
							<td><%= result.getString("TotalRevenueForTicketWithoutCancelFee") %></td>
						
						
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
				
				String month = request.getParameter("MonthForReport");
				
				//Run the query against the database.
				//ResultSet result = stmt.executeQuery("SELECT password FROM " + loginType + "_logins WHERE username = '" + username + "';");
			
				//ResultSet result = stmt.executeQuery("select EXTRACT(month FROM b.purchaseDate) Month, sum(t.cancelFee) CancelFeeRev from tickets t, buys b where t.ticketID = b.ticketID and isCancelled = 'y' and EXTRACT(month FROM b.purchaseDate) = " + month + " group by Month;");
				
				
				ResultSet result = stmt.executeQuery("select t.ticketID TicketID, sum(t.cancelFee) TotalCancelRevPerTicket from tickets t, buys b where b.ticketID = t.ticketID AND isCancelled = 'y'  AND EXTRACT(month FROM b.purchaseDate) = " + month + " group by t.ticketID;");
				
				%>
				
				
				
				
				Total Revenue Of Cancellation Fees Per Ticket
				<br>
				<small>If the table is empty, there were no cancelled tickets for this month</small>
				<table border ='1'>
					<tr>
						<td>Ticket ID</td>
						<td>Total Revenue Per Ticket Of Cancel Fees</td>
					</tr>
					
					<%
					while(result.next()) { %>
						<tr>
							<td><%= result.getString("TicketID") %></td>
							<td><%= result.getString("TotalCancelRevPerTicket") %></td>
						
						
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
			
				
				
				