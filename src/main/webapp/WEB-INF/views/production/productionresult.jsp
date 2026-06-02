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
	- 생산실적은 작업지시 기준으로 등록
	- 등록 가능한 작업지시는 잔량이 남은 작업지시만 표시
	- 기본 조회 기준은 Mapper에서 잔량 20EA 이상만 표시
	- [소량 잔량 포함] 체크 시 잔량 1EA 이상 작업지시도 표시
	- QR 스캔 진입은 orderId 기준 별도 조회이므로 소량 잔량 필터 제한을 받지 않음
	- 생산수량 + LOSS량은 작업지시 잔량보다 클 수 없음
	- 생산상태는 Mapper에서 누적수량 기준으로 자동 계산
	  정상 등록 → 진행중 또는 완료
	  보류 선택 → 보류
	- 품질검사 상태는 등록 시 기본값 "검사 예정"
	- 생산실적 담당자는 productionResultEmpList 사용
	- QR 스캔 진입 시 작업지시/LOT 자동입력 및 모달 자동 오픈
	- 검색어 input placeholder는 생산관리 공통 기준 "검색 키워드"로 통일
	- 전체검색은 Mapper에서 상세페이지 주요 항목까지 대소문자 구분 없이 일부 포함 검색
	- 진행중은 완료와 같은 정상 스타일로 표시한다
	- 모바일 select 깨짐 방지를 위해 작업지시 option 문구는 짧게 표시하고 상세 정보는 선택 후 아래에 표시한다

	목록 컬럼 기준:
	- PC: 체크박스 포함 8개
	  1 선택
	  2 실적번호
	  3 작업지시번호
	  4 LOT번호
	  5 생산수량
	  6 생산일자
	  7 생산상태
	  8 상세

	- 모바일: 체크박스 포함 5개
	  1 선택
	  2 LOT번호
	  3 생산수량
	  4 생산상태
	  5 상세
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div class="coPageWrap">

	<c:if test="${not empty msg}">
		<script>
			alert("${msg}");
		</script>
	</c:if>


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
						placeholder="검색 키워드"
						value="${keyword}">
				</div>

				<input type="hidden" name="includeSmallRemain"
					id="searchIncludeSmallRemain"
					value="${includeSmallRemain}">

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


	<form method="post" id="deleteForm"
		action="${contextPath}/production/productionresult/delete">

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
					onclick="deleteCheck();">
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

			<table class="coTable production-result-table">

				<thead>
					<tr>
						<th class="mobile_show">
							<label id="productionResultCheckAllLabel">선택</label>
							<input type="checkbox" id="productionResultCheckAll"
								style="display: none;">
						</th>

						<th class="mobile_hidden">실적번호</th>
						<th class="mobile_hidden">작업지시번호</th>
						<th class="mobile_show">LOT번호</th>
						<th class="mobile_show">생산수량</th>
						<th class="mobile_hidden">생산일자</th>
						<th class="mobile_show">생산상태</th>
						<th class="mobile_show">상세</th>
					</tr>
				</thead>

				<tbody>

					<c:choose>

						<c:when test="${not empty list}">

							<c:forEach var="result" items="${list}">

								<tr>
									<td class="mobile_show">
										<input type="checkbox" name="prodIds"
											value="${result.prodId}">
									</td>

									<td class="mobile_hidden" title="${result.docNo}">
										${result.docNo}
									</td>

									<td class="mobile_hidden" title="${result.workOrderDocNo}">
										${result.workOrderDocNo}
									</td>

									<td class="mobile_show" title="${result.productLot}">
										${result.productLot}
									</td>

									<td class="mobile_show">
										<fmt:formatNumber value="${result.prodQty}"
											pattern="#,##0" />
										${result.itemUnit}
									</td>

									<td class="mobile_hidden">
										${result.prodDate}
									</td>

									<td class="mobile_show">
										<c:choose>

											<c:when
												test="${result.prodStatus eq '완료' or result.prodStatus eq '진행중'}">
												<span class="coStatus coStatusUse">
													${result.prodStatus}
												</span>
											</c:when>

											<c:when
												test="${result.prodStatus eq '취소' or result.prodStatus eq '보류'}">
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

						</c:when>

						<c:otherwise>
							<tr>
								<td colspan="8">조회된 생산실적이 없습니다.</td>
							</tr>
						</c:otherwise>

					</c:choose>

				</tbody>

			</table>

		</div>

	</form>


	<div id="modal_insert" class="modal_wrap" aria-hidden="true">

		<div class="modal_box production-result-modal-box" role="dialog"
			aria-modal="true">

			<div class="modal_header">
				<h3 class="modal_title">생산실적 등록</h3>
			</div>

			<form class="modal_form" method="post"
				action="${contextPath}/production/productionresult/insert"
				onsubmit="return checkProductionResultInsert();">

				<input type="hidden" name="orderQty" id="insertOrderQty">

				<div class="modal_body modal_body_2col production-result-modal-body">

					<div class="modal_item modal_item_full">

						<div class="production-result-order-option-row">

							<label class="modal_label">
								작업지시 선택 <span class="modal_required">*</span>
							</label>

							<label class="production-result-small-remain-label">
								<input type="checkbox" id="includeSmallRemainCheck"
									value="Y"
									<c:if test="${includeSmallRemain eq 'Y'}">checked</c:if>
									onchange="changeIncludeSmallRemain(this);">
								<span>소량 잔량 포함</span>
							</label>

						</div>

						<select name="orderId" id="insertOrderId"
							class="modal_select production-result-order-select"
							onchange="setProductionResultOrderInfo();"
							required>

							<option value="">선택</option>

							<c:if test="${not empty qrOrder}">
								<option value="${qrOrder.orderId}"
									data-work-order-doc-no="${qrOrder.workOrderDocNo}"
									data-product-lot="${qrOrder.productLot}"
									data-item-code="${qrOrder.itemCode}"
									data-item-name="${qrOrder.itemName}"
									data-item-unit="${qrOrder.itemUnit}"
									data-order-qty="${qrOrder.orderQty}"
									data-total-prod-qty="${qrOrder.totalProdQty}"
									data-total-loss-qty="${qrOrder.totalLossQty}"
									data-remain-qty="${qrOrder.remainQty}"
									data-order-date="${qrOrder.orderDate}"
									selected>
									${qrOrder.workOrderDocNo} / ${qrOrder.productLot} / 잔량
									<fmt:formatNumber value="${qrOrder.remainQty}" pattern="#,##0" />${qrOrder.itemUnit}
								</option>
							</c:if>

							<c:forEach var="order" items="${productionResultOrderList}">
								<c:if test="${empty qrOrder or qrOrder.orderId ne order.orderId}">
									<option value="${order.orderId}"
										data-work-order-doc-no="${order.workOrderDocNo}"
										data-product-lot="${order.productLot}"
										data-item-code="${order.itemCode}"
										data-item-name="${order.itemName}"
										data-item-unit="${order.itemUnit}"
										data-order-qty="${order.orderQty}"
										data-total-prod-qty="${order.totalProdQty}"
										data-total-loss-qty="${order.totalLossQty}"
										data-remain-qty="${order.remainQty}"
										data-order-date="${order.orderDate}">
										${order.workOrderDocNo} / ${order.productLot} / 잔량
										<fmt:formatNumber value="${order.remainQty}" pattern="#,##0" />${order.itemUnit}
									</option>
								</c:if>
							</c:forEach>

						</select>

						<div class="modal_help_text">
							기본값은 잔량 20EA 이상인 최근 작업지시만 표시합니다.
							소량 잔량 작업지시가 필요하면 “소량 잔량 포함”을 체크하세요.
						</div>

						<div class="modal_help_text">
							모바일 화면에서는 작업지시 선택 목록을 짧게 표시하고, 상세 정보는 선택 후 아래에 표시됩니다.
						</div>

					</div>


					<div class="modal_item">
						<label class="modal_label">작업지시번호</label>

						<input type="text" id="insertWorkOrderDocNo"
							class="modal_input"
							placeholder="작업지시 선택 시 자동 표시" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">LOT번호</label>

						<input type="text" id="insertProductLot"
							class="modal_input"
							placeholder="작업지시 선택 시 자동 표시" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">품목코드</label>

						<input type="text" id="insertItemCode"
							class="modal_input"
							placeholder="작업지시 선택 시 자동 표시" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">품목명</label>

						<input type="text" id="insertItemName"
							class="modal_input"
							placeholder="작업지시 선택 시 자동 표시" readonly>
					</div>

					<div class="modal_item modal_item_full">
						<label class="modal_label">작업지시 수량 / 누계 / 잔량</label>

						<input type="text" id="insertOrderQtyText"
							class="modal_input"
							placeholder="작업지시 선택 시 자동 표시" readonly>

						<div id="remainQtyHelpText" class="modal_help_text">
							생산수량과 LOSS량의 합은 잔량을 초과할 수 없습니다.
						</div>
					</div>

					<div class="modal_item">
						<label class="modal_label">
							생산일자 <span class="modal_required">*</span>
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

							<c:forEach var="emp" items="${productionResultEmpList}">
								<option value="${emp.empId}">
									${emp.ename} / ${emp.dept}
								</option>
							</c:forEach>

						</select>

						<div class="modal_help_text">
							생산실적 담당자는 작업자 / 작업자 / WORKER 기준으로 표시됩니다.
						</div>
					</div>

					<div class="modal_item">
						<label class="modal_label">
							생산수량 <span class="modal_required">*</span>
						</label>

						<input type="number" name="prodQty" id="insertProdQty"
							class="modal_input" min="1" required
							oninput="checkResultQtyPreview();">
					</div>

					<div class="modal_item">
						<label class="modal_label">
							LOSS량 <span class="modal_required">*</span>
						</label>

						<input type="number" name="lossQty" id="insertLossQty"
							class="modal_input" min="0" value="0" required
							oninput="checkResultQtyPreview();">
					</div>

					<div class="modal_item">
						<label class="modal_label">
							등록구분 <span class="modal_required">*</span>
						</label>

						<select name="prodStatus" id="insertProdStatus"
							class="modal_select" required>
							<option value="진행중">정상등록</option>
							<option value="보류">보류</option>
						</select>

						<div class="modal_help_text">
							정상등록은 누적수량 기준으로 진행중/완료가 자동 계산됩니다.
						</div>
					</div>

					<div class="modal_item">
						<label class="modal_label">품질검사 상태</label>

						<input type="text" id="insertInspectionStatusText"
							class="modal_input" value="검사 예정" readonly>

						<div class="modal_help_text">
							생산실적 등록 후 품질검사 등록 시 검사 완료로 변경됩니다.
						</div>
					</div>

					<div class="modal_item modal_item_full">
						<label class="modal_label">수량검증</label>

						<input type="text" id="insertQtyCheckText"
							class="modal_input" value="작업지시 선택 후 수량을 입력하세요." readonly>
					</div>

					<div class="modal_item modal_item_full">
						<label class="modal_label">비고</label>

						<textarea name="remark" class="modal_textarea"
							placeholder="생산실적 관련 메모를 입력하세요."></textarea>
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
	word-break: keep-all;
	overflow-wrap: anywhere;
}

