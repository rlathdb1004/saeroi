
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="fmt"
	uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>

	.coTable {
		width: 100%;
		table-layout: fixed;
	}

	.coTable th,
	.coTable td {
		font-size: 13px;
		text-align: center;
		vertical-align: middle;
		white-space: nowrap;
		padding: 12px 5px;
		word-break: keep-all;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	/* =====================================================
		선택
	===================================================== */
	.coTable th:nth-child(1),
	.coTable td:nth-child(1) {
		width: 4%;
	}

	/* =====================================================
		품목코드
		품목명이 더 넓게 보이도록 기존보다 살짝 줄임
	===================================================== */
	.coTable th:nth-child(2),
	.coTable td:nth-child(2) {
		width: 14%;
		font-size: 13px;
		letter-spacing: -0.3px;
	}

	/* =====================================================
		품목유형
		원자재 / 완제품만 표시되므로 폭을 크게 줄임
	===================================================== */
	.coTable th:nth-child(3),
	.coTable td:nth-child(3) {
		width: 7%;
		font-size: 13px;
		letter-spacing: -0.3px;
	}

	/* =====================================================
		품목명
		가장 많이 보여야 하는 컬럼이므로 폭을 크게 늘림
	===================================================== */
	.coTable th:nth-child(4),
	.coTable td:nth-child(4) {
		width: 31%;
		font-size: 13px;
		letter-spacing: -0.3px;
	}

	/* =====================================================
		현재재고/단위
		숫자 + 단위만 표시되므로 폭을 줄임
	===================================================== */
	.coTable th:nth-child(5),
	.coTable td:nth-child(5) {
		width: 10%;
		font-size: 13px;
	}

	/* =====================================================
		창고위치
		품목명 공간 확보를 위해 기존보다 줄임
	===================================================== */
	.coTable th:nth-child(6),
	.coTable td:nth-child(6) {
		width: 11%;
		font-size: 13px;
		letter-spacing: -0.3px;
	}

	/* =====================================================
		생성일
		날짜만 표시되므로 기존보다 줄임
	===================================================== */
	.coTable th:nth-child(7),
	.coTable td:nth-child(7) {
		width: 13%;
		font-size: 13px;
	}

	/* =====================================================
		상세
		보기 버튼만 있으므로 최소 폭으로 줄임
	===================================================== */
	.coTable th:nth-child(8),
	.coTable td:nth-child(8) {
		width: 6%;
		font-size: 13px;
	}


	/* =====================================================
		모바일 테이블 컬럼 보정
		팀 공통 규칙에 맞게 mobile_show / mobile_hidden 만 사용한다.
		공통 CSS 파일은 수정하지 않고, 이 JSP 안에서만 모바일 표시를 보정한다.
		모바일 노출 컬럼:
		선택 / 품목명 / 현재재고/단위 / 창고위치 / 상세
		상세 컬럼은 반드시 mobile_show로 유지한다.
	===================================================== */
	@media screen and (max-width: 768px) {

		.coTable th.mobile_hidden,
		.coTable td.mobile_hidden {
			display: none !important;
		}

		.coTable th.mobile_show,
		.coTable td.mobile_show {
			display: table-cell !important;
		}

		.coTable {
			width: 100%;
			table-layout: fixed;
		}

		.coTable th,
		.coTable td {
			font-size: 11px;
			padding: 10px 4px;
			letter-spacing: -0.5px;
		}

		.coTable th:nth-child(1),
		.coTable td:nth-child(1) {
			width: 46px;
		}

		/* =================================================
			모바일 컬럼 폭 최종 보정
			팀 공통 mobile_show/mobile_hidden 규칙은 그대로 사용하고,
			품목명이 너무 넓어서 상세 컬럼이 잘리지 않도록 폭만 조정한다.
		================================================= */
		.coTable th:nth-child(4),
		.coTable td:nth-child(4) {
			width: 38%;
		}

		.coTable th:nth-child(5),
		.coTable td:nth-child(5) {
			width: 18%;
		}

		.coTable th:nth-child(6),
		.coTable td:nth-child(6) {
			width: 22%;
		}

		.coTable th:nth-child(8),
		.coTable td:nth-child(8) {
			width: 52px;
		}

		.coTable th,
		.coTable td {
			overflow: hidden;
			text-overflow: ellipsis;
			white-space: nowrap;
		}

		.coDetailBtn {
			min-width: 36px;
			padding: 6px 6px;
			font-size: 11px;
		}
	}

</style>

<div class="coPageWrap">

	<form class="search-form"
		method="get"
		action="${pageContext.request.contextPath}/inventory/stockList">

		<div class="search-box">

			<div class="search-row">

				<%-- =====================================================
					시작일
				===================================================== --%>
				<div class="search-item">

					<label class="search-label">
						시작일
					</label>

					<input type="date"
						name="startDate"
						id="inventoryStartDate"
						class="search-date"
						value="${startDate}">

				</div>

				<%-- =====================================================
					종료일
				===================================================== --%>
				<div class="search-item">

					<label class="search-label">
						종료일
					</label>

					<input type="date"
						name="endDate"
						id="inventoryEndDate"
						class="search-date"
						min="${startDate}"
						value="${endDate}">

				</div>

				<%-- =====================================================
					구분
				===================================================== --%>
				<div class="search-item">

					<label class="search-label">
						구분
					</label>

					<select name="searchType"
						class="search-select">

						<option value="">
							전체
						</option>

						<option value="itemCode"
							<c:if test="${searchType eq 'itemCode'}">selected</c:if>>

							품목코드

						</option>

						<option value="itemName"
							<c:if test="${searchType eq 'itemName'}">selected</c:if>>

							품목명

						</option>

					</select>

				</div>

				<%-- =====================================================
					검색어
				===================================================== --%>
				<div class="search-item">

					<label class="search-label">
						검색어
					</label>

					<input type="text"
						name="keyword"
						class="search-input"
						placeholder="검색키워드"
						value="${keyword}">

				</div>

				<div class="search-btn-wrap">

					<%-- =================================================
						검색 버튼
					================================================= --%>
					<button type="submit"
						class="search-btn search-btn-main">

						<svg viewBox="0 0 24 24"
							fill="none">

							<circle cx="10.5"
								cy="10.5"
								r="7.5"
								stroke="currentColor"
								stroke-width="2">
							</circle>

							<path d="M16 16L21 21"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round">
							</path>

						</svg>

						검색

					</button>

					<%-- =================================================
						초기화 버튼
					================================================= --%>
					<button type="button"
						class="search-btn search-btn-sub search-reset-btn"
						onclick="location.href='${pageContext.request.contextPath}/inventory/stockList'">

						<svg viewBox="0 0 24 24"
							fill="none">

							<path d="M20 12C20 16.4 16.4 20 12 20C7.6 20 4 16.4 4 12C4 7.6 7.6 4 12 4C14.4 4 16.5 5.1 18 6.8"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round">
							</path>

							<path d="M18 4V7H21"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round"
								stroke-linejoin="round">
							</path>

						</svg>

						초기화

					</button>

				</div>

			</div>

		</div>

	</form>

	<form method="post"
		id="deleteForm"
		action="${pageContext.request.contextPath}/inventory/stockList/delete">

		<div class="coTableTop">

			<p class="coTotalCount">
				총 ${pageInfo.totalCount}건
			</p>

			<%-- =====================================================
				관리자 / 매니저만 등록 삭제 가능
			===================================================== --%>
			<c:if test="${sessionScope.loginUser.role eq 'ADMIN'
				or sessionScope.loginUser.role eq 'MANAGER'}">

				<div class="search-btn-right">

					<%-- =================================================
						등록 버튼 + SVG 추가
					================================================= --%>
					<button type="button"
						class="search-btn search-btn-main modal_open_btn"
						data_modal_target="#modal_insert">

						<svg viewBox="0 0 24 24"
							fill="none">

							<path d="M12 5V19"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round">
							</path>

							<path d="M5 12H19"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round">
							</path>

						</svg>

						등록

					</button>

					<%-- =================================================
						선택 삭제 버튼 + SVG 추가
					================================================= --%>
					<button type="button"
						class="search-btn search-btn-sub"
						onclick="deleteCheck()">

						<svg viewBox="0 0 24 24"
							fill="none">

							<path d="M4 7H20"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round">
							</path>

							<path d="M10 11V17"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round">
							</path>

							<path d="M14 11V17"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round">
							</path>

							<path d="M6 7L7 21H17L18 7"
								stroke="currentColor"
								stroke-width="2"
								stroke-linejoin="round">
							</path>

							<path d="M9 7V4H15V7"
								stroke="currentColor"
								stroke-width="2"
								stroke-linejoin="round">
							</path>

						</svg>

						선택 삭제

					</button>

				</div>

			</c:if>

		</div>

		<div class="coTableWrap">

			<%-- =====================================================
				재고조회 관리 목록 테이블 모바일 컬럼 규칙
				mobile_show   : 모바일에서도 보여줄 컬럼
				mobile_hidden : 모바일에서 숨길 컬럼
				모바일에서는 선택 / 품목명 / 현재재고/단위 / 창고위치 / 상세 총 5개만 노출한다.
				공통 CSS / 공통 JSP는 절대 수정하지 않는다.
			===================================================== --%>
			<%-- =====================================================
				재고조회관리 목록 모바일 컬럼 규칙 최종 반영
				mobile_show   : 모바일에서도 보여줄 컬럼
				mobile_hidden : 모바일에서 숨길 컬럼
				모바일 노출 컬럼은 선택 / 품목명 / 현재재고/단위 / 창고위치 / 상세 총 5개이다.
				상세 컬럼은 팀 공통 규칙상 반드시 mobile_show로 유지한다.
				공통 JSP / 공통 CSS는 수정하지 않는다.
			===================================================== --%>
			<table class="coTable">

				<thead>

					<tr>

						<th class="mobile_show">

							<label id="checkAllLabel">
								선택
							</label>

							<input type="checkbox"
								id="checkAll"
								style="display:none;">

						</th>

						<th class="mobile_hidden">품목코드</th>
						<th class="mobile_hidden">품목유형</th>
						<th class="mobile_show">품목명</th>
						<th class="mobile_show">현재재고/단위</th>
						<th class="mobile_show">창고위치</th>
						<%-- =====================================================
							모바일 컬럼 규칙
							생성일은 PC에서는 보이지만 모바일에서는 5개 컬럼 제한 때문에 숨긴다.
							모바일 노출 컬럼: 선택 / 품목명 / 현재재고/단위 / 창고위치 / 상세
						===================================================== --%>
						<th class="mobile_hidden">생성일</th>
						<th class="mobile_show">상세</th>

					</tr>

				</thead>

				<tbody>

					<c:forEach var="inventory"
						items="${list}">

						<tr>

							<td class="mobile_show">

								<input type="checkbox"
									name="inventoryIds"
									value="${inventory.inventoryId}">

							</td>

							<td class="mobile_hidden"
								title="${inventory.itemCode}">

								${inventory.itemCode}

							</td>

							<td class="mobile_hidden">

								<c:choose>

									<c:when test="${inventory.itemType eq 'FG'}">
										완제품
									</c:when>

									<c:when test="${inventory.itemType eq 'RM'}">
										원자재
									</c:when>

									<%-- =====================================================
										우리 프로젝트 기준
										SM은 화면에서 부자재가 아니라 완제품으로 표시한다.
									===================================================== --%>
									<c:when test="${inventory.itemType eq 'SM'}">
										완제품
									</c:when>

									<c:otherwise>
										${inventory.itemType}
									</c:otherwise>

								</c:choose>

							</td>

							<td class="mobile_show"
								title="${inventory.itemName}">

								${inventory.itemName}

							</td>

							<td class="mobile_show">

								<%-- =====================================================
									팀장님 피드백 반영
									현재재고와 단위를 따로 보여주지 않고 한 칸에 합쳐서 표시한다.
								===================================================== --%>
								<fmt:formatNumber value="${inventory.inventoryStock}" pattern="#,###" /> ${inventory.itemUnit}

							</td>

							<td class="mobile_show">

								${inventory.stockLocation}

							</td>

							<%-- =====================================================
								모바일 컬럼 규칙
								생성일 값도 header와 동일하게 mobile_hidden 처리한다.
								공통 CSS는 수정하지 않고 JSP 컬럼 class만 맞춘다.
							===================================================== --%>
							<td class="mobile_hidden">

								${inventory.createdDate}

							</td>

							<td class="mobile_show">

								<button type="button"
									class="coDetailBtn"
									onclick="location.href='${pageContext.request.contextPath}/inventory/stockList/detail?inventoryId=${inventory.inventoryId}'">

									보기

								</button>

							</td>

						</tr>

					</c:forEach>

				</tbody>

			</table>

		</div>

	</form>

	<%-- =========================================================
		재고 등록 모달
	========================================================= --%>
	<div id="modal_insert"
		class="modal_wrap"
		aria-hidden="true">

		<div class="modal_box"
			role="dialog"
			aria-modal="true">

			<div class="modal_header">

				<h3 class="modal_title">
					재고 등록
				</h3>

			</div>

			<form id="inventoryInsertForm"
				class="modal_form"
				method="post"
				action="${pageContext.request.contextPath}/inventory/stockList/insert"
				onsubmit="return checkInventoryInsert();">

				<div class="modal_body modal_body_2col">

					<%-- =================================================
						재고번호
						INVENTORY_ID는 DB 시퀀스로 자동 생성되므로 화면에서는 자동생성 안내만 표시한다.
					================================================= --%>
					<div class="modal_item">

						<label class="modal_label">
							재고번호
						</label>

						<input type="text"
							class="modal_input"
							value="자동생성"
							readonly>

					</div>


					<%-- =================================================
						품목명
					================================================= --%>
					<div class="modal_item">

						<label class="modal_label">

							품목명
							<span class="modal_required">*</span>

						</label>

						<select name="itemId"
							id="insertInventoryItemId"
							class="modal_select">

							<option value="">
								선택
							</option>

							<c:forEach var="item"
								items="${itemList}">

								<option value="${item.itemId}"
									data-code="${item.itemCode}"
									data-type="${item.itemType}"
									data-unit="${item.itemUnit}"
									data-location="${item.stockLocation}"
									data-stock="${item.inventoryStock}">

									${item.itemName}

								</option>

							</c:forEach>

						</select>

						<%-- =================================================
							품목명 에러 메시지
						================================================= --%>
						<div id="inventoryItemError"
							class="input_error_text">

							품목명을 선택해주세요.

						</div>

					</div>

					<%-- =================================================
						품목ID
						ITEM_ID는 품목명 선택 시 자동 표시하고, 실제 저장은 품목명 select의 itemId로 처리한다.
					================================================= --%>
					<div class="modal_item">

						<label class="modal_label">
							품목ID
						</label>

						<input type="text"
							id="insertInventoryItemIdView"
							class="modal_input"
							readonly>

					</div>

					<%-- =================================================
						품목코드
						ITEM 테이블 조회값을 품목 선택 시 자동 표시한다.
					================================================= --%>
					<div class="modal_item">

						<label class="modal_label">
							품목코드
						</label>

						<input type="text"
							id="insertInventoryItemCodeView"
							class="modal_input"
							readonly>

					</div>

					<%-- =================================================
						품목유형
						FG / RM / SM 코드를 한글명으로 자동 표시한다.
						SM은 우리 프로젝트 기준으로 완제품으로 표시한다.
					================================================= --%>
					<div class="modal_item">

						<label class="modal_label">
							품목유형
						</label>

						<input type="text"
							id="insertInventoryItemTypeView"
							class="modal_input"
							readonly>

					</div>

					<%-- =================================================
						단위
						ITEM.ITEM_UNIT 값을 자동 표시한다.
					================================================= --%>
					<div class="modal_item">

						<label class="modal_label">
							단위
						</label>

						<input type="text"
							id="insertInventoryItemUnitView"
							class="modal_input"
							readonly>

					</div>

					<%-- =================================================
						현재재고
					================================================= --%>
					<div class="modal_item">

						<label class="modal_label">

							현재재고
							<span class="modal_required">*</span>

						</label>

						<input type="number"
							name="inventoryStock"
							id="insertInventoryStock"
							class="modal_input"
							min="0">

						<%-- =================================================
							현재재고 에러 메시지
						================================================= --%>
						<div id="inventoryStockError"
							class="input_error_text">

							현재재고는 0 이상 입력해주세요.

						</div>

					</div>

					<%-- =================================================
						창고위치
					================================================= --%>
					<div class="modal_item">

						<label class="modal_label">

							창고위치
							<span class="modal_required">*</span>

						</label>

						<input type="text"
							name="stockLocation"
							id="insertStockLocation"
							class="modal_input">

						<%-- =================================================
							창고위치 에러 메시지
						================================================= --%>
						<div id="stockLocationError"
							class="input_error_text">

							창고위치를 입력해주세요.

						</div>

					</div>

					<%-- =================================================
						비고
					================================================= --%>
					<div class="modal_item">

						<label class="modal_label">
							비고
						</label>

						<input type="text"
							name="remark"
							class="modal_input">

					</div>

					<%-- =================================================
						생성일 / 수정일
						DB의 CREATED_DATE / UPDATED_DATE는 등록 시 SYSDATE로 자동 저장된다.
					================================================= --%>
					<div class="modal_item">

						<label class="modal_label">
							생성일
						</label>

						<input type="text"
							class="modal_input"
							value="등록 시 자동 저장"
							readonly>

					</div>

					<div class="modal_item">

						<label class="modal_label">
							수정일
						</label>

						<input type="text"
							class="modal_input"
							value="등록 시 자동 저장"
							readonly>

					</div>

				</div>

				<div class="modal_footer">

					<button type="button"
						class="modal_btn modal_btn_cancel modal_close_btn">

						취소

					</button>

					<%-- =================================================
						등록 버튼
						type="submit"으로 직접 submit 되게 한다.
						공통 모달 / 공통 JS는 건드리지 않고
						현재 form의 onsubmit="return checkInventoryInsert();" 검증을 통과하면
						Controller(/inventory/stockList/insert)로 정상 전송된다.
					================================================= --%>
					<button type="button"
						class="modal_btn modal_btn_submit"
						onclick="submitInventoryInsertDirect();">

						등록

					</button>

				</div>

			</form>

		</div>

	</div>

	<jsp:include page="/WEB-INF/views/common/paging.jsp" />

