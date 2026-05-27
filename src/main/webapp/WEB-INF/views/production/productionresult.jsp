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
	- 생산관리 파일 구조 유지
	  DTO / DAO / Service / Controller / Mapper는 생산관리 1개 파일로 관리
	  JSP만 페이지별 관리
	- 생산실적번호는 Mapper에서 자동 생성
	- 생산실적은 작업지시/공정진행/품질 데이터와 연결되므로 목록 삭제 기능 제외
	- 등록 모달에서 작업지시 선택 시 작업지시번호 / LOT / 품목코드 / 품명 / 지시수량 자동 표시
	- 생산수량, 불량수량 천단위 표시
	- 등록 시 생산수량 1 이상, 불량수량 0 이상, 불량수량 <= 생산수량 검증

	목록 컬럼 기준:
	- PC: 체크박스 포함 8개
	  1 선택
	  2 실적번호
	  3 LOT번호
	  4 품명
	  5 생산수량
	  6 불량수량
	  7 생산상태
	  8 상세

	- 모바일: 체크박스 포함 5개
	  1 선택
	  2 실적번호
	  3 LOT번호
	  4 생산수량
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
						placeholder="실적번호 / 작업지시번호 / LOT / 품목코드 / 품명"
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


	<div class="coTableWrap">

		<table class="coTable production-result-table">

			<thead>
				<tr>
					<th class="mobile_show">
						<label id="productionResultCheckAllLabel">선택</label>
						<input type="checkbox" id="productionResultCheckAll"
							style="display: none;">
					</th>

					<th class="mobile_show">실적번호</th>
					<th class="mobile_show">LOT번호</th>
					<th class="mobile_hidden">품명</th>
					<th class="mobile_show">생산수량</th>
					<th class="mobile_hidden">불량수량</th>
					<th class="mobile_hidden">생산상태</th>
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

								<td class="mobile_show" title="${result.docNo}">
									<c:choose>
										<c:when test="${not empty result.docNo}">
											${result.docNo}
										</c:when>
										<c:otherwise>
											PRD-${result.prodId}
										</c:otherwise>
									</c:choose>
								</td>

								<td class="mobile_show" title="${result.productLot}">
									${result.productLot}
								</td>

								<td class="coTextLeft mobile_hidden" title="${result.itemName}">
									${result.itemName}
								</td>

								<td class="mobile_show">
									<fmt:formatNumber value="${result.prodQty}"
										pattern="#,##0" />
									${result.itemUnit}
								</td>

								<td class="mobile_hidden">
									<fmt:formatNumber value="${result.lossQty}"
										pattern="#,##0" />
									${result.itemUnit}
								</td>

								<td class="mobile_hidden">
									<c:choose>
										<c:when test="${result.prodStatus eq '완료'}">
											<span class="coStatus coStatusUse">
												${result.prodStatus}
											</span>
										</c:when>

										<c:when test="${result.prodStatus eq '보류'}">
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


	<div id="modal_insert" class="modal_wrap" aria-hidden="true">

		<div class="modal_box" role="dialog" aria-modal="true">

			<div class="modal_header">
				<h3 class="modal_title">생산실적 등록</h3>
			</div>

			<form class="modal_form" method="post"
				action="${contextPath}/production/productionresult/insert"
				onsubmit="return checkProductionResultInsert();">

				<div class="modal_body modal_body_2col">

					<div class="modal_item modal_item_full">
						<label class="modal_label">
							작업지시 선택 <span class="modal_required">*</span>
						</label>

						<select name="orderId" id="insertOrderId"
							class="modal_select"
							onchange="setProductionResultOrderInfo();"
							required>

							<option value="">선택</option>

							<c:forEach var="order" items="${productionResultOrderList}">

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
						<label class="modal_label">실적번호</label>

						<input type="text" class="modal_input"
							value="저장 시 자동 생성" readonly>
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

						<div class="production-result-qty-box">
							<input type="number" name="prodQty" id="insertProdQty"
								class="modal_input" min="1"
								oninput="setProductionResultQtyPreview();"
								required>

							<input type="text" id="insertProdUnit"
								class="modal_input production-result-unit-input"
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
							oninput="setProductionResultQtyPreview();">

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
							생산상태 <span class="modal_required">*</span>
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
}

.production-result-qty-box {
	display: flex;
	align-items: center;
	gap: 8px;
	width: 100%;
	box-sizing: border-box;
}

.production-result-qty-box .modal_input:first-child {
	flex: 1 1 auto;
	min-width: 0;
}

.production-result-unit-input {
	flex: 0 0 80px;
	text-align: center;
}
</style>


<script>
	var productionResultCheckAllLabel = document
			.getElementById("productionResultCheckAllLabel");

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


	var prodChecks = document.getElementsByName("prodIds");

	for (var i = 0; i < prodChecks.length; i++) {

		prodChecks[i].onclick = function() {

			var allChecked = true;

			for (var j = 0; j < prodChecks.length; j++) {

				if (!prodChecks[j].checked) {
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


	function setProductionResultOrderInfo() {

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
			setProductionResultQtyPreview();
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

		setProductionResultQtyPreview();
	}


	function setProductionResultQtyPreview() {

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


	function checkProductionResultInsert() {

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
			alert("생산상태를 선택해주세요.");
			document.getElementById("insertProdStatus").focus();
			return false;
		}

		if (empId === "") {
			alert("담당자를 선택해주세요.");
			document.getElementById("insertEmpId").focus();
			return false;
		}

		if (!confirm("생산실적을 등록하시겠습니까?")) {
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