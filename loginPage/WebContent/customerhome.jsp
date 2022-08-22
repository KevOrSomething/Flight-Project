<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Customer Homepage</title>
	</head>
	<body>
			
		<%
		try {
			if (session.getAttribute("user") == null || !session.getAttribute("userType").equals("customer")) {
				response.sendRedirect("login.jsp");
			}
			
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			out.println(session.getAttribute("welcomeMessage"));
						
			//This part prints all the alerts for all the given user's waitlisted flights
			String waitlistQuery = "SELECT * FROM in_waitlist_of WHERE username = ?";
			PreparedStatement waitlistPS = con.prepareStatement(waitlistQuery);
			waitlistPS.setString(1, (String)session.getAttribute("user"));
			ResultSet waitlistSet = waitlistPS.executeQuery();
			
			while (waitlistSet.next()) {
				out.print(waitlistSet.getString("alert"));
				%><br><%
			}
			
			//PUT YOUR REDIRECT BUTTONS TO YOUR PAGES HERE
			//...
			
			%>
			<br>
			Search for flights:
			<form action="./customerSearchFolder/search.jsp" method="post">
			    <input type="submit" value="Go to Search">
			</form>
			<br>
			
			Check out your past and upcoming tickets here:
			<form action="viewtickets.jsp" method="post">
			    <input type="submit" value="Go to Your Tickets">
			</form>
			<br>
			
			
			Need help? Get customer representative support at our Q&A:
			<form action="qanda.jsp" method="post">
			    <input type="submit" value="Go to Q&A">
			</form>
			<br>
			<%
			
			con.close();
		} catch (Exception e) {
			out.println(e);
		} finally {
			out.println("<a href=\"loggedout.jsp\">Log out</a>");
		}
		
		%>
	</body>
</html>