</div>

<script>

	// =========================================================
	// 전체 선택
	// =========================================================
	document.getElementById("checkAllLabel").onclick =
		function() {

		var checkAll =
			document.getElementById("checkAll");

		var checks =
			document.getElementsByName("inventoryIds");

		checkAll.checked =
			!checkAll.checked;

		for (var i = 0; i < checks.length; i++) {

			checks[i].checked =
				checkAll.checked;
		}
	};

	// =========================================================
	// 체크박스 상태 동기화
	// =========================================================
	var checks =
		document.getElementsByName("inventoryIds");

	for (var i = 0; i < checks.length; i++) {

		checks[i].onclick = function() {

			var allChecked = true;

			for (var j = 0; j < checks.length; j++) {

				if (!checks[j].checked) {

					allChecked = false;
					break;
				}
			}

			document.getElementById("checkAll").checked =
				allChecked;
		};
	}

	// =========================================================
	// 선택 삭제
	// =========================================================
	function deleteCheck() {

		var checks =
			document.getElementsByName("inventoryIds");

		var checked = false;

		for (var i = 0; i < checks.length; i++) {

			if (checks[i].checked) {
				checked = true;
			}
		}

		if (!checked) {

			alert("삭제할 항목을 선택해주세요.");
			return;
		}

		if (confirm("선택한 항목을 삭제하시겠습니까?")) {

			document.getElementById("deleteForm").submit();
		}
	}

	// =========================================================
	// 등록 방어코딩
	// =========================================================
	function checkInventoryInsert() {

		var itemId =
			document.getElementById(
				"insertInventoryItemId");

		var inventoryStock =
			document.getElementById(
				"insertInventoryStock");

		var stockLocation =
			document.getElementById(
				"insertStockLocation");

		var inventoryItemError =
			document.getElementById(
				"inventoryItemError");

		var inventoryStockError =
			document.getElementById(
				"inventoryStockError");

		var stockLocationError =
			document.getElementById(
				"stockLocationError");

		// =====================================================
		// 초기화
		// =====================================================
		itemId.classList.remove("input_error");
		inventoryStock.classList.remove("input_error");
		stockLocation.classList.remove("input_error");

		inventoryItemError.style.display = "none";
		inventoryStockError.style.display = "none";
		stockLocationError.style.display = "none";

		var isValid = true;

		// =====================================================
		// 품목명 체크
		// =====================================================
		if (itemId.value == "") {

			itemId.classList.add("input_error");

			inventoryItemError.style.display =
				"block";

			isValid = false;
		}

		// =====================================================
		// 현재재고 체크
		// =====================================================
		if (inventoryStock.value == ""
			|| Number(inventoryStock.value) < 0) {

			inventoryStock.classList.add(
				"input_error");

			inventoryStockError.style.display =
				"block";

			isValid = false;
		}

		// =====================================================
		// 창고위치 체크
		// =====================================================
		if (stockLocation.value.trim() == "") {

			stockLocation.classList.add(
				"input_error");

			stockLocationError.style.display =
				"block";

			isValid = false;
		}

		return isValid;
	}

	// =========================================================
	// 품목 선택 시 창고위치 자동입력
	// =========================================================
	document.getElementById(
		"insertInventoryItemId")
		.addEventListener(
			"change",
			function() {

		var selectedOption =
			this.options[this.selectedIndex];

		var stockLocation =
			selectedOption.getAttribute(
				"data-location");

		var itemCode =
			selectedOption.getAttribute(
				"data-code");

		var itemType =
			selectedOption.getAttribute(
				"data-type");

		var itemUnit =
			selectedOption.getAttribute(
				"data-unit");

		var inventoryStock =
			selectedOption.getAttribute(
				"data-stock");

		if (stockLocation == null
			|| stockLocation == "null"
			|| stockLocation == undefined
			|| stockLocation == "창고 미지정") {

			stockLocation = "";
		}

		if (itemCode == null
			|| itemCode == "null"
			|| itemCode == undefined) {

			itemCode = "";
		}

		if (itemUnit == null
			|| itemUnit == "null"
			|| itemUnit == undefined) {

			itemUnit = "";
		}

		if (inventoryStock == null
			|| inventoryStock == "null"
			|| inventoryStock == undefined
			|| inventoryStock == "") {

			inventoryStock = "";
		}

		var itemTypeText = "";

		if (itemType == "FG") {

			itemTypeText = "완제품";

		} else if (itemType == "RM") {

			itemTypeText = "원자재";

		} else if (itemType == "SM") {

			// =====================================================
			// 우리 프로젝트 기준
			// SM은 화면에서 부자재가 아니라 완제품으로 표시한다.
			// =====================================================
			itemTypeText = "완제품";

		} else if (itemType != null
			&& itemType != "null"
			&& itemType != undefined) {

			itemTypeText = itemType;
		}

		document.getElementById(
			"insertStockLocation").value =
				stockLocation;

		var itemIdView =
			document.getElementById("insertInventoryItemIdView");

		if (itemIdView != null) {

			itemIdView.value =
				this.value;
		}

		var itemCodeView =
			document.getElementById("insertInventoryItemCodeView");

		if (itemCodeView != null) {

			itemCodeView.value =
				itemCode;
		}

		var itemTypeView =
			document.getElementById("insertInventoryItemTypeView");

		if (itemTypeView != null) {

			itemTypeView.value =
				itemTypeText;
		}

		var itemUnitView =
			document.getElementById("insertInventoryItemUnitView");

		if (itemUnitView != null) {

			itemUnitView.value =
				itemUnit;
		}

		var inventoryStockInput =
			document.getElementById("insertInventoryStock");

		if (inventoryStockInput != null) {

			inventoryStockInput.value =
				inventoryStock;
		}
	});

	// =========================================================
	// 재고 등록 버튼 직접 제출
	// 공통 모달 스크립트는 건드리지 않고, 현재 JSP에서만 등록 버튼 submit을 보장한다.
	// 기존 checkInventoryInsert() 검증을 통과한 경우에만 실제 form submit을 실행한다.
	// =========================================================
	function submitInventoryInsertForm() {

		var form =
			document.getElementById("inventoryInsertForm");

		if (form == null) {
			alert("재고 등록 폼을 찾을 수 없습니다.");
			return;
		}

		if (checkInventoryInsert()) {
			form.submit();
		}
	}

