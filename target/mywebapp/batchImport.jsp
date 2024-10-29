<%@ page import="java.io.*, java.sql.*, org.apache.commons.csv.*" %>
<%@ page session="true" %>
<%@ include file="/nav.jsp" %> <!-- Include the navigation bar -->

<%
  // Check the user's role from the session directly
  if (!"Admin".equals(session.getAttribute("role"))) {
      response.sendRedirect("home.jsp"); // Redirect non-admins to home
      return; // Stop further processing
  }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Batch Import</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <h2>Batch Data Import</h2>
  <form action="upload" method="POST" enctype="multipart/form-data">
    <input type="file" name="csvFile" required />
    <input type="submit" value="Upload" />
</form>


</body>
</html>
