<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.util.Date, java.text.SimpleDateFormat, java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Get Waitlist of Flights</title>
</head>
	<body>

		<h3>	
			<%
			try{
				//Get the database connection
				String flightNum = request.getParameter("flightNumber");
				String airlineID = request.getParameter("airlineID");
				String departDate = request.getParameter("departDate");
				
				ApplicationDB db = new ApplicationDB();
				Connection con = db.getConnection();
		
				//Create a SQL statement
				Statement stmt = con.createStatement();
				ResultSet results = stmt.executeQuery("select firstname, lastname, flightnum, alert from in_waitlist_of inner join customer_logins on in_waitlist_of.username = customer_logins.username where flightnum = " + flightNum + " and airlineID=\"" + airlineID + "\" and departDate=\"" + departDate + "\"");
				
				
				if(!results.next()) out.println("No data found!");
				else{
					
					%>
					<table border ='1'>
	                <tr><th>First Name</th><th>Last Name</th><th>Flight Number</th><th>Alert</th></tr>	                    
	                <%do{%>
	                
	                	<tr><td><%= results.getString(1) %></td><td><%= results.getString(2) %></td><td><%= results.getString(3) %></td><td><%= results.getString(4) %></td></tr><%
	                
	                }while(results.next());
				
				}
				
			}catch (Exception e) {
				out.print(e);
			}%>
		</h3>
		
		<form action="./waitlistHome.jsp">
		<input type="submit" value="Return to Dashboard">
		</form>

	</body>
</html>