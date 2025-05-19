

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Files;

import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import mybean.*;


import jakarta.servlet.annotation.MultipartConfig;


/**
 * Servlet implementation class YourUploadServlet
 */
@WebServlet("/YourUploadServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class YourUploadServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	// Method to check if the user has applied earlier
	private boolean userHasApplied(String username,String id) {
	    try {
	        Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/TA", "root", "root");
	        String query = "SELECT * FROM job_application WHERE username = ? and course_id=?";
	        PreparedStatement preparedStatement = connection.prepareStatement(query);
	        preparedStatement.setString(1, username);
	        preparedStatement.setString(2, id);
	        ResultSet resultSet = preparedStatement.executeQuery();

	        // If the resultSet has any rows, the user has applied earlier
	        return resultSet.next();
	    } catch (SQLException e) {
	        e.printStackTrace();
	        // Handle exceptions appropriately
	        return false;
	    }
	}
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public YourUploadServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	// Method to generate a unique job ID
	private String generateJobId() {
	    try {
	        Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/TA", "root", "root");

	        // Get the current count of job applications
	        String countQuery = "SELECT COUNT(*) FROM job_application";
	        PreparedStatement countStatement = connection.prepareStatement(countQuery);
	        ResultSet countResultSet = countStatement.executeQuery();
	        countResultSet.next();
	        int applicationCount = countResultSet.getInt(1);
	        countResultSet.close();
	        countStatement.close();

	        // Generate a job ID based on the count
	        String jobId = "TA" + (applicationCount + 1);

	        connection.close();

	        return jobId;
	    } catch (SQLException e) {
	        e.printStackTrace();
	        // Handle exceptions appropriately
	        return null;
	    }
	}
	
	 protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	        // Handle file upload
		 String courseId = request.getParameter("courseId");
	        String username = request.getParameter("username");
	        PrintWriter out=response.getWriter();
		// Check if the user has applied earlier
		    if (!userHasApplied(username,courseId)) 
		    {  
		    	 // Add today's date in the form of "DD-MM-YYYY" as a string
		        String currentDate = new SimpleDateFormat("dd-MM-yyyy").format(new Date());

		        // Generate a unique identifier for the application
		        String applicationId = generateJobId();

		    	
	        Part resumePart = request.getPart("resume");
	        String resumeFileName = Paths.get(resumePart.getSubmittedFileName()).getFileName().toString();
	        String uploadPath = "C:/Users/Empow/OneDrive/Desktop/uploads";
	        String resumeFilePath = uploadPath + "/"+ resumeFileName;
	       System.out.println(resumeFilePath);
	        try (InputStream resumeInput = resumePart.getInputStream()) {
	            Files.copy(resumeInput, Paths.get(resumeFilePath), StandardCopyOption.REPLACE_EXISTING);
	        }

	        // Retrieve other form parameters
	       
	        String hasServedAsTA = request.getParameter("hasServedAsTA");
	     // Get selected relevant courses
	        String[] selectedCourses = request.getParameterValues("otherCourses");
	        String concatenatedCourses = (selectedCourses != null) ? String.join(",", selectedCourses) : "";

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
            	concatenatedData = new StringBuilder();
            	 concatenatedData.append("no");
            }
              
	        // Create a JobApplication object
	        JobApplication application = new JobApplication();
	        application.setCourseId(courseId);
	        application.setUsername(username);
	        application.setResume(resumeFilePath);
	        application.setHasServedAsTA(hasServedAsTA);
	        application.setRelevantCourses(concatenatedData.toString());
	        application.setOtherCourses(concatenatedCourses);
	    

	        // JDBC code to insert data into the database
	        try {
	            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/TA", "root", "root");
	            String query = "INSERT INTO job_application (course_id, username, has_served_as_tA, relevant_courses,resume,application_id,date_added,otherCourses,status) VALUES (?, ?, ?, ?, ?,?,?,?,?)";
	            PreparedStatement preparedStatement = connection.prepareStatement(query);

	            preparedStatement.setString(1, application.getCourseId());
	            preparedStatement.setString(2, application.getUsername());
	            preparedStatement.setString(5, application.getResume());
	            preparedStatement.setString(3, application.getHasServedAsTA());
	            preparedStatement.setString(4, application.getRelevantCourses());
	            preparedStatement.setString(6, applicationId);
	            preparedStatement.setString(7, currentDate); // Add today's date
	            preparedStatement.setString(8, application.getOtherCourses());
	            preparedStatement.setString(9, "Applied");
	            preparedStatement.executeUpdate();

	            preparedStatement.close();
	            connection.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	            // Handle exceptions appropriately
	        }
	        
	        
	        // Redirect or forward to a success page
	        response.sendRedirect("success.jsp");
	    }
	 
	 else 
	 
		 out.println("You have already applied");
	 
	 }
}

