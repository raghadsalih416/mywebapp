package com.example.mywebapp;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.UUID;

public class SendResetLinkServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String resetToken = UUID.randomUUID().toString(); // Generate a unique token

        try {
            // Connect to the database
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/mydb?useSSL=false&serverTimezone=UTC";
            Connection conn = DriverManager.getConnection(url, "root", "Juliahunt76!##!");

            // Store the token in the database with an expiry time
            String query = "UPDATE Users SET reset_token = ?, token_expiry = NOW() + INTERVAL 1 HOUR WHERE email = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, resetToken);
            stmt.setString(2, email);
            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated > 0) {
                // Send an email with the reset link (implement the email sending logic)
                String resetLink = "http://yourdomain.com/mywebapp/resetPassword.jsp?token=" + resetToken;
                sendResetEmail(email, resetLink);
                response.getWriter().write("Reset link sent to your email.");
            } else {
                response.getWriter().write("Email not found.");
            }

            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error processing request: " + e.getMessage());
        }
    }

    private void sendResetEmail(String email, String resetLink) {
        // Implement your email sending logic here
        // This might involve using JavaMail API or another email service
    }
}