.production-result-modal-box {
	width: min(900px, calc(100vw - 32px));
	max-height: calc(100vh - 40px);
	display: flex;
	flex-direction: column;
}

.production-result-modal-body {
	overflow-y: auto;
	max-height: calc(100vh - 180px);
	padding-right: 4px;
}

.production-result-modal-body .modal_textarea {
	min-height: 74px;
}

.production-result-order-option-row {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 12px;
	margin-bottom: 6px;
}

.production-result-small-remain-label {
	display: inline-flex;
	align-items: center;
	gap: 6px;
	font-size: 13px;
	color: #333;
	white-space: nowrap;
	cursor: pointer;
}

.production-result-small-remain-label input {
	margin: 0;
}

.production-result-order-select {
	width: 100%;
	max-width: 100%;
	box-sizing: border-box;
}

.production-result-order-select option {
	max-width: 100%;
}

@media (max-width: 768px) {
	.production-result-modal-box {
		width: calc(100vw - 24px);
		max-height: calc(100vh - 24px);
	}

	.production-result-modal-body {
		max-height: calc(100vh - 164px);
		padding-right: 0;
	}

	.production-result-order-option-row {
		align-items: flex-start;
		flex-direction: column;
		gap: 6px;
	}

	.production-result-small-remain-label {
		font-size: 13px;
	}

	.production-result-order-select {
		font-size: 13px;
		min-width: 0;
	}

	.modal_help_text {
		font-size: 12px;
	}
}
</style>


