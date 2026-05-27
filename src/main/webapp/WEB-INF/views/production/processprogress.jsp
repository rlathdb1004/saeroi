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
	- 공정진행 현황은 작업지시 기준 누적 생산수량 / 누적 불량수량 / 진행률 조회 화면
	- 등록 모달은 생산실적 등록과 동일하게 PRODUCTION 테이블에 실적을 추가하는 구조
	- 지시수량 / 누적생산수량 / 누적불량수량 천단위 표시
	- 진행률 바 표시

	목록 컬럼 기준:
	- PC: 체크박스 포함 8개
	  1 선택
	  2 작업지시번호
	  3 LOT번호
	  4 품명
	  5 라인
	  6 누적생산
	  7 진행률
	  8 상세

	- 모바일: 체크박스 포함 5개
	  1 선택
	  2 작업지시번호
	  3 품명
	  4 진행률
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

					<select name="progressStatus" class="search-select">
						<option value="">전체</option>

						<c:forEach var="status" items="${processProgressStatusList}">
							<option value="${status}"
								<c:if test="${progressStatus eq status}">selected</c:if>>
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
				공정실적 등록
			</button>

		</div>

	</div>


	<%-- =========================================================
	     4. 공정진행 현황 목록
	     ========================================================= --%>
	<div class="coTableWrap">

		<table class="coTable process-progress-table">

			<thead>
				<tr>
					<th class="mobile_show">
						<label id="processProgressCheckAllLabel">선택</label>
						<input type="checkbox" id="processProgressCheckAll"
							style="display: none;">
					</th>

					<th class="mobile_show">작업지시번호</th>
					<th class="mobile_hidden">LOT번호</th>
					<th class="mobile_show">품명</th>
					<th class="mobile_hidden">라인</th>
					<th class="mobile_hidden">누적생산</th>
					<th class="mobile_show">진행률</th>
					<th class="mobile_show">상세</th>
				</tr>
			</thead>

			<tbody>

				<c:choose>

					<c:when test="${not empty list}">

						<c:forEach var="progress" items="${list}">

							<tr>
								<td class="mobile_show">
									<input type="checkbox" name="progressOrderIds"
										value="${progress.orderId}">
								</td>

								<td class="mobile_show" title="${progress.docNo}">
									${progress.docNo}
								</td>

								<td class="mobile_hidden" title="${progress.productLot}">
									${progress.productLot}
								</td>

								<td class="coTextLeft mobile_show" title="${progress.itemName}">
									${progress.itemName}
								</td>

								<td class="mobile_hidden" title="${progress.lineName}">
									<c:choose>
										<c:when test="${not empty progress.lineName}">
											${progress.lineName}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<td class="mobile_hidden">
									<div>
										<fmt:formatNumber value="${progress.totalProdQty}"
											pattern="#,##0" />
										${progress.itemUnit}
									</div>

									<div class="process-progress-loss-text">
										불량
										<fmt:formatNumber value="${progress.totalLossQty}"
											pattern="#,##0" />
										${progress.itemUnit}
									</div>
								</td>

								<td class="mobile_show">
									<div class="process-progress-rate-box">
										<div class="process-progress-rate-top">
											<span>
												<c:choose>
													<c:when test="${not empty progress.progressRate}">
														${progress.progressRate}%
													</c:when>
													<c:otherwise>0%</c:otherwise>
												</c:choose>
											</span>

											<c:choose>
												<c:when test="${progress.progressStatus eq '완료'}">
													<span class="coStatus coStatusUse">
														${progress.progressStatus}
													</span>
												</c:when>

												<c:when test="${progress.progressStatus eq '보류'}">
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

										<div class="process-progress-bar">
											<div class="process-progress-bar-fill"
												style="width:${empty progress.progressRate ? 0 : progress.progressRate}%;">
											</div>
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

					</c:when>

					<c:otherwise>
						<tr>
							<td colspan="8">조회된 공정진행 현황이 없습니다.</td>
						</tr>
					</c:otherwise>

				</c:choose>

			</tbody>

		</table>

	</div>


	<%-- =========================================================
	     5. 공정실적 등록 모달
	     ========================================================= --%>
	<div id="modal_insert" class="modal_wrap" aria-hidden="true">

		<div class="modal_box" role="dialog" aria-modal="true">

			<div class="modal_header">
				<h3 class="modal_title">공정실적 등록</h3>
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
							onchange="setProcessProgressOrderInfo();"
							required>

							<option value="">선택</option>

							<c:forEach var="order" items="${processProgressOrderList}">

								<option value="${order.orderId}"
									data-work-order-doc-no="${order.workOrderDocNo}"
									data-product-lot="${order.productLot}"
									data-item-code="${order.itemCode}"
									data-item-name="${order.itemName}"
									data-order-qty="${order.orderQty}"
									data-order-date="${order.orderDate}"
									data-item-unit="${order.itemUnit}">
									${order.workOrderDocNo} / ${order.productLot} /
									${order.itemCode} / ${order.itemName}
								</option>

							</c:forEach>

						</select>

						<div class="modal_help_text">
							작업지시를 선택하면 LOT, 품목, 지시수량이 자동 표시됩니다.
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

					<div class="modal_item modal_item_full">
						<label class="modal_label">품목명</label>

						<input type="text" id="insertItemName"
							class="modal_input"
							placeholder="작업지시 선택 시 자동 표시" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">지시수량</label>

						<input type="text" id="insertOrderQtyText"
							class="modal_input"
							placeholder="작업지시 선택 시 자동 표시" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">
							생산수량 <span class="modal_required">*</span>
						</label>

						<div class="process-progress-qty-box">
							<input type="number" name="prodQty" id="insertProdQty"
								class="modal_input" min="1"
								oninput="setProcessProgressQtyPreview();"
								required>

							<input type="text" id="insertProdUnit"
								class="modal_input process-progress-unit-input"
								placeholder="단위" readonly>
						</div>

						<div id="prodQtyPreviewText" class="modal_help_text">
							생산수량을 입력하세요.
						</div>
					</div>

					<div class="modal_item">
						<label class="modal_label">불량수량</label>

						<input type="number" name="lossQty" id="insertLossQty"
							class="modal_input" min="0" value="0"
							oninput="setProcessProgressQtyPreview();">

						<div id="lossQtyPreviewText" class="modal_help_text">
							불량수량은 생산수량보다 클 수 없습니다.
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
							진행상태 <span class="modal_required">*</span>
						</label>

						<select name="prodStatus" id="insertProdStatus"
							class="modal_select" required>
							<option value="">선택</option>
							<option value="진행중">진행중</option>
							<option value="완료">완료</option>
							<option value="보류">보류</option>
						</select>
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

					<div class="modal_item modal_item_full">
						<label class="modal_label">비고</label>

						<textarea name="remark" class="modal_textarea"
							maxlength="500"
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

