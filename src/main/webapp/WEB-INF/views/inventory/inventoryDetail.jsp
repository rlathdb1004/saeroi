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
		하단 가로 스크롤바를 없애고, 입출고번호 / LOT번호가 한 줄로 보이도록
		테이블 폭과 글자 크기만 조정한다.
		말줄임표(...) 처리는 사용하지 않는다.
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
		padding-left: 4px;
		padding-right: 4px;
		letter-spacing: -0.4px;
	}

	.inventory-history-table .memo-cell {
		text-align: center;
		white-space: nowrap;
		font-size: 11px;
	}

	/* 구분 */
	.inventory-history-table th:nth-child(1),
	.inventory-history-table td:nth-child(1) {
		width: 10%;
	}

	/* 입출고번호 */
	.inventory-history-table th:nth-child(2),
	.inventory-history-table td:nth-child(2) {
		width: 19%;
	}

	/* 입출고일자 */
	.inventory-history-table th:nth-child(3),
	.inventory-history-table td:nth-child(3) {
		width: 12%;
	}

	/* LOT번호 */
	.inventory-history-table th:nth-child(4),
	.inventory-history-table td:nth-child(4) {
		width: 20%;
	}

	/* 수량/단위 */
	.inventory-history-table th:nth-child(5),
	.inventory-history-table td:nth-child(5) {
		width: 11%;
	}

	/* 상태 */
	.inventory-history-table th:nth-child(6),
	.inventory-history-table td:nth-child(6) {
		width: 8%;
	}

	/* 비고 */
	.inventory-history-table th:nth-child(7),
	.inventory-history-table td:nth-child(7) {
		width: 20%;
	}

	.inventory-history-paging {
		margin-top: 18px;
	}

	/* =====================================================
		내역서 안에서 다른 상세화면으로 이동하는 링크 표시
		LOT 이력추적 화면 스타일처럼 클릭 가능한 값에 ↗ 표시를 붙인다.
	===================================================== */
	.inventory-detail-link {
		color: #0b7a5a;
		font-weight: 700;
		text-decoration: none;
		border-bottom: 1px dotted #0b7a5a;
		white-space: nowrap;
	}

	.inventory-detail-link::after {
		content: " ↗";
		font-size: 12px;
	}

	.inventory-detail-link:hover {
		color: #075f46;
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
								<td>${inventory.itemCode}</td>

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
							<td>${inventory.itemCode}</td>

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
		재고번호를 따라갔을 때 해당 품목의 입고 / 사용 / 출고 이력을 확인한다.
		내역은 Controller에서 5개씩 잘라서 전달하고, 아래 공통 페이징으로 이동한다.
		공통 paging.jsp는 수정하지 않는다.
	========================================================= --%>
	<div class="detail_card">

		<div class="detail_card_title">
			재고 입출고 내역서
		</div>

		<div class="inventory-history-scroll">

		<table class="detail_info_table inventory-history-table">

			<colgroup>
				<col style="width: 10%;">
				<col style="width: 19%;">
				<col style="width: 12%;">
				<col style="width: 20%;">
				<col style="width: 11%;">
				<col style="width: 8%;">
				<col style="width: 20%;">
			</colgroup>

			<thead>

				<tr>
					<th>구분</th>
					<th>입출고번호</th>
					<th>입출고일자</th>
					<th>LOT번호</th>
					<th>수량/단위</th>
					<th>상태</th>
					<th>비고</th>
				</tr>

			</thead>

			<tbody>

				<c:choose>

					<c:when test="${empty inoutHistory}">

						<tr>
							<td colspan="7">
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

								<td>
									<a class="inventory-detail-link"
										href="${pageContext.request.contextPath}/inventory/materialIn/detail?inoutId=${history.inoutId}">
										${history.docNo}
									</a>
								</td>
								<td>${history.inoutDate}</td>
								<td>
									<a class="inventory-detail-link"
										href="${pageContext.request.contextPath}/lot/lothistory?searchType=lotNo&keyword=${history.materialLot}">
										${history.materialLot}
									</a>
								</td>
								<td><fmt:formatNumber value="${history.inoutQty}" pattern="#,###" /> ${history.itemUnit}</td>
								<td>${history.status}</td>
								<td class="memo-cell">${history.historyRemark}</td>
							</tr>

						</c:forEach>

					</c:otherwise>

				</c:choose>

			</tbody>

		</table>

		<%-- =====================================================
			공통 페이징 영역
			Controller에서 pageInfo / pageUrl을 전달하므로 기존 paging.jsp를 그대로 사용한다.
			기본 5개씩 보이고, 공통 select 박스에서 몇 개씩 볼지 선택할 수 있다.
		===================================================== --%>
		<div class="inventory-history-paging">
			<jsp:include page="/WEB-INF/views/common/paging.jsp" />
		</div>

	</div>

</div>
