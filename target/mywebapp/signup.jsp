<%@ page import="java.sql.*" %>
<%@ include file="nav.jsp" %> <!-- Include the navigation bar if needed -->

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sign Up</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <h2>Sign Up</h2>
  <form id="signupForm" method="post">
    <label for="usernameInput">Username:</label>
    <input type="text" id="usernameInput" name="username" required>
    
    <label for="passwordInput">Password:</label>
    <input type="password" id="passwordInput" name="password" required>
    
    <label for="roleInput">Role:</label>
    <select id="roleInput" name="role">
      <option value="User">User</option>
      <option value="Admin">Admin</option>
    </select>

    <button type="submit">Create Account</button>
  </form>

  <%
    if (request.getMethod().equals("POST")) {
        // Renamed local variables to avoid conflict with session attributes
        String newUsername = request.getParameter("username");
        String newPassword = request.getParameter("password");
        String newRole = request.getParameter("role");

        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect to the database
            String url = "jdbc:mysql://localhost:3306/mydb?useSSL=false&serverTimezone=UTC";
            Connection conn = DriverManager.getConnection(url, "root", "Juliahunt76!##!");

            // Insert user data
            PreparedStatement ps = conn.prepareStatement("INSERT INTO user (username, password, role, approved) VALUES (?, ?, ?, ?)");
            ps.setString(1, newUsername);
            ps.setString(2, newPassword); // Normally, password should be hashed
            ps.setString(3, newRole);
            ps.setBoolean(4, false); // Set approved to false initially

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                out.println("<p>Account successfully created! Awaiting admin approval.</p>");
            } else {
                out.println("<p>Error creating account.</p>");
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>An error occurred: " + e.getMessage() + "</p>");
        }
    }
  %>
</body>
</html>
