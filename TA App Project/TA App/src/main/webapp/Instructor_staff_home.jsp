<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.*, java.util.List, mybean.JobApplication" %>

<%@ page import="java.util.ArrayList" %>
<%@ include file="DbConnection.jsp" %><!DOCTYPE html>
<%!    Connection connection = null;
Statement statement = null;
ResultSet resultSet = null; %>
<%
//Check if the session is not null and if a specific attribute is set
if (session != null && session.getAttribute("Instructor") != null) {
	

    // Session is valid, continue with your logic
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Instructor  Home</title>
    <style>
        /* Add your styling here */
        body {
            font-family: Arial, sans-serif;
        }

        .container {
            max-width: 1200px;
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
<h1>Welcome Instructor</h1> <a href="Logout.jsp"><img src="logout.png" width=50 height=50></a>
    <div class="menu">
        
        <div onclick="showDiv('viewCourses')">View Courses</div>
        <div onclick="showDiv('viewTAs')">View Appointed TAs</div>
        <div onclick="showDiv('check')">Check Performance</div>
    </div>

    <div class="content" id="inputCourses">
        <h2>Welcome Instructor</h2>
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


    </div>

    <div class="content" id="viewCourses" style="display: none;">
        <h2>View Courses</h2>
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
  

    // Retrieve all courses from the database


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
            </tr>
<%
        while (resultSet.next()) {
%>
            <tr>
                <td><%= resultSet.getInt("course_id") %></td>
                <td><%= resultSet.getString("course_name") %></td>
                <td><%= resultSet.getString("description") %></td>
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

    <div class="content" id="viewTAs" style="display: none;">
        <h2>View Appointed TAs</h2>
       <%
   
   

    try {
        // Load the JDBC driver
       // Establish the database connection using the function
        connection = connectToDatabase();
        statement = connection.createStatement();
        // Execute a query to fetch all records from the "TAusers" table
        String query = "SELECT * FROM job_application where status='Accepted'";
        resultSet = statement.executeQuery(query);
%>

   
    <table border="1">
        <tr>
            <th>Username</th>
            <th>Course Id</th>
            <th>Other Courses </th>
           
            <!-- Add more columns based on your table structure -->
        </tr>

        <% 
            // Loop through the result set and display the records in the table
            while (resultSet.next()) {
        %>
                <tr>
                    <td><%= resultSet.getString(2) %></td>
                    <td><%= resultSet.getString(1) %></td>
                    <td><%= resultSet.getString(8) %></td>
                 
                
                    <!-- Add more columns based on your table structure -->
                </tr>
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
       
    </div>

    <div class="content" id="check" style="display: none;">
        <h2>Check Performance</h2>
        <%
    List<JobApplication> applications = new ArrayList<>();

    try {
        Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/TA", "root", "root");
        String query = "SELECT * FROM marks";
        Statement statement = connection.createStatement();
        ResultSet resultSet = statement.executeQuery(query);

        while (resultSet.next()) {
            JobApplication s1 = new JobApplication();
            
            s1.setDateAdded(resultSet.getString("date_uploaded"));
            s1.setCourseId(resultSet.getString("course_id"));

            s1.setUsername(resultSet.getString("username"));
         
            s1.setResume(resultSet.getString("report"));
          
            applications.add(s1);
            
        }

        resultSet.close();
        statement.close();
        connection.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
   
    <!-- Add any additional styling or formatting if needed -->
</head>
<body>

    <h2>Performance Report</h2>

    <table border="1">
        <tr>
          
             <th>Date Uploaded On</th>
            <th>Course ID</th>
            <th>Username</th>
           
            <th>Performance Report</th>
        
        </tr>

        <% for (JobApplication k : applications) { %>
            <tr>
               
                  <td><%= k.getDateAdded() %></td>
                  
                    <td><%= k.getCourseId() %></td>
                <td><%= k.getUsername() %></td>
               
                <td><a href="MarksDownloadServlet?t1=<%= k.getCourseId() %>">Download</a></td>
                
            </tr>
        <% } %>
    </table>
    </div>

</div>

<script>
    function showDiv(divId) {
        // Hide all divs
        document.getElementById('inputCourses').style.display = 'none';
        document.getElementById('viewCourses').style.display = 'none';
        document.getElementById('viewTAs').style.display = 'none';
        document.getElementById('check').style.display = 'none';

        // Show the selected div
        document.getElementById(divId).style.display = 'block';
    }
</script>
  <%}
else 
{
	 response.sendRedirect("Logout.jsp");
}%> 
</body>
</html>
