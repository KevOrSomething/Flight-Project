<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="stylesheet.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Testing</title>
	</head>
	<body>
		<%
			try {
				//Get the database connection
				ApplicationDB db = new ApplicationDB();
				Connection con = db.getConnection();
		
				//Create a SQL statement
				Statement stmt = con.createStatement();
				String username = request.getParameter("registerUsername");
				String password = request.getParameter("registerPassword");
				String repeatPassword = request.getParameter("repeatPassword");
				String firstName = request.getParameter("registerFirstName");
				String lastName = request.getParameter("registerLastName");
				
				if (username.equals("") || username == null) {
					out.println("<h2>Username field was empty</h2>");
					out.println("<a href=\"register.jsp\">Go back</a>");
				} else if (password.equals("") || password == null) {
					out.println("<h2>Password field was empty</h2>");
					out.println("<a href=\"register.jsp\">Go back</a>");
				} else if (!password.equals(repeatPassword)) {
					out.println("<h2>Passwords do not match&mdash;please try again</h2>");
					out.println("<a href=\"register.jsp\">Go back</a>");
				} else {	
					//Check to see if username already exists
					ResultSet checkIfExists = stmt.executeQuery("SELECT count(*) AS 'exists' FROM customer_logins WHERE username = '" + username + "';");
					boolean exists = false;
					
					if (checkIfExists.next()) {
						if (checkIfExists.getInt("exists") == 0) { //username is unique and doesn't already exist
							//Run the query against the database.				
							stmt.executeUpdate("INSERT INTO customer_logins(username, password, firstname, lastname) VALUES('" + username + "', '" + password + "', '" + firstName + "', '" + lastName + "');");
							ResultSet result = stmt.executeQuery("SELECT password FROM customer_logins WHERE username = '" + username + "'");
							
							out.println("<h1>Successfully registered</h1>");
							out.println("<p>Your new login information is:</p>");
							out.println("username: <b>" + username + "</b><br>");
							out.println("password: <b>" + password + "</b><br>");
							out.println("first name: <b>" + firstName + "</b><br>");
							out.println("last name: <b>" + lastName + "</b>");
							
							out.println("<br><br><h2>SQL verification</h2>");
							
							out.println("username: <b>" + username + "</b><br>");
							while (result.next()) {
								out.println("password: <b>" + result.getString("password") + "</b><br><br>");
							}
							out.println("<a href=\"login.jsp\">Log out</a>");
						} else { //username already exists in the database
							out.println("<h2>Username already exists&mdash;please try again</h2>");
							out.println("<a href=\"register.jsp\">Go back</a>");
						}
					}
				}
			} catch (Exception e) {
				out.print(e);
			}
		%>
		
	</body>
</html>