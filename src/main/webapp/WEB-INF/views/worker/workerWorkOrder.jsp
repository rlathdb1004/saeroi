<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>작업자 작업지시 조회</title>
<link rel="icon"
	href="${pageContext.request.contextPath}/resources/favicon.ico">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/worker.css">
</head>

<body class="workerSubPage workerWorkOrderPage">

	<h2 class="pageTitle">작업자 작업지시 조회</h2>

	<div class="workerInfo">${workerName} 작업자 작업지시 목록</div>

	<div class="tableWrap">
		<table>
			<thead>
				<tr>
					<th>작업지시번호</th>
					<th>제품명</th>
					<th>라인명</th>
					<th>작업자</th>
					<th>상태</th>
					<th>지시수량</th>
					<th>작업일자</th>
				</tr>
			</thead>
	<tbody>
    <c:if test="${empty list}">
        <tr>
            <td colspan="7" class="noData">작업지시 데이터가 없습니다.</td>
        </tr>
    </c:if>

    <c:forEach var="dto" items="${list}">
        <tr>
            <td>${dto.orderId}</td>
            <td>${dto.itemName}</td>
            <td>${dto.lineName}</td>
            <td>${dto.ename}</td>
            <td>${dto.prodStatus}</td>
            <td>${dto.orderQty}</td>
            <td>${dto.orderDate}</td>
        </tr>
    </c:forEach>
</tbody>
		</table>

		<button type="button" class="moveBtn"
			onclick="location.href='${pageContext.request.contextPath}/worker/main'">
			작업자 메인 이동</button>
	</div>
</body>
</html>