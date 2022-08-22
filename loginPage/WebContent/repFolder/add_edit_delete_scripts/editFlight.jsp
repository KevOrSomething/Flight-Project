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
	<%
		try {
			
			/*
			<input type="text" name="flightNum" placeholder="Flight Number"/><br>
				<input type="text" name="currentTime" placeholder="Current Time"/><br>
				<input type="text" name="currentDate" placeholder="Current Date"/><br>
				<input type="text" name="airlineID" placeholder="Airline ID"/><br>	
				<input type="number" step="0.01" name="price" placeholder="Price"/><br>
				<input type="text" name="flightType" placeholder="Flight Type"/><br>
				<input type="text" name="airportID" placeholder="Airport ID"/><br>
				<input type="text" name="boundStatus" placeholder="Arriving or Departing"/><br>
				<input type="text" name="newTime" placeholder="New Time"/><br>
				<input type="text" name="newDate" placeholder="New Date"/><br>*/
	                //Get the database connection
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
	
			Statement stmt = con.createStatement();
			String flightNum = request.getParameter("flightNum");
			String currentTime = request.getParameter("currentTime");
			String currentDate = request.getParameter("currentDate");
			String airlineID = request.getParameter("airlineID");
			String price = request.getParameter("price");
			String flightType = request.getParameter("flightType");
			String airportID = request.getParameter("airportID");  
			String boundStatus = request.getParameter("boundStatus");  
			String newTime = request.getParameter("newTime");
			String newDate = request.getParameter("newDate");
			
	                
			//stmt.executeUpdate("DELETE FROM tickets WHERE ticketID=" + ticketID);
			
			ResultSet results = stmt.executeQuery("select * from flights where flightNum=" + flightNum);
			
			if(!results.next()) out.println("Flight not found!");
			
			stmt.executeUpdate("UPDATE uses SET airlineID=\"" + airlineID + "\" WHERE flightNum=" + flightNum);
			stmt.executeUpdate("UPDATE flights SET airlineID=\"" + airlineID + "\", price=" + price + ", flightType=\"" + flightType + "\" WHERE flightNum=" + flightNum);
			stmt.executeUpdate("SET FOREIGN_KEY_CHECKS=0");
			if(boundStatus.toLowerCase().equals("arriving")){
				stmt.executeUpdate("UPDATE arrives_at SET airportID=\"" + airportID + "\", airlineID=\"" + airlineID + "\", arrivalDate=\"" + newDate + "\", arrivalTime=\"" + newTime + "\" WHERE flightNum=" + flightNum + " and arrivalDate=\"" + currentDate + "\" and arrivalTime=\"" + currentTime + "\"");
				stmt.executeUpdate("UPDATE includes SET airlineID=\"" + airlineID + "\", arrivalDate=\"" + newDate + "\" WHERE flightNum=" + flightNum + " and arrivalDate=\"" + currentDate + "\"");
				
			}else if(boundStatus.toLowerCase().equals("departing")){
				stmt.executeUpdate("UPDATE departs_from SET airportID=\"" + airportID + "\", airlineID=\"" + airlineID + "\", departDate=\"" + newDate + "\", departTime=\"" + newTime + "\" WHERE flightNum=" + flightNum + " and departDate=\"" + currentDate + "\" and departTime=\"" + currentTime + "\"");
				stmt.executeUpdate("UPDATE includes SET airlineID=\"" + airlineID + "\", departDate=\"" + newDate + "\" WHERE flightNum=" + flightNum + " and departDate=\"" + currentDate + "\"");
				stmt.executeUpdate("UPDATE tickets SET departDate=\"" + newDate + "\", departTime=\"" + newTime + "\" WHERE departDate=\"" + currentDate + "\" and departTime=\"" + currentTime + "\"");
			}
			stmt.executeUpdate("SET FOREIGN_KEY_CHECKS=1");
			
			
			
			
			
			
		}catch (Exception e) {
            out.print(e);
		}
	
	%>
	Successfully edited flight!
	<form action="../editFlightInformation.jsp">
	<input type="submit" value="Return to Flight Information">
	</form>
</h3>
</body>
</html>