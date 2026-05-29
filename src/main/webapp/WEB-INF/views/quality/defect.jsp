<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="canManageQuality"
	value="${not empty sessionScope.loginUser
		and (sessionScope.loginUser.role eq 'ADMIN'
		or sessionScope.loginUser.role eq 'MANAGER')}" />

<style>
.quality_search_error {
	margin: 10px 0 0;
	color: #c62828;
	font-size: 13px;
	font-weight: 600;
}
</style>

<div class="coPageWrap">

	<form class="search-form" method="get"
		action="${pageContext.request.contextPath}/quality/defect"
		onsubmit="return validateDateRange(this);">

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
					<label class="search-label">구분</label> <select name="searchType"
						class="search-select">
						<option value="">전체</option>
						<option value="defectCode"
							<c:if test="${searchType == 'defectCode'}">selected</c:if>>불량코드</option>
						<option value="itemName"
							<c:if test="${searchType == 'itemName'}">selected</c:if>>품목명</option>
						<option value="productLot"
							<c:if test="${searchType == 'productLot'}">selected</c:if>>LOT번호</option>
						<option value="defectName"
							<c:if test="${searchType == 'defectName'}">selected</c:if>>불량명</option>
						<option value="ename"
							<c:if test="${searchType == 'ename'}">selected</c:if>>검사자</option>
					</select>
				</div>

				<div class="search-item">
					<label class="search-label">검색어</label> <input type="text"
						name="keyword" class="search-input" placeholder="검색키워드"
						value="${keyword}">
				</div>

				<div class="search-btn-wrap">
					<button type="submit" class="search-btn search-btn-main">
						<svg viewBox="0 0 24 24" fill="none">
							<circle cx="10.5" cy="10.5" r="7.5" stroke="currentColor"
								stroke-width="2"></circle>
							<path d="M16 16L21 21" stroke="currentColor" stroke-width="2"
								stroke-linecap="round"></path>
						</svg>
						검색
					</button>

					<button type="button"
						class="search-btn search-btn-sub search-reset-btn"
						onclick="location.href='${pageContext.request.contextPath}/quality/defect'">
						<svg viewBox="0 0 24 24" fill="none">
							<path
								d="M20 12C20 16.4 16.4 20 12 20C7.6 20 4 16.4 4 12C4 7.6 7.6 4 12 4C14.4 4 16.5 5.1 18 6.8"
								stroke="currentColor" stroke-width="2" stroke-linecap="round"></path>
							<path d="M18 4V7H21" stroke="currentColor" stroke-width="2"
								stroke-linecap="round" stroke-linejoin="round"></path>
						</svg>
						초기화
					</button>
				</div>

			</div>

			<c:if test="${not empty dateError}">
				<div class="quality_search_error">${dateError}</div>
			</c:if>
		</div>
	</form>

	<form method="post" id="defectDeleteForm" accept-charset="UTF-8"
		action="${pageContext.request.contextPath}/quality/defect/delete"
		onsubmit="return checkDefectDelete();">

		<div class="coTableTop">
			<p class="coTotalCount">총 ${pageInfo.totalCount}건</p>

			<c:if test="${canManageQuality}">
