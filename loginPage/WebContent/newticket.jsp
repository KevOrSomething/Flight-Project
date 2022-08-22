<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.loginPage.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Ticket</title>
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
			
			//First, run everything for the outbound trip.
			if (!request.getParameter("outbound").equals("null")) {
				
				String tripString = request.getParameter("outbound");
				//out.print(tripString);
							
				ArrayList<String> tripArray = new ArrayList<String>();
				
				//Arraylists for each of the types of input necessary
				ArrayList<String> airlineIDList = new ArrayList<String>();
				ArrayList<Integer> flightNumList = new ArrayList<Integer>();
				ArrayList<java.sql.Date> departDateList = new ArrayList<java.sql.Date>();
				ArrayList<java.sql.Date> arrivalDateList = new ArrayList<java.sql.Date>();
				ArrayList<Float> priceList = new ArrayList<Float>();
				
				StringTokenizer tripTokens = new StringTokenizer(tripString, "_");
				
				//Skips number of flights and "outbound/return" tag
				tripTokens.nextToken();
				tripTokens.nextToken();
				
				
				while (tripTokens.hasMoreTokens()) {
					String currToken = tripTokens.nextToken();
					if (currToken.equals("flight1") || currToken.equals("flight2") || currToken.equals("flight3")) continue;
					tripArray.add(currToken);
					//out.print(currToken + " ");
				}
				
				
				//Populate airlineIDs
				for (int i = 0; i < tripArray.size(); i+=7) {
					airlineIDList.add(tripArray.get(i));
				}
				
				//Populate flightNums
				for (int i = 1; i < tripArray.size(); i+=7) {
					flightNumList.add(Integer.parseInt(tripArray.get(i)));
				}
				
				//Populate departDates
				for (int i = 4; i < tripArray.size(); i+=7) {
					departDateList.add(java.sql.Date.valueOf(tripArray.get(i)));
				}
				
				//Populate departDates
				for (int i = 5; i < tripArray.size(); i+=7) {
					arrivalDateList.add(java.sql.Date.valueOf(tripArray.get(i)));
				}
				
				//Populate prices
				for (int i = 6; i < tripArray.size(); i+=7) {
					priceList.add(Float.parseFloat(tripArray.get(i)));
				}
				
				
				//This part gets the number of flights as a stable variable
				int numFlights = flightNumList.size();
				
				/*
				for (int i = 0; i < airlineIDList.size(); i++) {
					out.print(airlineIDList.get(i) + " " 
							+ flightNumList.get(i) + " " 
							+ departDateList.get(i) + " " 
							+ arrivalDateList.get(i) + " "
							+ priceList.get(i) );
				
					
				}
				*/
				
				
				
				boolean alreadyOnFlight = false;
				//First, we check to see if the user is already on any of the flights.

				for (int i = 0; i < numFlights; i ++) {
					String checkQuery = "SELECT * FROM buys " +
							"JOIN (SELECT ticketID, isCancelled FROM tickets) tickets USING (ticketID) " +
							"JOIN includes USING (ticketID) " +
							"JOIN flights USING (flightNum, airlineID) " +
							"WHERE airlineID = ? AND flightNum = ? AND username = ? AND departDate = ? AND isCancelled = 'n'";
					PreparedStatement checkPS = con.prepareStatement(checkQuery);
					checkPS.setString(1, airlineIDList.get(i));
					checkPS.setInt(2, flightNumList.get(i));
					checkPS.setString(3, (String)session.getAttribute("user"));
					checkPS.setDate(4, departDateList.get(i));
					ResultSet checkSet = checkPS.executeQuery();
					
					if(checkSet.isBeforeFirst()) {
						alreadyOnFlight = true;
					}
							
				}
				
				//If the user is already on a flight, prevent them from registering.
				if (alreadyOnFlight) {
					out.print("OUTBOUND: You are already registered for at least one flight in this trip.");
				} else {
					
					//second, we check to see if all each of the flights are actually available.
					boolean hasFullFlight = false;
					
					for (int i = 0; i < numFlights; i ++) {
						String flightFullQuery = "SELECT airlineID, flightNum, departDate, numOfSeats, if(ISNULL(numPeople), 0, numPeople) numPeople "  + 
								"FROM " +
								
								"(SELECT * FROM flights " +   
								"JOIN uses USING (flightNum, airlineID) " +
								"JOIN aircraft USING (aircraftID)) seatNums " +


								"LEFT JOIN (SELECT airlineID, flightNum, departDate, count(*) as numPeople " +  
								"FROM " +   
								"(SELECT i.airlineID, i.flightNum, i.departDate " +   
								"FROM includes i, tickets t  " +   
								"WHERE i.ticketID = t.ticketID " +
								"AND isCancelled = 'n') temp  " +
								"GROUP BY airlineID, flightNum, departDate) peopleNum " +

							"USING (airlineID, flightNum) " +
							"WHERE airlineID = ? AND flightNum = ? AND departDate = ?";
						
						PreparedStatement flightFullPS = con.prepareStatement(flightFullQuery);
						flightFullPS.setString(1, airlineIDList.get(i));
						flightFullPS.setInt(2, flightNumList.get(i));
						flightFullPS.setDate(3, departDateList.get(i));
						
						ResultSet flightFullSet = flightFullPS.executeQuery();
						
						//First, if there isn't any tuples, then that means that no one is on this specific flight yet, so we're good
						if (!flightFullSet.isBeforeFirst()) {    
						    //leave this empty
						} else {
							flightFullSet.next();
							
							//If a flight is full, add the user to the waitlist for it
							if (flightFullSet.getInt("numOfSeats") <= flightFullSet.getInt("numPeople")) {
								hasFullFlight = true;
								
								String insertWaitlistQuery = "INSERT INTO in_waitlist_of (username, airlineID, flightNum, alert, departDate, arrivalDate) "
										+ "VALUES (?, ?, ?, ?, ?, ?)";
								PreparedStatement insertWaitlistPS = con.prepareStatement(insertWaitlistQuery);
								
								insertWaitlistPS.setString(1, (String)session.getAttribute("user"));
								insertWaitlistPS.setString(2, airlineIDList.get(i));
								insertWaitlistPS.setInt(3, flightNumList.get(i));
								insertWaitlistPS.setString(4, "Watching availability for: " + airlineIDList.get(i) + flightNumList.get(i)
									+ " (Departing on: " +  departDateList.get(i)+")");
								insertWaitlistPS.setDate(5, departDateList.get(i));
								insertWaitlistPS.setDate(6, arrivalDateList.get(i));
								
								insertWaitlistPS.executeUpdate();
								
							}
						}
					}
					
					
					//If there's at least one flight that isn't avaiable, this puts the user on the waitlist for that flight, and prevents them from booking the trip.
					if (hasFullFlight) {
						out.print("OUTBOUND: Sorry, at least one flight in that trip is full. As such, you have been put on a waitlist for the full flight(s).");
					} else {
						//Otherwise, go ahead with adding the ticket.
						
						
						//This is where the ticket values get figured out and inputted.
						
						//First, we gotta get the time of the earliest flight.
						String earliestFlightQuery = "SELECT * FROM departs_from WHERE flightNum = ? AND airlineID = ? ";
						PreparedStatement earliestFlightPS = con.prepareStatement(earliestFlightQuery);
						earliestFlightPS.setInt(1, flightNumList.get(0));
						earliestFlightPS.setString(2, airlineIDList.get(0));
						ResultSet earliestFlightSet = earliestFlightPS.executeQuery();
						earliestFlightSet.next();
						
						java.sql.Time earliestTime = earliestFlightSet.getTime("departTime");
						
						//Then we have to calculate the total fare of the flight.
						float totalFare = 0;
						for (int i = 0; i < numFlights; i ++) {
							String currPriceQuery = "SELECT * FROM flights WHERE airlineID = ? and flightNum = ?";
							PreparedStatement currPricePS = con.prepareStatement(currPriceQuery);
							currPricePS.setString(1, airlineIDList.get(i));
							currPricePS.setInt(2, flightNumList.get(i));
							ResultSet priceSet = currPricePS.executeQuery();
							priceSet.next();
							totalFare += priceSet.getFloat("price");
						}
						
						//Finally, our cancel fee.
						String ticketClass = request.getParameter("ticketClass");
						float cancelFee = ((ticketClass.equals("e")) ? 30 : 0);
						
						
						//And now we execute the insertion for tickets.
						String insertTicket = "INSERT INTO tickets (departDate, departTime, totalFare, ticketClass, isCancelled, cancelFee) "
								+ "VALUES (?, ?, ?, ?, 'n', ?)";
						PreparedStatement insertTicketPS = con.prepareStatement(insertTicket);
						
						insertTicketPS.setDate(1, departDateList.get(0));
						insertTicketPS.setTime(2, earliestTime);
						insertTicketPS.setFloat(3, totalFare);
						insertTicketPS.setString(4, ticketClass);
						insertTicketPS.setFloat(5, cancelFee);
						
						insertTicketPS.executeUpdate();
						
						//Here, we get the newly created ticket id itself.
						ResultSet maxIDSet = stmt.executeQuery("select max(ticketID) maxID from tickets");
						maxIDSet.next();
						int maxID = maxIDSet.getInt("maxID");
						
						//And we also execute the insertion for buys.
						String insertBuys = "INSERT INTO buys (username, ticketID, purchaseDate, purchaseTime, bookingFee) "
								+ "VALUES (?, ?, curdate(), curtime(), 50)";
						PreparedStatement insertBuysPS = con.prepareStatement(insertBuys);
						insertBuysPS.setString(1, (String)session.getAttribute("user"));
						insertBuysPS.setInt(2, maxID);
						
						insertBuysPS.executeUpdate();

						//We also have to go throught each flight and add it to the includes table.
						for (int i = 0; i < numFlights; i++) {
							
							//Here, we get the next highest seat number available.
							String seatNumQuery = "SELECT * FROM includes, " +
									"(SELECT ticketID FROM tickets WHERE isCancelled = 'n') cancelCheck " +
									"WHERE includes.ticketID = cancelCheck.ticketID " +
									"AND airlineID = ? AND flightNum = ? AND departDate = ? ORDER BY seatNum ASC";
							
							PreparedStatement seatNumPS = con.prepareStatement(seatNumQuery);
							seatNumPS.setString(1, airlineIDList.get(i));
							seatNumPS.setInt(2, flightNumList.get(i));
							seatNumPS.setDate(3, departDateList.get(i));
							
							ResultSet seatNumSet = seatNumPS.executeQuery();
							
							
							int seatNum = 1;
							//First, check if there are even people in the same flight, and if there aren't
							//Set the user to be have seat number 1
							if (!seatNumSet.isBeforeFirst() ) {    
							    seatNum = 1;
							} else {
								//Otherwise, we run an algorithm to find the next unused number.
								
								while(seatNumSet.next()) {
									//If the item has a discrepancy, then we found our seat number.
									if (seatNum != seatNumSet.getInt("seatNum")) {
										break;
									} else {
										//otherwise, just increment
										seatNum ++;
									}
								}
							}
							
							
							String insertIncludes = "INSERT INTO includes (ticketID, airlineID, flightNum, departDate, arrivalDate, seatNum) "
									+ "VALUES (?, ?, ?, ?, ?, ?)";
							PreparedStatement insertIncludesPS = con.prepareStatement(insertIncludes);
							
							insertIncludesPS.setInt(1, maxID);
							insertIncludesPS.setString(2, airlineIDList.get(i));
							insertIncludesPS.setInt(3, flightNumList.get(i));
							insertIncludesPS.setDate(4, departDateList.get(i));
							insertIncludesPS.setDate(5, arrivalDateList.get(i));
							insertIncludesPS.setInt(6, seatNum);
							
							insertIncludesPS.executeUpdate();
						}
						
						//Furthermore, we should also remove the user from any waitlists of these flights.
						for (int i = 0; i < numFlights; i ++) {
							String deleteWaitlistQuery = "DELETE FROM in_waitlist_of WHERE airlineID = ? AND flightNum = ? AND departDate = ? AND username = ?";
							PreparedStatement deleteWaitlistPS = con.prepareStatement(deleteWaitlistQuery);
							deleteWaitlistPS.setString(1, airlineIDList.get(i));
							deleteWaitlistPS.setInt(2, flightNumList.get(i));
							deleteWaitlistPS.setDate(3, departDateList.get(i));
							deleteWaitlistPS.setString(4, (String)session.getAttribute("user"));
							
							deleteWaitlistPS.executeUpdate();
							
						}
						
						//Finally, print out the ticket number for the user.
						out.print("OUTBOUND: Ticket purchased. Your ticket number: " + maxID);
					}
					
				}
			}
			
			%><br><%
			
			//Then, run everything for the return trip.
			if (!request.getParameter("return").equals("null")) {
				
				String tripString = request.getParameter("return");
				//out.print(tripString);
							
				ArrayList<String> tripArray = new ArrayList<String>();
				
				//Arraylists for each of the types of input necessary
				ArrayList<String> airlineIDList = new ArrayList<String>();
				ArrayList<Integer> flightNumList = new ArrayList<Integer>();
				ArrayList<java.sql.Date> departDateList = new ArrayList<java.sql.Date>();
				ArrayList<java.sql.Date> arrivalDateList = new ArrayList<java.sql.Date>();
				ArrayList<Float> priceList = new ArrayList<Float>();
				
				StringTokenizer tripTokens = new StringTokenizer(tripString, "_");
				
				//Skips number of flights and "outbound/return" tag
				tripTokens.nextToken();
				tripTokens.nextToken();
				
				
				while (tripTokens.hasMoreTokens()) {
					String currToken = tripTokens.nextToken();
					if (currToken.equals("flight1") || currToken.equals("flight2") || currToken.equals("flight3")) continue;
					tripArray.add(currToken);
					//out.print(currToken + " ");
				}
				
				
				//Populate airlineIDs
				for (int i = 0; i < tripArray.size(); i+=7) {
					airlineIDList.add(tripArray.get(i));
				}
				
				//Populate flightNums
				for (int i = 1; i < tripArray.size(); i+=7) {
					flightNumList.add(Integer.parseInt(tripArray.get(i)));
				}
				
				//Populate departDates
				for (int i = 4; i < tripArray.size(); i+=7) {
					departDateList.add(java.sql.Date.valueOf(tripArray.get(i)));
				}
				
				//Populate departDates
				for (int i = 5; i < tripArray.size(); i+=7) {
					arrivalDateList.add(java.sql.Date.valueOf(tripArray.get(i)));
				}
				
				//Populate prices
				for (int i = 6; i < tripArray.size(); i+=7) {
					priceList.add(Float.parseFloat(tripArray.get(i)));
				}
				
				
				//This part gets the number of flights as a stable variable
				int numFlights = flightNumList.size();
				
				/*
				for (int i = 0; i < airlineIDList.size(); i++) {
					out.print(airlineIDList.get(i) + " " 
							+ flightNumList.get(i) + " " 
							+ departDateList.get(i) + " " 
							+ arrivalDateList.get(i) + " "
							+ priceList.get(i) );
				
					
				}
				*/
				
				
				
				boolean alreadyOnFlight = false;
				//First, we check to see if the user is already on any of the flights.

				for (int i = 0; i < numFlights; i ++) {
					String checkQuery = "SELECT * FROM buys " +
							"JOIN (SELECT ticketID, isCancelled FROM tickets) tickets USING (ticketID) " +
							"JOIN includes USING (ticketID) " +
							"JOIN flights USING (flightNum, airlineID) " +
							"WHERE airlineID = ? AND flightNum = ? AND username = ? AND departDate = ? AND isCancelled = 'n'";
					PreparedStatement checkPS = con.prepareStatement(checkQuery);
					checkPS.setString(1, airlineIDList.get(i));
					checkPS.setInt(2, flightNumList.get(i));
					checkPS.setString(3, (String)session.getAttribute("user"));
					checkPS.setDate(4, departDateList.get(i));
					ResultSet checkSet = checkPS.executeQuery();
					
					if(checkSet.isBeforeFirst()) {
						alreadyOnFlight = true;
					}
							
				}
				
				//If the user is already on a flight, prevent them from registering.
				if (alreadyOnFlight) {
					out.print("RETURN: You are already registered for at least one flight in this trip.");
				} else {
					
					//second, we check to see if all each of the flights are actually available.
					boolean hasFullFlight = false;
					
					for (int i = 0; i < numFlights; i ++) {
						String flightFullQuery = "SELECT airlineID, flightNum, departDate, numOfSeats, if(ISNULL(numPeople), 0, numPeople) numPeople "  + 
								"FROM " +
								
								"(SELECT * FROM flights " +   
								"JOIN uses USING (flightNum, airlineID) " +
								"JOIN aircraft USING (aircraftID)) seatNums " +


								"LEFT JOIN (SELECT airlineID, flightNum, departDate, count(*) as numPeople " +  
								"FROM " +   
								"(SELECT i.airlineID, i.flightNum, i.departDate " +   
								"FROM includes i, tickets t  " +   
								"WHERE i.ticketID = t.ticketID " +
								"AND isCancelled = 'n') temp  " +
								"GROUP BY airlineID, flightNum, departDate) peopleNum " +

							"USING (airlineID, flightNum) " +
							"WHERE airlineID = ? AND flightNum = ? AND departDate = ?";
						
						PreparedStatement flightFullPS = con.prepareStatement(flightFullQuery);
						flightFullPS.setString(1, airlineIDList.get(i));
						flightFullPS.setInt(2, flightNumList.get(i));
						flightFullPS.setDate(3, departDateList.get(i));
						
						ResultSet flightFullSet = flightFullPS.executeQuery();
						
						//First, if there isn't any tuples, then that means that no one is on this specific flight yet, so we're good
						if (!flightFullSet.isBeforeFirst()) {    
						    //leave this empty
						} else {
							flightFullSet.next();
							
							//If a flight is full, add the user to the waitlist for it
							if (flightFullSet.getInt("numOfSeats") <= flightFullSet.getInt("numPeople")) {
								hasFullFlight = true;
								
								String insertWaitlistQuery = "INSERT INTO in_waitlist_of (username, airlineID, flightNum, alert, departDate, arrivalDate) "
										+ "VALUES (?, ?, ?, ?, ?, ?)";
								PreparedStatement insertWaitlistPS = con.prepareStatement(insertWaitlistQuery);
								
								insertWaitlistPS.setString(1, (String)session.getAttribute("user"));
								insertWaitlistPS.setString(2, airlineIDList.get(i));
								insertWaitlistPS.setInt(3, flightNumList.get(i));
								insertWaitlistPS.setString(4, "Watching availability for: " + airlineIDList.get(i) + flightNumList.get(i)
									+ " (Departing on: " +  departDateList.get(i)+")");
								insertWaitlistPS.setDate(5, departDateList.get(i));
								insertWaitlistPS.setDate(6, arrivalDateList.get(i));
								
								insertWaitlistPS.executeUpdate();
								
							}
						}
					}
					
					
					//If there's at least one flight that isn't avaiable, this puts the user on the waitlist for that flight, and prevents them from booking the trip.
					if (hasFullFlight) {
						out.print("RETURN: Sorry, at least one flight in that trip is full. As such, you have been put on a waitlist for the full flight(s).");
					} else {
						//Otherwise, go ahead with adding the ticket.
						
						
						//This is where the ticket values get figured out and inputted.
						
						//First, we gotta get the time of the earliest flight.
						String earliestFlightQuery = "SELECT * FROM departs_from WHERE flightNum = ? AND airlineID = ? ";
						PreparedStatement earliestFlightPS = con.prepareStatement(earliestFlightQuery);
						earliestFlightPS.setInt(1, flightNumList.get(0));
						earliestFlightPS.setString(2, airlineIDList.get(0));
						ResultSet earliestFlightSet = earliestFlightPS.executeQuery();
						earliestFlightSet.next();
						
						java.sql.Time earliestTime = earliestFlightSet.getTime("departTime");
						
						//Then we have to calculate the total fare of the flight.
						float totalFare = 0;
						for (int i = 0; i < numFlights; i ++) {
							String currPriceQuery = "SELECT * FROM flights WHERE airlineID = ? and flightNum = ?";
							PreparedStatement currPricePS = con.prepareStatement(currPriceQuery);
							currPricePS.setString(1, airlineIDList.get(i));
							currPricePS.setInt(2, flightNumList.get(i));
							ResultSet priceSet = currPricePS.executeQuery();
							priceSet.next();
							totalFare += priceSet.getFloat("price");
						}
						
						//Finally, our cancel fee.
						String ticketClass = request.getParameter("ticketClass");
						float cancelFee = ((ticketClass.equals("e")) ? 30 : 0);
						
						
						//And now we execute the insertion for tickets.
						String insertTicket = "INSERT INTO tickets (departDate, departTime, totalFare, ticketClass, isCancelled, cancelFee) "
								+ "VALUES (?, ?, ?, ?, 'n', ?)";
						PreparedStatement insertTicketPS = con.prepareStatement(insertTicket);
						
						insertTicketPS.setDate(1, departDateList.get(0));
						insertTicketPS.setTime(2, earliestTime);
						insertTicketPS.setFloat(3, totalFare);
						insertTicketPS.setString(4, ticketClass);
						insertTicketPS.setFloat(5, cancelFee);
						
						insertTicketPS.executeUpdate();
						
						//Here, we get the newly created ticket id itself.
						ResultSet maxIDSet = stmt.executeQuery("select max(ticketID) maxID from tickets");
						maxIDSet.next();
						int maxID = maxIDSet.getInt("maxID");
						
						//And we also execute the insertion for buys.
						String insertBuys = "INSERT INTO buys (username, ticketID, purchaseDate, purchaseTime, bookingFee) "
								+ "VALUES (?, ?, curdate(), curtime(), 50)";
						PreparedStatement insertBuysPS = con.prepareStatement(insertBuys);
						insertBuysPS.setString(1, (String)session.getAttribute("user"));
						insertBuysPS.setInt(2, maxID);
						
						insertBuysPS.executeUpdate();

						//We also have to go throught each flight and add it to the includes table.
						for (int i = 0; i < numFlights; i++) {
							
							//Here, we get the next highest seat number available.
							String seatNumQuery = "SELECT * FROM includes, " +
									"(SELECT ticketID FROM tickets WHERE isCancelled = 'n') cancelCheck " +
									"WHERE includes.ticketID = cancelCheck.ticketID " +
									"AND airlineID = ? AND flightNum = ? AND departDate = ? ORDER BY seatNum ASC";
							
							PreparedStatement seatNumPS = con.prepareStatement(seatNumQuery);
							seatNumPS.setString(1, airlineIDList.get(i));
							seatNumPS.setInt(2, flightNumList.get(i));
							seatNumPS.setDate(3, departDateList.get(i));
							
							ResultSet seatNumSet = seatNumPS.executeQuery();
							
							
							int seatNum = 1;
							//First, check if there are even people in the same flight, and if there aren't
							//Set the user to be have seat number 1
							if (!seatNumSet.isBeforeFirst() ) {    
							    seatNum = 1;
							} else {
								//Otherwise, we run an algorithm to find the next unused number.
								
								while(seatNumSet.next()) {
									//If the item has a discrepancy, then we found our seat number.
									if (seatNum != seatNumSet.getInt("seatNum")) {
										break;
									} else {
										//otherwise, just increment
										seatNum ++;
									}
								}
							}
							
							
							String insertIncludes = "INSERT INTO includes (ticketID, airlineID, flightNum, departDate, arrivalDate, seatNum) "
									+ "VALUES (?, ?, ?, ?, ?, ?)";
							PreparedStatement insertIncludesPS = con.prepareStatement(insertIncludes);
							
							insertIncludesPS.setInt(1, maxID);
							insertIncludesPS.setString(2, airlineIDList.get(i));
							insertIncludesPS.setInt(3, flightNumList.get(i));
							insertIncludesPS.setDate(4, departDateList.get(i));
							insertIncludesPS.setDate(5, arrivalDateList.get(i));
							insertIncludesPS.setInt(6, seatNum);
							
							insertIncludesPS.executeUpdate();
						}
						
						//Furthermore, we should also remove the user from any waitlists of these flights.
						for (int i = 0; i < numFlights; i ++) {
							String deleteWaitlistQuery = "DELETE FROM in_waitlist_of WHERE airlineID = ? AND flightNum = ? AND departDate = ? AND username = ?";
							PreparedStatement deleteWaitlistPS = con.prepareStatement(deleteWaitlistQuery);
							deleteWaitlistPS.setString(1, airlineIDList.get(i));
							deleteWaitlistPS.setInt(2, flightNumList.get(i));
							deleteWaitlistPS.setDate(3, departDateList.get(i));
							deleteWaitlistPS.setString(4, (String)session.getAttribute("user"));
							
							deleteWaitlistPS.executeUpdate();
							
						}
						
						//Finally, print out the ticket number for the user.
						out.print("RETURN: Ticket purchased. Your ticket number: " + maxID);
					}
					
				}
			}
			
			
			
			
			
			
			con.close();
			
		} catch (Exception e) {
			
			out.print(e);
			
		} finally {
			%>
			<br>
			<form action="viewtickets.jsp">
			<input type="submit" value="View Tickets">
			</form>
			<%
		}
		%>
		
		
	</body>
</html>