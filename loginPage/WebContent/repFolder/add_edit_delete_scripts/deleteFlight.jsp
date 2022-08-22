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
			String flightNum = request.getParameter("flightNum");
			String arrivalDate = request.getParameter("arrivalDate");
			String arrivalTime = request.getParameter("arrivalTime");
			String departDate = request.getParameter("departDate");
			String departTime = request.getParameter("departTime");

			stmt.executeUpdate("DELETE FROM includes WHERE flightNum=" + flightNum + " and departDate=\"" + departDate + "\" and arrivalDate=\"" + arrivalDate + "\"");
			stmt.executeUpdate("DELETE FROM arrives_at WHERE flightNum=" + flightNum + " and arrivalDate=\"" + arrivalDate + "\" and arrivalTime=\"" + arrivalTime + "\"");
			stmt.executeUpdate("DELETE FROM departs_from WHERE flightNum=" + flightNum + " and departDate=\"" + departDate + "\" and departTime=\"" + departTime + "\"");
			stmt.executeUpdate("DELETE FROM uses WHERE flightNum=" + flightNum);
			stmt.executeUpdate("DELETE FROM flights WHERE flightNum=" + flightNum);
			
		}catch (Exception e) {
            out.print(e);
		}
	
	%>
	Successfully deleted flight!
	<form action="../editFlightInformation.jsp">
	<input type="submit" value="Return to Flight Information">
	</form>
</h3>
</body>
</html>