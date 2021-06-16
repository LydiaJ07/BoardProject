<%@page language="java" %>
<%@page import="java.sql.*, javax.sql.*, java.io.*, java.net.URL" %>
<%@page contentType="text/html; charset=utf-8" %>
<% request.setCharacterEncoding("utf-8");%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시판</title>
    <link rel="stylesheet" href="css/css.css">
    <script
    src="https://code.jquery.com/jquery-3.6.0.min.js"
    integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
    crossorigin="anonymous"></script>

    <script>
        function editClick(id, password) {
            var pw = prompt("비밀번호를 입력해주세요");

            if(pw == "") {
                editClick();
            } else if(pw == null) {
                return;
            } else if(pw != password) {
                alert("비밀번호가 일치하지 않습니다.");
                editClick();
            } else {
                location.href = "edit.jsp?id=" + id;
            } 
        } 

        $(document).ready(function () {
                $(".toggle").click(function () {
                    $(".under_toggle").toggle();
                });
            });
    </script>

</head>
<body>
    <div class="board_wrap">
        <div class="board_title">
            <strong>자유게시판</strong>
            <p>여러분들의 생각을 자유롭게 남겨주세요.</p>
        </div>

        <%
        String targetID = request.getParameter("id");
        
        Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://192.168.23.71:3306/kopo36", "root", "wjdthdud12");
		Statement stmt = conn.createStatement();

        //카운트 1 올리기
        ResultSet rset = stmt.executeQuery("select count from board where id=" + targetID + ";");
        
        int newCnt = 0;
        
        while(rset.next()) {
        newCnt = rset.getInt(1) + 1;
        }
        
        rset.close();
        stmt.execute("update board set count=" + newCnt + " where id=" + targetID + ";");

        rset = stmt.executeQuery("select * from board where id=" + targetID + ";");

        String password ="";
        while(rset.next()) {

            //비밀번호
            password = rset.getString(4);

        %>

        <div class="board_view_wrap">
            <div class="board_view">
                <div class="title">
                    <%= rset.getString(2) %>
                </div>
                <div class="info">
                    <dl>
                        <dt>번호</dt>
                        <dd><%= rset.getInt(1) %></dd>
                    </dl>
                    <dl>
                        <dt>글쓴이</dt>
                        <dd><%= rset.getString(3) %></dd>
                    </dl>
                    <dl>
                        <dt>작성일</dt>
                        <dd><%= rset.getString(5) %></dd>
                    </dl>
                    <dl>
                        <dt>조회수</dt>
                        <dd><%= rset.getInt(7) %></dd>
                    </dl>
                </div>
                <div class="cont">
                    <pre><%= rset.getString(6) %></pre>
                </div>
            </div>

            <!-- 댓글 -->
            <div class="comment_wrap">
                <div class="toggle">
                    <img src="./css/chat.png" width="16px">
                    <span id="cmtspan">댓글 목록▼</span>
                </div>
                <div class="under_toggle">
            <%
            }

            rset = stmt.executeQuery("select * from boardcmt where postId=" + targetID + " order by date;");

            while(rset.next()) {
            %>
                    <div class="comment_show">
                        <div class="comment_header">
                            <div class="writer"><b><%= rset.getString(3) %></b></div>
                            <div class="time"><%= rset.getString(5) %></div>
                            <div class="delete"><b>삭제</b></div>
                            <div class="edit"><b>수정</b></div>
                        </div>
                        <div class="comment_body"><%= rset.getString(4) %></div>
                    </div>
<%
}

rset.close();
stmt.close();
conn.close();
            %>
                    <div class="comment_write">
                        <form method="post">
                            <input type="hidden" name="cmt_postId" value="<%= targetID %>">
                            <input id="cmt_writer" name="cmt_writer" type="text" placeholder="작성자">
                            <input id="cmt_content" name="cmt_content" type="text" placeholder="댓글 작성">
                            <button id="cmt_submit" formaction="commentWrite.jsp">등록</button>
                    </form>
                    </div>
                </div>
            </div>
            <div class="bt_wrap">
                <a href="list.jsp" class="on">목록</a>
                <a id="editButton" onClick="editClick('<%= targetID %>', '<%= password %>')">수정/삭제</a>
            </div>
        </div>
    </div>
</body>
</html>