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
	    <h3>
	    Arriving Flights:
	        <%
	            try {
	                //Get the database connection
	                ApplicationDB db = new ApplicationDB();
	                Connection con = db.getConnection();
	
	                Statement stmt = con.createStatement();
	                String airportID = request.getParameter("AirportIDForFlights");
	                
	                ResultSet results = stmt.executeQuery("select art.airportID, art.flightNum, art.arrivalTime from arrives_at art where art.airportID = \"" + airportID + "\"");
					if(!results.next()) out.println("No data found!");
					else{
		    %>
		                <table border ='1'>
		                <tr><th>Airport ID</th><th>Flight Number</th><th>Arrival Time</th></tr>	                    
		                <%do{%>
		                
		                	<tr><td><%= results.getString(1) %></td><td><%= results.getString(2) %></td><td><%= results.getString(3) %></td></tr><%
		                
		                }while(results.next());%>
		 
		                </table> <%
	
					}
				}catch (Exception e) {
	                    out.print(e);
				}%>
		</h3>
		<h3>
		Departing Flights:
			<%try {
	                //Get the database connection
	                ApplicationDB db = new ApplicationDB();
	                Connection con = db.getConnection();
	
	                Statement stmt = con.createStatement();
	                String airportID = request.getParameter("AirportIDForFlights");
	                
	                ResultSet results = stmt.executeQuery("select df.airportID, df.flightNum, df.departTime from departs_from df where df.airportID = \"" + airportID + "\"");
					if(!results.next()) out.println("No data found!");
	                else{%>
	                
	                <table border ='1'>
	                <tr><th>Airport ID</th><th>Flight Number</th><th>Departure Time</th></tr>	 
	                <%do{%>
	                
	                	<tr><td><%= results.getString(1) %></td><td><%= results.getString(2) %></td><td><%= results.getString(3) %></td></tr><%
	                
	                }while(results.next());%>
	 
	                </table> <%
	
	                
	                }
					}catch (Exception e) {
	                    out.print(e);
					}%>
		<form action="./airportFlights.jsp">
		<input type="submit" value="Return to Dashboard">
		</form>
		</h3>
	</body>
</html>

                
                
                