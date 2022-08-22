<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.util.Date, java.text.SimpleDateFormat, java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	
	<h3>
			<%
			try{
				//Get the database connection
				ApplicationDB db = new ApplicationDB();
				Connection con = db.getConnection();
		
				//Create a SQL statement
				Statement stmt = con.createStatement();
				ResultSet results = stmt.executeQuery("SELECT ticketID FROM tickets");
				
				String ticketID = request.getParameter("ticketID");
				String totalFare = request.getParameter("totalFare");
				String ticketClass = request.getParameter("ticketClass");
				String flightNum = request.getParameter("flightNum");
				String seatNum = request.getParameter("seatNum");
				
				stmt.executeUpdate("UPDATE tickets SET totalFare=" + totalFare + ", ticketClass=\"" + ticketClass + "\" WHERE ticketID=" + ticketID);
				stmt.executeUpdate("UPDATE includes SET seatNum=" + seatNum + " WHERE ticketID=" + ticketID + " and flightNum=" + flightNum);
				
			}catch (Exception e) {
				out.print(e);
			}%>
			Successfully edited ticket reservation!
			<form action="userFlightActions.jsp">
			<input type="submit" value="Return to Flight Actions">
			</form>
			
		</h3>

</body>
</html>