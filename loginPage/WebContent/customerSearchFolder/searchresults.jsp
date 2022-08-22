<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="../stylesheet.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Search results</title>
	</head>
	<body>
		<a href="javascript:history.back()">Back to search</a>
		<h1>Search results (outbound flight)</h1>
		<%
			try {
				//Database connection
				ApplicationDB db = new ApplicationDB();
				Connection con = db.getConnection();
				
				////////////////////////////////////////////////////////////////////////////////
				
				//search
				String tripType = request.getParameter("tripType");
				String searchFrom = request.getParameter("searchFrom");//.toUpperCase();
				String searchTo = request.getParameter("searchTo");//.toUpperCase();
				String searchDate = request.getParameter("searchDate");
				String searchReturnDate = request.getParameter("searchReturnDate");
				String searchFlexible = request.getParameter("tripFlexible");
				
				//determine trip type
				boolean roundTrip = false;
				if (tripType.equals("roundTrip")) {
					roundTrip = true;
				}
				
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
				String stopsFrom = request.getParameter("filterStopsFrom");
				String stopsTo = request.getParameter("filterStopsTo");
				
				//default "from" values when "to" is NOT empty
				if (priceFrom.equals("") && !priceTo.equals("")) { priceFrom = "0"; }
				if (takeoffFrom.equals("") && !takeoffTo.equals("")) { takeoffFrom = "00:00"; }
				if (arrivalFrom.equals("") && !arrivalTo.equals("")) { arrivalFrom = "00:00"; }
				if (durationFrom.equals("") && !durationTo.equals("")) { durationFrom = "00:00"; }
				if (stopsFrom.equals("") && !stopsTo.equals("")) { stopsFrom = "0"; }
				
				//default "to" values when "from" is NOT empty
				if (!priceFrom.equals("") && priceTo.equals("")) { priceTo = "9999"; }
				if (!takeoffFrom.equals("") && takeoffTo.equals("")) { takeoffTo = "23:59"; }
				if (!arrivalFrom.equals("") && arrivalTo.equals("")) { arrivalTo = "23:59"; }
				if (!durationFrom.equals("") && durationTo.equals("")) { durationTo = "999"; }
				if (!stopsFrom.equals("") && stopsTo.equals("")) { stopsTo = "4"; }
				
				//validate stops filter in case both are empty
				if (stopsFrom.equals("") && stopsTo.equals("")) { stopsFrom = "0"; stopsTo = "4"; }
				
				//determine flexibility
				boolean flexible = false;
				if (searchFlexible.equals("searchFlexible")) {
					flexible = true;
				}
				
				//IMPORTANT TO-DO: FILTER QUERIES ALSO BASED ON STOPS AND CONNECTION TIME
				
				//filter queries
				String airlineQuery = ""; String priceQuery = ""; String takeoffQuery = ""; String arrivalQuery = ""; String durationQuery = ""; String stopsQuery = ""; String connectionTimeQuery = "";
				
				boolean filtered = false;
				if (!(priceFrom.concat(priceTo).concat(takeoffFrom).concat(takeoffTo).concat(arrivalFrom).concat(arrivalTo).concat(durationFrom).concat(durationTo)).equals("")) {
					filtered = true;
					if (!priceFrom.equals("") && !priceTo.equals("")) {
						priceQuery = "AND totalPrice BETWEEN " + priceFrom + " AND " + priceTo;
					}
					if (!takeoffFrom.equals("") && !takeoffTo.equals("")) {
						takeoffQuery = "AND departTime BETWEEN '" + takeoffFrom + "' AND '" + takeoffTo + "'";
					}
					if (!arrivalFrom.equals("") && !arrivalTo.equals("")) {
						arrivalQuery = "AND arrivalTime BETWEEN '" + arrivalFrom + "' AND '" + arrivalTo + "'";
					}
					if (!durationFrom.equals("") && !durationTo.equals("")) {
						durationQuery = "AND duration BETWEEN '" + durationFrom + "' AND '" + durationTo + "'";
					}
				}
				
				////////////////////////////////////////////////////////////////////////////////
				
				//IMPORTANT!
				String bookingRedirect = "../selectclass.jsp";
				
				//1. 	standard one-way
				//1_r.	standard round trip
				//3.	flexible one-way
				//3_r.	flexible round trip
				
				String callsign = ""; String flightNum = ""; String from = ""; String to = ""; String departTime = ""; String departDate = ""; String arrivalTime = ""; String arrivalDate = ""; String duration = ""; String totalDuration = ""; String flightType = ""; String price = ""; String totalPrice = "";
				
				if (!flexible) { //1. standard one-way
					out.println("<form action=\"" + bookingRedirect + "\" method=\"post\">");
					
					if (Integer.valueOf(stopsFrom) <= 0 && Integer.valueOf(stopsTo) >= 0) {
					
						if (!airlineFilter.equals("")) {
							airlineQuery = " and d.airlineID = '" + airlineFilter + "' ";
						} else {
							airlineQuery = "";
						}
						
						String priceQuerySingle = "";
						if (!priceQuery.equals("")) {
							priceQuerySingle = " and f.price between " + priceFrom + " and " + priceTo;
						}
						
						String query1 = "select d.airlineID as 'callsign', f.flightNum as 'flightNum', d.airportID as 'from', a.airportID as 'to', d.departTime as 'departTime', d.departDate as 'departDateOrig', a.arrivalTime as 'arrivalTime', a.arrivalDate as 'arrivalDateOrig', '" + searchDate + "' as 'departDateAdj', date_add('" + searchDate + "', interval (datediff(a.arrivalDate, d.departDate)) day) as 'arrivalDateAdj', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'totalDuration', dayname(d.departDate) as 'dayOperating', f.flightType as 'flightType', f.price as 'price', f.price as 'totalPrice' from departs_from d, arrives_at a, flights f where d.airportID = '" + searchFrom + "' and a.airportID = '" + searchTo + "' and d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum " + airlineQuery + " " + priceQuerySingle + " " + takeoffQuery + " " + arrivalQuery + " " + durationQuery + " " + " having dayname(d.departDate) = dayname('" + searchDate + "') " + " " + sort + ";";
						Statement stmt1 = con.createStatement();
						ResultSet result1 = stmt1.executeQuery(query1);
						
						if (result1.next()) {
							callsign = result1.getString("callsign");
							flightNum = result1.getString("flightNum");
							from = result1.getString("from");
							to = result1.getString("to");
							departTime = result1.getString("departTime");
							departDate = result1.getString("departDateAdj");
							arrivalTime = result1.getString("arrivalTime");
							arrivalDate = result1.getString("arrivalDateAdj");
							duration = result1.getString("duration");
							totalDuration = result1.getString("totalDuration");
							price = result1.getString("price");
							totalPrice = result1.getString("totalPrice");
							flightType = result1.getString("flightType");
							
							if (flightType.equals("i")) {
								flightType = "international";
							} else {
								flightType = "domestic";
							}
							
							out.println("<h2>Direct flights</h2>");
							out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
							out.println("<tr><td>" + callsign + "</td><td>" + flightNum + "</td><td>" + from + "</td><td>" + to + "</td><td>" +  "0" + "</td><td>" + departTime + "</td><td>" + departDate + "</td><td>" + arrivalTime + "</td><td>" + arrivalDate + "</td><td>" + duration + "</td><td>" + totalDuration + "</td><td>" + flightType + "</td><td>$" + price + "</td><td>$" + totalPrice + "</td><td><input type=\"radio\" name=\"outbound\" value=\"__1____outbound____flight1__" + callsign + "_" + flightNum + "_" + from + "_" + to + "_" + departDate + "_" + arrivalDate + "_" + price + "\"><label>Book</label><br></td></tr>");
							
							while (result1.next()) {
								callsign = result1.getString("callsign");
								flightNum = result1.getString("flightNum");
								from = result1.getString("from");
								to = result1.getString("to");
								departTime = result1.getString("departTime");
								departDate = result1.getString("departDateAdj");
								arrivalTime = result1.getString("arrivalTime");
								arrivalDate = result1.getString("arrivalDateAdj");
								duration = result1.getString("duration");
								totalDuration = result1.getString("totalDuration");
								price = result1.getString("price");
								totalPrice = result1.getString("totalPrice");
								flightType = result1.getString("flightType");
								
								if (flightType.equals("i")) {
									flightType = "international";
								} else {
									flightType = "domestic";
								}
								
								out.println("<tr><td>" + callsign + "</td><td>" + flightNum + "</td><td>" + from + "</td><td>" + to + "</td><td>" +  "0" + "</td><td>" + departTime + "</td><td>" + departDate + "</td><td>" + arrivalTime + "</td><td>" + arrivalDate + "</td><td>" + duration + "</td><td>" + totalDuration + "</td><td>" + flightType + "</td><td>$" + price + "</td><td>$" + totalPrice + "</td><td><input type=\"radio\" name=\"outbound\" value=\"__1____outbound____flight1__" + callsign + "_" + flightNum + "_" + from + "_" + to + "_" + departDate + "_" + arrivalDate + "_" + price + "\"><label>Book</label><br></td></tr>");
							}
							
							out.println("</table>");
						}
					}
					
					/////////////////////////////////////////////////////////////////
					//check if connecting flights (1 connection)
					if (Integer.valueOf(stopsFrom) <= 1 && Integer.valueOf(stopsTo) >= 1) {
						String query1_c2_a = "create temporary table c1( select d.airlineID as 'callsign', f.flightNum as 'flightNum', d.airportID as 'from', a.airportID as 'to', d.departDate as 'departDateOrig', a.arrivalDate as 'arrivalDateOrig', '" + searchDate + "' as 'departDateAdj', d.departTime as 'departTime', date_add('" + searchDate + "', interval (datediff(a.arrivalDate, d.departDate)) day) as 'arrivalDateAdj', a.arrivalTime as 'arrivalTime', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration', dayname(d.departDate) as 'dayOperating', f.flightType as 'flightType', f.price as 'price' from departs_from d, arrives_at a, flights f where d.airportID = '" + searchFrom + "' and d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum having dayname(d.departDate) = dayname('" + searchDate + "') );";
						Statement stmt1_c2_a = con.createStatement();
						stmt1_c2_a.execute(query1_c2_a);
						
						String query1_c2_b = "create temporary table c2( select distinct d.airlineID as 'callsign2', f.flightNum as 'flightNum2', d.airportID as 'from2', a.airportID as 'to2', d.departDate as 'departDateOrig2', a.arrivalDate as 'arrivalDateOrig2', date_add(d.departDate, interval datediff(c1.departDateAdj, c1.departDateOrig) day) as 'departDateAdj2', d.departTime as 'departTime2', date_add(a.arrivalDate, interval datediff('" + searchDate + "', c1.departDateOrig) day) as 'arrivalDateAdj2', a.arrivalTime as 'arrivalTime2', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration2', dayname(d.departDate) as 'dayOperating2', f.flightType as 'flightType2', f.price as 'price2' from departs_from d, arrives_at a, flights f, c1 where a.airportID = '" + searchTo + "' and d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum );";
						Statement stmt1_c2_b = con.createStatement();
						stmt1_c2_b.execute(query1_c2_b);
						
						String query1_c2_c = "create temporary table c3( select *, timestampdiff(hour, timestamp(c1.arrivalDateAdj, c1.arrivalTime), timestamp(c2.departDateAdj2, c2.departTime2)) as 'connectionTime2', (price + price2) as 'totalPrice', (cast((addtime(duration, duration2)) as decimal) / 10000) as 'totalDuration' from c1 join c2 on (timestampdiff(hour, timestamp(c1.arrivalDateAdj, c1.arrivalTime), timestamp(c2.departDateAdj2, c2.departTime2)) between 0 and 24) and (c2.from2 <> c1.`from`) and (c2.from2 = c1.`to`) );";
						Statement stmt1_c2_c = con.createStatement();
						stmt1_c2_c.execute(query1_c2_c);
						
						if (!airlineFilter.equals("")) {
							airlineQuery = " and callsign = '" + airlineFilter + "' and callsign2 = '" + airlineFilter + "' ";
						} else {
							airlineQuery = "";
						}
						
						String query1_c2_d = "select * from c3 where callsign <> '' "  + airlineQuery + " " + priceQuery + " " + takeoffQuery + " " + arrivalQuery + " " + durationQuery + " " + sort + ";";
						Statement stmt1_c2_d = con.createStatement();
						ResultSet result1_c2 = stmt1_c2_d.executeQuery(query1_c2_d);
						
						int i_c2_a = 0;
						
						while (result1_c2.next()) {
							if (i_c2_a == 0) {
								out.println("<h2>Up to one stop</h1>");
								out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
							}
							
							callsign = result1_c2.getString("callsign");
							flightNum = result1_c2.getString("flightNum");
							from = result1_c2.getString("from");
							to = result1_c2.getString("to");
							departTime = result1_c2.getString("departTime");
							departDate = result1_c2.getString("departDateAdj");
							arrivalTime = result1_c2.getString("arrivalTime");
							arrivalDate = result1_c2.getString("arrivalDateAdj");
							duration = result1_c2.getString("duration");
							totalDuration = result1_c2.getString("totalDuration");
							price = result1_c2.getString("price");
							totalPrice = result1_c2.getString("totalPrice");
							flightType = result1_c2.getString("flightType");
							if (flightType.equals("i")) { flightType = "international"; } else { flightType = "domestic"; }
							
							String callsign2 = result1_c2.getString("callsign2");
							String flightNum2 = result1_c2.getString("flightNum2");
							String from2 = result1_c2.getString("from2");
							String to2 = result1_c2.getString("to2");
							String departTime2 = result1_c2.getString("departTime2");
							String departDate2 = result1_c2.getString("departDateAdj2");
							String arrivalTime2 = result1_c2.getString("arrivalTime2");
							String arrivalDate2 = result1_c2.getString("arrivalDateAdj2");
							String duration2 = result1_c2.getString("duration2");
							String price2 = result1_c2.getString("price2");
							String flightType2 = result1_c2.getString("flightType2");
							if (flightType2.equals("i")) { flightType2 = "international"; } else { flightType2 = "domestic"; }
							
							out.println("<tr><td>" + callsign + "</td><td>" + flightNum + "</td><td>" + from + "</td><td>" + to + "</td><td>" +  "1" + "</td><td>" + departTime + "</td><td>" + departDate + "</td><td>" + arrivalTime + "</td><td>" + arrivalDate + "</td><td>" + duration + "</td><td>" + totalDuration + "</td><td>" + flightType + "</td><td>$" + price + "</td><td>$" + totalPrice + "</td><td><input type=\"radio\" name=\"outbound\" value=\"__2____outbound____flight1__" + callsign + "_" + flightNum + "_" + from + "_" + to + "_" + departDate + "_" + arrivalDate + "_" + price + "__flight2__" + callsign2 + "_" + flightNum2 + "_" + from2 + "_" + to2 + "_" + departDate2 + "_" + arrivalDate2 + "_" + price2 + "\"><label>Book</label><br></td></tr>");
							
							// out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
							out.println("<tr class=\"connection\"><td>" + callsign2 + "</td><td>" + flightNum2 + "</td><td>" + from2 + "</td><td>" + to2 + "</td><td>" +  "" + "</td><td>" + departTime2 + "</td><td>" + departDate2 + "</td><td>" + arrivalTime2 + "</td><td>" + arrivalDate2 + "</td><td>" + duration2 + "</td><td></td><td>" + flightType2 + "</td><td>$" + price2 + "</td><td></td><td></td></tr>");
							
							i_c2_a++;
						}
						
						out.println("</table>");
					}
					
					/////////////////////////////////////////////////////////////////
					//check if connecting flights (2 connections)
					if (Integer.valueOf(stopsFrom) <= 2 && Integer.valueOf(stopsTo) >= 2) {
						
						String query1_c3_a = "create temporary table d1( select d.airlineID as 'callsign', f.flightNum as 'flightNum', d.airportID as 'from', a.airportID as 'to', d.departDate as 'departDateOrig', a.arrivalDate as 'arrivalDateOrig', '" + searchDate + "' as 'departDateAdj', d.departTime as 'departTime', date_add('" + searchDate + "', interval (datediff(a.arrivalDate, d.departDate)) day) as 'arrivalDateAdj', a.arrivalTime as 'arrivalTime', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration', dayname(d.departDate) as 'dayOperating', f.flightType as 'flightType', f.price as 'price' from departs_from d, arrives_at a, flights f where d.airportID = '" + searchFrom + "' and d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum having dayname(d.departDate) = dayname('" + searchDate + "') );";
						Statement stmt1_c3_a = con.createStatement();
						stmt1_c3_a.execute(query1_c3_a);
						
						String query1_c3_b = "create temporary table d2( select distinct d.airlineID as 'callsign2', f.flightNum as 'flightNum2', d.airportID as 'from2', a.airportID as 'to2', d.departDate as 'departDateOrig2', a.arrivalDate as 'arrivalDateOrig2', date_add(d.departDate, interval datediff(d1.departDateAdj, d1.departDateOrig) day) as 'departDateAdj2', d.departTime as 'departTime2', date_add(a.arrivalDate, interval datediff('" + searchDate + "', d1.departDateOrig) day) as 'arrivalDateAdj2', a.arrivalTime as 'arrivalTime2', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration2', dayname(d.departDate) as 'dayOperating2', f.flightType as 'flightType2', f.price as 'price2' from departs_from d, arrives_at a, flights f, d1 where d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum );";
						Statement stmt1_c3_b = con.createStatement();
						stmt1_c3_b.execute(query1_c3_b);
						
						String query1_c3_c = "create temporary table d3( select *, timestampdiff(hour, timestamp(d1.arrivalDateAdj, d1.arrivalTime), timestamp(d2.departDateAdj2, d2.departTime2)) as 'connectionTime2' from d1 join d2 on (timestampdiff(hour, timestamp(d1.arrivalDateAdj, d1.arrivalTime), timestamp(d2.departDateAdj2, d2.departTime2)) between 0 and 24) );";
						Statement stmt1_c3_c = con.createStatement();
						stmt1_c3_c.execute(query1_c3_c);
						
						String query1_c3_d = "create temporary table d4( select distinct d.airlineID as 'callsign3', f.flightNum as 'flightNum3', d3.to2 as 'from3', a.airportID as 'to3', d.departDate as 'departDateOrig3', a.arrivalDate as 'arrivalDateOrig3', date_add(d.departDate, interval datediff(d1.departDateAdj, d1.departDateOrig) day) as 'departDateAdj3', d.departTime as 'departTime3', date_add(a.arrivalDate, interval datediff('" + searchDate + "', d1.departDateOrig) day) as 'arrivalDateAdj3', a.arrivalTime as 'arrivalTime3', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration3', dayname(d.departDate) as 'dayOperating3', f.flightType as 'flightType3', f.price as 'price3' from departs_from d, arrives_at a, flights f, d1, d3 where a.airportID = '" + searchTo + "' and d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum );";
						Statement stmt1_c3_d = con.createStatement();
						stmt1_c3_d.execute(query1_c3_d);
						
						String query1_c3_e = "create temporary table d5( select *, timestampdiff(hour, timestamp(d3.arrivalDateAdj2, d3.arrivalTime2), timestamp(d4.departDateAdj3, d4.departTime3)) as 'connectionTime3' from d3 join d4 on (timestampdiff(hour, timestamp(d3.arrivalDateAdj2, d3.arrivalTime2), timestamp(d4.departDateAdj3, d4.departTime3)) between 0 and 24) );";
						Statement stmt1_c3_e = con.createStatement();
						stmt1_c3_e.execute(query1_c3_e);
						
						String query1_c3_f = "create temporary table d6( select *, (price + price2 + price3) as 'totalPrice', (cast((addtime(addtime(duration, duration2), duration3)) as decimal) / 10000) as 'totalDuration' from d5 where (`to` = from2) and (to2 = from3) and (from2 <> '" + searchTo + "') and (from3 <> '" + searchTo + "') and (from2 <> to3) );";
						Statement stmt1_c3_f = con.createStatement();
						stmt1_c3_f.execute(query1_c3_f);
						
						if (!airlineFilter.equals("")) {
							airlineQuery = " and callsign = '" + airlineFilter + "' and callsign2 = '" + airlineFilter + "' and callsign3 = '" + airlineFilter + "' ";
						} else {
							airlineQuery = "";
						}
						
						String query1_c3_g = "select * from d6 where callsign <> '' " + airlineQuery + " " + priceQuery + " " + takeoffQuery + " " + arrivalQuery + " " + durationQuery + " " + sort + ";";
						Statement stmt1_c3_g = con.createStatement();
						ResultSet result1_c3 = stmt1_c3_g.executeQuery(query1_c3_g);
						
						int i_c3_a = 0;
						
						while (result1_c3.next()) {
							if (i_c3_a == 0) {
								out.println("<h2>Up to two stops</h1>");
								out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
							}
							
							callsign = result1_c3.getString("callsign");
							flightNum = result1_c3.getString("flightNum");
							from = result1_c3.getString("from");
							to = result1_c3.getString("to");
							departTime = result1_c3.getString("departTime");
							departDate = result1_c3.getString("departDateAdj");
							arrivalTime = result1_c3.getString("arrivalTime");
							arrivalDate = result1_c3.getString("arrivalDateAdj");
							duration = result1_c3.getString("duration");
							totalDuration = result1_c3.getString("totalDuration");
							price = result1_c3.getString("price");
							totalPrice = result1_c3.getString("totalPrice");
							flightType = result1_c3.getString("flightType");
							if (flightType.equals("i")) { flightType = "international"; } else { flightType = "domestic"; }
							
							String callsign2 = result1_c3.getString("callsign2");
							String flightNum2 = result1_c3.getString("flightNum2");
							String from2 = result1_c3.getString("from2");
							String to2 = result1_c3.getString("to2");
							String departTime2 = result1_c3.getString("departTime2");
							String departDate2 = result1_c3.getString("departDateAdj2");
							String arrivalTime2 = result1_c3.getString("arrivalTime2");
							String arrivalDate2 = result1_c3.getString("arrivalDateAdj2");
							String duration2 = result1_c3.getString("duration2");
							String price2 = result1_c3.getString("price2");
							String flightType2 = result1_c3.getString("flightType2");
							if (flightType2.equals("i")) { flightType2 = "international"; } else { flightType2 = "domestic"; }
							
							String callsign3 = result1_c3.getString("callsign3");
							String flightNum3 = result1_c3.getString("flightNum3");
							String from3 = result1_c3.getString("from3");
							String to3 = result1_c3.getString("to3");
							String departTime3 = result1_c3.getString("departTime3");
							String departDate3 = result1_c3.getString("departDateAdj3");
							String arrivalTime3 = result1_c3.getString("arrivalTime3");
							String arrivalDate3 = result1_c3.getString("arrivalDateAdj3");
							String duration3 = result1_c3.getString("duration3");
							String price3 = result1_c3.getString("price3");
							String flightType3 = result1_c3.getString("flightType3");
							if (flightType3.equals("i")) { flightType3 = "international"; } else { flightType3 = "domestic"; }
							
							out.println("<tr><td>" + callsign + "</td><td>" + flightNum + "</td><td>" + from + "</td><td>" + to + "</td><td>" +  "2" + "</td><td>" + departTime + "</td><td>" + departDate + "</td><td>" + arrivalTime + "</td><td>" + arrivalDate + "</td><td>" + duration + "</td><td>" + totalDuration + "</td><td>" + flightType + "</td><td>$" + price + "</td><td>$" + totalPrice + "</td></td><td><input type=\"radio\" name=\"outbound\" value=\"__3____outbound____flight1__" + callsign + "_" + flightNum + "_" + from + "_" + to + "_" + departDate + "_" + arrivalDate + "_" + price + "__flight2__" + callsign2 + "_" + flightNum2 + "_" + from2 + "_" + to2 + "_" + departDate2 + "_" + arrivalDate2 + "_" + price2 + "__flight3__" + callsign3 + "_" + flightNum3 + "_" + from3 + "_" + to3 + "_" + departDate3 + "_" + arrivalDate3 + "_" + price3 + "\"><label>Book</label><br></td></tr>");
							// out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
							out.println("<tr class=\"connection\"><td>" + callsign2 + "</td><td>" + flightNum2 + "</td><td>" + from2 + "</td><td>" + to2 + "</td><td>" +  "" + "</td><td>" + departTime2 + "</td><td>" + departDate2 + "</td><td>" + arrivalTime2 + "</td><td>" + arrivalDate2 + "</td><td>" + duration2 + "</td><td></td><td>" + flightType2 + "</td><td>$" + price2 + "</td><td></td><td></td></tr>");
							// out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
							out.println("<tr class=\"connection\"><td>" + callsign3 + "</td><td>" + flightNum3 + "</td><td>" + from3 + "</td><td>" + to3 + "</td><td>" +  "" + "</td><td>" + departTime3 + "</td><td>" + departDate3 + "</td><td>" + arrivalTime3 + "</td><td>" + arrivalDate3 + "</td><td>" + duration3 + "</td><td></td><td>" + flightType3 + "</td><td>$" + price3 + "</td><td></td><td></td></tr>");
							
							i_c3_a++;
						}
						
						out.println("</table>");
					}
					
					/////////////////////////////////////////////////////////////////
					
					if (!roundTrip) {
						//out.println("<br><input type=\"submit\" value=\"Proceed to booking\"/>");
						//out.println("</form>");
					} else { //1_r. standard round trip
						out.println("<h1>Search results (return flight)</h1>");
					
						if (Integer.valueOf(stopsFrom) <= 0 && Integer.valueOf(stopsTo) >= 0) {
						
							if (!airlineFilter.equals("")) {
								airlineQuery = " and d.airlineID = '" + airlineFilter + "' ";
							} else {
								airlineQuery = "";
							}
							
							String priceQuerySingle = "";
							if (!priceQuery.equals("")) {
								priceQuerySingle = " and f.price between " + priceFrom + " and " + priceTo;
							}
						
							String query1_r = "select d.airlineID as 'callsign', f.flightNum as 'flightNum', d.airportID as 'from', a.airportID as 'to', d.departTime as 'departTime', d.departDate as 'departDateOrig', a.arrivalTime as 'arrivalTime', a.arrivalDate as 'arrivalDateOrig', '" + searchReturnDate + "' as 'departDateAdj', date_add('" + searchReturnDate + "', interval (datediff(a.arrivalDate, d.departDate)) day) as 'arrivalDateAdj', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'totalDuration', dayname(d.departDate) as 'dayOperating', f.flightType as 'flightType', f.price as 'price', f.price as 'totalPrice' from departs_from d, arrives_at a, flights f where d.airportID = '" + searchTo + "' and a.airportID = '" + searchFrom + "' and d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum " + airlineQuery + " " + priceQuerySingle + " " + takeoffQuery + " " + arrivalQuery + " " + durationQuery + " having dayname(d.departDate) = dayname('" + searchReturnDate + "') " + sort + ";";
							Statement stmt1_r = con.createStatement();
							ResultSet result1_r = stmt1_r.executeQuery(query1_r);
							
							if (result1_r.next()) {
								callsign = result1_r.getString("callsign");
								flightNum = result1_r.getString("flightNum");
								from = result1_r.getString("from");
								to = result1_r.getString("to");
								departTime = result1_r.getString("departTime");
								departDate = result1_r.getString("departDateAdj");
								arrivalTime = result1_r.getString("arrivalTime");
								arrivalDate = result1_r.getString("arrivalDateAdj");
								duration = result1_r.getString("duration");
								totalDuration = result1_r.getString("totalDuration");
								price = result1_r.getString("price");
								totalPrice = result1_r.getString("totalPrice");
								flightType = result1_r.getString("flightType");
								
								if (flightType.equals("i")) {
									flightType = "international";
								} else {
									flightType = "domestic";
								}
								
								out.println("<h2>Direct flights</h2>");
								out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
								out.println("<tr><td>" + callsign + "</td><td>" + flightNum + "</td><td>" + from + "</td><td>" + to + "</td><td>" +  "0" + "</td><td>" + departTime + "</td><td>" + departDate + "</td><td>" + arrivalTime + "</td><td>" + arrivalDate + "</td><td>" + duration + "</td><td>" + totalDuration + "</td><td>" + flightType + "</td><td>$" + price + "</td><td>$" + totalPrice + "</td></td><td><input type=\"radio\" name=\"return\" value=\"__1____return____flight1__" + callsign + "_" + flightNum + "_" + from + "_" + to + "_" + departDate + "_" + arrivalDate + "_" + price + "\"><label>Book</label><br></td></tr>");
								
								while (result1_r.next()) {
									callsign = result1_r.getString("callsign");
									flightNum = result1_r.getString("flightNum");
									from = result1_r.getString("from");
									to = result1_r.getString("to");
									departTime = result1_r.getString("departTime");
									departDate = result1_r.getString("departDateAdj");
									arrivalTime = result1_r.getString("arrivalTime");
									arrivalDate = result1_r.getString("arrivalDateAdj");
									duration = result1_r.getString("duration");
									totalDuration = result1_r.getString("totalDuration");
									price = result1_r.getString("price");
									totalPrice = result1_r.getString("totalPrice");
									flightType = result1_r.getString("flightType");
									
									if (flightType.equals("i")) {
										flightType = "international";
									} else {
										flightType = "domestic";
									}
									
									out.println("<tr><td>" + callsign + "</td><td>" + flightNum + "</td><td>" + from + "</td><td>" + to + "</td><td>" +  "0" + "</td><td>" + departTime + "</td><td>" + departDate + "</td><td>" + arrivalTime + "</td><td>" + arrivalDate + "</td><td>" + duration + "</td><td>" + totalDuration + "</td><td>" + flightType + "</td><td>$" + price + "</td><td>$" + totalPrice + "</td></td><td><input type=\"radio\" name=\"return\" value=\"__1____return____flight1__" + callsign + "_" + flightNum + "_" + from + "_" + to + "_" + departDate + "_" + arrivalDate + "_" + price + "\"><label>Book</label><br></td></tr>");
								}
								
								out.println("</table>");
								//out.println("<br><input type=\"submit\" value=\"Proceed to booking\"/>");
								//out.println("</form>");
							}
							
					/////////////////////////////////////////////////////////////////
					//check if connecting flights (1 connection)
					if (Integer.valueOf(stopsFrom) <= 1 && Integer.valueOf(stopsTo) >= 1) {
						String query1_r_c2_a = "create temporary table c1_r( select d.airlineID as 'callsign', f.flightNum as 'flightNum', d.airportID as 'from', a.airportID as 'to', d.departDate as 'departDateOrig', a.arrivalDate as 'arrivalDateOrig', '" + searchReturnDate + "' as 'departDateAdj', d.departTime as 'departTime', date_add('" + searchReturnDate + "', interval (datediff(a.arrivalDate, d.departDate)) day) as 'arrivalDateAdj', a.arrivalTime as 'arrivalTime', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration', dayname(d.departDate) as 'dayOperating', f.flightType as 'flightType', f.price as 'price' from departs_from d, arrives_at a, flights f where d.airportID = '" + searchTo + "' and d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum having dayname(d.departDate) = dayname('" + searchReturnDate + "') );";
						Statement stmt1_r_c2_a = con.createStatement();
						stmt1_r_c2_a.execute(query1_r_c2_a);
						
						String query1_r_c2_b = "create temporary table c2_r( select distinct d.airlineID as 'callsign2', f.flightNum as 'flightNum2', d.airportID as 'from2', a.airportID as 'to2', d.departDate as 'departDateOrig2', a.arrivalDate as 'arrivalDateOrig2', date_add(d.departDate, interval datediff(c1_r.departDateAdj, c1_r.departDateOrig) day) as 'departDateAdj2', d.departTime as 'departTime2', date_add(a.arrivalDate, interval datediff('" + searchReturnDate + "', c1_r.departDateOrig) day) as 'arrivalDateAdj2', a.arrivalTime as 'arrivalTime2', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration2', dayname(d.departDate) as 'dayOperating2', f.flightType as 'flightType2', f.price as 'price2' from departs_from d, arrives_at a, flights f, c1_r where a.airportID = '" + searchFrom + "' and d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum );";
						Statement stmt1_r_c2_b = con.createStatement();
						stmt1_r_c2_b.execute(query1_r_c2_b);
						
						String query1_r_c2_c = "create temporary table c3_r( select *, timestampdiff(hour, timestamp(c1_r.arrivalDateAdj, c1_r.arrivalTime), timestamp(c2_r.departDateAdj2, c2_r.departTime2)) as 'connectionTime2', (price + price2) as 'totalPrice', (cast((addtime(duration, duration2)) as decimal) / 10000) as 'totalDuration' from c1_r join c2_r on (timestampdiff(hour, timestamp(c1_r.arrivalDateAdj, c1_r.arrivalTime), timestamp(c2_r.departDateAdj2, c2_r.departTime2)) between 0 and 24) and (c2_r.from2 <> c1_r.`from`) and (c2_r.from2 = c1_r.`to`) );";
						Statement stmt1_r_c2_c = con.createStatement();
						stmt1_r_c2_c.execute(query1_r_c2_c);
						
						if (!airlineFilter.equals("")) {
							airlineQuery = " and callsign = '" + airlineFilter + "' and callsign2 = '" + airlineFilter + "' ";
						} else {
							airlineQuery = "";
						}
						
						String query1_r_c2_d = "select * from c3_r where callsign <> '' "  + airlineQuery + " " + priceQuery + " " + takeoffQuery + " " + arrivalQuery + " " + durationQuery + " " + sort + ";";
						Statement stmt1_r_c2_d = con.createStatement();
						ResultSet result1_r_c2 = stmt1_r_c2_d.executeQuery(query1_r_c2_d);
						
						int i_r_c2_a = 0;
						
						while (result1_r_c2.next()) {
							if (i_r_c2_a == 0) {
								out.println("<h2>Up to one stop</h1>");
								out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
							}
							
							callsign = result1_r_c2.getString("callsign");
							flightNum = result1_r_c2.getString("flightNum");
							from = result1_r_c2.getString("from");
							to = result1_r_c2.getString("to");
							departTime = result1_r_c2.getString("departTime");
							departDate = result1_r_c2.getString("departDateAdj");
							arrivalTime = result1_r_c2.getString("arrivalTime");
							arrivalDate = result1_r_c2.getString("arrivalDateAdj");
							duration = result1_r_c2.getString("duration");
							totalDuration = result1_r_c2.getString("totalDuration");
							price = result1_r_c2.getString("price");
							totalPrice = result1_r_c2.getString("totalPrice");
							flightType = result1_r_c2.getString("flightType");
							if (flightType.equals("i")) { flightType = "international"; } else { flightType = "domestic"; }
							
							String callsign2 = result1_r_c2.getString("callsign2");
							String flightNum2 = result1_r_c2.getString("flightNum2");
							String from2 = result1_r_c2.getString("from2");
							String to2 = result1_r_c2.getString("to2");
							String departTime2 = result1_r_c2.getString("departTime2");
							String departDate2 = result1_r_c2.getString("departDateAdj2");
							String arrivalTime2 = result1_r_c2.getString("arrivalTime2");
							String arrivalDate2 = result1_r_c2.getString("arrivalDateAdj2");
							String duration2 = result1_r_c2.getString("duration2");
							String price2 = result1_r_c2.getString("price2");
							String flightType2 = result1_r_c2.getString("flightType2");
							if (flightType2.equals("i")) { flightType2 = "international"; } else { flightType2 = "domestic"; }
							
							out.println("<tr><td>" + callsign + "</td><td>" + flightNum + "</td><td>" + from + "</td><td>" + to + "</td><td>" +  "1" + "</td><td>" + departTime + "</td><td>" + departDate + "</td><td>" + arrivalTime + "</td><td>" + arrivalDate + "</td><td>" + duration + "</td><td>" + totalDuration + "</td><td>" + flightType + "</td><td>$" + price + "</td><td>$" + totalPrice + "</td><td><input type=\"radio\" name=\"return\" value=\"__2____return____flight1__" + callsign + "_" + flightNum + "_" + from + "_" + to + "_" + departDate + "_" + arrivalDate + "_" + price + "__flight2__" + callsign2 + "_" + flightNum2 + "_" + from2 + "_" + to2 + "_" + departDate2 + "_" + arrivalDate2 + "_" + price2 + "\"><label>Book</label><br></td></tr>");
							
							// out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
							out.println("<tr class=\"connection\"><td>" + callsign2 + "</td><td>" + flightNum2 + "</td><td>" + from2 + "</td><td>" + to2 + "</td><td>" +  "" + "</td><td>" + departTime2 + "</td><td>" + departDate2 + "</td><td>" + arrivalTime2 + "</td><td>" + arrivalDate2 + "</td><td>" + duration2 + "</td><td></td><td>" + flightType2 + "</td><td>$" + price2 + "</td><td></td><td></td></tr>");
							
							i_r_c2_a++;
						}
						
						out.println("</table>");
					}
					
					/////////////////////////////////////////////////////////////////
					//check if connecting flights (2 connections)
					if (Integer.valueOf(stopsFrom) <= 2 && Integer.valueOf(stopsTo) >= 2) {
						
						String query1_r_c3_a = "create temporary table d1_r( select d.airlineID as 'callsign', f.flightNum as 'flightNum', d.airportID as 'from', a.airportID as 'to', d.departDate as 'departDateOrig', a.arrivalDate as 'arrivalDateOrig', '" + searchReturnDate + "' as 'departDateAdj', d.departTime as 'departTime', date_add('" + searchReturnDate + "', interval (datediff(a.arrivalDate, d.departDate)) day) as 'arrivalDateAdj', a.arrivalTime as 'arrivalTime', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration', dayname(d.departDate) as 'dayOperating', f.flightType as 'flightType', f.price as 'price' from departs_from d, arrives_at a, flights f where d.airportID = '" + searchTo + "' and d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum having dayname(d.departDate) = dayname('" + searchReturnDate + "') );";
						Statement stmt1_r_c3_a = con.createStatement();
						stmt1_r_c3_a.execute(query1_r_c3_a);
						
						String query1_r_c3_b = "create temporary table d2_r( select distinct d.airlineID as 'callsign2', f.flightNum as 'flightNum2', d.airportID as 'from2', a.airportID as 'to2', d.departDate as 'departDateOrig2', a.arrivalDate as 'arrivalDateOrig2', date_add(d.departDate, interval datediff(d1_r.departDateAdj, d1_r.departDateOrig) day) as 'departDateAdj2', d.departTime as 'departTime2', date_add(a.arrivalDate, interval datediff('" + searchReturnDate + "', d1_r.departDateOrig) day) as 'arrivalDateAdj2', a.arrivalTime as 'arrivalTime2', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration2', dayname(d.departDate) as 'dayOperating2', f.flightType as 'flightType2', f.price as 'price2' from departs_from d, arrives_at a, flights f, d1_r where d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum );";
						Statement stmt1_r_c3_b = con.createStatement();
						stmt1_r_c3_b.execute(query1_r_c3_b);
						
						String query1_r_c3_c = "create temporary table d3_r( select *, timestampdiff(hour, timestamp(d1_r.arrivalDateAdj, d1_r.arrivalTime), timestamp(d2_r.departDateAdj2, d2_r.departTime2)) as 'connectionTime2' from d1_r join d2_r on (timestampdiff(hour, timestamp(d1_r.arrivalDateAdj, d1_r.arrivalTime), timestamp(d2_r.departDateAdj2, d2_r.departTime2)) between 0 and 24) );";
						Statement stmt1_r_c3_c = con.createStatement();
						stmt1_r_c3_c.execute(query1_r_c3_c);
						
						String query1_r_c3_d = "create temporary table d4_r( select distinct d.airlineID as 'callsign3', f.flightNum as 'flightNum3', d3_r.to2 as 'from3', a.airportID as 'to3', d.departDate as 'departDateOrig3', a.arrivalDate as 'arrivalDateOrig3', date_add(d.departDate, interval datediff(d1_r.departDateAdj, d1_r.departDateOrig) day) as 'departDateAdj3', d.departTime as 'departTime3', date_add(a.arrivalDate, interval datediff('" + searchReturnDate + "', d1_r.departDateOrig) day) as 'arrivalDateAdj3', a.arrivalTime as 'arrivalTime3', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration3', dayname(d.departDate) as 'dayOperating3', f.flightType as 'flightType3', f.price as 'price3' from departs_from d, arrives_at a, flights f, d1_r, d3_r where a.airportID = '" + searchFrom + "' and d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum );";
						Statement stmt1_r_c3_d = con.createStatement();
						stmt1_r_c3_d.execute(query1_r_c3_d);
						
						String query1_r_c3_e = "create temporary table d5_r( select *, timestampdiff(hour, timestamp(d3_r.arrivalDateAdj2, d3_r.arrivalTime2), timestamp(d4_r.departDateAdj3, d4_r.departTime3)) as 'connectionTime3' from d3_r join d4_r on (timestampdiff(hour, timestamp(d3_r.arrivalDateAdj2, d3_r.arrivalTime2), timestamp(d4_r.departDateAdj3, d4_r.departTime3)) between 0 and 24) );";
						Statement stmt1_r_c3_e = con.createStatement();
						stmt1_r_c3_e.execute(query1_r_c3_e);
						
						String query1_r_c3_f = "create temporary table d6_r( select *, (price + price2 + price3) as 'totalPrice', (cast((addtime(addtime(duration, duration2), duration3)) as decimal) / 10000) as 'totalDuration' from d5_r where (`to` = from2) and (to2 = from3) and (from2 <> '" + searchFrom + "') and (from3 <> '" + searchFrom + "') and (from2 <> to3) );";
						Statement stmt1_r_c3_f = con.createStatement();
						stmt1_r_c3_f.execute(query1_r_c3_f);
						
						if (!airlineFilter.equals("")) {
							airlineQuery = " and callsign = '" + airlineFilter + "' and callsign2 = '" + airlineFilter + "' and callsign3 = '" + airlineFilter + "' ";
						} else {
							airlineQuery = "";
						}
						
						String query1_r_c3_g = "select * from d6_r where callsign <> '' " + airlineQuery + " " + priceQuery + " " + takeoffQuery + " " + arrivalQuery + " " + durationQuery + " " + sort + ";";
						Statement stmt1_r_c3_g = con.createStatement();
						ResultSet result1_r_c3 = stmt1_r_c3_g.executeQuery(query1_r_c3_g);
						
						int i_r_c3_a = 0;
						
						while (result1_r_c3.next()) {
							if (i_r_c3_a == 0) {
								out.println("<h2>Up to two stops</h1>");
								out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
							}
							
							callsign = result1_r_c3.getString("callsign");
							flightNum = result1_r_c3.getString("flightNum");
							from = result1_r_c3.getString("from");
							to = result1_r_c3.getString("to");
							departTime = result1_r_c3.getString("departTime");
							departDate = result1_r_c3.getString("departDateAdj");
							arrivalTime = result1_r_c3.getString("arrivalTime");
							arrivalDate = result1_r_c3.getString("arrivalDateAdj");
							duration = result1_r_c3.getString("duration");
							totalDuration = result1_r_c3.getString("totalDuration");
							price = result1_r_c3.getString("price");
							totalPrice = result1_r_c3.getString("totalPrice");
							flightType = result1_r_c3.getString("flightType");
							if (flightType.equals("i")) { flightType = "international"; } else { flightType = "domestic"; }
							
							String callsign2 = result1_r_c3.getString("callsign2");
							String flightNum2 = result1_r_c3.getString("flightNum2");
							String from2 = result1_r_c3.getString("from2");
							String to2 = result1_r_c3.getString("to2");
							String departTime2 = result1_r_c3.getString("departTime2");
							String departDate2 = result1_r_c3.getString("departDateAdj2");
							String arrivalTime2 = result1_r_c3.getString("arrivalTime2");
							String arrivalDate2 = result1_r_c3.getString("arrivalDateAdj2");
							String duration2 = result1_r_c3.getString("duration2");
							String price2 = result1_r_c3.getString("price2");
							String flightType2 = result1_r_c3.getString("flightType2");
							if (flightType2.equals("i")) { flightType2 = "international"; } else { flightType2 = "domestic"; }
							
							String callsign3 = result1_r_c3.getString("callsign3");
							String flightNum3 = result1_r_c3.getString("flightNum3");
							String from3 = result1_r_c3.getString("from3");
							String to3 = result1_r_c3.getString("to3");
							String departTime3 = result1_r_c3.getString("departTime3");
							String departDate3 = result1_r_c3.getString("departDateAdj3");
							String arrivalTime3 = result1_r_c3.getString("arrivalTime3");
							String arrivalDate3 = result1_r_c3.getString("arrivalDateAdj3");
							String duration3 = result1_r_c3.getString("duration3");
							String price3 = result1_r_c3.getString("price3");
							String flightType3 = result1_r_c3.getString("flightType3");
							if (flightType3.equals("i")) { flightType3 = "international"; } else { flightType3 = "domestic"; }
							
							out.println("<tr><td>" + callsign + "</td><td>" + flightNum + "</td><td>" + from + "</td><td>" + to + "</td><td>" +  "2" + "</td><td>" + departTime + "</td><td>" + departDate + "</td><td>" + arrivalTime + "</td><td>" + arrivalDate + "</td><td>" + duration + "</td><td>" + totalDuration + "</td><td>" + flightType + "</td><td>$" + price + "</td><td>$" + totalPrice + "</td></td><td><input type=\"radio\" name=\"return\" value=\"__3____return____flight1__" + callsign + "_" + flightNum + "_" + from + "_" + to + "_" + departDate + "_" + arrivalDate + "_" + price + "__flight2__" + callsign2 + "_" + flightNum2 + "_" + from2 + "_" + to2 + "_" + departDate2 + "_" + arrivalDate2 + "_" + price2 + "__flight3__" + callsign3 + "_" + flightNum3 + "_" + from3 + "_" + to3 + "_" + departDate3 + "_" + arrivalDate3 + "_" + price3 + "\"><label>Book</label><br></td></tr>");
							// out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
							out.println("<tr class=\"connection\"><td>" + callsign2 + "</td><td>" + flightNum2 + "</td><td>" + from2 + "</td><td>" + to2 + "</td><td>" +  "" + "</td><td>" + departTime2 + "</td><td>" + departDate2 + "</td><td>" + arrivalTime2 + "</td><td>" + arrivalDate2 + "</td><td>" + duration2 + "</td><td></td><td>" + flightType2 + "</td><td>$" + price2 + "</td><td></td><td></td></tr>");
							// out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
							out.println("<tr class=\"connection\"><td>" + callsign3 + "</td><td>" + flightNum3 + "</td><td>" + from3 + "</td><td>" + to3 + "</td><td>" +  "" + "</td><td>" + departTime3 + "</td><td>" + departDate3 + "</td><td>" + arrivalTime3 + "</td><td>" + arrivalDate3 + "</td><td>" + duration3 + "</td><td></td><td>" + flightType3 + "</td><td>$" + price3 + "</td><td></td><td></td></tr>");
							
							i_r_c3_a++;
						}
						
						out.println("</table>");
					}
						} else {
							out.println("no results");
						}
					}
				} else { //3. flexible one-way
					out.println("<form action=\"" + bookingRedirect + "\" method=\"post\">");
					
					if (Integer.valueOf(stopsFrom) <= 0 && Integer.valueOf(stopsTo) >= 0) {
						
						Statement stmt3a = con.createStatement();
						stmt3a.execute("create temporary table f1( select d.airlineID as 'callsign', f.flightNum as 'flightNum', d.airportID as 'from', a.airportID as 'to', d.departDate as 'departDateOrig', a.arrivalDate as 'arrivalDateOrig', date_add(d.departDate, interval (floor((abs(datediff('" + searchDate + "', d.departDate)) / 7)) * 7) day) as 'departDateAdj', d.departTime as 'departTime', convert(date_add((date_add(d.departDate, interval (floor((abs(datediff('" + searchDate + "', d.departDate)) / 7)) * 7) day)), interval (timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime))) hour_second), date) as 'arrivalDateAdj', a.arrivalTime as 'arrivalTime', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'totalDuration', dayname(d.departDate) as 'dayOperating', f.flightType as 'flightType', f.price as 'price', f.price as 'totalPrice' from departs_from d, arrives_at a, flights f where d.airportID = '" + searchFrom + "' and a.airportID = '" + searchTo + "' and d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum );");
						
						if (!airlineFilter.equals("")) {
							airlineQuery = " and callsign = '" + airlineFilter + "' ";
						} else {
							airlineQuery = "";
						}
						
						Statement stmt3 = con.createStatement();
						ResultSet result3 = stmt3.executeQuery("select * from f1 where departDateAdj between (date_add('" + searchDate + "', interval -3 day)) and (date_add('" + searchDate + "', interval 3 day)) " + airlineQuery + " " + priceQuery + " " + takeoffQuery + " " + arrivalQuery + " " + durationQuery + " " + sort);
						
						if (result3.next()) {
							callsign = result3.getString("callsign");
							flightNum = result3.getString("flightNum");
							from = result3.getString("from");
							to = result3.getString("to");
							departTime = result3.getString("departTime");
							departDate = result3.getString("departDateAdj");
							arrivalTime = result3.getString("arrivalTime");
							arrivalDate = result3.getString("arrivalDateAdj");
							duration = result3.getString("duration");
							totalDuration = result3.getString("totalDuration");
							price = result3.getString("price");
							totalPrice = result3.getString("totalPrice");
							flightType = result3.getString("flightType");
							
							if (flightType.equals("i")) {
								flightType = "international";
							} else {
								flightType = "domestic";
							}
							
							out.println("<h2>Direct flights</h2>");
							out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
							out.println("<tr><td>" + callsign + "</td><td>" + flightNum + "</td><td>" + from + "</td><td>" + to + "</td><td>" +  "0" + "</td><td>" + departTime + "</td><td>" + departDate + "</td><td>" + arrivalTime + "</td><td>" + arrivalDate + "</td><td>" + duration + "</td><td>" + totalDuration + "</td><td>" + flightType + "</td><td>$" + price + "</td><td>$" + totalPrice + "</td><td><input type=\"radio\" name=\"outbound\" value=\"__1____outbound____flight1__" + callsign + "_" + flightNum + "_" + from + "_" + to + "_" + departDate + "_" + arrivalDate + "_" + price + "\"><label>Book</label><br></td></tr>");
							
							while (result3.next()) {
								callsign = result3.getString("callsign");
								flightNum = result3.getString("flightNum");
								from = result3.getString("from");
								to = result3.getString("to");
								departTime = result3.getString("departTime");
								departDate = result3.getString("departDateAdj");
								arrivalTime = result3.getString("arrivalTime");
								arrivalDate = result3.getString("arrivalDateAdj");
								duration = result3.getString("duration");
								totalDuration = result3.getString("totalDuration");
								price = result3.getString("price");
								totalPrice = result3.getString("totalPrice");
								flightType = result3.getString("flightType");
								
								if (flightType.equals("i")) {
									flightType = "international";
								} else {
									flightType = "domestic";
								}
								
								out.println("<tr><td>" + callsign + "</td><td>" + flightNum + "</td><td>" + from + "</td><td>" + to + "</td><td>" +  "0" + "</td><td>" + departTime + "</td><td>" + departDate + "</td><td>" + arrivalTime + "</td><td>" + arrivalDate + "</td><td>" + duration + "</td><td>" + totalDuration + "</td><td>" + flightType + "</td><td>$" + price + "</td><td>$" + totalPrice + "</td><td><input type=\"radio\" name=\"outbound\" value=\"__1____outbound____flight1__" + callsign + "_" + flightNum + "_" + from + "_" + to + "_" + departDate + "_" + arrivalDate + "_" + price + "\"><label>Book</label><br></td></tr>");
							}
							
							out.println("</table>");
						}
					}
					
					/////////////////////////////////////////////////////////////////
					//check if connecting flights (1 connection)
					if (Integer.valueOf(stopsFrom) <= 1 && Integer.valueOf(stopsTo) >= 1) {
						String query1_c2_a = "create temporary table c1( select d.airlineID as 'callsign', f.flightNum as 'flightNum', d.airportID as 'from', a.airportID as 'to', d.departDate as 'departDateOrig', a.arrivalDate as 'arrivalDateOrig', date_add(d.departDate, interval (ceil((abs(datediff('" + searchDate + "', d.departDate)) / 7)) * 7) day) as 'departDateAdj', d.departTime as 'departTime', convert(date_add((date_add(d.departDate, interval (ceil((abs(datediff('" + searchDate + "', d.departDate)) / 7)) * 7) day)), interval (timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime))) hour_second), date) as 'arrivalDateAdj', a.arrivalTime as 'arrivalTime', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration', dayname(d.departDate) as 'dayOperating', f.flightType as 'flightType', f.price as 'price' from departs_from d, arrives_at a, flights f where d.airportID = '" + searchFrom + "' and d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum having departDateAdj between (date_add('" + searchDate + "', interval -3 day)) and (date_add('" + searchDate + "', interval 3 day)) );";
						Statement stmt1_c2_a = con.createStatement();
						stmt1_c2_a.execute(query1_c2_a);
						
						String query1_c2_b = "create temporary table c2( select d.airlineID as 'callsign2', f.flightNum as 'flightNum2', d.airportID as 'from2', a.airportID as 'to2', d.departDate as 'departDateOrig2', a.arrivalDate as 'arrivalDateOrig2', date_add(d.departDate, interval (ceil((abs(datediff('" + searchDate + "', d.departDate)) / 7)) * 7) day) as 'departDateAdj2', d.departTime as 'departTime2', convert(date_add((date_add(d.departDate, interval (ceil((abs(datediff('" + searchDate + "', d.departDate)) / 7)) * 7) day)), interval (timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime))) hour_second), date) as 'arrivalDateAdj2', a.arrivalTime as 'arrivalTime2', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration2', dayname(d.departDate) as 'dayOperating2', f.flightType as 'flightType2', f.price as 'price2' from departs_from d, arrives_at a, flights f, c1 where a.airportID = '" + searchTo + "' and d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum );";
						Statement stmt1_c2_b = con.createStatement();
						stmt1_c2_b.execute(query1_c2_b);
						
						String query1_c2_c = "create temporary table c3( select *, timestampdiff(hour, timestamp(c1.arrivalDateAdj, c1.arrivalTime), timestamp(c2.departDateAdj2, c2.departTime2)) as 'connectionTime2', (price + price2) as 'totalPrice', (cast((addtime(duration, duration2)) as decimal) / 10000) as 'totalDuration' from c1 join c2 on (timestampdiff(hour, timestamp(c1.arrivalDateAdj, c1.arrivalTime), timestamp(c2.departDateAdj2, c2.departTime2)) between 0 and 24) and (c2.from2 <> c1.`from`) and (c2.from2 = c1.`to`) );";
						Statement stmt1_c2_c = con.createStatement();
						stmt1_c2_c.execute(query1_c2_c);
						
						if (!airlineFilter.equals("")) {
							airlineQuery = " and callsign = '" + airlineFilter + "' and callsign2 = '" + airlineFilter + "' ";
						} else {
							airlineQuery = "";
						}
						
						String query1_c2_d = "select distinct * from c3 where callsign <> '' " + airlineQuery + " " + priceQuery + " " + takeoffQuery + " " + arrivalQuery + " " + durationQuery + " " + sort + ";";
						Statement stmt1_c2_d = con.createStatement();
						ResultSet result1_c2 = stmt1_c2_d.executeQuery(query1_c2_d);
						
						int i_c2_a = 0;
						
						while (result1_c2.next()) {
							if (i_c2_a == 0) {
								out.println("<h2>Up to one stop</h1>");
								out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
							}
							
							callsign = result1_c2.getString("callsign");
							flightNum = result1_c2.getString("flightNum");
							from = result1_c2.getString("from");
							to = result1_c2.getString("to");
							departTime = result1_c2.getString("departTime");
							departDate = result1_c2.getString("departDateAdj");
							arrivalTime = result1_c2.getString("arrivalTime");
							arrivalDate = result1_c2.getString("arrivalDateAdj");
							duration = result1_c2.getString("duration");
							totalDuration = result1_c2.getString("totalDuration");
							price = result1_c2.getString("price");
							totalPrice = result1_c2.getString("totalPrice");
							flightType = result1_c2.getString("flightType");
							if (flightType.equals("i")) {
								flightType = "international";
							} else {
								flightType = "domestic";
							}
							
							String callsign2 = result1_c2.getString("callsign2");
							String flightNum2 = result1_c2.getString("flightNum2");
							String from2 = result1_c2.getString("from2");
							String to2 = result1_c2.getString("to2");
							String departTime2 = result1_c2.getString("departTime2");
							String departDate2 = result1_c2.getString("departDateAdj2");
							String arrivalTime2 = result1_c2.getString("arrivalTime2");
							String arrivalDate2 = result1_c2.getString("arrivalDateAdj2");
							String duration2 = result1_c2.getString("duration2");
							String price2 = result1_c2.getString("price2");
							String flightType2 = result1_c2.getString("flightType2");
							if (flightType2.equals("i")) {
								flightType2 = "international";
							} else {
								flightType2 = "domestic";
							}
							
							out.println("<tr><td>" + callsign + "</td><td>" + flightNum + "</td><td>" + from + "</td><td>" + to + "</td><td>" + "1" + "</td><td>" + departTime + "</td><td>" + departDate + "</td><td>" + arrivalTime + "</td><td>" + arrivalDate + "</td><td>" + duration + "</td><td>" + totalDuration + "</td><td>" + flightType + "</td><td>$" + price + "</td><td>$" + totalPrice + "</td><td><input type=\"radio\" name=\"outbound\" value=\"__2____outbound____flight1__" + callsign + "_" + flightNum + "_" + from + "_" + to + "_" + departDate + "_" + arrivalDate + "_" + price + "__flight2__" + callsign2 + "_" + flightNum2 + "_" + from2 + "_" + to2 + "_" + departDate2 + "_" + arrivalDate2 + "_" + price2 + "\"><label>Book</label><br></td></tr>");
							
							// out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
							out.println("<tr class=\"connection\"><td>" + callsign2 + "</td><td>" + flightNum2 + "</td><td>" + from2 + "</td><td>" + to2 + "</td><td>" + "" + "</td><td>" + departTime2 + "</td><td>" + departDate2 + "</td><td>" + arrivalTime2 + "</td><td>" + arrivalDate2 + "</td><td>" + duration2 + "</td><td></td><td>" + flightType2 + "</td><td>$" + price2 + "</td><td></td><td></td></tr>");
							
							i_c2_a++;
						}
						
						out.println("</table>");
					}
					
					/////////////////////////////////////////////////////////////////
					//check if connecting flights (2 connections)
					if (Integer.valueOf(stopsFrom) <= 2 && Integer.valueOf(stopsTo) >= 2) {
					
					  String query1_c3_a = "create temporary table d1( select d.airlineID as 'callsign', f.flightNum as 'flightNum', d.airportID as 'from', a.airportID as 'to', d.departDate as 'departDateOrig', a.arrivalDate as 'arrivalDateOrig', date_add(d.departDate, interval (ceil((abs(datediff('" + searchDate + "', d.departDate)) / 7)) * 7) day) as 'departDateAdj', d.departTime as 'departTime', convert(date_add((date_add(d.departDate, interval (ceil((abs(datediff('" + searchDate + "', d.departDate)) / 7)) * 7) day)), interval (timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime))) hour_second), date) as 'arrivalDateAdj', a.arrivalTime as 'arrivalTime', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration', dayname(d.departDate) as 'dayOperating', f.flightType as 'flightType', f.price as 'price' from departs_from d, arrives_at a, flights f where d.airportID = '" + searchFrom + "' and d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum having departDateAdj between (date_add('" + searchDate + "', interval -3 day)) and (date_add('" + searchDate + "', interval 3 day)) );";
					  Statement stmt1_c3_a = con.createStatement();
					  stmt1_c3_a.execute(query1_c3_a);
					
					  String query1_c3_b = "create temporary table d2( select d.airlineID as 'callsign2', f.flightNum as 'flightNum2', d.airportID as 'from2', a.airportID as 'to2', d.departDate as 'departDateOrig2', a.arrivalDate as 'arrivalDateOrig2', date_add(d.departDate, interval (ceil((abs(datediff('" + searchDate + "', d.departDate)) / 7)) * 7) day) as 'departDateAdj2', d.departTime as 'departTime2', convert(date_add((date_add(d.departDate, interval (ceil((abs(datediff('" + searchDate + "', d.departDate)) / 7)) * 7) day)), interval (timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime))) hour_second), date) as 'arrivalDateAdj2', a.arrivalTime as 'arrivalTime2', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration2', dayname(d.departDate) as 'dayOperating2', f.flightType as 'flightType2', f.price as 'price2' from departs_from d, arrives_at a, flights f, d1 where d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum );";
					  Statement stmt1_c3_b = con.createStatement();
					  stmt1_c3_b.execute(query1_c3_b);
					
					  String query1_c3_c = "create temporary table d3( select *, timestampdiff(hour, timestamp(d1.arrivalDateAdj, d1.arrivalTime), timestamp(d2.departDateAdj2, d2.departTime2)) as 'connectionTime2' from d1 join d2 on (timestampdiff(hour, timestamp(d1.arrivalDateAdj, d1.arrivalTime), timestamp(d2.departDateAdj2, d2.departTime2)) between 0 and 24) and (d2.from2 <> d1.`from`) and (d2.from2 = d1.`to`) );";
					  Statement stmt1_c3_c = con.createStatement();
					  stmt1_c3_c.execute(query1_c3_c);
					
					  String query1_c3_d = "create temporary table d4( select distinct d.airlineID as 'callsign3', f.flightNum as 'flightNum3', d3.to2 as 'from3', a.airportID as 'to3', d.departDate as 'departDateOrig3', a.arrivalDate as 'arrivalDateOrig3', date_add(d.departDate, interval (ceil((abs(datediff('" + searchDate + "', d.departDate)) / 7)) * 7) day) as 'departDateAdj3', d.departTime as 'departTime3', convert(date_add((date_add(d.departDate, interval (ceil((abs(datediff('" + searchDate + "', d.departDate)) / 7)) * 7) day)), interval (timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime))) hour_second), date) as 'arrivalDateAdj3', a.arrivalTime as 'arrivalTime3', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration3', dayname(d.departDate) as 'dayOperating3', f.flightType as 'flightType3', f.price as 'price3' from departs_from d, arrives_at a, flights f, d1, d3 where a.airportID = '" + searchTo + "' and d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum );";
					  Statement stmt1_c3_d = con.createStatement();
					  stmt1_c3_d.execute(query1_c3_d);
					
					  String query1_c3_e = "create temporary table d5( select *, timestampdiff(hour, timestamp(d3.arrivalDateAdj2, d3.arrivalTime2), timestamp(d4.departDateAdj3, d4.departTime3)) as 'connectionTime3', (price + price2 + price3) as 'totalPrice', (cast((addtime(addtime(duration, duration2), duration3)) as decimal) / 10000) as 'totalDuration' from d3 join d4 on (timestampdiff(hour, timestamp(d3.arrivalDateAdj2, d3.arrivalTime2), timestamp(d4.departDateAdj3, d4.departTime3)) between 0 and 24) where (`to` <> `from`) and (to2 <> from2) and (to3 <> from3) and (`to` = from2) and (to2 = from3) and (from2 <> to3) );";
					  Statement stmt1_c3_e = con.createStatement();
					  stmt1_c3_e.execute(query1_c3_e);
					
					  if (!airlineFilter.equals("")) {
					  	airlineQuery = " and callsign = '" + airlineFilter + "' and callsign2 = '" + airlineFilter + "' and callsign3 = '" + airlineFilter + "' ";
					  } else {
					  	airlineQuery = "";
					  }
					  
					  String query1_c3_g = "select distinct * from d5 where callsign <> '' " + airlineQuery + " " + priceQuery + " " + takeoffQuery + " " + arrivalQuery + " " + durationQuery + " " + sort + ";";
					  Statement stmt1_c3_g = con.createStatement();
					  ResultSet result1_c3 = stmt1_c3_g.executeQuery(query1_c3_g);
					
					  int i_c3_a = 0;
					
					  while (result1_c3.next()) {
					    if (i_c3_a == 0) {
					      out.println("<h2>Up to two stops</h1>");
					      out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
					    }
					
					    callsign = result1_c3.getString("callsign");
					    flightNum = result1_c3.getString("flightNum");
					    from = result1_c3.getString("from");
					    to = result1_c3.getString("to");
					    departTime = result1_c3.getString("departTime");
					    departDate = result1_c3.getString("departDateAdj");
					    arrivalTime = result1_c3.getString("arrivalTime");
					    arrivalDate = result1_c3.getString("arrivalDateAdj");
					    duration = result1_c3.getString("duration");
					    totalDuration = result1_c3.getString("totalDuration");
					    price = result1_c3.getString("price");
					    totalPrice = result1_c3.getString("totalPrice");
					    flightType = result1_c3.getString("flightType");
					    if (flightType.equals("i")) {
					      flightType = "international";
					    } else {
					      flightType = "domestic";
					    }
					
					    String callsign2 = result1_c3.getString("callsign2");
					    String flightNum2 = result1_c3.getString("flightNum2");
					    String from2 = result1_c3.getString("from2");
					    String to2 = result1_c3.getString("to2");
					    String departTime2 = result1_c3.getString("departTime2");
					    String departDate2 = result1_c3.getString("departDateAdj2");
					    String arrivalTime2 = result1_c3.getString("arrivalTime2");
					    String arrivalDate2 = result1_c3.getString("arrivalDateAdj2");
					    String duration2 = result1_c3.getString("duration2");
					    String price2 = result1_c3.getString("price2");
					    String flightType2 = result1_c3.getString("flightType2");
					    if (flightType2.equals("i")) {
					      flightType2 = "international";
					    } else {
					      flightType2 = "domestic";
					    }
					
					    String callsign3 = result1_c3.getString("callsign3");
					    String flightNum3 = result1_c3.getString("flightNum3");
					    String from3 = result1_c3.getString("from3");
					    String to3 = result1_c3.getString("to3");
					    String departTime3 = result1_c3.getString("departTime3");
					    String departDate3 = result1_c3.getString("departDateAdj3");
					    String arrivalTime3 = result1_c3.getString("arrivalTime3");
					    String arrivalDate3 = result1_c3.getString("arrivalDateAdj3");
					    String duration3 = result1_c3.getString("duration3");
					    String price3 = result1_c3.getString("price3");
					    String flightType3 = result1_c3.getString("flightType3");
					    if (flightType3.equals("i")) {
					      flightType3 = "international";
					    } else {
					      flightType3 = "domestic";
					    }
					
					    out.println("<tr><td>" + callsign + "</td><td>" + flightNum + "</td><td>" + from + "</td><td>" + to + "</td><td>" + "2" + "</td><td>" + departTime + "</td><td>" + departDate + "</td><td>" + arrivalTime + "</td><td>" + arrivalDate + "</td><td>" + duration + "</td><td>" + totalDuration + "</td><td>" + flightType + "</td><td>$" + price + "</td><td>$" + totalPrice + "</td></td><td><input type=\"radio\" name=\"outbound\" value=\"__3____outbound____flight1__" + callsign + "_" + flightNum + "_" + from + "_" + to + "_" + departDate + "_" + arrivalDate + "_" + price + "__flight2__" + callsign2 + "_" + flightNum2 + "_" + from2 + "_" + to2 + "_" + departDate2 + "_" + arrivalDate2 + "_" + price2 + "__flight3__" + callsign3 + "_" + flightNum3 + "_" + from3 + "_" + to3 + "_" + departDate3 + "_" + arrivalDate3 + "_" + price3 + "\"><label>Book</label><br></td></tr>");
					    // out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
					    out.println("<tr class=\"connection\"><td>" + callsign2 + "</td><td>" + flightNum2 + "</td><td>" + from2 + "</td><td>" + to2 + "</td><td>" + "" + "</td><td>" + departTime2 + "</td><td>" + departDate2 + "</td><td>" + arrivalTime2 + "</td><td>" + arrivalDate2 + "</td><td>" + duration2 + "</td><td></td><td>" + flightType2 + "</td><td>$" + price2 + "</td><td></td><td></td></tr>");
					    // out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
					    out.println("<tr class=\"connection\"><td>" + callsign3 + "</td><td>" + flightNum3 + "</td><td>" + from3 + "</td><td>" + to3 + "</td><td>" + "" + "</td><td>" + departTime3 + "</td><td>" + departDate3 + "</td><td>" + arrivalTime3 + "</td><td>" + arrivalDate3 + "</td><td>" + duration3 + "</td><td></td><td>" + flightType3 + "</td><td>$" + price3 + "</td><td></td><td></td></tr>");
					
					    i_c3_a++;
					  }
					
					  out.println("</table>");
					}
					
					if (!roundTrip) {
						//out.println("<br><input type=\"submit\" value=\"Proceed to booking\"/>");
						//out.println("</form>");
					} else { //3_r. flexible round trip
						out.println("<h1>Search results (return flight)</h1>");
					
						if (Integer.valueOf(stopsFrom) <= 0 && Integer.valueOf(stopsTo) >= 0) {
							Statement stmt3_ra = con.createStatement();
							stmt3_ra.execute("create temporary table f1_r( select d.airlineID as 'callsign', f.flightNum as 'flightNum', d.airportID as 'from', a.airportID as 'to', d.departDate as 'departDateOrig', a.arrivalDate as 'arrivalDateOrig', date_add(d.departDate, interval (floor((abs(datediff('" + searchReturnDate + "', d.departDate)) / 7)) * 7) day) as 'departDateAdj', d.departTime as 'departTime', convert(date_add((date_add(d.departDate, interval (floor((abs(datediff('" + searchReturnDate + "', d.departDate)) / 7)) * 7) day)), interval (timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime))) hour_second), date) as 'arrivalDateAdj', a.arrivalTime as 'arrivalTime', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'totalDuration', dayname(d.departDate) as 'dayOperating', f.flightType as 'flightType', f.price as 'price', f.price as 'totalPrice' from departs_from d, arrives_at a, flights f where d.airportID = '" + searchTo + "' and a.airportID = '" + searchFrom + "' and d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum );");
							
							if (!airlineFilter.equals("")) {
								airlineQuery = " and callsign = '" + airlineFilter + "' ";
							} else {
								airlineQuery = "";
							}
							
							Statement stmt3_r = con.createStatement();
							ResultSet result3_r = stmt3_r.executeQuery("select * from f1_r where departDateAdj between (date_add('" + searchReturnDate + "', interval -3 day)) and (date_add('" + searchReturnDate + "', interval 3 day));");
							
							if (result3_r.next()) {
								callsign = result3_r.getString("callsign");
								flightNum = result3_r.getString("flightNum");
								from = result3_r.getString("from");
								to = result3_r.getString("to");
								departTime = result3_r.getString("departTime");
								departDate = result3_r.getString("departDateAdj");
								arrivalTime = result3_r.getString("arrivalTime");
								arrivalDate = result3_r.getString("arrivalDateAdj");
								duration = result3_r.getString("duration");
								totalDuration = result3_r.getString("totalDuration");
								price = result3_r.getString("price");
								totalPrice = result3_r.getString("totalPrice");
								flightType = result3_r.getString("flightType");
								
								if (flightType.equals("i")) {
									flightType = "international";
								} else {
									flightType = "domestic";
								}
								
								out.println("<h2>Direct flights</h2>");
								out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
								out.println("<tr><td>" + callsign + "</td><td>" + flightNum + "</td><td>" + from + "</td><td>" + to + "</td><td>" +  "0" + "</td><td>" + departTime + "</td><td>" + departDate + "</td><td>" + arrivalTime + "</td><td>" + arrivalDate + "</td><td>" + duration + "</td><td>" + totalDuration + "</td><td>" + flightType + "</td><td>$" + price + "</td><td>$" + totalPrice + "</td><td><input type=\"radio\" name=\"return\" value=\"__1____return____flight1__" + callsign + "_" + flightNum + "_" + from + "_" + to + "_" + departDate + "_" + arrivalDate + "_" + price + "\"><label>Book</label><br></td></tr>");
								
								while (result3_r.next()) {
									callsign = result3_r.getString("callsign");
									flightNum = result3_r.getString("flightNum");
									from = result3_r.getString("from");
									to = result3_r.getString("to");
									departTime = result3_r.getString("departTime");
									departDate = result3_r.getString("departDateAdj");
									arrivalTime = result3_r.getString("arrivalTime");
									arrivalDate = result3_r.getString("arrivalDateAdj");
									duration = result3_r.getString("duration");
									totalDuration = result3_r.getString("totalDuration");
									price = result3_r.getString("price");
									totalPrice = result3_r.getString("totalPrice");
									flightType = result3_r.getString("flightType");
									
									if (flightType.equals("i")) {
										flightType = "international";
									} else {
										flightType = "domestic";
									}
									
									out.println("<tr><td>" + callsign + "</td><td>" + flightNum + "</td><td>" + from + "</td><td>" + to + "</td><td>" +  "0" + "</td><td>" + departTime + "</td><td>" + departDate + "</td><td>" + arrivalTime + "</td><td>" + arrivalDate + "</td><td>" + duration + "</td><td>" + totalDuration + "</td><td>" + flightType + "</td><td>$" + price + "</td><td>$" + totalPrice + "</td><td><input type=\"radio\" name=\"return\" value=\"__1____return____flight1__" + callsign + "_" + flightNum + "_" + from + "_" + to + "_" + departDate + "_" + arrivalDate + "_" + price + "\"><label>Book</label><br></td></tr>");
								}
								
								out.println("</table>");
								//out.println("<br><input type=\"submit\" value=\"Proceed to booking\"/>");
								//out.println("</form>");
							}
					/////////////////////////////////////////////////////////////////
					//check if connecting flights (1 connection)
					if (Integer.valueOf(stopsFrom) <= 1 && Integer.valueOf(stopsTo) >= 1) {
						String query1_r_2_c2_r_2_a = "create temporary table c1_r_2( select d.airlineID as 'callsign', f.flightNum as 'flightNum', d.airportID as 'from', a.airportID as 'to', d.departDate as 'departDateOrig', a.arrivalDate as 'arrivalDateOrig', date_add(d.departDate, interval (ceil((abs(datediff('" + searchDate + "', d.departDate)) / 7)) * 7) day) as 'departDateAdj', d.departTime as 'departTime', convert(date_add((date_add(d.departDate, interval (ceil((abs(datediff('" + searchDate + "', d.departDate)) / 7)) * 7) day)), interval (timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime))) hour_second), date) as 'arrivalDateAdj', a.arrivalTime as 'arrivalTime', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration', dayname(d.departDate) as 'dayOperating', f.flightType as 'flightType', f.price as 'price' from departs_from d, arrives_at a, flights f where d.airportID = '" + searchFrom + "' and d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum having departDateAdj between (date_add('" + searchDate + "', interval -3 day)) and (date_add('" + searchDate + "', interval 3 day)) );";
						Statement stmt1_c2_r_2_a = con.createStatement();
						stmt1_c2_r_2_a.execute(query1_r_2_c2_r_2_a);
						
						String query1_r_2_c2_r_2_b = "create temporary table c2_r_2( select d.airlineID as 'callsign2', f.flightNum as 'flightNum2', d.airportID as 'from2', a.airportID as 'to2', d.departDate as 'departDateOrig2', a.arrivalDate as 'arrivalDateOrig2', date_add(d.departDate, interval (ceil((abs(datediff('" + searchDate + "', d.departDate)) / 7)) * 7) day) as 'departDateAdj2', d.departTime as 'departTime2', convert(date_add((date_add(d.departDate, interval (ceil((abs(datediff('" + searchDate + "', d.departDate)) / 7)) * 7) day)), interval (timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime))) hour_second), date) as 'arrivalDateAdj2', a.arrivalTime as 'arrivalTime2', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration2', dayname(d.departDate) as 'dayOperating2', f.flightType as 'flightType2', f.price as 'price2' from departs_from d, arrives_at a, flights f, c1_r_2 where a.airportID = '" + searchTo + "' and d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum );";
						Statement stmt1_c2_r_2_b = con.createStatement();
						stmt1_c2_r_2_b.execute(query1_r_2_c2_r_2_b);
						
						String query1_r_2_c2_r_2_c = "create temporary table c3_r_2( select *, timestampdiff(hour, timestamp(c1_r_2.arrivalDateAdj, c1_r_2.arrivalTime), timestamp(c2_r_2.departDateAdj2, c2_r_2.departTime2)) as 'connectionTime2', (price + price2) as 'totalPrice', (cast((addtime(duration, duration2)) as decimal) / 10000) as 'totalDuration' from c1_r_2 join c2_r_2 on (timestampdiff(hour, timestamp(c1_r_2.arrivalDateAdj, c1_r_2.arrivalTime), timestamp(c2_r_2.departDateAdj2, c2_r_2.departTime2)) between 0 and 24) and (c2_r_2.from2 <> c1_r_2.`from`) and (c2_r_2.from2 = c1_r_2.`to`) );";
						Statement stmt1_c2_r_2_c = con.createStatement();
						stmt1_c2_r_2_c.execute(query1_r_2_c2_r_2_c);
						
						if (!airlineFilter.equals("")) {
							airlineQuery = " and callsign = '" + airlineFilter + "' and callsign2 = '" + airlineFilter + "' ";
						} else {
							airlineQuery = "";
						}
						
						String query1_r_2_c2_r_2_d = "select distinct * from c3_r_2 where callsign <> '' " + airlineQuery + " " + priceQuery + " " + takeoffQuery + " " + arrivalQuery + " " + durationQuery + " " + sort + ";";
						Statement stmt1_c2_r_2_d = con.createStatement();
						ResultSet result1_c2_r_2 = stmt1_c2_r_2_d.executeQuery(query1_r_2_c2_r_2_d);
						
						int i_c2_r_2_r_2_a = 0;
						
						while (result1_c2_r_2.next()) {
							if (i_c2_r_2_r_2_a == 0) {
								out.println("<h2>Up to one stop</h1>");
								out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
							}
							
							callsign = result1_c2_r_2.getString("callsign");
							flightNum = result1_c2_r_2.getString("flightNum");
							from = result1_c2_r_2.getString("from");
							to = result1_c2_r_2.getString("to");
							departTime = result1_c2_r_2.getString("departTime");
							departDate = result1_c2_r_2.getString("departDateAdj");
							arrivalTime = result1_c2_r_2.getString("arrivalTime");
							arrivalDate = result1_c2_r_2.getString("arrivalDateAdj");
							duration = result1_c2_r_2.getString("duration");
							totalDuration = result1_c2_r_2.getString("totalDuration");
							price = result1_c2_r_2.getString("price");
							totalPrice = result1_c2_r_2.getString("totalPrice");
							flightType = result1_c2_r_2.getString("flightType");
							if (flightType.equals("i")) {
								flightType = "international";
							} else {
								flightType = "domestic";
							}
							
							String callsign2 = result1_c2_r_2.getString("callsign2");
							String flightNum2 = result1_c2_r_2.getString("flightNum2");
							String from2 = result1_c2_r_2.getString("from2");
							String to2 = result1_c2_r_2.getString("to2");
							String departTime2 = result1_c2_r_2.getString("departTime2");
							String departDate2 = result1_c2_r_2.getString("departDateAdj2");
							String arrivalTime2 = result1_c2_r_2.getString("arrivalTime2");
							String arrivalDate2 = result1_c2_r_2.getString("arrivalDateAdj2");
							String duration2 = result1_c2_r_2.getString("duration2");
							String price2 = result1_c2_r_2.getString("price2");
							String flightType2 = result1_c2_r_2.getString("flightType2");
							if (flightType2.equals("i")) {
								flightType2 = "international";
							} else {
								flightType2 = "domestic";
							}
							
							out.println("<tr><td>" + callsign + "</td><td>" + flightNum + "</td><td>" + from + "</td><td>" + to + "</td><td>" + "1" + "</td><td>" + departTime + "</td><td>" + departDate + "</td><td>" + arrivalTime + "</td><td>" + arrivalDate + "</td><td>" + duration + "</td><td>" + totalDuration + "</td><td>" + flightType + "</td><td>$" + price + "</td><td>$" + totalPrice + "</td><td><input type=\"radio\" name=\"return\" value=\"__2____return____flight1__" + callsign + "_" + flightNum + "_" + from + "_" + to + "_" + departDate + "_" + arrivalDate + "_" + price + "__flight2__" + callsign2 + "_" + flightNum2 + "_" + from2 + "_" + to2 + "_" + departDate2 + "_" + arrivalDate2 + "_" + price2 + "\"><label>Book</label><br></td></tr>");
							
							// out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
							out.println("<tr class=\"connection\"><td>" + callsign2 + "</td><td>" + flightNum2 + "</td><td>" + from2 + "</td><td>" + to2 + "</td><td>" + "" + "</td><td>" + departTime2 + "</td><td>" + departDate2 + "</td><td>" + arrivalTime2 + "</td><td>" + arrivalDate2 + "</td><td>" + duration2 + "</td><td></td><td>" + flightType2 + "</td><td>$" + price2 + "</td><td></td><td></td></tr>");
							
							i_c2_r_2_r_2_a++;
						}
						
						out.println("</table>");
					}
					
					/////////////////////////////////////////////////////////////////
					//check if connecting flights (2 connections)
					if (Integer.valueOf(stopsFrom) <= 2 && Integer.valueOf(stopsTo) >= 2) {
					
					  String query1_r_2_c3_a = "create temporary table d1_r_2( select d.airlineID as 'callsign', f.flightNum as 'flightNum', d.airportID as 'from', a.airportID as 'to', d.departDate as 'departDateOrig', a.arrivalDate as 'arrivalDateOrig', date_add(d.departDate, interval (ceil((abs(datediff('" + searchDate + "', d.departDate)) / 7)) * 7) day) as 'departDateAdj', d.departTime as 'departTime', convert(date_add((date_add(d.departDate, interval (ceil((abs(datediff('" + searchDate + "', d.departDate)) / 7)) * 7) day)), interval (timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime))) hour_second), date) as 'arrivalDateAdj', a.arrivalTime as 'arrivalTime', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration', dayname(d.departDate) as 'dayOperating', f.flightType as 'flightType', f.price as 'price' from departs_from d, arrives_at a, flights f where d.airportID = '" + searchFrom + "' and d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum having departDateAdj between (date_add('" + searchDate + "', interval -3 day)) and (date_add('" + searchDate + "', interval 3 day)) );";
					  Statement stmt1_c3_r_2_a = con.createStatement();
					  stmt1_c3_r_2_a.execute(query1_r_2_c3_a);
					
					  String query1_r_2_c3_b = "create temporary table d2_r_2( select d.airlineID as 'callsign2', f.flightNum as 'flightNum2', d.airportID as 'from2', a.airportID as 'to2', d.departDate as 'departDateOrig2', a.arrivalDate as 'arrivalDateOrig2', date_add(d.departDate, interval (ceil((abs(datediff('" + searchDate + "', d.departDate)) / 7)) * 7) day) as 'departDateAdj2', d.departTime as 'departTime2', convert(date_add((date_add(d.departDate, interval (ceil((abs(datediff('" + searchDate + "', d.departDate)) / 7)) * 7) day)), interval (timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime))) hour_second), date) as 'arrivalDateAdj2', a.arrivalTime as 'arrivalTime2', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration2', dayname(d.departDate) as 'dayOperating2', f.flightType as 'flightType2', f.price as 'price2' from departs_from d, arrives_at a, flights f, d1_r_2 where d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum );";
					  Statement stmt1_c3_r_2_b = con.createStatement();
					  stmt1_c3_r_2_b.execute(query1_r_2_c3_b);
					
					  String query1_r_2_c3_c = "create temporary table d3_r_2( select *, timestampdiff(hour, timestamp(d1_r_2.arrivalDateAdj, d1_r_2.arrivalTime), timestamp(d2_r_2.departDateAdj2, d2_r_2.departTime2)) as 'connectionTime2' from d1_r_2 join d2_r_2 on (timestampdiff(hour, timestamp(d1_r_2.arrivalDateAdj, d1_r_2.arrivalTime), timestamp(d2_r_2.departDateAdj2, d2_r_2.departTime2)) between 0 and 24) and (d2_r_2.from2 <> d1_r_2.`from`) and (d2_r_2.from2 = d1_r_2.`to`) );";
					  Statement stmt1_c3_r_2_c = con.createStatement();
					  stmt1_c3_r_2_c.execute(query1_r_2_c3_c);
					
					  String query1_r_2_c3_d = "create temporary table d4_r_2( select distinct d.airlineID as 'callsign3', f.flightNum as 'flightNum3', d3_r_2.to2 as 'from3', a.airportID as 'to3', d.departDate as 'departDateOrig3', a.arrivalDate as 'arrivalDateOrig3', date_add(d.departDate, interval (ceil((abs(datediff('" + searchDate + "', d.departDate)) / 7)) * 7) day) as 'departDateAdj3', d.departTime as 'departTime3', convert(date_add((date_add(d.departDate, interval (ceil((abs(datediff('" + searchDate + "', d.departDate)) / 7)) * 7) day)), interval (timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime))) hour_second), date) as 'arrivalDateAdj3', a.arrivalTime as 'arrivalTime3', timediff(timestamp(a.arrivalDate, a.arrivalTime), timestamp(d.departDate, d.departTime)) as 'duration3', dayname(d.departDate) as 'dayOperating3', f.flightType as 'flightType3', f.price as 'price3' from departs_from d, arrives_at a, flights f, d1_r_2, d3_r_2 where a.airportID = '" + searchTo + "' and d.airlineID = a.airlineID and d.flightNum = a.flightNum and f.airlineID = a.airlineID and f.airlineID = d.airlineID and f.flightNum = a.flightNum and f.flightNum = d.flightNum );";
					  Statement stmt1_c3_r_2_d = con.createStatement();
					  stmt1_c3_r_2_d.execute(query1_r_2_c3_d);
					
					  String query1_r_2_c3_e = "create temporary table d5_r_2( select *, timestampdiff(hour, timestamp(d3_r_2.arrivalDateAdj2, d3_r_2.arrivalTime2), timestamp(d4_r_2.departDateAdj3, d4_r_2.departTime3)) as 'connectionTime3', (price + price2 + price3) as 'totalPrice', (cast((addtime(addtime(duration, duration2), duration3)) as decimal) / 10000) as 'totalDuration' from d3_r_2 join d4_r_2 on (timestampdiff(hour, timestamp(d3_r_2.arrivalDateAdj2, d3_r_2.arrivalTime2), timestamp(d4_r_2.departDateAdj3, d4_r_2.departTime3)) between 0 and 24) where (`to` <> `from`) and (to2 <> from2) and (to3 <> from3) and (`to` = from2) and (to2 = from3) and (from2 <> to3) );";
					  Statement stmt1_c3_r_2_e = con.createStatement();
					  stmt1_c3_r_2_e.execute(query1_r_2_c3_e);
					  
					  if (!airlineFilter.equals("")) {
					  	airlineQuery = " and callsign = '" + airlineFilter + "' and callsign2 = '" + airlineFilter + "' and callsign3 = '" + airlineFilter + "' ";
					  } else {
					  	airlineQuery = "";
					  }
					
					  String query1_r_2_c3_g = "select distinct * from d5_r_2 where callsign <> '' " + airlineQuery + " " + priceQuery + " " + takeoffQuery + " " + arrivalQuery + " " + durationQuery + " " + sort + ";";
					  Statement stmt1_c3_r_2_g = con.createStatement();
					  ResultSet result1_c3_r_2 = stmt1_c3_r_2_g.executeQuery(query1_r_2_c3_g);
					
					  int i_c3_r_2_a = 0;
					
					  while (result1_c3_r_2.next()) {
					    if (i_c3_r_2_a == 0) {
					      out.println("<h2>Up to two stops</h1>");
					      out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
					    }
					
					    callsign = result1_c3_r_2.getString("callsign");
					    flightNum = result1_c3_r_2.getString("flightNum");
					    from = result1_c3_r_2.getString("from");
					    to = result1_c3_r_2.getString("to");
					    departTime = result1_c3_r_2.getString("departTime");
					    departDate = result1_c3_r_2.getString("departDateAdj");
					    arrivalTime = result1_c3_r_2.getString("arrivalTime");
					    arrivalDate = result1_c3_r_2.getString("arrivalDateAdj");
					    duration = result1_c3_r_2.getString("duration");
					    totalDuration = result1_c3_r_2.getString("totalDuration");
					    price = result1_c3_r_2.getString("price");
					    totalPrice = result1_c3_r_2.getString("totalPrice");
					    flightType = result1_c3_r_2.getString("flightType");
					    if (flightType.equals("i")) {
					      flightType = "international";
					    } else {
					      flightType = "domestic";
					    }
					
					    String callsign2 = result1_c3_r_2.getString("callsign2");
					    String flightNum2 = result1_c3_r_2.getString("flightNum2");
					    String from2 = result1_c3_r_2.getString("from2");
					    String to2 = result1_c3_r_2.getString("to2");
					    String departTime2 = result1_c3_r_2.getString("departTime2");
					    String departDate2 = result1_c3_r_2.getString("departDateAdj2");
					    String arrivalTime2 = result1_c3_r_2.getString("arrivalTime2");
					    String arrivalDate2 = result1_c3_r_2.getString("arrivalDateAdj2");
					    String duration2 = result1_c3_r_2.getString("duration2");
					    String price2 = result1_c3_r_2.getString("price2");
					    String flightType2 = result1_c3_r_2.getString("flightType2");
					    if (flightType2.equals("i")) {
					      flightType2 = "international";
					    } else {
					      flightType2 = "domestic";
					    }
					
					    String callsign3 = result1_c3_r_2.getString("callsign3");
					    String flightNum3 = result1_c3_r_2.getString("flightNum3");
					    String from3 = result1_c3_r_2.getString("from3");
					    String to3 = result1_c3_r_2.getString("to3");
					    String departTime3 = result1_c3_r_2.getString("departTime3");
					    String departDate3 = result1_c3_r_2.getString("departDateAdj3");
					    String arrivalTime3 = result1_c3_r_2.getString("arrivalTime3");
					    String arrivalDate3 = result1_c3_r_2.getString("arrivalDateAdj3");
					    String duration3 = result1_c3_r_2.getString("duration3");
					    String price3 = result1_c3_r_2.getString("price3");
					    String flightType3 = result1_c3_r_2.getString("flightType3");
					    if (flightType3.equals("i")) {
					      flightType3 = "international";
					    } else {
					      flightType3 = "domestic";
					    }
					
					    out.println("<tr><td>" + callsign + "</td><td>" + flightNum + "</td><td>" + from + "</td><td>" + to + "</td><td>" + "2" + "</td><td>" + departTime + "</td><td>" + departDate + "</td><td>" + arrivalTime + "</td><td>" + arrivalDate + "</td><td>" + duration + "</td><td>" + totalDuration + "</td><td>" + flightType + "</td><td>$" + price + "</td><td>$" + totalPrice + "</td></td><td><input type=\"radio\" name=\"return\" value=\"__3____return____flight1__" + callsign + "_" + flightNum + "_" + from + "_" + to + "_" + departDate + "_" + arrivalDate + "_" + price + "__flight2__" + callsign2 + "_" + flightNum2 + "_" + from2 + "_" + to2 + "_" + departDate2 + "_" + arrivalDate2 + "_" + price2 + "__flight3__" + callsign3 + "_" + flightNum3 + "_" + from3 + "_" + to3 + "_" + departDate3 + "_" + arrivalDate3 + "_" + price3 + "\"><label>Book</label><br></td></tr>");
					    // out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
					    out.println("<tr class=\"connection\"><td>" + callsign2 + "</td><td>" + flightNum2 + "</td><td>" + from2 + "</td><td>" + to2 + "</td><td>" + "" + "</td><td>" + departTime2 + "</td><td>" + departDate2 + "</td><td>" + arrivalTime2 + "</td><td>" + arrivalDate2 + "</td><td>" + duration2 + "</td><td></td><td>" + flightType2 + "</td><td>$" + price2 + "</td><td></td><td></td></tr>");
					    // out.println("<table><tr><th>Call sign</th><th>Flight number</th><th>From</th><th>To</th><th># stops</th><th>Depart time</th><th>Depart date</th><th>Arrival time</th><th>Arrival date</th><th>Duration</th><th>Total duration</th><th>Flight type</th><th>Price</th><th>Total price</th><th>Book</th></tr>");
					    out.println("<tr class=\"connection\"><td>" + callsign3 + "</td><td>" + flightNum3 + "</td><td>" + from3 + "</td><td>" + to3 + "</td><td>" + "" + "</td><td>" + departTime3 + "</td><td>" + departDate3 + "</td><td>" + arrivalTime3 + "</td><td>" + arrivalDate3 + "</td><td>" + duration3 + "</td><td></td><td>" + flightType3 + "</td><td>$" + price3 + "</td><td></td><td></td></tr>");
					
					    i_c3_r_2_a++;
					  }
					
					  out.println("</table>");
					}
						}
					}
				}
				
				//out.println("<br><input type=\"submit\" value=\"Proceed to booking\"/>");
				//out.println("</form>");
			} catch(Exception e) {
				out.println("<h1>No results found</h1>");
				out.print(e);
			}
		%>
		<%
			out.println("</table>");
			out.println("<br><input type=\"submit\" value=\"Proceed to booking\"/>");
			out.println("</form>");
		%>
	</body>
</html>