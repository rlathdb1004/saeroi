<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<div class="coPageWrap">

	<form class="search-form"
		method="get"
		action="${pageContext.request.contextPath}/inventory/stockList">

		<div class="search-box">

			<div class="search-row">

				<div class="search-item">
					<label class="search-label">시작일</label>

					<input type="date"
						name="startDate"
						class="search-date"
						value="${startDate}">
				</div>

				<div class="search-item">
					<label class="search-label">종료일</label>

					<input type="date"
						name="endDate"
						class="search-date"
						value="${endDate}">
				</div>

				<div class="search-item">
					<label class="search-label">구분</label>

					<select name="searchType"
						class="search-select">

						<option value="">선택</option>

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

				<div class="search-item">
					<label class="search-label">검색어</label>

					<input type="text"
						name="keyword"
						class="search-input"
						placeholder="검색키워드"
						value="${keyword}">
				</div>

				<div class="search-btn-wrap">

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

			<c:if test="${sessionScope.loginUser.role eq 'ADMIN'
				or sessionScope.loginUser.role eq 'MANAGER'}">

				<div class="search-btn-right">

					<button type="button"
						class="search-btn search-btn-main modal_open_btn"
						data_modal_target="#modal_insert">
						등록
					</button>

					<button type="button"
						class="search-btn search-btn-sub"
						onclick="deleteCheck()">
						선택 삭제
					</button>

				</div>

			</c:if>

		</div>

		<div class="coTableWrap">

			<table class="coTable">

				<thead>
					<tr>
						<th class="mobile_show">
							<label id="checkAllLabel">선택</label>

							<input type="checkbox"
								id="checkAll"
								style="display:none;">
						</th>

						<th class="mobile_hidden">품목코드</th>
						<th class="mobile_hidden">품목유형</th>
						<th class="mobile_show">품목명</th>
						<th class="mobile_show">현재재고</th>
						<th class="mobile_hidden">단위</th>
						<th class="mobile_hidden">창고위치</th>
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
									<c:when test="${inventory.itemType eq 'FG'}">완제품</c:when>
									<c:when test="${inventory.itemType eq 'RM'}">원자재</c:when>
									<c:when test="${inventory.itemType eq 'SM'}">부자재</c:when>
									<c:otherwise>${inventory.itemType}</c:otherwise>
								</c:choose>
							</td>

							<td class="mobile_show"
								title="${inventory.itemName}">
								${inventory.itemName}
							</td>

							<td class="mobile_show">
								${inventory.inventoryStock}
							</td>

							<td class="mobile_hidden">
								${inventory.itemUnit}
							</td>

							<td class="mobile_hidden">
								${inventory.stockLocation}
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

	<%-- 공통 모달 구조 사용 --%>
	<div id="modal_insert"
		class="modal_wrap"
		aria-hidden="true">

		<div class="modal_box"
			role="dialog"
			aria-modal="true">

			<div class="modal_header">
				<h3 class="modal_title">재고 등록</h3>
			</div>

			<form class="modal_form"
				method="post"
				action="${pageContext.request.contextPath}/inventory/stockList/insert"
				onsubmit="return checkInventoryInsert();">

				<div class="modal_body modal_body_2col">

					<div class="modal_item">
						<label class="modal_label">
							품목명<span class="modal_required">*</span>
						</label>

						<select name="itemId"
							id="insertInventoryItemId"
							class="modal_select"
							onchange="changeStockLocation();"
							required>

							<option value="">선택</option>

							<c:forEach var="item"
								items="${itemList}">

								<option value="${item.itemId}"
									data-location="${item.stockLocation}">
									${item.itemName}
								</option>

							</c:forEach>

						</select>
					</div>

					<div class="modal_item">
						<label class="modal_label">
							현재재고<span class="modal_required">*</span>
						</label>

						<input type="number"
							name="inventoryStock"
							id="insertInventoryStock"
							class="modal_input"
							min="0"
							required>
					</div>

					<div class="modal_item">
						<label class="modal_label">
							창고위치<span class="modal_required">*</span>
						</label>

						<input type="text"
							name="stockLocation"
							id="insertStockLocation"
							class="modal_input"
							required>
					</div>

					<div class="modal_item">
						<label class="modal_label">비고</label>

						<input type="text"
							name="remark"
							class="modal_input">
					</div>

				</div>

				<div class="modal_footer">

					<button type="button"
						class="modal_btn modal_btn_cancel modal_close_btn">
						취소
					</button>

					<button type="submit"
						class="modal_btn modal_btn_submit">
						등록
					</button>

				</div>

			</form>

		</div>

	</div>

	<jsp:include page="/WEB-INF/views/common/paging.jsp" />

</div>

<script>
	// 품목명 선택 시 창고위치 자동 입력
	function changeStockLocation() {

		var select =
			document.getElementById("insertInventoryItemId");

		var option =
			select.options[select.selectedIndex];

		var location =
			option.getAttribute("data-location");

		if (location == null) {
			location = "";
		}

		document.getElementById("insertStockLocation").value =
			location;
	}

	// 선택 글씨 클릭 시 전체 선택 / 전체 해제
	document.getElementById("checkAllLabel").onclick = function() {

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

	// 선택 삭제 방어코딩
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

	// 등록 방어코딩
	function checkInventoryInsert() {

		var itemId =
			document.getElementById("insertInventoryItemId").value;

		var inventoryStock =
			document.getElementById("insertInventoryStock").value;

		var stockLocation =
			document.getElementById("insertStockLocation").value;

		if (itemId == "") {
			alert("품목명을 선택해주세요.");
			return false;
		}

		if (inventoryStock == "" || Number(inventoryStock) < 0) {
			alert("현재재고는 0 이상 입력해주세요.");
			return false;
		}

		if (stockLocation == "") {
			alert("창고위치를 입력해주세요.");
			return false;
		}

		return true;
	}
</script>