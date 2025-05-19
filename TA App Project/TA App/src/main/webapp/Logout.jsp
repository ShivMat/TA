<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Enumeration, jakarta.servlet.http.HttpSession" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Logout</title>
</head>
<body>

<%
    // Invalidate and destroy all sessions
    Enumeration<String> attributeNames = session.getAttributeNames();
    while (attributeNames.hasMoreElements()) {
        String attributeName = attributeNames.nextElement();
        session.removeAttribute(attributeName);
    }
    session.invalidate();
%>

<script type="text/javascript">
    // Disable back button
    window.history.forward();
    function noBack() { window.history.forward(); }

    // Redirect to index.html after a delay (adjust the delay time as needed)
    setTimeout(function() {
        window.location.href = "index.html";
    }, 1000); // 3000 milliseconds (3 seconds)
</script>

</body>
</html>
