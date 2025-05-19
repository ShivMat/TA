

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
@WebServlet("/MarksUploadServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class MarksUploadServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	// Method to check if the user has applied earlier
	
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MarksUploadServlet() {
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
	
	
	 protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	        // Handle file upload
		 String courseId = request.getParameter("courseId");
	        String username = request.getParameter("username");
	        PrintWriter out=response.getWriter();
		// Check if the user has applied earlier
		  // Add today's date in the form of "DD-MM-YYYY" as a string
		        String currentDate = new SimpleDateFormat("dd-MM-yyyy").format(new Date());


		    	
	        Part resumePart = request.getPart("marks");
	        String resumeFileName = Paths.get(resumePart.getSubmittedFileName()).getFileName().toString();
	        String uploadPath = "C:/Users/Empow/OneDrive/Desktop/uploads";
	        String resumeFilePath = uploadPath + "/"+ resumeFileName;
	       System.out.println(resumeFilePath);
	        try (InputStream resumeInput = resumePart.getInputStream()) {
	            Files.copy(resumeInput, Paths.get(resumeFilePath), StandardCopyOption.REPLACE_EXISTING);
	        }

	       
              
	        // Create a JobApplication object
	        JobApplication application = new JobApplication();
	        application.setCourseId(courseId);
	        application.setUsername(username);
	        application.setResume(resumeFilePath);
	       
	    

	        // JDBC code to insert data into the database
	        try {
	        
	            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/TA", "root", "root");
	            String query = "INSERT INTO marks (date_uploaded,course_id, username, report) VALUES (?, ?, ?, ?)";
	            PreparedStatement preparedStatement = connection.prepareStatement(query);
	            preparedStatement.setString(1, currentDate); // Add today's date
	            preparedStatement.setString(2, application.getCourseId());
	            preparedStatement.setString(3, application.getUsername());
	            preparedStatement.setString(4, application.getResume());
	            int k=preparedStatement.executeUpdate();
               if(k>0)
               {
            	  out.print("Marks Uploaded"); 
               }
               else 
               {
            	   out.print("Error in uploading");  
               }
	            preparedStatement.close();
	            connection.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	            // Handle exceptions appropriately
	        }
	        
	        
	       
	    
	 
	
}
}

