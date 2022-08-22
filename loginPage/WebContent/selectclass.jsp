<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Select Class</title>
	</head>
	<body>
		<%
		try {
			
			if (session.getAttribute("user") == null) {
				response.sendRedirect("login.jsp");
			}
			
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			String outboundString = request.getParameter("outbound");
			String returnString = request.getParameter("return");
			//out.print(tripString);
			
			//First checks if no trip was selected
			if (outboundString == null && returnString == null) {
				out.print("No trip was selected.");
			} else {
				%>
				Select your class.
				<form method="post" action="newticket.jsp">
					<select name="ticketClass" size=1>
						<option value="f">First Class</option>
						<option value="b">Business</option>
						<option value="e">Economy</option>
					</select>&nbsp;<br>
					NOTE: Outbound and return trips are registered on separate tickets.<br>
					Furthermore, each ticket has a booking fee of $50.00.<br>
					Finally, if you purchase an economy ticket, you must pay $30.00 if you wish to cancel it.<br>
					<input type="submit" value="Buy Ticket">
					<input type="hidden" name="outbound" value=<%=outboundString%> >
					<input type="hidden" name="return" value=<%=returnString%> >
				</form>
				<br>
				
				<%
			}
			
			
			con.close();
			
		} catch (Exception e) {
			
			out.print(e);
			
		} finally {
			%>
			<br>
			<form action="./customerSearchFolder/search.jsp">
			<input type="submit" value="Return to Search">
			</form>
			<%
		}
		%>
		
		
	</body>
</html>