<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="stylesheet.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Editing A Customer</title>
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
 
						
				ResultSet result = stmt.executeQuery("select * from customer_logins c where c.username = '" + username + "';");
						
	//			int rows = stmt.executeUpdate("INSERT into rep_logins Values (\"" + username + "\", \"" + password + "\", \"" + firstName + "\", \"" + lastName + "\");");
	
	
				//stmt.executeUpdate("Insert into rep_logins Values ('"+ username + "', '" + password + "', '" + firstName + "', '" + lastName + "' )");
				
				if(!result.next())
				{
					out.println("Username Not Found");	
				}else{
					stmt.executeUpdate("UPDATE customer_logins SET password = '" + password + "', firstname = '" + firstName + "', lastname = '" + lastName + "' WHERE username = '" + username + "';");
					
					out.println("Customer Successfully Edited");
				
				}
				
				
			}
				catch (Exception e) {
					out.print(e);
			}
		
				
	
				
				%>
				
				<form action="../adminhome.jsp">
				<input type="submit" value="Return to Dashboard">
				</form>
								
			</body>
		</html>
				
				