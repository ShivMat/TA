<%@ page import="java.sql.*" %>

<%!
    // Function to establish a database connection
    public Connection connectToDatabase() throws SQLException, ClassNotFoundException 
    {
        String url = "jdbc:mysql://localhost:3306/TA";
        String username = "root";
        String password = "root";
        
        // Load the JDBC driver
        Class.forName("com.mysql.jdbc.Driver");
        
        // Establish the database connection
        return DriverManager.getConnection(url, username, password);
    }
%>
