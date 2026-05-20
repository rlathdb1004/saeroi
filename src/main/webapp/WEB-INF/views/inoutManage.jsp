<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 관리자 / 매니저 권한 체크 --%>
<c:set var="isAdmin"
	value="${sessionScope.member.role eq 'ADMIN'
		or sessionScope.member.role eq 'MANAGER'
		or sessionScope.loginUser.role eq 'ADMIN'
		or sessionScope.loginUser.role eq 'MANAGER'
		or sessionScope.member.job eq '관리자'
		or sessionScope.loginUser.job eq '관리자'}" />

<div class="coPageWrap">

	<form class="search-form"
		method="get"
		action="${pageContext.request.contextPath}/inventory/materialIn">

		<div class="search-box">
			<div class="search-row">

				<%-- 구분 검색 select는 제거했다. --%>

				<div class="search-item">
					<label class="search-label">입출고구분</label>

					<select name="inoutType" class="search-select">
						<option value="">전체</option>

						<option value="MI"
							<c:if test="${inoutType eq 'MI'}">selected</c:if>>
							입고
						</option>

						<option value="MO-PROD"
							<c:if test="${inoutType eq 'MO-PROD'}">selected</c:if>>
							출고
						</option>
					</select>
				</div>

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
					<label class="search-label">검색어</label>
					<input type="text" name="keyword" class="search-input"
						placeholder="검색키워드" value="${keyword}">
				</div>

				<div class="search-btn-wrap">
					<button type="submit" class="search-btn search-btn-main">검색</button>

					<button type="button"
						class="search-btn search-btn-sub search-reset-btn"
						onclick="location.href='${pageContext.request.contextPath}/inventory/materialIn'">
						초기화
					</button>
				</div>

			</div>
		</div>
	</form>

	<form method="post" id="deleteForm"
		action="${pageContext.request.contextPath}/inventory/materialIn/delete">

		<div class="coTableTop">

			<p class="coTotalCount">총 ${pageInfo.totalCount}건</p>

			<%-- 관리자 / 매니저만 등록, 선택 삭제 버튼 보임 --%>
			<c:if test="${isAdmin}">
				<div class="search-btn-right">

					<button type="button"
						class="search-btn search-btn-main modal_open_btn"
						data_modal_target="#modal_insert">
						등록
					</button>

					<button type="button" class="search-btn search-btn-sub"
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
						<%-- 선택 글씨를 누르면 전체선택 된다. --%>
						<th>
							<label for="checkAll">선택</label>
							<input type="checkbox" id="checkAll" style="display:none;">
						</th>
						<th>입출고번호</th>
						<th>입출고구분</th>
						<th>품목명</th>
						<th>입출고량</th>
						<th>단위</th>
						<th>일자</th>
						<th>상세</th>
					</tr>
				</thead>

				<tbody>
					<c:forEach var="inout" items="${list}">

						<tr>
							<td>
								<input type="checkbox" name="inoutIds"
									value="${inout.inoutId}">
							</td>

							<td title="${inout.docNo}">${inout.docNo}</td>

							<td>
								<c:choose>
									<c:when test="${inout.inoutType eq 'MI'}">입고</c:when>
									<c:when test="${inout.inoutType eq 'MO-PROD'}">출고</c:when>
									<c:otherwise>${inout.inoutType}</c:otherwise>
								</c:choose>
							</td>

							<td title="${inout.itemName}">${inout.itemName}</td>
							<td>${inout.inoutQty}</td>
							<td>${inout.itemUnit}</td>
							<td>${inout.inoutDate}</td>

							<td>
								<button type="button" class="coDetailBtn"
									onclick="location.href='${pageContext.request.contextPath}/inventory/materialIn/detail?inoutId=${inout.inoutId}'">
									보기
								</button>
							</td>
						</tr>

					</c:forEach>
				</tbody>

			</table>
		</div>
	</form>

	<jsp:include page="/WEB-INF/views/common/paging.jsp" />

</div>

<%-- 등록 모달 --%>
<div id="modal_insert" class="modal_wrap" aria-hidden="true">

	<div class="modal_box" role="dialog" aria-modal="true">

		<div class="modal_header">
			<h3 class="modal_title">입출고 등록</h3>
		</div>

		<form class="modal_form" method="post"
			action="${pageContext.request.contextPath}/inventory/materialIn/insert">

			<div class="modal_body modal_body_2col">

				<div class="modal_item">
					<label class="modal_label">
						품목명<span class="modal_required">*</span>
					</label>

					<select name="itemId" id="itemSelect"
						class="modal_select" onchange="changeItemInfo()" required>

						<option value="">선택</option>

						<c:forEach var="item" items="${itemList}">
							<option value="${item.itemId}"
								data-code="${item.itemCode}"
								data-name="${item.itemName}"
								data-type="${item.itemType}"
								data-unit="${item.itemUnit}">
								${item.itemName}
							</option>
						</c:forEach>

					</select>
				</div>

				<div class="modal_item">
					<label class="modal_label">품목코드</label>
					<input type="text" id="itemCode" class="modal_input" readonly>
				</div>

				<div class="modal_item">
					<label class="modal_label">품목명</label>
					<input type="text" id="itemName" class="modal_input" readonly>
				</div>

				<div class="modal_item">
					<label class="modal_label">품목유형</label>
					<input type="text" id="itemType" class="modal_input" readonly>
				</div>

				<div class="modal_item">
					<label class="modal_label">
						입출고구분<span class="modal_required">*</span>
					</label>

					<select name="inoutType" class="modal_select" required>
						<option value="MI">입고</option>
						<option value="MO-PROD">출고</option>
					</select>
				</div>

				<div class="modal_item">
					<label class="modal_label">
						수량<span class="modal_required">*</span>
					</label>

					<input type="number" name="inoutQty"
						class="modal_input" min="0" required>
				</div>

				<div class="modal_item">
					<label class="modal_label">단위</label>
					<input type="text" id="itemUnit" class="modal_input" readonly>
				</div>

				<div class="modal_item">
					<label class="modal_label">
						일자<span class="modal_required">*</span>
					</label>

					<input type="date" name="inoutDate"
						class="modal_input modal_today" required>
				</div>

				<div class="modal_item">
					<label class="modal_label">비고</label>
					<input type="text" name="remark" class="modal_input">
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

<script>
	document.getElementById("checkAll").onclick = function() {

		var checks = document.getElementsByName("inoutIds");

		for (var i = 0; i < checks.length; i++) {
			checks[i].checked = this.checked;
		}
	};

	function deleteCheck() {

		var checks = document.getElementsByName("inoutIds");
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

	function changeItemInfo() {

		var select = document.getElementById("itemSelect");
		var option = select.options[select.selectedIndex];

		document.getElementById("itemCode").value =
			option.getAttribute("data-code");

		document.getElementById("itemName").value =
			option.getAttribute("data-name");

		var itemType = option.getAttribute("data-type");

		if (itemType == "FG") {
			itemType = "완제품";
		} else if (itemType == "RM") {
			itemType = "원자재";
		} else if (itemType == "SM") {
			itemType = "부자재";
		}

		document.getElementById("itemType").value = itemType;

		document.getElementById("itemUnit").value =
			option.getAttribute("data-unit");
	}
</script>