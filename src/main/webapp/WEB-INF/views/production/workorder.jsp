<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명: workorder.jsp
	메뉴: 생산관리 > 작업지시 관리

	기준:
	- URL: /production/workorder
	- Controller return: production/workorder.tiles
	- 생산관리 파일 구조 유지
	  DTO / DAO / Service / Controller / Mapper는 생산관리 1개 파일로 관리
	  JSP만 페이지별 관리
	- 작업지시 등록 시 작업지시번호, 완제품 LOT는 Mapper에서 자동 생성
	- 작업지시 등록 시 Service에서 BOM 기준 원자재 투입 이력 자동 생성
	- 사용자는 BOM을 직접 선택하지 않음
	  생산계획 → 완제품 item_id → 사용중 BOM → BOM_DETAIL 순서로 자동 적용
	- PC 목록 8컬럼 / 모바일 5컬럼 기준
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
		action="${contextPath}/production/workorder">

		<div class="search-box">

			<div class="search-row">

				<div class="search-item">
					<label class="search-label">시작일</label> <input type="date"
						name="startDate" class="search-date" value="${startDate}">
				</div>

				<div class="search-item">
					<label class="search-label">종료일</label> <input type="date"
						name="endDate" class="search-date" value="${endDate}">
				</div>

				<div class="search-item">
					<label class="search-label">상태</label> <select name="prodStatus"
						class="search-select">
						<option value="">전체</option>

						<c:forEach var="status" items="${workOrderStatusList}">
							<option value="${status}"
								<c:if test="${prodStatus eq status}">selected</c:if>>
								${status}</option>
						</c:forEach>
					</select>
				</div>

				<div class="search-item">
					<label class="search-label">검색어</label> <input type="text"
						name="keyword" class="search-input"
						placeholder="작업지시번호 / LOT / 품목코드 / 품명" value="${keyword}">
				</div>

				<div class="search-item">
					<label class="search-label">보기</label> <select name="size"
						class="search-select">
						<option value="5"
							<c:if test="${pageInfo.size == 5}">selected</c:if>>5개씩</option>
						<option value="10"
							<c:if test="${pageInfo.size == 10}">selected</c:if>>
							10개씩</option>
						<option value="20"
							<c:if test="${pageInfo.size == 20}">selected</c:if>>
							20개씩</option>
						<option value="30"
							<c:if test="${pageInfo.size == 30}">selected</c:if>>
							30개씩</option>
					</select>
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
						onclick="location.href='${contextPath}/production/workorder'">
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
	     3. 상단 버튼 / 목록
	     ========================================================= --%>
	<form method="post" id="deleteForm"
		action="${contextPath}/production/workorder/delete">

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

				<button type="button" class="search-btn search-btn-sub"
					onclick="deleteCheck()">
					<svg viewBox="0 0 24 24" fill="none">
						<path d="M4 7H20" stroke="currentColor" stroke-width="2"
							stroke-linecap="round">
						</path>
						<path d="M10 11V17" stroke="currentColor" stroke-width="2"
							stroke-linecap="round">
						</path>
						<path d="M14 11V17" stroke="currentColor" stroke-width="2"
							stroke-linecap="round">
						</path>
						<path d="M6 7L7 21H17L18 7" stroke="currentColor" stroke-width="2"
							stroke-linejoin="round">
						</path>
						<path d="M9 7V4H15V7" stroke="currentColor" stroke-width="2"
							stroke-linejoin="round">
						</path>
					</svg>
					선택 삭제
				</button>

			</div>

		</div>


		<div class="coTableWrap">

			<table class="coTable">

				<thead>
					<tr>
						<th class="mobile_show"><label id="workOrderCheckAllLabel">선택</label>
							<input type="checkbox" id="workOrderCheckAll"
							style="display: none;"></th>

						<th class="mobile_hidden">작업지시번호</th>
						<th class="mobile_show">LOT번호</th>
						<th class="mobile_hidden">품목명</th>
						<th class="mobile_show">지시수량</th>
						<th class="mobile_hidden">작업지시일</th>
						<th class="mobile_show">작업상태</th>
						<th class="mobile_show">상세</th>
					</tr>
				</thead>

				<tbody>

					<c:forEach var="workOrder" items="${list}">

						<tr>
							<td class="mobile_show"><input type="checkbox"
								name="orderIds" value="${workOrder.orderId}"></td>

							<td class="mobile_hidden" title="${workOrder.docNo}">
								${workOrder.docNo}</td>

							<td class="mobile_show" title="${workOrder.productLot}">
								${workOrder.productLot}</td>

							<td class="coTextLeft mobile_hidden"
								title="${workOrder.itemName}">${workOrder.itemName}</td>

							<td class="mobile_show"><fmt:formatNumber
									value="${workOrder.orderQty}" pattern="#,##0" />
								${workOrder.itemUnit}</td>

							<td class="mobile_hidden">${workOrder.orderDate}</td>

							<td class="mobile_show"><c:choose>
									<c:when test="${workOrder.prodStatus eq '완료'}">
										<span class="coStatus coStatusUse">
											${workOrder.prodStatus} </span>
									</c:when>

									<c:when
										test="${workOrder.prodStatus eq '취소' or workOrder.prodStatus eq '보류'}">
										<span class="coStatus coStatusStop">
											${workOrder.prodStatus} </span>
									</c:when>

									<c:otherwise>
										<span class="coStatus"> ${workOrder.prodStatus} </span>
									</c:otherwise>
								</c:choose></td>

							<td class="mobile_show">
								<button type="button" class="coDetailBtn"
									onclick="location.href='${contextPath}/production/workorder/detail?orderId=${workOrder.orderId}'">
									보기</button>
							</td>
						</tr>

					</c:forEach>

					<c:if test="${empty list}">
						<tr>
							<td colspan="8">조회된 작업지시가 없습니다.</td>
						</tr>
					</c:if>

				</tbody>

			</table>

		</div>

	</form>


	<%-- =========================================================
	     4. 작업지시 등록 모달
	     ========================================================= --%>
	<div id="modal_insert" class="modal_wrap" aria-hidden="true">

		<div class="modal_box" role="dialog" aria-modal="true">

			<div class="modal_header">
				<h3 class="modal_title">작업지시 등록</h3>
			</div>

			<form class="modal_form" method="post"
				action="${contextPath}/production/workorder/insert"
				onsubmit="return checkWorkOrderInsert();">

				<div class="modal_body modal_body_2col">

					<div class="modal_item modal_item_full">
						<label class="modal_label"> 생산계획 선택 <span
							class="modal_required">*</span>
						</label> <select name="prodPlanId" id="insertProdPlanId"
							class="modal_select" onchange="setWorkOrderPlanInfo();" required>

							<option value="">선택</option>

							<c:forEach var="plan" items="${workOrderPlanList}">

								<option value="${plan.prodPlanId}" data-doc-no="${plan.docNo}"
									data-item-code="${plan.itemCode}"
									data-item-name="${plan.itemName}"
									data-plan-qty="${plan.prodPlanQty}"
									data-ordered-qty="${plan.orderedQty}"
									data-remain-qty="${plan.remainQty}"
									data-item-unit="${plan.itemUnit}"
									data-prod-plan-date="${plan.prodPlanDate}"
									data-due-date="${plan.dueDate}">${plan.docNo} /
									${plan.itemCode} / ${plan.itemName} / 잔량
									<fmt:formatNumber value="${plan.remainQty}" pattern="#,##0" />${plan.itemUnit}
								</option>

							</c:forEach>

						</select>

						<div class="modal_help_text">선택한 생산계획의 완제품 기준으로 사용중 BOM이 자동
							적용되고, BOM 상세 기준 원자재 투입 이력이 자동 생성됩니다.</div>
					</div>


					<div class="modal_item">
						<label class="modal_label">작업지시번호</label> <input type="text"
							id="insertDocNo" class="modal_input" value="저장 시 자동 생성" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">완제품 LOT</label> <input type="text"
							id="insertProductLot" class="modal_input" value="저장 시 자동 생성"
							readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">품목코드</label> <input type="text"
							id="insertItemCode" class="modal_input"
							placeholder="생산계획 선택 시 자동 표시" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">품목명</label> <input type="text"
							id="insertItemName" class="modal_input"
							placeholder="생산계획 선택 시 자동 표시" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">계획수량</label> <input type="text"
							id="insertPlanQtyText" class="modal_input"
							placeholder="생산계획 선택 시 자동 표시" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">납기일</label> <input type="text"
							id="insertDueDate" class="modal_input"
							placeholder="생산계획 선택 시 자동 표시" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label"> 지시수량 <span
							class="modal_required">*</span>
						</label> <input type="number" name="orderQty" id="insertOrderQty"
							class="modal_input" min="1" required>
					</div>

					<div class="modal_item">
						<label class="modal_label"> 작업지시일 <span
							class="modal_required">*</span>
						</label> <input type="date" name="orderDate" id="insertOrderDate"
							class="modal_input modal_today" required>
					</div>

					<div class="modal_item">
						<label class="modal_label"> 라인 <span
							class="modal_required">*</span>
						</label> <select name="lineId" id="insertLineId" class="modal_select"
							required>

							<option value="">선택</option>

							<c:forEach var="line" items="${lineList}">
								<option value="${line.lineId}">${line.lineName}</option>
							</c:forEach>

						</select>
					</div>

					<div class="modal_item">
						<label class="modal_label"> 담당자 <span
							class="modal_required">*</span>
						</label> <select name="empId" id="insertEmpId" class="modal_select"
							required>

							<option value="">선택</option>

							<c:forEach var="emp" items="${empList}">
								<option value="${emp.empId}">${emp.ename}/${emp.dept}</option>
							</c:forEach>

						</select>
					</div>

					<div class="modal_item modal_item_full">
						<label class="modal_label">비고</label>

						<textarea name="remark" class="modal_textarea"
							placeholder="작업지시 관련 메모를 입력하세요."></textarea>
					</div>

					<div class="modal_item modal_item_full">
						<div class="modal_help_text workorder_auto_help">작업지시 등록 후
							작업지시번호와 완제품 LOT가 자동 생성됩니다. 등록이 완료되면 BOM 기준 원자재 투입 이력이 함께 생성됩니다.</div>
					</div>

				</div>

				<div class="modal_footer">

					<button type="button"
						class="modal_btn modal_btn_cancel modal_close_btn">취소</button>

					<button type="submit" class="modal_btn modal_btn_submit">
						등록</button>

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

