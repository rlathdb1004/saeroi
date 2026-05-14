<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>SAEROI MES</title>

    <!-- 페비콘 연결 -->
    <link rel="icon" href="${pageContext.request.contextPath}/resources/favicon.ico">
    
	<!-- header.jsp의 상단 제목, 탭, 시간/온도 박스 디자인을 적용하기 위해 header.css를 연결한다. -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/header.css">

	<!-- sidebar.jsp의 사이드바 디자인을 적용하기 위해 sidebar.css를 연결한다. -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/sidebar.css">
	
	<%-- 공통 검색영역, 버튼, 테이블, 페이징 디자인을 적용하는 CSS 파일이다. --%>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/content.css">
</head>
<body>

    <!-- 사이드바 영역 -->
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

    <!-- 헤더 영역 -->
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <!-- 실제 페이지 내용이 들어가는 영역 -->
    <main class="main-content">
        <jsp:include page="${contentPage}" />
    </main>
    
	<!--JS 파일에서 사용할 프로젝트 기본 주소를 저장한다. -->
    <script> var contextPath = "${pageContext.request.contextPath}";</script>

	<!-- 현재 시간 표시와 날씨/온도 표시를 담당하는 header.js 파일을 연결한다. -->
    <script src="${pageContext.request.contextPath}/resources/js/common/header.js"></script>

	<!-- 사이드바 메뉴 펼침/접힘 동작을 담당하는 sidebar.js 파일을 연결한다. -->
	<script src="${pageContext.request.contextPath}/resources/js/common/sidebar.js"></script>

</body>
</html>