<%@page language="java" %>
<%@page import="java.util.Date" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.sql.*, javax.sql.*, java.io.*, java.net.URL" %>
<%@page contentType="text/html; charset=utf-8" %>
<% request.setCharacterEncoding("utf-8");%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script
    src="https://code.jquery.com/jquery-3.6.0.min.js"
    integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
    crossorigin="anonymous"></script>
    <title>Document</title>
    <script>
        $(document).ready(function() {
            alert("글이 삭제되었습니다.");
            location.href="list.jsp";
        });
    </script>
</head>
<body>

<%
String targetID = request.getParameter("id");

Class.forName("com.mysql.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mysql://192.168.23.71:3306/kopo36", "root", "wjdthdud12");
Statement stmt = conn.createStatement();

String QueryTxt = "delete from board where id=?";
PreparedStatement pstmt = conn.prepareStatement(QueryTxt);

pstmt.setString(1, targetID);

int result = pstmt.executeUpdate();

pstmt.close();
stmt.close();
conn.close();
%>

</body>
</html>

