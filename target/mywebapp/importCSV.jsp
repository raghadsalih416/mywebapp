package com.example.mywebapp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.apache.commons.csv.CSVRecord;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;

@MultipartConfig
public class FileUploadServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Part filePart = request.getPart("csvFile");

        // Check if a file was uploaded
        if (filePart == null || filePart.getSize() == 0) {
            response.getWriter().println("No file uploaded");
            return;
        }

        // Save the uploaded file temporarily
        String tempFilePath = "/tmp/" + filePart.getSubmittedFileName(); // Temporary storage
        try (InputStream fileContent = filePart.getInputStream()) {
            Files.copy(fileContent, Paths.get(tempFilePath), StandardCopyOption.REPLACE_EXISTING);
        }

        // Process the uploaded CSV file
        try (InputStreamReader fileReader = new InputStreamReader(Files.newInputStream(Paths.get(tempFilePath)));
             CSVParser parser = new CSVParser(fileReader, CSVFormat.DEFAULT.withHeader())) {
            
            List<CSVRecord> records = parser.getRecords();

            // Database connection
            String url = "jdbc:mysql://localhost:3306/mydb?useSSL=false&serverTimezone=UTC";
            try (Connection conn = DriverManager.getConnection(url, "root", "Juliahunt76!##!")) {
                // Iterate through each record and insert into the respective tables
                for (CSVRecord record : records) {
                    // Debugging output: Print the record being inserted
                    response.getWriter().println("Inserting record: " + record.toString());

                    String tableName = record.get("table"); // Get the table name from the CSV

                    try {
                        switch (tableName) {
                            case "PEEREVALS":
                                PreparedStatement psPeer = conn.prepareStatement("INSERT INTO PEEREVALS (MEMBERNAME, EVALUATIONID, SELFEVALSCORE, PEERRATERAVGSCORE, EXTERNALRATEAVGSCORE, TEAMSURVEYSCORE) VALUES (?, ?, ?, ?, ?, ?)");
                                psPeer.setString(1, record.get("username")); // MEMBERNAME
                                psPeer.setInt(2, 1); // Example EVALUATIONID
                                psPeer.setInt(3, 0); // SELFEVALSCORE
                                psPeer.setInt(4, 0); // PEERRATERAVGSCORE
                                psPeer.setInt(5, 0); // EXTERNALRATEAVGSCORE
                                psPeer.setInt(6, 0); // TEAMSURVEYSCORE
                                int peerRows = psPeer.executeUpdate();
                                response.getWriter().println(peerRows + " row(s) inserted into PEEREVALS.");
                                break;

                            case "StudentData":
                                PreparedStatement psStudent = conn.prepareStatement("INSERT INTO StudentData (FirstName, LastName, Email, SMUStudentNumber) VALUES (?, ?, ?, ?)");
                                psStudent.setString(1, record.get("FirstName")); // FirstName
                                psStudent.setString(2, record.get("LastName")); // LastName
                                psStudent.setString(3, record.get("Email")); // Email
                                psStudent.setLong(4, Long.parseLong(record.get("SMUStudentNumber"))); // SMUStudentNumber
                                int studentRows = psStudent.executeUpdate();
                                response.getWriter().println(studentRows + " row(s) inserted into StudentData.");
                                break;

                            case "CourseData":
                                PreparedStatement psCourse = conn.prepareStatement("INSERT INTO CourseData (CourseName, Semester, Year, Time, ProfessorID) VALUES (?, ?, ?, ?, ?)");
                                psCourse.setString(1, record.get("CourseName")); // CourseName
                                psCourse.setString(2, record.get("Semester")); // Semester
                                psCourse.setInt(3, Integer.parseInt(record.get("Year"))); // Year
                                psCourse.setString(4, record.get("Time")); // Time
                                psCourse.setLong(5, Long.parseLong(record.get("ProfessorID"))); // ProfessorID
                                int courseRows = psCourse.executeUpdate();
                                response.getWriter().println(courseRows + " row(s) inserted into CourseData.");
                                break;

                            default:
                                response.getWriter().println("Unknown table: " + tableName);
                        }
                    } catch (SQLException e) {
                        response.getWriter().println("Error inserting record: " + e.getMessage());
                        e.printStackTrace(); // Print stack trace for SQL errors
                    }
                }
            } catch (SQLException e) {
                response.getWriter().println("Database connection error: " + e.getMessage());
                e.printStackTrace();
            }
        } catch (Exception e) {
            response.getWriter().println("Error processing file: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
