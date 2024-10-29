<%@ page import="java.sql.*" %>
<%@ include file="nav.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Members</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h2>Search Members</h2>
    
    <form id="searchForm" method="get">
        <label for="searchInput">Search Member Name:</label>
        <input type="text" id="searchInput" name="memberName" value="<%= request.getParameter("memberName") != null ? request.getParameter("memberName") : "" %>">

        <label for="evaluationIdFilter">Filter by Evaluation ID:</label>
        <input type="number" id="evaluationIdFilter" name="evaluationIdFilter" value="<%= request.getParameter("evaluationIdFilter") != null ? request.getParameter("evaluationIdFilter") : "" %>">

        <label for="sortOrder">Sort By:</label>
        <select id="sortOrder" name="sortOrder">
            <option value="MEMBERNAME" <%= "MEMBERNAME".equals(request.getParameter("sortOrder")) ? "selected" : "" %>>Member Name</option>
            <option value="EVALUATIONID" <%= "EVALUATIONID".equals(request.getParameter("sortOrder")) ? "selected" : "" %>>Evaluation ID</option>
            <option value="SELFEVALSCORE" <%= "SELFEVALSCORE".equals(request.getParameter("sortOrder")) ? "selected" : "" %>>Self Eval Score</option>
        </select>

        <button type="submit">Search</button>
        <input type="button" value="Reset" onclick="resetForm()">
    </form>

    <script>
        // Reset the form and page
        function resetForm() {
            document.getElementById("searchInput").value = "";
            document.getElementById("evaluationIdFilter").value = "";
            document.getElementById("sortOrder").selectedIndex = 0; // Reset sort order to the first option

            // Optionally submit the form to clear the parameters in the URL
            document.getElementById("searchForm").submit();
        }
    </script>

    <table>
        <thead>
            <tr>
                <th>Member Name</th>
                <th>Evaluation ID</th>
                <th>Self Eval Score</th>
            </tr>
        </thead>
        <tbody>
            <%
            // Retrieve the search term, evaluation ID filter, and sorting order from the form input
            String memberName = request.getParameter("memberName");
            String evaluationIdFilter = request.getParameter("evaluationIdFilter");
            String sortOrder = request.getParameter("sortOrder");
            boolean hasResults = false;

            // Default sort order if none is selected
            if (sortOrder == null || sortOrder.isEmpty()) {
                sortOrder = "MEMBERNAME"; // Default sort by MEMBERNAME
            }

            // Initialize base query
            String query = "SELECT * FROM PEEREVALS WHERE 1=1";

            // Append conditions for search and filter
            if (memberName != null && !memberName.trim().isEmpty()) {
                query += " AND MEMBERNAME LIKE ?";
            }
            if (evaluationIdFilter != null && !evaluationIdFilter.isEmpty()) {
                query += " AND EVALUATIONID = ?";
            }
            query += " ORDER BY " + sortOrder;

            try {
                // Load the MySQL JDBC driver
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Set up the connection
                String url = "jdbc:mysql://localhost:3306/mydb?useSSL=false&serverTimezone=UTC";
                Connection conn = DriverManager.getConnection(url, "root", "Juliahunt76!##!");

                // Prepare the query
                PreparedStatement ps = conn.prepareStatement(query);
                int paramIndex = 1;

                if (memberName != null && !memberName.trim().isEmpty()) {
                    ps.setString(paramIndex++, "%" + memberName + "%"); // Use wildcard for partial match
                }
                if (evaluationIdFilter != null && !evaluationIdFilter.isEmpty()) {
                    ps.setInt(paramIndex++, Integer.parseInt(evaluationIdFilter));
                }

                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    hasResults = true;
            %>
                    <tr>
                        <td><%= rs.getString("MEMBERNAME") %></td>
                        <td><%= rs.getInt("EVALUATIONID") %></td>
                        <td><%= rs.getInt("SELFEVALSCORE") %></td>
                    </tr>
            <%
                }
                conn.close(); // Close the connection
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<tr><td colspan='3'>An error occurred: " + e.getMessage() + "</td></tr>");
            }

            if (!hasResults) {
            %>
                <tr><td colspan="3">No results found for "<%= memberName != null ? memberName : "" %>".</td></tr>
            <%
            }
            %>
        </tbody>
    </table>
</body>
</html>
