<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<h3>
		<%
		try{
			//Get the database connection
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
	
			//Create a SQL statement
			Statement stmt = con.createStatement();
			ResultSet results = stmt.executeQuery("SELECT * FROM airports");
			if(!results.next()){
				out.println("Empty set");
			}
			else{
			%>
				<table border='1'>
				<tr><th>Airport ID</th></tr> <%
				do{%>
					<tr><td><%= results.getString(1) %></td></tr><%
					
					
				}while(results.next());%>
				</table> <%
			}
			
		}catch (Exception e) {
			out.print(e);
		}
		%>
		<!-- This is for add, edit, and delete of Aircraft -->
		<div class="form-container">
	        <b>Add Airport Information:</b>
	        <br/>
	        <small>Input the airport ID.</small>
	        <form action="./add_edit_delete_scripts/addAirport.jsp" method="post">
				<input type="text" name="airportID" placeholder="Airport ID"/><br>
				<input type="submit" value="Submit"/>
        	</form>
		
	    </div>
	    
	    <div class="form-container">
	        <b>Edit Airport Information:</b>
	        <br/>
	        <small>Input the needed edits for the designated airport ID, and the new airport ID to replace it with.</small>
	        <form action="./add_edit_delete_scripts/editAirport.jsp" method="post">
				<input type="text" name="airportID" placeholder="Airport ID"/><br>
				<input type="text" name="newAirportID" placeholder="New Airport ID"/><br>
				<input type="submit" value="Submit"/>
        	</form>
	    </div>
	    
	    <div class="form-container">
	        <b>Delete Airport Information:</b>
	        <br/>
	        <small>Input the airport ID you wish to delete</small>
	        <form action="./add_edit_delete_scripts/deleteAirport.jsp" method="post">
				<input type="text" name="airportID" placeholder="Airport ID"/><br>
				<input type="submit" value="Submit"/>
        	</form>
		
	    </div>
	    
	    <form action="../rephome.jsp">
		<input type="submit" value="Return to Dashboard">
		</form>
	</h3>
</body>
</html>