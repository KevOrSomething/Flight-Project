<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Support</title>
	</head>
	<body>
		<%
		try {
			
			if (session.getAttribute("user") == null) {
				response.sendRedirect("login.jsp");
			}
			
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
	
			Statement stmt = con.createStatement();
			
			String newQuestion = request.getParameter("newQuestionText");
			
			
			int lastId;
			String lastIdQuery = "SELECT max(q.questionID) as max " +
					"FROM questions q";
			
			ResultSet lastIdSet = stmt.executeQuery(lastIdQuery);
			
			if (lastIdSet.next() == false) {
				lastId = 0;
			} else {
				lastId = lastIdSet.getInt("max");
			}
			
			
			if (newQuestion == null || newQuestion ==  ""){
				out.print("Failed to post question.");
			} else {
				
				String insertQuestion = "INSERT INTO questions(questionInfo) "
						+ "VALUES (?)";
				
				//Use this to get username from session and set up asks
				String insertAsks = "INSERT INTO asks (username) " +
						"VALUES (?)";
				
				//int newQuestionId = lastId + 1;
				
				PreparedStatement ps = con.prepareStatement(insertQuestion);
				
				//Inserts the question into question table
				ps.setString(1, newQuestion);
				ps.executeUpdate();
				
				//Inserts the questionID and given session user
				ps = con.prepareStatement(insertAsks);
				ps.setString(1, (String)session.getAttribute("user"));
				ps.executeUpdate();
		
				out.print("Successfully posted question.");
			}
			
			con.close();
			
		} catch (Exception e) {
			
			out.print(e);
			
		} finally {
			
			%>
			<form action="qanda.jsp">
			<input type="submit" value="Return to Q&A">
			</form>
			<%
		}
		%>
		
		
	</body>
</html>