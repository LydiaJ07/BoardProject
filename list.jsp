<%@page language="java" %>
<%@page import="java.util.Date" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.sql.*, javax.sql.*, java.io.*, java.net.URL, java.util.*" %>
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
        function postClick (id) {
            location.href="view.jsp?id="+id;
        }
    </script>
</head>
<body>
    <%
    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://192.168.23.71:3306/kopo36", "root", "wjdthdud12");
    Statement stmt = conn.createStatement();
    
    ResultSet rset = stmt.executeQuery("select count(*) from board;");

    int totalContents = 0; //총 게시글 수
    while(rset.next()) {
        totalContents = rset.getInt(1);
    }
    rset.close();
    %>
    <header>
        <div class="nav_wrap">
            <h1>LOGO</h1>
            <nav>
                <ul class="nav_menu">
                    <li><a href="#">HOME</a></li>
                    <li><a href="#">LOGIN</a></li>
                    <li><a href="#">SINGUP</a></li>
                </ul>
            </nav>
        </div>
    </header>
    <div class="board_wrap">
        <div class="board_title">
            <strong>자유게시판</strong>
            <p>여러분들의 생각을 자유롭게 남겨주세요.</p>
        </div>
        <p style="padding:4px; font-size: 12px;">총 게시글 수 : <%= totalContents %></p>
        <div class="board_list_wrap">
            <div class="board_list">
                <div class="top">
                    <div class="num">번호</div>
                    <div class="title">제목</div>
                    <div class="writer">글쓴이</div>
                    <div class="date">작성일</div>
                    <div class="count">조회수</div>
                </div>
    <%
    //페이지 번호
    int pageNum = 1;
    if (request.getParameter("pageNum")==null) {
        pageNum = 1;
    } else if (Integer.parseInt(request.getParameter("pageNum")) < 0) {
        pageNum = 1;
    } else {
        pageNum = Integer.parseInt(request.getParameter("pageNum"));
    }

    //한 페이지 내 출력 단위
    int print_volume = 7; // default값을 5로 설정
    
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    Date today = new Date();

    String todayStr = df.format(today);

    rset = stmt.executeQuery("select a.* from(select * from board order by id desc) a " + 
                                "limit " + print_volume + " offset " + print_volume*(pageNum-1) + ";");
    
    while(rset.next()) {
    %>
                <div onclick="postClick('<%= rset.getInt(1) %>');" class="postDiv">
                    <div class="num"><%= rset.getInt(1) %></div>
                    <div class="title"><%= rset.getString(2) %>
    <%

        if (rset.getString(5).equals(todayStr) && rset.getInt(7) >= 50) {
            %>
                    <img src="./css/new.png">
                    <img src="./css/hot.png">
            <%

        } else if (rset.getString(5).equals(todayStr) && rset.getInt(7) < 50) {
            %>
                <img src="./css/new.png">
            <%
        } else if (rset.getString(5).equals(todayStr) == false && rset.getInt(7) >= 50) {
            %>
                <img src="./css/hot.png">
            <%
        } 
        %>
            </div>
            <div class="writer"><%= rset.getString(3) %></div>
            <div class="date"><%= rset.getString(5) %></div>
            <div class="count"><%= rset.getInt(7) %></div>
        </div>
        <%
    }
    out.print("</div>");

    rset.close();
    stmt.close();
    conn.close();
    %>
    <div class="search_wrap">
        <div class="searchBox">
            <form method="post" name="searchForm" action="search.jsp">
                <select name="searchIndex" id="Index" >
                    <option value="title">글 제목</option>
                    <option value="content">본문</option>
                    <option value="writer">작성자</option>
                </select>
                <input type="text" name="searchTarget" placeholder="검색어">
                <button id="searchBt" type="submit" form="searchForm"><img src="./css/search.png" style="height: 12px; padding: 4px;"></button>
            </form>
        </div>
    </div>
    <div class="bt_wrap">
        <a href="write.html" class="on">글 작성</a>
    </div>

    <!-- 페이징 블록 -->
    <div class="board_page">
        <a href="list.jsp" class="bt first"><<</a>

    <%
    int totalPage = 0; //총 페이지 수
    if (totalContents%print_volume == 0) {
        totalPage = totalContents / print_volume;
    } else {
        totalPage = totalContents / print_volume + 1;
    }
    
    //페이징 블록(한 블록에 5개씩)
    int totalPageBlock = (totalPage / 5) + 1; //총 페이징 블록 수
    int pageBlockNum = ((pageNum - 1) / 5) + 1; //현재 페이지가 위치하는 블록의 번호
    int block_start = 5 * (pageBlockNum - 1) + 1; //현재 페이징 블록의 첫 페이지 번호 
    int block_end = 5 * pageBlockNum; //현재 페이징 블록의 마지막 번호
    
    if (pageBlockNum == totalPageBlock) {
        block_end = totalPage;
    }

    //첫 페이지 일 때, 이전 페이지 버튼 처리 
    if (pageNum == 1){
        out.print("<a href='list.jsp?pageNum=1' class='bt prev'><</a>");
    } else {
        out.print("<a href='list.jsp?pageNum=" + (pageNum - 1) + "'' class='bt prev'><</a>");
    }

    //반복문을 사용해 헤당 페이지 블록에 5개 페이지 버튼 출력
    for (int i = block_start; i<=block_end; i++) {
        if(i == pageNum) {
            out.print("<a href='list.jsp?pageNum=" + i + "'' class='num on'>" + i + "</a>");
        } else {
            out.print("<a href='list.jsp?pageNum=" + i + "'' class='num'>" + i + "</a>");
        }
    }

    //마지막 페이지 일때 다음 페이지 버튼 처리
    if (pageNum == totalPage){
        out.print("<a href='list.jsp?pageNum=" + totalPage + "' class='bt next'>></a>");
    } else {
        out.print("<a href='list.jsp?pageNum=" + (pageNum + 1) + "'' class='bt next'>></a>");
    }

    %>

                <a href='list.jsp?pageNum=<%= totalPage %>' class='bt last'>>></a>
            </div>
        </div>
    </div>
</body>
</html> 