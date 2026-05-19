<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<style>
	.coTable {
		table-layout: fixed;
		width: 100%;
	}

	.coTable th,
	.coTable td {
		font-size: 12px;
		padding: 9px 6px;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
		text-align: center;
	}
</style>

<div class="coPageWrap">

	<!-- 검색 영역 -->
	<form class="search-form"
		method="get"
		action="${pageContext.request.contextPath}/inventory/materialIn">

		<div class="search-box">

			<div class="search-row">

				<!-- 검색구분 -->
				<div class="search-item">

					<label class="search-label">구분</label>

					<select name="searchType"
						class="search-select">

						<option value="">
							전체
						</option>

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

				<!-- 입출고구분 -->
				<div class="search-item">

					<label class="search-label">입출고구분</label>

					<select name="inoutType"
						class="search-select">

						<option value="">
							전체
						</option>

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

						<svg viewBox="0 0 24 24" fill="none">
							<circle cx="10.5" cy="10.5" r="7.5"
								stroke="currentColor" stroke-width="2"></circle>
							<path d="M16 16L21 21"
								stroke="currentColor" stroke-width="2"
								stroke-linecap="round"></path>
						</svg>

						검색
					</button>

					<button type="button"
						class="search-btn search-btn-sub search-reset-btn"
						onclick="location.href='${pageContext.request.contextPath}/inventory/materialIn'">

						<svg viewBox="0 0 24 24" fill="none">
							<path d="M20 12C20 16.4 16.4 20 12 20C7.6 20 4 16.4 4 12C4 7.6 7.6 4 12 4C14.4 4 16.5 5.1 18 6.8"
								stroke="currentColor" stroke-width="2"
								stroke-linecap="round"></path>
							<path d="M18 4V7H21"
								stroke="currentColor" stroke-width="2"
								stroke-linecap="round"
								stroke-linejoin="round"></path>
						</svg>

						초기화
					</button>

				</div>

			</div>

		</div>

	</form>

	<!-- 삭제용 form -->
	<form method="post"
		id="deleteForm"
		action="${pageContext.request.contextPath}/inventory/materialIn/delete">

		<div class="coTableTop">

			<p class="coTotalCount">
				총 ${pageInfo.totalCount}건
			</p>

			<div class="search-btn-right">

				<!-- 등록 버튼 : 팀장님 공통 모달 버튼 사용 -->
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

		</div>

		<div class="coTableWrap">

			<table class="coTable">

				<thead>
					<tr>
						<th>
							<input type="checkbox" id="checkAll">
						</th>
						<th>NO</th>
						<th>입출고번호</th>
						<th>입출고구분</th>
						<th>품목코드</th>
						<th>품목유형</th>
						<th>품목명</th>
						<th>입출고량</th>
						<th>단위</th>
						<th>일자</th>
						<th>상세</th>
					</tr>
				</thead>

				<tbody>

					<c:forEach var="inout"
						items="${list}"
						varStatus="status">

						<tr>
							<td>
								<input type="checkbox"
									name="inoutIds"
									value="${inout.inoutId}">
							</td>

							<td>${status.count}</td>

							<td title="${inout.docNo}">
								${inout.docNo}
							</td>

							<td>
								<c:choose>
									<c:when test="${inout.inoutType eq 'MI'}">입고</c:when>
									<c:when test="${inout.inoutType eq 'MO-PROD'}">출고</c:when>
									<c:otherwise>${inout.inoutType}</c:otherwise>
								</c:choose>
							</td>

							<td title="${inout.itemCode}">
								${inout.itemCode}
							</td>

							<td>
								<c:choose>
									<c:when test="${inout.itemType eq 'FG'}">완제품</c:when>
									<c:when test="${inout.itemType eq 'RM'}">원자재</c:when>
									<c:when test="${inout.itemType eq 'SM'}">부자재</c:when>
									<c:otherwise>${inout.itemType}</c:otherwise>
								</c:choose>
							</td>

							<td title="${inout.itemName}">
								${inout.itemName}
							</td>

							<td>${inout.inoutQty}</td>
							<td>${inout.itemUnit}</td>
							<td>${inout.inoutDate}</td>

							<td>
								<button type="button"
									class="coDetailBtn"
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

	<!-- 공통 페이징 -->
	<jsp:include page="/WEB-INF/views/common/paging.jsp" />

