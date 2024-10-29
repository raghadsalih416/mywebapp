package com.example.mywebapp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.apache.commons.csv.CSVRecord;


import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@MultipartConfig
public class FileUploadServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the uploaded file part
        Part filePart = request.getPart("csvFile");

        // Check if a file was uploaded
        if (filePart == null || filePart.getSize() == 0) {
            response.getWriter().println("No file uploaded");
            return;
        }

        // Get the name of the uploaded file
        String fileName = filePart.getSubmittedFileName();
        String directoryPath = "/Users/raghadsalih/myapp_uploads/"; // Update with your desired directory
        Path path = Paths.get(directoryPath);

        // Create the directory if it doesn't exist
        if (!Files.exists(path)) {
            Files.createDirectories(path);
        }

        // Save the uploaded file
        String filePath = directoryPath + fileName; // Full file path
        try (InputStream fileContent = filePart.getInputStream()) {
            Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
        }

        response.getWriter().println("File uploaded successfully");
    }
}
