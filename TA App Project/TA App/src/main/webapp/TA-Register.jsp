
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="DbConnection.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Form</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }
        .form-container {
            display: flex;
            justify-content: space-between;
            width: 600px;
        }
        .form-container div {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 48%;
        }
        label {
            display: block;
            margin-bottom: 8px;
            width: 100%;
        }
        input,
        textarea {
            width: 100%;
            padding: 8px;
            margin-bottom: 12px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        input[type="submit"] {
            background-color: #4caf50;
            color: #fff;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>

<%
    // Database connection details
  

    Connection connection = null;
    PreparedStatement preparedStatement = null;

    try {
        // Load the JDBC driver
         // Establish the database connection using the function from DbConnection.jsp
        connection = connectToDatabase();

        // Check if the form is submitted
        if (request.getMethod().equalsIgnoreCase("post")) {
            // Retrieve form data
            String fullName = request.getParameter("fullName");
            String mobileNumber = request.getParameter("mobileNumber");
            String usernameVal = request.getParameter("username");
            String passwordVal = request.getParameter("password");
            String repeatPassword = request.getParameter("repeatPassword");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String qualification = request.getParameter("qualification");

            // Insert data into the database
            String sql = "INSERT INTO TAusers (full_name, mobile_number, username, password, email, address, qualification) VALUES (?, ?, ?, ?, ?, ?, ?)";
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, fullName);
            preparedStatement.setString(2, mobileNumber);
            preparedStatement.setString(3, usernameVal);
            preparedStatement.setString(4, passwordVal);
            preparedStatement.setString(5, email);
            preparedStatement.setString(6, address);
            preparedStatement.setString(7, qualification);

            int rowsAffected = preparedStatement.executeUpdate();

            if (rowsAffected > 0) {
                out.println("<p>Data successfully inserted into the database.</p>");
            } else {
                out.println("<p>Error inserting data into the database.</p>");
            }
        }
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
    } finally {
        // Close resources
        try {
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

<div class="form-container">
    <div>
        <form action="#" method="post">
            <label for="fullName">Full Name:</label>
            <input type="text" id="fullName" name="fullName" required>

            <label for="mobileNumber">Mobile Number:</label>
            <input type="tel" id="mobileNumber" name="mobileNumber" pattern="[0-9]{10}" required>

            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>

            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>

            <label for="repeatPassword">Repeat Password:</label>
            <input type="password" id="repeatPassword" name="repeatPassword" required>
       
    </div>

    <div>
        
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>

            <label for="address">Address:</label>
            <textarea id="address" name="address" rows="4" required></textarea>

            <label for="qualification">Qualification:</label>
            <input type="text" id="qualification" name="qualification" required>

            <input type="submit" value="Register">
        </form><br><br><br><br>
         <center> <a href="TA-Login.jsp">Already Registered? Login</a></center>
    </div>
</div>

</body>
</html>