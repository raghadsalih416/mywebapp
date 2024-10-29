<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ include file="/nav.jsp" %> <!-- Include the navigation bar -->

<%
  String role = (String) session.getAttribute("role");
  if (role == null || !"Admin".equals(role)) {
      response.sendRedirect("home.jsp");
      return;
  }

  int userId = Integer.parseInt(request.getParameter("id"));

  try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      String url = "jdbc:mysql://localhost:3306/mydb?useSSL=false&serverTimezone=UTC";
      Connection conn = DriverManager.getConnection(url, "root", "Juliahunt76!##!");

      PreparedStatement ps = conn.prepareStatement("DELETE FROM user WHERE id = ?");
      ps.setInt(1, userId);
      ps.executeUpdate();

      conn.close();
  } catch (Exception e) {
      e.printStackTrace();
      out.println("<p>Error denying user: " + e.getMessage() + "</p>");
  }

  response.sendRedirect("userApproval.jsp");
%>
