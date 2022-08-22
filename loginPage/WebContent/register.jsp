<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="stylesheet.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Application</title>
	</head>
	<body>
		<div class="form-container">
			<h1>Register for an account</h1>
			<form action="registered.jsp" method="post">
				<input type="text" name="registerFirstName" placeholder="First name"/><br>
				<input type="text" name="registerLastName" placeholder="Last name"/><br>
				<!-- <p>Username:</p> --><input type="text" name="registerUsername" placeholder="Username"/><br>
				<!-- <p>Password:</p> --><input type="password" name="registerPassword" placeholder="Password"/><br>
				<!-- <p>Repeat password:</p> --><input type="password" name="repeatPassword" placeholder="Repeat password"/><br>
				<input type="submit" value="Register"/>
			</form>
			<br>
			<a href="login.jsp">Log into your account here</a>
		</div>
	</body>
</html>