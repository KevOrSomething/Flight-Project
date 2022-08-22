<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Add Flight</title>
</head>
<body>
<h3>

	<%
		try {
	                //Get the database connection
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
	
			Statement stmt = con.createStatement();
			String flightNum = request.getParameter("flightNum");
			String airlineID = request.getParameter("airlineID");
			String price = request.getParameter("price");
			String flightType = request.getParameter("flightType");
			
			String arrivingAirportID = request.getParameter("arrivingAirportID");   
			String arrivalTime = request.getParameter("arrivalTime");
			String arrivalDate = request.getParameter("arrivalDate");
			
			String departingAirportID = request.getParameter("departingAirportID");   
			String departTime = request.getParameter("departTime");
			String departDate = request.getParameter("departDate");
			  
			
			stmt.executeUpdate("INSERT INTO flights VALUES (" + flightNum + ", \"" + airlineID + "\", " + price + ", \"" + flightType + "\");");
			stmt.executeUpdate("INSERT INTO arrives_at VALUES (" + flightNum + ", \"" + airlineID + "\", \"" + arrivingAirportID + "\", \"" + arrivalTime + "\", \"" + arrivalDate + "\")");
			stmt.executeUpdate("INSERT INTO departs_from VALUES (" + flightNum + ", \"" + airlineID + "\", \"" + departingAirportID + "\", \"" + departTime + "\", \"" + departDate + "\")");
			
		}catch (Exception e) {
            out.print(e);
		}
	
	%>
	Successfully added flight!
	<form action="../editFlightInformation.jsp">
	<input type="submit" value="Return to Flight Information">
	</form>
</h3>
</body>
</html>