<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="stylesheet.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Reservations</title>
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
				
				String flightNum = request.getParameter("FlightNumForRes");
				
				//String airlineID = request.getParameter("airlineIDForRes");
				
				//Run the query against the database.
				//ResultSet result = stmt.executeQuery("SELECT password FROM " + loginType + "_logins WHERE username = '" + username + "';");
				//ResultSet result = stmt.executeQuery("select EXTRACT(month FROM t.purchaseDate) Month, count(ticketID) NumberOfTickets from tickets t where EXTRACT(month FROM t.purchaseDate) = " + month + " group by EXTRACT(month FROM t.purchaseDate)"); 
				//.ticketID TicketID, t.totalFare TotalFare from tickets t, buys where b.ticketID = t.ticketID AND EXTRACT(month FROM b.purchaseDate) = 12
				//		group by t.ticketID ")
				
				//ResultSet result = stmt.executeQuery("select t.ticketID TicketID, t.departDate DepartDate, t.departTime DepartTime, t.totalFare TotalFare, t.ticketClass TicketClass from tickets t, includes i, flights f where f.flightNum = i.flightNum and i.ticketID = t.ticketID and f.flightNum = " + flightNum + " and i.airlineID ='" + airlineID + "';");
				
				//ResultSet result = stmt.executeQuery("select t.ticketID TicketID, t.departDate DepartDate, t.departTime DepartTime, t.totalFare TotalFare, t.ticketClass TicketClass from tickets t, includes i, flights f where f.flightNum = i.flightNum and i.ticketID = t.ticketID and f.flightNum = " + flightNum + ";");
				
				ResultSet result = stmt.executeQuery("select t.ticketID TicketID, t.departDate DepartDate, t.departTime DepartTime, t.totalFare TotalFare, t.ticketClass TicketClass, i.airlineID airlineID from includes i, tickets t where t.ticketID = i.ticketID and i.flightNum = " + flightNum +";");
				


			//	ResultSet result = stmt.executeQuery("select t.ticketID TicketID, t.totalFare TotalFare from tickets t, buys b where b.ticketID = t.ticketID AND EXTRACT(month FROM b.purchaseDate) = " + month + " group by t.ticketID;");

				//stmt.executeUpdate("INSERT INTO credentials(username, password) VALUES('" + username + "', '" + password + "');");
				//ResultSet result = stmt.executeQuery("SELECT password FROM credentials WHERE username = '" + username + "'");
				
				//out.println("Success");
				
		/* 	} catch (Exception e) {
				out.print(e);
			} */
				
				%>
				
				<table border ='1'>
					<tr>
						<td>Ticket ID</td>
						<td>Depart Date</td>
						<td>Depart Time</td>
						<td>Total Fare</td>
						<td>Ticket Class</td>	
						<td>Airline ID</td>		
					</tr>
					
					<%
					while(result.next()) { %>
						<tr>
							<td><%= result.getString("TicketID") %></td>
							<td><%= result.getString("DepartDate") %></td>
							<td><%= result.getString("DepartTime") %></td>
							<td><%= result.getString("TotalFare") %></td>
							<td><%= result.getString("TicketClass") %></td>
							<td><%= result.getString("airlineID") %></td>
						
						
						</tr>
					
					<% }
						db.closeConnection(con);
					%>
					
					
				</table>

				
				<%} catch (Exception e) {
					out.print(e);
				}%>
						<form action="../adminhome.jsp">
						<input type="submit" value="Return to Dashboard">
						</form>
			
					</body>
			</html>
				