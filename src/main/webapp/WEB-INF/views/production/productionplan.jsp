<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명: productionplan.jsp
	메뉴: 생산관리 > 생산계획 관리

	기준:
	- URL: /production/productionplan
	- Controller return: production/productionplan.tiles
	- 생산관리 파일 구조 유지
	  DTO / DAO / Service / Controller / Mapper는 생산관리 1개 파일로 관리
	  JSP만 페이지별 관리
	- 생산계획번호는 Mapper에서 자동 생성
	- 생산계획은 작업지시의 상위 데이터이므로 화면에서 삭제 기능 제외
	- 검색 조건: 품목구분 itemType, 검색어 keyword, 시작일 startDate, 종료일 endDate
	- 등록 모달 품목 select는 품목코드 / 품명 / 단위 표시
	- 계획수량은 천단위 + 단위 표시
	- 등록 시 계획수량 1 이상, 납기일 >= 계획일자 검증

	목록 컬럼 기준:
	- PC: 체크박스 포함 8개
	  1 선택
	  2 생산계획번호
	  3 품목코드
	  4 품명
	  5 계획수량
	  6 계획일자
	  7 납기일
	  8 상세

	- 모바일: 체크박스 포함 5개
	  1 선택
	  2 생산계획번호
	  3 품명
	  4 계획수량
	  5 상세
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div class="coPageWrap">

	<%-- =========================================================
	     1. 메시지
	     ========================================================= --%>
	<c:if test="${not empty msg}">
		<script>
			alert("${msg}");
		</script>
	</c:if>


	<%-- =========================================================
	     2. 검색 영역
	     ========================================================= --%>
	<form class="search-form" method="get"
		action="${contextPath}/production/productionplan">

		<div class="search-box">

			<div class="search-row">

				<div class="search-item">
					<label class="search-label">시작일</label>

					<input type="date" name="startDate" class="search-date"
						value="${startDate}">
				</div>

				<div class="search-item">
					<label class="search-label">종료일</label>

					<input type="date" name="endDate" class="search-date"
						value="${endDate}">
				</div>

				<div class="search-item">
					<label class="search-label">품목구분</label>

					<select name="itemType" class="search-select">
						<option value="">전체</option>

						<c:forEach var="type" items="${itemTypeList}">
							<option value="${type}"
								<c:if test="${itemType eq type}">selected</c:if>>
								${type}
							</option>
						</c:forEach>
					</select>
				</div>

				<div class="search-item">
					<label class="search-label">검색어</label>

					<input type="text" name="keyword" class="search-input"
						placeholder="생산계획번호 / 품목코드 / 품명"
						value="${keyword}">
				</div>

				<div class="search-item">
					<label class="search-label">보기</label>

					<select name="size" class="search-select">
						<option value="5"
							<c:if test="${pageInfo.size == 5}">selected</c:if>>
							5개씩
						</option>
						<option value="10"
							<c:if test="${pageInfo.size == 10}">selected</c:if>>
							10개씩
						</option>
						<option value="20"
							<c:if test="${pageInfo.size == 20}">selected</c:if>>
							20개씩
						</option>
						<option value="30"
							<c:if test="${pageInfo.size == 30}">selected</c:if>>
							30개씩
						</option>
					</select>
				</div>

				<div class="search-btn-wrap">

					<button type="submit" class="search-btn search-btn-main">
						<svg viewBox="0 0 24 24" fill="none">
							<circle cx="10.5" cy="10.5" r="7.5"
								stroke="currentColor" stroke-width="2">
							</circle>
							<path d="M16 16L21 21" stroke="currentColor"
								stroke-width="2" stroke-linecap="round">
							</path>
						</svg>
						검색
					</button>

					<button type="button"
						class="search-btn search-btn-sub search-reset-btn"
						onclick="location.href='${contextPath}/production/productionplan'">
						<svg viewBox="0 0 24 24" fill="none">
							<path
								d="M20 12C20 16.4 16.4 20 12 20C7.6 20 4 16.4 4 12C4 7.6 7.6 4 12 4C14.4 4 16.5 5.1 18 6.8"
								stroke="currentColor" stroke-width="2" stroke-linecap="round">
							</path>
							<path d="M18 4V7H21" stroke="currentColor" stroke-width="2"
								stroke-linecap="round" stroke-linejoin="round">
							</path>
						</svg>
						초기화
					</button>

				</div>

			</div>

		</div>

	</form>


	<%-- =========================================================
	     3. 상단 버튼
	     ========================================================= --%>
	<div class="coTableTop">

		<p class="coTotalCount">총 ${pageInfo.totalCount}건</p>

		<div class="search-btn-right">

			<button type="button"
				class="search-btn search-btn-main modal_open_btn"
				data_modal_target="#modal_insert">
				<svg viewBox="0 0 24 24" fill="none">
					<path d="M12 5V19" stroke="currentColor" stroke-width="2"
						stroke-linecap="round">
					</path>
					<path d="M5 12H19" stroke="currentColor" stroke-width="2"
						stroke-linecap="round">
					</path>
				</svg>
				등록
			</button>

		</div>

	</div>


	<%-- =========================================================
	     4. 생산계획 목록
	     ========================================================= --%>
	<div class="coTableWrap">

		<table class="coTable production-plan-table">

			<thead>
				<tr>
					<th class="mobile_show">
						<label id="productionPlanCheckAllLabel">선택</label>
						<input type="checkbox" id="productionPlanCheckAll"
							style="display: none;">
					</th>

					<th class="mobile_show">생산계획번호</th>
					<th class="mobile_hidden">품목코드</th>
					<th class="mobile_show">품명</th>
					<th class="mobile_show">계획수량</th>
					<th class="mobile_hidden">계획일자</th>
					<th class="mobile_hidden">납기일</th>
					<th class="mobile_show">상세</th>
				</tr>
			</thead>

			<tbody>

				<c:choose>

					<c:when test="${not empty list}">

						<c:forEach var="plan" items="${list}">

							<tr>
								<td class="mobile_show">
									<input type="checkbox" name="prodPlanIds"
										value="${plan.prodPlanId}">
								</td>

								<td class="mobile_show" title="${plan.docNo}">
									<c:choose>
										<c:when test="${not empty plan.docNo}">
											${plan.docNo}
										</c:when>
										<c:otherwise>
											PP-${plan.prodPlanId}
										</c:otherwise>
									</c:choose>
								</td>

								<td class="mobile_hidden" title="${plan.itemCode}">
									${plan.itemCode}
								</td>

								<td class="coTextLeft mobile_show" title="${plan.itemName}">
									${plan.itemName}
								</td>

								<td class="mobile_show">
									<fmt:formatNumber value="${plan.prodPlanQty}"
										pattern="#,##0" />
									${plan.itemUnit}
								</td>

								<td class="mobile_hidden">
									${plan.prodPlanDate}
								</td>

								<td class="mobile_hidden">
									${plan.dueDate}
								</td>

								<td class="mobile_show">
									<button type="button" class="coDetailBtn"
										onclick="location.href='${contextPath}/production/productionplan/detail?prodPlanId=${plan.prodPlanId}'">
										보기
									</button>
								</td>
							</tr>

						</c:forEach>

					</c:when>

					<c:otherwise>
						<tr>
							<td colspan="8">조회된 생산계획이 없습니다.</td>
						</tr>
					</c:otherwise>

				</c:choose>

			</tbody>

		</table>

	</div>


	<%-- =========================================================
	     5. 생산계획 등록 모달
	     ========================================================= --%>
	<div id="modal_insert" class="modal_wrap" aria-hidden="true">

		<div class="modal_box" role="dialog" aria-modal="true">

			<div class="modal_header">
				<h3 class="modal_title">생산계획 등록</h3>
			</div>

			<form class="modal_form" method="post"
				action="${contextPath}/production/productionplan/insert"
				onsubmit="return checkProductionPlanInsert();">

				<div class="modal_body modal_body_2col">

					<div class="modal_item modal_item_full">
						<label class="modal_label">
							품목 선택 <span class="modal_required">*</span>
						</label>

						<select name="itemId" id="insertItemId"
							class="modal_select"
							onchange="setProductionPlanItemInfo();"
							required>

							<option value="">선택</option>

							<c:forEach var="item" items="${itemList}">
								<option value="${item.itemId}"
									data-item-code="${item.itemCode}"
									data-item-name="${item.itemName}"
									data-item-type="${item.itemType}"
									data-item-unit="${item.itemUnit}">
									${item.itemCode} / ${item.itemName} / ${item.itemUnit}
								</option>
							</c:forEach>

						</select>

						<div class="modal_help_text">
							완제품 품목만 선택합니다. 생산계획번호는 계획일자 기준으로 자동 생성됩니다.
							예: PP-20260527-0001
						</div>
					</div>


					<div class="modal_item">
						<label class="modal_label">품목코드</label>

						<input type="text" id="insertItemCode"
							class="modal_input"
							placeholder="품목 선택 시 자동 표시" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">품목구분</label>

						<input type="text" id="insertItemType"
							class="modal_input"
							placeholder="품목 선택 시 자동 표시" readonly>
					</div>

					<div class="modal_item modal_item_full">
						<label class="modal_label">품목명</label>

						<input type="text" id="insertItemName"
							class="modal_input"
							placeholder="품목 선택 시 자동 표시" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">
							계획수량 <span class="modal_required">*</span>
						</label>

						<div class="production-plan-qty-box">
							<input type="number" name="prodPlanQty" id="insertProdPlanQty"
								class="modal_input" min="1" required
								oninput="setPlanQtyPreview();" />

							<input type="text" id="insertItemUnit"
								class="modal_input production-plan-unit-input"
								placeholder="단위" readonly>
						</div>

						<div id="insertQtyPreview" class="modal_help_text">
							계획수량을 입력하세요.
						</div>
					</div>

					<div class="modal_item">
						<label class="modal_label">
							계획일자 <span class="modal_required">*</span>
						</label>

						<input type="date" name="prodPlanDate" id="insertProdPlanDate"
							class="modal_input modal_today"
							onchange="checkPlanDateRange();"
							required>
					</div>

					<div class="modal_item">
						<label class="modal_label">
							납기일 <span class="modal_required">*</span>
						</label>

						<input type="date" name="dueDate" id="insertDueDate"
							class="modal_input"
							onchange="checkPlanDateRange();"
							required>

						<div id="dateCheckText" class="modal_help_text">
							납기일은 계획일자와 같거나 이후여야 합니다.
						</div>
					</div>

					<div class="modal_item modal_item_full">
						<label class="modal_label">비고</label>

						<textarea name="remark" class="modal_textarea"
							maxlength="500"
							placeholder="생산계획 관련 메모를 입력하세요."></textarea>
					</div>

				</div>

				<div class="modal_footer">

					<button type="button"
						class="modal_btn modal_btn_cancel modal_close_btn">
						취소
					</button>

					<button type="submit" class="modal_btn modal_btn_submit">
						등록
					</button>

				</div>

			</form>

		</div>

	</div>


	<jsp:include page="/WEB-INF/views/common/paging.jsp" />

