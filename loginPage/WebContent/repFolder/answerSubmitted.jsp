<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<h3>
	<%
		try {
	                //Get the database connection
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
	
			Statement stmt = con.createStatement();
			String questionID = request.getParameter("QuestionID");
			String answerInfo = request.getParameter("AnswerInfo");
			String username = session.getAttribute("user").toString();
			
			stmt.executeUpdate("INSERT INTO answers VALUES (" + questionID + ", \"" + username +  "\", \"" + answerInfo + "\")");
		}catch (Exception e) {
            out.print(e);
		}
	
	%>
	Successfully answered question!
	<form action="./userQuestions.jsp">
	<input type="submit" value="Return to Questions">
	</form>
</h3>
</body>
</html>