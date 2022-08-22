<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="stylesheet.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Editing A Customer Representative</title>
	</head>
	<body>
		<%
			try {
				//Get the database connection
				ApplicationDB db = new ApplicationDB();
				Connection con = db.getConnection();
		
				//Create a SQL statement
				Statement stmt = con.createStatement();
				//String username = request.getParameter("loginUsername");
				//String enteredPassword = request.getParameter("loginPassword");
				//String correctPassword = null;
				//String loginType = request.getParameter("loginType");
				
				String username = request.getParameter("usernameForLogin");
				String password = request.getParameter("passwordForLogin");
				String firstName = request.getParameter("firstNameForLogin");
				String lastName = request.getParameter("lastNameForLogin");
 
				
				//Run the query against the database.
				//ResultSet result = stmt.executeQuery("SELECT password FROM " + loginType + "_logins WHERE username = '" + username + "';");
				//ResultSet result = stmt.executeQuery("select EXTRACT(month FROM t.purchaseDate) Month, count(ticketID) NumberOfTickets from tickets t where EXTRACT(month FROM t.purchaseDate) = " + month + " group by EXTRACT(month FROM t.purchaseDate)"); 
				//.ticketID TicketID, t.totalFare TotalFare from tickets t, buys where b.ticketID = t.ticketID AND EXTRACT(month FROM b.purchaseDate) = 12
				//		group by t.ticketID ")
				
				//ResultSet result = stmt.executeQuery("select t.ticketID TicketID, t.departDate DepartDate, t.departTime DepartTime, t.totalFare TotalFare, t.ticketClass TicketClass from tickets t, includes i, flights f where f.flightNum = i.flightNum and i.ticketID = t.ticketID and f.flightNum = " + flightNum + ";");
				
		//		ResultSet result = stmt.executeQuery("select f.flightNum FlightNum, sum(t.totalFare) TotalFares from flights f, includes i, tickets t where f.flightNum = i.flightNum and i.ticketID = t.ticketID group by f.flightNum;");
						
		
				//ResultSet result = stmt.executeQuery("select f.airlineID AirlineID, sum(t.totalFare) TotalFares from flights f, includes i, tickets t where f.flightNum = i.flightNum and i.ticketID = t.ticketID and f.airlineID = '" + airlineID + "' group by f.airlineID;");

				
				ResultSet result = stmt.executeQuery("select * from rep_logins r where r.username = '" + username + "';");
						
	//			int rows = stmt.executeUpdate("INSERT into rep_logins Values (\"" + username + "\", \"" + password + "\", \"" + firstName + "\", \"" + lastName + "\");");
	
	
				//stmt.executeUpdate("Insert into rep_logins Values ('"+ username + "', '" + password + "', '" + firstName + "', '" + lastName + "' )");
				
				if(!result.next())
				{
					out.println("Username Not Found");	
				}else{
					stmt.executeUpdate("UPDATE rep_logins SET password = '" + password + "', firstname = '" + firstName + "', lastname = '" + lastName + "' WHERE username = '" + username + "';");
					
					out.println("Customer Representative Successfully Edited");
				
				}
				
	//			 stmt.executeUpdate("UPDATE flights SET airlineID=\"" + airlineID + "\", price=" + price + ", flightType = \"" + flightType + "\" WHERE flightNum=" + flightNum);
				
			}
				catch (Exception e) {
					out.print(e);
			}
		
				
			//	ResultSet result = stmt.executeQuery("select t.ticketID TicketID, t.totalFare TotalFare from tickets t, buys b where b.ticketID = t.ticketID AND EXTRACT(month FROM b.purchaseDate) = " + month + " group by t.ticketID;");

				//stmt.executeUpdate("INSERT INTO credentials(username, password) VALUES('" + username + "', '" + password + "');");
				//ResultSet result = stmt.executeQuery("SELECT password FROM credentials WHERE username = '" + username + "'");
				
				//out.println("Success");
				
		/* 	} catch (Exception e) {
				out.print(e);
			} */
				
				%>
						
				<form action="../adminhome.jsp">
				<input type="submit" value="Return to Dashboard">
				</form>
								
			</body>
		</html>
				
				