<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ include file="/nav.jsp" %> <!-- Include the navigation bar -->

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>User Approval Management</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <h2>User Approval Management</h2>
  
  <table>
    <thead>
      <tr>
        <th>Username</th>
        <th>Role</th>
        <th>Approve</th>
        <th>Deny</th>
      </tr>
    </thead>
    <tbody>
      <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/mydb?useSSL=false&serverTimezone=UTC";
            Connection conn = DriverManager.getConnection(url, "root", "Juliahunt76!##!");

            PreparedStatement ps = conn.prepareStatement("SELECT id, username, role FROM user WHERE approved = FALSE");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int userId = rs.getInt("id");
                String userRole = rs.getString("role"); // Get role from ResultSet
                // Use username directly from ResultSet
                String usernameFromDB = rs.getString("username"); 
      %>
                <tr>
                    <td><%= usernameFromDB %></td>
                    <td><%= userRole %></td>
                    <td><a href="approveUser.jsp?id=<%= userId %>">Approve</a></td>
                    <td><a href="denyUser.jsp?id=<%= userId %>">Deny</a></td>
                </tr>
      <%
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error loading users: " + e.getMessage() + "</p>");
        }
      %>
    </tbody>
  </table>
</body>
</html>
