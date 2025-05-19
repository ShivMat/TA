<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="DbConnection.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body><%
    // Retrieve form data
    String courseName = request.getParameter("courseName");
    String description = request.getParameter("description");

    // Auto-generate Course ID (you can customize this logic based on your requirements)
    int generatedCourseID = (int) (Math.random() * 1000);

    // Check if the Course ID is unique (you may want to enhance this logic in a real application)
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;

    try {
        // Establish the database connection using the function
        connection = connectToDatabase();

        // Check if the generated Course ID is unique
        String checkUniqueIDQuery = "SELECT * FROM course_table WHERE course_id = ?";
        preparedStatement = connection.prepareStatement(checkUniqueIDQuery);
        preparedStatement.setInt(1, generatedCourseID);
        resultSet = preparedStatement.executeQuery();

        // If the generated Course ID is not unique, generate a new one
        while (resultSet.next()) {
            generatedCourseID = (int) (Math.random() * 1000);
            preparedStatement.setInt(1, generatedCourseID);
            resultSet = preparedStatement.executeQuery();
        }

        // Insert the course details into the database
        String insertCourseQuery = "INSERT INTO course_table (course_id, course_name, description) VALUES (?, ?, ?)";
        preparedStatement = connection.prepareStatement(insertCourseQuery);
        preparedStatement.setInt(1, generatedCourseID);
        preparedStatement.setString(2, courseName);
        preparedStatement.setString(3, description);

        int rowsAffected = preparedStatement.executeUpdate();

        if (rowsAffected > 0) {
            out.println("<p>Course successfully added with Course ID: " + generatedCourseID + "</p>");
        } else {
            out.println("<p>Error adding course.</p>");
        }
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
    } finally {
        // Close resources
        try {
            if (resultSet != null) {
                resultSet.close();
            }
            if (preparedStatement != null) {
                preparedStatement.close();
            }
            if (connection != null) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
</body>
</html>