<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Questions</title>
</head>
	<body>
		<h3>
		Unanswered Questions:
			<%
			try{
				//Get the database connection
				ApplicationDB db = new ApplicationDB();
				Connection con = db.getConnection();
		
				//Create a SQL statement
				Statement stmt = con.createStatement();
				ResultSet results = stmt.executeQuery("SELECT * FROM questions WHERE questions.questionID NOT IN (select answers.questionID from answers)");
				if(!results.next()){
					out.println("No questions found!");
				}
				else{
				%>
					<table border='1'>
					<tr><th>Question ID</th><th>Question Info</th></tr> <%
					do{%>
						<tr><td><%= results.getString(1) %></td><td><%= results.getString(2) %></td></tr><%
						
						
					}while(results.next());%>
					</table> <%
				}
				
			}catch (Exception e) {
				out.print(e);
			}%>
		</h3>
		<h3>
		
			<div class="form-container">
	        <b>Answer a question!</b>
	        <br/>
	        <small>Input the question ID, the answer to it, and your username.</small>
	        <form action="answerSubmitted.jsp" method="post">
				<input type="text" name="QuestionID" placeholder="Question ID"/><br>
				<input type="text" name="AnswerInfo" placeholder="Answer Information"/><br>
				<input type="submit" value="Submit"/>
        	</form>
        	
		
	    	</div>
	    	<div class="form-container">
	        <b>Access all answered questions: </b>
	        <br/>
	        <form action="accessAllQuestions.jsp" method="post">
				<input type="submit" value="Access"/>
        	</form>
        	
	    	</div>
	    	
		<form action="../rephome.jsp">
		<input type="submit" value="Return to Dashboard">
		</form>
		
		</h3>
	</body>
</html>