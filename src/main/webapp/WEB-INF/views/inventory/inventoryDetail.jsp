<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="fmt"
	uri="http://java.sun.com/jsp/jstl/fmt"%>

<%-- =========================================================
	상세페이지 공통 CSS
	공통 파일은 건드리지 않고 기존 detail.css 그대로 사용
========================================================= --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<%-- =========================================================
	재고 상세페이지 전용 보정 CSS
	공통 CSS 파일은 절대 수정하지 않고, 이 JSP 안에서만 내역서 테이블 폭을 맞춘다.
========================================================= --%>
<style>

	/* =====================================================
		재고 입출고 내역서 표시 보정
		공통 detail.css는 건드리지 않고 이 JSP 안에서만 적용한다.
		입출고번호 / LOT번호가 옆 컬럼 선을 침범하지 않도록
		테이블 폭, 글자 간격, 링크 표시 방식을 조정한다.
	===================================================== */
	.inventory-history-scroll {
		width: 100%;
		overflow-x: hidden;
	}

	.inventory-history-table {
		width: 100%;
		table-layout: fixed;
	}

	.inventory-history-table th,
	.inventory-history-table td {
		font-size: 11px;
		white-space: nowrap;
		word-break: keep-all;
		text-align: center;
		vertical-align: middle;
		padding: 8px 3px;
		letter-spacing: -0.5px;
		overflow: hidden;
	}

	.inventory-history-table .memo-cell {
		text-align: center;
		white-space: nowrap;
		font-size: 11px;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	/* 구분 */
	.inventory-history-table th:nth-child(1),
	.inventory-history-table td:nth-child(1) {
		width: 9%;
	}

	/* 입출고번호 */
	.inventory-history-table th:nth-child(2),
	.inventory-history-table td:nth-child(2) {
		width: 24%;
		font-size: 10.5px;
		letter-spacing: -0.7px;
	}

	/* 수량 */
	.inventory-history-table th:nth-child(3),
	.inventory-history-table td:nth-child(3) {
		width: 13%;
		font-weight: 700;
	}

	/* 누적잔량 */
	.inventory-history-table th:nth-child(4),
	.inventory-history-table td:nth-child(4) {
		width: 13%;
		font-weight: 800;
		color: #0b7a5a;
	}

	/* 입출고일자 */
	.inventory-history-table th:nth-child(5),
	.inventory-history-table td:nth-child(5) {
		width: 12%;
		font-size: 10.5px;
		letter-spacing: -0.6px;
	}

	/* 비고 */
	.inventory-history-table th:nth-child(6),
	.inventory-history-table td:nth-child(6) {
		width: 29%;
	}


	.inventory-history-paging {
		margin-top: 18px;
	}


	/* =====================================================
		LOT 요약 카드
		입고/출고 내역을 보기 전에 총입고, 총출고, 선택 LOT 잔량을 먼저 보여준다.
		공통 CSS는 건드리지 않고 현재 JSP 안에서만 카드 형태로 보정한다.
	===================================================== */
	.lot-summary-box {
		display: grid;
		grid-template-columns: 1.4fr 1fr 1fr 1fr;
		gap: 10px;
		margin-bottom: 14px;
	}

	.lot-summary-item {
		border: 1px solid #d8e3df;
		border-radius: 10px;
		background: #fbfdfc;
		padding: 12px 14px;
		min-height: 62px;
	}

	.lot-summary-label {
		display: block;
		font-size: 12px;
		color: #5f6f6a;
		margin-bottom: 6px;
	}

	.lot-summary-value {
		display: block;
		font-size: 16px;
		font-weight: 800;
		color: #0b7a5a;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	.lot-summary-value.strong {
		font-size: 18px;
		color: #064c39;
	}


	/* =====================================================
		기본정보 품목코드 링크
		품목코드는 재고 화면이 아니라 기준정보관리 > 품목관리의 마스터 정보이므로
		클릭 시 품목관리 상세페이지로 이동한다.
		공통 detail.css는 건드리지 않고 이 JSP에서만 링크 색상을 맞춘다.
	===================================================== */
	.inventory-item-code-link {
		display: inline-block;
		max-width: 100%;
		color: #0b7a5a;
		font-weight: 800;
		text-decoration: none;
		border-bottom: 1px dotted #0b7a5a;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
		vertical-align: middle;
	}

	.inventory-item-code-link::after {
		content: " ↗";
		font-size: 11px;
	}

	.inventory-item-code-link:hover {
		color: #075f46;
	}


	/* =====================================================
		내역서 안에서 다른 상세화면으로 이동하는 링크 표시
		LOT 이력추적 화면 스타일처럼 클릭 가능한 값에 ↗ 표시를 붙인다.
		단, 긴 번호가 옆 칸을 침범하지 않도록 링크 자체를 셀 폭 안에 가둔다.
	===================================================== */
	.inventory-detail-link {
		display: inline-block;
		max-width: 100%;
		color: #0b7a5a;
		font-weight: 700;
		text-decoration: none;
		border-bottom: 1px dotted #0b7a5a;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
		vertical-align: middle;
	}

	.inventory-detail-link::after {
		content: " ↗";
		font-size: 10px;
	}

	.inventory-detail-link:hover {
		color: #075f46;
	}

	/* =====================================================
		모바일 전용 보정
		공통 CSS는 절대 수정하지 않고 inventoryDetail.jsp 안에서만 적용한다.
		팀 공통 모바일 규칙과 충돌하지 않도록 이 화면의 입출고 흐름 테이블은
		모바일에서 카드형으로 바꿔서 깨짐을 막는다.
	===================================================== */
	@media screen and (max-width: 768px) {

		/* =================================================
			상세페이지 전체 여백 보정
			모바일에서는 공통 레이아웃 안에서 좌우 여백만 줄인다.
		================================================= */
		.detail_page {
			padding-left: 10px;
			padding-right: 10px;
		}

		.detail_card {
			padding: 14px 10px;
			overflow: visible;
		}

		/* =================================================
			LOT 요약 카드 모바일 배치
			PC: 4칸 한 줄
			모바일: 2칸씩 두 줄
		================================================= */
		.lot-summary-box {
			grid-template-columns: 1fr 1fr;
			gap: 8px;
			margin-bottom: 12px;
		}

		.lot-summary-item {
			min-height: auto;
			padding: 10px;
			border-radius: 9px;
		}

		.lot-summary-label {
			font-size: 11px;
			margin-bottom: 5px;
		}

		.lot-summary-value {
			font-size: 14px;
			letter-spacing: -0.4px;
		}

		.lot-summary-value.strong {
			font-size: 15px;
		}

		/* =================================================
			입출고 흐름 모바일 카드형 처리
			공통 detail.css의 모바일 테이블 규칙이 th/td를 세로로 쪼개는 경우가 있어서,
			재고 입출고 내역서만 table 형태를 버리고 행 단위 카드로 보여준다.
			공통 파일은 수정하지 않고 이 JSP 안에서만 처리한다.
		================================================= */
		.inventory-history-scroll {
			width: 100%;
			overflow-x: visible !important;
			overflow-y: visible !important;
		}

		.inventory-history-table,
		.inventory-history-table thead,
		.inventory-history-table tbody,
		.inventory-history-table tr,
		.inventory-history-table th,
		.inventory-history-table td {
			display: block !important;
			width: auto !important;
			min-width: 0 !important;
			max-width: none !important;
			box-sizing: border-box !important;
		}

		.inventory-history-table {
			border: 0 !important;
			background: transparent !important;
			table-layout: auto !important;
		}

		.inventory-history-table colgroup,
		.inventory-history-table thead {
			display: none !important;
		}

		.inventory-history-table tbody tr {
			position: relative;
			margin-bottom: 10px;
			padding: 10px 10px 10px 92px;
			border: 1px solid #d8e3df;
			border-radius: 10px;
			background: #ffffff;
			min-height: 118px;
		}

		.inventory-history-table tbody tr td {
			border: 0 !important;
			padding: 3px 0 !important;
			font-size: 12px !important;
			line-height: 1.35 !important;
			text-align: left !important;
			letter-spacing: -0.3px !important;
			white-space: normal !important;
			overflow: visible !important;
			text-overflow: clip !important;
		}

		/* =================================================
			구분 값은 카드 왼쪽 배지처럼 고정해서 한눈에 입고/출고를 구분한다.
		================================================= */
		.inventory-history-table tbody tr td:nth-child(1) {
			position: absolute;
			left: 10px;
			top: 10px;
			width: 68px !important;
			min-height: 98px;
			border-radius: 8px;
			background: #eef7f4;
			color: #0b7a5a;
			font-weight: 800;
			text-align: center !important;
			display: flex !important;
			align-items: center;
			justify-content: center;
			padding: 0 4px !important;
			white-space: normal !important;
		}

		.inventory-history-table tbody tr td:nth-child(2)::before {
			content: "입출고번호";
			font-weight: 700;
			color: #5f6f6a;
			margin-right: 8px;
		}

		.inventory-history-table tbody tr td:nth-child(3)::before {
			content: "수량";
			font-weight: 700;
			color: #5f6f6a;
			margin-right: 8px;
		}

		.inventory-history-table tbody tr td:nth-child(4)::before {
			content: "누적잔량";
			font-weight: 700;
			color: #5f6f6a;
			margin-right: 8px;
		}

		.inventory-history-table tbody tr td:nth-child(5)::before {
			content: "일자";
			font-weight: 700;
			color: #5f6f6a;
			margin-right: 8px;
		}

		.inventory-history-table tbody tr td:nth-child(6)::before {
			content: "비고";
			font-weight: 700;
			color: #5f6f6a;
			margin-right: 8px;
		}

		.inventory-history-table tbody tr td:nth-child(3),
		.inventory-history-table tbody tr td:nth-child(4) {
			font-weight: 800 !important;
		}

		.inventory-history-table tbody tr td:nth-child(4) {
			color: #0b7a5a !important;
		}

		.inventory-detail-link {
			display: inline !important;
			max-width: none !important;
			white-space: normal !important;
			overflow: visible !important;
			text-overflow: clip !important;
		}

		.inventory-history-table .memo-cell {
			font-size: 12px !important;
			white-space: normal !important;
			overflow: visible !important;
			text-overflow: clip !important;
		}
	}

	/* =====================================================
		작은 모바일 화면 보정
		360px 이하에서는 LOT 요약 카드도 1칸씩 보여서 글자가 눌리지 않게 한다.
	===================================================== */
	@media screen and (max-width: 380px) {

		.lot-summary-box {
			grid-template-columns: 1fr;
		}
	}

</style>

<div class="detail_page">

	<div class="detail_header">

		<div>

			<h2 class="detail_title">
				재고 상세
			</h2>

			<div class="detail_path">
				자재/재고관리 &gt; 재고조회 관리 &gt; 재고 상세
			</div>

		</div>

		<div class="detail_btn_area">

			<c:if test="${sessionScope.loginUser.role eq 'ADMIN'
				or sessionScope.loginUser.role eq 'MANAGER'}">

				<c:if test="${mode ne 'edit'}">

					<button type="button"
						class="detail_btn_green"
						onclick="location.href='${pageContext.request.contextPath}/inventory/stockList/detail?inventoryId=${inventory.inventoryId}&mode=edit'">

						<svg width="16"
							height="16"
							viewBox="0 0 24 24"
							fill="none"
							stroke="currentColor"
							stroke-width="2"
							stroke-linecap="round"
							stroke-linejoin="round"
							style="vertical-align: -3px; margin-right: 6px;"
							aria-hidden="true">

							<path d="M12 20h9"></path>
							<path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"></path>

						</svg>

						수정

					</button>

				</c:if>

				<c:if test="${mode eq 'edit'}">

					<button type="submit"
						id="saveBtn"
						class="detail_btn_green"
						form="updateForm">

						<svg width="16"
							height="16"
							viewBox="0 0 24 24"
							fill="none"
							stroke="currentColor"
							stroke-width="2"
							stroke-linecap="round"
							stroke-linejoin="round"
							style="vertical-align: -3px; margin-right: 6px;"
							aria-hidden="true">

							<path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
							<path d="M17 21v-8H7v8"></path>
							<path d="M7 3v5h8"></path>

						</svg>

						저장

					</button>

					<button type="button"
						id="cancelBtn"
						class="detail_btn_line"
						onclick="location.href='${pageContext.request.contextPath}/inventory/stockList/detail?inventoryId=${inventory.inventoryId}'">

						<svg width="16"
							height="16"
							viewBox="0 0 24 24"
							fill="none"
							stroke="currentColor"
							stroke-width="2"
							stroke-linecap="round"
							stroke-linejoin="round"
							style="vertical-align: -3px; margin-right: 6px;"
							aria-hidden="true">

							<path d="M18 6L6 18"></path>
							<path d="M6 6l12 12"></path>

						</svg>

						취소

					</button>

				</c:if>

			</c:if>

			<button type="button"
				class="detail_btn_line"
				onclick="location.href='${pageContext.request.contextPath}/inventory/stockList'">

				<svg width="16"
					height="16"
					viewBox="0 0 24 24"
					fill="none"
					stroke="currentColor"
					stroke-width="2"
					stroke-linecap="round"
					stroke-linejoin="round"
					style="vertical-align: -3px; margin-right: 6px;"
					aria-hidden="true">

					<path d="M8 6h13"></path>
					<path d="M8 12h13"></path>
					<path d="M8 18h13"></path>
					<path d="M3 6h.01"></path>
					<path d="M3 12h.01"></path>
					<path d="M3 18h.01"></path>

				</svg>

				목록

			</button>

		</div>

	</div>

	<c:choose>

		<c:when test="${mode eq 'edit'}">

			<form id="updateForm"
				method="post"
				action="${pageContext.request.contextPath}/inventory/stockList/update">

				<input type="hidden"
					name="inventoryId"
					value="${inventory.inventoryId}">

				<div class="detail_card">

					<div class="detail_card_title">
						기본 정보
					</div>

					<table class="detail_info_table">

						<tbody>

							<%-- =====================================================
								화면 표시용 기본 정보
								재고번호 / 품목ID / 단위는 중복 표시라서 제외한다.
								단위는 현재재고/단위 칸에 같이 보여준다.
							===================================================== --%>
							<tr>

								<th>품목코드</th>
								<td>
									<%-- =====================================================
										품목코드 클릭 시 기준정보관리 > 품목관리 상세로 이동한다.
										품목코드는 재고/입출고 데이터가 아니라 품목 마스터 정보이므로
										/master/item/detail?itemId=품목ID 로 연결한다.
									===================================================== --%>
									<a class="inventory-item-code-link"
										href="${pageContext.request.contextPath}/master/item/detail?itemId=${inventory.itemId}">
										${inventory.itemCode}
									</a>
								</td>

								<th>품목명</th>
								<td>${inventory.itemName}</td>

								<th>품목유형</th>
								<td>
									<c:choose>
										<c:when test="${inventory.itemType eq 'FG'}">완제품</c:when>
										<c:when test="${inventory.itemType eq 'RM'}">원자재</c:when>
										<c:when test="${inventory.itemType eq 'SM'}">완제품</c:when>
										<c:otherwise>${inventory.itemType}</c:otherwise>
									</c:choose>
								</td>

							</tr>

							<tr>

								<th>현재재고/단위</th>
								<td>

									<input type="number"
										name="inventoryStock"
										class="search-input"
										value="${inventory.inventoryStock}">

									${inventory.itemUnit}

								</td>

								<th>창고위치</th>
								<td>

									<input type="text"
										name="stockLocation"
										class="search-input"
										value="${inventory.stockLocation}">

								</td>

								<th>생성일</th>
								<td>${inventory.createdDate}</td>

							</tr>

							<tr>

								<th>수정일</th>
								<td>${inventory.updatedDate}</td>

								<th>비고</th>
								<td colspan="3">

									<input type="text"
										name="remark"
										class="search-input"
										value="${inventory.remark}">

								</td>

							</tr>

						</tbody>

					</table>

				</div>

			</form>

		</c:when>

		<c:otherwise>

			<div class="detail_card">

				<div class="detail_card_title">
					기본 정보
				</div>

				<table class="detail_info_table">

					<tbody>

						<%-- =====================================================
							재고 상세 기본정보
							재고번호 / 품목ID / 단위는 화면에서 제외한다.
							단위는 현재재고/단위에 함께 표시한다.
						===================================================== --%>
						<tr>

							<th>품목코드</th>
							<td>
								<%-- =====================================================
									품목코드 클릭 시 기준정보관리 > 품목관리 상세로 이동한다.
									기존 자재입출고관리 검색 이동이 아니라 품목 마스터 상세로 연결한다.
								===================================================== --%>
								<a class="inventory-item-code-link"
									href="${pageContext.request.contextPath}/master/item/detail?itemId=${inventory.itemId}">
									${inventory.itemCode}
								</a>
							</td>

							<th>품목명</th>
							<td>${inventory.itemName}</td>

							<th>품목유형</th>
							<td>
								<c:choose>
									<c:when test="${inventory.itemType eq 'FG'}">완제품</c:when>
									<c:when test="${inventory.itemType eq 'RM'}">원자재</c:when>
									<c:when test="${inventory.itemType eq 'SM'}">완제품</c:when>
									<c:otherwise>${inventory.itemType}</c:otherwise>
								</c:choose>
							</td>

						</tr>

						<tr>

							<th>현재재고/단위</th>
							<td><fmt:formatNumber value="${inventory.inventoryStock}" pattern="#,###" /> ${inventory.itemUnit}</td>

							<th>창고위치</th>
							<td>${inventory.stockLocation}</td>

							<th>생성일</th>
							<td>${inventory.createdDate}</td>

						</tr>

						<tr>

							<th>수정일</th>
							<td>${inventory.updatedDate}</td>

							<th>비고</th>
							<td colspan="3">${inventory.remark}</td>

						</tr>

					</tbody>

				</table>

			</div>

		</c:otherwise>

	</c:choose>


	<%-- =========================================================
		재고 입출고 내역서
		품목코드 기준 전체 내역이 아니라 최신 자재 LOT번호 기준으로만 조회한다.
		입고량, 출고량, 선택 LOT 잔량을 한눈에 확인할 수 있도록
		요약 카드와 수량/누적잔량 중심의 흐름 테이블로 보여준다.
		공통 paging.jsp는 수정하지 않는다.
	========================================================= --%>
	<div class="detail_card">

		<div class="detail_card_title">
			선택 LOT 입출고 흐름
		</div>

		<c:if test="${not empty inoutHistory}">

			<c:set var="lotSummary"
				value="${inoutHistory[0]}" />

			<%-- =====================================================
				LOT 기준 요약
				팀 피드백 반영: 입고 1000, 출고 100/200이면
				현재 잔여수량 700처럼 바로 보이도록 먼저 요약한다.
				LOT번호는 LOT 이력추적 화면으로 이동할 수 있게 링크를 건다.
			===================================================== --%>
			<div class="lot-summary-box">

				<div class="lot-summary-item">
					<span class="lot-summary-label">선택 LOT번호</span>
					<a class="lot-summary-value inventory-detail-link"
						title="${lotSummary.materialLot}"
						href="${pageContext.request.contextPath}/lot/lothistory?searchType=lotNo&keyword=${lotSummary.materialLot}">
						${lotSummary.materialLot}
					</a>
				</div>

				<div class="lot-summary-item">
					<span class="lot-summary-label">총입고량</span>
					<span class="lot-summary-value">
						<fmt:formatNumber value="${lotSummary.totalInQty}" pattern="#,###" /> ${lotSummary.itemUnit}
					</span>
				</div>

				<div class="lot-summary-item">
					<span class="lot-summary-label">총출고량</span>
					<span class="lot-summary-value">
						<fmt:formatNumber value="${lotSummary.totalOutQty}" pattern="#,###" /> ${lotSummary.itemUnit}
					</span>
				</div>

				<div class="lot-summary-item">
					<span class="lot-summary-label">선택 LOT 잔량</span>
					<span class="lot-summary-value strong">
						<fmt:formatNumber value="${lotSummary.currentRemainQty}" pattern="#,###" /> ${lotSummary.itemUnit}
					</span>
				</div>

			</div>

		</c:if>

		<div class="inventory-history-scroll">

			<table class="detail_info_table inventory-history-table">

				<colgroup>
					<col style="width: 9%;">
					<col style="width: 24%;">
					<col style="width: 13%;">
					<col style="width: 13%;">
					<col style="width: 12%;">
					<col style="width: 29%;">
				</colgroup>

				<thead>

					<tr>
						<th>구분</th>
						<th>입출고번호</th>
						<th>수량</th>
						<th>누적잔량</th>
						<th>입출고일자</th>
						<th>비고</th>
					</tr>

				</thead>

				<tbody>

					<c:choose>

						<c:when test="${empty inoutHistory}">

							<tr>
								<td colspan="6">
									입출고 내역이 없습니다.
								</td>
							</tr>

						</c:when>

						<c:otherwise>

							<c:forEach var="history"
								items="${inoutHistory}">

								<tr>
									<td>
										<c:choose>
											<c:when test="${history.inoutType eq 'MI'}">입고</c:when>
											<c:when test="${history.inoutType eq 'MO-PROD'}">사용/출고</c:when>
											<c:otherwise>${history.inoutType}</c:otherwise>
										</c:choose>
									</td>

									<td title="${history.displayDocNo}">
										<a class="inventory-detail-link"
											href="${pageContext.request.contextPath}/inventory/materialIn/detail?inoutId=${history.inoutId}">
											${history.displayDocNo}
										</a>
									</td>

									<%-- =====================================================
										수량 컬럼
										입고는 +수량, 출고/사용은 -수량으로 보여줘서
										재고 흐름을 한 줄에서 바로 이해할 수 있게 한다.
									===================================================== --%>
									<td>
										<c:choose>
											<c:when test="${history.inQty gt 0}">
												+<fmt:formatNumber value="${history.inQty}" pattern="#,###" /> ${history.itemUnit}
											</c:when>
											<c:when test="${history.outQty gt 0}">
												-<fmt:formatNumber value="${history.outQty}" pattern="#,###" /> ${history.itemUnit}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<%-- =====================================================
										누적잔량
										입고/출고가 반영된 뒤 해당 LOT가 몇 개 남았는지 표시한다.
									===================================================== --%>
									<td>
										<fmt:formatNumber value="${history.remainQty}" pattern="#,###" /> ${history.itemUnit}
									</td>

									<td>${history.inoutDate}</td>
									<td class="memo-cell" title="${history.historyRemark}">${history.historyRemark}</td>
								</tr>

							</c:forEach>

						</c:otherwise>

					</c:choose>

				</tbody>

			</table>

			<%-- =====================================================
				LOT 기준 최근 흐름만 보여주므로 공통 페이징은 사용하지 않는다.
				공통 paging.jsp 자체는 수정하지 않는다.
			===================================================== --%>
		</div>

	</div>

</div>
