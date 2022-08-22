<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="../stylesheet.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Search</title>
	</head>
	<body>
		<div class="form-container">
			<form action="searchresults.jsp" method="get">
				<h1>Search</h1>
				<select id="trip-type" name="tripType">
					<option value="oneWay" selected>One-way</option>
					<option value="roundTrip">Round-trip</option>
				</select><br>
				<label for="from-field">From: </label><input type="text" id="from-field" name="searchFrom" maxlength="3" style="text-transform: uppercase" placeholder="From"><br>
				<label for="to-field">To: </label><input type="text" id="to-field" name="searchTo" maxlength="3" style="text-transform: uppercase" placeholder="To"><br>
				<label for="date-field">Depart date (YYYY-MM-DD): </label><br><input type="date" id="date-field" name="searchDate" class="push-field" placeholder="Depart date"><br>
				<label for="return-date-field">Return date (YYYY-MM-DD) (only for round-trip): </label><br><input type="date" id="return-date-field" name="searchReturnDate" class="push-field" placeholder="Return date"><br>
				<!-- <label for="time-field">Time (HH:MM): </label><input type="time" id="time-field" name="searchTime" placeholder="Time"><br> -->
				<select id="flexible-field" name="tripFlexible">
					<option value="searchExact">Exact dates</option>
					<option value="searchFlexible">Flexible (+/- 3 days)</option>
				</select><br>
				
				<h2>Sort</h2>
				<label for="sort-by-field">Sort by:</label>
				<select id="sort-by-field" name="tripSortBy">
					<option value="ORDER BY totalPrice ASC" selected>Price: low to high</option>
					<option value="ORDER BY totalPrice DESC">Price: high to low</option>
					
					<option value="ORDER BY departDateAdj ASC, departTime ASC">Takeoff: earliest first</option>
					<option value="ORDER BY departDateAdj DESC, departTime DESC">Takeoff: latest first</option>
					
					<option value="ORDER BY arrivalDateAdj ASC, arrivalTime ASC">Landing: earliest first</option>
					<option value="ORDER BY arrivalDateAdj DESC, arrivalTime DESC">Landing: latest first</option>
					
					<option value="ORDER BY totalDuration ASC">Duration: shortest to longest</option> 
					<option value="ORDER BY totalDuration DESC">Duration: longest to shortest</option>
				</select><br>
				
				<h2>Filter</h2>	
				<label for="airline-field">Airline (XX): </label><br><input type="text" id="airline-field" name="filterAirline" class="push-field" placeholder="airline ID" style="text-transform: uppercase"><br>
				
				<label for="price-from-field">Price ($): </label><br><input type="number" id="price-from-field" name="filterPriceFrom" class="push-field" placeholder="from"><br>
				<!-- <label for="price-to-field">to</label> --><input type="number" id="price-to-field" name="filterPriceTo" class="push-field" placeholder="to"><br>
				
				<label for="takeoff-from-field">Takeoff (HH:MM): </label><br><input type="time" id="takeoff-from-field" name="filterTakeoffFrom" class="push-field" placeholder="from"><br>
				<!-- <label for="takeoff-to-field">to</label> --><input type="time" id="takeoff-to-field" name="filterTakeoffTo" class="push-field" placeholder="to"><br>
				
				<label for="arrival-from-field">Arrival (HH:MM): </label><br><input type="time" id="arrival-from-field" name="filterArrivalFrom" class="push-field" placeholder="from"><br>
				<!-- <label for="arrival-to-field">to</label> --><input type="time" id="arrival-to-field" name="filterArrivalTo" class="push-field" placeholder="to"><br>
				
				<label for="duration-from-field">Duration (HH:MM): </label><br><input type="time" id="duration-from-field" name="filterDurationFrom" class="push-field" placeholder="from"><br>
				<!-- <label for="duration-to-field">to</label> --><input type="time" id="duration-to-field" name="filterDurationTo" class="push-field" placeholder="to"><br>
				
				<label for="stops-from-field">Number of stops: </label><br><input type="number" id="stops-from-field" name="filterStopsFrom" class="push-field" placeholder="from"><br>
				<!-- <label for="duration-to-field">to</label> --><input type="number" id="stops-to-field" name="filterStopsTo" class="push-field" placeholder="to"><br>
				
				<br>
				<br>
				
				<input type="submit" value="Search"/>
			</form>
		</div>
		
		<!-- <form action="customerhome.jsp" method="get">
			<h2>Sort</h2>
			<label for="sort-dropdown">Sort by:</label>
			<select id="sort-dropdown">
				<option value="priceASC">Price: low to high</option>
				<option value="priceDESC">Price: high to low</option>
				
				<option value="takeoffASC">Takeoff: earliest first</option>
				<option value="takeoffDESC">Takeoff: latest first</option>
				
				<option value="landingASC">Landing: earliest first</option>
				<option value="landingDESC">Landing: latest first</option>
				
				<option value="durationASC">Duration: shortest to longest</option> 
				<option value="durationDESC">Duration: longest to shortest</option>
			</select>
		
			<label for="sort-price">Sort by price:</label>
			<select id="sort-price" name="sortPrice">
				<option value="ASC">Low to high</option>
				<option value="DESC">High to low</option>
			</select>
			<br>
			
			<label for="sort-takeoff">Sort by takeoff time:</label>
			<select id="sort-takeoff" name="sortTakeoff">
				<option value="ASC">Earliest first</option>
				<option value="DESC">Latest first</option>
			</select>
			<br>
			
			<label for="sort-landing">Sort by landing time:</label>
			<select id="sort-landing" name="sortLanding">
				<option value="ASC">Earliest first</option>
				<option value="DESC">Latest first</option>
			</select>
			<br>
			
			<label for="sort-duration">Sort by duration:</label>
			<select id="sort-duration" name="sortDuration">
				<option value="ASC">Shortest to longest</option> 
				<option value="DESC">Longest to shortest</option>
			</select>
			<br>
			
			<input type="submit" value="Sort"/>
		</form> -->
		
		<%-- <h1>Search results (first leg)</h1>
		
		<%
			try {
				//search
				String tripType = request.getParameter("tripType");
				String searchFrom = request.getParameter("searchFrom");//.toUpperCase();
				String searchTo = request.getParameter("searchTo");//.toUpperCase();
				String searchDate = request.getParameter("searchDate");
				String searchFlexible = request.getParameter("tripFlexible");
				
				//sort
				String sort = request.getParameter("tripSortBy");
				
				//filters
				String airlineFilter = request.getParameter("filterAirline");
				
				String priceFrom = request.getParameter("filterPriceFrom");
				String priceTo = request.getParameter("filterPriceTo");
				
				String takeoffFrom = request.getParameter("filterTakeoffFrom");
				String takeoffTo = request.getParameter("filterTakeoffTo");
				
				String arrivalFrom = request.getParameter("filterArrivalFrom");
				String arrivalTo = request.getParameter("filterArrivalTo");
				
				String durationFrom = request.getParameter("filterDurationFrom");
				String durationTo = request.getParameter("filterDurationTo");
				
				//default "from" values when "to" is NOT empty
				if (priceFrom.equals("") && !priceTo.equals("")) { priceFrom = "0"; }
				if (takeoffFrom.equals("") && !takeoffTo.equals("")) { takeoffFrom = "00:00"; }
				if (arrivalFrom.equals("") && !arrivalTo.equals("")) { arrivalFrom = "00:00"; }
				if (durationFrom.equals("") && !durationTo.equals("")) { durationFrom = "00:00"; }
				
				//default "to" values when "from" is NOT empty
				if (!priceFrom.equals("") && priceTo.equals("")) { priceTo = "9999"; }
				if (!takeoffFrom.equals("") && takeoffTo.equals("")) { takeoffTo = "23:59"; }
				if (!arrivalFrom.equals("") && arrivalTo.equals("")) { arrivalTo = "23:59"; }
				if (!durationFrom.equals("") && durationTo.equals("")) { durationTo = "999"; }
				
				//set queries
					//date query
					String dateQuery = "d.departDate = '" + searchDate + "'";
					if (searchFlexible.equals("searchFlexible")) {
						dateQuery = "d.departDate BETWEEN DATE_ADD('" + searchDate + "', INTERVAL -3 DAY) AND DATE_ADD('" + searchDate + "', INTERVAL 3 DAY)";
					}
					
					//filter queries
					String airlineQuery = "";
					String priceQuery = "";
					String takeoffQuery = "";
					String arrivalQuery = "";
					String durationQuery = "";
					
					boolean filtered = false;
					if (!(priceFrom.concat(priceTo).concat(takeoffFrom).concat(takeoffTo).concat(arrivalFrom).concat(arrivalTo).concat(durationFrom).concat(durationTo)).equals("")) {
						filtered = true;
						
						if (!airlineFilter.equals("")) {
							airlineQuery = "AND f.airlineID = '" + airlineFilter + "'";
						}
						
						if (!priceFrom.equals("") && !priceTo.equals("")) {
							priceQuery = "AND f.price BETWEEN " + priceFrom + " AND " + priceTo;
						}
						
						if (!takeoffFrom.equals("") && !takeoffTo.equals("")) {
							takeoffQuery = "AND d.departTime BETWEEN '" + takeoffFrom + "' AND '" + takeoffTo + "'";
						}
						
						if (!arrivalFrom.equals("") && !arrivalTo.equals("")) {
							arrivalQuery = "AND a.arrivalTime BETWEEN '" + arrivalFrom + "' AND '" + arrivalTo + "'";
						}
						
						if (!durationFrom.equals("") && !durationTo.equals("")) {
							durationQuery = "AND timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) BETWEEN '" + durationFrom + "' AND '" + durationTo + "'";
						}
					}
				
				out.println("Trip type: <b>" + tripType + "</b><br>");
				out.println("Search from: <b>" + searchFrom + "</b><br>");
				out.println("Search to: <b>" + searchTo + "</b><br>");
				out.println("Search date: <b>" + searchDate + "</b><br>");
				/* out.println("Search time: <b>" + searchTime + "</b><br>"); */
				out.println("Search flexible: <b>" + searchFlexible + "</b><br>");
				out.println("Sort by: <b>" + sort + "</b><br>");
				out.println("<br><br>");
				
				//Database connection
				ApplicationDB db = new ApplicationDB();
				Connection con = db.getConnection();
				
				//set general query to get search results
				String query = "SELECT d.airlineID AS 'callsign', f.flightNum AS 'flightNum', d.airportID AS 'from', a.airportID AS 'to', d.departTime AS 'departTime', d.departDate AS 'departDate', a.arrivalTime AS 'arrivalTime', a.arrivalDate AS 'arrivalDate', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration', f.flightType AS 'flightType', f.daysOperating AS 'daysOperating', f.price AS 'price' FROM departs_from d, arrives_at a, flights f WHERE d.airportID = '" + searchFrom + "' and a.airportID = '" + searchTo + "' and " + dateQuery + " and d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum " + sort + ";";
				if (filtered) {
					   query = "SELECT d.airlineID AS 'callsign', f.flightNum AS 'flightNum', d.airportID AS 'from', a.airportID AS 'to', d.departTime AS 'departTime', d.departDate AS 'departDate', a.arrivalTime AS 'arrivalTime', a.arrivalDate AS 'arrivalDate', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration', f.flightType AS 'flightType', f.daysOperating AS 'daysOperating', f.price AS 'price' FROM departs_from d, arrives_at a, flights f WHERE d.airportID = '" + searchFrom + "' and a.airportID = '" + searchTo + "' and " + dateQuery + " and d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum " + airlineQuery + " " + priceQuery + " " + takeoffQuery + " " + arrivalQuery + " " + durationQuery + " " + sort + ";";
				}
				
				Statement stmt = con.createStatement();
				ResultSet result = stmt.executeQuery(query);
				
				if (result.next()) {
					String callsign = result.getString("callsign");
					String flightNum = result.getString("flightNum");
					String from = result.getString("from");
					String to = result.getString("to");
					String departTime = result.getString("departTime");
					String departDate = result.getString("departDate");
					String arrivalTime = result.getString("arrivalTime");
					String arrivalDate = result.getString("arrivalDate");
					String duration = result.getString("duration");
					String flightType = result.getString("flightType");
					String daysOperating = result.getString("daysOperating");
					String price = result.getString("price");
						
					out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Flight type</th><th>Days operating</th><th>Price</th><th>Book</th></tr>");
					out.println("<tr><td>" + callsign + "</td><td>" + flightNum + "</td><td>" + from + "</td><td>" + to + "</td><td>" + departTime + "</td><td>" + departDate + "</td><td>" + arrivalTime + "</td><td>" + arrivalDate + "</td><td>" + duration + "</td><td>" + flightType + "</td><td>" + daysOperating + "</td><td>" + price + "</td><td><a href=\"\">Book</a></td></tr>");
					
					/* out.println("<h1>results found: validation</h1>");
					out.println("<p>callsign: " + callsign + "</p>");
					out.println("<p>flightNum: " + flightNum + "</p>");
					out.println("<p>from: " + from + "</p>");
					out.println("<p>to: " + to + "</p>");
					out.println("<p>departTime: " + departTime + "</p>");
					out.println("<p>departDate: " + departDate + "</p>");
					out.println("<p>arrivalTime: " + arrivalTime + "</p>");
					out.println("<p>arrivalDate: " + arrivalDate + "</p>");
					out.println("<p>flightType: " + flightType + "</p>");
					out.println("<p>daysOperating: " + daysOperating + "</p>");
					out.println("<p>price: " + price + "</p>"); */
					
						while (result.next()) {
							callsign = result.getString("callsign");
							flightNum = result.getString("flightNum");
							from = result.getString("from");
							to = result.getString("to");
							departTime = result.getString("departTime");
							departDate = result.getString("departDate");
							arrivalTime = result.getString("arrivalTime");
							arrivalDate = result.getString("arrivalDate");
							duration = result.getString("duration");
							flightType = result.getString("flightType");
							daysOperating = result.getString("daysOperating");
							price = result.getString("price");
							
							out.println("<tr><td>" + callsign + "</td><td>" + flightNum + "</td><td>" + from + "</td><td>" + to + "</td><td>" + departTime + "</td><td>" + departDate + "</td><td>" + arrivalTime + "</td><td>" + arrivalDate + "</td><td>" + duration + "</td><td>" + flightType + "</td><td>" + daysOperating + "</td><td>" + price + "</td><td><a href=\"\">Book</a></td></tr>");
						}
					
					out.println("</table>");
					
				} else {
					out.println("<h1>no results found</h1>");
				}
				
			} catch(Exception e) {
				out.print(e);
			}
		%>
		
		
		<br><br>
		<h3>Testing table</h3>
		<table>
			<tr>
				<th>Call sign</th>
				<th>Flight number</th>
				<th>From</th>
				<th>To</th>
				<th>Depart time</th>
				<th>Depart date</th>
				<th>Arrival time</th>
				<th>Arrival date</th>
				<th>Flight type</th>
				<th>Days operating</th>
				<th>Price</th>
			</tr>
		</table>
		
		<br><br>
		
		<table>
			<tr>
				<th>From</th>
				<th>To</th>
				<th>Date</th>
				<th>Departure time</th>
				<th>Arrival time</th>
				<th>Duration</th>
				<th>Book</th>
			</tr>
			<tr>
				<td>TEST</td>
				<td>TEST</td>
				<td>12/31/2021</td>
				<td>14:34</td>
				<td>19:44</td>
				<td>5.17 hours</td>
				<td><a href="">Book ticket</a></td>
			</tr>
			<tr>
				<td>TEST</td>
				<td>TEST</td>
				<td>12/15/2021</td>
				<td>04:56</td>
				<td>11:12</td>
				<td>6.27 hours</td>
				<td><a href="">Book ticket</a></td>
			</tr>
		</table>
		
		<h1>Search results (second leg)</h1>
		<table>
			<tr>
				<th>From</th>
				<th>To</th>
				<th>Date</th>
				<th>Departure time</th>
				<th>Arrival time</th>
				<th>Book</th>
			</tr>
		</table> --%>
	</body>
</html>