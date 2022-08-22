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
		<h1>Login status</h1>
		
		
		<%
		
			
			try {
				//Get the database connection
				ApplicationDB db = new ApplicationDB();
				Connection con = db.getConnection();
		
				//Create a SQL statement
				Statement stmt = con.createStatement();
				String username = request.getParameter("loginUsername");
				String enteredPassword = request.getParameter("loginPassword");
				String correctPassword = null;
				String loginType = request.getParameter("loginType");
				
				ResultSet result;
				String getAccountQuery = "SELECT password, firstname, lastname FROM " + loginType + "_logins WHERE username = ? ;";
								
				PreparedStatement ps = con.prepareStatement(getAccountQuery);
				ps.setString(1, username);
				result = ps.executeQuery();

				
				if (result.next()) {
					correctPassword = result.getString("password");
				}

				if (enteredPassword != null && enteredPassword.equals(correctPassword)) {
					
					
					//Set up session user 
					session.setAttribute("user", username);
					session.setAttribute("userFirstName", result.getString("firstname"));
					session.setAttribute("userLastName", result.getString("lastname"));
					session.setAttribute("userType", loginType);
					session.setAttribute("welcomeMessage", 
							String.format("Welcome back, <b>%s %s (%s).</b><br><br>", 
							session.getAttribute("userFirstName"),
							session.getAttribute("userLastName"),
							session.getAttribute("user")));
					response.sendRedirect(loginType + "home.jsp");
					
				} else {
					out.println("<h2>Incorrect login</h2>");
					out.println("<a href=\"login.jsp\">Go back</a>");
				}
				
				con.close();

			} catch (Exception e) {
				out.print(e);
			}
		%>
		
	</body>
</html>