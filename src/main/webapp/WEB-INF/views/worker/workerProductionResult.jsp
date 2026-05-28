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
	작업자 생산실적
</title>

<link rel="icon"
	href="${pageContext.request.contextPath}/resources/favicon.ico">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/worker.css">

</head>

<body class="workerSubPage workerProductionResultPage">

	<h2 class="workerResultTitle">

		작업자 생산실적 조회

	</h2>

	<div class="workerInfoBox">

		${workerName} 작업자 생산실적 목록

	</div>

	<div class="workerTableWrap">

		<table class="workerTable">

			<thead>

				<tr>

					<th>
						생산번호
					</th>

					<th>
						제품명
					</th>

					<th>
						생산수량
					</th>

					<th>
						불량수량
					</th>

					<th>
						생산상태
					</th>

					<th>
						작업자
					</th>

				</tr>

			</thead>

			<tbody>

				<c:if test="${empty list}">

					<tr>

						<td colspan="6"
							class="noData">

							생산실적 데이터가 없습니다.

						</td>

					</tr>

				</c:if>

				<c:forEach var="dto"
					items="${list}">

					<tr>

						<td>
							${dto.prodId}
						</td>

						<td>
							${dto.itemName}
						</td>

						<td>
							${dto.prodQty}
						</td>

						<td>
							${dto.lossQty}
						</td>

						<td>
							${dto.prodStatus}
						</td>

						<td>
							${dto.ename}
						</td>

					</tr>

				</c:forEach>

			</tbody>

		</table>

		<button type="button"
			class="moveMainBtn"
			onclick="location.href='${pageContext.request.contextPath}/worker/main'">

			작업자 메인 이동

		</button>

	</div>

</body>

</html>