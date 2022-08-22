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
	                //Get the database connection
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
	
			Statement stmt = con.createStatement();
			String aircraftID = request.getParameter("aircraftID");
			String numberOfSeats = request.getParameter("numberOfSeats");
	                
			stmt.executeUpdate("INSERT INTO aircraft VALUES (" + aircraftID + ", " + numberOfSeats + ")");
		}catch (Exception e) {
            out.print(e);
		}
	
	%>
	Successfully added aircraft!
	<form action="../editAircraftInformation.jsp">
	<input type="submit" value="Return to Aircraft Information">
	</form>
</h3>
</body>
</html>