<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="DbConnection.jsp" %><!DOCTYPE html>
<%!    Connection connection = null;
Statement statement = null;
ResultSet resultSet = null; %>
<%
//Check if the session is not null and if a specific attribute is set
if (session != null && session.getAttribute("loggedInUser") != null) {
	

    // Session is valid, continue with your logic
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home</title>
    <style>
        /* Add your styling here */
        body {
            font-family: Arial, sans-serif;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
        }

        .menu {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .menu div {
            flex-grow: 1;
            padding: 10px;
            text-align: center;
            background-color: #f2f2f2;
            border: 1px solid #ddd;
            cursor: pointer;
        }

        .content {
            border: 1px solid #ddd;
            padding: 20px;
        }
    </style>
</head>
<body>

<div class="container">
<h1>Welcome TA</h1> <a href="Logout.jsp"><img src="logout.png" width=50 height=50></a>
    <div class="menu">
        <div onclick="showDiv('ApplyHere')">Apply Here</div>
         <div onclick="showDiv('Jobs')">Job Status</div>
                 <div onclick="showDiv('MyClasses')">Upload Marks</div>
       
    </div>

    <div class="content" id="ApplyHere">
        <h2>Choose your course to apply as Teaching Assistant</h2>
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
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 400px;
        }
        label {
            display: block;
            margin-bottom: 8px;
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
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #4caf50;
            color: #fff;
        }
    </style>
</head>
<body>

<%
    try {
        // Establish the database connection using the function
        connection = connectToDatabase();

        // Execute a query to retrieve all courses
        String sql = "SELECT * FROM course_table";
        statement = connection.createStatement();
        resultSet = statement.executeQuery(sql);

        // Display courses in a table
%>
        <table>
            <tr>
                <th>Course ID</th>
                <th>Course Name</th>
                <th>Description</th>
                <th>Action</th> <!-- Add a new column for the action button -->
            </tr>
<%
        while (resultSet.next()) {
%>
            <tr>
                <td><%= resultSet.getInt("course_id") %></td>
                <td><%= resultSet.getString("course_name") %></td>
                <td><%= resultSet.getString("description") %></td>
                <td>
                    <!-- Add a button for applying for a job -->
                    <form action="apply.jsp" method="post">
                        <input type="hidden" name="courseId" value="<%= resultSet.getInt("course_id") %>">
                        <input type="submit" value="Apply for Job">
                    </form>
                </td>
            </tr>
<%
        }
%>
        </table>
<%
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
    } finally {
        // Close resources
        try {
            if (resultSet != null) {
                resultSet.close();
            }
            if (statement != null) {
                statement.close();
            }
            if (connection != null) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
</div>

    <div class="content" id="Jobs" style="display: none;">
        <h2>View Job Status</h2>
       <%
   
   

    try {
        // Load the JDBC driver
       // Establish the database connection using the function
       String user=(String)session.getAttribute("loggedInUser");
        connection = connectToDatabase();
        statement = connection.createStatement();
        // Execute a query to fetch all records from the "TAusers" table
        String query = "SELECT * from job_application where  username='"+user+"'";
        resultSet = statement.executeQuery(query);
%>

   
    <table border="1">
        <tr>
         <th>Date Applied On</th>
            <th>Course ID</th>
            <th>Application ID</th>
           
            <th>Status</th>
            <!-- Add more columns based on your table structure -->
        </tr>

        <% 
            // Loop through the result set and display the records in the table
            while (resultSet.next()) {
        %>
                <tr>
                    <td><%= resultSet.getString(7) %></td>
                    <td><%= resultSet.getString(1) %></td>
                    <td><%= resultSet.getString(6) %></td>
                    <%
                    String h=resultSet.getString("status");
                    if(h.equals("Job Offer Sent"))
                    {
              
                    %>
                     <td>Job Offer Received <a href="SendJobOffer.jsp?status=<%= resultSet.getString(6) %>&s=accept">Accept</a> <a href="SendJobOffer.jsp?status=<%= resultSet.getString(6) %>&s=decline">Decline</a></td>
                    
                
                   <% }
                    
                    else 
                    {
                    
                %>
                 <td><%= resultSet.getString("status") %></td>
            
                    <!-- Add more columns based on your table structure -->
                </tr>
        <%
                    } }
        %>
    </table>

<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // Close resources in the reverse order of their creation to avoid resource leaks
        if (resultSet != null) resultSet.close();
        if (statement != null) statement.close();
        if (connection != null) connection.close();
    }
%>
       
    </div>

  <div class="content" id="MyClasses" style="display: none;">
        <h2>Upload Class Performance</h2>
       <%
   
   

    try {
        // Load the JDBC driver
       // Establish the database connection using the function
       String user=(String)session.getAttribute("loggedInUser");
        connection = connectToDatabase();
        statement = connection.createStatement();
        // Execute a query to fetch all records from the "TAusers" table
        String query = "SELECT * from job_application where  username='"+user+"' and status='Accepted'";
        resultSet = statement.executeQuery(query);
%>

   
    <table border="1">
        <tr>
         <th>Course id </th>
           
           
            <th>Upload marks</th>
            <!-- Add more columns based on your table structure -->
        </tr>

        <% 
            // Loop through the result set and display the records in the table
            while (resultSet.next()) {
        %>
                <tr>
                    <td><%= resultSet.getString(1) %></td>
<td><form action="MarksUploadServlet" method="post" enctype="multipart/form-data">
        <input type="hidden" name="courseId" value="<%= resultSet.getString(1) %>">
        
        <input type="hidden" name="username" value="<%= user %>">
        
        <label for="resume">Marks report:</label>
        <input type="file" name="marks" accept=".pdf,.doc,.docx" required><br>
       <input type="submit" value="Submit">
    </form> </td>            
        <%
                     }
        %>
    </table>

<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // Close resources in the reverse order of their creation to avoid resource leaks
        if (resultSet != null) resultSet.close();
        if (statement != null) statement.close();
        if (connection != null) connection.close();
    }
%>
  <%}
else 
{
	 response.sendRedirect("Logout.jsp");
}%>     
    </div>

<script>
    function showDiv(divId) {
        // Hide all divs
        
        document.getElementById('ApplyHere').style.display = 'none';
        document.getElementById('Jobs').style.display = 'none';
        document.getElementById('MyClasses').style.display = 'none';

        // Show the selected div
        document.getElementById(divId).style.display = 'block';
    }
</script>

</body>
</html>
