<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Cancel Ticket</title>
	</head>
	<body>
		<%
		try {
			
			if (session.getAttribute("user") == null) {
				response.sendRedirect("login.jsp");
			}
			
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			int cancelledTicket = Integer.parseInt(request.getParameter("cancelTicket"));
			
			String checkTicket = "SELECT * " +
					"FROM tickets " +
					"JOIN buys USING (ticketID) " +
					"WHERE ticketID = ? AND username = ? AND departDate >= curdate();";
			
			PreparedStatement checkPS = con.prepareStatement(checkTicket);
			checkPS.setInt(1, cancelledTicket);
			checkPS.setString(2, (String)session.getAttribute("user"));
			
			ResultSet checkSet = checkPS.executeQuery();
			
			if (!checkSet.next()) {
				out.print("Failed to find ticket OR ticket depart date has already passed.");
				
			} else {
				
				String ticketClass = checkSet.getString("ticketClass");

				out.print(String.format("A fee of $%f must be paid in order to delete Ticket %d. Continue?", checkSet.getFloat("cancelFee"),cancelledTicket));
				%>
				<form method="post" action="deleteticket.jsp">
					<input type="hidden" name="ticketID" value=<%=request.getParameter("cancelTicket") %>>
					<input type="submit" value="Yes, Pay Fee and Delete">
				</form>
				<%
			
				
				/*
				String deleteTicket = "DELETE FROM tickets WHERE ticketID = ?";
				PreparedStatement deletePS = con.prepareStatement(deleteTicket);
				deletePS.setInt(1, cancelledTicket);
				deletePS.executeUpdate();
				
				out.print("Ticket " + cancelledTicket + " successfully deleted.");
				*/
			}
			
			/*
			if (newQuestion== null || newQuestion ==  ""){
				out.print("Failed to post question.");
			} else {
				
			}
			*/
			con.close();
			
		} catch (Exception e) {
			
			out.print(e);
			
		} finally {
			%>
			<br>
			<form action="viewtickets.jsp">
			<input type="submit" value="Return to Tickets">
			</form>
			<%
		}
		%>
		
		
	</body>
</html>