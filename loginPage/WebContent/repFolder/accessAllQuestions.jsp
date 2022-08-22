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
			String username = request.getParameter("username");
		                
			ResultSet results = stmt.executeQuery("SELECT questions.questionID, questions.questionInfo, answers.answerInfo FROM questions INNER JOIN answers on questions.questionID = answers.questionID");
		
			if(!results.next()){
				out.println("No answers found!");
			}
			else{
			%>
				<table border='1'>
				<tr><th>Question ID</th><th>Question Info</th><th>Answer Info</th></tr> <%
				do{%>
					<tr><td><%= results.getString(1) %></td><td><%= results.getString(2) %></td><td><%= results.getString(3) %></td></tr><%
					
					
				}while(results.next());%>
				</table> <%
			}
		
		
		}catch (Exception e) {
            out.print(e);
		}
	
	%>
	<form action="./userQuestions.jsp">
	<input type="submit" value="Return to Dashboard">
	</form>
</h3>
</body>
</html>