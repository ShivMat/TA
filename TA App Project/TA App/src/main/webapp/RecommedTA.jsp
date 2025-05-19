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
        String r=request.getParameter("status");
        String sql = "update job_application set status=? where application_id=?";
        preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, "Recommeded to Commitee");
        preparedStatement.setString(2,r );
        int p = preparedStatement.executeUpdate();

        if (p>0) {
        	out.println("Status Updated");
            } else {
            	out.println("some problem");}
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