<script>
	var productionResultCheckAllLabel =
		document.getElementById("productionResultCheckAllLabel");

	if (productionResultCheckAllLabel != null) {

		productionResultCheckAllLabel.onclick = function() {

			var checkAll = document.getElementById("productionResultCheckAll");
			var checks = document.getElementsByName("prodIds");

			if (checkAll == null || checks == null) {
				return;
			}

			checkAll.checked = !checkAll.checked;

			for (var i = 0; i < checks.length; i++) {
				checks[i].checked = checkAll.checked;
			}
		};
	}


	var productionResultChecks = document.getElementsByName("prodIds");

	for (var i = 0; i < productionResultChecks.length; i++) {

		productionResultChecks[i].onclick = function() {

			var allChecked = true;

			for (var j = 0; j < productionResultChecks.length; j++) {

				if (!productionResultChecks[j].checked) {
					allChecked = false;
					break;
				}
			}

			var checkAll = document.getElementById("productionResultCheckAll");

			if (checkAll != null) {
				checkAll.checked = allChecked;
			}
		};
	}


	function deleteCheck() {

		var checks = document.getElementsByName("prodIds");
		var checked = false;

		for (var i = 0; i < checks.length; i++) {

			if (checks[i].checked) {
				checked = true;
				break;
			}
		}

		if (!checked) {
			alert("삭제할 항목을 선택해주세요.");
			return;
		}

		alert("생산실적은 품질검사, 재고반영, LOT 이력과 연결되므로 삭제 기능은 지원하지 않습니다.\n수정이 필요한 경우 상세 화면에서 보류 또는 취소 상태로 관리하세요.");
	}


	function changeIncludeSmallRemain(checkBox) {

		var url = new URL(window.location.href);

		if (checkBox.checked) {
			url.searchParams.set("includeSmallRemain", "Y");
		} else {
			url.searchParams.delete("includeSmallRemain");
		}

		url.searchParams.set("openInsertModal", "Y");
		url.searchParams.delete("page");

		window.location.href = url.toString();
	}


	document.addEventListener("DOMContentLoaded", function() {

		var openModal = "${openModal}";
		var openInsertModal = "${param.openInsertModal}";

		if (openModal === "Y" || openInsertModal === "Y") {

			var modal = document.getElementById("modal_insert");

			if (modal != null) {
				modal.classList.add("modal_is_open");
				modal.setAttribute("aria-hidden", "false");
				document.body.classList.add("modal_body_lock");
			}
		}

		setModalTodayDate();

		var orderSelect = document.getElementById("insertOrderId");

		if (orderSelect != null && orderSelect.value !== "") {
			setProductionResultOrderInfo();
		}
	});


	function setModalTodayDate() {

		var prodDateInput = document.getElementById("insertProdDate");

		if (prodDateInput == null || prodDateInput.value !== "") {
			return;
		}

		var today = new Date();
		var year = today.getFullYear();
		var month = String(today.getMonth() + 1).padStart(2, "0");
		var date = String(today.getDate()).padStart(2, "0");

		prodDateInput.value = year + "-" + month + "-" + date;
	}


	function setProductionResultOrderInfo() {

		var orderSelect = document.getElementById("insertOrderId");
		var selectedOption = orderSelect.options[orderSelect.selectedIndex];

		if (selectedOption == null || selectedOption.value === "") {

			document.getElementById("insertWorkOrderDocNo").value = "";
			document.getElementById("insertProductLot").value = "";
			document.getElementById("insertItemCode").value = "";
			document.getElementById("insertItemName").value = "";
			document.getElementById("insertOrderQtyText").value = "";
			document.getElementById("insertOrderQty").value = "";
			document.getElementById("remainQtyHelpText").innerHTML =
				"생산수량과 LOSS량의 합은 잔량을 초과할 수 없습니다.";

			checkResultQtyPreview();
			return;
		}

		var workOrderDocNo =
			selectedOption.getAttribute("data-work-order-doc-no");
		var productLot =
			selectedOption.getAttribute("data-product-lot");
		var itemCode =
			selectedOption.getAttribute("data-item-code");
		var itemName =
			selectedOption.getAttribute("data-item-name");
		var itemUnit =
			selectedOption.getAttribute("data-item-unit");
		var orderQty =
			selectedOption.getAttribute("data-order-qty");
		var totalProdQty =
			selectedOption.getAttribute("data-total-prod-qty");
		var totalLossQty =
			selectedOption.getAttribute("data-total-loss-qty");
		var remainQty =
			selectedOption.getAttribute("data-remain-qty");

		document.getElementById("insertWorkOrderDocNo").value =
			workOrderDocNo || "";
		document.getElementById("insertProductLot").value =
			productLot || "";
		document.getElementById("insertItemCode").value =
			itemCode || "";
		document.getElementById("insertItemName").value =
			itemName || "";
		document.getElementById("insertOrderQty").value =
			orderQty || "";

		document.getElementById("insertOrderQtyText").value =
			"지시 " + formatNumber(orderQty || 0) + " " + (itemUnit || "")
			+ " / 생산누계 " + formatNumber(totalProdQty || 0) + " " + (itemUnit || "")
			+ " / LOSS누계 " + formatNumber(totalLossQty || 0) + " " + (itemUnit || "")
			+ " / 잔량 " + formatNumber(remainQty || 0) + " " + (itemUnit || "");

		document.getElementById("remainQtyHelpText").innerHTML =
			"현재 등록 가능 잔량은 " + formatNumber(remainQty || 0)
			+ " " + (itemUnit || "") + " 입니다.";

		checkResultQtyPreview();
	}


	function checkResultQtyPreview() {

		var orderSelect = document.getElementById("insertOrderId");
		var selectedOption = orderSelect.options[orderSelect.selectedIndex];

		var prodQty = Number(document.getElementById("insertProdQty").value || 0);
		var lossQty = Number(document.getElementById("insertLossQty").value || 0);

		if (selectedOption == null || selectedOption.value === "") {
			document.getElementById("insertQtyCheckText").value =
				"작업지시를 먼저 선택하세요.";
			return;
		}

		var remainQty = Number(selectedOption.getAttribute("data-remain-qty") || 0);
		var itemUnit = selectedOption.getAttribute("data-item-unit") || "";
		var requestQty = prodQty + lossQty;

		if (prodQty <= 0) {
			document.getElementById("insertQtyCheckText").value =
				"생산수량을 1 이상 입력하세요.";
			return;
		}

		if (lossQty < 0) {
			document.getElementById("insertQtyCheckText").value =
				"LOSS량은 0 이상 입력하세요.";
			return;
		}

		if (lossQty > prodQty) {
			document.getElementById("insertQtyCheckText").value =
				"LOSS량은 생산수량보다 클 수 없습니다.";
			return;
		}

		if (requestQty > remainQty) {
			document.getElementById("insertQtyCheckText").value =
				"초과: 생산수량 + LOSS량 = "
				+ formatNumber(requestQty) + " " + itemUnit
				+ " / 잔량 " + formatNumber(remainQty) + " " + itemUnit;
			return;
		}

		document.getElementById("insertQtyCheckText").value =
			"정상: 생산수량 + LOSS량 = "
			+ formatNumber(requestQty) + " " + itemUnit
			+ " / 잔량 " + formatNumber(remainQty) + " " + itemUnit;
	}


	function checkProductionResultInsert() {

		var orderId = document.getElementById("insertOrderId").value;
		var empId = document.getElementById("insertEmpId").value;
		var prodDate = document.getElementById("insertProdDate").value;
		var prodQty = Number(document.getElementById("insertProdQty").value || 0);
		var lossQty = Number(document.getElementById("insertLossQty").value || 0);

		if (orderId === "") {
			alert("작업지시를 선택해주세요.");
			document.getElementById("insertOrderId").focus();
			return false;
		}

		if (prodDate === "") {
			alert("생산일자를 선택해주세요.");
			document.getElementById("insertProdDate").focus();
			return false;
		}

		if (empId === "") {
			alert("담당자를 선택해주세요.");
			document.getElementById("insertEmpId").focus();
			return false;
		}

		if (prodQty <= 0) {
			alert("생산수량은 1 이상 입력해주세요.");
			document.getElementById("insertProdQty").focus();
			return false;
		}

		if (lossQty < 0) {
			alert("LOSS량은 0 이상 입력해주세요.");
			document.getElementById("insertLossQty").focus();
			return false;
		}

		if (lossQty > prodQty) {
			alert("LOSS량은 생산수량보다 클 수 없습니다.");
			document.getElementById("insertLossQty").focus();
			return false;
		}

		var orderSelect = document.getElementById("insertOrderId");
		var selectedOption = orderSelect.options[orderSelect.selectedIndex];
		var remainQty = Number(selectedOption.getAttribute("data-remain-qty") || 0);
		var requestQty = prodQty + lossQty;

		if (requestQty > remainQty) {
			alert("생산수량과 LOSS량의 합은 작업지시 잔량보다 클 수 없습니다.\n잔량: "
				+ formatNumber(remainQty)
				+ "\n입력합계: "
				+ formatNumber(requestQty));
			document.getElementById("insertProdQty").focus();
			return false;
		}

		if (!confirm("생산실적을 등록하시겠습니까?\n등록 후 품질검사 상태는 검사 예정으로 처리됩니다.")) {
			return false;
		}

		return true;
	}


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