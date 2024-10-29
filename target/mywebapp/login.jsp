<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ include file="/nav.jsp" %> <!-- Include the navigation bar if needed -->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <h2>Login</h2>
  <form method="post">
    <label for="usernameInput">Username:</label>
    <input type="text" id="usernameInput" name="username" required>
    
    <label for="passwordInput">Password:</label>
    <input type="password" id="passwordInput" name="password" required>
    
    <button type="submit">Login</button>
  </form>

  <p>Don't have an account? <a href="signup.jsp">Sign up here</a>.</p>
  <a href="resetPassword.jsp">Forgot Password?</a>


  <%
    if ("POST".equals(request.getMethod())) {
        // Rename local variables to avoid conflicts with session attributes
        String inputUsername = request.getParameter("username");
        String inputPassword = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/mydb?useSSL=false&serverTimezone=UTC";
            Connection conn = DriverManager.getConnection(url, "root", "Juliahunt76!##!");

            PreparedStatement ps = conn.prepareStatement("SELECT * FROM user WHERE username = ? AND password = ? AND approved = TRUE");
            ps.setString(1, inputUsername);
            ps.setString(2, inputPassword);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String userRole = rs.getString("role"); // Rename to avoid conflict
                session.setAttribute("username", inputUsername);
                session.setAttribute("role", userRole);
                response.sendRedirect("home.jsp"); // Redirect to homepage after login
            } else {
                out.println("<p>Invalid credentials or account not approved.</p>");
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
