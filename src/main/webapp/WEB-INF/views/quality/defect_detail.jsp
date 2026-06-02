<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<c:set var="canManageQuality"
	value="${sessionScope.loginUser.role eq 'ADMIN'
		or sessionScope.loginUser.role eq 'MANAGER'}" />

<style>
.defect_status_badge {
	background-color: #FDECEC;
	color: #C62828;
	border: 1px solid #F5CACA;
}

.defect_detail_section {
	margin-top: 16px;
}

.defect_detail_bottom {
	display: grid;
	grid-template-columns: 1fr 1.2fr;
	gap: 16px;
	margin-top: 16px;
}

.defect_photo {
	width: 100%;
	height: 280px;
	object-fit: cover;
	border-radius: 8px;
	border: 1px solid #E1E8E3;
}

.defect_photo_empty {
	height: 280px;
	display: flex;
	align-items: center;
	justify-content: center;
	border: 1px solid #E1E8E3;
	border-radius: 8px;
	color: #777;
	background: #F8FAF8;
}

.defect_action_header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 12px;
}

.defect_action_table {
	width: 100%;
	border-collapse: collapse;
	border: 1px solid #E1E8E3;
}

.defect_action_table th, .defect_action_table td {
	border: 1px solid #E1E8E3;
	padding: 12px;
	text-align: center;
	font-size: 14px;
}

.defect_action_table th {
	background: #F4F8F5;
	font-weight: 700;
}

.defect_action_table .coTextLeft {
	text-align: left;
}

.defect_action_table th:first-child, .defect_action_table td:first-child
	{
	width: 110px;
	min-width: 110px;
	white-space: nowrap;
}

@media ( max-width : 900px) {
	.defect_detail_bottom {
		grid-template-columns: 1fr;
	}
}

.lot-link {
	display: inline-block;
	color: #0b7a5a;
	font-weight: 700;
	text-decoration: none;
	border-bottom: 1px dotted #0b7a5a;
	white-space: nowrap;
}

.lot-link::after {
	content: " ↗";
	font-size: 10px;
}

.lot-link:hover {
	color: #075f46;
}
</style>

