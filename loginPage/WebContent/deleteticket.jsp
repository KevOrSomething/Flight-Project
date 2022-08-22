<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Cancel Ticket</title>
	</head>
	<body>
		<%
		try {
			
			if (session.getAttribute("user") == null) {
				response.sendRedirect("login.jsp");
			}
			
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			int cancelledTicket = Integer.parseInt(request.getParameter("ticketID"));
			
			String cancelQuery = "UPDATE tickets SET isCancelled = 'y' WHERE ticketID = ?";
			PreparedStatement cancelPS = con.prepareStatement(cancelQuery);
			cancelPS.setInt(1, cancelledTicket);
			cancelPS.executeUpdate();
			
			out.print("Ticket successfully deleted.");
			
			//This segment checks if a given flight has available seats, and if so,
			//Notifies those on the waitlist for these flights that a seat has opened
			String seatRefresh = "SELECT airlineID, flightNum, departDate, numOfSeats, numPeople " +
					"FROM " +

					"(SELECT * FROM flights " + 
					"JOIN uses USING (flightNum, airlineID) " +
					"JOIN aircraft USING (aircraftID)) seatNums " + 


					"JOIN (SELECT airlineID, flightNum, departDate, count(*) as numPeople " +
					"FROM " +
					"(SELECT i.airlineID, i.flightNum, i.departDate " + 
					"FROM includes i, tickets t " + 
					"WHERE i.ticketID = t.ticketID " +
					"AND isCancelled = 'n') temp " + 
					"GROUP BY airlineID, flightNum, departDate) peopleNum " +

					"USING (airlineID, flightNum)";
			PreparedStatement seatRefreshPS = con.prepareStatement(seatRefresh);
			ResultSet seatRefreshSet = seatRefreshPS.executeQuery();
			
			//For every seat/people ratio...if a seat is less than num of seats
			//change alert to all the people who are on the waitlist for that flight
			while (seatRefreshSet.next()) {
				if (seatRefreshSet.getInt("numOfSeats") > seatRefreshSet.getInt("numPeople")) {
					
					LocalDate currDate = LocalDate.now();
					LocalTime currTime = LocalTime.now();
					
					String newAlert = "<b>**ALERT**</b> On " + currDate + " at " + currTime + ", the following flight was seen as available: " +
					seatRefreshSet.getString("airlineID") + seatRefreshSet.getString("flightNum") + 
					" (Departing on " + seatRefreshSet.getString("departDate") + ")";
					
					
					String updateAlert = "UPDATE in_waitlist_of " +
							"SET alert = ? " +
							"WHERE airlineID = ? AND flightNum = ? AND departDate = ?";
					
					PreparedStatement updateAlertPS = con.prepareStatement(updateAlert);
					updateAlertPS.setString(1, newAlert);
					updateAlertPS.setString(2, seatRefreshSet.getString("airlineID"));
					updateAlertPS.setString(3, seatRefreshSet.getString("flightNum"));
					updateAlertPS.setDate(4, seatRefreshSet.getDate("departDate"));
					
					updateAlertPS.executeUpdate();
				}
			}
			
			con.close();
			
		} catch (Exception e) {
			
			out.print(e);
			
		} finally {
			%>
			<form action="viewtickets.jsp">
			<input type="submit" value="Return to Tickets">
			</form>
			<%
		}
		%>
		
		
	</body>
</html>