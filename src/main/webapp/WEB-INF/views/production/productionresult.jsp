<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="coPageWrap">

	<form class="search-form" method="get"
		action="${pageContext.request.contextPath}/production/productionresult">

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
					<label class="search-label">구분</label> <select name="prodStatus"
						class="search-select">

						<option value="">전체</option>

						<c:forEach var="status" items="${productionResultStatusList}">

							<option value="${status}"
								<c:if test="${prodStatus eq status}">selected</c:if>>
								${status}</option>

						</c:forEach>

					</select>
				</div>

				<div class="search-item">
					<label class="search-label">검색어</label> <input type="text"
						name="keyword" class="search-input"
						placeholder="검색키워드" value="${keyword}">
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
						onclick="location.href='${pageContext.request.contextPath}/production/productionresult'">

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
		action="${pageContext.request.contextPath}/production/productionresult/delete">

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
					onclick="deleteProductionResultCheck()">

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
						<th class="mobile_show"><label
							id="productionResultCheckAllLabel">선택</label> <input
							type="checkbox" id="productionResultCheckAll"
							style="display: none;"></th>

						<th class="mobile_hidden">실적번호</th>
						<th class="mobile_hidden">작업지시번호</th>
						<th class="mobile_show">LOT번호</th>
						<th class="mobile_show">품목명</th>
						<th class="mobile_show">생산수량</th>
						<th class="mobile_hidden">생산일자</th>
						<th class="mobile_show">상세</th>
					</tr>
				</thead>

				<tbody>

					<c:forEach var="result" items="${list}">

						<tr>
							<td class="mobile_show"><input type="checkbox"
								name="prodIds" value="${result.prodId}"></td>

							<td class="mobile_hidden" title="${result.docNo}">
								${result.docNo}</td>

							<td class="mobile_hidden" title="${result.workOrderDocNo}">
								${result.workOrderDocNo}</td>

							<td class="mobile_show" title="${result.productLot}">
								${result.productLot}</td>

							<td class="coTextLeft mobile_show" title="${result.itemName}">
								${result.itemName}</td>

							<td class="mobile_show">${result.prodQty}</td>

							<td class="mobile_hidden">${result.prodDate}</td>

							<td class="mobile_show">
								<button type="button" class="coDetailBtn"
									onclick="location.href='${pageContext.request.contextPath}/production/productionresult/detail?prodId=${result.prodId}'">
									보기</button>
							</td>
						</tr>

					</c:forEach>

					<c:if test="${empty list}">
						<tr>
							<td colspan="8">조회된 생산실적이 없습니다.</td>
						</tr>
					</c:if>

				</tbody>

			</table>

		</div>

	</form>


	<div id="modal_insert" class="modal_wrap" aria-hidden="true">

		<div class="modal_box" role="dialog" aria-modal="true">

			<div class="modal_header">
				<h3 class="modal_title">생산실적 등록</h3>
			</div>

			<form class="modal_form" method="post"
				action="${pageContext.request.contextPath}/production/productionresult/insert"
				onsubmit="return checkProductionResultInsert();">

				<div class="modal_body modal_body_2col">

					<div class="modal_item">
						<label class="modal_label"> 작업지시 선택<span
							class="modal_required">*</span>
						</label> <select name="orderId" id="insertOrderId" class="modal_select"
							onchange="setProductionResultOrderInfo();" required>

							<option value="">선택</option>

							<c:forEach var="order" items="${productionResultOrderList}">

								<option value="${order.orderId}"
									data-work-order-doc-no="${order.workOrderDocNo}"
									data-product-lot="${order.productLot}"
									data-item-name="${order.itemName}"
									data-order-qty="${order.orderQty}"
									data-item-unit="${order.itemUnit}">
									${order.workOrderDocNo} / ${order.productLot} /
									${order.itemName}</option>

							</c:forEach>

						</select>
					</div>

					<div class="modal_item">
						<label class="modal_label">실적번호</label> <input type="text"
							class="modal_input" value="저장 시 자동 생성" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">LOT번호</label> <input type="text"
							id="insertProductLot" class="modal_input"
							placeholder="작업지시 선택 시 자동 표시" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">품목명</label> <input type="text"
							id="insertItemName" class="modal_input"
							placeholder="작업지시 선택 시 자동 표시" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">지시수량</label> <input type="text"
							id="insertOrderQty" class="modal_input"
							placeholder="작업지시 선택 시 자동 표시" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label"> 생산수량<span
							class="modal_required">*</span>
						</label> <input type="number" name="prodQty" id="insertProdQty"
							class="modal_input" min="1" required>
					</div>

					<div class="modal_item">
						<label class="modal_label"> 불량수량 </label> <input type="number"
							name="lossQty" id="insertLossQty" class="modal_input" min="0"
							value="0">
					</div>

					<div class="modal_item">
						<label class="modal_label"> 생산일자<span
							class="modal_required">*</span>
						</label> <input type="date" name="prodDate" id="insertProdDate"
							class="modal_input modal_today" required>
					</div>

					<div class="modal_item">
						<label class="modal_label"> 생산상태<span
							class="modal_required">*</span>
						</label> <select name="prodStatus" id="insertProdStatus"
							class="modal_select" required>

							<option value="">선택</option>
							<option value="진행중">진행중</option>
							<option value="완료">완료</option>
							<option value="보류">보류</option>

						</select>
					</div>

					<div class="modal_item">
						<label class="modal_label"> 담당자<span
							class="modal_required">*</span>
						</label> <select name="empId" id="insertEmpId" class="modal_select"
							required>

							<option value="">선택</option>

							<c:forEach var="emp" items="${empList}">

								<option value="${emp.empId}">${emp.ename} / ${emp.dept}
								</option>

							</c:forEach>

						</select>
					</div>

					<div class="modal_item modal_item_full">
						<label class="modal_label">비고</label>

						<textarea name="remark" class="modal_textarea"
							placeholder="생산실적 관련 메모를 입력하세요."></textarea>
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

			document.getElementById("productionResultCheckAll").checked = allChecked;
		};
	}

	// 선택 삭제 방어코딩이다.
	function deleteProductionResultCheck() {

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

		alert("생산실적 선택 삭제는 다음 단계에서 연결할 예정입니다.");
	}

	// 작업지시를 선택하면 LOT번호, 품목명, 지시수량을 자동 표시한다.
	function setProductionResultOrderInfo() {

		var orderSelect = document.getElementById("insertOrderId");

		var selectedOption = orderSelect.options[orderSelect.selectedIndex];

		var productLot = selectedOption.getAttribute("data-product-lot");

		var itemName = selectedOption.getAttribute("data-item-name");

		var orderQty = selectedOption.getAttribute("data-order-qty");

		var itemUnit = selectedOption.getAttribute("data-item-unit");

		document.getElementById("insertProductLot").value = productLot || "";

		document.getElementById("insertItemName").value = itemName || "";

		if (orderQty == null || orderQty == "") {
			document.getElementById("insertOrderQty").value = "";
		} else {
			document.getElementById("insertOrderQty").value = orderQty + " "
					+ (itemUnit || "");
		}

		document.getElementById("insertProdQty").value = orderQty || "";
	}

	// 생산실적 등록 방어코딩이다.
	function checkProductionResultInsert() {

		var orderId = document.getElementById("insertOrderId").value;

		var prodQty = document.getElementById("insertProdQty").value;

		var lossQty = document.getElementById("insertLossQty").value;

		var prodDate = document.getElementById("insertProdDate").value;

		var prodStatus = document.getElementById("insertProdStatus").value;

		var empId = document.getElementById("insertEmpId").value;

		if (orderId == "") {
			alert("작업지시를 선택해주세요.");
			return false;
		}

		if (prodQty == "" || Number(prodQty) <= 0) {
			alert("생산수량은 1 이상 입력해주세요.");
			return false;
		}

		if (lossQty != "" && Number(lossQty) < 0) {
			alert("불량수량은 0 이상 입력해주세요.");
			return false;
		}

		if (prodDate == "") {
			alert("생산일자를 선택해주세요.");
			return false;
		}

		if (prodStatus == "") {
			alert("생산상태를 선택해주세요.");
			return false;
		}

		if (empId == "") {
			alert("담당자를 선택해주세요.");
			return false;
		}

		return true;
	}
</script>