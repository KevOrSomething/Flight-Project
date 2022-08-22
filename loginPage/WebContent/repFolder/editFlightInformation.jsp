<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<h3>	
	Arriving Flights
		<%
		try{
			//Get the database connection
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
	
			//Create a SQL statement
			Statement stmt = con.createStatement();
			ResultSet results = stmt.executeQuery("select flights.flightNum, flights.airlineID, flights.price, flights.flightType, arrives_at.airportID, arrives_at.arrivalTime, arrives_at.arrivalDate from flights join arrives_at ON flights.flightNum = arrives_at.flightNum");
			if(!results.next()){
				out.println("Empty set");
			}
			else{
			%>
				<table border='1'>
				<tr><th>Flight Number</th><th>Airline ID</th><th>Price</th><th>Flight Type</th><th>Airport</th><th>Arrival Time</th><th>Arrival Date</th></tr> <%
				do{%>
					<tr><td><%= results.getString(1) %></td><td><%= results.getString(2) %></td><td><%= results.getString(3) %></td><td><%= results.getString(4) %></td><td><%= results.getString(5) %></td><td><%= results.getString(6) %></td><td><%= results.getString(7) %></td></tr><%
					
					
				}while(results.next());%>
				</table> <%
			}
			
		}catch (Exception e) {
			out.print(e);
		}
		%>
		Departing Flights
		<%
		try{
			//Get the database connection
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
	
			//Create a SQL statement
			Statement stmt = con.createStatement();
			ResultSet results = stmt.executeQuery("select flights.flightNum, flights.airlineID, flights.price, flights.flightType, departs_from.airportID, departs_from.departTime, departs_from.departDate from flights join departs_from ON flights.flightNum = departs_from.flightNum");
			if(!results.next()){
				out.println("Empty set");
			}
			else{
			%>
				<table border='1'>
				<tr><th>Flight Number</th><th>Airline ID</th><th>Price</th><th>Flight Type</th><th>Airport</th><th>Departure Time</th><th>Departure Date</th></tr> <%
				do{%>
					<tr><td><%= results.getString(1) %></td><td><%= results.getString(2) %></td><td><%= results.getString(3) %></td><td><%= results.getString(4) %></td><td><%= results.getString(5) %></td><td><%= results.getString(6) %></td><td><%= results.getString(7) %></td></tr><%
					
					
				}while(results.next());%>
				</table> <%
			}
			
		}catch (Exception e) {
			out.print(e);
		}
		%>

		<div class="form-container">
	        <b>Add Flight Information:</b>
	        <br/>
	        <small>Input the flight number, airline ID, price, flight type, arrival time, and arrival date.</small>
	        <form action="./add_edit_delete_scripts/addFlight.jsp" method="post">
				<input type="text" name="flightNum" placeholder="Flight Number"/><br>
				<input type="text" name="airlineID" placeholder="Airline ID"/><br>
				<input type="number" step="0.01" name="price" placeholder="Price"/><br>
				<input type="text" name="flightType" placeholder="Flight Type"/><br>
				<input type="text" name="arrivingAirportID" placeholder="Arriving Airport ID"/><br>
				<input type="text" name="arrivalTime" placeholder="Arrival Time"/><br>
				<input type="text" name="arrivalDate" placeholder="Arrival Date"/><br>
				<input type="text" name="departingAirportID" placeholder="Departing Airport ID"/><br>
				<input type="text" name="departTime" placeholder="Departure Time"/><br>
				<input type="text" name="departDate" placeholder="Departure Date"/><br>
				<input type="submit" value="Submit"/>
        	</form>
	    </div>

	    
	    <div class="form-container">
	        <b>Edit Flight Information:</b>
	        <br/>
	        <small>Input the flight number, airline ID, price, flight type, new time, and new date.</small>
	        <form action="./add_edit_delete_scripts/editFlight.jsp" method="post">
				<input type="text" name="flightNum" placeholder="Flight Number"/><br>
				<input type="text" name="currentTime" placeholder="Current Time"/><br>
				<input type="text" name="currentDate" placeholder="Current Date"/><br>
				<input type="text" name="airlineID" placeholder="Airline ID"/><br>	
				<input type="number" step="0.01" name="price" placeholder="Price"/><br>
				<input type="text" name="flightType" placeholder="Flight Type"/><br>
				<input type="text" name="airportID" placeholder="Airport ID"/><br>
				<input type="text" name="boundStatus" placeholder="Arriving or Departing"/><br>
				<input type="text" name="newTime" placeholder="New Time"/><br>
				<input type="text" name="newDate" placeholder="New Date"/><br>
				<input type="submit" value="Submit"/>
        	</form>
	    </div>
	    
	    <div class="form-container">
	        <b>Delete Flight Information:</b>
	        <br/>
	        <small>Input the flight number you wish to delete.</small>
	        <form action="./add_edit_delete_scripts/deleteFlight.jsp" method="post">
				<input type="text" name="flightNum" placeholder="Flight Number"/><br>
				<input type="text" name="arrivalDate" placeholder="Arrival Date"/><br>
				<input type="text" name="arrivalTime" placeholder="Arrival Time"/><br>
				
				<input type="text" name="departDate" placeholder="Depart Date"/><br>
				<input type="text" name="departTime" placeholder="Depart Time"/><br>
				<input type="submit" value="Submit"/>
        	</form>
		
	    </div>
	
	<form action="../rephome.jsp">
	<input type="submit" value="Return to Dashboard">
	</form>
	
	</h3>
</body>
</html>