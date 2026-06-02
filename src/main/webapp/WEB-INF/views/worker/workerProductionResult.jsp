<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명: productionresult.jsp
	메뉴: 생산관리 > 생산실적 등록

	기준:
	- URL: /production/productionresult
	- Controller return: production/productionresult.tiles
	- 작업지시 QR 스캔 시 GET 방식으로 진입
	  예: /production/productionresult?orderId=1015&productLot=FGLOT-20260608-0001&openModal=Y
	- QR 진입 시 등록 모달 자동 오픈
	- QR 대상 작업지시 자동 선택
	- LOT / 작업지시번호 / 품목 / 지시수량 / 담당자 자동 입력
	- 작업자는 수량 확인 후 등록 버튼 클릭
	- LOSS_QTY는 불량수량이 아니라 LOSS량 / 손실수량
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%-- =========================================================
	작업자 전용 생산실적 등록 화면
	팀원 원본 productionresult.jsp는 수정하지 않고,
	작업자 URL(/worker/productionresult)에서만 사용하는 별도 JSP이다.
	작업자는 조회만 가능하므로 등록 / 선택 삭제 버튼을 제거했다.
	관리자로 /production/productionresult에 들어가면 팀원 원본 화면을 그대로 타므로 버튼이 모두 보인다.
========================================================= --%>

<div class="coPageWrap workerReadonlyPage">

	<c:if test="${not empty msg}">
		<script>
			alert("${msg}");
		</script>
	</c:if>


	<%-- =========================================================
	     1. 검색 영역
	     ========================================================= --%>
	<form class="search-form" method="get"
		action="${contextPath}/production/productionresult">

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
					<label class="search-label">상태</label>
					<select name="prodStatus" class="search-select">
						<option value="">전체</option>

						<c:forEach var="status" items="${productionResultStatusList}">
							<option value="${status}"
								<c:if test="${prodStatus eq status}">selected</c:if>>
								${status}
							</option>
						</c:forEach>
					</select>
				</div>

				<div class="search-item">
					<label class="search-label">검색어</label>
					<input type="text" name="keyword" class="search-input"
						placeholder="실적번호 / LOT / 품목코드 / 품명" value="${keyword}">
				</div>

				<div class="search-btn-wrap">

					<button type="submit" class="search-btn search-btn-main">
						<svg viewBox="0 0 24 24" fill="none">
							<circle cx="10.5" cy="10.5" r="7.5" stroke="currentColor"
								stroke-width="2">
							</circle>
							<path d="M16 16L21 21" stroke="currentColor" stroke-width="2"
								stroke-linecap="round">
							</path>
						</svg>
						검색
					</button>

					<button type="button"
						class="search-btn search-btn-sub search-reset-btn"
						onclick="location.href='${contextPath}/production/productionresult'">
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
	     2. 목록 상단 버튼
	     ========================================================= --%>
	<form method="post" id="deleteForm"
		action="${contextPath}/production/productionresult/delete">

		<div class="coTableTop">

			<p class="coTotalCount">총 ${pageInfo.totalCount}건</p>

			<div class="search-btn-right">