<div class="detail_page">

	<div class="detail_header">
		<div>
			<h2 class="detail_title">불량 상세</h2>
			<div class="detail_path">품질관리 &gt; 불량관리 &gt; 불량 상세</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${canManageQuality}">
				<button type="submit" id="saveBtn" class="detail_btn_green"
					form="defectDetailForm" style="display: none;">

					<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
						stroke="currentColor" stroke-width="2" stroke-linecap="round"
						stroke-linejoin="round"
						style="vertical-align: -3px; margin-right: 6px;"
						aria-hidden="true">
						<path
							d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
						<path d="M17 21v-8H7v8"></path>
						<path d="M7 3v5h8"></path>
					</svg>

					저장
				</button>

				<button type="button" id="cancelBtn" class="detail_btn_line"
					onclick="changeEditMode(false);" style="display: none;">

					<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
						stroke="currentColor" stroke-width="2" stroke-linecap="round"
						stroke-linejoin="round"
						style="vertical-align: -3px; margin-right: 6px;"
						aria-hidden="true">
						<path d="M18 6L6 18"></path>
						<path d="M6 6l12 12"></path>
					</svg>

					취소
				</button>

				<button type="button" id="editBtn" class="detail_btn_green"
					onclick="changeEditMode(true);">

					<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
						stroke="currentColor" stroke-width="2" stroke-linecap="round"
						stroke-linejoin="round"
						style="vertical-align: -3px; margin-right: 6px;"
						aria-hidden="true">
						<path d="M12 20h9"></path>
						<path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"></path>
					</svg>

					수정
				</button>
			</c:if>

			<button type="button" class="detail_btn_line"
				onclick="location.href='${pageContext.request.contextPath}/quality/defect'">

				<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
					stroke="currentColor" stroke-width="2" stroke-linecap="round"
					stroke-linejoin="round"
					style="vertical-align: -3px; margin-right: 6px;" aria-hidden="true">
					<path d="M8 6h13"></path>
					<path d="M8 12h13"></path>
					<path d="M8 18h13"></path>
					<path d="M3 6h.01"></path>
					<path d="M3 12h.01"></path>
					<path d="M3 18h.01"></path>
				</svg>

				목록
			</button>
		</div>
	</div>

	<form id="defectDetailForm" method="post" accept-charset="UTF-8"
		action="${pageContext.request.contextPath}/quality/defect/update">

		<input type="hidden" name="defect_list_id"
			value="${defect.defect_list_id}">

		<div class="detail_card">
			<div class="detail_card_title">불량 정보</div>

			<table class="detail_info_table">
				<colgroup>
					<col style="width: 12%;">
					<col style="width: 21%;">
					<col style="width: 12%;">
					<col style="width: 21%;">
					<col style="width: 12%;">
					<col style="width: 22%;">
				</colgroup>

				<tbody>
					<tr>
						<th>불량문서번호</th>
						<td>${defect.doc_no}</td>

						<th>불량번호</th>
						<td>${defect.defect_list_id}</td>

						<th>불량코드</th>
						<td>${defect.defect_code}</td>
					</tr>

					<tr>
						<th>불량명</th>
						<td><span
							class="detailText detail_status_badge defect_status_badge">${defect.defect_name}</span>
							<select name="defect_id" class="detailInput"
							data-selected="${defect.defect_id}" style="display: none;"
							required>
								<option value="${defect.defect_id}" selected>${defect.defect_name}</option>
						</select></td>

						<th>불량유형</th>
						<td>${defect.defect_type}</td>

						<th>불량발생일시</th>
						<td><span class="detailText">${defect.defect_date}</span> <input
							type="date" name="defect_date" class="detailInput"
							value="${defect.defect_date}" style="display: none;" required>
						</td>
					</tr>

					<tr>
						<th>조치부서</th>
						<td>${defect.action_dept}</td>

						<th>등록일</th>
						<td>${defect.created_date}</td>

						<th>수정일</th>
						<td>${defect.updated_date}</td>
					</tr>

					<tr>
						<th>비고</th>
						<td colspan="5"><span class="detailText">${defect.remark}</span>
							<input type="text" name="remark" class="detailInput"
							value="${defect.remark}" style="display: none;"></td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="detail_card defect_detail_section">
			<div class="detail_card_title">검사/생산 및 수량 정보</div>

			<table class="detail_info_table">
				<colgroup>
					<col style="width: 12%;">
					<col style="width: 21%;">
					<col style="width: 12%;">
					<col style="width: 21%;">
					<col style="width: 12%;">
					<col style="width: 22%;">
				</colgroup>

				<tbody>
					<tr>
						<th>검사번호</th>
						<td>${defect.insp_doc_no}</td>

						<th>검사자</th>
						<td>${defect.ename}</td>

						<th>LOT번호</th>
						<td><c:choose>
								<c:when test="${not empty defect.product_lot}">
									<a class="lot-link"
										href="${pageContext.request.contextPath}/lot/lothistory?searchType=lotNo&keyword=${defect.product_lot}">
										${defect.product_lot} </a>
								</c:when>
								<c:otherwise>-</c:otherwise>
							</c:choose></td>
					</tr>

					<tr>
						<th>품목코드</th>
						<td>${defect.item_code}</td>

						<th>품목명</th>
						<td>${defect.item_name}</td>

						<th>단위</th>
						<td>${defect.item_unit}</td>
					</tr>

					<tr>
						<th>생산문서번호</th>
						<td>${defect.prod_doc_no}</td>

						<th>작업지시번호</th>
						<td>${defect.work_order_doc_no}</td>

						<th>생산상태</th>
						<td>${defect.prod_status}</td>
					</tr>

					<tr>
						<th>생산일자</th>
						<td>${defect.prod_date}</td>

						<th>지시일자</th>
						<td colspan="3">${defect.order_date}</td>
					</tr>

					<tr>
						<th>지시수량</th>
						<td>${defect.order_qty}</td>

						<th>생산수량</th>
						<td>${defect.prod_qty}</td>

						<th>검사수량</th>
						<td>${defect.inspection_qty}</td>
					</tr>

					<tr>
						<th>양품수량</th>
						<td>${defect.good_qty}</td>

						<th>불량수량</th>
						<td><span class="detailText">${defect.defect_qty}</span> <input
							type="number" name="defect_qty" class="detailInput"
							value="${defect.defect_qty}" style="display: none;" min="0"
							required></td>

						<th>손실수량</th>
						<td>${defect.loss_qty}</td>
					</tr>
				</tbody>
			</table>
		</div>
	</form>

	<div class="defect_detail_bottom">

		<div class="detail_card defect_photo_card">
			<div class="detail_card_title">불량 사진</div>

			<c:choose>
				<c:when test="${not empty defect.defect_photo}">
					<img class="defect_photo"
						src="${pageContext.request.contextPath}${defect.defect_photo}"
						alt="불량 사진">
				</c:when>

				<c:otherwise>
					<div class="defect_photo_empty">등록된 불량 사진이 없습니다.</div>
				</c:otherwise>
			</c:choose>
		</div>

		<div class="detail_card defect_action_card">
			<div class="defect_action_header">
				<div class="detail_card_title">조치 및 처리 내역
					(${defectActionList.size()}건)</div>

				<c:if test="${canManageQuality}">
					<button type="button" id="actionAddBtn"
						class="detail_btn_green modal_open_btn"
						data_modal_target="#modal_action_insert" style="display: none;">조치
						추가</button>
				</c:if>
			</div>

			<table class="defect_action_table">
				<thead>
					<tr>
						<th>일시</th>
						<th>담당부서</th>
						<th>조치담당자</th>
						<th>조치내역</th>
					</tr>
				</thead>

				<tbody>
					<c:forEach var="action" items="${defectActionList}">
						<tr>
							<td>${action.action_date}</td>
							<td>${action.dept}</td>
							<td>${action.action_ename}</td>
							<td class="coTextLeft">${action.action_content}</td>
						</tr>
					</c:forEach>

					<c:if test="${empty defectActionList}">
						<tr>
							<td colspan="4">등록된 조치 내역이 없습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>

	</div>
