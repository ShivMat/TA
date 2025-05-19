<%@ page import="java.io.File" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.nio.file.Files" %>
<%@ page import="java.nio.file.StandardCopyOption" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.UUID" %>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Job Application</title>
    <style>
        /* Your existing styles here */
    </style>
    <script>
        /* Your existing scripts here */
    </script>
</head>
<body>
    <h1>Job Application</h1>

  

    <%-- Perform database insertion directly in JSP (Not recommended) --%>
    <% if ("POST".equals(request.getMethod())) 
    { 
      
            // Get form data
         
         // Get form data
            String courseId = request.getParameter("courseId");
            String username = request.getParameter("username");
            String hasServedAsTA = request.getParameter("hasServedAsTA");
            System.out.println(courseId);
            System.out.println(username);
            System.out.println(hasServedAsTA);
            StringBuilder concatenatedData=null;
            if(hasServedAsTA.equals("yes")) 
            {
            // Get arrays of relevant courses, from dates, and to dates submitted by the user
            String[] relevantCourses = request.getParameterValues("relevantCourses");
            String[] fromDates = request.getParameterValues("fromDate");
            String[] toDates = request.getParameterValues("toDate");

            // Concatenate relevant courses, from dates, and to dates into a single string with a separator
             concatenatedData = new StringBuilder();
            for (int i = 0; i < relevantCourses.length; i++) {
                concatenatedData.append(relevantCourses[i]);
                concatenatedData.append(",");
                concatenatedData.append(fromDates[i]);
                concatenatedData.append(",");
                concatenatedData.append(toDates[i]);
                concatenatedData.append(";");
            }
            }
            else 
            {
            	 concatenatedData.append("no");
            }

            // Get the Part for the uploaded file
            Part resumePart = request.getPart("resume");

            // Process file upload
            String fileName = resumePart.getSubmittedFileName();
            InputStream fileContent = resumePart.getInputStream();

            // Generate a unique filename to avoid overwriting
            String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;

            // Specify the directory to store the uploaded file
            String uploadPath = "C:/Users/Empow/OneDrive/Desktop/uploads/"; // Change this to your desired directory

            // Create the directory if it doesn't exist
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            // Save the file to the server
            File uploadedFile = new File(uploadPath + File.separator + uniqueFileName);
            Files.copy(fileContent, uploadedFile.toPath(), StandardCopyOption.REPLACE_EXISTING);

            // Save the file path or unique filename
            String resumeFilePath = uploadedFile.getAbsolutePath();

            // Cleanup: delete the temporary file if needed
            // uploadedFile.delete();

            // Insert data into the database
            try {
                Class.forName("com.mysql.jdbc.Driver");
                String jdbcURL = "jdbc:mysql://localhost:3306/TA";
                String dbUser = "root";
                String dbPassword = "root";
                Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

                String sql = "INSERT INTO job_application (course_id, username, has_served_as_ta, resume) VALUES (?, ?, ?, ?)";
                try (PreparedStatement statement = connection.prepareStatement(sql)) 
                {
                    statement.setString(1, courseId);
                    statement.setString(2, username);
                    statement.setString(3, hasServedAsTA);
                    statement.setString(4, resumeFilePath);

                    statement.executeUpdate();
                }

                connection.close();
            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace();
            }

            // Redirect to a success page or any other appropriate action
            response.sendRedirect("success.jsp");
    }  %>

    