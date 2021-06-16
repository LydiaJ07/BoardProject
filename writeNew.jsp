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
            // 다큐먼트가 다 불러와졌을 때 실행하고 싶은 내용 넣기
            alert("글이 등록되었습니다.");
            location.href = "list.jsp";
        });
    </script>
</head>
<body>

<%
String new_title = request.getParameter("title");
String new_writer = request.getParameter("writer");
String new_pw = request.getParameter("pw");
String new_content = request.getParameter("content");

Class.forName("com.mysql.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mysql://192.168.23.71:3306/kopo36", "root", "wjdthdud12");
Statement stmt = conn.createStatement();

String QueryTxt = "insert into board (title, writer, pw, date, content, count) " 
                    + "values (?, ?, ?, ?, ?, 0)";
PreparedStatement pstmt = conn.prepareStatement(QueryTxt);

SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
Date today = new Date();

String new_date = df.format(today);

pstmt.setString(1, new_title);
pstmt.setString(2, new_writer);
pstmt.setString(3, new_pw);
pstmt.setString(4, new_date);
pstmt.setString(5, new_content);

int result = pstmt.executeUpdate();

pstmt.close();
stmt.close();
conn.close();
%>

</body>
</html>

