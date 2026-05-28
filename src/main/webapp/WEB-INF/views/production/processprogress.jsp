<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명: processprogress.jsp
	메뉴: 생산관리 > 공정진행 현황

	기준:
	- URL: /production/processprogress
	- Controller return: production/processprogress.tiles
	- 생산관리 파일 구조 유지
	  DTO / DAO / Service / Controller / Mapper는 생산관리 1개 파일로 관리
	  JSP만 페이지별 관리
	- LOSS_QTY는 불량수량이 아니라 LOSS량 / 손실수량이다.
	- 공정진행 현황은 작업지시 기준으로 진행률을 조회한다.
	- PC 목록 8컬럼 / 모바일 5컬럼 기준
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div class="coPageWrap">

	<c:if test="${not empty msg}">
		<script>
			alert("${msg}");
		</script>
	</c:if>


	<%-- =========================================================
	     1. 검색 영역
	     ========================================================= --%>
	<form class="search-form" method="get"
		action="${contextPath}/production/processprogress">

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
					<label class="search-label">진행상태</label>
					<select name="prodStatus" class="search-select">
						<option value="">전체</option>

						<c:forEach var="status" items="${processProgressStatusList}">
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
						placeholder="작업지시번호 / LOT / 품목코드 / 품명 / 라인"
						value="${keyword}">
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
						onclick="location.href='${contextPath}/production/processprogress'">
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
	     2. 목록 상단
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
	     3. 목록
	     ========================================================= --%>
	<div class="coTableWrap">

		<table class="coTable process_progress_table">

			<thead>
				<tr>
					<th class="mobile_hidden">작업지시번호</th>
					<th class="mobile_show">LOT번호</th>
					<th class="mobile_hidden">품목명</th>
					<th class="mobile_hidden">라인</th>
					<th class="mobile_show">지시수량</th>
					<th class="mobile_show">누적생산</th>
					<th class="mobile_hidden">LOSS량</th>
					<th class="mobile_show">진행률</th>
					<th class="mobile_show">상세</th>
				</tr>
			</thead>

			<tbody>

				<c:forEach var="progress" items="${list}">

					<tr>
						<td class="mobile_hidden" title="${progress.workOrderDocNo}">
							${progress.workOrderDocNo}
						</td>

						<td class="mobile_show" title="${progress.productLot}">
							${progress.productLot}
						</td>

						<td class="coTextLeft mobile_hidden"
							title="${progress.itemName}">
							${progress.itemName}
						</td>

						<td class="mobile_hidden" title="${progress.lineName}">
							${progress.lineName}
						</td>

						<td class="mobile_show">
							<fmt:formatNumber value="${progress.orderQty}" pattern="#,##0" />
							${progress.itemUnit}
						</td>

						<td class="mobile_show">
							<fmt:formatNumber value="${progress.totalProdQty}" pattern="#,##0" />
							${progress.itemUnit}
						</td>

						<td class="mobile_hidden">
							<fmt:formatNumber value="${progress.totalLossQty}" pattern="#,##0" />
							${progress.itemUnit}
						</td>

						<td class="mobile_show">
							<div class="progress_cell">

								<div class="progress_bar">
									<div class="progress_bar_fill"
										style="width:${progress.progressRate}%;">
									</div>
								</div>

								<div class="progress_text">
									<fmt:formatNumber value="${progress.progressRate}" pattern="#,##0" />%
									/
									<c:choose>
										<c:when test="${progress.progressStatus eq '완료'}">
											<span class="coStatus coStatusUse">
												${progress.progressStatus}
											</span>
										</c:when>

										<c:when test="${progress.progressStatus eq '보류' or progress.progressStatus eq '취소'}">
											<span class="coStatus coStatusStop">
												${progress.progressStatus}
											</span>
										</c:when>

										<c:otherwise>
											<span class="coStatus">
												${progress.progressStatus}
											</span>
										</c:otherwise>
									</c:choose>
								</div>

							</div>
						</td>

						<td class="mobile_show">
							<button type="button" class="coDetailBtn"
								onclick="location.href='${contextPath}/production/processprogress/detail?orderId=${progress.orderId}'">
								보기
							</button>
						</td>
					</tr>

				</c:forEach>

				<c:if test="${empty list}">
					<tr>
						<td colspan="9">조회된 공정진행 정보가 없습니다.</td>
					</tr>
				</c:if>

			</tbody>

		</table>

	</div>


	<%-- =========================================================
	     4. 공정진행 등록 모달
	     ========================================================= --%>
	<div id="modal_insert" class="modal_wrap" aria-hidden="true">

		<div class="modal_box" role="dialog" aria-modal="true">

			<div class="modal_header">
				<h3 class="modal_title">공정진행 등록</h3>
			</div>

			<form class="modal_form" method="post"
				action="${contextPath}/production/processprogress/insert"
				onsubmit="return checkProcessProgressInsert();">

				<div class="modal_body modal_body_2col">

					<div class="modal_item modal_item_full">
						<label class="modal_label">
							작업지시 선택 <span class="modal_required">*</span>
						</label>

						<select name="orderId" id="insertOrderId"
							class="modal_select"
							onchange="setProcessProgressOrderInfo();" required>

							<option value="">선택</option>

							<c:forEach var="order" items="${processProgressOrderList}">
								<option value="${order.orderId}"
									data-prod-plan-doc-no="${order.prodPlanDocNo}"
									data-work-order-doc-no="${order.workOrderDocNo}"
									data-product-lot="${order.productLot}"
									data-order-qty="${order.orderQty}"
									data-item-code="${order.itemCode}"
									data-item-name="${order.itemName}"
									data-item-unit="${order.itemUnit}">
									${order.workOrderDocNo} / ${order.productLot} /
									${order.itemCode} / ${order.itemName} /
									지시수량
									<fmt:formatNumber value="${order.orderQty}" pattern="#,##0" />${order.itemUnit}
								</option>
							</c:forEach>

						</select>

						<div class="modal_help_text">
							공정진행 등록은 생산실적 등록과 같은 production 테이블에 저장됩니다.
							LOSS량은 불량수량이 아니라 생산 중 손실수량입니다.
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
							진행상태 <span class="modal_required">*</span>
						</label>

						<select name="prodStatus" id="insertProdStatus"
							class="modal_select" required>
							<option value="진행중">진행중</option>
							<option value="완료">완료</option>
							<option value="보류">보류</option>
						</select>
					</div>

					<div class="modal_item modal_item_full">
						<label class="modal_label">비고</label>
						<textarea name="remark" class="modal_textarea"
							placeholder="공정진행 관련 메모를 입력하세요."></textarea>
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