<!-- 				<div class="search-btn-right"> -->
<!-- 					<button type="button" -->
<!-- 						class="search-btn search-btn-main modal_open_btn" -->
<!-- 						data_modal_target="#modal_insert"> -->
<!-- 						<svg viewBox="0 0 24 24" fill="none"> -->
<!-- 							<path d="M12 5V19" stroke="currentColor" stroke-width="2" -->
<!-- 								stroke-linecap="round"></path> -->
<!-- 							<path d="M5 12H19" stroke="currentColor" stroke-width="2" -->
<!-- 								stroke-linecap="round"></path> -->
<!-- 						</svg> -->
<!-- 						등록 -->
<!-- 					</button> -->

					<button type="submit" class="search-btn search-btn-sub">
						<svg viewBox="0 0 24 24" fill="none">
							<path d="M4 7H20" stroke="currentColor" stroke-width="2"
								stroke-linecap="round"></path>
							<path d="M10 11V17" stroke="currentColor" stroke-width="2"
								stroke-linecap="round"></path>
							<path d="M14 11V17" stroke="currentColor" stroke-width="2"
								stroke-linecap="round"></path>
							<path d="M6 7L7 21H17L18 7" stroke="currentColor"
								stroke-width="2" stroke-linejoin="round"></path>
							<path d="M9 7V4H15V7" stroke="currentColor" stroke-width="2"
								stroke-linejoin="round"></path>
						</svg>
						선택 삭제
					</button>
				</div>
			</c:if>
		</div>

		<div class="coTableWrap">
			<table class="coTable">
				<thead>
					<tr>
						<th class="mobile_show checkAllHeader" style="cursor: pointer;">선택</th>
						<th class="mobile_hidden">불량코드</th>
						<th class="mobile_show">발생일시</th>
						<th class="mobile_show">품목명</th>
						<th class="mobile_hidden">LOT번호</th>
						<th class="mobile_show">불량명</th>
						<th class="mobile_hidden">검사자</th>
						<th class="mobile_show">상세</th>
					</tr>
				</thead>

				<tbody>
					<c:forEach var="defect" items="${list}">
						<tr>
							<td class="mobile_show"><input type="checkbox"
								name="defect_list_id" value="${defect.defect_list_id}">
							</td>

							<td class="mobile_hidden">${defect.defect_code}</td>
							<td class="mobile_show">${defect.defect_date}</td>
							<td class="coTextLeft mobile_show">${defect.item_name}</td>
							<td class="mobile_hidden">${defect.product_lot}</td>
							<td class="mobile_show"><span class="coStatus coStatusStop">${defect.defect_name}</span>
							</td>
							<td class="mobile_hidden">${defect.ename}</td>

							<td class="mobile_show">
								<button type="button" class="coDetailBtn"
									onclick="location.href='${pageContext.request.contextPath}/quality/defect_detail?defect_list_id=${defect.defect_list_id}'">
									보기</button>
							</td>
						</tr>
					</c:forEach>

					<c:if test="${empty list}">
						<tr>
							<td colspan="8">조회된 불량 내역이 없습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>
	</form>

	<jsp:include page="/WEB-INF/views/common/paging.jsp" />

</div>

<c:if test="${canManageQuality}">
	<div id="modal_insert" class="modal_wrap" aria-hidden="true">
		<div class="modal_box" role="dialog" aria-modal="true">

			<div class="modal_header">
				<h3 class="modal_title">불량 등록</h3>
			</div>

			<form class="modal_form" method="post" accept-charset="UTF-8"
				enctype="multipart/form-data"
				action="${pageContext.request.contextPath}/quality/defect/add">

				<div class="modal_body modal_body_2col">

					<div class="modal_item">
						<label class="modal_label">발생일시<span
							class="modal_required">*</span></label> <input type="date"
							name="defect_date" class="modal_input modal_today" required>
					</div>

					<div class="modal_item">
						<label class="modal_label">검사번호<span
							class="modal_required">*</span></label> <select name="insp_id"
							class="modal_select" required>
							<option value="">선택</option>
						</select>
					</div>

					<div class="modal_item">
						<label class="modal_label">불량명<span class="modal_required">*</span></label>
						<select name="defect_id" class="modal_select" required>
							<option value="">선택</option>
						</select>
					</div>

					<div class="modal_item">
						<label class="modal_label">불량수량<span
							class="modal_required">*</span></label> <input type="number"
							name="defect_qty" class="modal_input" min="0" required>
					</div>

					<div class="modal_item">
						<label class="modal_label">불량사진</label> <input type="file"
							name="defect_photo_file" class="modal_input" accept="image/*">
					</div>

					<div class="modal_item">
						<label class="modal_label">비고</label> <input type="text"
							name="remark" class="modal_input">
					</div>

				</div>

				<div class="modal_footer">
					<button type="button"
						class="modal_btn modal_btn_cancel modal_close_btn">취소</button>
					<button type="submit" class="modal_btn modal_btn_submit">등록</button>
				</div>

			</form>
		</div>
	</div>
</c:if>

<script>
	function checkDefectDelete() {
		const checkedList = document
				.querySelectorAll('input[name="defect_list_id"]:checked');

		if (checkedList.length === 0) {
			alert('삭제할 불량 내역을 선택해주세요.');
			return false;
		}

		return confirm('선택한 불량 내역을 삭제하시겠습니까?');
	}
</script>

<script
	src="${pageContext.request.contextPath}/resources/js/inspection.js"></script>
