<%@ page language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>
	작업자 작업지시 조회
</title>
<link rel="icon"
	href="${pageContext.request.contextPath}/resources/favicon.ico">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/worker.css">

</head>

<body class="workerSubPage workerWorkOrderPage">

	<!-- =================================================
		타이틀
	================================================= -->
	<h2 class="pageTitle">

		작업자 작업지시 조회

	</h2>

	<!-- =================================================
		로그인 작업자
	================================================= -->
	<div class="workerInfo">

		${workerName} 작업자 작업지시 목록

	</div>

	<!-- =================================================
		테이블
	================================================= -->
	<div class="tableWrap">

		<table>

			<thead>

				<tr>

					<th>
						작업지시번호
					</th>

					<th>
						제품명
					</th>

					<th>
						라인명
					</th>

					<th>
						작업자
					</th>

					<th>
						상태
					</th>

					<th>
						지시수량
					</th>

					<th>
						작업일자
					</th>

				</tr>

			</thead>

			<tbody>

				<!-- =========================================
					데이터 없을 때
				========================================= -->
				<c:if test="${empty list}">

					<tr>

						<td colspan="7"
							class="noData">

							작업지시 데이터가 없습니다.

						</td>

					</tr>

				</c:if>

				<!-- =========================================
					DTO 전체 데이터 확인용
				========================================= -->
				<c:forEach var="dto"
					items="${list}">

					<tr>

						<td colspan="7"
							class="debugBox">

							<!-- =============================
								DTO 전체 출력
								현재 어떤 값 들어오는지 확인
							============================= -->
							${dto}

						</td>

					</tr>

				</c:forEach>

			</tbody>

		</table>

		<!-- =============================================
			메인 이동
		============================================= -->
		<button type="button"
			class="moveBtn"
			onclick="location.href='${pageContext.request.contextPath}/worker/main'">

			작업자 메인 이동

		</button>

	</div>

</body>

</html>