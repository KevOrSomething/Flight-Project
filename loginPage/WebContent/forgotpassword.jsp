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
		<p>Your password was:</p>
		
		<%
			try {
				//Get the database connection
				ApplicationDB db = new ApplicationDB();
				Connection con = db.getConnection();
		
				//Create a SQL statement
				Statement stmt = con.createStatement();
				String username = request.getParameter("recoverByUsername");
				//Run the query against the database.
				//ResultSet result = stmt.executeQuery("SELECT password FROM credentials WHERE username = '" + username + "';");
				ResultSet result = stmt.executeQuery("SELECT password FROM customer_logins WHERE username = '" + username + "';");
				
				while (result.next()) {
					out.println("<b>" + result.getString("password") + "</b>");
				}
				
			} catch (Exception e) {
				out.print(e);
			}
		%>
		
	</body>
</html>