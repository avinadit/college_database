<html>
<head>
<title>MyTriton:CSE132B</title>
<link href="Style.css" rel="stylesheet" type="text/css">
</head>
<body background="wood_background1.jpg">


	<table border="0">
		<tr>
			<td valign="top"><p class="centeredImage">
					<img src="header.jpg" align="middle" />
				</p></td>
		</tr>
	</table>
	<%-- -------- Include menu HTML code -------- --%>
	<jsp:include page="menu.html" />
	<table border="1">

		<tr>
			<td valign="top"></td>
			<td>
				<%-- Set the scripting language to Java and --%> <%-- Import the java.sql package --%>
				<%@ page language="java" import="java.sql.*"%>

				<%-- -------- Open Connection Code -------- --%> <%
 	try {

 		DriverManager
 				.registerDriver(new com.microsoft.sqlserver.jdbc.SQLServerDriver());

 		Connection conn = DriverManager
 				.getConnection(
 						"jdbc:sqlserver://128.54.26.173:1433;databaseName=MyTriton;",
 						"avinash", "avinash");
 %> <%-- -------- INSERT Code -------- --%> <%
 	String action = request.getParameter("action");
 		// Check if an insertion is requested
 		if (action != null && action.equals("insert")) {

 			// Begin transaction
 			conn.setAutoCommit(false);

 			// Create the prepared statement and use it to
 			// INSERT the student attributes INTO the Student table.
 			PreparedStatement pstmt = conn
 					.prepareStatement("INSERT INTO Student VALUES (?, ?, ?, ?, ?, ?,?,?)");

 			pstmt.setString(1, request.getParameter("StudentID"));
 			pstmt.setString(2, request.getParameter("FirstName"));
 			pstmt.setString(3, request.getParameter("MiddleName"));
 			pstmt.setString(4, request.getParameter("LastName"));
 			pstmt.setString(5, request.getParameter("SSN"));
 			pstmt.setInt(6, Integer.parseInt(request
 					.getParameter("GradStatus")));
 			pstmt.setInt(7, Integer.parseInt(request
 					.getParameter("ResidencyStatusID")));
 			pstmt.setInt(8,
 					Integer.parseInt(request.getParameter("DegreeID")));
 			try {
 				int rowCount = pstmt.executeUpdate();

 				// Commit transaction
 				conn.commit();
 				conn.setAutoCommit(true);
 			} catch (SQLException sqle) {
 				out.println(sqle.getMessage());
 				conn.rollback();
 				conn.setAutoCommit(true);
 				out.println("  |sql Exception occured- Rolling back gracfully |  ");

 			} catch (Exception e) {
 				out.println(e.getMessage());
 			}
 		}
 %> <%-- -------- UPDATE Code -------- --%> <%
 	// Check if an update is requested
 		if (action != null && action.equals("update")) {

 			// Begin transaction
 			conn.setAutoCommit(false);

 			// Create the prepared statement and use it to
 			// UPDATE the student attributes in the Student table.
 			PreparedStatement pstmt = conn
 					.prepareStatement("UPDATE Student SET StudentID = ?, FirstName = ?, "
 							+ "MiddleName = ?, LastName = ?, GradStatus = ?, ResidencyStatusID = ?, DegreeID =? WHERE SSN = ?");

 			pstmt.setString(1, request.getParameter("StudentID"));
 			pstmt.setString(2, request.getParameter("FirstName"));
 			pstmt.setString(3, request.getParameter("MiddleName"));
 			pstmt.setString(4, request.getParameter("LastName"));
 			pstmt.setInt(5, Integer.parseInt(request
 					.getParameter("GradStatus")));
 			pstmt.setInt(6, Integer.parseInt(request
 					.getParameter("ResidencyStatusID")));
 			pstmt.setInt(7,
 					Integer.parseInt(request.getParameter("DegreeID")));
 			pstmt.setString(8, request.getParameter("SSN"));

 			try {

 				int rowCount = pstmt.executeUpdate();

 				// Commit transaction
 				conn.commit();
 				conn.setAutoCommit(true);
 			} catch (Exception e) {

 				conn.rollback();
 				conn.setAutoCommit(true);
 				out.println("   |sql Exception occured- Rolling back gracfully|  ");
 			}
 		}
 %> <%-- -------- DELETE Code -------- --%> <%
 	// Check if a delete is requested
 		if (action != null && action.equals("delete")) {

 			// Begin transaction
 			conn.setAutoCommit(false);

 			// Create the prepared statement and use it to
 			// DELETE the student FROM the Student table.
 			PreparedStatement pstmt = conn
 					.prepareStatement("DELETE FROM Student WHERE SSN = ?");

 			pstmt.setString(1, request.getParameter("SSN"));
 			try {

 				int rowCount = pstmt.executeUpdate();

 	 			// Commit transaction
 	 			conn.commit();
 	 			conn.setAutoCommit(true);
 			} catch (Exception e) {

 				conn.rollback();
 				conn.setAutoCommit(true);
 				out.println("   |sql Exception occured- Rolling back gracfully|  ");
 			}

 			
 			
 		}
 %> <%-- -------- SELECT Statement Code -------- --%> <%
 	// Create the statement
 		Statement statement = conn.createStatement();

 		// Use the created statement to SELECT
 		// the student attributes FROM the Student table.
 		ResultSet rs = statement.executeQuery("SELECT * FROM Student");
 %> <!-- Add an HTML table header row to format the results -->
				<table border="1">
					<tr>
						<th>SSN</th>
						<th>StudentID</th>
						<th>FirstName</th>
						<th>MiddleName</th>
						<th>LastName</th>
						<th>GradStatus</th>
						<th>ResidencyStatusID</th>
						<th>DegreeID</th>
						<th>Action</th>
					</tr>
					<tr>
						<form action="students.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="StudentID" size="10"></th>
							<th><input value="" name="FirstName" size="15"></th>
							<th><input value="" name="MiddleName" size="15"></th>
							<th><input value="" name="LastName" size="15"></th>
							<th><input value="" name="GradStatus" size="15"></th>
							<th><input value="" name="ResidencyStatusID" size="15"></th>
							<th><input value="" name="DegreeID" size="15"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>

					<%-- -------- Iteration Code -------- --%>
					<%
						// Iterate over the ResultSet

							while (rs.next()) {
					%>

					<tr>
						<form action="students.jsp" method="get">
							<input type="hidden" value="update" name="action">

							<%-- Get the SSN, which is a number --%>
							<td><input value="<%=rs.getString("SSN")%>" name="SSN"
								size="10"></td>

							<%-- Get the StudentID --%>
							<td><input value="<%=rs.getString("StudentID")%>"
								name="StudentID" size="10"></td>

							<%-- Get the FirstName --%>
							<td><input value="<%=rs.getString("FirstName")%>"
								name="FirstName" size="15"></td>

							<%-- Get the MiddleName --%>
							<td><input value="<%=rs.getString("MiddleName")%>"
								name="MiddleName" size="15"></td>

							<%-- Get the LastName --%>
							<td><input value="<%=rs.getString("LastName")%>"
								name="LastName" size="15"></td>

							<%-- Get the  GradStatus --%>
							<td><input value="<%=rs.getInt("GradStatus")%>"
								name="GradStatus" size="15"></td>

							<%-- Get the ResidencyStatusID --%>
							<td><input value="<%=rs.getInt("ResidencyStatusID")%>"
								name="ResidencyStatusID" size="15"></td>
							<%-- Get the DegreeID --%>
							<td><input value="<%=rs.getInt("DegreeID")%>"
								name="DegreeID" size="15"></td>

							<%-- Button --%>
							<td><input type="submit" value="Update"></td>
						</form>
						<form action="students.jsp" method="get">
							<input type="hidden" value="delete" name="action"> <input
								type="hidden" value="<%=rs.getString("SSN")%>" name="SSN">
							<%-- Button --%>
							<td><input type="submit" value="Delete"></td>
						</form>
					</tr>
					<%
						}
					%>

					<%-- -------- Close Connection Code -------- --%>
					<%
						// Close the ResultSet
							rs.close();

							// Close the Statement
							statement.close();

							// Close the Connection
							conn.close();
						} catch (SQLException sqle) {
							out.println(sqle.getMessage());
						} catch (Exception e) {
							out.println(e.getMessage());
						}
					%>
				</table>
			</td>
		</tr>
	</table>
</body>

</html>
