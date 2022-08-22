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
			String airportID = request.getParameter("airportID");
	                
			stmt.executeUpdate("DELETE FROM airports WHERE airportID=\"" + airportID + "\"");

			
			
		}catch (Exception e) {
            out.print(e);
		}
	
	%>
	Successfully deleted airport!
	<form action="../editAirportInformation.jsp">
	<input type="submit" value="Return to Airport Information">
	</form>
</h3>
</body>
</html>