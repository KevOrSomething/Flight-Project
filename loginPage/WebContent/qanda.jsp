<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Q&A</title>
	</head>
	<body>
		
		<%
		if (session.getAttribute("user") == null) {
				response.sendRedirect("login.jsp");
			}
		%>
		
		
		<form action="customerhome.jsp" method="post">
		    <input type="submit" value="Back to Home">
		</form>
		<br>
			
	
		<form method="post" action="newquestion.jsp">
			<table>
				<tr>
					<td>Ask a question:</td>
				</tr>
				<tr>    
					<td><input type="text" name="newQuestionText"></td>
				</tr>
			</table>
			<input type="submit" value="Post Question">
		</form>
		<br>
		
		<form method="get" action="qanda.jsp">
			<table>
				<tr>
					<td>Look up keywords:</td>
				</tr>
				<tr>    
					<td><input type="text" name="searchText"></td>
				</tr>
			</table>
			<input type="submit" value="Search">
		</form>
		<br>
		
		<% 
			//Get the database connection
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
			try {
		
				//Create a SQL statement
				Statement stmt = con.createStatement();
				
				String keyword = request.getParameter("searchText");
						
				
				ResultSet questionSet;
				
				if (keyword == null) {
					String allQuestionsQuery = "SELECT q.questionInfo, a.answerInfo " +
							"FROM questions q " +
							"LEFT JOIN answers a ON q.questionID = a.questionID";
					questionSet = stmt.executeQuery(allQuestionsQuery);
				} else {
					String keywordQuestionsQuery = "SELECT * " +
							"FROM (SELECT q.questionInfo, a.answerInfo " +
									"FROM questions q " +
									"LEFT JOIN answers a ON q.questionID = a.questionID) s " +
								"WHERE s.questionInfo LIKE ? OR s.answerInfo LIKE ?";
						PreparedStatement ps = con.prepareStatement(keywordQuestionsQuery);
						ps.setString(1, "%" + keyword + "%");
						ps.setString(2, "%" + keyword + "%");
						questionSet = ps.executeQuery();
				}
				
				
				
				
		%>
		
		
		
		<table border='1'>
			<tr>
				<td><strong>Question</strong></td>
				<td><strong>Answer</strong></td>
			</tr>
			<%
			while (questionSet.next()) { %>
				<tr>
					<td><%= questionSet.getString("questionInfo") %></td>
					<td>
					<%if (questionSet.getString("answerInfo") != null) { %>
						<%= questionSet.getString("answerInfo") %>
					<% } else { %>
						[Unanswered]
					<% } %>
					</td>
				</tr>
			<% } %>
		</table>
				
		<%
			} catch (Exception e) {
				out.print(e);
			} finally {
				con.close();
			}
		%>
		
	</body>
</html>