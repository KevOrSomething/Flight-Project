<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Add Arriving Flight</title>
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
			String arrivalTime = request.getParameter("arrivalTime");
			String arrivalDate = request.getParameter("arrivalDate");
			String airportID = request.getParameter("airportID");     
			
			stmt.executeUpdate("INSERT INTO flights VALUES (" + flightNum + ", \"" + airlineID + "\", " + price + ", \"" + flightType + "\");");
			stmt.executeUpdate("INSERT INTO arrives_at VALUES (" + flightNum + ", \"" + airlineID + "\", \"" + airportID + "\", \"" + arrivalTime + "\", \"" + arrivalDate + "\")");
			
			
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