</div>


<style>
.modal_help_text {
	margin-top: 6px;
	font-size: 13px;
	color: #666;
	line-height: 1.5;
}

.production-plan-qty-box {
	display: flex;
	align-items: center;
	gap: 8px;
	width: 100%;
	box-sizing: border-box;
}

.production-plan-qty-box .modal_input:first-child {
	flex: 1 1 auto;
	min-width: 0;
}

.production-plan-unit-input {
	flex: 0 0 80px;
	text-align: center;
}
</style>


<script>
	/*
	 * 선택 컬럼명 클릭 시 전체 선택 / 전체 해제
	 */
	var productionPlanCheckAllLabel = document
			.getElementById("productionPlanCheckAllLabel");

	if (productionPlanCheckAllLabel != null) {

		productionPlanCheckAllLabel.onclick = function() {

			var checkAll = document.getElementById("productionPlanCheckAll");
			var checks = document.getElementsByName("prodPlanIds");

			if (checkAll == null || checks == null) {
				return;
			}

			checkAll.checked = !checkAll.checked;

			for (var i = 0; i < checks.length; i++) {
				checks[i].checked = checkAll.checked;
			}
		};
	}


	/*
	 * 개별 체크박스 상태에 따라 전체 선택 상태를 맞춘다.
	 */
	var prodPlanChecks = document.getElementsByName("prodPlanIds");

	for (var i = 0; i < prodPlanChecks.length; i++) {

		prodPlanChecks[i].onclick = function() {

			var allChecked = true;

			for (var j = 0; j < prodPlanChecks.length; j++) {

				if (!prodPlanChecks[j].checked) {
					allChecked = false;
					break;
				}
			}

			var checkAll = document.getElementById("productionPlanCheckAll");

			if (checkAll != null) {
				checkAll.checked = allChecked;
			}
		};
	}


	/*
	 * 품목 선택 시 품목 정보 자동 표시
	 */
	function setProductionPlanItemInfo() {

		var itemSelect = document.getElementById("insertItemId");
		var selectedOption = itemSelect.options[itemSelect.selectedIndex];

		if (selectedOption == null || selectedOption.value === "") {
			document.getElementById("insertItemCode").value = "";
			document.getElementById("insertItemName").value = "";
			document.getElementById("insertItemType").value = "";
			document.getElementById("insertItemUnit").value = "";
			setPlanQtyPreview();
			return;
		}

		var itemCode = selectedOption.getAttribute("data-item-code");
		var itemName = selectedOption.getAttribute("data-item-name");
		var itemType = selectedOption.getAttribute("data-item-type");
		var itemUnit = selectedOption.getAttribute("data-item-unit");

		document.getElementById("insertItemCode").value = itemCode || "";
		document.getElementById("insertItemName").value = itemName || "";
		document.getElementById("insertItemType").value = itemType || "";
		document.getElementById("insertItemUnit").value = itemUnit || "";

		setPlanQtyPreview();
	}


	/*
	 * 계획수량 천단위 미리보기
	 */
	function setPlanQtyPreview() {

		var qty = document.getElementById("insertProdPlanQty").value;
		var unit = document.getElementById("insertItemUnit").value;

		if (qty == null || qty === "") {
			document.getElementById("insertQtyPreview").innerHTML =
				"계획수량을 입력하세요.";
			return;
		}

		if (Number(qty) <= 0) {
			document.getElementById("insertQtyPreview").innerHTML =
				"계획수량은 1 이상 입력해야 합니다.";
			return;
		}

		document.getElementById("insertQtyPreview").innerHTML =
			"입력수량: " + formatNumber(qty) + " " + (unit || "");
	}


	/*
	 * 계획일자 / 납기일 검증
	 */
	function checkPlanDateRange() {

		var prodPlanDate = document.getElementById("insertProdPlanDate").value;
		var dueDate = document.getElementById("insertDueDate").value;

		if (prodPlanDate === "" || dueDate === "") {
			document.getElementById("dateCheckText").innerHTML =
				"납기일은 계획일자와 같거나 이후여야 합니다.";
			return true;
		}

		if (dueDate < prodPlanDate) {
			document.getElementById("dateCheckText").innerHTML =
				"납기일은 계획일자보다 빠를 수 없습니다.";
			return false;
		}

		document.getElementById("dateCheckText").innerHTML =
			"계획일자와 납기일이 정상입니다.";
		return true;
	}


	/*
	 * 생산계획 등록 검증
	 */
	function checkProductionPlanInsert() {

		var itemId = document.getElementById("insertItemId").value;
		var prodPlanQty = document.getElementById("insertProdPlanQty").value;
		var prodPlanDate = document.getElementById("insertProdPlanDate").value;
		var dueDate = document.getElementById("insertDueDate").value;

		if (itemId === "") {
			alert("품목을 선택해주세요.");
			document.getElementById("insertItemId").focus();
			return false;
		}

		if (prodPlanQty === "" || Number(prodPlanQty) <= 0) {
			alert("계획수량은 1 이상 입력해주세요.");
			document.getElementById("insertProdPlanQty").focus();
			return false;
		}

		if (prodPlanDate === "") {
			alert("계획일자를 선택해주세요.");
			document.getElementById("insertProdPlanDate").focus();
			return false;
		}

		if (dueDate === "") {
			alert("납기일을 선택해주세요.");
			document.getElementById("insertDueDate").focus();
			return false;
		}

		if (dueDate < prodPlanDate) {
			alert("납기일은 계획일자보다 빠를 수 없습니다.");
			document.getElementById("insertDueDate").focus();
			return false;
		}

		if (!confirm("생산계획을 등록하시겠습니까?")) {
			return false;
		}

		return true;
	}


	/*
	 * 숫자 천단위 구분 표시
	 */
	function formatNumber(value) {

		if (value == null || value === "") {
			return "";
		}

		var numberValue = Number(value);

		if (isNaN(numberValue)) {
			return value;
		}

		return numberValue.toLocaleString();
	}
</script>