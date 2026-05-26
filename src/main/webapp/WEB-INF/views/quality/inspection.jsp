<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="canManageQuality"
	value="${sessionScope.loginUser.role eq 'ADMIN'
		or sessionScope.loginUser.role eq 'MANAGER'}" />

<div class="coPageWrap">

	<form class="search-form" method="get"
		action="${pageContext.request.contextPath}/quality/inspection">

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
						<option value="insp_id"
							<c:if test="${searchType == 'insp_id'}">selected</c:if>>검사번호</option>
						<option value="itemName"
							<c:if test="${searchType == 'itemName'}">selected</c:if>>품목명</option>
						<option value="productLot"
							<c:if test="${searchType == 'productLot'}">selected</c:if>>LOT번호</option>
						<option value="ename"
							<c:if test="${searchType == 'ename'}">selected</c:if>>검사자</option>
						<option value="result"
							<c:if test="${searchType == 'result'}">selected</c:if>>검사결과</option>
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
						onclick="location.href='${pageContext.request.contextPath}/quality/inspection'">
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
		</div>
	</form>

	<form method="post" id="deleteForm" accept-charset="UTF-8"
		action="${pageContext.request.contextPath}/quality/inspection/delete">

		<div class="coTableTop">
			<p class="coTotalCount">총 ${pageInfo.totalCount}건</p>

			<c:if test="${canManageQuality}">
				<div class="search-btn-right">
					<button type="button"
						class="search-btn search-btn-main modal_open_btn"
						data_modal_target="#modal_insert">
						<svg viewBox="0 0 24 24" fill="none">
							<path d="M12 5V19" stroke="currentColor" stroke-width="2"
								stroke-linecap="round"></path>
							<path d="M5 12H19" stroke="currentColor" stroke-width="2"
								stroke-linecap="round"></path>
						</svg>
						등록
					</button>

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
						<th class="mobile_show">검사번호</th>
						<th class="mobile_hidden">검사일시</th>
						<th class="mobile_show">품목명</th>
						<th class="mobile_hidden">LOT번호</th>
						<th class="mobile_hidden">검사자</th>
						<th class="mobile_show">검사결과</th>
						<th class="mobile_show">상세</th>
					</tr>
				</thead>

				<tbody>
					<c:forEach var="inspection" items="${list}">
						<tr>
							<td class="mobile_show"><input type="checkbox"
								name="insp_id" value="${inspection.insp_id}"></td>

							<td class="mobile_show">${inspection.doc_no}</td>
							<td class="mobile_hidden">${inspection.insp_date}</td>
							<td class="coTextLeft mobile_show">${inspection.item_name}</td>
							<td class="mobile_hidden">${inspection.product_lot}</td>
							<td class="mobile_hidden">${inspection.ename}</td>

							<td class="mobile_show"><c:choose>
									<c:when test="${inspection.result == '조건부'}">
										<span class="coStatus coStatusStop">${inspection.result}</span>
									</c:when>
									<c:otherwise>
										<span class="coStatus coStatusUse">${inspection.result}</span>
									</c:otherwise>
								</c:choose></td>

							<td class="mobile_show">
								<button type="button" class="coDetailBtn"
									onclick="location.href='${pageContext.request.contextPath}/quality/inspection_detail?insp_id=${inspection.insp_id}'">
									보기</button>
							</td>
						</tr>
					</c:forEach>

					<c:if test="${empty list}">
						<tr>
							<td colspan="8">조회된 검사 내역이 없습니다.</td>
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
				<h3 class="modal_title">검사 등록</h3>
			</div>

			<form class="modal_form" method="post" accept-charset="UTF-8"
				action="${pageContext.request.contextPath}/quality/inspection/add">

				<div class="modal_body modal_body_2col">

					<div class="modal_item">
						<label class="modal_label">검사일시<span
							class="modal_required">*</span></label> <input type="date"
							name="insp_date" class="modal_input modal_today" required>
					</div>

					<div class="modal_item">
						<label class="modal_label">품목명<span class="modal_required">*</span></label>
						<select name="prod_id" class="modal_select" required>
							<option value="">선택</option>
						</select>
					</div>

					<div class="modal_item">
						<label class="modal_label">검사자</label> <input type="text"
							class="modal_input" value="${sessionScope.loginUser.ename}"
							readonly> <input type="hidden" name="emp_id"
							value="${sessionScope.loginUser.empno}">
					</div>

					<div class="modal_item">
						<label class="modal_label">검사구분<span
							class="modal_required">*</span></label> <select name="insp_type"
							class="modal_select" required>
							<option value="">선택</option>
						</select>
					</div>

					<div class="modal_item">
						<label class="modal_label">검사결과<span
							class="modal_required">*</span></label> <select name="result"
							class="modal_select" required>
							<option value="">선택</option>
						</select>
					</div>

					<div class="modal_item">
						<label class="modal_label">검사수량<span
							class="modal_required">*</span></label> <input type="number"
							name="inspection_qty" class="modal_input" min="0" required>
					</div>

					<div class="modal_item">
						<label class="modal_label">양품수량<span
							class="modal_required">*</span></label> <input type="number"
							name="good_qty" class="modal_input" min="0" required>
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

<script
	src="${pageContext.request.contextPath}/resources/js/inspection.js"></script>