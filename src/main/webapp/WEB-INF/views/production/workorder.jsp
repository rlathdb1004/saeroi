<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="coPageWrap">

	<form class="search-form" method="get"
		action="${pageContext.request.contextPath}/production/workorder">

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
						onclick="location.href='${pageContext.request.contextPath}/production/workorder'">

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
		action="${pageContext.request.contextPath}/production/workorder/delete">

		<div class="coTableTop">

			<p class="coTotalCount">총 ${pageInfo.totalCount}건</p>

			<div class="search-btn-right">

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
					등록</button>

				<button type="button" class="search-btn search-btn-sub"
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
					선택 삭제</button>

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

							<td class="coTextLeft mobile_hidden" title="${workOrder.itemName}">
								${workOrder.itemName}</td>

							<td class="mobile_show">${workOrder.orderQty}</td>

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
									onclick="location.href='${pageContext.request.contextPath}/production/workorder/detail?orderId=${workOrder.orderId}'">
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


	<div id="modal_insert" class="modal_wrap" aria-hidden="true">

		<div class="modal_box" role="dialog" aria-modal="true">

			<div class="modal_header">
				<h3 class="modal_title">작업지시 등록</h3>
			</div>

			<form class="modal_form" method="post"
				action="${pageContext.request.contextPath}/production/workorder/insert"
				onsubmit="return checkWorkOrderInsert();">

				<div class="modal_body modal_body_2col">

					<div class="modal_item">
						<label class="modal_label"> 생산계획 선택<span
							class="modal_required">*</span>
						</label> <select name="prodPlanId" id="insertProdPlanId"
							class="modal_select" onchange="setWorkOrderPlanInfo();" required>

							<option value="">선택</option>

							<c:forEach var="plan" items="${workOrderPlanList}">

								<option value="${plan.prodPlanId}"
									data-item-name="${plan.itemName}"
									data-plan-qty="${plan.prodPlanQty}"
									data-item-unit="${plan.itemUnit}">${plan.docNo} /
									${plan.itemName} / ${plan.prodPlanQty}${plan.itemUnit}</option>

							</c:forEach>

						</select>
					</div>

					<div class="modal_item">
						<label class="modal_label">작업지시번호</label> <input type="text"
							id="insertDocNo" class="modal_input" value="저장 시 자동 생성" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">LOT번호</label> <input type="text"
							id="insertProductLot" class="modal_input" value="저장 시 자동 생성"
							readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">품목명</label> <input type="text"
							id="insertItemName" class="modal_input"
							placeholder="생산계획 선택 시 자동 표시" readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label"> 지시수량<span
							class="modal_required">*</span>
						</label> <input type="number" name="orderQty" id="insertOrderQty"
							class="modal_input" min="1" required>
					</div>

					<div class="modal_item">
						<label class="modal_label"> 작업지시일<span
							class="modal_required">*</span>
						</label> <input type="date" name="orderDate" id="insertOrderDate"
							class="modal_input modal_today" required>
					</div>

					<div class="modal_item">
						<label class="modal_label"> 라인<span class="modal_required">*</span>
						</label> <select name="lineId" id="insertLineId" class="modal_select"
							required>

							<option value="">선택</option>

							<c:forEach var="line" items="${lineList}">

								<option value="${line.lineId}">${line.lineName}</option>

							</c:forEach>

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
							placeholder="작업지시 관련 메모를 입력하세요."></textarea>
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

		alert("작업지시 선택 삭제는 다음 단계에서 연결할 예정입니다.");
	}

	// 생산계획을 선택하면 품목명과 계획수량을 작업지시 등록 모달에 자동 표시한다.
	function setWorkOrderPlanInfo() {

		var prodPlanSelect = document.getElementById("insertProdPlanId");

		var selectedOption = prodPlanSelect.options[prodPlanSelect.selectedIndex];

		var itemName = selectedOption.getAttribute("data-item-name");

		var planQty = selectedOption.getAttribute("data-plan-qty");

		document.getElementById("insertItemName").value = itemName || "";

		document.getElementById("insertOrderQty").value = planQty || "";
	}

	// 작업지시 등록 방어코딩이다.
	function checkWorkOrderInsert() {

		var prodPlanId = document.getElementById("insertProdPlanId").value;

		var orderQty = document.getElementById("insertOrderQty").value;

		var orderDate = document.getElementById("insertOrderDate").value;

		var lineId = document.getElementById("insertLineId").value;

		var empId = document.getElementById("insertEmpId").value;

		if (prodPlanId == "") {
			alert("생산계획을 선택해주세요.");
			return false;
		}

		if (orderQty == "" || Number(orderQty) <= 0) {
			alert("지시수량은 1 이상 입력해주세요.");
			return false;
		}

		if (orderDate == "") {
			alert("작업지시일을 선택해주세요.");
			return false;
		}

		if (lineId == "") {
			alert("라인을 선택해주세요.");
			return false;
		}

		if (empId == "") {
			alert("담당자를 선택해주세요.");
			return false;
		}

		return true;
	}
</script>