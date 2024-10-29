<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - My Application</title>
    <link rel="stylesheet" href="styles.css"> <!-- Link to your CSS file -->
    <script>
        function togglePasswordVisibility(passwordFieldId) {
            const passwordField = document.getElementById(passwordFieldId);
            const currentType = passwordField.getAttribute("type");
            passwordField.setAttribute("type", currentType === "password" ? "text" : "password");
        }
    </script>
</head>
<body>
    <header>
        <img src="smu4.png" alt="Logo" class="logo"> <!-- Placeholder for your logo -->
        <h1>Reset Your Password</h1>
    </header>

    <div class="form-container">
        <form id="resetPasswordForm" action="/mywebapp/resetPassword" method="POST">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" placeholder="Enter your username" required>
            
            <label for="oldPassword">Old Password:</label>
            <input type="password" id="oldPassword" name="oldPassword" placeholder="Enter your old password" required>
            <button type="button" onclick="togglePasswordVisibility('oldPassword')">Show</button>
            
            <label for="newPassword">New Password:</label>
            <input type="password" id="newPassword" name="newPassword" placeholder="Enter your new password" required>
            <button type="button" onclick="togglePasswordVisibility('newPassword')">Show</button>
            
            <input type="submit" value="Reset Password">
        </form>

        <div id="messageBox" style="margin-top: 10px;">
            <%
                String message = (String) request.getAttribute("message");
                if (message != null) {
                    out.println(message);
                }
            %>
        </div>

        <button type="button" onclick="window.location.href = 'login.jsp';">Back</button> <!-- Back button -->
    </div>
</body>
</html>