.process-progress-loss-text {
	margin-top: 4px;
	font-size: 12px;
	color: #888;
}

.process-progress-rate-box {
	width: 100%;
	min-width: 130px;
}

.process-progress-rate-top {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 8px;
	margin-bottom: 6px;
}

.process-progress-rate-top span:first-child {
	font-weight: 700;
	color: #333;
}

.process-progress-bar {
	width: 100%;
	height: 8px;
	border-radius: 999px;
	background: #e9edf2;
	overflow: hidden;
}

.process-progress-bar-fill {
	height: 100%;
	border-radius: 999px;
	background: #2f7d5b;
}

.process-progress-qty-box {
	display: flex;
	align-items: center;
	gap: 8px;
	width: 100%;
	box-sizing: border-box;
}

.process-progress-qty-box .modal_input:first-child {
	flex: 1 1 auto;
	min-width: 0;
}

.process-progress-unit-input {
	flex: 0 0 80px;
	text-align: center;
}


</style>


<script>
	/*
	 * 선택 컬럼명 클릭 시 전체 선택 / 전체 해제
	 */
	var processProgressCheckAllLabel = document
			.getElementById("processProgressCheckAllLabel");

	if (processProgressCheckAllLabel != null) {

		processProgressCheckAllLabel.onclick = function() {

			var checkAll = document.getElementById("processProgressCheckAll");
			var checks = document.getElementsByName("progressOrderIds");

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
	var progressChecks = document.getElementsByName("progressOrderIds");

	for (var i = 0; i < progressChecks.length; i++) {

		progressChecks[i].onclick = function() {

			var allChecked = true;

			for (var j = 0; j < progressChecks.length; j++) {

				if (!progressChecks[j].checked) {
					allChecked = false;
					break;
				}
			}

			var checkAll = document.getElementById("processProgressCheckAll");

			if (checkAll != null) {
				checkAll.checked = allChecked;
			}
		};
	}


	/*
	 * 작업지시 선택 시 LOT, 품목, 지시수량을 자동 표시한다.
	 */
	function setProcessProgressOrderInfo() {

		var orderSelect = document.getElementById("insertOrderId");
		var selectedOption = orderSelect.options[orderSelect.selectedIndex];

		if (selectedOption == null || selectedOption.value === "") {
			document.getElementById("insertWorkOrderDocNo").value = "";
			document.getElementById("insertProductLot").value = "";
			document.getElementById("insertItemCode").value = "";
			document.getElementById("insertItemName").value = "";
			document.getElementById("insertOrderQtyText").value = "";
			document.getElementById("insertProdQty").value = "";
			document.getElementById("insertProdUnit").value = "";
			setProcessProgressQtyPreview();
			return;
		}

		var workOrderDocNo = selectedOption.getAttribute("data-work-order-doc-no");
		var productLot = selectedOption.getAttribute("data-product-lot");
		var itemCode = selectedOption.getAttribute("data-item-code");
		var itemName = selectedOption.getAttribute("data-item-name");
		var orderQty = selectedOption.getAttribute("data-order-qty");
		var itemUnit = selectedOption.getAttribute("data-item-unit");

		document.getElementById("insertWorkOrderDocNo").value = workOrderDocNo || "";
		document.getElementById("insertProductLot").value = productLot || "";
		document.getElementById("insertItemCode").value = itemCode || "";
		document.getElementById("insertItemName").value = itemName || "";
		document.getElementById("insertProdUnit").value = itemUnit || "";

		if (orderQty != null && orderQty !== "") {
			document.getElementById("insertOrderQtyText").value =
				formatNumber(orderQty) + " " + (itemUnit || "");
			document.getElementById("insertProdQty").value = orderQty;
		} else {
			document.getElementById("insertOrderQtyText").value = "";
			document.getElementById("insertProdQty").value = "";
		}

		setProcessProgressQtyPreview();
	}


	/*
	 * 생산수량 / 불량수량 천단위 미리보기
	 */
	function setProcessProgressQtyPreview() {

		var prodQty = document.getElementById("insertProdQty").value;
		var lossQty = document.getElementById("insertLossQty").value;
		var unit = document.getElementById("insertProdUnit").value;

		var prodPreview = document.getElementById("prodQtyPreviewText");
		var lossPreview = document.getElementById("lossQtyPreviewText");

		if (prodQty == null || prodQty === "") {
			prodPreview.innerHTML = "생산수량을 입력하세요.";
		} else if (Number(prodQty) <= 0) {
			prodPreview.innerHTML = "생산수량은 1 이상 입력해야 합니다.";
		} else {
			prodPreview.innerHTML =
				"생산수량: " + formatNumber(prodQty) + " " + (unit || "");
		}

		if (lossQty == null || lossQty === "") {
			lossPreview.innerHTML = "불량수량 미입력 시 0으로 처리됩니다.";
			return;
		}

		if (Number(lossQty) < 0) {
			lossPreview.innerHTML = "불량수량은 0 이상 입력해야 합니다.";
			return;
		}

		if (prodQty !== "" && Number(lossQty) > Number(prodQty)) {
			lossPreview.innerHTML = "불량수량은 생산수량보다 클 수 없습니다.";
			return;
		}

		lossPreview.innerHTML =
			"불량수량: " + formatNumber(lossQty) + " " + (unit || "");
	}


	/*
	 * 공정실적 등록 검증
	 */
	function checkProcessProgressInsert() {

		var orderId = document.getElementById("insertOrderId").value;
		var prodQty = document.getElementById("insertProdQty").value;
		var lossQty = document.getElementById("insertLossQty").value;
		var prodDate = document.getElementById("insertProdDate").value;
		var prodStatus = document.getElementById("insertProdStatus").value;
		var empId = document.getElementById("insertEmpId").value;

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

		if (lossQty === "") {
			document.getElementById("insertLossQty").value = 0;
			lossQty = 0;
		}

		if (Number(lossQty) < 0) {
			alert("불량수량은 0 이상 입력해주세요.");
			document.getElementById("insertLossQty").focus();
			return false;
		}

		if (Number(lossQty) > Number(prodQty)) {
			alert("불량수량은 생산수량보다 클 수 없습니다.");
			document.getElementById("insertLossQty").focus();
			return false;
		}

		if (prodDate === "") {
			alert("생산일자를 선택해주세요.");
			document.getElementById("insertProdDate").focus();
			return false;
		}

		if (prodStatus === "") {
			alert("진행상태를 선택해주세요.");
			document.getElementById("insertProdStatus").focus();
			return false;
		}

		if (empId === "") {
			alert("담당자를 선택해주세요.");
			document.getElementById("insertEmpId").focus();
			return false;
		}

		if (!confirm("공정실적을 등록하시겠습니까?")) {
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