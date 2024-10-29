<%@ include file="nav.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Student Data</title>
    <link rel="stylesheet" href="styles.css"> <!-- Link to CSS file -->
    <script>
        function submitForm(event) {
            event.preventDefault(); // Prevent the default form submission

            const form = document.getElementById("studentForm");
            const formData = new FormData(form);

            // Send the form data using fetch
            fetch("/mywebapp/submitStudentData", {
                method: "POST",
                body: formData
            })
            .then(response => response.text())
            .then(data => {
                // Show the success message
                document.getElementById("notification").innerText = data;
                // Reset the form fields
                form.reset();
            })
            .catch(error => {
                console.error("Error submitting data:", error);
                document.getElementById("notification").innerText = "Error submitting data.";
            });
        }
    </script>
</head>
<body>
    <h1>Student Data Form</h1>
    <div id="notification" style="color: green; margin-bottom: 10px;"></div> <!-- Notification area -->
    <form id="studentForm" onsubmit="submitForm(event)" method="post">
        <label for="firstName">First Name:</label>
        <input type="text" id="firstName" name="firstName" required>
        <br>

        <label for="lastName">Last Name:</label>
        <input type="text" id="lastName" name="lastName" required>
        <br>

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required>
        <br>

        <label for="studentNumber">Student Number:</label>
        <input type="number" id="studentNumber" name="studentNumber" required>
        <br>

        <input type="submit" value="Submit">
    </form>
</body>
</html>
