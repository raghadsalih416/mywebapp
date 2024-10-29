<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ include file="/nav.jsp" %> <!-- Include the navigation bar -->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>MYWEBAPP Home</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <header>
    <h1>Welcome to MYWEBAPP</h1>
    
    <!-- Display username if logged in -->
    <p class="welcome-message">
      <% 
        if (session.getAttribute("username") != null) { 
      %>
        Hello, <span class="username"><%= session.getAttribute("username") %></span>!
      <% } else { %>
        Please <a href="login.jsp" class="link">log in</a> to access the options.
      <% } %>
    </p>

    <% if (session.getAttribute("username") != null) { %>
      <p>Select an option to get started</p>
    <% } %>
  </header>

  <% if (session.getAttribute("username") != null) { %>
    <div class="buttons-container">
      <!-- Common options for all logged-in users -->
      <button onclick="location.href='index.jsp'" class="btn">Input Form</button>
      <button onclick="location.href='searchResults.jsp'" class="btn">Search Results</button>
      
      <% 
        // Access role directly from session without redeclaring
        if ("Admin".equals(session.getAttribute("role"))) { 
      %>
        <!-- Admin-specific options -->
        <button onclick="location.href='userManagement.jsp'" class="btn">User Role Management</button>
        <button onclick="location.href='batchImport.jsp'" class="btn">Batch Import</button>
      <% } else if ("User".equals(session.getAttribute("role"))) { %>
        <!-- User-specific options -->
        <button onclick="location.href='userContent.jsp'" class="btn">User Content</button>
      <% } %>
    </div>
  <% } %>
</body>
</html>
