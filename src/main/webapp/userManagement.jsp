<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ include file="nav.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>User Management</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <h2>User Management</h2>

  <table>
    <thead>
      <tr>
        <th>Username</th>
        <th>Role</th>
        <th>Approved</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/mydb?useSSL=false&serverTimezone=UTC";
            Connection conn = DriverManager.getConnection(url, "root", "Juliahunt76!##!");

            PreparedStatement ps = conn.prepareStatement("SELECT * FROM user WHERE approved = FALSE");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
      %>
              <tr>
                <td><%= rs.getString("username") %></td>
                <td><%= rs.getString("role") %></td>
                <td><%= rs.getBoolean("approved") %></td>
                <td>
                  <a href="approveUser.jsp?id=<%= rs.getInt("id") %>">Approve</a>
                  <a href="deleteUser.jsp?id=<%= rs.getInt("id") %>">Delete</a>
                </td>
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
