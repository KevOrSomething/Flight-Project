<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

	<div class="form-container">
        <b>Get A List of Waitlisted Passengers for a Flight</b>
        <br/>
        <small>Enter A Flight Number</small>
        <form action="getWaitlist.jsp" method="post">
		<input type="text" name="flightNumber" placeholder="Flight Number"/><br>
		<input type="text" name="airlineID" placeholder="Airline ID"/><br>
		<input type="text" name="departDate" placeholder="Departure Date"/><br>
		<input type="submit" value="Submit"/>
        </form>
    </div>

	<form action="../rephome.jsp">
	<input type="submit" value="Return to Dashboard">
	</form>

</body>
</html>