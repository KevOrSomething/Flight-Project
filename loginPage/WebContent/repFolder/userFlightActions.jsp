<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
	<body>
		<h3>
		Here are the current tickets:
		<%
	            try {
	                //Get the database connection
	                ApplicationDB db = new ApplicationDB();
	                Connection con = db.getConnection();
	
	                Statement stmt = con.createStatement();
	                String airportID = request.getParameter("AirportIDForFlights");
	                
	                ResultSet results = stmt.executeQuery("select tickets.ticketID, tickets.departDate, tickets.departTime, includes.arrivalDate, tickets.totalFare, tickets.ticketClass, includes.seatNum, includes.flightNum, includes.airlineID from tickets join includes on includes.ticketID = tickets.ticketID");
	               
					if(!results.next()) out.println("No data found!");
					else{
		    %>
		                <table border ='1'>
		                <tr><th>Ticket ID</th><th>Departure Date</th><th>Departure Time</th><th>Arrival Date</th><th>Total Fare</th><th>Ticket Class</th><th>Seat Number</th><th>Flight Number</th><th>Airline</th></tr>	                    
		                <%do{%>
		                
		                <tr><td><%= results.getString(1) %></td>
		                	<td><%= results.getString(2) %></td>
		                	<td><%= results.getString(3) %></td>
		                	<td><%= results.getString(4) %></td>
		                	<td><%= results.getString(5) %></td>
		                <td><%= results.getString(6) %></td>
		                <td><%= results.getString(7) %></td>
		                <td><%= results.getString(8) %></td>
		                <td><%= results.getString(9) %></td></tr><%
		                
		                
		                }while(results.next());%>
		 
		                </table> <%
	
					}
				}catch (Exception e) {
	                    out.print(e);
				}%>
		<div class="form-container">
	        <b>Make a flight reservation for a user.</b>
	        <br/>
	        <small>Input the depart date, depart time, total fare, ticket class, customer's username, flight number, and airline ID:</small>
	        <form action="reservationCreated.jsp" method="post">
				<input type="text" name="departDate" placeholder="Departure Date"/><br>
				<input type="text" name="departTime" placeholder="Departure Time"/><br>
				<input type="text" name="arrivalDate" placeholder="Arrival Date"/><br>
				<input type="number" step="0.01" name="totalFare" placeholder="Total Fare"/><br>
				<input type="text" name="ticketClass" placeholder="Ticket Class"/><br>
				<input type="text" name="username" placeholder="Username"/><br>
				<input type="text" name="flightNum" placeholder="Flight Number"/><br>
				<input type="text" name="airlineID" placeholder="Airline ID"/><br>			
				<input type="submit" value="Submit"/>
        	</form>
        	
	    </div>
		
		</h3>
		<h3>
		<div class="form-container">
	        <b>Make edits for a user's flight reservation.</b>
	        <br/>
	        <small>Edit the new information for the specified ticket ID:</small>
	        <form action="editReservation.jsp" method="post">
	        	<input type="text" name="ticketID" placeholder="Ticket ID"/><br>
				<input type="number" step="0.01" name="totalFare" placeholder="Total Fare"/><br>
				<input type="text" name="ticketClass" placeholder="Ticket Class"/><br>
				<input type="text" name="flightNum" placeholder="Flight Number"/><br>
				<input type="text" name="seatNum" placeholder="Seat Number"/><br>
				<input type="submit" value="Submit"/>
        	</form>
        	
	    </div>
		</h3>
		<form action="../rephome.jsp">
		<input type="submit" value="Return to Dashboard">
		</form>
	</body>
</html>