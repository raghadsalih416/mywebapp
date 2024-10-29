<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
%>

<nav>
  <div class="logo">
    <img src="images/smu4.png" alt="My Web App Logo" style="width: 100px; height: auto;"> <!-- Adjust size as needed -->
  </div>
  
  <ul>
    <li><a href="home.jsp">Home</a></li>
    
    <% if (username == null) { %>
      <!-- Links for non-logged-in users -->
      <li><a href="login.jsp">Login</a></li>
      <li><a href="signup.jsp">Sign Up</a></li>
    <% } else { %>
      <!-- Links for logged-in users -->
      <li><a href="profile.jsp">Profile</a></li>

      <% if ("Admin".equals(role)) { %>
        <li><a href="userManagement.jsp">User Role Management</a></li>
        <li><a href="batchImport.jsp">Batch Import</a></li>
      <% } %>

      <% if ("Admin".equals(session.getAttribute("role"))) { %>
        <li><a href="userApproval.jsp">User Approval</a></li>
      <% } %>

      <% if ("User".equals(role) || "Admin".equals(role)) { %>
        <li><a href="userContent.jsp">User Content</a></li>
      <% } %>

      <li><a href="logout.jsp">Logout</a></li>
    <% } %>
  </ul>
</nav>

<style>
  /* Styling for the nav bar */
  nav {
    display: flex;
    align-items: center; /* Align items vertically */
    padding: 10px;
    background-color: #007BFF; /* Navbar background color */
  }

  .logo img {
    width: 100px; /* Set the logo width */
    height: auto; /* Maintain aspect ratio */
    margin-right: 20px; /* Space between logo and nav links */
  }

  nav ul {
    list-style-type: none;
    padding: 0;
    display: flex;
    gap: 10px; /* Space between links */
    margin: 0; /* Reset margin */
  }

  nav ul li {
    display: inline;
  }

  nav ul li a {
    text-decoration: none;
    color: #fff; /* Text color for links */
    padding: 8px 12px;
    background-color: lightblue; /* Link background color */
    border-radius: 4px;
    transition: background-color 0.3s ease; /* Transition for hover effect */
  }

  nav ul li a:hover {
    background-color: lightblue; /* Darker green on hover */
  }
</style>