.workorder_auto_help {
	padding: 10px 12px;
	border-radius: 8px;
	background: #f7f9fb;
	border: 1px solid #e5e8eb;
	color: #444;
}
</style>


<script>
	// 선택 글씨 클릭 시 전체 선택 / 전체 해제
	var workOrderCheckAllLabel = document
			.getElementById("workOrderCheckAllLabel");

	if (workOrderCheckAllLabel != null) {

		workOrderCheckAllLabel.onclick = function() {

			var checkAll = document.getElementById("workOrderCheckAll");

			var checks = document.getElementsByName("orderIds");

			checkAll.checked = !checkAll.checked;

			for (var i = 0; i < checks.length; i++) {
				checks[i].checked = checkAll.checked;
			}
		};
	}

	// 개별 체크박스 상태에 따라 전체 선택 상태를 맞춘다.
	var checks = document.getElementsByName("orderIds");

	for (var i = 0; i < checks.length; i++) {

		checks[i].onclick = function() {

			var allChecked = true;

			for (var j = 0; j < checks.length; j++) {

				if (!checks[j].checked) {
					allChecked = false;
					break;
				}
			}

			document.getElementById("workOrderCheckAll").checked = allChecked;
		};
	}

	// 선택 삭제 방어코딩이다.
	function deleteCheck() {

		var checks = document.getElementsByName("orderIds");

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

		alert("작업지시는 생산실적과 원자재 투입 이력에 연결되므로 삭제 기능은 다음 단계에서 별도 검토합니다.");
	}

	// 생산계획을 선택하면 품목정보와 계획수량을 작업지시 등록 모달에 자동 표시한다.
	function setWorkOrderPlanInfo() {

		var prodPlanSelect = document.getElementById("insertProdPlanId");

		var selectedOption = prodPlanSelect.options[prodPlanSelect.selectedIndex];

		if (selectedOption == null || selectedOption.value === "") {
			document.getElementById("insertItemCode").value = "";
			document.getElementById("insertItemName").value = "";
			document.getElementById("insertPlanQtyText").value = "";
			document.getElementById("insertDueDate").value = "";
			document.getElementById("insertOrderQty").value = "";
			return;
		}

		var itemCode = selectedOption.getAttribute("data-item-code");
		var itemName = selectedOption.getAttribute("data-item-name");
		var planQty = selectedOption.getAttribute("data-plan-qty");
		var orderedQty = selectedOption.getAttribute("data-ordered-qty");
		var remainQty = selectedOption.getAttribute("data-remain-qty");
		var itemUnit = selectedOption.getAttribute("data-item-unit");
		var dueDate = selectedOption.getAttribute("data-due-date");

		document.getElementById("insertItemCode").value = itemCode || "";
		document.getElementById("insertItemName").value = itemName || "";
		document.getElementById("insertDueDate").value = dueDate || "";

		if (planQty != null && planQty !== "") {
			document.getElementById("insertPlanQtyText").value =
				"계획 " + formatNumber(planQty) + " " + (itemUnit || "")
				+ " / 지시완료 " + formatNumber(orderedQty || 0) + " " + (itemUnit || "")
				+ " / 잔량 " + formatNumber(remainQty || 0) + " " + (itemUnit || "");

			document.getElementById("insertOrderQty").value = remainQty || "";
		} else {
			document.getElementById("insertPlanQtyText").value = "";
			document.getElementById("insertOrderQty").value = "";
		}
	}

	// 작업지시 등록 방어코딩이다.
	function checkWorkOrderInsert() {

		var prodPlanId = document.getElementById("insertProdPlanId").value;

		var orderQty = document.getElementById("insertOrderQty").value;

		var orderDate = document.getElementById("insertOrderDate").value;

		var lineId = document.getElementById("insertLineId").value;

		var empId = document.getElementById("insertEmpId").value;

		if (prodPlanId === "") {
			alert("생산계획을 선택해주세요.");
			document.getElementById("insertProdPlanId").focus();
			return false;
		}

		if (orderQty === "" || Number(orderQty) <= 0) {
			alert("지시수량은 1 이상 입력해주세요.");
			document.getElementById("insertOrderQty").focus();
			return false;
		}
		
		var prodPlanSelect = document.getElementById("insertProdPlanId");
		var selectedOption = prodPlanSelect.options[prodPlanSelect.selectedIndex];
		var remainQty = 0;

		if (selectedOption != null && selectedOption.value !== "") {
			remainQty = Number(selectedOption.getAttribute("data-remain-qty") || 0);
		}

		if (Number(orderQty) > remainQty) {
			alert("지시수량은 생산계획 잔량보다 클 수 없습니다.\n잔량: " + formatNumber(remainQty));
			document.getElementById("insertOrderQty").focus();
			return false;
		}

		if (orderDate === "") {
			alert("작업지시일을 선택해주세요.");
			document.getElementById("insertOrderDate").focus();
			return false;
		}

		if (lineId === "") {
			alert("라인을 선택해주세요.");
			document.getElementById("insertLineId").focus();
			return false;
		}

		if (empId === "") {
			alert("담당자를 선택해주세요.");
			document.getElementById("insertEmpId").focus();
			return false;
		}

		if (!confirm("작업지시를 등록하시겠습니까?\n등록 시 해당 완제품의 BOM 기준으로 원자재 투입 이력이 자동 생성됩니다.")) {
			return false;
		}

		return true;
	}

	// 숫자 천단위 구분 표시용이다.
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