</div>

<!-- 등록 모달 : 팀장님 공통 모달 사용 -->
<div id="modal_insert"
	class="modal_wrap"
	aria-hidden="true">

	<div class="modal_box"
		role="dialog"
		aria-modal="true">

		<div class="modal_header">
			<h3 class="modal_title">입출고 등록</h3>
		</div>

		<form class="modal_form"
			method="post"
			action="${pageContext.request.contextPath}/inventory/materialIn/insert">

			<div class="modal_body modal_body_2col">

				<!-- 품목 선택 -->
				<div class="modal_item">
					<label class="modal_label">
						품목명<span class="modal_required">*</span>
					</label>

					<select name="itemId"
						id="itemSelect"
						class="modal_select"
						onchange="changeItemInfo()"
						required>

						<option value="">
							선택
						</option>

						<c:forEach var="item"
							items="${itemList}">

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

				<!-- 품목코드 -->
				<div class="modal_item">
					<label class="modal_label">
						품목코드
					</label>

					<input type="text"
						id="itemCode"
						class="modal_input"
						readonly>
				</div>

				<!-- 품목명 -->
				<div class="modal_item">
					<label class="modal_label">
						품목명
					</label>

					<input type="text"
						id="itemName"
						class="modal_input"
						readonly>
				</div>

				<!-- 품목유형 -->
				<div class="modal_item">
					<label class="modal_label">
						품목유형
					</label>

					<input type="text"
						id="itemType"
						class="modal_input"
						readonly>
				</div>

				<!-- 입출고구분 -->
				<div class="modal_item">
					<label class="modal_label">
						입출고구분<span class="modal_required">*</span>
					</label>

					<select name="inoutType"
						class="modal_select"
						required>

						<option value="MI">입고</option>
						<option value="MO-PROD">출고</option>

					</select>
				</div>

				<!-- 수량 -->
				<div class="modal_item">
					<label class="modal_label">
						수량<span class="modal_required">*</span>
					</label>

					<input type="number"
						name="inoutQty"
						class="modal_input"
						min="0"
						required>
				</div>

				<!-- 단위 -->
				<div class="modal_item">
					<label class="modal_label">
						단위
					</label>

					<input type="text"
						id="itemUnit"
						class="modal_input"
						readonly>
				</div>

				<!-- 일자 -->
				<div class="modal_item">
					<label class="modal_label">
						일자<span class="modal_required">*</span>
					</label>

					<input type="date"
						name="inoutDate"
						class="modal_input modal_today"
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
	// 전체 체크박스
	document.getElementById("checkAll").onclick = function() {

		var checks =
			document.getElementsByName("inoutIds");

		for (var i = 0; i < checks.length; i++) {
			checks[i].checked = this.checked;
		}
	};

	// 선택 삭제
	function deleteCheck() {

		var checks =
			document.getElementsByName("inoutIds");

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

	// 품목 선택 시 자동 입력
	function changeItemInfo() {

		var select =
			document.getElementById("itemSelect");

		var option =
			select.options[select.selectedIndex];

		document.getElementById("itemCode").value =
			option.getAttribute("data-code");

		document.getElementById("itemName").value =
			option.getAttribute("data-name");

		var itemType =
			option.getAttribute("data-type");

		if (itemType == "FG") {
			itemType = "완제품";
		} else if (itemType == "RM") {
			itemType = "원자재";
		} else if (itemType == "SM") {
			itemType = "부자재";
		}

		document.getElementById("itemType").value =
			itemType;

		document.getElementById("itemUnit").value =
			option.getAttribute("data-unit");
	}
</script>