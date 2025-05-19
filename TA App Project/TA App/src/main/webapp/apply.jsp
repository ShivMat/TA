<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.ArrayList" %>
<%!
    // Method to fetch courses from the database
    public ArrayList<String> fetchCoursesFromDatabase() {
        ArrayList<String> courses = new ArrayList<>();

        try {
            // Establish a database connection
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/TA", "root", "root");

            // Execute a SQL query to fetch courses
            String query = "SELECT course_name FROM course_table";
            Statement statement = connection.createStatement();
            ResultSet resultSet = statement.executeQuery(query);

            // Iterate through the result set and add courses to the ArrayList
            while (resultSet.next()) {
                String courseName = resultSet.getString("course_name");
                courses.add(courseName);
            }

            // Close resources
            resultSet.close();
            statement.close();
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle exceptions appropriately
        }

        return courses;
    }
%>
<html>
<head>
    <title>Job Application</title>
    
    <style>
        .form-group {
            margin-bottom: 10px;
            display: inline-block;
        }

        .delete-icon {
            cursor: pointer;
            color: red;
        }
    </style>

    <script>
        function toggleTAFields() {
            var hasServedAsTA = document.querySelector('input[name="hasServedAsTA"]:checked').value;
            var taFields = document.getElementById("taFields");

            if (hasServedAsTA === "yes") {
                taFields.style.display = "block";
            } else {
                taFields.style.display = "none";

                // Hide all existing course rows
                var courseRows = document.getElementsByClassName("course-row");
                for (var i = 0; i < courseRows.length; i++) {
                    courseRows[i].style.display = "none";
                }
            }
        }

        function addMoreCourses() {
            var coursesContainer = document.getElementById("coursesContainer");
            var newCourseFields = document.createElement("div");

            newCourseFields.className = "course-row"; // Add a class to identify each course row

            newCourseFields.innerHTML = `
                <div class="form-group">
                    <label for="relevantCourses">Relevant Course(s):</label>
                    <input type="text" name="relevantCourses" size="30">
                </div>
                
                <div class="form-group">
                    <label for="fromDate">From Date:</label>
                    <input type="date" name="fromDate">
                </div>
                
                <div class="form-group">
                    <label for="toDate">To Date:</label>
                    <input type="date" name="toDate">
                </div>
                
                <span class="delete-icon" onclick="removeCourse(this)">❌</span>
            `;

            coursesContainer.appendChild(newCourseFields);
        }

        function removeCourse(deleteIcon) {
            var courseFields = deleteIcon.parentNode;
            courseFields.parentNode.removeChild(courseFields);
        }
    </script>
</head>
<body>
    <h1>Job Application</h1>

    <%-- Retrieve the course_id and username from session attributes --%>
    <% String courseId = request.getParameter("courseId"); %>
    <% String username = (String) session.getAttribute("loggedInUser"); %>

    <%-- Display the course_id and username in a separate field --%>
    <p>Applying for Course ID: <%= courseId %></p>
    <p>Username: <%= username %></p>

    <form action="YourUploadServlet" method="post" enctype="multipart/form-data">
        <input type="hidden" name="courseId" value="<%= courseId %>">
        
        <input type="hidden" name="username" value="<%= username %>">
        
        <label for="resume">Resume:</label>
        <input type="file" name="resume" accept=".pdf,.doc,.docx" required><br>
         <div class="form-group">
            <label for="relevantCourses">I am qualified to assist </label>
            <%
    // Assuming you have a method to fetch courses from the database
    ArrayList<String> courses = fetchCoursesFromDatabase();
%>
            <%-- Dynamically generate checkboxes based on fetched courses --%>
            <%
                for (String course : courses) {
            %>
                    <label><input type="checkbox" name="otherCourses" value="<%= course %>"><%= course %></label>
            <%
                }
            %>
            
        </div><br>
        
        <label for="hasServedAsTA">Have you previously served as a TA at North University?</label><br>
        <label><input type="radio" name="hasServedAsTA" value="yes" onclick="toggleTAFields()"> Yes</label>
        <label><input type="radio" name="hasServedAsTA" value="no" onclick="toggleTAFields()" checked> No</label><br>
         
        <div id="taFields" style="display: none;">
          
        
            <div class="form-group">
                <label for="relevantCourses">Relevant Course(s):</label>
                <input type="text" name="relevantCourses" size="30">
            </div>
            
            
            <div class="form-group">
                <label for="fromDate">From Date:</label>
                <input type="date" name="fromDate">
            </div>
            
            <div class="form-group">
                <label for="toDate">To Date:</label>
                <input type="date" name="toDate">
            </div>

            <div id="coursesContainer"></div>

            <button type="button" onclick="addMoreCourses()">Add More</button>
        </div>
        
        <input type="submit" value="Submit">
    </form>
</body>
</html>
