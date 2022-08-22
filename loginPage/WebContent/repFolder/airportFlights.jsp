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
        <b>Get A List of Flights For A Given Airport</b>
        <br/>
        <small>Enter An Airport ID</small>
        <form action="getFlightList.jsp" method="post">
		<input type="text" name="AirportIDForFlights" placeholder="Airport ID"/><br>
		<input type="submit" value="Submit"/>

        </form>
    </div>
	<form action="../rephome.jsp">
	<input type="submit" value="Return to Dashboard">
	</form>
</body>
</html>