</div>

<c:if test="${canManageQuality}">

	<div id="modal_action_insert" class="modal_wrap" aria-hidden="true">
		<div class="modal_box" role="dialog" aria-modal="true">

			<div class="modal_header">
				<h3 class="modal_title">조치 추가</h3>
			</div>

			<form class="modal_form" method="post" accept-charset="UTF-8"
				action="${pageContext.request.contextPath}/quality/defect/action/add">

				<input type="hidden" name="defect_list_id"
					value="${defect.defect_list_id}">

				<div class="modal_body modal_body_2col">

					<div class="modal_item">
						<label class="modal_label">조치 일시<span
							class="modal_required">*</span></label> <input type="date"
							name="action_date" class="modal_input modal_today" required>
					</div>

					<div class="modal_item">
						<label class="modal_label">조치 부서</label> <input type="text"
							id="actionDept" class="modal_input" value="${defect.action_dept}"
							readonly>
					</div>

					<div class="modal_item">
						<label class="modal_label">조치 담당자<span
							class="modal_required">*</span></label> <select name="emp_id"
							id="actionEmpId" class="modal_select"
							data-dept="${defect.action_dept}" required>
							<option value="">선택</option>
						</select>
					</div>

					<div class="modal_item modal_item_full">
						<label class="modal_label">조치 내역<span
							class="modal_required">*</span></label>
						<textarea name="action_content" class="modal_textarea" rows="5"
							placeholder="조치 내역을 입력하세요." required></textarea>
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
