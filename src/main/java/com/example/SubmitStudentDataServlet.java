package com.example.mywebapp;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.MultipartConfig;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@MultipartConfig
public class SubmitStudentDataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form data from the request
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String studentNumber = request.getParameter("studentNumber");
        String role = request.getParameter("role"); // Retrieve role from the form

        // Database connection and insertion logic
        try {
            // Connect to MySQL database
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/mydb?useSSL=false&serverTimezone=UTC";
            Connection conn = DriverManager.getConnection(url, "root", "Juliahunt76!##!");

            // SQL query for inserting data into StudentData table
            String query = "INSERT INTO StudentData (FirstName, LastName, Email, SMUStudentNumber, Role) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, firstName);
            stmt.setString(2, lastName);
            stmt.setString(3, email);
            stmt.setLong(4, Long.parseLong(studentNumber)); // Parse studentNumber to a long
            stmt.setString(5, role); // Set the role parameter

            // Execute the query and close resources
            stmt.executeUpdate();
            stmt.close();
            conn.close();

            // Send success response to the client
            response.getWriter().write("Student Data Submitted Successfully!");

        } catch (Exception e) {
            e.printStackTrace(); // Log error details
            response.getWriter().write("Error submitting data: " + e.getMessage()); // Send error response
        }
    }
}
