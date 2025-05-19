import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/FileDownloadServlet")
public class FileDownloadServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String applicationId = request.getParameter("t1"); // Assuming you pass the application ID as a parameter

        try {
        	// Load the JDBC driver
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/TA", "root", "root");
            String query = "SELECT resume FROM job_application WHERE application_id = ?";
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, applicationId);

            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                String filePath = resultSet.getString("resume");
                Path file = Paths.get(filePath);
      // System.out.println(file);
                if (Files.exists(file)) {
                    response.setContentType("application/octet-stream");
                    
                    // Set the filename for the downloaded file
                    String fileName = file.getFileName().toString();
                    response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

                    try (InputStream inputStream = Files.newInputStream(file);
                            OutputStream outputStream = response.getOutputStream()) {
                        byte[] buffer = new byte[4096];
                        int bytesRead = -1;
                        while ((bytesRead = inputStream.read(buffer)) != -1) {
                            outputStream.write(buffer, 0, bytesRead);
                           // System.out.println("while");
                        }
                    }
                } else {
                    response.getWriter().println("File not found.");
                
            }}

            preparedStatement.close();
            connection.close();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            // Handle exceptions appropriately
        }
    }
}