</div>

		</div>


		<%-- =========================================================
		     3. 목록
		     ========================================================= --%>
		<div class="coTableWrap">

			<table class="coTable">

				<thead>
					<tr>
						<th class="mobile_show">
							<label id="productionResultCheckAllLabel">선택</label>
							<input type="checkbox" id="productionResultCheckAll"
								style="display: none;">
						</th>

						<th class="mobile_hidden">실적번호</th>
						<th class="mobile_show">LOT번호</th>
						<th class="mobile_hidden">품목명</th>
						<th class="mobile_show">생산수량</th>
						<th class="mobile_hidden">LOSS량</th>
						<th class="mobile_hidden">생산일</th>
						<th class="mobile_show">상태</th>
						<th class="mobile_show">상세</th>
					</tr>
				</thead>

				<tbody>

					<c:forEach var="result" items="${list}">

						<tr>
							<td class="mobile_show">
								<input type="checkbox" name="prodIds"
									value="${result.prodId}">
							</td>

							<td class="mobile_hidden" title="${result.docNo}">
								${result.docNo}
							</td>

							<td class="mobile_show" title="${result.productLot}">
								${result.productLot}
							</td>

							<td class="coTextLeft mobile_hidden"
								title="${result.itemName}">
								${result.itemName}
							</td>

							<td class="mobile_show">
								<fmt:formatNumber value="${result.prodQty}" pattern="#,##0" />
								${result.itemUnit}
							</td>

							<td class="mobile_hidden">
								<fmt:formatNumber value="${result.lossQty}" pattern="#,##0" />
								${result.itemUnit}
							</td>

							<td class="mobile_hidden">${result.prodDate}</td>

							<td class="mobile_show">
								<c:choose>
									<c:when test="${result.prodStatus eq '완료'}">
										<span class="coStatus coStatusUse">
											${result.prodStatus}
										</span>
									</c:when>

									<c:when test="${result.prodStatus eq '보류' or result.prodStatus eq '취소'}">
										<span class="coStatus coStatusStop">
											${result.prodStatus}
										</span>
									</c:when>

									<c:otherwise>
										<span class="coStatus">
											${result.prodStatus}
										</span>
									</c:otherwise>
								</c:choose>
							</td>

							<td class="mobile_show">
								<button type="button" class="coDetailBtn"
									onclick="location.href='${contextPath}/production/productionresult/detail?prodId=${result.prodId}'">
									보기
								</button>
							</td>
						</tr>

					</c:forEach>

					<c:if test="${empty list}">
						<tr>
							<td colspan="9">조회된 생산실적이 없습니다.</td>
						</tr>
					</c:if>

				</tbody>

			</table>

		</div>

	</form>


	<%-- =========================================================
	     4. 생산실적 등록 모달
	     ========================================================= --%>
	<div id="modal_insert" class="modal_wrap" aria-hidden="true">

		<div class="modal_box" role="dialog" aria-modal="true">

			<div class="modal_header">
				<h3 class="modal_title">생산실적 등록</h3>
			</div>

			<form class="modal_form" method="post"
				action="${contextPath}/production/productionresult/insert"
				onsubmit="return checkProductionResultInsert();">

				<div class="modal_body modal_body_2col">

					<c:if test="${openModal eq 'Y'}">
						<div class="modal_item modal_item_full">
							<div class="qr_entry_notice">
								QR 스캔으로 진입했습니다. 작업지시 정보와 담당자가 자동 입력됩니다.
							</div>
						</div>
					</c:if>

					<div class="modal_item modal_item_full">
						<label class="modal_label">
							작업지시 선택 <span class="modal_required">*</span>
						</label>

						<select name="orderId" id="insertOrderId"
							class="modal_select"
							onchange="setProductionResultOrderInfo();" required>

							<option value="">선택</option>

							<c:if test="${not empty qrOrder}">
								<option value="${qrOrder.orderId}"
									data-prod-plan-doc-no="${qrOrder.prodPlanDocNo}"
									data-work-order-doc-no="${qrOrder.workOrderDocNo}"
									data-product-lot="${qrOrder.productLot}"
									data-order-qty="${qrOrder.orderQty}"
									data-emp-id="${qrOrder.empId}"
									data-item-code="${qrOrder.itemCode}"
									data-item-name="${qrOrder.itemName}"
									data-item-unit="${qrOrder.itemUnit}"
									data-order-date="${qrOrder.orderDate}"
									data-prod-plan-qty="${qrOrder.prodPlanQty}"
									selected>
									[QR] ${qrOrder.workOrderDocNo} / ${qrOrder.productLot} /
									${qrOrder.itemCode} / ${qrOrder.itemName}
								</option>
							</c:if>

							<c:forEach var="order" items="${productionResultOrderList}">

								<option value="${order.orderId}"
									data-prod-plan-doc-no="${order.prodPlanDocNo}"
									data-work-order-doc-no="${order.workOrderDocNo}"
									data-product-lot="${order.productLot}"
									data-order-qty="${order.orderQty}"
									data-emp-id="${order.empId}"
									data-item-code="${order.itemCode}"
									data-item-name="${order.itemName}"
									data-item-unit="${order.itemUnit}"
									data-order-date="${order.orderDate}"
									data-prod-plan-qty="${order.prodPlanQty}">
									${order.workOrderDocNo} / ${order.productLot} /
									${order.itemCode} / ${order.itemName} /
									지시수량
									<fmt:formatNumber value="${order.orderQty}" pattern="#,##0" />${order.itemUnit}
								</option>

							</c:forEach>

						</select>

						<div class="modal_help_text">
							QR로 진입한 경우 해당 작업지시가 자동 선택되고, LOT·수량·담당자가 자동 입력됩니다.
						</div>
					</div>


					<div class="modal_item">
						<label class="modal_label">생산계획번호</label>
						<input type="text" id="insertProdPlanDocNo"
							class="modal_input" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">작업지시번호</label>
						<input type="text" id="insertWorkOrderDocNo"
							class="modal_input" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">완제품 LOT</label>
						<input type="text" id="insertProductLot"
							class="modal_input" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">품목코드</label>
						<input type="text" id="insertItemCode"
							class="modal_input" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">품목명</label>
						<input type="text" id="insertItemName"
							class="modal_input" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">작업지시수량</label>
						<input type="text" id="insertOrderQtyText"
							class="modal_input" readonly>
						<input type="hidden" name="orderQty" id="insertOrderQty">
					</div>

					<div class="modal_item">
						<label class="modal_label">
							생산수량 <span class="modal_required">*</span>
						</label>
						<input type="number" name="prodQty" id="insertProdQty"
							class="modal_input" min="1" required>
					</div>

					<div class="modal_item">
						<label class="modal_label">LOSS량</label>
						<input type="number" name="lossQty" id="insertLossQty"
							class="modal_input" min="0" value="0">
					</div>

					<div class="modal_item">
						<label class="modal_label">
							생산일 <span class="modal_required">*</span>
						</label>
						<input type="date" name="prodDate" id="insertProdDate"
							class="modal_input modal_today" required>
					</div>

					<div class="modal_item">
						<label class="modal_label">
							담당자 <span class="modal_required">*</span>
						</label>
						<select name="empId" id="insertEmpId"
							class="modal_select" required>

							<option value="">선택</option>

							<c:forEach var="emp" items="${empList}">
								<option value="${emp.empId}">
									${emp.ename} / ${emp.dept}
								</option>
							</c:forEach>

						</select>
					</div>

					<div class="modal_item">
						<label class="modal_label">
							상태 <span class="modal_required">*</span>
						</label>
						<select name="prodStatus" id="insertProdStatus"
							class="modal_select" required>
							<option value="완료">완료</option>
							<option value="진행중">진행중</option>
							<option value="보류">보류</option>
						</select>
					</div>

					<div class="modal_item modal_item_full">
						<label class="modal_label">비고</label>
						<textarea name="remark" class="modal_textarea"
							placeholder="생산실적 관련 메모를 입력하세요."></textarea>
					</div>

					<div class="modal_item modal_item_full">
						<div class="modal_help_text production_result_help">
							생산수량은 작업지시수량을 기본값으로 자동 입력합니다.
							LOSS량은 불량수량이 아니라 생산 중 손실수량입니다.
						</div>
					</div>

				</div>

				<div class="modal_footer">

					<button type="button"
						class="modal_btn modal_btn_cancel modal_close_btn"
						onclick="closeProductionResultInsertModal();">
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

