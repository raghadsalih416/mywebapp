package com.example.mywebapp;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ResetPasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");

        String message = ""; // Initialize message

        try {
            // Connect to MySQL database
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/mydb?useSSL=false&serverTimezone=UTC";
            Connection conn = DriverManager.getConnection(url, "root", "Juliahunt76!##!");

            // Check if the old password is correct
            String query = "SELECT password FROM user WHERE username = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String dbOldPassword = rs.getString("password");
                if (dbOldPassword.equals(oldPassword)) { // Check if the old password matches
                    // Update the new password
                    String updateQuery = "UPDATE user SET password = ? WHERE username = ?";
                    PreparedStatement updateStmt = conn.prepareStatement(updateQuery);
                    updateStmt.setString(1, newPassword);
                    updateStmt.setString(2, username);
                    updateStmt.executeUpdate();
                    
                    message = "Password reset successfully.";
                } else {
                    message = "Old password is incorrect.";
                }
            } else {
                message = "No user found with this username.";
            }

            // Close resources
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
        }

        // Set message to request and forward back to form
        request.setAttribute("message", message);
        request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
    }
}

