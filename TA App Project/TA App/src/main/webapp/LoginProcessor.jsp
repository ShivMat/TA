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
    String enteredUsername = request.getParameter("username");
    String enteredPassword = request.getParameter("password");

    // Check if the entered credentials are valid
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;

    try {
        // Establish the database connection using the function
        connection = connectToDatabase();

        // Query the database for the TA credentials
        String sql = "SELECT * FROM TAUsers WHERE username = ? AND password = ?";
        preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, enteredUsername);
        preparedStatement.setString(2, enteredPassword);
        resultSet = preparedStatement.executeQuery();

        if (resultSet.next()) {
            // Successful login
            session.setAttribute("loggedInUser", enteredUsername);
            response.sendRedirect("Welcome.jsp"); // Redirect to a welcome page or dashboard
        } else {
            // Failed login
            out.println("<p>Login failed. Please check your username and password.</p>");
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