.process_progress_table {
	table-layout: fixed;
}

.progress_cell {
	width: 100%;
	min-width: 0;
}

.progress_bar {
	width: 100%;
	height: 7px;
	background: #e9edf0;
	border-radius: 99px;
	overflow: hidden;
	margin-bottom: 5px;
}

.progress_bar_fill {
	height: 100%;
	background: #174c3c;
	border-radius: 99px;
}

.progress_text {
	font-size: 12px;
	color: #444;
	white-space: nowrap;
}
</style>


<script>
	// 작업지시 선택 시 공정진행 등록 정보 자동입력
	function setProcessProgressOrderInfo() {

		var orderSelect = document.getElementById("insertOrderId");

		var selectedOption = orderSelect.options[orderSelect.selectedIndex];

		if (selectedOption == null || selectedOption.value === "") {
			clearProcessProgressOrderInfo();
			return;
		}

		var prodPlanDocNo = selectedOption.getAttribute("data-prod-plan-doc-no");
		var workOrderDocNo = selectedOption.getAttribute("data-work-order-doc-no");
		var productLot = selectedOption.getAttribute("data-product-lot");
		var orderQty = selectedOption.getAttribute("data-order-qty");
		var itemCode = selectedOption.getAttribute("data-item-code");
		var itemName = selectedOption.getAttribute("data-item-name");
		var itemUnit = selectedOption.getAttribute("data-item-unit");

		document.getElementById("insertProdPlanDocNo").value = prodPlanDocNo || "";
		document.getElementById("insertWorkOrderDocNo").value = workOrderDocNo || "";
		document.getElementById("insertProductLot").value = productLot || "";
		document.getElementById("insertItemCode").value = itemCode || "";
		document.getElementById("insertItemName").value = itemName || "";

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

	// 공정진행 등록 정보 초기화
	function clearProcessProgressOrderInfo() {

		document.getElementById("insertProdPlanDocNo").value = "";
		document.getElementById("insertWorkOrderDocNo").value = "";
		document.getElementById("insertProductLot").value = "";
		document.getElementById("insertItemCode").value = "";
		document.getElementById("insertItemName").value = "";
		document.getElementById("insertOrderQtyText").value = "";
		document.getElementById("insertOrderQty").value = "";
		document.getElementById("insertProdQty").value = "";
		document.getElementById("insertLossQty").value = "0";
	}

	// 공정진행 등록 방어코딩
	function checkProcessProgressInsert() {

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
			alert("진행상태를 선택해주세요.");
			document.getElementById("insertProdStatus").focus();
			return false;
		}

		if (!confirm("공정진행 정보를 등록하시겠습니까?")) {
			return false;
		}

		return true;
	}

	// 숫자 천단위 구분
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