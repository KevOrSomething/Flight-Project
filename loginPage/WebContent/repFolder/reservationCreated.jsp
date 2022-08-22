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
				Statement stmt2 = con.createStatement();
				
				
				String departDate = request.getParameter("departDate");
				
				String departTime = request.getParameter("departTime");
				String arrivalDate = request.getParameter("arrivalDate");
				String totalFare = request.getParameter("totalFare");
				String ticketClass = request.getParameter("ticketClass");
				String username = request.getParameter("username");
				String airlineID = request.getParameter("airlineID");
				String flightNum = request.getParameter("flightNum");
				
				double bookingFee = Float.parseFloat(totalFare) * 0.15;
				
				System.out.println("flag0");
				stmt2.executeUpdate("SET FOREIGN_KEY_CHECKS=0");
				if(!results.next()){
					int ticketID = 1;
					int seatNum = 1;
					System.out.println("flag1");
					stmt.executeUpdate("INSERT INTO tickets VALUES(" + ticketID + ", \"" + departDate + "\", \"" + departTime + "\", " + totalFare + ", \"" + ticketClass + "\")");
					stmt.executeUpdate("INSERT INTO buys VALUES(\"" + username + "\", " + ticketID + ", \"" + java.time.LocalDate.now() + "\", \"" + java.time.LocalTime.now().toString().substring(0, 8) + "\"," + bookingFee + ")");
					stmt.executeUpdate("INSERT INTO includes VALUES (" + ticketID + ", \"" + airlineID + "\", \"" + flightNum + "\", " + seatNum + ")");
					
				}
				else{
					System.out.println("flag2");
					results.last();
					
					int ticketID = results.getInt("ticketID") + 1;
					ResultSet seatNumSet = stmt.executeQuery("SELECT seatNum FROM includes");
					seatNumSet.last();
					
					int seatNum = seatNumSet.getInt("seatNum") + 1;
					System.out.println("flag3");
					stmt.executeUpdate("INSERT INTO tickets VALUES(" + ticketID + ", \"" + departDate + "\", \"" + departTime + "\", " + totalFare + ", \"" + ticketClass + "\", \"n\", 0)");	
					System.out.println("flag4");
					stmt.executeUpdate("INSERT INTO buys VALUES(\"" + username + "\", " + ticketID + ", \"" + java.time.LocalDate.now() + "\", \"" + java.time.LocalTime.now().toString().substring(0, 8) + "\"," + bookingFee + ")");
					System.out.println("flag5");
					stmt.executeUpdate("INSERT INTO includes VALUES (" + ticketID + ", \"" + airlineID + "\", \"" + flightNum + "\", \"" + departDate + "\", \"" + arrivalDate + "\", " + seatNum + ")");
					System.out.println("flag6");
				}
				
			
				stmt2.executeUpdate("SET FOREIGN_KEY_CHECKS=1");
			}catch (Exception e) {
				out.print(e);
			}%>
			Successfully made ticket reservation!
			<form action="userFlightActions.jsp">
			<input type="submit" value="Return to Flight Actions">
			</form>
		</h3>
</body>
</html>