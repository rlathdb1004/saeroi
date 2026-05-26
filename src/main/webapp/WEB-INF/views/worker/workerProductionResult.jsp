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

<style>

	* {

		margin: 0;
		padding: 0;
		box-sizing: border-box;
		font-family: Pretendard;
	}

	body {

		background: #f7f8f9;
		padding: 30px;
	}

	:root {

		--mainColor: #2f7d62;
		--mainHover: #256851;
	}

	/* =====================================================
		상단 타이틀
	===================================================== */
	.workerResultTitle {

		font-size: 34px;
		font-weight: 800;

		color: #111;

		margin-bottom: 30px;
	}

	/* =====================================================
		테이블 박스
	===================================================== */
	.workerTableWrap {

		background: #fff;

		border-radius: 18px;

		padding: 30px;

		box-shadow: 0 2px 12px rgba(0,0,0,0.08);
	}

	/* =====================================================
		테이블
	===================================================== */
	.workerTable {

		width: 100%;

		border-collapse: collapse;
	}

	.workerTable thead tr {

		background: var(--mainColor);
		color: #fff;
	}

	.workerTable th {

		padding: 16px;

		font-size: 16px;
		font-weight: 700;
	}

	.workerTable td {

		padding: 16px;

		border-bottom: 1px solid #eee;

		text-align: center;

		font-size: 15px;
	}

	.workerTable tbody tr:hover {

		background: #f3f8f5;
	}

	/* =====================================================
		데이터 없을 때
	===================================================== */
	.noData {

		padding: 60px 0;

		text-align: center;

		font-size: 18px;
		font-weight: 600;

		color: #888;
	}

	/* =====================================================
		상단 작업자 정보
	===================================================== */
	.workerInfoBox {

		margin-bottom: 20px;

		font-size: 18px;
		font-weight: 700;

		color: var(--mainColor);
	}

	/* =====================================================
		메인 버튼
	===================================================== */
	.moveMainBtn {

		margin-top: 25px;

		width: 180px;
		height: 52px;

		border: none;
		border-radius: 12px;

		background: var(--mainColor);
		color: #fff;

		font-size: 16px;
		font-weight: 700;

		cursor: pointer;
	}

	.moveMainBtn:hover {

		background: var(--mainHover);
	}

</style>

</head>

<body>

	<!-- =================================================
		타이틀
	================================================= -->
	<h2 class="workerResultTitle">

		작업자 생산실적 조회

	</h2>

	<!-- =================================================
		작업자 정보
	================================================= -->
	<div class="workerInfoBox">

		${workerName} 작업자 생산실적 목록

	</div>

	<!-- =================================================
		테이블
	================================================= -->
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
						생산상태
					</th>

					<th>
						작업자
					</th>

				</tr>

			</thead>

			<tbody>

				<!-- =========================================
					데이터 없을 때
				========================================= -->
				<c:if test="${empty list}">

					<tr>

						<td colspan="5"
							class="noData">

							생산실적 데이터가 없습니다.

						</td>

					</tr>

				</c:if>

				<!-- =========================================
					생산실적 목록
				========================================= -->
				<c:forEach var="dto"
					items="${list}">

					<tr>

						<td>
							${dto.prodNo}
						</td>

						<td>
							${dto.itemName}
						</td>

						<td>
							${dto.prodQty}
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

		<!-- =============================================
			메인 이동 버튼
		============================================= -->
		<button type="button"
			class="moveMainBtn"
			onclick="location.href='${pageContext.request.contextPath}/worker/main'">

			작업자 메인 이동

		</button>

	</div>

</body>

</html>