.production_result_help {
	padding: 10px 12px;
	border-radius: 8px;
	background: #f7f9fb;
	border: 1px solid #e5e8eb;
	color: #444;
}

.qr_entry_notice {
	padding: 10px 12px;
	border-radius: 8px;
	background: #e8f3ee;
	border: 1px solid #c7dfd5;
	color: #174c3c;
	font-size: 13px;
	font-weight: 700;
	line-height: 1.5;
}

/* QR 진입 시 공통 모달 방식과 무관하게 모달 표시 보정 */
#modal_insert.force_open {
	display: flex !important;
	align-items: center;
	justify-content: center;
	opacity: 1 !important;
	visibility: visible !important;
	pointer-events: auto !important;
	z-index: 9999 !important;
}

#modal_insert.force_open .modal_box {
	display: block;
	opacity: 1;
	visibility: visible;
}
</style>


<script>
	// 선택 글씨 클릭 시 전체 선택 / 전체 해제
	var productionResultCheckAllLabel = document
			.getElementById("productionResultCheckAllLabel");

	if (productionResultCheckAllLabel != null) {

		productionResultCheckAllLabel.onclick = function() {

			var checkAll = document.getElementById("productionResultCheckAll");

			var checks = document.getElementsByName("prodIds");

			checkAll.checked = !checkAll.checked;

			for (var i = 0; i < checks.length; i++) {
				checks[i].checked = checkAll.checked;
			}
		};
	}

	// 개별 체크박스 상태에 따라 전체 선택 상태를 맞춘다.
	var checks = document.getElementsByName("prodIds");

	for (var i = 0; i < checks.length; i++) {

		checks[i].onclick = function() {

			var allChecked = true;

			for (var j = 0; j < checks.length; j++) {

				if (!checks[j].checked) {
					allChecked = false;
					break;
				}
			}

			document.getElementById("productionResultCheckAll").checked = allChecked;
		};
	}

	// 선택 삭제 방어코딩이다.
	function deleteCheck() {

		var checks = document.getElementsByName("prodIds");

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

		alert("생산실적은 검사/불량/재고 이력과 연결되므로 삭제 기능은 다음 단계에서 별도 검토합니다.");
	}

	// 작업지시 선택 시 생산실적 등록 정보 자동입력
	function setProductionResultOrderInfo() {

		var orderSelect = document.getElementById("insertOrderId");

		if (orderSelect == null) {
			return;
		}

		var selectedOption = orderSelect.options[orderSelect.selectedIndex];

		if (selectedOption == null || selectedOption.value === "") {
			clearProductionResultOrderInfo();
			return;
		}

		var prodPlanDocNo = selectedOption.getAttribute("data-prod-plan-doc-no");
		var workOrderDocNo = selectedOption.getAttribute("data-work-order-doc-no");
		var productLot = selectedOption.getAttribute("data-product-lot");
		var orderQty = selectedOption.getAttribute("data-order-qty");
		var empId = selectedOption.getAttribute("data-emp-id");
		var itemCode = selectedOption.getAttribute("data-item-code");
		var itemName = selectedOption.getAttribute("data-item-name");
		var itemUnit = selectedOption.getAttribute("data-item-unit");

		document.getElementById("insertProdPlanDocNo").value = prodPlanDocNo || "";
		document.getElementById("insertWorkOrderDocNo").value = workOrderDocNo || "";
		document.getElementById("insertProductLot").value = productLot || "";
		document.getElementById("insertItemCode").value = itemCode || "";
		document.getElementById("insertItemName").value = itemName || "";

		if (empId != null && empId !== "") {
			document.getElementById("insertEmpId").value = empId;
		} else {
			document.getElementById("insertEmpId").value = "";
		}

		document.getElementById("insertOrderQty").value = orderQty || "";

		if (orderQty != null && orderQty !== "") {
			document.getElementById("insertOrderQtyText").value =
				formatNumber(orderQty) + " " + (itemUnit || "");

			document.getElementById("insertProdQty").value = orderQty;
		} else {
			document.getElementById("insertOrderQtyText").value = "";
			document.getElementById("insertProdQty").value = "";
		}

		document.getElementById("insertLossQty").value = "0";
	}

	// 작업지시 자동입력 정보 초기화
	function clearProductionResultOrderInfo() {

		document.getElementById("insertProdPlanDocNo").value = "";
		document.getElementById("insertWorkOrderDocNo").value = "";
		document.getElementById("insertProductLot").value = "";
		document.getElementById("insertItemCode").value = "";
		document.getElementById("insertItemName").value = "";
		document.getElementById("insertOrderQtyText").value = "";
		document.getElementById("insertOrderQty").value = "";
		document.getElementById("insertProdQty").value = "";
		document.getElementById("insertLossQty").value = "0";
		document.getElementById("insertEmpId").value = "";
	}

	// 생산실적 등록 방어코딩
	function checkProductionResultInsert() {

		var orderId = document.getElementById("insertOrderId").value;
		var orderQty = document.getElementById("insertOrderQty").value;
		var prodQty = document.getElementById("insertProdQty").value;
		var lossQty = document.getElementById("insertLossQty").value;
		var prodDate = document.getElementById("insertProdDate").value;
		var empId = document.getElementById("insertEmpId").value;
		var prodStatus = document.getElementById("insertProdStatus").value;

		if (orderId === "") {
			alert("작업지시를 선택해주세요.");
			document.getElementById("insertOrderId").focus();
			return false;
		}

		if (prodQty === "" || Number(prodQty) <= 0) {
			alert("생산수량은 1 이상 입력해주세요.");
			document.getElementById("insertProdQty").focus();
			return false;
		}

		if (lossQty === "" || Number(lossQty) < 0) {
			alert("LOSS량은 0 이상 입력해주세요.");
			document.getElementById("insertLossQty").focus();
			return false;
		}

		if (orderQty !== "" && Number(prodQty) > Number(orderQty)) {
			if (!confirm("생산수량이 작업지시수량보다 큽니다.\n그래도 등록하시겠습니까?")) {
				document.getElementById("insertProdQty").focus();
				return false;
			}
		}

		if (Number(lossQty) > Number(prodQty)) {
			alert("LOSS량은 생산수량보다 클 수 없습니다.");
			document.getElementById("insertLossQty").focus();
			return false;
		}

		if (prodDate === "") {
			alert("생산일을 선택해주세요.");
			document.getElementById("insertProdDate").focus();
			return false;
		}

		if (empId === "") {
			alert("담당자를 선택해주세요.");
			document.getElementById("insertEmpId").focus();
			return false;
		}

		if (prodStatus === "") {
			alert("상태를 선택해주세요.");
			document.getElementById("insertProdStatus").focus();
			return false;
		}

		if (!confirm("생산실적을 등록하시겠습니까?")) {
			return false;
		}

		return true;
	}

	// 숫자 천단위 구분 표시
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

	// 오늘 날짜를 yyyy-MM-dd 형식으로 반환
	function getTodayText() {

		var today = new Date();

		var year = today.getFullYear();
		var month = String(today.getMonth() + 1).padStart(2, "0");
		var day = String(today.getDate()).padStart(2, "0");

		return year + "-" + month + "-" + day;
	}

	// 생산일 기본값 보정
	function setDefaultProdDate() {

		var prodDateInput = document.getElementById("insertProdDate");

		if (prodDateInput != null && prodDateInput.value === "") {
			prodDateInput.value = getTodayText();
		}
	}

	// QR 진입 시 넘어온 작업지시를 select에서 강제로 선택한다.
	function selectQrOrderOption() {

		var qrOrderId = "${qrOrderId}";

		if (qrOrderId == null || qrOrderId === "") {
			return;
		}

		var orderSelect = document.getElementById("insertOrderId");

		if (orderSelect == null) {
			return;
		}

		for (var i = 0; i < orderSelect.options.length; i++) {

			if (orderSelect.options[i].value === qrOrderId) {
				orderSelect.selectedIndex = i;
				return;
			}
		}
	}

	// 생산실적 등록 모달 강제 오픈
	function openProductionResultInsertModal() {

		var modal = document.getElementById("modal_insert");

		if (modal == null) {
			return;
		}

		modal.classList.add("active");
		modal.classList.add("on");
		modal.classList.add("show");
		modal.classList.add("open");
		modal.classList.add("force_open");

		modal.setAttribute("aria-hidden", "false");

		modal.style.display = "flex";
		modal.style.alignItems = "center";
		modal.style.justifyContent = "center";
		modal.style.opacity = "1";
		modal.style.visibility = "visible";
		modal.style.pointerEvents = "auto";
		modal.style.zIndex = "9999";

		document.body.classList.add("modal_open");
		document.body.classList.add("modal-open");
	}

	// 생산실적 등록 모달 닫기
	function closeProductionResultInsertModal() {

		var modal = document.getElementById("modal_insert");

		if (modal == null) {
			return;
		}

		modal.classList.remove("active");
		modal.classList.remove("on");
		modal.classList.remove("show");
		modal.classList.remove("open");
		modal.classList.remove("force_open");

		modal.setAttribute("aria-hidden", "true");

		modal.style.display = "";
		modal.style.alignItems = "";
		modal.style.justifyContent = "";
		modal.style.opacity = "";
		modal.style.visibility = "";
		modal.style.pointerEvents = "";
		modal.style.zIndex = "";

		document.body.classList.remove("modal_open");
		document.body.classList.remove("modal-open");
	}

	// 공통 닫기 버튼과 강제 오픈 모달의 충돌 방지
	function bindProductionResultModalClose() {

		var closeButtons = document.querySelectorAll("#modal_insert .modal_close_btn");

		for (var i = 0; i < closeButtons.length; i++) {
			closeButtons[i].onclick = function() {
				closeProductionResultInsertModal();
			};
		}
	}

	// QR 진입 시 등록 모달 자동 오픈 + 작업지시 정보 자동입력
	document.addEventListener("DOMContentLoaded", function() {

		setDefaultProdDate();
		bindProductionResultModalClose();

		var openModal = "${openModal}";

		if (openModal === "Y") {

			selectQrOrderOption();

			setProductionResultOrderInfo();

			openProductionResultInsertModal();
		}
	});
</script>