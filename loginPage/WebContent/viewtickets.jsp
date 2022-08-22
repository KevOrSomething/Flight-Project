<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>View Tickets</title>
	</head>
	<body>
		
		<%
		if (session.getAttribute("user") == null) {
				response.sendRedirect("login.jsp");
			}
		
		//Resets ticketRange string to all 
		String ticketRange = request.getParameter("ticketRange");
		if (ticketRange == null || ticketRange == "Default") ticketRange = "All";
		
		%>
		
		
		<form action="customerhome.jsp" method="post">
		    <input type="submit" value="Back to Home">
		</form>
		<br>
			
	
		<form method="post" action="checkticket.jsp">
			<table>
				<tr>
					<td>Cancel a Ticket:</td>
				</tr>
				<tr>    
					<td><input type="text" name="cancelTicket" placeholder="Ticket Number/ID"></td>
				</tr>
			</table>
			<input type="submit" value="Cancel Ticket">
		</form>
		<br>
		
		<form method="post" action="viewtickets.jsp">
			<select name="ticketRange" size=1>
				<option value="Default">Select an Option</option>
				<option value="All">All Tickets</option>
				<option value="Past">Past Tickets</option>
				<option value="Upcoming">Upcoming Tickets</option>
			</select>&nbsp;<br>
			<input type="submit" value="Refresh">
		</form>
		<br>
	
		<%
		
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		try {
			String user = (String)session.getAttribute("user");

			String ticketsQuery = "SELECT * " +
					"FROM (SELECT * FROM buys WHERE username = ?) b " +
					"JOIN tickets t USING (ticketID) WHERE isCancelled = 'n'";
			PreparedStatement getTicketsPS;
			
			//Changes query and title depending on selection
			if (ticketRange == null || ticketRange.equals("All")) {
				%>
				<h1><b>All Tickets</b></h1>
				<%
				getTicketsPS = con.prepareStatement(ticketsQuery);
			} else if (ticketRange.equals("Past")) {
				%>
				<h1><b>Past Tickets (Tickets departed before today)</b></h1>
				<%
				String beforeString = " AND departDate < curdate()";
				getTicketsPS = con.prepareStatement(ticketsQuery + beforeString);
			} else {
				%>
				<h1><b>Upcoming Tickets (Tickets departing after or during today)</b></h1>
				<%
				String beforeString = " AND departDate >= curdate()";
				getTicketsPS = con.prepareStatement(ticketsQuery + beforeString);
			}
				
			getTicketsPS.setString(1, user);
			ResultSet ticketSet = getTicketsPS.executeQuery();
			
			while(ticketSet.next()) {
				
				int ticketID = ticketSet.getInt("ticketID");
				
				//Query for all info on current ticket
				String ticketInfoQuery = "SELECT * FROM tickets WHERE ticketID = " + ticketID;
				PreparedStatement ticketInfoPS = con.prepareStatement(ticketInfoQuery);
				ResultSet ticketInfoSet = ticketInfoPS.executeQuery();
				ticketInfoSet.next();
				
				//Conversion between class lettering to actual name
				String classLetter = ticketInfoSet.getString("ticketClass");
				String className;
				if (classLetter.equals("b")) className = "Business";
				else if (classLetter.equals("f")) className = "First Class";
				else className = "Economy";
				
				//Query for all info on "buys"
				String buysInfoQuery = "SELECT * FROM buys WHERE ticketID = " + ticketID;
				PreparedStatement buysInfoPS = con.prepareStatement(buysInfoQuery);
				ResultSet buysInfoSet = buysInfoPS.executeQuery();
				buysInfoSet.next();
				
				
				//Note: this doesn't actually work...
				/*
				//Query to get starting airport
				String earliestAirportQuery = "SELECT min(departDate), min(departTime), airportID " +
						"FROM (SELECT * FROM includes WHERE ticketID = ?) i " + 
						"JOIN flights f USING (airlineID, flightNum) " + 
						"JOIN departs_from d USING (airlineID, flightNum)";
				PreparedStatement earliestAirportPS = con.prepareStatement(earliestAirportQuery);
				earliestAirportPS.setInt(1, ticketID);
				ResultSet earliestAirportSet = earliestAirportPS.executeQuery();
				earliestAirportSet.next();
				String earliestAirport = earliestAirportSet.getString("airportID");

				*/
				
				//Prints ticket information
				out.print("<h2><b>Ticket " + ticketID + "</b></h2>");
				out.print(String.format("Total Fare: $%f, Booking Fee: $%f (%s)<br>", 
						ticketInfoSet.getFloat("totalFare"), buysInfoSet.getFloat("bookingFee"), className));
				out.print("Purchased on " + buysInfoSet.getDate("purchaseDate") +
						" at " + buysInfoSet.getTime("purchaseTime") + "<br>");
				out.print("Departed/Departing on " + ticketInfoSet.getDate("departDate") +
						" at " + ticketInfoSet.getTime("departTime") + "<br>");
				
				//Query for each flight in order of departing date/time
				
				String flightQuery = "SELECT * FROM includes " +
						"JOIN (SELECT airlineID, flightNum, departTime FROM departs_from) timeTable USING (airlineID, flightNum) " +
						"WHERE ticketId = " + ticketID +
						" ORDER BY departDate ASC, departTime ASC";
				
				PreparedStatement flightPS = con.prepareStatement(flightQuery);
				ResultSet flightSet = flightPS.executeQuery();
				
				%>
				
				<br>
				<table border='1'>
					<tr>
						<td><b>Flight Number</b></td>
						<td><b>Airline</b></td>
						<td><b>Type</b></td>
						<td><b>Price</b></td>
						<td><b>Departs From</b></td>
						<td><b>Depart Time</b></td>
						<td><b>Arrives At</b></td>
						<td><b>Arrival Time</b></td>
						<td><b>Seat Number</b></td>
					</tr>
				
				
				
				<%
				while(flightSet.next()) {
					int flightNum = flightSet.getInt("flightNum");
					String airlineID = flightSet.getString("airlineID");
					
					//Query for the info of each flight
					String flightInfoQuery = "SELECT * FROM flights WHERE flightNum = ? AND airlineID = ?";
					PreparedStatement flightInfoPS = con.prepareStatement(flightInfoQuery);
					flightInfoPS.setInt(1, flightNum);
					flightInfoPS.setString(2, airlineID);
					ResultSet flightInfoSet = flightInfoPS.executeQuery();
					flightInfoSet.next();
					
					//Querey for each flight's dates
					String dateQuery = "SELECT * FROM includes WHERE ticketID = " + ticketID + " AND flightNum = ? AND airlineID = ?";
					PreparedStatement datePS = con.prepareStatement(dateQuery);
					datePS.setInt(1, flightNum);
					datePS.setString(2, airlineID);
					ResultSet dateSet = datePS.executeQuery();
					dateSet.next();
					
					//Query for info of each flight's departing (location and time)
					String departInfoQuery = "SELECT * FROM departs_from WHERE flightNum = ? AND airlineID = ?";
					PreparedStatement departInfoPS = con.prepareStatement(departInfoQuery);
					departInfoPS.setInt(1, flightNum);
					departInfoPS.setString(2, airlineID);
					ResultSet departInfoSet = departInfoPS.executeQuery();
					departInfoSet.next();
					
					//Query for info of each flight's arrival
					String arriveInfoQuery = "SELECT * FROM arrives_at WHERE flightNum = ? AND airlineID = ?";
					PreparedStatement arriveInfoPS = con.prepareStatement(arriveInfoQuery);
					arriveInfoPS.setInt(1, flightNum);
					arriveInfoPS.setString(2, airlineID);
					ResultSet arriveInfoSet = arriveInfoPS.executeQuery();
					arriveInfoSet.next();
					
					
					String typeString;
					if (flightInfoSet.getString("flightType").equals("d")) typeString = "Domestic";
					else typeString = "International";
					
					%>
					<tr>
						<td><%=flightNum%></td>
						<td><%=airlineID%></td>
						<td><%=typeString%></td>
						<td><%=flightInfoSet.getFloat("price")%></td>
						<td><%=departInfoSet.getString("airportID")%></td>
						<td><%=dateSet.getDate("departDate") + " at " + departInfoSet.getTime("departTime")%></td>
						<td><%=arriveInfoSet.getString("airportID")%></td>
						<td><%=dateSet.getDate("arrivalDate") + " at " + arriveInfoSet.getTime("arrivalTime")%></td>
						<td><%=dateSet.getInt("seatNum")%></td>
					</tr>
					
					<%
					
				}
				%>
				</table>
				<%
			}
			
		} catch (Exception e){
			out.print(e);
		} finally {
			con.close();
		}
		
		 %>
	</body>
</html>