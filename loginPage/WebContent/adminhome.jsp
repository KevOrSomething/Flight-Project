<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Admin Homepage</title>
	</head>
	<body>
			
		<%
		try {
			if (session.getAttribute("user") == null || !session.getAttribute("userType").equals("admin")) {
				response.sendRedirect("login.jsp");
			}
			
			out.println(session.getAttribute("welcomeMessage"));
			
			//PUT YOUR REDIRECT BUTTONS TO YOUR PAGES HERE
			//...
			
			%>
			
	<div class="form-container">
		<b>Add A Customer Representative</b>
		<br/>
		<small>Enter The Following Information For The Customer Representative</small>

		<form action="./AdminFolder/addCustomerRep.jsp" method="post">
						<input type="text" name="usernameForLogin" placeholder="Username"/><br>
						<input type="text" name="passwordForLogin" placeholder="Password"/><br>
						<input type="text" name="firstNameForLogin" placeholder="First Name"/><br>
						<input type="text" name="lastNameForLogin" placeholder="Last Name"/><br>
						
						<input type="submit" value="Submit"/>
		
		</form>
	</div>


	<div class="form-container">
		<b>Add A Customer</b>
		<br/>
		<small>Enter The Following Information For The Customer</small>

		<form action="./AdminFolder/addCustomerOnly.jsp" method="post">
						<input type="text" name="usernameForLogin" placeholder="Username"/><br>
						<input type="text" name="passwordForLogin" placeholder="Password"/><br>
						<input type="text" name="firstNameForLogin" placeholder="First Name"/><br>
						<input type="text" name="lastNameForLogin" placeholder="Last Name"/><br>
						
						<input type="submit" value="Submit"/>
		
		</form>
	</div>

	<div class="form-container">
		<b>Delete A Customer Representative</b>
		<br/>
		<small>Enter The Username For The Customer Representative You Want Deleted</small>

		<form action="./AdminFolder/deleteCustRep.jsp" method="post">
						<input type="text" name="usernameForLogin" placeholder="Username"/><br>
						<input type="submit" value="Submit"/>
		
		</form>
	</div>

	<div class="form-container">
		<b>Delete A Customer</b>
		<br/>
		<small>Enter The Username For The Customer You Want Deleted</small>

		<form action="./AdminFolder/deleteCustomer.jsp" method="post">
						<input type="text" name="usernameForLogin" placeholder="Username"/><br>
						<input type="submit" value="Submit"/>
		
		</form>
	</div>

	<div class="form-container">
		<b>Edit A Customer Representative</b>
		<br/>
		<small>Enter The Username For the Customer Representative Being Edited Along With The Rest of the Information</small>

		<form action="./AdminFolder/editCustRep.jsp" method="post">
						<input type="text" name="usernameForLogin" placeholder="Username"/><br>
						<input type="text" name="passwordForLogin" placeholder="Password"/><br>
						<input type="text" name="firstNameForLogin" placeholder="First Name"/><br>
						<input type="text" name="lastNameForLogin" placeholder="Last Name"/><br>
						
						<input type="submit" value="Submit"/>
		
		</form>
	</div>


	<div class="form-container">
		<b>Edit A Customer</b>
		<br/>
		<small>Enter The Username For the Customer Being Edited Along With The Rest of the Information</small>

		<form action="./AdminFolder/editCustomer.jsp" method="post">
						<input type="text" name="usernameForLogin" placeholder="Username"/><br>
						<input type="text" name="passwordForLogin" placeholder="Password"/><br>
						<input type="text" name="firstNameForLogin" placeholder="First Name"/><br>
						<input type="text" name="lastNameForLogin" placeholder="Last Name"/><br>
						
						<input type="submit" value="Submit"/>
		
		</form>
	</div>



	<div class="form-container">
		<b>Get A Sales Report</b>
		<br/>
		<small>Enter The Month You Desire</small>
		<small>01 = January, 02 = February, ..., 12 = December</small>

		<form action="./AdminFolder/salesReport.jsp" method="post">
				<!-- <p>Password:</p> --><input type="text" name="MonthForReport" placeholder="Month"/><br>
						<input type="submit" value="Submit"/>
		
		</form>
	</div>
	
	
	<div class="form-container">
		<b>Get A List of Reservations With A Flight Number</b>
		<br/>
		<small>Enter A Flight Number</small>
		<form action="./AdminFolder/flightNumReservations.jsp" method="post">
				<!-- <p>Password:</p> --><input type="text" name="FlightNumForRes" placeholder="Flight Number"/><br>
						<input type="submit" value="Submit"/>
		
		</form>
	</div>
	
	
	
	<div class="form-container">
		<b>Get A List of Reservations With A Customer Name</b>
		<br/>
		<small>Enter A Customer Name</small>
		<form action="./AdminFolder/customerNameReservations.jsp" method="post">
				<!-- <p>Password:</p> --><input type="text" name="firstNameforRes" placeholder="First Name"/><br>
				<!-- <p>Password:</p> --><input type="text" name="lastNameforRes" placeholder="Last Name"/><br>
										<input type="submit" value="Submit"/>
									
		</form>
	</div>
	
	<div class="form-container">
		<b>Get A Summary Listing of Revenue For Each Flight</b>
		<br/>
		<form action="./AdminFolder/summListRevFlight.jsp" method="post">
								<input type="submit" value="Submit"/>
									
		</form>
	</div>
	
	<div class="form-container">
		<b>Get A Summary Listing of Revenue For Each Airline</b>
		<br/>
		<form action="./AdminFolder/summListRevAirline.jsp" method="post">
								<input type="submit" value="Submit"/>
									
		</form>
	</div>
	
	<div class="form-container">
		<b>Get A Summary Listing of Revenue For Each Customer</b>
		<br/>
		<form action="./AdminFolder/summListRevCust.jsp" method="post">
								<input type="submit" value="Submit"/>
									
		</form>
	</div>
	
	
	
	<div class="form-container">
		<b>Get The Summary Listing of Revenue For A Particular Flight</b>
		<br/>
		<small>Enter A Flight Number and AirlineID</small>
		
		<form action="./AdminFolder/summListPartFlight.jsp" method="post">
						<input type="text" name="flightNumForSum" placeholder="Flight Number"/><br>
						<input type="text" name="airlineIDForSum" placeholder="Airline ID"/><br>
						
						<input type="submit" value="Submit"/>
									
		</form>
	</div>
	
	<div class="form-container">
		<b>Get The Summary Listing of Revenue For A Particular Airline</b>
		<br/>
		<small>Enter An Airline ID</small>
		
		<form action="./AdminFolder/sumListPartAirline.jsp" method="post">
						<input type="text" name="airlineIDforSum" placeholder="Airline ID"/><br>
						<input type="submit" value="Submit"/>
									
		</form>
	</div>
	
	<div class="form-container">
		<b>Get The Summary Listing of Revenue For A Particular Customer</b>
		<br/>
		<small>Enter A Customer Username</small>
		
		<form action="./AdminFolder/sumListPartCustomer.jsp" method="post">
						<input type="text" name="usernameForSum" placeholder="Username"/><br>
						<input type="submit" value="Submit"/>
									
		</form>
	</div>
	
	<div class="form-container">
		<b>Get The Customer With the Largest Amount of Revenue Generated</b>
		<br/>
		<form action="./AdminFolder/maxRevenueForCust.jsp" method="post">
								<input type="submit" value="Submit"/>
									
		</form>
	</div>
	
	
	<div class="form-container">
		<b>Get A List of the Most Active Flights</b>
		<br/>
		<form action="./AdminFolder/mostActiveFlights.jsp" method="post">
								<input type="submit" value="Submit"/>
									
		</form>
	</div>
	
	<br>
	<br>
			
			
			
			
			<%
		} catch (Exception e) {
			out.println(e);
		} finally {
			out.println("<a href=\"loggedout.jsp\">Log out</a>");
		}
		
		%>
	</body>
</html>