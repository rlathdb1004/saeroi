<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<div class="coPageWrap">

	<!-- 검색 영역 -->
	<form class="search-form"
		method="get"
		action="${pageContext.request.contextPath}/inventory/stockList">

		<div class="search-box">
			<div class="search-row">

				<!-- 구분 -->
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

				<!-- 시작일 -->
				<div class="search-item">
					<label class="search-label">시작일</label>

					<input type="date"
						name="startDate"
						class="search-date"
						value="${startDate}">
				</div>

				<!-- 종료일 -->
				<div class="search-item">
					<label class="search-label">종료일</label>

					<input type="date"
						name="endDate"
						class="search-date"
						value="${endDate}">
				</div>

				<!-- 검색어 -->
				<div class="search-item">
					<label class="search-label">검색어</label>

					<input type="text"
						name="keyword"
						class="search-input"
						placeholder="검색키워드"
						value="${keyword}">
				</div>

				<!-- 검색 / 초기화 버튼 -->
				<div class="search-btn-wrap">

					<button type="submit"
						class="search-btn search-btn-main">
						검색
					</button>

					<button type="button"
						class="search-btn search-btn-sub search-reset-btn"
						onclick="location.href='${pageContext.request.contextPath}/inventory/stockList'">
						초기화
					</button>

				</div>

			</div>
		</div>

	</form>

	<!-- 삭제 form -->
	<form method="post"
		id="deleteForm"
		action="${pageContext.request.contextPath}/inventory/stockList/delete">

		<div class="coTableTop">

			<p class="coTotalCount">
				총 ${pageInfo.totalCount}건
			</p>

			<!-- 관리자/매니저만 등록/삭제 버튼 보임 -->
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

		<!-- 목록 테이블 -->
		<div class="coTableWrap">

			<table class="coTable">

				<thead>
					<tr>
						<th>
							<label for="checkAll">선택</label>
							<input type="checkbox"
								id="checkAll"
								style="display:none;">
						</th>
						<th>품목코드</th>
						<th>품목유형</th>
						<th>품목명</th>
						<th>현재재고</th>
						<th>단위</th>
						<th>창고위치</th>
						<th>상세</th>
					</tr>
				</thead>

				<tbody>

					<c:forEach var="inventory"
						items="${list}">

						<tr>
							<td>
								<input type="checkbox"
									name="inventoryIds"
									value="${inventory.inventoryId}">
							</td>

							<td title="${inventory.itemCode}">
								${inventory.itemCode}
							</td>

							<td>
								<c:choose>
									<c:when test="${inventory.itemType eq 'FG'}">완제품</c:when>
									<c:when test="${inventory.itemType eq 'RM'}">원자재</c:when>
									<c:when test="${inventory.itemType eq 'SM'}">부자재</c:when>
									<c:otherwise>${inventory.itemType}</c:otherwise>
								</c:choose>
							</td>

							<td title="${inventory.itemName}">
								${inventory.itemName}
							</td>

							<td>${inventory.inventoryStock}</td>
							<td>${inventory.itemUnit}</td>
							<td>${inventory.stockLocation}</td>

							<td>
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

	<!-- 공통 페이징 -->
	<jsp:include page="/WEB-INF/views/common/paging.jsp" />

</div>

<!-- 등록 모달 -->
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
			action="${pageContext.request.contextPath}/inventory/stockList/insert">

			<div class="modal_body modal_body_2col">

				<!-- 품목 선택 -->
				<div class="modal_item">

					<label class="modal_label">
						품목명<span class="modal_required">*</span>
					</label>

					<select name="itemId"
						id="itemSelect"
						class="modal_select"
						onchange="changeStockLocation()"
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

				<!-- 현재 재고 -->
				<div class="modal_item">

					<label class="modal_label">
						현재재고<span class="modal_required">*</span>
					</label>

					<input type="number"
						name="inventoryStock"
						class="modal_input"
						min="0"
						required>

				</div>

				<!-- 창고 위치 -->
				<div class="modal_item">

					<label class="modal_label">
						창고위치<span class="modal_required">*</span>
					</label>

					<input type="text"
						name="stockLocation"
						id="stockLocation"
						class="modal_input"
						required>

				</div>

				<!-- 비고 -->
				<div class="modal_item">

					<label class="modal_label">
						비고
					</label>

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

<script>

	// 선택 글씨를 누르면 전체 선택 / 해제
	document.getElementById("checkAll").onclick = function() {

		var checks =
			document.getElementsByName("inventoryIds");

		for (var i = 0; i < checks.length; i++) {
			checks[i].checked = this.checked;
		}
	};

	// 선택 삭제
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

	// 품목명을 선택하면 창고위치 자동 입력
	function changeStockLocation() {

		var select =
			document.getElementById("itemSelect");

		var option =
			select.options[select.selectedIndex];

		var location =
			option.getAttribute("data-location");

		if (location == null) {
			location = "";
		}

		document.getElementById("stockLocation").value =
			location;
	}

</script>