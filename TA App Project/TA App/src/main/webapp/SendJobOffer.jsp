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
 

    // Check if the entered credentials are valid
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;

    try {
        // Establish the database connection using the function
        connection = connectToDatabase();

        // Query the database for the TA credentials
        String r=request.getParameter("status");
        String pp=request.getParameter("s");
        String sql = "update job_application set status=? where application_id=?";
        preparedStatement = connection.prepareStatement(sql);
        if(pp.equals("accept"))
		{
			preparedStatement.setString(1, "Accepted");
	        preparedStatement.setString(2,r );
		}
        if(pp.equals("decline"))
		{
			preparedStatement.setString(1, "Declined");
	        preparedStatement.setString(2,r );
		}
        		if(pp.equals("send"))
        		{
        			preparedStatement.setString(1, "Job Offer Sent");
        	        preparedStatement.setString(2,r );
        		}
        		if(pp.equals("reject"))
        		{
        			preparedStatement.setString(1, "Rejected");
        	        preparedStatement.setString(2,r );
        		}
      
        
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