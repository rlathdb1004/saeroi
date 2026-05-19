<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">

    <%-- tiles_config.xml에서 설정한 title 값이 브라우저 탭 제목으로 들어온다. --%>
    <title>
        <tiles:insertAttribute name="title" />
    </title>

    <%-- 페비콘을 연결한다. resources 폴더에 favicon.ico가 있어야 정상 표시된다. --%>
    <link rel="icon" href="${pageContext.request.contextPath}/resources/favicon.ico">

    <%-- header.jsp 디자인을 적용하는 CSS 파일이다. --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/header.css">

    <%-- sidebar.jsp 디자인을 적용하는 CSS 파일이다. --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/sidebar.css">

    <%-- 공통 검색영역, 버튼, 테이블, 페이징 디자인을 적용하는 CSS 파일이다. --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/content.css">

	<%-- 대시보드 화면 전용 디자인을 적용하는 CSS 파일이다. --%>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/dashboard.css">
	
	<%-- 각페이지 상단 테이블 CSS 파일이다. --%>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/searchtable.css">

	<%-- 공통 모달 디자인을 적용하는 CSS 파일이다. --%>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/modal.css">

</head>

<body>

    <%-- 
        sidebar 영역이다.
        tiles_config.xml에서 name="sidebar"로 지정한 파일이 이 위치에 들어온다.
        현재 연결되는 파일은 /WEB-INF/views/common/sidebar.jsp 이다.
    --%>
    <tiles:insertAttribute name="sidebar" />

    <%-- 
        header 영역이다.
        tiles_config.xml에서 name="header"로 지정한 파일이 이 위치에 들어온다.
        현재 연결되는 파일은 /WEB-INF/views/common/header.jsp 이다.
    --%>
    <tiles:insertAttribute name="header" />

    <%-- 실제 페이지 내용이 들어가는 영역이다. --%>
    <main class="main-content">

        <%-- 
            content 영역이다.
            Controller에서 return한 .tiles 주소에 따라 실제 JSP가 이 위치에 들어온다.

            예)
            return "dashboard.tiles";

            그러면 tiles_config.xml 규칙에 따라
            /WEB-INF/views/dashboard.jsp 파일이 이 위치에 들어온다.
        --%>
        <tiles:insertAttribute name="content" />

    </main>

    <%-- JS 파일에서 프로젝트 기본 주소를 사용할 수 있게 저장한다. --%>
    <script>
        var contextPath = "${pageContext.request.contextPath}";
    </script>

    <%-- 현재 시간 표시와 날씨/온도 표시를 담당하는 JS 파일이다. --%>
    <script src="${pageContext.request.contextPath}/resources/js/common/header.js"></script>

    <%-- 사이드바 메뉴 펼침/접힘 동작을 담당하는 JS 파일이다. --%>
    <script src="${pageContext.request.contextPath}/resources/js/common/sidebar.js"></script>
    
    <%-- 상단 테이블의 JS 파일이다. --%>
    <script src="${pageContext.request.contextPath}/resources/js/common/searchtable.js"></script>

	<%-- 공통 모달 열기, 닫기, 오늘 날짜 세팅을 담당하는 JS 파일이다. --%>
	<script src="${pageContext.request.contextPath}/resources/js/common/modal.js"></script>

</body>
</html>