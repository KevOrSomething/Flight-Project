<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="stylesheet.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Login</title>
	</head>
	<body>
	
		<%
		if ((session.getAttribute("user") != null)) {
			session.invalidate();
		}
		%>
		<div class="form-container">
			<h1>Log into your account</h1>
			<form action="loggedin.jsp" method="post">
				<!-- <p>Username:</p> --><input type="text" name="loginUsername" placeholder="Username"/><br>
				<!-- <p>Password:</p> --><input type="password" name="loginPassword" placeholder="Password"/><br>
				<label for="login-select">Log in as:</label><br>
				<select id="login-select" name="loginType">
					<option value="customer">Customer</option>
					<option value="rep">Customer representative</option>
					<option value="admin">Administrator</option>
				</select>
				<input type="submit" value="Log in"/>
			</form>
			<br>
			<a href="register.jsp">Register for an account here</a>
		</div>
		<!-- <h1>Forgot password</h1>
		<form action="forgotpassword.jsp" method="get">
			<p>Enter username:</p><input type="text" name="recoverByUsername"/><br>
			<input type="submit" value="Get password"/>
		</form> -->
	</body>
</html>