</script>
<script>
// =============================================================
// 재고조회 검색 날짜 제어
// 공통 파일은 건드리지 않고 현재 JSP 안에서만 처리한다.
// 시작일은 Controller에서 오늘 날짜로 기본 세팅되고,
// 종료일은 시작일보다 이전 날짜를 선택하지 못하게 min 값을 맞춘다.
// =============================================================
(function() {

	var startDate = document.getElementById("inventoryStartDate");
	var endDate = document.getElementById("inventoryEndDate");

	if (startDate == null || endDate == null) {
		return;
	}

	function syncEndDateMin() {

		if (startDate.value != "") {
			endDate.min = startDate.value;

			if (endDate.value != "" && endDate.value < startDate.value) {
				endDate.value = startDate.value;
			}
		}
	}

	syncEndDateMin();
	startDate.addEventListener("change", syncEndDateMin);

})();
</script>


<script>
/* =============================================================
	재고 등록 submit 복구
	공통 JS / 공통 JSP는 건드리지 않고 현재 JSP 안에서만 처리한다.

	등록 모달은 정상으로 뜨는데 저장이 안 되는 경우는
	공통 모달 스크립트가 .modal_btn_submit 클릭을 잡아먹거나,
	type="submit" 이벤트가 꼬이는 경우가 있다.

	그래서 등록 버튼 클릭 시
	1) 기존 checkInventoryInsert() 검증을 먼저 실행하고
	2) 통과하면 현재 form을 직접 submit 한다.
============================================================= */
function submitInventoryInsertDirect() {

	var form =
		document.getElementById("inventoryInsertForm");

	if (form == null) {
		alert("재고 등록 form을 찾을 수 없습니다.");
		return;
	}

	if (typeof checkInventoryInsert == "function") {

		if (!checkInventoryInsert()) {
			return;
		}
	}

	// =========================================================
	// HTMLFormElement 기본 submit을 직접 호출한다.
	// 공통 JS에서 버튼 click 이벤트를 막아도 Controller로 전송되게 한다.
	// =========================================================
	HTMLFormElement.prototype.submit.call(form);
}
</script>
