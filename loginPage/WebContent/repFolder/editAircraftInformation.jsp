<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html>
<html>
	<head>
	<meta charset="ISO-8859-1">
	<title>Customer Representative</title>
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
			ResultSet results = stmt.executeQuery("SELECT * FROM aircraft");
			if(!results.next()){
				out.println("Empty set");
			}
			else{
			%>
				<table border='1'>
				<tr><th>Aircraft ID</th><th>Number of Seats</th></tr> <%
				do{%>
					<tr><td><%= results.getString(1) %></td><td><%= results.getString(2) %></td></tr><%
					
					
				}while(results.next());%>
				</table> <%
			}
			
		}catch (Exception e) {
			out.print(e);
		}
		%>
		<!-- This is for add, edit, and delete of Aircraft -->
		<div class="form-container">
	        <b>Add Aircraft Information:</b>
	        <br/>
	        <small>Input the aircraft ID, and number of seats.</small>
	        <form action="./add_edit_delete_scripts/addAircraft.jsp" method="post">
				<input type="text" name="aircraftID" placeholder="Aircraft ID"/><br>
				<input type="text" name="numberOfSeats" placeholder="Number of Seats"/><br>
				<input type="submit" value="Submit"/>
        	</form>
		
	    </div>
	    
	    <div class="form-container">
	        <b>Edit Aircraft Information:</b>
	        <br/>
	        <small>Input the needed edits for aircraft ID, and number of seats.</small>
	        <form action="./add_edit_delete_scripts/editAircraft.jsp" method="post">
				<input type="text" name="aircraftID" placeholder="Aircraft ID"/><br>
				<input type="text" name="numberOfSeats" placeholder="Number of Seats"/><br>
				<input type="submit" value="Submit"/>
        	</form>
	    </div>
	    
	    <div class="form-container">
	        <b>Delete Aircraft Information:</b>
	        <br/>
	        <small>Input the aircraft ID you wish to delete</small>
	        <form action="./add_edit_delete_scripts/deleteAircraft.jsp" method="post">
				<input type="text" name="aircraftID" placeholder="Aircraft ID"/><br>
				<input type="submit" value="Submit"/>
        	</form>
		
	    </div>
	
	<form action="../rephome.jsp">
	<input type="submit" value="Return to Dashboard">
	</form>
	
	</h3>
		
	</body>
</html>