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

<style>

	:root {

		--mainColor: #2f7d62;
		--mainHover: #256851;
	}

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

	/* =====================================================
		타이틀
	===================================================== */
	.pageTitle {

		font-size: 32px;
		font-weight: 800;

		margin-bottom: 24px;

		color: #111;
	}

	/* =====================================================
		작업자 정보
	===================================================== */
	.workerInfo {

		font-size: 18px;
		font-weight: 700;

		color: var(--mainColor);

		margin-bottom: 20px;
	}

	/* =====================================================
		테이블 박스
	===================================================== */
	.tableWrap {

		background: #fff;

		border-radius: 18px;

		padding: 26px;

		box-shadow: 0 2px 12px rgba(0,0,0,0.08);
	}

	/* =====================================================
		테이블
	===================================================== */
	table {

		width: 100%;

		border-collapse: collapse;
	}

	thead {

		background: var(--mainColor);
		color: #fff;
	}

	th {

		padding: 16px;

		font-size: 15px;
		font-weight: 700;
	}

	td {

		padding: 16px;

		text-align: center;

		border-bottom: 1px solid #eee;

		font-size: 14px;
	}

	tbody tr:hover {

		background: #f4faf7;
	}

	/* =====================================================
		DTO 디버그 박스
	===================================================== */
	.debugBox {

		background: #fff8dc;

		color: #111;

		font-size: 13px;

		text-align: left;

		padding: 14px;

		line-height: 1.6;

		border-bottom: 1px solid #ddd;
	}

	/* =====================================================
		데이터 없음
	===================================================== */
	.noData {

		padding: 50px 0;

		font-size: 18px;
		font-weight: 700;

		color: #888;
	}

	/* =====================================================
		메인 이동 버튼
	===================================================== */
	.moveBtn {

		margin-top: 24px;

		width: 180px;
		height: 50px;

		border: none;
		border-radius: 12px;

		background: var(--mainColor);
		color: #fff;

		font-size: 15px;
		font-weight: 700;

		cursor: pointer;
	}

	.moveBtn:hover {

		background: var(--mainHover);
	}

</style>

</head>

<body>

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